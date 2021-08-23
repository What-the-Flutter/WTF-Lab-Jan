import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utils/constants.dart';
import '../../../widgets/pie_chart.dart';
import 'bloc/bloc.dart';
import 'bloc/stats_bloc.dart';

class StatsContent extends StatefulWidget {
  const StatsContent({Key? key}) : super(key: key);

  @override
  _StatsContentState createState() => _StatsContentState();
}

class _StatsContentState extends State<StatsContent> with SingleTickerProviderStateMixin {
  late final StatsBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read();
  }

  Widget _notes(FetchedNotesState state) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              Insets.large,
              Insets.large,
              Insets.small,
              Insets.small,
            ),
            child: _statsElement(
              Icons.sticky_note_2_outlined,
              Theme.of(context).accentColor,
              'Total',
              state.notes.length,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              Insets.small,
              Insets.large,
              Insets.large,
              Insets.small,
            ),
            child: _statsElement(
              Icons.star,
              Colors.amber,
              'Starred',
              state.notes.where((element) => element.note.hasStar).length,
            ),
          ),
        ),
      ],
    );
  }

  Widget _statsElement(IconData icon, Color color, String name, dynamic data) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(CornerRadius.card),
        color: Theme.of(context).cardColor,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: Insets.medium,
        horizontal: Insets.large,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(Insets.small),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(CornerRadius.circle),
              color: color.withAlpha(Alpha.alpha50),
            ),
            child: Icon(icon, color: color),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: Insets.small),
            child: Text(name),
          ),
          Text(
            '$data',
            style: Theme.of(context).textTheme.bodyText2?.copyWith(
                  fontSize: FontSize.superLarge,
                ),
          ),
        ],
      ),
    );
  }

  Widget _categories(int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Insets.large,
        vertical: Insets.small,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(CornerRadius.card),
          color: Theme.of(context).cardColor,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: Insets.medium,
          horizontal: Insets.large,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(Insets.small),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(CornerRadius.circle),
                color: Colors.pinkAccent.withAlpha(Alpha.alpha50),
              ),
              child: const Icon(Icons.category, color: Colors.pinkAccent),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: Insets.medium),
              child: Text('Categories'),
            ),
            Expanded(
              child: Text(
                '$count',
                style: Theme.of(context).textTheme.bodyText2?.copyWith(
                      fontSize: FontSize.superLarge,
                    ),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatsBloc, StatsState>(
      builder: (context, state) {
        final content;
        if (state is FetchedNotesState) {
          content = state.notes.isEmpty
              ? Center(
                  child: Text('Nothing found.', style: Theme.of(context).textTheme.bodyText2),
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: Insets.xmedium),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: StatsPieChart(data: state.categoryCountData),
                      ),
                    ),
                    _notes(state),
                    _categories(state.categoryAmount),
                  ],
                );
        } else {
          content = Center(
            child: CircularProgressIndicator(color: Theme.of(context).accentColor),
          );
        }
        return Scaffold(body: content);
      },
    );
  }
}
