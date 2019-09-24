import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

alert(BuildContext context, String msg, {Function callback}) {
  showDialog(
    context: context,
    barrierDismissible:
        false, // false = user must tap button, true = tap outside dialog
    builder: (BuildContext dialogContext) {
      return WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: Text('Carros'),
          content: Text(msg),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                //Navigator.of(dialogContext).pop(); // Dismiss alert dialog
                Navigator.pop(context);
                if (callback != null) {
                  callback();
                }
              },
            ),
          ],
        ),
      );
    },
  );
}
