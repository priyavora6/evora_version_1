import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../../config/app_colors.dart';
import '../../config/app_routes.dart';
import '../../providers/cart_provider.dart';
import '../../models/category_model.dart'; // ✅ Import CategoryModel
import 'dashboard_screen.dart';

class ShowcaseTab extends StatefulWidget {
  const ShowcaseTab({super.key});

  @override
  State<ShowcaseTab> createState() => _ShowcaseTabState();
}

class _ShowcaseTabState extends State<ShowcaseTab> {
  String selectedFilter = 'All';

  final List<String> categories = [
    'All',
    'Wedding',
    'Engagement',
    'Party',
    'Corporate',
    'Anniversary',
    'Baby Shower',
    'Graduation'
  ];

   //═══════════════════════════════════════════════════════════════════════
  // 💼 MASSIVE PORTFOLIO DATA (8 Categories x 10 Items = 80 Real Events)
  // ═══════════════════════════════════════════════════════════════════════
  List<Map<String, dynamic>> get portfolioItems => [

    // ─── 1. WEDDINGS (10) ───
    {
      'title': 'Royal Palace Wedding',
      'category': 'Wedding',
      'location': 'Udaipur Palace',
      'image': 'https://akm-img-a-in.tosshub.com/indiatoday/images/story/202602/wedding-192354333-16x9.jpg?VersionId=fkEUn2BvTPrWY6JY3QwwPsem2U7XOCX7&size=690:388',
      'desc': 'A magnificent 3-day destination wedding with traditional Vidhi, Sangeet, and Reception.',
      'typeId': 'wedding'
    },
    {
      'title': 'Sunset Beach Vows',
      'category': 'Wedding',
      'location': 'Goa Resort',
      'image': 'https://thumbs.dreamstime.com/b/couple-stands-hand-exchanging-vows-sunset-serene-beach-framed-lush-greenery-exchanges-beautiful-wedding-surrounded-349279492.jpg',
      'desc': 'Dreamy floral mandap right on the sand with a sunset backdrop.',
      'typeId': 'wedding'
    },
    {
      'title': 'Traditional Kerala Wedding',
      'category': 'Wedding',
      'location': 'Kochi Backwaters',
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTfgBl5h4cgH-0Oo0sNrZ9R_BMWCin3tbcP7A&s',
      'desc': 'Serene morning ceremony with marigold decor and traditional Sadhya feast.',
      'typeId': 'wedding'
    },
    {
      'title': 'White Christian Wedding',
      'category': 'Wedding',
      'location': 'St. Mary’s Cathedral',
      'image': 'https://images.unsplash.com/photo-1511285560929-80b456fea0bc?auto=format&fit=crop&q=80&w=800',
      'desc': 'Elegant aisle setup with white lilies, live choir, and vintage car entry.',
      'typeId': 'wedding'
    },
    {
      'title': 'Sangeet Night Extravaganza',
      'category': 'Wedding',
      'location': 'City Club Arena',
      'image': 'https://thumbs.dreamstime.com/b/sea-dance-festival-dj-set-crowd-budva-july-paradiso-stage-music-july-budva-jaz-beach-montenegro-77463978.jpg',
      'desc': 'A night of dance featuring a 40ft LED stage and celebrity DJ.',
      'typeId': 'wedding'
    },
    {
      'title': 'Mountain Destination',
      'category': 'Wedding',
      'location': 'Mussoorie Hills',
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRdGz4wWK-8rbJRy9rtMlMUJCrAVmhBTHrXMw&s',
      'desc': 'Breathtaking ceremony amidst the clouds with rustic wooden decor.',
      'typeId': 'wedding'
    },
    {
      'title': 'Grand Reception Gala',
      'category': 'Wedding',
      'location': 'JW Marriott',
      'image': 'https://images.unsplash.com/photo-1519167758481-83f550bb49b3?auto=format&fit=crop&q=80&w=800',
      'desc': 'A luxurious evening with a 5-tier cake, jazz band, and seated dinner.',
      'typeId': 'wedding'
    },
    {
      'title': 'Haldi & Mehndi Fun',
      'category': 'Wedding',
      'location': 'Resort Lawn',
      'image': 'https://floweraura-blog-img.s3.ap-south-1.amazonaws.com/Holi/famous-jewish-gujju-wedding.jpg',
      'desc': 'Yellow themed haldi function with phoolon ki holi.',
      'typeId': 'wedding'
    },
    {
      'title': 'Vintage Garden Wedding',
      'category': 'Wedding',
      'location': 'Heritage Bungalow',
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQRD4AEKpm_P09L4w855jDqSaDNMUt9QvF4gg&s',
      'desc': 'Rustic theme with fairy lights and pastel florals.',
      'typeId': 'wedding'
    },
    {
      'title': 'Intimate Temple Wedding',
      'category': 'Wedding',
      'location': 'Iskcon Temple',
      'image': 'https://images.squarespace-cdn.com/content/v1/6744250b81521d675423a80c/1736842969506-OQMCT6NUOOAP5885E37X/29484099217_fa3015ccf2_o-e1536057903277.jpeg',
      'desc': 'Spiritual and simple ceremony with close family.',
      'typeId': 'wedding'
    },

    // ─── 2. ENGAGEMENT (10) ───
    {
      'title': 'Rooftop Roka Ceremony',
      'category': 'Engagement',
      'location': 'Skyline Terrace',
      'image': 'https://www.pakwaancandlelightdinner.com/images/family-roka-dinner.jpg',
      'desc': 'Intimate ring ceremony with fairy lights.',
      'typeId': 'engagement'
    },
    {
      'title': 'Garden Ring Exchange',
      'category': 'Engagement',
      'location': 'Botanical Garden',
      'image': 'https://media.istockphoto.com/id/940217166/photo/exchange-of-wedding-rings-white.jpg?s=612x612&w=0&k=20&c=90KBKD25Ab6NevFoA3bW4hqrX3FLM4dAl5FU6NLBTPo=',
      'desc': 'Lush green outdoor setup with hanging floral baskets.',
      'typeId': 'engagement'
    },
    {
      'title': 'Golden Glam Engagement',
      'category': 'Engagement',
      'location': 'Luxury Banquet',
      'image': 'https://media.weddingz.in/images/11b44d75ab84c9d57d7559de787838a9/Wedding-Reception-Stage-Decoration-Ideas10.jpg',
      'desc': 'Premium gold and white decor with crystal chandeliers.',
      'typeId': 'engagement'
    },
    {
      'title': 'Beach Proposal Setup',
      'category': 'Engagement',
      'location': 'Private Beach',
      'image': 'https://jusst4you.com/wp-content/uploads/2023/10/SJG004.webp',
      'desc': 'Marry Me light letters on the sand.',
      'typeId': 'engagement'
    },
    {
      'title': 'Boho Chic Engagement',
      'category': 'Engagement',
      'location': 'The Barn',
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTEwFxDmhRStG-Z8FbglHFSWJWzbq6jgK322A&s',
      'desc': 'Rustic theme with pampas grass and macrame.',
      'typeId': 'engagement'
    },
    {
      'title': 'Minimalist Ring Ceremony',
      'category': 'Engagement',
      'location': 'Home Garden',
      'image': 'https://moeindia.com/wp-content/uploads/2025/05/Engagement-ceremony-decorations.webp',
      'desc': 'Simple and elegant home setup with pastel florals.',
      'typeId': 'engagement'
    },
    {
      'title': 'Poolside Ring Party',
      'category': 'Engagement',
      'location': 'Villa Pool',
      'image': 'https://media.weddingz.in/images/8783a77558a0c86290e4328abecaa4a7/10-Super-Fun-and-Quirky-Ideas-to-throw-the-most-Epic-Pool-Party-at-your-Wedding-1.jpg',
      'desc': 'Casual ring exchange with a pool party vibe.',
      'typeId': 'engagement'
    },
    {
      'title': 'Black Tie Engagement',
      'category': 'Engagement',
      'location': 'City Hotel',
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQrNTqvfrSnlwBKm42lXi0l4DwcNxqFhOjTEQ&s',
      'desc': 'Formal evening with suits, gowns, and jazz music.',
      'typeId': 'engagement'
    },
    {
      'title': 'Floral Arch Surprise',
      'category': 'Engagement',
      'location': 'Park Gazebo',
      'image': 'https://www.woofern.com/public/uploads/all/uX6tzCfmn45i83eOB4DL4wpbjiCONPRZ6e2QDAax.png',
      'desc': 'Surprise proposal setup with a massive flower arch.',
      'typeId': 'engagement'
    },
    {
      'title': 'Traditional Sagai',
      'category': 'Engagement',
      'location': 'Community Hall',
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQr6JoBIUfTmbhpUGu_goYa933ujSTD79cNzQ&s',
      'desc': 'Traditional family gathering for ring exchange.',
      'typeId': 'engagement'
    },

    // ─── 3. BIRTHDAY (10) ───
    {
      'title': 'Superhero 5th B’day',
      'category': 'Birthday',
      'location': 'Private Farmhouse',
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTBfYCfLfnM1xoD4MWIvn_QFQ1gM3uuYfeBMg&s',
      'desc': 'Avengers-themed setup with custom cutouts.',
      'typeId': 'birthday'
    },
    {
      'title': 'Sweet 16 Paris Theme',
      'category': 'Birthday',
      'location': 'Rooftop Cafe',
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQsQrfESO_xjua7LmxdX4a8M-EbNa7CEKypcQ&s',
      'desc': 'Eiffel Tower cutouts and pink macarons.',
      'typeId': 'birthday'
    },
    {
      'title': 'Dino-Mite 3rd Birthday',
      'category': 'Birthday',
      'location': 'Community Garden',
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRrAS41wKWFXYYhRA9EPjUVKkcVSAJUju0t-g&s',
      'desc': 'Jungle setup with giant dinosaur props.',
      'typeId': 'birthday'
    },
    {
      'title': '70th Milestone Dinner',
      'category': 'Birthday',
      'location': 'Banquet Hall',
      'image': 'https://cdn.shopify.com/s/files/1/0493/5680/0149/files/DZ_70th_birthday_Grandstand_candle_holder_copy.jpg?v=1691451953',
      'desc': 'Nostalgic evening with memory walk gallery.',
      'typeId': 'birthday'
    },
    {
      'title': 'Unicorn Fantasy Party',
      'category': 'Birthday',
      'location': 'Indoor Play Zone',
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT0qC8NcWxIGthpr_T0TIe_9YcA4wDi95ZcVg&s',
      'desc': 'Pastel rainbow decor and glitter station.',
      'typeId': 'birthday'
    },
    {
      'title': 'First Birthday Carnival',
      'category': 'Birthday',
      'location': 'City Park',
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR2nv1D6v3SRR4EghBA31XJrNzhzW50zalXvQ&s',
      'desc': 'Grand carnival with popcorn and bouncy castles.',
      'typeId': 'birthday'
    },
    {
      'title': 'Space Theme Adventure',
      'category': 'Birthday',
      'location': 'Science Museum',
      'image': 'https://www.partyfoxx.in/cdn/shop/files/Space-theme-decoration.jpg?v=1751437968',
      'desc': 'Astronaut props and galaxy backdrop.',
      'typeId': 'birthday'
    },
    {
      'title': 'Princess Tea Party',
      'category': 'Birthday',
      'location': 'Home Backyard',
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSh0D_dabZnZPMTTatN7clSESYWDv8kJXvYvw&s',
      'desc': 'Elegant tea party for little princesses.',
      'typeId': 'birthday'
    },
    {
      'title': 'Harry Potter Wizardry',
      'category': 'Birthday',
      'location': 'Library Hall',
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRSPfUmONe9wipuNf_uVkuNZDKMEJeNIz5hcQ&s',
      'desc': 'Magic wands, floating candles, and wizard robes.',
      'typeId': 'birthday'
    },
    {
      'title': 'Construction Theme',
      'category': 'Birthday',
      'location': 'Playground',
      'image': 'https://theballoonwala.com/cdn/shop/files/104-PXL_20250613_140927035.jpg?v=1750218903&width=1946',
      'desc': 'Yellow hats, diggers, and sand play area.',
      'typeId': 'birthday'
    },

    // ─── 4. CORPORATE (10) ───
    {
      'title': 'TechFlow Annual Summit',
      'category': 'Corporate',
      'location': 'Grand Hyatt',
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRqIAjE5Rgz3ngaMr_uifD7OS3n5SyrntESpg&s',
      'desc': 'High-tech gathering for 500+ employees.',
      'typeId': 'corporate'
    },
    {
      'title': 'Product Launch 2024',
      'category': 'Corporate',
      'location': 'Convention Centre',
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQkchajoU2JO783HRTtOg0huyNSwIn9UoofXg&s',
      'desc': 'Launch event with stage pyrotechnics.',
      'typeId': 'corporate'
    },
    {
      'title': 'Annual Awards Night',
      'category': 'Corporate',
      'location': 'The Oberoi',
      'image': 'https://www.bizzabo.com/wp-content/uploads/2021/09/The-Europas-Awards-Ceremony-Ideas-min.png',
      'desc': 'Black-tie event with crystal trophies.',
      'typeId': 'corporate'
    },
    {
      'title': 'Startup Hackathon',
      'category': 'Corporate',
      'location': 'Co-working Space',
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSVncrfE_mAnzZ9aX0wHJzmmSJGSB2pg1a2sQ&s',
      'desc': '24-hour coding marathon setup.',
      'typeId': 'corporate'
    },
    {
      'title': 'Executive Retreat',
      'category': 'Corporate',
      'location': 'Hill Resort',
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRFpPZ7Z8bbt6OkWccH1LZ5l57beJ1tKsq4wA&s',
      'desc': 'Team building weekend with trekking.',
      'typeId': 'corporate'
    },
    {
      'title': 'High Tea Networking',
      'category': 'Corporate',
      'location': 'Golf Club',
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR363n2QumISxfdZM2Ly1B9GtKb-tgIuCaOTg&s',
      'desc': 'Casual networking event with gourmet tea.',
      'typeId': 'corporate'
    },
    {
      'title': 'Diwali Office Party',
      'category': 'Corporate',
      'location': 'Office HQ',
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRIKEFIue8hoCexRHWxGmG-F3ZNbgd2BgU5dg&s',
      'desc': 'Traditional office celebration with rangoli.',
      'typeId': 'corporate'
    },
    {
      'title': 'Workshop & Training',
      'category': 'Corporate',
      'location': 'Training Hall',
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ-NS3Hh2Z7mbvrqmx3rj9xhYLNpRMfQcEC9w&s',
      'desc': 'Educational setup with projectors and kits.',
      'typeId': 'corporate'
    },
    {
      'title': 'Company Sports Day',
      'category': 'Corporate',
      'location': 'Sports Complex',
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSBlP68E4vPGvEAnjGn0hDRyJ2kwl6COaYJSg&s',
      'desc': 'Outdoor sports tournament for employees.',
      'typeId': 'corporate'
    },
    {
      'title': 'Christmas Office Gala',
      'category': 'Corporate',
      'location': 'Banquet Hall',
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRxBPSykJwJOkzIpx9qTTrhNjsAj4mZbfPdtw&s',
      'desc': 'Holiday party with Secret Santa.',
      'typeId': 'corporate'
    },

    // ─── 5. PARTY (10) ───
    {
      'title': 'Neon Moonlight Party',
      'category': 'Party',
      'location': 'Sky Deck Lounge',
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTUNtQk66BlsKLoEoJrlan01KfJx-GUqmyXxg&s',
      'desc': 'Cocktail night with UV décor.',
      'typeId': 'party'
    },
    {
      'title': 'Holi Rain Dance',
      'category': 'Party',
      'location': 'Resort Lawns',
      'image': 'https://i0.wp.com/holi.shrih.net/wp-content/uploads/2024/02/rain-dance-setup-3.jpg?fit=800%2C448&ssl=1',
      'desc': 'Organic colors, rain dance setup.',
      'typeId': 'party'
    },
    {
      'title': 'Diwali Card Party',
      'category': 'Party',
      'location': 'Luxury Villa',
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSMTplyDCF_RocM6PcKENYMmDf9qurbTQT1wg&s',
      'desc': 'Festive night with poker tables.',
      'typeId': 'party'
    },
    {
      'title': 'Halloween Spookfest',
      'category': 'Party',
      'location': 'Old Manor House',
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQodVLNU2bpTqtRv_ab533b1nqxn_zZVo3QgQ&s',
      'desc': 'Costume party with cobweb decor.',
      'typeId': 'party'
    },
    {
      'title': 'Poolside Sundowner',
      'category': 'Party',
      'location': 'Weekend Villa',
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR1ZaoIEs_N1Qu3o3Nnxo7qjgpDRbaGWTUx0Q&s',
      'desc': 'Relaxed evening with tropical drinks.',
      'typeId': 'party'
    },
    {
      'title': 'Bachelor Poker Night',
      'category': 'Party',
      'location': 'Penthouse Suite',
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS5_hTVV3bYb_lO3qWr8g0AM04NszX383WqRA&s',
      'desc': 'Gentleman’s evening with whiskey tasting.',
      'typeId': 'party'
    },
    {
      'title': 'Masquerade Ball',
      'category': 'Party',
      'location': 'Ballroom',
      'image': 'https://ichef.bbci.co.uk/news/480/cpsprodpb/d129/live/2b9ed730-a1b4-11ef-a4fe-a3e9a6c5d640.png.webp',
      'desc': 'Mysterious mask party with live orchestra.',
      'typeId': 'party'
    },
    {
      'title': 'New Year Yacht Party',
      'category': 'Party',
      'location': 'Private Yacht',
      'image': 'https://www.dubainewyeareve.com/wp-content/uploads/2024/11/new-year-shared-luxurious-yacht-tour-1024x692.webp',
      'desc': 'Exclusive countdown party on the sea.',
      'typeId': 'party'
    },
    {
      'title': 'Retro 80s Disco',
      'category': 'Party',
      'location': 'Club Lounge',
      'image': 'https://www.shutterstock.com/image-vector/retro-style-80s-disco-design-600w-340573127.jpg',
      'desc': 'Mirror balls and retro music night.',
      'typeId': 'party'
    },
    {
      'title': 'Kitty Party High Tea',
      'category': 'Party',
      'location': 'Cafe Patio',
      'image': 'https://cdn.shopify.com/s/files/1/1269/4785/files/MaevaTuticorinShootMay18-5_large.jpg?v=1526982689',
      'desc': 'Afternoon tea party with games.',
      'typeId': 'party'
    },

    // ─── 6. ANNIVERSARY (10) ───
    {
      'title': 'Silver Jubilee Gala',
      'category': 'Anniversary',
      'location': 'ITC Maratha',
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTN_WL1KYzLZLT8cjFiSFwnGP_yk7ClBTX32Q&s',
      'desc': 'Celebrating 25 years with a live sufi band.',
      'typeId': 'anniversary'
    },
    {
      'title': 'Romantic Yacht Dinner',
      'category': 'Anniversary',
      'location': 'Private Yacht',
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQns2J98UUR-DIdfrs1WcFPL8vThjFzVPoKwA&s',
      'desc': 'Exclusive sunset cruise with private chef.',
      'typeId': 'anniversary'
    },
    {
      'title': '50th Golden Celebration',
      'category': 'Anniversary',
      'location': 'Heritage Hotel',
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ--hBVPZ_6IW_4kEAmsOlXBasEGcAfs4_z5A&s',
      'desc': 'Grand celebration with memory lane.',
      'typeId': 'anniversary'
    },
    {
      'title': 'Surprise Rooftop Dinner',
      'category': 'Anniversary',
      'location': 'Sky Lounge',
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRjIjZIogmqJtzdwDEVY2M8jfxPpnvSydjRmg&s',
      'desc': 'Candlelight dinner under the stars.',
      'typeId': 'anniversary'
    },
    {
      'title': 'Renewal of Vows',
      'category': 'Anniversary',
      'location': 'Resort Garden',
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ8VSUJZqBNGoYI3EYy_pb7600oDnSH2Kt1yw&s',
      'desc': 'Recreating the wedding magic.',
      'typeId': 'anniversary'
    },
    {
      'title': '1st Anniversary Trip',
      'category': 'Anniversary',
      'location': 'Hill Station',
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcROVsmpnbv_h7EBDqvJ0uiyW6_SX4_GWYp24Q&s',
      'desc': 'Weekend getaway setup with decor.',
      'typeId': 'anniversary'
    },
    {
      'title': 'Home Candlelight Surprise',
      'category': 'Anniversary',
      'location': 'Living Room',
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR7A2uIYXZMCdaZysMwQNwfQVsUO0ozztT6_A&s',
      'desc': 'Rose petals and candles at home.',
      'typeId': 'anniversary'
    },
    {
      'title': 'Movie Night Setup',
      'category': 'Anniversary',
      'location': 'Garden',
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS0zRwTkU3PUXgvReb8Sta9PSK_Y6E_eBLw7Q&s',
      'desc': 'Outdoor projector and cozy seating.',
      'typeId': 'anniversary'
    },
    {
      'title': 'Brunch with Friends',
      'category': 'Anniversary',
      'location': 'Bistro',
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrOpVfaXQuFKedvJFH_q8fQuhvCyr4zJOd1g&s',
      'desc': 'Casual anniversary brunch party.',
      'typeId': 'anniversary'
    },
    {
      'title': 'Wine Tasting Tour',
      'category': 'Anniversary',
      'location': 'Vineyard',
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTCRZhT4609nIaCguFLKBEXHBSq4qaaPs5Hqg&s',
      'desc': 'Private tour and tasting session.',
      'typeId': 'anniversary'
    },

    // ─── 7. BABY SHOWER (10) ───
    {
      'title': 'Simran’s Boho Shower',
      'category': 'Baby Shower',
      'location': 'Garden Cafe',
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTBOlzGfU6Vtz-4CYOrXXi0AmxpfUBezx7GWA&s',
      'desc': 'Pastel-themed brunch with floral swing.',
      'typeId': 'babyshower'
    },
    {
      'title': 'Gender Reveal Blast',
      'category': 'Baby Shower',
      'location': 'Open Lawn',
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRVHDGBKjT28_pRmtW35a0u6MYmcpodNlO_XA&s',
      'desc': 'Blue/Pink smoke reveal with drone.',
      'typeId': 'babyshower'
    },
    {
      'title': 'Traditional Godh Bharai',
      'category': 'Baby Shower',
      'location': 'Home Setup',
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaSHb1uKSzecl_usCNdPhaIDow6z7CxmhoXQ&s',
      'desc': 'Authentic traditional decor.',
      'typeId': 'babyshower'
    },
    {
      'title': 'Bridal Shower Brunch',
      'category': 'Baby Shower',
      'location': 'Floral Cafe',
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSUyhd84gY5T-sDuLdpX4iN4E1ZUIb-yJtFFA&s',
      'desc': 'Chic brunch with flower crowns.',
      'typeId': 'babyshower'
    },
    {
      'title': 'Blue Theme Welcome',
      'category': 'Baby Shower',
      'location': 'Banquet',
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR7T2S9xWNcb53N8PjkEWLKc47kmClU3E74hw&s',
      'desc': 'It’s a Boy theme party.',
      'typeId': 'babyshower'
    },
    {
      'title': 'Pink Princess Theme',
      'category': 'Baby Shower',
      'location': 'Backyard',
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ-LWrv1GuQtPJiFdeY23K_bW2vN883fLVxzA&s',
      'desc': 'It’s a Girl theme party.',
      'typeId': 'babyshower'
    },
    {
      'title': 'Elephant & Clouds',
      'category': 'Baby Shower',
      'location': 'Indoor Hall',
      'image': 'https://m.media-amazon.com/images/I/71ak0sknTqL._AC_UF350,350_QL80_.jpg',
      'desc': 'Cute props for neutral theme.',
      'typeId': 'babyshower'
    },

    {
      'title': 'Baby BBQ Party',
      'category': 'Baby Shower',
      'location': 'Garden',
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTwxRVlBQeKeQDEr23-DgYb14YPCB03slJV6A&s',
      'desc': 'Casual BaBy-Q lunch.',
      'typeId': 'babyshower'
    },
    {
      'title': 'Tea Party Shower',
      'category': 'Baby Shower',
      'location': 'Tea Room',
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSYkvFZl2EueJ8c3mwgwtWSRBiIyxpET9J69w&s',
      'desc': 'Classic English tea party.',
      'typeId': 'babyshower'
    },

    // ─── 8. GRADUATION (10) ───
    {
      'title': 'Class of 2024 Bash',
      'category': 'Graduation',
      'location': 'University Grounds',
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR-GZgzfGwT4P-WXutq_oKfkZzxqBpsWStBOQ&s',
      'desc': 'Outdoor graduation party with cap-toss.',
      'typeId': 'graduation'
    },
    {
      'title': 'Prom Night Send-off',
      'category': 'Graduation',
      'location': 'City Ballroom',
      'image': 'https://m.media-amazon.com/images/I/513iHwvolzL._AC_UF894,1000_QL80_.jpg',
      'desc': 'Black-tie prom night with red carpet.',
      'typeId': 'graduation'
    },
    {
      'title': 'Convocation After-Party',
      'category': 'Graduation',
      'location': 'Rooftop Lounge',
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRtiLJBbN0W27cOAQ4mEyBXiFp3ZJir3PIDCg&s',
      'desc': 'Celebratory dinner with degree cake.',
      'typeId': 'graduation'
    },
    {
      'title': 'High School Farewell',
      'category': 'Graduation',
      'location': 'School Audi',
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTMnRcRpJCzyvRUKXIv6yN4T-9C2rYXFfSmsA&s',
      'desc': 'Emotional farewell with speeches.',
      'typeId': 'graduation'
    },
    {
      'title': 'PhD Success Dinner',
      'category': 'Graduation',
      'location': 'Fine Dining',
      'image': 'https://images.unsplash.com/photo-1565022536102-f7645c84354a?auto=format&fit=crop&q=80&w=800',
      'desc': 'Formal dinner for doctorate achievement.',
      'typeId': 'graduation'
    },
    {
      'title': 'Garden Grad Party',
      'category': 'Graduation',
      'location': 'Home Garden',
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTPGPvpNMMNoNPFfc1-5VVkH3cRn20AQRMWhA&s',
      'desc': 'Family BBQ graduation party.',
      'typeId': 'graduation'
    },
    {
      'title': 'Degree Ceremony Decor',
      'category': 'Graduation',
      'location': 'Campus',
      'image': 'https://images.unsplash.com/photo-1554415707-6e8cfc93fe23?auto=format&fit=crop&q=80&w=800',
      'desc': 'Stage and podium setup.',
      'typeId': 'graduation'
    },
    {
      'title': 'Virtual Graduation',
      'category': 'Graduation',
      'location': 'Online',
      'image': 'https://images.unsplash.com/photo-1627556704290-2b1f5853ff78?auto=format&fit=crop&q=80&w=800',
      'desc': 'Live streamed event for remote students.',
      'typeId': 'graduation'
    },
    {
      'title': 'Alumni Networking',
      'category': 'Graduation',
      'location': 'Hotel Hall',
      'image': 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRpgAb5rGFJugB63boYlIrsOItdR_Wmy-sD6g&s',
      'desc': 'Meet and greet for past graduates.',
      'typeId': 'graduation'
    },

  ];


