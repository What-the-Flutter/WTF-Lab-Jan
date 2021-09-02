import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../modules/page_info.dart';
import 'create_page_cubit.dart';

class CreatePageScreen extends StatelessWidget {
  final TextEditingController _pageNameController = TextEditingController();

  CreatePageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final createPageCubit = context.read<CreatePageCubit>();
    createPageCubit.loadIcons();
    createPageCubit
        .initEditPage(ModalRoute.of(context)!.settings.arguments as PageInfo?);
    _pageNameController.text = createPageCubit.state.editPage?.title ?? '';

    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 40),
        padding: const EdgeInsets.all(30),
        alignment: Alignment.center,
        child: Column(
          children: [
            Text(
              createPageCubit.state.editPage == null
                  ? 'Create New Page'
                  : 'Edit Page',
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
                    style: TextStyle(color: Theme.of(context).accentColor),
                  ),
                  TextField(
                    autofocus: true,
                    cursorColor: Theme.of(context).accentColor,
                    controller: _pageNameController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                ],
              ),
            ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createPage(context),
        child: const Icon(
          Icons.check,
          color: Colors.black,
        ),
      ),
    );
  }

  void _createPage(BuildContext context) {
    context.read<CreatePageCubit>().createPage(_pageNameController.text);
    Navigator.of(context).pop(context.read<CreatePageCubit>().state.editPage);
  }

  List<Widget> _iconList(BuildContext context) {
    return context.read<CreatePageCubit>().state.icons.map(
      (iconData) {
        return GestureDetector(
          onTap: () {
            context.read<CreatePageCubit>().selectIcon(iconData);
          },
          child: _iconListElement(context, iconData),
        );
      },
    ).toList();
  }

  Widget _iconListElement(BuildContext context, IconData iconData) {
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
        if (context.read<CreatePageCubit>().state.selectedIcon == iconData)
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
