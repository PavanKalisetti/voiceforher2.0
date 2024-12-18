# Voice For Her App - Addressing Harassment Faced by Girl Students and working staff

## Project Overview
Voice for her is a mobile application designed to address harassment faced by girl students and working staff in universities. The app enables users to document and report harassment incidents, connect with peer support, and notify university authorities. It also offers an option to submit complaints anonymously for better privacy and security.

This project is aimed at providing a safer and more supportive environment for students by utilizing technology to handle harassment incidents in a structured and organized manner.

## Tech Stack
- **Frontend**: Flutter
- **Backend**: Firebase (Firestore, Authentication)
- **Authentication**: Firebase Authentication
- **Database**: Firebase Firestore
- **Hosting/Deployment**: Firebase Hosting for backend

## Key Features
- **Emergency Button**: Users can make direct call from the app for the trusted person with a single click
- **Safe Zone**: User can view the nearby Realtime Safest Zones in Gmaps
- **She Mate**: User can view the nearby Female Security Locations in Gmaps
- **Safe PathWays**: User can view the Safest Path in their journey(i.e most crowded path Routes) in Gmaps
- **Complaint Box**: Users can report harassment incidents by filling out a form with necessary details,
- **Raise Complaint**: This Feature Can only accessed by the Girl user and not by authority. it provides a form to raise a complaint and she can be anonymous on her will, while raising the complaint to authority
- **Chat Interation Between Authority and Girl User**: Realtime chat feature has been developed, to address the current complaint in detail with authority while staying anonymous.
- **Past Complaints**: Users can view the past complaints raised by them
- **Current Complaints**: Users can view the currently unsolved complaints raised by them, and also chat with authorities.
- **Incident Tracking**: Track the status of the filed complaints (both current and past complaints).
- **Awarness and Counselling**: Access resources for peer support and university authority contacts.
- **Anonymous Reporting**: Anonymity is guaranteed for users who wish to file complaints discreetly.
- **Emergency Contacts**: Users can add their trusted contacts in this page to send an alert msg or call when emergency button was clicked.
- **Maps**: Users can track their realtime locations using Gmaps
- **Mitra AI ChatBot**: In the case of loneliness, if she doesn't want to share her situation to any person, she can interact and share her condition/problems with out Mitra AI ChatBot.
- **Profile Page**: The Details of the user or Authority will be shown in this page

## Setup & Installation Instructions

### 1. Clone the repository
First, clone the repository to your local machine using Git:

### bash
``` git clone https://github.com/pavankalisetti/voiceforher.git ```

### 2. Install Flutter
If you don't have Flutter installed, follow the official installation guide here: Flutter Installation

### 3. Install Dependencies
Navigate to the project directory and run the following command to install the required dependencies:
``` flutter pub get ```

This will install all the dependencies listed in the ```pubspec.yaml``` file.


### 4. Running the App
   Run the app on your Android/iOS device or emulator:

### bash
```flutter run```
### 5. Building APK (for Android)
   To build the APK for Android, run:
   ```flutter build apk```
   You can then upload the APK file as required for the hackathon submission.

