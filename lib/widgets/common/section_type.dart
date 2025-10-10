import 'package:flutter/material.dart';

/// SectionType interface - Flutter equivalent van Swift SectionType protocol
abstract class SectionType {
  String get id;
  String title(BuildContext context);
  String description(BuildContext context);
  String get icon;
}