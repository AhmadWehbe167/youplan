// import 'package:flutter/material.dart';
//
// import 'file:///D:/AndroidStudioProjects/youplan/lib/Home_Package/Refactored_Widgets/plan_card.dart';
//
// class PlanCardRequest extends StatelessWidget {
//   final String title;
//   final String type;
//   final DateTime selectedDate;
//   final String place;
//   final String description;
//   final String notes;
//   PlanCardRequest({
//     Key key,
//     this.title,
//     this.type,
//     this.notes,
//     this.description,
//     this.place,
//     this.selectedDate,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(4.0),
//       child: Card(
//         elevation: 7,
//         child: Column(
//           children: [
//             PlanCard(
//               title: title,
//               type: type,
// //              date: selectedDate.toString(),
//               locationDescription: place,
//               isPLan: true,
//               elevate: false,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 FlatButton(
//                   color: Colors.green,
//                   onPressed: () {
//                     print(
//                         'Accept button pressed'); //TODO: Accept the Plan and add it to Home Page
//                   },
//                   child: Text(
//                     'Accept',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//                 FlatButton(
//                   color: Colors.red,
//                   onPressed: () {
//                     print('Reject button pressed'); //TODO:Reject the Plan
//                   },
//                   child: Text(
//                     'Reject',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
