import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_colors.dart';
import '../../config/app_routes.dart';
import '../../config/app_strings.dart';
import '../../models/cart_item_model.dart';
import '../../providers/cart_provider.dart';

class FoodMenuScreen extends StatefulWidget {
  const FoodMenuScreen({super.key});

  @override
  State<FoodMenuScreen> createState() => _FoodMenuScreenState();
}

class _FoodMenuScreenState extends State<FoodMenuScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';

  static const String sectionId = 'food';
  static const String sectionName = 'Food';

  final List<String> _categories = [
    'All', 'Starters', 'Punjabi', 'Chinese', 'South Indian', 'Continental',
    'Tandoor & Breads', 'Biryani & Rice', 'Dal & Curry', 'Soups', 'Salads',
    'Desserts', 'Ice Cream', 'Beverages', 'Chaat', 'Live Counters',
  ];

  // ═══════════════════════════════════════════════════════════════════════
  // COMPLETE VEG FOOD DATABASE (150 ITEMS)
  // ═══════════════════════════════════════════════════════════════════════
  static const List<_FoodItem> _allFoodItems = [
    // 🥗 STARTERS (20)
    _FoodItem(id: 'st_01', name: 'Paneer Tikka', price: 180, category: 'Starters', description: 'Marinated paneer cubes grilled in tandoor'),
    _FoodItem(id: 'st_02', name: 'Hara Bhara Kebab', price: 160, category: 'Starters', description: 'Spinach and peas patties with spices'),
    _FoodItem(id: 'st_03', name: 'Veg Spring Roll', price: 140, category: 'Starters', description: 'Crispy rolls with sautéed vegetables'),
    _FoodItem(id: 'st_04', name: 'Mushroom Tikka', price: 190, category: 'Starters', description: 'Stuffed mushroom caps grilled to perfection'),
    _FoodItem(id: 'st_05', name: 'Paneer 65', price: 200, category: 'Starters', description: 'Spicy deep fried paneer chunks'),
    _FoodItem(id: 'st_06', name: 'Veg Crispy', price: 170, category: 'Starters', description: 'Batter fried assorted vegetables'),
    _FoodItem(id: 'st_07', name: 'Corn Cheese Balls', price: 210, category: 'Starters', description: 'Crunchy balls with melting cheese center'),
    _FoodItem(id: 'st_08', name: 'Dahi Ke Kebab', price: 220, category: 'Starters', description: 'Creamy kebabs made from hung curd'),
    _FoodItem(id: 'st_09', name: 'Veg Seekh Kebab', price: 180, category: 'Starters', description: 'Minced vegetable skewers'),
    _FoodItem(id: 'st_10', name: 'Paneer Malai Tikka', price: 210, category: 'Starters', description: 'Paneer marinated in cream and cashew'),
    _FoodItem(id: 'st_11', name: 'Baby Corn Fry', price: 160, category: 'Starters', description: 'Crispy fried baby corn with dip'),
    _FoodItem(id: 'st_12', name: 'Gobi 65', price: 150, category: 'Starters', description: 'Spicy marinated cauliflower florets'),
    _FoodItem(id: 'st_13', name: 'Tandoori Aloo', price: 150, category: 'Starters', description: 'Scooped spiced potatoes from tandoor'),
    _FoodItem(id: 'st_14', name: 'Veg Manchurian Dry', price: 160, category: 'Starters', description: 'Cabbage balls in soya garlic sauce'),
    _FoodItem(id: 'st_15', name: 'Aloo Tikki', price: 120, category: 'Starters', description: 'Potato patties served with mint chutney'),
    _FoodItem(id: 'st_16', name: 'Cheese Chilly Toast', price: 180, category: 'Starters', description: 'Toast topped with cheese and green chilies'),
    _FoodItem(id: 'st_17', name: 'Soya Chaap Tikka', price: 190, category: 'Starters', description: 'Marinated soya chunks grilled'),
    _FoodItem(id: 'st_18', name: 'Dragon Potato', price: 160, category: 'Starters', description: 'Spicy honey glazed potato wedges'),
    _FoodItem(id: 'st_19', name: 'Paneer Pakora', price: 150, category: 'Starters', description: 'Classic gram flour batter fried paneer'),
    _FoodItem(id: 'st_20', name: 'Veg Cutlet', price: 130, category: 'Starters', description: 'Hearty mixed vegetable fried cakes'),

    // 🍛 PUNJABI (20)
    _FoodItem(id: 'pj_01', name: 'Paneer Butter Masala', price: 240, category: 'Punjabi', description: 'Rich tomato gravy with paneer chunks'),
    _FoodItem(id: 'pj_02', name: 'Kadhai Paneer', price: 230, category: 'Punjabi', description: 'Paneer cooked with bell peppers'),
    _FoodItem(id: 'pj_03', name: 'Shahi Paneer', price: 250, category: 'Punjabi', description: 'Royal cashew based sweet gravy'),
    _FoodItem(id: 'pj_04', name: 'Palak Paneer', price: 220, category: 'Punjabi', description: 'Fresh spinach puree with paneer'),
    _FoodItem(id: 'pj_05', name: 'Malai Kofta', price: 260, category: 'Punjabi', description: 'Paneer balls in creamy white gravy'),
    _FoodItem(id: 'pj_06', name: 'Paneer Tikka Masala', price: 270, category: 'Punjabi', description: 'Grilled paneer in spicy tikka gravy'),
    _FoodItem(id: 'pj_07', name: 'Mix Veg', price: 200, category: 'Punjabi', description: 'Assorted seasonal vegetables in masala'),
    _FoodItem(id: 'pj_08', name: 'Mutter Paneer', price: 210, category: 'Punjabi', description: 'Green peas and cottage cheese curry'),
    _FoodItem(id: 'pj_09', name: 'Aloo Gobi Mutter', price: 180, category: 'Punjabi', description: 'Potato, cauliflower and peas dry'),
    _FoodItem(id: 'pj_10', name: 'Baingan Bharta', price: 190, category: 'Punjabi', description: 'Roasted mashed eggplant with peas'),
    _FoodItem(id: 'pj_11', name: 'Bhindi Do Pyaza', price: 180, category: 'Punjabi', description: 'Okra with double the onions'),
    _FoodItem(id: 'pj_12', name: 'Dum Aloo Punjabi', price: 220, category: 'Punjabi', description: 'Baby potatoes in thick red gravy'),
    _FoodItem(id: 'pj_13', name: 'Kaju Curry', price: 280, category: 'Punjabi', description: 'Roasted cashews in spicy brown gravy'),
    _FoodItem(id: 'pj_14', name: 'Methi Mutter Malai', price: 240, category: 'Punjabi', description: 'Fenugreek and peas in cream gravy'),
    _FoodItem(id: 'pj_15', name: 'Mushroom Masala', price: 230, category: 'Punjabi', description: 'Fresh mushrooms in onion tomato gravy'),
    _FoodItem(id: 'pj_16', name: 'Paneer Lababdar', price: 260, category: 'Punjabi', description: 'Creamy gravy with grated and cubed paneer'),
    _FoodItem(id: 'pj_17', name: 'Veg Kofta', price: 210, category: 'Punjabi', description: 'Vegetable dumplings in spicy gravy'),
    _FoodItem(id: 'pj_18', name: 'Chole Bhature Special', price: 180, category: 'Punjabi', description: 'Spiced chickpeas with fluffy bread'),
    _FoodItem(id: 'pj_19', name: 'Veg Kolhapuri', price: 220, category: 'Punjabi', description: 'Extra spicy mixed vegetable curry'),
    _FoodItem(id: 'pj_20', name: 'Jeera Aloo', price: 160, category: 'Punjabi', description: 'Cumin tempered dry potatoes'),

    // 🥡 CHINESE (15)
    _FoodItem(id: 'ch_01', name: 'Veg Manchurian Gravy', price: 180, category: 'Chinese', description: 'Veg balls in dark soya gravy'),
    _FoodItem(id: 'ch_02', name: 'Veg Hakka Noodles', price: 170, category: 'Chinese', description: 'Stir fried noodles with veggies'),
    _FoodItem(id: 'ch_03', name: 'Veg Fried Rice', price: 160, category: 'Chinese', description: 'Classic wok tossed fried rice'),
    _FoodItem(id: 'ch_04', name: 'Schezwan Noodles', price: 185, category: 'Chinese', description: 'Spicy noodles in schezwan sauce'),
    _FoodItem(id: 'ch_05', name: 'Chilly Paneer Gravy', price: 220, category: 'Chinese', description: 'Paneer in spicy chilly sauce'),
    _FoodItem(id: 'ch_06', name: 'Triple Schezwan Rice', price: 240, category: 'Chinese', description: 'Rice, noodles and manchurian combo'),
    _FoodItem(id: 'ch_07', name: 'American Chopsuey', price: 210, category: 'Chinese', description: 'Crispy noodles with sweet tangy sauce'),
    _FoodItem(id: 'ch_08', name: 'Singapore Noodles', price: 190, category: 'Chinese', description: 'Yellow curry flavored noodles'),
    _FoodItem(id: 'ch_09', name: 'Veg Momos Steamed', price: 120, category: 'Chinese', description: 'Handmade dumplings (10 pcs)'),
    _FoodItem(id: 'ch_10', name: 'Veg Momos Fried', price: 140, category: 'Chinese', description: 'Crispy fried dumplings'),
    _FoodItem(id: 'ch_11', name: 'Honey Chilly Potato', price: 160, category: 'Chinese', description: 'Crispy potato in sweet spicy glaze'),
    _FoodItem(id: 'ch_12', name: 'Burnt Garlic Rice', price: 180, category: 'Chinese', description: 'Aromatic garlic tossed rice'),
    _FoodItem(id: 'ch_13', name: 'Veg Chowmein', price: 150, category: 'Chinese', description: 'Street style spicy noodles'),
    _FoodItem(id: 'ch_14', name: 'Paneer 65 Dry', price: 200, category: 'Chinese', description: 'Spicy fried paneer appetizer'),
    _FoodItem(id: 'ch_15', name: 'Kimchi Salad', price: 100, category: 'Chinese', description: 'Traditional cabbage salad'),

    // 🍚 SOUTH INDIAN (15)
    _FoodItem(id: 'si_01', name: 'Masala Dosa', price: 110, category: 'South Indian', description: 'Rice crepe with potato masala'),
    _FoodItem(id: 'si_02', name: 'Paneer Dosa', price: 140, category: 'South Indian', description: 'Dosa stuffed with paneer bhurji'),
    _FoodItem(id: 'si_03', name: 'Mysore Masala Dosa', price: 130, category: 'South Indian', description: 'Spicy red chutney spread dosa'),
    _FoodItem(id: 'si_04', name: 'Idli Sambar', price: 80, category: 'South Indian', description: 'Steamed rice cakes with lentil stew'),
    _FoodItem(id: 'si_05', name: 'Medu Vada', price: 90, category: 'South Indian', description: 'Crispy deep fried lentil donuts'),
    _FoodItem(id: 'si_06', name: 'Onion Uttapam', price: 100, category: 'South Indian', description: 'Thick pancake with onion topping'),
    _FoodItem(id: 'si_07', name: 'Rava Masala Dosa', price: 130, category: 'South Indian', description: 'Crispy semolina crepe'),
    _FoodItem(id: 'si_08', name: 'Paper Plain Dosa', price: 120, category: 'South Indian', description: 'Extra thin and large crispy dosa'),
    _FoodItem(id: 'si_09', name: 'Cheese Masala Dosa', price: 150, category: 'South Indian', description: 'Masala dosa with melted cheese'),
    _FoodItem(id: 'si_10', name: 'Upma', price: 70, category: 'South Indian', description: 'Savory semolina breakfast dish'),
    _FoodItem(id: 'si_11', name: 'Pongal', price: 90, category: 'South Indian', description: 'Rice and lentil ghee mash'),
    _FoodItem(id: 'si_12', name: 'Curd Rice', price: 80, category: 'South Indian', description: 'Tempered yogurt and rice'),
    _FoodItem(id: 'si_13', name: 'Tomato Uttapam', price: 110, category: 'South Indian', description: 'Pancake with tomato and chilly'),
    _FoodItem(id: 'si_14', name: 'Set Dosa', price: 100, category: 'South Indian', description: 'Spongy soft small dosas (3 pcs)'),
    _FoodItem(id: 'si_15', name: 'Lemon Rice', price: 120, category: 'South Indian', description: 'Tangy rice with peanuts and curry leaves'),

    // 🍝 CONTINENTAL (10)
    _FoodItem(id: 'ct_01', name: 'White Sauce Pasta', price: 240, category: 'Continental', description: 'Penne in creamy alfredo sauce'),
    _FoodItem(id: 'ct_02', name: 'Red Sauce Pasta', price: 220, category: 'Continental', description: 'Fusilli in spicy arrabiata sauce'),
    _FoodItem(id: 'ct_03', name: 'Mix Sauce Pasta', price: 250, category: 'Continental', description: 'Pasta in pink creamy tomato sauce'),
    _FoodItem(id: 'ct_04', name: 'Margherita Pizza', price: 280, category: 'Continental', description: 'Classic cheese and basil pizza'),
    _FoodItem(id: 'ct_05', name: 'Veggie Pizza', price: 320, category: 'Continental', description: 'Pizza topped with mixed vegetables'),
    _FoodItem(id: 'ct_06', name: 'Garlic Bread with Cheese', price: 160, category: 'Continental', description: 'Toasted baguette with garlic butter'),
    _FoodItem(id: 'ct_07', name: 'Veg Burger', price: 140, category: 'Continental', description: 'Crispy patty with mayo and lettuce'),
    _FoodItem(id: 'ct_08', name: 'Paneer Burger', price: 170, category: 'Continental', description: 'Grilled paneer steak burger'),
    _FoodItem(id: 'ct_09', name: 'French Fries', price: 100, category: 'Continental', description: 'Salted golden potato fries'),
    _FoodItem(id: 'ct_10', name: 'Cheese Nachos', price: 180, category: 'Continental', description: 'Loaded with salsa and cheese sauce'),

    // 🔥 TANDOOR & BREADS (10)
    _FoodItem(id: 'td_01', name: 'Butter Naan', price: 50, category: 'Tandoor & Breads', description: 'Soft refined flour bread'),
    _FoodItem(id: 'td_02', name: 'Garlic Naan', price: 70, category: 'Tandoor & Breads', description: 'Naan topped with chopped garlic'),
    _FoodItem(id: 'td_03', name: 'Laccha Paratha', price: 60, category: 'Tandoor & Breads', description: 'Multi layered wheat bread'),
    _FoodItem(id: 'td_04', name: 'Tandoori Roti', price: 20, category: 'Tandoor & Breads', description: 'Whole wheat tandoori bread'),
    _FoodItem(id: 'td_05', name: 'Missi Roti', price: 40, category: 'Tandoor & Breads', description: 'Gram flour mixed masala roti'),
    _FoodItem(id: 'td_06', name: 'Paneer Kulcha', price: 90, category: 'Tandoor & Breads', description: 'Bread stuffed with spiced paneer'),
    _FoodItem(id: 'td_07', name: 'Stuffed Paratha', price: 80, category: 'Tandoor & Breads', description: 'Choice of Aloo, Gobi or Onion'),
    _FoodItem(id: 'td_08', name: 'Butter Roti', price: 25, category: 'Tandoor & Breads', description: 'Wheat roti with butter'),
    _FoodItem(id: 'td_09', name: 'Roomali Roti', price: 40, category: 'Tandoor & Breads', description: 'Paper thin large soft bread'),
    _FoodItem(id: 'td_10', name: 'Cheese Garlic Naan', price: 100, category: 'Tandoor & Breads', description: 'Naan stuffed with cheese and garlic'),

    // 🍚 BIRYANI & RICE (10)
    _FoodItem(id: 'br_01', name: 'Veg Dum Biryani', price: 260, category: 'Biryani & Rice', description: 'Slow cooked aromatic rice with veggies'),
    _FoodItem(id: 'br_02', name: 'Paneer Biryani', price: 290, category: 'Biryani & Rice', description: 'Biryani with marinated paneer cubes'),
    _FoodItem(id: 'br_03', name: 'Jeera Rice', price: 140, category: 'Biryani & Rice', description: 'Basmati rice tempered with cumin'),
    _FoodItem(id: 'br_04', name: 'Veg Pulao', price: 180, category: 'Biryani & Rice', description: 'Mildly spiced vegetable rice'),
    _FoodItem(id: 'br_05', name: 'Steamed Rice', price: 110, category: 'Biryani & Rice', description: 'Plain long grain basmati rice'),
    _FoodItem(id: 'br_06', name: 'Kashmiri Pulao', price: 220, category: 'Biryani & Rice', description: 'Sweet rice with fruits and nuts'),
    _FoodItem(id: 'br_07', name: 'Dal Khichdi Tadka', price: 200, category: 'Biryani & Rice', description: 'Comforting lentil and rice mix'),
    _FoodItem(id: 'br_08', name: 'Mushroom Pulao', price: 210, category: 'Biryani & Rice', description: 'Rice cooked with fresh mushrooms'),
    _FoodItem(id: 'br_09', name: 'Hyderabadi Veg Biryani', price: 270, category: 'Biryani & Rice', description: 'Spicy biryani with fried onions'),
    _FoodItem(id: 'br_10', name: 'Matar Pulao', price: 160, category: 'Biryani & Rice', description: 'Rice with green peas and spices'),

    // 🍲 DAL & CURRY (10)
    _FoodItem(id: 'dc_01', name: 'Dal Makhani', price: 210, category: 'Dal & Curry', description: 'Black lentils cooked overnight with cream'),
    _FoodItem(id: 'dc_02', name: 'Dal Tadka', price: 170, category: 'Dal & Curry', description: 'Yellow lentils with garlic tempering'),
    _FoodItem(id: 'dc_03', name: 'Dal Fry', price: 160, category: 'Dal & Curry', description: 'Lentils cooked with onion and tomato'),
    _FoodItem(id: 'dc_04', name: 'Rajma Masala', price: 190, category: 'Dal & Curry', description: 'Red kidney beans in thick gravy'),
    _FoodItem(id: 'dc_05', name: 'Chole Masala', price: 180, category: 'Dal & Curry', description: 'Spicy kabuli chana curry'),
    _FoodItem(id: 'dc_06', name: 'Kadhi Pakora', price: 170, category: 'Dal & Curry', description: 'Gram flour dumplings in yogurt curry'),
    _FoodItem(id: 'dc_07', name: 'Panchmel Dal', price: 200, category: 'Dal & Curry', description: 'Mix of 5 different lentils'),
    _FoodItem(id: 'dc_08', name: 'Gujarati Dal', price: 150, category: 'Dal & Curry', description: 'Sweet and sour lentil soup'),
    _FoodItem(id: 'dc_09', name: 'Dal Maharani', price: 220, category: 'Dal & Curry', description: 'Rich mixed lentils with butter'),
    _FoodItem(id: 'dc_10', name: 'Lasooni Dal Tadka', price: 180, category: 'Dal & Curry', description: 'Lentils with heavy garlic punch'),

    // 🥣 SOUPS & SALADS (10)
    _FoodItem(id: 'sp_01', name: 'Tomato Soup', price: 100, category: 'Soups', description: 'Classic roasted tomato soup'),
    _FoodItem(id: 'sp_02', name: 'Veg Manchow Soup', price: 110, category: 'Soups', description: 'Spicy soup with crispy noodles'),
    _FoodItem(id: 'sp_03', name: 'Sweet Corn Soup', price: 110, category: 'Soups', description: 'Creamy soup with corn kernels'),
    _FoodItem(id: 'sp_04', name: 'Hot & Sour Soup', price: 110, category: 'Soups', description: 'Spicy tangy vegetable soup'),
    _FoodItem(id: 'sl_01', name: 'Green Salad', price: 70, category: 'Salads', description: 'Fresh sliced garden vegetables'),
    _FoodItem(id: 'sl_02', name: 'Kachumber Salad', price: 60, category: 'Salads', description: 'Diced onion, tomato and cucumber'),
    _FoodItem(id: 'sl_03', name: 'Russian Salad', price: 130, category: 'Salads', description: 'Boiled veggies in creamy mayo'),
    _FoodItem(id: 'sl_04', name: 'Corn & Sprout Salad', price: 110, category: 'Salads', description: 'Healthy mix of sprouts and corn'),
    _FoodItem(id: 'sl_05', name: 'Macaroni Salad', price: 140, category: 'Salads', description: 'Pasta salad with bell peppers'),
    _FoodItem(id: 'sl_06', name: 'Pineapple Raita', price: 120, category: 'Salads', description: 'Sweet yogurt with pineapple chunks'),

    // 🍨 DESSERTS & ICE CREAM (20)
    _FoodItem(id: 'ds_01', name: 'Gulab Jamun', price: 80, category: 'Desserts', description: 'Hot milk dumplings (2 pcs)'),
    _FoodItem(id: 'ds_02', name: 'Rasmalai', price: 100, category: 'Desserts', description: 'Paneer discs in saffron milk'),
    _FoodItem(id: 'ds_03', name: 'Gajar Halwa', price: 120, category: 'Desserts', description: 'Winter special carrot pudding'),
    _FoodItem(id: 'ds_04', name: 'Moong Dal Halwa', price: 140, category: 'Desserts', description: 'Rich lentil halwa with ghee'),
    _FoodItem(id: 'ds_05', name: 'Jalebi with Rabri', price: 150, category: 'Desserts', description: 'Crispy jalebis with thick milk'),
    _FoodItem(id: 'ds_06', name: 'Kheer', price: 90, category: 'Desserts', description: 'Traditional rice pudding'),
    _FoodItem(id: 'ds_07', name: 'Kaju Katli', price: 180, category: 'Desserts', description: 'Cashew fudge (100g)'),
    _FoodItem(id: 'ds_08', name: 'Rasgulla', price: 80, category: 'Desserts', description: 'Soft syrupy cheese balls'),
    _FoodItem(id: 'ds_09', name: 'Chocolate Brownie', price: 150, category: 'Desserts', description: 'Warm eggless brownie'),
    _FoodItem(id: 'ds_10', name: 'Malpua', price: 110, category: 'Desserts', description: 'Sweet pancakes in syrup'),
    _FoodItem(id: 'ic_01', name: 'Vanilla Ice Cream', price: 70, category: 'Ice Cream', description: 'Classic vanilla scoop'),
    _FoodItem(id: 'ic_02', name: 'Chocolate Ice Cream', price: 80, category: 'Ice Cream', description: 'Rich chocolate cocoa scoop'),
    _FoodItem(id: 'ic_03', name: 'Butterscotch', price: 90, category: 'Ice Cream', description: 'Crunchy nut ice cream'),
    _FoodItem(id: 'ic_04', name: 'Mango Ice Cream', price: 90, category: 'Ice Cream', description: 'Alphonso mango flavor'),
    _FoodItem(id: 'ic_05', name: 'Kesar Pista Kulfi', price: 100, category: 'Ice Cream', description: 'Traditional stick kulfi'),
    _FoodItem(id: 'ic_06', name: 'Paan Ice Cream', price: 110, category: 'Ice Cream', description: 'Refreshing betel leaf flavor'),
    _FoodItem(id: 'ic_07', name: 'Strawberry Ice Cream', price: 80, category: 'Ice Cream', description: 'Fresh berry flavor'),
    _FoodItem(id: 'ic_08', name: 'Dry Fruit Mastani', price: 180, category: 'Ice Cream', description: 'Thick shake with ice cream'),
    _FoodItem(id: 'ic_09', name: 'Ice Cream Sandwich', price: 120, category: 'Ice Cream', description: 'Biscuit with vanilla filling'),
    _FoodItem(id: 'ic_10', name: 'Cassata Slice', price: 150, category: 'Ice Cream', description: 'Multi layered ice cream cake'),

    // 🥤 BEVERAGES (10)
    _FoodItem(id: 'bv_01', name: 'Mango Lassi', price: 100, category: 'Beverages', description: 'Thick yogurt mango drink'),
    _FoodItem(id: 'bv_02', name: 'Sweet Lassi', price: 80, category: 'Beverages', description: 'Creamy punjabi lassi'),
    _FoodItem(id: 'bv_03', name: 'Masala Chaas', price: 50, category: 'Beverages', description: 'Spiced butter milk'),
    _FoodItem(id: 'bv_04', name: 'Fresh Lime Soda', price: 70, category: 'Beverages', description: 'Salted or sweet soda'),
    _FoodItem(id: 'bv_05', name: 'Cold Coffee', price: 120, category: 'Beverages', description: 'Blended with vanilla ice cream'),
    _FoodItem(id: 'bv_06', name: 'Virgin Mojito', price: 130, category: 'Beverages', description: 'Mint and lemon cooler'),
    _FoodItem(id: 'bv_07', name: 'Blue Lagoon', price: 140, category: 'Beverages', description: 'Refreshing blue mocktail'),
    _FoodItem(id: 'bv_08', name: 'Masala Chai', price: 40, category: 'Beverages', description: 'Indian spiced milk tea'),
    _FoodItem(id: 'bv_09', name: 'Filter Coffee', price: 50, category: 'Beverages', description: 'Authentic south indian coffee'),
    _FoodItem(id: 'bv_10', name: 'Thandai Special', price: 110, category: 'Beverages', description: 'Dry fruit and saffron milk'),

    // 🍟 CHAAT (10)
    _FoodItem(id: 'cht_01', name: 'Pani Puri', price: 60, category: 'Chaat', description: '8 crispy puris with spiced water'),
    _FoodItem(id: 'cht_02', name: 'Bhel Puri', price: 70, category: 'Chaat', description: 'Puffed rice mix with chutneys'),
    _FoodItem(id: 'cht_03', name: 'Sev Puri', price: 80, category: 'Chaat', description: 'Flat puris topped with potato'),
    _FoodItem(id: 'cht_04', name: 'Dahi Puri', price: 90, category: 'Chaat', description: 'Puris filled with sweet yogurt'),
    _FoodItem(id: 'cht_05', name: 'Aloo Tikki Chaat', price: 100, category: 'Chaat', description: 'Potato patty with curd & chutneys'),
    _FoodItem(id: 'cht_06', name: 'Samosa Chaat', price: 90, category: 'Chaat', description: 'Crushed samosa with chickpeas'),
    _FoodItem(id: 'cht_07', name: 'Papdi Chaat', price: 80, category: 'Chaat', description: 'Crunchy papdis with masala'),
    _FoodItem(id: 'cht_08', name: 'Raj Kachori', price: 140, category: 'Chaat', description: 'Giant kachori with all toppings'),
    _FoodItem(id: 'cht_09', name: 'Ragda Pattice', price: 100, category: 'Chaat', description: 'Potato pattice with peas curry'),
    _FoodItem(id: 'cht_10', name: 'Pav Bhaji', price: 120, category: 'Chaat', description: 'Buttery pav with spicy mash'),

    // 🍳 LIVE COUNTERS (10)
    _FoodItem(id: 'lc_01', name: 'Live Dosa Counter', price: 500, category: 'Live Counters', description: 'Fresh dosas made live for guests'),
    _FoodItem(id: 'lc_02', name: 'Live Pasta Station', price: 600, category: 'Live Counters', description: 'Penne/Fusilli cooked on spot'),
    _FoodItem(id: 'lc_03', name: 'Live Mocktail Bar', price: 700, category: 'Live Counters', description: 'Bartender making fresh drinks'),
    _FoodItem(id: 'lc_04', name: 'Live Jalebi Counter', price: 400, category: 'Live Counters', description: 'Hot jalebis fried live'),
    _FoodItem(id: 'lc_05', name: 'Live Chaat Counter', price: 450, category: 'Live Counters', description: 'Assorted chaat station'),
    _FoodItem(id: 'lc_06', name: 'Live Stir Fry', price: 550, category: 'Live Counters', description: 'Exotic veggies tossed in wok'),
    _FoodItem(id: 'lc_07', name: 'Live Pizza Oven', price: 800, category: 'Live Counters', description: 'Thin crust pizzas in wood oven'),
    _FoodItem(id: 'lc_08', name: 'Live Pav Bhaji', price: 400, category: 'Live Counters', description: 'Hot pav bhaji from big tawa'),
    _FoodItem(id: 'lc_09', name: 'Live Ice Cream Rolls', price: 450, category: 'Live Counters', description: 'Hand rolled milk ice cream'),
    _FoodItem(id: 'lc_10', name: 'Live Momos Counter', price: 500, category: 'Live Counters', description: 'Steamed and fried momos station'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<_FoodItem> _getFilteredItems() {
    List<_FoodItem> items = List.from(_allFoodItems);
    final selectedCategory = _categories[_tabController.index];
    if (selectedCategory != 'All') {
      items = items.where((item) => item.category == selectedCategory).toList();
    }
    if (_searchQuery.isNotEmpty) {
      items = items.where((item) =>
      item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.description.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 180,
              pinned: true,
              backgroundColor: const Color(0xFF1A237E),
              leading: IconButton(
                icon: const CircleAvatar(
                  backgroundColor: Colors.black26,
                  child: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
                ),
                onPressed: () => Navigator.pop(context),
              ),
              actions: [
                _buildCartIcon(context),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF1A237E), Color(0xFF311B92)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Pure Veg Menu', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
                        Text('150+ Premium Selection Items', style: TextStyle(fontSize: 14, color: Colors.white70)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ];
        },
        body: Column(
          children: [
            _buildSearchBar(),
            _buildCategoryTabs(),
            Expanded(
              child: _buildFoodList(),
            ),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildCartIcon(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        final count = cart.items.where((i) => i.type == 'food').length;
        return Stack(
          alignment: Alignment.center,
          children: [
            IconButton(icon: const Icon(Icons.shopping_cart, color: Colors.white), onPressed: () => Navigator.pushNamed(context, AppRoutes.cart)),
            if (count > 0)
              Positioned(
                right: 8, top: 8,
                child: CircleAvatar(radius: 8, backgroundColor: Colors.red, child: Text('$count', style: const TextStyle(fontSize: 10, color: Colors.white))),
              )
          ],
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        children: [
          TextField(
            onChanged: (val) => setState(() => _searchQuery = val),
            decoration: InputDecoration(
              hintText: 'Search vegetarian dishes...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.eco, color: Colors.green, size: 20),
                  SizedBox(width: 6),
                  Text('100% Veg', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                ],
              ),
              Consumer<CartProvider>(
                builder: (context, cart, child) => Text('${cart.guestCount} Guests', style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        onTap: (index) => setState(() {}),
        indicatorColor: Colors.green,
        labelColor: Colors.green,
        unselectedLabelColor: Colors.grey,
        tabs: _categories.map((cat) => Tab(text: cat)).toList(),
      ),
    );
  }

  Widget _buildFoodList() {
    final items = _getFilteredItems();
    if (items.isEmpty) return const Center(child: Text("No items found"));
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) => _FoodItemCard(item: items[index], sectionId: sectionId, sectionName: sectionName),
    );
  }

  Widget _buildBottomBar() {
    return Consumer<CartProvider>(
      builder: (context, cart, child) {
        final foodItems = cart.items.where((i) => i.type == 'food').toList();
        if (foodItems.isEmpty) return const SizedBox.shrink();
        final total = foodItems.fold<double>(0, (sum, item) => sum + (item.price * cart.guestCount));

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)]),
          child: SafeArea(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('${foodItems.length} items added', style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text('${AppStrings.rupee}${total.toStringAsFixed(0)} total', style: const TextStyle(fontSize: 18, color: Colors.green, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.cart),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  child: const Text('DONE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _FoodItemCard extends StatelessWidget {
  final _FoodItem item;
  final String sectionId, sectionName;

  const _FoodItemCard({required this.item, required this.sectionId, required this.sectionName});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
      child: Row(
        children: [
          // Veg Icon
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(border: Border.all(color: Colors.green, width: 1.5), borderRadius: BorderRadius.circular(4)),
            child: const CircleAvatar(radius: 4, backgroundColor: Colors.green),
          ),
          const SizedBox(width: 12),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(item.description, style: const TextStyle(fontSize: 11, color: Colors.grey), maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text('${AppStrings.rupee}${item.price.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                    const SizedBox(width: 10),
                    const Icon(Icons.star, color: Colors.amber, size: 14),
                    const Text(' 4.5', style: TextStyle(fontSize: 11)),
                  ],
                ),
              ],
            ),
          ),
          // ADD BUTTON / TICK (Removed plus/minus)
          Consumer<CartProvider>(
            builder: (context, cartProvider, child) {
              final isInCart = cartProvider.isInCart(item.id);

              return isInCart
                  ? InkWell(
                onTap: () => cartProvider.removeItem(item.id),
                child: const Column(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 30),
                    Text("Added", style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold))
                  ],
                ),
              )
                  : ElevatedButton(
                onPressed: () {
                  final cartItem = CartItem(id: item.id, sectionId: sectionId, sectionName: sectionName, itemName: item.name, price: item.price, quantity: 1, image: '', type: 'food');
                  cartProvider.addItem(cartItem);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, foregroundColor: Colors.green,
                  side: const BorderSide(color: Colors.green), elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('ADD'),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _FoodItem {
  final String id, name, category, description;
  final double price;
  const _FoodItem({
    required this.id, required this.name, required this.price, required this.category,
    required this.description,
  });
}