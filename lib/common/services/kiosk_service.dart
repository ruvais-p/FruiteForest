import 'package:flutter_kiosk_mode/flutter_kiosk_mode.dart';

class KioskService {
  static final FlutterKioskMode _kiosk = FlutterKioskMode.instance();

  static Future<void> enableKiosk() async {
    final isOwner = await _kiosk.owner();

    if (!isOwner) {
      // App is not device owner – start normal kiosk if allowed
      await _kiosk.start();
      return;
    }

    await _kiosk.start();
  }

  static Future<void> disableKiosk() async {
    await _kiosk.stop();
  }
}
