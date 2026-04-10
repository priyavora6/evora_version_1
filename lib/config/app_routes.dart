import 'package:flutter/material.dart';

// ═══════════════════════════════════════════════════════════════════════════
// AUTH SCREENS
// ═══════════════════════════════════════════════════════════════════════════
import '../screens/auth/change_password_screen.dart';
import '../screens/auth/email_otp_screen.dart';
import '../screens/auth/email_verify_waiting_screen.dart';
import '../screens/auth/verification_gate_screen.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/auth/role_selection_screen.dart';

// ═══════════════════════════════════════════════════════════════════════════
// MAIN & DYNAMIC CATEGORY SCREENS (✅ UPDATED TO NEW ARCHITECTURE)
// ═══════════════════════════════════════════════════════════════════════════
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/cart/cart_screen.dart';
import '../screens/create_event/event_form_screen.dart';
import '../screens/create_event/event_confirmation_screen.dart';

// ✅ New Dynamic Screens Imports
import '../screens/categories/categories_screen.dart';
import '../screens/categories/subcategories_screen.dart';
import '../screens/categories/services_screen.dart';
import '../screens/categories/service_detail_screen.dart';

// ═══════════════════════════════════════════════════════════════════════════
// EVENT DETAIL SCREENS
// ═══════════════════════════════════════════════════════════════════════════
import '../screens/my_events/my_events_screen.dart';
import '../screens/my_events/event_detail_screen.dart';

// ═══════════════════════════════════════════════════════════════════════════
// FEATURE SCREENS
// ═══════════════════════════════════════════════════════════════════════════
import '../screens/guests/add_guest_screen.dart';
import '../screens/guests/guest_list_screen.dart';
import '../screens/guests/event_pass_screen.dart';
import '../screens/guests/qr_scanner_screen.dart';
import '../screens/notifications/notification_screen.dart';
import '../screens/budget/budget_screen.dart';
import '../screens/budget/payment_tracking_screen.dart';
import '../screens/payment/payment_screen.dart';
import '../screens/payment/payment_history_screen.dart';

// ═══════════════════════════════════════════════════════════════════════════
// SETTINGS SCREENS
// ═══════════════════════════════════════════════════════════════════════════
import '../screens/settings/edit_profile_screen.dart';
import '../screens/settings/about_screen.dart';
import '../screens/settings/feedback_screen.dart';
import '../screens/settings/contact_us_screen.dart';
import '../screens/settings/policy_screen.dart';
import '../screens/settings/developers_screen.dart';

// ═══════════════════════════════════════════════════════════════════════════
// VENDOR SCREENS (USER SIDE)
// ═══════════════════════════════════════════════════════════════════════════
import '../screens/vendors/vendor_payment_screen.dart';
import '../screens/vendors/my_vendor_booking_screen.dart';

// ═══════════════════════════════════════════════════════════════════════════
// VENDOR PANEL SCREENS
// ═══════════════════════════════════════════════════════════════════════════
import '../screens/vendor_panel/vendor_main_screen.dart';
import '../screens/vendor_panel/pages/vendor_registration_page.dart';
import '../screens/vendor_panel/pages/vendor_application_status_page.dart';
import '../screens/vendor_panel/pages/event_details_page.dart';
import '../screens/vendor_panel/pages/edit_profile_page.dart';
import '../screens/vendor_panel/pages/vendor_notification_screen.dart';
import '../screens/vendor_panel/pages/vendor_notifications_settings_screen.dart';
import '../screens/vendor_panel/pages/vendor_help_screen.dart';
import '../screens/vendor_panel/pages/vendor_terms_screen.dart';

// Packages
import '../screens/packages/package_detail_screen.dart';

class AppRoutes {
  // Auth Routes
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String changePassword = '/change-password';
  static const String verificationGate = '/verification-gate';
  static const String emailOtpScreen = '/email-otp';
  static const String emailVerifyWaiting = '/email-waiting';
  static const String roleSelection = '/role-selection';

