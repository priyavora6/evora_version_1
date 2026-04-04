
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../config/app_colors.dart';
import '../../config/app_routes.dart';
import '../../config/app_strings.dart';
import '../../providers/auth_provider.dart';
import '../../providers/user_event_provider.dart';
import '../../providers/notification_provider.dart';
import 'widgets/upcoming_event_card.dart';
import 'widgets/overview_card.dart';
import 'widgets/quick_action_button.dart';

// ✅ IMPORT YOUR NEW SHOWCASE TAB HERE
import 'showcase_tab.dart';
// ✅ IMPORT YOUR STATIC SCREENS HERE
import '../settings/about_screen.dart';
import '../settings/feedback_screen.dart';
import '../settings/contact_us_screen.dart';
import '../settings/policy_screen.dart';
import '../settings/developers_screen.dart';

class DashboardScreen extends StatefulWidget {
const DashboardScreen({super.key});

@override
State<DashboardScreen> createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
int _currentIndex = 0;

void setIndex(int index) {
setState(() {
_currentIndex = index;
});
}

@override
void initState() {
super.initState();

WidgetsBinding.instance.addPostFrameCallback((_) async {
final authProvider = Provider.of<AuthProvider>(context, listen: false);
final userEventProvider = Provider.of<UserEventProvider>(context, listen: false);
final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);

if (authProvider.user != null) {
await userEventProvider.fetchUserEvents(authProvider.user!.id);
notificationProvider.startNotificationsListener(authProvider.user!.id, false);
await FirebaseMessaging.instance.requestPermission();
}
});
}

@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: _currentIndex == 2 ? Colors.black : AppColors.background,
body: _buildBody(),
bottomNavigationBar: _buildBottomNavBar(),
floatingActionButton: _currentIndex == 0 ? _buildFAB() : null,
);
}

Widget _buildFAB() {
return FloatingActionButton.extended(
onPressed: () => Navigator.pushNamed(context, AppRoutes.eventTypes),
backgroundColor: AppColors.primary,
icon: const Icon(Icons.add, color: Colors.white),
label: const Text('Create Event', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
);
}

Widget _buildBody() {
switch (_currentIndex) {
case 0: return const _HomeTab();
case 1: return const _MyEventsTab();
case 2: return const ShowcaseTab();
case 3: return const _SettingsTab();
default: return const _HomeTab();
}
}

Widget _buildBottomNavBar() {
return Container(
decoration: BoxDecoration(
color: Colors.white,
boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -5))],
),
child: BottomNavigationBar(
currentIndex: _currentIndex,
onTap: (index) => setState(() => _currentIndex = index),
type: BottomNavigationBarType.fixed,
backgroundColor: Colors.white,
selectedItemColor: AppColors.primary,
unselectedItemColor: AppColors.textSecondary,
selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
items: const [
BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
BottomNavigationBarItem(icon: Icon(Icons.event_outlined), activeIcon: Icon(Icons.event), label: 'My Events'),
BottomNavigationBarItem(icon: Icon(Icons.auto_awesome_outlined), activeIcon: Icon(Icons.auto_awesome), label: 'Showcase'),
BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), activeIcon: Icon(Icons.settings), label: 'Settings'),
],
),
);
}
}

// 🏠 1. HOME TAB
class _HomeTab extends StatelessWidget {
const _HomeTab();

@override
Widget build(BuildContext context) {
return SafeArea(
child: RefreshIndicator(
onRefresh: () async {
final authProvider = Provider.of<AuthProvider>(context, listen: false);
final userEventProvider = Provider.of<UserEventProvider>(context, listen: false);
if (authProvider.user != null) {
await userEventProvider.fetchUserEvents(authProvider.user!.id);
}
},
child: SingleChildScrollView(
physics: const AlwaysScrollableScrollPhysics(),
padding: const EdgeInsets.all(20),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
_buildHeader(context),
const SizedBox(height: 24),
_buildUpcomingEvent(context),
const SizedBox(height: 24),
_buildOverviewSection(context),
const SizedBox(height: 24),
_buildQuickActions(context),
const SizedBox(height: 24),
_buildRecentEvents(context),
const SizedBox(height: 80),
],
),
),
),
);
}

