# 🐕 AIdogscanner

> **AI-Powered Dog Breed Identification & Pet Care Management Platform**  
> A full-stack solution featuring a high-performance **Flutter** cross-platform client (Web, Android, iOS) and an enterprise-grade **Spring Boot** backend with **TensorFlow Lite** on-device inference.

---

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white)](https://dart.dev/)
[![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.5-6DB33F?logo=springboot&logoColor=white)](https://spring.io/projects/spring-boot)
[![Java](https://img.shields.io/badge/Java-21-ED8B00?logo=openjdk&logoColor=white)](https://www.oracle.com/java/)
[![MySQL](https://img.shields.io/badge/MySQL-8.0%2B-4479A1?logo=mysql&logoColor=white)](https://www.mysql.com/)
[![TensorFlow Lite](https://img.shields.io/badge/TensorFlow%20Lite-Supported-FF6F00?logo=tensorflow&logoColor=white)](https://www.tensorflow.org/lite)

---

## 🌟 Key Features

### 🔍 1. AI Dog Breed Identification
- **On-Device Inference**: Fast, local breed recognition powered by TensorFlow Lite (`.tflite`).
- **Comprehensive Breed Intelligence**:
  - Confidence scoring and rank-ordered predictions.
  - Physical attributes: size, coat texture, body structure, head/face traits, and coloring.
  - Behavioral insights: temperament characteristics, trainability, and exercise needs.
- **Multiple Input Modes**: Real-time camera capture or photo gallery upload.

### 🐾 2. Pet Health & Activity Companion
- **Activity & Routine Logging**: Schedule and log walks, feeding sessions, and medication.
- **Hydration & Nutrition Calculators**: Tailored food and drink recommendations according to dog size, weight, and activity level.
- **Hygiene & Grooming Records**: Track grooming schedules, dental care, and baths.
- **Reminder & Notification Engine**: Configurable calendar reminders for vet visits and wellness routines.

### 🌐 3. Multi-Language & Modern UI
- **Global Localization (i18n)**: Out-of-the-box support for English, Spanish, French, German, Italian, Portuguese, and more.
- **Fluid Design System**: Sora and Inter typography, responsive layouts optimized for Mobile and Web (Chrome).
- **Offline Resilience**: Local caching and preferences via Hive and SharedPreferences.

---

## 🏗️ Architecture & Repository Structure

```plaintext
AIdogscanner/
├── Backend/
│   └── spring-dog-backend/             # Spring Boot REST API
│       ├── src/main/java/              # Controllers, Services, Models, Repositories
│       ├── src/main/resources/         # application.properties & database migrations
│       └── pom.xml                     # Maven project configuration (Java 21, Spring Boot 3.5)
│
├── Frontend/
│   └── Dog_Breed/                      # Flutter Cross-Platform Client
│       ├── assets/
│       │   ├── models/                 # TensorFlow Lite model files
│       │   ├── fonts/                  # Sora & Inter typography
│       │   └── images/                 # UI graphics and splash assets
│       ├── lib/
│       │   ├── View/                   # Screens (Scanner, Dashboard, Pets, Calendar)
│       │   ├── View_model/             # State management and presentation logic
│       │   ├── services/               # TFLite service (with web stubs) & API client
│       │   ├── l10n/                   # Multi-language ARB localization files
│       │   └── main.dart               # Flutter application entrypoint
│       └── pubspec.yaml                # Flutter dependencies & asset registry
│
├── .gitignore                          # Root Git exclusion rules
└── README.md                           # Project documentation
```

---

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK**: `>= 3.9.0` ([Install Guide](https://flutter.dev/docs/get-started/install))
- **JDK**: Java 21 LTS ([Download OpenJDK](https://adoptium.net/))
- **Maven**: 3.8+ (or use included `./mvnw`)
- **MySQL**: 8.0+
- **Google Chrome** (for web deployment)

---

### 1. Backend Setup (Spring Boot)

1. **Navigate to the backend directory**:
   ```bash
   cd Backend/spring-dog-backend
   ```

2. **Configure Database**:
   Update `src/main/resources/application.properties` with your MySQL credentials:
   ```properties
   spring.datasource.url=jdbc:mysql://localhost:3306/dog_breed_db?createDatabaseIfNotExist=true
   spring.datasource.username=root
   spring.datasource.password=your_password
   spring.jpa.hibernate.ddl-auto=update
   server.port=8081
   ```

3. **Build and Run**:
   ```bash
   # Using Maven wrapper
   ./mvnw clean spring-boot:run
   ```
   *The REST API will be available at `http://localhost:8081/api`.*

---

### 2. Frontend Setup (Flutter)

1. **Navigate to the frontend directory**:
   ```bash
   cd Frontend/Dog_Breed
   ```

2. **Install Flutter dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run on Google Chrome**:
   ```bash
   flutter run -d chrome --web-port=8085
   ```
   *Access the web app at `http://localhost:8085`.*

4. **Run on Mobile (Android / iOS)**:
   ```bash
   # Android
   flutter run -d android

   # iOS
   flutter run -d ios
   ```

---

## 🛡️ Machine Learning Pipeline

- **Model format**: TensorFlow Lite (`dog_identifier.tflite`)
- **Labels file**: `assets/labels.txt`
- **Cross-Platform Compatibility**: Uses conditional compilation (`tflite_service.dart`) with a mock stub for browser execution, allowing web builds to run smoothly while retaining full native on-device TFLite acceleration on mobile.

---

## 🤝 Contributing

Contributions, bug reports, and feature requests are welcome!
1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

**Developed with ❤️ by [Muzammal Nazeer](https://github.com/MuzammalNazeer)**
