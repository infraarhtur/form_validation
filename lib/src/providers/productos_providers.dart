import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http_parser/http_parser.dart' ;

import 'package:form_validation/src/models/producto_model.dart';
import 'package:http/http.dart' as http;
import 'package:mime_type/mime_type.dart';

class ProductosProvider {
  final String _url = 'https://flutter-varios-44c2d.firebaseio.com';

  Future<bool> crearProducto(ProductoModel producto) async {
    final url = '$_url/productos.json';

    final res = await http.post(url, body: productoModelToJson(producto));

    final decodeData = json.decode(res.body);
    print(decodeData);
    return true;
  }

  Future<bool> editarProducto(ProductoModel producto) async {
    final url = '$_url/productos/${producto.id}.json';

    final res = await http.put(url, body: productoModelToJson(producto));

    final decodeData = json.decode(res.body);
    print(decodeData);
    return true;
  }


  Future<List<ProductoModel>> cargarProductos() async {
    final url = '$_url/productos.json';
    final res = await http.get(url);
    final Map<String, dynamic> decodeData = json.decode(res.body);

    final List<ProductoModel> productos = new List();
    if (decodeData == null) return [];

    decodeData.forEach((id, prod) {
      final prodTemp = ProductoModel.fromJson(prod);
      prodTemp.id = id;
      productos.add(prodTemp);
    });
    return productos;
  }

Future<int> borrarProducto(String id) async{

 final url = '$_url/productos/$id.json';
final res = await http.delete(url);
print(res.body);
return 1;

}


Future<String> subirImagen(File imagen )async{

final url = Uri.parse('https://api.cloudinary.com/v1_1/dm8kuxaub/image/upload?upload_preset=qzyou70n&');
final mineType= mime(imagen.path).split('/');

final imageUploadRequest = http.MultipartRequest(
  'POST',
  url
);

final file = await http.MultipartFile.fromPath(
  'file',
   imagen.path,
   contentType: MediaType(mineType[0], mineType[1])

   );


imageUploadRequest.files.add(file);

final streamResponse = await imageUploadRequest.send();
final resp = await http.Response.fromStream(streamResponse);

if(resp.statusCode != 200 &&  resp.statusCode != 201){
  print('Algo salio mal :(');
  print(resp.body);
  return null;
}

final respData = json.decode(resp.body);
print(respData);
return respData['secure_url'];

}


}
