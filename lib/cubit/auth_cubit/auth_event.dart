// lib/features/auth/presentation/bloc/auth_event.dart

import 'dart:io';

abstract class AuthEvent {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  final bool rememberMe;

  const LoginRequested({
    required this.email,
    required this.password,
    required this.rememberMe,
  });

  @override
  List<Object?> get props => [email, password, rememberMe];
}

class RegisterRequested extends AuthEvent {
  final String email;
  final String password;
  final String username;
  final String firstName;
  final String lastName;

  const RegisterRequested({
    required this.email,
    required this.password,
    required this.username,
    required this.firstName,
    required this.lastName,
  });

  @override
  List<Object?> get props => [email, password, username, firstName, lastName];
}

class EditProfileRequested extends AuthEvent {
  final String username;

  final File? imageFile;

  const EditProfileRequested({required this.username, this.imageFile});

  @override
  List<Object?> get props => [username, imageFile];
}

class UpdateEmailRequested extends AuthEvent {
  final String newEmail;
  final String currentPassword;

  const UpdateEmailRequested({
    required this.newEmail,
    required this.currentPassword,
  });

  @override
  List<Object?> get props => [newEmail, currentPassword];
}

class UpdatePasswordRequested extends AuthEvent {
  final String currentPassword;
  final String newPassword;

  const UpdatePasswordRequested({
    required this.currentPassword,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [currentPassword, newPassword];
}

class LoadCurrentUser extends AuthEvent {
  const LoadCurrentUser();
}

class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}
