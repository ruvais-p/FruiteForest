# 🛒 Store Feature Documentation

## File Structure

```
lib/feature/store/
├── bloc/
│   ├── store_bloc.dart     # Store business logic
│   ├── store_event.dart    # Purchase/address events
│   └── store_state.dart    # Store states
├── model/
│   ├── store_items_model.dart      # Store item entity
│   ├── shipping_address_model.dart # Address entity
│   └── order_model.dart            # Order entity
├── presentation/
│   ├── store_page.dart             # Store listing + address section
│   ├── add_shipping_address_page.dart  # First-time address form
│   ├── edit_shipping_address_page.dart # Edit existing address
│   └── widgets/
│       └── store_item_card_widget.dart # Item card with image
└── repository/
    └── store_repository.dart       # Database operations
```

---

## Classes & Functions

### StoreItem (`store_items_model.dart`)

```dart
class StoreItem {
  final String id;
  final String name;
  final int points;
  final String? imageUrl;     // From Supabase storage
  final String? description;
  final int? stock;

  bool get hasImage => ...    // Check if image exists
}
```

### StoreBloc (`store_bloc.dart`)

| Function                   | Purpose                                   |
| -------------------------- | ----------------------------------------- |
| `_onLoadStore`             | Fetch all items from `store` table        |
| `_onCheckShippingAddress`  | Validate points + address before purchase |
| `_onAddShippingAddress`    | Insert new address, then place order      |
| `_onUpdateShippingAddress` | Update existing address                   |
| `_onPlaceOrder`            | Create order, deduct points               |
| `_onLoadShippingAddress`   | Fetch user's address for display          |

### StoreRepository (`store_repository.dart`)

| Function                      | Purpose                     |
| ----------------------------- | --------------------------- |
| `fetchStoreItems()`           | Query `store` table         |
| `getUserPoints()`             | Get current points balance  |
| `checkShippingAddress()`      | Check if address exists     |
| `addShippingAddress(...)`     | Insert new address          |
| `updateShippingAddress(...)`  | Update address              |
| `createOrder(itemId, points)` | Insert order, deduct points |

---

## Purchase Flow

```
┌──────────────┐
│ Store Page   │ ← View items + address
└───────┬──────┘
        │ Tap item
        ▼
┌──────────────┐
│ Check Points │
└───────┬──────┘
   Insufficient? → Show snackbar
        │
        ▼
┌──────────────┐
│Check Address │
└───────┬──────┘
   Not found? → Navigate to Add Address
        │
        ▼
┌──────────────┐
│ Place Order  │
│ Deduct Points│
└───────┬──────┘
        │
        ▼
   ✓ Success!
```

---

## Supabase Table Schema

### `store` table

```sql
id            UUID PRIMARY KEY
store_element TEXT        -- Item name
points        INT         -- Cost in points
image_url     TEXT        -- URL to image (optional)
description   TEXT        -- Item description (optional)
stock         INT         -- Available quantity (optional)
created_at    TIMESTAMP
```

### `shipping_addresses` table

```sql
uid           UUID PRIMARY KEY REFERENCES auth.users
address       TEXT
state         TEXT
district      TEXT
post_office   TEXT
post_pin      TEXT (6 digits)
created_at    TIMESTAMP
updated_at    TIMESTAMP
```

### `orders` table

```sql
id            UUID PRIMARY KEY
user_id       UUID REFERENCES auth.users
item          UUID REFERENCES store(id)
status        TEXT    -- pending, shipped, delivered
created_at    TIMESTAMP
```

### `points` table

```sql
uid           UUID PRIMARY KEY REFERENCES auth.users
point         INT     -- Current point balance
updated_at    TIMESTAMP
```

---

## UI Components

### Store Page (`store_page.dart`)

- Lists items from Supabase
- Shows "Delivering to" section with address
- Edit button navigates to edit address page

### Store Item Card (`store_item_card_widget.dart`)

- Displays item image (or placeholder)
- Shows name and points badge
- Arrow indicator for tap action
- `isFeatured` prop for first item highlight

### Address Pages

- **Add**: First-time purchase, saves address then completes order
- **Edit**: Update existing address from store page

---

## Debugging

### Items Not Loading

1. Check `store` table has rows in Supabase
2. Verify RLS policies allow authenticated reads
3. Check `store_element` column has the item name

### Purchase Failing

1. Check user has sufficient points in `points` table
2. Verify shipping address exists
3. Check database triggers/functions

### Images Not Showing

1. Verify `image_url` column exists in `store` table
2. Check URLs are valid and accessible
3. Images should be served via Supabase Storage or public CDN

---

## Future Modifications

### Add Item Images to Supabase

1. Upload images to Supabase Storage
2. Get public URL
3. Update `store` table with `image_url`

### Add Order History

1. Create `OrderHistoryPage` in presentation
2. Add `LoadOrders` event to bloc
3. Query `orders` table joined with `store`

### Add Stock Management

1. Show "Out of Stock" badge when `stock = 0`
2. Disable purchase button
3. Decrement stock on order (via trigger)
