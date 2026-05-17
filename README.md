# 🛒 E-Commerce Mobile App

A cross-platform E-Commerce mobile application built with **Flutter**, featuring global state management, secure payment gateway integration, and Firebase backend integration.

---

## 📱 App Screenshots

| 🏠 Home & 📄 Details | 🛒 Cart & ❤️ Favorites | 👤 Profile & 🔍 Search |
| :---: | :---: | :---: |
| <img src="https://github.com/user-attachments/assets/7f6cb581-76d5-4c0d-8220-66ff91b51a66" width="230" alt="Home"/> <img src="https://github.com/user-attachments/assets/aaec477a-0b62-413d-8f38-d9bcd5c4d797" width="230" alt="Details"/> | <img src="https://github.com/user-attachments/assets/df2db69a-9b58-40b7-a6ce-e00991bc0b6a" width="230" alt="Cart"/> <img src="https://github.com/user-attachments/assets/f11bdb94-eacb-47ce-abeb-7af730a92b1b" width="230" alt="Favorite"/> | <img src="https://github.com/user-attachments/assets/60758ea9-5064-4347-bee7-3e600ca0357f" width="230" alt="Profile"/> <img src="https://github.com/user-attachments/assets/ef05c21c-eb8f-4dd4-8c17-c31f10e7c0a8" width="230" alt="Search"/> |

---

## ✨ Core Features

* **Secure Authentication:** User registration and login powered by Firebase Auth.
* **Dynamic Product Catalog:** Products fetching and data parsing using REST APIs.
* **State Management:** Reactive global state for Cart and Favorites using Provider.
* **Seamless Payments:** Full checkout pipeline integrated with Stripe Payment Gateway.
* **Cloud Sync:** Saving user cart and favorites data with Firebase Firestore.

---

## 🛠️ Tech Stack & Architecture

This project follows clean code principles and structured folder management to ensure scalability:

* **Frontend:** Flutter & Dart
* **State Management:** Provider
* **Backend & Database:** Firebase Auth & Cloud Firestore
* **Payment Gateway:** Stripe SDK
* **Networking:** HTTP Client

### 📂 Project Structure Overview
```text
lib/
│
├── core/          # Network clients, themes, and shared utilities
├── models/        # Data models (Product, User, CartItem)
├── providers/     # Global state logic (CartProvider, AuthProvider)
└── screens/       # UI Views (Home, ProductDetails, Cart, Checkout)
