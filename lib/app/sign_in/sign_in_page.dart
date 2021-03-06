import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:timetracker/app/sign_in/email_sign_in_page.dart';
import 'package:timetracker/app/sign_in/sign_in_manager.dart';
import 'package:timetracker/app/sign_in/sign_in_button.dart';
import 'package:timetracker/app/sign_in/social_sign_in_button.dart';
import 'package:timetracker/common_widgets/platform_exception_alert_dialog.dart';
import 'package:timetracker/services/auth.dart';

class SignInPage extends StatelessWidget {

  final SignInManager manager;
  final bool isLoading;

  SignInPage({
    Key key, 
    @required this.manager,
    @required this.isLoading
    }) : super(key: key);

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<ValueNotifier<bool>>(
          create: (_) => ValueNotifier<bool>(false),
          child: Consumer<ValueNotifier<bool>>(
            builder: (_, isLoading, __) => Provider<SignInManager>(
            create: (_) => SignInManager(auth: auth, isLoading: isLoading),
            child: Consumer<SignInManager>(
                    builder: (context, manager, _) => SignInPage(manager: manager, isLoading: isLoading.value,)
                  ),
      ),
          ),
    );
  }

  void _showSignInError(BuildContext context, PlatformException exception) {
      PlatformExceptionAlertDialog(
          title: 'Sign in Failed', 
          exception: exception
        ).show(context);
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      await manager.signInAnonymously();
    } on PlatformException catch (e) {
      _showSignInError(context, e);
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      await manager.signInWithGoogle();
    } on PlatformException catch (e) {
      if(e.code != 'ERROR_ABORTED_BY_USER') {
        _showSignInError(context, e);
      }
    }
  }

  void _signInWithEmail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => EmailSignInPage()
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Time Tracker"),
        elevation: 2.0,
      ),
      body: _buildContent(context),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContent(BuildContext context)
  {
    return Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 50.0,
              child: _buildHeader(),
            ),
            SizedBox(height: 48.0,),
            SocialSignInButton(
              text: "Sign in with Google",
              assetName: 'images/google-logo.png',
              textColor: Colors.black87,
              color: Colors.white,
              onPressed: isLoading ? null : () => _signInWithGoogle(context),
              ),
            SizedBox(height: 8.0,),
            SocialSignInButton(
              assetName: 'images/facebook-logo.png',
              text: "Sign in with Facebook",
              textColor: Colors.white,
              color: Color(0xff334d92),
              onPressed: () {},
            ),
            SizedBox(height: 8.0,),
            SignInButton(
              text: "Sign in with Email",
              textColor: Colors.white,
              color: Colors.teal[700],
              onPressed: () => _signInWithEmail(context),
            ),
            SizedBox(height: 8.0),
            Text(
              "or", 
              style: TextStyle(
                fontSize: 14.0, color: 
                Colors.black87), 
              textAlign: TextAlign.center,
              ),
            SizedBox(height: 8.0),
            SignInButton(
              text: "Sign in anonymous",
              textColor: Colors.black,
              color: Colors.lime[300],
              onPressed: isLoading ? null : () => _signInAnonymously(context),
            ),

        ],)
      );
  }
  
  Widget _buildHeader() {
    if(isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Text(
        "Sign In",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600)
        );
    }
  }
  
}