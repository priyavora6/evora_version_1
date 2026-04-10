// lib/screens/my_events/tabs/professionals_tab.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../config/app_colors.dart';

class ProfessionalsTab extends StatefulWidget {
  final String eventId;
  final String eventName;

  const ProfessionalsTab({
    super.key,
    required this.eventId,
    required this.eventName,
  });

  @override
  State<ProfessionalsTab> createState() => _ProfessionalsTabState();
}

class _ProfessionalsTabState extends State<ProfessionalsTab> {
  // ═══════════════════════════════════════════════════════════════════════
  // 📋 SERVICE TYPES LIST
  // ═══════════════════════════════════════════════════════════════════════
  final List<Map<String, dynamic>> _serviceTypes = [
    {'name': 'Photography', 'icon': Icons.camera_alt_outlined},
    {'name': 'Videography', 'icon': Icons.videocam_outlined},
    {'name': 'Catering', 'icon': Icons.restaurant_menu},
    {'name': 'Decoration', 'icon': Icons.auto_awesome_mosaic_outlined},
    {'name': 'Makeup Artist', 'icon': Icons.face_retouching_natural},
    {'name': 'Mehendi', 'icon': Icons.front_hand},
    {'name': 'DJ & Music', 'icon': Icons.music_note},
    {'name': 'Anchor/Host', 'icon': Icons.mic},
    {'name': 'Choreographer', 'icon': Icons.directions_run},
    {'name': 'Florist', 'icon': Icons.local_florist},
    {'name': 'Transportation', 'icon': Icons.directions_car},
    {'name': 'Invitation Cards', 'icon': Icons.mail_outline},
    {'name': 'Pandit/Priest', 'icon': Icons.temple_hindu},
    {'name': 'Security', 'icon': Icons.security},
    {'name': 'Other', 'icon': Icons.more_horiz},
  ];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('userEvents')
          .doc(widget.eventId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Center(child: Text("Event not found"));
        }

        final eventData = snapshot.data!.data() as Map<String, dynamic>;
        final List<dynamic> professionals = eventData['ownProfessionals'] ?? [];

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Info Card
            _buildInfoCard(),
            const SizedBox(height: 20),

            // Add Professional Button
            _buildAddButton(context),
            const SizedBox(height: 20),

            // Professionals Count Header
            if (professionals.isNotEmpty) ...[
              _buildHeader(professionals.length),
              const SizedBox(height: 16),
            ],

            // Professionals List
            if (professionals.isEmpty)
              _buildEmptyState()
            else
              ...professionals.asMap().entries.map((entry) {
                final index = entry.key;
                final professional = entry.value as Map<String, dynamic>;
                return _buildProfessionalCard(
                  context,
                  professional,
                  index,
                );
              }).toList(),

