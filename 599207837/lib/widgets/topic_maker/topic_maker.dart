import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../entity/entities.dart' as entity;
import '../../main.dart';
import 'topic_maker_cubit.dart';
import 'topic_maker_state.dart';

class TopicMaker extends StatelessWidget {
  final entity.Topic? topic;
  final Function onChange;

  const TopicMaker({Key? key, this.topic, required this.onChange}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => topic == null ? TopicMakerCubit() : TopicMakerCubit.editing(topic!),
      child: _TopicMaker(
        onChange: onChange,
      ),
    );
  }
}

class _TopicMaker extends StatelessWidget {
  late final ThemeInherited themeInherited;
  final Function onChange;

  _TopicMaker({Key? key, required this.onChange}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    themeInherited = ThemeInherited.of(context)!;
    return BlocBuilder<TopicMakerCubit, TopicMakerState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: themeInherited.preset.colors.backgroundColor,
          appBar: AppBar(
            backgroundColor: themeInherited.preset.colors.themeColor1,
            title: Text(
              state.topic == null ? 'Create new topic' : 'Edit ${state.topic!.name}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.brightness_4_rounded),
                tooltip: 'Change theme',
                onPressed: () {
                  themeInherited.changeTheme();
                  context.read<TopicMakerCubit>().update();
                },
              ),
            ],
          ),
          body: Container(
            padding: const EdgeInsets.all(25),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintStyle: TextStyle(color: themeInherited.preset.colors.minorTextColor),
                    hintText: 'Enter topic name...',
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: themeInherited.preset.colors.minorTextColor,
                        width: 1,
                      ),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.teal,
                        width: 2.5,
                      ),
                    ),
                  ),
                  controller: state.nameController,
                  style: TextStyle(
                    color: themeInherited.preset.colors.textColor1,
                  ),
                ),
                const SizedBox(height: 20),
                _iconsGrid(),
                const SizedBox(height: 35),
                ElevatedButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(const EdgeInsets.all(20)),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all(Colors.teal),
                  ),
                  onPressed: () {
                    if (state.nameController!.text.isNotEmpty && state.selected != -1) {
                      context.read<TopicMakerCubit>().finish();
                      Navigator.pop(context);
                      onChange();
                    }
                  },
                  child: Text(
                    state.topic == null ? 'Add topic' : 'Save',
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: themeInherited.preset.colors.buttonColor,
            onPressed: () => Navigator.pop(context),
            child: const Icon(Icons.close_rounded),
          ),
        );
      },
    );
  }

  Widget _iconsGrid() {
    return Container(
      width: 450,
      height: 450,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black45,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          const BoxShadow(
            color: Colors.black12,
            offset: Offset(7.0, 7.0),
          ),
        ],
      ),
      child: BlocBuilder<TopicMakerCubit, TopicMakerState>(
        builder: (context, state) {
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 30,
              mainAxisSpacing: 30,
            ),
            padding: const EdgeInsets.all(20),
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: TopicMakerState.icons.length,
            itemBuilder: (context, index) {
              return _iconAvatar(
                index: index,
                radius: 40,
                iconColor: Colors.white,
                backgroundColor: themeInherited.preset.colors.avatarColor,
                onSelect: () => context.read<TopicMakerCubit>().changeSelected(index),
                selected: state.selected,
              );
            },
          );
        },
      ),
    );
  }

  Widget _iconAvatar({
    required int index,
    required double radius,
    required Color iconColor,
    required Color backgroundColor,
    required Function() onSelect,
    required int selected,
  }) {
    return GestureDetector(
      onTap: onSelect,
      child: CircleAvatar(
        child: Icon(
          TopicMakerState.icons[index],
          color: iconColor,
          size: radius,
        ),
        backgroundColor: index == selected ? Colors.teal : backgroundColor,
      ),
    );
  }
}
