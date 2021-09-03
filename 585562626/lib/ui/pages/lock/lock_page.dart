import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/bloc.dart';
import 'lock_content.dart';

class LockPage extends StatelessWidget {
  const LockPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LockBloc(initialState: const LockState()),
      child: LockContent(),
    );
  }
}
