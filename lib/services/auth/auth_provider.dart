import 'package:database/services/auth/auth_user.dart';

abstract class AuthProvider{
  AuthUser? get currentUser;
  Future<void>initialize();
 Future<AuthUser> Login({
    required email,
    required password
  });
  Future<AuthUser>Createuser({
    required email,
    required password
  });
  Future<void>Logout();
  Future<void>SendEmailVerification();

}