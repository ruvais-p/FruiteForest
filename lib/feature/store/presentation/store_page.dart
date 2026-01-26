import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruiteforest/common/theme/colors/colors.dart';
import 'package:fruiteforest/feature/store/model/shipping_address_model.dart';
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
      create: (_) => StoreBloc(StoreRepository())
        ..add(LoadStore())
        ..add(LoadShippingAddress()),
      child: const _StoreView(),
    );
  }
}

class _StoreView extends StatelessWidget {
  const _StoreView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Store',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
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
              ),
            );
          }

          if (state is ShippingAddressNotFound) {
            // Navigate to add address page
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

          // Extract items and address from various states
          final items = _extractItems(state);
          final address = _extractAddress(state);

          return Column(
            children: [
              // Store items list
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return StoreItemCard(item: item);
                  },
                ),
              ),

              // Delivering to section (only if address exists)
              if (address != null) _buildAddressSection(context, address),
            ],
          );
        },
      ),
    );
  }

  List<StoreItem> _extractItems(StoreState state) {
    return switch (state) {
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
  }

  ShippingAddress? _extractAddress(StoreState state) {
    if (state is ShippingAddressLoaded) return state.address;
    if (state is ShippingAddressUpdated) return state.address;
    return null;
  }

  Widget _buildAddressSection(BuildContext context, ShippingAddress address) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Delivering to',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.edit, size: 20),
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
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Address details
          _buildAddressLine('Address', address.address),
          _buildAddressLine('Post Office', address.postOffice),
          _buildAddressLine('District', address.district),
          _buildAddressLine('State', address.state),
          _buildAddressLine('PIN Code', address.postPin),
        ],
      ),
    );
  }

  Widget _buildAddressLine(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        '$label: $value',
        style: const TextStyle(fontSize: 14, color: Colors.black87),
      ),
    );
  }
}
