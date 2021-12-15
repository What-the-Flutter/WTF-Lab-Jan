import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../pages/main_page/main_page_screen.dart';
import 'auth_cubit.dart';
import 'auth_state.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = '', password = '';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return Scaffold(
          body: state.isLoading
              ? _circularProgressContainer()
              : _singleScrollView(state),
        );
      },
    );
  }

  Widget _circularProgressContainer() {
    return Container(
      alignment: Alignment.center,
      child: const CircularProgressIndicator(),
    );
  }

  Widget _singleScrollView(AuthState state) {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: <Widget>[
            _backgroundImageContainer(),
            _contentColumn(state),
            GestureDetector(
              onTap: () async {
                _checkBiometrics(state);
              },
              child: _fingerPrintImage(),
            ),
            const SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () {
                //widget.toogleView();
              },
              child: const Text(
                "Don't have an account?",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  decoration: TextDecoration.underline,
                  letterSpacing: 0.5,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _backgroundImageContainer() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Image.asset(
        'assets/background.jpg',
        fit: BoxFit.fill,
      ),
    );
  }

  Widget _contentColumn(AuthState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _logoImage(),
        const SizedBox(
          height: 13,
        ),
        const Text(
          'CHAT JOURNAL',
          style: TextStyle(
            fontSize: 27,
            color: Colors.white,
            letterSpacing: 0.6,
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        Container(
          width: 180,
          child: const Text(
            'WTF lab',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white54, letterSpacing: 0.6, fontSize: 11),
          ),
        ),
        const SizedBox(
          height: 40,
        ),
        const Text(
          'Sign In',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 1,
            fontSize: 23,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        _subTitleRow(),
        const SizedBox(
          height: 30,
        ),
        _registrationForm(state),
        const SizedBox(
          height: 20,
        ),
        GestureDetector(
          onTap: () async {
            _anonymousAuthorization(state);
          },
          child: _anonymousContainer(),
        ),
        const SizedBox(
          height: 20,
        ),
        const Text(
          'OR',
          style: TextStyle(fontSize: 14, color: Colors.white60),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget _logoImage() {
    return Center(
      child: Image.asset(
        'assets/logo.jpg',
        height: 30,
        width: 30,
        alignment: Alignment.center,
      ),
    );
  }

  Widget _subTitleRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text(
          'Plane your life with modern chat journal!',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white70,
            letterSpacing: 1,
            fontSize: 17,
          ),
        ),
      ],
    );
  }

  Widget _fingerPrintImage() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        margin: const EdgeInsets.all(30),
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 0,
        ),
        height: 50,
        child: Image.asset(
          'assets/fingerprint.jpg',
          height: 36,
          width: 36,
        ),
      ),
    );
  }

  Widget _registrationForm(AuthState state) {
    return Form(
      key: _formKey,
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 45,
        ),
        child: Column(
          children: <Widget>[
            _validationEmailTextFormField(),
            const SizedBox(
              height: 16,
            ),
            _emailAndPasswordTextFormField(),
            const SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  BlocProvider.of<AuthCubit>(context)
                      .signInWithEmailAndPassword(email, password);
                  if (state.isAuthorized) {
                    // BlocProvider.of<AuthCubit>(context)
                    //    .loadingState(true);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => MainPageScreen(),
                      ),
                    );
                  } else {
                    print('Wrong password provided for that user.');
                  }
                }
              },
              child: _submitContainer(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _validationEmailTextFormField() {
    return TextFormField(
      validator: (val) => val!.isEmpty ? 'Enter Valid Email' : null,
      decoration: const InputDecoration(
        enabledBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        hintText: 'Email',
        hintStyle: TextStyle(color: Colors.white70, fontSize: 15),
      ),
      onSaved: (val) {
        email = val!;
      },
    );
  }

  Widget _emailAndPasswordTextFormField() {
    return TextFormField(
      obscureText: true,
      validator: (val) => val!.isEmpty ? 'Enter Password' : null,
      decoration: const InputDecoration(
        enabledBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        hintText: 'Password',
        hintStyle: TextStyle(color: Colors.white70, fontSize: 15),
      ),
      onSaved: (val) {
        password = val!;
      },
    );
  }

  void _signInWithEmailAndPassword(AuthState state) {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      BlocProvider.of<AuthCubit>(context)
          .signInWithEmailAndPassword(email, password);
      if (state.isAuthorized) {
        // BlocProvider.of<AuthCubit>(context)
        //    .loadingState(true);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MainPageScreen(),
          ),
        );
      } else {
        print('Wrong password provided for that user.');
      }
    }
  }

  Widget _submitContainer() {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 0,
      ),
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(50),
      ),
      child: const Text(
        'SUBMIT',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          letterSpacing: 1,
        ),
      ),
    );
  }

  void _anonymousAuthorization(AuthState state) {
    BlocProvider.of<AuthCubit>(context).signInAnonymously();
    if (state.isAuthorized) {
      // BlocProvider.of<AuthCubit>(context)
      //   .loadingState(true);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => MainPageScreen(),
        ),
      );
    } else {
      print('Anonymously authorization failed');
    }
  }

  Widget _anonymousContainer() {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 45,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 0,
      ),
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(50),
      ),
      child: const Text(
        'SIGN IN ANONYMOUSLY',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          letterSpacing: 1,
        ),
      ),
    );
  }

  void _checkBiometrics(AuthState state) {
    BlocProvider.of<AuthCubit>(context).checkBiometrics();
    if (state.canCheckBiometrics) {
      BlocProvider.of<AuthCubit>(context).authorizeWithBiometric();
      if (state.isAuthorized) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MainPageScreen(),
          ),
        );
      } else {
        cantCheckBiometricsDialog(context);
      }
    } else {
      cantCheckBiometricsDialog(context);
    }
  }
}

Future<void> cantCheckBiometricsDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (context) {
      return AlertDialog(
        title: const Text('No Biometrics Found'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              const Text('Can not login with Biometrics'),
            ],
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            child: const Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
