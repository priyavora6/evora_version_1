// lib/screens/vendor_panel/pages/edit_profile_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../config/app_colors.dart';
import '../../../providers/auth_provider.dart';
import '../../../widgets/custom_textfield.dart';
import '../../../widgets/loading_indicator.dart';

class VendorEditProfilePage extends StatefulWidget {
  const VendorEditProfilePage({super.key});

  @override
  State<VendorEditProfilePage> createState() => _VendorEditProfilePageState();
}

class _VendorEditProfilePageState extends State<VendorEditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isSaving = false;

  // Controllers
  late TextEditingController _vendorNameController;
  late TextEditingController _businessNameController;
  late TextEditingController _descriptionController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _whatsappController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _experienceController;
  late TextEditingController _priceRangeController;
  late TextEditingController _websiteController;
  late TextEditingController _instagramController;
  late TextEditingController _facebookController;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadVendorData();
  }

  void _initializeControllers() {
    _vendorNameController = TextEditingController();
    _businessNameController = TextEditingController();
    _descriptionController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _whatsappController = TextEditingController();
    _addressController = TextEditingController();
    _cityController = TextEditingController();
    _experienceController = TextEditingController();
    _priceRangeController = TextEditingController();
    _websiteController = TextEditingController();
    _instagramController = TextEditingController();
    _facebookController = TextEditingController();
  }

  void _loadVendorData() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final vendor = authProvider.currentVendor;

    if (vendor != null) {
      _vendorNameController.text = vendor.vendorName;
      _businessNameController.text = vendor.businessName;
      _descriptionController.text = vendor.description;
      _phoneController.text = vendor.businessPhone;
      _emailController.text = vendor.businessEmail;
      _whatsappController.text = vendor.whatsappNumber ?? '';
      _addressController.text = vendor.businessAddress;
      _cityController.text = vendor.city;
      _experienceController.text = vendor.experience;
      _priceRangeController.text = vendor.priceRange;
      _websiteController.text = vendor.websiteUrl ?? '';
      _instagramController.text = vendor.instagramHandle ?? '';
      _facebookController.text = vendor.facebookUrl ?? '';
    }
  }

  @override
  void dispose() {
    _vendorNameController.dispose();
    _businessNameController.dispose();
    _descriptionController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _whatsappController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _experienceController.dispose();
    _priceRangeController.dispose();
    _websiteController.dispose();
    _instagramController.dispose();
    _facebookController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: const Text('Edit Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _saveProfile,
            child: _isSaving
                ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
                : const Text(
              'Save',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Business Info Section
              _buildSectionHeader(Icons.business, 'Business Information'),
              const SizedBox(height: 16),

              CustomTextField(
                controller: _vendorNameController,
                label: 'Vendor Name',
                hint: 'Your display name',
                prefixIcon: Icons.person_pin_outlined,
              ),
              const SizedBox(height: 16),

              CustomTextField(
                controller: _businessNameController,
                label: 'Business Name',
                hint: 'Your business name',
                prefixIcon: Icons.store_outlined,
              ),
              const SizedBox(height: 16),

              CustomTextField(
                controller: _descriptionController,
                label: 'Description',
                hint: 'Describe your services...',
                prefixIcon: Icons.description_outlined,
                maxLines: 4,
              ),
              const SizedBox(height: 16),

              CustomTextField(
                controller: _priceRangeController,
                label: 'Price Range',
                hint: 'e.g. ₹15,000 - ₹50,000',
                prefixIcon: Icons.currency_rupee,
              ),
              const SizedBox(height: 16),

              CustomTextField(
                controller: _experienceController,
                label: 'Years of Experience',
                hint: 'e.g. 5',
                prefixIcon: Icons.calendar_today_outlined,
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 30),

              // Contact Section
              _buildSectionHeader(Icons.contact_phone, 'Contact Details'),
              const SizedBox(height: 16),

              CustomTextField(
                controller: _phoneController,
                label: 'Business Phone',
                hint: '10-digit number',
                prefixIcon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),

              CustomTextField(
                controller: _emailController,
                label: 'Business Email',
                hint: 'contact@business.com',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              CustomTextField(
                controller: _whatsappController,
                label: 'WhatsApp Number',
                hint: 'Optional',
                prefixIcon: Icons.message_outlined,
                keyboardType: TextInputType.phone,
              ),

              const SizedBox(height: 30),

              // Location Section
              _buildSectionHeader(Icons.location_on, 'Location'),
              const SizedBox(height: 16),

              CustomTextField(
                controller: _addressController,
                label: 'Business Address',
                hint: 'Full address',
                prefixIcon: Icons.home_outlined,
                maxLines: 2,
              ),
              const SizedBox(height: 16),

              CustomTextField(
                controller: _cityController,
                label: 'City',
                hint: 'e.g. Mumbai',
                prefixIcon: Icons.location_city_outlined,
              ),

              const SizedBox(height: 30),

              // Social Links Section
              _buildSectionHeader(Icons.link, 'Social Links'),
              const SizedBox(height: 16),

              CustomTextField(
                controller: _websiteController,
                label: 'Website URL',
                hint: 'https://www.yourbusiness.com',
                prefixIcon: Icons.language,
              ),
              const SizedBox(height: 16),

              CustomTextField(
                controller: _instagramController,
                label: 'Instagram Handle',
                hint: '@yourbusiness',
                prefixIcon: Icons.camera_alt_outlined,
              ),
              const SizedBox(height: 16),

              CustomTextField(
                controller: _facebookController,
                label: 'Facebook Page',
                hint: 'https://facebook.com/yourbusiness',
                prefixIcon: Icons.facebook,
              ),

              const SizedBox(height: 40),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isSaving
                      ? const LoadingIndicator()
                      : const Text(
                    'Save Changes',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Future<void> _saveProfile() async {
    setState(() => _isSaving = true);

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final vendorId = authProvider.currentVendor?.id;

      if (vendorId == null) {
        throw Exception('Vendor not found');
      }

      await FirebaseFirestore.instance
          .collection('vendors')
          .doc(vendorId)
          .update({
        'vendorName': _vendorNameController.text.trim(),
        'businessName': _businessNameController.text.trim(),
        'description': _descriptionController.text.trim(),
        'businessPhone': _phoneController.text.trim(),
        'businessEmail': _emailController.text.trim(),
        'whatsappNumber': _whatsappController.text.trim(),
        'businessAddress': _addressController.text.trim(),
        'city': _cityController.text.trim(),
        'experience': _experienceController.text.trim(),
        'priceRange': _priceRangeController.text.trim(),
        'websiteUrl': _websiteController.text.trim(),
        'instagramHandle': _instagramController.text.trim(),
        'facebookUrl': _facebookController.text.trim(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Refresh vendor data
      await authProvider.updateVendorData();

      setState(() => _isSaving = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() => _isSaving = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
