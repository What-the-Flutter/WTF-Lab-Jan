import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../pages/category_page.dart';
import '../pages/cubits/records/records_cubit.dart';

class TimelineTab extends StatefulWidget {
  @override
  _TimelineTabState createState() => _TimelineTabState();
}

class _TimelineTabState extends State<TimelineTab> {
  @override
  void initState() {
    context.read<RecordsCubit>().loadRecords();
    super.initState();
  }

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
