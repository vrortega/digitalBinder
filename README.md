# 📱 Digital Binder

A Flutter application that simulates a **photocard binder**, allowing users to create a binder and add, replace, or remove images from card slots.

This project was created to practice **Flutter architecture, UI composition, and state management**, following the **MVVM pattern** and a scalable project structure.

---

# ✨ Features

## 📖 Binder System

- Create a **photocard binder**
- Binder layout with **4 card slots**
- Photocards displayed in a **realistic binder layout**

Users can:

- ➕ Add an image to an empty card slot
- 🔄 Replace an existing photocard
- 🗑 Delete a photocard

Images are selected using the device gallery via **image_picker**.

---

## 🧱 MVVM Architecture

The project follows a **Model–View–ViewModel (MVVM)** structure:

| Layer | Responsibility |
|------|------|
| **Model** | Data structure of the binder |
| **ViewModel** | Business logic and state handling |
| **Views** | UI screens |
| **Widgets** | Reusable UI components |

This separation keeps the code **clean, testable, and scalable**.

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
