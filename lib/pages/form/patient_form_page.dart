import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p; // <-- Alias used to resolve name conflict
import 'dart:convert';
// import 'admin_dashboard.dart';


// Import url_launcher if you want to make the PDF link clickable
// import 'package:url_launcher/url_launcher.dart';

// Import Firebase Auth for authentication
// import 'package:firebase_auth/firebase_auth.dart';

class PatientFormPage extends StatefulWidget {
  final String? idToken; // received from login

  const PatientFormPage({super.key, this.idToken});

  @override
  State<PatientFormPage> createState() => _PatientFormPageState();
}

class PatientData {
  final String name;
  final String age;
  final String condition;
  final String? filePath;

  PatientData({
    required this.name,
    required this.age,
    required this.condition,
    this.filePath,
  });
}


class _PatientFormPageState extends State<PatientFormPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _conditionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  File? _pickedFile;
  bool _isLoading = false;
  String? _errorMessage;
  String? _pdfUrl;
  String? _therapySuggestion;

  // --- UI Styling Constants ---
  static const Color primaryColor = Color(0xFF00897B); // Teal 600
  static const Color accentColor = Color(0xFF4DB6AC); // Teal 300
  static const double borderRadius = 12.0;

  // Pick file from device
  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _pickedFile = File(result.files.single.path!);
      });
    }
  }


  // Submit form to backend
  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      setState(() {
        _errorMessage = "Please fill in all required fields correctly.";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _pdfUrl = null;
      _therapySuggestion = null;
    });

    try {
      //  IMPORTANT: Replace with your actual backend URL
      var uri = Uri.parse("http://10.142.156.216:8000/patient/submit");

      var request = http.MultipartRequest('POST', uri)
        ..fields['name'] = _nameController.text
        ..fields['age'] = _ageController.text
        ..fields['condition'] = _conditionController.text
        ..headers['Authorization'] = 'Bearer ${widget.idToken}';

      
      // Only attach the file if one was selected
      if (_pickedFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'report', _pickedFile!.path,
            filename: p.basename(_pickedFile!.path))); // <-- FIX 1: Using p.basename
      }
      
      var response = await request.send();
      var responseData = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(responseData.body);

        setState(() {
          _pdfUrl = jsonResponse['pdf_report_link'] ?? "Not provided";
          _therapySuggestion =
              jsonResponse['ai_suggestion'] ?? "No suggestion received from AI/System.";
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Form submitted successfully!')),
          );
        });
      } else {
        setState(() {
          try {
  var errorBody = json.decode(responseData.body);
  if (errorBody['detail'] != null) {
    _errorMessage = "Submission Failed: ${errorBody['detail']}";
  } else if (errorBody['message'] != null) {
    _errorMessage = "Submission Failed: ${errorBody['message']}";
  }
} catch (_) {
  _errorMessage = "Failed to submit form: ${response.reasonPhrase ?? 'Unknown error'}";
}

              // "Failed to submit form: ${response.reasonPhrase ?? 'Error'}";
//               try {
//   var errorBody = json.decode(responseData.body);
//   if (errorBody['detail'] != null) {
//     _errorMessage = "Submission Failed: ${errorBody['detail']}";
//   }
// } catch (_) {}

//           // Attempt to read error message from body if available
//           try {
//             var errorBody = json.decode(responseData.body);
//             if (errorBody.containsKey('message')) {
//                 _errorMessage = "Submission Failed: ${errorBody['message']}";
//             }
//           } catch (_) {
//              // ignore
//           }
             
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Error submitting form: $e";
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
  
  // // Function to launch PDF URL (requires url_launcher package)
  // Future<void> _launchUrl(String url) async {
  //   final uri = Uri.parse(url);
  //   if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
  //     // ignore: avoid_print
  //     print('Could not launch $url');
  //   }
  // }


  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _conditionController.dispose();
    super.dispose();
  }

  // --- HELPER WIDGETS AND DECORATION ---

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: primaryColor.withOpacity(0.8)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: accentColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: BorderSide(color: accentColor.withOpacity(0.5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: const BorderSide(color: primaryColor, width: 2.0),
      ),
      filled: true,
      fillColor: Colors.white,
      labelStyle: const TextStyle(color: primaryColor),
    );
  }


  Widget _buildFilePicker() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: accentColor.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Upload Report (Optional)",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  _pickedFile != null
                      ? 'File: ${p.basename(_pickedFile!.path)}' // <-- FIX 2: Using p.basename
                      : "No file chosen. Submit without a report.",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: _pickedFile != null ? primaryColor : Colors.grey.shade600,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton.icon(
                onPressed: _pickFile,
                icon: const Icon(Icons.upload_file, size: 20),
                label: const Text("Select File"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: accentColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResultSection() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(top: 20),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Analysis Results",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const Divider(color: accentColor),
            
            // PDF URL Link (or selectable text)
            Text(
              "PDF Report Link:",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            // Use InkWell/GestureDetector if you integrate url_launcher
            SelectableText(
              _pdfUrl ?? "Not provided", 
              style: TextStyle(color: _pdfUrl != "Not provided" ? Colors.blue.shade700 : Colors.grey.shade700, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 16),
            
            // Therapy Suggestion
            Text(
              "AI Therapy Suggestion:",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(_therapySuggestion ?? "No Suggestion available"),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Patient Data Submission",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        // Subtle background gradient for professionalism
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.teal.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600), // Max width for tablet/desktop views
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Patient Details",
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Divider(color: accentColor, thickness: 1.5, height: 30),

                    // Name Field
                    TextFormField(
                      controller: _nameController,
                      decoration: _inputDecoration("Name", Icons.person),
                      validator: (value) => value!.isEmpty ? 'Name is required' : null,
                    ),
                    const SizedBox(height: 16),

                    // Age Field
                    TextFormField(
                      controller: _ageController,
                      keyboardType: TextInputType.number,
                      decoration: _inputDecoration("Age", Icons.calendar_today),
                      validator: (value) {
                        if (value!.isEmpty) return 'Age is required';
                        if (int.tryParse(value) == null) return 'Must be a valid number';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Condition Field
                    TextFormField(
                      controller: _conditionController,
                      decoration: _inputDecoration("Condition / Symptoms", Icons.sick),
                      maxLines: 3,
                      validator: (value) => value!.isEmpty ? 'Symptoms description is required' : null,
                    ),
                    const SizedBox(height: 24),

                    // File Picker Section (Optional)
                    _buildFilePicker(),
                    const SizedBox(height: 24),

                    // Error Message
                    if (_errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      
                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: _isLoading ? null : _submitForm,
                        icon: _isLoading 
                          ? const SizedBox.shrink() 
                          : const Icon(Icons.send, color: Colors.white),
                        label: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                "Submit Data",
                                style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(borderRadius),
                          ),
                          disabledBackgroundColor: accentColor.withOpacity(0.5),
                        ),
                      ),
                    ),
                    
                    // Results Section
                    if (_pdfUrl != null || _therapySuggestion != null)
                      _buildResultSection(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}