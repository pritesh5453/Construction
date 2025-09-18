class AuthService {
  // Dummy credentials
  static const String dummyPhone = '9876543210';
  static const String dummyPassword = 'TechMET@183';

  static bool login(String phone, String password) {
    if (phone == dummyPhone && password == dummyPassword) {
      return true; // ✅ Login success
    }
    return false; // ❌ Invalid credentials
  }
}
