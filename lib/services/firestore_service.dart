import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<DocumentReference> createPatientRecord({
    required String name,
    required int age,
    required String condition,
    required String fileUrl,
    required String createdByUid,
  }) {
    final data = {
      'name': name,
      'age': age,
      'condition': condition,
      'fileUrl': fileUrl,
      'createdBy': createdByUid,
      'createdAt': FieldValue.serverTimestamp(),
    };
    return _firestore.collection('patients').add(data);
  }
}
