# **Bookify - Book Rental App**

Bookify is a Flutter-based book rental application that allows users to browse, search, and rent books. Admins can manage books, upload cover images, and oversee rental orders. The app leverages **SQLite (sqflite)** for local data storage and **Riverpod** for state management.

---

## **Features Implemented**

### **For Users**
- Browse a catalog of books with images, ratings, and descriptions.
- Search books by title or author.
- View detailed book information.
- Rent available books with start and end dates.
- View personal rental history on the **Profile Page**.

### **For Admins**
- Add, edit, or delete books with cover images.
- Update book availability status.
- View and manage rental orders.

### **General**
- Role-based navigation (User/Admin).
- Local storage with **SQLite**.
- State management using **Riverpod**.
- Clean and modern UI with **Material Design**.
- Support for book images and placeholders when no image is available.

---

## **Setup Instructions**

### **Requirements**
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (latest stable)
- Android Studio or VS Code with Flutter & Dart plugins installed.
- Android Emulator or a physical Android device.

### **Steps to Run the App**
1. **Clone the repository:**
   ```bash
   git clone https://github.com/AsimAlrimi/bookify.git
   cd bookify

2. **Install dependencies:**
   ```bash
   flutter pub get

3. **Run the app:**
   ```bash
   flutter run

---

## **Folder Structure**

lib/
├── main.dart                 # Entry point
├── theme/                    # App theme configuration
├── routes/                   # App navigation (GoRouter)
├── pages/                    # Screens (AdminPage, SearchPage, BookDetailsPage, etc.)
├── services/                 # Providers, Database service, Models
├── widgets/                  # Reusable widgets (BookCard, BookFormDialog, etc.)

