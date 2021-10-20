import 'package:chat_journal/models/chat_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import '../chat_detail_page.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () => {},
                  child: Card(
                    color: Theme.of(context).colorScheme.secondary,
                    margin: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 5.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 0.0,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const <Widget>[
                          CircleAvatar(
                            backgroundImage: Svg('assets/icons/chatbot.svg'),
                            backgroundColor: Colors.white,
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          Text(
                            'Questionnare Bot',
                            style: TextStyle(
                              fontFamily: 'Merriweather',
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Divider(),
                Expanded(
                  child: ListView.separated(
                    scrollDirection: Axis.vertical,
                    itemCount: chats.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(),
                    itemBuilder: (BuildContext context, int index) {
                      return Material(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.grey,
                            radius: 30.0,
                            child: Icon(
                              chats[index].icon,
                              color: Colors.white,
                              size: 30.0,
                            ),
                          ),
                          title: Text(
                            chats[index].title,
                            style: const TextStyle(
                              fontFamily: 'Merriweather',
                              fontSize: 20.0,
                            ),
                          ),
                          subtitle: Text(
                            chats[index].subtitle!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: 'Dancing',
                              fontSize: 25.0,
                              color: Colors.blueGrey,
                            ),
                          ),
                          trailing: Text(chats[index].time!),
                          hoverColor: Colors.lightBlueAccent,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ChatDetailPage(title: chats[index].title,),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
