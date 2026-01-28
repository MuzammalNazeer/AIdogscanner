import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


class Utils {
  static void fieldFocusChange(
      BuildContext context, FocusNode current, FocusNode nextFocus) {
    current.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  static void toastMessage(String message, {Color color = Colors.black}) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: color,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 4,
    );
  }
  static void showCustomerDialog(BuildContext context, bool check) {
    showDialog(
      context: context,
      builder: (context) =>  AlertDialog(
        icon: check
            ? const Icon(Icons.check_circle, color: Colors.green, size: 44,)
            : const Icon(Icons.error, color: Colors.red, size: 44,),
        title: Text(check ? "Success" : "Error", style: const
        TextStyle(color: Colors.black, fontSize: 28)),
        content: Text(
          check
              ? "Your document was successfully sent to the other signers."
              " Please wait for the other signers to sign the document."
              : "An error occurred. Please try again later.",
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: const [
          // RoundButton(
          //   title: "Done",
          //   width: 150,
          //   isSelected: true,
          //   backgroundColors: check ? Colors.green : Colors.red,
          //   onPress: () {
          //     Navigator.of(context).pop();
          //   },
          // ),
        ],
      ),
    );
  }

  // static void showSuccessDialog(BuildContext context,AlertDialog? alertDialog,bool check) {
  //   showDialog(
  //     context: context,
  //     builder: (context) =>alertDialog?? AlertDialog(
  //       icon: check?const Icon(
  //         Icons.check_circle,
  //         color: Colors.green,
  //         size: 44,
  //       ):
  //           const Icon(
  //             Icons.error,
  //             color: Colors.green,
  //             size: 44,
  //           ),
  //       title: Text(
  //         check?"Success":"Error"
  //       ),
  //       content: Text(
  //         check?"yours document successfully send to the other signers ."
  //             "Please wait for the other signers to the sign the document ,Thank You!":
  //         "An error Occurred during your process"
  //                  "Please Go back and upload again .Thank You!"
  //       ),
  //       actionsAlignment: MainAxisAlignment.center,
  //       actions: [
  //         RoundButton(
  //             title: "Done",
  //             width: 150,
  //             isSelected: true,
  //             backgroundColors: check?Colors.green:Colors.red,
  //             onPress:(){
  //               Navigator.of(context).pop();
  //             })
  //       ],
  //     ),
  //   );
  // }
  // static void showBackDialog(BuildContext context, alertDialog) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       icon:  const Icon(Icons.backspace, color: Colors.red,size: 44,),
  //       title: const Text("Oh no!",style: TextStyle(
  //           color: Colors.black,
  //           fontSize: 28
  //       ),),
  //       content: const Text("An error occured during your process"
  //           "Please Go back and upload again .Thank You!",
  //           textAlign: TextAlign.center
  //       ),
  //       actionsAlignment: MainAxisAlignment.center,
  //       actions: [
  //         RoundButton(
  //             title: "Done",
  //             width: 150,
  //             isSelected: true,
  //             backgroundColors: Colors.red,
  //             onPress:(){
  //               Navigator.of(context).pop();
  //             })
  //       ],
  //     ),
  //   );
  // }

  static void flushBarMessage(
      BuildContext context, {
        required String title,
        required String messageText,
        required IconData icon,
        required Color backgroundColor,
      }) {
    showFlushbar(
      context: context,
      flushbar: Flushbar(
        forwardAnimationCurve: Curves.decelerate,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: const EdgeInsets.all(15),
        title: title,
        messageText: Text(
          messageText,
          style: const TextStyle(color: Colors.white),
        ),
        duration: const Duration(seconds: 10),
        borderRadius: BorderRadius.circular(8),
        flushbarPosition: FlushbarPosition.TOP,
        backgroundColor: backgroundColor,
        reverseAnimationCurve: Curves.easeInOut,
        positionOffset: 20,
        icon: Icon(icon, size: 28, color: Colors.white),
      )..show(context),
    );
  }


  static void flushBarError(BuildContext context) {
    flushBarMessage(
      context,
      title: 'Error!',
      messageText: 'An error occurred. Please try again.',
      icon: Icons.error,
      backgroundColor: Colors.red,
    );
  }


  static void flushBarSuccess(BuildContext context) {
    flushBarMessage(
      context,
      title: 'Success!',
      messageText:
      'Success is walking from failure to failure with no loss of enthusiasm.',
      icon: Icons.check_circle,
      backgroundColor: Colors.green,
    );
  }


  static void flushBarInfo(BuildContext context) {
    flushBarMessage(
      context,
      title: 'Info!',
      messageText: 'This is an informational message.',
      icon: Icons.info,
      backgroundColor: Colors.blue,
    );
  }


  static void flushBarWarning(BuildContext context) {
    flushBarMessage(
      context,
      title: 'Warning!',
      messageText: 'Be careful what you ask for, you might get it.',
      icon: Icons.warning,
      backgroundColor: Colors.orange,
    );
  }
}


