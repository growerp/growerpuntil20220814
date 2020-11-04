import 'authenticate.dart';

class FormArguments {
  final Authenticate authenticate;
  final String message;
  final Object object;
  FormArguments(this.authenticate, [this.message, this.object]);
  String toString() =>
      'Auth: ${authenticate.company.name} msg: $message object: ${object.toString()}';
}
