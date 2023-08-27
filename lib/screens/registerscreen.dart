// ignore_for_file: file_names, use_build_context_synchronously
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_details/screens/loginscreen.dart';
import 'package:flutter_details/services/auth_service.dart';
import '../services/mailchecker.dart';
import 'emailverification.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _showPassword = false;
  bool passwordsMatch = true;
  bool validmail = true;
  TextEditingController emailControler = TextEditingController();
  TextEditingController passwordControler = TextEditingController();
  TextEditingController conformPasswordcontroler = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        // shadowColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Welcome to our",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  const Text(
                    "Community",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3,
                    ),
                  ),
                  const SizedBox(height: 40),
                  TextField(
                    controller: emailControler,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: const OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: validmail ? Colors.grey : Colors.red,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: validmail ? Colors.grey : Colors.red,
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        validateEmail(emailControler.text) == true
                            ? validmail = true
                            : validmail = false;
                      });
                    },
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    obscureText: !_showPassword,
                    controller: passwordControler,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: passwordsMatch ? Colors.grey : Colors.red,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: passwordsMatch ? Colors.grey : Colors.red,
                        ),
                      ),
                      border: const OutlineInputBorder(),
                      // suffixIcon: Icon(
                      //     _showPassword ? Icons.visibility_off : Icons.visibility),
                    ),
                    onChanged: (value) {
                      setState(
                        () {
                          passwordControler.text ==
                                  conformPasswordcontroler.text
                              ? passwordsMatch = true
                              : passwordsMatch = false;
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    onChanged: (value) {
                      setState(
                        () {
                          passwordControler.text ==
                                  conformPasswordcontroler.text
                              ? passwordsMatch = true
                              : passwordsMatch = false;
                        },
                      );
                    },
                    obscureText: !_showPassword,
                    controller: conformPasswordcontroler,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: passwordsMatch ? Colors.grey : Colors.red,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: passwordsMatch ? Colors.grey : Colors.red,
                        ),
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            if (_showPassword) {
                              _showPassword = false;
                            } else {
                              _showPassword = true;
                            }
                            // print(showPassword);
                          });
                        },
                        child: Icon(_showPassword
                            ? Icons.visibility_off
                            : Icons.visibility),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(double.maxFinite, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Colors.blueAccent,
                    ),
                    onPressed: () async {
                      if (emailControler.text == "" ||
                          passwordControler.text == "") {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              duration: Duration(milliseconds: 500),
                              content: Text("Enter Password and email",
                                  style: TextStyle(color: Colors.white)),
                              backgroundColor: Colors.red),
                        );
                      } else if (passwordsMatch == false) {
                        passwordControler.clear();
                        conformPasswordcontroler.clear();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              duration: Duration(milliseconds: 500),
                              content: Text("Password doesn't Match",
                                  style: TextStyle(color: Colors.white)),
                              backgroundColor: Colors.red),
                        );
                      } else {
                        try {
                          Object? result = await AuthService().register(
                              emailControler.text, passwordControler.text);
                          if (result != null) {
                            conformPasswordcontroler.clear();
                            passwordControler.clear();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EmailVerification(
                                    mail: emailControler.text,
                                    durationInMinutes: 2),
                              ),
                            );
                          }
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'email-already-in-use') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                duration: const Duration(seconds: 1),
                                content: Row(
                                  children: [
                                    const Text("Email Already in use. "),
                                    InkWell(
                                      onTap: () {
                                        emailControler.clear();
                                        passwordControler.clear();
                                        Navigator.pop(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginScreen(),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        "Login ->",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w800),
                                      ),
                                    )
                                  ],
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          } else if (e.code == 'weak-password') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                duration: Duration(seconds: 1),
                                content: Text(
                                    "Password is weak or be at least 6 character."),
                                backgroundColor: Colors.red,
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                duration: Duration(seconds: 1),
                                content: Text("An Error Occured"),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      }
                    },
                    child: const Text(
                      "Submit",
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // const SizedBox(height:),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("Already Registered?"),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 5.0),
                        child: InkWell(
                          onTap: () {
                            conformPasswordcontroler.clear();
                            passwordControler.clear();
                            emailControler.clear();
                            Navigator.pop(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(
                              color: Color.fromARGB(255, 11, 20, 188),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
