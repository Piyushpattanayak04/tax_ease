// Simplified T1 Form Data Models
// This is a working version without JSON serialization complexity

class T1PersonalInfo {
  final String firstName;
  final String? middleName;
  final String lastName;
  final String sin;
  final DateTime? dateOfBirth;
  final String address;
  final String phoneNumber;
  final String email;
  final bool? isCanadianCitizen;
  final String maritalStatus;
  final T1SpouseInfo? spouseInfo;
  final List<T1ChildInfo> children;

  const T1PersonalInfo({
    this.firstName = '',
    this.middleName,
    this.lastName = '',
    this.sin = '',
    this.dateOfBirth,
    this.address = '',
    this.phoneNumber = '',
    this.email = '',
    this.isCanadianCitizen,
    this.maritalStatus = '',
    this.spouseInfo,
    this.children = const [],
  });

  factory T1PersonalInfo.fromJson(Map<String, dynamic> json) {
    return T1PersonalInfo(
      firstName: json['firstName'] ?? '',
      middleName: json['middleName'],
      lastName: json['lastName'] ?? '',
      sin: json['sin'] ?? '',
      dateOfBirth: json['dateOfBirth'] != null ? DateTime.parse(json['dateOfBirth']) : null,
      address: json['address'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      email: json['email'] ?? '',
      isCanadianCitizen: json['isCanadianCitizen'],
      maritalStatus: json['maritalStatus'] ?? '',
      spouseInfo: json['spouseInfo'] != null ? T1SpouseInfo.fromJson(json['spouseInfo']) : null,
      children: (json['children'] as List? ?? []).map((e) => T1ChildInfo.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'sin': sin,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'address': address,
      'phoneNumber': phoneNumber,
      'email': email,
      'isCanadianCitizen': isCanadianCitizen,
      'maritalStatus': maritalStatus,
      'spouseInfo': spouseInfo?.toJson(),
      'children': children.map((e) => e.toJson()).toList(),
    };
  }

  T1PersonalInfo copyWith({
    String? firstName,
    String? middleName,
    String? lastName,
    String? sin,
    DateTime? dateOfBirth,
    String? address,
    String? phoneNumber,
    String? email,
    bool? isCanadianCitizen,
    String? maritalStatus,
    T1SpouseInfo? spouseInfo,
    List<T1ChildInfo>? children,
  }) {
    return T1PersonalInfo(
      firstName: firstName ?? this.firstName,
      middleName: middleName ?? this.middleName,
      lastName: lastName ?? this.lastName,
      sin: sin ?? this.sin,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      isCanadianCitizen: isCanadianCitizen ?? this.isCanadianCitizen,
      maritalStatus: maritalStatus ?? this.maritalStatus,
      spouseInfo: spouseInfo ?? this.spouseInfo,
      children: children ?? this.children,
    );
  }
}

class T1SpouseInfo {
  final String firstName;
  final String? middleName;
  final String lastName;
  final String sin;
  final DateTime? dateOfBirth;

  const T1SpouseInfo({
    this.firstName = '',
    this.middleName,
    this.lastName = '',
    this.sin = '',
    this.dateOfBirth,
  });

  factory T1SpouseInfo.fromJson(Map<String, dynamic> json) {
    return T1SpouseInfo(
      firstName: json['firstName'] ?? '',
      middleName: json['middleName'],
      lastName: json['lastName'] ?? '',
      sin: json['sin'] ?? '',
      dateOfBirth: json['dateOfBirth'] != null ? DateTime.parse(json['dateOfBirth']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'sin': sin,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
    };
  }

  T1SpouseInfo copyWith({
    String? firstName,
    String? middleName,
    String? lastName,
    String? sin,
    DateTime? dateOfBirth,
  }) {
    return T1SpouseInfo(
      firstName: firstName ?? this.firstName,
      middleName: middleName ?? this.middleName,
      lastName: lastName ?? this.lastName,
      sin: sin ?? this.sin,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
    );
  }
}

class T1ChildInfo {
  final String firstName;
  final String? middleName;
  final String lastName;
  final String sin;
  final DateTime? dateOfBirth;

  const T1ChildInfo({
    this.firstName = '',
    this.middleName,
    this.lastName = '',
    this.sin = '',
    this.dateOfBirth,
  });

  factory T1ChildInfo.fromJson(Map<String, dynamic> json) {
    return T1ChildInfo(
      firstName: json['firstName'] ?? '',
      middleName: json['middleName'],
      lastName: json['lastName'] ?? '',
      sin: json['sin'] ?? '',
      dateOfBirth: json['dateOfBirth'] != null ? DateTime.parse(json['dateOfBirth']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'sin': sin,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
    };
  }

  T1ChildInfo copyWith({
    String? firstName,
    String? middleName,
    String? lastName,
    String? sin,
    DateTime? dateOfBirth,
  }) {
    return T1ChildInfo(
      firstName: firstName ?? this.firstName,
      middleName: middleName ?? this.middleName,
      lastName: lastName ?? this.lastName,
      sin: sin ?? this.sin,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
    );
  }
}

// Simplified classes for questionnaire sections
class T1ForeignProperty {
  final String investmentDetails;
  final double grossIncome;
  final double gainLossOnSale;
  final double maxCostDuringYear;
  final double costAmountYearEnd;
  final String country;

  const T1ForeignProperty({
    this.investmentDetails = '',
    this.grossIncome = 0.0,
    this.gainLossOnSale = 0.0,
    this.maxCostDuringYear = 0.0,
    this.costAmountYearEnd = 0.0,
    this.country = '',
  });

  factory T1ForeignProperty.fromJson(Map<String, dynamic> json) {
    return T1ForeignProperty(
      investmentDetails: json['investmentDetails'] ?? '',
      grossIncome: (json['grossIncome'] ?? 0.0).toDouble(),
      gainLossOnSale: (json['gainLossOnSale'] ?? 0.0).toDouble(),
      maxCostDuringYear: (json['maxCostDuringYear'] ?? 0.0).toDouble(),
      costAmountYearEnd: (json['costAmountYearEnd'] ?? 0.0).toDouble(),
      country: json['country'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'investmentDetails': investmentDetails,
      'grossIncome': grossIncome,
      'gainLossOnSale': gainLossOnSale,
      'maxCostDuringYear': maxCostDuringYear,
      'costAmountYearEnd': costAmountYearEnd,
      'country': country,
    };
  }
}

class T1SelfEmployment {
  final String businessType; // 'uber', 'general', 'rental'

  const T1SelfEmployment({
    this.businessType = '',
  });

  factory T1SelfEmployment.fromJson(Map<String, dynamic> json) {
    return T1SelfEmployment(
      businessType: json['businessType'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'businessType': businessType,
    };
  }
}

// Main form data class
class T1FormData {
  final T1PersonalInfo personalInfo;
  final bool? hasForeignProperty;
  final List<T1ForeignProperty> foreignProperties;
  final bool? hasMedicalExpenses;
  final bool? hasCharitableDonations;
  final bool? hasMovingExpenses;
  final bool? isSelfEmployed;
  final T1SelfEmployment? selfEmployment;
  final bool? isFirstHomeBuyer;
  final bool? soldPropertyLongTerm;
  final bool? soldPropertyShortTerm;
  final bool? hasWorkFromHomeExpense;
  final bool? wasStudentLastYear;
  final bool? isUnionMember;
  final bool? hasDaycareExpenses;
  final bool? isFirstTimeFiler;
  final bool? hasOtherIncome;
  final String otherIncomeDescription;
  final bool? hasProfessionalDues;
  final bool? hasRrspFhsaInvestment;
  final bool? hasChildArtSportCredit;
  final bool? isProvinceFiler;

  const T1FormData({
    this.personalInfo = const T1PersonalInfo(),
    this.hasForeignProperty,
    this.foreignProperties = const [],
    this.hasMedicalExpenses,
    this.hasCharitableDonations,
    this.hasMovingExpenses,
    this.isSelfEmployed,
    this.selfEmployment,
    this.isFirstHomeBuyer,
    this.soldPropertyLongTerm,
    this.soldPropertyShortTerm,
    this.hasWorkFromHomeExpense,
    this.wasStudentLastYear,
    this.isUnionMember,
    this.hasDaycareExpenses,
    this.isFirstTimeFiler,
    this.hasOtherIncome,
    this.otherIncomeDescription = '',
    this.hasProfessionalDues,
    this.hasRrspFhsaInvestment,
    this.hasChildArtSportCredit,
    this.isProvinceFiler,
  });

  factory T1FormData.fromJson(Map<String, dynamic> json) {
    return T1FormData(
      personalInfo: json['personalInfo'] != null 
          ? T1PersonalInfo.fromJson(json['personalInfo']) 
          : const T1PersonalInfo(),
      hasForeignProperty: json['hasForeignProperty'],
      foreignProperties: (json['foreignProperties'] as List? ?? [])
          .map((e) => T1ForeignProperty.fromJson(e))
          .toList(),
      hasMedicalExpenses: json['hasMedicalExpenses'],
      hasCharitableDonations: json['hasCharitableDonations'],
      hasMovingExpenses: json['hasMovingExpenses'],
      isSelfEmployed: json['isSelfEmployed'],
      selfEmployment: json['selfEmployment'] != null 
          ? T1SelfEmployment.fromJson(json['selfEmployment'])
          : null,
      isFirstHomeBuyer: json['isFirstHomeBuyer'],
      soldPropertyLongTerm: json['soldPropertyLongTerm'],
      soldPropertyShortTerm: json['soldPropertyShortTerm'],
      hasWorkFromHomeExpense: json['hasWorkFromHomeExpense'],
      wasStudentLastYear: json['wasStudentLastYear'],
      isUnionMember: json['isUnionMember'],
      hasDaycareExpenses: json['hasDaycareExpenses'],
      isFirstTimeFiler: json['isFirstTimeFiler'],
      hasOtherIncome: json['hasOtherIncome'],
      otherIncomeDescription: json['otherIncomeDescription'] ?? '',
      hasProfessionalDues: json['hasProfessionalDues'],
      hasRrspFhsaInvestment: json['hasRrspFhsaInvestment'],
      hasChildArtSportCredit: json['hasChildArtSportCredit'],
      isProvinceFiler: json['isProvinceFiler'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'personalInfo': personalInfo.toJson(),
      'hasForeignProperty': hasForeignProperty,
      'foreignProperties': foreignProperties.map((e) => e.toJson()).toList(),
      'hasMedicalExpenses': hasMedicalExpenses,
      'hasCharitableDonations': hasCharitableDonations,
      'hasMovingExpenses': hasMovingExpenses,
      'isSelfEmployed': isSelfEmployed,
      'selfEmployment': selfEmployment?.toJson(),
      'isFirstHomeBuyer': isFirstHomeBuyer,
      'soldPropertyLongTerm': soldPropertyLongTerm,
      'soldPropertyShortTerm': soldPropertyShortTerm,
      'hasWorkFromHomeExpense': hasWorkFromHomeExpense,
      'wasStudentLastYear': wasStudentLastYear,
      'isUnionMember': isUnionMember,
      'hasDaycareExpenses': hasDaycareExpenses,
      'isFirstTimeFiler': isFirstTimeFiler,
      'hasOtherIncome': hasOtherIncome,
      'otherIncomeDescription': otherIncomeDescription,
      'hasProfessionalDues': hasProfessionalDues,
      'hasRrspFhsaInvestment': hasRrspFhsaInvestment,
      'hasChildArtSportCredit': hasChildArtSportCredit,
      'isProvinceFiler': isProvinceFiler,
    };
  }

  T1FormData copyWith({
    T1PersonalInfo? personalInfo,
    bool? hasForeignProperty,
    List<T1ForeignProperty>? foreignProperties,
    bool? hasMedicalExpenses,
    bool? hasCharitableDonations,
    bool? hasMovingExpenses,
    bool? isSelfEmployed,
    T1SelfEmployment? selfEmployment,
    bool? isFirstHomeBuyer,
    bool? soldPropertyLongTerm,
    bool? soldPropertyShortTerm,
    bool? hasWorkFromHomeExpense,
    bool? wasStudentLastYear,
    bool? isUnionMember,
    bool? hasDaycareExpenses,
    bool? isFirstTimeFiler,
    bool? hasOtherIncome,
    String? otherIncomeDescription,
    bool? hasProfessionalDues,
    bool? hasRrspFhsaInvestment,
    bool? hasChildArtSportCredit,
    bool? isProvinceFiler,
  }) {
    return T1FormData(
      personalInfo: personalInfo ?? this.personalInfo,
      hasForeignProperty: hasForeignProperty ?? this.hasForeignProperty,
      foreignProperties: foreignProperties ?? this.foreignProperties,
      hasMedicalExpenses: hasMedicalExpenses ?? this.hasMedicalExpenses,
      hasCharitableDonations: hasCharitableDonations ?? this.hasCharitableDonations,
      hasMovingExpenses: hasMovingExpenses ?? this.hasMovingExpenses,
      isSelfEmployed: isSelfEmployed ?? this.isSelfEmployed,
      selfEmployment: selfEmployment ?? this.selfEmployment,
      isFirstHomeBuyer: isFirstHomeBuyer ?? this.isFirstHomeBuyer,
      soldPropertyLongTerm: soldPropertyLongTerm ?? this.soldPropertyLongTerm,
      soldPropertyShortTerm: soldPropertyShortTerm ?? this.soldPropertyShortTerm,
      hasWorkFromHomeExpense: hasWorkFromHomeExpense ?? this.hasWorkFromHomeExpense,
      wasStudentLastYear: wasStudentLastYear ?? this.wasStudentLastYear,
      isUnionMember: isUnionMember ?? this.isUnionMember,
      hasDaycareExpenses: hasDaycareExpenses ?? this.hasDaycareExpenses,
      isFirstTimeFiler: isFirstTimeFiler ?? this.isFirstTimeFiler,
      hasOtherIncome: hasOtherIncome ?? this.hasOtherIncome,
      otherIncomeDescription: otherIncomeDescription ?? this.otherIncomeDescription,
      hasProfessionalDues: hasProfessionalDues ?? this.hasProfessionalDues,
      hasRrspFhsaInvestment: hasRrspFhsaInvestment ?? this.hasRrspFhsaInvestment,
      hasChildArtSportCredit: hasChildArtSportCredit ?? this.hasChildArtSportCredit,
      isProvinceFiler: isProvinceFiler ?? this.isProvinceFiler,
    );
  }
}