import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruiteforest/feature/store/bloc/store_bloc.dart';
import 'package:fruiteforest/feature/store/model/store_items_model.dart';

class StoreItemCard extends StatelessWidget {
  final StoreItem item;

  const StoreItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<StoreBloc>().add(CheckShippingAddress(item.id));
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black, width: 1.5),
        ),
        child: Row(
          children: [
            // Product image
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: item.imageUrl != null && item.imageUrl!.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        item.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildPlaceholderIcon();
                        },
                      ),
                    )
                  : _buildPlaceholderIcon(),
            ),
            const SizedBox(width: 16),

            // Item info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${item.points} points',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            // Arrow icon
            const Icon(Icons.arrow_forward, color: Colors.black54, size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderIcon() {
    return Icon(
      Icons.inventory_2_outlined,
      size: 32,
      color: Colors.grey.shade400,
    );
  }
}
