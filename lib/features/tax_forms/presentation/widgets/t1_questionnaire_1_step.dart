import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/utils/smooth_scroll_physics.dart';
import '../../../../core/utils/responsive.dart';
import '../../data/models/t1_form_models_simple.dart';

class T1Questionnaire1Step extends StatefulWidget {
  final T1FormData formData;
  final Function(T1FormData) onFormDataChanged;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  /// Label to use when there are no additional steps (i.e. the questionnaire is the last step).
  /// Defaults to "Submit Form".
  final String finalActionLabel;

  const T1Questionnaire1Step({
    super.key,
    required this.formData,
    required this.onFormDataChanged,
    required this.onPrevious,
    required this.onNext,
    this.finalActionLabel = 'Submit Form',
  });

  @override
  State<T1Questionnaire1Step> createState() => _T1Questionnaire1StepState();
}

class _T1Questionnaire1StepState extends State<T1Questionnaire1Step> {
  late T1FormData _formData;

  // Local UI state for dynamic tables and date fields
  final List<int> _foreignPropertyRowIds = [];
  int _foreignPropertyRowCounter = 0;

  final List<int> _medicalExpenseRowIds = [];
  int _medicalExpenseRowCounter = 0;

  final List<int> _charitableDonationRowIds = [];
  int _charitableDonationRowCounter = 0;

  final List<int> _unionDueRowIds = [];
  int _unionDueRowCounter = 0;

  final List<int> _daycareExpenseRowIds = [];
  int _daycareExpenseRowCounter = 0;

  final List<int> _professionalDueRowIds = [];
  int _professionalDueRowCounter = 0;

  final List<int> _childArtSportRowIds = [];
  int _childArtSportRowCounter = 0;

  final List<int> _provinceFilerRowIds = [];
  int _provinceFilerRowCounter = 0;

  DateTime? _firstTimeFilerLandingDate;
  DateTime? _firstTimeFilerLandingDateSpouse;

  bool _showWorkFromHomeSpouse = false;
  bool _includeFirstTimeFilerSpouse = false;

  @override
  void initState() {
    super.initState();
    _formData = widget.formData;
    _syncUiFromFormData();
  }

