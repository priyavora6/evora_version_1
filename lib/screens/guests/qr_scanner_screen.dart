import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import '../../../config/app_colors.dart';
import '../../../providers/guest_provider.dart'; // ✅ Use GuestProvider, not UserEventProvider

class QrScannerScreen extends StatefulWidget {
  final String eventId;
  const QrScannerScreen({super.key, required this.eventId});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  bool isScanning = true;

  void _onDetect(BarcodeCapture capture) async {
    if (!isScanning) return;

    final String? code = capture.barcodes.first.rawValue;
    if (code == null) return;

    setState(() => isScanning = false); // Pause scanner

    // 🔍 EXTRACT GUEST ID FROM URL
    String guestId = code;

    // If it's a URL (e.g. https://.../ticket.html?guest=abc123xyz)
    if (code.contains("guest=")) {
      final uri = Uri.tryParse(code);
      if (uri != null) {
        guestId = uri.queryParameters['guest'] ?? code;
      }
    }

    print("🔍 Scanned Code: $code");
    print("🔍 Extracted Guest ID: $guestId");

    // ✅ Use GuestProvider to validate
    final provider = Provider.of<GuestProvider>(context, listen: false);
    final result = await provider.validateAndCheckInGuest(widget.eventId, guestId);

    if (mounted) {
      _showResultDialog(result);
    }
  }

  void _showResultDialog(Map<String, dynamic> result) {
    bool success = result['success'];
    String message = result['message'];

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: success ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                success ? Icons.check_circle : (message.contains("Already") ? Icons.warning : Icons.error),
                color: success ? Colors.green : (message.contains("Already") ? Colors.orange : Colors.red),
                size: 60,
              ),
            ),
            const SizedBox(height: 20),

            // Guest Name (if found)
            if (result['guestName'] != null)
              Text(
                result['guestName'],
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

            const SizedBox(height: 10),

            // Message
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 30),

            // Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() => isScanning = true); // Resume scanner
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Scan Next Guest", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Entrance Scanner"), backgroundColor: AppColors.primary, foregroundColor: Colors.white),
      body: Stack(
        children: [
          MobileScanner(onDetect: _onDetect),
          // Scanner Overlay
          Center(
            child: Container(
              width: 250, height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.secondary, width: 4),
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),
          const Positioned(
            bottom: 100, left: 0, right: 0,
            child: Center(
              child: Text("Align QR code inside the box", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
            ),
          )
        ],
      ),
    );
  }
}