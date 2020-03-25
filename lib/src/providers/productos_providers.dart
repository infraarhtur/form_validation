import 'dart:convert';
import 'package:form_validation/src/models/producto_model.dart';
import 'package:http/http.dart' as http;

class ProductosProvider {
  final String _url = 'https://flutter-varios-44c2d.firebaseio.com';

  Future<bool> crearProducto(ProductoModel producto) async {
    final url = '$_url/productos.json';

    final res = await http.post(url, body: productoModelToJson(producto));

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

}