  // 🧭 NAVIGATION HELPER
  void _navigateToEvent(BuildContext context, String categoryName, String typeId) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    cartProvider.clearCart();

    // ✅ Create a model to pass to the next screen
    final selectedCategory = CategoryModel(
      id: typeId,
      name: categoryName,
      emoji: '',
      description: '',
      icon: '',
    );

    Navigator.pushNamed(
      context,
      AppRoutes.subCategory, // Navigates to SubcategoriesScreen
      arguments: {'category': selectedCategory}, // ✅ Matches updated app_routes.dart
    );
  }

  void _openProjectDetails(BuildContext context, Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _PortfolioDetailSheet(
        item: item,
        onBook: () {
          Navigator.pop(context);
          _navigateToEvent(context, item['category'], item['typeId'] ?? 'party');
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = selectedFilter == 'All'
        ? portfolioItems
        : portfolioItems.where((i) => i['category'] == selectedFilter).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Event Gallery',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () {
            // ✅ Redirect to Home Tab of Dashboard
            final dashboardState = context.findAncestorStateOfType<DashboardScreenState>();
            if (dashboardState != null) {
              dashboardState.setIndex(0);
            } else {
              AppRoutes.navigateToUserDashboard(context);
            }
          },
        ),
      ),
      body: Column(
        children: [
          // ─── FILTER CHIPS ───
          Container(
            color: AppColors.primary,
            padding: const EdgeInsets.symmetric(vertical: 8),
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final cat = categories[index];
                final isSelected = selectedFilter == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: InkWell(
                    onTap: () => setState(() => selectedFilter = cat),
                    borderRadius: BorderRadius.circular(25),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white : Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: isSelected ? Colors.white : Colors.white.withOpacity(0.4),
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        cat,
                        style: TextStyle(
                          color: isSelected ? AppColors.primary : Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // ─── MASONRY GRID ───
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
              itemCount: filteredList.length,
              itemBuilder: (context, index) => _PortfolioCard(
                item: filteredList[index],
                onTap: () => _openProjectDetails(context, filteredList[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PortfolioCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onTap;

  const _PortfolioCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: item['image'],
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => Container(color: Colors.grey[200], child: const Icon(Icons.broken_image)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item['category'].toUpperCase(), style: const TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(item['title'], style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14), maxLines: 1),
                  const SizedBox(height: 4),
                  Row(children: [
                    const Icon(Icons.location_on, size: 12, color: Colors.grey),
                    Expanded(child: Text(item['location'], style: const TextStyle(color: Colors.grey, fontSize: 11), maxLines: 1)),
                  ]),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _PortfolioDetailSheet extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onBook;

  const _PortfolioDetailSheet({required this.item, required this.onBook});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: CachedNetworkImage(imageUrl: item['image'], height: 250, width: double.infinity, fit: BoxFit.cover),
                  ),
                  const SizedBox(height: 20),
                  Text(item['title'], style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(item['desc'], style: const TextStyle(color: Colors.black54, height: 1.5)),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: onBook,
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      child: const Text("Plan an Event Like This", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
