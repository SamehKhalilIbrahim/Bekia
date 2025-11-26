import '../../core/models/user_model/user_model.dart';

abstract class AuthState {
  const AuthState();

  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  final UserModel user;

  const AuthAuthenticated({required this.user});

  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}

class AuthSuccess extends AuthState {
  final String message;
  final UserModel? user;

  const AuthSuccess({required this.message, this.user});

  @override
  List<Object?> get props => [message, user];
}

class ProfileUpdated extends AuthState {
  final UserModel user;
  final String message;

  const ProfileUpdated({required this.user, required this.message});

  @override
  List<Object?> get props => [user, message];
}

class PasswordUpdated extends AuthState {
  final String message;

  const PasswordUpdated({required this.message});

  @override
  List<Object?> get props => [message];
}
