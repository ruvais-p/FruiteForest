# 🔐 Auth Feature Documentation

## File Structure

```
lib/feature/auth/
├── bloc/
│   ├── auth_bloc.dart      # Authentication business logic
│   ├── auth_event.dart     # User authentication actions
│   └── auth_state.dart     # Authentication states
├── presentation/
│   ├── welcome_page/       # Landing screen
│   ├── login/              # Phone number input
│   ├── otp_verification/   # OTP code input
│   ├── createuser/         # Profile creation
│   ├── splashscreen/       # Initial loading screen
│   └── widgets/            # Shared auth widgets
└── repository/
    └── auth_repository.dart # Supabase auth calls
```

---

## Classes & Functions

### AuthBloc (`auth_bloc.dart`)

| Function                                 | Purpose                             |
| ---------------------------------------- | ----------------------------------- |
| `_sendOtp(SendOtpEvent)`                 | Request OTP via Supabase SMS        |
| `_verifyOtp(VerifyOtpEvent)`             | Verify OTP, create session          |
| `_checkAuthStatus(CheckAuthStatusEvent)` | Check existing session on app start |
| `_createProfile(CreateProfileEvent)`     | Insert new user profile             |

### AuthRepository (`auth_repository.dart`)

| Function                | Purpose                                 |
| ----------------------- | --------------------------------------- |
| `sendOtp(phone)`        | `signInWithOtp(phone)` call to Supabase |
| `verifyOtp(phone, otp)` | Verify OTP token                        |
| `resolveUserFlow()`     | Returns 0/1/2 for navigation decision   |
| `createProfile(...)`    | Insert into `profiles` table            |

---

## Auth Flow Diagram

```
┌─────────────────┐
│   WelcomePage   │ ← User lands here
└────────┬────────┘
         │ "Get Started"
         ▼
┌─────────────────┐
│    LoginPage    │ ← Enter phone number
└────────┬────────┘
         │ SendOtpEvent
         ▼
┌─────────────────┐
│ OtpVerification │ ← Enter 6-digit OTP
└────────┬────────┘
         │ VerifyOtpEvent
         ▼
    ┌────┴────┐
    │ flow=?  │
    └────┬────┘
    0    │    1    │    2
    ↓    ▼         ▼    ↓
  Welcome  CreateUser   Home
```

---

## Debugging

### Skip OTP During Testing

In `main.dart`, change:

```dart
home: WelcomePage(),
// To:
home: HomePage(),
```

### Test Phone Numbers

Configure in Supabase Dashboard → Authentication → Phone → Test Phone Numbers:

- Add test number (e.g., `+1234567890`)
- Set fixed OTP (e.g., `123456`)

---

## Future Modifications

### Add OAuth (Google/Apple)

1. Add `signInWithGoogle()` to `AuthRepository`
2. Add `GoogleSignInEvent` to events
3. Handle in `AuthBloc`

### Add Logout

1. Add `LogoutEvent` to events
2. Call `_client.auth.signOut()` in repository
3. Clear local state and navigate to welcome

### Add Session Persistence Check

Currently implemented via `CheckAuthStatusEvent` on app start.
