import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/create_page/create_page_cubit.dart';
import '../../cubit/settings/settings_cubit.dart';
import '../../main.dart';
import '../../models/note_model.dart';

class AddNote extends StatelessWidget {
  late var textState;

  AddNote({Key? key}) : super(key: key);

  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    textState =
        BlocProvider.of<SettingsCubit>(context).state.textSize.toDouble();
    final createPageCubit = context.read<CreatePageCubit>();
    createPageCubit.loadIcons();

    if (ModalRoute.of(context)!.settings.arguments != null) {
      createPageCubit.setEditPage(
          ModalRoute.of(context)!.settings.arguments as PageCategoryInfo);
    }

    _textController.text = createPageCubit.state.editPage?.title ?? '';

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          createPageCubit.state.editPage == null
              ? 'Create new page'
              : 'Edit page',
          style: TextStyle(
            fontSize: textState + 5,
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(left: 30, right: 30, top: 30),
            child: TextFormField(
              controller: _textController,
              autofocus: true,
              keyboardType: TextInputType.text,
              maxLines: 1,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.secondary,
                    width: 0.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.secondary,
                    width: 0.0,
                  ),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.secondary,
                    width: 0.0,
                  ),
                ),
                hintText: 'Title of your note',
                helperText: '*required field, keep it short',
                helperStyle: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: textState - 3,
                ),
                labelText: 'Title',
                labelStyle: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: textState,
                ),
                contentPadding: const EdgeInsets.all(10),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: BlocBuilder<CreatePageCubit, CreatePageState>(
                builder: (context, state) {
                  return GridView.count(
                    crossAxisCount: 4,
                    padding: const EdgeInsets.all(20),
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    children: _iconList(context),
                  );
                },
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.check,
          color: Colors.white,
        ),
        backgroundColor: Colors.green,
        onPressed: () {
          if (_textController.text != '') {
            Navigator.of(context).pop(context
                .read<CreatePageCubit>()
                .createPage(_textController.text));
          }
        },
      ),
    );
  }
}

List<Widget> _iconList(BuildContext context) {
  return context.read<CreatePageCubit>().state.icons.map(
    (iconData) {
      return GestureDetector(
        onTap: () {
          context
              .read<CreatePageCubit>()
              .selectIcon(pagesIcons.indexOf(iconData));
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
          color: Theme.of(context).accentColor,
        ),
        radius: 32,
        backgroundColor: Theme.of(context).cardColor,
      ),
      if (context.read<CreatePageCubit>().state.selectedIcon ==
          context.read<CreatePageCubit>().state.icons.indexOf(iconData))
        const CircleAvatar(
          radius: 11,
          backgroundColor: Colors.white,
          child: CircleAvatar(
            radius: 9,
            backgroundColor: Colors.green,
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
