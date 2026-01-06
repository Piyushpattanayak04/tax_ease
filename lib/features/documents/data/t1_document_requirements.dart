import '../../tax_forms/data/models/t1_form_models_simple.dart';

class T1DocumentRequirement {
  final String label;
  final bool Function(T1FormData form)? isRequiredWhen;

  /// If false, the card can be shown but it will not block submission.
  final bool countsTowardsSubmission;

  const T1DocumentRequirement({
    required this.label,
    this.isRequiredWhen,
    this.countsTowardsSubmission = true,
  });
}

class T1DocumentRequirements {
  T1DocumentRequirements._();

  /// All supported document cards.
  ///
  static const List<T1DocumentRequirement> all = [
    // Q19 – Disability tax credit
    T1DocumentRequirement(
      label: 'Disability Approval form',
      isRequiredWhen: _hasDisabilityTaxCredit,
    ),

    // Q20 – Deceased return
    T1DocumentRequirement(
      label: 'Clearance Certificate',
      isRequiredWhen: _isFilingForDeceased,
    ),

    // Charitable donations
    T1DocumentRequirement(
      label: 'Charitable Donation Receipts',
      isRequiredWhen: _hasCharitableDonations,
    ),

    // Moving expenses – base doc plus granular items derived from detailed form
    T1DocumentRequirement(
      label: 'Moving Expense',
      isRequiredWhen: _hasMovingExpenses,
    ),
    T1DocumentRequirement(
      label: 'Air Tickets',
      isRequiredWhen: _hasMovingAirTicketCost,
    ),
    T1DocumentRequirement(
      label: 'Detailed claim moving expense receipt (Optional)',
      isRequiredWhen: _hasMovingMoversAndPackers,
      countsTowardsSubmission: false,
    ),
    T1DocumentRequirement(
      label: 'Meals receipts (Optional)',
      isRequiredWhen: _hasMovingMealsAndOtherCost,
      countsTowardsSubmission: false,
    ),
    T1DocumentRequirement(
      label: 'Hotel stay receipts – 14 nights accommodation on the first move',
      isRequiredWhen: _hasMovingAnyOtherCost,
    ),
    T1DocumentRequirement(
      label: 'Short term accomodation in between provinces',
      isRequiredWhen: _hasMovingAnyOtherCost,
    ),
    T1DocumentRequirement(
      label: 'Vehicle change permit receipt (Optional)',
      isRequiredWhen: _hasMovingAnyOtherCost,
      countsTowardsSubmission: false,
    ),

    // Uber / Skip / DoorDash self-employment documents
    T1DocumentRequirement(
      label: 'Uber Income Statement',
      isRequiredWhen: _hasUberSkipBusiness,
    ),
    T1DocumentRequirement(
      label: 'Skip Income Statement',
      isRequiredWhen: _hasUberSkipBusiness,
    ),
    T1DocumentRequirement(
      label: 'Uber Eats Statement',
      isRequiredWhen: _hasUberSkipBusiness,
    ),
    T1DocumentRequirement(
      label: 'Doordash Income Statement',
      isRequiredWhen: _hasUberSkipBusiness,
    ),
    T1DocumentRequirement(
      label: 'U-Ride Income Statement',
      isRequiredWhen: _hasUberSkipBusiness,
    ),
    T1DocumentRequirement(
      label: 'Car purchase Receipt (ONLY IF YOU PURCHASED A CAR)',
      isRequiredWhen: _hasUberSkipCarPurchase,
    ),

    // Rental income – show docs when specific expense fields are filled
    T1DocumentRequirement(
      label: 'House Insurance Statement',
      isRequiredWhen: _hasRentalHouseInsurance,
    ),
    T1DocumentRequirement(
      label: 'Bank Mortgage Statement',
      isRequiredWhen: _hasRentalMortgageInterest,
    ),
    T1DocumentRequirement(
      label: 'Property Tax Bill',
      isRequiredWhen: _hasRentalPropertyTaxes,
    ),
    T1DocumentRequirement(
      label: 'Utility Bill',
      isRequiredWhen: _hasRentalUtilities,
    ),
    T1DocumentRequirement(
      label: 'Management / Admin Fees Receipt',
      isRequiredWhen: _hasRentalManagementFees,
    ),
    T1DocumentRequirement(
      label: 'Repair and Maintenance Receipt',
      isRequiredWhen: _hasRentalRepairAndMaintenance,
    ),
    T1DocumentRequirement(
      label: 'Cleaning Expense Receipt',
      isRequiredWhen: _hasRentalCleaningExpense,
    ),
    T1DocumentRequirement(
      label: 'Legal and Professional Fees Receipt',
      isRequiredWhen: _hasRentalLegalProfessionalFees,
    ),
    T1DocumentRequirement(
      label: 'Advertising and Promotion Receipt',
      isRequiredWhen: _hasRentalAdvertisingPromotion,
    ),

    // Education, union, daycare, professional dues, RRSP/FHSA, child credits
    T1DocumentRequirement(
      label: 'T2202 Form',
      isRequiredWhen: _wasStudentLastYear,
    ),
    T1DocumentRequirement(
      label: 'Union Dues Receipt',
      isRequiredWhen: _isUnionMember,
    ),
    T1DocumentRequirement(
      label: 'Day Care Expense Receipts',
      isRequiredWhen: _hasDaycareExpenses,
    ),
    T1DocumentRequirement(
      label: 'Professional Fees Receipt',
      isRequiredWhen: _hasProfessionalDues,
    ),
    T1DocumentRequirement(
      label: 'RRSP/FHSA T-slips',
      isRequiredWhen: _hasRrspFhsaInvestment,
    ),
    T1DocumentRequirement(
      label: "Receipt for Child's Sport/Fitness & Art",
      isRequiredWhen: _hasChildArtSportCredit,
    ),
  ];