  // Main Routes
  static const String dashboard = '/dashboard';
  static const String categories = '/categories';
  static const String subCategory = '/subcategory';
  static const String service = '/service';
  static const String serviceDetail = '/service-detail'; // ✅ Replaced 'item'
  static const String cart = '/cart';
  static const String eventForm = '/event-form';
  static const String eventConfirmation = '/event-confirmation';

  // Event & Guest Routes
  static const String myEvents = '/my-events';
  static const String eventDetail = '/event-detail';
  static const String addGuest = '/add-guest';
  static const String guestList = '/guest-list';
  static const String eventPass = '/event-pass';
  static const String qrScanner = '/qr-scanner';

  // System Routes
  static const String notifications = '/notifications';
  static const String budget = '/budget';
  static const String paymentTracking = '/payment-tracking';
  static const String payment = '/payment';
  static const String paymentHistory = '/payment-history';

  // Settings
  static const String editProfile = '/edit-profile';
  static const String aboutApp = '/about-app';
  static const String helpSupport = '/help-support';
  static const String privacyPolicy = '/privacy-policy';
  static const String developers = '/developers';
  static const String feedback = '/feedback';

  // Vendor Panel
  static const String vendorMain = '/vendor-main';
  static const String vendorRegistration = '/vendor-registration';
  static const String vendorApplicationStatus = '/vendor-application-status';
  static const String vendorEventDetails = '/vendor-event-details';
  static const String vendorEditProfile = '/vendor-edit-profile';
  static const String vendorNotifications = '/vendor-notifications';
  static const String vendorNotificationsSettings = '/vendor-notifications-settings';
  static const String vendorHelp = '/vendor-help';
  static const String vendorTerms = '/vendor-terms';

  // User Side Vendor
  static const String vendorPayment = '/vendor-payment';
  static const String myVendorBookings = '/my-vendor-bookings';

  // Packages
  static const String packageDetail = '/package-detail';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash: return MaterialPageRoute(builder: (_) => const SplashScreen());
      case onboarding: return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case login: return MaterialPageRoute(builder: (_) => const LoginScreen());
      case register: return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case forgotPassword: return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case changePassword: return MaterialPageRoute(builder: (_) => const ChangePasswordScreen());
      case emailVerifyWaiting: return MaterialPageRoute(builder: (_) => const EmailVerifyWaitingScreen());
      case roleSelection: return MaterialPageRoute(builder: (_) => const RoleSelectionScreen());

      case dashboard: return MaterialPageRoute(builder: (_) => const DashboardScreen());
      case categories: return MaterialPageRoute(builder: (_) => const CategoriesScreen()); // ✅ Updated
      case cart: return MaterialPageRoute(builder: (_) => const CartScreen());
      case eventForm: return MaterialPageRoute(builder: (_) => const EventFormScreen());
      case myEvents: return MaterialPageRoute(builder: (_) => const MyEventsScreen());
      case notifications: return MaterialPageRoute(builder: (_) => const NotificationsScreen());
      case editProfile: return MaterialPageRoute(builder: (_) => const EditProfileScreen());
      case aboutApp: return MaterialPageRoute(builder: (_) => const AboutScreen());
      case helpSupport: return MaterialPageRoute(builder: (_) => const ContactUsScreen());
      case privacyPolicy: return MaterialPageRoute(builder: (_) => const PolicyScreen());
      case developers: return MaterialPageRoute(builder: (_) => const DevelopersScreen());
      case feedback: return MaterialPageRoute(builder: (_) => const FeedbackScreen());

      case vendorMain: return MaterialPageRoute(builder: (_) => const VendorMainScreen());
      case vendorRegistration: return MaterialPageRoute(builder: (_) => const VendorRegistrationPage());
      case vendorApplicationStatus: return MaterialPageRoute(builder: (_) => const VendorApplicationStatusPage());
      case vendorEditProfile: return MaterialPageRoute(builder: (_) => const VendorEditProfilePage());
      case vendorNotifications: return MaterialPageRoute(builder: (_) => const VendorNotificationsScreen());
      case vendorNotificationsSettings: return MaterialPageRoute(builder: (_) => const VendorNotificationSettingsScreen());
      case vendorHelp: return MaterialPageRoute(builder: (_) => const VendorHelpScreen());
      case vendorTerms: return MaterialPageRoute(builder: (_) => const VendorTermsScreen());

