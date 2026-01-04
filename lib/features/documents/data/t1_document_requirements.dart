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
    // Q19
    T1DocumentRequirement(
      label: 'Disability Approval form',
      isRequiredWhen: _hasDisabilityTaxCredit,
    ),
    // Q20
    T1DocumentRequirement(
      label: 'Clearance Certificate',
      isRequiredWhen: _isFilingForDeceased,
    ),
    T1DocumentRequirement(
      label: 'Charitable Donation Receipts',
      isRequiredWhen: _hasCharitableDonations,
    ),
    T1DocumentRequirement(
      label: 'Moving Expense',
      isRequiredWhen: _hasMovingExpenses,
    ),
    T1DocumentRequirement(
      label: 'Statement of Adjustment issued by lawyer',
      isRequiredWhen: _isFirstHomeBuyer,
    ),
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
}
