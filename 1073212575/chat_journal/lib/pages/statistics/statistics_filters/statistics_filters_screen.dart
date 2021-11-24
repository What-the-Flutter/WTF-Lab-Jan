import 'package:chat_journal/pages/statistics/statistics_filters/statistics_filters_cubit.dart';
import 'package:chat_journal/pages/statistics/statistics_filters/statistics_filters_state.dart';
import 'package:chat_journal/theme/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



class StatisticsFiltersPage extends StatefulWidget {
  @override
  _StatisticsFiltersPageState createState() => _StatisticsFiltersPageState();
}

class _StatisticsFiltersPageState extends State<StatisticsFiltersPage> {
  final _controller = TextEditingController();

  @override
  void initState() {
    BlocProvider.of<StatisticsFiltersPageCubit>(context).init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var first = Theme.of(context).colorScheme.secondary;
    var second = Theme.of(context).colorScheme.onSecondary;
    var third = Theme.of(context).colorScheme.secondaryVariant;
    return BlocBuilder<StatisticsFiltersPageCubit, StatisticsFiltersPageState>(
      builder: (blocContext, state) {
        return AnimatedContainer(
          duration: const Duration(seconds: 1),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                first,
                state.isColorChanged ? second : first,
                state.isColorChanged ? third : first,
              ],
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: _appBar(),
            floatingActionButton: _floatingActionButton(),
            body: Column(
              children: [
                _pagesFilter(state),
              ],
            ),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(radiusValue),
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded),
        onPressed: () => Navigator.pop(context,BlocProvider.of<StatisticsFiltersPageCubit>(context).filterParameters()),
      ),
      title: const Text('Filters'),
    );
  }

  Widget _floatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.pop(context,BlocProvider.of<StatisticsFiltersPageCubit>(context).filterParameters());
      },
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: Icon(
        Icons.check,
        color: Theme.of(context).colorScheme.secondaryVariant,
      ),
    );
  }

  Widget _pagesFilter(StatisticsFiltersPageState state) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(20),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(
              Radius.circular(radiusValue),
            ),
            child: Container(
              padding: const EdgeInsets.all(10),
              height: 80,
              color: Theme.of(context).colorScheme.onPrimary,
              child: Text(
                BlocProvider.of<StatisticsFiltersPageCubit>(context).pagesInfo(),
                textAlign: TextAlign.center,
                style:
                TextStyle(color: Theme.of(context).colorScheme.background),
              ),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 20),
          child: Row(
            children: [
              Text(
                'Ignore selected pages',
                style:
                TextStyle(color: Theme.of(context).colorScheme.background),
              ),
              Switch(
                value: state.parameters.arePagesIgnored,
                onChanged: (value) {
                  BlocProvider.of<StatisticsFiltersPageCubit>(context)
                      .changeIgnorePages();
                },
                activeTrackColor: Theme.of(context).colorScheme.onSecondary,
                activeColor: Theme.of(context).colorScheme.secondaryVariant,
              ),
            ],
          ),
        ),
        _pages(state),
      ],
    );
  }

  Widget _pages(StatisticsFiltersPageState state) {
    return Wrap(
      spacing: 10,
      children: [
        for (var i = 0; i < state.eventPages.length; i++)
          Container(
            width: 120,
            margin: const EdgeInsets.only(top: 5),
            child: ElevatedButton(
              style: ButtonStyle(
                shadowColor:
                MaterialStateProperty.all<Color>(Colors.transparent),
                backgroundColor: MaterialStateProperty.all<Color>(
                    (BlocProvider.of<StatisticsFiltersPageCubit>(context)
                        .isPageSelected(state.eventPages[i].id))
                        ? Theme.of(context).colorScheme.surface
                        : Theme.of(context).colorScheme.onPrimary),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(radiusValue),
                    ),
                  ),
                ),
              ),
              onPressed: () =>
                  BlocProvider.of<StatisticsFiltersPageCubit>(context).onPagePressed(
                    state.eventPages[i].id,
                  ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Icon(
                      state.eventPages[i].icon,
                      color: Theme.of(context).colorScheme.primaryVariant,
                      size: 20,
                    ),
                  ),
                  Text(
                    state.eventPages[i].name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.background,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
