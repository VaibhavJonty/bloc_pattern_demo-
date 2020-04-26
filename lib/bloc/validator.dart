import 'dart:async';

class Validators {
  final validateUsernmae =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (email.isNotEmpty) {
      sink.add(email);
    } else {
      sink.addError('Enter a username');
    }
  });

  final validatePassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (password.length > 1) {
      sink.add(password);
    } else {
      sink.addError('Invalid password, please enter more than 1 characters');
    }
  });
  final validateEmail = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (password.length > 1) {
      sink.add(password);
    } else {
      sink.addError('Invalid Email, please eneter valid email');
    }
  });
}
