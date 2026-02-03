import 'package:flutter/material.dart';

class Option {
  final String id;
  final String label;

  const Option({required this.id, required this.label});
}

class CustomDropdown extends StatefulWidget {
  const CustomDropdown({
    super.key,
    required this.defaultOptionId,
    required this.options,
  });

  final String defaultOptionId;
  final List<Option> options;

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  @override
  Widget build(BuildContext context) {
    return Text(widget.defaultOptionId);
  }
}
