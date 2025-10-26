#!/usr/bin/env python3
import re

# Read the main file
with open('lib/features/tax_forms/presentation/widgets/t1_questionnaire_2_step.dart', 'r', encoding='utf-8') as f:
    main_content = f.read()

# Read the new implementation
with open('GENERAL_BUSINESS_FORM_IMPLEMENTATION.txt', 'r', encoding='utf-8') as f:
    new_impl = f.read()

# Extract just the method from the new implementation (skip the comment lines at the top)
new_method = '\n'.join(new_impl.split('\n')[3:])  # Skip first 3 lines

# Replace the old method with the new one
# Pattern: from "// ========== GENERAL BUSINESS DETAILS" to just before "// ========== RENTAL INCOME"
pattern = r'(  // ========== GENERAL BUSINESS DETAILS ==========.*?)(  // ========== RENTAL INCOME DETAILS)'
replacement = new_method + '\n\n\\2'

new_content = re.sub(pattern, replacement, main_content, flags=re.DOTALL)

# Write back
with open('lib/features/tax_forms/presentation/widgets/t1_questionnaire_2_step.dart', 'w', encoding='utf-8') as f:
    f.write(new_content)

print("✅ General Business form replaced successfully!")
