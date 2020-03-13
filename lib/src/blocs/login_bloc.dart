import 'dart:async';



class LoginBloc{

final _emailController = StreamController<String>.broadcast();
final _passwordController = StreamController<String>.broadcast();

//Recuperar datos del stream|

Stream<String> get emailStream => _emailController.stream;
Stream<String> get paswordStream => _passwordController.stream;




//insertar valores al Stream
Function(String) get changeEmail => _emailController.sink.add;
Function(String) get changePassword => _passwordController.sink.add;

dispose(){
  _emailController?.close();
  _passwordController?.close();
}


}


