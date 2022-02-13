import 'package:flutter/services.dart';
import 'package:timetracker/common_widgets/platform_alert_dialog.dart';
import 'package:meta/meta.dart';


class PlatformExceptionAlertDialog extends PlatformAlertDialog {
    PlatformExceptionAlertDialog({
      @required String title, 
      @required PlatformException exception
      }) : super(
        title: title,
        content: _message(exception),
        defaultActionText: "OK"
      );
      
    static String _message(PlatformException exception) {
      if(exception.message == 'FIRFirestoreErrorDomain') {
        if(exception.code == 'Error 7') {
          return 'Missing or insufficient permissions';
        }
      }
      return _errors[exception.code] ?? exception.message;
    }

    static Map<String, String> _errors = {
        'ERROR_WEAK_PASSWORD' : 'The password you entered is too weak',
        'ERROR_INVALID_EMAIL' : 'The email address is invalid',
        'ERROR_EMAIL_ALREADY_IN_USE' : 'The email address is already in use',
        'ERROR_WRONG_PASSWORD' : 'The password is invalid',
        'ERROR_USER_NOT_FOUND' : 'A user matching these credentials was not found',
        'ERROR_USER_DISABLED' : 'The user account has been disabled',
        'ERROR_TOO_MANY_REQUESTS' : 'Blocked due to too many sign in requests',
        'ERROR_OPERATION_NOT_ALLOWED' : 'Not allowed',
    };
}