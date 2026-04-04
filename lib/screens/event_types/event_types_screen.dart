import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_colors.dart';
import '../../config/app_routes.dart';
import '../../providers/cart_provider.dart';

class EventType {
  final String id, name, imageUrl, description;
  const EventType({required this.id, required this.name, required this.imageUrl, required this.description});
}

// ✅ Professional Event Database with Unsplash URLs
const List<EventType> _eventTypes = [
  EventType(
    id: 'wedding',
    name: 'Wedding',
    imageUrl: 'https://i.pinimg.com/736x/24/4c/b0/244cb0a18c14e25d05d42f08b4b391cb.jpg',
    description: 'Elegant planning for your big day',
  ),
  EventType(
    id: 'birthday',
    name: 'Birthday',
    imageUrl: 'https://i.pinimg.com/736x/f6/cd/b3/f6cdb3f9109a52eaf619d53361a853e3.jpg',
    description: 'Fun and memorable celebrations',
  ),
  EventType(
    id: 'corporate',
    name: 'Corporate',
    imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQZkELF8ywpHsp4ihNwoSa7DnPiyPveLRWL8Q&s',
    description: 'Professional events and seminars',
  ),
  EventType(
    id: 'engagement',
    name: 'Engagement',
    imageUrl: 'https://i.pinimg.com/736x/e4/78/13/e47813c64725302f8b0ef38e3a623eeb.jpg',
    description: 'Start your journey with love',
  ),
  EventType(
    id: 'babyshower',
    name: 'Baby Shower',
    imageUrl: 'https://i.pinimg.com/236x/bd/5e/ef/bd5eefe1fcf87fa15ad2e79ceb7b047c.jpg',
    description: 'Welcome the little one with joy',
  ),
  EventType(
    id: 'graduation',
    name: 'Graduation',
    imageUrl: 'https://i.pinimg.com/736x/2f/12/6e/2f126e96ff90f7a427213c77157a8e47.jpg',
    description: 'Celebrate the achievement milestone',
  ),
  EventType(
    id: 'anniversary',
    name: 'Anniversary',
    imageUrl: 'https://i.pinimg.com/736x/7a/b1/d0/7ab1d0f0752106a56508e7344002ffbe.jpg',
    description: 'Honor your years together',
  ),
  EventType(
    id: 'party',
    name: 'Party',
    imageUrl: 'https://i.pinimg.com/736x/8c/91/91/8c919134c08992a7cc8f00ba23b02028.jpg',
    description: 'Vibrant events for everyone',
  ),
];

class EventTypesScreen extends StatelessWidget {
  const EventTypesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Clean professional background
      appBar: AppBar(
        title: const Text('Select Event Type', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color(0xFF1A237E), // Professional Midnight Indigo
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sub-header title
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 24, 20, 8),
            child: Text(
              "What are we planning?",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1A237E)),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text("Select a category to see specialized services",
                style: TextStyle(color: Colors.grey, fontSize: 14)),
          ),
          const SizedBox(height: 16),

          // Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.8, // Adjusted for perfect image and text fit
              ),
              itemCount: _eventTypes.length,
              itemBuilder: (context, index) {
                final eventType = _eventTypes[index];
                return _EventTypeCard(
                  eventType: eventType,
                  onTap: () {
                    final cartProvider = Provider.of<CartProvider>(context, listen: false);
                    cartProvider.clearCart();
                    cartProvider.setEventType(eventType.id, eventType.name);
                    Navigator.pushNamed(
                      context,
                      AppRoutes.sections,
                      arguments: {'eventTypeId': eventType.id, 'eventTypeName': eventType.name},
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _EventTypeCard extends StatelessWidget {
  final EventType eventType;
  final VoidCallback onTap;

  const _EventTypeCard({required this.eventType, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🖼️ IMAGE BOX
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: Stack(
                  children: [
                    Image.network(
                      eventType.imageUrl,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    // Subtle overlay for better look
                    Container(decoration: BoxDecoration(color: Colors.black.withOpacity(0.05))),
                  ],
                ),
              ),
            ),
            // 📝 TEXT BOX
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      eventType.name,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A237E)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      eventType.description,
                      style: const TextStyle(fontSize: 11, color: Colors.grey, height: 1.2),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}