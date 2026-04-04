// lib/screens/events/event_form_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../config/app_colors.dart';
import '../../config/app_routes.dart';
import '../../config/app_strings.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/user_event_provider.dart';
import '../../services/user_event_service.dart';
import '../../models/user_event_model.dart';
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
  bool _isCheckingDate = false;
  List<UserEvent> _existingEventsOnDate = [];

  final UserEventService _eventService = UserEventService();

  @override
  void initState() {
    super.initState();
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    _guestCountController.text = cartProvider.guestCount.toString();
    _checkDateAvailability(_selectedDate);
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

  // ═══════════════════════════════════════════════════════════════════════
  // 📅 CHECK DATE AVAILABILITY
  // ═══════════════════════════════════════════════════════════════════════
  Future<void> _checkDateAvailability(DateTime date) async {
    setState(() => _isCheckingDate = true);

    try {
      final events = await _eventService.getEventsOnDate(date);
      if (mounted) {
        setState(() {
          _existingEventsOnDate = events;
          _isCheckingDate = false;
        });
      }
    } catch (e) {
      debugPrint('Error checking date availability: $e');
      if (mounted) {
        setState(() => _isCheckingDate = false);
      }
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  // 📅 SELECT DATE
  // ═══════════════════════════════════════════════════════════════════════
  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 730)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: AppColors.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
      _checkDateAvailability(picked);
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  // ⏰ SELECT TIME
  // ═══════════════════════════════════════════════════════════════════════
  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(primary: AppColors.primary),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  // ═══════════════════════════════════════════════════════════════════════
  // ✅ CREATE EVENT
  // ═══════════════════════════════════════════════════════════════════════
  Future<void> _createEvent() async {
    if (!_formKey.currentState!.validate()) return;

    // Check for date conflicts
    if (_existingEventsOnDate.isNotEmpty) {
      final proceed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Date Busy!"),
          content: const Text(
            "There are already events scheduled for this day. Do you want to proceed anyway?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text("Book Anyway"),
            ),
          ],
        ),
      );

      if (proceed != true) return;
    }

    setState(() => _isLoading = true);

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final userEventProvider = Provider.of<UserEventProvider>(context, listen: false);

    // Get user info
    final user = authProvider.currentUser;
    if (user == null) {
      setState(() => _isLoading = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please login to book event")),
      );
      return;
    }

    // Parse guest count and budget
    final guestCount = int.tryParse(_guestCountController.text) ?? 100;
    final budget = double.tryParse(_budgetController.text) ?? 0.0;

    // Update cart guest count
    cartProvider.setGuestCount(guestCount);

    try {
      // Create event with all required fields
      final eventId = await userEventProvider.createEvent(
        userId: user.id,
        userName: user.name,
        userPhone: user.phone,
        userEmail: user.email,
        eventTypeId: cartProvider.selectedEventTypeId ?? 'custom',
        eventTypeName: cartProvider.selectedEventTypeName ?? 'Custom Event',
        eventName: _eventNameController.text.trim(),
        description: _descriptionController.text.trim(),
        eventDate: _selectedDate,
        eventTime: _selectedTime.format(context),
        location: _locationController.text.trim(),
        venue: _venueController.text.trim(),
        city: _cityController.text.trim(),
        guestCount: guestCount,
        estimatedBudget: budget,
        totalEstimatedCost: cartProvider.totalPrice,
        selectedItems: cartProvider.items, // ✅ Added missing required parameter
      );

      setState(() => _isLoading = false);

      if (eventId != null && mounted) {
        // Clear cart
        cartProvider.clearCart();

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Event booking request submitted successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate to confirmation
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.eventConfirmation,
          arguments: {'eventId': eventId},
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(userEventProvider.error ?? 'Failed to create event'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Event'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.primary.withOpacity(0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Consumer<CartProvider>(
                  builder: (context, cart, _) => Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            cart.selectedEventTypeName ?? 'Event',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '${AppStrings.rupee}${cart.totalPrice.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      if (cart.items.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        const Divider(color: Colors.white24),
                        const SizedBox(height: 5),
                        Text(
                          '${cart.items.length} service(s) selected',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Event Details Section
              const Text(
                'Event Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 15),

              // Event Name
              CustomTextField(
                controller: _eventNameController,
                label: 'Event Name *',
                hint: "e.g. John's Birthday Party",
                prefixIcon: Icons.celebration_outlined,
                validator: Validators.validateRequired,
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 20),

              // Description
              CustomTextField(
                controller: _descriptionController,
                label: 'Description',
                hint: 'Brief description of your event',
                prefixIcon: Icons.description_outlined,
                maxLines: 3,
              ),
              const SizedBox(height: 20),

              // Date & Time
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: _selectDate,
                      child: AbsorbPointer(
                        child: CustomTextField(
                          controller: TextEditingController(
                            text: DateFormat('dd MMM yyyy').format(_selectedDate),
                          ),
                          label: 'Event Date *',
                          prefixIcon: Icons.calendar_today,
                          readOnly: true,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: _selectTime,
                      child: AbsorbPointer(
                        child: CustomTextField(
                          controller: TextEditingController(
                            text: _selectedTime.format(context),
                          ),
                          label: 'Time *',
                          prefixIcon: Icons.access_time,
                          readOnly: true,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Date Availability Check
              const SizedBox(height: 10),
              if (_isCheckingDate)
                const Padding(
                  padding: EdgeInsets.only(left: 4.0),
                  child: Text(
                    "Checking availability...",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                )
              else if (_existingEventsOnDate.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.orange),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.warning, color: Colors.orange, size: 18),
                          SizedBox(width: 8),
                          Text(
                            "Events already booked on this day:",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ..._existingEventsOnDate.map(
                            (e) => Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Text(
                            "• ${e.eventName} (${e.eventTypeName})",
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              else
                const Padding(
                  padding: EdgeInsets.only(left: 4.0),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, size: 16, color: Colors.green),
                      SizedBox(width: 5),
                      Text(
                        "Date available!",
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 30),

              // Venue Details Section
              const Text(
                'Venue Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 15),

              // Venue Name
              CustomTextField(
                controller: _venueController,
                label: 'Venue Name *',
                hint: 'e.g. Grand Ballroom',
                prefixIcon: Icons.business_outlined,
                validator: Validators.validateRequired,
              ),
              const SizedBox(height: 20),

              // Location Address
              CustomTextField(
                controller: _locationController,
                label: 'Address *',
                hint: 'Full venue address',
                prefixIcon: Icons.location_on_outlined,
                validator: Validators.validateRequired,
                maxLines: 2,
              ),
              const SizedBox(height: 20),

              // City
              CustomTextField(
                controller: _cityController,
                label: 'City *',
                hint: 'e.g. Mumbai',
                prefixIcon: Icons.location_city_outlined,
                validator: Validators.validateRequired,
              ),

              const SizedBox(height: 30),

              // Guest & Budget Section
              const Text(
                'Guest & Budget',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 15),

              // Guest Count
              CustomTextField(
                controller: _guestCountController,
                label: 'Expected Guests *',
                hint: 'Number of guests',
                prefixIcon: Icons.people_outline,
                keyboardType: TextInputType.number,
                validator: Validators.validateNumber,
              ),
              const SizedBox(height: 20),

              // Budget
              CustomTextField(
                controller: _budgetController,
                label: 'Your Budget',
                hint: 'Approximate budget in ₹',
                prefixIcon: Icons.currency_rupee,
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 40),

              // Submit Button
              _isLoading
                  ? const Center(
                child: Column(
                  children: [
                    LoadingIndicator(),
                    SizedBox(height: 10),
                    Text(
                      'Submitting your booking request...',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              )
                  : CustomButton(
                text: 'Request Booking',
                onPressed: _createEvent,
              ),

              const SizedBox(height: 20),

              // Info Note
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue, size: 20),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Your booking request will be reviewed by our team. You will be notified once approved.',
                        style: TextStyle(fontSize: 12, color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}