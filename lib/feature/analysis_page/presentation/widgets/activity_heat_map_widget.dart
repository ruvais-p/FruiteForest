import 'package:flutter/material.dart';
import 'package:fruiteforest/feature/analysis_page/mock_data_provider.dart';

/// Calendar-style Activity Heatmap Widget
///
/// Displays a two-month calendar view with activity intensity colors.
/// Shows previous month (left) and current month (right).
class ActivityHeatMap extends StatefulWidget {
  /// Date → minutes
  final Map<DateTime, double> data;

  const ActivityHeatMap({super.key, required this.data});

  @override
  State<ActivityHeatMap> createState() => _ActivityHeatMapState();
}

class _ActivityHeatMapState extends State<ActivityHeatMap> {
  late DateTime _currentMonth;

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show previous month on left, current viewing month on right
    final rightMonth = _currentMonth;
    final leftMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);

    return Column(
      children: [
        // Navigation row
        Row(
          children: [
            // Left arrow
            IconButton(
              icon: const Icon(Icons.chevron_left, size: 24),
              onPressed: _previousMonth,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            // Month labels
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _formatMonth(leftMonth),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      _formatMonth(rightMonth),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Right arrow
            IconButton(
              icon: const Icon(Icons.chevron_right, size: 24),
              onPressed: _nextMonth,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Two calendars side by side
        Row(
          children: [
            Expanded(child: _buildMonthCalendar(leftMonth)),
            const SizedBox(width: 8),
            Expanded(child: _buildMonthCalendar(rightMonth)),
          ],
        ),
      ],
    );
  }

  Widget _buildMonthCalendar(DateTime month) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate cell size based on available width
        final cellSize =
            (constraints.maxWidth - 12) / 7; // 7 days, with small gaps

        return Column(
          children: [
            // Day headers
            _buildDayHeaders(cellSize),
            const SizedBox(height: 2),
            // Calendar grid
            _buildCalendarGrid(month, cellSize),
          ],
        );
      },
    );
  }

  Widget _buildDayHeaders(double cellSize) {
    const days = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: days.map((day) {
        return SizedBox(
          width: cellSize,
          child: Text(
            day,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCalendarGrid(DateTime month, double cellSize) {
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);
    final daysInMonth = lastDay.day;

    // Monday = 1, Sunday = 7 (Dart's weekday)
    // We want Monday as first column (index 0)
    final startOffset = (firstDay.weekday - 1) % 7;

    final List<Widget> rows = [];
    List<Widget> currentRow = [];

    // Add empty cells for offset
    for (int i = 0; i < startOffset; i++) {
      currentRow.add(_buildDayCell(null, null, cellSize));
    }

    // Add day cells
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(month.year, month.month, day);
      final minutes = widget.data[DateTime(date.year, date.month, date.day)];

      currentRow.add(_buildDayCell(day, minutes, cellSize));

      // Start new row after Sunday
      if (currentRow.length == 7) {
        rows.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: currentRow,
          ),
        );
        currentRow = [];
      }
    }

    // Fill remaining cells in last row
    while (currentRow.isNotEmpty && currentRow.length < 7) {
      currentRow.add(_buildDayCell(null, null, cellSize));
    }
    if (currentRow.isNotEmpty) {
      rows.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: currentRow,
        ),
      );
    }

    return Column(children: rows);
  }

  Widget _buildDayCell(int? day, double? minutes, double size) {
    Color backgroundColor = Colors.transparent;
    Color textColor = Colors.grey.shade400;

    if (day != null) {
      textColor = Colors.black87;

      if (minutes != null && minutes > 0) {
        // Get color based on thresholds
        backgroundColor = _getIntensityColor(minutes);
        textColor = Colors.white;
      }
    }

    return Container(
      width: size,
      height: size,
      margin: const EdgeInsets.symmetric(vertical: 1),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Text(
          day?.toString() ?? '',
          style: TextStyle(
            fontSize: size * 0.4, // Responsive font size
            fontWeight: minutes != null && minutes > 0
                ? FontWeight.w600
                : FontWeight.normal,
            color: textColor,
          ),
        ),
      ),
    );
  }

  Color _getIntensityColor(double minutes) {
    // Using thresholds from mock_data_provider
    if (minutes <= HeatmapThresholds.low) {
      return const Color(0xFFFFD699); // Light orange
    } else if (minutes <= HeatmapThresholds.medium) {
      return const Color(0xFFFFB347); // Medium orange
    } else if (minutes <= HeatmapThresholds.high) {
      return const Color(0xFFE8963F); // Dark orange
    } else {
      return const Color(0xFFD4782C); // Very dark orange/brown
    }
  }

  String _formatMonth(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}
