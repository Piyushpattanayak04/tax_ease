import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/utils/smooth_scroll_physics.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/animations/smooth_animations.dart';
import '../../data/files_api.dart';
import '../../data/t1_document_requirements.dart';
import '../../../tax_forms/data/models/t1_form_models_simple.dart';
import '../../../tax_forms/data/services/t1_form_storage_service.dart';
import '../../../tax_forms/data/services/unified_form_service.dart';

class DocumentsPage extends StatefulWidget {
  const DocumentsPage({super.key});

  @override
  State<DocumentsPage> createState() => _DocumentsPageState();
}

class _DocumentsPageState extends State<DocumentsPage> {
  final List<String> _uploadedFileNames = [];

  /// T1 form whose questionnaire answers drive which document cards appear.
  T1FormData? _activeT1Form;

  /// If true, there are no local draft forms to upload documents for.
  bool _hasAnyDraftForm = true;

  /// Tracks the most recently uploaded file name for each document type.
  final Map<String, String?> _documentUploads = {};

  /// Tracks which document types are currently uploading so we can show
  /// per-card loading indicators.
  final Set<String> _uploadingDocumentTypes = {};

  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    // Need post-frame access to context for reading query params.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadActiveT1Form();
    });
  }

  Future<void> _loadActiveT1Form() async {
    try {
      final queryFormId = GoRouterState.of(context).uri.queryParameters['t1FormId'];
      T1FormData? active;

      if (queryFormId != null && queryFormId.trim().isNotEmpty) {
        active = await T1FormStorageService.instance.getFormById(queryFormId);
      } else {
        // Try to use the same "most recent draft" logic as the dashboard.
        final status = await UnifiedFormService.instance.getUnifiedProgressStatus();

        if (status['formType'] == 'T1' && status['formId'] != null) {
          final formId = status['formId'] as String;
          active = await T1FormStorageService.instance.getFormById(formId);
        } else {
          // Fallback: pick the most recently updated T1 draft form, if any.
          final t1Forms = await T1FormStorageService.instance.loadAllForms();
          final draftForms = t1Forms.where((f) => f.status == 'draft').toList();

          if (draftForms.isNotEmpty) {
            active = draftForms.reduce((a, b) =>
                (a.updatedAt ?? DateTime(0)).isAfter(b.updatedAt ?? DateTime(0)) ? a : b);
          } else {
            // No draft forms -> nothing to upload.
            active = null;
          }
        }
      }

      if (!mounted) return;
      setState(() {
        _activeT1Form = active;
        _hasAnyDraftForm = active != null;

        _documentUploads
          ..clear()
          ..addAll(active?.uploadedDocuments ?? const {});
        _uploadedFileNames
          ..clear()
          ..addAll(_documentUploads.values.whereType<String>());
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _activeT1Form = null;
        _hasAnyDraftForm = false;
      });
    }
  }

  Future<void> _pickAndUpload({String? documentType}) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        allowedExtensions: const ['pdf', 'jpg', 'jpeg', 'png', 'doc', 'docx', 'xls', 'xlsx'],
        withReadStream: false,
        withData: false,
      );
      if (result == null || result.files.isEmpty) return; // user canceled

      final file = result.files.single;
      final path = file.path;
      if (path == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not access the selected file path.')),
          );
        }
        return;
      }

      setState(() {
        _isUploading = true;
        if (documentType != null) {
          _uploadingDocumentTypes.add(documentType);
        }
      });
      final resp = await FilesApi.uploadFile(filePath: path);

      // Prefer original filename from API if provided, else from picker
      final name = (resp['original_filename'] ?? file.name)?.toString() ?? 'Uploaded file';

      if (!mounted) return;

      setState(() {
        _isUploading = false;
        if (documentType != null) {
          _uploadingDocumentTypes.remove(documentType);
          final previousName = _documentUploads[documentType];
          _documentUploads[documentType] = name;

          if (previousName != null) {
            _uploadedFileNames.remove(previousName);
          }
          _uploadedFileNames.add(name);
        } else {
          _uploadedFileNames.add(name);
        }
      });

      // Persist upload state against the active form so submission can be gated.
      T1FormData? updatedForm;
      if (documentType != null && _activeT1Form != null) {
        updatedForm = _activeT1Form!.copyWith(
          uploadedDocuments: {
            ..._activeT1Form!.uploadedDocuments,
            documentType: name,
          },
        );
        await T1FormStorageService.instance.saveForm(updatedForm);
      }

      if (!mounted) return;
      if (updatedForm != null) {
        setState(() {
          _activeT1Form = updatedForm;
        });
      }

      final prefix = documentType != null ? '$documentType: ' : '';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Uploaded: $prefix$name')),
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          _isUploading = false;
          if (documentType != null) {
            _uploadingDocumentTypes.remove(documentType);
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload failed: $e')),
        );
      }
    }
  }

  bool get _showSubmitForT1 =>
      _activeT1Form != null &&
      _activeT1Form!.status == 'draft' &&
      _activeT1Form!.awaitingDocuments == true &&
      T1DocumentRequirements.requiresAny(_activeT1Form!);

  bool get _canSubmitT1 =>
      _activeT1Form != null &&
      T1DocumentRequirements.areAllRequiredUploaded(_activeT1Form!);

  Future<void> _submitT1Form() async {
    final form = _activeT1Form;
    if (form == null) return;

    if (!T1DocumentRequirements.areAllRequiredUploaded(form)) return;

    final submitted = form.copyWith(status: 'submitted', awaitingDocuments: false);
    await T1FormStorageService.instance.saveForm(submitted);

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        icon: Icon(
          Icons.check_circle,
          color: AppColors.success,
          size: 64,
        ),
        title: const Text('Form Submitted Successfully!'),
        content: const Text(
          'Your T1 Personal Tax form has been saved and is now under review. '
          'You can continue to edit the form until the filing deadline.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.go('/tax-forms/filled-forms?refresh=true');
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Documents'),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          ResponsiveContainer(
            centerContent: false,
            padding: EdgeInsets.all(Responsive.responsive(
              context: context,
              mobile: AppDimensions.screenPadding,
              tablet: AppDimensions.screenPaddingLarge,
              desktop: AppDimensions.spacingXl,
            )),
            child: SingleChildScrollView(
              physics: const SmoothBouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SmoothAnimations.slideUp(
                    child: Text(
                      'Upload Tax Documents',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  if (!_hasAnyDraftForm)
                    SmoothAnimations.slideUp(
                      delay: const Duration(milliseconds: 100),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(AppDimensions.spacingLg),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius:
                              BorderRadius.circular(AppDimensions.radiusLg),
                          border:
                              Border.all(color: Theme.of(context).dividerColor),
                        ),
                        child: const Text(
                          'No documents needed to upload.',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    )
                  else
                    SmoothAnimations.slideUp(
                      delay: const Duration(milliseconds: 100),
                      child: _buildDocumentTypeCards(),
                    ),
                  if (_hasAnyDraftForm) ...[
                    const SizedBox(height: 32),
                    SmoothAnimations.slideUp(
                      delay: const Duration(milliseconds: 150),
                      child: Text(
                        'Your Documents',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (_isUploading) const LinearProgressIndicator(minHeight: 2),
                    const SizedBox(height: 12),
                    SmoothAnimations.slideUp(
                      delay: const Duration(milliseconds: 250),
                      child: _buildDocumentsList(),
                    ),
                  ],

                  // Extra space so content isn't hidden behind the floating nav + submit button
                  const SizedBox(height: 160),
                ],
              ),
            ),
          ),
          if (_showSubmitForT1)
            Positioned(
              left: AppDimensions.spacingMd,
              right: AppDimensions.spacingMd,
              // MainScaffold overlays a floating bottom nav; keep this above it.
              bottom: 100,
              child: SizedBox(
                height: AppDimensions.buttonHeightXl,
                child: ElevatedButton(
                  onPressed: _canSubmitT1 ? _submitT1Form : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: AppColors.grey400,
                    disabledForegroundColor: Colors.white,
                  ),
                  child: const Text('Submit Form'),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: _hasAnyDraftForm
          ? FloatingActionButton(
              onPressed: _isUploading ? null : () => _pickAndUpload(),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  /// Builds the grid of 10 document cards with individual upload buttons.
  Widget _buildDocumentTypeCards() {
    final visibleRequirements = T1DocumentRequirements.visibleFor(_activeT1Form);

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;

        // Decide an approximate card width based on available width.
        // - 3 cards per row on very wide screens
        // - 2 cards per row on tablets / medium
        // - full width on small phones
        double cardWidth;
        if (maxWidth >= 1024) {
          cardWidth = (maxWidth - (AppDimensions.spacingMd * 2)) / 3;
        } else if (maxWidth >= 700) {
          cardWidth = (maxWidth - AppDimensions.spacingMd) / 2;
        } else {
          cardWidth = maxWidth;
        }

        return Wrap(
          spacing: AppDimensions.spacingMd,
          runSpacing: AppDimensions.spacingMd,
          children: visibleRequirements.map((req) {
            final documentType = req.label;
            final uploadedName = _documentUploads[documentType];
            final isUploadingThis = _uploadingDocumentTypes.contains(documentType);

            return SizedBox(
              width: cardWidth,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacingMd,
                  vertical: AppDimensions.spacingSm,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                  border: Border.all(color: Theme.of(context).dividerColor),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            documentType,
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: AppDimensions.spacing2xs),
                          Text(
                            uploadedName ?? 'No file uploaded yet',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.grey600,
                                ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppDimensions.spacingSm),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton.icon(
                          onPressed: isUploadingThis
                              ? null
                              : () => _pickAndUpload(documentType: documentType),
                          icon: isUploadingThis
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : const Icon(Icons.upload_file, size: 18),
                          label: Text(uploadedName == null ? 'Upload' : 'Replace'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppDimensions.spacingSm,
                              vertical: AppDimensions.spacing2xs,
                            ),
                            minimumSize: const Size(0, AppDimensions.buttonHeightSm),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildDocumentsList() {
    return Builder(
      builder: (context) {
        if (_uploadedFileNames.isEmpty) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: const Center(
              child: Text('No documents uploaded yet.'),
            ),
          );
        }

        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            border: Border.all(color: Theme.of(context).dividerColor),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _uploadedFileNames.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final name = _uploadedFileNames[index];
              return ListTile(
                leading: const Icon(
                  Icons.description,
                  color: AppColors.primary,
                ),
                title: Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {},
                ),
              );
            },
          ),
        );
      },
    );
  }
}

