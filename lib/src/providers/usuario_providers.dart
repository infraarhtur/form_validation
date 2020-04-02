import 'dart:convert';

import 'package:form_validation/src/preferencias_usuario/preferencia_usuario.dart';
import 'package:http/http.dart' as http;

class UsuarioProvider {
  
  final String _firebaseToken = 'AIzaSyBZtkVa_y-SIrt0BexBOGklcyWSNBUm2ok';
  final _prefs = new PreferenciasUsuario();

  Future<Map<String, dynamic>> logIn(String email, String password) async {
    final authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_firebaseToken';
    final resp = await http.post(url, body: json.encode(authData));
    Map<String, dynamic> decodedResp = json.decode(resp.body);

    print(decodedResp);
    if (decodedResp.containsKey('idToken')) {
      _prefs.token = decodedResp['idToken'];
      return {'ok': true, 'token': decodedResp['idToken']};
    } else {
      return {'ok': true, 'mensaje': decodedResp['error']['message']};
    }
  }

  Future<Map<String, dynamic>> nuevoUsuario(
      String email, String password) async {
    final authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_firebaseToken';
    final resp = await http.post(url, body: json.encode(authData));
    Map<String, dynamic> decodedResp = json.decode(resp.body);

    
    if (decodedResp.containsKey('idToken')) {
      _prefs.token = decodedResp['idToken'];
      return {'ok': true, 'token': decodedResp['idToken']};
    } else {
      _prefs.token ='';
      print(decodedResp['error']['message']);
      return {'ok': false,'mensaje': decodedResp['error']['message']};
    }
  }
}
