import 'package:flutter/material.dart';
import 'package:project_manager/themes/decorations.dart';
import 'package:project_manager/themes/dimens.dart';
import 'package:project_manager/utils/math.dart';

// Data ----------------------------------------------------------------------
class BottomNavItem {
  final int index;
  final IconData icon;
  final String label;

  const BottomNavItem({
    required this.index,
    required this.icon,
    required this.label,
  });
}

const List<BottomNavItem> mainNavBarItems = [
  BottomNavItem(index: 0, icon: Icons.home, label: 'Dashboard'),
  BottomNavItem(index: 1, icon: Icons.view_kanban, label: 'Projects'),
  BottomNavItem(index: 2, icon: Icons.library_add_check, label: 'Tasks'),
  BottomNavItem(index: 3, icon: Icons.calendar_month, label: 'Upcoming'),
];
const List<BottomNavItem> extendedNavBarItems = [
  BottomNavItem(index: 4, icon: Icons.search, label: 'Search'),
  BottomNavItem(index: 5, icon: Icons.bar_chart, label: 'Activities'),
  BottomNavItem(index: 6, icon: Icons.settings, label: 'Settings'),
];
const Duration _animationDuration = Duration(milliseconds: 250);
// Helpers -------------------------------------------------------------------
double _alignmentFromIndex(
  int index,
  List<BottomNavItem> items, {
  bool hasMoreTabs = false,
}) {
  if (items.length <= 1) return 0.0;
  double lastIndex = items.last.index.toDouble();
  final firstIndex = items.first.index.toDouble();
  // Add 1 to account for the 'More Tabs' item
  lastIndex = hasMoreTabs ? lastIndex + 1 : lastIndex;
  return Math.linearMap(index.toDouble(), lastIndex, firstIndex, 1.0, -1.0);
}

