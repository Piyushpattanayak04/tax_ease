import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/utils/smooth_scroll_physics.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/animations/smooth_animations.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../../core/widgets/global_loading_overlay.dart';
import '../../data/files_api.dart';
import '../../data/t1_document_requirements.dart';
import '../../../tax_forms/data/models/t1_form_models_simple.dart';
import '../../../tax_forms/data/services/t1_form_storage_service.dart';
import '../../../tax_forms/data/services/t1_remote_service.dart';
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

  /// Tracks which document types the user has explicitly marked as
  /// unavailable on this page.
  final Map<String, bool> _unavailableDocuments = {};

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

        _unavailableDocuments
          ..clear()
          ..addAll(active?.unavailableDocuments ?? const {});
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _activeT1Form = null;
        _hasAnyDraftForm = false;
      });
    }
  }

  Future<void> _uploadFile({
    String? filePath,
    List<int>? bytes,
    required String? documentType,
    String? fallbackName,
  }) async {
    try {
      setState(() {
        _isUploading = true;
        if (documentType != null) {
          _uploadingDocumentTypes.add(documentType);
        }
      });

      // Use the active T1 form id as filing_id for the upload API.
      final filingId = _activeT1Form?.id;

      LoadingOverlayController.show();
      final resp = await FilesApi.uploadFile(
        filePath: filePath,
        bytes: bytes,
        fileName: fallbackName,
        filingId: filingId,
        category: documentType,
      );

      final derivedName = (fallbackName ??
          (filePath != null ? filePath.split(RegExp(r"[\\/]")).last : 'upload.bin'));
      final name = (resp['original_filename'] ?? derivedName).toString();

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

          // Once a document is uploaded, clear any "unavailable" flag for it.
          _unavailableDocuments.remove(documentType);
        } else {
          _uploadedFileNames.add(name);
        }
      });

      // Persist upload state against the active form so submission can be gated.
      T1FormData? updatedForm;
      if (documentType != null && _activeT1Form != null) {
        final updatedUnavailable = Map<String, bool>.from(
          _activeT1Form!.unavailableDocuments,
        )..remove(documentType);

        updatedForm = _activeT1Form!.copyWith(
          uploadedDocuments: {
            ..._activeT1Form!.uploadedDocuments,
            documentType: name,
          },
          unavailableDocuments: updatedUnavailable,
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
      AppToast.success(context, 'Uploaded: $prefix$name');
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isUploading = false;
        if (documentType != null) {
          _uploadingDocumentTypes.remove(documentType);
        }
      });
      final message = e.toString().replaceFirst('Exception: ', '');
      AppToast.error(context, 'Upload failed: $message');
    } finally {
      LoadingOverlayController.hide();
    }
  }

  Future<void> _pickFileAndUpload({String? documentType}) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      allowedExtensions: const ['pdf', 'jpg', 'jpeg', 'png', 'doc', 'docx', 'xls', 'xlsx'],
      withReadStream: false,
      // On web we need the in-memory bytes; on mobile/desktop we rely on the file path.
      withData: kIsWeb,
    );
    if (result == null || result.files.isEmpty) return;

    final file = result.files.single;

    if (kIsWeb) {
      final bytes = file.bytes;
      if (bytes == null) {
        if (!mounted) return;
        AppToast.error(context, 'Could not read the selected file.');
        return;
      }

      await _uploadFile(
        bytes: bytes,
        documentType: documentType,
        fallbackName: file.name,
      );
      return;
    }

    final path = file.path;
    if (path == null) {
      if (!mounted) return;
      AppToast.error(context, 'Could not access the selected file path.');
      return;
    }

    await _uploadFile(
      filePath: path,
      documentType: documentType,
      fallbackName: file.name,
    );
  }

  Future<void> _capturePhotoAndUpload({String? documentType}) async {
    final picker = ImagePicker();
    final XFile? captured = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 90,
    );
    if (captured == null) return;

    if (kIsWeb) {
      final bytes = await captured.readAsBytes();
      await _uploadFile(
        bytes: bytes,
        documentType: documentType,
        fallbackName: captured.name,
      );
    } else {
      // No cropping (direct capture -> confirm -> upload)
      await _uploadFile(
        filePath: captured.path,
        documentType: documentType,
        fallbackName: captured.name,
      );
    }
  }

  Future<void> _showUploadOptions({String? documentType}) async {
    if (!mounted) return;

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        // The app uses a floating bottom nav (overlay). Add extra bottom padding so
        // the sheet content doesn't sit under the nav pill.
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.folder_open),
                  title: const Text('Choose file'),
                  onTap: () async {
                    Navigator.of(context).pop();
                    await _pickFileAndUpload(documentType: documentType);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Open camera'),
                  onTap: () async {
                    Navigator.of(context).pop();
                    await _capturePhotoAndUpload(documentType: documentType);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _setDocumentUnavailable(String documentType, bool isUnavailable) async {
    final form = _activeT1Form;
    if (form == null) return;

    final updatedUnavailable = Map<String, bool>.from(form.unavailableDocuments);
    final updatedUploads = Map<String, String>.from(form.uploadedDocuments);

    if (isUnavailable) {
      updatedUnavailable[documentType] = true;

      // Clear any uploaded file for this document when marked unavailable.
      final previousName = updatedUploads.remove(documentType);
      if (previousName != null) {
        _uploadedFileNames.remove(previousName);
      }
      _documentUploads[documentType] = null;
    } else {
      updatedUnavailable.remove(documentType);
    }

    final updatedForm = form.copyWith(
      uploadedDocuments: updatedUploads,
      unavailableDocuments: updatedUnavailable,
    );

    await T1FormStorageService.instance.saveForm(updatedForm);

    if (!mounted) return;

    setState(() {
      _activeT1Form = updatedForm;
      if (isUnavailable) {
        _unavailableDocuments[documentType] = true;
      } else {
        _unavailableDocuments.remove(documentType);
      }
    });
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
    if (form == null || form.id.isEmpty) return;

    LoadingOverlayController.show();
    try {
      // Load the full T1 form for this filing so we submit complete answers.
      final fullForm =
          await T1FormStorageService.instance.getFormById(form.id) ?? form;

      // Persist latest answers (idempotent if already up to date), then submit.
      await T1RemoteService.instance.saveAnswers(
        filingId: form.id,
        form: fullForm,
      );
      final submitResult =
          await T1RemoteService.instance.submit(filingId: form.id);

      final submittedAtRaw = submitResult['submitted_at'];
      DateTime? submittedAt;
      if (submittedAtRaw is String) {
        submittedAt = DateTime.tryParse(submittedAtRaw);
      }

      final submitted = fullForm.copyWith(
        status: 'submitted',
        awaitingDocuments: false,
        updatedAt: submittedAt ?? DateTime.now(),
      );
      await T1FormStorageService.instance.saveForm(submitted);

      if (!mounted) return;

      setState(() {
        _activeT1Form = submitted;
      });

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
            'Your T1 Personal Tax form has been submitted and is now under review.',
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
    } catch (e) {
      if (!mounted) return;
      final message = e.toString().replaceFirst('Exception: ', '');
      AppToast.error(
        context,
        'Error submitting form: $message',
      );
    } finally {
      LoadingOverlayController.hide();
    }
  }

  Future<void> _onSubmitPressed() async {
    final form = _activeT1Form;
    if (form == null) return;

    // Guard again in case state changed between build and tap.
    if (!T1DocumentRequirements.areAllRequiredUploaded(form)) return;

    final hasUnavailable = T1DocumentRequirements.hasAnyUnavailable(form);
    if (!hasUnavailable) {
      await _submitT1Form();
      return;
    }

    if (!mounted) return;

    final proceed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: const Text(
          'The Filing process may be slowed down due to insufficient documents',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Proceed'),
          ),
        ],
      ),
    );

    if (proceed == true) {
      await _submitT1Form();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Documents'),
        automaticallyImplyLeading: false,
      ),
      body: ResponsiveContainer(
        centerContent: true,
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
                      borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                      border: Border.all(color: Theme.of(context).dividerColor),
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

              const SizedBox(height: 24),

              if (_showSubmitForT1)
                SmoothAnimations.slideUp(
                  delay: const Duration(milliseconds: 200),
                  child: SizedBox(
                    width: double.infinity,
                    height: AppDimensions.buttonHeightXl,
                    child: ElevatedButton(
                      onPressed: _canSubmitT1 ? _onSubmitPressed : null,
                      child: const Text('Submit Form'),
                    ),
                  ),
                ),

              // Extra space so content isn't hidden behind the floating nav
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
      floatingActionButton: _hasAnyDraftForm
          ? FloatingActionButton(
              onPressed: _isUploading ? null : () => _showUploadOptions(),
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
            final isUnavailable = _unavailableDocuments[documentType] == true;

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
                          onPressed: isUploadingThis || isUnavailable
                              ? null
                              : () => _showUploadOptions(documentType: documentType),
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
                        const SizedBox(height: AppDimensions.spacing2xs),
                        OutlinedButton(
                          onPressed: () => _setDocumentUnavailable(
                            documentType,
                            !isUnavailable,
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppDimensions.spacingSm,
                              vertical: AppDimensions.spacing2xs,
                            ),
                            minimumSize: const Size(0, AppDimensions.buttonHeightSm),
                          ),
                          child: Text(isUnavailable ? 'Mark as Available' : 'Unavailable'),
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

