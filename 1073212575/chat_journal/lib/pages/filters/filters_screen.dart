import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jiffy/jiffy.dart';

import '../../models/categories.dart';
import '../../theme/themes.dart';
import 'filters_cubit.dart';
import 'filters_state.dart';

class FiltersPage extends StatefulWidget {
  @override
  _FiltersPageState createState() => _FiltersPageState();
}

class _FiltersPageState extends State<FiltersPage> {
  final _controller = TextEditingController();

  @override
  void initState() {
    BlocProvider.of<FiltersPageCubit>(context).init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var first = Theme.of(context).colorScheme.secondary;
    var second = Theme.of(context).colorScheme.onSecondary;
    var third = Theme.of(context).colorScheme.secondaryVariant;
    return BlocBuilder<FiltersPageCubit, FiltersPageState>(
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
                _textField(),
                _filters(state),
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
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text('Filters'),
    );
  }

  Widget _floatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        Navigator.pop(context);
        BlocProvider.of<FiltersPageCubit>(context)
            .setSearchText(_controller.text);
        _controller.clear();
      },
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: Icon(
        Icons.check,
        color: Theme.of(context).colorScheme.secondaryVariant,
      ),
    );
  }

  Widget _textField() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(
          Radius.circular(radiusValue),
        ),
        child: Container(
          height: 50,
          color: Theme.of(context).colorScheme.onPrimary,
          child: TextField(
            style: TextStyle(
              color: Theme.of(context).colorScheme.background,
            ),
            controller: _controller,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.all(10),
              border: InputBorder.none,
              hintText: 'Search Query',
              hintStyle: TextStyle(
                color: Color(0xFFE5E0EF),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _filters(FiltersPageState state) {
    return Container(
      height: 350,
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            toolbarHeight: 0,
            automaticallyImplyLeading: false,
            bottom: const TabBar(
              tabs: [
                Tab(
                  text: 'Pages',
                ),
                Tab(
                  text: 'Tags',
                ),
                Tab(
                  text: 'Labels',
                ),
                Tab(
                  text: 'Others',
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              _pagesFilter(state),
              _tagsFilter(state),
              _labelsFilter(state),
              _othersFilter(state),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pagesFilter(FiltersPageState state) {
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
                BlocProvider.of<FiltersPageCubit>(context).pagesInfo(),
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
                  BlocProvider.of<FiltersPageCubit>(context)
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

  Widget _pages(FiltersPageState state) {
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
                    (BlocProvider.of<FiltersPageCubit>(context)
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
                  BlocProvider.of<FiltersPageCubit>(context).onPagePressed(
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

  Widget _tagsFilter(FiltersPageState state) {
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
                BlocProvider.of<FiltersPageCubit>(context).tagsInfo(),
                style:
                    TextStyle(color: Theme.of(context).colorScheme.background),
              ),
            ),
          ),
        ),
        _tags(state),
      ],
    );
  }

  Widget _tags(FiltersPageState state) {
    return Wrap(
      spacing: 10,
      children: [
        for (var i = 0; i < state.hashTags.length; i++)
          Container(
            width: 120,
            margin: const EdgeInsets.only(top: 5),
            child: ElevatedButton(
              style: ButtonStyle(
                shadowColor:
                    MaterialStateProperty.all<Color>(Colors.transparent),
                backgroundColor: MaterialStateProperty.all<Color>(
                    (BlocProvider.of<FiltersPageCubit>(context)
                            .isTagSelected(state.hashTags[i]))
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
                  BlocProvider.of<FiltersPageCubit>(context).onTagsPressed(
                state.hashTags[i],
              ),
              child: Text(
                state.hashTags[i],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.background,
                  fontSize: 15,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _labelsFilter(FiltersPageState state) {
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
                BlocProvider.of<FiltersPageCubit>(context).labelsInfo(),
                style:
                    TextStyle(color: Theme.of(context).colorScheme.background),
              ),
            ),
          ),
        ),
        _labels(state),
      ],
    );
  }

  Widget _labels(FiltersPageState state) {
    return Wrap(
      spacing: 10,
      children: [
        for (var i = 0; i < categories.length; i++)
          Container(
            width: 130,
            margin: const EdgeInsets.only(top: 5),
            child: ElevatedButton(
              style: ButtonStyle(
                shadowColor:
                    MaterialStateProperty.all<Color>(Colors.transparent),
                backgroundColor: MaterialStateProperty.all<Color>(
                    (BlocProvider.of<FiltersPageCubit>(context)
                            .isLabelSelected(categories[i]))
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
                  BlocProvider.of<FiltersPageCubit>(context).onLabelPressed(
                categories[i],
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Icon(
                      categories[i].icon,
                      color: Theme.of(context).colorScheme.primaryVariant,
                      size: 20,
                    ),
                  ),
                  Text(
                    categories[i].name,
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

  Widget _othersFilter(FiltersPageState state) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(20),
          child: GestureDetector(
            onTap: () => _selectDate(context),
            child: Row(
              children: [
                const Icon(Icons.event),
                Column(
                  children: [
                    Text(
                      'Jump to date',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.background),
                    ),
                    if (state.parameters.isDateSelected)
                      Text(
                        Jiffy(state.parameters.date).format('d/M/y'),
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.background),
                      ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shadowColor:
                          MaterialStateProperty.all<Color>(Colors.transparent),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Theme.of(context).colorScheme.onPrimary),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(radiusValue),
                          ),
                        ),
                      ),
                    ),
                    onPressed: () =>
                        BlocProvider.of<FiltersPageCubit>(context).resetDate(),
                    child: Text(
                      'Reset',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.background),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Text(
                'Ignore selected pages',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.background),
              ),
              Switch(
                value: state.parameters.onlyCheckedMessages,
                onChanged: (value) {
                  BlocProvider.of<FiltersPageCubit>(context)
                      .changeCheckedMessagesDisplay();
                },
                activeTrackColor: Theme.of(context).colorScheme.onSecondary,
                activeColor: Theme.of(context).colorScheme.secondaryVariant,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _selectDate(BuildContext context) async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2010),
      lastDate: DateTime(2025),
    );
    BlocProvider.of<FiltersPageCubit>(context).setDate(newDate);
  }
}
