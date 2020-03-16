import 'dart:async';

import 'package:form_validation/src/blocs/validators.dart';
import 'package:rxdart/rxdart.dart';



class LoginBloc with Validators{

final _emailController = BehaviorSubject<String>();
final _passwordController = BehaviorSubject<String>();

//Recuperar datos del stream|

Stream<String> get emailStream => _emailController.stream.transform(validarEmail);
Stream<String> get paswordStream => _passwordController.stream.transform(validarPassword);


 Stream<bool> get formValidStream =>
CombineLatestStream.combine2(emailStream, paswordStream, (e, p) => true);

//insertar valores al Stream
Function(String) get changeEmail => _emailController.sink.add;
Function(String) get changePassword => _passwordController.sink.add;

//obtener ultimos valores ingresados por los streams
String get email => _emailController.value;
String get password => _passwordController.value;

dispose(){
  _emailController?.close();
  _passwordController?.close();
}


}


