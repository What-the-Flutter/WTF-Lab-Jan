import 'package:bloc/bloc.dart';
import 'package:try_bloc_app/repository/messages_repository.dart';

import '../messages/widgets/message/message_cubit.dart';

part 'searching_messages_state.dart';

class SearchMessageCubit extends Cubit<SearchMessageState> {
  final MessagesRepository repository;
  final String title;
  final List<MessageCubit> list = <MessageCubit>[];

  SearchMessageCubit({
    this.repository,
    this.title,
  }) : super(SearchMessageState());
}
