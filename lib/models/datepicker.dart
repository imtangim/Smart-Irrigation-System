// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class MyDatePickerScreen extends StatefulWidget {
  const MyDatePickerScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<MyDatePickerScreen> createState() => _MyDatePickerScreenState();
}

class _MyDatePickerScreenState extends State<MyDatePickerScreen> {
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();
  List<String> selectedDates = [];
  bool isChecked = false;
  bool csvIsChecked = false;
  bool jsonIsChecked = false;
  bool excelIsChecked = false;

  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: fromDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != fromDate) {
      setState(() {
        fromDate = picked;
      });
    }
  }

  Future<void> _selectToDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: toDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != toDate) {
      setState(() {
        toDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Format the selected dates using DateFormat
    final DateFormat dateFormatter = DateFormat('yyyy-MM-dd');

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Column(
          children: [
            SizedBox(
              height: 100,
              width: 300,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "From:",
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          letterSpacing: 2,
                          wordSpacing: 2,
                        ),
                      ),
                      Text(
                        "To:",
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          letterSpacing: 2,
                          wordSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: isChecked ? Colors.grey : null,
                          minimumSize: const Size(10, 40),
                          elevation: 2,
                        ),
                        onPressed: () {
                          setState(() {
                            isChecked ? null : _selectFromDate(context);
                          });
                        },
                        child: Text(
                          dateFormatter.format(fromDate).toString(),
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: isChecked ? Colors.grey : null,
                          minimumSize: const Size(10, 40),
                          elevation: 2,
                        ),
                        onPressed: () =>
                            isChecked ? null : _selectToDate(context),
                        child: Text(
                          dateFormatter.format(toDate).toString(),
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Gap(10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              textBaseline: TextBaseline.ideographic,
              children: [
                Checkbox(
                  splashRadius: BorderSide.strokeAlignInside,
                  value: isChecked,
                  onChanged: (bool? value) {
                    if (value != null) {
                      setState(() {
                        isChecked = value;
                      });
                    }
                  },
                ),
                const Gap(10),
                const Text(
                  "Download All",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2,
                    wordSpacing: 2,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Checkbox(
                  splashRadius: BorderSide.strokeAlignInside,
                  value: excelIsChecked,
                  onChanged: (bool? value) {
                    if (value != null) {
                      setState(() {
                        excelIsChecked = value;
                      });
                    }
                  },
                ),
                const Text("Excel"),
                Checkbox(
                  splashRadius: BorderSide.strokeAlignInside,
                  value: csvIsChecked,
                  onChanged: (bool? value) {
                    if (value != null) {
                      setState(() {
                        csvIsChecked = value;
                      });
                    }
                  },
                ),
                const Text("CSV"),
                Checkbox(
                  splashRadius: BorderSide.strokeAlignInside,
                  value: jsonIsChecked,
                  onChanged: (bool? value) {
                    if (value != null) {
                      setState(() {
                        jsonIsChecked = value;
                      });
                    }
                  },
                ),
                const Text("Json"),
              ],
            )
          ],
        ),
      ],
    );
  }
}
