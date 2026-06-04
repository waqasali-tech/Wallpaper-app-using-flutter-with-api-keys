import 'package:final_project/login/googleauth.dart';
import 'package:final_project/login/mytext.dart';
import 'package:final_project/login/siginButton.dart';
import 'package:final_project/login/square.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class Login extends StatefulWidget {
  final Function()? onTap;
 const Login({super.key, required this.onTap});


  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
 final emailController = TextEditingController();
         final passwordController = TextEditingController();

  void signUserIn() async {
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const Center(
                     child: CircularProgressIndicator(
            color: Colors.lightGreenAccent,
          ),
        );
      },
    );

    try {
      
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      Navigator.pop(context);


    } on FirebaseAuthException catch (e) {
    
      Navigator.pop(context);

      String errorMessage;
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password buddy.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'The email address is not valid.';
      } else {
        errorMessage = 'An error occurred: ${e.message}';
      }

      
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Login Failed"),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            )
          ],
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                const Icon(Icons.lock, size: 60),
                Text(
                  "Welcome Back I missed You Jan!",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[700], fontSize: 16),
                ),
                const SizedBox(height: 30),

                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),
                const SizedBox(height: 10),

                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 15),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                MyButton( 
                  text: "Sign In",
                  onTap: signUserIn), // 🔁 Uses our signUserIn method

                const SizedBox(height: 20, width: 5,),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    children: [
                      Expanded(
                          child:
                              Divider(thickness: 0.5, color: Colors.grey[300])),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text('Or continue with'),
                      ),
                      Expanded(
                          child:
                              Divider(thickness: 0.5, color: Colors.grey[300])),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Square(
                      onTap: () => AuthSignIN().signInWithGoogle(),
                      ImagePath: 'images/google.png'),
                    SizedBox(width: 17),
                    Square(onTap: () => AuthSignIN().signInWithGoogle(),
                      ImagePath: 'images/apple.png'),
                  ],
                ),

                const SizedBox(height: 30),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Not a member?",
                        style: TextStyle(color: Colors.grey[700])),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget. onTap,
                      child: Text("Register here",
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold)),
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
