import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Uploads a file and returns the download URL
  Future<String> uploadReport({required File file, required String patientId}) async {
    final String ext = file.path.split('.').last;
    final ref = _storage.ref().child('reports/$patientId/${DateTime.now().millisecondsSinceEpoch}.$ext');
    final task = await ref.putFile(file);
    final url = await task.ref.getDownloadURL();
    return url;
  }
}
