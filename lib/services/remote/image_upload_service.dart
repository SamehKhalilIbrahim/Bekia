import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

enum ImageType { product, profile }

class ImageUploadService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<String> uploadImage(File imageFile, ImageType type) async {
    final fileExt = imageFile.path.split('.').last;
    final fileName = '${const Uuid().v4()}.$fileExt';
    final filePath = '${type.name}/$fileName';

    await _supabase.storage.from('images').upload(filePath, imageFile);

    // Get public URL
    final publicUrl = _supabase.storage.from('images').getPublicUrl(filePath);

    return publicUrl;
  }
}
