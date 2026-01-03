# CreditPay 💳

**CreditPay** is a comprehensive fintech mobile application built with **Flutter**. It empowers users to manage their finances seamlessly, offering features such as wallet funding, bank transfers, bill payments, airtime/data verification, and instant loan applications.

The app is designed with a modern, user-friendly interface and robust security features including PIN verification and biometric support potential.

## 🚀 Key Features

### 🏦 Wallet & Transactions
- **Fund Wallet**: Easily top up your wallet using Paystack integration.
- **Bank Transfers**:
  - Transfer money to any Nigerian bank.
  - **Real-time Account Verification**: Automatically verifies account names before transfer.
  - **Save Beneficiaries**: Save frequent contacts for quick customized transfers.
  - **Transaction History**: Detailed logs of all credits and debits.

### 💸 Payments & Bills
- **Airtime & Data**: Purchase airtime and data bundles directly from the app.
- **Bill Payments**: Pay utility bills (Electricity, TV cables, etc.) effortlessly.

### 💰 Loans (Credit)
- **Instant Loan Application**: Apply for loans with a streamlined process.
- **KYC Integration**:
  - Personal Information verification.
  - Employer Information.
  - Next of Kin details.
  - Document Upload (IDs, etc.) using Cloudinary.
- **Loan Repayment**: Manage and repay active loans directly.

### 🔐 Authentication & Security
- **Secure Onboarding**: Phone number verification (OTP) via Firebase.
- **KYC Verification**: Tier-based account limits and verification.
- **PIN Security**: Secure transaction PIN for all sensitive actions.
- **Password Management**: Change and reset password capabilities.

## 🛠️ Technology Stack

- **Framework**: [Flutter](https://flutter.dev/) (Dart)
- **State Management**: [Provider](https://pub.dev/packages/provider)
- **Backend / Database**:
  - [Firebase Auth](https://firebase.google.com/docs/auth) (Authentication)
  - [Cloud Firestore](https://firebase.google.com/docs/firestore) (Database)
  - [Firebase Storage](https://firebase.google.com/docs/storage) & [Cloudinary](https://cloudinary.com/) (Media Storage)
- **Payments**: [Flutter Paystack Plus](https://pub.dev/packages/flutter_paystack_plus)
- **UI Libraries**:
  - `flutter_screenutil` (Responsive design)
  - `dropdown_search` (Searchable dropdowns)
  - `google_fonts` (Typography)

## 📂 Project Structure

```
lib/
├── constants/         # App-wide constants (colors, styles, API keys)
├── models/            # Data models (Bank, user, Transaction, etc.)
├── providers/         # State management (WalletProvider, AuthProvider)
├── screens/           # UI Screens
│   ├── transfer_screen.dart       # Bank transfer with Paystack verification
│   ├── fund_wallet_screen.dart    # Wallet top-up
│   ├── home_page_screen.dart      # Dashboard
│   ├── loan_application_screen.dart
│   └── ...
├── services/          # External services (Paystack, Cloudinary, Firebase)
├── widgets/           # Reusable UI components
└── main.dart          # Entry point
```

## ⚙️ Setup & Installation

1.  **Prerequisites**:
    - Flutter SDK installed (`flutter doctor`)
    - Android Studio / VS Code
    - Firebase project setup.

2.  **Clone the Repository**:
    ```bash
    git clone https://github.com/yourusername/creditpay.git
    cd creditpay
    ```

3.  **Install Dependencies**:
    ```bash
    flutter pub get
    ```

4.  **Configuration**:
    - **Firebase**: Add your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) to the respective platform folders.
    - **Paystack**: Ensure your Public/Secret keys are set in `lib/services/paystack_service.dart`.
    - **Cloudinary**: Update cloud name and upload preset in `lib/services/cloudinary_service.dart`.

5.  **Run the App**:
    ```bash
    flutter run
    ```

## ⚠️ Important Notes

- **Paystack Test Mode**: The app is currently configured with Paystack Test Keys. Real bank verification limit is 3 requests/day in test mode. Use Paystack test bank codes or switch to live keys for production.
- **KYC**: Document uploads require a valid Cloudinary configuration.

## 🤝 Contribution

Contributions are welcome! Please fork the repository and submit a pull request.

---
*Built with ❤️ by the CreditPay Team*
