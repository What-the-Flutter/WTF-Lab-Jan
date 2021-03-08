import 'package:chat_journal/pages/chats_cubit/chats_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/category_widget.dart';

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CategoriesListView();
  }
}

class CategoriesListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatsCubit, ChatsState>(
      builder: (context, state) {
        print('rebuild categories list view');
        return ListView.separated(
          separatorBuilder: (context, index) => Divider(),
          itemBuilder: (context, index) =>
              CategoryWidget(state.categories[index]),
          itemCount: state.categories.length,
        );
      },
    );
  }
}
