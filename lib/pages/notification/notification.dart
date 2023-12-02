import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:moapp_team_project/pages/today_date_page/today_date.dart';
import 'package:moapp_team_project/src/app_state.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final notifications = FlutterLocalNotificationsPlugin();

//1. 앱로드시 실행할 기본설정
initNotification(context) async {
  final appstate = Provider.of<ApplicationState>(context);
  //안드로이드용 아이콘파일 이름
  var androidSetting = AndroidInitializationSettings('app_icon');

  //ios에서 앱 로드시 유저에게 권한요청하려면
  var iosSetting = DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  var initializationSettings =
      InitializationSettings(android: androidSetting, iOS: iosSetting);
  await notifications.initialize(initializationSettings,
      //알림 누를때 함수실행하고 싶으면
      //onSelectNotification: 함수명추가
      onDidReceiveNotificationResponse: (payload) {
        print("move!");
    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (context) => TodayDatePage(),
    //   ),
    // );
    
    Navigator.pushNamed(context, '/todayDate');
  });
}
showNotification() async {

  var androidDetails = AndroidNotificationDetails(
    '유니크한 알림 채널 ID',
    '알림종류 설명',
    priority: Priority.high,
    importance: Importance.max,
    color: Color.fromARGB(255, 255, 0, 0),
  );

  var iosDetails = DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );

  // 알림 id, 제목, 내용 맘대로 채우기
  notifications.show(
      1,
      '제목1',
      '내용1',
      NotificationDetails(android: androidDetails, iOS: iosDetails),
      payload:'부가정보' // 부가정보
    );
}

  makeDate(hour, min, sec){
    int m_hour = hour;
    if(hour < 9){
      m_hour = 15 + hour as int;
    }
    else{
      m_hour -= 9;
    }
  var now = tz.TZDateTime.now(tz.local);
  var when = tz.TZDateTime(tz.local, now.year, now.month, now.day, m_hour, min, sec);
  print(now);
  print(when);
  if (when.isBefore(now)) {
    return when.add(Duration(days: 1));
  } else {
    return when;
  }
}

showNotification2() async {

  tz.initializeTimeZones();

  var androidDetails = const AndroidNotificationDetails(
    '유니크한 알림 ID',
    '알림종류 설명',
    priority: Priority.high,
    importance: Importance.max,
    color: Color.fromARGB(255, 255, 0, 0),
  );
  var iosDetails = const DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );

  notifications.zonedSchedule(
      2,
      '제목2',
      '내용2',
      makeDate(13,13,00),
      NotificationDetails(android: androidDetails, iOS: iosDetails),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime
  );
  
}