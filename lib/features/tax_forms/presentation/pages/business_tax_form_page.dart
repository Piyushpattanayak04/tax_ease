import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../data/models/t2_form_models.dart';
import '../../data/services/t2_form_storage_service.dart';
import '../widgets/t2_corporation_info_step.dart';
import '../widgets/t2_income_deductions_step.dart';
import '../widgets/t2_form_progress_bar.dart';

class BusinessTaxFormPage extends StatefulWidget {
  final String? formId;
  
  const BusinessTaxFormPage({super.key, this.formId});

  @override
  State<BusinessTaxFormPage> createState() => _BusinessTaxFormPageState();
}

class _BusinessTaxFormPageState extends State<BusinessTaxFormPage>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _progressController;
  late AnimationController _slideController;
  
  int _currentStep = 0;
  final int _totalSteps = 2; // Corporation Info, Income & Deductions
  
  T2FormData _formData = T2FormData.empty();
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    _loadFormData();
  }

  @override
  void dispose() {
    _autoSaveTimer?.cancel();
    _pageController.dispose();
    _progressController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  Future<void> _loadFormData() async {
    T2FormData? savedData;
    
    if (widget.formId != null) {
      // Load specific form by ID
      savedData = await T2FormStorageService.instance.getFormById(widget.formId!);
    }
    
    if (savedData == null) {
      // Create a new form if no existing form found
      savedData = T2FormStorageService.instance.createNewForm();
      // Save the new form immediately
      await T2FormStorageService.instance.saveForm(savedData);
    }
    
    setState(() {
      _formData = savedData!;
      _isLoading = false;
    });
  }

  Future<void> _saveFormData() async {
    if (_isSaving) return;
    
    setState(() {
      _isSaving = true;
    });
    
    try {
      final success = await T2FormStorageService.instance.saveForm(_formData);
      
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Form saved successfully'),
              ],
            ),
            backgroundColor: AppColors.success,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 8),
                Text('Error saving form: $e'),
              ],
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      setState(() {
        _currentStep++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _progressController.animateTo(_currentStep / (_totalSteps - 1));
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _progressController.animateTo(_currentStep / (_totalSteps - 1));
    }
  }

  Future<void> _submitForm() async {
    // Update form status to submitted
    _formData = _formData.copyWith(status: 'submitted');
    await _saveFormData();
    
    if (mounted) {
      // Show success dialog
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
            'Your T2 Corporation Income Tax Return has been saved and is now under review. '
            'You can continue to edit the form until the filing deadline.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
context.go('/tax-forms/filled-forms?refresh=true'); // Navigate with refresh parameter
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void _updateFormData(T2FormData newData) {
    setState(() {
      _formData = newData;
    });
    // Auto-save the form data when it changes
    _autoSaveFormData();
  }

  void _updateCorporationInfo(T2CorporationInfo corporationInfo) {
    _updateFormData(_formData.copyWith(corporationInfo: corporationInfo));
  }

  void _updateTaxYearInfo(T2TaxYearInfo taxYearInfo) {
    _updateFormData(_formData.copyWith(taxYearInfo: taxYearInfo));
  }

  void _updateTaxableIncomeInfo(T2TaxableIncomeInfo taxableIncomeInfo) {
    _updateFormData(_formData.copyWith(taxableIncomeInfo: taxableIncomeInfo));
  }

  // Debounced auto-save to avoid excessive saves
  Timer? _autoSaveTimer;
  void _autoSaveFormData() {
    _autoSaveTimer?.cancel();
    _autoSaveTimer = Timer(const Duration(milliseconds: 1500), () {
      _performAutoSave();
    });
  }

  Future<void> _performAutoSave() async {
    if (!mounted) return;
    
    try {
      await T2FormStorageService.instance.saveForm(_formData);
      // Silent auto-save, no user notification
    } catch (e) {
      // Only log error, don't show user notification for auto-save failures
      debugPrint('Auto-save failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('T2 Corporation Tax Form'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
onPressed: () => context.go('/tax-forms/filled-forms'),
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('T2 Corporation Tax Form'),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
onPressed: () => context.go('/tax-forms/filled-forms'),
        ),
        actions: [
          if (_isSaving)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Progress Bar
          Container(
            color: Theme.of(context).cardColor,
            padding: const EdgeInsets.all(AppDimensions.spacingMd),
            child: Column(
              children: [
                T2FormProgressBar(
                  currentStep: _currentStep,
                  totalSteps: _totalSteps,
                  controller: _progressController,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Corporation Info',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: _currentStep == 0 ? FontWeight.w600 : FontWeight.w400,
                        color: _currentStep == 0 ? AppColors.primary : AppColors.grey500,
                      ),
                    ),
                    Text(
                      'Income & Deductions',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: _currentStep == 1 ? FontWeight.w600 : FontWeight.w400,
                        color: _currentStep == 1 ? AppColors.primary : AppColors.grey500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Form Content
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentStep = index;
                });
                _progressController.animateTo(index / (_totalSteps - 1));
              },
              children: [
                // Step 1: Corporation Information
                T2CorporationInfoStep(
                  corporationInfo: _formData.corporationInfo,
                  taxYearInfo: _formData.taxYearInfo,
                  onCorporationInfoChanged: _updateCorporationInfo,
                  onTaxYearInfoChanged: _updateTaxYearInfo,
                  onNext: _nextStep,
                ),
                // Step 2: Income & Deductions
                T2IncomeDeductionsStep(
                  taxableIncomeInfo: _formData.taxableIncomeInfo,
                  formData: _formData,
                  onTaxableIncomeChanged: _updateTaxableIncomeInfo,
                  onFormDataChanged: _updateFormData,
                  onPrevious: _previousStep,
                  onSubmit: _submitForm,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
