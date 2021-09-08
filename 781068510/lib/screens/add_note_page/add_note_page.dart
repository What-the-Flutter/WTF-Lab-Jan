import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/create_page/create_page_cubit.dart';
import '../../models/note_model.dart';

class AddNote extends StatelessWidget {
  AddNote({Key? key}) : super(key: key);

  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final createPageCubit = context.read<CreatePageCubit>();
    createPageCubit.loadIcons();
    createPageCubit.setEditPage(
        ModalRoute
            .of(context)!
            .settings
            .arguments as PageCategoryInfo?);
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
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(left: 30, right: 30, top: 30),
            child: TextFormField(
              controller: _textController,
              autofocus: true,
              onChanged: (text) {
                // TODO???
              },
              keyboardType: TextInputType.text,
              maxLines: 1,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Title of your note',
                helperText: '*required field, keep it short',
                helperStyle: TextStyle(color: Colors.blue),
                labelText: 'Title',
                contentPadding: EdgeInsets.all(10),
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
            Navigator.of(context).pop(
                context.read<CreatePageCubit>().createPage(
                    _textController.text));
          }
        },
      ),
    );
  }
}

List<Widget> _iconList(BuildContext context) {
  return context
      .read<CreatePageCubit>()
      .state
      .icons
      .map(
        (iconData) {
      return GestureDetector(
        onTap: () {
          context.read<CreatePageCubit>().selectIcon(iconData);
        },
        child: _iconListElement(context, iconData),
      );
    },
  )
      .toList();
}

Widget _iconListElement(BuildContext context, IconData iconData) {
  return Stack(
    alignment: Alignment.bottomRight,
    children: [
      CircleAvatar(
        child: Icon(
          iconData,
          color: Theme
              .of(context)
              .accentColor,
        ),
        radius: 32,
        backgroundColor: Theme
            .of(context)
            .cardColor,
      ),
      if (context
          .read<CreatePageCubit>()
          .state
          .selectedIcon == iconData)
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
