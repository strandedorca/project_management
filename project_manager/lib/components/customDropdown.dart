import 'package:flutter/material.dart';
import 'package:project_manager/components/paddedRoundedBorderedBox.dart';
import 'package:project_manager/themes/decorations.dart';
import 'package:project_manager/themes/dimens.dart';

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
    required this.onSelected,
  });

  final String defaultOptionId;
  final List<Option> options;
  final ValueChanged<String> onSelected;
  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  late String _selectedOptionId;
  late String _selectedOptionLabel;
  OverlayEntry? _overlayEntry;
  final LayerLink priorityDropdownLayerLink = LayerLink();
  final GlobalKey _priorityTargetKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _selectedOptionId = widget.defaultOptionId;
    _selectedOptionLabel = widget.options
        .firstWhere((e) => e.id == _selectedOptionId)
        .label;
  }

  void _onTap() {
    // setState(() => _isOptionsSheetOpen = true);
    _showOverlay();
  }

  void _showOverlay() {
    final renderBox =
        _priorityTargetKey.currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    final mediaQuery = MediaQuery.of(context);
    final viewportHeight = mediaQuery.size.height;
    final viewPadding = mediaQuery.viewPadding;
    final bottomBarHeight = 56;
    final spaceBelow =
        viewportHeight -
        position.dy -
        size.height -
        viewPadding.bottom -
        bottomBarHeight;

    final maxDropdownHeight = 48 * 4;
    final openAbove = spaceBelow < maxDropdownHeight;

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
            width: size.width,
            child: CompositedTransformFollower(
              targetAnchor: !openAbove
                  ? Alignment.topLeft
                  : Alignment.bottomRight,
              followerAnchor: !openAbove
                  ? Alignment.topLeft
                  : Alignment.bottomRight,
              link: priorityDropdownLayerLink,
              child: Material(
                color: Theme.of(context).colorScheme.surface,

                shape: AppDecorations.roundedBorderedRectangleBorder(
                  context,
                  AppDimens.borderRadiusSmall,
                ),
                clipBehavior: Clip.hardEdge,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...widget.options.map(
                      (e) => SizedBox(
                        height: size.height,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _selectedOptionId = e.id;
                              _selectedOptionLabel = e.label;
                              widget.onSelected(e.id);
                            });
                            _closeDropdown();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppDimens.paddingMedium,
                            ),
                            child: Row(
                              children: [
                                Expanded(child: Text(e.label)),
                                if (e.id == _selectedOptionId)
                                  const Icon(Icons.check),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
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

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppDimens.borderRadiusSmall),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: _onTap,
        key: _priorityTargetKey,
        child: CompositedTransformTarget(
          link: priorityDropdownLayerLink,
          child: PaddedRoundedBorderedBox(
            padding: EdgeInsets.symmetric(horizontal: AppDimens.paddingMedium),
            borderRadius: AppDimens.borderRadiusSmall,

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(_selectedOptionLabel)),
                Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
