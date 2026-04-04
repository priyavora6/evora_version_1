// lib/utils/validators.dart

import '../config/app_strings.dart';

class Validators {
  // 📧 Email Validator
  static String? validateEmail(String? value) {
    // Trim accidental whitespace
    final trimmedValue = value?.trim();

    if (trimmedValue == null || trimmedValue.isEmpty) {
      return AppStrings.emailRequired;
    }

    // Standard RFC 5322 regex for email
    // This will catch typos like "vora@06149@gmail.com"
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegex.hasMatch(trimmedValue)) {
      return AppStrings.invalidEmail;
    }
    return null;
  }

  // 🔑 Password Validator
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.passwordRequired;
    }
    if (value.length < 6) {
      return AppStrings.passwordTooShort;
    }
    return null;
  }

  // 👤 Name Validator
  static String? validateName(String? value) {
    final trimmedValue = value?.trim();
    if (trimmedValue == null || trimmedValue.isEmpty) {
      return AppStrings.nameRequired;
    }
    if (trimmedValue.length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  // 📞 Phone Validator (Ensures only digits and exactly 10 length)
  static String? validatePhone(String? value) {
    final trimmedValue = value?.trim();
    if (trimmedValue == null || trimmedValue.isEmpty) {
      return AppStrings.phoneRequired;
    }

    final phoneRegex = RegExp(r'^[0-9]{10}$');
    if (!phoneRegex.hasMatch(trimmedValue)) {
      return 'Enter a valid 10-digit phone number';
    }
    return null;
  }

  // 📍 Required Field Validator
  static String? validateRequired(String? value, [String fieldName = 'This field']) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  // 🔢 Number Validator
  static String? validateNumber(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.fieldRequired;
    }
    if (double.tryParse(value) == null) {
      return 'Please enter a valid number';
    }
    return null;
  }

  // 🌐 URL Validator (🔥 NEEDED FOR VENDOR SOCIAL LINKS)
  static String? validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return null; // URLs are usually optional in your form
    }
    final urlRegex = RegExp(
      r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$',
    );
    if (!urlRegex.hasMatch(value.trim())) {
      return 'Please enter a valid URL (e.g. instagram.com/name)';
    }
    return null;
  }
}