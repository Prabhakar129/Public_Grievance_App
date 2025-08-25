import 'package:dpg_app/components/home/my_button.dart';
import 'package:dpg_app/pages/create_account_page.dart';
import 'package:dpg_app/pages/login_page.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  void SignIn(BuildContext context) async {
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }

  void CreateAccount(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateAccountPage(),
      ),
    );
  }
  

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // Logo
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    'U',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // App Title
              const Text(
                'UserApp',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 16),

              // Subtitle
              Text(
                'Welcome to your personal registeration platform',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),

              const Spacer(),

              // 🔹 Box starts here
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                margin: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'Get Started',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      'Join thousands of users who trust our platform for secure registeration and profile management.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Create New Account Button (filled)
                    MyButton(
                      text: "Create New Account",
                      onTap: () => CreateAccount(context),
                    ),

                    // Sign In Button (outlined)
                    MyButton(
                      text: "Already have an account? Sign In",
                      onTap: () => SignIn(context),
                      isOutlined: true,
                    ),
                  ],
                ),
              ),
              // 🔹 Box ends here

              const SizedBox(height: 40),

              // Features
              Text(
                'Secure • Fast • Reliable',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
