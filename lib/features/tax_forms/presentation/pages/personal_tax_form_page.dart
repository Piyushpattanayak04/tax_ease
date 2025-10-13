import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../data/models/t1_form_models_simple.dart';
import '../../data/services/t1_form_storage_service.dart';
import '../widgets/t1_personal_info_step.dart';
import '../widgets/t1_questionnaire_step.dart';
import '../widgets/t1_form_progress_bar.dart';

class PersonalTaxFormPage extends StatefulWidget {
  const PersonalTaxFormPage({super.key});

  @override
  State<PersonalTaxFormPage> createState() => _PersonalTaxFormPageState();
}

class _PersonalTaxFormPageState extends State<PersonalTaxFormPage>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _progressController;
  late AnimationController _slideController;
  
  int _currentStep = 0;
  final int _totalSteps = 2; // Personal Info, Questionnaire
  
  T1FormData _formData = const T1FormData();
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
    final savedData = await T1FormStorageService.instance.loadT1FormData();
    setState(() {
      _formData = savedData ?? const T1FormData();
      _isLoading = false;
    });
  }

  Future<void> _saveFormData() async {
    if (_isSaving) return;
    
    setState(() {
      _isSaving = true;
    });
    
    try {
      final success = await T1FormStorageService.instance.saveT1FormData(_formData);
      
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
            'Your T1 Personal Tax form has been saved and is now under review. '
            'You can continue to edit the form until the filing deadline.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Go back to previous screen
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void _updateFormData(T1FormData newData) {
    setState(() {
      _formData = newData;
    });
    // Auto-save the form data when it changes
    _autoSaveFormData();
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
      await T1FormStorageService.instance.saveT1FormData(_formData);
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
        appBar: AppBar(title: const Text('T1 Personal Tax Form')),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('T1 Personal Tax Form'),
        centerTitle: true,
        elevation: 0,
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
                T1FormProgressBar(
                  currentStep: _currentStep,
                  totalSteps: _totalSteps,
                  controller: _progressController,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Personal Info',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: _currentStep == 0 ? FontWeight.w600 : FontWeight.w400,
                        color: _currentStep == 0 ? AppColors.primary : AppColors.grey500,
                      ),
                    ),
                    Text(
                      'Questionnaire',
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
                // Step 1: Personal Information
                T1PersonalInfoStep(
                  personalInfo: _formData.personalInfo,
                  onPersonalInfoChanged: (personalInfo) {
                    _updateFormData(_formData.copyWith(personalInfo: personalInfo));
                  },
                  onNext: _nextStep,
                ),
                // Step 2: Questionnaire
                T1QuestionnaireStep(
                  formData: _formData,
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
