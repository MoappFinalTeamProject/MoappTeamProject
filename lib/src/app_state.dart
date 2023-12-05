import 'dart:async';
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart'; // new
import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:moapp_team_project/src/member_info_cons.dart';
import 'package:timer_builder/timer_builder.dart';
import 'package:tuple/tuple.dart';

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  String _currentUserName = "";
  String get currentUserName => _currentUserName;

  void setCurrentUserName(String name) {
    _currentUserName = name;
    //notifyListeners();
  }

  int _currentImageSliderIndex = 0;
  int get currentImageSliderIndex => _currentImageSliderIndex;
  void setCurrentImageSliderIndex(int index) {
    _currentImageSliderIndex = index;
    // notifyListeners();
  }

  int _currentGenderIndex = 0;
  int get currentGenderIndex => _currentGenderIndex;
  void SetCurrentGenderIndex(int index) {
    _currentGenderIndex = index;
    // notifyListeners();
  }

  int _memberCount = 0;
  int get memberCount => _memberCount;

  void set_memberCount() {
    _memberCount++;
  }

  bool _isFlipped = false;
  bool get isFlipped => _isFlipped;
  void setIsFlipped() {
    if (_isFlipped)
      _isFlipped = false;
    else
      _isFlipped = true;
  }

  List<String> profilePicUrls = [];
  List<Tuple2<String, String>> result = [];

  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;

  StreamSubscription<QuerySnapshot>? _memberSubscription;
  List<MemberInfoCons> _memberInfo = [];

  List<MemberInfoCons> get memberInfo => _memberInfo;

  List<String> _imageUrl = [];

  List<String> get imageUrl => _imageUrl;

  double _atLeastPerc = 60;
  double get atLeastPerc => _atLeastPerc;
  void setAtLeastPerc(double leastValue) {
    _atLeastPerc = leastValue;
  }

  Map<String, dynamic>? _preference;

  Map<String, dynamic>? get preference => _preference;

  void setPreference(Map<String, dynamic> docData) {
    _preference = docData;
  }

  String _currentUserGender = "";
  String get currentUserGender => _currentUserGender;
  void setCurrentUserGender(String gender) {
    _currentUserGender = gender;
  }

  double _percentage = 0;
  double get percentage => _percentage;
  String partnerUid = "";

  void setImageUrl() {
    final url = FirebaseFirestore.instance.collection("home").doc("image url");
    url.get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        for (int i = 0; i < data.length; i++) {
          _imageUrl.add(data["${i}"]);
        }
      },
      onError: (e) => print("Error getting document: $e"),
    );
  }

  List<Uri> _siteUrl = [];

  List<Uri> get siteUrl => _siteUrl;

  void setSiteUrl() {
    final url = FirebaseFirestore.instance.collection("home").doc("site url");
    url.get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        for (int i = 0; i < data.length; i++) {
          _siteUrl.add(Uri.parse(data["${i}"]));
        }
      },
      onError: (e) => print("Error getting document: $e"),
    );
  }

  Future<void> init() async {
    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loggedIn = true;

        _memberSubscription = FirebaseFirestore.instance
            .collection('member')
            .orderBy('timestamp', descending: true)
            .snapshots()
            .listen((snapshot) {
          _memberInfo = [];
          for (final document in snapshot.docs) {
            _memberInfo.add(
              MemberInfoCons(
                email: document.data()['email'] as String,
                uid: document.data()['uid'] as String,
                time: document.data()['timestamp'] as int,
                gender: document.data()['gender'] as String,
              ),
            );
          }
          //notifyListeners();
        });
      } else {
        _loggedIn = false;
        _memberInfo = [];
        _memberSubscription?.cancel();
      }
      notifyListeners();
    });
  }

  Future<void> addMember() {
    set_memberCount();
    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }
    final data;

    data = <String, dynamic>{
      'email': FirebaseAuth.instance.currentUser!.email,
      'uid': FirebaseAuth.instance.currentUser!.uid,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'gender': ""
    };

    final member = FirebaseFirestore.instance
        .collection('member')
        .doc(FirebaseAuth.instance.currentUser!.uid);
    notifyListeners();
    return member.set(data);
  }

  Future<void> addMemberInfo() {
    set_memberCount();
    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }
    final data;

    data = <String, dynamic>{
      'name': "",
      'birthday': "",
      'age': "",
      'phone number': "",
      'gender': "",
    };

    final member = FirebaseFirestore.instance
        .collection('member')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("member info")
        .doc('basic info');
    notifyListeners();
    return member.set(data);
  }

  Future<List<String>> getProfilePics() async {
    FirebaseStorage storage = FirebaseStorage.instance;

    final profilePicsRef = FirebaseFirestore.instance
        .collection('member')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("member info")
        .doc('profile pictures');

    final profilePicsDoc = await profilePicsRef.get();
    final profilePicsData = profilePicsDoc.data();

    List<String> profilePicUrls = [];

    try {
      var url1 = await storage
          .ref('profile/${FirebaseAuth.instance.currentUser!.uid}/image1.png')
          .getDownloadURL();
      var url2 = await storage
          .ref('profile/${FirebaseAuth.instance.currentUser!.uid}/image2.png')
          .getDownloadURL();
      var url3 = await storage
          .ref('profile/${FirebaseAuth.instance.currentUser!.uid}/image3.png')
          .getDownloadURL();

      profilePicUrls.add(url1);
      profilePicUrls.add(url2);
      profilePicUrls.add(url3);
    } catch (e) {
      print(e);
    }

    return profilePicUrls;
  }

  Future<void> addTodayDatePartner(String partnerUid, double percentage) {
    final dataToPartner;
    final dataToCurrentUser;

    dataToPartner = <String, dynamic>{
      'partner uid': FirebaseAuth.instance.currentUser!.uid
    };

    dataToCurrentUser = <String, dynamic>{
      'partner uid': partnerUid,
    };

    final toParter = FirebaseFirestore.instance
        .collection('member')
        .doc(partnerUid)
        .collection("today date partner")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set(dataToPartner);

    final toCurrentUser = FirebaseFirestore.instance
        .collection('member')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("today date partner")
        .doc(partnerUid);

    final updateCurrentUserIsMatched = FirebaseFirestore.instance
        .collection('member')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("preference") //TODO 필터 선호도 받으면 여기에도 파라미터로 전달
        .doc("${percentage}") //TODO 필터 선호도 받으면 여기에도 파라미터로 전달
        .update({
      'is matched?': true,
    });

    final updatePartnerIsMatched = FirebaseFirestore.instance
        .collection('member')
        .doc(partnerUid)
        .collection("preference") //TODO 필터 선호도 받으면 여기에도 파라미터로 전달
        .doc("${percentage}") //TODO 필터 선호도 받으면 여기에도 파라미터로 전달
        .update({
      'is matched?': true,
    });

    notifyListeners();
    return toCurrentUser.set(dataToCurrentUser);
  }

  Future<void> removeTodayPartner() {
    final removeTodayPartnerFromCurrentUser = FirebaseFirestore.instance
        .collection('member')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("today date partner")
        .doc(partnerUid) //TODO 필터 선호도 받으면 여기에도 파라미터로 전달
        .delete();

    final removeTodayPartnerFromPartner = FirebaseFirestore.instance
            .collection('member')
            .doc(partnerUid)
            .collection("today date partner")
            .doc(FirebaseAuth
                .instance.currentUser!.uid) //TODO 필터 선호도 받으면 여기에도 파라미터로 전달
        ;

    notifyListeners();
    return removeTodayPartnerFromPartner.delete();
  }

  Future<List<Tuple2<String, String>>> getMatchedProfilePics() async {
    //profilePicUrls = [];
    _percentage = 0;
    partnerUid = "";
    final checkCurrentPartner = FirebaseFirestore.instance
        .collection('member')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("today date partner");

    checkCurrentPartner.get().then((value) async {
      if (value.docs.isNotEmpty) {
        for (var data in value.docs) {
          partnerUid = data.data()["partner uid"];

          await getProfilesUrl(partnerUid);
          //notifyListeners();
          return result;
        }
      } else {
        profilePicUrls = [];
        result.clear();
        print("매칭 대상 찾기 시작");
        final profilePicsRef = FirebaseFirestore.instance
            .collection('member')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("preference") //TODO 유저에게 범위 설정받으면 됨.
            .get()
            .then((querySnapshot) async {
          for (var docSnapshot in querySnapshot.docs) {
            print("doc data is: ${docSnapshot.data()}");
            if (docSnapshot.data()["detail percentage"] >= atLeastPerc) {
              print(
                  "in db : ${docSnapshot.data()["detail percentage"]}  / at least : ${atLeastPerc}");
              if (!docSnapshot.data()["is matched?"]) {
                if (docSnapshot.data()["detail percentage"] > percentage) {
                  _percentage = docSnapshot.data()["detail percentage"];
                  partnerUid = docSnapshot.data()["partner uid"];
                  print(partnerUid);
                }
              }
            }
          }
          if (partnerUid == "") {
            print("상대방이 없습니다");
            //notifyListeners();
          } else {
            print("work on eles");
            getProfilesUrl(partnerUid);
            addTodayDatePartner(partnerUid, percentage);
            //notifyListeners();
          }
        });
      }
    });
    return result;
  }

  Future<void> getProfilesUrl(String p_uid) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    try {
      var url1 =
          await storage.ref('profile/${p_uid}/image1.png').getDownloadURL();
      var url2 =
          await storage.ref('profile/${p_uid}/image2.png').getDownloadURL();
      var url3 =
          await storage.ref('profile/${p_uid}/image3.png').getDownloadURL();

      profilePicUrls.add(url1);
      profilePicUrls.add(url2);
      profilePicUrls.add(url3);
      result.add(Tuple2<String, String>(url1, p_uid));
      result.add(Tuple2<String, String>(url2, p_uid));
      result.add(Tuple2<String, String>(url3, p_uid));
    } catch (e) {
      print(e);
    }
  }

  TimerBuilder checkTime() {
    return TimerBuilder.periodic(
      const Duration(seconds: 1),
      builder: (context) {
        if (formatDate(DateTime.now(), [
              HH,
              ':',
              nn,
              ':',
              ss,
            ]) ==
            "23:55:20") {
          _isFlipped = false;
          print("test");
          removeTodayPartner();
        }
        return Text("");
      },
    );
  }

  Future<void> addProfilePics(List<String> _url) {
    set_memberCount();
    if (!_loggedIn) {
      throw Exception('Must be logged in');
    }
    final data;

    data = <String, dynamic>{
      'pic1': _url[0],
      'pic2': _url[1],
      'pic3': _url[2],
    };

    final member = FirebaseFirestore.instance
        .collection('member')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("member info")
        .doc('profile pictures');
    notifyListeners();
    return member.set(data);
  }

  Future<void> updateInformation(
      String name, String birthday, int age, String phoneNum) async {
    FirebaseFirestore.instance
        .collection('member')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'name': name,
    });

    final member = FirebaseFirestore.instance
        .collection('member')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("member info")
        .doc('basic info')
        .update({
      'name': name,
      'birthday': birthday,
      'age': "${age}",
      'phone number': phoneNum,
      'gender': _currentGenderIndex == 0 ? "M" : "W",
    });

    final gender = FirebaseFirestore.instance
        .collection('member')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'gender': _currentGenderIndex == 0 ? "M" : "W",
    });
    notifyListeners();

    return member;
  }

  Future<List<String>> getHomeImageUrl() async {
    FirebaseStorage storage = FirebaseStorage.instance;

    List<String> homImageUrls = [];

    try {
      var url1 =
          await FirebaseStorage.instance.ref('home/menu.png').getDownloadURL();
      var url2 = await storage.ref('home/hisnet.png').getDownloadURL();
      var url3 = await storage.ref('home/youtube.png').getDownloadURL();

      var url4 = await storage.ref('home/news.png').getDownloadURL();

      homImageUrls.add(url1);
      homImageUrls.add(url2);
      homImageUrls.add(url3);
      homImageUrls.add(url4);
    } catch (e) {
      print(e);
    }

    return homImageUrls;
  }

  Future<void> addPreference(String uid, double percent) {
    final data;
    String percentage = "";
    data = <String, dynamic>{
      'detail percentage': percent,
      'is matched?': false,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'partner uid': uid,
    };
    final member = FirebaseFirestore.instance
        .collection('member')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("preference")
        .doc("${percent}");
    notifyListeners();
    return member.set(data);
  }

  Future<void> fetchPreferences(ApplicationState appState) async {
    final mySnapshot = await FirebaseFirestore.instance
        .collection('member')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('member info')
        .doc('preference');

    mySnapshot.get().then(
      (DocumentSnapshot myDoc) {
        final myData = myDoc.data() as Map<String, dynamic>;
        appState.setPreference(myData);
      },
    );

    FirebaseFirestore.instance.collection('member').get().then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        int matchCount = 0;
        int percent = 0;
        if (docSnapshot.id != FirebaseAuth.instance.currentUser!.uid) {
          if (docSnapshot.data()["gender"] != appState.currentUserGender) {
            final otherSnapshot = FirebaseFirestore.instance
                .collection('member')
                .doc(docSnapshot.id)
                .collection("member info")
                .doc("preference");

            otherSnapshot.get().then(
              (DocumentSnapshot otherDoc) {
                final otherData = otherDoc.data()! as Map<String, dynamic>;
                appState.preference!.forEach((Mapkey, Mapvalue) {
                  Mapvalue.forEach((key, value) {
                    print(
                        "key is :${key}, my value is : ${value}. other value is : ${otherData[Mapkey][key]}");
                    if (value == true) percent++;
                    if (otherData[Mapkey][key] != null) if (value &&
                        otherData[Mapkey][key] == true) {
                      matchCount++;
                    }
                  });
                });
                appState.addPreference(
                    docSnapshot.id, matchCount / percent * 100);
                if (matchCount / percent * 100 >= 80.0) {}
              },
            );
          }
        }
      }
    });
  }

  Future<void> addWishPercent(double leastValue) {
    final data;
    String percentage = "";
    data = <String, dynamic>{
      'wish percentage': leastValue,
    };
    final member = FirebaseFirestore.instance
        .collection('member')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("wish percentage")
        .doc("percentage");
    notifyListeners();
    return member.set(data);
  }

  Future<void> getWishPercent() async {
    final docRef = await FirebaseFirestore.instance
        .collection("member")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("wish percentage")
        .doc("percentage");

    docRef.get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        setAtLeastPerc(data["wish percentage"]);
      },
      onError: (e) => print("Error getting document: $e"),
    );
  }
}
