import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ✅ Import our custom, clean models!
import '../models/category_model.dart';
import '../models/subcategory_model.dart';
import '../models/service_model.dart';

class CategoryProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ✅ Use our custom models here
  List<CategoryModel> categories = [];
  List<SubCategoryModel> subcategories = [];
  List<ServiceModel> services = [];

  bool isLoading = false;

  // ==========================================
  // LEVEL 1: FETCH CATEGORIES (Wedding, Party)
  // ==========================================
  Future<void> fetchCategories() async {
    isLoading = true;
    notifyListeners();

    try {
      debugPrint("🔍 Fetching categories from Firestore...");
      var snapshot = await _db.collection('categories').get();
      
      debugPrint("📊 Found ${snapshot.docs.length} category documents");

      // ✅ Map to CategoryModel and filter out empty/invalid ones
      categories = snapshot.docs
          .map((doc) => CategoryModel.fromFirestore(doc))
          .where((c) => c.name.isNotEmpty && c.isActive) // Filter out empty names
          .toList();
      
      // Sort manually by order
      categories.sort((a, b) => a.order.compareTo(b.order));
      
      debugPrint("✅ Processed ${categories.length} valid active categories");
    } catch (e) {
      debugPrint("❌ Error fetching categories: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  // ==========================================
  // LEVEL 2: FETCH SUB-CATEGORIES (Haldi, Birthday)
  // ==========================================
  Future<void> fetchSubcategories(String categoryId) async {
    isLoading = true;
    notifyListeners();

    try {
      debugPrint("🔍 Fetching subcategories for category: $categoryId");
      var snapshot = await _db.collection('subcategories')
          .where('categoryId', isEqualTo: categoryId)
          .get();

      // ✅ Map to SubCategoryModel
      subcategories = snapshot.docs.map((doc) => SubCategoryModel.fromFirestore(doc)).toList();
      debugPrint("✅ Found ${subcategories.length} subcategories");
    } catch (e) {
      debugPrint("❌ Error fetching subcategories: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  // ==========================================
  // LEVEL 3: FETCH SERVICES (Cakes, Decor, Photography)
  // ==========================================
  Future<void> fetchServices(String subcategoryId) async {
    isLoading = true;
    notifyListeners();
    services = []; // Clear previous services

    try {
      debugPrint("🔍 Fetching services for subcategory: $subcategoryId");
      var snapshot = await _db.collection('services')
          .where('categoryId', isEqualTo: subcategoryId)
          .get();

      // 🔍 FALLBACK: If no services found and it's a 'Food & Catering' subcategory (id ends with _food),
      // we check for the generic 'food_menu' items.
      if (snapshot.docs.isEmpty && subcategoryId.endsWith('_food')) {
        snapshot = await _db.collection('services')
            .where('categoryId', isEqualTo: 'food_menu')
            .get();
      }

      // ✅ Map to ServiceModel
      services = snapshot.docs.map((doc) => ServiceModel.fromFirestore(doc)).toList();
      debugPrint("✅ Fetched ${services.length} services for $subcategoryId");
    } catch (e) {
      debugPrint("❌ Error fetching services: $e");
    }

    isLoading = false;
    notifyListeners();
  }
}
