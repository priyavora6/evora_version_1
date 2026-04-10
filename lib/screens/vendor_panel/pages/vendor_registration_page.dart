// lib/screens/vendor_panel/pages/vendor_registration_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_routes.dart';
import '../../../providers/auth_provider.dart';
import '../../../widgets/custom_textfield.dart';
import '../../../widgets/loading_indicator.dart';
import '../../../utils/validators.dart';

class VendorRegistrationPage extends StatefulWidget {
  const VendorRegistrationPage({super.key});

  @override
  State<VendorRegistrationPage> createState() => _VendorRegistrationPageState();
}

class _VendorRegistrationPageState extends State<VendorRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  bool _isSubmitting = false;
  bool _agreedToTerms = false;

  // Controllers
  final _vendorNameController = TextEditingController();
  final _businessNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _businessPhoneController = TextEditingController();
  final _businessEmailController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _experienceController = TextEditingController();
  final _priceRangeController = TextEditingController();
  final _websiteController = TextEditingController();
  final _instagramController = TextEditingController();
  final _facebookController = TextEditingController();
  final _referencesController = TextEditingController();

  String _selectedServiceType = 'Photography';

  final List<String> _serviceTypes = [
    'Photography', 'Videography', 'Catering', 'Decoration', 'DJ & Music',
    'Makeup Artist', 'Venue', 'Florist', 'Lighting', 'Transportation',
    'Event Planner', 'Anchor/Host', 'Other',
  ];

  @override
  void initState() {
    super.initState();
    _prefillOwnerInfo();
  }

  void _prefillOwnerInfo() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.currentUser;
    if (user != null) {
      _ownerNameController.text = user.name;
      _businessEmailController.text = user.email;
      _businessPhoneController.text = user.phone;
    }
  }

  @override
  void dispose() {
    _vendorNameController.dispose();
    _businessNameController.dispose();
    _descriptionController.dispose();
    _ownerNameController.dispose();
    _businessPhoneController.dispose();
    _businessEmailController.dispose();
    _whatsappController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _experienceController.dispose();
    _priceRangeController.dispose();
    _websiteController.dispose();
    _instagramController.dispose();
    _facebookController.dispose();
    _referencesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: const Text('Become a Vendor', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          _buildProgressIndicator(),
          Expanded(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_currentStep == 0) _buildBusinessDetailsStep(),
                    if (_currentStep == 1) _buildContactInfoStep(),
                    if (_currentStep == 2) _buildLocationStep(),
                    if (_currentStep == 3) _buildExperienceLinksStep(),
                    if (_currentStep == 4) _buildReviewSubmitStep(),
                    const SizedBox(height: 30),
                    _buildNavigationButtons(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // 📊 PROGRESS INDICATOR
  // ═══════════════════════════════════════════════════════════════════════
  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.all(20),
      color: AppColors.primary,
      child: Column(
        children: [
          Row(
            children: List.generate(5, (index) {
              return Expanded(
                child: Container(
                  height: 4,
                  margin: EdgeInsets.only(right: index < 4 ? 8 : 0),
                  decoration: BoxDecoration(
                    color: index <= _currentStep ? Colors.white : Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _getStepTitle(_currentStep),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                'Step ${_currentStep + 1} of 5',
                style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getStepTitle(int step) {
    switch (step) {
      case 0: return 'Business Details';
      case 1: return 'Contact Information';
      case 2: return 'Location';
      case 3: return 'Experience & Links';
      case 4: return 'Review & Submit';
      default: return '';
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  // STEPS
  // ═══════════════════════════════════════════════════════════════════════

  Widget _buildBusinessDetailsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(icon: Icons.business, title: 'Tell us about your business'),
        const SizedBox(height: 20),
        CustomTextField(controller: _vendorNameController, label: 'Vendor Name *', hint: 'e.g. John Doe / Studio Name', prefixIcon: Icons.person_pin_outlined, validator: Validators.validateRequired, textCapitalization: TextCapitalization.words),
        const SizedBox(height: 20),
        CustomTextField(controller: _businessNameController, label: 'Business Name *', hint: 'e.g. Perfect Moments Photography', prefixIcon: Icons.store_outlined, validator: Validators.validateRequired, textCapitalization: TextCapitalization.words),
        const SizedBox(height: 20),
        _buildDropdownField(label: 'Service Type *', value: _selectedServiceType, items: _serviceTypes, onChanged: (value) => setState(() => _selectedServiceType = value!)),
        const SizedBox(height: 20),
        CustomTextField(controller: _descriptionController, label: 'Business Description *', hint: 'Describe your services...', prefixIcon: Icons.description_outlined, maxLines: 5, validator: Validators.validateRequired),
        const SizedBox(height: 20),
        CustomTextField(controller: _priceRangeController, label: 'Price Range *', hint: 'e.g. ₹15,000 - ₹50,000', prefixIcon: Icons.currency_rupee, validator: Validators.validateRequired),
      ],
    );
  }

  Widget _buildContactInfoStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(icon: Icons.contact_phone, title: 'Contact Information'),
        const SizedBox(height: 20),
        CustomTextField(controller: _ownerNameController, label: 'Owner / Contact Name *', hint: 'Your full name', prefixIcon: Icons.person_outline, validator: Validators.validateRequired, textCapitalization: TextCapitalization.words),
        const SizedBox(height: 20),
        CustomTextField(controller: _businessPhoneController, label: 'Business Phone *', hint: '10-digit mobile number', prefixIcon: Icons.phone_outlined, keyboardType: TextInputType.phone, validator: Validators.validatePhone, maxLength: 10),
        const SizedBox(height: 20),
        CustomTextField(controller: _businessEmailController, label: 'Business Email *', hint: 'contact@yourbusiness.com', prefixIcon: Icons.email_outlined, keyboardType: TextInputType.emailAddress, validator: Validators.validateEmail),
        const SizedBox(height: 20),
        CustomTextField(controller: _whatsappController, label: 'WhatsApp Number (Optional)', hint: 'For quick client communication', prefixIcon: Icons.message_outlined, keyboardType: TextInputType.phone, maxLength: 10),
      ],
    );
  }

  Widget _buildLocationStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(icon: Icons.location_on, title: 'Business Location'),
        const SizedBox(height: 20),
        CustomTextField(controller: _addressController, label: 'Business Address *', hint: 'Street address, building name, etc.', prefixIcon: Icons.home_outlined, maxLines: 2, validator: Validators.validateRequired),
        const SizedBox(height: 20),
        CustomTextField(controller: _cityController, label: 'City *', hint: 'e.g. Mumbai', prefixIcon: Icons.location_city_outlined, validator: Validators.validateRequired, textCapitalization: TextCapitalization.words),
      ],
    );
  }

  Widget _buildExperienceLinksStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(icon: Icons.work_history, title: 'Experience & Social Links'),
        const SizedBox(height: 20),
        CustomTextField(controller: _experienceController, label: 'Years of Experience *', hint: 'e.g. 5', prefixIcon: Icons.calendar_today_outlined, keyboardType: TextInputType.number, validator: Validators.validateRequired),
        const SizedBox(height: 20),
        CustomTextField(controller: _websiteController, label: 'Website URL', hint: 'https://www.yourbusiness.com', prefixIcon: Icons.language, keyboardType: TextInputType.url),
        const SizedBox(height: 20),
        CustomTextField(controller: _instagramController, label: 'Instagram Handle', hint: '@yourbusiness', prefixIcon: Icons.camera_alt_outlined),
        const SizedBox(height: 20),
        CustomTextField(controller: _facebookController, label: 'Facebook Page URL', hint: 'https://facebook.com/yourbusiness', prefixIcon: Icons.facebook, keyboardType: TextInputType.url),
        const SizedBox(height: 20),
        CustomTextField(controller: _referencesController, label: 'Previous Client References', hint: 'Names of previous clients', prefixIcon: Icons.people_outline, maxLines: 3),
      ],
    );
  }

  Widget _buildReviewSubmitStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(icon: Icons.fact_check, title: 'Review Your Application'),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSummaryItem('Vendor Name', _vendorNameController.text),
              _buildSummaryItem('Business Name', _businessNameController.text),
              _buildSummaryItem('Service Type', _selectedServiceType),
              _buildSummaryItem('Owner Name', _ownerNameController.text),
              _buildSummaryItem('Phone', _businessPhoneController.text),
              _buildSummaryItem('City', _cityController.text),
              _buildSummaryItem('Experience', '${_experienceController.text} years'),
              _buildSummaryItem('Price Range', _priceRangeController.text),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.05), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.primary.withOpacity(0.2))),
          child: Row(
            children: [
              Checkbox(value: _agreedToTerms, onChanged: (value) => setState(() => _agreedToTerms = value ?? false), activeColor: AppColors.primary),
              Expanded(child: Text('I agree to the Terms & Conditions and confirm that all information provided is accurate.', style: TextStyle(fontSize: 13, color: AppColors.textPrimary))),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    if (value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 120, child: Text(label, style: TextStyle(color: AppColors.textSecondary, fontSize: 13))),
          Expanded(child: Text(value, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w500, fontSize: 14))),
        ],
      ),
    );
  }

  Widget _buildDropdownField({required String label, required String value, required List<String> items, required Function(String?) onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade300)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down),
              items: items.map((String item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader({required IconData icon, required String title}) {
    return Row(
      children: [
        Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: AppColors.primary, size: 24)),
        const SizedBox(width: 12),
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
      ],
    );
  }

  Widget _buildNavigationButtons() {
    return Row(
      children: [
        if (_currentStep > 0)
          Expanded(
            child: OutlinedButton(
              onPressed: () => setState(() => _currentStep--),
              style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), side: BorderSide(color: AppColors.primary), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              child: Text('Back', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
            ),
          ),
        if (_currentStep > 0) const SizedBox(width: 16),
        Expanded(
          flex: _currentStep > 0 ? 1 : 2,
          child: _isSubmitting
              ? const Center(child: LoadingIndicator())
              : ElevatedButton(
            onPressed: _currentStep == 4 ? (_agreedToTerms ? _submitApplication : null) : _nextStep,
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), disabledBackgroundColor: Colors.grey.shade300),
            child: Text(_currentStep == 4 ? 'Submit Application' : 'Continue', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ),
      ],
    );
  }

  void _nextStep() {
    if (_validateCurrentStep()) setState(() => _currentStep++);
  }

  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0:
        if (_vendorNameController.text.isEmpty || _businessNameController.text.isEmpty || _descriptionController.text.isEmpty || _priceRangeController.text.isEmpty) { _showError('Please fill all required fields'); return false; } break;
      case 1:
        if (_ownerNameController.text.isEmpty || _businessPhoneController.text.isEmpty || _businessEmailController.text.isEmpty) { _showError('Please fill all required fields'); return false; } break;
      case 2:
        if (_addressController.text.isEmpty || _cityController.text.isEmpty) { _showError('Please fill all required fields'); return false; } break;
      case 3:
        if (_experienceController.text.isEmpty) { _showError('Please enter your experience'); return false; } break;
    }
    return true;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.red));
  }

  Future<void> _submitApplication() async {
    if (!_agreedToTerms) return _showError('Please agree to the terms');
    setState(() => _isSubmitting = true);

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final user = authProvider.currentUser;
      if (user == null) throw Exception("User not found");

      final firestore = FirebaseFirestore.instance;
      final vendorDocId = user.id;

      final vendorData = {
        'id': vendorDocId,
        'userId': user.id,
        'vendorName': _vendorNameController.text.trim(),
        'businessName': _businessNameController.text.trim(),
        'serviceType': _selectedServiceType,
        'description': _descriptionController.text.trim(),
        'ownerName': _ownerNameController.text.trim(),
        'businessPhone': _businessPhoneController.text.trim(),
        'businessEmail': _businessEmailController.text.trim(),
        'whatsappNumber': _whatsappController.text.trim(),
        'businessAddress': _addressController.text.trim(),
        'city': _cityController.text.trim(),
        'experience': _experienceController.text.trim(),
        'priceRange': _priceRangeController.text.trim(),
        'rating': 0.0,
        'totalEvents': 0,
        'totalReviews': 0,
        'status': 'pending',
        'isApproved': false,
        'appliedDate': FieldValue.serverTimestamp(),
      };

      WriteBatch batch = firestore.batch();
      batch.set(firestore.collection('vendors').doc(vendorDocId), vendorData);
      batch.update(firestore.collection('users').doc(user.id), {'vendorId': vendorDocId, 'vendorStatus': 'pending', 'updatedAt': FieldValue.serverTimestamp()});
      await batch.commit();

      try {
        await firestore.collection('admin_alerts').add({'type': 'new_vendor_application', 'businessName': _businessNameController.text.trim(), 'userId': user.id, 'createdAt': FieldValue.serverTimestamp()});
      } catch (_) {}

      await authProvider.refreshUserData();
      setState(() => _isSubmitting = false);
      if (mounted) _showSuccessDialog();
    } catch (e) {
      setState(() => _isSubmitting = false);
      _showError('Submission failed: ${e.toString()}');
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Success! ✅',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B2F5E),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Your application has been submitted and is under review.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, AppRoutes.vendorApplicationStatus, (route) => false);
                },
                child: Container(
                  width: double.infinity,
                  height: 54,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1B2F5E),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'View Application Status',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
