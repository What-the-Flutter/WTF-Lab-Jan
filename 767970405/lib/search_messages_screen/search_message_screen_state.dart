part of 'search_message_screen_cubit.dart';

enum ModeScreen { found, notFound, wait }

class SearchMessageScreenState extends Equatable {
  final ModeScreen type;
  final List<ModelMessage> list;
  final List<ModelTag> tags;
  final ModelPage page;

  SearchMessageScreenState({
    this.type,
    this.page,
    this.list,
    this.tags,
  });

  @override
  List<Object> get props => [list, page, tags, type];

  SearchMessageScreenState copyWith({
    ModelPage page,
    ModeScreen type,
    List<ModelMessage> list,
    List<ModelTag> tags,
  }) {
    return SearchMessageScreenState(
      page: page ?? this.page,
      type: type ?? this.type,
      list: list ?? this.list,
      tags: tags ?? this.tags,
    );
  }
}
