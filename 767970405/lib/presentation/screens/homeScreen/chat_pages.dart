import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../customIcon/my_flutter_app_icons.dart';
import '../../../logic/event_page_cubit.dart';
import '../../../logic/home_screen_cubit.dart';
import '../../theme/theme.dart';
import '../../theme/theme_model.dart';
import 'event_page.dart';

class ChatPages extends StatefulWidget {
  @override
  _ChatPagesState createState() => _ChatPagesState();
}

class _ChatPagesState extends State<ChatPages> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeScreenCubit, HomeScreenInitial>(
      builder: (context, state) {
        return ListView.separated(
            itemCount: context.read<HomeScreenCubit>().eventPages.length + 1,
            itemBuilder: (context, i) {
              if (i == 0) return _buildBot();
              return EventPage(i - 1);
            },
            separatorBuilder: (context, index) => Divider());
      },
    );
  }

  Widget _buildBot() {
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
