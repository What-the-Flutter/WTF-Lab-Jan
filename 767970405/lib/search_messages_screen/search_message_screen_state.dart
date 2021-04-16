part of 'search_message_screen_cubit.dart';

class SearchMessageScreenState extends Equatable {
  final ResultSearch type;
  final ModeScreen modeScreen;
  final List<ModelMessage> list;
  final List<ModelTag> tags;
  final ModelPage page;

  SearchMessageScreenState({
    this.type,
    this.page,
    this.list,
    this.tags,
    this.modeScreen,
  });

  @override
  List<Object> get props => [list, page, tags, type, modeScreen];

  SearchMessageScreenState copyWith({
    ModeScreen modeScreen,
    ModelPage page,
    ResultSearch type,
    List<ModelMessage> list,
    List<ModelTag> tags,
  }) {
    return SearchMessageScreenState(
      modeScreen: modeScreen ?? this.modeScreen,
      page: page ?? this.page,
      type: type ?? this.type,
      list: list ?? this.list,
      tags: tags ?? this.tags,
    );
  }
}
