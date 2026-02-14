import 'package:flutter/material.dart';

// Option model for dropdowns and pickers
class Option {
  final String value;
  final String label;
  final IconData? icon;

  // Add a method to convert to option
  factory Option.fromValues(String value, String name, IconData? icon) {
    return Option(value: value, label: name, icon: icon);
  }

  const Option({required this.value, required this.label, this.icon});
}
