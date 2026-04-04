// lib/config/app_routes.dart

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
// MAIN SCREENS
// ═══════════════════════════════════════════════════════════════════════════
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/event_types/event_types_screen.dart';
import '../screens/sections/sections_screen.dart';
import '../screens/cart/cart_screen.dart';
import '../screens/create_event/event_form_screen.dart';
import '../screens/create_event/event_confirmation_screen.dart';

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
// 🆕 VENDOR PANEL SCREENS
// ═══════════════════════════════════════════════════════════════════════════
import '../screens/vendor_panel/vendor_main_screen.dart';
import '../screens/vendor_panel/pages/vendor_registration_page.dart';
import '../screens/vendor_panel/pages/vendor_application_status_page.dart';
import '../screens/vendor_panel/pages/event_details_page.dart';
import '../screens/vendor_panel/pages/edit_profile_page.dart';
import '../screens/vendor_panel/pages/vendor_notification_screen.dart';
import '../screens/vendor_panel/pages/vendor_notifications_settings_screen.dart';

// Packages & Categories
import '../screens/packages/package_screen.dart';
import '../screens/packages/package_detail_screen.dart';
import '../screens/food/food_menu_screen.dart';
import '../screens/sections/marriage/vidhi_screen.dart';
import '../screens/sections/marriage/sangeet_screen.dart';
import '../screens/sections/marriage/photography_screen.dart';
import '../screens/sections/marriage/makeup_screen.dart';
import '../screens/sections/marriage/decoration_screen.dart';
import '../screens/sections/marriage/mehendi_screen.dart';
import '../screens/sections/birthday/cake_screen.dart';
import '../screens/sections/birthday/birthday_decor_screen.dart';
import '../screens/sections/birthday/entertainment_screen.dart';
import '../screens/sections/birthday/return_gifts_screen.dart';
import '../screens/sections/birthday/birthday_photography_screen.dart';
import '../screens/sections/engagement/ring_ceremony_screen.dart';
import '../screens/sections/engagement/engagement_decor_screen.dart';
import '../screens/sections/engagement/engagement_photography_screen.dart';
import '../screens/sections/engagement/engagement_makeup_screen.dart';
import '../screens/sections/engagement/engagement_mehendi_screen.dart';
import '../screens/sections/engagement/engagement_music_screen.dart';
import '../screens/sections/anniversary/anniversary_decor_screen.dart';
import '../screens/sections/anniversary/anniversary_cake_screen.dart';
import '../screens/sections/anniversary/anniversary_photography_screen.dart';
import '../screens/sections/anniversary/anniversary_music_screen.dart';
import '../screens/sections/anniversary/anniversary_gifts_screen.dart';
import '../screens/sections/babyshower/babyshower_decor_screen.dart';
import '../screens/sections/babyshower/babyshower_cake_screen.dart';
import '../screens/sections/babyshower/babyshower_games_screen.dart';
import '../screens/sections/babyshower/babyshower_photography_screen.dart';
import '../screens/sections/babyshower/babyshower_gifts_screen.dart';
import '../screens/sections/corporate/corporate_venue_screen.dart';
import '../screens/sections/corporate/corporate_decor_screen.dart';
import '../screens/sections/corporate/corporate_av_screen.dart';
import '../screens/sections/corporate/corporate_photography_screen.dart';
import '../screens/sections/corporate/corporate_gifts_screen.dart';
import '../screens/sections/corporate/corporate_team_building_screen.dart';
import '../screens/sections/party/party_decor_screen.dart';
import '../screens/sections/party/party_dj_screen.dart';
import '../screens/sections/party/party_photography_screen.dart';
import '../screens/sections/party/party_bar_screen.dart';
import '../screens/sections/party/party_games_screen.dart';
import '../screens/sections/graduation/graduation_decor_screen.dart';
import '../screens/sections/graduation/graduation_cake_screen.dart';
import '../screens/sections/graduation/graduation_photography_screen.dart';
import '../screens/sections/graduation/graduation_gown_screen.dart';
import '../screens/sections/graduation/graduation_gifts_screen.dart';

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
  static const String eventTypes = '/event-types';
  static const String sections = '/sections';
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

  // User Side Vendor
  static const String vendorPayment = '/vendor-payment';
  static const String myVendorBookings = '/my-vendor-bookings';

  // Packages & Food
  static const String packages = '/packages';
  static const String packageDetail = '/package-detail';
  static const String foodMenu = '/food-menu';

  // Marriage Section
  static const String marriageVidhi = '/marriage-vidhi';
  static const String marriageSangeet = '/marriage-sangeet';
  static const String marriagePhotography = '/marriage-photography';
  static const String marriageMakeup = '/marriage-makeup';
  static const String marriageDecor = '/marriage-decor';
  static const String marriageMehendi = '/marriage-mehendi';

  static const String vendorStatus = '/vendor-status';

  // Other constants
  static const String birthdayCake = '/birthday-cake';
  static const String birthdayDecor = '/birthday-decor';
  static const String birthdayEntertainment = '/birthday-entertainment';
  static const String birthdayReturnGifts = '/birthday-return-gifts';
  static const String birthdayPhotography = '/birthday-photography';
  static const String engagementRing = '/engagement-ring';
  static const String engagementDecor = '/engagement-decor';
  static const String engagementPhotography = '/engagement-photography';
  static const String engagementMakeup = '/engagement-makeup';
  static const String engagementMehendi = '/engagement-mehendi';
  static const String engagementMusic = '/engagement-music';
  static const String anniversaryDecor = '/anniversary-decor';
  static const String anniversaryCake = '/anniversary-cake';
  static const String anniversaryPhotography = '/anniversary-photography';
  static const String anniversaryMusic = '/anniversary-music';
  static const String anniversaryGifts = '/anniversary-gifts';
  static const String babyShowerDecor = '/babyshower-decor';
  static const String babyShowerCake = '/babyshower-cake';
  static const String babyShowerGames = '/babyshower-games';
  static const String babyShowerPhotography = '/babyshower-photography';
  static const String babyShowerGifts = '/babyshower-gifts';
  static const String corporateVenue = '/corporate-venue';
  static const String corporateDecor = '/corporate-decor';
  static const String corporateAV = '/corporate-av';
  static const String corporatePhotography = '/corporate-photography';
  static const String corporateGifts = '/corporate-gifts';
  static const String corporateTeamBuilding = '/corporate-team';
  static const String partyDecor = '/party-decor';
  static const String partyDJ = '/party-dj';
  static const String partyPhotography = '/party-photography';
  static const String partyBar = '/party-bar';
  static const String partyGames = '/party-games';
  static const String graduationDecor = '/graduation-decor';
  static const String graduationCake = '/graduation-cake';
  static const String graduationPhotography = '/graduation-photography';
  static const String graduationGown = '/graduation-gown';
  static const String graduationGifts = '/graduation-gifts';

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
      case eventTypes: return MaterialPageRoute(builder: (_) => const EventTypesScreen());
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
      case vendorStatus: return MaterialPageRoute(builder: (_) => const VendorApplicationStatusPage());
      case vendorEditProfile: return MaterialPageRoute(builder: (_) => const VendorEditProfilePage());
      case vendorNotifications: return MaterialPageRoute(builder: (_) => const VendorNotificationsScreen());
      case vendorNotificationsSettings: return MaterialPageRoute(builder: (_) => const VendorNotificationSettingsScreen());

      case foodMenu: return MaterialPageRoute(builder: (_) => const FoodMenuScreen());

      case verificationGate:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(builder: (_) => VerificationGateScreen(email: args?['email'] ?? ''));
      case emailOtpScreen:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => EmailOtpScreen(
            email: args?['email'] ?? '',
          ),
          settings: settings,
        );
      case sections:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(builder: (_) => SectionsScreen(eventTypeId: args?['eventTypeId'] ?? '', eventTypeName: args?['eventTypeName'] ?? ''));
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
      case packages:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(builder: (_) => PackagesScreen(sectionId: args?['sectionId'] ?? '', sectionName: args?['sectionName'] ?? ''));
      case packageDetail:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(builder: (_) => PackageDetailScreen(packageId: args?['packageId'] ?? ''));

      case marriageMehendi: return MaterialPageRoute(builder: (_) => const MarriageMehendiScreen());
      case marriageVidhi: return MaterialPageRoute(builder: (_) => const VidhiScreen());
      case marriageSangeet: return MaterialPageRoute(builder: (_) => const SangeetScreen());
      case marriagePhotography: return MaterialPageRoute(builder: (_) => const PhotographyScreen());
      case marriageMakeup: return MaterialPageRoute(builder: (_) => const MarriageMakeupScreen());
      case marriageDecor: return MaterialPageRoute(builder: (_) => const MarriageDecorScreen());
      case birthdayCake: return MaterialPageRoute(builder: (_) => const CakeScreen());
      case birthdayDecor: return MaterialPageRoute(builder: (_) => const BirthdayDecorScreen());
      case birthdayEntertainment: return MaterialPageRoute(builder: (_) => const EntertainmentScreen());
      case birthdayReturnGifts: return MaterialPageRoute(builder: (_) => const ReturnGiftsScreen());
      case birthdayPhotography: return MaterialPageRoute(builder: (_) => const BirthdayPhotographyScreen());
      case engagementRing: return MaterialPageRoute(builder: (_) => const RingCeremonyScreen());
      case engagementDecor: return MaterialPageRoute(builder: (_) => const EngagementDecorScreen());
      case engagementPhotography: return MaterialPageRoute(builder: (_) => const EngagementPhotographyScreen());
      case engagementMakeup: return MaterialPageRoute(builder: (_) => const EngagementMakeupScreen());
      case engagementMehendi: return MaterialPageRoute(builder: (_) => const EngagementMehendiScreen());
      case engagementMusic: return MaterialPageRoute(builder: (_) => const EngagementMusicScreen());
      case anniversaryDecor: return MaterialPageRoute(builder: (_) => const AnniversaryDecorScreen());
      case anniversaryCake: return MaterialPageRoute(builder: (_) => const AnniversaryCakeScreen());
      case anniversaryPhotography: return MaterialPageRoute(builder: (_) => const AnniversaryPhotographyScreen());
      case anniversaryMusic: return MaterialPageRoute(builder: (_) => const AnniversaryMusicScreen());
      case anniversaryGifts: return MaterialPageRoute(builder: (_) => const AnniversaryGiftsScreen());
      case babyShowerDecor: return MaterialPageRoute(builder: (_) => const BabyShowerDecorScreen());
      case babyShowerCake: return MaterialPageRoute(builder: (_) => const BabyShowerCakeScreen());
      case babyShowerGames: return MaterialPageRoute(builder: (_) => const BabyShowerGamesScreen());
      case babyShowerPhotography: return MaterialPageRoute(builder: (_) => const BabyShowerPhotographyScreen());
      case babyShowerGifts: return MaterialPageRoute(builder: (_) => const BabyShowerGiftsScreen());
      case corporateVenue: return MaterialPageRoute(builder: (_) => const CorporateVenueScreen());
      case corporateDecor: return MaterialPageRoute(builder: (_) => const CorporateDecorScreen());
      case corporateAV: return MaterialPageRoute(builder: (_) => const CorporateAVScreen());
      case corporatePhotography: return MaterialPageRoute(builder: (_) => const CorporatePhotographyScreen());
      case corporateGifts: return MaterialPageRoute(builder: (_) => const CorporateGiftsScreen());
      case corporateTeamBuilding: return MaterialPageRoute(builder: (_) => const CorporateTeamBuildingScreen());
      case partyDecor: return MaterialPageRoute(builder: (_) => const PartyDecorScreen());
      case partyDJ: return MaterialPageRoute(builder: (_) => const PartyDJScreen());
      case partyPhotography: return MaterialPageRoute(builder: (_) => const PartyPhotographyScreen());
      case partyBar: return MaterialPageRoute(builder: (_) => const PartyBarScreen());
      case partyGames: return MaterialPageRoute(builder: (_) => const PartyGamesScreen());
      case graduationDecor: return MaterialPageRoute(builder: (_) => const GraduationDecorScreen());
      case graduationCake: return MaterialPageRoute(builder: (_) => const GraduationCakeScreen());
      case graduationPhotography: return MaterialPageRoute(builder: (_) => const GraduationPhotographyScreen());
      case graduationGown: return MaterialPageRoute(builder: (_) => const GraduationGownScreen());
      case graduationGifts: return MaterialPageRoute(builder: (_) => const GraduationGiftsScreen());

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
