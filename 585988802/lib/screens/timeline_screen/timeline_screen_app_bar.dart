import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/font_size_customization.dart';
import '../setting_screen/settings_screen_bloc.dart';
import 'timeline_bloc.dart';
import 'timeline_event.dart';

class TimelineScreenAppBar extends StatefulWidget
    implements PreferredSizeWidget {
  TimelineScreenAppBar({Key key}) : super(key: key);

  @override
  _TimelineScreenAppBarState createState() => _TimelineScreenAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(56);
}

class _TimelineScreenAppBarState extends State<TimelineScreenAppBar> {
  _TimelineScreenAppBarState();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).appBarTheme.color,
      iconTheme: Theme.of(context).iconTheme,
      title: BlocProvider.of<TimelineScreenBloc>(context)
              .state
              .isSearchIconButtonPressed
          ? TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: TextStyle(
                  color: Colors.white70,
                ),
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(25.0),
                  ),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                filled: true,
                fillColor: Colors.white38,
              ),
              onChanged: (value) {
                BlocProvider.of<TimelineScreenBloc>(context).add(
                  TimelineEventMessageListFiltered(
                      BlocProvider.of<TimelineScreenBloc>(context)
                          .state
                          .eventMessageList,
                      value),
                );
                BlocProvider.of<TimelineScreenBloc>(context)
                    .add(TimelineEventMessageListFilteredReceived());
              },
            )
          : Container(
              child: Text(
                'Timeline',
                style: TextStyle(
                  color: Theme.of(context).secondaryHeaderColor,
                  fontSize: BlocProvider.of<SettingScreenBloc>(context)
                              .state
                              .fontSize ==
                          0
                      ? appBarSmallFontSize
                      : BlocProvider.of<SettingScreenBloc>(context)
                                  .state
                                  .fontSize ==
                              1
                          ? appBarDefaultFontSize
                          : appBarLargeFontSize,
                ),
              ),
              alignment: Alignment.centerLeft,
            ),
      elevation: 0.0,
      actions: [
        BlocProvider.of<TimelineScreenBloc>(context)
                .state
                .isSearchIconButtonPressed
            ? IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  BlocProvider.of<TimelineScreenBloc>(context).add(
                    TimelineSearchIconButtonUnpressed(
                      BlocProvider.of<TimelineScreenBloc>(context)
                          .state
                          .eventMessageList,
                      BlocProvider.of<TimelineScreenBloc>(context)
                          .state
                          .isSearchIconButtonPressed,
                    ),
                  );
                },
              )
            : IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  BlocProvider.of<TimelineScreenBloc>(context).add(
                    TimelineSearchIconButtonPressed(
                        BlocProvider.of<TimelineScreenBloc>(context)
                            .state
                            .isSearchIconButtonPressed),
                  );
                },
              ),
        IconButton(
          icon: Icon(
            Icons.bookmark_border_outlined,
            color: BlocProvider.of<TimelineScreenBloc>(context)
                    .state
                    .isFavoriteButPressed
                ? Colors.orangeAccent
                : Theme.of(context).iconTheme.color,
          ),
          onPressed: () {
            BlocProvider.of<TimelineScreenBloc>(context).add(
              TimelineFavoriteButPressed(
                  BlocProvider.of<TimelineScreenBloc>(context)
                      .state
                      .isFavoriteButPressed),
            );
          },
        ),
      ],
    );
  }
}
