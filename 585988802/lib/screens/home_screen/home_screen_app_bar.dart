import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common_widgets/change_theme_button_widget.dart';
import '../../models/font_size_customization.dart';
import '../../theme/theme_bloc.dart';
import '../setting_screen/settings_screen_bloc.dart';

class HomeScreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: Theme.of(context).iconTheme,
      backgroundColor: Theme.of(context).appBarTheme.color,
      title: Container(
        child: Text(
          'Home',
          style: TextStyle(
            color: BlocProvider.of<ThemeBloc>(context).state == ThemeMode.dark
                ? Theme.of(context).accentColor
                : Theme.of(context).primaryColor,
            fontSize:
                BlocProvider.of<SettingScreenBloc>(context).state.fontSize == 0
                    ? appBarSmallFontSize
                    : BlocProvider.of<SettingScreenBloc>(context)
                                .state
                                .fontSize ==
                            1
                        ? appBarDefaultFontSize
                        : appBarLargeFontSize,
          ),
        ),
        alignment: Alignment.center,
      ),
      elevation: 0.0,
      actions: [
        ChangeThemeButtonWidget(),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
