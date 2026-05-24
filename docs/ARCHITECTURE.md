# App Architecture

## MVVM Pattern
- Model: Data classes in lib/models/
- View: UI screens in lib/screens/
- ViewModel: Business logic in lib/view_models/

## Folder Structure

```text
lib/
├── core/          -> app_colors, app_theme, app_routes, constants
├── models/        -> product, cart, order, user, address models
├── screens/       -> all UI screens organized by feature
├── services/      -> Firebase repositories (auth, cart, orders, etc.)
├── view_models/   -> business logic for each screen
├── data/          -> dummy/seed data
└── main.dart      -> app entry point
```

## Data Flow

User Action -> ViewModel -> Repository -> Firebase -> ViewModel -> UI Update

## Key Services
- firebase_auth_service.dart -> handles all auth operations
- product_repository.dart -> Firestore product CRUD
- cart_repository.dart -> cart persistence
- order_repository.dart -> order management
- user_profile_repository.dart -> profile updates
