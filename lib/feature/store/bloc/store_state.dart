part of 'store_bloc.dart';

@immutable
sealed class StoreState {}

class StoreInitial extends StoreState {}

class StoreLoading extends StoreState {}

class StoreLoaded extends StoreState {
  final List<StoreItem> items;
  StoreLoaded(this.items);
}

class StorePurchaseSuccess extends StoreState {
  final List<StoreItem> items;
  StorePurchaseSuccess(this.items);
}

class StoreError extends StoreState {
  final String message;
  StoreError(this.message);
}

class StorePurchaseFailed extends StoreState {
  final String message;
  final List<StoreItem> items;
  StorePurchaseFailed(this.message, this.items);
}

class InsufficientPoints extends StoreState {
  final int userPoints;
  final int requiredPoints;
  final List<StoreItem> items;
  InsufficientPoints({
    required this.userPoints,
    required this.requiredPoints,
    required this.items,
  });
}

class ShippingAddressNotFound extends StoreState {
  final String itemId;
  final List<StoreItem> items;
  ShippingAddressNotFound({required this.itemId, required this.items});
}

class ShippingAddressAdded extends StoreState {
  final String itemId;
  final List<StoreItem> items;
  ShippingAddressAdded({required this.itemId, required this.items});
}

class OrderPlaced extends StoreState {
  final List<StoreItem> items;
  OrderPlaced(this.items);
}

class ShippingAddressLoaded extends StoreState {
  final ShippingAddress? address;
  final List<StoreItem> items;
  ShippingAddressLoaded({required this.address, required this.items});
}

class ShippingAddressUpdated extends StoreState {
  final ShippingAddress address;
  final List<StoreItem> items;
  ShippingAddressUpdated({required this.address, required this.items});
}