// CustomBottomNavigationBar --------------------------------------------------
class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({
    super.key,
    required this.selectedTab,
    required this.onSwitchTab,
    required this.onTap,
  });

  final int selectedTab;
  final ValueChanged<int> onSwitchTab;
  final VoidCallback onTap;

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  final LayerLink _navBarLayerLink = LayerLink();
  OverlayEntry? _extendedNavBarOverlayEntry;
  bool _isExtended = false;

  void showExtendedNavBar() {
    setState(() {
      _isExtended = true;
    });
    widget.onTap();
    final extendedActiveIndicatorAlignmentY = _alignmentFromIndex(
      widget.selectedTab,
      extendedNavBarItems,
    );

    _extendedNavBarOverlayEntry = OverlayEntry(
      builder: (context) => ExtendedNavBar(
        layerLink: _navBarLayerLink,
        onTap: widget.onSwitchTab,
        alignmentY: extendedActiveIndicatorAlignmentY,
        items: extendedNavBarItems,
        onDismiss: hideExtendedNavBar,
        selectedTab: widget.selectedTab,
      ),
    );

    Overlay.of(context).insert(_extendedNavBarOverlayEntry!);
  }

  void hideExtendedNavBar() {
    _extendedNavBarOverlayEntry?.remove();
    setState(() {
      _isExtended = false;
      _extendedNavBarOverlayEntry = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final navBarItemCount = mainNavBarItems.length;
    final mainActiveIndicatorAlignmentX = _alignmentFromIndex(
      // Extended tabs use indices beyond mainNavBarItemCount,
      // When an extended tab is selected, the main indicator should be aligned to the 'More Tabs' item
      widget.selectedTab.clamp(0, navBarItemCount),
      mainNavBarItems,
      hasMoreTabs: true,
    );
    final mainActiveIndicator = FractionallySizedBox(
      // Add 1 to account for the 'More Tabs' item
      widthFactor: 1 / (navBarItemCount + 1),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(999),
        ),
      ),
    );

    return CompositedTransformTarget(
      link: _navBarLayerLink,
      child: Container(
        padding: EdgeInsets.all(AppDimens.paddingExtraSmall),
        // Offset so that the nav bar does not overlap with the main content
        margin: EdgeInsets.symmetric(
          horizontal: AppDimens.appPadding - AppDimens.paddingExtraSmall,
        ),
        decoration: AppDecorations.roundedBorderedBox(context, 999),
        child: Stack(
          children: [
            Positioned.fill(
              child: AnimatedAlign(
                alignment: Alignment(mainActiveIndicatorAlignmentX, 0),
                duration: _animationDuration,
                curve: Curves.easeInOut,
                child: mainActiveIndicator,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ...mainNavBarItems.map(
                  (item) => Expanded(
                    child: IconButton(
                      onPressed: () => widget.onSwitchTab(item.index),
                      icon: Icon(item.icon),
                    ),
                  ),
                ),
                // 'More Tabs' item
                Expanded(
                  child: IconButton(
                    onPressed: _isExtended
                        ? hideExtendedNavBar
                        : showExtendedNavBar,
                    icon: Icon(Icons.pending),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ExtendedNavBar extends StatefulWidget {
  const ExtendedNavBar({
    super.key,
    required this.layerLink,
    required this.onTap,
    required this.alignmentY,
    required this.items,
    required this.onDismiss,
    required this.selectedTab,
  });

  final LayerLink layerLink;
  final ValueChanged<int> onTap;
  final double alignmentY;
  final List<BottomNavItem> items;
  final VoidCallback onDismiss;
  final int selectedTab;

  @override
  State<ExtendedNavBar> createState() => _ExtendedNavBarState();
}

class _ExtendedNavBarState extends State<ExtendedNavBar> {
  static const _extendedNavBarWidth = 80.0;
  static const _extendedNavBarHeight = 156.0;
  static const _scaleDuration = Duration(milliseconds: 150);
  late double extendedActiveIndicatorAlignmentY;
  double _scale = 0.0;

  @override
  void initState() {
    super.initState();
    extendedActiveIndicatorAlignmentY = _alignmentFromIndex(
      widget.selectedTab,
      extendedNavBarItems,
    );
    Future.delayed(_scaleDuration, () {
      setState(() {
        _scale = 1.0;
      });
    });
  }

  void _closeWithAnimation() {
    setState(() {
      _scale = 0;
    });
    Future.delayed(_scaleDuration, () {
      widget.onDismiss();
    });
  }

  void _onSwitchTab(int index) {
    setState(() {
      extendedActiveIndicatorAlignmentY = _alignmentFromIndex(
        index,
        extendedNavBarItems,
      );
    });

    // Let the indicator slide first, then switch tab and close.
    Future.delayed(_scaleDuration, () {
      if (!mounted) return;
      widget.onTap(index);
      _closeWithAnimation();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isActiveTabExtended =
        widget.selectedTab > mainNavBarItems.last.index;
    final Widget extendedActiveTabIndicator = FractionallySizedBox(
      heightFactor: 1 / widget.items.length,
      child: Container(
        decoration: AppDecorations.roundedBorderedBox(
          context,
          AppDimens.borderRadiusMedium,
        ).copyWith(color: Theme.of(context).colorScheme.primary),
      ),
    );

    return Stack(
      children: [
        // Capture taps outside the extended nav bar to close it
        Positioned.fill(child: GestureDetector(onTap: _closeWithAnimation)),
        Positioned(
          width: _extendedNavBarWidth,
          height: _extendedNavBarHeight,
          child: CompositedTransformFollower(
            link: widget.layerLink,
            targetAnchor: Alignment.topRight,
            followerAnchor: Alignment.bottomRight,
            offset: Offset(
              // Offset so that the extended nav bar does not overlap with the app body
              -AppDimens.appPadding + AppDimens.paddingExtraSmall,
              -AppDimens.paddingMedium,
            ),
            child: AnimatedScale(
              scale: _scale,
              duration: _scaleDuration,
              curve: Curves.easeInOut,
              alignment: Alignment(0, 1),
              child: Material(
                shape: AppDecorations.roundedBorderedRectangleBorder(
                  context,
                  AppDimens.borderRadiusMedium,
                ),
                color: Theme.of(context).colorScheme.surface,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: AnimatedAlign(
                        alignment: Alignment(
                          0,
                          extendedActiveIndicatorAlignmentY,
                        ),
                        duration: _animationDuration,
                        curve: Curves.easeInOut,
                        child: isActiveTabExtended
                            ? extendedActiveTabIndicator
                            : null,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ...widget.items.map(
                          (item) => Expanded(
                            child: IconButton(
                              onPressed: () => _onSwitchTab(item.index),
                              icon: Icon(item.icon),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
