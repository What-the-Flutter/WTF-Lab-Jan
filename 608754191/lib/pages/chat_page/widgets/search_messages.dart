import 'package:flutter/material.dart';
import '../../../entity/category.dart' show Category;
import '../../../entity/message.dart';

class SearchMessageDelegate extends SearchDelegate {
  final Category? category;
  final List<Message> messagesList;

  SearchMessageDelegate({
    required this.messagesList,
    this.category,
  });

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData.dark().copyWith(primaryColorDark: Colors.yellow);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(
          Icons.cleaning_services_rounded,
          color: Colors.yellow,
        ),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        query = '';
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return messagesList
            .where(
              (element) => element.text.contains(
                query,
              ),
            )
            .isEmpty
        ? const Center(
            child: Text(
              'No matches!',
              style: TextStyle(color: Colors.yellow),
            ),
          )
        : ListView.builder(
            scrollDirection: Axis.vertical,
            reverse: true,
            itemCount: messagesList
                .where(
                  (element) => element.text.contains(
                    query,
                  ),
                )
                .length,
            itemBuilder: (context, index) {
              final message = messagesList
                  .where(
                    (element) => element.text.contains(
                      query,
                    ),
                  )
                  .toList()[index];
              return Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 5.0,
                  horizontal: 20.0,
                ),
                width: 200,
                constraints: const BoxConstraints(),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    50,
                  ),
                  child: Card(
                    elevation: 3,
                    child: ListTile(
                      title: Text(
                        message.text,
                      ),
                      subtitle: Text(
                        '${message.time}\n${category!.title}',
                      ),
                      isThreeLine: true,
                    ),
                  ),
                ),
              );
            },
          );
  }
}
