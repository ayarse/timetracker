import 'dart:io';
import 'package:flutter/material.dart';

abstract class PlatformWidget extends StatelessWidget {

  Widget buildCupertino(BuildContext context);

  Widget buildMaterial(BuildContext context);

  @override
  Widget build(BuildContext context) {
    if(Platform.isIOS) {
      return buildCupertino(context);
    }
    return buildMaterial(context);
  }
}