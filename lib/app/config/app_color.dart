import 'package:flutter/material.dart';

abstract class AppColor {
  const AppColor._();

  // Gray
  static const Color gray00 = Color(0xFFFFFFFF);
  static const Color gray100 = Color(0xFFF5F7FA);
  static const Color gray200 = Color(0xFFF0F0F5);
  static const Color gray300 = Color(0xFFE1E1E8);
  static const Color gray400 = Color(0xFFCACCD8);
  static const Color gray500 = Color(0xFFADAFBB);
  static const Color gray600 = Color(0xFF858898);
  static const Color gray700 = Color(0xFF35363F);
  static const Color gray800 = Color(0xFF23252B);

  // Primary
  static const Color primary1 = Color(0xFFEDEDF9);
  static const Color primary2 = Color(0xFF8989A6);
  static const Color primary3 = Color(0xFF404054);
  static const Color primary4 = Color(0xFF232332);
  static const Color primary5 = Color(0xFF000000);

  // Secandary
  static const Color secondary1 = Color(0xFF11D85D);
  static const Color secondary2 = Color(0xFFEAFFF2);

  // Status
  static const Color statusPositive = Color(0xFF00BF40);
  static const Color statusCautionary = Color(0xFFFF9200);
  static const Color statusNegative = Color(0xFFFF4242);

  // Accent
  static const Color accentRed = Color(0xFFF5506C);
}
