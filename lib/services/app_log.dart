import 'package:flutter/foundation.dart';

class AppLog {
  static bool enabled = true;

  static void d(String msg) {
    if (enabled) debugPrint("[DEBUG] $msg");
  }

  static void i(String msg) {
    debugPrint("[INFO] $msg");
  }

  static void e(String msg) {
    debugPrint("[ERROR] $msg");
  }
}