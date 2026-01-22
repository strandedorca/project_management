class User {
  final String id;
  final String name;
  final String? imageUrl;

  const User({required this.id, required this.name, this.imageUrl});

  // Immutable
  User copyWith({String? id, String? name, String? imageUrl}) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
