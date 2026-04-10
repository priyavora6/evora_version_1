import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

// Config & Services
import 'firebase_options.dart';
import 'config/app_theme.dart';
import 'config/app_routes.dart';
import 'services/notification_service.dart';

// Screens
import 'screens/splash/splash_screen.dart';

// Providers
import 'providers/auth_provider.dart';
import 'providers/category_provider.dart';
import 'providers/user_event_provider.dart';
import 'providers/vendor_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/guest_provider.dart';
import 'providers/budget_provider.dart';
import 'providers/task_provider.dart';
import 'providers/notification_provider.dart';
import 'providers/payment_provider.dart';
import 'providers/vendor_panel_provider.dart';
import 'providers/review_provider.dart';

// 🛰️ TOP-LEVEL BACKGROUND HANDLER (Define only here)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint("🌙 Handling background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 0. Load Environment Variables
  await dotenv.load(fileName: ".env");

  // 1. Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 2. Initialize Stripe ONLY IF NOT ON WEB
  if (!kIsWeb) {
    Stripe.publishableKey = dotenv.get('STRIPE_PUBLISHABLE_KEY', fallback: "");
    await Stripe.instance.applySettings();
  }

  // 3. Setup Background Messaging (ONLY HERE)
  if (!kIsWeb) {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  // 4. Initialize Notification Service
  await NotificationService().init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => UserEventProvider()),
        ChangeNotifierProvider(create: (_) => VendorProvider()),
        ChangeNotifierProvider(create: (_) => VendorPanelProvider()),
        ChangeNotifierProvider(create: (_) => ReviewProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => GuestProvider()),
        ChangeNotifierProvider(create: (_) => BudgetProvider()),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => PaymentProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      child: MaterialApp(
        title: 'EVORA',
        debugShowCheckedModeBanner: false,
        navigatorKey: NotificationService.navigatorKey,
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
        onGenerateRoute: AppRoutes.generateRoute,
        builder: (context, child) {
          if (child == null) return const SizedBox.shrink();
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
            child: child,
          );
        },
      ),
    );
  }
}
