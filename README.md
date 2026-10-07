# 🐕 AIdogscanner

> **AI-Powered Dog Breed Identification & Complete Pet Care Management Platform**  
> A full-stack solution featuring a high-performance **Flutter** cross-platform client (Web, Android, iOS, Windows) and an enterprise-grade **Spring Boot** backend with on-device **TensorFlow Lite** AI inference.

---

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white)](https://dart.dev/)
[![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.5-6DB33F?logo=springboot&logoColor=white)](https://spring.io/projects/spring-boot)
[![Java](https://img.shields.io/badge/Java-21-ED8B00?logo=openjdk&logoColor=white)](https://www.oracle.com/java/)
[![MySQL](https://img.shields.io/badge/MySQL-8.0%2B-4479A1?logo=mysql&logoColor=white)](https://www.mysql.com/)
[![TensorFlow Lite](https://img.shields.io/badge/TensorFlow%20Lite-On--Device%20AI-FF6F00?logo=tensorflow&logoColor=white)](https://www.tensorflow.org/lite)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

---

## 🌟 Key Features

### 🔍 1. AI Dog Breed Identification
- **On-Device Inference**: Ultra-fast offline breed prediction powered by TensorFlow Lite (`dog_identifier.tflite`).
- **Comprehensive Breed Intelligence**:
  - Probability & confidence scoring for top breed matches.
  - Physical attributes: size, coat texture, body structure, head/face characteristics, and coloration.
  - Behavioral insights: temperament, trainability, exercise requirements, and purpose.
- **Multiple Input Modes**: Real-time live camera detection or instant photo gallery picker.
- **Web & Mobile Support**: Seamless conditional architecture (`tflite_service.dart`) with dedicated web stubs enabling cross-platform compilation on Chrome and desktop.

### 🐾 2. Pet Health & Care Companion
- **Pet Profile Hub**: Manage multiple pets with age, weight, breed, photos, and personalized notes.
- **Activity & Routine Logging**: Schedule and record daily walks, feeding sessions, and medication.
- **Hydration & Diet Calculators**: Automated water and food portion calculators calibrated to pet weight and activity level.
- **Hygiene & Grooming Records**: Track bath sessions, brushing, dental hygiene, and nail clipping.
- **Medical Records & Vaccinations**: Log vet visits, vaccination certificates, and medical history.
- **Interactive Reminders**: High-priority exact alarms and calendar notifications powered by `flutter_local_notifications`.

### 🌐 3. Multi-Language & Modern UI
- **Global Localization (i18n)**: Out-of-the-box support for 14+ languages (English, Spanish, French, German, Italian, Portuguese, Turkish, Dutch, Polish, Czech, Danish, Finnish, Swedish, and Indonesian).
- **Modern Design System**: Sora and Inter typography, fluid micro-interactions, responsive ScreenUtil scaling, and Light/Dark theme switching (`ThemeNotifier`).
- **Offline Storage & Caching**: Fast local preferences using SharedPreferences and Hive.

---

## 🏗️ Architecture & Project Structure

```plaintext
AIdogscanner/
├── Backend/
│   └── spring-dog-backend/             # Spring Boot REST API
│       ├── src/main/java/              # Controllers, Services, Models, Repositories
│       │   └── controller/             # REST Endpoints (Auth, Pets, Breeds, Reminders, etc.)
│       ├── src/main/resources/         # application.properties (MySQL & JWT setup)
│       └── pom.xml                     # Maven configuration (Java 21, Spring Boot 3.5)
│
├── Frontend/
│   └── Dog_Breed/                      # Flutter Cross-Platform Client
│       ├── assets/
│       │   ├── models/                 # TensorFlow Lite model (dog_identifier.tflite)
│       │   ├── fonts/                  # Sora & Inter typography fonts
│       │   └── images/                 # App artwork, illustrations & branding
│       ├── lib/
│       │   ├── View/                   # Screens (Scanner, Dashboard, Pets, Activities, Settings)
│       │   ├── View_model/             # State management providers (Provider & Notifiers)
│       │   ├── services/               # TFLite inference service & REST API integrations
│       │   ├── l10n/                   # Multi-language ARB localization files
│       │   └── main.dart               # App entry point, camera & notification init
│       └── pubspec.yaml                # Flutter dependencies & asset configurations
│
├── .gitignore                          # Git ignore rules for build artifacts
└── README.md                           # Project documentation
```

---

## 🔌 Backend REST API Overview

The Spring Boot backend exposes comprehensive REST endpoints:

| Endpoint Group | Description |
| :--- | :--- |
| `/api/auth` | User registration, login, JWT token issuance, and password recovery |
| `/api/pets` | CRUD operations for pet profiles, photos, and attributes |
| `/api/breeds` | Dog breed database, care specifications, and trait queries |
| `/api/favorites` | Bookmark and manage favorite dog breeds |
| `/api/predictions` | Store and retrieve AI scanning history and predictions |
| `/api/reminders` | Schedule reminders, task alerts, and calendar notifications |
| `/api/cleaning-logs` | Grooming, cleaning, and bath tracking |
| `/api/hygiene-logs` | Comprehensive hygiene and wellness monitoring |
| `/api/medical-records` | Health checkups, vaccinations, and vet records |

---

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK**: `>= 3.9.0` ([Flutter Installation](https://flutter.dev/docs/get-started/install))
- **Java Development Kit**: JDK 21 LTS ([Adoptium OpenJDK 21](https://adoptium.net/))
- **Build Tool**: Maven 3.8+ (or use the included `./mvnw` wrapper)
- **Database**: MySQL 8.0+
- **Browser**: Google Chrome (for web client)

---

### 1. Backend Setup (Spring Boot)

1. **Navigate to the backend directory**:
   ```bash
   cd Backend/spring-dog-backend
   ```

2. **Configure Database**:
   Verify or update `src/main/resources/application.properties` with your MySQL credentials:
   ```properties
   server.port=8081
   spring.datasource.url=jdbc:mysql://localhost:3306/petcare_management?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true
   spring.datasource.username=root
   spring.datasource.password=your_mysql_password
   spring.jpa.hibernate.ddl-auto=update
   ```

3. **Run the Backend**:
   ```bash
   # Windows
   .\mvnw.cmd clean spring-boot:run

   # macOS / Linux
   ./mvnw clean spring-boot:run
   ```
   *The API will start at `http://localhost:8081/api`.*

---

### 2. Frontend Setup (Flutter)

1. **Navigate to the frontend directory**:
   ```bash
   cd Frontend/Dog_Breed
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run on Google Chrome**:
   ```bash
   flutter run -d chrome --web-port=8085
   ```
   *Access the web application in your browser at `http://localhost:8085`.*

4. **Run on Mobile (Android / iOS)**:
   ```bash
   # Run on Android Device / Emulator
   flutter run -d android

   # Run on iOS Simulator (macOS only)
   flutter run -d ios
   ```

5. **Run on Windows Desktop**:
   ```bash
   flutter run -d windows
   ```

---

## 🧠 Machine Learning Details

- **Model File**: `assets/models/dog_identifier.tflite`
- **Labels Registry**: `assets/labels.txt`
- **Inference Service**: Implemented in [`lib/services/tflite/`](lib/services/tflite/) with conditional compilation:
  - `tflite_io.dart`: High-performance native inference utilizing hardware acceleration on mobile.
  - `tflite_stub.dart`: Clean browser fallback enabling seamless web compilation on Google Chrome without `dart:ffi` dependency conflicts.

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit issues or pull requests:

1. Fork the Repository
2. Create your Feature Branch (`git checkout -b feature/NewFeature`)
3. Commit your Changes (`git commit -m 'feat: Add NewFeature'`)
4. Push to the Branch (`git push origin feature/NewFeature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

**Developed with ❤️ by [Muzammal Nazeer](https://github.com/MuzammalNazeer)**
