import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:treebo_self_checkin/services/document_verification_service.dart';
import 'signature_screen.dart';

class DocumentVerificationScreen extends StatefulWidget {
  const DocumentVerificationScreen({Key? key}) : super(key: key);

  @override
  _DocumentVerificationScreenState createState() => _DocumentVerificationScreenState();
}

class _DocumentVerificationScreenState extends State<DocumentVerificationScreen> {
  final ImagePicker _picker = ImagePicker();
  
  dynamic _frontImage;
  dynamic _backImage;
  bool _isVerifying = false;
  bool _isFrontVerified = false;
  bool _isBackVerified = false;
  String? _verificationError;
  Map<String, dynamic>? _extractedData;
  
  String _selectedDocumentType = 'Aadhar Card';
  final List<String> _documentTypes = [
    'Aadhar Card',
    'PAN Card',
    'Driving License',
    'Passport',
  ];
  
  Future<void> _pickImage(bool isFront) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      
      if (image != null && mounted) {
        setState(() {
          if (isFront) {
            _frontImage = kIsWeb ? image : File(image.path);
            _isFrontVerified = false;
          } else {
            _backImage = kIsWeb ? image : File(image.path);
            _isBackVerified = false;
          }
          _verificationError = null;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: $e')),
        );
      }
    }
  }
  
  Future<void> _verifyDocument(bool isFront) async {
    final image = isFront ? _frontImage : _backImage;
    if (image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please upload ${isFront ? 'front' : 'back'} side first'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isVerifying = true;
      _verificationError = null;
    });

    try {
      final isImageValid = await DocumentVerificationService.validateImageQuality(image);
      if (!isImageValid) {
        setState(() {
          _verificationError = 'Image quality is too low. Please upload a clearer image.';
          _isVerifying = false;
        });
        return;
      }

      final result = await DocumentVerificationService.verifyDocument(
        image: image,
        documentType: _selectedDocumentType,
        isFront: isFront,
      );

      if (!mounted) return;

      setState(() {
        _isVerifying = false;
        if (result['success'] == true && result['isValid'] == true) {
          if (isFront) {
            _isFrontVerified = true;
            _extractedData = result['extractedData'];
          } else {
            _isBackVerified = true;
          }
          _verificationError = null;
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${isFront ? 'Front' : 'Back'} side verified successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          _verificationError = result['message'] ?? 'Verification failed. Please try again.';
          if (isFront) _isFrontVerified = false;
          if (!isFront) _isBackVerified = false;
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_verificationError!),
              backgroundColor: Colors.red,
            ),
          );
        }
      });
    } catch (e) {
      if (!mounted) return;
      
      setState(() {
        _isVerifying = false;
        _verificationError = 'Error verifying document: $e';
        if (isFront) _isFrontVerified = false;
        if (!isFront) _isBackVerified = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  
  void _proceedToSignature() {
    if (!_isFrontVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please verify the front side of your document first'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_selectedDocumentType == 'Aadhar Card' && !_isBackVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please verify the back side of your Aadhar Card'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SignatureScreen(extractedData: _extractedData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Document Verification'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ID Verification',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please upload and verify your identity document',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            
            Text(
              'Document Type',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedDocumentType,
                  isExpanded: true,
                  items: _documentTypes.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedDocumentType = newValue;
                        _isFrontVerified = false;
                        _isBackVerified = false;
                        _frontImage = null;
                        _backImage = null;
                      });
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            _buildDocumentUploadSection(
              title: 'Front Side',
              image: _frontImage,
              isVerified: _isFrontVerified,
              onPickImage: () => _pickImage(true),
              onVerify: () => _verifyDocument(true),
              isLoading: _isVerifying,
            ),
            const SizedBox(height: 24),
            
            if (_selectedDocumentType == 'Aadhar Card')
              _buildDocumentUploadSection(
                title: 'Back Side',
                image: _backImage,
                isVerified: _isBackVerified,
                onPickImage: () => _pickImage(false),
                onVerify: () => _verifyDocument(false),
                isLoading: _isVerifying,
              ),
            
            if (_verificationError != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  _verificationError!,
                  style: GoogleFonts.poppins(
                    color: Colors.red,
                    fontSize: 14,
                  ),
                ),
              ),
            
            const SizedBox(height: 32),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _proceedToSignature,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Proceed to Signature',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildDocumentUploadSection({
    required String title,
    required dynamic image,
    required bool isVerified,
    required VoidCallback onPickImage,
    required VoidCallback onVerify,
    required bool isLoading,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onPickImage,
          child: Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(
                color: isVerified ? Colors.green : Colors.grey[300]!,
                width: isVerified ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[100],
            ),
            child: image == null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.upload_file,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap to upload $title',
                          style: GoogleFonts.poppins(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : Stack(
                    fit: StackFit.expand,
                    children: [
                      kIsWeb
                          ? Image.network(
                              (image as XFile).path,
                              fit: BoxFit.contain,
                            )
                          : Image.file(
                              image as File,
                              fit: BoxFit.contain,
                            ),
                      if (isVerified)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                    ],
                  ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onPickImage,
                icon: const Icon(Icons.upload),
                label: Text('Upload $title'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: image == null || isVerified ? null : onVerify,
                icon: isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Icon(isVerified ? Icons.check_circle : Icons.verified_user),
                label: Text(
                  isLoading ? 'Verifying...' : isVerified ? 'Verified' : 'Verify',
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: isVerified ? Colors.green : null,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
