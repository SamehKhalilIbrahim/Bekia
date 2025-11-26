import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Failure {
  final String error;

  Failure({required this.error});

  factory Failure.fromDioError(DioException dioException) {
    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
        return Failure(error: "Connection timed out.");
      case DioExceptionType.sendTimeout:
        return Failure(error: "Send timeout.");
      case DioExceptionType.receiveTimeout:
        return Failure(error: "Receive timeout.");
      case DioExceptionType.badCertificate:
        return Failure(error: "Bad SSL certificate.");
      case DioExceptionType.badResponse:
        return Failure._fromBadResponse(
          statusCode: dioException.response?.statusCode,
          response: dioException.response?.data,
        );
      case DioExceptionType.cancel:
        return Failure(error: "Request was cancelled.");
      case DioExceptionType.connectionError:
        return Failure(error: "No internet connection.");
      case DioExceptionType.unknown:
        if (dioException.message?.contains("SocketException") ?? false) {
          return Failure(error: "No internet connection.");
        }
        return Failure(error: "Unexpected error occurred.");
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
      return Failure(error: "Resource not found.");
    } else if (statusCode == 409) {
      return Failure(error: "Conflict error.");
    } else if (statusCode == 500) {
      return Failure(error: "Internal server error.");
    } else {
      return Failure(error: "An error occurred.");
    }
  }

  factory Failure.fromAuthApiException(AuthApiException exception) {
    final message = exception.message.toLowerCase();
    final code = exception.code;

    if (code == 'otp_invalid' ||
        message.contains('invalid') && message.contains('otp') ||
        code == 'otp_expired') {
      return Failure(error: "Invalid OTP code.");
    } else if (code == 'same_password' ||
        message.contains('new password should be different') ||
        message.contains('same password')) {
      return Failure(error: "New password must be different.");
    } else if (message.contains("invalid login credentials")) {
      return Failure(error: "Invalid login credentials.");
    } else if (message.contains("email not confirmed")) {
      return Failure(error: "Email not confirmed.");
    } else if (message.contains("user already registered")) {
      return Failure(error: "User already registered.");
    } else if (message.contains("expired action link") ||
        message.contains("token has expired")) {
      return Failure(error: "Link has expired.");
    } else if (message.contains("password")) {
      return Failure(error: "Weak or incorrect password.");
    } else {
      return Failure(error: "Authentication failed.");
    }
  }

  factory Failure.fromAuthException(AuthException exception) {
    final message = exception.message.toLowerCase();
    final code = exception.code;

    if (code == 'access_denied') {
      if (message.contains('permissions error')) {
        return Failure(error: "Login cancelled.");
      } else if (message.contains('expired')) {
        return Failure(error: "Link expired.");
      } else {
        return Failure(error: "Login cancelled.");
      }
    } else if (code == 'otp_expired' ||
        message.contains('expired') ||
        message.contains('invalid') && message.contains('link')) {
      return Failure(error: "Link expired.");
    } else if (code == 'otp_invalid' ||
        message.contains('invalid') && message.contains('otp')) {
      return Failure(error: "Invalid OTP code.");
    } else if (code == 'same_password') {
      return Failure(error: "New password must be different.");
    } else if (message.contains("invalid login credentials")) {
      return Failure(error: "Invalid login credentials.");
    } else if (message.contains("email not confirmed")) {
      return Failure(error: "Email not confirmed.");
    } else if (message.contains("user already registered")) {
      return Failure(error: "User already registered.");
    } else if (message.contains("password")) {
      return Failure(error: "Weak or incorrect password.");
    } else {
      return Failure(error: "Authentication failed.");
    }
  }

  factory Failure.fromSqlException(PostgrestException exception) {
    final code = exception.code;
    final message = exception.message.toLowerCase();

    if (code == "23505" || message.contains("duplicate key")) {
      return Failure(error: "Duplicate record error.");
    } else if (code == "23503" || message.contains("foreign key")) {
      return Failure(error: "Foreign key constraint error.");
    } else if (code == "23502" || message.contains("null value")) {
      return Failure(error: "Null value error.");
    } else if (code == "42601" || message.contains("syntax")) {
      return Failure(error: "SQL syntax error.");
    } else if (code == "22001" || message.contains("value too long")) {
      return Failure(error: "Value too long.");
    } else if (code == "22P02" || message.contains("invalid input syntax")) {
      return Failure(error: "Invalid input syntax.");
    } else {
      return Failure(error: "Database error.");
    }
  }

  factory Failure.fromStorageException(StorageException exception) {
    final message = exception.message.toLowerCase();
    final statusCode = exception.statusCode;

    if (statusCode == '404' || message.contains('not found')) {
      return Failure(error: "File not found.");
    } else if (statusCode == '413' || message.contains('too large')) {
      return Failure(error: "File too large.");
    } else if (statusCode == '415' || message.contains('invalid file type')) {
      return Failure(error: "Invalid file type.");
    } else if (statusCode == '403' || message.contains('forbidden')) {
      return Failure(error: "Access denied.");
    } else if (message.contains('bucket') && message.contains('not found')) {
      return Failure(error: "Storage bucket not found.");
    } else if (message.contains('upload')) {
      return Failure(error: "File upload failed.");
    } else if (message.contains('download')) {
      return Failure(error: "File download failed.");
    } else {
      return Failure(error: "Storage error.");
    }
  }

  factory Failure.fromStringException(String errorMessage) {
    final message = errorMessage.toLowerCase();

    if (message.contains("user with provided email does not exist")) {
      return Failure(error: "User email not found.");
    }

    return Failure(error: "Unexpected error.");
  }

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
      return Failure(error: "Unexpected error occurred.");
    }
    // return Failure(error: exception.toString());
  }
}
