import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String userId; // Unique user ID
  final String authorityId;

  final dynamic hashedemail; // Unique authority ID

  const ChatPage({
    required this.userId,
    required this.authorityId,
    required this.hashedemail,
    Key? key,
  }) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late String _chatDocumentId;

  @override
  void initState() {
    super.initState();
    // _chatDocumentId = '${widget.userId}_${widget.authorityId}'; // Create unique document ID
    _chatDocumentId = '${widget.hashedemail}';
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final message = {
      'senderId': widget.userId, // Replace with authorityId if the sender is authority
      'message': _messageController.text.trim(),
      'timestamp': DateTime.now().toIso8601String(), // Use DateTime for timestamp
    };

    final chatRef = _firestore.collection('chats').doc(_chatDocumentId);

    try {
      // Append the new message to the messages array
      await chatRef.set(
        {
          'messages': FieldValue.arrayUnion([message]), // Use DateTime value
        },
        SetOptions(merge: true), // Merge with existing data
      );

      _messageController.clear(); // Clear the input field
    } catch (e) {
      debugPrint('Error sending message: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat with Authority'),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Chat Messages Section
          Expanded(
            child: StreamBuilder<DocumentSnapshot>(
              stream: _firestore.collection('chats').doc(_chatDocumentId).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
                  return const Center(
                    child: Text('No messages yet. Start the conversation!'),
                  );
                }

                final messages = snapshot.data!['messages'] as List<dynamic>? ?? [];

                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isUserMessage = message['senderId'] == widget.userId;

                    return Align(
                      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isUserMessage
                              ? Colors.teal.shade100
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          message['message'] ?? '',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // Message Input Section
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _sendMessage,
                  icon: const Icon(Icons.send, color: Colors.teal),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