  static bool requiresAny(T1FormData form) => requiredLabels(form).isNotEmpty;

  static List<T1DocumentRequirement> visibleFor(T1FormData? form) {
    if (form == null) return all;
    return all.where((req) {
      if (req.isRequiredWhen == null) return true;
      return req.isRequiredWhen!(form);
    }).toList();
  }

  static List<T1DocumentRequirement> requiredForSubmission(T1FormData form) {
    return all.where((req) {
      if (!req.countsTowardsSubmission) return false;
      if (req.isRequiredWhen == null) return false;
      return req.isRequiredWhen!(form);
    }).toList();
  }

  static List<String> requiredLabels(T1FormData form) {
    return requiredForSubmission(form).map((r) => r.label).toList();
  }

  static bool areAllRequiredUploaded(T1FormData form) {
    final required = requiredForSubmission(form);
    if (required.isEmpty) return true;

    final uploads = form.uploadedDocuments;
    final unavailable = form.unavailableDocuments;

    return required.every((req) {
      final label = req.label;
      final name = uploads[label];
      final isUnavailable = unavailable[label] == true;

      // A required document is considered satisfied if it is either uploaded
      // with a non-empty filename or explicitly marked as unavailable.
      return (name != null && name.trim().isNotEmpty) || isUnavailable;
    });
  }

  /// Returns true if the user has marked any document as unavailable.
  static bool hasAnyUnavailable(T1FormData form) {
    if (form.unavailableDocuments.isEmpty) return false;
    return form.unavailableDocuments.values.any((v) => v == true);
  }

