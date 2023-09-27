import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_details/models/otpbox.dart';


class OtpVerification extends StatefulWidget {
  final int durationInMinutes;
  final String phoneNumber;
  const OtpVerification(
      {Key? key, required this.phoneNumber, required this.durationInMinutes})
      : super(key: key);

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  late Timer _timer;
  late int _remainingSeconds;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.durationInMinutes * 60;

    // Start the timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        // Timer expired, cancel the timer
        _timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  String _formatDuration(int durationInSeconds) {
    int minutes = durationInSeconds ~/ 60;
    int seconds = durationInSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: double.maxFinite,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Verification Code",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text("We have sent the code verification to"),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(widget.phoneNumber),
                    InkWell(
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => const RegisterScreen(),
                        //   ),
                        // );
                      },
                      child: const Text(
                        "Change the phone number?",
                        style: TextStyle(color: Colors.blue),
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text("Resend Code after: "),
                    Text(_formatDuration(_remainingSeconds))
                  ],
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: const OtpBox(),
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor:
                              const Color.fromARGB(255, 97, 101, 107),
                          minimumSize: const Size(50, 40),
                        ),
                        onPressed: _remainingSeconds > 0 ? null : () {},
                        child: Text(
                          _remainingSeconds > 0
                              ? "Resend ($_remainingSeconds)"
                              : "Resend",
                          style: TextStyle(
                            color: _remainingSeconds > 0
                                ? Colors.grey
                                : Colors.white,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor:
                              const Color.fromARGB(255, 19, 85, 201),
                          minimumSize: const Size(50, 40),
                        ),
                        onPressed: () {},
                        child: const Text(
                          "Confirm",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
