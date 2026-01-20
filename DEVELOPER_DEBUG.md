# 🔬 FruiteForest - Developer Debug Documentation

> **⚠️ CONFIDENTIAL**: This file is gitignored and for developer use only

---

## 📂 Complete Directory Structure

```
FruiteForest/
├── lib/
│   ├── main.dart                                    # App entry point
│   │
│   ├── common/                                       # Shared utilities
│   │   ├── services/
│   │   │   └── dnd_service.dart                     # Do Not Disturb management
│   │   └── theme/
│   │       ├── app_theme/
│   │       │   └── app_theme.dart                   # Main theme configuration
│   │       ├── colors/
│   │       │   └── colors.dart                      # Color palette
│   │       └── text_theme/
│   │           └── text_theme.dart                  # Typography styles
│   │
│   └── feature/                                      # Feature modules
│       │
│       ├── auth/                                     # Authentication feature
│       │   ├── bloc/
│       │   │   ├── auth_bloc.dart                   # Auth business logic
│       │   │   ├── auth_event.dart                  # Auth events
│       │   │   └── auth_state.dart                  # Auth states
│       │   ├── presentation/
│       │   │   ├── welcome_page/
│       │   │   │   └── welcome_page.dart            # Landing screen
│       │   │   ├── splashscreen/
│       │   │   │   └── splash_screen.dart           # Splash screen
│       │   │   ├── login/
│       │   │   │   └── login_page.dart              # Phone login
│       │   │   ├── otp_verification/
│       │   │   │   └── otp_verification_page.dart   # OTP input
│       │   │   ├── createuser/
│       │   │   │   └── create_user_page.dart        # Profile setup
│       │   │   └── widgets/
│       │   │       └── bottom_button_auth_widget.dart
│       │   └── repository/
│       │       └── auth_repository.dart              # Auth data layer
│       │
│       ├── homepage/                                 # Home/Timer feature
│       │   ├── bloc/
│       │   │   ├── home_bloc.dart                   # Home business logic
│       │   │   ├── home_event.dart                  # Home events
│       │   │   └── home_state.dart                  # Home states
│       │   ├── model/
│       │   │   ├── activity_category_model.dart     # Category enum
│       │   │   └── activity_log_model.dart          # Activity log model
│       │   ├── presentation/
│       │   │   ├── home_page.dart                   # Main home screen
│       │   │   └── widget/
│       │   │       └── timer_widget.dart            # Countdown display
│       │   └── repository/
│       │       └── home_repository.dart              # Home data layer
│       │
│       ├── analysis_page/                            # Analytics feature
│       │   ├── bloc/
│       │   │   ├── analysis_bloc.dart               # Analysis logic
│       │   │   ├── analysis_event.dart              # Analysis events
│       │   │   └── analysis_state.dart              # Analysis states
│       │   ├── model/
│       │   │   └── heat_map_cell_model.dart         # Heatmap data model
│       │   ├── presentation/
│       │   │   ├── analysis_page.dart               # Analytics screen
│       │   │   └── widgets/
│       │   │       ├── activity_heat_map_widget.dart
│       │   │       └── category_pie_chart_widget.dart
│       │   └── repository/
│       │       └── analysis_repository.dart          # Analysis data layer
│       │
│       └── store/                                    # Store/Rewards feature
│           ├── bloc/
│           │   ├── store_bloc.dart                  # Store business logic
│           │   ├── store_event.dart                 # Store events
│           │   └── store_state.dart                 # Store states
│           ├── model/
│           │   ├── store_items_model.dart           # Item model
│           │   ├── shipping_address_model.dart      # Address model
│           │   └── order_model.dart                 # Order model
│           ├── presentation/
│           │   ├── store_page.dart                  # Store screen
│           │   ├── add_shipping_address_page.dart   # Add address
│           │   ├── edit_shipping_address_page.dart  # Edit address
│           │   └── widgets/
│           │       └── store_item_card_widget.dart  # Item card
│           └── repository/
│               └── store_repository.dart             # Store data layer
│
├── assets/
│   ├── font/outfit_font/                            # Custom font files
│   └── images/                                       # SVG/PNG assets
│
├── pubspec.yaml                                      # Dependencies
├── analysis_options.yaml                             # Linting rules
└── DEVELOPER_DEBUG.md                                # This file (gitignored)
```

---

## 🔐 Supabase Configuration

**Project URL**: `https://iatrojsqevuyuuvaeacm.supabase.co`
**Anon Key**: `sb_publishable_Kkn7vGRUEYWDNLtTSbx8aw_JvAk_MHy`

### Authentication Setup

- Method: Phone OTP (SMS)
- Provider: Supabase Auth
- Session Management: Automatic token refresh

---

## 🧠 STATE MANAGEMENT - BLoC Architecture Deep Dive

### 📦 A. AuthBloc - Authentication Management

**Location**: `lib/feature/auth/bloc/`

#### Events (auth_event.dart)

```dart
sealed class AuthEvent {}

// 1️⃣ Send OTP to phone number
class SendOtpEvent extends AuthEvent {
  final String phone;  // Format: "+91XXXXXXXXXX"
  SendOtpEvent(this.phone);
}

// 2️⃣ Verify received OTP code
class VerifyOtpEvent extends AuthEvent {
  final String phone;
  final String otp;    // 6-digit code
  VerifyOtpEvent({required this.phone, required this.otp});
}

// 3️⃣ Check if user is already authenticated (on app start)
class CheckAuthStatusEvent extends AuthEvent {}

// 4️⃣ Create user profile after first login
class CreateProfileEvent extends AuthEvent {
  final String name;
  final int age;
  final String gender;       // male, female, others
  final String profession;   // student, working professional, etc.
  final String purpose;      // focus, time management, etc.

  CreateProfileEvent({
    required this.name,
    required this.age,
    required this.gender,
    required this.profession,
    required this.purpose,
  });
}
```

#### States (auth_state.dart)

```dart
sealed class AuthState {}

class AuthInitial extends AuthState {}              // Initial state
class AuthLoading extends AuthState {}              // Processing request
class OtpSentSuccess extends AuthState {}           // OTP sent to phone

class AuthSuccess extends AuthState {
  final int flow;                                   // Navigation decision
  // flow = 0: Not authenticated → WelcomePage
  // flow = 1: Authenticated, no profile → CreateProfilePage
  // flow = 2: Fully setup → HomePage
  AuthSuccess(this.flow);
}

class ProfileCreatedSuccess extends AuthState {}    // Profile created
class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}
```

