// lib/screens/vendor_panel/tabs/vendor_home_tab.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider; // ✅ Fix: Hide conflicting AuthProvider
import '../../../config/app_colors.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/vendor_panel_provider.dart';

class VendorHomeTab extends StatefulWidget {
  const VendorHomeTab({super.key});

  @override
  State<VendorHomeTab> createState() => _VendorHomeTabState();
}

class _VendorHomeTabState extends State<VendorHomeTab> {
  String? vendorId;
  String? displayName;
  bool _isLoadingVendor = true;

  @override
  void initState() {
    super.initState();
    _loadVendorData();
  }

  Future<void> _loadVendorData() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final currentUser = FirebaseAuth.instance.currentUser;
      
      if (currentUser == null) {
        if (mounted) setState(() => _isLoadingVendor = false);
        return;
      }

      // 1. Try to get from AuthProvider first (Fastest)
      if (authProvider.currentVendor != null) {
        _setVendorData(authProvider.currentVendor!.id, authProvider.currentVendor!.businessName);
        return;
      }

      // 2. Try Fetch by Document ID (UID)
      var vendorDoc = await FirebaseFirestore.instance
          .collection('vendors')
          .doc(currentUser.uid)
          .get();

      if (vendorDoc.exists) {
        _processVendorDoc(vendorDoc);
        return;
      }

