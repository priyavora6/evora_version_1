// lib/providers/event_type_provider.dart

import 'package:flutter/material.dart';
import '../models/event_type_model.dart';
import '../services/event_type_service.dart';

class EventTypeProvider extends ChangeNotifier {
  final EventTypeService _service = EventTypeService();

  List<EventType> _eventTypes = [];
  EventType? _selectedEventType;
  bool _isLoading = false;
  String? _error;

  List<EventType> get eventTypes => _eventTypes;
  EventType? get selectedEventType => _selectedEventType;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Fetch all event types
  Future<void> fetchEventTypes() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _eventTypes = await _service.getAllEventTypes();
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  // Select event type
  void selectEventType(EventType eventType) {
    _selectedEventType = eventType;
    notifyListeners();
  }

  // Clear selection
  void clearSelection() {
    _selectedEventType = null;
    notifyListeners();
  }

  // Get event type by ID
  EventType? getEventTypeById(String id) {
    try {
      return _eventTypes.firstWhere((e) => e.id == id);
    } catch (e) {
      return null;
    }
  }
}