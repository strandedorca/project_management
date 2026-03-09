import 'package:flutter/material.dart';

// Option model for dropdowns and pickers
class Option {
  final String value;
  final String label;
  final IconData? icon;

  factory Option.fromValues(String value, String label, IconData? icon) {
    return Option(value: value, label: label, icon: icon);
  }

  const Option({required this.value, required this.label, this.icon});
}
