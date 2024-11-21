import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:app_pets/data/api/publicacion_api.dart';
import 'package:app_pets/data/models/PublicacionModel.dart';
import 'package:app_pets/auth/auth_service.dart'; // Asegúrate de tener este servicio

class CrearPublicacionPage extends StatefulWidget {
  @override
  _CrearPublicacionPageState createState() => _CrearPublicacionPageState();
}

class _CrearPublicacionPageState extends State<CrearPublicacionPage> {
  final _formKey = GlobalKey<FormState>();
  final PublicacionModel _publicacion = PublicacionModel(
    titulo: '',
    descripcion: '',
    raza: '',
    edad: 0,
    cantidadMachos: 0,
    cantidadHembras: 0,
    telefono: '',
    usuarioId: 1, // Se actualizará dinámicamente
    ciudadId: 1,
    especieId: 1,
  );
  final List<File> _imagenes = [];
  bool _isLoading = true;
  final PublicacionApi _api = PublicacionApi();
  final AuthService _authService = AuthService(); // Servicio de autenticación

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

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final userData = await _authService.getUserData();
      setState(() {
        _publicacion.usuarioId = userData['id'];
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al cargar usuario: $e")),
      );
    }
  }

  Future<void> _pickImages() async {
    try {
      final picker = ImagePicker();
      final pickedFiles = await picker.pickMultiImage();

      if (pickedFiles != null) {
        setState(() {
          _imagenes.addAll(pickedFiles.map((file) => File(file.path)));
        });
      } else {
        _showSnackbar("No se seleccionaron imágenes");
      }
    } catch (e) {
      _showSnackbar("Error al seleccionar imágenes: $e");
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    if (_imagenes.isEmpty) {
      _showSnackbar("Por favor selecciona al menos una imagen");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    _formKey.currentState!.save();

    try {
      final success = await _api.crearPublicacion(_publicacion, _imagenes);
      if (success) {
        _showSnackbar("Publicación creada exitosamente");
        Navigator.pop(context);
      } else {
        _showSnackbar("Error al crear publicación");
      }
    } catch (e) {
      _showSnackbar("Error al crear publicación: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Crear Publicación")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTextField("Título", FontAwesomeIcons.pen, (value) => _publicacion.titulo = value!),
                _buildTextField("Descripción", FontAwesomeIcons.fileLines, (value) => _publicacion.descripcion = value!),
                _buildTextField("Raza", FontAwesomeIcons.dog, (value) => _publicacion.raza = value!),
                _buildNumberField("Edad", FontAwesomeIcons.cakeCandles, (value) => _publicacion.edad = int.parse(value!)),
                _buildNumberField("Cantidad de Machos", FontAwesomeIcons.mars, (value) => _publicacion.cantidadMachos = int.parse(value!)),
                _buildNumberField("Cantidad de Hembras", FontAwesomeIcons.venus, (value) => _publicacion.cantidadHembras = int.parse(value!)),
                _buildTextField("Teléfono", FontAwesomeIcons.phone, (value) => _publicacion.telefono = value!, keyboardType: TextInputType.phone),
                _buildDropdownField("Ciudad", FontAwesomeIcons.city, _ciudades, (value) => _publicacion.ciudadId = value!),
                _buildDropdownField("Especie", FontAwesomeIcons.paw, _especies, (value) => _publicacion.especieId = value!),
                ElevatedButton(
                  style: _buildButtonStyle(),
                  onPressed: _pickImages,
                  child: const Text("Seleccionar Imágenes"),
                ),
                if (_imagenes.isNotEmpty) ..._imagenes.map((img) => _buildImagePreview(img)).toList(),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: _buildButtonStyle(),
                  onPressed: _submitForm,
                  child: const Text("Publicar"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, IconData icon, Function(String?) onSaved, {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
      keyboardType: keyboardType,
      validator: (value) => value!.isEmpty ? "Campo requerido" : null,
      onSaved: onSaved,
    );
  }

  Widget _buildNumberField(String label, IconData icon, Function(String?) onSaved) {
    return _buildTextField(label, icon, onSaved, keyboardType: TextInputType.number);
  }

  Widget _buildDropdownField(String label, IconData icon, Map<int, String> items, Function(int?) onChanged) {
    return DropdownButtonFormField<int>(
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
      value: _publicacion.ciudadId,
      items: items.entries.map((entry) => DropdownMenuItem<int>(value: entry.key, child: Text(entry.value))).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildImagePreview(File img) {
    return Image.file(img, width: 100, height: 100, fit: BoxFit.cover);
  }

  ButtonStyle _buildButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: const Color.fromRGBO(155, 60, 130, 1),
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    );
  }
}
