import 'package:country_flags/country_flags.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'phoneverification.dart';

class PhoneRegistration extends StatefulWidget {
  const PhoneRegistration({super.key});

  @override
  State<PhoneRegistration> createState() => _PhoneRegistrationState();
}

class _PhoneRegistrationState extends State<PhoneRegistration> {
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController district = TextEditingController();
  TextEditingController division = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  List<String> divisionDropdown = [
    "Division",
    "Dhaka",
    "Khulna",
    "Rajsahi",
    "Chattogram"
  ];
  List<String> districtDropdown = [
    "District",
    "Dhaka",
    "Khulna",
    "Rajsahi",
    "Chattogram"
  ];
  bool termConditionCheckBox = false;
  String selectedDivision = "Division";
  String selectedDistrict = "District";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.width * 0.06,
                left: MediaQuery.of(context).size.width * 0.06,
                right: MediaQuery.of(context).size.width * 0.06,
                bottom: 0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Center(
                    child: Text(
                      "Welcome to our community",
                      style: TextStyle(
                        fontSize: 27,
                        fontFamily: "Lato",
                        wordSpacing: 6,
                      ),
                    ),
                  ),
                  const Gap(20),
                  TextField(
                    controller: firstName,
                    onSubmitted: (value) {},
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'First Name',
                    ),
                  ),
                  const Gap(20),
                  TextField(
                    controller: lastName,
                    onSubmitted: (value) {},
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Last Name',
                    ),
                  ),
                  const Gap(20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.07,
                        width: MediaQuery.of(context).size.width * 0.39,
                        child: Center(
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  width: 2,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            borderRadius: BorderRadius.circular(10),
                            hint: const Text("Division"),
                            value: selectedDivision, // Set the selected value
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: "Lato",
                              fontWeight: FontWeight.w500,
                            ),

                            items: divisionDropdown.map((option) {
                              return DropdownMenuItem<String>(
                                value: option,
                                child: Text(option),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                division.text += value!;
                                selectedDivision =
                                    value; // Update the selected value
                              });
                              if (kDebugMode) {
                                print("The value is $selectedDivision");
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
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  width: 2,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            borderRadius: BorderRadius.circular(10),
                            hint: const Text("District"),
                            value: selectedDistrict, // Set the selected value
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: "Lato",
                              fontWeight: FontWeight.w500,
                            ),

                            items: districtDropdown.map((option) {
                              return DropdownMenuItem<String>(
                                value: option,
                                child: Text(option),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                district.text += value!;
                                selectedDistrict =
                                    value; // Update the selected value
                              });
                              if (kDebugMode) {
                                print("The value is $selectedDivision");
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                        width: MediaQuery.of(context).size.width * 0.2,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CountryFlag.fromCountryCode(
                              'bd',
                              height: 20,
                              width: 25,
                            ),
                            const Gap(5),
                            const Text(
                              "+88",
                              style: TextStyle(fontSize: 18),
                            )
                          ],
                        ),
                      ),
                      const Gap(10),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 140,
                        height: MediaQuery.of(context).size.height * 0.07,
                        child: TextField(
                          controller: phoneNumber,
                          keyboardType: TextInputType.phone,
                          onSubmitted: (value) {},
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Mobile number',
                            hintText: "01234-567890",
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.03,
              ),
              child: Row(
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
            ),
            const Gap(20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(180, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () async {
                if (phoneNumber.text != '' &&
                    phoneNumber.text.length == 11 &&
                    firstName.text != '' &&
                    lastName.text != '' &&
                    district.text != "" &&
                    division.text != "" &&
                    district.text != "Division" &&
                    district.text != "District" &&
                    termConditionCheckBox) {
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
                                phoneNumber.text.length < 11 &&
                                    phoneNumber.text.isNotEmpty
                            ? 'Phone Number is not valid'
                            : phoneNumber.text.isEmpty
                                ? 'Phone Number Can\'t be empty'
                                : firstName.text.isEmpty
                                    ? "Must Provide your first name"
                                    : lastName.text.isEmpty
                                        ? "Must Provide your Last Name"
                                        : district.text.isEmpty ||
                                                district.text == "District"
                                            ? "Select your District"
                                            : division.text.isEmpty ||
                                                    division.text == "Division"
                                                ? "Select your Division"
                                                : "Must Agree with our terms and condition",
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text(
                "Register",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Lato",
                  fontSize: 16,
                  wordSpacing: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
