import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/screens/filter_screen/filter_screen_cubit.dart';
import '/screens/settings/settings_cubit.dart';
import '../../icons.dart';

const _emptyFilterChatList = 'Tap to select a label you want to include to the'
    'the filter. All pages are included by default.';
const _emptyFilterCategoryList =
    'Tap to select a label you want to include to the'
    'the filter. All labels are included by default.';

class FilterScreen extends StatefulWidget {
  FilterScreen({Key? key}) : super(key: key);

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  final _controller = TextEditingController();

  @override
  void initState() {
    BlocProvider.of<FilterScreenCubit>(context).fetchChatList();
    BlocProvider.of<FilterScreenCubit>(context).init();
    _controller.text =
        BlocProvider.of<FilterScreenCubit>(context).state.searchText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Filters',
          style: TextStyle(
            fontSize: BlocProvider.of<SettingsCubit>(context).state.fontSize,
          ),
        ),
      ),
      floatingActionButton: _customFloatingActionButton(),
      body: _body(),
    );
  }

  Widget _customFloatingActionButton() {
    final _blocProvider = BlocProvider.of<FilterScreenCubit>(context);
    return FloatingActionButton(
      onPressed: () {
        _blocProvider.exitFilterScreen(_controller.text);
        Navigator.pop(context);
      },
      child: const Icon(Icons.check),
      splashColor: Colors.transparent,
    );
  }

  Widget _body() {
    return BlocBuilder<FilterScreenCubit, FilterScreenState>(
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Stack(
              alignment: const Alignment(1, 0),
              children: [
                _textField(state),
                if (!state.isTextfieldEmpty)
                  IconButton(
                    onPressed: () {
                      BlocProvider.of<FilterScreenCubit>(context)
                          .clearTextField();
                      _controller.clear();
                    },
                    icon: const Icon(Icons.clear),
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                  )
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _customTab(state),
            ),
          ],
        );
      },
    );
  }

  Widget _customTab(FilterScreenState state) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: Column(
          children: [
            const TabBar(
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
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _pagesTab(state),
                  _tagsTab(state),
                  _labelsTab(state),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _textField(FilterScreenState state) {
    return TextField(
      onChanged: (value) {
        BlocProvider.of<FilterScreenCubit>(context).isTextFieldEmpty(value);
      },
      keyboardType: TextInputType.multiline,
      maxLines: null,
      controller: _controller,
      cursorColor: Colors.orange[300],
      cursorWidth: 2.5,
      decoration: InputDecoration(
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(0),
          borderSide: const BorderSide(style: BorderStyle.none),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(0),
          borderSide: const BorderSide(style: BorderStyle.none),
        ),
        hintText: 'Enter Event',
      ),
    );
  }

  Widget _startContainer(String text) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            margin: const EdgeInsets.only(left: 30, right: 30, top: 15),
            color: Theme.of(context).colorScheme.primaryVariant,
            child: Text(
              text,
              style: TextStyle(
                color: Colors.grey,
                fontSize:
                    BlocProvider.of<SettingsCubit>(context).state.fontSize,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  Widget _pagesTab(FilterScreenState state) {
    final text = state.filterChatList.isEmpty
        ? _emptyFilterChatList
        : '${state.filterChatList.length} page(s) selected';
    return SingleChildScrollView(
      child: Column(
        children: [
          _startContainer(text),
          _pageTagsList(state),
        ],
      ),
    );
  }

  Widget _tagsTab(FilterScreenState state) {
    final text = state.filterTagList.isEmpty
        ? _emptyFilterChatList
        : '${state.filterTagList.length} page(s) selected';
    return SingleChildScrollView(
      child: Column(
        children: [
          _startContainer(text),
        ],
      ),
    );
  }

  Widget _labelsTab(FilterScreenState state) {
    final text = state.filterCategoryList.isEmpty
        ? _emptyFilterCategoryList
        : '${state.filterCategoryList.length} page(s) selected';
    return SingleChildScrollView(
      child: Column(
        children: [
          _startContainer(text),
          _categoryList(state),
        ],
      ),
    );
  }

  Widget _pageTagsList(FilterScreenState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      alignment: Alignment.centerLeft,
      child: Wrap(
        spacing: 10,
        children: [
          for (int i = 0; i < state.chatList.length; i++)
            ChoiceChip(
              backgroundColor: Theme.of(context).colorScheme.primaryVariant,
              avatar: Icon(iconsData[state.chatList[i].iconIndex]),
              label: Text(state.chatList[i].elementName),
              onSelected: (selected) =>
                  BlocProvider.of<FilterScreenCubit>(context)
                      .onChatSelected(state.chatList[i]),
              selected: BlocProvider.of<FilterScreenCubit>(context)
                  .isChatSelected(state.chatList[i]),
            ),
        ],
      ),
    );
  }

  Widget _categoryList(FilterScreenState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      alignment: Alignment.centerLeft,
      child: Wrap(
        spacing: 10,
        children: [
          for (int i = 1; i < categoriesMap.length; i++)
            ChoiceChip(
              backgroundColor: Theme.of(context).colorScheme.primaryVariant,
              avatar: Icon(categoriesMap.values.elementAt(i)),
              label: Text(categoriesMap.keys.elementAt(i)),
              onSelected: (selected) =>
                  BlocProvider.of<FilterScreenCubit>(context)
                      .onCategorySelected(i),
              selected: BlocProvider.of<FilterScreenCubit>(context)
                  .isCategorySelected(i),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
