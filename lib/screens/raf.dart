// import 'package:flutter/material.dart';

// class DynamicTextFields extends StatefulWidget {
//   @override
//   _DynamicTextFieldsState createState() => _DynamicTextFieldsState();
// }

// class _DynamicTextFieldsState extends State<DynamicTextFields> {
//   List<Widget> textFields = [];
//   int newIndex = 1;
//   Map<int, GlobalKey> keys = {};

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Column(
//       children: [
//         Expanded(
//           child: ListView.builder(
//             itemCount: textFields.length,
//             itemBuilder: (context, index) => textFields[index],
//           ),
//         ),
//         ElevatedButton(
//           onPressed: () {
//             setState(() {
//               GlobalKey key = GlobalKey(); // Create a unique GlobalKey
//               keys[newIndex] = key; // Store the key with an identifier
//               textFields.add(
//                 Row(
//                   key: key, // Assign the key to the widget
//                   children: [
//                     Text(
//                       "$newIndex.",
//                       style: const TextStyle(fontSize: 20),
//                     ),
//                     const SizedBox(width: 10),
//                     Expanded(
//                       child: Column(
//                         children: [
//                           TextField(
//                             onSubmitted: (value) {},
//                             decoration: const InputDecoration(
//                               border: OutlineInputBorder(),
//                               labelText: 'Device ID',
//                             ),
//                           ),
//                           const SizedBox(height: 10),
//                           TextField(
//                             onSubmitted: (value) {},
//                             decoration: const InputDecoration(
//                               border: OutlineInputBorder(),
//                               labelText: 'Shade Name',
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     ElevatedButton(
//                       onPressed: () {
//                         setState(() {
//                           int indexToRemove = keys.keys.firstWhere(
//                             (k) => keys[k] == key,
//                             orElse: () => -1,
//                           );

//                           if (indexToRemove > textFields.length - 1) {
//                             int tempindex = textFields.length - 1;

//                             keys.remove(tempindex);
//                             textFields.removeAt(tempindex);
//                           } else {
//                             if (indexToRemove != -1) {
//                               keys.remove(indexToRemove);
//                               textFields.removeAt(
//                                   indexToRemove); // Adjust for the row itself
//                             }
//                           }
//                         });
//                       },
//                       style: ElevatedButton.styleFrom(
//                         shape: const CircleBorder(side: BorderSide.none),
//                       ),
//                       child: const Icon(Icons.remove),
//                     ),
//                   ],
//                 ),
//               );
//               newIndex++;
//             });
//           },
//           style: ElevatedButton.styleFrom(
//             shape: const CircleBorder(side: BorderSide.none),
//           ),
//           child: const Icon(Icons.add),
//         ),
//       ],
//     ));
//   }
// }
