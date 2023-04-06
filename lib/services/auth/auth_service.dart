import 'package:database/services/auth/auth_provider.dart';
import 'package:database/services/auth/auth_user.dart';
import 'package:database/services/auth/firebase_auth_provider.dart';

class AuthService implements AuthProvider{
  final AuthProvider provider; 
  const AuthService(this.provider);
  factory AuthService.firebase()=>AuthService(FirebaseAuthProvider());
  @override
  Future<AuthUser> Createuser({required email, required password})=>
  provider.Createuser(email: email, password: password) ;
  @override
  Future<AuthUser> Login({required email, required password})=>provider.Login(email: email, password: password);


  @override
  Future<void> Logout()=>provider.Logout(); 
  
  @override
  Future<void> SendEmailVerification() => provider.SendEmailVerification();

  @override
  AuthUser? get currentUser => provider.currentUser;
  
  @override
  Future<void> initialize()=>provider.initialize();
    
  

}