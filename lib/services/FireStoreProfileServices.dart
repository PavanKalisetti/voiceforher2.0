import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreProfileService{
  // get collection of data
  final CollectionReference complaints = FirebaseFirestore.instance.collection("profiles");

  // create: add a new complain
  Future<void> addProfile(String name, String email, String hashedEmail, String password, String? education, String mobile, String role,String? address, bool isAuthority){
    return complaints.add({
      'name': name,
      'email': email,
      'hashedEmail': hashedEmail,
      'password': password,
      'education': education,
      'mobile': mobile,
      'role': role,
      'isAuthority': isAuthority,
      'address': address,
      'timestamp': Timestamp.now(),
    });
  }

  // READ: reading complain from firestore
  Stream<QuerySnapshot> getProfileStream(){
    final complaintStream = complaints.orderBy("timestamp", descending: true).snapshots();
    return complaintStream;
  }

  // update:
  Future<void> updateProfile(String docID, String name, String email, String hashedEmail, String password, String? education, String mobile, String role,String? address, bool isAuthority){
    return complaints.doc(docID).update({
      'name': name,
      'email': email,
      'hashedEmail': hashedEmail,
      'password': password,
      'education': education,
      'mobile': mobile,
      'role': role,
      'isAuthority': isAuthority,
      'address': address,
      'timestamp': Timestamp.now(),
    });
  }

}