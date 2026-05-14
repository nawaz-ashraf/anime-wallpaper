import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/local_storage_service.dart';

class ThemeController extends GetxController {
  ThemeController(this._storage);

  final LocalStorageService _storage;

  final RxBool isDarkMode = true.obs;

  Future<void> loadTheme() async {
    isDarkMode.value = _storage.isDarkMode;
  }

  ThemeMode get themeMode =>
      isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  Future<void> toggleTheme() async {
    isDarkMode.value = !isDarkMode.value;
    await _storage.setDarkMode(isDarkMode.value);
  }
}
