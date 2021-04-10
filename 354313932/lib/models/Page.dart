import 'package:flutter/material.dart';

class Page {
  Icon icon;
  String title;
  String subtitle;

  Page({this.icon, this.title, this.subtitle});
}

List pages = [
  Page(
      icon: Icon(
        Icons.flight_takeoff,
        color: Colors.white,
      ),
      title: "Travel",
      subtitle: "No Events. Click to create one."),
  Page(
      icon: Icon(
        Icons.weekend,
        color: Colors.white,
      ),
      title: "Family",
      subtitle: "No Events. Click to create one."),
  Page(
      icon: Icon(
        Icons.fitness_center,
        color: Colors.white,
      ),
      title: "Sports",
      subtitle: "No Events. Click to create one.")
];
