import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/utils/smooth_scroll_physics.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../shared/animations/smooth_animations.dart';
import '../../data/models/t1_form_models_simple.dart';
import '../../data/services/t1_form_storage_service.dart';

class FilledFormsPage extends StatefulWidget {
  final bool? shouldRefresh;
  
  const FilledFormsPage({super.key, this.shouldRefresh});

  @override
  State<FilledFormsPage> createState() => _FilledFormsPageState();
}

class _FilledFormsPageState extends State<FilledFormsPage> with WidgetsBindingObserver {
  List<T1FormData> _submittedForms = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadSubmittedForms();
    
    // If we should refresh (e.g., after form submission), delay and reload
    if (widget.shouldRefresh == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            _loadSubmittedForms();
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
      _loadSubmittedForms();
    }
  }

  Future<void> _loadSubmittedForms() async {
    try {
      // Load all forms using the new multi-form system
      final forms = await T1FormStorageService.instance.loadAllForms();
      setState(() {
        _submittedForms = forms;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _submittedForms = [];
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Tax Forms'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/tax-forms'),
        ),
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
                          'Your T1 Forms',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_submittedForms.length} form${_submittedForms.length == 1 ? '' : 's'} saved',
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
                    child: _submittedForms.isEmpty
                        ? _buildEmptyState()
                        : _buildFormsList(),
                  ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Create a new form and navigate with the form ID
          final newForm = T1FormStorageService.instance.createNewForm();
          context.push('/tax-forms/personal?formId=${newForm.id}');
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
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(60),
            ),
            child: Icon(
              Icons.description_outlined,
              size: 60,
              color: AppColors.primary.withOpacity(0.7),
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
            'Start your first T1 Personal Tax filing by tapping the "New Filing" button below.',
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
        children: _submittedForms.asMap().entries.map((entry) {
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

  Widget _buildFormCard(T1FormData form, int index) {
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
        onTap: () => context.push('/tax-forms/personal?formId=${form.id}'),
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
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.description,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'T1 Personal Tax Form ${DateTime.now().year}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          form.personalInfo.firstName.isNotEmpty
                              ? '${form.personalInfo.firstName} ${form.personalInfo.lastName}'
                              : 'Draft Form',
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
                      color: _getStatusColor(form.status).withOpacity(0.1),
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
