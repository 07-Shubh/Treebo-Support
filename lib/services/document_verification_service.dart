import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class DocumentVerificationService {
  static const String _apiBaseUrl = 'https://your-document-verification-api.com';
  static const String _apiKey = 'your-api-key';

  // Simulated document verification (replace with actual API call)
  static Future<Map<String, dynamic>> verifyDocument({
    required dynamic image,
    required String documentType,
    required bool isFront,
  }) async {
    try {
      // In a real app, you would send the image to your document verification API
      // For this example, we'll simulate the API response
      await Future.delayed(const Duration(seconds: 2));

      // Simulate different responses based on document type
      final random = DateTime.now().millisecondsSinceEpoch % 3;
      
      if (random == 0) {
        // Success case
        return {
          'success': true,
          'documentType': documentType,
          'isFront': isFront,
          'isValid': true,
          'confidence': 0.95,
          'extractedData': {
            'name': 'Venkata',
            'documentNumber': 'XXXX XXXX XXXX',
            'dateOfBirth': '01/01/1990',
          },
          'message': 'Document verified successfully',
        };
      } else if (random == 1) {
        // Document not clear
        return {
          'success': false,
          'documentType': documentType,
          'isFront': isFront,
          'isValid': false,
          'confidence': 0.45,
          'message': 'Document image is not clear. Please upload a clearer image.',
        };
      } else {
        // Document type mismatch
        return {
          'success': false,
          'documentType': documentType,
          'isFront': isFront,
          'isValid': false,
          'confidence': 0.2,
          'message': 'The uploaded document does not appear to be a $documentType.',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error verifying document: ${e.toString()}',
      };
    }
  }

  // In a real app, this would be the actual API call
  static Future<Map<String, dynamic>> _makeApiRequest({
    required String endpoint,
    required Map<String, dynamic> body,
    required dynamic image,
  }) async {
    try {
      final uri = Uri.parse('$_apiBaseUrl/$endpoint');
      
      // Create multipart request
      var request = http.MultipartRequest('POST', uri);
      
      // Add headers
      request.headers['Authorization'] = 'Bearer $_apiKey';
      request.headers['Content-Type'] = 'multipart/form-data';
      
      // Add fields
      body.forEach((key, value) {
        request.fields[key] = value.toString();
      });
      
      // Add image file
      if (kIsWeb) {
        // For web
        if (image is XFile) {
          final bytes = await image.readAsBytes();
          request.files.add(http.MultipartFile.fromBytes(
            'document',
            bytes,
            filename: 'document.jpg',
          ));
        }
      } else if (image is File) {
        // For mobile
        request.files.add(await http.MultipartFile.fromPath(
          'document',
          image.path,
        ));
      }
      
      // Send request
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      
      if (response.statusCode == 200) {
        return jsonDecode(responseBody);
      } else {
        throw Exception('Failed to verify document: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error making API request: $e');
    }
  }
  
  // Validate document image quality
  static Future<bool> validateImageQuality(dynamic image) async {
    try {
      int? fileSize;
      
      if (kIsWeb && image is XFile) {
        final bytes = await image.readAsBytes();
        fileSize = bytes.length;
        print('Web image size: ${fileSize ~/ 1024} KB');
      } else if (image is File) {
        fileSize = await image.length();
        print('Mobile image size: ${fileSize ~/ 1024} KB');
      } else {
        print('Unsupported image type: ${image.runtimeType}');
        return false;
      }
      
      // Reduced minimum size to 20KB and added maximum size check
      const minSize = 20 * 1024; // 20KB minimum
      const maxSize = 10 * 1024 * 1024; // 10MB maximum
      
      if (fileSize < minSize) {
        print('Image too small: $fileSize bytes (min: $minSize bytes)');
        return false;
      }
      
      if (fileSize > maxSize) {
        print('Image too large: $fileSize bytes (max: $maxSize bytes)');
        return false;
      }
      
      print('Image quality check passed: $fileSize bytes');
      return true;
    } catch (e) {
      print('Error validating image quality: $e');
      return false;
    }
  }
}
