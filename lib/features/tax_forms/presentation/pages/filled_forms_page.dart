import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/utils/smooth_scroll_physics.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/animations/smooth_animations.dart';
import '../../data/models/t1_form_models_simple.dart';
import '../../data/models/t2_form_models.dart';
import '../../data/services/t1_form_storage_service.dart';
import '../../data/services/t2_form_storage_service.dart';

// Combined form data for unified display
class CombinedFormData {
  final String id;
  final String formType; // 'T1' or 'T2'
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String displayName;
  final T1FormData? t1Form;
  final T2FormData? t2Form;

  CombinedFormData({
    required this.id,
    required this.formType,
    required this.status,
    this.createdAt,
    this.updatedAt,
    required this.displayName,
    this.t1Form,
    this.t2Form,
  });
  
  static CombinedFormData fromT1(T1FormData form) {
    return CombinedFormData(
      id: form.id,
      formType: 'T1',
      status: form.status,
      createdAt: form.createdAt,
      updatedAt: form.updatedAt,
      displayName: form.personalInfo.firstName.isNotEmpty
          ? '${form.personalInfo.firstName} ${form.personalInfo.lastName}'
          : 'Personal Tax Draft',
      t1Form: form,
    );
  }
  
  static CombinedFormData fromT2(T2FormData form) {
    return CombinedFormData(
      id: form.id,
      formType: 'T2',
      status: form.status,
      createdAt: form.createdAt,
      updatedAt: form.updatedAt,
      displayName: form.corporationInfo.corporationName.isNotEmpty
          ? form.corporationInfo.corporationName
          : 'Business Tax Draft',
      t2Form: form,
    );
  }
}

class YourFormsPage extends StatefulWidget {
  final bool? shouldRefresh;
  
  const YourFormsPage({super.key, this.shouldRefresh});

  @override
  State<YourFormsPage> createState() => _YourFormsPageState();
}

class _YourFormsPageState extends State<YourFormsPage> with WidgetsBindingObserver {
  List<CombinedFormData> _allForms = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
_loadAllForms();
    
    // If we should refresh (e.g., after form submission), delay and reload
    if (widget.shouldRefresh == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            _loadAllForms();
          }
        });
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Refresh forms when app comes back into focus
      _loadAllForms();
    }
  }

  Future<void> _loadAllForms() async {
    try {
      // Load T1 forms
      final t1Forms = await T1FormStorageService.instance.loadAllForms();
      final t1CombinedForms = t1Forms.map((form) => CombinedFormData.fromT1(form)).toList();
      
      // Load T2 forms
      final t2Forms = await T2FormStorageService.instance.loadAllForms();
      final t2CombinedForms = t2Forms.map((form) => CombinedFormData.fromT2(form)).toList();
      
      // Combine and sort by updated date
      final allForms = [...t1CombinedForms, ...t2CombinedForms];
      allForms.sort((a, b) {
        final aDate = a.updatedAt ?? DateTime(0);
        final bDate = b.updatedAt ?? DateTime(0);
        return bDate.compareTo(aDate); // Most recent first
      });
      
      setState(() {
        _allForms = allForms;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _allForms = [];
        _isLoading = false;
      });
    }
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return 'Unknown';
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          // Navigate back to home when back button is pressed
          context.go('/home');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Your Forms'),
          automaticallyImplyLeading: false, // Remove back button
        ),
      body: ResponsiveContainer(
        centerContent: false,
        padding: EdgeInsets.all(Responsive.responsive(
          context: context,
          mobile: AppDimensions.screenPadding,
          tablet: AppDimensions.screenPaddingLarge,
          desktop: AppDimensions.spacingXl,
        )),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header section
                  SmoothAnimations.slideUp(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your Tax Forms',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_allForms.length} form${_allForms.length == 1 ? '' : 's'} saved',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.grey600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Forms list
                  Expanded(
                    child: _allForms.isEmpty
                        ? _buildEmptyState()
                        : _buildFormsList(),
                  ),
                ],
              ),
      ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 80), // Add bottom padding to avoid collision
          child: FloatingActionButton.extended(
            onPressed: () {
              // Navigate to TaxForms page for form selection
              context.push('/tax-forms');
            },
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text(
              'New Filing',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return SmoothAnimations.slideUp(
      delay: const Duration(milliseconds: 400),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(60),
            ),
            child: Icon(
              Icons.description_outlined,
              size: 60,
              color: AppColors.primary.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No forms yet',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start your first tax filing by tapping the "New Filing" button below.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.grey600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormsList() {
    return SingleChildScrollView(
      physics: const SmoothBouncingScrollPhysics(),
      child: Column(
        children: _allForms.asMap().entries.map((entry) {
          final index = entry.key;
          final form = entry.value;
          return SmoothAnimations.slideUp(
            delay: Duration(milliseconds: 400 + (index * 100)),
            child: _buildFormCard(form, index),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFormCard(CombinedFormData form, int index) {
    final isT1 = form.formType == 'T1';
    final formIcon = isT1 ? Icons.person : Icons.business;
    final formColor = isT1 ? AppColors.primary : AppColors.secondary;
    final formTitle = isT1 
        ? 'T1 Personal Tax Form ${DateTime.now().year}'
        : 'T2 Business Tax Form ${DateTime.now().year}';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: Theme.of(context).dividerColor),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        onTap: () {
          if (isT1) {
            context.push('/tax-forms/personal?formId=${form.id}');
          } else {
            context.push('/tax-forms/business?formId=${form.id}');
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spacingLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: formColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      formIcon,
                      color: formColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: formColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                form.formType,
                                style: TextStyle(
                                  color: formColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                formTitle,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          form.displayName,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.grey600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(form.status).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getStatusText(form.status),
                      style: TextStyle(
                        color: _getStatusColor(form.status),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: AppColors.grey500,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Last modified: ${_formatDateTime(form.updatedAt)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.grey500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'submitted':
        return AppColors.success;
      case 'draft':
      default:
        return Colors.orange;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'submitted':
        return 'Submitted';
      case 'draft':
      default:
        return 'Draft';
    }
  }
}
