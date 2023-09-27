import 'package:flutter/material.dart';


class EmailVerification extends StatefulWidget {
  final int durationInMinutes;
  final String mail;
  const EmailVerification(
      {Key? key, required this.mail, required this.durationInMinutes})
      : super(key: key);

  @override
  State<EmailVerification> createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.verified),
          const Text(
            "Verification Sent",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text("We have sent the email verification to"),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.mail),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  " Change the email?",
                  style: TextStyle(color: Colors.blue),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: const Color.fromARGB(255, 19, 85, 201),
                ),
                onPressed: () {
                  // Navigator.pop(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => ,
                  //   ),
                  // );
                },
                child: const Text(
                  "Go to Login",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
