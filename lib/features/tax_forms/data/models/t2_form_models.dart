// T2 Corporation Income Tax Return Data Models
// Based on T2 Corporation Income Tax Return (2024 and later tax years)

class T2CorporationInfo {
  final String businessNumber;
  final String corporationName;
  final String headOfficeAddress;
  final String headOfficeCity;
  final String headOfficeProvince;
  final String headOfficeCountry;
  final String headOfficePostalCode;
  final bool headOfficeAddressChanged;
  final String? mailingAddress;
  final String? mailingCity;
  final String? mailingProvince;
  final String? mailingCountry;
  final String? mailingPostalCode;
  final bool mailingAddressChanged;
  final String? booksAndRecordsAddress;
  final String? booksAndRecordsCity;
  final String? booksAndRecordsProvince;
  final String? booksAndRecordsCountry;
  final String? booksAndRecordsPostalCode;
  final bool booksAndRecordsAddressChanged;
  final String typeOfCorporation; // CCPC, Other private, Public, etc.
  final DateTime? typeChangeEffectiveDate;

  const T2CorporationInfo({
    this.businessNumber = '',
    this.corporationName = '',
    this.headOfficeAddress = '',
    this.headOfficeCity = '',
    this.headOfficeProvince = '',
    this.headOfficeCountry = '',
    this.headOfficePostalCode = '',
    this.headOfficeAddressChanged = false,
    this.mailingAddress,
    this.mailingCity,
    this.mailingProvince,
    this.mailingCountry,
    this.mailingPostalCode,
    this.mailingAddressChanged = false,
    this.booksAndRecordsAddress,
    this.booksAndRecordsCity,
    this.booksAndRecordsProvince,
    this.booksAndRecordsCountry,
    this.booksAndRecordsPostalCode,
    this.booksAndRecordsAddressChanged = false,
    this.typeOfCorporation = '',
    this.typeChangeEffectiveDate,
  });

