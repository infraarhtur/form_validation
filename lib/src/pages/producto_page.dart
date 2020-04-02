import 'dart:io';

import 'package:flutter/material.dart';
import 'package:form_validation/src/blocs/provider.dart';

import 'package:form_validation/src/models/producto_model.dart';
// import 'package:form_validation/src/providers/productos_providers.dart';
import 'package:form_validation/src/utils/utils.dart' as utils;
import 'package:image_picker/image_picker.dart';

class ProductoPage extends StatefulWidget {
  @override
  _ProductoPageState createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {
 
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();


ProductosBloc productosBloc;

  ProductoModel producto = new ProductoModel();
  bool _guardando = false;
  File foto;

  @override
  Widget build(BuildContext context) {

productosBloc = Provider.productosBloc(context);


    final ProductoModel proData = ModalRoute.of(context).settings.arguments;

    if (proData != null) {
      producto = proData;
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Productos'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.photo_size_select_actual),
              onPressed: _seleccionarFoto),
          IconButton(icon: Icon(Icons.camera_alt), onPressed: _tomarFoto)
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
                  _mostrarFoto(),
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
      onSaved: (value) => producto.valor = double.parse(value),
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
      title: Text('Disponible'),
      onChanged: (value) {
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
      onPressed: (_guardando) ? null : _submit,
    );
  }

  void _submit()async{
    if (!formKey.currentState.validate()) return;

    formKey.currentState
        .save(); // dispara el onsave hace el guardado en el objeto producto

    setState(() {
      _guardando = true;
    });

if(foto != null){
 producto.fotoUrl= await productosBloc.subirFoto(foto);
}

    if (producto.id == null) {
      productosBloc.agregarProductos(producto);
      mostrarSnackbar('Producto Guardado');
    } else {
      productosBloc.editarProductos(producto);
      mostrarSnackbar('Producto editado');
    }

//      setState(() {
//    _guardando = false;
//  });

    Navigator.pop(context);
  }

  void mostrarSnackbar(String mensaje) {
    final snackbar = SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds: 1500),
    );

    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  Widget _mostrarFoto() {
    if (producto.fotoUrl != null && producto.fotoUrl != '') {
     
return FadeInImage(
  placeholder: AssetImage('assets/jar-loading.gif'),
   image: NetworkImage(producto.fotoUrl),
   fit: BoxFit.cover,
          height: 300.0,
   );

    } else {
      if (foto != null) {
        return Image.file(
          foto,
          fit: BoxFit.cover,
          height: 300.0,
        );
      }

      return Image(
          image: AssetImage('assets/no-photo.png'),
          height: 300.0,
          fit: BoxFit.cover);
    }
  }

  _seleccionarFoto() async {
     _procesarFoto(ImageSource.gallery);
  }

  _tomarFoto() async {
   _procesarFoto(ImageSource.camera);

  }

  _procesarFoto( ImageSource origen) async {
    foto = await ImagePicker.pickImage(source: origen);

    if (foto != null) {
      //limpieza
      producto.fotoUrl = null;
      

    }

    setState(() {});
  }
}
