# Firebase Setup Guide

## Step 1: Create Firebase Project
- Go to console.firebase.google.com
- Click "Add project" -> Name: "fashion-store-app"
- Disable Google Analytics -> Create project

## Step 2: Add Android App
- Click Android icon
- Package name: com.example.fashion_store_app
- App nickname: MFashion Store
- Download google-services.json
- Place it in: android/app/google-services.json

## Step 3: Enable Authentication
- Go to Authentication -> Sign-in method
- Enable Email/Password provider

## Step 4: Create Firestore Database
- Go to Firestore Database -> Create database
- Start in test mode
- Choose region: asia-south1

## Step 5: Firestore Collections Structure

- users/{userId} -> name, email, phone, address, photoUrl
- products/{productId} -> name, price, category, description, imageUrl, stock
- carts/{userId}/items/{itemId} -> productId, name, price, quantity, imageUrl
- orders/{userId}/userOrders/{orderId} -> items, totalAmount, deliveryAddress, status, timestamp
- wishlists/{userId}/items/{itemId} -> productId, name, price, imageUrl

## Step 6: Firestore Security Rules

Copy the rules from firestore.rules file in the project:

```firestore
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {
    match /products/{productId} {
      allow read: if true;
      allow write: if request.auth != null;
    }

    match /orders/{orderId} {
      allow create: if request.auth != null
        && request.resource.data.userId == request.auth.uid;
      allow read, update, delete: if request.auth != null
        && resource.data.userId == request.auth.uid;
    }

    match /users/{userId} {
      allow read, create, update, delete: if request.auth != null
        && request.auth.uid == userId;

      match /{subcollection}/{documentId} {
        allow read, create, update, delete: if request.auth != null
          && request.auth.uid == userId;
      }
    }
  }
}
```

## Step 7: Run the App

```bash
flutter pub get
flutter run
```