Widget _buildHeader(BuildContext context) {
return Consumer<AuthProvider>(
builder: (context, authProvider, child) {
return Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
const Text('${AppStrings.welcome},', style: TextStyle(fontSize: 16, color: AppColors.textSecondary)),
const SizedBox(height: 4),
Text(authProvider.user?.name ?? 'User', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
],
),
Consumer<NotificationProvider>(
builder: (context, notif, child) {
return GestureDetector(
onTap: () => Navigator.pushNamed(context, AppRoutes.notifications),
child: Container(
width: 50, height: 50,
decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(15), border: Border.all(color: AppColors.border)),
child: Stack(
children: [
const Center(child: Icon(Icons.notifications_outlined, color: AppColors.textPrimary, size: 26)),
if (notif.unreadCount > 0)
Positioned(
top: 10, right: 10,
child: Container(padding: const EdgeInsets.all(4), decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle), constraints: const BoxConstraints(minWidth: 16, minHeight: 16), child: Text('${notif.unreadCount}', style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
),
],
),
),
);
},
),
],
);
},
);
}

Widget _buildUpcomingEvent(BuildContext context) {
return Consumer<UserEventProvider>(builder: (context, p, c) {
if (p.upcomingEvents.isEmpty) {
return Container(
width: double.infinity, padding: const EdgeInsets.all(30),
decoration: BoxDecoration(gradient: LinearGradient(colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)], begin: Alignment.topLeft, end: Alignment.bottomRight), borderRadius: BorderRadius.circular(20)),
child: Column(children: [
Icon(Icons.celebration_outlined, size: 60, color: Colors.white.withOpacity(0.9)),
const SizedBox(height: 16),
const Text('No Upcoming Events', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
const SizedBox(height: 8),
Text('Start planning your next special occasion!', style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.9))),
const SizedBox(height: 20),
ElevatedButton(onPressed: () => Navigator.pushNamed(context, AppRoutes.eventTypes), style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: const Text('Create Event', style: TextStyle(fontWeight: FontWeight.w600))),
]),
);
}
return UpcomingEventCard(event: p.upcomingEvents.first);
});
}

Widget _buildOverviewSection(BuildContext context) {
return Consumer<UserEventProvider>(builder: (context, p, c) {
return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
const Text('Overview', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
const SizedBox(height: 16),
Row(children: [
Expanded(child: GestureDetector(onTap: () => Navigator.pushNamed(context, AppRoutes.myEvents), child: OverviewCard(title: 'Total Events', value: p.events.length.toString(), icon: Icons.event, color: AppColors.primary))),
const SizedBox(width: 12),
Expanded(child: GestureDetector(onTap: () => Navigator.pushNamed(context, AppRoutes.myEvents), child: OverviewCard(title: 'Upcoming', value: p.upcomingEvents.length.toString(), icon: Icons.upcoming, color: AppColors.success))),
]),
]);
});
}

Widget _buildQuickActions(BuildContext context) {
return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
const Text('Quick Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
const SizedBox(height: 16),
Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
QuickActionButton(icon: Icons.add_circle_outline, label: 'Create\nEvent', color: AppColors.primary, onTap: () => Navigator.pushNamed(context, AppRoutes.eventTypes)),
QuickActionButton(icon: Icons.people_outline, label: 'Manage\nGuests', color: AppColors.secondary, onTap: () => _handleSmartNavigation(context, 'guests')),
QuickActionButton(icon: Icons.account_balance_wallet_outlined, label: 'Budget\nTracker', color: AppColors.success, onTap: () => _handleSmartNavigation(context, 'budget')),
QuickActionButton(icon: Icons.checklist, label: 'Task\nPlanner', color: AppColors.warning, onTap: () => _handleSmartNavigation(context, 'tasks')),
]),
]);
}