#### BLoC Functions (auth_bloc.dart)

**Function: `_sendOtp`**

```dart
Purpose: Initiate phone authentication via Supabase
Flow:
  1. Emit AuthLoading
  2. Call repository.sendOtp(phone)
  3. Supabase sends SMS with OTP
  4. Emit OtpSentSuccess
  5. UI navigates to OTP verification page
```

**Function: `_verifyOtp`**

```dart
Purpose: Verify OTP and determine user flow
Flow:
  1. Emit AuthLoading
  2. Call repository.verifyOtp(phone, otp)
  3. Supabase verifies OTP and creates session
  4. Call repository.resolveUserFlow()
     - Checks if user exists in profiles table
     - Returns flow: 0 (no auth), 1 (no profile), 2 (complete)
  5. Emit AuthSuccess(flow)
  6. UI navigates based on flow value
```

**Function: `_checkAuthStatus`**

```dart
Purpose: Check authentication on app startup
Flow:
  1. Called in main.dart MultiBlocProvider
  2. Checks Supabase session
  3. Queries profiles table
  4. Returns appropriate flow
  5. Auto-navigates to correct page
```

**Function: `_createProfile`**

```dart
Purpose: Insert user profile into database
Flow:
  1. Emit AuthLoading
  2. Get currentUser.id from Supabase
  3. Insert into profiles table:
     - uid, phone, name, age, gender, profession, purpose
  4. Emit ProfileCreatedSuccess
  5. Navigate to HomePage
```

#### Repository Functions (auth_repository.dart)

**Function: `sendOtp(String phone)`**

```dart
Implementation:
  await _client.auth.signInWithOtp(phone: phone);

Notes:
  - Supabase handles SMS delivery
  - Rate limited to prevent abuse
  - OTP valid for 60 seconds
```

**Function: `verifyOtp({required String phone, required String otp})`**

```dart
Implementation:
  await _client.auth.verifyOTP(
    phone: phone,
    token: otp,
    type: OtpType.sms
  );

Notes:
  - Creates authenticated session
  - Session stored in secure storage
  - Auto-refresh enabled
```

**Function: `resolveUserFlow()`**

```dart
Implementation:
  1. Get current session
  2. If null, return 0 (not authenticated)
  3. Query profiles table for uid
  4. If no profile, return 1
  5. If profile exists, return 2

Database Query:
  SELECT uid FROM profiles WHERE uid = $user_id LIMIT 1
```

**Function: `createProfile(...)`**

```dart
Implementation:
  INSERT INTO profiles (uid, phone, name, age, gender, profession, purpose)
  VALUES ($user_id, $phone, $name, $age, $gender, $profession, $purpose)

Validation:
  - User must be authenticated
  - Phone extracted from auth.currentUser
```

---

### ⏱️ B. HomeBloc - Timer & Focus Session Management

**Location**: `lib/feature/homepage/bloc/`

#### Events (home_event.dart)

```dart
sealed class HomeEvent {}

class HomeStarted extends HomeEvent {}              // Initialize home, start listeners
class CategorySelected extends HomeEvent {
  final ActivityCategory category;                 // focus, study, gym, reading
  CategorySelected(this.category);
}
class TimerStart extends HomeEvent {}               // Start focus session
class TimerTick extends HomeEvent {}                // Every second countdown
class TimerGiveUp extends HomeEvent {}              // Cancel session early
class PointsUpdated extends HomeEvent {
  final int points;                                 // Real-time points update
  PointsUpdated(this.points);
}
```

#### State (home_state.dart)

```dart
class HomeState {
  final int seconds;                    // Remaining countdown seconds (0-1500)
  final bool hasStarted;                // Timer has been initiated
  final bool isRunning;                 // Actively counting down
  final bool showCompletionDialog;      // Show success dialog
  final int points;                     // User's current points (real-time)
  final DateTime? activityStartedAt;    // Session start timestamp
  final ActivityCategory? category;     // Selected focus category

  factory HomeState.initial() => const HomeState(
    seconds: 0,
    hasStarted: false,
    isRunning: false,
    showCompletionDialog: false,
    points: 0,
    activityStartedAt: null,
    category: null,
  );
}
```

#### BLoC Functions (home_bloc.dart)

**Function: `_onHomeStarted`**

```dart
Purpose: Initialize home page and setup real-time listeners
Flow:
  1. Update last_active_at in profiles table
  2. Cancel existing points subscription
  3. Start new real-time points stream subscription
  4. Listen for changes in points table
  5. Emit PointsUpdated event on each change

Performance:
  - Uses Supabase real-time WebSocket
  - Auto-reconnects on disconnect
  - Minimal latency (~50-200ms)
```

**Function: `_onPointsUpdated`**

```dart
Purpose: Update points in state from real-time stream
Flow:
  1. Receive points value from stream
  2. Emit new state with updated points
  3. UI automatically rebuilds (BlocBuilder)

Note: This function is called automatically via stream subscription
```

**Function: `_onCategorySelected`**

```dart
Purpose: User selects activity category before starting timer
Flow:
  1. Validate category is not null
  2. Emit state with selected category
  3. Enable "Start" button in UI
```

**Function: `_onStart`**

```dart
Purpose: Start focus session with DND enabled
Flow:
  1. Validate category is selected (safety check)
  2. Set totalSeconds = 25 * 60 (1500 seconds = 25 minutes)
  3. Call DndService.enableDnd()
     - Requests notification permission if needed
     - Sets interruption filter to priority mode
  4. Emit state:
     - seconds: 1500
     - hasStarted: true
     - isRunning: true
     - activityStartedAt: DateTime.now()
  5. Create periodic timer (1 second intervals)
  6. Timer callback emits TimerTick event

Critical:
  - Must cancel existing timer before creating new one
  - DND permission required on Android
```

**Function: `_onTick`**

