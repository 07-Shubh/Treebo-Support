import 'package:flutter/material.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:google_fonts/google_fonts.dart';
import 'checkin_confirmation_screen.dart';

class SignatureScreen extends StatefulWidget {
  final Map<String, dynamic>? extractedData;
  
  const SignatureScreen({
    super.key,
    this.extractedData,
  });

  @override
  State<SignatureScreen> createState() => _SignatureScreenState();
}

class _SignatureScreenState extends State<SignatureScreen> {
  final GlobalKey<SignatureState> _signatureKey = GlobalKey<SignatureState>();
  bool _isSigned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guest Signature'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _isSigned
                ? () {
                    _signatureKey.currentState?.clear();
                    setState(() {
                      _isSigned = false;
                    });
                  }
                : null,
            child: Semantics(
              button: true,
              label: 'Clear signature',
              child: Text(
                'Clear',
                style: TextStyle(
                  color: _isSigned
                      ? Theme.of(context).colorScheme.error
                      : Colors.grey,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: RepaintBoundary(
                  key: _signatureKey,
                  child: Container(
                    color: Colors.white,
                    child: Signature(
                      onSign: () {
                        setState(() {
                          _isSigned = true;
                        });
                      },
                      strokeWidth: 3.0,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  'Sign above to confirm your check-in',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSigned ? _completeCheckIn : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white, // Text color
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Semantics(
                      button: true,
                      label: 'Complete check in',
                      child: Text(
                        'Complete Check-in',
                        style: GoogleFonts.poppins(
                          color: Colors.white, // Ensure text is white
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _completeCheckIn() async {
    if (!_isSigned) return;
    
    // Show loading indicator
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    
    try {
      // In a real app, you would save the signature here
      // final boundary = _signatureKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      // if (boundary != null) {
      //   final image = await boundary.toImage(pixelRatio: 3.0);
      //   final byteData = await image.toByteData(format: ImageByteFormat.png);
      //   await _saveSignature(byteData!);
      // }
      
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      if (!mounted) return;
      
      // Close loading dialog
      Navigator.of(context).pop();
      
      // Navigate to confirmation screen
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const CheckInConfirmationScreen(),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      // Close loading dialog if still mounted
      Navigator.of(context).pop();
      
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Check-in completed successfully'),
          backgroundColor: Colors.green,
        ),
      );
      
      // Still navigate to home even if signature capture fails
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const CheckInConfirmationScreen(),
        ),
      );
    }
  }
}
