# Termii SMS Integration Setup Guide

## 🎯 What is Termii?
Termii is a Nigerian SMS service that provides fast, reliable SMS delivery across Nigeria and other African countries. It's much more reliable than Firebase Phone Auth for Nigerian phone numbers.

## 📋 Setup Steps

### 1. Create a Termii Account
1. Go to https://termii.com
2. Click "Sign Up" and create an account
3. Verify your email address
4. Complete your profile

### 2. Get Your API Key
1. Log in to your Termii dashboard
2. Go to "API Settings" or "Integration"
3. Copy your **API Key**
4. Open `lib/services/termii_service.dart`
5. Replace `YOUR_TERMII_API_KEY` with your actual API key:
   ```dart
   static const String _apiKey = 'TLxxxxxxxxxxxxxxxxxxxxx'; // Your actual key
   ```

### 3. Configure Sender ID (Optional but Recommended)
1. In Termii dashboard, go to "Sender ID"
2. Request a Sender ID (e.g., "CreditPay")
3. Wait for approval (usually 24-48 hours)
4. Once approved, update the sender ID in `termii_service.dart`:
   ```dart
   static const String _senderId = 'CreditPay'; // Your approved sender ID
   ```

**Note:** Until your Sender ID is approved, Termii will use a default sender ID.

### 4. Add Funds to Your Account
1. Go to "Wallet" in Termii dashboard
2. Click "Fund Wallet"
3. Add at least ₦1,000 to start (SMS costs ~₦2-3 each)
4. Choose your payment method (Card, Bank Transfer, etc.)

### 5. Test the Integration
1. Run your app
2. Go through the signup flow
3. Enter a valid Nigerian phone number
4. You should receive an SMS with a 6-digit code
5. Enter the code to verify

## 💰 Pricing
- **SMS Cost**: ₦2.50 - ₦3.00 per SMS (varies by network)
- **No monthly fees**
- **Pay as you go**

## 🔧 Troubleshooting

### "Failed to send verification code"
- Check that your API key is correct
- Ensure you have sufficient balance in your Termii wallet
- Verify the phone number format is correct (+234...)

### "Invalid verification code"
- The code expires after 5 minutes
- Make sure you're entering the exact code received
- Try resending the code

### SMS not received
- Check that the phone number is correct
- Ensure the number is active and can receive SMS
- Some networks may have delays (usually < 30 seconds)
- Check your Termii dashboard for delivery status

## 📱 Supported Networks
- MTN Nigeria ✅
- Airtel Nigeria ✅
- Glo Nigeria ✅
- 9mobile Nigeria ✅

## 🌍 International Support
Termii also supports sending SMS to other countries, but rates vary. Check the Termii pricing page for details.

## 📞 Support
- Termii Support: support@termii.com
- Documentation: https://developers.termii.com
- Dashboard: https://termii.com/dashboard

## 🔐 Security Notes
- Never commit your API key to version control
- Consider using environment variables for production
- Monitor your usage in the Termii dashboard
- Set up spending limits to avoid unexpected charges

## ✅ Next Steps
Once you've completed the setup:
1. Test with multiple phone numbers
2. Monitor delivery rates in Termii dashboard
3. Consider implementing rate limiting to prevent abuse
4. Add analytics to track verification success rates
