# 📁 Developer Debug Documentation

Welcome to the FruiteForest developer documentation. This folder contains internal documentation for developers.

> ⚠️ **This folder is gitignored** - Do not commit sensitive information here.

---

## 📚 Documentation Index

| File                                       | Description                                             |
| ------------------------------------------ | ------------------------------------------------------- |
| [DEVELOPER_DEBUG.md](./DEVELOPER_DEBUG.md) | Complete architecture, BLoC details, database functions |
| [analysis_page.md](./analysis_page.md)     | Analysis feature with configurable charts               |
| [auth.md](./auth.md)                       | Authentication flow documentation                       |
| [homepage.md](./homepage.md)               | Timer/Focus session documentation                       |
| [store.md](./store.md)                     | Store/E-commerce documentation                          |

---

## 🏗️ Project Architecture Overview

```
lib/
├── main.dart                 # Entry point, Supabase init, BLoC providers
├── common/                   # Shared code
│   ├── services/            # Platform services (DND)
│   └── theme/               # Colors, text styles, ThemeData
└── feature/                 # Feature modules
    ├── auth/                # Authentication
    ├── homepage/            # Timer/Focus sessions
    ├── analysis_page/       # Analytics dashboards
    └── store/               # E-commerce/Rewards
```

### Feature Module Pattern

Each feature follows this consistent structure:

```
feature_name/
├── bloc/                    # State management
│   ├── *_bloc.dart         # BLoC class (business logic)
│   ├── *_event.dart        # Events (user actions)
│   └── *_state.dart        # States (UI states)
├── config/                  # Feature configuration (optional)
├── model/                   # Data models/entities
├── presentation/            # UI layer
│   ├── *_page.dart         # Screen/Page widget
│   └── widgets/            # Reusable widgets
└── repository/              # Data access layer
    └── *_repository.dart   # Database/API calls
```

### Why This Structure?

1. **Separation of Concerns**: Each layer has one responsibility
2. **Testability**: BLoC and Repository can be unit tested
3. **Scalability**: Add new features without touching others
4. **Maintainability**: Easy to find and modify code

---

## 🐛 Debugging Guide

### Hot Reload

Press `r` in the `flutter run` terminal to hot reload changes.

### Common Issues

| Issue                 | Solution                                                   |
| --------------------- | ---------------------------------------------------------- |
| BLoC not updating UI  | Check `BlocBuilder` key, ensure events are dispatched      |
| Supabase RPC errors   | Check function name, parameter types in Supabase dashboard |
| Real-time not working | Verify table has replication enabled                       |
| DND not enabling      | Check notification access permission on Android            |

### Debug Commands

```bash
# Run with verbose logs
flutter run -v

# Analyze code
flutter analyze

# Rebuild if state is broken
flutter clean && flutter pub get && flutter run
```

---

## 📝 Adding New Features

1. Create folder: `lib/feature/new_feature/`
2. Add subfolders: `bloc/`, `model/`, `presentation/`, `repository/`
3. Create BLoC with events and states
4. Add repository for data access
5. Create page widget with `BlocBuilder`
6. Register BLoC in `main.dart` `MultiBlocProvider`
7. Add documentation in `developer_debug/`
