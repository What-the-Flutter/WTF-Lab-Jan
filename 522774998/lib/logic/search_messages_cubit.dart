import 'package:bloc/bloc.dart';

import '../../repository/messages_repository.dart';
import 'screenMessagesCubits/message_cubit.dart';

part 'search_messages_state.dart';

class SearchMessageCubit extends Cubit<SearchMessageState> {
  final MessagesRepository repository;
  final String title;
  final List<MessageCubit> list = <MessageCubit>[];

  SearchMessageCubit({
    this.repository,
    this.title,
  }) : super(SearchMessageState());


}
