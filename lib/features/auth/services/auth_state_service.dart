import 'package:mini_home/features/auth/repositories/auth_storage_repository.dart';
import 'package:mini_home/features/user/services/user_service.dart';
import 'package:mini_home/features/user_group/models/user_group.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_state_service.g.dart';

class AuthState {
  final bool isLoggedIn;
  final String email;
  final UserGroup? defaultUserGroup;

  const AuthState(
      {required this.isLoggedIn, required this.email, this.defaultUserGroup});

  AuthState copyWith(
      {bool? isLoggedIn, String? email, UserGroup? defaultUserGroup}) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      email: email ?? this.email,
      defaultUserGroup: defaultUserGroup ?? this.defaultUserGroup,
    );
  }

  factory AuthState.initial() =>
      const AuthState(isLoggedIn: false, email: "", defaultUserGroup: null);
}

@riverpod
class AuthStateService extends _$AuthStateService {
  @override
  FutureOr<AuthState> build() async {
    final userService = ref.watch(userServiceProvider.notifier);
    final isLoggedIn = await checkIsLoggedIn();

    if (isLoggedIn) {
      final user = await userService.getCurrentUser();
      return AuthState(
          isLoggedIn: true,
          email: user?.email ?? "",
          defaultUserGroup: user?.defaultHomeId != null
              ? UserGroup(id: user!.defaultHomeId!, name: 'My Home')
              : user?.userGroups?.isNotEmpty == true
                  ? user?.userGroups!.first
                  : null);
    } else {
      return AuthState.initial();
    }
  }

  Future<bool> checkIsLoggedIn() async {
    final authStorageRepository = AuthStorageRepository();
    final token = await authStorageRepository.getCurrentAccessToken();
    final user = await ref.read(userServiceProvider.notifier).getCurrentUser();

    return token != null && token.isNotEmpty && user != null;
  }
}
