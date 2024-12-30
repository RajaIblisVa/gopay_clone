import 'package:appwrite/models.dart' as models;
import 'package:myapp/models/user_profile_model.dart';
import 'package:myapp/services/auth_services.dart';
import 'package:myapp/services/user_profile_services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../utils/provider.dart';

part 'auth_provider.g.dart';

@riverpod
class Auth extends _$Auth {
  late final AuthService _authService =
      AuthService(account: ref.read(appwriteAccountProvider));
  late final UserProfileService _userService =
      UserProfileService(db: ref.read(appwriteDatabaseProvider));

  @override
  Future<models.User?> build() async {
    return checkSession();
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    final result = await _authService.login(email: email, password: password);
    if (result.isSuccess) {
      state = AsyncValue.data(result.resultValue);
    } else {
      state = AsyncValue.error(result.errorMessage!, StackTrace.current);
      resetState();
    }
  }

  Future<void> register(String email, String password, String name) async {
    state = const AsyncValue.loading();
    final result = await _authService.createAccount(
        email: email, password: password, name: name);
    if (result.isSuccess) {
      final user = UserProfile(id: result.resultValue!.$id, name: name, email: email, imageId: '');
      await _userService.createUserProfile(user);
      await login(email, password);
    } else {
      state = AsyncValue.error(result.errorMessage!, StackTrace.current);
      resetState();
    }
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    final result = await _authService.logout();
    if (result.isSuccess) {
      state = const AsyncValue.data(null);
    } else {
      state = AsyncValue.error(result.errorMessage!, StackTrace.current);
      resetState();
    }
  }

  void resetState() async {
    Future.delayed(const Duration(seconds: 1), () {
      state = const AsyncValue.data(null);
    });
  }

  Future<models.User?> checkSession() async {
    try {
      // Get the current session
      final sessionResult = await _authService.getCurrentSession();

      if (sessionResult.isSuccess) {
        // If there's an active session, fetch the user details
        final userResult = await _authService.getCurrentUser();
        if (userResult.isSuccess) {
          return userResult.resultValue; // Return the user directly from build
        }
      }
    } catch (e) {
      // Handle any errors (e.g., network issues, session expired)
      print('Error checking session: $e');
    }

    // Return null if there's no active session or if an error occurred
    return null;
  }
}
