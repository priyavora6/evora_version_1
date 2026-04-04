// lib/providers/section_provider.dart

import 'package:flutter/material.dart';
import '../models/section_model.dart';
import '../models/item_model.dart';
import '../models/package_model.dart';
import '../services/section_service.dart';
import '../services/item_service.dart';
import '../services/package_service.dart';

class SectionProvider extends ChangeNotifier {
  final SectionService _sectionService = SectionService();
  final ItemService _itemService = ItemService();
  final PackageService _packageService = PackageService();

  List<Section> _sections = [];
  Section? _selectedSection;
  List<SectionItem> _sectionItems = [];
  List<Package> _packages = [];
  bool _isLoading = false;
  String? _error;

  List<Section> get sections => _sections;
  Section? get selectedSection => _selectedSection;
  List<SectionItem> get sectionItems => _sectionItems;
  List<Package> get packages => _packages;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Fetch sections by event type
  Future<void> fetchSectionsByEventType(String eventTypeId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _sections = await _sectionService.getSectionsByEventType(eventTypeId);
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  // Select section
  void selectSection(Section section) {
    _selectedSection = section;
    notifyListeners();
  }

  // Fetch items for a section
  Future<void> fetchSectionItems(String sectionId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _sectionItems = await _itemService.getItemsBySection(sectionId);
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  // Fetch packages for a section (decoration)
  Future<void> fetchPackages(String sectionId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _packages = await _packageService.getPackagesBySection(sectionId);
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  // Clear data
  void clearData() {
    _sections = [];
    _selectedSection = null;
    _sectionItems = [];
    _packages = [];
    notifyListeners();
  }
}