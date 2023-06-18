import 'package:flutter/material.dart';

extension NavigationUtility on Widget {
  void navigateToScreen(BuildContext context, Widget nextScreen, bool previousPageCleanFlag) {

   if(previousPageCleanFlag)
     {
       Navigator.of(context).pushReplacement(
         MaterialPageRoute(builder: (context) => nextScreen),
       );
     }
   else{
     Navigator.of(context).push(
       MaterialPageRoute(builder: (context) => nextScreen),
     );
   }



  }

  void showSnackBarWithMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
