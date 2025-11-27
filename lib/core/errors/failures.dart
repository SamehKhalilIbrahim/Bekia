import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Failure {
  final String error;

  Failure({required this.error});

  // -------------------------
  // DIO ERRORS
  // -------------------------
  factory Failure.fromDioError(DioException dioException) {
    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
        return Failure(error: "Connection timeout with server.");
      case DioExceptionType.sendTimeout:
        return Failure(error: "Send timeout with server.");
      case DioExceptionType.receiveTimeout:
        return Failure(error: "Receive timeout with server.");
      case DioExceptionType.badCertificate:
        return Failure(error: "Bad certificate (incorrect certificate).");
      case DioExceptionType.badResponse:
        return Failure._fromBadResponse(
          statusCode: dioException.response?.statusCode,
          response: dioException.response?.data,
        );
      case DioExceptionType.cancel:
        return Failure(error: "Request was canceled.");
      case DioExceptionType.connectionError:
        return Failure(error: "No internet connection.");
      case DioExceptionType.unknown:
        if (dioException.message?.contains("SocketException") ?? false) {
          return Failure(error: "No internet connection.");
        }
        return Failure(error: "Unexpected error. Please try again.");
    }
  }

  factory Failure._fromBadResponse({
    required int? statusCode,
    dynamic response,
  }) {
    if (statusCode == null) {
      return Failure(error: "Unexpected server error.");
    }

    if (statusCode == 400 || statusCode == 401 || statusCode == 403) {
      return Failure(
        error: response?["error"]["message"] ?? "Unauthorized request.",
      );
    } else if (statusCode == 404) {
      return Failure(error: "Your request was not found.");
    } else if (statusCode == 409) {
      return Failure(error: "There is a conflict with the current data.");
    } else if (statusCode == 500) {
      return Failure(error: "Internal server error. Please try again.");
    } else {
      return Failure(error: "Oops, something went wrong. Please try again.");
    }
  }

  // -------------------------
  // AUTH API EXCEPTIONS
  // -------------------------
  factory Failure.fromAuthApiException(AuthApiException exception) {
    final message = exception.message.toLowerCase();
    final code = exception.code;

    if (code == 'otp_invalid' ||
        (message.contains('invalid') && message.contains('otp')) ||
        code == 'otp_expired') {
      return Failure(error: "Invalid OTP code. Please check and try again.");
    } else if (code == 'same_password' ||
        message.contains('new password should be different') ||
        message.contains('same password')) {
      return Failure(
        error: "New password must be different from the old password.",
      );
    } else if (message.contains("invalid login credentials")) {
      return Failure(error: "Invalid email or password.");
    } else if (message.contains("email not confirmed")) {
      return Failure(error: "Please confirm your email before logging in.");
    } else if (message.contains("user already registered")) {
      return Failure(error: "This email is already registered.");
    } else if (message.contains("expired action link") ||
        message.contains("token has expired")) {
      return Failure(error: "This reset link has expired.");
    } else if (message.contains("password")) {
      return Failure(error: "Your password is too weak or incorrect.");
    } else {
      return Failure(error: "Authentication failed. Please try again.");
    }
  }

  // -------------------------
  // AUTH EXCEPTIONS
  // -------------------------
  factory Failure.fromAuthException(AuthException exception) {
    final message = exception.message.toLowerCase();
    final code = exception.code;

    if (code == 'access_denied') {
      if (message.contains('permissions error')) {
        return Failure(error: "Login was cancelled.");
      } else if (message.contains('expired')) {
        return Failure(error: "This reset link has expired.");
      } else {
        return Failure(error: "Login was cancelled.");
      }
    } else if (code == 'otp_expired' ||
        message.contains('expired') ||
        (message.contains('invalid') && message.contains('link'))) {
      return Failure(error: "This reset link has expired.");
    } else if (code == 'otp_invalid' ||
        (message.contains('invalid') && message.contains('otp'))) {
      return Failure(error: "Invalid OTP code. Please check and try again.");
    } else if (code == 'same_password' ||
        message.contains('new password should be different') ||
        message.contains('same password')) {
      return Failure(
        error: "New password must be different from the old password.",
      );
    } else if (message.contains("invalid login credentials")) {
      return Failure(error: "Invalid email or password.");
    } else if (message.contains("email not confirmed")) {
      return Failure(error: "Please confirm your email before logging in.");
    } else if (message.contains("user already registered")) {
      return Failure(error: "This email is already registered.");
    } else if (message.contains("password")) {
      return Failure(error: "Your password is too weak or incorrect.");
    } else {
      return Failure(error: "Authentication failed. Please try again.");
    }
  }

  // -------------------------
  // SQL EXCEPTIONS
  // -------------------------
  factory Failure.fromSqlException(PostgrestException exception) {
    final code = exception.code;
    final message = exception.message.toLowerCase();

    if (code == "23505" || message.contains("duplicate key")) {
      return Failure(error: "This record already exists.");
    } else if (code == "23503" || message.contains("foreign key")) {
      return Failure(error: "This record is linked and cannot be removed.");
    } else if (code == "23502" || message.contains("null value")) {
      return Failure(error: "A required field was left empty.");
    } else if (code == "42601" || message.contains("syntax")) {
      return Failure(error: "There is a problem with the database query.");
    } else if (code == "22001" || message.contains("value too long")) {
      return Failure(error: "The provided value is too long.");
    } else if (code == "22P02" || message.contains("invalid input syntax")) {
      return Failure(error: "Invalid input format.");
    } else {
      return Failure(error: "A database error occurred. Please try again.");
    }
  }

  // -------------------------
  // STORAGE EXCEPTIONS
  // -------------------------
  factory Failure.fromStorageException(StorageException exception) {
    final message = exception.message.toLowerCase();
    final statusCode = exception.statusCode;

    if (statusCode == '404' || message.contains('not found')) {
      return Failure(error: "File not found.");
    } else if (statusCode == '413' || message.contains('too large')) {
      return Failure(error: "File is too large.");
    } else if (statusCode == '415' || message.contains('invalid file type')) {
      return Failure(error: "Invalid file type.");
    } else if (statusCode == '403' || message.contains('forbidden')) {
      return Failure(error: "Access denied to storage.");
    } else if (message.contains('bucket') && message.contains('not found')) {
      return Failure(error: "Storage bucket not found.");
    } else if (message.contains('upload')) {
      return Failure(error: "File upload failed.");
    } else if (message.contains('download')) {
      return Failure(error: "File download failed.");
    } else {
      return Failure(error: "Storage error occurred.");
    }
  }

  // -------------------------
  // STRING EXCEPTIONS
  // -------------------------
  factory Failure.fromStringException(String errorMessage) {
    final message = errorMessage.toLowerCase();

    if (message.contains("user with provided email does not exist")) {
      return Failure(error: "User with provided email does not exist.");
    }

    return Failure(error: "Unexpected error. Please try again.");
  }

  // -------------------------
  // AUTO DETECT
  // -------------------------
  factory Failure.fromException(dynamic exception) {
    if (exception is AuthException) {
      return Failure.fromAuthException(exception);
    } else if (exception is AuthApiException) {
      return Failure.fromAuthApiException(exception);
    } else if (exception is PostgrestException) {
      return Failure.fromSqlException(exception);
    } else if (exception is StorageException) {
      return Failure.fromStorageException(exception);
    } else if (exception is DioException) {
      return Failure.fromDioError(exception);
    } else if (exception is String) {
      return Failure.fromStringException(exception);
    } else {
      return Failure(error: "Unexpected error. Please try again.");
    }
  }
}
