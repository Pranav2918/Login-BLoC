import 'package:bloc_login/auth/auth_repo.dart';
import 'package:bloc_login/auth/login/formsubmission.dart';
import 'package:bloc_login/auth/login/loginbloc.dart';
import 'package:bloc_login/auth/login/loginevent.dart';
import 'package:bloc_login/auth/login/loginstate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.black, title: Text('Login Through BLoC')),
      backgroundColor: Colors.black,
      body: BlocProvider(
          create: (context) =>
              LoginBloc(authRepo: context.read<AuthRepository>()),
          child: loginForm()),
    );
  }

  Widget loginForm() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            usernamesField(),
            passwordField(),
            SizedBox(height: 10),
            // loginButton()
            BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
              return state.formStatus is FormSubmitting
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<LoginBloc>().add(LoginSubmitted());
                        }
                      },
                      child: Text('Login'),
                    );
            })
          ],
        ),
      ),
    );
  }
}

Widget usernamesField() {
  return BlocBuilder<LoginBloc, LoginState>(
    builder: (context, state) {
      return Container(
        margin: EdgeInsets.only(bottom: 25),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            validator: (value) =>
                state.isValidUsername ? null : 'Username is too short.',
            decoration: InputDecoration(
                icon: Icon(Icons.person, color: Colors.white),
                hintText: 'Usernames',
                hintStyle: TextStyle(color: Colors.white, letterSpacing: 1.0),
                border: InputBorder.none),
            onChanged: (value) => context
                .read<LoginBloc>()
                .add(LoginPasswordChanged(password: value)),
          ),
        ),
      );
    },
  );
}

Widget passwordField() {
  return BlocBuilder<LoginBloc, LoginState>(
    builder: (context, state) {
      return Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            validator: (val) =>
                state.isValidPassword ? null : 'Password is too short.',
            obscureText: true,
            decoration: InputDecoration(
                icon: Icon(Icons.security, color: Colors.white),
                hintText: 'Password',
                hintStyle: TextStyle(color: Colors.white, letterSpacing: 1.0),
                border: InputBorder.none),
            onChanged: (value) => context
                .read<LoginBloc>()
                .add(LoginUsernameChanged(username: value)),
          ),
        ),
      );
    },
  );
}
