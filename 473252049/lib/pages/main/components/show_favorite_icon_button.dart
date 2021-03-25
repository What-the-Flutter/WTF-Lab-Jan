import 'package:chat_journal/pages/category/cubit/records_cubit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShowFavoriteIconButton extends StatelessWidget {
  final RecordsState state;
  final int categoryId;

  const ShowFavoriteIconButton({
    Key key,
    this.state,
    this.categoryId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(state is RecordsShowFavoriteSuccess
          ? Icons.bookmark
          : Icons.bookmark_outline_outlined),
      onPressed: () {
        if (state is RecordsShowFavoriteSuccess) {
          return context.read<RecordsCubit>().loadRecords(
                categoryId: categoryId,
              );
        }
        context.read<RecordsCubit>().showFavorite();
      },
    );
  }
}
