import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';
import '../models/t2_form_models.dart';

class T2FormStorageService {
  static const String _t2FormDataKey = 'T2_FORM_DATA';
  static const String _t2FormProgressKey = 'T2_FORM_PROGRESS';
  static const String _t2FormLastSavedKey = 'T2_FORM_LAST_SAVED';
  static const String _t2FormsListKey = 'T2_FORMS_LIST';

  static T2FormStorageService? _instance;
  static T2FormStorageService get instance {
    _instance ??= T2FormStorageService._();
    return _instance!;
  }

  final Logger _logger = Logger();

  T2FormStorageService._();

  /// Create a new T2 form with unique ID
  T2FormData createNewForm() {
    final id = 'T2_${DateTime.now().millisecondsSinceEpoch}';
    return T2FormData(
      id: id,
      status: 'draft',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Save multiple forms to SharedPreferences
  Future<bool> saveAllForms(List<T2FormData> forms) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = forms.map((form) => form.toJson()).toList();
      final jsonString = json.encode(jsonList);
      
      await prefs.setString(_t2FormsListKey, jsonString);
      return true;
    } catch (e) {
      _logger.e('Error saving T2 forms: $e');
      return false;
    }
  }

  /// Load all T2 forms from SharedPreferences
  Future<List<T2FormData>> loadAllForms() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_t2FormsListKey);
      
      if (jsonString == null) {
        // Try to migrate old single form to new format
        final oldForm = await loadT2FormData();
        if (oldForm != null) {
          final migratedForm = oldForm.copyWith(
            id: oldForm.id.isEmpty ? 'T2_${DateTime.now().millisecondsSinceEpoch}' : oldForm.id,
          );
          await saveAllForms([migratedForm]);
          return [migratedForm];
        }
        return [];
      }
      
      final jsonList = json.decode(jsonString) as List;
      return jsonList.map((json) => T2FormData.fromJson(json)).toList();
    } catch (e) {
      _logger.e('Error loading T2 forms: $e');
      return [];
    }
  }

  /// Save a specific form (update existing or add new)
  Future<bool> saveForm(T2FormData form) async {
    try {
      final forms = await loadAllForms();
      final index = forms.indexWhere((f) => f.id == form.id);
      
      if (index >= 0) {
        // Update existing form
        forms[index] = form;
      } else {
        // Add new form
        forms.add(form);
      }
      
      return await saveAllForms(forms);
    } catch (e) {
      _logger.e('Error saving T2 form: $e');
      return false;
    }
  }

  /// Get a form by ID
  Future<T2FormData?> getFormById(String id) async {
    try {
      final forms = await loadAllForms();
      return forms.firstWhere((form) => form.id == id);
    } catch (e) {
      _logger.e('Error getting T2 form by ID: $e');
      return null;
    }
  }

  /// Save T2 form data to SharedPreferences (Legacy method)
  Future<bool> saveT2FormData(T2FormData formData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = json.encode(formData.toJson());
      
      await prefs.setString(_t2FormDataKey, jsonString);
      await prefs.setString(_t2FormLastSavedKey, DateTime.now().toIso8601String());
      
      // Calculate and save progress
      final progress = calculateFormProgress(formData);
      await prefs.setDouble(_t2FormProgressKey, progress);
      
      return true;
    } catch (e) {
      _logger.e('Error saving T2 form data: $e');
      return false;
    }
  }

  /// Load T2 form data from SharedPreferences (Legacy method)
  Future<T2FormData?> loadT2FormData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_t2FormDataKey);
      
      if (jsonString == null) return null;
      
      final jsonData = json.decode(jsonString) as Map<String, dynamic>;
      return T2FormData.fromJson(jsonData);
    } catch (e) {
      _logger.e('Error loading T2 form data: $e');
      return null;
    }
  }

  /// Get form progress percentage (0.0 to 1.0)
  Future<double> getFormProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getDouble(_t2FormProgressKey) ?? 0.0;
    } catch (e) {
      _logger.e('Error getting T2 form progress: $e');
      return 0.0;
    }
  }

  /// Get progress text based on percentage
  String getProgressText(double progress) {
    if (progress <= 0.01) {
      return 'Get Started';
    } else if (progress >= 1.0) {
      return 'Form filled successfully, under review';
    } else {
      // Format as percentage with 0 decimal places
      return '${(progress * 100).toInt()}% Complete';
    }
  }

  /// Get last saved date
  Future<DateTime?> getLastSavedDate() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final dateString = prefs.getString(_t2FormLastSavedKey);
      return dateString != null ? DateTime.parse(dateString) : null;
    } catch (e) {
      _logger.e('Error getting last saved date: $e');
      return null;
    }
  }

  /// Clear all T2 form data
  Future<bool> clearT2FormData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_t2FormDataKey);
      await prefs.remove(_t2FormProgressKey);
      await prefs.remove(_t2FormLastSavedKey);
      return true;
    } catch (e) {
      _logger.e('Error clearing T2 form data: $e');
      return false;
    }
  }

  /// Clear all forms data (including the new forms list)
  Future<bool> clearAllFormsData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Clear all T2 form related keys
      await prefs.remove(_t2FormDataKey);
      await prefs.remove(_t2FormProgressKey);
      await prefs.remove(_t2FormLastSavedKey);
      await prefs.remove(_t2FormsListKey);
      
      _logger.i('All T2 forms data cleared successfully');
      return true;
    } catch (e) {
      _logger.e('Error clearing all T2 forms data: $e');
      return false;
    }
  }

  /// Calculate form completion progress based on filled fields
  double calculateFormProgress(T2FormData formData) {
    int totalFields = 0;
    int filledFields = 0;

    // Corporation Info (Weight: 35%)
    final corporationInfoProgress = _getCorporationInfoProgress(formData.corporationInfo);
    totalFields += corporationInfoProgress['total']!;
    filledFields += corporationInfoProgress['filled']!;

    // Tax Year Info (Weight: 25%)
    final taxYearInfoProgress = _getTaxYearInfoProgress(formData.taxYearInfo);
    totalFields += taxYearInfoProgress['total']!;
    filledFields += taxYearInfoProgress['filled']!;

    // Taxable Income Info (Weight: 30%)
    final taxableIncomeProgress = _getTaxableIncomeProgress(formData.taxableIncomeInfo);
    totalFields += taxableIncomeProgress['total']!;
    filledFields += taxableIncomeProgress['filled']!;

    // Additional Information (Weight: 10%)
    totalFields += 12; // Additional questions
    if (formData.isInactive != null) filledFields++;
    if (formData.usesIFRS != null) filledFields++;
    if (formData.meetsSubstantiveCCPC != null) filledFields++;
    if (formData.principalProduct1.isNotEmpty) filledFields++;
    if (formData.principalProduct1Percentage > 0) filledFields++;
    if (formData.immigratedToCanada != null) filledFields++;
    if (formData.emigratedFromCanada != null) filledFields++;
    if (formData.wantsQuarterlyInstallments != null) filledFields++;
    if (formData.hasSubcontractors != null) filledFields++;
    
    // Bonus points for multiple products
    if (formData.principalProduct2.isNotEmpty) filledFields++;
    if (formData.principalProduct3.isNotEmpty) filledFields++;
    if (formData.ceasedQuarterlyEligibility != null) filledFields++;

    if (totalFields == 0) return 0.0;
    return filledFields / totalFields;
  }

  Map<String, int> _getCorporationInfoProgress(T2CorporationInfo corporationInfo) {
    int total = 0;
    int filled = 0;

    // Required fields
    total += 8; // businessNumber, corporationName, headOfficeAddress, city, province, country, postalCode, typeOfCorporation
    if (corporationInfo.businessNumber.isNotEmpty) filled++;
    if (corporationInfo.corporationName.isNotEmpty) filled++;
    if (corporationInfo.headOfficeAddress.isNotEmpty) filled++;
    if (corporationInfo.headOfficeCity.isNotEmpty) filled++;
    if (corporationInfo.headOfficeProvince.isNotEmpty) filled++;
    if (corporationInfo.headOfficeCountry.isNotEmpty) filled++;
    if (corporationInfo.headOfficePostalCode.isNotEmpty) filled++;
    if (corporationInfo.typeOfCorporation.isNotEmpty) filled++;

    // Optional mailing address (if provided)
    if (corporationInfo.mailingAddress?.isNotEmpty == true) {
      total += 5; // Mailing address fields
      if (corporationInfo.mailingCity?.isNotEmpty == true) filled++;
      if (corporationInfo.mailingProvince?.isNotEmpty == true) filled++;
      if (corporationInfo.mailingCountry?.isNotEmpty == true) filled++;
      if (corporationInfo.mailingPostalCode?.isNotEmpty == true) filled++;
      filled++; // For the address itself
    }

    // Books and records address (if different)
    if (corporationInfo.booksAndRecordsAddress?.isNotEmpty == true) {
      total += 5; // Books and records address fields
      if (corporationInfo.booksAndRecordsCity?.isNotEmpty == true) filled++;
      if (corporationInfo.booksAndRecordsProvince?.isNotEmpty == true) filled++;
      if (corporationInfo.booksAndRecordsCountry?.isNotEmpty == true) filled++;
      if (corporationInfo.booksAndRecordsPostalCode?.isNotEmpty == true) filled++;
      filled++; // For the address itself
    }

    return {'total': total, 'filled': filled};
  }

  Map<String, int> _getTaxYearInfoProgress(T2TaxYearInfo? taxYearInfo) {
    int total = 4; // taxYearStart, taxYearEnd, isCanadianResident, and one more basic field
    int filled = 0;

    if (taxYearInfo != null) {
      // Tax year dates are always filled in constructor
      filled += 2; // taxYearStart, taxYearEnd
      
      // Canadian residency
      filled++; // isCanadianResident has default
      
      // Additional questions
      total += 8; // Additional boolean fields
      if (taxYearInfo.hasAcquisitionOfControl) {
        filled++;
        if (taxYearInfo.acquisitionOfControlDate != null) filled++;
      }
      if (taxYearInfo.isDeemedTaxYearEnd) filled++;
      if (taxYearInfo.isProfessionalCorporationPartnership) filled++;
      if (taxYearInfo.isFirstYearAfterIncorporation) filled++;
      if (taxYearInfo.isFirstYearAfterAmalgamation) filled++;
      if (taxYearInfo.hasWindUpOfSubsidiary) filled++;
      if (taxYearInfo.isFinalYearBeforeAmalgamation) filled++;
      if (taxYearInfo.isFinalReturnUpToDissolution) filled++;
      
      if (taxYearInfo.functionalCurrency.isNotEmpty) filled++;
      if (!taxYearInfo.isCanadianResident && taxYearInfo.countryOfResidence?.isNotEmpty == true) filled++;
    }

    return {'total': total, 'filled': filled};
  }

  Map<String, int> _getTaxableIncomeProgress(T2TaxableIncomeInfo taxableIncomeInfo) {
    int total = 16; // All the numeric fields
    int filled = 0;

    // Count non-zero values as filled
    if (taxableIncomeInfo.netIncomeOrLoss != 0.0) filled++;
    if (taxableIncomeInfo.charitableDonations != 0.0) filled++;
    if (taxableIncomeInfo.culturalGifts != 0.0) filled++;
    if (taxableIncomeInfo.ecologicalGifts != 0.0) filled++;
    if (taxableIncomeInfo.taxableDividendsDeductible != 0.0) filled++;
    if (taxableIncomeInfo.partVITaxDeduction != 0.0) filled++;
    if (taxableIncomeInfo.nonCapitalLosses != 0.0) filled++;
    if (taxableIncomeInfo.netCapitalLosses != 0.0) filled++;
    if (taxableIncomeInfo.restrictedFarmLosses != 0.0) filled++;
    if (taxableIncomeInfo.farmLosses != 0.0) filled++;
    if (taxableIncomeInfo.limitedPartnershipLosses != 0.0) filled++;
    if (taxableIncomeInfo.restrictedInterestExpenses != 0.0) filled++;
    if (taxableIncomeInfo.taxableCapitalGains != 0.0) filled++;
    if (taxableIncomeInfo.prospectorShares != 0.0) filled++;
    if (taxableIncomeInfo.employerDeductionNonQualified != 0.0) filled++;
    if (taxableIncomeInfo.section110Additions != 0.0) filled++;

    return {'total': total, 'filled': filled};
  }

  /// Check if form is complete (100% filled)
  Future<bool> isFormComplete() async {
    final progress = await getFormProgress();
    return progress >= 1.0;
  }

  /// Get progress status text based on percentage
  String getProgressStatusText(double progress) {
    if (progress == 0.0) {
      return 'Get Started';
    } else if (progress >= 1.0) {
      return 'Form filled successfully, under review';
    } else {
      return '${(progress * 100).round()}% form filled';
    }
  }

  /// Get progress status for dashboard based on multiple forms
  Future<Map<String, dynamic>> getProgressStatus() async {
    try {
      final forms = await loadAllForms();
      
      // If no forms exist, show "Get Started"
      if (forms.isEmpty) {
        return {
          'progress': 0.0,
          'progressText': 'Get Started',
          'lastSaved': null,
          'isComplete': false,
        };
      }
      
      // Separate forms by status
      final draftForms = forms.where((f) => f.status == 'draft').toList();
      final submittedForms = forms.where((f) => f.status == 'submitted').toList();
      
      // If all forms are submitted, show "under review"
      if (draftForms.isEmpty && submittedForms.isNotEmpty) {
        final mostRecent = submittedForms.reduce((a, b) => 
          (a.updatedAt ?? DateTime(0)).isAfter(b.updatedAt ?? DateTime(0)) ? a : b);
        
        return {
          'progress': 1.0,
          'progressText': 'Form submitted, under review',
          'lastSaved': mostRecent.updatedAt,
          'isComplete': true,
        };
      }
      
      // If there are draft forms, show progress of most recent draft
      if (draftForms.isNotEmpty) {
        final mostRecentDraft = draftForms.reduce((a, b) => 
          (a.updatedAt ?? DateTime(0)).isAfter(b.updatedAt ?? DateTime(0)) ? a : b);
        
        final progress = calculateFormProgress(mostRecentDraft);
        
        return {
          'progress': progress,
          'progressText': getProgressStatusText(progress),
          'lastSaved': mostRecentDraft.updatedAt,
          'isComplete': progress >= 1.0,
        };
      }
      
      // Fallback (shouldn't reach here)
      return {
        'progress': 0.0,
        'progressText': 'Get Started',
        'lastSaved': null,
        'isComplete': false,
      };
    } catch (e) {
      _logger.e('Error getting T2 progress status: $e');
      return {
        'progress': 0.0,
        'progressText': 'Get Started',
        'lastSaved': null,
        'isComplete': false,
      };
    }
  }
}