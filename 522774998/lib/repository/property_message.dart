import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PropertyMessage {
  final bool isSelected;
  final IconData icon;
  String message;
  DateTime time;
  int id;
  int idMessagePage;

  PropertyMessage(
      {this.id,
      this.idMessagePage,
      @required this.message,
      this.time,
      this.isSelected = false,
      this.icon});

  PropertyMessage copyWith(
      {int id,
      int idMessagePage,
      String message,
      String time,
      final bool isSelected,
      final IconData icon}) {
    return PropertyMessage(
      id: id ?? this.id,
      idMessagePage: idMessagePage ?? this.idMessagePage,
      message: message ?? this.message,
      time: time ?? this.time,
      isSelected: isSelected ?? this.isSelected,
      icon: icon ?? this.icon,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'message': message,
      'time': DateFormat('hh:mm').format(time),
      'iconCodePointMessage': icon == null ? null : icon.codePoint,
      'idMessagePage': idMessagePage,
    };
  }

  factory PropertyMessage.fromMap(Map<String, dynamic> map) => PropertyMessage(
        id: map['id'],
        message: map['message'],
        time: DateFormat('hh:mm').parse(map['time']),
        icon: map['iconCodePointMessage'] == null ? null : IconData(map['iconCodePointMessage'], fontFamily: 'MaterialIcons'),
        idMessagePage: map['idMessagePage'],
      );
}
