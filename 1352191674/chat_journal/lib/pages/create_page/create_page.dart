import 'package:chat_journal/pages/create_page/create_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'create_extras.dart';

class CreatePage extends StatelessWidget {
  final _bloc = CreateBloc();
  final bool isEdit;
  final String pageTitle;
  final IconData pageIcon;

  CreatePage({
    Key? key,
    this.isEdit = false,
    this.pageTitle = '',
    this.pageIcon = Icons.book,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateBloc,CreateState>(
      bloc: _bloc,
      builder: (context, state) {
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () => _bloc.controller.text.isNotEmpty
                ? Navigator.pop(context, <Object>[
                    _bloc.controller.text,
                    state.currentIconIndex
                  ])
                : Navigator.pop(context),
            tooltip: 'Save',
            child: Icon(Icons.done_outlined),
            backgroundColor: Theme.of(context).accentColor,
          ),
          body: SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: Text(
                      isEdit ? 'Edit Page' : 'Create a new Page',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 30, top: 18, right: 30, bottom: 20),
                    child: TextField(
                      controller: _bloc.controller,
                      decoration: InputDecoration(
                        filled: true,
                        labelText: 'Name of the Page',
                      ),
                    ),
                  ),
                  IconsList(bloc:_bloc,state:state),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class IconsList extends StatelessWidget {
  final CreateBloc bloc;
  final CreateState state;
  const IconsList({Key? key, required this.bloc, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: iconsList.length,
      itemBuilder: (context, index) {
        return IconButton(
          icon: CircleAvatar(
            backgroundColor: state.currentIconIndex == index
                ? Theme.of(context).accentColor
                : Colors.blueGrey[600],
            radius: 28,
            child: Icon(iconsList[index], size: 35, color: Colors.white),
          ),
          onPressed: () {
            bloc.add(NewIconEvent(index));
          },
        );
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 5.0,
        crossAxisSpacing: 7.0,
      ),
    );
  }
}

final iconsList = <IconData>[
  Icons.book,
  Icons.import_contacts_outlined,
  Icons.nature_people_outlined,
  Icons.info,
  Icons.mail,
  Icons.ac_unit,
  Icons.access_time,
  Icons.camera_alt,
  Icons.hail,
  Icons.all_inbox,
];
