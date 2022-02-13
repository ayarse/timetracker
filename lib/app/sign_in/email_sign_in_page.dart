
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetracker/app/sign_in/email_sign_in_form_bloc_based.dart';
import 'package:timetracker/app/sign_in/email_sign_in_form_change_notifier.dart';
import 'package:timetracker/services/auth.dart';

class EmailSignInPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In"),
        elevation: 2.0,
      ),
      body: SingleChildScrollView(
              child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Card(
            child: EmailSignInFormChangeNotifier.create(context),
            ),
          ),
      ),
      backgroundColor: Colors.grey[200],
    );
  }
}