import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../database/database.dart';
import '../entity/entities.dart';
import 'theme_provider/theme_cubit.dart';
import 'theme_provider/theme_state.dart';

enum _SocialMedia { facebook, linkedin, twitter }

class Alerts {
  static void moveAlert({
    required BuildContext context,
    required Topic currentTopic,
    required Function(Topic topic) onMoved,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        final theme = context.read<ThemeCubit>().state;
        return AlertDialog(
          backgroundColor: theme.colors.backgroundColor,
          title: Text(
            'Select the topic',
            style: TextStyle(color: theme.colors.textColor1),
          ),
          content: _topicList(currentTopic, theme, onMoved),
          actions: <Widget>[
            Container(
              padding: const EdgeInsets.only(right: 5, bottom: 5),
              child: TextButton(
                style: TextButton.styleFrom(primary: Colors.transparent),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 18,
                    color: theme.colors.textColor1,
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        );
      },
    );
  }

  static Widget _topicList(
    Topic currentTopic,
    ThemeState theme,
    Function onMoved,
  ) {
    final items = topics.values.toList();
    return Container(
      width: 250.0,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: items.length,
        itemBuilder: (context, index) => items[index].id == currentTopic.id
            ? Container()
            : GestureDetector(
                onTap: () => onMoved(items[index]),
                child: Container(
                  padding: const EdgeInsets.all(15),
                  child: Text(
                    items[index].name,
                    style: TextStyle(
                      color: theme.colors.textColor2,
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  static void shareAlert({required BuildContext context}) {
    showDialog(
      context: context,
      builder: (context) {
        final theme = context.read<ThemeCubit>().state;
        return AlertDialog(
          backgroundColor: theme.colors.backgroundColor,
          title: Text(
            'Select social media',
            textAlign: TextAlign.center,
            style: TextStyle(color: theme.colors.textColor1),
          ),
          content: _socials(),
          actions: <Widget>[
            Container(
              padding: const EdgeInsets.only(right: 5, bottom: 5),
              child: TextButton(
                style: TextButton.styleFrom(primary: Colors.transparent),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 18,
                    color: theme.colors.textColor1,
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        );
      },
    );
  }

  static Widget _socials() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _socialButton(
          icon: FontAwesomeIcons.facebookSquare,
          iconColor: Colors.blue,
          onPressed: () => share(_SocialMedia.facebook),
        ),
        _socialButton(
          icon: FontAwesomeIcons.linkedin,
          iconColor: Colors.indigo.shade400,
          onPressed: () => share(_SocialMedia.linkedin),
        ),
        _socialButton(
          icon: FontAwesomeIcons.twitterSquare,
          iconColor: Colors.lightBlueAccent,
          onPressed: () => share(_SocialMedia.twitter),
        ),
      ],
    );
  }

  static Widget _socialButton({
    required IconData icon,
    required Color iconColor,
    required Function() onPressed,
  }) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        icon,
        color: iconColor,
        size: 45,
      ),
    );
  }

  static void share(_SocialMedia social) async {
    final text = 'Best chat-diary app!\nDownload it right now when it\'s free!🔥🔥🔥';
    final url = 'play.google.com/store/apps/details?id=com.arthassson.chatdiary&hl=ru&gl=RU';

    final urls = {
      _SocialMedia.facebook: 'https://www.facebook.com/sharer/sharer.php?u=$url&text=$text',
      _SocialMedia.linkedin: 'https://www.linkedin.com/shareArticle?mini=true&url=$url',
      _SocialMedia.twitter: 'https://twitter.com/intent/tweet?url=$url&text=$text',
    };

    await launch(urls[social]!);
  }
}
