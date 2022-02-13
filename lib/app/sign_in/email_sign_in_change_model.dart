import 'package:flutter/foundation.dart';
import 'package:timetracker/app/sign_in/email_sign_in_model.dart';
import 'package:timetracker/app/sign_in/validators.dart';
import 'package:timetracker/services/auth.dart';

class EmailSignInChangeModel with EmailAndPasswordValidators, ChangeNotifier {

  EmailSignInChangeModel({
    @required this.auth,
    this.email = '', 
    this.password = '', 
    this.formType = EmailSignInFormType.signIn, 
    this.isLoading = false, 
    this.submitted = false
    });

  final AuthBase auth;
  String email;
  String password;
  EmailSignInFormType formType;
  bool isLoading;
  bool submitted;

  Future<void> submit() async {
  updateWith(submitted: true, isLoading: true);
  try {
    if(formType == EmailSignInFormType.signIn) {
      await auth.signInWithEmailAndPassword(email, password);
    } else {
      await auth.createUserWithEmailAndPassword(email, password);
    }
  } catch (e) {
    updateWith(isLoading: false);
    rethrow;
  }
}

  String get primaryButtonText {
    return formType == EmailSignInFormType.signIn 
                        ? 'Sign In' 
                        : 'Create an Account';
  }

  String get secondaryButtonText {
    return formType == EmailSignInFormType.signIn 
                      ? 'Need an Account ? Register' 
                      : 'Have an account? Sign In';
  }

  bool get canSubmit {
        return emailValidator.isValid(email) && 
        passwordValidator.isValid(password) && 
        !isLoading;
  }

  String get passwordErrorText {
        bool showErrorText =  submitted && !passwordValidator.isValid(password);
        return showErrorText ? invalidPasswordErrorText : null;
  }

  String get emailErrorText {
        bool showErrorText = submitted && !emailValidator.isValid(email);
        return showErrorText ? invalidEmailErrorText : null;

  }

  void updateEmail(String email) => updateWith(email: email); 
  void updatePassword(String password) => updateWith(password: password);

  void toggleFormType() {
    final formType = this.formType == EmailSignInFormType.signIn 
          ? EmailSignInFormType.Register 
          : EmailSignInFormType.signIn;
    updateWith(
      email: 'clickm',
      password: '',
      formType: formType,
      submitted: false, 
      isLoading: false,
      );
  }

  void updateWith({
      String email,
      String password,
      EmailSignInFormType formType,
      bool isLoading,
      bool submitted,
    }) {
        this.email = email ?? this.email;
        this.password = password ?? this.password;
        this.formType = formType ?? this.formType;
        this.isLoading = isLoading ?? this.isLoading;
        this.submitted = submitted ?? this.submitted;
        notifyListeners();
  }

}