
<div align="center">

# SkinSync
### Sync Your Routine. Transform Your Skin.

**AI-Assisted Personalized Skincare Mobile Application**

A third-year Computer Science and Engineering project developed to help users understand their skin, build personalized skincare routines, discover skincare products, and monitor their skincare journey.

![Flutter](https://img.shields.io/badge/Flutter-Mobile_App-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-Programming_Language-0175C2?logo=dart)
![Node.js](https://img.shields.io/badge/Node.js-Backend-339933?logo=node.js)
![Express.js](https://img.shields.io/badge/Express.js-REST_API-000000?logo=express)
![MongoDB](https://img.shields.io/badge/MongoDB-Database-47A248?logo=mongodb)
![Project](https://img.shields.io/badge/Project-3rd_Year_Defense-blue)

</div>

---

## 📌 Project Overview

**SkinSync** is a personalized skincare mobile application developed as a third-year Computer Science and Engineering project.

The application aims to simplify skincare management by combining skin assessment, AI-assisted facial image analysis, personalized skincare routines, product recommendations, ingredient education, reminders, and progress tracking into one platform.

Users can capture or upload facial photographs, complete a skincare questionnaire, receive skincare-related insights, and organize their daily skincare activities.

SkinSync is designed to encourage consistent skincare habits and help users monitor their skincare journey over time.

### 🎯 Project Objectives

- Develop a cross-platform skincare application using Flutter.
- Help users assess and manage their skincare needs.
- Implement AI-assisted analysis of supported visible skin characteristics.
- Generate personalized morning and evening skincare routines.
- Provide skincare product and ingredient information.
- Encourage consistent skincare habits through reminders.
- Enable progress-photo tracking and skincare journaling.
- Apply software engineering, database management, and backend development principles.

---

## 🚀 Live Demo

<img width="2220" height="1180" alt="SkinSync – User Interaction Design" src="https://github.com/user-attachments/assets/aba63f50-bd64-4091-9da1-92bc84860d99" />

---

## ✨ Key Features

### 1. User Registration and Authentication

Users can create an account, log in, and access their personal skincare information.

The authentication system protects user accounts and restricts access to private application features.

### 2. Facial Photo Capture and Upload

Users can capture a facial photograph using their device camera or upload an existing photograph from their gallery.

The application validates the selected image before sending it for analysis.

### 3. AI-Assisted Skin Analysis

SkinSync integrates an AI-assisted image-analysis service to identify supported visible skin characteristics.

Depending on the capabilities of the selected analysis service, the application may provide skincare-related insights concerning visible blemishes, redness, dark spots, dryness-related appearance, and other supported characteristics.

The analysis is intended for general skincare information, not medical diagnosis.

### 4. Skin Assessment Questionnaire

Users complete a questionnaire covering skin type, skincare concerns, sensitivity, habits, and preferences.

The questionnaire provides additional information that can support personalized skincare recommendations.

### 5. Personalized Skin Profile

The application combines available questionnaire responses and supported analysis results to generate a skin profile.

The profile may include skin type, reported concerns, skincare preferences, and previous assessment records.

### 6. Personalized Morning Routine

SkinSync provides an organized morning skincare routine based on the user's profile and preferences.

Users can review skincare steps, access relevant product information, and mark activities as completed.

### 7. Personalized Evening Routine

The application provides an evening skincare routine to help users maintain consistent skincare habits.

Users can review recommended steps and track their daily routine completion.

### 8. Skincare Product Recommendations

Users can discover skincare products relevant to their skincare profile.

Product information may include product name, brand, category, ingredients, general purpose, and usage instructions.

### 9. Ingredient Search and Education

Users can search for skincare ingredients and explore their general functions, benefits, and common uses.

This feature helps users understand the ingredients found in skincare products.

### 10. Favorites

Users can save products and other supported skincare resources to a favorites list for convenient access.

### 11. Skincare Reminders

Users can configure reminders for morning and evening skincare activities.

Reminder preferences can be managed according to the application's supported notification functionality.

### 12. Progress Photo Tracking

Users can upload photographs to document their skincare journey.

Photographs can be organized by date and reviewed over time. Where supported, users can compare earlier and more recent photographs.

### 13. Skincare Journal

Users can record personal observations about their skin, products, routines, and skincare experiences.

Journal entries help users maintain a history of their skincare activities.

### 14. Skincare History

SkinSync stores relevant assessment results, routine records, journal entries, and progress photographs.

Users can review their previous skincare activities and assessments.

### 15. Educational Resources

Users can access skincare-related educational content to learn about skincare practices, products, and ingredients.

### 16. Administrative Management

Authorized administrators may manage skincare products, ingredient information, educational content, and predefined routines.

Administrative features depend on the final implementation.

---

## 🛠️ Technologies Used

### Frontend

- Flutter
- Dart
- Android Studio
- Visual Studio Code

### Backend

- Node.js
- Express.js
- MongoDB
- JWT Authentication
- Cloudinary
- AI Image Analysis Service

### Development Tools

- Git
- GitHub
- Postman
- Figma

> **Note:** This technology stack follows the previously prepared SkinSync architecture diagram. Confirm that it matches the technologies used in your final implementation.

---

## 🏗️ System Architecture

SkinSync follows a client-server architecture.

The Flutter mobile application communicates with the Node.js and Express.js backend through RESTful APIs over HTTPS.

The backend manages authentication, application logic, database operations, and communication with the AI analysis service and image-storage platform.

### Architecture Components

| Component | Technology | Responsibility |
|---|---|---|
| Mobile Application | Flutter | User interface and mobile functionality |
| Backend Server | Node.js, Express.js | API endpoints and application logic |
| Database | MongoDB | Persistent application data |
| Authentication | JWT | Authenticated access to protected resources |
| Image Storage | Cloudinary | Storage and management of photographs |
| AI Analysis | AI Analysis Service | Processing supported facial image characteristics |

### Complete Architecture Diagram

<img width="1800" height="2280" alt="Frame" src="https://github.com/user-attachments/assets/0a23b763-1b33-4f36-8feb-3f96804e7f4f" />

The architecture diagram illustrates:

- Overall system architecture.
- Flutter mobile application.
- Backend server and REST API.
- Database and image-storage services.
- AI image-analysis workflow.
- Registration and login process.
- Personalized recommendation generation.
- Data storage structure.
- Component communication.

### Simplified Architecture

```text
                   ┌──────────────────────┐
                   │         User         │
                   └──────────┬───────────┘
                              │
                              ▼
                   ┌──────────────────────┐
                   │    Flutter Mobile    │
                   │      Application     │
                   └──────────┬───────────┘
                              │
                         HTTPS / REST
                              │
                              ▼
                   ┌──────────────────────┐
                   │   Node.js + Express  │
                   │      Backend API     │
                   └──────┬─────┬─────────┘
                          │     │
                 ┌────────┘     └─────────┐
                 ▼                        ▼
        ┌─────────────────┐      ┌─────────────────┐
        │     MongoDB     │      │  AI Analysis    │
        │    Database     │      │    Service      │
        └─────────────────┘      └────────┬────────┘
                                          │
                                          ▼
                                 ┌─────────────────┐
                                 │    Cloudinary   │
                                 │  Image Storage  │
                                 └─────────────────┘
```

---

## 🎨 User Interface Design

SkinSync is designed with a simple, intuitive, and visually consistent interface.

The application organizes skincare information into clear sections and provides straightforward navigation between assessment, analysis, routines, products, and progress tracking.

### UI and User Interaction Diagram

![SkinSync User Interface and Interaction Design](docs/images/ui-user-interaction-diagram.png)

**Diagram file:** `docs/images/ui-user-interaction-diagram.png`

The UI design diagram illustrates the application's screens, navigation, and major user interactions.

### Main Application Screens

1. Welcome Screen
2. Registration Screen
3. Login Screen
4. Home Dashboard
5. Skin Assessment Screen
6. Photo Capture and Upload Screen
7. AI Skin Analysis Results Screen
8. Skin Profile Screen
9. Morning Routine Screen
10. Evening Routine Screen
11. Product Browsing Screen
12. Product Details Screen
13. Ingredient Information Screen
14. Favorites Screen
15. Reminder Settings Screen
16. Progress Photo Gallery
17. Skincare Journal
18. Skincare History
19. User Profile and Settings

The final screen list should match the UI designs and features implemented in the application.

---

## 🔄 Application Workflow

The primary SkinSync workflow begins with user registration and a skincare assessment.

The user can then capture or upload a facial photograph for supported AI-assisted analysis.

The application combines available analysis results with questionnaire information to generate a skin profile and personalized recommendations.

```text
          User Registration / Login
                    |
                    ▼
          Complete Skin Assessment
                    |
                    ▼
          Capture or Upload Photo
                    |
                    ▼
              Image Validation
                    |
                    ▼
          AI-Assisted Skin Analysis
                    |
                    ▼
            Generate Skin Profile
                    |
                    ▼
       Personalized Recommendations
                    |
           ┌────────┴────────┐
           ▼                 ▼
     Morning Routine   Evening Routine
           │                 │
           └────────┬────────┘
                    ▼
       Follow Routine and Reminders
                    |
                    ▼
        Record Skincare Activities
                    |
                    ▼
          Upload Progress Photos
                    |
                    ▼
        Monitor Skincare Journey
```

---

## 📂 Project Structure

The following is a suggested repository structure. Update it to match your actual implementation.

```text
SkinSync/
│
├── README.md
│
├── docs/
│   ├── images/
│   │   ├── architecture-diagram.png
│   │   └── ui-user-interaction-diagram.png
│   │
│   └── project-documentation/
│
├── frontend/
│   └── skinsync_flutter/
│       ├── lib/
│       │   ├── main.dart
│       │   ├── models/
│       │   ├── screens/
│       │   ├── widgets/
│       │   ├── services/
│       │   └── providers/
│       │
│       ├── assets/
│       ├── test/
│       └── pubspec.yaml
│
├── backend/
│   ├── src/
│   │   ├── controllers/
│   │   ├── routes/
│   │   ├── models/
│   │   ├── middleware/
│   │   ├── services/
│   │   └── config/
│   │
│   ├── server.js
│   ├── package.json
│   └── .env.example
│
└── .gitignore
```

---

## ⚙️ Installation and Setup

### Prerequisites

Install the following software:

- Flutter SDK
- Dart SDK
- Android Studio or Visual Studio Code
- Node.js and npm
- MongoDB or an accessible MongoDB deployment
- Cloudinary account
- Credentials for the selected AI analysis service, if required

### 1. Clone the Repository

```bash
git clone https://github.com/YOUR_USERNAME/SkinSync.git

cd SkinSync
```

Replace `YOUR_USERNAME` with the GitHub username or organization hosting the repository.

### 2. Configure the Backend

Navigate to the backend directory:

```bash
cd backend
```

Install dependencies:

```bash
npm install
```

Create a local environment file from the example:

```bash
cp .env.example .env
```

Configure the required environment variables:

```env
PORT=5000

MONGODB_URI=YOUR_MONGODB_CONNECTION_STRING

JWT_SECRET=YOUR_SECURE_JWT_SECRET

CLOUDINARY_CLOUD_NAME=YOUR_CLOUDINARY_CLOUD_NAME
CLOUDINARY_API_KEY=YOUR_CLOUDINARY_API_KEY
CLOUDINARY_API_SECRET=YOUR_CLOUDINARY_API_SECRET

AI_API_KEY=YOUR_AI_SERVICE_API_KEY
```

The exact variables depend on your backend and AI service implementation.

**Never commit your actual `.env` file, passwords, API keys, or private credentials to GitHub.**

Start the backend:

```bash
npm run dev
```

If the development script is not configured, add the appropriate command to `package.json`.

### 3. Configure the Flutter Application

Open a new terminal and navigate to the Flutter project:

```bash
cd frontend/skinsync_flutter
```

Install Flutter dependencies:

```bash
flutter pub get
```

Configure the backend API URL in the appropriate application configuration file.

For example:

```dart
const String apiBaseUrl = "YOUR_BACKEND_API_URL";
```

Use the correct development URL for your emulator or physical device.

### 4. Run the Application

Check available devices:

```bash
flutter devices
```

Run SkinSync:

```bash
flutter run
```

The application should launch on the selected Android device or emulator once the backend and required services are configured.

---

## 🧪 Testing

Testing should verify that the application's major features operate correctly.

### Functional Testing

Test:

- User registration and login.
- Authentication and protected routes.
- Skin assessment submission.
- Facial photo upload.
- Image validation.
- AI-analysis request and response handling.
- Skin profile generation.
- Personalized routine display.
- Product search and recommendations.
- Favorites management.
- Reminder functionality.
- Progress photo upload and retrieval.
- Journal entry creation and retrieval.

### API Testing

Use Postman or an equivalent tool to verify:

- API requests return expected responses.
- Invalid inputs are handled correctly.
- Unauthorized requests are rejected.
- Database operations behave as expected.
- Errors are handled without exposing sensitive information.

### UI Testing

Verify:

- Screens display correctly.
- Navigation works as intended.
- Forms validate user input.
- Loading and error states are understandable.
- The application works on supported screen sizes.

---

## 🔐 Privacy and Security

SkinSync may process personal information, skincare records, and facial photographs.

The application should apply appropriate security and privacy practices:

- Secure password handling.
- HTTPS communication.
- JWT validation.
- Authorization checks for user-specific information.
- Secure management of API credentials.
- Restricted access to uploaded photographs.
- Appropriate consent for image processing.
- Careful handling of skincare history and journal entries.

Facial photographs and personal skincare records should not be publicly accessible without authorization.

---

## 🗺️ Future Improvements

Potential future improvements include:

- More advanced AI-assisted skin-analysis capabilities.
- Improved skincare personalization.
- Expanded product and ingredient databases.
- Additional progress-tracking tools.
- Enhanced reminders and notifications.
- Improved accessibility.
- Additional mobile-platform support.
- More comprehensive educational resources.
- Enhanced privacy controls.

Future improvements will depend on the final project scope, available resources, and testing.

---

## 👥 Development Team

SkinSync is developed by the following students.

| Role | Name |
|---|---|
| Teammate 1 | Md Shamsul Alom Rahat |
| Teammate 2 | Fabliha Ahmed Fami |
| Teammate 3 | Shahrin Chowdhury |

---

## 👨‍🏫 Project Supervisor

**Abdulla Al Mahmud Mughdo**

Supervisor  
Department of Computer Science and Engineering

---

## 🎓 Academic Context

SkinSync is a third-year Computer Science and Engineering project.

The project demonstrates practical implementation of:

- Mobile application development.
- Software requirement analysis.
- System architecture and design.
- REST API development.
- Database management.
- Authentication and authorization.
- Cloud-based image storage.
- AI-assisted image analysis.
- Software testing and documentation.

---

## ⚠️ Disclaimer

SkinSync is an educational skincare management application.

Its AI-assisted analysis and product recommendations are intended for general informational purposes and are not medical diagnoses.

The application cannot replace professional medical advice, diagnosis, or treatment.

Users with persistent, severe, or concerning skin conditions should consult a qualified healthcare professional.

---

## 📬 Contact

For questions, suggestions, or collaboration regarding SkinSync, contact the project team through the repository's GitHub Issues section.

**GitHub Repository:**  
[Add your repository link here]

**Project Contact:**  
[Add your preferred contact information here]

---

## 📝 License

The project's license has not yet been specified.

If the repository is intended to be open source, add an appropriate license file and update this section.

---

## ⚡ Quick Reminder

SkinSync is a third-year academic project combining mobile development, backend engineering, database management, and AI-assisted image analysis.

The architecture and UI diagrams should be placed in `docs/images/` and referenced from this README.

Before publishing, ensure that the documented technologies, features, installation steps, and screenshots match the actual implementation.

---

<div align="center">

### SkinSync
**Sync Your Routine. Transform Your Skin.**

Developed as a third-year CSE project.

</div>
```
