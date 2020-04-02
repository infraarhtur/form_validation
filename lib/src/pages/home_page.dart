import 'package:flutter/material.dart';
// import 'package:form_validation/src/blocs/provider.dart';
import 'package:form_validation/src/models/producto_model.dart';
import 'package:form_validation/src/providers/productos_providers.dart';

class HomePage extends StatelessWidget {
  final productosProvider = new ProductosProvider();

  @override
  Widget build(BuildContext context) {
    // final bloc = Provider.of(context);

    return Scaffold(
      appBar: AppBar(title: Text('home')),
      body: _crearListado(context),
      floatingActionButton: _crearBoton(context),
    );
  }

  Widget _crearBoton(BuildContext context) {
    return FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
        onPressed: () {
          Navigator.pushNamed(context, 'producto');
        });
  }

  Widget _crearListado(BuildContext context) {
    return FutureBuilder(
        future: productosProvider.cargarProductos(),
        builder: (BuildContext context,
            AsyncSnapshot<List<ProductoModel>> snapshot) {
          if (snapshot.hasData) {
            final productos = snapshot.data;
            return ListView.builder(
              itemCount: productos.length,
              itemBuilder: (context, i) => _crearItem(context, productos[i]),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Widget _crearItem(BuildContext context, ProductoModel producto) {
    return Dismissible(
        key: UniqueKey(),
        background: Container(
          color: Colors.red,
        ),
        onDismissed: (direccion) {
          // if (producto.fotoUrl != null && producto.fotoUrl != '') {
          //   productosProvider.borrarImagen(producto.fotoUrl);
          // }

          productosProvider.borrarProducto(producto.id);
        },
        child: Card(
          child: Column(
            children: <Widget>[
              (producto.fotoUrl == null || producto.fotoUrl == '')
                  ? Image(image: AssetImage('assets/no-photo.png'))
                  : FadeInImage(
                      placeholder: AssetImage('assets/jar-loading.gif'),
                      image: NetworkImage(producto.fotoUrl),
                      height: 300.0,
                      width: double.infinity,
                      fit: BoxFit.cover),
              ListTile(
                title: Text('${producto.titulo}-${producto.valor} '),
                subtitle: Text('${producto.id}'),
                onTap: () {
                  Navigator.pushNamed(context, 'producto', arguments: producto);
                },
              ),
            ],
          ),
        ));
  }
}
