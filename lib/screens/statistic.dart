import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_details/models/bargraph.dart';
import 'package:flutter_details/models/error.dart';
import 'package:flutter_details/models/piechart.dart';
import 'package:flutter_details/screens/showdialog.dart';
import 'package:gap/gap.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Statistic extends StatefulWidget {
  const Statistic({Key? key}) : super(key: key);

  @override
  State<Statistic> createState() => _StatisticState();
}

class _StatisticState extends State<Statistic> {
  Set<String> value = <String>{};
  Timer? timer;
  Set<String> timevalue = <String>{};
  Map<String, dynamic> id = {};
  @override
  void initState() {
    super.initState();

    // fetchData(); // Initial data fetch
  }

  Map<String, dynamic> lastval = {};
  Future<Map<String, dynamic>> matcher(String dropdownValue) async {
    final response =
        await http.get(Uri.parse('https://smartirrigation.cloud/readings'));

    if (response.statusCode == 200) {
      // Parse the JSON response
      final List<dynamic> apiData = json.decode(response.body);
      if (dropdownValue.isNotEmpty) {
        String selectedID = id[dropdownValue];

        Map<String, dynamic> matchingObject = {};
        for (var apiObject in apiData) {
          String apiID = apiObject["_id"];
          // print("APi and Selectedtime : $apiTimestamp & $selectedTime");
          if (apiID == selectedID) {
            matchingObject = apiObject;
            break; // Exit the loop when a matching object is found
          }
        }
        if (matchingObject.isNotEmpty) {
          // The matchingObject variable now contains the object with the matching timestamp
          if (kDebugMode) {
            print("Matching Object: $matchingObject");
          }
          return matchingObject;
        } else {
          if (kDebugMode) {
            print("No matching object found.");
          }
          return {
            "nitrogen": 0.0,
            "phosphorus": 0.0,
            "potassium": 0.0,
            "moisture_level": 0.0,
          };
        }
      } else {
        if (kDebugMode) {
          print("Drop down empty.");
        }
        Map<String, dynamic> apiValues = apiData.last;
        if (kDebugMode) {
          print(apiValues);
        }
        return apiValues;
      }
    } else {
      if (kDebugMode) {
        print("No matching object found.");
      }
      return {
        "nitrogen": 1.0,
        "phosphorus": 1.0,
        "potassium": 1.0,
        "moisture_level": 1.0,
      };
    }
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

    List<String> key = ["timestamp"];

// [Jun, 24,, 2023, 07:28, PM]
    try {
      final response =
          await http.get(Uri.parse('https://smartirrigation.cloud/readings'));

      if (response.statusCode == 200) {
        // Parse the JSON response
        final List<dynamic> apiData = json.decode(response.body);

        if (apiData.isNotEmpty) {
          int apiLenght = apiData.length;
          Map<String, dynamic> apiValues = apiData.last;
          lastval[key[0]] = apiValues[key[0]].round();

          for (var i = 0; i < apiLenght; i++) {
            Map<String, dynamic> apiValues = apiData[i];
            final List<String> dateandtime =
                (formatUnixTimestampToAMPM(apiValues[key[0]])).split(" ");
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
            if (i > 0 && value.last != date) {
              // setState(() {
              value.add(date);
              // });
            } else if (i == 0) {
              // setState(() {
              value.add(date);
              // });
            }
            // setState(() {
            timevalue.add(time);

            id["$date$time"] = apiValues["_id"];
            // });
          }
          // Get the app's documents directory

          if (kDebugMode) {
            print(id);
          }
        } else {
          return;
        }
      } else {
        if (kDebugMode) {
          print("HTTP request failed with status code ${response.statusCode}");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error during HTTP request: $e");
      }
    }
  }

  String dropdownValue = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "History",
          style: TextStyle(
            fontFamily: "Lato",
            fontSize: 30,
            fontWeight: FontWeight.w500,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              
              child: CircularProgressIndicator(),
            );
          } else {
            try {
              return SafeArea(
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              DropdownButton<String>(
                                hint: const Text("Date"),

                                icon: const Icon(Icons.arrow_downward),
                                style: const TextStyle(
                                    color:
                                        Colors.white), // Changed the text color
                                underline: Container(
                                  height: 2,
                                  color: Colors.white,
                                ),
                                onChanged: (value) {
                                  // setState(() {
                                  dropdownValue = "";
                                  dropdownValue += value!;
                                  // });
                                },
                                items: value.map((option) {
                                  return DropdownMenuItem<String>(
                                    value: option,
                                    child: Text(option),
                                  );
                                }).toList(),
                              ),
                              DropdownButton<String>(
                                hint: const Text("Time"),

                                icon: const Icon(Icons.arrow_downward),
                                style: const TextStyle(
                                    color:
                                        Colors.white), // Changed the text color
                                underline: Container(
                                  height: 2,
                                  color: Colors.white,
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    dropdownValue += value!;
                                    matcher(dropdownValue);
                                  });
                                  if (kDebugMode) {
                                    print("The value is $dropdownValue");
                                  }
                                },

                                items: timevalue.map((option) {
                                  return DropdownMenuItem<String>(
                                    value: option,
                                    child: Text(option),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                          const Gap(40),
                          FutureBuilder(
                            future: matcher(dropdownValue),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (snapshot.data != null) {
                                try {
                                  return Column(
                                    children: [
                                      SizedBox(
                                        height: 300,
                                        width: double.maxFinite,
                                        child: BarChartSample3(
                                          n: snapshot.data?["nitrogen"]
                                              .toDouble(),
                                          k: snapshot.data?["potassium"]
                                              .toDouble(),
                                          p: snapshot.data?["phosphorus"]
                                              .toDouble(),
                                        ),
                                      ),
                                      Text(
                                        "Mosture Level: ${snapshot.data?["moisture_level"].toStringAsFixed(2)}%",
                                        style:
                                            const TextStyle(letterSpacing: 1),
                                      ),
                                      const Gap(20),
                                      ElevatedButton(
                                          onPressed: () {
                                            showDialog(
                                                barrierDismissible: false,
                                                context: context,
                                                builder: (context) {
                                                  return const Popup();
                                                });
                                          },
                                          style: ElevatedButton.styleFrom(
                                            minimumSize: const Size(300, 50),
                                            elevation: 4,
                                          ),
                                          child: const Text(
                                            "Download Data",
                                            style: TextStyle(letterSpacing: 2),
                                          )),
                                      const Gap(50),
                                      const Text(
                                        "Overall Soil Result",
                                        style: TextStyle(
                                          fontFamily: "Lato",
                                          wordSpacing: 2,
                                          fontSize: 25,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          PieChartSample2(
                                            n: snapshot.data?["nitrogen"]
                                                .toDouble(),
                                            p: snapshot.data?["phosphorus"]
                                                .toDouble(),
                                            k: snapshot.data?["potassium"]
                                                .toDouble(),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const Text(
                                                    "Temperature: ",
                                                    style: TextStyle(
                                                      fontSize: 19,
                                                      fontFamily: 'Lato',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    "${snapshot.data?["temperature"].toStringAsFixed(2)}° C",
                                                    style: const TextStyle(
                                                      fontSize: 19,
                                                      fontFamily: 'Lato',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            const Gap(20),
                                            SizedBox(
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const Text(
                                                    "Humidity: ",
                                                    style: TextStyle(
                                                      fontSize: 19,
                                                      fontFamily: 'Lato',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    "${snapshot.data?["humidity"].toStringAsFixed(2)}%",
                                                    style: const TextStyle(
                                                      fontSize: 19,
                                                      fontFamily: 'Lato',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                } catch (e) {
                                  return const Center(
                                    child: Text("No Data Found"),
                                  );
                                }
                              } else {
                                return const Text("No Data Found");
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } catch (e) {
              return const Center(
                  child: ErrorBox(text: "No History Available"));
            }
          }
        },
      ),
    );
  }
}
