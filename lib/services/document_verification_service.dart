import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class DocumentVerificationService {
  // In-memory verification database (replace with real database in production)
  static final Map<String, Map<String, dynamic>> _verificationDatabase = {
    // Aadhaar samples
    '482884294931': {
      'type': 'AADHAAR',
      'fullName': 'DAYANAND NINGAYYA MAYUR',
      'dob': '01/07/1969',
      'gender': 'MALE',
      'address': '123, SECTOR 12, NEW DELHI, DELHI 110001',
      'isVerified': true,
    },
    '123456789012': {
      'type': 'AADHAAR',
      'fullName': 'RAHUL KUMAR',
      'dob': '15/06/1990',
      'gender': 'MALE',
      'address': '123, SECTOR 12, NEW DELHI, DELHI 110001',
      'isVerified': true,
    },
    '987654321098': {
      'type': 'AADHAAR',
      'fullName': 'PRIYA SHARMA',
      'dob': '22/11/1985',
      'gender': 'FEMALE',
      'address': 'BLOCK B, APT 304, MUMBAI, MAHARASHTRA 400001',
      'isVerified': true,
    },
    // PAN samples
    'ABCDE1234F': {
      'type': 'PAN',
      'fullName': 'RAHUL KUMAR',
      'dob': '15/06/1990',
      'isVerified': true,
    },
  };

  // OCR Configuration (uncomment when implementing real OCR service)
  // static const String _ocrApiKey = 'your-ocr-api-key';
  // static const String _ocrApiUrl = 'https://api.ocr.space/parse/image';

  /// Verifies a document by processing the image and extracting information
  static Future<Map<String, dynamic>> verifyDocument({
    required dynamic image,
    required String documentType,
    bool isFront = true,
  }) async {
    try {
      // Normalize document type (case-insensitive, remove spaces)
      String normalizedDocType = documentType.toUpperCase().replaceAll(' ', '');
      debugPrint('Starting document verification for type: $documentType (normalized: $normalizedDocType)');
      
      // 0. Process image with OCR first
      debugPrint('Processing image with OCR...');
      final ocrResult = await _processImageWithOcr(image);
      
      // Ensure ocrResult is properly typed
      final Map<String, dynamic> resultMap = Map<String, dynamic>.from(ocrResult);
      
      if (resultMap['success'] != true) {
        final error = 'Failed to process image: ${resultMap['error'] ?? 'Unknown error'}';
        debugPrint('OCR processing failed: $error');
        return _errorResponse(error);
      }
      
      final ocrText = resultMap['text']?.toString() ?? '';
      debugPrint('OCR result text: $ocrText');
      
      // First, try to detect document type from content
      bool isPan = ocrText.contains(RegExp(r'PERMANENT\s*ACCOUNT\s*NUMBER', caseSensitive: false)) || 
                 ocrText.contains(RegExp(r'INCOME\s*TAX', caseSensitive: false)) ||
                 ocrText.contains(RegExp(r'GOVT\.?\s*OF\s*INDIA', caseSensitive: false)) ||
                 RegExp(r'[A-Z]{5}[0-9]{4}[A-Z]').hasMatch(ocrText);
                 
      bool isAadhaar = ocrText.contains(RegExp(r'AADHAAR', caseSensitive: false)) || 
                     ocrText.contains('आधार') ||
                     RegExp(r'\d{4}[\s-]?\d{4}[\s-]?\d{4}').hasMatch(ocrText);
      
      debugPrint('Document detection - isPan: $isPan, isAadhaar: $isAadhaar');
      
      // If document type is AUTO or not matching, try to detect
      if (normalizedDocType.isEmpty || normalizedDocType == 'AUTO') {
        if (isPan) {
          normalizedDocType = 'PAN';
          debugPrint('Auto-detected document type as: PAN');
        } else if (isAadhaar) {
          normalizedDocType = 'AADHAAR';
          debugPrint('Auto-detected document type as: AADHAAR');
        } else {
          debugPrint('Could not auto-detect document type');
        }
      }
      // If document type is specified but doesn't match content, show warning
      else if ((normalizedDocType == 'AADHAAR' && isPan) || 
               (normalizedDocType == 'PAN' && isAadhaar)) {
        String detectedType = isPan ? 'PAN' : 'AADHAAR';
        String warning = 'Warning: Document appears to be $detectedType but was specified as $normalizedDocType';
        debugPrint(warning);
        return _errorResponse(
          '$warning. Please upload the correct document type.',
          documentType: normalizedDocType,
          extractedData: {'detectedType': detectedType}
        );
      }
      
      // 1. Validate input type
      if (image is! File && image is! XFile) {
        final error = 'Invalid image type provided. Expected File or XFile';
        debugPrint('Validation error: $error');
        return _errorResponse(error);
      }

      // 3. Extract document information using normalized document type
      debugPrint('Extracting document information for type: $normalizedDocType...');
      final extractedData = _extractDocumentInfo(ocrText, normalizedDocType);
      if (extractedData.containsKey('error')) {
        debugPrint('Error extracting document info: ${extractedData['error']}');
        return _errorResponse(extractedData['error']);
      }

      // 4. Verify document number
      final String docNumber = extractedData['document_number']?.toString() ?? '';
      debugPrint('Extracted document number: "$docNumber" (length: ${docNumber.length})');
      
      // Print all keys in the database for debugging
      debugPrint('Verification database has ${_verificationDatabase.length} entries:');
      _verificationDatabase.forEach((key, value) {
        debugPrint('  - "$key" (length: ${key.length})');
      });
      
      // Check if the document number exists in the database
      // Check if document exists and is verified
      final bool existsInDb = _verificationDatabase.containsKey(docNumber);
      debugPrint('Document number exists in database: $existsInDb');
      
      // Get verification data and ensure it's valid
      final docData = _verificationDatabase[docNumber];
      
      // Strict verification checks
      bool isVerified = false;
      if (existsInDb && docData != null) {
        // Check if document is explicitly verified
        // Get document data from database
        final dbData = {
          'fullName': _normalizeText(docData['fullName']?.toString()),
          'dob': _normalizeText(docData['dob']?.toString()),
          'gender': _normalizeText(docData['gender']?.toString()),
          'type': _normalizeText(docData['type']?.toString()),
        };
        
        final isDocVerified = docData['isVerified'] == true;
        
        // Extract and normalize data from OCR text
        final ocrData = {
          'fullName': _normalizeText(_extractFromOcr(ocrText, r'Name[\s:]+([^\n]+)')),
          'dob': _normalizeText(_extractFromOcr(ocrText, r'DOB[\s:]+([0-9/]+)')),
          'gender': _normalizeText(_extractFromOcr(ocrText, r'GENDER[\s:]+([A-Za-z]+)')),
          'documentNumber': docNumber,
        };
        
        // Log extracted data for debugging
        debugPrint('Database data: $dbData');
        debugPrint('OCR extracted data: $ocrData');
        
        // Check required fields
        final hasRequiredFields = 
            dbData['fullName']!.isNotEmpty &&
            dbData['type']!.isNotEmpty &&
            ocrData['fullName']!.isNotEmpty;
        
        // Verify each field matches
        int matchScore = 0;
        final int totalFields = 3; // name, dob, gender
        
        if (dbData['fullName'] == ocrData['fullName']) matchScore++;
        if (dbData['dob'] == ocrData['dob']) matchScore++;
        if (dbData['gender'] == ocrData['gender']) matchScore++;
        
        final double matchPercentage = matchScore / totalFields;
        final bool detailsMatch = matchPercentage >= 0.8; // Require at least 80% match
        
        debugPrint('Match score: $matchScore/$totalFields (${(matchPercentage * 100).toStringAsFixed(0)}%)');
        
        if (!detailsMatch) {
          debugPrint('⚠️ Document details do not match database records');
        }
            
        // Normalize document type for comparison
        String normalizeDocType(String? type) {
          if (type == null) return '';
          final normalized = type.trim().toUpperCase().replaceAll(' ', '');
          if (normalized == 'AADHARCARD') return 'AADHAAR';
          return normalized;
        }
        
        final docType = normalizeDocType(docData['type']?.toString());
        final inputDocType = normalizeDocType(documentType);
        final isTypeMatch = docType == inputDocType;
        
        debugPrint('Document type comparison - DB: "$docType" vs Input: "$inputDocType" -> Match: $isTypeMatch');
        
        isVerified = isDocVerified && hasRequiredFields && isTypeMatch && detailsMatch;
        
        if (!isVerified) {
          debugPrint('Verification failed - Verified: $isDocVerified, ' 
                    'Has Fields: $hasRequiredFields, Type Match: $isTypeMatch');
        }
      }
      
      if (existsInDb) {
        debugPrint('Document details: ${_verificationDatabase[docNumber]}');
      } else {
        debugPrint('Document not found in database');
      }
      debugPrint('Document verification result: $isVerified');

      // Ensure all maps are properly typed as Map<String, dynamic>
      final Map<String, dynamic> extractedDataMap = extractedData['extracted_data'] is Map 
          ? Map<String, dynamic>.from(extractedData['extracted_data'] as Map) 
          : <String, dynamic>{};
          
      final Map<String, dynamic> verificationData = isVerified 
          ? Map<String, dynamic>.from(_verificationDatabase[docNumber] as Map)
          : <String, dynamic>{};
      
      return <String, dynamic>{
        'success': true,
        'documentType': documentType,
        'isFront': isFront,
        'isValid': isVerified,
        'confidence': (resultMap['confidence'] as num?)?.toDouble() ?? 0.8,
        'extractedData': <String, dynamic>{
          ...extractedDataMap,
          'documentNumber': docNumber,
        },
        'verificationData': isVerified ? verificationData : null,
        'message': isVerified ? 'Document verified successfully' : 'Document not found in verification database',
      };
    } catch (e) {
      return _errorResponse('Document verification failed: $e');
    }
  }

  /// Processes an image with OCR (mock implementation)
  static Future<Map<String, dynamic>> _processImageWithOcr(dynamic imageFile) async {
    try {
      // For web platform
      if (kIsWeb) {
        if (imageFile is! XFile) {
          return {
            'success': false,
            'error': 'Invalid image type for web. Expected XFile'
          };
        }
        // On web, we can use the XFile directly
        // For demo purposes, we'll just use mock data without processing the actual file
      }
      // For mobile platforms
      else {
        if (imageFile is XFile) {
          // Convert XFile to File for mobile
          final tempDir = await getTemporaryDirectory();
          final tempPath =
              '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
          final file = File(tempPath);
          await file.writeAsBytes(await imageFile.readAsBytes());
          // For mobile, we could validate the file exists
          if (!await file.exists()) {
            return {'success': false, 'error': 'Failed to save temporary file'};
          }
        } else if (imageFile is! File) {
          return {
            'success': false,
            'error': 'Invalid image type. Expected File or XFile'
          };
        }
      }

      // Mock implementation - replace with actual OCR service
      await Future.delayed(const Duration(seconds: 1));
      
      // Return mock OCR response with explicit types
      return <String, dynamic>{
        'success': true,
        'text': 'AADHAAR NO: 4828 8429 4931\nName: Dayanand Ningayya Mayur\nDOB: 01/07/1969\nGENDER: MALE\nAddress: 123, SECTOR 12, NEW DELHI, DELHI 110001',
        'confidence': 0.95,
      };
    } catch (e) {
      return <String, dynamic>{
        'success': false, 
        'error': 'OCR processing failed: $e'
      };
    }
  }

  /// Extracts information from OCR text based on document type
  static Map<String, dynamic> _extractDocumentInfo(
      String ocrText, String documentType) {
    try {
      debugPrint('Extracting info for document type: $documentType');
      
      // Initialize result map with explicit types
      final Map<String, dynamic> result = <String, dynamic>{
        'document_type': documentType,
        'document_number': '',
        'extracted_data': <String, dynamic>{},
      };
      
      // Store original OCR text for reference
      result['extracted_data']['ocr_text'] = ocrText;
      
      // Convert OCR text to uppercase for case-insensitive matching
      final ocrUpper = ocrText.toUpperCase();
      
      // If document type is not recognized, try to extract any ID number
      if (documentType != 'PAN' && documentType != 'AADHAAR') {
        debugPrint('Warning: Unsupported document type: $documentType');
        
        // Try to extract PAN
        final panMatch = RegExp(r'[A-Z]{5}[0-9]{4}[A-Z]').firstMatch(ocrText);
        if (panMatch != null) {
          result['document_number'] = panMatch.group(0);
          result['extracted_data']['detected_type'] = 'PAN';
          debugPrint('Extracted potential PAN: ${result['document_number']}');
          return result;
        }
        
        // Try to extract Aadhaar
        final aadhaarMatch = RegExp(r'\d{4}[\s-]?\d{4}[\s-]?\d{4}').firstMatch(ocrText);
        if (aadhaarMatch != null) {
          result['document_number'] = aadhaarMatch.group(0)?.replaceAll(RegExp(r'[\s-]'), '') ?? '';
          result['extracted_data']['detected_type'] = 'AADHAAR';
          debugPrint('Extracted potential Aadhaar: ${result['document_number']}');
          return result;
        }
        
        return {'error': 'Unsupported document type and could not extract any ID number'};
      }
      
      // Handle PAN card extraction
      if (documentType == 'PAN') {
        debugPrint('=== STARTING PAN CARD EXTRACTION ===');
        debugPrint('Original OCR Text: "$ocrText"');
        
        // PAN number pattern: 5 letters, 4 numbers, 1 letter
        final panPattern = RegExp(r'[A-Z]{5}[0-9]{4}[A-Z]{1}');
        final panMatch = panPattern.firstMatch(ocrText);
        
        if (panMatch != null) {
          final panNumber = panMatch.group(0);
          debugPrint('Extracted PAN number: $panNumber');
          result['document_number'] = panNumber;
          
          // Extract name
          final nameMatch = RegExp(r'Name[\s:]*([^\n]+)').firstMatch(ocrText);
          if (nameMatch != null) {
            result['extracted_data']['fullName'] = nameMatch.group(1)?.trim() ?? '';
          }
          
          // Extract DOB
          final dobMatch = RegExp(r'DOB[\s:]*([0-9]{2}[/-][0-9]{2}[/-][0-9]{4})').firstMatch(ocrText);
          if (dobMatch != null) {
            result['extracted_data']['dateOfBirth'] = dobMatch.group(1)?.trim() ?? '';
          }
          
          return result;
        } else {
          return {'error': 'Could not extract PAN number from the document'};
        }
      }
      
      // Extract based on document type (already normalized)
      if (documentType == 'AADHAAR' || documentType == 'AADHARCARD') {
        debugPrint('=== STARTING AADHAAR EXTRACTION ===');
        debugPrint('Original OCR Text: "$ocrText"');
        
        // Try different patterns to extract Aadhaar number
        String aadhaarNumber = '';
        
        // Pattern 1: AADHAAR NO: 1234 5678 9012 (with various formats)
        var pattern1 = RegExp(r'(?:(?:AADHAAR|Aadhaar|आधार)[\s\S]*?(?:NO|Number|No\.?)[\s:]*)(\d{4}[\s-]?\d{4}[\s-]?\d{4})', caseSensitive: false);
        var match1 = pattern1.firstMatch(ocrText);
        if (match1 != null) {
          aadhaarNumber = match1.group(1)?.replaceAll(RegExp(r'[\s-]+'), '') ?? '';
          debugPrint('Pattern 1 matched. Group 1: ${match1.group(1)}');
        } 
        
        // Pattern 2: Just look for any 12-digit number with optional spaces/dashes
        if (aadhaarNumber.isEmpty) {
          debugPrint('Pattern 1 did not match, trying pattern 2...');
          var pattern2 = RegExp(r'\b(\d[\d\s-]{10,}\d)\b');
          var matches = pattern2.allMatches(ocrText);
          
          for (var match in matches) {
            String potentialNumber = match.group(0)!.replaceAll(RegExp(r'[\s-]+'), '');
            debugPrint('Found potential number: $potentialNumber');
            
            // Check if it's 12 digits (Aadhaar length)
            if (potentialNumber.length == 12) {
              aadhaarNumber = potentialNumber;
              debugPrint('Selected 12-digit number: $aadhaarNumber');
              break;
            }
          }
        }
        
        // Store the extracted Aadhaar number
        result['document_number'] = aadhaarNumber;
        
        // Initialize extracted_data if not already done
        if (result['extracted_data'] == null) {
          result['extracted_data'] = <String, dynamic>{};
        }
        
        // Extract name
        String fullName = '';
        final nameMatch = RegExp(r'NAME[\s:]*([^\n]+)').firstMatch(ocrText);
        if (nameMatch != null) {
          fullName = nameMatch.group(1)?.trim() ?? '';
          result['extracted_data']['fullName'] = fullName;
        }

        // Extract DOB
        String dob = '';
        final dobMatch =
            RegExp(r'DOB[:\s]*(\d{2}[/-]\d{2}[/-]\d{4})').firstMatch(ocrText);
        if (dobMatch != null) {
          dob = dobMatch.group(1) ?? '';
        }

        // Extract gender
        String gender = '';
        final genderMatch =
            RegExp(r'GENDER[:\s]*(MALE|FEMALE|M|F)').firstMatch(ocrText);
        if (genderMatch != null) {
          gender = genderMatch.group(1) ?? '';
        }

        // Extract address
        String address = '';
        final addressMatch =
            RegExp(r'ADDRESS[:\s]*(.*?)(?:\n\n|$)').firstMatch(ocrText);
        if (addressMatch != null) {
          address = addressMatch.group(1)?.trim() ?? '';
        }

        result['document_number'] = aadhaarNumber;
        result['extracted_data'] = {
          'fullName': fullName,
          'dateOfBirth': dob,
          'gender': gender,
          'address': address,
        };
      }
      // Add more document types as needed
      else if (documentType == 'PAN') {
        // Similar extraction logic for PAN card
        final panRegex = RegExp(r'[A-Z]{5}[0-9]{4}[A-Z]{1}');
        final panMatch = panRegex.firstMatch(ocrText);
        final panNumber = panMatch?.group(0) ?? '';

        String fullName = '';
        final nameMatch =
            RegExp(r'NAME[:\s]*(.*?)(?:\n|$)').firstMatch(ocrText);
        if (nameMatch != null) {
          fullName = nameMatch.group(1)?.trim() ?? '';
        }

        result['document_number'] = panNumber;
        result['extracted_data'] = {
          'fullName': fullName,
          'documentType': 'PAN',
        };
      }

      return result;
    } catch (e) {
      return {'error': 'Failed to extract document info: $e'};
    }
  }

  /// Helper method to create error responses
  /// Extracts text from OCR using the given regex pattern
  static String _extractFromOcr(String ocrText, String pattern) {
    try {
      final match = RegExp(pattern, caseSensitive: false).firstMatch(ocrText);
      if (match != null && match.groupCount >= 1) {
        return match.group(1)?.trim() ?? '';
      }
    } catch (e) {
      debugPrint('Error extracting text with pattern $pattern: $e');
    }
    return '';
  }
  
  /// Normalizes text for comparison (uppercase and remove extra spaces)
  static String _normalizeText(String? text) {
    if (text == null) return '';
    return text.trim().toUpperCase().replaceAll(RegExp(r'\s+'), ' ');
  }

  /// Helper method to create error responses
  static Map<String, dynamic> _errorResponse(String message, {String? documentType, Map<String, dynamic>? extractedData}) {
    return {
      'success': false,
      'message': message,
      'isValid': false,
      'confidence': 0.0,
      'documentType': documentType,
      'extractedData': extractedData ?? {},
    };
  }

  /// Validates Aadhaar number using Verhoeff algorithm
  static bool validateAadhaarNumber(String aadhaar) {
    // Implementation of Verhoeff algorithm
    if (aadhaar.length != 12) return false;

    // Simple check for demo - in production, implement the full Verhoeff algorithm
    try {
      int.parse(aadhaar);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Adds a document to the verification database
  static void addToVerificationDatabase(
      String documentNumber, Map<String, dynamic> data) {
    _verificationDatabase[documentNumber] = {
      ...data,
      'isVerified': true,
      'addedAt': DateTime.now().toIso8601String(),
    };
  }

  /// Retrieves a document from the verification database
  static Map<String, dynamic>? getFromVerificationDatabase(
      String documentNumber) {
    return _verificationDatabase[documentNumber];
  }

  /// Validates image quality (size and format)
  static Future<bool> validateImageQuality(dynamic imageFile) async {
    try {
      int length;

      if (imageFile is XFile) {
        final data = await imageFile.readAsBytes();
        length = data.lengthInBytes;
      } else if (imageFile is File) {
        length = await imageFile.length();
      } else {
        debugPrint('Invalid image type. Expected File or XFile');
        return false;
      }

      const minSize = 20 * 1024; // 20KB minimum
      const maxSize = 10 * 1024 * 1024; // 10MB maximum

      if (length < minSize) {
        debugPrint('Image is too small. Minimum size is ${minSize ~/ 1024}KB');
        return false;
      }

      if (length > maxSize) {
        debugPrint(
            'Image is too large. Maximum size is ${maxSize ~/ (1024 * 1024)}MB');
        return false;
      }

      // You can add more validations here like image dimensions, format, etc.
      return true;
    } catch (e) {
      debugPrint('Error validating image quality: $e');
      return false;
    }
  }
}
