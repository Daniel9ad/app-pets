import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:app_pets/data/api/publicacion_api.dart';
import 'package:app_pets/data/models/PublicacionModel.dart';
import 'package:logger/logger.dart';
import 'dart:convert';


class CrearPublicacionPage extends StatefulWidget {
  @override
  _CrearPublicacionPageState createState() => _CrearPublicacionPageState();
}

class _CrearPublicacionPageState extends State<CrearPublicacionPage> {
  final _formKey = GlobalKey<FormState>();
  final _publicacion = PublicacionModel(
    titulo: '',
    descripcion: '',
    raza: '',
    edad: 0,
    cantidadMachos: 0,
    cantidadHembras: 0,
    telefono: '',
    usuarioId: 1, // Cambia este valor según la lógica de tu aplicación
    ciudadId: 1,  // Cambia este valor según tu aplicación
    especieId: 1, // Cambia este valor según tu aplicación
  );
  final List<File> _imagenes = [];
  bool _isLoading = false;

  final PublicacionApi _api = PublicacionApi();


Future<void> _pickImages() async {
  try {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();

    if (pickedFiles != null) {
      setState(() {
        _imagenes.addAll(pickedFiles.map((file) => File(file.path)));
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No se seleccionaron imágenes")),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error al seleccionar imágenes: $e")),
    );
  }
}
  // Método para enviar el formulario
  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    if (_imagenes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Por favor selecciona al menos una imagen")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    _formKey.currentState!.save();

    try {
      final success = await _api.crearPublicacion(_publicacion, _imagenes);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Publicación creada exitosamente")),
        );
        Navigator.pop(context); // Regresa a la pantalla anterior
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al crear publicación")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al crear publicación: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Crear Publicación")),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        decoration: InputDecoration(labelText: "Título"),
                        validator: (value) => value!.isEmpty ? "Campo requerido" : null,
                        onSaved: (value) => _publicacion.titulo = value!,
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: "Descripción"),
                        validator: (value) => value!.isEmpty ? "Campo requerido" : null,
                        onSaved: (value) => _publicacion.descripcion = value!,
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: "Raza"),
                        validator: (value) => value!.isEmpty ? "Campo requerido" : null,
                        onSaved: (value) => _publicacion.raza = value!,
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: "Edad"),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) return "Campo requerido";
                          if (int.tryParse(value) == null) return "Debe ser un número";
                          return null;
                        },
                        onSaved: (value) => _publicacion.edad = int.parse(value!),
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: "Cantidad de Machos"),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) return "Campo requerido";
                          if (int.tryParse(value) == null) return "Debe ser un número";
                          return null;
                        },
                        onSaved: (value) => _publicacion.cantidadMachos = int.parse(value!),
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: "Cantidad de Hembras"),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) return "Campo requerido";
                          if (int.tryParse(value) == null) return "Debe ser un número";
                          return null;
                        },
                        onSaved: (value) => _publicacion.cantidadHembras = int.parse(value!),
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: "Teléfono"),
                        keyboardType: TextInputType.phone,
                        validator: (value) => value!.isEmpty ? "Campo requerido" : null,
                        onSaved: (value) => _publicacion.telefono = value!,
                      ),
                      ElevatedButton(
                        onPressed: _pickImages,
                        child: Text("Seleccionar Imágenes"),
                      ),
                      if (_imagenes.isNotEmpty)
                        Wrap(
                          spacing: 10,
                          children: _imagenes
                              .map((img) => Image.file(img, width: 100, height: 100, fit: BoxFit.cover))
                              .toList(),
                        ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _submitForm,
                        child: Text("Publicar"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
