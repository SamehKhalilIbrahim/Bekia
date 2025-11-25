import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/remote/auth_services.dart';
import 'auth_event.dart';
import 'auth_states.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;

  AuthBloc({required AuthService authService})
    : _authService = authService,
      super(const AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<EditProfileRequested>(_onEditProfileRequested);
    on<UpdateEmailRequested>(_onUpdateEmailRequested);
    on<UpdatePasswordRequested>(_onUpdatePasswordRequested);
    on<LoadCurrentUser>(_onLoadCurrentUser);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await _authService.login(
      email: event.email,
      password: event.password,
      rememberMe: event.rememberMe,
    );

    result.fold(
      (failure) => emit(AuthError(message: failure.error)),
      (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await _authService.register(
      email: event.email,
      password: event.password,
      username: event.username,
      firstName: event.firstName,
      lastName: event.lastName,
    );

    result.fold(
      (failure) => emit(AuthError(message: failure.error)),
      (user) => emit(
        const AuthSuccess(
          message: 'Registration successful! Please verify your email.',
        ),
      ),
    );
  }

  Future<void> _onEditProfileRequested(
    EditProfileRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await _authService.editProfile(
      username: event.username,

      imageFile: event.imageFile,
    );

    result.fold(
      (failure) => emit(AuthError(message: failure.error)),
      (user) => emit(
        ProfileUpdated(user: user, message: 'Profile updated successfully!'),
      ),
    );
  }

  Future<void> _onUpdateEmailRequested(
    UpdateEmailRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await _authService.updateEmail(
      newEmail: event.newEmail,
      currentPassword: event.currentPassword,
    );

    result.fold(
      (failure) => emit(AuthError(message: failure.error)),
      (user) => emit(
        ProfileUpdated(
          user: user,
          message: 'Email updated successfully! Please verify your new email.',
        ),
      ),
    );
  }

  Future<void> _onUpdatePasswordRequested(
    UpdatePasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await _authService.updatePassword(
      currentPassword: event.currentPassword,
      newPassword: event.newPassword,
    );

    result.fold(
      (failure) => emit(AuthError(message: failure.error)),
      (user) => emit(
        const PasswordUpdated(message: 'Password updated successfully!'),
      ),
    );
  }

  Future<void> _onLoadCurrentUser(
    LoadCurrentUser event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await _authService.getCurrentUser();

    result.fold(
      (failure) => emit(const AuthUnauthenticated()),
      (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await _authService.logout();

    result.fold(
      (failure) => emit(AuthError(message: failure.error)),
      (_) => emit(const AuthUnauthenticated()),
    );
  }
}
