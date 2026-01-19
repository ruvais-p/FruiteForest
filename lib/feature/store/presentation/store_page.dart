import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruiteforest/feature/store/model/store_items_model.dart';
import 'package:fruiteforest/feature/store/presentation/widgets/store_item_card_widget.dart';

import '../bloc/store_bloc.dart';
import '../repository/store_repository.dart';
import 'add_shipping_address_page.dart';
import 'edit_shipping_address_page.dart';

class StorePage extends StatelessWidget {
  const StorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => StoreBloc(StoreRepository())..add(LoadStore()),
      child: const _StoreView(),
    );
  }
}

class _StoreView extends StatelessWidget {
  const _StoreView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Store'), centerTitle: true),
      body: BlocConsumer<StoreBloc, StoreState>(
        listener: (context, state) {
          if (state is StorePurchaseSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Purchase successful! 🎉'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );
          }

          if (state is StorePurchaseFailed) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
                action: SnackBarAction(
                  label: 'OK',
                  textColor: Colors.white,
                  onPressed: () {},
                ),
              ),
            );
          }

          if (state is InsufficientPoints) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Insufficient points! You have ${state.userPoints} points but need ${state.requiredPoints} points.',
                ),
                backgroundColor: Colors.orange,
                duration: const Duration(seconds: 4),
                action: SnackBarAction(
                  label: 'OK',
                  textColor: Colors.white,
                  onPressed: () {},
                ),
              ),
            );
          }

          if (state is ShippingAddressNotFound) {
            // Navigate to address page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: context.read<StoreBloc>(),
                  child: AddShippingAddressPage(itemId: state.itemId),
                ),
              ),
            );
          }

          if (state is OrderPlaced) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Order placed successfully! 🎉'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is StoreLoading || state is StoreInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          // Extract items from various states
          final items = switch (state) {
            StoreLoaded() => state.items,
            StorePurchaseSuccess() => state.items,
            StorePurchaseFailed() => state.items,
            InsufficientPoints() => state.items,
            ShippingAddressNotFound() => state.items,
            ShippingAddressAdded() => state.items,
            OrderPlaced() => state.items,
            ShippingAddressLoaded() => state.items,
            ShippingAddressUpdated() => state.items,
            _ => <StoreItem>[],
          };

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = items[index];
              return StoreItemCard(item: item);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<StoreBloc>(),
                child: const EditShippingAddressPage(),
              ),
            ),
          );
        },
        icon: const Icon(Icons.edit_location),
        label: const Text('Edit Address'),
      ),
    );
  }
}
