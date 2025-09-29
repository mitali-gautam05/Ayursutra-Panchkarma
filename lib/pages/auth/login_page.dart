import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

enum AuthMode { login, signUp }
enum UserType { patient, doctor }

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  File? _pickedFile;
  bool _isLoading = false;
  String? _errorMessage;
  AuthMode _authMode = AuthMode.login;
  UserType _userType = UserType.patient; 

  // ------------------------------------------------------------------
  // CORE FUNCTIONS
  // ------------------------------------------------------------------

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _pickedFile = File(result.files.single.path!);
      });
    }
  }

  void _submitAuthForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final isLogin = _authMode == AuthMode.login;
    final actionName = isLogin ? "Login" : "Sign Up";
    
    // --- BASIC VALIDATION (SIMULATED) ---
    if (_userType == UserType.doctor) {
        if (_emailController.text != 'doctor@ayusutra.com') {
             setState(() {
                 _errorMessage = "Doctor login/signup requires 'doctor@ayusutra.com' for simulation.";
                 _isLoading = false;
             });
             return;
        }
        if (_authMode == AuthMode.signUp && _pickedFile == null) {
             setState(() {
                 _errorMessage = "Doctors must upload a credential file during Sign Up.";
                 _isLoading = false;
             });
             return;
        }
    }

    await Future.delayed(const Duration(seconds: 1)); 

    setState(() {
      _isLoading = false;
    });

    if (!mounted) return;
    
    String route = _userType == UserType.doctor ? '/doctor' : '/form';
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Successful $actionName as ${_userType.name}!')),
    );
    Navigator.pushReplacementNamed(context, route);
  }

  void _toggleMode() {
    setState(() {
      _authMode = _authMode == AuthMode.login ? AuthMode.signUp : AuthMode.login;
      _errorMessage = null;
      _pickedFile = null; 
    });
  }

  // ------------------------------------------------------------------
  // UI BUILD
  // ------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final isLogin = _authMode == AuthMode.login;
    final isDoctor = _userType == UserType.doctor;
    final buttonText = isLogin ? "LOGIN" : "SIGN UP";

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade50, Colors.green.shade50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            
            // ⭐ FIX for Smaller Box: Constrains the width of the login form
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 400, // Sets the maximum width for the Card
              ),
              child: Form(
                key: _formKey,
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 1. Logo and App Name
                        Image.asset(
                          // 🚨 CRITICAL PATH FIX: Ensure this path is 100% correct
                          'assets/images/ayursutra logo.png', 
                          height: 80,
                          width: 80,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.error_outline, size: 80, color: Colors.red);
                          },
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'AYURSTURA', // Display name from your image
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: Colors.teal.shade700,
                          ),
                        ),
                        const SizedBox(height: 30),

                        // 2. User Type Selector (Segmented Control)
                        _buildUserTypeSelector(),
                        const SizedBox(height: 20),

                        // 3. Email Field
                        TextFormField(
                          controller: _emailController,
                          decoration: _inputDecoration("Email Address", Icons.email),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || !value.contains('@')) {
                              return 'Enter a valid email address.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // 4. Password Field
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: _inputDecoration("Password", Icons.lock),
                          validator: (value) {
                            if (value == null || value.length < 6) {
                              return 'Password must be at least 6 characters.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        // 5. File Picker (Only visible for Doctor Sign Up)
                        if (!isLogin && isDoctor) ...[
                          _buildFilePickerSection(),
                          const SizedBox(height: 20),
                        ],
                        
                        // 6. Error Message
                        if (_errorMessage != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Text(
                              _errorMessage!,
                              style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),

                        // 7. Submit Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _submitAuthForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    width: 20, height: 20, 
                                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                  )
                                : Text(
                                    buttonText,
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // 8. Toggle Mode Button
                        TextButton(
                          onPressed: _toggleMode,
                          child: Text(
                            isLogin ? "Don’t have an account? Sign Up" : "Already have an account? Login",
                            style: TextStyle(color: Colors.teal.shade600, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------------
  // HELPER WIDGETS
  // ------------------------------------------------------------------

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.teal),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      filled: true,
      fillColor: Colors.teal.withOpacity(0.05),
    );
  }

  Widget _buildUserTypeSelector() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.teal.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ToggleButtons(
        isSelected: [_userType == UserType.patient, _userType == UserType.doctor],
        onPressed: (index) {
          setState(() {
            _userType = index == 0 ? UserType.patient : UserType.doctor;
            _errorMessage = null;
            _pickedFile = null;
          });
        },
        borderRadius: BorderRadius.circular(10),
        selectedColor: Colors.white,
        fillColor: Colors.teal,
        color: Colors.teal.shade800,
        borderColor: Colors.transparent,
        selectedBorderColor: Colors.transparent,
        children: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              children: [
                Icon(Icons.people_alt, size: 20),
                SizedBox(width: 8),
                Text('Patient'),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              children: [
                Icon(Icons.local_hospital, size: 20),
                SizedBox(width: 8),
                Text('Doctor'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilePickerSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Doctor's License/ID (Required for Sign Up):",
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Text(
                _pickedFile != null
                    ? 'File: ${_pickedFile!.path.split('/').last}'
                    : 'No file selected',
                style: TextStyle(
                  color: _pickedFile != null ? Colors.teal : Colors.grey.shade600,
                  fontStyle: FontStyle.italic,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton.icon(
              onPressed: _pickFile,
              icon: const Icon(Icons.upload_file, size: 18, color: Colors.white),
              label: const Text("Choose File", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal.shade400,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}