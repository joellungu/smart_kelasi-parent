// import 'package:flutter/material.dart';
// import 'package:smart_keslassi_parent/utils/periode.dart';

// class CoursPoints extends StatelessWidget {
//   //
//   Period period;
//   //
//   CoursPoints(this.period);
//   //
//   @override
//   Widget build(BuildContext context) {
//     //
//     return Scaffold(appBar: AppBar(), body: _buildPeriodDetails());
//   }
//   //

//   Widget _buildPeriodDetails() {
//     return Column(
//       children: [
//         _buildPeriodHeader(period),
//         Divider(height: 1),
//         Expanded(
//           child: ListView.separated(
//             padding: EdgeInsets.zero,
//             itemCount: period.courses.length,
//             separatorBuilder: (context, index) => Divider(height: 1),
//             itemBuilder: (context, index) {
//               return _buildCourseItem(period.courses[index], period);
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildPeriodHeader(Period period) {
//     //
//     int pend = 100;
//     //period.name.toLowerCase().contains("exam") ? (100 * 2) : 100;
//     //
//     Color scoreColor =
//         period.score >= period.score / 1.2
//             ? Colors.green
//             : period.score >= period.score / 2
//             ? Colors.blue
//             : Colors.orange;
//     String appreciation =
//         period.score >= period.score / 1.2
//             ? 'Excellent'
//             : period.score >= period.score / 2
//             ? 'Bon travail'
//             : 'Doit progresser';

//     double total =
//         period.name.toLowerCase().contains("exam")
//             ? (period.total * 2)
//             : period.total;

//     double pr = (period.score / total) * pend;

//     return Container(
//       padding: EdgeInsets.all(16),
//       color: Colors.blueGrey[50],
//       child: Row(
//         children: [
//           Container(
//             width: 48,
//             height: 48,
//             decoration: BoxDecoration(
//               color: scoreColor.withOpacity(0.2),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Icon(
//               period.score >= period.score / 1.2
//                   ? Icons.emoji_events
//                   : period.score >= period.score / 2
//                   ? Icons.thumb_up
//                   : Icons.warning,
//               color: scoreColor,
//               size: 28,
//             ),
//           ),
//           SizedBox(width: 16),
//           Expanded(
//             child: _PlaceEleve(),
//             // child: Column(
//             //   crossAxisAlignment: CrossAxisAlignment.start,
//             //   children: [
//             //     Text(
//             //       '${period.startDate.day}/${period.startDate.month} - ${period.endDate.day}/${period.endDate.month}',
//             //       style: TextStyle(color: Colors.blueGrey[600]),
//             //     ),
//             //     SizedBox(height: 4),
//             //     Text(
//             //       'Moyenne générale',
//             //       style: TextStyle(fontWeight: FontWeight.bold),
//             //     ),
//             //   ],
//             // ),
//           ),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Text(
//                 '${pr.toStringAsFixed(1)}/$pend',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: scoreColor,
//                 ),
//               ),
//               Text(appreciation, style: TextStyle(color: Colors.blueGrey[600])),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCourseItem(CourseResult course, Period period) {
//     //
//     //
//     Color scoreColor =
//         course.score >=
//                 (period.name.toLowerCase().contains("exam") ? (85 * 2) : 85)
//             ? Colors.green
//             : course.score >=
//                 (period.name.toLowerCase().contains("exam") ? (70 * 2) : 70)
//             ? Colors.blue
//             : Colors.orange;
//     IconData scoreIcon =
//         course.score >=
//                 (period.name.toLowerCase().contains("exam")
//                     ? ((course.total / 1.2) * 2)
//                     : course.total / 1.2)
//             ? Icons.check_circle
//             : course.score >=
//                 (period.name.toLowerCase().contains("exam")
//                     ? ((course.total / 2) * 2)
//                     : course.total / 2)
//             ? Icons.done
//             : Icons.error_outline;

//     return ListTile(
//       contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       // onTap: () {
//       //   //
//       //   Get.to(CotesHomePage());
//       // },
//       leading: Container(
//         width: 40,
//         height: 40,
//         decoration: BoxDecoration(
//           color: scoreColor.withOpacity(0.1),
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Icon(scoreIcon, color: scoreColor, size: 20),
//       ),
//       title: Text(
//         course.name,
//         style: TextStyle(
//           fontSize: 13,
//           fontWeight: FontWeight.bold,
//           color: Colors.black,
//         ),
//       ),
//       trailing: Container(
//         padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//         decoration: BoxDecoration(
//           color: scoreColor.withOpacity(0.1),
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Text(
//           '${course.score}/${(period.name.toLowerCase().contains("exam") ? (course.total * 2) : course.total)}',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             color: scoreColor,
//             fontSize: 10,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _PlaceEleve() {
//     //

//     return FutureBuilder(
//       future: getPlaceEleve(widget.eleves, widget.eleve['cle']),
//       builder: (c, t) {
//         if (t.hasData) {
//           //
//           place = t.data as int;
//           //
//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 '$place / ${widget.eleves.length}',
//                 style: TextStyle(color: Colors.blueGrey[600]),
//               ),
//               SizedBox(height: 4),
//               Text(
//                 'Moyenne générale',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//             ],
//           );
//         } else if (t.hasError) {
//           return Container();
//         }
//         return Center(
//           child: Container(
//             height: 30,
//             width: 30,
//             child: CircularProgressIndicator(),
//           ),
//         );
//       },
//     );
//   }

//   //
//   Future<int> getPlaceEleve(List eleves, String idEleve) async {
//     //
//     List els = [];
//     //
//     for (Map eleve in eleves) {
//       //
//       double tt = 0.0;
//       double pp = 0.0;
//       //
//       List nn = await notecoursobtenue.getCoursParCat2(
//         cour['niveau'],
//         cour['cycle'],
//         cour['section'],
//         cour['lettre'],
//         widget.eleve['cle'],
//         cour['cle'],
//       );
//       //
//       for (Map c in nn) {
//         //
//         tt = tt + double.parse("${c['total']}");
//         pp = pp + double.parse("${c['point']}");
//         //
//       }
//       els.add({"cle": eleve['cle'], "total": tt, "points": pp});
//     }
//     //
//     els.sort((a, b) => b["points"].compareTo(a["points"]));
//     //
//     // On parcourt la liste pour trouver la position de l'élève
//     for (int i = 0; i < els.length; i++) {
//       if (els[i]["cle"] == idEleve) {
//         return i + 1; // +1 car le rang commence à 1
//       }
//     }

//     // Si l'élève n'est pas trouvé
//     return -1;
//   }
// }
