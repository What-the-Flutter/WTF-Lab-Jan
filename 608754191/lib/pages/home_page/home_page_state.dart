part of 'home_page_cubit.dart';

class HomePageState extends Equatable {
  final List<Category> categories;
  final Category? category;
  // List<Message> messageList = [];
  HomePageState({
    required this.category,
    required this.categories,
    // required this.messageList,
  });

  HomePageState copyWith(
      {List<Category>? categories, Category? category, List<Message>? messageList}) {
    return HomePageState(
      categories: categories ?? this.categories,
      category: category ?? this.category,
      // messageList: messageList ?? this.messageList,
    );
  }

  @override
  List<Object?> get props => [categories];
}
