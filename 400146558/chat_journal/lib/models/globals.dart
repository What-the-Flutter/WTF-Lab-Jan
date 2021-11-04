library my_prj.globals;
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'message_model.dart';
import 'chat_model.dart';

List<Message>? selected = <Message>[];
List<Message>? favourites = <Message>[];
bool? isAnySelected = false;
bool? isShowFav = false;

List<Chat> chats = [
  Chat(
    icon: Icons.airplanemode_on_sharp,
    myIndex: 0,
    title: 'Travel',
    messageBase: travel,
    time:  Jiffy({"year": 2021, "month": 9, "day": 20, "hour": 14, "minutes": 45}),
  ),
  Chat(
    icon: Icons.book_rounded,
    myIndex: 1,
    title: 'Journal',
    messageBase: [],
    time:  Jiffy({"year": 2021, "month": 9, "day": 20, "hour": 14, "minutes": 45}),
  ),
  Chat(
    icon: Icons.nature_people,
    myIndex: 2,
    title: 'Communication',
    messageBase: [],
    time:  Jiffy({"year": 2021, "month": 9, "day": 20, "hour": 14, "minutes": 45}),
  ),
];

List<Message>? travel = <Message>[
  Message(
      "buy bread",
      Jiffy({"year": 2021, "month": 9, "day": 20, "hour": 14, "minutes": 45}),
      false,
      false),
  Message(
      "go to school",
      Jiffy({"year": 2021, "month": 9, "day": 20, "hour": 14, "minutes": 50}),
      false,
      false),
  Message(
      "go to work",
      Jiffy({"year": 2021, "month": 9, "day": 20, "hour": 14, "minutes": 53}),
      false,
      false),
];

