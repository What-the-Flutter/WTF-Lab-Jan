part of 'journal_page.dart';

class MessageView extends StatelessWidget {
  final Message message;
  final onLongPress;
  final onTap;
  MessageView(this.message,this.onLongPress,this.onTap);

  @override
  Widget build(BuildContext context) {
    print('Build Message widget');
    return Container(
      child: Row(
        children: [
          Flexible(
            child: Container(),
          ),
          if(message.selected)Icon(Icons.label_important_outline),
          GestureDetector(
            child: Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * .6),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                  child: Container(
                    child: Column(
                      children: [
                        Container(
                          child: Text(
                            message.text,
                            maxLines: 100,
                          ),
                        ),
                        Container(
                          child: Text(
                            " ${message.time.hour.toString()}:${message.time.minute.toString()}",
                            style: Theme.of(context).textTheme.caption,
                            overflow: TextOverflow.ellipsis,
                            textScaleFactor: 0.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            onLongPress: onLongPress,
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}
