// Category model
class Category {
  final String id;
  final String name;
  final String? icon;
  final bool isSystem;

  Category({
    required this.id,
    required this.name,
    this.icon,
    this.isSystem = false,
  });
}
