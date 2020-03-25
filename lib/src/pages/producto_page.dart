import 'package:flutter/material.dart';
import 'package:form_validation/src/models/producto_model.dart';
import 'package:form_validation/src/providers/productos_providers.dart';
import 'package:form_validation/src/utils/utils.dart' as utils;

class ProductoPage extends StatefulWidget {
  @override
  _ProductoPageState createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {
  final productoProvider = new ProductosProvider();
  final formKey = GlobalKey<FormState>();

  ProductoModel producto = new ProductoModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Productos'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.photo_size_select_actual), onPressed: () {})
        ],
      ),
      body: SingleChildScrollView(
        // controller: controller,
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  _crearNombre(),
                  _crearPrecio(),
                  _crearDisponible(),
                  _crearBoton()
                ],
              )),
        ),
      ),
    );
  }

  Widget _crearNombre() {
    return TextFormField(
      initialValue: producto.titulo,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(labelText: 'Producto'),
        onSaved: (value) => producto.titulo = value,
      validator: (value) {
        if (value.length <= 3) {
          return 'ingrese un nombre del producto  con mas caracteres';
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearPrecio() {
    return TextFormField(
      initialValue: producto.valor.toString(),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(labelText: 'Precio'),
      onSaved: (value) => producto.valor = double.parse(value) ,
      validator: (value) {
        if (utils.isNumeric(value)) {
          return null;
        } else {
          return 'solo numeros';
        }
      },
    );
  }



   Widget _crearDisponible() {

return SwitchListTile(
  
  value: producto.disponible,
  activeColor: Colors.deepPurple,
  title:Text('Disponible') ,

 onChanged:(value) {
   setState(() {
     producto.disponible = value;
   });
 },
 );

   }

  Widget _crearBoton() {
    return RaisedButton.icon(
      color: Colors.deepPurple,
      textColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      icon: Icon(Icons.save),
      label: Text('Guardar'),
      onPressed: () {
        _submit();
      },
    );
  }




  void _submit() {
    if (!formKey.currentState.validate()) return;

    formKey.currentState.save(); // dispara el onsave hace el guardado en el objeto producto

    print('todo ok');
    print(producto.titulo);
     print(producto.valor);
      print(producto.disponible);

productoProvider.crearProducto(producto);

  }
}
