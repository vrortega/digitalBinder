# 📱 Digital Binder

A Flutter application that simulates a **photocard binder**, allowing users to create a binder and add, replace, or remove images from card slots.

This project was created to practice **Flutter architecture, UI composition, and state management**, following the **MVVM pattern** and a scalable project structure.

---

# Preview


https://github.com/user-attachments/assets/2bd132bc-08c0-4303-b0e4-1acf0f633efd






# ✨ Features

## 📖 Binder Management

- Create **multiple binders**
- Edit binder name ✏️
- Delete binders 🗑️
- Persist binders locally

---

## 🃏 Photocard System

- Each binder contains **multiple pages**
- Each page contains **4 card slots**
- Add, replace, or delete cards
- Local image persistence

---

## 🎯 Interactions

- Drag and drop cards to reorder 🔄
- Navigate between pages
- Dynamic page creation
- Smooth UI interactions

---

## ⚙️ Tech Stack

## 📱 Core

- Flutter
- Dart

## 🧠 Architecture

- MVVM (Model–View–ViewModel)
- ChangeNotifier (state management)

## 📦 Packages

- image_picker → image selection
- shared_preferences → local data storage
- path_provider → file system access

## 🧪 Testing

- flutter_test
- mocktail

## 🎨 UI

- Material Design
- Custom fonts (Sora)

## 🚀 Dev Tools

- flutter_lints
- flutter_native_splash

---

## 🧱 MVVM Architecture

The project follows a **Model–View–ViewModel (MVVM)** structure:

| Layer | Responsibility |
|------|------|
| **Model** | Data structure of the binder |
| **ViewModel** | Business logic and state handling |
| **Views** | UI screens |
| **Services** | External operations (Storage, image handling) |
| **Repository** | Data persistence layer |

---

# 🔄 Updates
## 🆕 Latest Improvements
- Added page counter indicator to binder
- Improved UI and user experience

---

# 🛣️ Future Improvements
- 🚀 Publish app on Google Play
- ⭐ Add "favorite photocard" feature (priority tracking for purchases)
- 🎨 UI/UX refinements
  
---

## 🚀 Getting Started

### 1️⃣ Clone the repository

```bash
git clone https://github.com/vrortega/digital_binder.git
```

### 2️⃣ Navigate to the project

```bash
cd digital_binder
```

### 3️⃣ Install dependencies

```bash
flutter pub get
```

### 4️⃣ Run the app

```bash
flutter run
```
