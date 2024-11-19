import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:app_pets/data/api/publicacion_api.dart';
import 'package:app_pets/data/models/PublicacionModel.dart';
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
    usuarioId: 1,
    ciudadId: 1,
    especieId: 1,
  );
  final List<File> _imagenes = [];
  bool _isLoading = false;

  final PublicacionApi _api = PublicacionApi();

  // Listas para las opciones de ciudad y especie
  final Map<int, String> _ciudades = {
    1: 'La Paz',
    2: 'Cochabamba',
    3: 'Santa Cruz',
    4: 'Oruro',
    5: 'Potosí',
    6: 'Tarija',
    7: 'Sucre',
    8: 'Beni',
    9: 'Pando',
  };

  final Map<int, String> _especies = {
    1: 'Perro',
    2: 'Gato',
    3: 'Otro',
  };

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
        Navigator.pop(context);
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
                      // Título
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Título",
                          prefixIcon: Icon(FontAwesomeIcons.pen),
                        ),
                        validator: (value) => value!.isEmpty ? "Campo requerido" : null,
                        onSaved: (value) => _publicacion.titulo = value!,
                      ),
                      // Descripción
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Descripción",
                          prefixIcon: Icon(FontAwesomeIcons.fileLines),
                        ),
                        validator: (value) => value!.isEmpty ? "Campo requerido" : null,
                        onSaved: (value) => _publicacion.descripcion = value!,
                      ),
                      // Raza
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Raza",
                          prefixIcon: Icon(FontAwesomeIcons.dog),
                        ),
                        validator: (value) => value!.isEmpty ? "Campo requerido" : null,
                        onSaved: (value) => _publicacion.raza = value!,
                      ),
                      // Edad
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Edad",
                          prefixIcon: Icon(FontAwesomeIcons.cakeCandles),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) return "Campo requerido";
                          if (int.tryParse(value) == null) return "Debe ser un número";
                          return null;
                        },
                        onSaved: (value) => _publicacion.edad = int.parse(value!),
                      ),
                      // Cantidad de Machos
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Cantidad de Machos",
                          prefixIcon: Icon(FontAwesomeIcons.mars),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) return "Campo requerido";
                          if (int.tryParse(value) == null) return "Debe ser un número";
                          return null;
                        },
                        onSaved: (value) => _publicacion.cantidadMachos = int.parse(value!),
                      ),
                      // Cantidad de Hembras
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Cantidad de Hembras",
                          prefixIcon: Icon(FontAwesomeIcons.venus),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) return "Campo requerido";
                          if (int.tryParse(value) == null) return "Debe ser un número";
                          return null;
                        },
                        onSaved: (value) => _publicacion.cantidadHembras = int.parse(value!),
                      ),
                      // Teléfono
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Teléfono",
                          prefixIcon: Icon(FontAwesomeIcons.phone),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) => value!.isEmpty ? "Campo requerido" : null,
                        onSaved: (value) => _publicacion.telefono = value!,
                      ),
                      // Selector de Ciudad
                      DropdownButtonFormField<int>(
                        decoration: InputDecoration(
                          labelText: "Ciudad",
                          prefixIcon: Icon(FontAwesomeIcons.city),
                        ),
                        value: _publicacion.ciudadId,
                        items: _ciudades.entries
                            .map((entry) => DropdownMenuItem<int>(
                                  value: entry.key,
                                  child: Text(entry.value),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _publicacion.ciudadId = value!;
                          });
                        },
                      ),
                      // Selector de Especie
                      DropdownButtonFormField<int>(
                        decoration: InputDecoration(
                          labelText: "Especie",
                          prefixIcon: Icon(FontAwesomeIcons.paw),
                        ),
                        value: _publicacion.especieId,
                        items: _especies.entries
                            .map((entry) => DropdownMenuItem<int>(
                                  value: entry.key,
                                  child: Text(entry.value),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _publicacion.especieId = value!;
                          });
                        },
                      ),
                      // Botón para seleccionar imágenes
                      ElevatedButton(
                         style: ElevatedButton.styleFrom(
   backgroundColor: Color.fromRGBO(155, 60, 130, 1), 
                  foregroundColor : Colors.white, 
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),

  ), 
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
                      // Botón para enviar formulario
                      ElevatedButton(
                         style: ElevatedButton.styleFrom(
   backgroundColor: Color.fromRGBO(155, 60, 130, 1), 
                  foregroundColor : Colors.white, 
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),

  ),
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
