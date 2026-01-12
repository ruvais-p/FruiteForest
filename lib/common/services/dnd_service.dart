import 'package:do_not_disturb/do_not_disturb_plugin.dart';
import 'package:do_not_disturb/types.dart';

class DndService {
  static final DoNotDisturbPlugin _dnd = DoNotDisturbPlugin();

  static Future<void> enableDnd() async {
    final granted = await _dnd.isNotificationPolicyAccessGranted();

    if (!granted) {
      await _dnd.openNotificationPolicyAccessSettings();
      return;
    }

    await _dnd.setInterruptionFilter(InterruptionFilter.priority);
  }

  static Future<void> disableDnd() async {
    final granted = await _dnd.isNotificationPolicyAccessGranted();

    if (!granted) return;

    await _dnd.setInterruptionFilter(InterruptionFilter.all);
  }
}
