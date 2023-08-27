import 'package:flutter/material.dart';
import 'package:flutter_details/models/datepicker.dart';

class Popup extends StatefulWidget {
  const Popup({super.key});

  @override
  State<Popup> createState() => _PopupState();
}

class _PopupState extends State<Popup> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Download",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    letterSpacing: 2,
                    wordSpacing: 2,
                  ),
            ),
            IconButton(
              enableFeedback: true,
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.close),
              color: Colors.red, // Adjust the icon color as needed
              tooltip: 'Close',
              splashRadius: 10.0,
              iconSize: 30.0,
            )
          ],
        ),
        content: SizedBox(
          // alignment: Alignment.topCenter,
          height: 270,
          width: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const MyDatePickerScreen(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 3,
                      minimumSize: const Size(double.infinity, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text("Download"),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