  @override
  void didUpdateWidget(T1Questionnaire1Step oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.formData != widget.formData) {
      _formData = widget.formData;
      _syncUiFromFormData();
    }
  }

  void _updateFormData(T1FormData newData) {
    setState(() {
      _formData = newData;
    });
    widget.onFormDataChanged(_formData);
  }

  void _syncUiFromFormData() {
    _foreignPropertyRowIds
      ..clear()
      ..addAll(List<int>.generate(_formData.foreignProperties.length,
          (index) => index));
    _foreignPropertyRowCounter = _foreignPropertyRowIds.length;

    _medicalExpenseRowIds
      ..clear()
      ..addAll(List<int>.generate(_formData.medicalExpenses.length,
          (index) => index));
    _medicalExpenseRowCounter = _medicalExpenseRowIds.length;

    _charitableDonationRowIds
      ..clear()
      ..addAll(List<int>.generate(_formData.charitableDonations.length,
          (index) => index));
    _charitableDonationRowCounter = _charitableDonationRowIds.length;

    _unionDueRowIds
      ..clear()
      ..addAll(List<int>.generate(_formData.unionDues.length,
          (index) => index));
    _unionDueRowCounter = _unionDueRowIds.length;

    _daycareExpenseRowIds
      ..clear()
      ..addAll(List<int>.generate(_formData.daycareExpenses.length,
          (index) => index));
    _daycareExpenseRowCounter = _daycareExpenseRowIds.length;

    _professionalDueRowIds
      ..clear()
      ..addAll(List<int>.generate(_formData.professionalDues.length,
          (index) => index));
    _professionalDueRowCounter = _professionalDueRowIds.length;

    _childArtSportRowIds
      ..clear()
      ..addAll(List<int>.generate(_formData.childArtSportEntries.length,
          (index) => index));
    _childArtSportRowCounter = _childArtSportRowIds.length;

    _provinceFilerRowIds
      ..clear()
      ..addAll(List<int>.generate(_formData.provinceFilerEntries.length,
          (index) => index));
    _provinceFilerRowCounter = _provinceFilerRowIds.length;

    _firstTimeFilerLandingDate =
        _formData.firstTimeFilerIndividual?.dateOfLanding;
    _firstTimeFilerLandingDateSpouse =
        _formData.firstTimeFilerSpouse?.dateOfLanding;

    _showWorkFromHomeSpouse = _formData.workFromHomeSpouse != null;
    _includeFirstTimeFilerSpouse =
        _formData.firstTimeFilerSpouse != null;
  }

  // Helpers for dynamic rows
  void _addForeignPropertyRow() {
    final updated = List<T1ForeignProperty>.from(_formData.foreignProperties)
      ..add(const T1ForeignProperty());
    _foreignPropertyRowIds.add(_foreignPropertyRowCounter++);
    _updateFormData(_formData.copyWith(foreignProperties: updated));
  }

  void _removeForeignPropertyRow(int id) {
    final index = _foreignPropertyRowIds.indexOf(id);
    if (index < 0) return;
    final updated = List<T1ForeignProperty>.from(_formData.foreignProperties)
      ..removeAt(index);
    _foreignPropertyRowIds.removeAt(index);
    _updateFormData(_formData.copyWith(foreignProperties: updated));
  }

  void _addMedicalExpenseRow() {
    final updated = List<T1MedicalExpense>.from(_formData.medicalExpenses)
      ..add(const T1MedicalExpense());
    _medicalExpenseRowIds.add(_medicalExpenseRowCounter++);
    _updateFormData(_formData.copyWith(medicalExpenses: updated));
  }

  void _removeMedicalExpenseRow(int id) {
    final index = _medicalExpenseRowIds.indexOf(id);
    if (index < 0) return;
    final updated = List<T1MedicalExpense>.from(_formData.medicalExpenses)
      ..removeAt(index);
    _medicalExpenseRowIds.removeAt(index);
    _updateFormData(_formData.copyWith(medicalExpenses: updated));
  }

  void _addCharitableDonationRow() {
    final updated =
        List<T1CharitableDonation>.from(_formData.charitableDonations)
          ..add(const T1CharitableDonation());
    if (_charitableDonationRowIds.isEmpty && updated.isNotEmpty) {
      _charitableDonationRowIds.add(0);
      _charitableDonationRowCounter = 1;
    }
    _charitableDonationRowIds.add(_charitableDonationRowCounter++);
    _updateFormData(
        _formData.copyWith(charitableDonations: updated));
  }

  void _removeCharitableDonationRow(int id) {
    final index = _charitableDonationRowIds.indexOf(id);
    if (index < 0) return;
    final updated =
        List<T1CharitableDonation>.from(_formData.charitableDonations)
          ..removeAt(index);
    _charitableDonationRowIds.removeAt(index);
    _updateFormData(
        _formData.copyWith(charitableDonations: updated));
  }

  void _addUnionDueRow() {
    final updated = List<T1UnionDue>.from(_formData.unionDues)
      ..add(const T1UnionDue());
    if (_unionDueRowIds.isEmpty && updated.isNotEmpty) {
      _unionDueRowIds.add(0);
      _unionDueRowCounter = 1;
    }
    _unionDueRowIds.add(_unionDueRowCounter++);
    _updateFormData(_formData.copyWith(unionDues: updated));
  }

  void _removeUnionDueRow(int id) {
    final index = _unionDueRowIds.indexOf(id);
    if (index < 0) return;
    final updated = List<T1UnionDue>.from(_formData.unionDues)
      ..removeAt(index);
    _unionDueRowIds.removeAt(index);
    _updateFormData(_formData.copyWith(unionDues: updated));
  }

  void _addDaycareExpenseRow() {
    final updated =
        List<T1DaycareExpense>.from(_formData.daycareExpenses)
          ..add(const T1DaycareExpense());
    if (_daycareExpenseRowIds.isEmpty && updated.isNotEmpty) {
      _daycareExpenseRowIds.add(0);
      _daycareExpenseRowCounter = 1;
    }
    _daycareExpenseRowIds.add(_daycareExpenseRowCounter++);
    _updateFormData(_formData.copyWith(daycareExpenses: updated));
  }

  void _removeDaycareExpenseRow(int id) {
    final index = _daycareExpenseRowIds.indexOf(id);
    if (index < 0) return;
    final updated =
        List<T1DaycareExpense>.from(_formData.daycareExpenses)
          ..removeAt(index);
    _daycareExpenseRowIds.removeAt(index);
    _updateFormData(_formData.copyWith(daycareExpenses: updated));
  }

  void _addProfessionalDueRow() {
    final updated =
        List<T1ProfessionalDue>.from(_formData.professionalDues)
          ..add(const T1ProfessionalDue());
    if (_professionalDueRowIds.isEmpty && updated.isNotEmpty) {
      _professionalDueRowIds.add(0);
      _professionalDueRowCounter = 1;
    }
    _professionalDueRowIds.add(_professionalDueRowCounter++);
    _updateFormData(
        _formData.copyWith(professionalDues: updated));
  }

  void _removeProfessionalDueRow(int id) {
    final index = _professionalDueRowIds.indexOf(id);
    if (index < 0) return;
    final updated =
        List<T1ProfessionalDue>.from(_formData.professionalDues)
          ..removeAt(index);
    _professionalDueRowIds.removeAt(index);
    _updateFormData(
        _formData.copyWith(professionalDues: updated));
  }

  void _addChildArtSportRow() {
    final updated =
        List<T1ChildArtSportEntry>.from(_formData.childArtSportEntries)
          ..add(const T1ChildArtSportEntry());
    if (_childArtSportRowIds.isEmpty && updated.isNotEmpty) {
      _childArtSportRowIds.add(0);
      _childArtSportRowCounter = 1;
    }
    _childArtSportRowIds.add(_childArtSportRowCounter++);
    _updateFormData(
        _formData.copyWith(childArtSportEntries: updated));
  }

  void _removeChildArtSportRow(int id) {
    final index = _childArtSportRowIds.indexOf(id);
    if (index < 0) return;
    final updated =
        List<T1ChildArtSportEntry>.from(_formData.childArtSportEntries)
          ..removeAt(index);
    _childArtSportRowIds.removeAt(index);
    _updateFormData(
        _formData.copyWith(childArtSportEntries: updated));
  }

  void _addProvinceFilerRow() {
    final updated =
        List<T1ProvinceFilerEntry>.from(_formData.provinceFilerEntries)
          ..add(const T1ProvinceFilerEntry());
    if (_provinceFilerRowIds.isEmpty && updated.isNotEmpty) {
      _provinceFilerRowIds.add(0);
      _provinceFilerRowCounter = 1;
    }
    _provinceFilerRowIds.add(_provinceFilerRowCounter++);
    _updateFormData(
        _formData.copyWith(provinceFilerEntries: updated));
  }

  void _removeProvinceFilerRow(int id) {
    final index = _provinceFilerRowIds.indexOf(id);
    if (index < 0) return;
    final updated =
        List<T1ProvinceFilerEntry>.from(_formData.provinceFilerEntries)
          ..removeAt(index);
    _provinceFilerRowIds.removeAt(index);
    _updateFormData(
        _formData.copyWith(provinceFilerEntries: updated));
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveContainer(
      padding: EdgeInsets.all(Responsive.responsive(
        context: context,
        mobile: AppDimensions.spacingMd,
        tablet: AppDimensions.spacingLg,
        desktop: AppDimensions.spacingXl,
      )),
      child: SingleChildScrollView(
        physics: const SmoothBouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildHeader(),
            const SizedBox(height: 24),

            // Questions 1-3 (Unchanged)
            _buildForeignPropertySection(),
            const SizedBox(height: 16),

            _buildMedicalExpensesSection(),
            const SizedBox(height: 16),

            _buildCharitableDonationsSection(),
            const SizedBox(height: 16),

            // Question 4: Moving Expenses (Simplified - Only Yes/No)
            _buildMovingExpensesSection(),
            const SizedBox(height: 16),

            // Question 5: Self Employment (Simplified - Yes/No + Checkboxes)
            _buildSelfEmploymentSection(),
            const SizedBox(height: 24),

            // Questions 6-18 continue...
            _buildFirstHomeBuyerSection(),
            const SizedBox(height: 16),

            _buildPropertySaleLongTermSection(),
            const SizedBox(height: 16),

            _buildPropertySaleShortTermSection(),
            const SizedBox(height: 16),

            _buildWorkFromHomeSection(),
            const SizedBox(height: 16),

            _buildStudentSection(),
            const SizedBox(height: 16),

            _buildUnionMemberSection(),
            const SizedBox(height: 16),

            _buildDaycareExpensesSection(),
            const SizedBox(height: 16),

            _buildFirstTimeFilerSection(),
            const SizedBox(height: 16),

            _buildOtherIncomeSection(),
            const SizedBox(height: 16),

            _buildProfessionalDuesSection(),
            const SizedBox(height: 16),

            _buildRrspFhsaSection(),
            const SizedBox(height: 16),

            _buildChildArtSportSection(),
            const SizedBox(height: 16),

            _buildProvinceFilerSection(),
            const SizedBox(height: 16),

            _buildDisabilityTaxCreditSection(),
            const SizedBox(height: 16),

            _buildDeceasedReturnQuestionSection(),
            const SizedBox(height: 32),

            // Navigation Buttons
            _buildNavigationButtons(),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.spacingMd),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Questionnaire',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            'Please answer the following questions. Detailed information will be collected in additional steps if applicable.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.grey600,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.spacingMd),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildRadioQuestion({
    required String question,
    required bool? value,
    required Function(bool?) onChanged,
    Widget? conditionalWidget,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (question.isNotEmpty) ...[
          Text(
            question,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
        ],
        Row(
          children: [
            Radio<bool>(
              value: true,
              groupValue: value,
              onChanged: onChanged,
            ),
            const Text('Yes'),
            const SizedBox(width: 24),
            Radio<bool>(
              value: false,
              groupValue: value,
              onChanged: onChanged,
            ),
            const Text('No'),
          ],
        ),
        if (conditionalWidget != null && value == true) ...[
          const SizedBox(height: 16),
          conditionalWidget,
        ],
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    String? initialValue,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    int? maxLines,
    required Function(String) onChanged,
  }) {
    return TextFormField(
      initialValue: initialValue,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      maxLines: maxLines,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    DateTime? date,
    required Function(DateTime?) onChanged,
  }) {
    return InkWell(
      onTap: () async {
        final pickedDate = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime(2030),
        );
        onChanged(pickedDate);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          ),
        ),
        child: Text(
          date != null ? '${date.day}/${date.month}/${date.year}' : 'Select Date',
          style: date != null ? null : TextStyle(color: AppColors.grey500),
        ),
      ),
    );
  }

  Widget _buildForeignPropertySection() {
    return _buildSection(
      title: '1. Did taxpayer own specified foreign property at any time in 2023 with a total cost of more than CAN\$100,000?',
      child: _buildRadioQuestion(
        question: '',
        value: _formData.hasForeignProperty,
        onChanged: (value) {
          _updateFormData(_formData.copyWith(hasForeignProperty: value));
        },
        conditionalWidget: _formData.hasForeignProperty == true
            ? _buildForeignPropertyTable()
            : null,
      ),
    );
  }

  Widget _buildForeignPropertyTable() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Foreign Property Details',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        if (_formData.foreignProperties.isEmpty)
          _buildForeignPropertyRow(0)
        else
          ..._foreignPropertyRowIds.map(_buildForeignPropertyRow),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: _addForeignPropertyRow,
          icon: const Icon(Icons.add),
          label: const Text('Add Row'),
        ),
      ],
    );
  }

  Widget _buildForeignPropertyRow(int id) {
    final index = _foreignPropertyRowIds.isEmpty
        ? 0
        : _foreignPropertyRowIds.indexOf(id);
    final props = _formData.foreignProperties;
    final current = (index >= 0 && index < props.length)
        ? props[index]
        : const T1ForeignProperty();
    return Container(
      key: ValueKey('foreign_property_$id'),
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Theme.of(context).colorScheme.surface.withOpacity(0.7)
            : AppColors.grey50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Property ${index + 1}',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              if (_foreignPropertyRowIds.length > 1)
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _removeForeignPropertyRow(id),
                ),
            ],
          ),
          const SizedBox(height: 12),
          _buildTextField(
            label: 'Investment Details',
            initialValue: current.investmentDetails,
            onChanged: (value) {
              final updated = List<T1ForeignProperty>.from(props);
              if (index >= updated.length) {
                updated.add(current.copyWith(investmentDetails: value));
              } else {
                updated[index] =
                    current.copyWith(investmentDetails: value);
              }
              _updateFormData(
                  _formData.copyWith(foreignProperties: updated));
            },
          ),
          const SizedBox(height: 12),
          _buildTextField(
            label: 'Gross Income',
            keyboardType: TextInputType.number,
            initialValue: current.grossIncome == 0.0
                ? ''
                : current.grossIncome.toString(),
            onChanged: (value) {
              final parsed = double.tryParse(value) ?? 0.0;
              final updated = List<T1ForeignProperty>.from(props);
              updated[index] = current.copyWith(grossIncome: parsed);
              _updateFormData(
                  _formData.copyWith(foreignProperties: updated));
            },
          ),
          const SizedBox(height: 12),
          _buildTextField(
            label: 'Gain/Loss on sale',
            keyboardType: TextInputType.number,
            initialValue: current.gainLossOnSale == 0.0
                ? ''
                : current.gainLossOnSale.toString(),
            onChanged: (value) {
              final parsed = double.tryParse(value) ?? 0.0;
              final updated = List<T1ForeignProperty>.from(props);
              updated[index] = current.copyWith(gainLossOnSale: parsed);
              _updateFormData(
                  _formData.copyWith(foreignProperties: updated));
            },
          ),
          const SizedBox(height: 12),
          _buildTextField(
            label: 'Maximum Cost during the year',
            keyboardType: TextInputType.number,
            initialValue: current.maxCostDuringYear == 0.0
                ? ''
                : current.maxCostDuringYear.toString(),
            onChanged: (value) {
              final parsed = double.tryParse(value) ?? 0.0;
              final updated = List<T1ForeignProperty>.from(props);
              updated[index] =
                  current.copyWith(maxCostDuringYear: parsed);
              _updateFormData(
                  _formData.copyWith(foreignProperties: updated));
            },
          ),
          const SizedBox(height: 12),
          _buildTextField(
            label: 'Cost amount at the year end',
            keyboardType: TextInputType.number,
            initialValue: current.costAmountYearEnd == 0.0
                ? ''
                : current.costAmountYearEnd.toString(),
            onChanged: (value) {
              final parsed = double.tryParse(value) ?? 0.0;
              final updated = List<T1ForeignProperty>.from(props);
              updated[index] =
                  current.copyWith(costAmountYearEnd: parsed);
              _updateFormData(
                  _formData.copyWith(foreignProperties: updated));
            },
          ),
          const SizedBox(height: 12),
          _buildTextField(
            label: 'Country',
            initialValue: current.country,
            onChanged: (value) {
              final updated = List<T1ForeignProperty>.from(props);
              updated[index] = current.copyWith(country: value);
              _updateFormData(
                  _formData.copyWith(foreignProperties: updated));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMedicalExpensesSection() {
    return _buildSection(
      title: '2. Do you have any Medical Expenses?',
      child: _buildRadioQuestion(
        question: '',
        value: _formData.hasMedicalExpenses,
        onChanged: (value) {
          _updateFormData(_formData.copyWith(hasMedicalExpenses: value));
        },
        conditionalWidget: _formData.hasMedicalExpenses == true
            ? _buildMedicalExpensesTable()
            : null,
      ),
    );
  }

  Widget _buildMedicalExpensesTable() {
    return Column(
      children: [
        if (_formData.medicalExpenses.isEmpty)
          _buildMedicalExpenseRow(0)
        else
          ..._medicalExpenseRowIds.map(_buildMedicalExpenseRow),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: _addMedicalExpenseRow,
          icon: const Icon(Icons.add),
          label: const Text('Add Row'),
        ),
      ],
    );
  }

  Widget _buildMedicalExpenseRow(int id) {
    final index = _medicalExpenseRowIds.isEmpty
        ? 0
        : _medicalExpenseRowIds.indexOf(id);
    final expenses = _formData.medicalExpenses;
    final current = (index >= 0 && index < expenses.length)
        ? expenses[index]
        : const T1MedicalExpense();
    final date = current.paymentDate;
    return Container(
      key: ValueKey('medical_expense_$id'),
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Theme.of(context).colorScheme.surface.withOpacity(0.7)
            : AppColors.grey50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Medical Expense ${index + 1}',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              if (_medicalExpenseRowIds.length > 1)
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _removeMedicalExpenseRow(id),
                ),
            ],
          ),
          const SizedBox(height: 12),
          _buildDateField(
            label: 'Payment Date',
            date: date,
            onChanged: (picked) {
              final updated = List<T1MedicalExpense>.from(expenses);
              if (index >= updated.length) {
                updated.add(current.copyWith(paymentDate: picked));
              } else {
                updated[index] = current.copyWith(paymentDate: picked);
              }
              _updateFormData(
                  _formData.copyWith(medicalExpenses: updated));
            },
          ),
          const SizedBox(height: 12),
          _buildTextField(
            label: 'Patient Name',
            initialValue: current.patientName,
            onChanged: (value) {
              final updated = List<T1MedicalExpense>.from(expenses);
              updated[index] = current.copyWith(patientName: value);
              _updateFormData(
                  _formData.copyWith(medicalExpenses: updated));
            },
          ),
          const SizedBox(height: 12),
          _buildTextField(
            label: 'PAYMENT MADE TO',
            initialValue: current.paymentMadeTo,
            onChanged: (value) {
              final updated = List<T1MedicalExpense>.from(expenses);
              updated[index] = current.copyWith(paymentMadeTo: value);
              _updateFormData(
                  _formData.copyWith(medicalExpenses: updated));
            },
          ),
          const SizedBox(height: 12),
          _buildTextField(
            label: 'DESCRIPTION OF EXPENSE',
            initialValue: current.descriptionOfExpense,
            onChanged: (value) {
              final updated = List<T1MedicalExpense>.from(expenses);
              updated[index] =
                  current.copyWith(descriptionOfExpense: value);
              _updateFormData(
                  _formData.copyWith(medicalExpenses: updated));
            },
          ),
          const SizedBox(height: 12),
          _buildTextField(
            label: 'INSURANCE COVERED',
            keyboardType: TextInputType.number,
            initialValue: current.insuranceCovered == 0.0
                ? ''
                : current.insuranceCovered.toString(),
            onChanged: (value) {
              final parsed = double.tryParse(value) ?? 0.0;
              final updated = List<T1MedicalExpense>.from(expenses);
              updated[index] =
                  current.copyWith(insuranceCovered: parsed);
              _updateFormData(
                  _formData.copyWith(medicalExpenses: updated));
            },
          ),
          const SizedBox(height: 12),
          _buildTextField(
            label: 'Amount Paid from Pocket',
            keyboardType: TextInputType.number,
            initialValue: current.amountPaidFromPocket == 0.0
                ? ''
                : current.amountPaidFromPocket.toString(),
            onChanged: (value) {
              final parsed = double.tryParse(value) ?? 0.0;
              final updated = List<T1MedicalExpense>.from(expenses);
              updated[index] =
                  current.copyWith(amountPaidFromPocket: parsed);
              _updateFormData(
                  _formData.copyWith(medicalExpenses: updated));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCharitableDonationsSection() {
    return _buildSection(
      title: '3. Do you have any Charitable Donations?',
      child: _buildRadioQuestion(
        question: '',
        value: _formData.hasCharitableDonations,
        onChanged: (value) {
          _updateFormData(_formData.copyWith(hasCharitableDonations: value));
        },
        conditionalWidget: _formData.hasCharitableDonations == true
            ? _buildCharitableDonationsTable()
            : null,
      ),
    );
  }

  Widget _buildCharitableDonationsTable() {
    return Column(
      children: [
        if (_formData.charitableDonations.isEmpty)
          _buildCharitableDonationRow(0)
        else
          ..._charitableDonationRowIds.map(_buildCharitableDonationRow),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: _addCharitableDonationRow,
          icon: const Icon(Icons.add),
          label: const Text('Add Row'),
        ),
      ],
    );
  }

  Widget _buildCharitableDonationRow(int id) {
    final index = _charitableDonationRowIds.isEmpty
        ? 0
        : _charitableDonationRowIds.indexOf(id);
    final rows = _formData.charitableDonations;
    final current = (index >= 0 && index < rows.length)
        ? rows[index]
        : const T1CharitableDonation();
    return Container(
      key: ValueKey('charitable_donation_$id'),
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Theme.of(context).colorScheme.surface.withOpacity(0.7)
            : AppColors.grey50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Donation ${index + 1}',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              if (_charitableDonationRowIds.length > 1)
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _removeCharitableDonationRow(id),
                ),
            ],
          ),
          const SizedBox(height: 12),
          _buildTextField(
            label: 'Organization Name',
            initialValue: current.organizationName,
            onChanged: (value) {
              final updated = List<T1CharitableDonation>.from(rows);
              final newRow = current.copyWith(organizationName: value);
              if (index >= updated.length) {
                updated.add(newRow);
                if (_charitableDonationRowIds.isEmpty) {
                  _charitableDonationRowIds.add(0);
                  _charitableDonationRowCounter = 1;
                }
              } else {
                updated[index] = newRow;
              }
              _updateFormData(
                  _formData.copyWith(charitableDonations: updated));
            },
          ),
          const SizedBox(height: 12),
          _buildTextField(
            label: 'Amount Paid',
            keyboardType: TextInputType.number,
            initialValue:
                current.amount == 0.0 ? '' : current.amount.toString(),
            onChanged: (value) {
              final parsed = double.tryParse(value) ?? 0.0;
              final updated = List<T1CharitableDonation>.from(rows);
              final newRow = current.copyWith(amount: parsed);
              if (index >= updated.length) {
                updated.add(newRow);
                if (_charitableDonationRowIds.isEmpty) {
                  _charitableDonationRowIds.add(0);
                  _charitableDonationRowCounter = 1;
                }
              } else {
                updated[index] = newRow;
              }
              _updateFormData(
                  _formData.copyWith(charitableDonations: updated));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMovingExpensesSection() {
    return _buildSection(
      title: '4. If your province or territory of residence changed in 2023, do you have any moving expenses?',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRadioQuestion(
            question: '',
            value: _formData.hasMovingExpenses,
            onChanged: (value) {
              _updateFormData(_formData.copyWith(hasMovingExpenses: value));
            },
          ),
          if (_formData.hasMovingExpenses == true) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.primary.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: AppColors.primary, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Detailed moving expense information will be collected in Questionnaire 2',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSelfEmploymentSection() {
    return _buildSection(
      title: '5. Are you Self Employed?',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRadioQuestion(
            question: '',
            value: _formData.isSelfEmployed,
            onChanged: (value) {
              _updateFormData(_formData.copyWith(
                isSelfEmployed: value,
                selfEmployment: value == true ? const T1SelfEmployment() : null,
              ));
            },
          ),
          if (_formData.isSelfEmployed == true) ...[
            const SizedBox(height: 16),
            Text(
              'Select all that apply:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            CheckboxListTile(
              title: const Text('Uber/Skip/DoorDash'),
              value: _formData.selfEmployment?.businessTypes.contains('uber') ?? false,
              onChanged: (value) {
                final currentTypes = List<String>.from(_formData.selfEmployment?.businessTypes ?? []);
                if (value == true) {
                  if (!currentTypes.contains('uber')) currentTypes.add('uber');
                } else {
                  currentTypes.remove('uber');
                }
                _updateFormData(_formData.copyWith(
                  selfEmployment: T1SelfEmployment(businessTypes: currentTypes),
                ));
              },
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
            ),
            CheckboxListTile(
              title: const Text('General Business'),
              value: _formData.selfEmployment?.businessTypes.contains('general') ?? false,
              onChanged: (value) {
                final currentTypes = List<String>.from(_formData.selfEmployment?.businessTypes ?? []);
                if (value == true) {
                  if (!currentTypes.contains('general')) currentTypes.add('general');
                } else {
                  currentTypes.remove('general');
                }
                _updateFormData(_formData.copyWith(
                  selfEmployment: T1SelfEmployment(businessTypes: currentTypes),
                ));
              },
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
            ),
            CheckboxListTile(
              title: const Text('Rental Income'),
              value: _formData.selfEmployment?.businessTypes.contains('rental') ?? false,
              onChanged: (value) {
                final currentTypes = List<String>.from(_formData.selfEmployment?.businessTypes ?? []);
                if (value == true) {
                  if (!currentTypes.contains('rental')) currentTypes.add('rental');
                } else {
                  currentTypes.remove('rental');
                }
                _updateFormData(_formData.copyWith(
                  selfEmployment: T1SelfEmployment(businessTypes: currentTypes),
                ));
              },
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.primary.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: AppColors.primary, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Detailed income and expense information will be collected in Questionnaire 2',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // Remaining sections (6-18) - With original sub-forms
  Widget _buildFirstHomeBuyerSection() {
    return _buildSection(
      title: '6. Did you buy your FIRST HOME in the Tax Year?',
      child: _buildRadioQuestion(
        question: '',
        value: _formData.isFirstHomeBuyer,
        onChanged: (value) {
          _updateFormData(_formData.copyWith(isFirstHomeBuyer: value));
        },
      ),
    );
  }

  Widget _buildPropertySaleLongTermSection() {
    return _buildSection(
      title: '7. Did you sell any Residential Property which you hold more than 365 days last year? How much capital gain you earned?',
      child: _buildRadioQuestion(
        question: '',
        value: _formData.soldPropertyLongTerm,
        onChanged: (value) {
          _updateFormData(_formData.copyWith(soldPropertyLongTerm: value));
        },
        conditionalWidget: _formData.soldPropertyLongTerm == true
            ? _buildPropertySaleDetails(isLongTerm: true)
            : null,
      ),
    );
  }

  Widget _buildPropertySaleShortTermSection() {
    return _buildSection(
      title: '8. Did you sell any Residential Property which you hold less than 365 days last year? FLIP PROPERTY',
      child: _buildRadioQuestion(
        question: '',
        value: _formData.soldPropertyShortTerm,
        onChanged: (value) {
          _updateFormData(_formData.copyWith(soldPropertyShortTerm: value));
        },
        conditionalWidget: _formData.soldPropertyShortTerm == true
            ? _buildPropertySaleDetails(isLongTerm: false)
            : null,
      ),
    );
  }

  Widget _buildPropertySaleDetails({required bool isLongTerm}) {
    final details = isLongTerm
        ? (_formData.propertySaleLongTerm ?? const T1PropertySaleDetails())
        : (_formData.propertySaleShortTerm ??
            const T1PropertySaleDetails(isLongTerm: false));
    final purchaseDate = details.purchaseDate;
    final sellDate = details.sellDate;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Theme.of(context).colorScheme.surface.withOpacity(0.7)
            : AppColors.grey50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        children: [
          _buildTextField(
            label: 'Property Address',
            initialValue: details.propertyAddress,
            onChanged: (value) {
              final updatedDetails = details.copyWith(propertyAddress: value);
              _updateFormData(_formData.copyWith(
                propertySaleLongTerm:
                    isLongTerm ? updatedDetails : _formData.propertySaleLongTerm,
                propertySaleShortTerm:
                    isLongTerm ? _formData.propertySaleShortTerm : updatedDetails,
              ));
            },
          ),
          const SizedBox(height: 12),
          _buildDateField(
            label: 'Purchase Date',
            date: purchaseDate,
            onChanged: (date) {
              final updatedDetails = details.copyWith(purchaseDate: date);
              _updateFormData(_formData.copyWith(
                propertySaleLongTerm:
                    isLongTerm ? updatedDetails : _formData.propertySaleLongTerm,
                propertySaleShortTerm:
                    isLongTerm ? _formData.propertySaleShortTerm : updatedDetails,
              ));
            },
          ),
          const SizedBox(height: 12),
          _buildDateField(
            label: 'Sell Date',
            date: sellDate,
            onChanged: (date) {
              final updatedDetails = details.copyWith(sellDate: date);
              _updateFormData(_formData.copyWith(
                propertySaleLongTerm:
                    isLongTerm ? updatedDetails : _formData.propertySaleLongTerm,
                propertySaleShortTerm:
                    isLongTerm ? _formData.propertySaleShortTerm : updatedDetails,
              ));
            },
          ),
          const SizedBox(height: 12),
          _buildTextField(
            label: 'Purchase & Sell Expenses',
            keyboardType: TextInputType.number,
            initialValue: details.purchaseSellExpenses == 0.0
                ? ''
                : details.purchaseSellExpenses.toString(),
            onChanged: (value) {
              final parsed = double.tryParse(value) ?? 0.0;
              final updatedDetails =
                  details.copyWith(purchaseSellExpenses: parsed);
              _updateFormData(_formData.copyWith(
                propertySaleLongTerm:
                    isLongTerm ? updatedDetails : _formData.propertySaleLongTerm,
                propertySaleShortTerm:
                    isLongTerm ? _formData.propertySaleShortTerm : updatedDetails,
              ));
            },
          ),
          if (isLongTerm) ...[
            const SizedBox(height: 12),
            _buildTextField(
              label: 'Capital Gain Earned',
              keyboardType: TextInputType.number,
              initialValue: details.capitalGainEarned == 0.0
                  ? ''
                  : details.capitalGainEarned.toString(),
              onChanged: (value) {
                final parsed = double.tryParse(value) ?? 0.0;
                final updatedDetails =
                    details.copyWith(capitalGainEarned: parsed);
                _updateFormData(_formData.copyWith(
                  propertySaleLongTerm:
                      isLongTerm ? updatedDetails : _formData.propertySaleLongTerm,
                  propertySaleShortTerm:
                      isLongTerm ? _formData.propertySaleShortTerm : updatedDetails,
                ));
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildWorkFromHomeSection() {
    return _buildSection(
      title: '9. Did you have any work from home expense in the Tax year? Detailed method, T2200 is required from your employer.',
      child: _buildRadioQuestion(
        question: '',
        value: _formData.hasWorkFromHomeExpense,
        onChanged: (value) {
          _updateFormData(_formData.copyWith(hasWorkFromHomeExpense: value));
        },
        conditionalWidget: _formData.hasWorkFromHomeExpense == true
            ? _buildWorkFromHomeDetails()
            : null,
      ),
    );
  }

  Widget _buildWorkFromHomeDetails() {
    final individual = _formData.workFromHomeIndividual ??
        const T1WorkFromHomeExpense(personType: 'individual');
    final spouse = _formData.workFromHomeSpouse ??
        const T1WorkFromHomeExpense(personType: 'spouse');

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Theme.of(context).colorScheme.surface.withOpacity(0.7)
            : AppColors.grey50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Individual',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 12),
          _buildTextField(
            label: 'Total House Area (Sq.Ft.)',
            keyboardType: TextInputType.number,
            initialValue: individual.totalHouseArea == 0.0
                ? ''
                : individual.totalHouseArea.toString(),
            onChanged: (value) {
              final parsed = double.tryParse(value) ?? 0.0;
              final updated = individual.copyWith(totalHouseArea: parsed);
              _updateFormData(_formData.copyWith(
                workFromHomeIndividual: updated,
              ));
            },
          ),
          const SizedBox(height: 12),
          _buildTextField(
            label: 'Total Work Area (Sq.Ft.)',
            keyboardType: TextInputType.number,
            initialValue: individual.totalWorkArea == 0.0
                ? ''
                : individual.totalWorkArea.toString(),
            onChanged: (value) {
              final parsed = double.tryParse(value) ?? 0.0;
              final updated = individual.copyWith(totalWorkArea: parsed);
              _updateFormData(_formData.copyWith(
                workFromHomeIndividual: updated,
              ));
            },
          ),
          const SizedBox(height: 12),
          _buildTextField(
            label: 'Rent Expense',
            keyboardType: TextInputType.number,
            initialValue: individual.rentExpense == 0.0
                ? ''
                : individual.rentExpense.toString(),
            onChanged: (value) {
              final parsed = double.tryParse(value) ?? 0.0;
              final updated = individual.copyWith(rentExpense: parsed);
              _updateFormData(_formData.copyWith(
                workFromHomeIndividual: updated,
              ));
            },
          ),
          const SizedBox(height: 12),
          _buildTextField(
            label: 'Mortgage Expense',
            keyboardType: TextInputType.number,
            initialValue: individual.mortgageExpense == 0.0
                ? ''
                : individual.mortgageExpense.toString(),
            onChanged: (value) {
              final parsed = double.tryParse(value) ?? 0.0;
              final updated =
                  individual.copyWith(mortgageExpense: parsed);
              _updateFormData(_formData.copyWith(
                workFromHomeIndividual: updated,
              ));
            },
          ),
          const SizedBox(height: 12),
          _buildTextField(
            label: 'Wifi Expense',
            keyboardType: TextInputType.number,
            initialValue: individual.wifiExpense == 0.0
                ? ''
                : individual.wifiExpense.toString(),
            onChanged: (value) {
              final parsed = double.tryParse(value) ?? 0.0;
              final updated = individual.copyWith(wifiExpense: parsed);
              _updateFormData(_formData.copyWith(
                workFromHomeIndividual: updated,
              ));
            },
          ),
          const SizedBox(height: 12),
          _buildTextField(
            label: 'Electricity Expense',
            keyboardType: TextInputType.number,
            initialValue: individual.electricityExpense == 0.0
                ? ''
                : individual.electricityExpense.toString(),
            onChanged: (value) {
              final parsed = double.tryParse(value) ?? 0.0;
              final updated =
                  individual.copyWith(electricityExpense: parsed);
              _updateFormData(_formData.copyWith(
                workFromHomeIndividual: updated,
              ));
            },
          ),
          const SizedBox(height: 12),
          _buildTextField(
            label: 'Water Expense',
            keyboardType: TextInputType.number,
            initialValue: individual.waterExpense == 0.0
                ? ''
                : individual.waterExpense.toString(),
            onChanged: (value) {
              final parsed = double.tryParse(value) ?? 0.0;
              final updated =
                  individual.copyWith(waterExpense: parsed);
              _updateFormData(_formData.copyWith(
                workFromHomeIndividual: updated,
              ));
            },
          ),
          const SizedBox(height: 12),
          _buildTextField(
            label: 'Heat Expense',
            keyboardType: TextInputType.number,
            initialValue: individual.heatExpense == 0.0
                ? ''
                : individual.heatExpense.toString(),
            onChanged: (value) {
              final parsed = double.tryParse(value) ?? 0.0;
              final updated = individual.copyWith(heatExpense: parsed);
              _updateFormData(_formData.copyWith(
                workFromHomeIndividual: updated,
              ));
            },
          ),
          const SizedBox(height: 12),
          _buildTextField(
            label: 'Total Insurance Expense',
            keyboardType: TextInputType.number,
            initialValue: individual.totalInsuranceExpense == 0.0
                ? ''
                : individual.totalInsuranceExpense.toString(),
            onChanged: (value) {
              final parsed = double.tryParse(value) ?? 0.0;
              final updated =
                  individual.copyWith(totalInsuranceExpense: parsed);
              _updateFormData(_formData.copyWith(
                workFromHomeIndividual: updated,
              ));
            },
          ),
          const SizedBox(height: 16),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            title: const Text('Spouse'),
            value: _showWorkFromHomeSpouse,
            onChanged: (val) {
              setState(() {
                _showWorkFromHomeSpouse = val ?? false;
              });
              if (val == true && _formData.workFromHomeSpouse == null) {
                _updateFormData(_formData.copyWith(
                  workFromHomeSpouse: const T1WorkFromHomeExpense(
                    personType: 'spouse',
                  ),
                ));
              }
            },
          ),
          if (_showWorkFromHomeSpouse) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Theme.of(context).colorScheme.surface.withOpacity(0.7)
                    : Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Theme.of(context).dividerColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Spouse',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    label: 'Total House Area (Sq.Ft.)',
                    keyboardType: TextInputType.number,
                    initialValue: spouse.totalHouseArea == 0.0
                        ? ''
                        : spouse.totalHouseArea.toString(),
                    onChanged: (value) {
                      final parsed = double.tryParse(value) ?? 0.0;
                      final updated =
                          spouse.copyWith(totalHouseArea: parsed);
                      _updateFormData(_formData.copyWith(
                        workFromHomeSpouse: updated,
                      ));
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    label: 'Total Work Area (Sq.Ft.)',
                    keyboardType: TextInputType.number,
                    initialValue: spouse.totalWorkArea == 0.0
                        ? ''
                        : spouse.totalWorkArea.toString(),
                    onChanged: (value) {
                      final parsed = double.tryParse(value) ?? 0.0;
                      final updated =
                          spouse.copyWith(totalWorkArea: parsed);
                      _updateFormData(_formData.copyWith(
                        workFromHomeSpouse: updated,
                      ));
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    label: 'Rent Expense',
                    keyboardType: TextInputType.number,
                    initialValue: spouse.rentExpense == 0.0
                        ? ''
                        : spouse.rentExpense.toString(),
                    onChanged: (value) {
                      final parsed = double.tryParse(value) ?? 0.0;
                      final updated = spouse.copyWith(rentExpense: parsed);
                      _updateFormData(_formData.copyWith(
                        workFromHomeSpouse: updated,
                      ));
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    label: 'Mortgage Expense',
                    keyboardType: TextInputType.number,
                    initialValue: spouse.mortgageExpense == 0.0
                        ? ''
                        : spouse.mortgageExpense.toString(),
                    onChanged: (value) {
                      final parsed = double.tryParse(value) ?? 0.0;
                      final updated =
                          spouse.copyWith(mortgageExpense: parsed);
                      _updateFormData(_formData.copyWith(
                        workFromHomeSpouse: updated,
                      ));
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    label: 'Wifi Expense',
                    keyboardType: TextInputType.number,
                    initialValue: spouse.wifiExpense == 0.0
                        ? ''
                        : spouse.wifiExpense.toString(),
                    onChanged: (value) {
                      final parsed = double.tryParse(value) ?? 0.0;
                      final updated =
                          spouse.copyWith(wifiExpense: parsed);
                      _updateFormData(_formData.copyWith(
                        workFromHomeSpouse: updated,
                      ));
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    label: 'Electricity Expense',
                    keyboardType: TextInputType.number,
                    initialValue: spouse.electricityExpense == 0.0
                        ? ''
                        : spouse.electricityExpense.toString(),
                    onChanged: (value) {
                      final parsed = double.tryParse(value) ?? 0.0;
                      final updated = spouse.copyWith(
                          electricityExpense: parsed);
                      _updateFormData(_formData.copyWith(
                        workFromHomeSpouse: updated,
                      ));
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    label: 'Water Expense',
                    keyboardType: TextInputType.number,
                    initialValue: spouse.waterExpense == 0.0
                        ? ''
                        : spouse.waterExpense.toString(),
                    onChanged: (value) {
                      final parsed = double.tryParse(value) ?? 0.0;
                      final updated =
                          spouse.copyWith(waterExpense: parsed);
                      _updateFormData(_formData.copyWith(
                        workFromHomeSpouse: updated,
                      ));
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    label: 'Heat Expense',
                    keyboardType: TextInputType.number,
                    initialValue: spouse.heatExpense == 0.0
                        ? ''
                        : spouse.heatExpense.toString(),
                    onChanged: (value) {
                      final parsed = double.tryParse(value) ?? 0.0;
                      final updated = spouse.copyWith(heatExpense: parsed);
                      _updateFormData(_formData.copyWith(
                        workFromHomeSpouse: updated,
                      ));
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    label: 'Total Insurance Expense',
                    keyboardType: TextInputType.number,
                    initialValue: spouse.totalInsuranceExpense == 0.0
                        ? ''
                        : spouse.totalInsuranceExpense.toString(),
                    onChanged: (value) {
                      final parsed = double.tryParse(value) ?? 0.0;
                      final updated = spouse.copyWith(
                          totalInsuranceExpense: parsed);
                      _updateFormData(_formData.copyWith(
                        workFromHomeSpouse: updated,
                      ));
                    },
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStudentSection() {
    return _buildSection(
      title: '10. Were you a student last year? If yes then we would need T2202A form from your educational institution.',
      child: _buildRadioQuestion(
        question: '',
        value: _formData.wasStudentLastYear,
        onChanged: (value) {
          _updateFormData(_formData.copyWith(wasStudentLastYear: value));
        },
      ),
    );
  }

  Widget _buildUnionMemberSection() {
    return _buildSection(
      title: '11. Are you a member of any union? If yes then, do you have any union dues?',
      child: _buildRadioQuestion(
        question: '',
        value: _formData.isUnionMember,
        onChanged: (value) {
          _updateFormData(_formData.copyWith(isUnionMember: value));
        },
        conditionalWidget: _formData.isUnionMember == true
            ? _buildUnionDuesTable()
            : null,
      ),
    );
  }

  Widget _buildUnionDuesTable() {
    return Column(
      children: [
        if (_formData.unionDues.isEmpty)
          _buildUnionDueRow(0)
        else
          ..._unionDueRowIds.map(_buildUnionDueRow),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: _addUnionDueRow,
          icon: const Icon(Icons.add),
          label: const Text('Add Row'),
        ),
      ],
    );
  }

  Widget _buildUnionDueRow(int id) {
    final index = _unionDueRowIds.isEmpty
        ? 0
        : _unionDueRowIds.indexOf(id);
    final rows = _formData.unionDues;
    final current = (index >= 0 && index < rows.length)
        ? rows[index]
        : const T1UnionDue();
    return Container(
      key: ValueKey('union_due_$id'),
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Theme.of(context).colorScheme.surface.withOpacity(0.7)
            : AppColors.grey50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Union Due ${index + 1}',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              if (_unionDueRowIds.length > 1)
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _removeUnionDueRow(id),
                ),
            ],
          ),
          const SizedBox(height: 12),
          _buildTextField(
            label: 'Institution Name',
            initialValue: current.institutionName,
            onChanged: (value) {
              final updated = List<T1UnionDue>.from(rows);
              final newRow = current.copyWith(institutionName: value);
              if (index >= updated.length) {
                updated.add(newRow);
                if (_unionDueRowIds.isEmpty) {
                  _unionDueRowIds.add(0);
                  _unionDueRowCounter = 1;
                }
              } else {
                updated[index] = newRow;
              }
              _updateFormData(_formData.copyWith(unionDues: updated));
            },
          ),
          const SizedBox(height: 12),
          _buildTextField(
            label: 'Amount',
            keyboardType: TextInputType.number,
            initialValue:
                current.amount == 0.0 ? '' : current.amount.toString(),
            onChanged: (value) {
              final parsed = double.tryParse(value) ?? 0.0;
              final updated = List<T1UnionDue>.from(rows);
              final newRow = current.copyWith(amount: parsed);
              if (index >= updated.length) {
                updated.add(newRow);
                if (_unionDueRowIds.isEmpty) {
                  _unionDueRowIds.add(0);
                  _unionDueRowCounter = 1;
                }
              } else {
                updated[index] = newRow;
              }
              _updateFormData(_formData.copyWith(unionDues: updated));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDaycareExpensesSection() {
    return _buildSection(
      title: '12. Do you have Day care expenses for your child?',
      child: _buildRadioQuestion(
        question: '',
        value: _formData.hasDaycareExpenses,
        onChanged: (value) {
          _updateFormData(_formData.copyWith(hasDaycareExpenses: value));
        },
        conditionalWidget: _formData.hasDaycareExpenses == true
            ? _buildDaycareExpensesTable()
            : null,
      ),
    );
  }

  Widget _buildDaycareExpensesTable() {
    return Column(
      children: [
        if (_formData.daycareExpenses.isEmpty)
          _buildDaycareExpenseRow(0)
        else
          ..._daycareExpenseRowIds.map(_buildDaycareExpenseRow),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: _addDaycareExpenseRow,
          icon: const Icon(Icons.add),
          label: const Text('Add Row'),
        ),
      ],
    );
  }

  Widget _buildDaycareExpenseRow(int id) {
    final index = _daycareExpenseRowIds.isEmpty
        ? 0
        : _daycareExpenseRowIds.indexOf(id);
    final rows = _formData.daycareExpenses;
    final current = (index >= 0 && index < rows.length)
        ? rows[index]
        : const T1DaycareExpense();
    return Container(
      key: ValueKey('daycare_expense_$id'),
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Theme.of(context).colorScheme.surface.withOpacity(0.7)
            : AppColors.grey50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Daycare Expense ${index + 1}',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              if (_daycareExpenseRowIds.length > 1)
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _removeDaycareExpenseRow(id),
                ),
            ],
          ),
          const SizedBox(height: 12),
          _buildTextField(
            label: 'Childcare Provider',
            initialValue: current.childcareProvider,
            onChanged: (value) {
              final updated = List<T1DaycareExpense>.from(rows);
              final newRow = current.copyWith(childcareProvider: value);
              if (index >= updated.length) {
                updated.add(newRow);
                if (_daycareExpenseRowIds.isEmpty) {
                  _daycareExpenseRowIds.add(0);
                  _daycareExpenseRowCounter = 1;
                }
              } else {
                updated[index] = newRow;
              }
              _updateFormData(
                  _formData.copyWith(daycareExpenses: updated));
            },
          ),
          const SizedBox(height: 12),
          _buildTextField(
            label: 'Amount',
            keyboardType: TextInputType.number,
            initialValue:
                current.amount == 0.0 ? '' : current.amount.toString(),
            onChanged: (value) {
              final parsed = double.tryParse(value) ?? 0.0;
              final updated = List<T1DaycareExpense>.from(rows);
              final newRow = current.copyWith(amount: parsed);
              if (index >= updated.length) {
                updated.add(newRow);
                if (_daycareExpenseRowIds.isEmpty) {
                  _daycareExpenseRowIds.add(0);
                  _daycareExpenseRowCounter = 1;
                }
              } else {
                updated[index] = newRow;
              }
              _updateFormData(
                  _formData.copyWith(daycareExpenses: updated));
            },
          ),
          const SizedBox(height: 12),
          _buildTextField(
            label: 'Identification Number/SIN',
            initialValue: current.identificationNumberSin,
            onChanged: (value) {
              final updated = List<T1DaycareExpense>.from(rows);
              final newRow =
                  current.copyWith(identificationNumberSin: value);
              if (index >= updated.length) {
                updated.add(newRow);
                if (_daycareExpenseRowIds.isEmpty) {
                  _daycareExpenseRowIds.add(0);
                  _daycareExpenseRowCounter = 1;
                }
              } else {
                updated[index] = newRow;
              }
              _updateFormData(
                  _formData.copyWith(daycareExpenses: updated));
            },
          ),
          const SizedBox(height: 12),
          _buildTextField(
            label: 'Weeks',
            keyboardType: TextInputType.number,
            initialValue:
                current.weeks == 0.0 ? '' : current.weeks.toString(),
            onChanged: (value) {
              final parsed = double.tryParse(value) ?? 0.0;
              final updated = List<T1DaycareExpense>.from(rows);
              final newRow = current.copyWith(weeks: parsed);
              if (index >= updated.length) {
                updated.add(newRow);
                if (_daycareExpenseRowIds.isEmpty) {
                  _daycareExpenseRowIds.add(0);
                  _daycareExpenseRowCounter = 1;
                }
              } else {
                updated[index] = newRow;
              }
              _updateFormData(
                  _formData.copyWith(daycareExpenses: updated));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFirstTimeFilerSection() {
    return _buildSection(
      title: '13. Are you a first time filer? If Yes, then please provide the following details.',
      child: _buildRadioQuestion(
        question: '',
        value: _formData.isFirstTimeFiler,
        onChanged: (value) {
          _updateFormData(_formData.copyWith(isFirstTimeFiler: value));
        },
        conditionalWidget: _formData.isFirstTimeFiler == true
            ? _buildFirstTimeFilerDetails()
            : null,
      ),
    );
  }

  Widget _buildFirstTimeFilerDetails() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Theme.of(context).colorScheme.surface.withOpacity(0.7)
            : AppColors.grey50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Individual',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 12),
          _buildDateField(
            label: 'Date of Landing (Individual)',
            date: _firstTimeFilerLandingDate,
            onChanged: (date) {
              setState(() {
                _firstTimeFilerLandingDate = date;
              });
              final current =
                  _formData.firstTimeFilerIndividual ?? const T1FirstTimeFilerIncome();
              final updated = current.copyWith(dateOfLanding: date);
              _updateFormData(
                  _formData.copyWith(firstTimeFilerIndividual: updated));
            },
          ),
          const SizedBox(height: 12),
          _buildTextField(
            label: 'Income Outside Canada (CAD)',
            keyboardType: TextInputType.number,
            initialValue: (_formData.firstTimeFilerIndividual?.
                            incomeOutsideCanada ??
                        0.0) ==
                    0.0
                ? ''
                : _formData.firstTimeFilerIndividual!.incomeOutsideCanada
                    .toString(),
            onChanged: (value) {
              final parsed = double.tryParse(value) ?? 0.0;
              final current =
                  _formData.firstTimeFilerIndividual ?? const T1FirstTimeFilerIncome();
              final updated =
                  current.copyWith(incomeOutsideCanada: parsed);
              _updateFormData(
                  _formData.copyWith(firstTimeFilerIndividual: updated));
            },
          ),
          const SizedBox(height: 12),
          _buildTextField(
            label: 'Back Home Income 2024 (in CAD)',
            keyboardType: TextInputType.number,
            initialValue: (_formData.firstTimeFilerIndividual?.
                            backHomeIncome2024 ??
                        0.0) ==
                    0.0
                ? ''
                : _formData.firstTimeFilerIndividual!.backHomeIncome2024
                    .toString(),
            onChanged: (value) {
              final parsed = double.tryParse(value) ?? 0.0;
              final current =
                  _formData.firstTimeFilerIndividual ?? const T1FirstTimeFilerIncome();
              final updated =
                  current.copyWith(backHomeIncome2024: parsed);
              _updateFormData(
                  _formData.copyWith(firstTimeFilerIndividual: updated));
            },
          ),
          const SizedBox(height: 12),
          _buildTextField(
            label: 'Back Home Income 2023 (in CAD)',
            keyboardType: TextInputType.number,
            initialValue: (_formData.firstTimeFilerIndividual?.
                            backHomeIncome2023 ??
                        0.0) ==
                    0.0
                ? ''
                : _formData.firstTimeFilerIndividual!.backHomeIncome2023
                    .toString(),
            onChanged: (value) {
              final parsed = double.tryParse(value) ?? 0.0;
              final current =
                  _formData.firstTimeFilerIndividual ?? const T1FirstTimeFilerIncome();
              final updated =
                  current.copyWith(backHomeIncome2023: parsed);
              _updateFormData(
                  _formData.copyWith(firstTimeFilerIndividual: updated));
            },
          ),
          const SizedBox(height: 16),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            title: const Text('Spouse'),
            value: _includeFirstTimeFilerSpouse,
            onChanged: (val) {
              setState(() {
                _includeFirstTimeFilerSpouse = val ?? false;
              });
              if (val == true && _formData.firstTimeFilerSpouse == null) {
                _updateFormData(_formData.copyWith(
                  firstTimeFilerSpouse: const T1FirstTimeFilerIncome(),
                ));
              }
            },
          ),
          if (_includeFirstTimeFilerSpouse) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Theme.of(context).colorScheme.surface.withOpacity(0.7)
                    : Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Theme.of(context).dividerColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Spouse',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 12),
                  _buildDateField(
                    label: 'Date of Landing (Spouse)',
                    date: _firstTimeFilerLandingDateSpouse,
                    onChanged: (date) {
                      setState(() {
                        _firstTimeFilerLandingDateSpouse = date;
                      });
                      final current =
                          _formData.firstTimeFilerSpouse ?? const T1FirstTimeFilerIncome();
                      final updated = current.copyWith(dateOfLanding: date);
                      _updateFormData(
                          _formData.copyWith(firstTimeFilerSpouse: updated));
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    label: 'Income Outside Canada (CAD)',
                    keyboardType: TextInputType.number,
                    initialValue: (_formData.firstTimeFilerSpouse?.
                                    incomeOutsideCanada ??
                                0.0) ==
                            0.0
                        ? ''
                        : _formData.firstTimeFilerSpouse!.incomeOutsideCanada
                            .toString(),
                    onChanged: (value) {
                      final parsed = double.tryParse(value) ?? 0.0;
                      final current = _formData.firstTimeFilerSpouse ??
                          const T1FirstTimeFilerIncome();
                      final updated =
                          current.copyWith(incomeOutsideCanada: parsed);
                      _updateFormData(_formData.copyWith(
                        firstTimeFilerSpouse: updated,
                      ));
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    label: 'Back Home Income 2024 (in CAD)',
                    keyboardType: TextInputType.number,
                    initialValue: (_formData.firstTimeFilerSpouse?.
                                    backHomeIncome2024 ??
                                0.0) ==
                            0.0
                        ? ''
                        : _formData.firstTimeFilerSpouse!.backHomeIncome2024
                            .toString(),
                    onChanged: (value) {
                      final parsed = double.tryParse(value) ?? 0.0;
                      final current = _formData.firstTimeFilerSpouse ??
                          const T1FirstTimeFilerIncome();
                      final updated =
                          current.copyWith(backHomeIncome2024: parsed);
                      _updateFormData(_formData.copyWith(
                        firstTimeFilerSpouse: updated,
                      ));
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    label: 'Back Home Income 2023 (in CAD)',
                    keyboardType: TextInputType.number,
                    initialValue: (_formData.firstTimeFilerSpouse?.
                                    backHomeIncome2023 ??
                                0.0) ==
                            0.0
                        ? ''
                        : _formData.firstTimeFilerSpouse!.backHomeIncome2023
                            .toString(),
                    onChanged: (value) {
                      final parsed = double.tryParse(value) ?? 0.0;
                      final current = _formData.firstTimeFilerSpouse ??
                          const T1FirstTimeFilerIncome();
                      final updated =
                          current.copyWith(backHomeIncome2023: parsed);
                      _updateFormData(_formData.copyWith(
                        firstTimeFilerSpouse: updated,
                      ));
                    },
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOtherIncomeSection() {
    return _buildSection(
      title: '14. Do you have any other Income in 2023 which does not have T Slips?',
      child: _buildRadioQuestion(
        question: '',
        value: _formData.hasOtherIncome,
        onChanged: (value) {
          _updateFormData(_formData.copyWith(hasOtherIncome: value));
        },
        conditionalWidget: _formData.hasOtherIncome == true
            ? _buildTextField(
                label: 'Describe the income and amount',
                maxLines: 3,
                initialValue: _formData.otherIncomeDescription,
                onChanged: (value) {
                  _updateFormData(_formData.copyWith(otherIncomeDescription: value));
                },
              )
            : null,
      ),
    );
  }

  Widget _buildProfessionalDuesSection() {
    return _buildSection(
      title: '15. Do you have any Professional Dues, License Fees, Exam fees which you have paid from your pocket for last year?',
      child: _buildRadioQuestion(
        question: '',
        value: _formData.hasProfessionalDues,
        onChanged: (value) {
          _updateFormData(_formData.copyWith(hasProfessionalDues: value));
        },
        conditionalWidget: _formData.hasProfessionalDues == true
            ? _buildProfessionalDuesTable()
            : null,
      ),
    );
  }

  Widget _buildProfessionalDuesTable() {
    return Column(
      children: [
        if (_formData.professionalDues.isEmpty)
          _buildProfessionalDueRow(0)
        else
          ..._professionalDueRowIds.map(_buildProfessionalDueRow),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: _addProfessionalDueRow,
          icon: const Icon(Icons.add),
          label: const Text('Add Row'),
        ),
      ],
    );
  }

  Widget _buildProfessionalDueRow(int id) {
    final index = _professionalDueRowIds.isEmpty
        ? 0
        : _professionalDueRowIds.indexOf(id);
    final rows = _formData.professionalDues;
    final current = (index >= 0 && index < rows.length)
        ? rows[index]
        : const T1ProfessionalDue();
    return Container(
      key: ValueKey('professional_due_$id'),
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Theme.of(context).colorScheme.surface.withOpacity(0.7)
            : AppColors.grey50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Professional Due ${index + 1}',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              if (_professionalDueRowIds.length > 1)
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _removeProfessionalDueRow(id),
                ),
            ],
          ),
          const SizedBox(height: 12),
          _buildTextField(
            label: 'Name',
            initialValue: current.name,
            onChanged: (value) {
              final updated = List<T1ProfessionalDue>.from(rows);
              final newRow = current.copyWith(name: value);
              if (index >= updated.length) {
                updated.add(newRow);
                if (_professionalDueRowIds.isEmpty) {
                  _professionalDueRowIds.add(0);
                  _professionalDueRowCounter = 1;
                }
              } else {
                updated[index] = newRow;
              }
              _updateFormData(
                  _formData.copyWith(professionalDues: updated));
            },
          ),
          const SizedBox(height: 12),
          _buildTextField(
            label: 'Organization',
            initialValue: current.organization,
            onChanged: (value) {
              final updated = List<T1ProfessionalDue>.from(rows);
              final newRow = current.copyWith(organization: value);
              if (index >= updated.length) {
                updated.add(newRow);
                if (_professionalDueRowIds.isEmpty) {
                  _professionalDueRowIds.add(0);
                  _professionalDueRowCounter = 1;
                }
              } else {
                updated[index] = newRow;
              }
              _updateFormData(
                  _formData.copyWith(professionalDues: updated));
            },
          ),
          const SizedBox(height: 12),
          _buildTextField(
            label: 'Amount',
            keyboardType: TextInputType.number,
            initialValue:
                current.amount == 0.0 ? '' : current.amount.toString(),
            onChanged: (value) {
              final parsed = double.tryParse(value) ?? 0.0;
              final updated = List<T1ProfessionalDue>.from(rows);
              final newRow = current.copyWith(amount: parsed);
              if (index >= updated.length) {
                updated.add(newRow);
                if (_professionalDueRowIds.isEmpty) {
                  _professionalDueRowIds.add(0);
                  _professionalDueRowCounter = 1;
                }
              } else {
                updated[index] = newRow;
              }
              _updateFormData(
                  _formData.copyWith(professionalDues: updated));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRrspFhsaSection() {
    return _buildSection(
      title: '16. Do you have any RRSP/FHSA Investment? If yes, please provide the slips along with your T Slips.',
      child: _buildRadioQuestion(
        question: '',
        value: _formData.hasRrspFhsaInvestment,
        onChanged: (value) {
          _updateFormData(_formData.copyWith(hasRrspFhsaInvestment: value));
        },
      ),
    );
  }

  Widget _buildChildArtSportSection() {
    return _buildSection(
      title: '17. Children\'s Art & Sport Tax Credit - Do you have any receipts for your child\'s Sport/fitness & Art for 2023?',
      child: _buildRadioQuestion(
        question: '',
        value: _formData.hasChildArtSportCredit,
        onChanged: (value) {
          _updateFormData(_formData.copyWith(hasChildArtSportCredit: value));
        },
        conditionalWidget: _formData.hasChildArtSportCredit == true
            ? _buildChildArtSportTable()
            : null,
      ),
    );
  }

  Widget _buildChildArtSportTable() {
    return Column(
      children: [
        if (_formData.childArtSportEntries.isEmpty)
          _buildChildArtSportRow(0)
        else
          ..._childArtSportRowIds.map(_buildChildArtSportRow),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: _addChildArtSportRow,
          icon: const Icon(Icons.add),
          label: const Text('Add Row'),
        ),
      ],
    );
  }

  Widget _buildChildArtSportRow(int id) {
    final index = _childArtSportRowIds.isEmpty
        ? 0
        : _childArtSportRowIds.indexOf(id);
    final rows = _formData.childArtSportEntries;
    final current = (index >= 0 && index < rows.length)
        ? rows[index]
        : const T1ChildArtSportEntry();
    return Container(
      key: ValueKey('child_art_sport_$id'),
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Theme.of(context).colorScheme.surface.withOpacity(0.7)
            : AppColors.grey50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Entry ${index + 1}',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              if (_childArtSportRowIds.length > 1)
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _removeChildArtSportRow(id),
                ),
            ],
          ),
          const SizedBox(height: 12),
          _buildTextField(
            label: 'Institute Name',
            initialValue: current.instituteName,
            onChanged: (value) {
              final updated =
                  List<T1ChildArtSportEntry>.from(rows);
              final newRow = current.copyWith(instituteName: value);
              if (index >= updated.length) {
                updated.add(newRow);
                if (_childArtSportRowIds.isEmpty) {
                  _childArtSportRowIds.add(0);
                  _childArtSportRowCounter = 1;
                }
              } else {
                updated[index] = newRow;
              }
              _updateFormData(_formData.copyWith(
                childArtSportEntries: updated,
              ));
            },
          ),
          const SizedBox(height: 12),
          _buildTextField(
            label: 'Description',
            initialValue: current.description,
            onChanged: (value) {
              final updated =
                  List<T1ChildArtSportEntry>.from(rows);
              final newRow = current.copyWith(description: value);
              if (index >= updated.length) {
                updated.add(newRow);
                if (_childArtSportRowIds.isEmpty) {
                  _childArtSportRowIds.add(0);
                  _childArtSportRowCounter = 1;
                }
              } else {
                updated[index] = newRow;
              }
              _updateFormData(_formData.copyWith(
                childArtSportEntries: updated,
              ));
            },
          ),
          const SizedBox(height: 12),
          _buildTextField(
            label: 'Amount',
            keyboardType: TextInputType.number,
            initialValue:
                current.amount == 0.0 ? '' : current.amount.toString(),
            onChanged: (value) {
              final parsed = double.tryParse(value) ?? 0.0;
              final updated =
                  List<T1ChildArtSportEntry>.from(rows);
              final newRow = current.copyWith(amount: parsed);
              if (index >= updated.length) {
                updated.add(newRow);
                if (_childArtSportRowIds.isEmpty) {
                  _childArtSportRowIds.add(0);
                  _childArtSportRowCounter = 1;
                }
              } else {
                updated[index] = newRow;
              }
              _updateFormData(_formData.copyWith(
                childArtSportEntries: updated,
              ));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProvinceFilerSection() {
    return _buildSection(
      title: '18. FOR ONTARIO/ALBERTA/QUEBEC FILER ONLY - Please Provide below details for 2023',
      child: _buildRadioQuestion(
        question: '',
        value: _formData.isProvinceFiler,
        onChanged: (value) {
          _updateFormData(_formData.copyWith(isProvinceFiler: value));
        },
        conditionalWidget: _formData.isProvinceFiler == true
            ? _buildProvinceFilerTable()
            : null,
      ),
    );
  }

  Widget _buildProvinceFilerTable() {
    return Column(
      children: [
        if (_formData.provinceFilerEntries.isEmpty)
          _buildProvinceFilerRow(0)
        else
          ..._provinceFilerRowIds.map(_buildProvinceFilerRow),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: _addProvinceFilerRow,
          icon: const Icon(Icons.add),
          label: const Text('Add Row'),
        ),
      ],
    );
  }

  Widget _buildProvinceFilerRow(int id) {
    final index = _provinceFilerRowIds.isEmpty
        ? 0
        : _provinceFilerRowIds.indexOf(id);
    final rows = _formData.provinceFilerEntries;
    final current = (index >= 0 && index < rows.length)
        ? rows[index]
        : const T1ProvinceFilerEntry();
    return Container(
      key: ValueKey('province_filer_$id'),
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Theme.of(context).colorScheme.surface.withOpacity(0.7)
            : AppColors.grey50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Entry ${index + 1}',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              if (_provinceFilerRowIds.length > 1)
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _removeProvinceFilerRow(id),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Quebec Filer - Provide RL-31',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.grey600,
                  fontStyle: FontStyle.italic,
                ),
          ),
          const SizedBox(height: 8),
          _buildTextField(
            label: 'Rent or Property Tax',
            initialValue: current.rentOrPropertyTax,
            onChanged: (value) {
              final updated =
                  List<T1ProvinceFilerEntry>.from(rows);
              final newRow = current.copyWith(rentOrPropertyTax: value);
              if (index >= updated.length) {
                updated.add(newRow);
                if (_provinceFilerRowIds.isEmpty) {
                  _provinceFilerRowIds.add(0);
                  _provinceFilerRowCounter = 1;
                }
              } else {
                updated[index] = newRow;
              }
              _updateFormData(_formData.copyWith(
                provinceFilerEntries: updated,
              ));
            },
          ),
          const SizedBox(height: 12),
          _buildTextField(
            label: 'Property Address',
            initialValue: current.propertyAddress,
            onChanged: (value) {
              final updated =
                  List<T1ProvinceFilerEntry>.from(rows);
              final newRow = current.copyWith(propertyAddress: value);
              if (index >= updated.length) {
                updated.add(newRow);
                if (_provinceFilerRowIds.isEmpty) {
                  _provinceFilerRowIds.add(0);
                  _provinceFilerRowCounter = 1;
                }
              } else {
                updated[index] = newRow;
              }
              _updateFormData(_formData.copyWith(
                provinceFilerEntries: updated,
              ));
            },
          ),
          const SizedBox(height: 12),
          _buildTextField(
            label: 'Postal Code',
            initialValue: current.postalCode,
            onChanged: (value) {
              final updated =
                  List<T1ProvinceFilerEntry>.from(rows);
              final newRow = current.copyWith(postalCode: value);
              if (index >= updated.length) {
                updated.add(newRow);
                if (_provinceFilerRowIds.isEmpty) {
                  _provinceFilerRowIds.add(0);
                  _provinceFilerRowCounter = 1;
                }
              } else {
                updated[index] = newRow;
              }
              _updateFormData(_formData.copyWith(
                provinceFilerEntries: updated,
              ));
            },
          ),
          const SizedBox(height: 12),
          _buildTextField(
            label: 'No. Of Months Resides',
            keyboardType: TextInputType.number,
            initialValue: current.monthsResides == 0.0
                ? ''
                : current.monthsResides.toString(),
            onChanged: (value) {
              final parsed = double.tryParse(value) ?? 0.0;
              final updated =
                  List<T1ProvinceFilerEntry>.from(rows);
              final newRow = current.copyWith(monthsResides: parsed);
              if (index >= updated.length) {
                updated.add(newRow);
                if (_provinceFilerRowIds.isEmpty) {
                  _provinceFilerRowIds.add(0);
                  _provinceFilerRowCounter = 1;
                }
              } else {
                updated[index] = newRow;
              }
              _updateFormData(_formData.copyWith(
                provinceFilerEntries: updated,
              ));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDisabilityTaxCreditSection() {
    return _buildSection(
      title: '19. Is any family member has disability tax credit?',
      child: _buildRadioQuestion(
        question: 'Please provide details of the person who wants to claim the credit.',
        value: _formData.hasDisabilityTaxCredit,
        onChanged: (value) {
          // If turned off, clear members and remove any previously uploaded disability document reference.
          if (value == false) {
            final updatedDocs = Map<String, String>.from(_formData.uploadedDocuments);
            updatedDocs.remove('Disability Approval form');

            _updateFormData(_formData.copyWith(
              hasDisabilityTaxCredit: value,
              disabilityClaimMembers: const [],
              uploadedDocuments: updatedDocs,
            ));
            return;
          }

          // If turned on, ensure at least one member subform exists.
          final members = _formData.disabilityClaimMembers.isNotEmpty
              ? _formData.disabilityClaimMembers
              : const [T1DisabilityClaimMember()];

          _updateFormData(_formData.copyWith(
            hasDisabilityTaxCredit: value,
            disabilityClaimMembers: members,
          ));
        },
        conditionalWidget: _formData.hasDisabilityTaxCredit == true
            ? _buildDisabilityMembersList()
            : null,
      ),
    );
  }

  Widget _buildDisabilityMembersList() {
    final members = _formData.disabilityClaimMembers.isNotEmpty
        ? _formData.disabilityClaimMembers
        : const [T1DisabilityClaimMember()];

    // If form data didn't have any members yet, keep UI usable but don't mutate here.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...List.generate(members.length, (index) {
          final member = members[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Theme.of(context).colorScheme.surface.withValues(alpha: 0.7)
                  : AppColors.grey50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Member ${index + 1}',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    if (members.length > 1)
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          final updated = List<T1DisabilityClaimMember>.from(members);
                          updated.removeAt(index);
                          _updateFormData(_formData.copyWith(disabilityClaimMembers: updated));
                        },
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  label: 'First Name',
                  initialValue: member.firstName,
                  onChanged: (v) {
                    final updated = List<T1DisabilityClaimMember>.from(members);
                    updated[index] = member.copyWith(firstName: v);
                    _updateFormData(_formData.copyWith(disabilityClaimMembers: updated));
                  },
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  label: 'Last Name',
                  initialValue: member.lastName,
                  onChanged: (v) {
                    final updated = List<T1DisabilityClaimMember>.from(members);
                    updated[index] = member.copyWith(lastName: v);
                    _updateFormData(_formData.copyWith(disabilityClaimMembers: updated));
                  },
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  label: 'Relation',
                  initialValue: member.relation,
                  onChanged: (v) {
                    final updated = List<T1DisabilityClaimMember>.from(members);
                    updated[index] = member.copyWith(relation: v);
                    _updateFormData(_formData.copyWith(disabilityClaimMembers: updated));
                  },
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  label: 'Approved Year',
                  initialValue: member.approvedYear,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (v) {
                    final updated = List<T1DisabilityClaimMember>.from(members);
                    updated[index] = member.copyWith(approvedYear: v);
                    _updateFormData(_formData.copyWith(disabilityClaimMembers: updated));
                  },
                ),
              ],
            ),
          );
        }),
        OutlinedButton.icon(
          onPressed: () {
            final updated = List<T1DisabilityClaimMember>.from(members);
            updated.add(const T1DisabilityClaimMember());
            _updateFormData(_formData.copyWith(disabilityClaimMembers: updated));
          },
          icon: const Icon(Icons.add),
          label: const Text('Add another member'),
        ),
      ],
    );
  }

  Widget _buildDeceasedReturnQuestionSection() {
    return _buildSection(
      title: '20. Are you filing a return on behalf of a person who died in this Tax Year?',
      child: _buildRadioQuestion(
        question: '',
        value: _formData.isFilingForDeceased,
        onChanged: (value) {
          if (value == false) {
            final updatedDocs = Map<String, String>.from(_formData.uploadedDocuments);
            updatedDocs.remove('Clearance Certificate');

            _updateFormData(_formData.copyWith(
              isFilingForDeceased: value,
              deceasedReturnInfo: null,
              uploadedDocuments: updatedDocs,
            ));
            return;
          }

          _updateFormData(_formData.copyWith(
            isFilingForDeceased: value,
            deceasedReturnInfo: _formData.deceasedReturnInfo ?? const T1DeceasedReturnInfo(),
          ));
        },
      ),
    );
  }

  Widget _buildNavigationButtons() {
    final hasMovingExpenses = _formData.hasMovingExpenses ?? false;
    final isSelfEmployed = _formData.isSelfEmployed ?? false;
    final isFilingForDeceased = _formData.isFilingForDeceased ?? false;
    final needsAdditionalSteps = hasMovingExpenses || isSelfEmployed || isFilingForDeceased;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          onPressed: widget.onNext,
          child: Text(needsAdditionalSteps ? 'Next' : widget.finalActionLabel),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: widget.onPrevious,
          child: const Text('Previous: Personal Info'),
        ),
      ],
    );
  }
}
