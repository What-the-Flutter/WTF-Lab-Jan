import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../customIcon/my_flutter_app_icons.dart';
import '../../../logic/event_page_cubit.dart';
import '../../../logic/home_screen_cubit.dart';
import '../../../repository/property_page.dart';
import '../../theme/theme.dart';
import '../../theme/theme_model.dart';
import 'event_page.dart';

class ChatPages extends StatelessWidget {
  final List<PropertyPage> pages;

  const ChatPages({Key key, this.pages}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: pages.length + 1,
      itemBuilder: (context, i) {
        if (i == 0) return _buildBot(context);
        return BlocProvider<EventPageCubit>(
            create: (context) {
              final cubit = EventPageCubit(
                repository: context.read<HomeScreenCubit>().repository,
                index: i - 1,
              );
              context.read<HomeScreenCubit>().list.add(cubit);
              return cubit;
            },
            child: EventPage(i - 1));
      },
      separatorBuilder: (context, index) => Divider(),
    );
  }

  Widget _buildBot(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Icon(
            MyFlutterApp.smart_toy_24px,
            size: 30,
          ),
          Text(
            'Questionnaire Bot',
          ),
        ],
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: Provider.of<ThemeModel>(context).currentTheme == darkTheme
            ? Colors.black
            : Colors.green[50],
      ),
      margin: EdgeInsetsDirectional.only(start: 30.0, top: 5.0, end: 30.0),
      width: 200,
      height: 50,
    );
  }
}
