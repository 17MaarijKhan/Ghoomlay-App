# **Ghoomlay App**

**Ghoomlay** is a location-based social travel app built using **Flutter** and integrated with **Firebase Authentication**, **Firestore**, and **Firebase Realtime Database**. It allows users to sign up, log in, share travel experiences, view others' travel stories, like posts, and leave comments.

---

## **Features**

* **User Authentication**
  Secure sign-up and login using Firebase Authentication.

* **Image and Post Uploading**
  Users can upload images of travel destinations along with place name, city name, and a caption.

* **Feed Display**
  Home screen displays all travel posts with images and captions using Firebase Realtime Database.

* **Like and Comment Functionality**
  Users can like posts and comment on them in real time.

* **Password Reset**
  Password reset feature via email in case users forget their credentials.

* **Persistent User Data**
  Uses SharedPreferences to store and retrieve user information like email, user ID, name, and profile image.

---

## **Technology Stack**

* **Frontend:** Flutter (Dart)
* **Backend Services:**

  * Firebase Authentication
  * Firebase Firestore
  * Firebase Realtime Database
  * Firebase Storage (for default user images)
* **Local Storage:** SharedPreferences

---

## **Project Structure**

```
lib/
├── pages/
│   ├── add_page.dart           # Upload travel post
│   ├── comment.dart            # Post comment UI and logic
│   ├── home.dart               # Travel feed with likes and comments
│   ├── login.dart              # Login screen
│   ├── signup.dart             # Signup screen
├── services/
│   ├── database.dart           # Firestore and Realtime DB helpers
│   ├── shared_pref.dart        # SharedPreferences helper
│   ├── firebase_options.dart   # Firebase config (auto-generated)
├── main.dart                   # App entry point
```

---

## **Setup Instructions**

1. **Clone the Repository**

   ```
   git clone https://github.com/your-username/ghoomlay-app.git
   cd ghoomlay-app
   ```

2. **Install Dependencies**

   ```
   flutter pub get
   ```

3. **Firebase Configuration**

   * Set up Firebase project in [Firebase Console](https://console.firebase.google.com)
   * Download `google-services.json` for Android and `GoogleService-Info.plist` for iOS
   * Place them in respective directories and configure as per [Firebase Flutter setup guide](https://firebase.flutter.dev/docs/overview/)

4. **Run the App**

   ```
   flutter run
   ```

---

## **How It Works**

* **User signs up or logs in** with email and password.
* **Posts travel content** with image and description.
* **Home screen** fetches posts from Realtime Database.
* Users can **like** or **comment** on posts.
* Comments are stored under each post in the database and **streamed in real time**.

---

## **Future Improvements**

* Add **user profiles** with editing capability.
* Integrate **Google Maps** for location tagging.
* Enable **notifications** for comments and likes.
* Enhance **image storage** using Firebase Storage instead of base64.
