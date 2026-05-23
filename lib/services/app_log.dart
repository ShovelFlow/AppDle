import 'package:flutter/foundation.dart';

class AppLog {

  static void d(String msg) {
    // debugPrint("[DEBUG] $msg");
  }

  static void i(String msg) {
    debugPrint("[INFO] $msg");
  }

  static void e(String msg) {
    debugPrint("[ERROR] $msg");
  }
}