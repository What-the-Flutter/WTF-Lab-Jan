part of 'search_message_screen_cubit.dart';

abstract class SearchMessageScreenState extends Equatable {
  final List<ModelMessage> list;

  SearchMessageScreenState({
    this.list,
  });

  @override
  List<Object> get props => [list];
}

class SearchMessageScreenWait extends SearchMessageScreenState {
  SearchMessageScreenWait();
}

class SearchMessageScreenNotFound extends SearchMessageScreenState {
  SearchMessageScreenNotFound();
}

class SearchMessageScreenFound extends SearchMessageScreenState {
  SearchMessageScreenFound({
    List<ModelMessage> list,
  }) : super(
          list: list,
        );
}