void _handleSmartNavigation(BuildContext context, String targetTab) {
final userEventProvider = Provider.of<UserEventProvider>(context, listen: false);
final events = userEventProvider.events;
if (events.isEmpty) {
ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please create an event first!"), backgroundColor: Colors.orange));
} else if (events.length == 1) {
_navigateToTab(context, events.first.id, targetTab);
} else {
showModalBottomSheet(context: context, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))), builder: (context) => Container(padding: const EdgeInsets.all(20), child: Column(mainAxisSize: MainAxisSize.min, children: [const Text("Select Event", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), const SizedBox(height: 10), ...events.map((event) => ListTile(leading: const Icon(Icons.event, color: AppColors.primary), title: Text(event.eventName), onTap: () {Navigator.pop(context); _navigateToTab(context, event.id, targetTab);})).toList()])));
}
}

void _navigateToTab(BuildContext context, String eventId, String targetTab) {
int tabIndex = 0;
if (targetTab == 'guests') tabIndex = 2;
if (targetTab == 'budget') tabIndex = 3;
if (targetTab == 'tasks') tabIndex = 4;
Navigator.pushNamed(context, AppRoutes.eventDetail, arguments: {'eventId': eventId, 'initialTab': tabIndex});
}

Widget _buildRecentEvents(BuildContext context) {
return Consumer<UserEventProvider>(builder: (context, p, c) {
if (p.events.isEmpty) return const SizedBox.shrink();
final recent = p.events.take(3).toList();
return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Recent Events', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)), TextButton(onPressed: () => Navigator.pushNamed(context, AppRoutes.myEvents), child: const Text(AppStrings.seeAll, style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w500)))]),
const SizedBox(height: 12),
ListView.separated(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: recent.length, separatorBuilder: (_, __) => const SizedBox(height: 12), itemBuilder: (context, index) => _buildRecentEventTile(context, recent[index])),
]);
});
}

Widget _buildRecentEventTile(BuildContext context, dynamic event) {
return GestureDetector(onTap: () => Navigator.pushNamed(context, AppRoutes.eventDetail, arguments: {'eventId': event.id}), child: Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)), child: Row(children: [Container(width: 50, height: 50, decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.event, color: AppColors.primary)), const SizedBox(width: 16), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(event.eventName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)), const SizedBox(height: 4), Text(event.eventTypeName, style: const TextStyle(fontSize: 14, color: AppColors.textSecondary))]))])));
}
}

// 📅 2. MY EVENTS TAB
class _MyEventsTab extends StatelessWidget {
const _MyEventsTab();
@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: AppColors.background,
appBar: AppBar(title: const Text(AppStrings.myEvents, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)), centerTitle: true, elevation: 0, backgroundColor: AppColors.primary, leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20), onPressed: () => context.findAncestorStateOfType<DashboardScreenState>()?.setIndex(0))),
body: Consumer<UserEventProvider>(builder: (context, p, c) {
if (p.isLoading) return const Center(child: CircularProgressIndicator());
if (p.events.isEmpty) return const Center(child: Text("No events planned yet."));
return ListView.builder(padding: const EdgeInsets.all(20), itemCount: p.events.length, itemBuilder: (context, index) => _EventCard(event: p.events[index]));
}),
);
}
}

class _EventCard extends StatelessWidget {
final dynamic event;
const _EventCard({required this.event});
@override
Widget build(BuildContext context) {
return GestureDetector(onTap: () => Navigator.pushNamed(context, AppRoutes.eventDetail, arguments: {'eventId': event.id}), child: Container(margin: const EdgeInsets.only(bottom: 16), padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.border)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: Text(event.eventTypeName, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 11))), const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey)]), const SizedBox(height: 12), Text(event.eventName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), const SizedBox(height: 4), Text(event.location, style: const TextStyle(color: Colors.grey, fontSize: 13))])));
}
}