```dart
Purpose: Countdown timer tick (called every second)
Flow:
  if (seconds <= 1):
    // Timer completed
    1. Cancel timer
    2. Disable DND mode
    3. Insert activity log to database:
       - uid, started_at, ended_at, category
    4. Calculate points earned (done via DB trigger)
    5. Emit state:
       - seconds: 0
       - isRunning: false
       - hasStarted: false
       - showCompletionDialog: true
    6. UI shows success dialog
  else:
    // Continue countdown
    1. Decrement seconds by 1
    2. Emit updated state
    3. UI updates countdown display
```

**Function: `_onGiveUp`**

```dart
Purpose: User cancels session before completion
Flow:
  1. Cancel timer immediately
  2. Disable DND mode
  3. Emit state:
     - isRunning: false
     - hasStarted: false
     - seconds: 0
  4. No activity log inserted (incomplete session)
  5. No points awarded
```

**Function: `close()`**

```dart
Purpose: Cleanup when BLoC is disposed
Flow:
  1. Cancel timer if running
  2. Cancel points subscription
  3. Disable DND (safety)
  4. Call super.close()

Called: When HomePage is disposed or app closes
```

#### Repository Functions (home_repository.dart)

**Function: `updateLastActive()`**

```dart
Purpose: Track user activity for analytics
Implementation:
  UPDATE profiles
  SET last_active_at = NOW()
  WHERE uid = $user_id

Called: On HomeStarted event
```

**Function: `pointsStream()`**

```dart
Purpose: Real-time streaming of user points
Implementation:
  return _client
    .from('points')
    .stream(primaryKey: ['uid'])
    .eq('uid', user.id)
    .map((rows) => rows.first['point'] as int);

Technical Details:
  - Uses Supabase Realtime (PostgreSQL LISTEN/NOTIFY)
  - WebSocket connection maintained
  - Auto-reconnects on disconnect
  - Filters by user ID for security

Performance:
  - ~50-200ms latency
  - Minimal bandwidth usage
  - Battery efficient
```

**Function: `insertActivityLog(...)`**

```dart
Purpose: Record completed focus session
Implementation:
  INSERT INTO activity_log (uid, started_at, ended_at, category)
  VALUES ($uid, $started_at, $ended_at, $category)

Triggers (Database Side):
  ON INSERT activity_log:
    1. Calculate duration in minutes
    2. Calculate points earned (e.g., 1 point per minute)
    3. Update points table:
       UPDATE points
       SET point = point + $earned_points
       WHERE uid = $uid
    4. Real-time stream notifies app
    5. UI updates points display
```

#### Activity Category Model (activity_category_model.dart)

```dart
enum ActivityCategory {
  focus,    // General focus work
  study,    // Academic studying
  gym,      // Physical exercise
  reading,  // Reading books/articles
}

extension ActivityCategoryX on ActivityCategory {
  // Display name in UI dropdown
  String get label {
    switch (this) {
      case ActivityCategory.focus: return 'Focus';
      case ActivityCategory.study: return 'Study';
      case ActivityCategory.gym: return 'Gym';
      case ActivityCategory.reading: return 'Reading';
    }
  }

  // Database value (lowercase string)
  String get value => name; // Returns: 'focus', 'study', 'gym', 'reading'
}
```

---

### 📊 C. AnalysisBloc - Data Analytics

**Location**: `lib/feature/analysis_page/bloc/`

#### Events (analysis_event.dart)

```dart
sealed class AnalysisEvent {}

class LoadAnalysis extends AnalysisEvent {}  // Fetch all analytics data
```

#### State (analysis_state.dart)

```dart
class AnalysisState {
  final bool loading;
  final Map<String, double> categoryMinutes;  // Category → Total minutes
  final Map<DateTime, double> dailyMinutes;   // Date → Total minutes

  factory AnalysisState.initial() => const AnalysisState(
    loading: true,
    categoryMinutes: {},
    dailyMinutes: {}
  );
}
```

#### BLoC Functions (analysis_bloc.dart)

**Function: `_onLoadAnalysis`**

```dart
Purpose: Fetch and process analytics data
Flow:
  1. Emit loading state
  2. Get current user ID
  3. Call RPC: get_category_minutes(user_id)
     Returns: [{category: 'focus', minutes: 120}, ...]
  4. Call RPC: get_daily_minutes(user_id)
     Returns: [{day: '2026-01-20', minutes: 60}, ...]
  5. Process data into maps:
     categoryMap = {'focus': 120.0, 'study': 80.0, ...}
     dailyMap = {DateTime(2026,1,20): 60.0, ...}
  6. Emit state with processed data
  7. UI renders charts
```

#### Supabase RPC Functions (PostgreSQL)

**Function: `get_category_minutes(p_uid UUID)`**

```sql
CREATE OR REPLACE FUNCTION get_category_minutes(p_uid UUID)
RETURNS TABLE(category TEXT, minutes NUMERIC) AS $$
BEGIN
  RETURN QUERY
  SELECT
    al.category,
    SUM(EXTRACT(EPOCH FROM (al.ended_at - al.started_at)) / 60) AS minutes
  FROM activity_log al
  WHERE al.uid = p_uid
  GROUP BY al.category
  ORDER BY minutes DESC;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Example Output:
-- category  | minutes
-- ----------|--------
-- focus     | 120.5
-- study     | 85.0
-- reading   | 45.0
-- gym       | 30.0
```

**Function: `get_daily_minutes(p_uid UUID)`**

```sql
CREATE OR REPLACE FUNCTION get_daily_minutes(p_uid UUID)
RETURNS TABLE(day DATE, minutes NUMERIC) AS $$
BEGIN
  RETURN QUERY
  SELECT
    DATE(al.started_at) AS day,
    SUM(EXTRACT(EPOCH FROM (al.ended_at - al.started_at)) / 60) AS minutes
  FROM activity_log al
  WHERE al.uid = p_uid
  GROUP BY DATE(al.started_at)
  ORDER BY day DESC;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Example Output:
-- day        | minutes
-- -----------|--------
-- 2026-01-20 | 60.0
-- 2026-01-19 | 120.0
-- 2026-01-18 | 90.0
```

---

### 🛒 D. StoreBloc - E-commerce Logic

**Location**: `lib/feature/store/bloc/`

#### Events (store_event.dart)