      case verificationGate:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(builder: (_) => VerificationGateScreen(email: args?['email'] ?? ''));

      case emailOtpScreen:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => EmailOtpScreen(email: args?['email'] ?? ''),
          settings: settings,
        );

    // ✅ UPDATED DYNAMIC ROUTES
      case subCategory:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(builder: (_) => SubcategoriesScreen(category: args!['category']));

      case service:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(builder: (_) => ServicesScreen(subcategory: args!['subcategory'], category: args['category']));

      case serviceDetail:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(builder: (_) => ServiceDetailScreen(service: args!['service']));

      case eventConfirmation:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(builder: (_) => EventConfirmationScreen(eventId: args?['eventId'] ?? ''));

      case eventDetail:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(builder: (_) => EventDetailScreen(eventId: args?['eventId'] ?? '', initialTab: args?['initialTab'] ?? 0));

      case addGuest:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(builder: (_) => AddGuestScreen(eventId: args?['eventId'] ?? ''));

      case guestList:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(builder: (_) => GuestListScreen(eventId: args?['eventId'] ?? ''));

      case eventPass:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(builder: (_) => GuestPassScreen(eventId: args?['eventId'] ?? '', eventName: args?['eventName'] ?? '', guest: args?['guest']));

      case qrScanner:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(builder: (_) => QrScannerScreen(eventId: args?['eventId'] ?? ''));

      case budget:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(builder: (_) => BudgetScreen(eventId: args?['eventId'] ?? '', totalEstimated: (args?['totalEstimated'] ?? 0.0).toDouble()));

      case paymentTracking:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(builder: (_) => PaymentTrackingScreen(eventId: args?['eventId'] ?? ''));

      case payment:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(builder: (_) => PaymentScreen(
          totalAmount: (args?['totalAmount'] ?? 0.0).toDouble(),
          eventId: args?['eventId']?.toString() ?? '',
          bookingId: args?['bookingId']?.toString() ?? '',
          paymentType: args?['paymentType']?.toString(),
        ));

      case paymentHistory:
        String? eventId;
        if (settings.arguments is String) {
          eventId = settings.arguments as String;
        } else if (settings.arguments is Map<String, dynamic>) {
          eventId = (settings.arguments as Map<String, dynamic>)['eventId'];
        }
        return MaterialPageRoute(builder: (_) => PaymentHistoryScreen(eventId: eventId));

      case vendorPayment:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(builder: (_) => VendorPaymentScreen(bookingId: args?['bookingId'] ?? '', eventId: args?['eventId'] ?? ''));

      case vendorEventDetails:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(builder: (_) => VendorEventDetailsPage(eventId: args?['eventId'] ?? ''));

      case packageDetail:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(builder: (_) => PackageDetailScreen(packageId: args?['packageId'] ?? ''));

      default:
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: Center(child: Text('Route "${settings.name}" not found')),
          ),
        );
    }
  }

  static void navigateTo(BuildContext context, String routeName, {Map<String, dynamic>? arguments, bool replace = false, bool clearStack = false}) {
    if (clearStack) {
      Navigator.pushNamedAndRemoveUntil(context, routeName, (route) => false, arguments: arguments);
    } else if (replace) {
      Navigator.pushReplacementNamed(context, routeName, arguments: arguments);
    } else {
      Navigator.pushNamed(context, routeName, arguments: arguments);
    }
  }

  static void navigateToVendorPanel(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, vendorMain, (route) => false);
  }

  static void navigateToUserDashboard(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, dashboard, (route) => false);
  }

  static void navigateToEventDetail(BuildContext context, String eventId, {int initialTab = 0}) {
    Navigator.pushNamed(context, eventDetail, arguments: {'eventId': eventId, 'initialTab': initialTab});
  }

  static void navigateToVendorEventDetail(BuildContext context, String eventId) {
    Navigator.pushNamed(context, vendorEventDetails, arguments: {'eventId': eventId});
  }
}