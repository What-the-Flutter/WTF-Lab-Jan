import 'package:chat_diary/src/models/event_model.dart';
import 'package:flutter/material.dart';

import '../models/page_model.dart';

List<PageModel> defaultPages = [
  PageModel(
    icon: Icons.edit,
    name: 'Notes',
    id: 0,
    nextEventId: 0,
  ),
  PageModel(
    icon: Icons.warning,
    name: 'Important',
    id: 1,
    nextEventId: 0,
  ),
  PageModel(
    icon: Icons.spa,
    name: 'Relax',
    id: 2,
    nextEventId: 0,
  ),
];
