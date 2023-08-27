import 'package:flutter/material.dart';
import 'package:flutter_details/models/bargraph.dart';
import 'package:flutter_details/models/piechart.dart';
import 'package:flutter_details/screens/showdialog.dart';
import 'package:gap/gap.dart';

class Statistic extends StatefulWidget {
  const Statistic({Key? key}) : super(key: key);

  @override
  State<Statistic> createState() => _StatisticState();
}

class _StatisticState extends State<Statistic> {
  List<String> options = ["Option 1", "Option 2", "Option 3"];

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
      body: SafeArea(
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // const Text(
                  //   "Charts of all data",
                  //   style: TextStyle(
                  //     fontFamily: "Lato",
                  //     fontSize: 30,
                  //     fontWeight: FontWeight.w700,
                  //   ),
                  // ),
                  // const Gap(30),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DropdownButton<String>(
                        hint: const Text("Date"),

                        icon: const Icon(Icons.arrow_downward),
                        style: const TextStyle(
                            color: Colors.white), // Changed the text color
                        underline: Container(
                          height: 2,
                          color: Colors.white,
                        ),
                        onChanged: (value) {
                          setState(() {
                            dropdownValue = value!;
                          });
                        },
                        items: options.map((option) {
                          return DropdownMenuItem<String>(
                            value: option,
                            child: Text(option),
                          );
                        }).toList(),
                      ),
                      DropdownButton<String>(
                        hint: const Text("Month"),

                        icon: const Icon(Icons.arrow_downward),
                        style: const TextStyle(
                            color: Colors.white), // Changed the text color
                        underline: Container(
                          height: 2,
                          color: Colors.white,
                        ),
                        onChanged: (value) {
                          setState(() {
                            dropdownValue = value!;
                          });
                        },
                        items: options.map((option) {
                          return DropdownMenuItem<String>(
                            value: option,
                            child: Text(option),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  const Gap(40),
                  const SizedBox(
                    height: 300,
                    width: double.maxFinite,
                    child: BarChartSample3(),
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
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      PieChartSample2(),
                      Text(
                        "Mosture Level: 60%",
                        style: TextStyle(letterSpacing: 1),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
