import 'package:flutter/material.dart';

import '../../main/components/show_favorite_icon_button.dart';
import '../../search_record_page.dart';
import '../cubit/records_cubit.dart';

AppBar defaultAppBar(
  BuildContext context, {
  RecordsState state,
  int categoryId,
  String categoryName,
}) {
  return AppBar(
    title: Text(categoryName),
    actions: [
      ShowFavoriteIconButton(
        state: state,
        categoryId: categoryId,
      ),
      IconButton(
        icon: Icon(Icons.search),
        onPressed: () {
          showSearch(
            context: context,
            delegate: SearchRecordPage(
              context: context,
              records: state.records,
            ),
          );
        },
      ),
    ],
  );
}