// import 'package:another_flushbar/flushbar.dart';
// import 'package:another_flushbar/flushbar_route.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
//
// class Utils {
//   static void fieldFocusChange(
//       BuildContext context, FocusNode current, FocusNode nextFocus) {
//     current.unfocus();
//     FocusScope.of(context).requestFocus(nextFocus);
//   }
//
//   static void toastMessage(String message, {Color color = Colors.black}) {
//     Fluttertoast.showToast(
//       msg: message,
//       backgroundColor: color,
//       textColor: Colors.white,
//       toastLength: Toast.LENGTH_SHORT,
//       gravity: ToastGravity.BOTTOM,
//       timeInSecForIosWeb: 4,
//     );
//   }
//
//   static void flushBarMessage(
//     BuildContext context, {
//     required String title,
//     required String messageText,
//     required IconData icon,
//     required Color backgroundColor,
//   }) {
//     showFlushbar(
//       context: context,
//       flushbar: Flushbar(
//         forwardAnimationCurve: Curves.decelerate,
//         margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//         padding: const EdgeInsets.all(15),
//         title: title,
//         messageText: Text(
//           messageText,
//           style: const TextStyle(color: Colors.white),
//         ),
//         duration: const Duration(seconds: 10),
//         borderRadius: BorderRadius.circular(8),
//         flushbarPosition: FlushbarPosition.TOP,
//         backgroundColor: backgroundColor,
//         reverseAnimationCurve: Curves.easeInOut,
//         positionOffset: 20,
//         icon: Icon(icon, size: 28, color: Colors.white),
//       )..show(context),
//     );
//   }
//
//   static void flushBarError(BuildContext context) {
//     flushBarMessage(
//       context,
//       title: 'Error!',
//       messageText: 'An error occurred. Please try again.',
//       icon: Icons.error,
//       backgroundColor: Colors.red,
//     );
//   }
//
//   static void flushBarSuccess(BuildContext context) {
//     flushBarMessage(
//       context,
//       title: 'Success!',
//       messageText:
//           'Success is walking from failure to failure with no loss of enthusiasm.',
//       icon: Icons.check_circle,
//       backgroundColor: Colors.green,
//     );
//   }
//
//   static void flushBarInfo(BuildContext context) {
//     flushBarMessage(
//       context,
//       title: 'Info!',
//       messageText: 'This is an informational message.',
//       icon: Icons.info,
//       backgroundColor: Colors.blue,
//     );
//   }
//
//   static void flushBarWarning(BuildContext context) {
//     flushBarMessage(
//       context,
//       title: 'Warning!',
//       messageText: 'Be careful what you ask for; you might get it.',
//       icon: Icons.warning,
//       backgroundColor: Colors.orange,
//     );
//   }
//
//
//   static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackBar(
//       String message, BuildContext context) {
//     return ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         backgroundColor: Colors.red,
//         content: Text(message),
//       ),
//     );
//   }
// }
