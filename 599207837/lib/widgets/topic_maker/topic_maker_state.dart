import 'package:flutter/material.dart';
import '../../entity/topic.dart';

class TopicMakerState {
  static const Object? plug = Object();

  late final int selected;
  final Topic? topic;
  late final TextEditingController? nameController;

  TopicMakerState({this.selected = -1, this.topic, this.nameController});

  TopicMakerState.initial({this.selected = -1, this.topic}) {
    nameController = TextEditingController();
  }

  TopicMakerState.editing(this.topic) {
    nameController = TextEditingController();
    selected = icons.indexOf(topic!.icon);
    nameController!.text = topic!.name;
  }

  TopicMakerState duplicate({int? selected, Object? topic, Object? nameController}) {
    return TopicMakerState(
      selected: selected ?? this.selected,
      topic: topic == plug ? this.topic : topic as Topic,
      nameController:
          nameController == plug ? this.nameController : nameController as TextEditingController,
    );
  }

  static final List<IconData> icons = [
    Icons.account_balance_rounded,
    Icons.access_alarm_rounded,
    Icons.image_rounded,
    Icons.add_ic_call_rounded,
    Icons.agriculture_rounded,
    Icons.android_rounded,
    Icons.sports_esports_rounded,
    Icons.backup_rounded,
    Icons.star_rounded,
    Icons.add_location_rounded,
    Icons.add_shopping_cart_rounded,
    Icons.flutter_dash_rounded,
    Icons.airport_shuttle_rounded,
    Icons.tv_rounded,
    Icons.wb_incandescent_rounded,
    Icons.wb_cloudy_rounded,
    Icons.wifi_tethering_rounded,
    Icons.supervisor_account_rounded,
    Icons.airplanemode_active_rounded,
    Icons.cut_rounded,
    Icons.spa_rounded,
    Icons.sports_motorsports_rounded,
    Icons.child_friendly_rounded,
    Icons.sports_basketball_rounded,
    Icons.videogame_asset_rounded,
    Icons.delete_outline_rounded
  ];
}