```dart
sealed class StoreEvent {}

class LoadStore extends StoreEvent {}  // Fetch store items

class BuyStoreItem extends StoreEvent {
  final String itemId;
  BuyStoreItem(this.itemId);
}

class CheckShippingAddress extends StoreEvent {
  final String itemId;
  CheckShippingAddress(this.itemId);  // Validate before purchase
}

class AddShippingAddress extends StoreEvent {
  final String address, state, district, postOffice, postPin, itemId;
  AddShippingAddress({...});
}

class UpdateShippingAddress extends StoreEvent {
  final String address, state, district, postOffice, postPin;
  UpdateShippingAddress({...});
}

class PlaceOrder extends StoreEvent {
  final String itemId;
  PlaceOrder(this.itemId);
}

class LoadShippingAddress extends StoreEvent {}
```

#### States (store_state.dart)

```dart
sealed class StoreState {}

class StoreInitial extends StoreState {}
class StoreLoading extends StoreState {}
class StoreLoaded extends StoreState {
  final List<StoreItem> items;
}
class StorePurchaseSuccess extends StoreState {
  final List<StoreItem> items;
}
class StorePurchaseFailed extends StoreState {
  final String message;
  final List<StoreItem> items;
}
class InsufficientPoints extends StoreState {
  final int userPoints, requiredPoints;
  final List<StoreItem> items;
}
class ShippingAddressNotFound extends StoreState {
  final String itemId;
  final List<StoreItem> items;
}
class ShippingAddressAdded extends StoreState {
  final String itemId;
  final List<StoreItem> items;
}
class OrderPlaced extends StoreState {
  final List<StoreItem> items;
}
class ShippingAddressLoaded extends StoreState {
  final ShippingAddress? address;
  final List<StoreItem> items;
}
class ShippingAddressUpdated extends StoreState {
  final ShippingAddress address;
  final List<StoreItem> items;
}
```

#### BLoC Functions (store_bloc.dart)

**Function: `_onLoadStore`**

```dart
Purpose: Fetch all store items from database
Flow:
  1. Emit StoreLoading
  2. Query: SELECT * FROM store ORDER BY created_at
  3. Map results to List<StoreItem>
  4. Emit StoreLoaded(items)
```

**Function: `_onCheckShippingAddress`**

```dart
Purpose: Validate purchase prerequisites
Flow:
  1. Fetch store items
  2. Find item by ID
  3. Check user points:
     Query: SELECT point FROM points WHERE uid = $user_id
  4. If insufficient:
     - Emit InsufficientPoints state
     - Show error snackbar with current vs required points
     - Abort purchase
  5. Check shipping address:
     Query: SELECT * FROM shipping_addresses WHERE uid = $user_id
  6. If no address:
     - Emit ShippingAddressNotFound
     - Navigate to AddShippingAddressPage
  7. If address exists:
     - Emit PlaceOrder event
     - Continue to order placement

Critical: This is a validation gateway before purchase
```

**Function: `_onAddShippingAddress`**

```dart
Purpose: Add new shipping address
Flow:
  1. Insert into shipping_addresses table:
     INSERT INTO shipping_addresses
     (uid, address, state, district, post_office, post_pin)
     VALUES ($uid, $address, ...)
  2. Fetch updated store items
  3. Emit ShippingAddressAdded state
  4. Auto-trigger PlaceOrder event
  5. Navigate back and complete purchase
```

**Function: `_onPlaceOrder`**

```dart
Purpose: Create order and deduct points
Flow:
  1. Fetch store items
  2. Find item by ID (get points cost)
  3. Call repository.createOrder(itemId, itemPoints)
     - Inserts order record
     - Deducts points atomically
  4. Fetch updated items
  5. Emit OrderPlaced state
  6. Show success snackbar
  7. Points update triggers real-time stream in HomePage

Transaction Flow:
  BEGIN TRANSACTION
    INSERT INTO orders (user_id, item, status)
    VALUES ($user_id, $item_id, 'pending')

    UPDATE points
    SET point = point - $item_points,
        updated_at = NOW()
    WHERE uid = $user_id
  COMMIT
```

#### Repository Functions (store_repository.dart)

**Function: `fetchStoreItems()`**

```dart
Query:
  SELECT id, store_element, points, created_at
  FROM store
  ORDER BY created_at ASC

Returns: List<StoreItem>
```

**Function: `getUserPoints()`**

```dart
Query:
  SELECT point
  FROM points
  WHERE uid = $user_id
  LIMIT 1

Returns: int (points balance)
Default: 0 if no record
```

**Function: `checkShippingAddress()`**

```dart
Query:
  SELECT uid, address, state, district, post_office, post_pin, created_at, updated_at
  FROM shipping_addresses
  WHERE uid = $user_id
  LIMIT 1

Returns: ShippingAddress | null
```

**Function: `addShippingAddress(...)`**

```dart
Query:
  INSERT INTO shipping_addresses
  (uid, address, state, district, post_office, post_pin, created_at)
  VALUES ($uid, $address, $state, $district, $post_office, $post_pin, NOW())
  RETURNING *

Returns: ShippingAddress
Constraint: One address per user (uid is PRIMARY KEY)
```

**Function: `updateShippingAddress(...)`**

```dart
Query:
  UPDATE shipping_addresses
  SET
    address = $address,
    state = $state,
    district = $district,
    post_office = $post_office,
    post_pin = $post_pin,
    updated_at = NOW()
  WHERE uid = $user_id
  RETURNING *

Returns: ShippingAddress
```

**Function: `createOrder(itemId, itemPoints)`**

```dart
Implementation:
  1. Check address exists (safety)
  2. Begin transaction
  3. Insert order:
     INSERT INTO orders (user_id, item, status, created_at)
     VALUES ($user_id, $item_id, 'pending', NOW())
  4. Deduct points:
     UPDATE points
     SET point = point - $item_points, updated_at = NOW()
     WHERE uid = $user_id
  5. Commit transaction
  6. Return order

Rollback Conditions:
  - Address not found
  - Insufficient points
  - Database error
```

---

## 📊 DATABASE SCHEMA (Supabase/PostgreSQL)

### Table: `profiles`

```sql
CREATE TABLE profiles (
  uid UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  phone TEXT,
  name TEXT NOT NULL,
  age INTEGER NOT NULL CHECK (age > 0 AND age < 150),
  gender TEXT NOT NULL CHECK (gender IN ('male', 'female', 'others')),
  profession TEXT NOT NULL,
  purpose TEXT NOT NULL,
  last_active_at TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_profiles_last_active ON profiles(last_active_at DESC);
CREATE INDEX idx_profiles_created ON profiles(created_at DESC);
```

