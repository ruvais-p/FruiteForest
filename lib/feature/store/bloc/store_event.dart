part of 'store_bloc.dart';

@immutable
sealed class StoreEvent {}

class LoadStore extends StoreEvent {}

class BuyStoreItem extends StoreEvent {
  final String itemId;
  BuyStoreItem(this.itemId);
}

class CheckShippingAddress extends StoreEvent {
  final String itemId;
  CheckShippingAddress(this.itemId);
}

class AddShippingAddress extends StoreEvent {
  final String address;
  final String state;
  final String district;
  final String postOffice;
  final String postPin;
  final String itemId;
  AddShippingAddress({
    required this.address,
    required this.state,
    required this.district,
    required this.postOffice,
    required this.postPin,
    required this.itemId,
  });
}

class PlaceOrder extends StoreEvent {
  final String itemId;
  PlaceOrder(this.itemId);
}

class LoadShippingAddress extends StoreEvent {}

class UpdateShippingAddress extends StoreEvent {
  final String address;
  final String state;
  final String district;
  final String postOffice;
  final String postPin;
  UpdateShippingAddress({
    required this.address,
    required this.state,
    required this.district,
    required this.postOffice,
    required this.postPin,
  });
}
