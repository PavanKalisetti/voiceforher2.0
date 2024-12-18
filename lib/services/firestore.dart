import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService{
  // get collection of data
  final CollectionReference complaints = FirebaseFirestore.instance.collection("complaints");

  // create: add a new complain
  Future<void> addComplaint(String name, String hashedEmail,String Date, String Subject, String Description, String Category, String location, bool isAno, bool status){
    return complaints.add({
      'name': name,
      'hashedEmail': hashedEmail,
      'date': Date,
      'subject': Subject,
      'description': Description,
      'category': Category,
      'location': location,
      'isano': isAno,
      'timestamp': Timestamp.now(),
      'status': status,
    });
  }

  // READ: reading complain from firestore
  Stream<QuerySnapshot> getComplaintStream(){
    final complaintStream = complaints.orderBy("timestamp", descending: true).snapshots();
    
    return complaintStream;
  }

  // update:
  Future<void> updateComplaint(String docID, String name, String hashedEmail,String Date, String Subject, String Description, String Category, String location, bool isAno, bool status){
    return complaints.doc(docID).update({
      'name': name,
      'hashedEmail': hashedEmail,
      'date': Date,
      'subject': Subject,
      'description': Description,
      'category': Category,
      'location': location,
      'isano': isAno,
      'timestamp': Timestamp.now(),
      'status': status,
    });
  }

}