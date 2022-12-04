import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../controllers/cart_controller.dart';
import '../controllers/notification_controller.dart';
import '../models/route_argument.dart';
import '../repository/user_repository.dart';

class NotificationButtonWidget extends StatefulWidget {
  const NotificationButtonWidget({
    this.iconColor,
    this.labelColor,
    Key key,
  }) : super(key: key);

  final Color iconColor;
  final Color labelColor;

  @override
  _NotificationButtonWidgetState createState() =>
      _NotificationButtonWidgetState();
}

class _NotificationButtonWidgetState
    extends StateMVC<NotificationButtonWidget> {
  NotificationController _con;

  _NotificationButtonWidgetState() : super(NotificationController()) {
    _con = controller;
  }

  @override
  void initState() {
    _con.listenForNotifications();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.of(context).pushNamed('/notifications');
      },
      // ignore: sort_child_properties_last
      icon: Icon(
        Icons.notifications_outlined,
        color: this.widget.iconColor,
        size: 28,
      ),
      color: Colors.transparent,
    );
  }
}
