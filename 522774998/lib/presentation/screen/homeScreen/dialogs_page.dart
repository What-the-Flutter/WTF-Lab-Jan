import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../../logic/dialog_page_cubit.dart';
import '../../../../logic/home_screen_cubit.dart';
import '../../../../repository/property_page.dart';
import '../../theme/theme_model.dart';
import 'dialog.dart';

class DialogsPages extends StatelessWidget {
  final List<PropertyPage> dialogs;

  const DialogsPages({Key key, this.dialogs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.loose,
      children: <Widget>[
        Container(
          color: Provider.of<ThemeModel>(context).currentTheme.primaryColor,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50), topRight: Radius.circular(50)),
            color: Colors.white,
          ),
          child: ListView.builder(
            itemCount: dialogs.length + 1,
            itemBuilder: (context, i) {
              if (i == 0) {
                return _buildBot(context);
              }
              return BlocProvider<DialogPageCubit>(
                  create: (context) {
                    final cubit = DialogPageCubit(
                      repository: context.read<HomePageCubit>().repository,
                      index: i - 1,
                    );
                    context.read<HomePageCubit>().list.add(cubit);
                    return cubit;
                  },
                  child: DialogPage(i - 1));
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBot(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            color: Colors.orange[50],
          ),
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.only(top: 10, bottom: 10),
          child: Row(
            children: [
              Icon(
                Icons.help,
                size: 35,
                color: Colors.orange,
              ),
              Text(
                'Questionnaire Bot',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
