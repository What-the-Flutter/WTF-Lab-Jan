import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../cubit/records_cubit.dart';

AppBar editModeAppBar(
  BuildContext context, {
  @required int categoryId,
  @required TextEditingController controller,
}) {
  return AppBar(
    title: Text('Edit mode'),
    actions: [
      IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          context.read<RecordsCubit>().unselectAll(
                categoryId: categoryId,
              );
          controller.clear();
          FocusScope.of(context).unfocus();
        },
      ),
    ],
  );
}
