import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

/// Demonstration of the Diamond Accounts color scheme
/// Shows all colors in both light and dark themes with usage examples
class ColorSchemeDemo extends StatefulWidget {
  const ColorSchemeDemo({super.key});

  @override
  State<ColorSchemeDemo> createState() => _ColorSchemeDemoState();
}

class _ColorSchemeDemoState extends State<ColorSchemeDemo> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: isDarkMode 
          ? ThemeData.dark().copyWith(colorScheme: AppColors.darkColorScheme)
          : ThemeData.light().copyWith(colorScheme: AppColors.lightColorScheme),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Diamond Accounts Colors',
            style: AppTextStyles.appBarTitle,
          ),
          actions: [
            Switch(
              value: isDarkMode,
              onChanged: (value) => setState(() => isDarkMode = value),
            ),
            const SizedBox(width: 16),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildCoreColors(),
              const SizedBox(height: 24),
              _buildThemeColors(),
              const SizedBox(height: 24),
              _buildStatusColors(),
              const SizedBox(height: 24),
              _buildGradientShowcase(),
              const SizedBox(height: 24),
              _buildComponentExamples(),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => setState(() => isDarkMode = !isDarkMode),
          child: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.brandGradient,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            'Diamond Accounts',
            style: AppTextStyles.h2Large.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Professional Blue Color Scheme',
            style: AppTextStyles.bodyLarge.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            isDarkMode ? 'Dark Theme' : 'Light Theme',
            style: AppTextStyles.label.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoreColors() {
    return _buildSection(
      'Core Brand Colors',
      'Foundational colors derived from Diamond Accounts logo',
      [
        _buildColorCard('Primary Blue', AppColors.brandPrimaryBlue, '#1E50A0'),
        _buildColorCard('Light Blue', AppColors.brandLightBlue, '#4A8CDA'),
        _buildColorCard('Darker Blue', AppColors.brandDarkerBlue, '#0A2B68'),
      ],
    );
  }

  Widget _buildThemeColors() {
    return _buildSection(
      '${isDarkMode ? 'Dark' : 'Light'} Theme Colors',
      'Complete color palette for ${isDarkMode ? 'low-light' : 'bright'} environments',
      [
        _buildColorCard(
          'Primary', 
          isDarkMode ? AppColors.primaryDark : AppColors.primaryLight,
          isDarkMode ? '#4A8CDA' : '#1E50A0',
        ),
        _buildColorCard(
          'Secondary', 
          isDarkMode ? AppColors.secondaryDark : AppColors.secondaryLight,
          isDarkMode ? '#1E50A0' : '#4A8CDA',
        ),
        _buildColorCard(
          'Background', 
          isDarkMode ? AppColors.backgroundDark : AppColors.backgroundLight,
          isDarkMode ? '#0D1A2E' : '#F5F7FA',
        ),
        _buildColorCard(
          'Surface', 
          isDarkMode ? AppColors.surfaceDark : AppColors.surfaceLight,
          isDarkMode ? '#1A2B47' : '#FFFFFF',
        ),
        _buildColorCard(
          'Container', 
          isDarkMode ? AppColors.containerDark : AppColors.containerLight,
          isDarkMode ? '#243A5C' : '#F0F2F5',
        ),
      ],
    );
  }

  Widget _buildStatusColors() {
    return _buildSection(
      'Status Colors',
      'Colors for success, warning, error, and info states',
      [
        _buildColorCard('Success', AppColors.success, '#4CAF50'),
        _buildColorCard('Warning', AppColors.warning, '#FF9800'),
        _buildColorCard(
          'Error', 
          isDarkMode ? AppColors.errorDark : AppColors.errorLight,
          isDarkMode ? '#EF5350' : '#D32F2F',
        ),
        _buildColorCard('Info', AppColors.info, '#2196F3'),
      ],
    );
  }

  Widget _buildGradientShowcase() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Gradient Showcase', style: AppTextStyles.h3Small),
        const SizedBox(height: 8),
        Text(
          'Premium gradient animations using Diamond Accounts palette',
          style: AppTextStyles.bodySmall.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildGradientCard('Brand Gradient', AppColors.brandGradient)),
            const SizedBox(width: 12),
            Expanded(child: _buildGradientCard(
              '${isDarkMode ? 'Dark' : 'Light'} Gradient', 
              isDarkMode ? AppColors.darkGradient : AppColors.lightGradient,
            )),
          ],
        ),
      ],
    );
  }

  Widget _buildComponentExamples() {
    return _buildSection(
      'Component Examples',
      'How the colors look in real UI components',
      [
        _buildComponentCard(),
        const SizedBox(height: 16),
        _buildButtonExamples(),
        const SizedBox(height: 16),
        _buildFormExample(),
      ],
    );
  }

  Widget _buildSection(String title, String description, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.h3Small),
        const SizedBox(height: 8),
        Text(
          description,
          style: AppTextStyles.bodySmall.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }

  Widget _buildColorCard(String name, Color color, String hex) {
    final isLight = color.computeLuminance() > 0.5;
    final textColor = isLight ? Colors.black87 : Colors.white;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: AppTextStyles.bodyMedium.copyWith(
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              hex,
              style: AppTextStyles.bodySmall.copyWith(
                color: textColor.withOpacity(0.8),
                fontFamily: 'monospace',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGradientCard(String name, LinearGradient gradient) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          name,
          style: AppTextStyles.bodyMedium.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildComponentCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sample Card', style: AppTextStyles.cardTitle),
            const SizedBox(height: 8),
            Text(
              'This card demonstrates how the Diamond Accounts colors work with Material Design components.',
              style: AppTextStyles.cardSubtitle,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {},
                  child: const Text('CANCEL'),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () {},
                  child: const Text('CONFIRM'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonExamples() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        ElevatedButton(
          onPressed: () {},
          child: const Text('Elevated'),
        ),
        FilledButton(
          onPressed: () {},
          child: const Text('Filled'),
        ),
        OutlinedButton(
          onPressed: () {},
          child: const Text('Outlined'),
        ),
        TextButton(
          onPressed: () {},
          child: const Text('Text'),
        ),
      ],
    );
  }

  Widget _buildFormExample() {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            labelText: 'Sample Input',
            hintText: 'Enter some text...',
            prefixIcon: const Icon(Icons.person),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          decoration: InputDecoration(
            labelText: 'Error State',
            errorText: 'This field has an error',
            prefixIcon: const Icon(Icons.error),
          ),
        ),
      ],
    );
  }
}

/// Usage Examples:
/// 
/// **Core Brand Colors:**
/// ```dart
/// Container(color: AppColors.brandPrimaryBlue)
/// Container(color: AppColors.brandLightBlue)
/// Container(color: AppColors.brandDarkerBlue)
/// ```
/// 
/// **Theme Colors:**
/// ```dart
/// // Light theme
/// Container(color: AppColors.primaryLight)
/// Container(color: AppColors.backgroundLight)
/// 
/// // Dark theme
/// Container(color: AppColors.primaryDark)
/// Container(color: AppColors.backgroundDark)
/// 
/// // Auto-switching based on current theme
/// Container(color: Theme.of(context).colorScheme.primary)
/// Container(color: Theme.of(context).colorScheme.surface)
/// ```
/// 
/// **Complete ColorScheme Integration:**
/// ```dart
/// ThemeData(
///   colorScheme: AppColors.lightColorScheme,
/// )
/// 
/// ThemeData(
///   colorScheme: AppColors.darkColorScheme,
/// )
/// ```
/// 
/// **Gradients:**
/// ```dart
/// Container(
///   decoration: BoxDecoration(
///     gradient: AppColors.brandGradient,
///   ),
/// )
/// ```