### Table: `points`

```sql
CREATE TABLE points (
  uid UUID PRIMARY KEY REFERENCES profiles(uid) ON DELETE CASCADE,
  point INTEGER DEFAULT 0 CHECK (point >= 0),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Trigger: Auto-create points record when profile is created
CREATE OR REPLACE FUNCTION create_points_for_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO points (uid, point, updated_at)
  VALUES (NEW.uid, 0, NOW());
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_create_points
AFTER INSERT ON profiles
FOR EACH ROW
EXECUTE FUNCTION create_points_for_user();

-- Enable real-time
ALTER PUBLICATION supabase_realtime ADD TABLE points;
```

### Table: `activity_log`

```sql
CREATE TABLE activity_log (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  uid UUID NOT NULL REFERENCES profiles(uid) ON DELETE CASCADE,
  started_at TIMESTAMP WITH TIME ZONE NOT NULL,
  ended_at TIMESTAMP WITH TIME ZONE NOT NULL,
  category TEXT NOT NULL CHECK (category IN ('focus', 'study', 'gym', 'reading')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  CONSTRAINT check_ended_after_started CHECK (ended_at > started_at)
);

CREATE INDEX idx_activity_log_uid ON activity_log(uid);
CREATE INDEX idx_activity_log_started ON activity_log(started_at DESC);
CREATE INDEX idx_activity_log_category ON activity_log(category);

-- Trigger: Award points when activity is logged
CREATE OR REPLACE FUNCTION award_points_for_activity()
RETURNS TRIGGER AS $$
DECLARE
  duration_minutes NUMERIC;
  points_earned INTEGER;
BEGIN
  -- Calculate duration in minutes
  duration_minutes := EXTRACT(EPOCH FROM (NEW.ended_at - NEW.started_at)) / 60;

  -- Award 1 point per minute (adjust formula as needed)
  points_earned := FLOOR(duration_minutes);

  -- Update user points
  UPDATE points
  SET
    point = point + points_earned,
    updated_at = NOW()
  WHERE uid = NEW.uid;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_award_points
AFTER INSERT ON activity_log
FOR EACH ROW
EXECUTE FUNCTION award_points_for_activity();
```

### Table: `store`

```sql
CREATE TABLE store (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  store_element TEXT NOT NULL,
  points INTEGER NOT NULL CHECK (points > 0),
  description TEXT,
  image_url TEXT,
  stock_quantity INTEGER DEFAULT 0,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_store_active ON store(is_active) WHERE is_active = TRUE;
CREATE INDEX idx_store_points ON store(points ASC);

-- Sample Data
INSERT INTO store (store_element, points, description) VALUES
('T-Shirt', 100, 'FruiteForest branded t-shirt'),
('Water Bottle', 50, 'Reusable steel water bottle'),
('Notebook', 30, 'Premium quality notebook'),
('Hoodie', 200, 'Comfortable hoodie'),
('Backpack', 150, 'Durable backpack');
```

### Table: `shipping_addresses`

```sql
CREATE TABLE shipping_addresses (
  uid UUID PRIMARY KEY REFERENCES profiles(uid) ON DELETE CASCADE,
  address TEXT NOT NULL,
  state TEXT NOT NULL,
  district TEXT NOT NULL,
  post_office TEXT NOT NULL,
  post_pin TEXT NOT NULL CHECK (LENGTH(post_pin) = 6),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_shipping_addresses_uid ON shipping_addresses(uid);
```

### Table: `orders`

```sql
CREATE TABLE orders (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID NOT NULL REFERENCES profiles(uid) ON DELETE CASCADE,
  item UUID NOT NULL REFERENCES store(id) ON DELETE RESTRICT,
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'processing', 'shipped', 'delivered', 'cancelled')),
  tracking_number TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_orders_user_id ON orders(user_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_orders_created ON orders(created_at DESC);
```

### RPC Functions

**Function: `buy_store_item(p_item_id UUID)`**

```sql
CREATE OR REPLACE FUNCTION buy_store_item(p_item_id UUID)
RETURNS VOID AS $$
DECLARE
  v_user_id UUID;
  v_item_points INTEGER;
  v_user_points INTEGER;
BEGIN
  -- Get current user
  v_user_id := auth.uid();

  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'User not authenticated';
  END IF;

  -- Get item points
  SELECT points INTO v_item_points
  FROM store
  WHERE id = p_item_id AND is_active = TRUE;

  IF v_item_points IS NULL THEN
    RAISE EXCEPTION 'Item not found or inactive';
  END IF;

  -- Get user points
  SELECT point INTO v_user_points
  FROM points
  WHERE uid = v_user_id;

  -- Validate sufficient points
  IF v_user_points < v_item_points THEN
    RAISE EXCEPTION 'Insufficient points. You have % but need %', v_user_points, v_item_points;
  END IF;

  -- Deduct points (transaction is automatic)
  UPDATE points
  SET
    point = point - v_item_points,
    updated_at = NOW()
  WHERE uid = v_user_id;

  -- Note: Order creation is handled separately in createOrder() function
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
```

---

## 🔧 KEY SERVICES

### DndService (lib/common/services/dnd_service.dart)

**Purpose**: Manage Do Not Disturb mode during focus sessions

**Dependencies**:

- Package: `do_not_disturb: ^1.0.3`
- Android Permission: `android.permission.ACCESS_NOTIFICATION_POLICY`

**Functions**:

**`enableDnd()`**

```dart
Flow:
  1. Check if permission granted:
     bool granted = await _dnd.isNotificationPolicyAccessGranted()
  2. If not granted:
     - Open system settings:
       await _dnd.openNotificationPolicyAccessSettings()
     - User must manually grant permission
     - Return early
  3. If granted:
     - Set interruption filter:
       await _dnd.setInterruptionFilter(InterruptionFilter.priority)
     - Blocks all notifications except priority contacts

Interruption Modes:
  - all: Allow all notifications (default)
  - priority: Only priority contacts/apps
  - none: Complete silence
  - alarms: Only alarms (not available on all devices)
```

