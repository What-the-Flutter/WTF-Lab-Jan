import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

enum SwipeSelectedAction { edit, delete }

class SwipeWidget extends StatelessWidget {
  final Widget child;
  final bool isImageMessage;
  final SlidableController slidableController;

  final Function(SwipeSelectedAction action) doSwipeSelectedAction;

  SwipeWidget({
    Key key,
    this.child,
    this.doSwipeSelectedAction,
    this.isImageMessage,
    this.slidableController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isImageMessage ? _imageMessageSlidable : _eventMessageSlidable;
  }

  Slidable get _imageMessageSlidable {
    return Slidable(
      actionPane: SlidableStrechActionPane(),
      child: child,
      controller: slidableController,
      actionExtentRatio: 0.25,
      secondaryActions: <Widget>[
        SlideAction(
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.0),
              bottomLeft: Radius.circular(25.0),
            ),
          ),
          child: Center(
            child: Icon(Icons.delete),
          ),
          onTap: () => doSwipeSelectedAction(SwipeSelectedAction.delete),
        ),
      ],
    );
  }

  Slidable get _eventMessageSlidable {
    return Slidable(
      actionPane: SlidableStrechActionPane(),
      child: child,
      controller: slidableController,
      actionExtentRatio: 0.25,
      actions: <Widget>[
        SlideAction(
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(25.0),
              bottomRight: Radius.circular(25.0),
            ),
          ),
          child: Center(
            child: Icon(Icons.edit),
          ),
          closeOnTap: true,
          onTap: () => doSwipeSelectedAction(SwipeSelectedAction.edit),
        )
      ],
      secondaryActions: <Widget>[
        SlideAction(
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.0),
              bottomLeft: Radius.circular(25.0),
            ),
          ),
          child: Center(
            child: Icon(Icons.delete),
          ),
          closeOnTap: true,
          onTap: () => doSwipeSelectedAction(SwipeSelectedAction.delete),
        ),
      ],
    );
  }
}
