import 'package:flutter/services.dart';

class NativeBridge {
  static const MethodChannel _channel = MethodChannel('com.example.clonephone/native');

  // Method to fetch contact photo as Base64
  static Future<String?> fetchContactPhoto(String photoUri) async {
    try {
      final String? photoBase64 = await _channel.invokeMethod('fetchContactPhoto', {'photoUri': photoUri});
      return photoBase64;
    } catch (e) {
      print('Error fetching contact photo: $e');
      return null;
    }
  }
}
