import 'dart:io';

import 'package:form_validation/src/providers/productos_providers.dart';
import 'package:form_validation/src/models/producto_model.dart';
import 'package:rxdart/rxdart.dart';

class ProductosBloc{

final _productosController = new BehaviorSubject<List<ProductoModel>>();
final _cargandoController = new BehaviorSubject<bool>();

final _productosProvider = new ProductosProvider();


Stream<List<ProductoModel>> get productoStream =>_productosController.stream;
Stream<bool> get cargando => _cargandoController.stream;

void cargarProductos() async{

final productos = await _productosProvider.cargarProductos();

_productosController.sink.add(productos);
}

void agregarProductos(ProductoModel producto) async {

_cargandoController.sink.add(true);
await _productosProvider.crearProducto(producto);

_cargandoController.sink.add(false);


}

Future<String> subirFoto(File foto) async {

_cargandoController.sink.add(true);
final fotoUrl = await _productosProvider.subirImagen(foto);

_cargandoController.sink.add(false);

return fotoUrl;

}


void editarProductos(ProductoModel producto) async {

_cargandoController.sink.add(true);
await _productosProvider.editarProducto(producto);

_cargandoController.sink.add(false);


}


void borrarProductos(String idProducto) async {

// _cargandoController.sink.add(true);
await _productosProvider.borrarImagen(idProducto);

// _cargandoController.sink.add(false);


}

dispose(){
  _productosController?.close();
  _cargandoController?.close();
}

}