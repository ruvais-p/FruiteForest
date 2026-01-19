import 'package:bloc/bloc.dart';
import 'package:fruiteforest/feature/store/model/shipping_address_model.dart';
import 'package:fruiteforest/feature/store/model/store_items_model.dart';
import 'package:meta/meta.dart';
import '../repository/store_repository.dart';

part 'store_event.dart';
part 'store_state.dart';

class StoreBloc extends Bloc<StoreEvent, StoreState> {
  final StoreRepository repository;

  StoreBloc(this.repository) : super(StoreInitial()) {
    on<LoadStore>(_onLoadStore);
    on<BuyStoreItem>(_onBuyItem);
    on<CheckShippingAddress>(_onCheckShippingAddress);
    on<AddShippingAddress>(_onAddShippingAddress);
    on<PlaceOrder>(_onPlaceOrder);
    on<LoadShippingAddress>(_onLoadShippingAddress);
    on<UpdateShippingAddress>(_onUpdateShippingAddress);
  }

  Future<void> _onLoadStore(LoadStore event, Emitter<StoreState> emit) async {
    emit(StoreLoading());
    try {
      final items = await repository.fetchStoreItems();
      emit(StoreLoaded(items));
    } catch (e) {
      emit(StoreError('Failed to load store'));
    }
  }

  Future<void> _onBuyItem(BuyStoreItem event, Emitter<StoreState> emit) async {
    try {
      await repository.buyItem(event.itemId);
      // Refresh items after successful purchase
      final items = await repository.fetchStoreItems();
      emit(StorePurchaseSuccess(items));
    } catch (e) {
      // Fetch current items to keep displaying them
      final items = await repository.fetchStoreItems();
      emit(StorePurchaseFailed(e.toString(), items));
    }
  }

  Future<void> _onCheckShippingAddress(
    CheckShippingAddress event,
    Emitter<StoreState> emit,
  ) async {
    try {
      final items = await repository.fetchStoreItems();

      // Find the item being purchased
      final item = items.firstWhere((i) => i.id == event.itemId);

      // Check if user has enough points
      final userPoints = await repository.getUserPoints();

      if (userPoints < item.points) {
        // User doesn't have enough points
        emit(
          InsufficientPoints(
            userPoints: userPoints,
            requiredPoints: item.points,
            items: items,
          ),
        );
        return;
      }

      // Check if user has shipping address
      final address = await repository.checkShippingAddress();

      if (address == null) {
        // No address found, emit state to navigate to address page
        emit(ShippingAddressNotFound(itemId: event.itemId, items: items));
      } else {
        // Address exists, proceed to place order
        add(PlaceOrder(event.itemId));
      }
    } catch (e) {
      final items = await repository.fetchStoreItems();
      emit(StorePurchaseFailed(e.toString(), items));
    }
  }

  Future<void> _onAddShippingAddress(
    AddShippingAddress event,
    Emitter<StoreState> emit,
  ) async {
    try {
      await repository.addShippingAddress(
        address: event.address,
        state: event.state,
        district: event.district,
        postOffice: event.postOffice,
        postPin: event.postPin,
      );
      final items = await repository.fetchStoreItems();

      // Emit state indicating address was added, then place order
      emit(ShippingAddressAdded(itemId: event.itemId, items: items));

      // Automatically place the order after address is added
      add(PlaceOrder(event.itemId));
    } catch (e) {
      final items = await repository.fetchStoreItems();
      emit(StorePurchaseFailed(e.toString(), items));
    }
  }

  Future<void> _onPlaceOrder(PlaceOrder event, Emitter<StoreState> emit) async {
    try {
      final items = await repository.fetchStoreItems();
      final item = items.firstWhere((i) => i.id == event.itemId);

      await repository.createOrder(event.itemId, item.points);

      // Refresh items after order is placed
      final updatedItems = await repository.fetchStoreItems();
      emit(OrderPlaced(updatedItems));
    } catch (e) {
      final items = await repository.fetchStoreItems();
      emit(StorePurchaseFailed(e.toString(), items));
    }
  }

  Future<void> _onLoadShippingAddress(
    LoadShippingAddress event,
    Emitter<StoreState> emit,
  ) async {
    try {
      final items = await repository.fetchStoreItems();
      final address = await repository.getShippingAddress();
      emit(ShippingAddressLoaded(address: address, items: items));
    } catch (e) {
      final items = await repository.fetchStoreItems();
      emit(StorePurchaseFailed(e.toString(), items));
    }
  }

  Future<void> _onUpdateShippingAddress(
    UpdateShippingAddress event,
    Emitter<StoreState> emit,
  ) async {
    try {
      final address = await repository.updateShippingAddress(
        address: event.address,
        state: event.state,
        district: event.district,
        postOffice: event.postOffice,
        postPin: event.postPin,
      );
      final items = await repository.fetchStoreItems();
      emit(ShippingAddressUpdated(address: address, items: items));
    } catch (e) {
      final items = await repository.fetchStoreItems();
      emit(StorePurchaseFailed(e.toString(), items));
    }
  }
}
