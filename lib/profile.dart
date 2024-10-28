// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:line_awesome_flutter/line_awesome_flutter.dart';
// import 'package:flutter_application_1/login.dart';
// import 'package:flutter_application_1/Changepassword.dart';

// const double kSpacingUnit = 10;
// const Color kDarkPrimaryColor = Color.fromARGB(255, 255, 255, 255);

// // Define kTitleTextStyle
// const TextStyle kTitleTextStyle = TextStyle(
//   fontSize: 20,
//   fontWeight: FontWeight.bold,
// );

// // Define kCaptionTextStyle and kButtonTextStyle
// const TextStyle kCaptionTextStyle = TextStyle(
//   fontSize: 16,
//   color: Colors.grey,
// );

// const TextStyle kButtonTextStyle = TextStyle(
//   fontSize: 16,
//   color: Colors.white,
//   fontWeight: FontWeight.bold,
// );

// class ProfilePage extends StatefulWidget {

//   const ProfilePage({Key? key,}) : super(key: key);

//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }

// class _ProfilePageState extends State<ProfilePage> {

//   void _logout() {
//     Navigator.of(context).pushReplacement(
//       MaterialPageRoute(
//         builder: (context) => Login(), // Your login page widget
//       ),
//     );
//   }

//   void _changePassword() {
//     Navigator.of(context).pushReplacement(
//       MaterialPageRoute(
//         builder: (context) => ChangePasswordPage(), // Your login page widget
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     ScreenUtil.init(context, designSize: Size(414, 896));

//     var profileInfo = Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: [
//         Container(
//           height: kSpacingUnit.w * 12, // Adjusted height
//           width: kSpacingUnit.w * 12, // Adjusted width
//           margin: EdgeInsets.only(top: kSpacingUnit.w * 5),
//           child: Stack(
//             children: [
//               CircleAvatar(
//                 radius: kSpacingUnit.w * 6, // Adjusted radius
//                 backgroundImage: AssetImage('lib/assets/catmeem.jpg'),
//               ),
//               Align(
//                 alignment: Alignment.bottomRight,
//                 child: Container(
//                   height: kSpacingUnit.w * 3, // Size for the pen icon container
//                   width: kSpacingUnit.w * 3, // Size for the pen icon container
//                   decoration: BoxDecoration(
//                     color: Theme.of(context).colorScheme.secondary,
//                     shape: BoxShape.circle,
//                   ),
//                   child: Icon(
//                     LineAwesomeIcons.pen,
//                     color: kDarkPrimaryColor,
//                     size: ScreenUtil().setSp(kSpacingUnit.w * 1.5),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         SizedBox(height: kSpacingUnit.w * 2),
//         Text('Geust', style: kTitleTextStyle),
//         SizedBox(height: kSpacingUnit.w * 0.5),
//       ],
//     );
//     return Scaffold(
//       appBar: AppBar(
//         title: Padding(
//           padding: EdgeInsets.only(top: 20.0), // Adjust top padding as needed
//           child: Text(
//             'Profile',
//             style: kTitleTextStyle.copyWith(fontSize: 26.0), // Increase font size as needed
//           ),
//         ),
//         centerTitle: true, // This centers the title
//         automaticallyImplyLeading: false, // Remove the back arrow
//       ),
//       body: Padding(
//         padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0), // Adjust vertical and horizontal padding as needed
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center, // Align children in the center
//           children: <Widget>[
//             profileInfo,
//             SizedBox(height: kSpacingUnit.w * 3), // Add additional space between profileInfo and buttons
//             Expanded(
//               child: ListView(
//                 children: <Widget>[
//                   ProfileListItem(
//                     icon: LineAwesomeIcons.pen_fancy,
//                     text: 'Change Password',
//                     hasNavigation: true,
//                     onTap: _changePassword,
//                   ),
//                   SizedBox(height: kSpacingUnit.w * 0), // Add space between buttons
//                   ProfileListItem(
//                     icon: LineAwesomeIcons.alternate_sign_out, // Icon for "Logout"
//                     text: 'Logout',
//                     hasNavigation: true,
//                     onTap: _logout,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


// class ProfileListItem extends StatelessWidget {
//   final IconData icon;
//   final String text;
//   final bool hasNavigation;
//   final VoidCallback? onTap;

//   const ProfileListItem({
//     super.key,
//     required this.icon,
//     required this.text,
//     this.hasNavigation = false,
//     this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         height: kSpacingUnit.w * 5.5,
//         margin: EdgeInsets.symmetric(
//           horizontal: kSpacingUnit.w * 4,
//         ).copyWith(
//           bottom: kSpacingUnit.w * 2,
//         ),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(kSpacingUnit.w * 3),
//           color: Theme.of(context).colorScheme.background,
//         ),
//         child: Row(
//           children: <Widget>[
//             Icon(
//               this.icon,
//               size: kSpacingUnit.w * 2.5,
//             ),
//             SizedBox(width: kSpacingUnit.w * 2.5),
//             Text(
//               this.text,
//               style: kTitleTextStyle.copyWith(
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             Spacer(),
//             if (this.hasNavigation)
//               Icon(
//                 LineAwesomeIcons.angle_right,
//                 size: kSpacingUnit.w * 2.5,
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
