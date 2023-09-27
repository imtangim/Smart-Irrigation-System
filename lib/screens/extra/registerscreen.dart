// ignore_for_file: file_names, use_build_context_synchronously
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_details/services/auth_service.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart' as http;
// impor'extra/emailverification.dart'er.dart';
// import 'extra/emailverification.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController district = TextEditingController();
  TextEditingController division = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  List<String> divisionDropdown = [
    "Division",
  ];
  List<String> districtDropdown = [
    "District",
  ];
  bool termConditionCheckBox = false;
  String selectedDivision = "Division";
  String selectedDistrict = "District";
  bool _showPassword = false;
  bool passwordsMatch = true;
  bool validmail = true;
  TextEditingController emailControler = TextEditingController();
  TextEditingController passwordControler = TextEditingController();
  TextEditingController conformPasswordcontroler = TextEditingController();

  Future<void> fetchDivision() async {
    try {
      final response =
          await http.get(Uri.parse('https://bdapis.com/api/v1.1/divisions'));
      if (response.statusCode == 200) {
        // Parse the JSON response
        final Map<String, dynamic> apiData = json.decode(response.body);
        // if (kDebugMode) {
        //   print(apiData["data"]);
        // }

        for (var i = 0; i < apiData["data"].length; i++) {
          if (kDebugMode) {
            if (kDebugMode) {
          }
            print(apiData["data"][i]["division"]);
          }
          divisionDropdown.add(apiData["data"][i]["division"]);
          print(divisionDropdown);
        }
      } else {
        if (kDebugMode) {
          print("Request failed with status: ${response.statusCode}");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
    }
  }

  Future<void> fetchDistrict(String? division) async {
    try {
      final response = await http
          .get(Uri.parse('https://bdapis.com/api/v1.1/division/$division'));
      if (response.statusCode == 200) {
        // Parse the JSON response
        final Map<String, dynamic> apiData = json.decode(response.body);
        // if (kDebugMode) {
        //   print(apiData["data"]);
        // }
        print(apiData["data"]);

        for (var i = 0; i < apiData["data"].length; i++) {
          print(apiData["data"][i]["district"]);
          districtDropdown.add(apiData["data"][i]["district"]);
          print(districtDropdown);
        }
      } else {
        if (kDebugMode) {
          print("Request failed with status: ${response.statusCode}");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDivision();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double getHeight(int pixel) {
      double x = pixel / 1000;
      final height = x * MediaQuery.of(context).size.height;
      // print(height);

      return height;
    }

    double getWidth(int pixel) {
      double x = pixel / 1000;
      final width = x * MediaQuery.of(context).size.width;
      // print(width);

      return width;
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        // shadowColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      resizeToAvoidBottomInset: true,
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: getWidth(40),
          vertical: getHeight(20),
        ),
        margin: EdgeInsets.only(
          top: getHeight(35),
          left: getWidth(40),
          right: getWidth(40),
        ),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Welcome to our Community",
                style: TextStyle(
                  fontSize: getHeight(27),
                  fontWeight: FontWeight.bold,
                  letterSpacing: getHeight(2),
                ),
              ),

              Gap(getHeight(20)),
              TextField(
                controller: firstName,
                onSubmitted: (value) {},
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'First Name',
                ),
              ),
              Gap(getHeight(27)),
              TextField(
                controller: lastName,
                onSubmitted: (value) {},
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Last Name',
                ),
              ),
              Gap(getHeight(27)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width * 0.39,
                    child: Center(
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              width: getHeight(2),
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        borderRadius: BorderRadius.circular(20),
                        hint: const Text("Division"),
                        value: selectedDivision, // Set the selected value
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: getHeight(20),
                          fontFamily: "Lato",
                          fontWeight: FontWeight.w500,
                          overflow: TextOverflow.visible,
                        ),

                        items: divisionDropdown.map((option) {
                          return DropdownMenuItem<String>(
                            value: option,
                            child: Text(option),
                          );
                        }).toList(),
                        onChanged: (value) {
                          // fetchDistrict(value);

                          setState(() {
                            division.clear();
                            district.clear();
                            fetchDistrict(value);
                            selectedDistrict = "District";
                            districtDropdown.clear();
                            districtDropdown.add("District");
                            division.text += value!;
                            selectedDivision =
                                value; // Update the selected value
                          });
                          if (kDebugMode) {
                            print("The value is ${division.text}");
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.07,
                    width: MediaQuery.of(context).size.width * 0.39,
                    child: Center(
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(getHeight(10)),
                            borderSide: BorderSide(
                              width: getWidth(2),
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        borderRadius: BorderRadius.circular(getHeight(20)),
                        hint: const Text("District"),
                        value: selectedDistrict, // Set the selected value
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: getHeight(20),
                          fontFamily: "Lato",
                          fontWeight: FontWeight.w500,
                          overflow: TextOverflow.visible,
                        ),

                        items: districtDropdown.map((option) {
                          return DropdownMenuItem<String>(
                            value: option,
                            child: Text(option),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            district.clear();
                            district.text += value!;
                            selectedDistrict =
                                value; // Update the selected value
                          });
                          if (kDebugMode) {
                            print("The value is ${district.text}");
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Gap(getHeight(27)),
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
                  // setState(() {
                  //   validateEmail(emailControler.text) == true
                  //       ? validmail = true
                  //       : validmail = false;
                  // });
                },
              ),
              Gap(getHeight(27)),
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
                      passwordControler.text == conformPasswordcontroler.text
                          ? passwordsMatch = true
                          : passwordsMatch = false;
                    },
                  );
                },
              ),
              Gap(getHeight(27)),
              TextField(
                onChanged: (value) {
                  setState(
                    () {
                      passwordControler.text == conformPasswordcontroler.text
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
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Checkbox(
                    splashRadius: BorderSide.strokeAlignInside,
                    value: termConditionCheckBox,
                    onChanged: (bool? value) {
                      if (value != null) {
                        setState(() {
                          termConditionCheckBox = value;
                        });
                      }
                    },
                  ),
                  const Text("I agree with the "),
                  InkWell(
                    onTap: () {},
                    child: const Text(
                      "Terms & Condition",
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  )
                ],
              ),
              Gap(getHeight(27)),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(double.maxFinite, getHeight(60)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(getHeight(20)),
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
                        emailControler.text,
                        passwordControler.text,
                      );
                      if (result != null) {
                        conformPasswordcontroler.clear();
                        passwordControler.clear();
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => EmailVerification(
                        //         mail: emailControler.text,
                        //         durationInMinutes: 2),
                        //   ),
                        // );
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
                                    // Navigator.pop(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (context) =>
                                    //         const LoginScreen(),
                                    //   ),
                                    // );
                                  },
                                  child: const Text(
                                    "Login ->",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w800),
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
                child: Text(
                  "Submit",
                  style: TextStyle(
                    fontSize: getHeight(25),
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
                    padding: EdgeInsets.symmetric(
                        vertical: getHeight(15), horizontal: getHeight(10)),
                    child: InkWell(
                      onTap: () {
                        conformPasswordcontroler.clear();
                        passwordControler.clear();
                        emailControler.clear();
                        // Navigator.pop(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => const LoginScreen(),
                        //   ),
                        // );
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
    );
  }
}
