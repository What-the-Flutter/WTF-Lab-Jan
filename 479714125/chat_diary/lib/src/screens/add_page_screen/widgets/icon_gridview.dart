import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'icon_gridview_cubit/cubit.dart';

class IconsGridView extends StatelessWidget {
  final void Function(IconData) changeSelectedIcon;

  const IconsGridView({
    Key? key,
    required this.changeSelectedIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<IconGridViewCubit>(
      create: (context) => IconGridViewCubit(),
      child: BlocBuilder<IconGridViewCubit, IconGridViewState>(
        builder: (context, state) {
          return GridView.builder(
            itemCount: state.iconsOfPages.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 20,
              crossAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              return IconButton(
                onPressed: () {
                  changeSelectedIcon(state.iconsOfPages[index]);
                  context.read<IconGridViewCubit>().changeSelectedIcon(index);
                },
                icon: Icon(
                  state.iconsOfPages[index],
                  color: state.selectedIcon == index
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).colorScheme.onSecondary,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
