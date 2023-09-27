import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_details/main.dart';
import 'package:flutter_details/screens/bottombar.dart';
import 'package:flutter_details/screens/extra/registerscreen.dart';
import 'package:flutter_details/services/auth_service.dart';
import 'package:flutter_details/services/mailchecker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _validmail = true;
  bool _showPassword = false;
  TextEditingController emailControler = TextEditingController();
  TextEditingController passwordControler = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SafeArea(
          child: Container(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Welcome",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 5,
                    ),
                  ),
                  const Text(
                    "Back",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 5,
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
                          color: _validmail ? Colors.grey : Colors.red,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: _validmail ? Colors.grey : Colors.red,
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        validateEmail(emailControler.text) == true
                            ? _validmail = true
                            : _validmail = false;
                      });
                    },
                  ),
                  const SizedBox(height: 30),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        obscureText: !_showPassword,
                        controller: passwordControler,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: const OutlineInputBorder(),
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
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, left: 3.0),
                        child: InkWell(
                          onTap: () async {
                            if (emailControler.text != '') {
                              await AuthService()
                                  .resetPassword(emailControler.text);
                              snackBar("Password email sent.");
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  duration: Duration(seconds: 1),
                                  content: Text(
                                    'Email and Password cannot be empty.',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          child: const Text(
                            "Forgot passoword?",
                            style: TextStyle(
                              color: Color.fromARGB(255, 51, 13, 218),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      )
                    ],
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
                      if (emailControler.text != "" ||
                          passwordControler.text != "") {
                        FocusScope.of(context).unfocus();
                        // if (_key.currentState!.validate()) {
                        signinuser();
                      }
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(200, 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Colors.blueAccent,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Sign in With Phone",
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("Not Registered? "),
                      TextButton(
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(EdgeInsets.zero),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          animationDuration: const Duration(milliseconds: 0),
                          overlayColor:
                              MaterialStateProperty.all(Colors.transparent),
                          textStyle:
                              MaterialStateProperty.all(const TextStyle()),
                          elevation: MaterialStateProperty.all(0),
                          shadowColor:
                              MaterialStateProperty.all(Colors.transparent),
                          side: MaterialStateProperty.all(BorderSide.none),
                        ),
                        onPressed: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => const RegisterScreen(),
                          //   ),
                          // );
                        },
                        child: const Text(
                          "Create an account",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
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

  snackBar(String message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 1),
        content: Text(
          message,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 63, 144, 39),
      ),
    );
  }

  void signinuser() async {
    try {
      dynamic result = await AuthService().signin(
        emailControler.text,
        passwordControler.text,
      );

      if (result != null) {
        passwordControler.clear();
        emailControler.clear();
        snackBar("Successful.");
        ref.read(uidProvider.notifier).state = result.uid;
        if (kDebugMode) {
          print("The uid is : ${ref.watch(uidProvider)}");
        }
        // ignore: use_build_context_synchronously
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const Bottombar(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0); // Slide in from the right
              const end = Offset.zero;
              final tween = Tween(begin: begin, end: end);
              final offsetAnimation = animation.drive(tween);

              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 200),
            fullscreenDialog: true,
          ),
        );
      } else if (result == null) {
        passwordControler.clear();
        snackBar('Verify Email please.');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        snackBar('This account does not exist.');
      } else if (e.code == 'wrong-password') {
        passwordControler.clear();
        snackBar('Incorrect password.');
      }
    }
  }
}
