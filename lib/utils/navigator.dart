import 'package:flutter/material.dart';

Future push(BuildContext context, Widget page, {bool replace = false}) {
  if (replace) {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return page;
    }));
  } else {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return page;
    }));
  }
}

Future pop(BuildContext context, Widget page) {
  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
    return page;
  }));
}
