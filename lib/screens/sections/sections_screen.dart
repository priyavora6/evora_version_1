
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // ✅ Added for Badge
import '../../config/app_colors.dart';
import '../../config/app_routes.dart';
import '../../models/section_model.dart';
import '../../providers/cart_provider.dart'; // ✅ Added for Badge
import 'widgets/section_card.dart';

class SectionsScreen extends StatelessWidget {
  final String eventTypeId;
  final String eventTypeName;

  const SectionsScreen({
    super.key,
    required this.eventTypeId,
    required this.eventTypeName,
  });

  // ═══════════════════════════════════════════════════════════════════════
  // GET SECTIONS LIST BASED ON EVENT TYPE
  // ═══════════════════════════════════════════════════════════════════════
  List<Section> _getSectionsList() {
    final type = eventTypeName.toLowerCase();

    // ─────────────────────────────────────────────────────────────────────
    // MARRIAGE / WEDDING
    // ─────────────────────────────────────────────────────────────────────
    if (type.contains('marriage') || type.contains('wedding')) {
      return [
        Section(id: 'm_vidhi', eventTypeId: 'marriage', name: 'Vidhi', description: 'Mandap, Pandit & Rituals', image: 'https://www.vedicvidhi.com/wp-content/uploads/2020/06/Veidc-Vidhi-Icon-300x300.png'),
        Section(id: 'm_decor', eventTypeId: 'marriage', name: 'Decoration', description: 'Royal Flower & Stage Decor', image: 'https://media.weddingz.in/images/bbda52972b1de50671f1b9de639610de/Anais-Events-6.jpg'),
        Section(id: 'm_sangeet', eventTypeId: 'marriage', name: 'Sangeet', description: 'DJ, Sound & Lights', image: 'https://static.vecteezy.com/system/resources/thumbnails/052/931/430/small/indian-or-hindu-bride-and-groom-couple-illustration-for-wedding-haldi-mehndi-ceremony-and-wedding-invitation-cards-free-vector.jpg'),
        Section(id: 'm_mehendi', eventTypeId: 'marriage', name: 'Mehendi', description: 'Bridal Designs & Mehendi Artists', image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT9WlaVyJ7EtCwxmPDHzWv3OQijm0cm2RhikQ&s'),
        Section(id: 'm_photo', eventTypeId: 'marriage', name: 'Photography', description: 'Wedding Photo & Video', image: 'https://images.unsplash.com/photo-1537633552985-df8429e8048b?q=80&w=400&auto=format&fit=crop'),
        Section(id: 'm_makeup', eventTypeId: 'marriage', name: 'Makeup', description: 'Bridal & Groom Styling', image: 'https://i.pinimg.com/736x/64/5f/98/645f98982aa5f8666715fb4d47d15f6b.jpg'),
        Section(id: 'm_food', eventTypeId: 'marriage', name: 'Food', description: 'Catering & Menu', image: 'https://i.pinimg.com/236x/29/95/a0/2995a038b2bee0275bfa33644dd9d482.jpg'),
      ];
    }
    // ─────────────────────────────────────────────────────────────────────
    // BIRTHDAY
    // ─────────────────────────────────────────────────────────────────────
    if (type.contains('birthday')) {
      return [
        Section(id: 'b_cake', eventTypeId: 'birthday', name: 'Cake', description: 'Custom Birthday Cakes', image: 'https://static.vecteezy.com/system/resources/thumbnails/070/586/459/small/happy-birthday-cake-with-lit-candles-and-blue-balloons-for-a-festive-celebration-photo.jpeg'),
        Section(id: 'b_decor', eventTypeId: 'birthday', name: 'Decoration', description: 'Balloons & Party Themes', image: 'https://m.media-amazon.com/images/I/71t+atXLurL._AC_UF1000,1000_QL80_.jpg'),
        Section(id: 'b_ent', eventTypeId: 'birthday', name: 'Entertainment', description: 'Magic Show & Games', image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSC-6tKDOZcSDDk_QmEnfMmPyXqHpHWARZ1zA&s'),
        Section(id: 'b_photo', eventTypeId: 'birthday', name: 'Photography', description: 'Birthday Photoshoot', image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR5SFbS6CPRJ25sf5pWNcG0oQ0HY__PmR_UgQ&s'),
        Section(id: 'b_gifts', eventTypeId: 'birthday', name: 'Return Gifts', description: 'Gifts for your guests', image: 'https://m.media-amazon.com/images/I/81b0XrsRggL.jpg'),
        Section(id: 'b_food', eventTypeId: 'birthday', name: 'Food', description: 'Party Snacks & Dinner', image: 'https://i.pinimg.com/236x/29/95/a0/2995a038b2bee0275bfa33644dd9d482.jpg'),
      ];
    }

    // ─────────────────────────────────────────────────────────────────────
    // ENGAGEMENT
    // ─────────────────────────────────────────────────────────────────────
    if (type.contains('engagement')) {
      return [
        Section(id: 'e_ring', eventTypeId: 'engagement', name: 'Ring Ceremony', description: 'Ring Exchange & Rituals', image: 'https://images.unsplash.com/photo-1672190877749-815628ced93a?fm=jpg&q=60&w=3000&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8cmluZyUyMGNlcmVtb255fGVufDB8fDB8fHww'),
        Section(id: 'e_decor', eventTypeId: 'engagement', name: 'Decoration', description: 'Stage & Venue Decor', image: 'https://storage.googleapis.com/shy-pub/337348/1701583597893_SKU-0241_0.jpg'),
        Section(id: 'e_photo', eventTypeId: 'engagement', name: 'Photography', description: 'Engagement Photoshoot', image: 'https://i.pinimg.com/originals/c4/d2/ee/c4d2ee69962f79384f50c601b88659e3.jpg'),
        Section(id: 'e_makeup', eventTypeId: 'engagement', name: 'Makeup', description: 'Couple Styling & Grooming', image: 'https://i.pinimg.com/474x/fd/c1/a5/fdc1a5059048561a1c63e31cefbe2dc9.jpg'),
        Section(id: 'e_mehendi', eventTypeId: 'engagement', name: 'Mehendi', description: 'Bridal Mehendi Designs', image: 'https://i.pinimg.com/236x/ce/9a/3d/ce9a3df12b09550862e212281c8e360b.jpg'),
        Section(id: 'e_music', eventTypeId: 'engagement', name: 'Music & DJ', description: 'Sound & Entertainment', image: 'https://static.vecteezy.com/system/resources/thumbnails/071/321/818/small/cartoon-dj-mixing-music-with-turntables-young-man-with-headphones-creating-sounds-perfect-for-nightlife-entertainment-and-audio-visual-concepts-vector.jpg'),
        Section(id: 'e_food', eventTypeId: 'engagement', name: 'Food', description: 'Catering & Menu', image: 'https://i.pinimg.com/236x/29/95/a0/2995a038b2bee0275bfa33644dd9d482.jpg'),
      ];
    }

    // ─────────────────────────────────────────────────────────────────────
    // ANNIVERSARY
    // ─────────────────────────────────────────────────────────────────────
    if (type.contains('anniversary')) {
      return [
        Section(id: 'a_decor', eventTypeId: 'anniversary', name: 'Decoration', description: 'Romantic & Elegant Setup', image: 'https://cheetah.cherishx.com/uploads/1686748229_original.jpg'),
        Section(id: 'a_cake', eventTypeId: 'anniversary', name: 'Cake', description: 'Anniversary Special Cakes', image: 'https://regalodelights.com/cdn/shop/files/WhatsAppImage2024-04-06at4.23.33PM_1.jpg?v=1712487251'),
        Section(id: 'a_photo', eventTypeId: 'anniversary', name: 'Photography', description: 'Couple Photoshoot', image: 'https://i.pinimg.com/474x/f3/e8/b6/f3e8b6396d4b6bb3311a58cea8c5ec32.jpg'),
        Section(id: 'a_music', eventTypeId: 'anniversary', name: 'Music', description: 'Live Music & DJ', image: 'https://assets.winni.in/c_limit,dpr_1,fl_progressive,q_80,w_1000/39849_anniversary-musical-surprise.jpeg'),
        Section(id: 'a_gifts', eventTypeId: 'anniversary', name: 'Gifts', description: 'Surprise Gift Arrangements', image: 'https://giftway.in/wp-content/uploads/2024/07/Giftway-Gifts-for-Wedding-Anniversary-Gifts-for-bf-Couples-gift-Marriage-Gifts-Items-Husband-and-Wife-A48x11-2.jpg'),
        Section(id: 'a_food', eventTypeId: 'anniversary', name: 'Food', description: 'Catering & Menu', image: 'https://i.pinimg.com/236x/29/95/a0/2995a038b2bee0275bfa33644dd9d482.jpg'),
      ];
    }

    // ─────────────────────────────────────────────────────────────────────
    // BABY SHOWER
    // ─────────────────────────────────────────────────────────────────────
    if (type.contains('baby') || type.contains('shower')) {
      return [
        Section(id: 'bs_decor', eventTypeId: 'babyshower', name: 'Decoration', description: 'Baby Theme Decoration', image: 'https://m.media-amazon.com/images/I/61rC8IqBtvL._AC_UF1000,1000_QL80_.jpg'),
        Section(id: 'bs_cake', eventTypeId: 'babyshower', name: 'Cake', description: 'Baby Shower Cakes', image: 'https://cakofy.com/cdn/shop/files/Girl_or_Boy_Baby_Shower_Cake.jpg?v=1752863306'),
        Section(id: 'bs_games', eventTypeId: 'babyshower', name: 'Games', description: 'Fun Baby Shower Games', image: 'https://www.shutterstock.com/image-photo/black-young-adult-man-blindfolded-600nw-2680191307.jpg'),
        Section(id: 'bs_photo', eventTypeId: 'babyshower', name: 'Photography', description: 'Maternity Photoshoot', image: 'https://surpriseplanner.in/assets/photo/product/product_other_6075_1727099307.jpeg'),
        Section(id: 'bs_gifts', eventTypeId: 'babyshower', name: 'Gifts', description: 'Baby Gifts & Hampers', image: 'https://m.media-amazon.com/images/I/61YmIkgYAeL.jpg'),
        Section(id: 'bs_food', eventTypeId: 'babyshower', name: 'Food', description: 'Snacks & Catering', image: 'https://i.pinimg.com/236x/29/95/a0/2995a038b2bee0275bfa33644dd9d482.jpg'),
      ];
    }

    // ─────────────────────────────────────────────────────────────────────
    // CORPORATE
    // ─────────────────────────────────────────────────────────────────────
    if (type.contains('corporate') || type.contains('office')) {
      return [
        Section(id: 'c_venue', eventTypeId: 'corporate', name: 'Venue', description: 'Conference & Event Halls', image: 'https://blog.venuelook.com/wp-content/uploads/2025/08/Top-Amenities-to-Look-for-in-a-Corporate-Party-Venue.jpg'),
        Section(id: 'c_decor', eventTypeId: 'corporate', name: 'Decoration', description: 'Professional Event Setup', image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTYgFiu25L1lOEHN05YqgTIbRP7VQwPL--hDw&s'),
        Section(id: 'c_av', eventTypeId: 'corporate', name: 'AV Equipment', description: 'Projector, Mic & Sound', image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQZt7BY9HIKcQuMGe1kbg1ZG55x7UPkbAFzJw&s'),
        Section(id: 'c_photo', eventTypeId: 'corporate', name: 'Photography', description: 'Event Coverage', image: 'https://5.imimg.com/data5/SELLER/Default/2024/6/425399466/MP/MJ/HY/85109857/img-9791-textron-aviation-australasia-customer-conference-2022-novasoma-photography.jpg'),
        Section(id: 'c_gifts', eventTypeId: 'corporate', name: 'Corporate Gifts', description: 'Employee & Client Gifts', image: 'https://images.prestogifts.com/upload/New-Product-Listing/Gift-Set/SR169/1431x1431/634a50f120ee1_41%20(1)_236_11zon_236_11zon.webp'),
        Section(id: 'c_team', eventTypeId: 'corporate', name: 'Team Building', description: 'Activities & Games', image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQX3CQnd1p2SIvxX89gsBhWz3h3TW1zqxP1Pw&s'),
        Section(id: 'c_food', eventTypeId: 'corporate', name: 'Catering', description: 'Professional Catering', image: 'https://i.pinimg.com/236x/29/95/a0/2995a038b2bee0275bfa33644dd9d482.jpg'),
      ];
    }

    // ─────────────────────────────────────────────────────────────────────
    // PARTY
    // ─────────────────────────────────────────────────────────────────────
    if (type.contains('party')) {
      return [
        Section(id: 'p_decor', eventTypeId: 'party', name: 'Decoration', description: 'Party Theme Decoration', image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTUnf6H4BtVaSCjua0R65d4-dYdfnDGa7X7AQ&s'),
        Section(id: 'p_dj', eventTypeId: 'party', name: 'DJ & Music', description: 'DJ, Sound & Lights', image: 'https://images.stockcake.com/public/8/b/8/8b8a459d-badc-4520-b027-b9d692f3a25a_large/dj-at-party-stockcake.jpg'),
        Section(id: 'p_photo', eventTypeId: 'party', name: 'Photography', description: 'Party Photoshoot', image: 'https://5.imimg.com/data5/DJ/SK/MY-44767740/celebration-party-photography.jpg'),
        Section(id: 'p_bar', eventTypeId: 'party', name: 'Bar & Drinks', description: 'Mocktails & Bartender', image: 'https://media.istockphoto.com/id/1419545383/photo/glasses-alcohol-cocktail-set-and-beer-on-a-waiter-tray-in-bar.jpg?s=612x612&w=0&k=20&c=7wB1Ic-xfPScEzSrRPjgpfGcS-SWOtHo2R_6FRGuG5Q='),
        Section(id: 'p_games', eventTypeId: 'party', name: 'Games', description: 'Fun Party Games', image: 'https://www.activitygift.com/wp-content/uploads/2024/01/corporate-team-building.jpg'),
        Section(id: 'p_food', eventTypeId: 'party', name: 'Food', description: 'Snacks & Catering', image: 'https://i.pinimg.com/236x/29/95/a0/2995a038b2bee0275bfa33644dd9d482.jpg'),
      ];
    }

    // ─────────────────────────────────────────────────────────────────────
    // GRADUATION
    // ─────────────────────────────────────────────────────────────────────
    if (type.contains('graduation') || type.contains('convocation')) {
      return [
        Section(id: 'g_decor', eventTypeId: 'graduation', name: 'Decoration', description: 'Graduation Theme Setup', image: 'https://m.media-amazon.com/images/I/81vUZpZhU9L._AC_UF1000,1000_QL80_.jpg'),
        Section(id: 'g_cake', eventTypeId: 'graduation', name: 'Cake', description: 'Graduation Cakes', image: 'https://i.pinimg.com/736x/0b/53/d4/0b53d42ed866df6094af441d6908e267.jpg'),
        Section(id: 'g_photo', eventTypeId: 'graduation', name: 'Photography', description: 'Graduation Photoshoot', image: 'https://dawn-photo.com/wp-content/uploads/2021/05/senior-session-eugene-oregon-photographer-pnw-dawn-photo-119_websize.jpg'),
        Section(id: 'g_gown', eventTypeId: 'graduation', name: 'Gown & Cap', description: 'Graduation Dress Rental', image: 'https://img.freepik.com/free-vector/graduation-clothing-gown-cap-realistic-illustration-traditional-suit-school_1441-2329.jpg?semt=ais_rp_progressive&w=740&q=80'),
        Section(id: 'g_gifts', eventTypeId: 'graduation', name: 'Gifts', description: 'Graduation Gifts', image: 'https://m.media-amazon.com/images/I/71ZhAKwWuCL._AC_UF894,1000_QL80_.jpg'),
        Section(id: 'g_food', eventTypeId: 'graduation', name: 'Food', description: 'Party Food & Snacks', image: 'https://i.pinimg.com/236x/29/95/a0/2995a038b2bee0275bfa33644dd9d482.jpg'),
      ];
    }

    return [];
  }

  // ═══════════════════════════════════════════════════════════════════════
  // HANDLE NAVIGATION TO SECTION SCREENS
  // ═══════════════════════════════════════════════════════════════════════
  void _handleNavigation(BuildContext context, Section section) {
    final sName = section.name.toLowerCase();
    final eName = eventTypeName.toLowerCase();

    if (sName.contains('food') || sName.contains('catering') || sName.contains('dinner')) {
      Navigator.pushNamed(context, AppRoutes.foodMenu);
      return;
    }

    if (eName.contains('marriage') || eName.contains('wedding')) {
      if (sName.contains('vidhi')) {
        Navigator.pushNamed(context, AppRoutes.marriageVidhi);
      } else if (sName.contains('decor')) {
        Navigator.pushNamed(context, AppRoutes.marriageDecor, arguments: {'sectionId': section.id, 'sectionName': section.name});
      } else if (sName.contains('sangeet')) {
        Navigator.pushNamed(context, AppRoutes.marriageSangeet);
      } else if (sName.contains('photo')) {
        Navigator.pushNamed(context, AppRoutes.marriagePhotography);
      } else if (sName.contains('makeup')) {
        Navigator.pushNamed(context, AppRoutes.marriageMakeup);
      } else if (sName.contains('mehendi')) {
        Navigator.pushNamed(context, AppRoutes.marriageMehendi);
      }
      return;
    }

    if (eName.contains('birthday')) {
      if (sName.contains('cake')) {
        Navigator.pushNamed(context, AppRoutes.birthdayCake);
      } else if (sName.contains('decor')) {
        Navigator.pushNamed(context, AppRoutes.birthdayDecor);
      } else if (sName.contains('entertainment')) {
        Navigator.pushNamed(context, AppRoutes.birthdayEntertainment);
      } else if (sName.contains('photo')) {
        Navigator.pushNamed(context, AppRoutes.birthdayPhotography);
      } else if (sName.contains('gift')) {
        Navigator.pushNamed(context, AppRoutes.birthdayReturnGifts);
      }
      return;
    }
// 💍 ENGAGEMENT
// ═════════════════════════════════════════════════════════════════════
    if (eName.contains('engagement')) {
    if (sName.contains('ring')) {
    Navigator.pushNamed(context, AppRoutes.engagementRing);
    } else if (sName.contains('decor')) {
    Navigator.pushNamed(context, AppRoutes.engagementDecor);
    } else if (sName.contains('photo')) {
    Navigator.pushNamed(context, AppRoutes.engagementPhotography);
    } else if (sName.contains('makeup')) {
    Navigator.pushNamed(context, AppRoutes.engagementMakeup);
    } else if (sName.contains('mehendi')) {
    Navigator.pushNamed(context, AppRoutes.engagementMehendi);
    } else if (sName.contains('music') || sName.contains('dj')) {
    Navigator.pushNamed(context, AppRoutes.engagementMusic);
    }
    return;
    }

// ═════════════════════════════════════════════════════════════════════
// 💑 ANNIVERSARY
// ═════════════════════════════════════════════════════════════════════
    if (eName.contains('anniversary')) {
    if (sName.contains('decor')) {
    Navigator.pushNamed(context, AppRoutes.anniversaryDecor);
    } else if (sName.contains('cake')) {
    Navigator.pushNamed(context, AppRoutes.anniversaryCake);
    } else if (sName.contains('photo')) {
    Navigator.pushNamed(context, AppRoutes.anniversaryPhotography);
    } else if (sName.contains('music')) {
    Navigator.pushNamed(context, AppRoutes.anniversaryMusic);
    } else if (sName.contains('gift')) {
    Navigator.pushNamed(context, AppRoutes.anniversaryGifts);
    }
    return;
    }

// ═════════════════════════════════════════════════════════════════════
// 👶 BABY SHOWER
// ═════════════════════════════════════════════════════════════════════
    if (eName.contains('baby') || eName.contains('shower')) {
    if (sName.contains('decor')) {
    Navigator.pushNamed(context, AppRoutes.babyShowerDecor);
    } else if (sName.contains('cake')) {
    Navigator.pushNamed(context, AppRoutes.babyShowerCake);
    } else if (sName.contains('game')) {
    Navigator.pushNamed(context, AppRoutes.babyShowerGames);
    } else if (sName.contains('photo')) {
    Navigator.pushNamed(context, AppRoutes.babyShowerPhotography);
    } else if (sName.contains('gift')) {
    Navigator.pushNamed(context, AppRoutes.babyShowerGifts);
    }
    return;
    }

// ═════════════════════════════════════════════════════════════════════
// 🏢 CORPORATE
// ═════════════════════════════════════════════════════════════════════
    if (eName.contains('corporate') || eName.contains('office')) {
    if (sName.contains('venue')) {
    Navigator.pushNamed(context, AppRoutes.corporateVenue);
    } else if (sName.contains('decor')) {
    Navigator.pushNamed(context, AppRoutes.corporateDecor);
    } else if (sName.contains('av') || sName.contains('equipment')) {
    Navigator.pushNamed(context, AppRoutes.corporateAV);
    } else if (sName.contains('photo')) {
    Navigator.pushNamed(context, AppRoutes.corporatePhotography);
    } else if (sName.contains('gift')) {
    Navigator.pushNamed(context, AppRoutes.corporateGifts);
    } else if (sName.contains('team')) {
    Navigator.pushNamed(context, AppRoutes.corporateTeamBuilding);
    }
    return;
    }

// ═════════════════════════════════════════════════════════════════════
// 🎉 PARTY
// ═════════════════════════════════════════════════════════════════════
    if (eName.contains('party')) {
    if (sName.contains('decor')) {
    Navigator.pushNamed(context, AppRoutes.partyDecor);
    } else if (sName.contains('dj') || sName.contains('music')) {
    Navigator.pushNamed(context, AppRoutes.partyDJ);
    } else if (sName.contains('photo')) {
    Navigator.pushNamed(context, AppRoutes.partyPhotography);
    } else if (sName.contains('bar') || sName.contains('drink')) {
    Navigator.pushNamed(context, AppRoutes.partyBar);
    } else if (sName.contains('game')) {
    Navigator.pushNamed(context, AppRoutes.partyGames);
    }
    return;
    }

// ═════════════════════════════════════════════════════════════════════
// 🎓 GRADUATION
// ═════════════════════════════════════════════════════════════════════
    if (eName.contains('graduation') || eName.contains('convocation')) {
    if (sName.contains('decor')) {
    Navigator.pushNamed(context, AppRoutes.graduationDecor);
    } else if (sName.contains('cake')) {
    Navigator.pushNamed(context, AppRoutes.graduationCake);
    } else if (sName.contains('photo')) {
    Navigator.pushNamed(context, AppRoutes.graduationPhotography);
    } else if (sName.contains('gown') || sName.contains('cap')) {
    Navigator.pushNamed(context, AppRoutes.graduationGown);
    } else if (sName.contains('gift')) {
    Navigator.pushNamed(context, AppRoutes.graduationGifts);
    }
    return;
    }

// ═════════════════════════════════════════════════════════════════════
// 📦 DEFAULT - Generic Packages Screen
// ═════════════════════════════════════════════════════════════════════
    Navigator.pushNamed(
    context,
    AppRoutes.packages,
    arguments: {
    'sectionId': section.id,
    'sectionName': section.name,
    },
    );
  }

  @override
  Widget build(BuildContext context) {
    final sections = _getSectionsList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Light Professional Gray
      appBar: AppBar(
        title: Text('$eventTypeName Services',
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18)),
        centerTitle: true,
        backgroundColor: const Color(0xFF1A237E), // Midnight Indigo
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        // ✅ ADDED: CART ICON BUTTON HERE
        actions: [_buildCartBadge(context)],
      ),
      body: sections.isEmpty
          ? const Center(child: Text('Coming Soon!'))
          : ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        itemCount: sections.length,
        itemBuilder: (context, index) {
          return SectionCard(
            section: sections[index],
            onTap: () => _handleNavigation(context, sections[index]),
          );
        },
      ),
    );
  }

  // ─── CART ICON WITH REAL-TIME BADGE ───────────────────────────────
  Widget _buildCartBadge(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        int count = cart.items.length;
        return Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white, size: 26),
                onPressed: () => Navigator.pushNamed(context, AppRoutes.cart),
              ),
              if (count > 0)
                Positioned(
                  right: 6,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                    constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Text(
                      '$count',
                      style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
            ],
          ),
        );
      },
    );
  }
}
