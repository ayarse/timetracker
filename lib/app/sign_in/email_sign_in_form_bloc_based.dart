import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetracker/app/sign_in/email_sign_in_bloc.dart';
import 'package:timetracker/app/sign_in/email_sign_in_model.dart';
import 'package:timetracker/common_widgets/form_submit_button.dart';
import 'package:timetracker/common_widgets/platform_exception_alert_dialog.dart';
import 'package:timetracker/services/auth.dart';
import 'package:flutter/services.dart';

class   EmailSignInFormBlocBased extends StatefulWidget {
  
  EmailSignInFormBlocBased({this.bloc});
  final EmailSignInBloc bloc;

  static Widget create(BuildContext context) {
    final AuthBase auth = Provider.of<AuthBase>(context, listen: false);
    return Provider<EmailSignInBloc>(
      create: (context) => EmailSignInBloc(auth: auth),
      child: Consumer<EmailSignInBloc>(
        builder: (context, bloc, _) => EmailSignInFormBlocBased(bloc: bloc,),
        ),
      dispose: (context, bloc) => bloc.dispose(),
      );
  }

  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();

}

class _EmailSignInFormState extends State<EmailSignInFormBlocBased> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    try {
      await widget.bloc.submit();
      Navigator.of(context).pop();
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: "Sign In Failed",
        exception: e,
      ).show(context);
    } finally {
      widget.bloc.updateWith(isLoading: false);
    }
  }

  void _emailEditingComplete(EmailSignInModel model) {
    final newFocus = model.emailValidator.isValid(model.email) 
    ? _passwordFocusNode 
    : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _toggleFormType() {
    widget.bloc.toggleFormType();
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChildren(EmailSignInModel model) {

    return [
      _buildEmailTextField(model),
      SizedBox(height: 8.0),
      _buildPasswordTextField(model),
      SizedBox(height: 8.0),
      FormSubmitButton(
        text: model.primaryButtonText,
        onPressed: model.canSubmit ? _submit : null,
      ),
      SizedBox(height: 8.0),
      FlatButton(
        child: Text(model.secondaryButtonText),
        onPressed: !model.isLoading ? () => _toggleFormType : null,
      )
    ];
  }

  TextField _buildPasswordTextField(EmailSignInModel model) {
    return TextField(
      controller: _passwordController,
      decoration: InputDecoration(
        errorText: model.passwordErrorText,
        labelText: "Password",
        enabled: model.isLoading == false,
        ),
        obscureText: true,
        textInputAction: TextInputAction.done,
        focusNode: _passwordFocusNode,
        onEditingComplete: _submit,
        onChanged: widget.bloc.updatePassword,
      );
  }

  TextField _buildEmailTextField(EmailSignInModel model) {
    return TextField(
      controller: _emailController,
      decoration: InputDecoration(
        errorText: model.emailErrorText,
        labelText: "Email",
        enabled: model.isLoading == false,
        hintText: 'test@test.com',
      ),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      focusNode: _emailFocusNode,
      onEditingComplete: () => _emailEditingComplete(model),
      onChanged: widget.bloc.updateEmail,
          );
        }
      
        @override
        Widget build(BuildContext context) {

          return StreamBuilder<EmailSignInModel>(
            stream: widget.bloc.modelStream,
            initialData: EmailSignInModel(),
            builder: (context, snapshot) {
              final EmailSignInModel model = snapshot.data;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: _buildChildren(model),
                ),
              );
            }
          );
        }
    
}