// ⚙️ 4. SETTINGS TAB (Updated Logic)
class _SettingsTab extends StatelessWidget {
  const _SettingsTab();

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 22),
          onPressed: () => context.findAncestorStateOfType<DashboardScreenState>()?.setIndex(0),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // ─── USER INFO HEADER ───
          Center(
              child: CircleAvatar(
                  radius: 40,
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  child: Text(
                      auth.user?.name.isNotEmpty == true ? auth.user!.name[0].toUpperCase() : 'U',
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.primary)
                  )
              )
          ),
          const SizedBox(height: 12),
          Center(child: Text(auth.user?.name ?? 'User', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
          Center(child: Text(auth.user?.email ?? '', style: const TextStyle(color: Colors.grey))),

          const SizedBox(height: 32),

          // 🔥 NEW: DYNAMIC SWITCH CARD
          _buildVendorStatusCard(context, auth),

          const SizedBox(height: 32),

          const Text("GENERAL", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 12, letterSpacing: 1.2)),
          const SizedBox(height: 12),

          _buildSettingsTile(
            context,
            icon: Icons.lock_outline,
            title: "Change Password",
            onTap: () => Navigator.pushNamed(context, AppRoutes.changePassword),
          ),

          // ... (Rest of your settings tiles: About, Feedback, etc.) ...
          // Keeping code short for brevity, paste your existing tiles here
          _buildSettingsTile(
            context,
            icon: Icons.info_outline,
            title: "About",
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutScreen())),
          ),
          _buildSettingsTile(
            context,
            icon: Icons.privacy_tip_outlined,
            title: "Privacy Policy",
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PolicyScreen())),
          ),

          const SizedBox(height: 30),

          // 🔴 LOGOUT BUTTON
          Center(
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Provider.of<AuthProvider>(context, listen: false).logout().then((_) =>
                      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false));
                },
                icon: const Icon(Icons.logout, color: Colors.white, size: 20),
                label: const Text("Logout", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade500,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Center(child: Text("Version 1.0.0", style: TextStyle(color: Colors.grey, fontSize: 12))),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 🔥 SMART VENDOR LOGIC
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildVendorStatusCard(BuildContext context, AuthProvider auth) {
    String title;
    String subtitle;
    IconData icon;
    Color color;
    VoidCallback onTap;

    // 1. IF ALREADY APPROVED VENDOR -> Show "Switch to Professional Mode"
    if (auth.isApprovedVendor) {
      title = "Switch to Professional Mode";
      subtitle = "Manage your business & bookings";
      icon = Icons.storefront_rounded;
      color = Colors.teal; // Distinct color for Business Mode
      onTap = () {
        // ✅ Switch directly to Vendor Panel
        Navigator.pushNamedAndRemoveUntil(context, AppRoutes.vendorMain, (route) => false);
      };
    }
    // 2. IF PENDING -> Show Status
    else if (auth.vendorStatus?.toLowerCase() == 'pending') {
      title = "Application Pending";
      subtitle = "We are reviewing your profile";
      icon = Icons.hourglass_top_rounded;
      color = Colors.orange;
      onTap = () => Navigator.pushNamed(context, AppRoutes.vendorApplicationStatus);
    }
    // 3. IF REJECTED -> Show Status
    else if (auth.vendorStatus?.toLowerCase() == 'rejected') {
      title = "Application Declined";
      subtitle = "Tap to see details";
      icon = Icons.error_outline_rounded;
      color = Colors.red;
      onTap = () => Navigator.pushNamed(context, AppRoutes.vendorApplicationStatus);
    }
    // 4. NORMAL USER -> Show "Become a Professional"
    else {
      title = "Become a Professional";
      subtitle = "Join us and earn money";
      icon = Icons.add_business_rounded;
      color = AppColors.primary;
      onTap = () => Navigator.pushNamed(context, AppRoutes.vendorRegistration);
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.3), width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: color)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: TextStyle(fontSize: 12, color: color.withOpacity(0.8))),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 14, color: color),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTile(BuildContext context, {
    required IconData icon,
    required String title,
    String? trailingText,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: AppColors.primary, size: 24),
        ),
        title: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        trailing: trailingText != null
            ? Text(trailingText, style: TextStyle(color: Colors.grey.shade400, fontSize: 14, fontWeight: FontWeight.bold))
            : Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey.shade400),
      ),
    );
  }
}