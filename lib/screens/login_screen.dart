import 'package:flutter/material.dart';
import 'package:app_bows_celia/providers/login_form_provider.dart';
import 'package:app_bows_celia/ui/input_decorations.dart';
import 'package:app_bows_celia/widgets/widgets.dart';
import 'package:provider/provider.dart';

import '../services/services.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: LoginBackground(
            child: SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 150),
          CardContainer(
            child: Column(
              children: [
                Image.asset(
                  'assets/logo.png',
                  width: 100,
                ),
                const SizedBox(height: 10),
                Text('Inicio de sesión',
                    style: Theme.of(context).textTheme.headline4),
                const SizedBox(height: 30),
                ChangeNotifierProvider(
                    create: (_) => LoginFormProvider(), child: _LoginForm())
              ],
            ),
          ),
          const SizedBox(height: 50),
          TextButton(
            onPressed: () =>
                Navigator.pushReplacementNamed(context, 'register'),
            style: ButtonStyle(
                overlayColor:
                    MaterialStateProperty.all(Colors.purple.withOpacity(0.1)),
                shape: MaterialStateProperty.all(const StadiumBorder())),
            child: const Text(
              'Crear una nueva cuenta',
              style: TextStyle(fontSize: 18, color: Colors.black87),
            ),
          ),
          const SizedBox(height: 50),
        ],
      ),
    )));
  }
}

class _LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);
    return SizedBox(
      child: Form(
        key: loginForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                  hintText: '',
                  labelText: 'Correo electrónico',
                  prefixIcon: Icons.person),
              onChanged: (value) => loginForm.email = value,
              validator: (value) {
                String pattern =
                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regExp = RegExp(pattern);
                return regExp.hasMatch(value ?? '')
                    ? null
                    : 'El correo no es valido';
              },
            ),
            const SizedBox(height: 30),
            TextFormField(
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                  hintText: '',
                  labelText: 'Contraseña',
                  prefixIcon: Icons.lock_outline),
              onChanged: (value) => loginForm.password = value,
              validator: (value) {
                return (value != null && value.length >= 6)
                    ? null
                    : 'La contraseña debe ser de mínimo 6 caracteres';
              },
            ),
            const SizedBox(height: 30),
            MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                disabledColor: Colors.grey,
                elevation: 0,
                color: Colors.deepPurple,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 80, vertical: 30),
                  child: Text(
                    loginForm.isLoading ? 'Espere...' : 'Ingresar',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                onPressed: loginForm.isLoading
                    ? null
                    : () async {
                        FocusScope.of(context).unfocus();
                        final authService =
                            Provider.of<AuthService>(context, listen: false);
                        if (!loginForm.isValidForm()) return;
                        loginForm.isLoading = true;
                        final String? errorMessage = await authService.login(
                            loginForm.email, loginForm.password);
                        if (errorMessage == null) {
                          Navigator.pushReplacementNamed(context, 'home');
                        } else {
                          //print(errorMessage);
                          NotificationService.showSnackbar(errorMessage);
                          loginForm.isLoading = false;
                        }
                      })
          ],
        ),
      ),
    );
  }
}
