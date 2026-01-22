import 'package:project_manager/models/user.dart';

/// Service to manage current user data
///
/// **How it works:**
/// - Holds the current logged-in user
/// - Provides methods to fetch/update user data
/// - For MVP: Uses mock data
/// - For API: Will call your backend
///
///
class UserService {
  static User? _currentUser;

  Future<User?> getCurrentUser() async {
    // Simulate API delay (remove in production if not needed)
    await Future.delayed(const Duration(milliseconds: 1000));

    _currentUser ??= const User(
      id: 'user-1',
      name: 'Noa',
      imageUrl:
          'https://media.wired.com/photos/5f87340d114b38fa1f8339f9/master/w_1280,c_limit/Ideas_Surprised_Pikachu_HD.jpg',
    );

    return _currentUser;
  }
}