  factory T2CorporationInfo.fromJson(Map<String, dynamic> json) {
    return T2CorporationInfo(
      businessNumber: json['businessNumber'] ?? '',
      corporationName: json['corporationName'] ?? '',
      headOfficeAddress: json['headOfficeAddress'] ?? '',
      headOfficeCity: json['headOfficeCity'] ?? '',
      headOfficeProvince: json['headOfficeProvince'] ?? '',
      headOfficeCountry: json['headOfficeCountry'] ?? '',
      headOfficePostalCode: json['headOfficePostalCode'] ?? '',
      headOfficeAddressChanged: json['headOfficeAddressChanged'] ?? false,
      mailingAddress: json['mailingAddress'],
      mailingCity: json['mailingCity'],
      mailingProvince: json['mailingProvince'],
      mailingCountry: json['mailingCountry'],
      mailingPostalCode: json['mailingPostalCode'],
      mailingAddressChanged: json['mailingAddressChanged'] ?? false,
      booksAndRecordsAddress: json['booksAndRecordsAddress'],
      booksAndRecordsCity: json['booksAndRecordsCity'],
      booksAndRecordsProvince: json['booksAndRecordsProvince'],
      booksAndRecordsCountry: json['booksAndRecordsCountry'],
      booksAndRecordsPostalCode: json['booksAndRecordsPostalCode'],
      booksAndRecordsAddressChanged: json['booksAndRecordsAddressChanged'] ?? false,
      typeOfCorporation: json['typeOfCorporation'] ?? '',
      typeChangeEffectiveDate: json['typeChangeEffectiveDate'] != null ? 
          DateTime.parse(json['typeChangeEffectiveDate']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'businessNumber': businessNumber,
      'corporationName': corporationName,
      'headOfficeAddress': headOfficeAddress,
      'headOfficeCity': headOfficeCity,
      'headOfficeProvince': headOfficeProvince,
      'headOfficeCountry': headOfficeCountry,
      'headOfficePostalCode': headOfficePostalCode,
      'headOfficeAddressChanged': headOfficeAddressChanged,
      'mailingAddress': mailingAddress,
      'mailingCity': mailingCity,
      'mailingProvince': mailingProvince,
      'mailingCountry': mailingCountry,
      'mailingPostalCode': mailingPostalCode,
      'mailingAddressChanged': mailingAddressChanged,
      'booksAndRecordsAddress': booksAndRecordsAddress,
      'booksAndRecordsCity': booksAndRecordsCity,
      'booksAndRecordsProvince': booksAndRecordsProvince,
      'booksAndRecordsCountry': booksAndRecordsCountry,
      'booksAndRecordsPostalCode': booksAndRecordsPostalCode,
      'booksAndRecordsAddressChanged': booksAndRecordsAddressChanged,
      'typeOfCorporation': typeOfCorporation,
      'typeChangeEffectiveDate': typeChangeEffectiveDate?.toIso8601String(),
    };
  }

  T2CorporationInfo copyWith({
    String? businessNumber,
    String? corporationName,
    String? headOfficeAddress,
    String? headOfficeCity,
    String? headOfficeProvince,
    String? headOfficeCountry,
    String? headOfficePostalCode,
    bool? headOfficeAddressChanged,
    String? mailingAddress,
    String? mailingCity,
    String? mailingProvince,
    String? mailingCountry,
    String? mailingPostalCode,
    bool? mailingAddressChanged,
    String? booksAndRecordsAddress,
    String? booksAndRecordsCity,
    String? booksAndRecordsProvince,
    String? booksAndRecordsCountry,
    String? booksAndRecordsPostalCode,
    bool? booksAndRecordsAddressChanged,
    String? typeOfCorporation,
    DateTime? typeChangeEffectiveDate,
  }) {
    return T2CorporationInfo(
      businessNumber: businessNumber ?? this.businessNumber,
      corporationName: corporationName ?? this.corporationName,
      headOfficeAddress: headOfficeAddress ?? this.headOfficeAddress,
      headOfficeCity: headOfficeCity ?? this.headOfficeCity,
      headOfficeProvince: headOfficeProvince ?? this.headOfficeProvince,
      headOfficeCountry: headOfficeCountry ?? this.headOfficeCountry,
      headOfficePostalCode: headOfficePostalCode ?? this.headOfficePostalCode,
      headOfficeAddressChanged: headOfficeAddressChanged ?? this.headOfficeAddressChanged,
      mailingAddress: mailingAddress ?? this.mailingAddress,
      mailingCity: mailingCity ?? this.mailingCity,
      mailingProvince: mailingProvince ?? this.mailingProvince,
      mailingCountry: mailingCountry ?? this.mailingCountry,
      mailingPostalCode: mailingPostalCode ?? this.mailingPostalCode,
      mailingAddressChanged: mailingAddressChanged ?? this.mailingAddressChanged,
      booksAndRecordsAddress: booksAndRecordsAddress ?? this.booksAndRecordsAddress,
      booksAndRecordsCity: booksAndRecordsCity ?? this.booksAndRecordsCity,
      booksAndRecordsProvince: booksAndRecordsProvince ?? this.booksAndRecordsProvince,
      booksAndRecordsCountry: booksAndRecordsCountry ?? this.booksAndRecordsCountry,
      booksAndRecordsPostalCode: booksAndRecordsPostalCode ?? this.booksAndRecordsPostalCode,
      booksAndRecordsAddressChanged: booksAndRecordsAddressChanged ?? this.booksAndRecordsAddressChanged,
      typeOfCorporation: typeOfCorporation ?? this.typeOfCorporation,
      typeChangeEffectiveDate: typeChangeEffectiveDate ?? this.typeChangeEffectiveDate,
    );
  }
}

class T2TaxYearInfo {
  final DateTime taxYearStart;
  final DateTime taxYearEnd;
  final bool hasAcquisitionOfControl;
  final DateTime? acquisitionOfControlDate;
  final bool isDeemedTaxYearEnd;
  final bool isProfessionalCorporationPartnership;
  final bool isFirstYearAfterIncorporation;
  final bool isFirstYearAfterAmalgamation;
  final bool hasWindUpOfSubsidiary;
  final bool isFinalYearBeforeAmalgamation;
  final bool isFinalReturnUpToDissolution;
  final String functionalCurrency;
  final bool isCanadianResident;
  final String? countryOfResidence;
  final bool isClaimingTreatyExemption;

