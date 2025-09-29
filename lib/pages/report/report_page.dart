import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ReportPage extends StatelessWidget {
  final String pdfUrl;
  final String therapySuggestion;

  const ReportPage({
    super.key,
    required this.pdfUrl,
    required this.therapySuggestion,
  });

  // Download PDF using browser
  Future<void> _downloadPDF() async {
    final Uri uri = Uri.parse(pdfUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  // Share PDF URL
  void _sharePDF() {
    Share.share("Here is my therapy report: $pdfUrl");
  }

  @override
  Widget build(BuildContext context) {
    final bool isTablet = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.teal,
        title: const Text(
          "Your Report",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.download, color: Colors.white),
            onPressed: _downloadPDF,
            tooltip: "Download PDF",
          ),
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: _sharePDF,
            tooltip: "Share PDF",
          ),
        ],
      ),
      body: isTablet
          ? Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildPdfViewer(),
                ),
                Expanded(
                  flex: 1,
                  child: _buildTherapySuggestion(),
                ),
              ],
            )
          : Column(
              children: [
                Expanded(child: _buildPdfViewer()),
                _buildTherapySuggestion(),
              ],
            ),
    );
  }

  /// PDF Viewer Widget
  Widget _buildPdfViewer() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SfPdfViewer.network(pdfUrl),
      ),
    );
  }

  /// Therapy Suggestion Widget
  Widget _buildTherapySuggestion() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.teal, Colors.tealAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Therapy Suggestions",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            therapySuggestion,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.white,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}