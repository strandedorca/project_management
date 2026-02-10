import 'package:flutter/material.dart';
import 'package:project_manager/themes/decorations.dart';
import 'package:project_manager/themes/dimens.dart';

class BottomNavItem {
  final int? index; // null for the more tabs item
  final IconData icon;
  final String label;

  const BottomNavItem({
    required this.index,
    required this.icon,
    required this.label,
  });
}

const List<BottomNavItem> bottomNavigationBarItems = [
  BottomNavItem(index: 0, icon: Icons.home, label: 'Dashboard'),
  BottomNavItem(index: 1, icon: Icons.view_kanban, label: 'Projects'),
  BottomNavItem(index: 2, icon: Icons.library_add_check, label: 'Tasks'),
  BottomNavItem(index: 3, icon: Icons.calendar_month, label: 'Upcoming'),
  BottomNavItem(index: null, icon: Icons.pending, label: 'More Tabs'),
];

const List<BottomNavItem> extendedBottomNavigationBarItems = [
  BottomNavItem(index: 4, icon: Icons.search, label: 'Search'),
  BottomNavItem(index: 5, icon: Icons.bar_chart, label: 'Activities'),
  BottomNavItem(index: 6, icon: Icons.settings, label: 'Settings'),
];

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({
    super.key,
    required this.selectedTab,
    required this.onTap,
    this.isExtended = false,
  });

  final int selectedTab;
  final ValueChanged<int> onTap;
  final bool isExtended;

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  bool isExtended = false;
  final LayerLink navBarLayerLink = LayerLink();
  OverlayEntry? extendedNavBar;

  void showExtendedNavBar() {
    setState(() => isExtended = true);

    //TODO: Add linear mapping helper function
    final extendedNavBarItemCount = extendedBottomNavigationBarItems.length;
    final selectedTabAlignmentY = extendedNavBarItemCount == 1
        ? 0.0
        : widget.selectedTab - 5.0;
    final isExtendedTab = widget.selectedTab >= 4;
    final Widget? activeTabIndicator = isExtendedTab
        ? FractionallySizedBox(
            heightFactor: 1 / extendedBottomNavigationBarItems.length,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(
                  AppDimens.borderRadiusMedium,
                ),
              ),
            ),
          )
        : null;

    extendedNavBar = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Capture taps outside the extended nav bar to close it
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: hideExtendedNavBar,
            ),
          ),
          Positioned(
            width: 80,
            height: 156,
            child: CompositedTransformFollower(
              link: navBarLayerLink,
              targetAnchor: Alignment.topRight,
              followerAnchor: Alignment.bottomRight,
              offset: Offset(
                // Offset so that the extended nav bar does not overlap with the main content
                -AppDimens.appPadding + AppDimens.paddingExtraSmall,
                -AppDimens.paddingMedium,
              ),
              child: Material(
                shape: AppDecorations.roundedBorderedRectangleBorder(
                  context,
                  AppDimens.borderRadiusMedium,
                ),
                color: Theme.of(context).colorScheme.surface,
                child: Padding(
                  padding: EdgeInsets.all(AppDimens.paddingSmall),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: AnimatedAlign(
                          alignment: Alignment(0, selectedTabAlignmentY),
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeInOut,
                          child: activeTabIndicator,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ...extendedBottomNavigationBarItems.map(
                            (item) => Expanded(
                              child: IconButton(
                                onPressed: () {
                                  widget.onTap(item.index!);
                                  hideExtendedNavBar();
                                },
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
      ),
    );

    Overlay.of(context).insert(extendedNavBar!);
  }

  void hideExtendedNavBar() {
    setState(() => isExtended = false);
    extendedNavBar?.remove();
  }

  @override
  Widget build(BuildContext context) {
    final navBarItemCount = bottomNavigationBarItems.length;
    final selectedIndex = widget.selectedTab.clamp(0, navBarItemCount - 1);
    // TODO:Add linear mapping helper function
    final selectedAlignmentX = navBarItemCount == 1
        ? 0.0
        : -1.0 + 2.0 * (selectedIndex / (navBarItemCount - 1));

    return CompositedTransformTarget(
      link: navBarLayerLink,
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
                alignment: Alignment(selectedAlignmentX, 0),
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                child: FractionallySizedBox(
                  widthFactor: 1 / navBarItemCount,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ...bottomNavigationBarItems.map(
                  (item) => Expanded(
                    child: IconButton(
                      onPressed: () {
                        if (item.index == null) {
                          if (!isExtended) {
                            showExtendedNavBar();
                          } else {
                            hideExtendedNavBar();
                          }
                        } else {
                          widget.onTap(item.index!);
                        }
                      },
                      icon: Icon(item.icon),
                    ),
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
