import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:ui';

class LoginPage extends StatefulWidget {
  final Function(bool) onLoginStateChanged;

  const LoginPage({super.key, required this.onLoginStateChanged});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();

  bool _otpSent = false;
  bool _isLoading = false;
  int _remainingTime = 0;
  Timer? _timer;

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Scaffold(
      // Completely transparent background
      backgroundColor: Colors.transparent,

      // Use body correctly (not child)
      body: Center(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              // Blur background slightly
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                child: Container(color: Colors.transparent),
              ),

              // Login container
              Center(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: isMobile ? screenWidth * 0.9 : 500,
                  ),
                  padding: EdgeInsets.zero,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    // Semi-transparent container
                    color: Colors.white.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header with X button
                      Padding(
                        padding: const EdgeInsets.only(right: 8, top: 8),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: Colors.black54,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ),

                      // Form content
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Logo and app name
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.spa,
                                    color: Color(0xFF4CAF50),
                                    size: 36,
                                  ),
                                  const SizedBox(width: 12),
                                  RichText(
                                    text: const TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Nutri',
                                          style: TextStyle(
                                            color: Color(0xFF4CAF50),
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(
                                          text: 'Plan AI',
                                          style: TextStyle(
                                            color: Color(0xFF2E7D32),
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 30),

                              // Title
                              Text(
                                _otpSent
                                    ? 'Verify OTP'
                                    : 'Login to Your Account',
                                style: TextStyle(
                                  fontSize: isMobile ? 20 : 24,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Colors
                                          .black87, // Darker text for contrast
                                ),
                              ),

                              const SizedBox(height: 8),

                              // Subtitle
                              Text(
                                _otpSent
                                    ? 'Enter the OTP sent to your mobile number'
                                    : 'Get started with your personalized nutrition journey',
                                style: TextStyle(
                                  fontSize: isMobile ? 14 : 16,
                                  color:
                                      Colors
                                          .black54, // Darker text for contrast
                                ),
                                textAlign: TextAlign.center,
                              ),

                              const SizedBox(height: 30),

                              // Phone number input
                              if (!_otpSent)
                                TextFormField(
                                  controller: _phoneController,
                                  decoration: InputDecoration(
                                    labelText: 'Phone Number',
                                    hintText: 'Enter your mobile number',
                                    prefixIcon: const Icon(Icons.phone),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    fillColor: Colors.white.withOpacity(
                                      0.9,
                                    ), // More opaque background for input
                                    filled: true,
                                  ),
                                  keyboardType: TextInputType.phone,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your phone number';
                                    }
                                    // Basic validation for phone number (10 digits)
                                    if (value.length != 10 ||
                                        int.tryParse(value) == null) {
                                      return 'Please enter a valid 10-digit phone number';
                                    }
                                    return null;
                                  },
                                ),

                              // OTP input
                              if (_otpSent) ...[
                                TextFormField(
                                  controller: _otpController,
                                  decoration: InputDecoration(
                                    labelText: 'OTP',
                                    hintText: 'Enter the 6-digit OTP',
                                    prefixIcon: const Icon(Icons.lock_outline),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    fillColor: Colors.white.withOpacity(
                                      0.9,
                                    ), // More opaque background for input
                                    filled: true,
                                  ),
                                  keyboardType: TextInputType.number,
                                  maxLength: 6,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter the OTP';
                                    }
                                    if (value.length != 6 ||
                                        int.tryParse(value) == null) {
                                      return 'Please enter a valid 6-digit OTP';
                                    }
                                    return null;
                                  },
                                ),

                                // Timer text
                                if (_remainingTime > 0)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(
                                      'Resend OTP in $_remainingTime seconds',
                                      style: const TextStyle(
                                        color: Colors.black54,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),

                                // Resend button
                                if (_remainingTime == 0)
                                  TextButton(
                                    onPressed: _requestOTP,
                                    child: const Text('Resend OTP'),
                                  ),
                              ],

                              const SizedBox(height: 30),

                              // Action Button (Request OTP or Verify OTP)
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed:
                                      _isLoading
                                          ? null
                                          : (_otpSent
                                              ? _verifyOTP
                                              : _requestOTP),
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child:
                                      _isLoading
                                          ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            ),
                                          )
                                          : Text(
                                            _otpSent
                                                ? 'Verify & Login'
                                                : 'Request OTP',
                                            style: const TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                ),
                              ),

                              const SizedBox(height: 20),

                              // Back button when in OTP view
                              if (_otpSent)
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _otpSent = false;
                                      _otpController.clear();
                                      _timer?.cancel();
                                      _remainingTime = 0;
                                    });
                                  },
                                  child: const Text('Back to Phone Number'),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Request OTP method
  void _requestOTP() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API call with a delay
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
        _otpSent = true;
        _startResendTimer();
      });

      // Show snackbar message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('OTP sent to ${_phoneController.text}'),
          backgroundColor: const Color(0xFF4CAF50),
        ),
      );
    });
  }

  // Verify OTP method
  void _verifyOTP() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API call with a delay
    Future.delayed(const Duration(seconds: 2), () {
      // For demo, consider any 6-digit OTP as valid
      // In a real app, this would validate against a backend
      setState(() {
        _isLoading = false;
      });

      // Set the login state to true and notify parent
      widget.onLoginStateChanged(true);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login successful!'),
          backgroundColor: Color(0xFF4CAF50),
        ),
      );
    });
  }

  // Start timer for OTP resend
  void _startResendTimer() {
    _remainingTime = 30; // 30 seconds cooldown

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _timer?.cancel();
        }
      });
    });
  }
}
