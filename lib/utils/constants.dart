import 'package:flutter/material.dart';

class AppConstants {
  // App Info
  static const String appName = 'Asia Green';
  static const String appSlogan = 'Hôm nay bạn đã làm gì cho Trái Đất chưa?';
  
  // Colors
  static const Color primaryGreen = Color(0xFF2E7D32);
  static const Color lightGreen = Color(0xFF66BB6A);
  static const Color darkGreen = Color(0xFF1B5E20);
  static const Color accentBlue = Color(0xFF0288D1);
  static const Color backgroundColor = Color(0xFFF1F8E9);
  static const Color cardColor = Color(0xFFFFFFFF);
  
  // Lesson Categories
  static const String categoryWater = 'water';
  static const String categoryWaste = 'waste';
  static const String categoryEnergy = 'energy';
  static const String categoryClimate = 'climate';
  static const String categoryNature = 'nature';
  
  // User Level
  static const int levelBeginner = 0;
  static const int levelGreen = 100;
  static const int levelAmbassador = 500;
  
  static String getUserLevel(int points) {
    if (points >= levelAmbassador) {
      return 'Đại sứ Môi trường';
    } else if (points >= levelGreen) {
      return 'Nhà Xanh';
    } else {
      return 'Người mới';
    }
  }
  
  // Game Names
  static const String gameTrashSort = 'trash_sort';
  static const String gameRiverClean = 'river_clean';
  static const String gameTreePlant = 'tree_plant';
  static const String gameEnergySave = 'energy_save';
}
