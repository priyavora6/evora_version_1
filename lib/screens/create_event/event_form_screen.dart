import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../config/app_colors.dart';
import '../../config/app_routes.dart';
import '../../config/app_strings.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/user_event_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/loading_indicator.dart';
import '../../utils/validators.dart';

class EventFormScreen extends StatefulWidget {
  const EventFormScreen({super.key});

  @override
  State<EventFormScreen> createState() => _EventFormScreenState();
}

class _EventFormScreenState extends State<EventFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _eventNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _venueController = TextEditingController();
  final _cityController = TextEditingController();
  final _guestCountController = TextEditingController();
  final _budgetController = TextEditingController();

  // State
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 30));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 10, minute: 0);
  bool _isLoading = false;
  String _vendorPreference = 'platform'; 

  @override
  void initState() {
    super.initState();
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    _guestCountController.text = cartProvider.guestCount.toString();
  }

  @override
  void dispose() {
    _eventNameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _venueController.dispose();
    _cityController.dispose();
    _guestCountController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 730)),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  Future<void> _createEvent() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final userEventProvider = Provider.of<UserEventProvider>(context, listen: false);

    final user = authProvider.user; // ✅ Get user from your AuthProvider
    if (user == null) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please login first")));
      return;
    }

    try {
      final eventId = await userEventProvider.createEvent(
        userId: user.id,
        userName: user.name,
        userPhone: user.phone,
        userEmail: user.email,
        eventTypeId: cartProvider.selectedEventTypeId ?? 'custom',
        eventTypeName: cartProvider.selectedEventTypeName ?? 'Event',
        eventName: _eventNameController.text.trim(),
        description: _descriptionController.text.trim(),
        eventDate: _selectedDate,
        eventTime: _selectedTime.format(context),
        location: _locationController.text.trim(),
        venue: _venueController.text.trim(),
        city: _cityController.text.trim(),
        guestCount: int.parse(_guestCountController.text),
        estimatedBudget: double.tryParse(_budgetController.text) ?? 0.0,
        totalEstimatedCost: cartProvider.totalPrice,
        selectedItems: cartProvider.items, // ✅ Simplified now that models are unified
        vendorPreference: _vendorPreference,
        wantsPlatformVendors: _vendorPreference == 'platform',
        usesOwnVendors: _vendorPreference == 'own',
      );

      if (eventId != null) {
        cartProvider.clearCart();
        Navigator.pushReplacementNamed(context, AppRoutes.eventConfirmation, arguments: {'eventId': eventId});
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final bool isUserAVendor = authProvider.isVendor;

    return Scaffold(
      appBar: AppBar(title: const Text('Book Event')),
      body: _isLoading 
        ? const Center(child: LoadingIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSummaryCard(),
                  const SizedBox(height: 30),
                  _buildSectionTitle('Event Details'),
                  const SizedBox(height: 15),
                  CustomTextField(
                    controller: _eventNameController,
                    label: 'Event Name *',
                    hint: "e.g. My Wedding",
                    prefixIcon: Icons.celebration,
                    validator: Validators.validateRequired,
                  ),
                  const SizedBox(height: 15),
                  CustomTextField(
                    controller: _guestCountController,
                    label: 'No. of Guests *',
                    hint: "e.g. 200",
                    prefixIcon: Icons.people,
                    keyboardType: TextInputType.number,
                    validator: Validators.validateRequired,
                  ),
                  const SizedBox(height: 15),
                  CustomTextField(
                    controller: _locationController,
                    label: 'Location / Address *',
                    hint: "e.g. 123 Street, Area",
                    prefixIcon: Icons.location_on,
                    validator: Validators.validateRequired,
                  ),
                  const SizedBox(height: 20),
                  _buildDateTimeRow(),
                  const SizedBox(height: 30),
                  _buildSectionTitle('Venue Details'),
                  const SizedBox(height: 15),
                  CustomTextField(controller: _venueController, label: 'Venue Name *', validator: Validators.validateRequired),
                  const SizedBox(height: 15),
                  CustomTextField(controller: _cityController, label: 'City *', validator: Validators.validateRequired),
                  const SizedBox(height: 30),
                  _buildSectionTitle('Vendor Preference'),
                  _buildVendorOption('platform', 'Evora Vendors', Icons.verified_user),
                  
                  // 🛡️ Admin Vendor Deal Info
                  if (isUserAVendor && _vendorPreference == 'platform')
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.blue.shade700, size: 20),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'As an Evora Professional, selecting "Evora Vendors" means you cannot provide your own services for this event. Payments will be handled via Admin-Vendor deal.',
                              style: TextStyle(fontSize: 12, color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                    ),

                  _buildVendorOption('own', 'Own Vendors', Icons.people),
                  const SizedBox(height: 40),
                  CustomButton(text: 'Request Booking', onPressed: _createEvent),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildSummaryCard() {
    return Consumer<CartProvider>(
      builder: (context, cart, _) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(16)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(cart.selectedEventTypeName ?? 'Event Summary', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            Text('₹${cart.totalPrice.toStringAsFixed(0)}', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildDateTimeRow() {
    return Row(
      children: [
        Expanded(child: ListTile(title: const Text("Date"), subtitle: Text(DateFormat('dd MMM yyyy').format(_selectedDate)), onTap: _selectDate, tileColor: Colors.grey.shade100)),
        const SizedBox(width: 10),
        Expanded(child: ListTile(title: const Text("Time"), subtitle: Text(_selectedTime.format(context)), onTap: _selectTime, tileColor: Colors.grey.shade100)),
      ],
    );
  }

  Widget _buildVendorOption(String value, String title, IconData icon) {
    return RadioListTile(
      value: value,
      groupValue: _vendorPreference,
      onChanged: (val) => setState(() => _vendorPreference = val.toString()),
      title: Text(title),
      secondary: Icon(icon, color: AppColors.primary),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold));
  }
}
