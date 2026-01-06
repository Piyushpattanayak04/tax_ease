import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/theme_controller.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../data/models/t1_form_models_simple.dart';
import '../../data/services/t1_form_storage_service.dart';
import '../../data/services/t1_remote_service.dart';
import '../../../documents/data/t1_document_requirements.dart';
import '../widgets/t1_personal_info_step.dart';
import '../widgets/t1_questionnaire_1_step.dart';
import '../widgets/t1_questionnaire_2_step.dart';
import '../widgets/t1_form_progress_bar.dart';

class PersonalTaxFormPage extends StatefulWidget {
  final String? formId;
  
  const PersonalTaxFormPage({super.key, this.formId});

  @override
  State<PersonalTaxFormPage> createState() => _PersonalTaxFormPageState();
}

class _PersonalTaxFormPageState extends State<PersonalTaxFormPage>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _progressController;
  late AnimationController _slideController;
  
  int _currentStep = 0;
  
  /// Dynamic list of step titles shown in the top bar.
  /// Always starts with:
  /// 0: Personal Info
  /// 1: Questionnaire
  /// Followed by optional detail pages in this order:
  /// - Uber/Skip/DoorDash
  /// - Rental Income
  /// - General Business
  /// - Moving Expenses
  List<String> _stepTitles = const [];

  /// Detail steps corresponding to indices >= 2 in [_stepTitles].
  List<T1DetailStepType> _detailSteps = const [];
  
  T1FormData _formData = const T1FormData.empty();
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
    T1FormData? savedData;
    
    if (widget.formId != null) {
      // Load specific form by ID from local storage first
      savedData = await T1FormStorageService.instance.getFormById(widget.formId!);

      // If not found locally, attempt to load from backend
      if (savedData == null && ThemeController.authToken != null) {
        try {
          final remote = await T1RemoteService.instance.fetchForm(filingId: widget.formId!);
          savedData = remote.copyWith(id: widget.formId!);
          await T1FormStorageService.instance.saveForm(savedData!);
        } catch (_) {
          // Ignore remote failures here; we'll treat as no existing form
        }
      }
    }
    
    if (savedData == null) {
      // Create a new local form if no existing form found
      savedData = T1FormData(
        id: widget.formId ?? '',
        status: 'draft',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await T1FormStorageService.instance.saveForm(savedData!);
    }
    
    setState(() {
      _formData = savedData!;
      _isLoading = false;
      _rebuildSteps();
    });
  }

  Future<void> _saveFormData() async {
    if (_isSaving) return;
    
    setState(() {
      _isSaving = true;
    });
    
    try {
      final success = await T1FormStorageService.instance.saveForm(_formData);

      // Also persist to backend if we have a filing id
      if (_formData.id.isNotEmpty) {
        await T1RemoteService.instance.saveAnswers(
          filingId: _formData.id,
          form: _formData,
        );
      }
      
      if (success && mounted) {
        AppToast.success(context, 'Form saved successfully');
      }
    } catch (e) {
      if (mounted) {
        AppToast.error(context, 'Error saving form: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  void _rebuildSteps() {
    final hasMovingExpenses = _formData.hasMovingExpenses ?? false;
    final isSelfEmployed = _formData.isSelfEmployed ?? false;
    final isFilingForDeceased = _formData.isFilingForDeceased ?? false;
    final businessTypes = _formData.selfEmployment?.businessTypes ?? <String>[];

    final detailSteps = <T1DetailStepType>[];
    final titles = <String>['Personal Info', 'Questionnaire'];

    if (isSelfEmployed && businessTypes.contains('uber')) {
      detailSteps.add(T1DetailStepType.uberSkipDoordash);
      titles.add('Uberskip/Doordash');
    }
    if (isSelfEmployed && businessTypes.contains('rental')) {
      detailSteps.add(T1DetailStepType.rentalIncome);
      titles.add('Rental Income');
    }
    if (isSelfEmployed && businessTypes.contains('general')) {
      detailSteps.add(T1DetailStepType.generalBusiness);
      titles.add('General Business');
    }
    if (hasMovingExpenses) {
      detailSteps.add(T1DetailStepType.movingExpenses);
      titles.add('Moving Expenses');
    }

    if (isFilingForDeceased) {
      detailSteps.add(T1DetailStepType.deceasedReturn);
      titles.add('Deceased Return');
    }

    _detailSteps = detailSteps;
    _stepTitles = titles;

    if (_stepTitles.isEmpty) {
      _currentStep = 0;
      _progressController.animateTo(0.0);
      return;
    }

    if (_currentStep >= _stepTitles.length) {
      _currentStep = _stepTitles.length - 1;
    }

    _updateProgress();
  }

  void _updateProgress() {
    if (_stepTitles.length <= 1) {
      _progressController.animateTo(0.0);
    } else {
      _progressController.animateTo(_currentStep / (_stepTitles.length - 1));
    }
  }

  void _nextStep() {
    if (_stepTitles.isEmpty) return;

    // If this is the last step, take the final action (submit or upload documents)
    if (_currentStep >= _stepTitles.length - 1) {
      _handleFinalAction();
      return;
    }

    setState(() {
      _currentStep++;
    });
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    _updateProgress();
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
      _updateProgress();
    }
  }

  bool get _requiresDocuments => T1DocumentRequirements.requiresAny(_formData);

  Future<void> _handleFinalAction() async {
    // If docs are required, always route user through the documents workflow.
    if (_requiresDocuments) {
      _formData = _formData.copyWith(awaitingDocuments: true);
      await T1FormStorageService.instance.saveForm(_formData);

      if (mounted) {
        context.go('/documents?t1FormId=${_formData.id}');
      }
      return;
    }

    await _submitForm();
  }

  Future<void> _submitForm() async {
    if (_formData.id.isEmpty) {
      if (mounted) {
        AppToast.error(context, 'Missing filing id. Please start a new filing from "Your Forms".');
      }
      return;
    }

    // Validate required fields before submitting
    final validationError = _validateRequiredFields();
    if (validationError != null) {
      if (mounted) {
        AppToast.error(context, validationError);
        // Jump back to first step to help user fix issues
        _pageController.jumpToPage(0);
        setState(() {
          _currentStep = 0;
        });
        _updateProgress();
      }
      return;
    }

    try {
      // Persist latest answers then submit remotely
      await T1RemoteService.instance.saveAnswers(
        filingId: _formData.id,
        form: _formData,
      );
      await T1RemoteService.instance.submit(filingId: _formData.id);

      // Update local status to submitted
      _formData = _formData.copyWith(status: 'submitted', awaitingDocuments: false);
      await T1FormStorageService.instance.saveForm(_formData);
    } catch (e) {
      if (mounted) {
        AppToast.error(
          context,
          'Error submitting form. Please try again.',
        );
      }
      return;
    }
    
    if (mounted) {
      // Show success dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          icon: const Icon(
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
                Navigator.of(context).pop(); // Close dialog
                context.go('/tax-forms/filled-forms?refresh=true');
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void _updateFormData(T1FormData newData) {
    // If questionnaire updates mean documents are no longer required, clear the documents flow flag.
    if (!T1DocumentRequirements.requiresAny(newData) && newData.awaitingDocuments) {
      newData = newData.copyWith(awaitingDocuments: false);
    }

    setState(() {
      _formData = newData;
      _rebuildSteps();
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

  /// Ensure required personal info and all 20 questionnaire flags are answered.
  String? _validateRequiredFields() {
    final p = _formData.personalInfo;

    bool _isEmpty(String s) => s.trim().isEmpty;

    // Personal info mandatory fields
    if (_isEmpty(p.firstName) ||
        _isEmpty(p.lastName) ||
        _isEmpty(p.sin) ||
        p.dateOfBirth == null ||
        _isEmpty(p.address) ||
        _isEmpty(p.phoneNumber) ||
        _isEmpty(p.email) ||
        p.isCanadianCitizen == null ||
        p.maritalStatus.trim().isEmpty) {
      return 'Please complete all required personal information fields (marked with *).';
    }

    // Spouse info required if married/common-law
    if (p.maritalStatus == 'married' || p.maritalStatus == 'common-law') {
      final s = p.spouseInfo;
      if (s == null ||
          _isEmpty(s.firstName) ||
          _isEmpty(s.lastName) ||
          _isEmpty(s.sin) ||
          s.dateOfBirth == null) {
        return 'Please complete all required spouse information fields.';
      }
    }

    final f = _formData;
    final bools = <bool?>[
      f.hasForeignProperty,
      f.hasMedicalExpenses,
      f.hasCharitableDonations,
      f.hasMovingExpenses,
      f.isSelfEmployed,
      f.isFirstHomeBuyer,
      f.soldPropertyLongTerm,
      f.soldPropertyShortTerm,
      f.hasWorkFromHomeExpense,
      f.wasStudentLastYear,
      f.isUnionMember,
      f.hasDaycareExpenses,
      f.isFirstTimeFiler,
      f.hasOtherIncome,
      f.hasProfessionalDues,
      f.hasRrspFhsaInvestment,
      f.hasChildArtSportCredit,
      f.isProvinceFiler,
      f.hasDisabilityTaxCredit,
      f.isFilingForDeceased,
    ];

    if (bools.any((b) => b == null)) {
      return 'Please answer all 20 questionnaire questions (Yes or No).';
    }

    return null;
  }

  Future<void> _performAutoSave() async {
    if (!mounted) return;
    
    try {
      await T1FormStorageService.instance.saveForm(_formData);
      if (_formData.id.isNotEmpty) {
        await T1RemoteService.instance.saveAnswers(
          filingId: _formData.id,
          form: _formData,
        );
      }
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
          title: const Text('T1 Personal Tax Form'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              } else {
                context.go('/tax-forms/filled-forms');
              }
            },
          ),
        ),
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              context.go('/tax-forms/filled-forms');
            }
          },
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          final horizontalPadding = constraints.maxWidth >= 1024
              ? AppDimensions.spacingXl
              : AppDimensions.screenPadding;
          final maxContentWidth = constraints.maxWidth >= 1024 ? 900.0 : double.infinity;

          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxContentWidth),
              child: Column(
                children: [
                  // Progress Bar
                  Container(
                    color: Theme.of(context).cardColor,
                    padding: const EdgeInsets.all(AppDimensions.spacingMd),
                    child: Column(
                      children: [
                        T1FormProgressBar(
                          currentStep: _currentStep,
                          totalSteps: _stepTitles.length,
                          controller: _progressController,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(_stepTitles.length, (index) {
                            final isActive = index == _currentStep;
                            return Flexible(
                              child: Text(
                                _stepTitles[index],
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                                  color: isActive ? AppColors.primary : AppColors.grey500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                  // Form Content
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                      child: PageView(
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() {
                            _currentStep = index;
                          });
                          _updateProgress();
                        },
                        children: List.generate(_stepTitles.length, (index) {
                          // Step 0: Personal Information
                          if (index == 0) {
                            return T1PersonalInfoStep(
                              personalInfo: _formData.personalInfo,
                              onPersonalInfoChanged: (personalInfo) {
                                _updateFormData(_formData.copyWith(personalInfo: personalInfo));
                              },
                              onNext: _nextStep,
                            );
                          }
                          // Step 1: Questionnaire (basic questions)
                          if (index == 1) {
                            return T1Questionnaire1Step(
                              formData: _formData,
                              onFormDataChanged: _updateFormData,
                              onPrevious: _previousStep,
                              onNext: _nextStep,
                              finalActionLabel: _requiresDocuments ? 'Upload Documents' : 'Submit Form',
                            );
                          }
                          // Subsequent steps: detailed sections
                          final detailIndex = index - 2;
                          if (detailIndex < 0 || detailIndex >= _detailSteps.length) {
                            return const SizedBox.shrink();
                          }
                          final detailType = _detailSteps[detailIndex];
                          final isLastStep = index == _stepTitles.length - 1;
                          final String primaryLabel = isLastStep
                              ? (_requiresDocuments ? 'Upload Documents' : 'Submit Form')
                              : 'Next: ${_stepTitles[index + 1]}';
                          final String previousTitle = _stepTitles[index - 1];
                          return T1Questionnaire2Step(
                            stepType: detailType,
                            formData: _formData,
                            onFormDataChanged: _updateFormData,
                            onPrevious: _previousStep,
                            onPrimary: isLastStep
                                ? () {
                                    _handleFinalAction();
                                  }
                                : _nextStep,
                            primaryButtonLabel: primaryLabel,
                            previousStepTitle: previousTitle,
                          );
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
