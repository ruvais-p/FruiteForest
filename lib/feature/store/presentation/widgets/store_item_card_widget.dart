import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruiteforest/common/theme/colors/colors.dart';
import 'package:fruiteforest/feature/store/bloc/store_bloc.dart';
import 'package:fruiteforest/feature/store/model/store_items_model.dart';

/// Store Item Card Widget
///
/// Displays a store item with image, name, points, and buy action.
/// Uses AppTextTheme for consistent typography.
class StoreItemCard extends StatelessWidget {
  final StoreItem item;
  final bool isFeatured;

  const StoreItemCard({super.key, required this.item, this.isFeatured = false});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: isFeatured
            ? AppColors.yellow.withOpacity(0.15)
            : AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gray.withOpacity(0.2), width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            context.read<StoreBloc>().add(CheckShippingAddress(item.id));
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Item Image
                _buildItemImage(),
                const SizedBox(width: 16),

                // Item Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Item name using theme
                      Text(item.name, style: textTheme.titleSmall),
                      const SizedBox(height: 6),
                      // Points badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.yellow.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${item.points} points',
                          style: textTheme.labelSmall?.copyWith(
                            color: AppColors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Arrow indicator
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: AppColors.gray,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItemImage() {
    if (item.hasImage) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          item.imageUrl!,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
        ),
      );
    }
    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: AppColors.gray.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(
        Icons.inventory_2_outlined,
        size: 30,
        color: AppColors.gray,
      ),
    );
  }
}
