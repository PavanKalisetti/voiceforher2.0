import 'package:flutter_background_messenger/flutter_background_messenger.dart';

class SendSmsMessage {
    final messenger = FlutterBackgroundMessenger();

    Future<void> sendSMS() async {
        try {
            final success = await messenger.sendSMS(
            phoneNumber: '+918639829687',
            message: 'Hello from Flutter Background Messenger!',
            );

            if (success) {
                print('Debug testing SMS sent successfully');
            } else {
                print('Debug testing Failed to send SMS');
            }
        } catch (e) {
            print('Debug testing Error sending SMS: $e');
        }
    }
}