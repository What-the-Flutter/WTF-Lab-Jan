// import 'package:flutter/material.dart';
//
// class RobotBotWidget extends StatefulWidget {
//   const RobotBotWidget({Key key}) : super(key: key);
//
//   @override
//   _RobotBotWidgetState createState() => _RobotBotWidgetState();
// }
//
// class _RobotBotWidgetState extends State<RobotBotWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return RotatedBox(
//       quarterTurns: 3,
//       child: Stack(
//         children: [
//           Container(
//             height: 80,
//             width: 170,
//             color: Colors.transparent,
//             child: Align(
//               alignment: Alignment.bottomCenter,
//               child: GestureDetector(
//                 onTap: () {},
//                 child: Container(
//                   width: 170,
//                   height: 60,
//                   decoration: BoxDecoration(
//                     color: Color(0xFFE95223),
//                     borderRadius: BorderRadius.only(
//                       topRight: Radius.circular(80),
//                       topLeft: Radius.circular(80),
//                     ),
//                   ),
//                   child: Align(
//                       alignment: Alignment.bottomCenter,
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text('Bot Mr. Helper'),
//                       )),
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             left: 40,
//             child: Image.asset(
//               'assets/images/robot.png',
//               width: 85,
//               height: 50,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
