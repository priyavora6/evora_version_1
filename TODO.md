# Dynamic Services & Payment Flow Implementation Plan
## Overview
Transform static hardcoded services into dynamic Firebase structure:
- **3 Collections**: `categories` → `subcategories` → `services`
- **Payment Flow**: 10-step user→admin→vendor model with admin profit tracking

## Steps (To be checked off as completed)

### Phase 1: Data Models & Collections ✅
1. ✅ Create `lib/models/category_model.dart`
2. ✅ Create `lib/models/subcategory_model.dart` 
3. ✅ Create `lib/models/service_model.dart`
4. ✅ Update `lib/models/payment_model.dart` for admin/vendor payments
5. ✅ Update `lib/models/vendor_booking_model.dart` for profit tracking

### Phase 2: Providers & Services [ ]
6. ✅ Create `lib/providers/category_provider.dart`
7. [ ] Create `lib/services/dynamic_service_service.dart`
8. [ ] Update `lib/providers/payment_provider.dart` (admin/vendor payments)
9. [ ] Update `lib/providers/cart_provider.dart` (dynamic services)

### Phase 3: Dynamic UI Screens [ ]
10. [ ] Create `lib/screens/dynamic/category_screen.dart`
11. [ ] Create `lib/screens/dynamic/subcategory_screen.dart`
12. [ ] Create `lib/screens/dynamic/service_screen.dart`
13. [ ] Create `lib/screens/admin/payment_flow_screen.dart`
14. [ ] Update `lib/config/app_routes.dart`

### Phase 4: Firestore & Seeding [ ]
15. [ ] Update `firestore.rules` (secure collections)
16. [ ] Create seed script `seed_dynamic_data.dart`
17. [ ] Run seed script (100+ services across wedding/birthday/corporate)

### Phase 5: Integration & Flow [ ]
18. [ ] Delete hardcoded service screens (birthday_cake.dart, etc.)
19. [ ] Update dashboard/home to use dynamic categories
20. [ ] Implement 10-step payment flow in providers
21. [ ] Test end-to-end: Select→Pay→Assign→Complete→Profit

### Phase 6: Cleanup & Polish [ ]
22. [ ] Remove old static routes/screens
23. [ ] Update all JSON/config files
24. [ ] Full testing & deployment

**Current Progress: Starting Phase 1**
**Est. Completion: 2-3 hours**
