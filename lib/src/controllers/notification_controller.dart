import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../models/notification.dart' as model;
import '../repository/notification_repository.dart';

class NotificationController extends ControllerMVC {
  List<model.Notification> notifications = <model.Notification>[];
  int unReadNotificationsCount = 0;
  GlobalKey<ScaffoldState> scaffoldKey;

  NotificationController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    listenForNotifications();
  }

  void listenForNotifications({String message}) async {
    final Stream<model.Notification> stream = await getNotifications();
    stream.listen((model.Notification _notification) {
      setState(() {
        notifications.add(_notification);
      });
    }, onError: (a) {
      print(a);
       ScaffoldMessenger.of(scaffoldKey?.currentContext).hideCurrentSnackBar();
      ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
        content: Text(S.of(state.context).verify_your_internet_connection),
         duration: Duration(seconds: 3),
      ));
    }, onDone: () {
      if (message != null) {
            showDialog(
                    context: scaffoldKey?.currentContext,
                    builder: (ctx) => AlertDialog(
                        content: Text(
             message,
                    
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: Text( S.of(state.context).ok,   style: TextStyle(color: Theme.of(state.context).accentColor),),
                          onPressed: () {
                            Navigator.of(ctx).pop(false);
                          },
                        ),
                      ],
                    ),
                  );
    //    ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
    //      content: Text(message),
      //  ));
      }
    });
  }

  Future<void> refreshNotifications() async {
    notifications.clear();
    listenForNotifications(message: S.of(state.context).notifications_refreshed_successfuly);
  }

  void doMarkAsReadNotifications(model.Notification _notification) async {
    markAsReadNotifications(_notification).then((value) {
      setState(() {
        --unReadNotificationsCount;
        _notification.read = !_notification.read;
      });
          showDialog(
                    context: scaffoldKey?.currentContext,
                    builder: (ctx) => AlertDialog(
                        content: Text(
           S.of(state.context).thisNotificationHasMarkedAsRead,
                    
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: Text( S.of(state.context).ok,   style: TextStyle(color: Theme.of(state.context).accentColor),),
                          onPressed: () {
                            Navigator.of(ctx).pop(false);
                          },
                        ),
                      ],
                    ),
                  );
    //  ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
   //     content: Text(S.of(state.context).thisNotificationHasMarkedAsRead),
    //  ));
    });
  }

  void doMarkAsUnReadNotifications(model.Notification _notification) {
    markAsReadNotifications(_notification).then((value) {
      setState(() {
        ++unReadNotificationsCount;
        _notification.read = !_notification.read;
      });
        showDialog(
                    context: scaffoldKey?.currentContext,
                    builder: (ctx) => AlertDialog(
                        content: Text(
          S.of(state.context).thisNotificationHasMarkedAsUnread,
                    
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: Text( S.of(state.context).ok,   style: TextStyle(color: Theme.of(state.context).accentColor),),
                          onPressed: () {
                            Navigator.of(ctx).pop(false);
                          },
                        ),
                      ],
                    ),
                  );
      
  //    ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
 //      content: Text(S.of(state.context).thisNotificationHasMarkedAsUnread),
   //   ));
    });
  }

  void doRemoveNotification(model.Notification _notification) async {
    removeNotification(_notification).then((value) {
      setState(() {
        if (!_notification.read) {
          --unReadNotificationsCount;
        }
        this.notifications.remove(_notification);
      });
      
       showDialog(
                    context: scaffoldKey?.currentContext,
                    builder: (ctx) => AlertDialog(
                        content: Text(
       S.of(state.context).notificationWasRemoved,
                    
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: Text( S.of(state.context).ok,   style: TextStyle(color: Theme.of(state.context).accentColor),),
                          onPressed: () {
                            Navigator.of(ctx).pop(false);
                          },
                        ),
                      ],
                    ),
                  );
   //   ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
   //     content: Text(S.of(state.context).notificationWasRemoved),
   //   ));
    });
  }
}
