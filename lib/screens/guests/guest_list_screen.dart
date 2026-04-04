import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../providers/guest_provider.dart';
import '../../../config/app_colors.dart';
import '../../../config/app_routes.dart';
import '../../../models/guest_model.dart';
import '../../../providers/user_event_provider.dart';

class GuestListScreen extends StatefulWidget {
  final String eventId;
  const GuestListScreen({super.key, required this.eventId});

  @override
  State<GuestListScreen> createState() => _GuestListScreenState();
}

class _GuestListScreenState extends State<GuestListScreen> {
  @override
  void initState() {
    super.initState();
    // Start listening to guests stream on screen load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GuestProvider>(context, listen: false).startListening(widget.eventId);
    });
  }

  // 🔗 SHARE RSVP LINK FOR MASS INVITES
  void _shareRSVPLink() {
    // ✅ Uses exact domain, explicitly calling rsvp.html
    final String rsvpLink = "https://online-voting-system-76856.web.app/rsvp.html?event=${widget.eventId}";
    final String message = "You're invited! 🎉 Click here to RSVP and get your digital entry pass:\n\n$rsvpLink";

    Share.share(message);
  }

  // 🔗 SHARE INDIVIDUAL VIP PASS
  void _shareVIPPass(GuestModel guest) {
    // ✅ Uses exact domain, explicitly calling ticket.html
    final String ticketLink = "https://online-voting-system-76856.web.app/ticket.html?event=${widget.eventId}&guest=${guest.id}";
    final String message = "Hi ${guest.name}! 🌟 Here is your VIP Pass for the event. Have it ready at the entrance:\n\n$ticketLink";

    Share.share(message);
  }

  @override
  Widget build(BuildContext context) {
    // Get the expected guest count from the event details
    final event = Provider.of<UserEventProvider>(context, listen: false).selectedEvent;

    // ✅ Safely parse guestCount
    int expectedGuests = 100; // Default fallback
    if (event != null && event.guestCount.toString().isNotEmpty) {
      expectedGuests = int.tryParse(event.guestCount.toString().replaceAll(RegExp(r'[^0-9]'), '')) ?? 100;
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Guest Control Center"),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            tooltip: "Open Scanner",
            onPressed: () => Navigator.pushNamed(
                context,
                AppRoutes.qrScanner,
                arguments: {'eventId': widget.eventId}
            ),
          )
        ],
      ),
      body: Consumer<GuestProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.guests.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return CustomScrollView(
            slivers: [
              // ─── 1. HEADCOUNT DASHBOARD ───
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: _buildDashboard(
                    expectedGuests,
                    provider.totalRSVP,
                    provider.totalCheckedIn,
                  ),
                ),
              ),

              // ─── 2. ACTIONS ROW (Mass Invite & Scan) ───
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _shareRSVPLink,
                          icon: const Icon(Icons.link, size: 18),
                          label: const Text("Mass RSVP Link"),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: Colors.indigo,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => Navigator.pushNamed(
                            context,
                            AppRoutes.qrScanner,
                            arguments: {'eventId': widget.eventId},
                          ),
                          icon: const Icon(Icons.qr_code_scanner, size: 18),
                          label: const Text("Scan Tickets"),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: Colors.black87,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ─── 3. VIP LIST HEADER ───
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "VIP & Special Guests",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      TextButton.icon(
                        onPressed: () => Navigator.pushNamed(
                          context,
                          AppRoutes.addGuest,
                          arguments: {'eventId': widget.eventId},
                        ),
                        icon: const Icon(Icons.add_circle_outline, size: 18),
                        label: const Text("Add VIP"),
                      )
                    ],
                  ),
                ),
              ),

              // ─── 4. VIP LIST ───
              if (provider.vips.isEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.star_border, size: 48, color: Colors.grey.shade400),
                          const SizedBox(height: 12),
                          Text(
                            "No VIPs added yet.\nAdd special guests manually.",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) => _buildGuestTile(provider.vips[index], provider, event?.eventName ?? 'Event'),
                    childCount: provider.vips.length,
                  ),
                ),

              // ─── 5. REGULAR GUESTS HEADER (Optional: Show who RSVP'd online) ───
              if (provider.regularGuests.isNotEmpty) ...[
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 32, 20, 8),
                    child: Text(
                      "General RSVP List",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) => _buildGuestTile(provider.regularGuests[index], provider, event?.eventName ?? 'Event', isVipList: false),
                    childCount: provider.regularGuests.length,
                  ),
                ),
              ],

              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          );
        },
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 📊 DASHBOARD WIDGET
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildDashboard(int expected, int rsvp, int checkedIn) {
    double progress = expected > 0 ? (checkedIn / expected).clamp(0.0, 1.0) : 0;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Live Headcount", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(8)),
                child: Text("${(progress * 100).toStringAsFixed(0)}% Arrived", style: TextStyle(color: Colors.green.shade700, fontSize: 10, fontWeight: FontWeight.bold)),
              )
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStat("Expected", expected.toString(), Colors.blue),
              Container(width: 1, height: 30, color: Colors.grey.shade200),
              _buildStat("RSVP'd", rsvp.toString(), Colors.orange),
              Container(width: 1, height: 30, color: Colors.grey.shade200),
              _buildStat("Entered", checkedIn.toString(), Colors.green),
            ],
          ),
          const SizedBox(height: 24),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey.shade100,
              color: Colors.green,
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey.shade600)),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 🧑‍💼 GUEST TILE WIDGET
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildGuestTile(GuestModel guest, GuestProvider provider, String eventName, {bool isVipList = true}) {
    final isCheckedIn = guest.status == 'checked_in';

    return Dismissible(
      key: Key(guest.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(12)),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) {
        provider.deleteGuest(widget.eventId, guest.id);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${guest.name} removed')));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: isCheckedIn ? Colors.green.shade200 : Colors.grey.shade200),
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          onTap: () {
            // View Ticket
            Navigator.pushNamed(
              context,
              AppRoutes.eventPass,
              arguments: {
                'eventId': widget.eventId,
                'eventName': eventName,
                'guest': guest,
              },
            );
          },
          leading: CircleAvatar(
            backgroundColor: isCheckedIn ? Colors.green.shade50 : (isVipList ? Colors.amber.shade50 : Colors.blue.shade50),
            child: Icon(
              isCheckedIn ? Icons.how_to_reg : (isVipList ? Icons.star : Icons.person),
              color: isCheckedIn ? Colors.green : (isVipList ? Colors.amber.shade800 : Colors.blue),
            ),
          ),
          title: Text(guest.name, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(guest.phone.isNotEmpty ? guest.phone : "No phone provided", style: const TextStyle(fontSize: 12)),
          trailing: isCheckedIn
              ? const Chip(
            label: Text("In Venue", style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
            backgroundColor: Colors.green,
            padding: EdgeInsets.zero,
          )
              : IconButton(
            icon: const Icon(Icons.share, color: Colors.indigo),
            tooltip: "Share Digital Pass",
            onPressed: () => _shareVIPPass(guest),
          ),
        ),
      ),
    );
  }
}