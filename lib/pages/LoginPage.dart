import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:voiceforher/services/firestore.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  // firestore
  final FirestoreService firestoreService = FirestoreService();

  // text controller
  final TextEditingController textController = TextEditingController();

  //open a dialog box to add a compalint
  void openComplaintBox(String? docID){
    showDialog(context: context, builder: (context) => AlertDialog(
      // text user input
      content: TextField(
        controller: textController,
      ),
      actions: [
        // buttons to save
        ElevatedButton(
            onPressed: (){
              //adding note
              // if(docID == null){
              //    firestoreService.addComplaint("name", "20-20-2024","satish harassed me", "i was so low", "physical harassment ", "location", false, false);
              // }
              // else{
              //    firestoreService.updateComplaint(docID, "name", "20-20-2024","satish harassed me", "i was so low", "physical harassment ", "location", false, false);
              // }
              // // clear text controller
              // textController.clear();
              //
              // // close the box
              // Navigator.pop(context);
            },
            child: Text("Add"),
        ),
      ],
    )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Voice for her"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          // openComplaintBox();
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getComplaintStream(),
        builder: (context, snapshot) {
          //checking snapshot have data or not
          if (snapshot.hasData){
            List complaintList = snapshot.data!.docs;

            // displayList
            return ListView.builder(
              itemCount: complaintList.length,
                itemBuilder: (context, index){
                  // get each individual doc
                  DocumentSnapshot document  = complaintList[index];
                  String docID = document.id;

                  // get note from each doc
                  Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                  String complaintText = data['note'];

                  return ListTile(
                    title: Text(complaintText),
                    trailing: IconButton(
                      onPressed: (){
                          openComplaintBox(docID);
                      },
                      icon: const Icon(Icons.edit),
                    ),
                  );
                  //get note
                }
            );
          }

          else{
            return const Text("no notes...");
          }
        }
      ),
    );
  }
}
