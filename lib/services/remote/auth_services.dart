import 'dart:io';
import 'package:bekia/services/constants.dart';
import 'package:dartz/dartz.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/errors/failures.dart';
import '../../core/errors/error_handler.dart';
import '../../core/models/product_model/product_model.dart';
import '../../core/models/user_model/user_model.dart';
import 'image_upload_service.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final ImageUploadService _imageService = ImageUploadService();

  // Login
  Future<Either<Failure, UserModel>> login({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    return guard(() async {
      // Sign in with Supabase
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception('Login failed - no user returned');
      }

      // Save remember me preference
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool("remember_me", rememberMe);

      // Fetch user data from users table
      final userData = await _supabase
          .from('users')
          .select()
          .eq('id', response.user!.id)
          .single();

      return UserModel.fromJson(userData);
    });
  }

  // Register
  Future<Either<Failure, UserModel>> register({
    required String email,
    required String password,
    required String username,
  }) async {
    return guard(() async {
      // Check if username is taken
      final usernameExists = await _checkUsernameTaken(username);
      if (usernameExists) {
        throw Exception('Username is already taken');
      }

      // Sign up with Supabase
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception('Registration failed - no user returned');
      }

      final user = response.user!;

      // Insert user data into users table
      final userData = {
        'id': user.id,
        'email': email,
        'username': username,

        'created_at': user.createdAt,
      };

      await _supabase.from("users").insert(userData);

      // Sign out after registration (user needs to verify email)
      await _supabase.auth.signOut();

      return UserModel.fromJson(userData);
    });
  }

  // Get Current User
  Future<Either<Failure, UserModel>> getCurrentUser() async {
    return guard(() async {
      final currentUser = _supabase.auth.currentUser;

      if (currentUser == null) {
        throw Exception('No user logged in');
      }

      final userData = await _supabase
          .from('users')
          .select()
          .eq('id', currentUser.id)
          .single();

      return UserModel.fromJson(userData);
    });
  }

  // Edit Profile
  Future<Either<Failure, UserModel>> editProfile({
    required String username,
    File? imageFile,
  }) async {
    return guard(() async {
      final currentUser = _supabase.auth.currentUser;

      if (currentUser == null) {
        throw Exception('No user logged in');
      }

      // Check if new username is taken (if changed)
      final currentData = await _supabase
          .from('users')
          .select('username')
          .eq('id', currentUser.id)
          .single();

      if (currentData['username'] != username) {
        final usernameExists = await _checkUsernameTaken(username);
        if (usernameExists) {
          throw Exception('Username is already taken');
        }
      }

      // Upload image if provided
      String? imageUrl;
      if (imageFile != null) {
        imageUrl = await _imageService.uploadImage(
          imageFile,
          ImageType.profile,
        );
      }

      // Prepare update data
      final Map<String, dynamic> updateData = {'username': username};

      if (imageUrl != null) {
        updateData['profile_image_url'] = imageUrl;
      }

      // Update user data
      await _supabase.from('users').update(updateData).eq('id', currentUser.id);

      // Fetch updated user data
      final updatedUserData = await _supabase
          .from('users')
          .select()
          .eq('id', currentUser.id)
          .single();

      return UserModel.fromJson(updatedUserData);
    });
  }

  // Update Email
  Future<Either<Failure, UserModel>> updateEmail({
    required String newEmail,
    required String currentPassword,
  }) async {
    return guard(() async {
      final currentUser = _supabase.auth.currentUser;

      if (currentUser == null) {
        throw Exception('No user logged in');
      }

      // Re-authenticate user
      await _supabase.auth.signInWithPassword(
        email: currentUser.email!,
        password: currentPassword,
      );

      // Update email in auth
      await _supabase.auth.updateUser(UserAttributes(email: newEmail));

      // Update email in users table
      await _supabase
          .from('users')
          .update({'email': newEmail})
          .eq('id', currentUser.id);

      // Fetch updated user data
      final updatedUserData = await _supabase
          .from('users')
          .select()
          .eq('id', currentUser.id)
          .single();

      return UserModel.fromJson(updatedUserData);
    });
  }

  // Update Password
  Future<Either<Failure, Unit>> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    return guard(() async {
      final currentUser = _supabase.auth.currentUser;

      if (currentUser == null) {
        throw Exception('No user logged in');
      }

      // Re-authenticate user
      await _supabase.auth.signInWithPassword(
        email: currentUser.email!,
        password: currentPassword,
      );

      // Update password
      await _supabase.auth.updateUser(UserAttributes(password: newPassword));

      return unit;
    });
  }

  // Logout
  Future<Either<Failure, Unit>> logout() async {
    return guard(() async {
      // 1. Sign out from Supabase
      await _supabase.auth.signOut();

      // 2. Remove remember_me preference
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove("remember_me");

      // 3. Clear local Hive data (cart and favorites)
      await Hive.box<Product>(HiveConstant.cartProductBox).clear();
      await Hive.box<Product>(HiveConstant.favoritesProductBox).clear();

      return unit;
    });
  }

  // Helper method to check if username is taken
  Future<bool> _checkUsernameTaken(String username) async {
    final result = await _supabase
        .from('users')
        .select('username')
        .eq('username', username)
        .maybeSingle();

    return result != null;
  }
}
