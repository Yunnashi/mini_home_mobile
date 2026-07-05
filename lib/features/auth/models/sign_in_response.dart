import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mini_home/features/auth/models/token.dart';
import 'package:mini_home/features/user/models/user.dart';

part 'sign_in_response.freezed.dart';
part 'sign_in_response.g.dart';

@freezed
abstract class SignInResponse with _$SignInResponse {
  const factory SignInResponse({
    required Token token,
    required User user,
  }) = _SignInResponse;

  factory SignInResponse.fromJson(Map<String, dynamic> json) =>
      _$SignInResponseFromJson(json);
}
