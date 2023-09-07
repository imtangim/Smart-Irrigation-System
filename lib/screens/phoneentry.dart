import 'package:country_flags/country_flags.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_details/models/otpbox.dart';
import 'package:flutter_details/screens/bottombar.dart';
import 'package:flutter_details/screens/registerscreen.dart';
import 'package:flutter_details/services/auth_service.dart';
import 'package:flutter_details/services/mailchecker.dart';
import 'package:gap/gap.dart';

import 'phoneverification.dart';

class PhoneNoEntry extends StatefulWidget {
  const PhoneNoEntry({super.key});

  @override
  State<PhoneNoEntry> createState() => _PhoneNoEntryState();
}

class _PhoneNoEntryState extends State<PhoneNoEntry> {
  bool _validmail = false;

  TextEditingController phoneNumber = TextEditingController();

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
                    "Welcome Back",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 5,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            width: 1,
                            color: Colors.grey,
                          ),
                        ),
                        height: 55,
                        width: MediaQuery.of(context).size.width * 0.233,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CountryFlag.fromCountryCode(
                              'bd',
                              height: 20,
                              width: 25,
                            ),
                            const Gap(10),
                            const Text(
                              "+880",
                              style: TextStyle(fontSize: 18),
                            )
                          ],
                        ),
                      ),
                      const Gap(10),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 150,
                        height: MediaQuery.of(context).size.height * 0.07,
                        child: TextField(
                          style: const TextStyle(fontSize: 18),
                          controller: phoneNumber,
                          decoration: InputDecoration(
                            labelText: 'Mobile number',
                            hintText: "01234-567890",
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
                              validatephone(phoneNumber.text) == true
                                  ? _validmail = true
                                  : _validmail = false;
                            });
                            if (kDebugMode) {
                              print(_validmail);
                            }
                          },
                        ),
                      ),
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
                      if (phoneNumber.text != '' &&
                          phoneNumber.text.length == 11) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OtpVerification(
                              phoneNumber: phoneNumber.text,
                              durationInMinutes: 2,
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            duration: const Duration(seconds: 1),
                            content: Text(
                              phoneNumber.text.length > 11 ||
                                      phoneNumber.text.length < 11
                                  ? 'Phone Number is not valid'
                                  : 'Phone Number Can\'t be empty',
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500),
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
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
                      "Sign in With Email",
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterScreen(),
                            ),
                          );
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
}
