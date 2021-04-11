part of 'searching_messages_cubit.dart';

abstract class SearchMessageState extends Equatable {
  final List<PropertyMessage> list;
  final PropertyPage page;

  SearchMessageState({
    this.page,
    this.list,
  });

  @override
  List<Object> get props => [
        list,
        page,
      ];

  SearchMessageState copyWith({PropertyPage page});
}

class SearchMessageScreenWait extends SearchMessageState {
  SearchMessageScreenWait({PropertyPage page}) : super(page: page);

  @override
  SearchMessageState copyWith({
    PropertyPage page,
  }) {
    return SearchMessageScreenWait(
      page: page ?? this.page,
    );
  }
}

class SearchMessageScreenNotFound extends SearchMessageState {
  SearchMessageScreenNotFound({PropertyPage page}) : super(page: page);

  @override
  SearchMessageState copyWith({
    PropertyPage page,
  }) {
    return SearchMessageScreenNotFound(
      page: page,
    );
  }
}

class SearchMessageScreenFound extends SearchMessageState {
  SearchMessageScreenFound({
    PropertyPage page,
    List<PropertyMessage> list,
  }) : super(
    page: page,
    list: list,
  );

  @override
  SearchMessageState copyWith({PropertyPage page}) {
    throw UnimplementedError();
  }
}
