import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import 'background_image_setting_cubit.dart';
import 'background_image_setting_states.dart';

class BackgroundImageSetting extends StatefulWidget {
  @override
  _BackgroundImageSettingState createState() => _BackgroundImageSettingState();
}

class _BackgroundImageSettingState extends State<BackgroundImageSetting> {
  final BackGroundImageSettingCubit _cubit =
      BackGroundImageSettingCubit(BackgroundImageSettingStates());
  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      cubit: _cubit,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'Background image',
            ),
          ),
          body: _cubit.state.backGroundImagePath == ''
              ? Align(
                  alignment: Alignment.center,
                  child: _pickBackgroundImageColumn,
                )
              : _backgroundImageColumn,
        );
      },
    );
  }

  @override void initState(){
    _cubit.initState();
    super.initState();
  }

  Column get _pickBackgroundImageColumn {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Click the button bellow to set the background image',
        ),
        ElevatedButton(
          child: Text('Pick an image'),
          onPressed: () async {
            final image =
                await ImagePicker().getImage(source: ImageSource.gallery);
            if (image != null) {
              addBackgroundImageFromResource(File(image.path));
            }
          },
        )
      ],
    );
  }

  Column get _backgroundImageColumn {
    return Column(
      children: [
        Image.file(
          File(_cubit.state.backGroundImagePath),
        ),
        ListTile(
          leading: Icon(
            Icons.delete,
          ),
          title: Text(
            'Unset image',
          ),
          onTap: () {
            _cubit.setBackGroundImageSettingState('');
          },
        ),
        ListTile(
          leading: Icon(
            Icons.image,
          ),
          title: Text(
            'Pick a new image',
          ),
          onTap: () async {
            final image =
                await ImagePicker().getImage(source: ImageSource.gallery);
            if (image != null) {
              addBackgroundImageFromResource(File(image.path));
            }
          },
        ),
      ],
    );
  }

  Future<void> addBackgroundImageFromResource(File image) async {
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = path.basename(image.path);
    final saved = await image.copy('${appDir.path}/$fileName');
    _cubit.setBackGroundImageSettingState(saved.path);
  }

}
