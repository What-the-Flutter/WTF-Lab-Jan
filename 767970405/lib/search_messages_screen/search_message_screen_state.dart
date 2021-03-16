part of 'search_message_screen_cubit.dart';

abstract class SearchMessageScreenState extends Equatable {
  final List<ModelMessage> list;
  final ModelPage page;

  SearchMessageScreenState({
    this.page,
    this.list,
  });

  @override
  List<Object> get props => [list, page];

  SearchMessageScreenState copyWith({ModelPage page});
}

class SearchMessageScreenWait extends SearchMessageScreenState {
  SearchMessageScreenWait({
    ModelPage page,
  }) : super(
          page: page,
        );

  @override
  SearchMessageScreenState copyWith({
    ModelPage page,
  }) {
    return SearchMessageScreenWait(
      page: page ?? this.page,
    );
  }
}

class SearchMessageScreenNotFound extends SearchMessageScreenState {
  SearchMessageScreenNotFound({
    ModelPage page,
  }) : super(
          page: page,
        );

  @override
  SearchMessageScreenState copyWith({
    ModelPage page,
  }) {
    return SearchMessageScreenNotFound(
      page: page,
    );
  }
}

class SearchMessageScreenFound extends SearchMessageScreenState {
  SearchMessageScreenFound({
    ModelPage page,
    List<ModelMessage> list,
  }) : super(
          page: page,
          list: list,
        );

  @override
  SearchMessageScreenState copyWith({ModelPage page}) {
    // TODO: implement copyWith
    throw UnimplementedError();
  }
}
