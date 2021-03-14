import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/records/records_cubit.dart';
import '../pages/category_page.dart';

class TimelineTab extends StatelessWidget {
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