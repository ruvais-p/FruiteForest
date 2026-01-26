import 'package:flutter/material.dart';
import 'package:fruiteforest/feature/homepage/model/activity_category_model.dart';

class ActivityCategorySelector extends StatefulWidget {
  const ActivityCategorySelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final ActivityCategory selected;
  final ValueChanged<ActivityCategory> onChanged;

  @override
  State<ActivityCategorySelector> createState() =>
      _ActivityCategorySelectorState();
}

class _ActivityCategorySelectorState extends State<ActivityCategorySelector>
    with SingleTickerProviderStateMixin {
  bool isExpanded = false;

  Color _color(ActivityCategory c) {
    switch (c) {
      case ActivityCategory.focus:
        return const Color(0xFFE8A55B); // Amber

      case ActivityCategory.study:
        return const Color(0xFF8BE05D); // Green

      case ActivityCategory.gym:
        return const Color(0xFF67D6E8); // Aqua

      case ActivityCategory.reading:
        return const Color(0xFFE95C86); // Rose

      case ActivityCategory.diy:
        return const Color(0xFFB15CE8); // Purple

      case ActivityCategory.meditate:
        return const Color(0xFF5C6BC0); // Indigo calm

      case ActivityCategory.plan:
        return const Color(0xFF607D8B); // Structured slate
    }
  }

  @override
  Widget build(BuildContext context) {
    final selected = widget.selected;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// Selected pill
            GestureDetector(
              onTap: () => setState(() => isExpanded = !isExpanded),
              child: _pill(selected),
            ),

            if (isExpanded) ...[
              const SizedBox(height: 8),

              /// FIRST ROW (3 items centered)
              SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: ActivityCategory.values
                      .where((c) => c != selected)
                      .take(3)
                      .map(
                        (c) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          child: GestureDetector(
                            onTap: () {
                              widget.onChanged(c);
                              setState(() => isExpanded = false);
                            },
                            child: _pill(c),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 5),

              /// SECOND ROW (start aligned under Focus)
              SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: ActivityCategory.values
                      .where((c) => c != selected)
                      .skip(3)
                      .map(
                        (c) => Padding(
                          padding: const EdgeInsets.only(left: 3),
                          child: GestureDetector(
                            onTap: () {
                              widget.onChanged(c);
                              setState(() => isExpanded = false);
                            },
                            child: _pill(c),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _pill(ActivityCategory category) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: _color(category),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        category.label,
        style: Theme.of(
          context,
        ).textTheme.displayMedium!.copyWith(fontWeight: FontWeight.w400),
      ),
    );
  }
}
