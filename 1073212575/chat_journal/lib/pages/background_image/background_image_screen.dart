import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../theme/themes.dart';
import 'background_image_cubit.dart';
import 'background_image_state.dart';

class BackgroundImagePage extends StatefulWidget {
  @override
  _BackgroundImageState createState() => _BackgroundImageState();
}

class _BackgroundImageState extends State<BackgroundImagePage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BackgroundImageCubit, BackgroundImageState>(
      builder: (blocContext, state) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).colorScheme.secondary,
                Theme.of(context).colorScheme.onSecondary,
                Theme.of(context).colorScheme.secondaryVariant,
              ],
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: _appBar(),
            body:
                state.isImageSetted ? _changeImage(state) : _pickImageButton(),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(radiusValue),
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text('Background image'),
    );
  }

  Widget _pickImageButton() {
    return Center(
      child: ElevatedButton(
        onPressed: BlocProvider.of<BackgroundImageCubit>(context).setImage,
        child: const Text('Pick an image'),
      ),
    );
  }

  Widget _changeImage(BackgroundImageState state) {
    return Column(
      children: [
        Image.file(
          File(state.imagePath),
          height: 300,
        ),
        ElevatedButton(
          onPressed: BlocProvider.of<BackgroundImageCubit>(context).unsetImage,
          child: Row(
            children: [
              const Icon(Icons.delete_rounded),
              const Text('Unset image'),
            ],
          ),
        ),
        ElevatedButton(
          onPressed: BlocProvider.of<BackgroundImageCubit>(context).setImage,
          child: Row(
            children: [
              const Icon(Icons.image_rounded),
              const Text('Pick a new image'),
            ],
          ),
        ),
      ],
    );
  }
}
