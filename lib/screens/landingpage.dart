import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_details/models/card.dart';
import 'package:flutter_details/services/auth_service.dart';
import 'package:gap/gap.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  String currentTime = '';
  String greeting = '';
  Timer? _timeUpdateTimer;
  Timer? _greetingUpdateTimer;

  @override
  void initState() {
    super.initState();
    _updateTime();
    _updateGreeting();
  }

  void _updateTime() {
    setState(() {
      currentTime = _getCurrentTime();
    });

    _timeUpdateTimer = Timer(const Duration(seconds: 1), _updateTime);
  }

  String _getCurrentTime() {
    DateTime now = DateTime.now();
    String amPm = now.hour < 12 ? 'AM' : 'PM';
    int hour = now.hour % 12;
    if (hour == 0) {
      hour = 12;
    }
    return '${hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')} $amPm';
  }

  void _updateGreeting() {
    setState(() {
      greeting = _getGreeting();
    });

    _greetingUpdateTimer = Timer(const Duration(minutes: 1), _updateGreeting);
  }

  @override
  void dispose() {
    _timeUpdateTimer?.cancel();
    _greetingUpdateTimer?.cancel();
    super.dispose();
  }

  String _getGreeting() {
    DateTime now = DateTime.now();
    String greetingText = '';

    if (now.hour >= 0 && now.hour < 12) {
      greetingText = 'Good Morning';
    } else if (now.hour >= 12 && now.hour < 17) {
      greetingText = 'Good Afternoon';
    } else if (now.hour >= 17 && now.hour < 21) {
      greetingText = 'Good Evening';
    } else {
      greetingText = 'Good Night';
    }

    return greetingText;
  }

  @override
  Widget build(BuildContext context) {
    List<String> sensors = ['N', 'P', 'K', 'Mosture'];
    List<double> value = [78.2, 234, 123, 78];
    return Scaffold(
      body: SafeArea(
        // ignore: sized_box_for_whitespace
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                //top part
                Material(
                  elevation: 4,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                  child: Container(
                    width: double.infinity,
                    height: 200,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                      ),
                      // color: Colors.grey,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                greeting,
                                style: const TextStyle(
                                  fontFamily: 'Lato',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                  color: Colors.grey,
                                ),
                              ),
                              Column(
                                children: [
                                  Icon(
                                    Icons.sunny,
                                    size: 40,
                                    color: Colors.yellow.shade900,
                                  ),
                                  const Text(
                                    "Sunny",
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.grey,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                          const Gap(5),
                          const Text(
                            "Mr. Tangim Haque",
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: Colors.white,
                            ),
                          ),
                          const Gap(35),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Sunny, 40°C",
                                style: TextStyle(
                                  fontFamily: "Lato",
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                currentTime,
                                style: const TextStyle(
                                  fontFamily: "Lato",
                                  fontSize: 17,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                //top part finised

                Container(
                  padding: const EdgeInsets.all(16),
                  child: GridView.builder(
                    shrinkWrap: true,

                    itemCount: 4, // Number of rows
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Number of items in each row
                      crossAxisSpacing:
                          10, // Spacing between items horizontally
                      mainAxisSpacing: 10, // Spacing between items vertically
                    ),
                    itemBuilder: (context, index) {
                      return NpkCard(
                        cardname: sensors[index],
                        cardvalue: value[index],
                      );
                    },
                  ),
                ),
                //card part finised
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Score "),
                      LinearPercentIndicator(
                        width: 250,
                        trailing: const Text("20"),
                        lineHeight: 10,
                        percent: 0.5,
                        progressColor: Colors.deepPurple,
                        backgroundColor: Colors.deepPurple.shade200,
                        barRadius: const Radius.circular(20),
                        animation: true,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    onPressed: () async {
                      AuthService authService = AuthService();
                      await authService.signOut().then(
                            (result) => Navigator.of(context).pop(),
                          );
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text("Logout"),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