      // 3. Fallback: Query by userId field (In case Doc ID is different)
      final querySnapshot = await FirebaseFirestore.instance
          .collection('vendors')
          .where('userId', isEqualTo: currentUser.uid)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        _processVendorDoc(querySnapshot.docs.first);
        return;
      }

      // 4. No profile found
      if (mounted) setState(() => _isLoadingVendor = false);
    } catch (e) {
      debugPrint('Error loading vendor data: $e');
      if (mounted) setState(() => _isLoadingVendor = false);
    }
  }

  void _processVendorDoc(DocumentSnapshot doc) {
    if (!mounted) return;
    final data = doc.data() as Map<String, dynamic>;
    
    String name = data['vendorName'] ?? data['businessName'] ?? data['name'] ?? 'Partner';
    if (name.isNotEmpty) {
      name = name[0].toUpperCase() + name.substring(1);
    }

    _setVendorData(doc.id, name);
    
    // Refresh the auth provider data if it was missing vendorId
    Provider.of<AuthProvider>(context, listen: false).refreshUserData();
  }

  void _setVendorData(String id, String name) {
    if (!mounted) return;
    setState(() {
      vendorId = id;
      displayName = name;
      _isLoadingVendor = false;
    });

    // Load dashboard data
    Provider.of<VendorPanelProvider>(context, listen: false).loadVendorData(id);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingVendor) {
      return const Center(child: CircularProgressIndicator());
    }

    if (vendorId == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.storefront_outlined, size: 64, color: Colors.red.shade300),
              ),
              const SizedBox(height: 24),
              const Text(
                'Vendor Profile Not Found',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'We couldn\'t find a vendor account linked to your profile. Please contact support or try logging in again.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => _loadVendorData(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Try Refreshing'),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadVendorData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeHeader(displayName ?? 'Vendor'),
            const SizedBox(height: 24),
            _buildEarningsSummaryCard(vendorId!),
            const SizedBox(height: 24),
            _buildStatsGrid(vendorId!),
            const SizedBox(height: 24),
            _buildUpcomingEventsSection(vendorId!),
            const SizedBox(height: 24),
            _buildRecentPaymentsSection(vendorId!),
            const SizedBox(height: 24),
            _buildRecentReviewsSection(vendorId!),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // 👋 WELCOME HEADER
  // ═══════════════════════════════════════════════════════════════════════════
  Widget _buildWelcomeHeader(String name) {
    final hour = DateTime.now().hour;
    String greeting;
    IconData greetingIcon;

    if (hour < 12) {
      greeting = 'Good Morning';
      greetingIcon = Icons.wb_sunny_rounded;
    } else if (hour < 17) {
      greeting = 'Good Afternoon';
      greetingIcon = Icons.wb_cloudy_rounded;
    } else {
      greeting = 'Good Evening';
      greetingIcon = Icons.nights_stay_rounded;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(greetingIcon, color: Colors.white70, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      greeting,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.storefront_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEarningsSummaryCard(String vendorId) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('payments')
          .where('vendorId', isEqualTo: vendorId)
          .where('status', isEqualTo: 'success')
          .snapshots(),
      builder: (context, snapshot) {
        double totalEarnings = 0;
        double thisMonthEarnings = 0;
        int totalPayments = 0;

        if (snapshot.hasData) {
          final now = DateTime.now();
          final startOfMonth = DateTime(now.year, now.month, 1);

          for (var doc in snapshot.data!.docs) {
            final data = doc.data() as Map<String, dynamic>;
            final amount = (data['amount'] ?? 0).toDouble();
            final timestamp = (data['timestamp'] as Timestamp?)?.toDate();

            totalEarnings += amount;
            totalPayments++;

            if (timestamp != null && timestamp.isAfter(startOfMonth)) {
              thisMonthEarnings += amount;
            }
          }
        }
        return _buildPendingEarningsStream(
          vendorId: vendorId,
          totalEarnings: totalEarnings,
          thisMonthEarnings: thisMonthEarnings,
          totalPayments: totalPayments,
        );
      },
    );
  }

  Widget _buildPendingEarningsStream({
    required String vendorId,
    required double totalEarnings,
    required double thisMonthEarnings,
    required int totalPayments,
  }) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('userEvents').snapshots(),
      builder: (context, snapshot) {
        double pendingEarnings = 0;

        if (snapshot.hasData) {
          for (var doc in snapshot.data!.docs) {
            final data = doc.data() as Map<String, dynamic>;
            final assignedVendors = data['assignedVendors'] as List<dynamic>? ?? [];

            for (var vendor in assignedVendors) {
              if (vendor['vendorId'] == vendorId &&
                  (vendor['paymentStatus'] == 'pending' || vendor['paymentStatus'] == null)) {
                pendingEarnings += (vendor['price'] ?? 0).toDouble();
              }
            }
          }
        }

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade100),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Earnings',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$totalPayments Trans.',
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '₹${totalEarnings.toStringAsFixed(0)}',
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _buildEarningMiniCard(
                      'This Month',
                      '₹${thisMonthEarnings.toStringAsFixed(0)}',
                      Icons.calendar_month,
                      Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildEarningMiniCard(
                      'Pending',
                      '₹${pendingEarnings.toStringAsFixed(0)}',
                      Icons.hourglass_top_rounded,
                      Colors.orange,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEarningMiniCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              color: color.withOpacity(0.8),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(String vendorId) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('userEvents').snapshots(),
      builder: (context, snapshot) {
        int totalEvents = 0;
        int upcomingEvents = 0;
        int completedEvents = 0;

        if (snapshot.hasData) {
          final now = DateTime.now();

          for (var doc in snapshot.data!.docs) {
            final data = doc.data() as Map<String, dynamic>;
            final assignedVendors = data['assignedVendors'] as List<dynamic>? ?? [];
            final eventDate = (data['eventDate'] as Timestamp?)?.toDate();
            final status = data['status']?.toString().toLowerCase();

            bool isAssigned = assignedVendors.any((v) => v['vendorId'] == vendorId);

            if (isAssigned) {
              totalEvents++;

              if (status == 'completed') {
                completedEvents++;
              } else if (eventDate != null && eventDate.isAfter(now)) {
                upcomingEvents++;
              }
            }
          }
        }

        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.9,
          children: [
            _buildStatCard('Total', '$totalEvents', Icons.work, Colors.blue),
            _buildStatCard('Upcoming', '$upcomingEvents', Icons.upcoming, Colors.orange),
            _buildStatCard('Done', '$completedEvents', Icons.check_circle, Colors.green),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            title,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingEventsSection(String vendorId) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Upcoming Events',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 12),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('userEvents')
              .orderBy('eventDate')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return _buildEmptyState('No upcoming events', Icons.event_busy);
            }

            final vendorEvents = snapshot.data!.docs.where((doc) {
              final data = doc.data() as Map<String, dynamic>;
              final assignedVendors = data['assignedVendors'] as List<dynamic>? ?? [];
              final eventDate = (data['eventDate'] as Timestamp?)?.toDate();

              bool isAssigned = assignedVendors.any((v) => v['vendorId'] == vendorId);
              bool isFuture = eventDate != null && eventDate.isAfter(DateTime.now());

              return isAssigned && isFuture;
            }).take(3).toList();

            if (vendorEvents.isEmpty) {
              return _buildEmptyState('No upcoming schedule', Icons.calendar_today_outlined);
            }

            return Column(
              children: vendorEvents.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return _buildEventCard(data, vendorId);
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildEventCard(Map<String, dynamic> data, String vendorId) {
    final eventName = data['eventName'] ?? 'Event';
    final eventDate = (data['eventDate'] as Timestamp?)?.toDate();
    final location = data['location'] ?? 'Location TBA';

    final assignedVendors = data['assignedVendors'] as List<dynamic>? ?? [];
    double price = 0;
    String paymentStatus = 'pending';

    for (var v in assignedVendors) {
      if (v['vendorId'] == vendorId) {
        price = (v['price'] ?? 0).toDouble();
        paymentStatus = v['paymentStatus'] ?? 'pending';
        break;
      }
    }

    final isPaid = paymentStatus == 'paid';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Text(
                  eventDate != null ? _getMonth(eventDate) : 'DEC',
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.orange),
                ),
                Text(
                  eventDate != null ? eventDate.day.toString() : '12',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orange),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  eventName,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  location,
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹${price.toStringAsFixed(0)}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isPaid ? Colors.green.shade50 : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  isPaid ? 'PAID' : 'PENDING',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: isPaid ? Colors.green : Colors.grey,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentPaymentsSection(String vendorId) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Payments',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('payments')
              .where('vendorId', isEqualTo: vendorId)
              .where('status', isEqualTo: 'success')
              .orderBy('timestamp', descending: true)
              .limit(5)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: Padding(padding: EdgeInsets.all(10), child: CircularProgressIndicator(strokeWidth: 2)));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return _buildEmptyState('No payments yet', Icons.account_balance_wallet_outlined);
            }

            return Column(
              children: snapshot.data!.docs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return _buildPaymentCard(data);
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPaymentCard(Map<String, dynamic> data) {
    final amount = (data['amount'] ?? 0).toDouble();
    final eventName = data['eventName'] ?? 'Event Payment';
    final timestamp = (data['timestamp'] as Timestamp?)?.toDate();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.arrow_downward_rounded, color: Colors.green, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  eventName,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                ),
                Text(
                  _formatDate(timestamp),
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                ),
              ],
            ),
          ),
          Text(
            '+₹${amount.toStringAsFixed(0)}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.green),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentReviewsSection(String vendorId) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Reviews',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('reviews')
              .where('vendorId', isEqualTo: vendorId)
              .orderBy('createdAt', descending: true)
              .limit(3)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return _buildEmptyState('No reviews yet', Icons.star_border);
            }

            return Column(
              children: snapshot.data!.docs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                final userName = data['userName'] ?? 'User';
                final rating = (data['rating'] ?? 5).toDouble();
                final comment = data['comment'] ?? '';

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade100),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: AppColors.primary.withOpacity(0.1),
                            child: Text(
                              userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                              style: TextStyle(fontSize: 10, color: AppColors.primary, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(userName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          const Spacer(),
                          const Icon(Icons.star, color: Colors.amber, size: 14),
                          const SizedBox(width: 4),
                          Text(rating.toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        ],
                      ),
                      if (comment.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          comment,
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ]
                    ],
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildEmptyState(String text, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.grey.shade300, size: 30),
          const SizedBox(height: 8),
          Text(text, style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${date.day} ${months[date.month - 1]}, ${date.year}';
  }

  String _getMonth(DateTime date) {
    final months = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'];
    return months[date.month - 1];
  }
}