  T2TaxYearInfo({
    DateTime? taxYearStart,
    DateTime? taxYearEnd,
    this.hasAcquisitionOfControl = false,
    this.acquisitionOfControlDate,
    this.isDeemedTaxYearEnd = false,
    this.isProfessionalCorporationPartnership = false,
    this.isFirstYearAfterIncorporation = false,
    this.isFirstYearAfterAmalgamation = false,
    this.hasWindUpOfSubsidiary = false,
    this.isFinalYearBeforeAmalgamation = false,
    this.isFinalReturnUpToDissolution = false,
    this.functionalCurrency = '',
    this.isCanadianResident = false, // Changed default from true to false
    this.countryOfResidence,
    this.isClaimingTreatyExemption = false,
  }) : taxYearStart = taxYearStart ?? DateTime.now().subtract(const Duration(days: 365)),
       taxYearEnd = taxYearEnd ?? DateTime.now();

  // Cannot be const due to DateTime constructor limitations
  static T2TaxYearInfo empty() => T2TaxYearInfo(
    taxYearStart: DateTime(1970),
    taxYearEnd: DateTime(1970),
    functionalCurrency: '',
    isCanadianResident: false, // Changed from true to false
    countryOfResidence: null,
  );

  factory T2TaxYearInfo.fromJson(Map<String, dynamic> json) {
    return T2TaxYearInfo(
      taxYearStart: json['taxYearStart'] != null ? DateTime.parse(json['taxYearStart']) : null,
      taxYearEnd: json['taxYearEnd'] != null ? DateTime.parse(json['taxYearEnd']) : null,
      hasAcquisitionOfControl: json['hasAcquisitionOfControl'] ?? false,
      acquisitionOfControlDate: json['acquisitionOfControlDate'] != null ? 
          DateTime.parse(json['acquisitionOfControlDate']) : null,
      isDeemedTaxYearEnd: json['isDeemedTaxYearEnd'] ?? false,
      isProfessionalCorporationPartnership: json['isProfessionalCorporationPartnership'] ?? false,
      isFirstYearAfterIncorporation: json['isFirstYearAfterIncorporation'] ?? false,
      isFirstYearAfterAmalgamation: json['isFirstYearAfterAmalgamation'] ?? false,
      hasWindUpOfSubsidiary: json['hasWindUpOfSubsidiary'] ?? false,
      isFinalYearBeforeAmalgamation: json['isFinalYearBeforeAmalgamation'] ?? false,
      isFinalReturnUpToDissolution: json['isFinalReturnUpToDissolution'] ?? false,
      functionalCurrency: json['functionalCurrency'] ?? '',
      isCanadianResident: json['isCanadianResident'] ?? false,
      countryOfResidence: json['countryOfResidence'],
      isClaimingTreatyExemption: json['isClaimingTreatyExemption'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'taxYearStart': taxYearStart.toIso8601String(),
      'taxYearEnd': taxYearEnd.toIso8601String(),
      'hasAcquisitionOfControl': hasAcquisitionOfControl,
      'acquisitionOfControlDate': acquisitionOfControlDate?.toIso8601String(),
      'isDeemedTaxYearEnd': isDeemedTaxYearEnd,
      'isProfessionalCorporationPartnership': isProfessionalCorporationPartnership,
      'isFirstYearAfterIncorporation': isFirstYearAfterIncorporation,
      'isFirstYearAfterAmalgamation': isFirstYearAfterAmalgamation,
      'hasWindUpOfSubsidiary': hasWindUpOfSubsidiary,
      'isFinalYearBeforeAmalgamation': isFinalYearBeforeAmalgamation,
      'isFinalReturnUpToDissolution': isFinalReturnUpToDissolution,
      'functionalCurrency': functionalCurrency,
      'isCanadianResident': isCanadianResident,
      'countryOfResidence': countryOfResidence,
      'isClaimingTreatyExemption': isClaimingTreatyExemption,
    };
  }

  T2TaxYearInfo copyWith({
    DateTime? taxYearStart,
    DateTime? taxYearEnd,
    bool? hasAcquisitionOfControl,
    DateTime? acquisitionOfControlDate,
    bool? isDeemedTaxYearEnd,
    bool? isProfessionalCorporationPartnership,
    bool? isFirstYearAfterIncorporation,
    bool? isFirstYearAfterAmalgamation,
    bool? hasWindUpOfSubsidiary,
    bool? isFinalYearBeforeAmalgamation,
    bool? isFinalReturnUpToDissolution,
    String? functionalCurrency,
    bool? isCanadianResident,
    String? countryOfResidence,
    bool? isClaimingTreatyExemption,
  }) {
    return T2TaxYearInfo(
      taxYearStart: taxYearStart ?? this.taxYearStart,
      taxYearEnd: taxYearEnd ?? this.taxYearEnd,
      hasAcquisitionOfControl: hasAcquisitionOfControl ?? this.hasAcquisitionOfControl,
      acquisitionOfControlDate: acquisitionOfControlDate ?? this.acquisitionOfControlDate,
      isDeemedTaxYearEnd: isDeemedTaxYearEnd ?? this.isDeemedTaxYearEnd,
      isProfessionalCorporationPartnership: isProfessionalCorporationPartnership ?? this.isProfessionalCorporationPartnership,
      isFirstYearAfterIncorporation: isFirstYearAfterIncorporation ?? this.isFirstYearAfterIncorporation,
      isFirstYearAfterAmalgamation: isFirstYearAfterAmalgamation ?? this.isFirstYearAfterAmalgamation,
      hasWindUpOfSubsidiary: hasWindUpOfSubsidiary ?? this.hasWindUpOfSubsidiary,
      isFinalYearBeforeAmalgamation: isFinalYearBeforeAmalgamation ?? this.isFinalYearBeforeAmalgamation,
      isFinalReturnUpToDissolution: isFinalReturnUpToDissolution ?? this.isFinalReturnUpToDissolution,
      functionalCurrency: functionalCurrency ?? this.functionalCurrency,
      isCanadianResident: isCanadianResident ?? this.isCanadianResident,
      countryOfResidence: countryOfResidence ?? this.countryOfResidence,
      isClaimingTreatyExemption: isClaimingTreatyExemption ?? this.isClaimingTreatyExemption,
    );
  }
}

class T2TaxableIncomeInfo {
  final double netIncomeOrLoss;
  final double charitableDonations;
  final double culturalGifts;
  final double ecologicalGifts;
  final double taxableDividendsDeductible;
  final double partVITaxDeduction;
  final double nonCapitalLosses;
  final double netCapitalLosses;
  final double restrictedFarmLosses;
  final double farmLosses;
  final double limitedPartnershipLosses;
  final double restrictedInterestExpenses;
  final double taxableCapitalGains;
  final double prospectorShares;
  final double employerDeductionNonQualified;
  final double section110Additions;

