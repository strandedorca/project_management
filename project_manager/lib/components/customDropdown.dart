import 'dart:math';

import 'package:flutter/material.dart';
import 'package:project_manager/components/customScrollBar.dart';
import 'package:project_manager/components/customTextFormField.dart';
import 'package:project_manager/components/formFieldWrapper.dart';
import 'package:project_manager/components/formIconButton.dart';
import 'package:project_manager/models/option.dart';
import 'package:project_manager/themes/decorations.dart';
import 'package:project_manager/themes/dimens.dart';

// TODO: Add option icon support

/// CustomDropdown is a dropdown menu for selecting a value from a list of options.
///
/// It uses [Overlay] and [LayerLink] to float above the main widget.
/// It wraps around [FormFieldWrapper] and [CustomTextFormField] to achieve consistent styling with other form fields.
/// The controller is managed internally and is used to control the displayed text field.
/// The value is stored in the [selectedValue] and exposed through the [onSelected] callback.
///
/// ## Parameters
/// - (required) [initialValue]: Initial selected value.
/// - (required) [options]: The list of options.
///   Each option must be an [Option] with a [value], [label] and [icon].
/// - (required) [onSelected]: The callback function to call when an option is selected.
/// - (optional) [extraBottomSpace]: Extra spacing considered when positioning the dropdown
/// - (optional) [hintText]: Placeholder text shown when no option is selected.
/// - (optional) [suffixIcon]: The icon to display in the suffix of the text field.

class _OverlayLayout {
  const _OverlayLayout({required this.anchor, required this.size});

  final Alignment anchor;
  final Size size;
}

class CustomDropdown extends StatefulWidget {
  const CustomDropdown({
    super.key,
    this.initialValue,
    required this.options,
    required this.onSelected,
    this.hintText,
    this.suffixIcon,
    this.extraBottomSpace = 0.0,
  });

  final String? initialValue;
  final List<Option> options;
  final ValueChanged<String> onSelected;
  final String? hintText;
  final IconData? suffixIcon;
  final double extraBottomSpace;

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  late String? _selectedValue;
  final _controller = TextEditingController();
  OverlayEntry? _overlayEntry;
  final LayerLink layerLink = LayerLink();
  final GlobalKey _targetKey = GlobalKey();
  static const int _maxVisibleOptions = 4;
  late int _optionCount;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
    if (_selectedValue != null) {
      _controller.text = widget.options
          .firstWhere((e) => e.value == _selectedValue)
          .label;
    }
    _optionCount = widget.options.length;
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _showDropdown() {
    _showOverlay();
  }

  void _showOverlay() {
    final layout = _computeOverlayLayout();
    final optionHeight = layout.size.height;
    final width = layout.size.width;
    final anchor = layout.anchor;
    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Add a transparent overlay to close the dropdown when tapping anywhere outside the dropdown
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _closeDropdown,
            ),
          ),
          Positioned(
            width: width,
            height: optionHeight * min(_maxVisibleOptions, _optionCount),
            child: CompositedTransformFollower(
              link: layerLink,
              targetAnchor: anchor,
              followerAnchor: anchor,
              child: Material(
                color: Theme.of(context).colorScheme.surface,
                shape: AppDecorations.roundedBorderedRectangleBorder(
                  context,
                  AppDimens.borderRadiusSmall,
                ),
                clipBehavior: Clip.hardEdge,
                child: SizedBox(
                  height: optionHeight * min(_maxVisibleOptions, _optionCount),
                  child: CustomScrollBar(
                    controller: _scrollController,
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.zero,
                      itemCount: _optionCount,
                      itemExtent: optionHeight,
                      itemBuilder: (context, index) =>
                          _buildOption(widget.options[index], optionHeight),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _closeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  Widget _buildOption(Option option, double rowHeight) {
    return Container(
      height: rowHeight,
      color: option.value == _selectedValue
          ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.8)
          : null,
      child: InkWell(
        onTap: () {
          setState(() => _selectedValue = option.value);
          _controller.text = option.label;
          widget.onSelected(option.value);
          _closeDropdown();
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppDimens.paddingMedium),
          child: Row(
            children: [
              Expanded(child: Text(option.label)),
              if (option.value == _selectedValue) const Icon(Icons.check),
            ],
          ),
        ),
      ),
    );
  }

  _OverlayLayout _computeOverlayLayout() {
    final renderBox =
        _targetKey.currentContext!.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final topLeft = renderBox.localToGlobal(Offset.zero);

    final mediaQuery = MediaQuery.of(context);
    final viewportHeight = mediaQuery.size.height;
    final bottomPadding = mediaQuery.padding.bottom;
    final spaceBelow =
        viewportHeight -
        topLeft.dy -
        size.height -
        bottomPadding -
        widget.extraBottomSpace;

    final dropdownHeight = size.height * min(_maxVisibleOptions, _optionCount);
    final openAbove = spaceBelow < dropdownHeight;
    final anchor = openAbove ? Alignment.bottomLeft : Alignment.topLeft;

    return _OverlayLayout(anchor: anchor, size: size);
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      key: _targetKey,
      link: layerLink,
      child: FormFieldWrapper(
        childHasSuffixIcon: true,
        childField: CustomTextFormField(
          hintText: widget.hintText,
          onTap: _showDropdown,
          readOnly: true,
          suffixIcon: FormIconButton(
            iconData: widget.suffixIcon ?? Icons.arrow_drop_down,
            onPressed: _showDropdown,
          ),
          controller: _controller,
        ),
      ),
    );
  }
}
