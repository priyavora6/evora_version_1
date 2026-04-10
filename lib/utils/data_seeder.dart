import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataSeeder {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const String _seedingKey = 'data_seeded_v1';

  static Future<void> uploadAllData({bool force = false}) async {
    final prefs = await SharedPreferences.getInstance();
    final bool isAlreadySeeded = prefs.getBool(_seedingKey) ?? false;

    if (isAlreadySeeded && !force) {
      debugPrint("ℹ️ Data already seeded. Skipping upload. Use force: true to re-upload.");
      return;
    }

    debugPrint("⏳ STARTING DATA UPLOAD FROM JSON FILES...");

    try {
      // 1. Upload Categories
      debugPrint("📦 Uploading Categories...");
      await _uploadCollection('assets/data/categories.json', 'categories');

      // 2. Upload Subcategories
      debugPrint("📦 Uploading Subcategories...");
      await _uploadCollection('assets/data/subcategories.json', 'subcategories');

      // 3. Upload Services
      debugPrint("📦 Uploading Services...");
      await _uploadCollection('assets/data/services.json', 'services');

      // Mark as seeded
      await prefs.setBool(_seedingKey, true);

      debugPrint("✅✅✅ ALL DATA SUCCESSFULLY UPLOADED TO FIREBASE! ✅✅✅");
      debugPrint("🚀 Restart the app to see all services.");

    } catch (e) {
      debugPrint("❌❌❌ ERROR UPLOADING DATA: $e ❌❌❌");
    }
  }

  static Future<void> _uploadCollection(String jsonPath, String collectionName) async {
    try {
      String jsonString = await rootBundle.loadString(jsonPath);
      dynamic jsonData = jsonDecode(jsonString);

      List<Map<String, dynamic>> itemsToUpload = [];

      if (collectionName == 'services') {
        itemsToUpload = _flattenServices(jsonData);
      } else if (jsonData is Map && jsonData.containsKey(collectionName)) {
        itemsToUpload = List<Map<String, dynamic>>.from(jsonData[collectionName]);
      } else if (jsonData is List) {
        itemsToUpload = List<Map<String, dynamic>>.from(jsonData);
      } else if (jsonData is Map<String, dynamic>) {
        itemsToUpload = [jsonData];
      }

      if (itemsToUpload.isEmpty) {
        debugPrint("⚠️ No items found to upload for $collectionName.");
        return;
      }

      debugPrint("🔍 Preparing to upload ${itemsToUpload.length} items to '$collectionName'...");

      WriteBatch batch = _db.batch();
      int operationCount = 0;
      int totalUploaded = 0;

      for (var item in itemsToUpload) {
        String? docId = item['id']?.toString() ?? item['subCategoryId']?.toString() ?? item['subcategoryId']?.toString();
        
        if (docId == null && collectionName == 'services') {
          String cat = (item['categoryId'] ?? 'unknown').toString();
          String name = (item['name'] ?? 'service').toString();
          docId = "${cat}_${name}".toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '_');
        }

        DocumentReference ref = _db.collection(collectionName).doc(docId ?? _db.collection(collectionName).doc().id);

        batch.set(ref, item, SetOptions(merge: true));
        operationCount++;
        totalUploaded++;

        if (operationCount >= 400) {
          await batch.commit();
          batch = _db.batch();
          operationCount = 0;
          debugPrint("⏳ Progress: $totalUploaded/${itemsToUpload.length} items uploaded to '$collectionName'...");
        }
      }

      if (operationCount > 0) {
        await batch.commit();
      }

      debugPrint("✅ Done: $totalUploaded items uploaded to '$collectionName'.");

    } catch (e) {
      debugPrint("❌ Error uploading $collectionName: $e");
    }
  }

  static List<Map<String, dynamic>> _flattenServices(dynamic data) {
    List<Map<String, dynamic>> flatList = [];

    void traverse(dynamic item, {String? subCatId}) {
      if (item is List) {
        for (var i in item) {
          traverse(i, subCatId: subCatId);
        }
      } else if (item is Map<String, dynamic>) {
        String? currentSubCatId = item['subCategoryId'] ?? item['subcategoryId'] ?? subCatId;

        if (item.containsKey('services') && item['services'] is List) {
          traverse(item['services'], subCatId: currentSubCatId);
        } else if (item.containsKey('name')) {
          Map<String, dynamic> leaf = Map<String, dynamic>.from(item);
          if (currentSubCatId != null) {
            leaf['categoryId'] = currentSubCatId;
          }
          flatList.add(leaf);
        }
      }
    }

    traverse(data);
    return flatList;
  }
}