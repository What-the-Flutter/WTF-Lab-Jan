import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import 'background_image_setting_cubit.dart';

class BackgroundImageSetting extends StatefulWidget {
  @override
  _BackgroundImageSettingState createState() => _BackgroundImageSettingState();
}

class _BackgroundImageSettingState extends State<BackgroundImageSetting> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BackGroundImageSettingCubit, String>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text('Background image'),
          ),
          body: BlocProvider.of<BackGroundImageSettingCubit>(context)
                  .state
                  .isEmpty
              ? Align(
                  alignment: Alignment.center,
                  child: _pickBackgroundImageColumn,
                )
              : _backgroundImageColumn,
        );
      },
    );
  }

  @override
  void initState() {
    BlocProvider.of<BackGroundImageSettingCubit>(context).initState();
    super.initState();
  }

  Column get _pickBackgroundImageColumn {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Click the button bellow to set the background image'),
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
          File(BlocProvider.of<BackGroundImageSettingCubit>(context).state),
        ),
        ListTile(
          leading: Icon(Icons.delete),
          title: Text('Unset image'),
          onTap: () => BlocProvider.of<BackGroundImageSettingCubit>(context)
              .setBackGroundImageSettingState(''),
        ),
        ListTile(
          leading: Icon(Icons.image),
          title: Text('Pick a new image'),
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
    BlocProvider.of<BackGroundImageSettingCubit>(context)
        .setBackGroundImageSettingState(saved.path);
  }
}
