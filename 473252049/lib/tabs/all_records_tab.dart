import 'package:chat_journal/cubits/records/records_cubit.dart';
import 'package:chat_journal/pages/category_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllRecordsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecordsCubit, RecordsState>(
      builder: (context, state) {
        if (state is RecordsLoadInProcess) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return RecordsListView(
          records: state.records,
        );
      },
    );
  }
}
