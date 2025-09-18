import 'package:flutter/foundation.dart'; // ✅ For kReleaseMode
import 'package:construction/Screens/Components/Home.dart';
import 'package:construction/Screens/Authentication/SignUpPage.dart';
import 'package:construction/Screens/Authentication/forgetPass.dart';
import 'package:flutter/material.dart';
import 'package:construction/Screens/Auth_State/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscure = true;
  String selectedLanguage = 'English';
  final List<String> languages = ['English', 'Marathi', 'Hindi'];

  @override
  void initState() {
    super.initState();
    // Prefill in debug mode
    if (!kReleaseMode) {
      _phoneController.text = "9876543210";
      _passwordController.text = "TechMET@183";
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void handleLogin() {
    String phone = _phoneController.text.trim();
    String password = _passwordController.text.trim();

    if (phone.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill phone and password')),
      );
      return;
    }

    bool isLoggedIn = AuthService.login(phone, password);

    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(
          selectedLanguageCode: 'en', // Default to English
          onLanguageChanged: (code) {}, // Empty function for now
        )),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid phone or password')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Center(
          child: SizedBox(
            width:
                MediaQuery.of(context).size.shortestSide < 300
                    ? double.infinity
                    : 300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Center(
                  child: Image.asset(
                    "assets/logo/mm_logo.png",
                    width: 200,
                    height: 200,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Log in for exclusive designs, deals & quick checkout.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black54,
                    fontFamily: 'SourceSans3',
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: "Phone No.*",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  obscureText: _isObscure,
                  decoration: InputDecoration(
                    labelText: "Password*",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isObscure ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ForgetPasswordPage(),
                      ),
                    );
                  },
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Forget Password?",
                      style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: handleLogin,
                    child: const Text(
                      "LOG IN",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account?",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpPage(),
                          ),
                        );
                      },
                      child: const Text(
                        "Sign Up",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Text(
                      "Select Language:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 10),
                    DropdownButton<String>(
                      value: selectedLanguage,
                      items:
                          languages.map((lang) {
                            return DropdownMenuItem<String>(
                              value: lang,
                              child: Text(lang),
                            );
                          }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedLanguage = value;
                            // You can implement language change logic here
                            print('Selected Language: $selectedLanguage');
                          });
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
