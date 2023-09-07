import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_details/models/card.dart';
import 'package:flutter_details/models/error.dart';
import 'package:flutter_details/services/auth_service.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  Timer? timer;
  StreamController<List<dynamic>> dataStreamController =
      StreamController<List<dynamic>>();
  List<String> sensors = ['N', 'P', 'K', 'Mosture'];

  List<dynamic> value = [255.0, 255.0, 255.0, 100.0, 0.0, 0.0, "", ""];
  String currentTime = '';
  String greeting = '';
  Timer? _timeUpdateTimer;
  Timer? _greetingUpdateTimer;

  @override
  void initState() {
    super.initState();
    _updateTime();
    _updateGreeting();
    fetchData(); // Initial data fetch
    // Set up a periodic timer to fetch data every x seconds
    timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      fetchData();
    });
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
    timer?.cancel(); // Cancel the timer when the widget is disposed
    dataStreamController.close(); // Close the stream controller
    super.dispose();
  }

  String _getGreeting() {
    DateTime now = DateTime.now();
    if (kDebugMode) {
      print(now.hour);
    }
    String greetingText = '';

    if (now.hour >= 5 && now.hour < 12) {
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

  

  Future<void> fetchData() async {
    String formatUnixTimestampToAMPM(double unixTimestamp) {
      // Convert the Unix timestamp to milliseconds (assuming it's in seconds)
      int millisecondsSinceEpoch = (unixTimestamp * 1000).round();

      // Create a DateTime object from the milliseconds since epoch
      DateTime dateTime =
          DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);

      // Format the DateTime object to AM/PM format
      String formattedDateTime =
          DateFormat('MMM dd, yyyy hh:mm a').format(dateTime);

      return formattedDateTime;
    }

    List<String> key = [
      "nitrogen",
      "phosphorus",
      "potassium",
      "moisture_level",
      "temperature",
      "humidity",
      "timestamp"
    ];
    try {
      final response =
          await http.get(Uri.parse('https://smartirrigation.cloud/readings'));

      if (response.statusCode == 200) {
        // Parse the JSON response
        final List<dynamic> apiData = json.decode(response.body);

        if (apiData.isNotEmpty) {
          Map<String, dynamic> apiValues = apiData.last;

          final List<String> dateandtime =
              (formatUnixTimestampToAMPM(apiValues[key[6]])).split(" ");
          String date = "";
          String time = "";
          int counter = 0;

          for (String value in dateandtime) {
            if (counter < 3) {
              date += value;
              date += " ";
              counter++;
            } else {
              time += value;
              time += " ";
            }
          }
          if (kDebugMode) {
            print("Date: $date");
          }
          if (kDebugMode) {
            print("TIme: $time");
          }
// [Jun, 24,, 2023, 07:28, PM]
          // ignore: unrelated_type_equality_checks
          if (value != apiValues) {
            setState(() {
              value[0] = (apiValues[key[0]]).toDouble();
              value[1] = (apiValues[key[1]]).toDouble();
              value[2] = (apiValues[key[2]]).toDouble();
              value[3] = (apiValues[key[3]]).toDouble();
              value[4] = (apiValues[key[4]]).toDouble();
              value[5] = (apiValues[key[5]]).toDouble();
              value[6] = date;
              value[7] = time;
            });

            // if (kDebugMode) {
            //   print("Nitrogen: ${(apiValues[key[0]])}");
            // }
            // if (kDebugMode) {
            //   print("Phosphorus: ${apiValues[key[1]]}");
            // }
            // if (kDebugMode) {
            //   print("Potasium: ${(apiValues[key[2]]).toDouble().runtimeType}");
            // }
            if (kDebugMode) {
              print(value);
            }

            dataStreamController.add(value);
          } else {
            return;
          }
        } else {
          if (kDebugMode) {
            print(
                "HTTP request failed with status code ${response.statusCode}");
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error during HTTP request: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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

                StreamBuilder<List<dynamic>>(
                    stream: dataStreamController.stream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        if (kDebugMode) {
                          print(snapshot.connectionState);
                        }
                        return Column(
                          children: [
                            Row(
                              children: [
                                const Text("Data Date: "),
                                Text(value[7]),
                                const Text("Time: "),
                                Text(value[7])
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.all(16),
                              child: GridView.builder(
                                shrinkWrap: true,

                                itemCount: 4, // Number of rows
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:
                                      2, // Number of items in each row
                                  crossAxisSpacing:
                                      10, // Spacing between items horizontally
                                  mainAxisSpacing:
                                      10, // Spacing between items vertically
                                ),
                                itemBuilder: (context, index) {
                                  return NpkCard(
                                    cardname: sensors[index],
                                    cardvalue: value[index],
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      } else if (snapshot.hasData) {
                        try {
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 20.0, left: 20, right: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  // crossAxisAlignment: ,
                                  children: [
                                    Row(
                                      children: [
                                        const Text("Date: "),
                                        Text(value[6]),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text("Time: "),
                                        Text(value[7]),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(16),
                                child: GridView.builder(
                                  shrinkWrap: true,

                                  itemCount: 4, // Number of rows
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:
                                        2, // Number of items in each row
                                    crossAxisSpacing:
                                        10, // Spacing between items horizontally
                                    mainAxisSpacing:
                                        10, // Spacing between items vertically
                                  ),
                                  itemBuilder: (context, index) {
                                    return NpkCard(
                                      cardname: sensors[index],
                                      cardvalue: value[index],
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        } catch (e) {
                          return const ErrorBox(
                            text: "No Data Available",
                          );
                        }
                      } else if (snapshot.hasError) {
                        return ErrorBox(text: 'Error: ${snapshot.error}');
                      } else {
                        return const CircularProgressIndicator(); // Loading indicator while fetching data
                      }
                    }),

                //card part finised
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Temperature: ",
                              style: TextStyle(
                                fontSize: 19,
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "${value[4].toStringAsFixed(2)}° C",
                              style: const TextStyle(
                                fontSize: 19,
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                      ),
                      const Gap(20),
                      SizedBox(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Humidity: ",
                              style: TextStyle(
                                fontSize: 19,
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "${value[5].toStringAsFixed(2)}%",
                              style: const TextStyle(
                                fontSize: 19,
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                      )
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