**`disableDnd()`**

```dart
Flow:
  1. Check permission (safety)
  2. Set filter to allow all:
     await _dnd.setInterruptionFilter(InterruptionFilter.all)
  3. User receives all notifications normally
```

**Android Manifest Requirements** (android/app/src/main/AndroidManifest.xml):

```xml
<uses-permission android:name="android.permission.ACCESS_NOTIFICATION_POLICY"/>
```

---

## 🎨 THEME SYSTEM

### Colors (lib/common/theme/colors/colors.dart)

```dart
class AppColors {
  // Primary palette
  static const Color yellow = Color(0xFFF0AC5B);  // Accent color
  static const Color black = Color(0xFF000000);   // Text primary
  static const Color gray = Color(0xFF888888);    // Text secondary
  static const Color backgroundColor = Color(0xFFFFFFFF); // White background

  // Semantic colors (not defined, using defaults)
  // Success: Colors.green
  // Error: Colors.red
  // Warning: Colors.orange
  // Info: Colors.blue
}
```

### Text Theme (lib/common/theme/text_theme/text_theme.dart)

```dart
class AppTextTheme {
  static const String _fontFamily = "Inter"; // Note: Using "Inter" but Outfit font loaded

  static TextTheme lightTextTheme = TextTheme(
    // Large headlines
    headlineLarge: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 48,
      fontWeight: FontWeight.bold,
      color: AppColors.black,
    ),

    // Large labels/buttons
    labelLarge: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 20,
      fontWeight: FontWeight.w500,
      color: AppColors.gray,
    ),

    // Medium labels
    labelMedium: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppColors.gray,
    ),
  );
}
```

**Font Configuration** (pubspec.yaml):

```yaml
fonts:
  - family: Outfit
    fonts:
      - asset: assets/font/outfit_font/Outfit-VariableFont_wght.ttf
        style: normal
```

**Issue**: Text theme uses "Inter" but Outfit font is loaded. Recommendation: Update `_fontFamily = "Outfit"`

---

## 🔄 NAVIGATION FLOW

### Flow Chart

```
App Start (main.dart)
  ↓
Initialize Supabase
  ↓
Create MultiBlocProvider:
  - AuthBloc (CheckAuthStatusEvent)
  - HomeBloc (HomeStarted)
  - AnalysisBloc (LoadAnalysis)
  - StoreBloc (LoadStore)
  ↓
MaterialApp(home: WelcomePage())
  ↓
AuthBloc.CheckAuthStatusEvent triggers
  ↓
resolveUserFlow() checks database
  ↓
┌─────────────────────────────────────────┐
│ Flow 0: Not Authenticated               │
│   WelcomePage                           │
│     ↓                                   │
│   LoginPage (phone input)               │
│     ↓ SendOtpEvent                      │
│   OtpVerificationPage                   │
│     ↓ VerifyOtpEvent                    │
│   CreateProfilePage (first time)        │
│     ↓ CreateProfileEvent                │
│   HomePage                              │
└─────────────────────────────────────────┘
│
│ Flow 1: Authenticated, No Profile       │
│   CreateProfilePage                     │
│     ↓ CreateProfileEvent                │
│   HomePage                              │
└─────────────────────────────────────────┘
│
│ Flow 2: Fully Authenticated             │
│   HomePage (direct)                     │
└─────────────────────────────────────────┘
  ↓
HomePage
  ├─→ AnalysisPage (analytics icon)
  │     ↓ Back button
  │   HomePage
  │
  └─→ StorePage (cart icon)
        ├─→ AddShippingAddressPage (if no address)
        │     ↓ Submit
        │   StorePage (order placed)
        │
        └─→ EditShippingAddressPage (from store)
              ↓ Update
            StorePage
```

### Navigation Methods

**Push Navigation** (no back possible):

```dart
Navigator.push(context, MaterialPageRoute(
  builder: (_) => NextPage(),
));
```

**Replace Navigation** (back goes to previous-previous):

```dart
Navigator.pushReplacement(context, MaterialPageRoute(
  builder: (_) => NextPage(),
));
```

**Clear Stack** (no back possible):

```dart
Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (_) => HomePage()),
  (route) => false,
);
```

**BLoC-Triggered Navigation** (used in auth flow):

```dart
BlocListener<AuthBloc, AuthState>(
  listener: (context, state) {
    if (state is AuthSuccess) {
      if (state.flow == 1) {
        Navigator.push(context, MaterialPageRoute(
          builder: (_) => const CreateProfilePage(),
        ));
      } else if (state.flow == 2) {
        Navigator.push(context, MaterialPageRoute(
          builder: (_) => const HomePage(),
        ));
      }
    }
  },
  child: // UI
)
```

---

## 🚀 TECHNICAL FEATURES

### 1. Real-time Data Streaming

**Implementation**: Supabase Realtime (PostgreSQL LISTEN/NOTIFY)

**Setup**:

```sql
-- Enable real-time for points table
ALTER PUBLICATION supabase_realtime ADD TABLE points;
```

**Client Code**:

```dart
Stream<int> pointsStream() {
  return _client
      .from('points')
      .stream(primaryKey: ['uid'])  // Required for real-time
      .eq('uid', user.id)           // Filter by user
      .map((rows) {
        if (rows.isEmpty) return 0;
        return rows.first['point'] as int;
      });
}

// Usage in BLoC
_pointsSub = _repository.pointsStream().listen((points) {
  add(PointsUpdated(points));
});
```

**How it works**:

1. Client opens WebSocket connection to Supabase
2. Subscribes to changes in `points` table filtered by `uid`
3. PostgreSQL triggers NOTIFY when row updates
4. Supabase pushes update to client via WebSocket
5. Stream emits new value
6. BLoC receives event and updates state
7. UI rebuilds with new points

**Performance**:

- Latency: 50-200ms
- Bandwidth: ~100 bytes per update
- Battery: Minimal impact (WebSocket kept alive)

### 2. Timer Management

**Implementation**: Dart Timer with 1-second intervals

**Code**:

```dart
Timer? _timer;

// Start timer
_timer = Timer.periodic(const Duration(seconds: 1), (_) {
  add(TimerTick());
});

// Cancel timer
_timer?.cancel();

// Cleanup
@override
Future<void> close() {
  _timer?.cancel();
  return super.close();
}
```

