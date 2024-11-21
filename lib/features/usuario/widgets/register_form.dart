import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:app_pets/data/api/users.dart';
import 'package:app_pets/data/models/user.dart';
import 'custom_text_field.dart';
import 'register_button.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();

  bool isLoading = false;

  void _registerUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      final user = User(
        nombre: _nombreController.text,
        apellido: _apellidoController.text,
        email: _emailController.text,
        password: _passwordController.text,
        telefono: _telefonoController.text,
      );

      try {
        final success = await UserApi().registerUser(user);
        setState(() {
          isLoading = false;
        });

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Usuario registrado exitosamente'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text(
              'Registro',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),

          CustomTextField(
            controller: _nombreController,
            label: 'Nombre',
            icon: FontAwesomeIcons.user,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'El nombre es obligatorio';
              }
              return null;
            },
          ),

          CustomTextField(
            controller: _apellidoController,
            label: 'Apellido',
            icon: FontAwesomeIcons.userLarge,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'El apellido es obligatorio';
              }
              return null;
            },
          ),

          CustomTextField(
            controller: _telefonoController,
            label: 'Teléfono',
            icon: FontAwesomeIcons.phone,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'El teléfono es obligatorio';
              }
              return null;
            },
          ),

          CustomTextField(
            controller: _emailController,
            label: 'Correo Electrónico',
            icon: FontAwesomeIcons.envelope,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'El correo es obligatorio';
              } else if (!value.contains('@')) {
                return 'Ingrese un correo válido';
              }
              return null;
            },
          ),

          CustomTextField(
            controller: _passwordController,
            label: 'Contraseña',
            icon: FontAwesomeIcons.lock,
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'La contraseña es obligatoria';
              } else if (value.length < 6) {
                return 'Debe tener al menos 6 caracteres';
              }
              return null;
            },
          ),

          const SizedBox(height: 20),

          Center(
            child: RegisterButton(
              isLoading: isLoading,
              onPressed: isLoading ? null : _registerUser,
            ),
          ),
        ],
      ),
    );
  }
}
