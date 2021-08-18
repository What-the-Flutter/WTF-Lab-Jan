import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hashtagable/hashtagable.dart';

import '../../../../utils/constants.dart';
import '../../../../utils/themes.dart';
import '../../../../widgets/category_item.dart';
import '../timeline_content.dart';
import 'bloc/bloc.dart';
import 'bloc/filter_bloc.dart';

class FilterContent extends StatefulWidget {
  const FilterContent({Key? key}) : super(key: key);

  @override
  _FilterContentState createState() => _FilterContentState();
}

class _FilterContentState extends State<FilterContent> {
  final _textController = TextEditingController();

  late final FilterBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read();
  }

  Widget _searchField(FetchedDataState state) {
    return Container(
      padding: const EdgeInsets.only(bottom: Insets.large),
      child: HashTagTextField(
        autofocus: false,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: 'Enter a message',
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).accentColor),
          ),
          icon: Icon(Icons.search, color: Theme.of(context).accentColor),
          suffixIcon: IconButton(
            onPressed: () => _bloc.add(const ClearQueryEvent()),
            icon: Icon(Icons.clear, color: Theme.of(context).accentColor),
          ),
        ),
        basicStyle: Theme.of(context).textTheme.bodyText2!.copyWith(
              fontSize: Theme.of(context).textTheme.bodyText2!.fontSize! + 2,
            ),
        decoratedStyle: Theme.of(context).textTheme.bodyText2!.copyWith(
              fontSize: Theme.of(context).textTheme.bodyText2!.fontSize! + 2,
              color: Theme.of(context).accentColor,
            ),
        controller: _textController,
        onChanged: (text) => _bloc.add(QueryChangedEvent(text)),
      ),
    );
  }

  Widget _tags(FetchedDataState state) {
    return Wrap(
      spacing: Insets.small,
      children: state.tags
          .map(
            (tag) => GestureDetector(
              onTap: () => _bloc.add(SelectTagEvent(tag)),
              child: Chip(
                label: Text(
                  tag.name,
                  style: Theme.of(context).textTheme.subtitle1?.copyWith(
                        color: Theme.of(context).accentIconTheme.color,
                      ),
                ),
                backgroundColor: state.selectedTags.contains(tag)
                    ? Theme.of(context).accentColor
                    : darkAccentColor,
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _categoriesGrid(FetchedDataState state) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      mainAxisSpacing: Insets.xsmall,
      crossAxisSpacing: Insets.xsmall,
      padding: const EdgeInsets.symmetric(
        vertical: Insets.small,
      ),
      childAspectRatio: 1.0,
      children: state.categories
          .map(
            (category) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(CornerRadius.card),
                border: Border.all(
                  width: 2,
                  color: state.selectedCategories.contains(category)
                      ? Theme.of(context).accentColor
                      : Theme.of(context).scaffoldBackgroundColor,
                ),
                color: state.selectedCategories.contains(category)
                    ? Theme.of(context).accentColor.withAlpha(Alpha.alpha50)
                    : null,
              ),
              child: CategoryItem(
                category: category,
                showPin: true,
                onTap: (category) => _bloc.add(SelectCategoryEvent(category)),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _fab(FilterState state) {
    return FloatingActionButton(
      heroTag: 'filter_hero',
      child: const Icon(Icons.done),
      onPressed: state is FetchedDataState
          ? () => Navigator.of(context).pop(
                FilterResult(
                  query: state.query,
                  tags: state.selectedTags,
                  categories: state.selectedCategories,
                ),
              )
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FilterBloc, FilterState>(
      listener: (context, state) {
        if (state is FetchedDataState && state.query != _textController.text) {
          _textController.text = state.query;
        }
      },
      builder: (context, state) {
        final content;
        if (state is FetchedDataState) {
          content = Padding(
            padding: const EdgeInsets.all(Insets.large),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _searchField(state),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: Insets.small),
                  child: Text('Tags', style: Theme.of(context).textTheme.subtitle2),
                ),
                _tags(state),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: Insets.small),
                  child: Text('Categories', style: Theme.of(context).textTheme.subtitle2),
                ),
                _categoriesGrid(state),
              ],
            ),
          );
        } else {
          content = const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: Text('Filter', style: Theme.of(context).appBarTheme.titleTextStyle),
            actions: [
              if (state is FetchedDataState)
                TextButton(
                  onPressed: state.filtersEnabled ? () => _bloc.add(const ResetFilter()) : null,
                  child: const Text('Reset'),
                )
            ],
          ),
          body: content,
          floatingActionButton: _fab(state),
        );
      },
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
