import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:rxdart/subjects.dart';
import 'package:timetracker/app/sign_in/email_sign_in_model.dart';
import 'package:timetracker/services/auth.dart';

class EmailSignInBloc {

  EmailSignInBloc({@required this.auth});

  final _modelSubject = BehaviorSubject<EmailSignInModel>.seeded(EmailSignInModel());

  // final StreamController<EmailSignInModel> _modelController = StreamController<EmailSignInModel>();
  // Stream<EmailSignInModel> get modelStream => _modelController.stream;
  Stream<EmailSignInModel> get modelStream => _modelSubject.stream;
  EmailSignInModel get _model => _modelSubject.value;
  final AuthBase auth;

  void dispose() {
    _modelSubject.close();
  }

  void updateEmail(String email) => updateWith(email: email); 
  void updatePassword(String password) => updateWith(password: password);

  void toggleFormType() {
    final formType = _model.formType == EmailSignInFormType.signIn 
          ? EmailSignInFormType.Register 
          : EmailSignInFormType.signIn;
    updateWith(
      email: '',
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

      _modelSubject.value = _model.copyWith(
        email: email,
        password: password,
        formType: formType,
        isLoading: isLoading,
        submitted: submitted
      );      
    }

  Future<void> submit() async {
    updateWith(submitted: true, isLoading: true);
    try {
      if(_model.formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(_model.email, _model.password);
      } else {
        await auth.createUserWithEmailAndPassword(_model.email, _model.password);
      }
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

}