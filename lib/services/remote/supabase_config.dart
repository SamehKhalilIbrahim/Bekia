import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: 'https://ejklujulrbholnzajglq.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVqa2x1anVscmJob2xuemFqZ2xxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQwNzMyNDYsImV4cCI6MjA3OTY0OTI0Nn0.T4GsxeuC6ow-3alqo2WGOdicbYIvfi7PIpt0kydcUTc',
    );
  }
}
