import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetracker/app/sign_in/validators.dart';
import 'package:timetracker/common_widgets/form_submit_button.dart';
import 'package:timetracker/common_widgets/platform_exception_alert_dialog.dart';
import 'package:timetracker/services/auth.dart';
import 'package:flutter/services.dart';

enum EmailSignInFormType {
  signIn,
  Register
}

class EmailSignInFormStateful extends StatefulWidget with EmailAndPasswordValidators {

  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();

}

class _EmailSignInFormState extends State<EmailSignInFormStateful> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  String get _email => _emailController.text;
  String get _password => _passwordController.text;
  EmailSignInFormType _formType = EmailSignInFormType.signIn; 
  bool _submitted = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _submit() async {
    setState(() {
      _submitted = true;
      _isLoading = true;
    });
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      if(_formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(_email, _password);
      } else {
        await auth.createUserWithEmailAndPassword(_email, _password);
      }
      Navigator.of(context).pop();
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: "Sign In Failed",
        exception: e,
      ).show(context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _emailEditingComplete() {
    final newFocus = widget.emailValidator.isValid(_email) ? _passwordFocusNode : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _toggleFormType() {
    setState(() {
      _submitted = false;
      _formType = _formType == EmailSignInFormType.signIn ? EmailSignInFormType.Register : EmailSignInFormType.signIn;
    });
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChildren() {
    final primaryText = _formType == EmailSignInFormType.signIn ? 'Sign In' : 'Create an Account';
    final secondaryText = _formType == EmailSignInFormType.signIn ? 'Need an Account ? Register' : 'Have an account? Sign In';
    bool submitEnabled = widget.emailValidator.isValid(_email) && widget.passwordValidator.isValid(_password) && !_isLoading;
    return [
      _buildEmailTextField(),
      SizedBox(height: 8.0),
      _buildPasswordTextField(),
      SizedBox(height: 8.0),
      FormSubmitButton(
        text: primaryText,
        onPressed: submitEnabled ? _submit : null,
      ),
      SizedBox(height: 8.0),
      FlatButton(
        child: Text(secondaryText),
        onPressed: !_isLoading ? _toggleFormType : null,
      )
    ];
  }

  TextField _buildPasswordTextField() {
    bool showErrorText = _submitted && widget.passwordValidator.isValid(_password);
    return TextField(
      controller: _passwordController,
      decoration: InputDecoration(
        errorText: showErrorText ? widget.invalidPasswordErrorText : null,
        labelText: "Password",
        enabled: _isLoading == false,
        ),
        obscureText: true,
        textInputAction: TextInputAction.done,
        focusNode: _passwordFocusNode,
        onEditingComplete: _submit,
        onChanged: (password) => _updateState(),
      );
  }

  TextField _buildEmailTextField() {
    bool showErrorText = _submitted && widget.emailValidator.isValid(_email);
    return TextField(
      controller: _emailController,
      decoration: InputDecoration(
        errorText: showErrorText ? widget.invalidEmailErrorText : null,
        labelText: "Email",
        enabled: _isLoading == false,
        hintText: 'test@test.com',
      ),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      focusNode: _emailFocusNode,
      onEditingComplete: _emailEditingComplete,
      onChanged: (email) => _updateState(),
          );
        }
      
        @override
        Widget build(BuildContext context) {

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: _buildChildren(),
            ),
          );
        }
      
        _updateState() {
          setState((){});
        }
}