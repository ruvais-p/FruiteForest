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

/// Store Page
///
/// Displays purchasable items and delivery address.
/// Uses AppTextTheme for consistent typography.
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
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        title: Text('Store', style: textTheme.titleLarge),
      ),
      body: BlocConsumer<StoreBloc, StoreState>(
        listener: (context, state) {
          if (state is StorePurchaseSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Purchase successful! 🎉',
                  style: textTheme.bodyMedium?.copyWith(color: Colors.white),
                ),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );
          }

          if (state is StorePurchaseFailed) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.message,
                  style: textTheme.bodyMedium?.copyWith(color: Colors.white),
                ),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          }

          if (state is InsufficientPoints) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Need ${state.requiredPoints} points (you have ${state.userPoints})',
                  style: textTheme.bodyMedium?.copyWith(color: Colors.white),
                ),
                backgroundColor: Colors.orange,
                duration: const Duration(seconds: 3),
              ),
            );
          }

          if (state is ShippingAddressNotFound) {
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
              SnackBar(
                content: Text(
                  'Order placed successfully! 🎉',
                  style: textTheme.bodyMedium?.copyWith(color: Colors.white),
                ),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is StoreLoading || state is StoreInitial) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.yellow),
            );
          }

          final items = _extractItems(state);
          final address = _extractAddress(state);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Store Items
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return StoreItemCard(item: item, isFeatured: index == 0);
                  },
                ),

                const SizedBox(height: 32),

                // Delivering To Section
                _buildAddressSection(context, address, textTheme),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAddressSection(
    BuildContext context,
    ShippingAddress? address,
    TextTheme textTheme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Delivering to', style: textTheme.titleLarge),
            IconButton(
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
              icon: const Icon(Icons.edit, size: 20),
              color: AppColors.black,
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (address != null)
          _buildAddressCard(address, textTheme)
        else
          _buildNoAddressCard(context, textTheme),
      ],
    );
  }

  Widget _buildAddressCard(ShippingAddress address, TextTheme textTheme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.gray.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAddressRow('Address', address.address, textTheme),
          const SizedBox(height: 8),
          _buildAddressRow('Post Office', address.postOffice, textTheme),
          const SizedBox(height: 8),
          _buildAddressRow('District', address.district, textTheme),
          const SizedBox(height: 8),
          _buildAddressRow('State', address.state, textTheme),
          const SizedBox(height: 8),
          _buildAddressRow('PIN Code', address.postPin, textTheme),
        ],
      ),
    );
  }

  Widget _buildAddressRow(String label, String value, TextTheme textTheme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text('$label:', style: textTheme.labelMedium),
        ),
        Expanded(child: Text(value, style: textTheme.bodyMedium)),
      ],
    );
  }

  Widget _buildNoAddressCard(BuildContext context, TextTheme textTheme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.gray.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gray.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.location_off_outlined,
            size: 40,
            color: AppColors.gray,
          ),
          const SizedBox(height: 12),
          Text('No address saved', style: textTheme.labelMedium),
          const SizedBox(height: 12),
          TextButton(
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
            child: Text(
              'Add Address',
              style: textTheme.bodyMedium?.copyWith(color: AppColors.yellow),
            ),
          ),
        ],
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
    return switch (state) {
      ShippingAddressLoaded() => state.address,
      ShippingAddressUpdated() => state.address,
      _ => null,
    };
  }
}