  static bool _hasCharitableDonations(T1FormData f) => f.hasCharitableDonations == true;
  static bool _hasMovingExpenses(T1FormData f) => f.hasMovingExpenses == true;
  static bool _isFirstHomeBuyer(T1FormData f) => f.isFirstHomeBuyer == true;
  static bool _wasStudentLastYear(T1FormData f) => f.wasStudentLastYear == true;
  static bool _isUnionMember(T1FormData f) => f.isUnionMember == true;
  static bool _hasDaycareExpenses(T1FormData f) => f.hasDaycareExpenses == true;
  static bool _hasProfessionalDues(T1FormData f) => f.hasProfessionalDues == true;
  static bool _hasRrspFhsaInvestment(T1FormData f) => f.hasRrspFhsaInvestment == true;
  static bool _hasChildArtSportCredit(T1FormData f) => f.hasChildArtSportCredit == true;
  static bool _hasDisabilityTaxCredit(T1FormData f) => f.hasDisabilityTaxCredit == true;
  static bool _isFilingForDeceased(T1FormData f) => f.isFilingForDeceased == true;

  // ==== Helpers for new granular moving-expense-driven documents ====
  static Iterable<T1MovingExpense> _allMovingExpenses(T1FormData f) sync* {
    if (f.movingExpense != null) yield f.movingExpense!;
    if (f.movingExpenseIndividual != null) yield f.movingExpenseIndividual!;
    if (f.movingExpenseSpouse != null) yield f.movingExpenseSpouse!;
  }

  static bool _hasMovingAirTicketCost(T1FormData f) =>
      _allMovingExpenses(f).any((m) => m.airTicketCost > 0);

  static bool _hasMovingMoversAndPackers(T1FormData f) =>
      _allMovingExpenses(f).any((m) => m.moversAndPackers > 0);

  static bool _hasMovingMealsAndOtherCost(T1FormData f) =>
      _allMovingExpenses(f).any((m) => m.mealsAndOtherCost > 0);

  static bool _hasMovingAnyOtherCost(T1FormData f) =>
      _allMovingExpenses(f).any((m) => m.anyOtherCost > 0);

  // ==== Helpers for Uber / Skip / DoorDash documents ====
  static bool _hasUberSkipBusiness(T1FormData f) {
    final se = f.selfEmployment;
    if (se == null) return false;
    return se.businessTypes.contains('uber');
  }

  static bool _hasUberSkipCarPurchase(T1FormData f) {
    if (!_hasUberSkipBusiness(f)) return false;
    final uber = f.selfEmployment?.uberBusiness;
    if (uber == null) return false;
    // Heuristic: a positive depreciation implies an owned vehicle, i.e. a car purchase.
    return uber.depreciation > 0;
  }

  // ==== Helpers for rental-income-driven documents ====
  static T1RentalIncome? _rental(T1FormData f) {
    final se = f.selfEmployment;
    if (se == null) return null;
    if (!se.businessTypes.contains('rental')) return null;
    return se.rentalIncome;
  }

  static bool _hasRentalHouseInsurance(T1FormData f) {
    final r = _rental(f);
    return r != null && r.houseInsurance > 0;
  }

  static bool _hasRentalMortgageInterest(T1FormData f) {
    final r = _rental(f);
    return r != null && r.mortgageInterest > 0;
  }

  static bool _hasRentalPropertyTaxes(T1FormData f) {
    final r = _rental(f);
    return r != null && r.propertyTaxes > 0;
  }

  static bool _hasRentalUtilities(T1FormData f) {
    final r = _rental(f);
    return r != null && r.utilities > 0;
  }

  static bool _hasRentalManagementFees(T1FormData f) {
    final r = _rental(f);
    return r != null && r.managementAdminFees > 0;
  }

  static bool _hasRentalRepairAndMaintenance(T1FormData f) {
    final r = _rental(f);
    return r != null && r.repairAndMaintenance > 0;
  }

  static bool _hasRentalCleaningExpense(T1FormData f) {
    final r = _rental(f);
    return r != null && r.cleaningExpense > 0;
  }

  static bool _hasRentalLegalProfessionalFees(T1FormData f) {
    final r = _rental(f);
    return r != null && r.legalProfessionalFees > 0;
  }

  static bool _hasRentalAdvertisingPromotion(T1FormData f) {
    final r = _rental(f);
    return r != null && r.advertisingPromotion > 0;
  }
}
