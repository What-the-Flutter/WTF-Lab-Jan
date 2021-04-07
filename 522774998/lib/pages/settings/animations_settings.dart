import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_view/photo_view_gallery.dart';
import '../../theme/theme_cubit.dart';

import '../settings/settings_page.dart';
import 'settings_page_cubit.dart';

class AnimatedDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AnimatedDialogState();
}

class AnimatedDialogState extends State<AnimatedDialog>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.ease,
      ),
    );

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: AlertDialog(
        content: Container(
          height: 150,
          width: 100,
          child: ListView(
            children: <Widget>[
              TextButton(
                child: Text(
                  'Small',
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  BlocProvider.of<SettingPageCubit>(context).changeFontSize(14);
                  _controller
                      .reverse()
                      .then((value) => Navigator.of(context).pop());
                },
              ),
              TextButton(
                child: Text(
                  'Medium',
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  BlocProvider.of<SettingPageCubit>(context).changeFontSize(16);
                  _controller
                      .reverse()
                      .then((value) => Navigator.of(context).pop());
                },
              ),
              TextButton(
                child: Text(
                  'Large',
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  BlocProvider.of<SettingPageCubit>(context).changeFontSize(18);
                  _controller
                      .reverse()
                      .then((value) => Navigator.of(context).pop());
                },
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              'Ok',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              _controller
                  .reverse()
                  .then((value) => Navigator.of(context).pop());
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class AnimatedGallery extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AnimatedGalleryState();
}

class AnimatedGalleryState extends State<AnimatedGallery>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.ease,
    );

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    void onPageChanged(int index) {
      currentIndex = index;
    }

    return Scaffold(
      body: SizeTransition(
        sizeFactor: _animation,
        axis: Axis.horizontal,
        axisAlignment: -1,
        child: Scaffold(
          body: Stack(
            children: [
              PhotoViewGallery.builder(
                itemCount: galleryItems.length,
                scrollPhysics: const BouncingScrollPhysics(),
                builder: (context, index) {
                  return PhotoViewGalleryPageOptions(
                    imageProvider: AssetImage(
                      galleryItems[index],
                    ),
                  );
                },
                loadingBuilder: (context, event) => Center(
                  child: Container(
                    width: 20.0,
                    height: 20.0,
                    child: CircularProgressIndicator(
                      value: event == null
                          ? 0
                          : event.cumulativeBytesLoaded /
                              event.expectedTotalBytes,
                    ),
                  ),
                ),
                onPageChanged: onPageChanged,
              ),
              Container(
                padding: EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CircleAvatar(
                      backgroundColor: BlocProvider.of<ThemeCubit>(context)
                          .state
                          .theme
                          .accentColor,
                      child: IconButton(
                        icon: Icon(
                          Icons.close,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          _controller
                              .reverse()
                              .then((value) => Navigator.pop(context));
                        },
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: BlocProvider.of<ThemeCubit>(context)
                          .state
                          .theme
                          .accentColor,
                      child: IconButton(
                        icon: Icon(
                          Icons.done,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          print(currentIndex);
                          BlocProvider.of<SettingPageCubit>(context)
                              .changeIndexBackground(currentIndex);
                          _controller
                              .reverse()
                              .then((value) => Navigator.pop(context));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