**Accuracy**:

- Native Dart timer (microtask queue)
- Typical drift: ±50ms per minute
- Acceptable for 25-minute sessions

**Edge Cases Handled**:

- App backgrounded: Timer pauses (iOS/Android behavior)
- App closed: Timer stops, no activity logged
- Phone call: Timer pauses, DND handles call permission
- Low battery: Timer continues normally

### 3. Form Validation

**Pattern**: Real-time validation with error display

**Phone Input** (LoginPage):

```dart
TextField(
  controller: phoneController,
  keyboardType: TextInputType.phone,
  decoration: const InputDecoration(
    hintText: "+91XXXXXXXXXX",
    helperText: "Enter phone with country code",
  ),
)

// Validation in BLoC
if (!isValidPhone(event.phone)) {
  emit(AuthError("Invalid phone number format"));
  return;
}
```

**OTP Input** (OtpVerificationPage):

```dart
TextField(
  controller: otpController,
  keyboardType: TextInputType.number,
  maxLength: 6,
  decoration: const InputDecoration(
    hintText: "Enter 6-digit OTP",
  ),
)

// Auto-submit when 6 digits entered
otpController.addListener(() {
  if (otpController.text.length == 6) {
    context.read<AuthBloc>().add(
      VerifyOtpEvent(phone: phone, otp: otpController.text),
    );
  }
});
```

### 4. Purchase Validation Chain

**Flow**:

```
User taps "Buy" button
  ↓
StoreBloc.add(CheckShippingAddress(itemId))
  ↓
Fetch item details from store table
  ↓
Query user points: SELECT point FROM points WHERE uid = $user_id
  ↓
IF userPoints < itemPoints:
  ├─→ Emit InsufficientPoints state
  ├─→ Show SnackBar: "You have X points but need Y points"
  └─→ ABORT purchase
  ↓
ELSE:
  Query shipping address: SELECT * FROM shipping_addresses WHERE uid = $user_id
  ↓
  IF address IS NULL:
    ├─→ Emit ShippingAddressNotFound state
    ├─→ Navigate to AddShippingAddressPage
    ├─→ User fills form
    ├─→ Submit calls AddShippingAddress event
    ├─→ Insert address into database
    └─→ Auto-trigger PlaceOrder event
  ↓
  ELSE:
    StoreBloc.add(PlaceOrder(itemId))
    ↓
    Create order record: INSERT INTO orders (...)
    ↓
    Deduct points: UPDATE points SET point = point - $cost WHERE uid = $user_id
    ↓
    Emit OrderPlaced state
    ↓
    Show success SnackBar
    ↓
    Real-time stream updates points in HomePage
```

**Error Handling**:

```dart
try {
  await repository.createOrder(itemId, itemPoints);
  emit(OrderPlaced(items));
} catch (e) {
  if (e.toString().contains('Insufficient points')) {
    emit(InsufficientPoints(...));
  } else if (e.toString().contains('Address not found')) {
    emit(ShippingAddressNotFound(...));
  } else {
    emit(StorePurchaseFailed(e.toString(), items));
  }
}
```

### 5. State Persistence

**Current Implementation**: None (state lost on app restart)

**Recommended**: Add `hydrated_bloc` for state persistence

**Implementation**:

```yaml
# pubspec.yaml
dependencies:
  hydrated_bloc: ^9.1.1
```

```dart
// main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize storage
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );

  await Supabase.initialize(...);
  runApp(const MyApp());
}

// home_bloc.dart
class HomeBloc extends HydratedBloc<HomeEvent, HomeState> {
  @override
  HomeState fromJson(Map<String, dynamic> json) {
    return HomeState(
      seconds: json['seconds'] as int,
      hasStarted: json['hasStarted'] as bool,
      isRunning: json['isRunning'] as bool,
      showCompletionDialog: json['showCompletionDialog'] as bool,
      points: json['points'] as int,
      activityStartedAt: json['activityStartedAt'] != null
          ? DateTime.parse(json['activityStartedAt'])
          : null,
      category: json['category'] != null
          ? ActivityCategory.values.firstWhere(
              (e) => e.name == json['category'],
            )
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson(HomeState state) {
    return {
      'seconds': state.seconds,
      'hasStarted': state.hasStarted,
      'isRunning': state.isRunning,
      'showCompletionDialog': state.showCompletionDialog,
      'points': state.points,
      'activityStartedAt': state.activityStartedAt?.toIso8601String(),
      'category': state.category?.name,
    };
  }
}
```

---

## 🐛 DEBUGGING TIPS

### 1. Supabase Connection Issues

```dart
// Test connection
final response = await Supabase.instance.client
    .from('profiles')
    .select('uid')
    .limit(1);
print('Connection test: $response');
```

### 2. Authentication Debug

```dart
// Check current session
final session = Supabase.instance.client.auth.currentSession;
print('Session: ${session?.user.id}');
print('Phone: ${session?.user.phone}');
```

### 3. Real-time Streaming Debug

```dart
_repository.pointsStream().listen(
  (points) {
    print('Points updated: $points');
    add(PointsUpdated(points));
  },
  onError: (error) {
    print('Stream error: $error');
  },
);
```

### 4. BLoC State Tracking

```dart
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(this._repository) : super(HomeState.initial()) {
    // Log all transitions
    on<HomeEvent>((event, emit) async {
      print('Event: $event');
      print('Current State: $state');
    });
  }

  @override
  void onTransition(Transition<HomeEvent, HomeState> transition) {
    super.onTransition(transition);
    print('Transition: ${transition.currentState} → ${transition.nextState}');
  }
}
```

### 5. Database Query Testing

```sql
-- Test analytics queries
SELECT * FROM get_category_minutes('YOUR_USER_ID');
SELECT * FROM get_daily_minutes('YOUR_USER_ID');

-- Check points calculation
SELECT
  al.*,
  EXTRACT(EPOCH FROM (ended_at - started_at)) / 60 AS duration_minutes
FROM activity_log al
WHERE uid = 'YOUR_USER_ID'
ORDER BY created_at DESC
LIMIT 10;
```

### 6. Flutter DevTools

```bash
# Run app in debug mode
flutter run --debug

# Open DevTools
flutter pub global activate devtools
flutter pub global run devtools
```

