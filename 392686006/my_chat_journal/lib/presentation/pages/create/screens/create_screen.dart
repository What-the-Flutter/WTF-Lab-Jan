import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entities/event_info.dart';
import '../cubit/create_page_cubit.dart';

class CreateScreen extends StatelessWidget {
  CreateScreen({
    Key? key,
    this.eventInfo,
  }) : super(key: key);

  final EventInfo? eventInfo;
  final TextEditingController _pageNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final createPageCubit = context.read<CreatePageCubit>();
    createPageCubit.loadIcons();
    createPageCubit.setEditPage(eventInfo);
    _pageNameController.text = createPageCubit.state.editPage?.title ?? '';

    return Scaffold(
      body: _body(context, createPageCubit),
      floatingActionButton: _floatingActionButton(context),
    );
  }

  FloatingActionButton _floatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _continueCreatingPageOrCancel(context),
      child: _pageNameController.text.isEmpty
          ? const Icon(
              Icons.clear,
              color: Colors.black,
            )
          : const Icon(
              Icons.check,
              color: Colors.black,
            ),
    );
  }

  Widget _body(BuildContext context, dynamic createPageCubit) {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Container(
        padding: const EdgeInsets.all(30),
        alignment: Alignment.center,
        child: Column(
          children: [
            Text(
              createPageCubit.state.editPage == null ? 'Create New Page' : 'Edit Page',
              style: const TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
              ),
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Name of the Page',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                  TextField(
                    autofocus: true,
                    cursorColor: Theme.of(context).primaryColor,
                    controller: _pageNameController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                ],
              ),
            ),
            //TODO
            BlocBuilder<CreatePageCubit, CreatePageState>(
              builder: (context, state) {
                return Expanded(
                  child: GridView.count(
                    padding: const EdgeInsets.all(20),
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    crossAxisCount: 4,
                    children: _iconList(context),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _continueCreatingPageOrCancel(BuildContext context) {
    Navigator.of(context).pop(
      context.read<CreatePageCubit>().createPage(_pageNameController.text),
    );
  }

  List<Widget> _iconList(BuildContext context) {
    return context.read<CreatePageCubit>().state.icons.map(
      (iconData) {
        return GestureDetector(
          onTap: () {
            context.read<CreatePageCubit>().currentIcon(iconData);
          },
          child: _iconListElement(context, iconData),
        );
      },
    ).toList();
  }

  Stack _iconListElement(BuildContext context, IconData iconData) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatar(
          child: Icon(
            iconData,
            color: Colors.white,
          ),
          radius: 32,
          backgroundColor: Theme.of(context).cardColor,
        ),
        if (context.read<CreatePageCubit>().state.currentIcon == iconData)
          const CircleAvatar(
            radius: 11,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 9,
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              child: Icon(
                Icons.check,
                color: Colors.white,
                size: 17,
              ),
            ),
          ),
      ],
    );
  }
}
