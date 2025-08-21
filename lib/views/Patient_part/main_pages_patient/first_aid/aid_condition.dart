import 'package:flutter/material.dart';

class AidCondition {
  final String title;
  final String description;
  final String type; // emergency, critical, etc.
  final String actionText;
  final Color backgroundColor;
  final Color textColor;
  final IconData icon;
  final bool isTutorial;
  final List<String> detailedSteps;

  AidCondition({
    required this.title,
    required this.description,
    required this.type,
    required this.actionText,
    required this.backgroundColor,
    required this.textColor,
    required this.icon,
    required this.isTutorial,
    required this.detailedSteps
  });
}
