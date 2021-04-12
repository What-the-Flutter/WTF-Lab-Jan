import '../../properties/property_message.dart';
import '../../properties/property_page.dart';

class StatisticsState {
  final String timeline;
  final List<PropertyPage> pages;
  final List<PropertyMessage> messages;

  StatisticsState(
    this.timeline,
    this.messages,
    this.pages,
  );

  StatisticsState copyWith({
    String timeline,
    List<PropertyPage> pages,
    List<PropertyMessage> messages,
  }) =>
      StatisticsState(
        timeline ?? this.timeline,
        messages ?? this.messages,
        pages ?? this.pages,
      );
}
