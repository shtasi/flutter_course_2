import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveButton extends StatelessWidget {
  final String text;
  final Function handler;

  AdaptiveButton(this.text, this.handler);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
            child: Text(
              this.text,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: this.handler)
        : FlatButton(
            onPressed: this.handler,
            textColor: Theme.of(context).primaryColor,
            child: Text(
              this.text,
              style: TextStyle(fontWeight: FontWeight.bold),
            ));
  }
}
