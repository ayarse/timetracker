import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:timetracker/common_widgets/platform_widget.dart';

class PlatformAlertDialog extends PlatformWidget {

  final String title;
  final String content;
  final String defaultActionText;
  final String cancelActionText;

  Future<bool> show(BuildContext context) async {
    return Platform.isIOS ? 
    await showCupertinoDialog<bool>(
      context: context, 
      builder: (context) => this,
      )
    : await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => this,
    );
  }

  PlatformAlertDialog({
      @required this.title, 
      @required this.content, 
      @required this.defaultActionText,
      this.cancelActionText
    }) : assert(title != null),
         assert(content != null),
         assert(defaultActionText != null);

  @override
  Widget buildCupertino(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: _buildActions(context),
    );
  }

  @override
  Widget buildMaterial(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: _buildActions(context),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    final actions = <Widget>[];
    if(cancelActionText != null) {
      actions.add(
          PlatFormAlertDialogAction(
          child: Text(cancelActionText),
          onPressed: () => Navigator.of(context).pop(false),
        )
      );
    }
      actions.add(
          PlatFormAlertDialogAction(
          child: Text(defaultActionText),
          onPressed: () => Navigator.of(context).pop(true),
        )
      );
      return actions;
  }
  
}

class PlatFormAlertDialogAction extends PlatformWidget {
  final Widget child;
  final VoidCallback onPressed;

  PlatFormAlertDialogAction({this.child, this.onPressed});

  @override
  Widget buildCupertino(BuildContext context) {
    return CupertinoDialogAction(
      child: child, 
      onPressed: onPressed,
      );
  }

  @override
  Widget buildMaterial(BuildContext context) {
    return FlatButton(
      child: child, 
      onPressed: onPressed,
      );
  }

}