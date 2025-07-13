# HackatonAdapta - AI Traffic Violation Detection App

![Swift](https://img.shields.io/badge/Swift-5.0-orange.svg)
![iOS](https://img.shields.io/badge/iOS-15.0+-blue.svg)
![Firebase](https://img.shields.io/badge/Firebase-11.15.0-yellow.svg)

## 📋 Overview

HackatonAdapta is an iOS application developed for a hackathon that leverages AI to help with traffic violation detection and reporting. The app allows users to record videos of traffic incidents, automatically processes them with AI to detect possible violations, and stores the data for review by traffic authorities.

## ✨ Key Features

- **📹 Video Recording**: Capture traffic incidents with built-in camera functionality
- **📍 GPS Location**: Automatic location tracking for incident reporting
- **🤖 AI Analysis**: Integration with AI backend for traffic violation detection
- **📊 Incident Management**: View and track submitted traffic violations
- **☁️ Cloud Storage**: Video storage using Firebase Storage
- **🗄️ Data Management**: Incident data stored in Firestore database

## 🏗️ Architecture

The app follows the MVVM (Model-View-ViewModel) pattern with SwiftUI and integrates with:

- **Firebase Firestore**: For storing incident reports and metadata
- **Firebase Storage**: For video file storage
- **AI Backend API**: For processing videos and detecting violations
- **Core Location**: For GPS coordinates
- **AVFoundation**: For camera and video recording

## 📱 App Structure

### Main Components

1. **MainTabView**: Tab-based navigation with three main sections:
   - Infractions list
   - Camera recording
   - Chat (under development)

2. **Video Recording System**:
   - Real-time camera preview
   - Recording controls with visual feedback
   - Flash toggle functionality
   - Automatic location capture

3. **Data Models**:
   - `Envio`: Represents a submitted incident report
   - `Infracao`: Contains violation details and legal references
   - `ReferenciaArtigo`: Legal article references with confidence scores

### Key Views

- **VideoCaptureView**: Main camera interface for recording incidents
- **InfractionView**: Displays list of submitted violations
- **EnvioCard**: Individual incident card with location and status

## 🚀 Getting Started

### Prerequisites

- **Xcode 15.0+**
- **iOS 15.0+** target device or simulator
- **macOS 12.0+** for development
- **Firebase account** for backend services
- **AI Backend API** running (see Backend Setup section)

### Installation

1. **Clone the repository**:
   ```bash
   git clone <repository-url>
   cd Security
   ```

2. **Open the project**:
   ```bash
   open HackatonAdapta.xcodeproj
   ```

3. **Install dependencies**:
   - The project uses Swift Package Manager
   - Dependencies should resolve automatically when you open the project
   - Main dependencies include Firebase SDK (v11.15.0)

4. **Configure Firebase**:
   - Add your `GoogleService-Info.plist` file to the project
   - Replace the existing file in the project root
   - Ensure Firebase is properly configured in your Firebase Console

5. **Update Bundle Identifier**:
   - Change the bundle identifier from `puc.HackatonAdapta` to your own
   - Update in both the project settings and Firebase configuration

### Backend Setup

The app communicates with an AI backend API for video analysis. Update the API endpoint in `VideoRecorder.swift`:

```swift
// Line ~125 in VideoRecorder.swift
guard let url = URL(string: "http://YOUR_API_SERVER:5000/exemplo") else {
    print("URL inválida")
    return
}
```

Replace `YOUR_API_SERVER` with your actual backend server address.

### Firebase Configuration

1. **Create a Firebase project** at [Firebase Console](https://console.firebase.google.com/)

2. **Enable required services**:
   - **Firestore Database**: For storing incident reports
   - **Storage**: For video file storage
   - **Authentication** (optional): For user management

3. **Set up Firestore collections**:
   - `Envios`: For incident submissions
   - `Infracoes`: For processed violations

4. **Configure Storage rules** for video uploads

## 🔧 Configuration

### Camera Permissions

Add these permissions to your `Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>This app needs camera access to record traffic incidents</string>
<key>NSMicrophoneUsageDescription</key>
<string>This app needs microphone access to record audio with incidents</string>
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs location access to tag incident locations</string>
<key>NSPhotoLibraryAddUsageDescription</key>
<string>This app needs photo library access to save recorded videos</string>
```

### Build Settings

- **Deployment Target**: iOS 15.0
- **Swift Version**: 5.0
- **Bundle Identifier**: `puc.HackatonAdapta` (change this)

## 📊 Data Flow

1. **User records video** → Video saved locally and to Photos
2. **Location captured** → GPS coordinates obtained
3. **Video uploaded** → Firebase Storage
4. **Data sent to AI API** → Video URL + metadata for analysis
5. **Results stored** → Firestore database with violation details
6. **User views results** → InfractionView displays processed incidents

## 🔮 AI Integration

The app sends video data to an AI backend that:

- Analyzes traffic behavior in videos
- Detects possible violations (running red lights, illegal parking, etc.)
- Identifies vehicle information (color, model, license plate)
- Returns legal references and confidence scores
- Provides structured violation data

Expected AI API response format:
```json
{
  "Comportamento observado": "Vehicle ran red light",
  "Cor": "Blue",
  "Modelo": "Sedan",
  "Placa": "ABC-1234",
  "Possível infração": "Traffic signal violation",
  "law_references": [
    {
      "law_reference": "Art. 208 CTB",
      "score": 0.95,
      "ticket": "Advancing red signal"
    }
  ]
}
```

## 🧪 Testing

The project includes:

- **Unit Tests**: `HackatonAdaptaTests.swift`
- **UI Tests**: `HackatonAdaptaUITests.swift`

Run tests using:
```bash
# Unit tests
cmd+U in Xcode

# Or via command line
xcodebuild test -scheme HackatonAdapta -destination 'platform=iOS Simulator,name=iPhone 15'
```

## 🚧 Known Issues & TODOs

- **Chat functionality**: Currently under development
- **User authentication**: Uses hardcoded demo user ID
- **Error handling**: Could be improved for network failures
- **Video compression**: Large video files may impact performance
- **Offline mode**: No offline capabilities currently

## 🤝 Contributing

This is a hackathon project. For contributions:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📝 License

This project was created for a hackathon. Please check with the original authors for licensing terms.

## 👥 Team

Developed by Hannah Goldstein and team for the Hackathon Adapta.

## 📞 Support

For questions about this hackathon project, please reach out to the development team or create an issue in the repository.

---

**Note**: This is a hackathon prototype. For production use, additional security measures, error handling, and code optimization would be required.