            const SizedBox(height: 20),
          ],
        );
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // 📌 INFO CARD
  // ═══════════════════════════════════════════════════════════════════════
  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.shade600,
            Colors.blue.shade400,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.white, size: 22),
              SizedBox(width: 10),
              Text(
                "Your Own Professionals",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            "Add details of vendors you've hired personally. "
            "This helps you keep track of all professionals for your event.",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // ➕ ADD BUTTON
  // ═══════════════════════════════════════════════════════════════════════
  Widget _buildAddButton(BuildContext context) {
    return InkWell(
      onTap: () => _showAddEditDialog(context),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.primary,
            style: BorderStyle.solid,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle_outline, color: AppColors.primary, size: 24),
            const SizedBox(width: 10),
            Text(
              "Add Your Professional",
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // 📊 HEADER
  // ═══════════════════════════════════════════════════════════════════════
  Widget _buildHeader(int count) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.people_alt, color: Colors.green, size: 22),
          const SizedBox(width: 12),
          Text(
            "$count Professional${count > 1 ? 's' : ''} Added",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // 📟 EMPTY STATE
  // ═══════════════════════════════════════════════════════════════════════
  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_add_alt_1_outlined,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 20),
          const Text(
            "No Professionals Added Yet",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Add the vendors you've personally hired\n"
            "to keep all your event details in one place.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade600,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // 🎴 PROFESSIONAL CARD
  // ═══════════════════════════════════════════════════════════════════════
  Widget _buildProfessionalCard(
    BuildContext context,
    Map<String, dynamic> data,
    int index,
  ) {
    final String name = data['name'] ?? 'Professional';
    final String serviceType = data['serviceType'] ?? 'Service';
    final String phone = data['phone'] ?? '';
    final String? instagram = data['instagram'];
    final double? cost = data['estimatedCost'] != null
        ? (data['estimatedCost'] as num).toDouble()
        : null;
    final String? notes = data['notes'];
    final bool isConfirmed = data['isConfirmed'] ?? false;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(
          color: isConfirmed ? Colors.green.shade300 : Colors.grey.shade200,
          width: isConfirmed ? 1.5 : 1,
        ),
      ),
      child: Column(
        children: [
          // Main Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Top Row - Icon, Name, Price
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Service Icon
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _getIcon(serviceType),
                        color: AppColors.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 15),

                    // Name & Service Type
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            serviceType.toUpperCase(),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade600,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Cost
                    if (cost != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "₹${cost.toStringAsFixed(0)}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            "estimated",
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),

                const Divider(height: 24),

                // Contact Info Row
                Row(
                  children: [
                    // Phone
                    if (phone.isNotEmpty)
                      Expanded(
                        child: Row(
                          children: [
                            Icon(
                              Icons.phone_outlined,
                              size: 16,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              phone,
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Instagram
                    if (instagram != null && instagram.isNotEmpty)
                      Row(
                        children: [
                          const Icon(
                            Icons.camera_alt_outlined,
                            size: 16,
                            color: Colors.purple,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            instagram,
                            style: const TextStyle(
                              color: Colors.purple,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),

                // Notes
                if (notes != null && notes.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.note_outlined,
                          size: 16,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            notes,
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 12,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // Confirmation Status
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isConfirmed
                            ? Colors.green.withOpacity(0.1)
                            : Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isConfirmed
                                ? Icons.check_circle
                                : Icons.schedule,
                            size: 14,
                            color: isConfirmed ? Colors.green : Colors.orange,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isConfirmed ? 'Confirmed' : 'Pending',
                            style: TextStyle(
                              color: isConfirmed ? Colors.green : Colors.orange,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Toggle Confirmation
                    TextButton.icon(
                      onPressed: () => _toggleConfirmation(index, !isConfirmed),
                      icon: Icon(
                        isConfirmed
                            ? Icons.remove_circle_outline
                            : Icons.check_circle_outline,
                        size: 18,
                      ),
                      label: Text(
                        isConfirmed ? 'Unconfirm' : 'Mark Confirmed',
                        style: const TextStyle(fontSize: 12),
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor:
                            isConfirmed ? Colors.grey : Colors.green,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Action Buttons Footer
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(15),
              ),
            ),
            child: Row(
              children: [
                // Call Button
                if (phone.isNotEmpty)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _makeCall(phone),
                      icon: const Icon(Icons.phone, size: 18),
                      label: const Text('Call'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.green,
                        side: const BorderSide(color: Colors.green),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),

                if (phone.isNotEmpty) const SizedBox(width: 10),

                // Edit Button
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showAddEditDialog(
                      context,
                      existingData: data,
                      editIndex: index,
                    ),
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    label: const Text('Edit'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.blue,
                      side: const BorderSide(color: Colors.blue),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                // Delete Button
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _confirmDelete(context, index, name),
                    icon: const Icon(Icons.delete_outline, size: 18),
                    label: const Text('Remove'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // 📝 ADD / EDIT DIALOG
  // ═══════════════════════════════════════════════════════════════════════
  void _showAddEditDialog(
    BuildContext context, {
    Map<String, dynamic>? existingData,
    int? editIndex,
  }) {
    final bool isEditing = existingData != null;

    // Controllers
    final nameController = TextEditingController(
      text: existingData?['name'] ?? '',
    );
    final phoneController = TextEditingController(
      text: existingData?['phone'] ?? '',
    );
    final instagramController = TextEditingController(
      text: existingData?['instagram'] ?? '',
    );
    final costController = TextEditingController(
      text: existingData?['estimatedCost']?.toString() ?? '',
    );
    final notesController = TextEditingController(
      text: existingData?['notes'] ?? '',
    );

    String selectedService = existingData?['serviceType'] ?? 'Photography';
    bool isConfirmed = existingData?['isConfirmed'] ?? false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Icon(
                      isEditing ? Icons.edit : Icons.person_add,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      isEditing ? "Edit Professional" : "Add Professional",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),

              const Divider(height: 0),

              // Form
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Service Type Dropdown
                      const Text(
                        "Service Type *",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedService,
                            isExpanded: true,
                            items: _serviceTypes.map((service) {
                              return DropdownMenuItem<String>(
                                value: service['name'],
                                child: Row(
                                  children: [
                                    Icon(
                                      service['icon'],
                                      size: 20,
                                      color: AppColors.primary,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(service['name']),
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setModalState(() {
                                selectedService = value!;
                              });
                            },
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Professional Name
                      const Text(
                        "Professional / Business Name *",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: nameController,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          hintText: "e.g. Vishal Studios",
                          prefixIcon: const Icon(Icons.person_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Phone Number
                      const Text(
                        "Phone Number *",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: "+91-9876543210",
                          prefixIcon: const Icon(Icons.phone_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Instagram Handle (Optional)
                      const Text(
                        "Instagram Handle (Optional)",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: instagramController,
                        decoration: InputDecoration(
                          hintText: "@username",
                          prefixIcon: const Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.purple,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Estimated Cost (Optional)
                      const Text(
                        "Estimated Cost (Optional)",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: costController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "e.g. 25000",
                          prefixIcon: const Icon(Icons.currency_rupee),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Notes (Optional)
                      const Text(
                        "Notes (Optional)",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: notesController,
                        maxLines: 3,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          hintText: "Any special requirements or notes...",
                          prefixIcon: const Padding(
                            padding: EdgeInsets.only(bottom: 50),
                            child: Icon(Icons.note_outlined),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Confirmation Toggle
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isConfirmed
                                  ? Icons.check_circle
                                  : Icons.schedule,
                              color: isConfirmed ? Colors.green : Colors.orange,
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text(
                                "Booking Confirmed",
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ),
                            Switch(
                              value: isConfirmed,
                              activeColor: Colors.green,
                              onChanged: (value) {
                                setModalState(() {
                                  isConfirmed = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),

              // Save Button
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Validation
                      if (nameController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please enter professional name'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      if (phoneController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please enter phone number'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      // Create professional data
                      final professionalData = {
                        'name': nameController.text.trim(),
                        'serviceType': selectedService,
                        'phone': phoneController.text.trim(),
                        'instagram': instagramController.text.trim().isNotEmpty
                            ? instagramController.text.trim()
                            : null,
                        'estimatedCost': costController.text.trim().isNotEmpty
                            ? double.tryParse(costController.text.trim())
                            : null,
                        'notes': notesController.text.trim().isNotEmpty
                            ? notesController.text.trim()
                            : null,
                        'isConfirmed': isConfirmed,
                        'addedAt': FieldValue.serverTimestamp(),
                      };

                      if (isEditing && editIndex != null) {
                        _updateProfessional(editIndex, professionalData);
                      } else {
                        _addProfessional(professionalData);
                      }

                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      isEditing ? "Update Professional" : "Add Professional",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
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

  // ═══════════════════════════════════════════════════════════════════════
  // 🗑️ CONFIRM DELETE
  // ═══════════════════════════════════════════════════════════════════════
  void _confirmDelete(BuildContext context, int index, String name) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red),
            SizedBox(width: 10),
            Text("Remove Professional"),
          ],
        ),
        content: Text(
          'Are you sure you want to remove "$name" from your professionals list?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _removeProfessional(index);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text("Remove"),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════
  // 📤 FIRESTORE OPERATIONS
  // ═══════════════════════════════════════════════════════════════════════

  // Add Professional
  Future<void> _addProfessional(Map<String, dynamic> data) async {
    try {
      await FirebaseFirestore.instance
          .collection('userEvents')
          .doc(widget.eventId)
          .update({
        'ownProfessionals': FieldValue.arrayUnion([data]),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Professional added successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding professional: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Update Professional
  Future<void> _updateProfessional(
    int index,
    Map<String, dynamic> newData,
  ) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('userEvents')
          .doc(widget.eventId)
          .get();

      if (!doc.exists) return;

      final List<dynamic> professionals =
          List.from(doc.data()?['ownProfessionals'] ?? []);

      if (index < professionals.length) {
        professionals[index] = newData;

        await FirebaseFirestore.instance
            .collection('userEvents')
            .doc(widget.eventId)
            .update({'ownProfessionals': professionals});

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Professional updated successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating professional: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Remove Professional
  Future<void> _removeProfessional(int index) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('userEvents')
          .doc(widget.eventId)
          .get();

      if (!doc.exists) return;

      final List<dynamic> professionals =
          List.from(doc.data()?['ownProfessionals'] ?? []);

      if (index < professionals.length) {
        professionals.removeAt(index);

        await FirebaseFirestore.instance
            .collection('userEvents')
            .doc(widget.eventId)
            .update({'ownProfessionals': professionals});

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Professional removed successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error removing professional: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Toggle Confirmation Status
  Future<void> _toggleConfirmation(int index, bool confirmed) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('userEvents')
          .doc(widget.eventId)
          .get();

      if (!doc.exists) return;

      final List<dynamic> professionals =
          List.from(doc.data()?['ownProfessionals'] ?? []);

      if (index < professionals.length) {
        professionals[index]['isConfirmed'] = confirmed;

        await FirebaseFirestore.instance
            .collection('userEvents')
            .doc(widget.eventId)
            .update({'ownProfessionals': professionals});
      }
    } catch (e) {
      debugPrint('Error toggling confirmation: $e');
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  // 📞 MAKE CALL
  // ═══════════════════════════════════════════════════════════════════════
  void _makeCall(String phone) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not make call')),
        );
      }
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  // 🎨 GET ICON
  // ═══════════════════════════════════════════════════════════════════════
  IconData _getIcon(String type) {
    for (var service in _serviceTypes) {
      if (service['name'].toString().toLowerCase() == type.toLowerCase()) {
        return service['icon'];
      }
    }
    return Icons.business_center_outlined;
  }
}
