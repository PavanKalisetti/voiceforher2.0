import 'package:geolocator/geolocator.dart';
import 'package:flutter_background_messenger/flutter_background_messenger.dart';

class SendSmsMessage {
    final messenger = FlutterBackgroundMessenger();

    Future<void> sendSMSWithLocation() async {
        try {
            // Check and enable location services if disabled
            Position position = await _determinePosition();

            // Format the message with the location in Google Maps URL format
            String message =
                'Emergency! I am at https://www.google.com/maps?q=${position.latitude},${position.longitude}.';

            // Send the SMS
            final success = await messenger.sendSMS(
                phoneNumber: '+918639829687',
                message: message,
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

    Future<Position> _determinePosition() async {
        bool serviceEnabled;
        LocationPermission permission;

        // Check if location services are enabled
        serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) {
            // Prompt the user to enable location services
            await Geolocator.openLocationSettings();
            serviceEnabled = await Geolocator.isLocationServiceEnabled();
            if (!serviceEnabled) {
                throw Exception('Location services are disabled.');
            }
        }

        // Check for location permissions
        permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
            permission = await Geolocator.requestPermission();
            if (permission == LocationPermission.denied) {
                throw Exception('Location permissions are denied.');
            }
        }

        if (permission == LocationPermission.deniedForever) {
            throw Exception(
                'Location permissions are permanently denied, we cannot request permissions.');
        }

        // Get the current location
        return await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
    }
}
