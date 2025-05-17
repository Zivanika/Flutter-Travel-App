<h1 align="center">🌍 Flutter Travel App</h1>

<p align="center">
  A beautiful, fast, and responsive travel companion app built using Flutter and Dart.
</p>

---

## 🖥️ Tech Stack

**Frontend (Mobile):**

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)&nbsp;
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)&nbsp;
![Android](https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white)&nbsp;
![iOS](https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=apple&logoColor=white)&nbsp;

---

## 📱 Screenshots

| Home Screen             | Dragged View               |
| ----------------------- | -------------------------- |
| ![home](/img/home1.jpg) | ![dragged](/img/home2.jpg) |

---

## 🚀 Getting Started

### ✅ Prerequisites

Before running the project, make sure you have the following installed:

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- Android Studio or VS Code with Flutter extension
- Java JDK 11 or higher
- An emulator or physical device connected

---

### 🏠 Running the Project Locally

1. **Clone the Repository:**

```bash
git clone https://github.com/Zivanika/Flutter-Travel-App.git
cd Flutter-Travel-App
```

2. **Install Flutter Packages:**

   ```sh
   flutter pub get
   ```

3. **Run the App::**

   Using flutter:

   ```sh
   flutter run
   ```

   or just press F5

   (Make sure an emulator is running or a device is connected.)

### 🔐 Keystore Setup for Android Release

To generate a signed Android APK or AAB, you'll need a keystore:

1. **Generate a keystore:**

```bash
keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

2. **Create a key.properties file in android/ directory:**

storePassword=your_store_password
keyPassword=your_key_password
keyAlias=upload
storeFile=upload-keystore.jks

3. **Place upload-keystore.jks in the android/app/ directory**
4. **DO NOT commit key.properties or the .jks file to Git.**

### 🧪 Build APK

To build a release version:

```bash
flutter build apk --release
```

<h2>📬 Contact</h2>

If you want to contact me, you can reach me through below handles.

[![linkedin](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](linkedin.com/in/harshita-barnwal-17a732234/)

© 2025 Harshita Barnwal

[![forthebadge](https://forthebadge.com/images/badges/built-with-love.svg)](https://forthebadge.com)