---

## 📝 TODOS & IMPROVEMENTS

### Priority: High

- [ ] Add error boundary/crash reporting (Sentry/Firebase Crashlytics)
- [ ] Implement proper loading states (skeleton screens)
- [ ] Add input validation for all forms
- [ ] Fix font family mismatch (Inter vs Outfit)
- [ ] Add logout functionality
- [ ] Implement proper session timeout handling

### Priority: Medium

- [ ] Add state persistence (hydrated_bloc)
- [ ] Implement push notifications for completed sessions
- [ ] Add profile editing capability
- [ ] Add order history page
- [ ] Implement analytics filtering (date ranges)
- [ ] Add category customization

### Priority: Low

- [ ] Add dark mode theme
- [ ] Implement social sharing (share progress)
- [ ] Add achievements/badges system
- [ ] Implement referral system
- [ ] Add sound effects for timer
- [ ] Create onboarding tutorial

### Performance Optimizations

- [ ] Implement image caching for store items
- [ ] Add pagination for order history
- [ ] Optimize real-time stream subscriptions
- [ ] Implement lazy loading for analytics data
- [ ] Add database indexes for common queries

---

## 🔐 SECURITY NOTES

### Current Vulnerabilities

1. **Exposed API Keys**: Supabase keys hardcoded in main.dart
   - **Fix**: Move to environment variables
2. **No Rate Limiting**: OTP requests not rate limited
   - **Fix**: Implement Supabase Auth rate limiting
3. **Client-Side Validation Only**: Points validation done client-side
   - **Fix**: Add server-side validation in RPC functions

### Recommended Fixes

```dart
// .env file (add to .gitignore)
SUPABASE_URL=https://iatrojsqevuyuuvaeacm.supabase.co
SUPABASE_ANON_KEY=your_anon_key_here

// main.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(const MyApp());
}
```

### Row Level Security (RLS) Policies

```sql
-- Enable RLS on all tables
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE points ENABLE ROW LEVEL SECURITY;
ALTER TABLE activity_log ENABLE ROW LEVEL SECURITY;
ALTER TABLE shipping_addresses ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;

-- Profiles: Users can only read/update their own profile
CREATE POLICY "Users can view own profile"
  ON profiles FOR SELECT
  USING (auth.uid() = uid);

CREATE POLICY "Users can update own profile"
  ON profiles FOR UPDATE
  USING (auth.uid() = uid);

-- Points: Users can only read their own points
CREATE POLICY "Users can view own points"
  ON points FOR SELECT
  USING (auth.uid() = uid);

-- Activity Log: Users can only insert/view their own logs
CREATE POLICY "Users can insert own activity"
  ON activity_log FOR INSERT
  WITH CHECK (auth.uid() = uid);

CREATE POLICY "Users can view own activity"
  ON activity_log FOR SELECT
  USING (auth.uid() = uid);

-- Shipping Addresses: Users can manage their own address
CREATE POLICY "Users can manage own address"
  ON shipping_addresses FOR ALL
  USING (auth.uid() = uid);

-- Orders: Users can view/create their own orders
CREATE POLICY "Users can view own orders"
  ON orders FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can create own orders"
  ON orders FOR INSERT
  WITH CHECK (auth.uid() = user_id);
```

---

## 📊 ANALYTICS & METRICS

### Key Performance Indicators (KPIs)

1. **Daily Active Users (DAU)**: Count of unique users per day
2. **Session Completion Rate**: Completed sessions / Total started
3. **Average Session Duration**: Mean duration of completed sessions
4. **Points Earned Per User**: Total points / Total users
5. **Store Conversion Rate**: Orders placed / Store page visits

### Tracking Queries

```sql
-- Daily Active Users
SELECT
  DATE(last_active_at) as date,
  COUNT(DISTINCT uid) as dau
FROM profiles
WHERE last_active_at >= NOW() - INTERVAL '30 days'
GROUP BY DATE(last_active_at)
ORDER BY date DESC;

-- Session Completion Rate (by category)
SELECT
  category,
  COUNT(*) as total_sessions,
  AVG(EXTRACT(EPOCH FROM (ended_at - started_at)) / 60) as avg_duration_minutes
FROM activity_log
GROUP BY category;

-- Top Users by Points
SELECT
  p.name,
  p.phone,
  pt.point as points,
  COUNT(al.id) as sessions_completed
FROM profiles p
JOIN points pt ON p.uid = pt.uid
LEFT JOIN activity_log al ON p.uid = al.uid
GROUP BY p.uid, p.name, p.phone, pt.point
ORDER BY pt.point DESC
LIMIT 10;

-- Store Performance
SELECT
  s.store_element,
  s.points as cost,
  COUNT(o.id) as orders_count,
  COUNT(o.id) * s.points as total_points_spent
FROM store s
LEFT JOIN orders o ON s.id = o.item
GROUP BY s.id, s.store_element, s.points
ORDER BY orders_count DESC;
```

---

## 🚀 DEPLOYMENT

### Build Commands

**Android APK**:

```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

**Android App Bundle (Google Play)**:

```bash
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/app-release.aab
```

**iOS**:

```bash
flutter build ios --release
# Open in Xcode for signing and distribution
```

**Web**:

```bash
flutter build web --release
# Output: build/web/
```

### Environment Configuration

**Development**:

```dart
const bool isDevelopment = true;
const String supabaseUrl = 'https://dev.supabase.co';
```

**Production**:

```dart
const bool isDevelopment = false;
const String supabaseUrl = 'https://iatrojsqevuyuuvaeacm.supabase.co';
```

### Release Checklist

- [ ] Update version in pubspec.yaml
- [ ] Test on multiple devices (Android/iOS)
- [ ] Verify DND permissions work
- [ ] Test authentication flow end-to-end
- [ ] Test purchase flow with real data
- [ ] Check analytics display
- [ ] Verify real-time updates work
- [ ] Test timer accuracy
- [ ] Check all error states
- [ ] Update release notes
- [ ] Build signed APK/AAB
- [ ] Upload to Play Store/App Store

---

## 📞 SUPPORT & CONTACTS

**Developer**: Shaan Shoukath
**Project**: FruiteForest
**Last Updated**: January 20, 2026

---

**END OF DEVELOPER DEBUG DOCUMENTATION**
