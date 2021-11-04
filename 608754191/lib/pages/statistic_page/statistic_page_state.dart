import '../../entity/message.dart';

class StatisticPageState {
  final List<Message>? listMessages;
  final String? selectedPeriod;
  final int? countOfBookmarkedMessagesInThePeriod;
  final int? countOfMessagesInThePeriod;

  StatisticPageState({
    this.listMessages,
    this.selectedPeriod,
    this.countOfBookmarkedMessagesInThePeriod,
    this.countOfMessagesInThePeriod,
  });

  StatisticPageState copyWith({
    final List<Message>? listMessages,
    final String? selectedPeriod,
    final int? countOfBookmarkedMessagesInPeriod,
    final int? messageCountInThePeriod,
  }) {
    return StatisticPageState(
      listMessages: listMessages ?? this.listMessages,
      selectedPeriod: selectedPeriod ?? this.selectedPeriod,
      countOfBookmarkedMessagesInThePeriod:
          countOfBookmarkedMessagesInPeriod ?? countOfBookmarkedMessagesInThePeriod,
      countOfMessagesInThePeriod: messageCountInThePeriod ?? countOfMessagesInThePeriod,
    );
  }
}
