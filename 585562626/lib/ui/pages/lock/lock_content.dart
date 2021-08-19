import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';

import '../home/home_page.dart';
import 'bloc/bloc.dart';

class LockContent extends StatefulWidget {
  @override
  _LockContentState createState() => _LockContentState();
}

class _LockContentState extends State<LockContent> {
  final _localAuthentication = LocalAuthentication();
  late LockBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<LockBloc>();
    _authenticateMe();
  }

  Future<void> _authenticateMe() async {
    try {
      final result = await _localAuthentication.authenticate(
        localizedReason: 'Authenticate to enter the app',
        useErrorDialogs: true,
        stickyAuth: true,
        biometricOnly: true,
      );
      _bloc.add(AuthenticateEvent(isAuthenticated: result));
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LockBloc, LockState>(
      listener: (context, state) {
        if (state.authenticated == true) {
          Navigator.of(context).popAndPushNamed(HomePage.routeName);
        } else if (state.authenticated == false) {
          SystemChannels.platform.invokeMethod('SystemNavigator.pop', true);
        } else {
          _authenticateMe();
        }
      },
      child: Container(
        color: Theme.of(context).accentColor,
        alignment: Alignment.topCenter,
        child: FractionallySizedBox(
          widthFactor: 0.5,
          heightFactor: 0.5,
          child: Image.asset('assets/lock.png'),
        ),
      ),
    );
  }
}
