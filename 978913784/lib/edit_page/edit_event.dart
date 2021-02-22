import 'package:flutter/material.dart';

abstract class EditEvent {
  const EditEvent();
}

class IconChanged extends EditEvent {
  final IconData icon;
  const IconChanged(this.icon);
}

class AllowanceUpdated extends EditEvent {
  final bool isAllowed;
  const AllowanceUpdated(this.isAllowed);
}