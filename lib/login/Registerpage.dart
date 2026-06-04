import 'package:final_project/login/googleauth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:final_project/login/mytext.dart';
import 'package:final_project/login/siginButton.dart';
import 'package:final_project/login/square.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void signUserUp() async {
    if (passwordController.text.trim() != confirmPasswordController.text.trim()) {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text("Password Mismatch"),
          content: Text("Passwords do not match."),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Colors.lightGreenAccent),
      ),
    );

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'This email is already registered.';
          break;
        case 'invalid-email':
          errorMessage = 'The email format is invalid.';
          break;
        case 'weak-password':
          errorMessage = 'Password is too weak.';
          break;
        default:
          errorMessage = 'Error: ${e.message}';
      }

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Registration Failed"),
          content: Text(errorMessage),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 40),
                const Icon(Icons.lock, size: 60),
                Text("Let's Create an Account For You",
                    style: TextStyle(color: Colors.grey[700], fontSize: 16)),
                const SizedBox(height:30),

                MyTextField(controller: emailController, hintText: 'Email', obscureText: false),
                const SizedBox(height: 10),
                MyTextField(controller: passwordController, hintText: 'Password', obscureText: true),
                const SizedBox(height: 10),
                MyTextField(controller: confirmPasswordController, hintText: 'Confirm Password', obscureText: true),
                const SizedBox(height: 25),

                

                MyButton(onTap: signUserUp, text: "Sign Up"), // ✅ Fix

                const SizedBox(height: 50),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Expanded(child: Divider(thickness: 0.5)),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: Text("Or continue with")),
                    Expanded(child: Divider(thickness: 0.5)),
                  ],
                ),
                const SizedBox(height: 45),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    
                    Square(
                      onTap: () => AuthSignIN().signInWithGoogle(),
                      ImagePath: 'images/google.png'),
                    SizedBox(width: 17),
                    Square(
                      onTap: () => AuthSignIN().signInWithGoogle(),
                      ImagePath: 'images/apple.png'),
                  ],
                ),

                const SizedBox(height: 35),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account?", style: TextStyle(color: Colors.grey[700])),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text("Login now", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
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