  const T2TaxableIncomeInfo({
    this.netIncomeOrLoss = 0.0,
    this.charitableDonations = 0.0,
    this.culturalGifts = 0.0,
    this.ecologicalGifts = 0.0,
    this.taxableDividendsDeductible = 0.0,
    this.partVITaxDeduction = 0.0,
    this.nonCapitalLosses = 0.0,
    this.netCapitalLosses = 0.0,
    this.restrictedFarmLosses = 0.0,
    this.farmLosses = 0.0,
    this.limitedPartnershipLosses = 0.0,
    this.restrictedInterestExpenses = 0.0,
    this.taxableCapitalGains = 0.0,
    this.prospectorShares = 0.0,
    this.employerDeductionNonQualified = 0.0,
    this.section110Additions = 0.0,
  });

  factory T2TaxableIncomeInfo.fromJson(Map<String, dynamic> json) {
    return T2TaxableIncomeInfo(
      netIncomeOrLoss: (json['netIncomeOrLoss'] ?? 0.0).toDouble(),
      charitableDonations: (json['charitableDonations'] ?? 0.0).toDouble(),
      culturalGifts: (json['culturalGifts'] ?? 0.0).toDouble(),
      ecologicalGifts: (json['ecologicalGifts'] ?? 0.0).toDouble(),
      taxableDividendsDeductible: (json['taxableDividendsDeductible'] ?? 0.0).toDouble(),
      partVITaxDeduction: (json['partVITaxDeduction'] ?? 0.0).toDouble(),
      nonCapitalLosses: (json['nonCapitalLosses'] ?? 0.0).toDouble(),
      netCapitalLosses: (json['netCapitalLosses'] ?? 0.0).toDouble(),
      restrictedFarmLosses: (json['restrictedFarmLosses'] ?? 0.0).toDouble(),
      farmLosses: (json['farmLosses'] ?? 0.0).toDouble(),
      limitedPartnershipLosses: (json['limitedPartnershipLosses'] ?? 0.0).toDouble(),
      restrictedInterestExpenses: (json['restrictedInterestExpenses'] ?? 0.0).toDouble(),
      taxableCapitalGains: (json['taxableCapitalGains'] ?? 0.0).toDouble(),
      prospectorShares: (json['prospectorShares'] ?? 0.0).toDouble(),
      employerDeductionNonQualified: (json['employerDeductionNonQualified'] ?? 0.0).toDouble(),
      section110Additions: (json['section110Additions'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'netIncomeOrLoss': netIncomeOrLoss,
      'charitableDonations': charitableDonations,
      'culturalGifts': culturalGifts,
      'ecologicalGifts': ecologicalGifts,
      'taxableDividendsDeductible': taxableDividendsDeductible,
      'partVITaxDeduction': partVITaxDeduction,
      'nonCapitalLosses': nonCapitalLosses,
      'netCapitalLosses': netCapitalLosses,
      'restrictedFarmLosses': restrictedFarmLosses,
      'farmLosses': farmLosses,
      'limitedPartnershipLosses': limitedPartnershipLosses,
      'restrictedInterestExpenses': restrictedInterestExpenses,
      'taxableCapitalGains': taxableCapitalGains,
      'prospectorShares': prospectorShares,
      'employerDeductionNonQualified': employerDeductionNonQualified,
      'section110Additions': section110Additions,
    };
  }

  double get taxableIncome {
    final deductions = charitableDonations + culturalGifts + ecologicalGifts + 
                      taxableDividendsDeductible + partVITaxDeduction + 
                      nonCapitalLosses + netCapitalLosses + restrictedFarmLosses + 
                      farmLosses + limitedPartnershipLosses + restrictedInterestExpenses + 
                      taxableCapitalGains + prospectorShares + employerDeductionNonQualified;
    
    final subtotal = netIncomeOrLoss - deductions;
    return (subtotal < 0 ? 0 : subtotal) + section110Additions;
  }

  T2TaxableIncomeInfo copyWith({
    double? netIncomeOrLoss,
    double? charitableDonations,
    double? culturalGifts,
    double? ecologicalGifts,
    double? taxableDividendsDeductible,
    double? partVITaxDeduction,
    double? nonCapitalLosses,
    double? netCapitalLosses,
    double? restrictedFarmLosses,
    double? farmLosses,
    double? limitedPartnershipLosses,
    double? restrictedInterestExpenses,
    double? taxableCapitalGains,
    double? prospectorShares,
    double? employerDeductionNonQualified,
    double? section110Additions,
  }) {
    return T2TaxableIncomeInfo(
      netIncomeOrLoss: netIncomeOrLoss ?? this.netIncomeOrLoss,
      charitableDonations: charitableDonations ?? this.charitableDonations,
      culturalGifts: culturalGifts ?? this.culturalGifts,
      ecologicalGifts: ecologicalGifts ?? this.ecologicalGifts,
      taxableDividendsDeductible: taxableDividendsDeductible ?? this.taxableDividendsDeductible,
      partVITaxDeduction: partVITaxDeduction ?? this.partVITaxDeduction,
      nonCapitalLosses: nonCapitalLosses ?? this.nonCapitalLosses,
      netCapitalLosses: netCapitalLosses ?? this.netCapitalLosses,
      restrictedFarmLosses: restrictedFarmLosses ?? this.restrictedFarmLosses,
      farmLosses: farmLosses ?? this.farmLosses,
      limitedPartnershipLosses: limitedPartnershipLosses ?? this.limitedPartnershipLosses,
      restrictedInterestExpenses: restrictedInterestExpenses ?? this.restrictedInterestExpenses,
      taxableCapitalGains: taxableCapitalGains ?? this.taxableCapitalGains,
      prospectorShares: prospectorShares ?? this.prospectorShares,
      employerDeductionNonQualified: employerDeductionNonQualified ?? this.employerDeductionNonQualified,
      section110Additions: section110Additions ?? this.section110Additions,
    );
  }
}

// Main T2 Form Data class
class T2FormData {
  final String id;
  final String status; // 'draft', 'submitted'
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final T2CorporationInfo corporationInfo;
  final T2TaxYearInfo taxYearInfo;
  final T2TaxableIncomeInfo taxableIncomeInfo;
  final bool? isInactive;
  final bool? usesIFRS;
  final bool? meetsSubstantiveCCPC;
  final String principalProduct1;
  final int principalProduct1Percentage;
  final String principalProduct2;
  final int principalProduct2Percentage;
  final String principalProduct3;
  final int principalProduct3Percentage;
  final bool? immigratedToCanada;
  final bool? emigratedFromCanada;
  final bool? wantsQuarterlyInstallments;
  final DateTime? ceasedQuarterlyEligibility;
  final bool? hasSubcontractors;

  T2FormData({
    this.id = '',
    this.status = 'draft',
    DateTime? createdAt,
    DateTime? updatedAt,
    this.corporationInfo = const T2CorporationInfo(),
    T2TaxYearInfo? taxYearInfo,
    this.taxableIncomeInfo = const T2TaxableIncomeInfo(),
    this.isInactive,
    this.usesIFRS,
    this.meetsSubstantiveCCPC,
    this.principalProduct1 = '',
    this.principalProduct1Percentage = 0,
    this.principalProduct2 = '',
    this.principalProduct2Percentage = 0,
    this.principalProduct3 = '',
    this.principalProduct3Percentage = 0,
    this.immigratedToCanada,
    this.emigratedFromCanada,
    this.wantsQuarterlyInstallments,
    this.ceasedQuarterlyEligibility,
    this.hasSubcontractors,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now(),
       taxYearInfo = taxYearInfo ?? T2TaxYearInfo();

  T2FormData.empty()
      : id = '',
        status = 'draft',
        createdAt = null,
        updatedAt = null,
        corporationInfo = const T2CorporationInfo(),
        taxYearInfo = T2TaxYearInfo.empty(),
        taxableIncomeInfo = const T2TaxableIncomeInfo(),
        isInactive = null,
        usesIFRS = null,
        meetsSubstantiveCCPC = null,
        principalProduct1 = '',
        principalProduct1Percentage = 0,
        principalProduct2 = '',
        principalProduct2Percentage = 0,
        principalProduct3 = '',
        principalProduct3Percentage = 0,
        immigratedToCanada = null,
        emigratedFromCanada = null,
        wantsQuarterlyInstallments = null,
        ceasedQuarterlyEligibility = null,
        hasSubcontractors = null;

  factory T2FormData.fromJson(Map<String, dynamic> json) {
    return T2FormData(
      id: json['id'] ?? '',
      status: json['status'] ?? 'draft',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : DateTime.now(),
      corporationInfo: json['corporationInfo'] != null ? 
          T2CorporationInfo.fromJson(json['corporationInfo']) : const T2CorporationInfo(),
      taxYearInfo: json['taxYearInfo'] != null ? 
          T2TaxYearInfo.fromJson(json['taxYearInfo']) : T2TaxYearInfo(),
      taxableIncomeInfo: json['taxableIncomeInfo'] != null ? 
          T2TaxableIncomeInfo.fromJson(json['taxableIncomeInfo']) : const T2TaxableIncomeInfo(),
      isInactive: json['isInactive'],
      usesIFRS: json['usesIFRS'],
      meetsSubstantiveCCPC: json['meetsSubstantiveCCPC'],
      principalProduct1: json['principalProduct1'] ?? '',
      principalProduct1Percentage: json['principalProduct1Percentage'] ?? 0,
      principalProduct2: json['principalProduct2'] ?? '',
      principalProduct2Percentage: json['principalProduct2Percentage'] ?? 0,
      principalProduct3: json['principalProduct3'] ?? '',
      principalProduct3Percentage: json['principalProduct3Percentage'] ?? 0,
      immigratedToCanada: json['immigratedToCanada'],
      emigratedFromCanada: json['emigratedFromCanada'],
      wantsQuarterlyInstallments: json['wantsQuarterlyInstallments'],
      ceasedQuarterlyEligibility: json['ceasedQuarterlyEligibility'] != null ? 
          DateTime.parse(json['ceasedQuarterlyEligibility']) : null,
      hasSubcontractors: json['hasSubcontractors'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'corporationInfo': corporationInfo.toJson(),
      'taxYearInfo': taxYearInfo.toJson(),
      'taxableIncomeInfo': taxableIncomeInfo.toJson(),
      'isInactive': isInactive,
      'usesIFRS': usesIFRS,
      'meetsSubstantiveCCPC': meetsSubstantiveCCPC,
      'principalProduct1': principalProduct1,
      'principalProduct1Percentage': principalProduct1Percentage,
      'principalProduct2': principalProduct2,
      'principalProduct2Percentage': principalProduct2Percentage,
      'principalProduct3': principalProduct3,
      'principalProduct3Percentage': principalProduct3Percentage,
      'immigratedToCanada': immigratedToCanada,
      'emigratedFromCanada': emigratedFromCanada,
      'wantsQuarterlyInstallments': wantsQuarterlyInstallments,
      'ceasedQuarterlyEligibility': ceasedQuarterlyEligibility?.toIso8601String(),
      'hasSubcontractors': hasSubcontractors,
    };
  }

  T2FormData copyWith({
    String? id,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    T2CorporationInfo? corporationInfo,
    T2TaxYearInfo? taxYearInfo,
    T2TaxableIncomeInfo? taxableIncomeInfo,
    bool? isInactive,
    bool? usesIFRS,
    bool? meetsSubstantiveCCPC,
    String? principalProduct1,
    int? principalProduct1Percentage,
    String? principalProduct2,
    int? principalProduct2Percentage,
    String? principalProduct3,
    int? principalProduct3Percentage,
    bool? immigratedToCanada,
    bool? emigratedFromCanada,
    bool? wantsQuarterlyInstallments,
    DateTime? ceasedQuarterlyEligibility,
    bool? hasSubcontractors,
  }) {
    return T2FormData(
      id: id ?? this.id,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      corporationInfo: corporationInfo ?? this.corporationInfo,
      taxYearInfo: taxYearInfo ?? this.taxYearInfo,
      taxableIncomeInfo: taxableIncomeInfo ?? this.taxableIncomeInfo,
      isInactive: isInactive ?? this.isInactive,
      usesIFRS: usesIFRS ?? this.usesIFRS,
      meetsSubstantiveCCPC: meetsSubstantiveCCPC ?? this.meetsSubstantiveCCPC,
      principalProduct1: principalProduct1 ?? this.principalProduct1,
      principalProduct1Percentage: principalProduct1Percentage ?? this.principalProduct1Percentage,
      principalProduct2: principalProduct2 ?? this.principalProduct2,
      principalProduct2Percentage: principalProduct2Percentage ?? this.principalProduct2Percentage,
      principalProduct3: principalProduct3 ?? this.principalProduct3,
      principalProduct3Percentage: principalProduct3Percentage ?? this.principalProduct3Percentage,
      immigratedToCanada: immigratedToCanada ?? this.immigratedToCanada,
      emigratedFromCanada: emigratedFromCanada ?? this.emigratedFromCanada,
      wantsQuarterlyInstallments: wantsQuarterlyInstallments ?? this.wantsQuarterlyInstallments,
      ceasedQuarterlyEligibility: ceasedQuarterlyEligibility ?? this.ceasedQuarterlyEligibility,
      hasSubcontractors: hasSubcontractors ?? this.hasSubcontractors,
    );
  }
}