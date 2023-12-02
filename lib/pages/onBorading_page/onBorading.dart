import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:moapp_team_project/provider/mlkit_model.dart';
import 'package:moapp_team_project/pages/profile_page/my_preference.dart';
import 'package:moapp_team_project/src/app_state.dart';
import 'package:onboarding/onboarding.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:tuple/tuple.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

TextEditingController textController = TextEditingController();

const pageStyle = TextStyle(
  fontSize: 23.0,
  wordSpacing: 1,
  letterSpacing: 1.2,
  fontWeight: FontWeight.bold,
  color: Colors.black,
);

class _OnBoardingPageState extends State<OnBoardingPage> {
  File? _image1;
  File? _image2;
  File? _image3;
  XFile? _image1_1;
  XFile? _image2_1;
  XFile? _image3_1;
  final ImagePicker picker = ImagePicker(); //ImagePicker 초기화
  DateTime _selectedDate = DateTime(2000, 1, 1); // 변수를 초기화합니다.
  int _age = 0;
  late int indexGender = 0;
  late Material materialButton;
  late int index;
  late String _name = "";
  late String _birthday = "";
  late String _phoneNumber = "";
  late bool selected = false;
  //final onboardingPagesList =

  @override
  void initState() {
    super.initState();
    materialButton = _nextButton();
    index = 0;
  }

  final _formKey = GlobalKey<FormState>();
  List<bool> isChecked = [false, false, false, false, false, false];
  @override
  Widget build(BuildContext context) {
    final appstate = Provider.of<ApplicationState>(context);
    print("rebuild!");
    return Scaffold(
      body: OnbardingPages(context, appstate),
    );
  }

  Form OnbardingPages(BuildContext context, ApplicationState appstate) {
    List<SizedBox> spaceLevel = [
      SizedBox(
          height: MediaQuery.of(context).size.height * 0.05 //between contents
          ),
      SizedBox(
          height:
              MediaQuery.of(context).size.height * 0.1 //betwwen top and title
          ),
    ];
    return Form(
      key: _formKey,
      child: Onboarding(
        pages: [
          page1(context, spaceLevel, appstate),
          page2(context, spaceLevel),
          page3(context, appstate),
          page4(context, appstate, spaceLevel),
        ],
        onPageChange: (int pageIndex) {
          index = pageIndex;
        },
        startPageIndex: 0,
        footerBuilder: (context, dragDistance, pagesLength, setIndex) {
          return footer(dragDistance, pagesLength, appstate, context, setIndex);
        },
      ),
    );
  }

  DecoratedBox footer(
      double dragDistance,
      int pagesLength,
      ApplicationState appstate,
      BuildContext context,
      void setIndex(int index)) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          width: 0.0,
          color: Colors.yellow,
        ),
      ),
      child: ColoredBox(
        color: const Color.fromARGB(255, 235, 235, 235),
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomIndicator(
                netDragPercent: dragDistance,
                pagesLength: pagesLength,
                indicator: Indicator(
                  activeIndicator: ActiveIndicator(color: Colors.black),
                  closedIndicator: ClosedIndicator(
                      color: Color.fromARGB(255, 144, 169, 209)),
                  indicatorDesign: IndicatorDesign.polygon(
                      polygonDesign:
                          PolygonDesign(polygon: DesignType.polygon_circle)),
                ),
              ),
              index == pagesLength - 1
                  ? signupButton(appstate, context)
                  : _nextButton(setIndex: setIndex)
            ],
          ),
        ),
      ),
    );
  }

  PageModel page4(BuildContext context, ApplicationState appstate,
      List<SizedBox> spaceLevel) {
    return PageModel(
      widget: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(
            width: 0.0,
            color: Colors.yellow,
          ),
        ),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.95,
          child: SingleChildScrollView(
            controller: ScrollController(),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.1,
              ),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 90),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'HGU HONOR CODE',
                        style: pageStyle,
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Checkbox(
                        activeColor: Colors.red,
                        //isError: true,
                        //tristate: true,
                        value: isChecked[0],
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked[0] = value!;
                          });
                        },
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width * 0.65,
                          child: Text(
                            "나는 한동대학교의 구성원입니다.",
                            style: TextStyle(fontSize: 18),
                          )), //나는 하나님과 사람 앞에서 정직하고 부끄러움 없이
                    ],
                  ),
                  spaceLevel[0],
                  Row(
                    children: [
                      Checkbox(
                        activeColor: Colors.red,
                        //isError: true,
                        //tristate: true,
                        value: isChecked[1],
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked[1] = value!;
                          });
                        },
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width * 0.65,
                          child: Text(
                            "나는 허위정보를 기입하지 않았습니다.",
                            style: TextStyle(fontSize: 18),
                          )), //나는 하나님과 사람 앞에서 정직하고 부끄러움 없이
                    ],
                  ),
                  spaceLevel[0],
                  Row(
                    children: [
                      Checkbox(
                        activeColor: Colors.red,
                        //isError: true,
                        //tristate: true,
                        value: isChecked[2],
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked[2] = value!;
                          });
                        },
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width * 0.65,
                          child: Text(
                            "나는 사진 도용을 하지 않았습니다.",
                            style: TextStyle(fontSize: 18),
                          )), //나는 하나님과 사람 앞에서 정직하고 부끄러움 없이
                    ],
                  ),
                  spaceLevel[0],
                  Row(
                    children: [
                      Checkbox(
                        activeColor: Colors.red,
                        //isError: true,
                        //tristate: true,
                        value: isChecked[3],
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked[3] = value!;
                          });
                        },
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width * 0.65,
                          child: Text(
                            "나는 타인을 존중하며 불쾌감을 주는 행동을 하지 않겠습니다.",
                            style: TextStyle(fontSize: 18),
                          )), //나는 하나님과 사람 앞에서 정직하고 부끄러움 없이
                    ],
                  ),
                  spaceLevel[0],
                  Row(
                    children: [
                      Checkbox(
                        activeColor: Colors.red,
                        //isError: true,
                        //tristate: true,
                        value: isChecked[4],
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked[4] = value!;
                          });
                        },
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width * 0.65,
                          child: Text(
                            "나는 금전적인 요구, 부적절한 만남을 하지 않겠습니다.",
                            style: TextStyle(fontSize: 18),
                          )), //나는 하나님과 사람 앞에서 정직하고 부끄러움 없이
                    ],
                  ),
                  spaceLevel[0],
                  Row(
                    children: [
                      Checkbox(
                        activeColor: Colors.red,
                        //isError: true,
                        //tristate: true,
                        value: isChecked[5],
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked[5] = value!;
                          });
                        },
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width * 0.65,
                          child: Text(
                            "나는 하나님과 사람 앞에서 정직하고 부끄러움 없이 앱을 사용하겠습니다.",
                            style: TextStyle(fontSize: 18),
                          )),
                    ],
                  ),
                  spaceLevel[0],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  PageModel page3(BuildContext context, ApplicationState appstate) {
    return PageModel(
      widget: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(
            width: 0.0,
            color: Colors.yellow,
          ),
        ),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.90,
          child: SingleChildScrollView(
            controller: ScrollController(),
            child: const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 45.0,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 90),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '나의 선호',
                        style: pageStyle,
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  MyPreference(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  PageModel page2(BuildContext context, List<SizedBox> spaceLevel) {
    return PageModel(
      widget: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(
            width: 0.0,
            color: Colors.yellow,
          ),
        ),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            controller: ScrollController(),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 45.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  spaceLevel[1],
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '프로필 사진 등록',
                      style: pageStyle,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  spaceLevel[0],
                  Text("3장 이상의 프로필 사진을 등록해주세요.",
                      style: TextStyle(fontSize: 18)),
                  Text("* 얼굴이 잘 보이는 사진 *", style: TextStyle(fontSize: 14)),
                  spaceLevel[0],
                  Column(
                    children: [
                      _buildPhotoArea1(),
                      _buildPhotoArea2(),
                      _buildPhotoArea3(),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  PageModel page1(BuildContext context, List<SizedBox> spaceLevel,
      ApplicationState appstate) {
    return PageModel(
      widget: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(
            width: 0.0,
            color: Colors.yellow,
          ),
        ),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            controller: ScrollController(),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 45.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  spaceLevel[1],
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '기본 프로필 작성',
                      style: pageStyle,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  spaceLevel[0],
                  Text("환영합니다! \n13:13은 처음이신가요? \n몇 가지 정보가 필요합니다 :)",
                      style: TextStyle(fontSize: 18)),
                  spaceLevel[0],
                  Text(
                    "이름",
                    style: TextStyle(fontSize: 16),
                  ),
                  Name(),
                  spaceLevel[0],
                  Text(
                    "생년월일",
                    style: TextStyle(fontSize: 16),
                  ),
                  Birthday(context),
                  spaceLevel[0],
                  Text(
                    "나이(만)",
                    style: TextStyle(fontSize: 16),
                  ),
                  Age(),
                  spaceLevel[0],
                  Text(
                    "전화번호",
                    style: TextStyle(fontSize: 16),
                  ),
                  PhoneNumber(),
                  spaceLevel[0],
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 6.0),
                    child: Text(
                      "성별",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Gender(context, appstate),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future getImage(ImageSource imageSource, int num) async {
    //pickedFile에 ImagePicker로 가져온 이미지가 담긴다.
    final pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      setState(() {
        switch (num) {
          case 1:
            _image1 = File(pickedFile.path); //가져온 이미지를 _image에 저장
            _image1_1 = XFile(pickedFile.path);
          case 2:
            _image2 = File(pickedFile.path); //가져온 이미지를 _image에 저장
            _image2_1 = XFile(pickedFile.path);
          case 3:
            _image3 = File(pickedFile.path); //가져온 이미지를 _image에 저장
            _image3_1 = XFile(pickedFile.path);
        }
      });
    }
  }

  Future<void> uploadImage(File? _image1, File? _image2, File? _image3) async {
    FirebaseStorage _storage = FirebaseStorage.instance;
    Reference _ref1 = _storage.ref("profile/${FirebaseAuth.instance.currentUser!.uid}/image1.png");
    _ref1.putFile(_image1!);
    Reference _ref2 = _storage.ref("profile/${FirebaseAuth.instance.currentUser!.uid}/image2.png");
    _ref2.putFile(_image2!);
    Reference _ref3 = _storage.ref("profile/${FirebaseAuth.instance.currentUser!.uid}/image3.png");
    _ref3.putFile(_image3!);
  }

  Widget _buildPhotoArea1() {
    return _image1 != null
        ? GestureDetector(
            onTap: () {
              getImage(ImageSource.gallery, 1);
            },
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.width * 0.8,
                child: Image.file(
                  File(_image1!.path),
                  fit: BoxFit.cover,
                ), //가져온 이미지를 화면에 띄워주는 코드
              ),
            ),
          )
        : GestureDetector(
            onTap: () {
              getImage(ImageSource.gallery, 1);
            },
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                child: Center(
                  child: Icon(
                    Icons.photo_size_select_actual_rounded,
                    size: MediaQuery.of(context).size.width * 0.1,
                    color: Colors.grey[500],
                  ),
                ),
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.width * 0.8,
                color: Colors.grey[200],
              ),
            ),
          );
  }

  Widget _buildPhotoArea2() {
    return _image2 != null
        ? GestureDetector(
            onTap: () {
              getImage(ImageSource.gallery, 2);
            },
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.width * 0.8,
                child: Image.file(
                  File(_image2!.path),
                  fit: BoxFit.cover,
                ), //가져온 이미지를 화면에 띄워주는 코드
              ),
            ),
          )
        : GestureDetector(
            onTap: () {
              getImage(ImageSource.gallery, 2);
            },
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                child: Center(
                  child: Icon(
                    Icons.photo_size_select_actual_rounded,
                    size: MediaQuery.of(context).size.width * 0.1,
                    color: Colors.grey[500],
                  ),
                ),
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.width * 0.8,
                color: Colors.grey[200],
              ),
            ),
          );
  }

  Widget _buildPhotoArea3() {
    return _image3 != null
        ? GestureDetector(
            onTap: () {
              getImage(ImageSource.gallery, 3);
            },
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.width * 0.8,
                child: Image.file(
                  File(_image3!.path),
                  fit: BoxFit.cover,
                ), //가져온 이미지를 화면에 띄워주는 코드
              ),
            ),
          )
        : GestureDetector(
            onTap: () {
              getImage(ImageSource.gallery, 3);
            },
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                child: Center(
                  child: Icon(
                    Icons.photo_size_select_actual_rounded,
                    size: MediaQuery.of(context).size.width * 0.1,
                    color: Colors.grey[500],
                  ),
                ),
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.width * 0.8,
                color: Colors.grey[200],
              ),
            ),
          );
  }

  Column Gender(BuildContext context, ApplicationState appstate) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ToggleSwitch(
          minWidth: MediaQuery.of(context).size.width * 0.30,
          initialLabelIndex: appstate.currentGenderIndex,
          cornerRadius: 20.0,
          activeFgColor: Colors.white,
          inactiveBgColor: Colors.grey,
          inactiveFgColor: Colors.white,
          totalSwitches: 2,
          labels: ['Male', 'Female'],
          icons: [FontAwesomeIcons.mars, FontAwesomeIcons.venus],
          activeBgColors: [
            [Colors.blue],
            [Colors.pink]
          ],
          onToggle: (indexGender) {
            if (appstate.currentGenderIndex != indexGender)
              appstate.SetCurrentGenderIndex(indexGender!);
            print('switched to: ${appstate.currentGenderIndex}');
          },
        ),
      ],
    );
  }

  TextFormField PhoneNumber() {
    return TextFormField(
      inputFormatters: [
        FilteringTextInputFormatter(RegExp(r'^[0-9]{1}.{0,12}'), allow: true)
      ],
      decoration: const InputDecoration(
          //labelText: '닉네임',
          hintText: '010-1234-5678',
          isDense: true,
          contentPadding: EdgeInsets.all(0)),
      validator: (value) {
        if (value!.isEmpty) {
          return '전화번호를 입력해주세요.';
        } else if (!RegExp(r'^010-([0-9]{4})-([0-9]{4})').hasMatch(value)) {
          return '형식을 맞춰주세요(XXX-XXXX-XXXX)';
        }
        return null;
      },
      onChanged: (value) {
        setState(() {
          _phoneNumber = value;
        });
      },
    );
  }

  TextFormField Name() {
    return TextFormField(
      controller: textController,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(
            r'[a-z|A-Z|0-9|ㄱ-ㅎ|ㅏ-ㅣ|가-힣|ᆞ|ᆢ|ᄀᆞ|ᄂᆞ|ᄃᆞ|ᄅᆞ|ᄆᆞ|ᄇᆞ|ᄉᆞ|ᄋᆞ|ᄌᆞ|ᄎᆞ|ᄏᆞ|ᄐᆞ|ᄑᆞ|ᄒᆞ]'))
      ],
      decoration: const InputDecoration(
          //labelText: '닉네임',
          hintText: '이름을 입력하세요.',
          isDense: true,
          contentPadding: EdgeInsets.all(0)),
      validator: (value) {
        if (value!.isEmpty) {
          return '이름을 입력해주세요.';
        }
        return null;
      },
      onChanged: (value) {
        setState(() => _name = textController.text);
      },
    );
  }

  SizedBox Age() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.25,
      child: TextFormField(
        decoration: InputDecoration(
            hintStyle: selected
                ? TextStyle(color: Colors.black)
                : TextStyle(color: Colors.grey),
            //labelText: '닉네임',
            //enabled: false,
            hintText: selected ? "${_age} 세" : "",
            isDense: true,
            contentPadding: EdgeInsets.all(0)),
        validator: (value) {
          if (!selected) {
            return '나이를 입력해주세요';
          }
          return null;
        },
        onChanged: (value) {
          _age = value as int;
        },
      ),
    );
  }

  Row Birthday(context) {
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.35,
          child: TextFormField(
            decoration: InputDecoration(
                hintStyle: selected
                    ? TextStyle(color: Colors.black)
                    : TextStyle(color: Colors.grey),
                //labelText: '닉네임',
                enabled: false,
                hintText: selected ? _birthday : "YYYY-MM-DD",
                isDense: true,
                contentPadding: EdgeInsets.all(0)),
            validator: (value) {
              if (!selected) {
                return '생년월일을 입력해주세요.';
              }
              return null;
            },
          ),
        ),
        IconButton(
            onPressed: () {
              _selectDate(context)
                  .then((value) => _calculateAge())
                  .then((value) => setState(() {
                        _birthday =
                            "${DateFormat('yyyy-MM-dd').format(_selectedDate)}";
                        selected = true;
                      }));
            },
            icon: Icon(Icons.calendar_month)),
      ],
    );
  }

  Material signupButton(ApplicationState appstate, BuildContext context) {
    MLkitModel result = context.watch<MLkitModel>();
    return Material(
      borderRadius: defaultProceedButtonBorderRadius,
      color: defaultProceedButtonColor,
      child: InkWell(
        borderRadius: defaultProceedButtonBorderRadius,
        onTap: () async {
          List<String> url = ["", "", ""];
          if (_formKey.currentState!.validate()) {
            if (!(_image1 == null || _image2 == null || _image3 == null)) {
              Tuple2<bool, int> val1 =
                  await result.getRecognizedFace(_image1_1!);
              Tuple2<bool, int> val2 =
                  await result.getRecognizedFace(_image2_1!);
              Tuple2<bool, int> val3 =
                  await result.getRecognizedFace(_image3_1!);
              if (val1.item1 && val2.item1 && val3.item1) {
                if (val1.item2 == 1 && val2.item2 == 1 && val3.item2 == 1) {
                  if (isChecked[0] &&
                      isChecked[1] &&
                      isChecked[2] &&
                      isChecked[3] &&
                      isChecked[4] &&
                      isChecked[5]) {
                    uploadImage(_image1, _image2, _image3);
                    Future.delayed(const Duration(milliseconds: 1000),
                        () async {
                      //print("product_count after : ${product_count}");
                      Reference _ref1 = FirebaseStorage.instance
                          .ref()
                          .child('profile/image1.png');
                      Reference _ref2 = FirebaseStorage.instance
                          .ref()
                          .child('profile/image2.png');
                      Reference _ref3 = FirebaseStorage.instance
                          .ref()
                          .child('profile/image3.png');
                      List<String> _url = [
                        await _ref1.getDownloadURL(),
                        await _ref2.getDownloadURL(),
                        await _ref3.getDownloadURL(),
                      ];
                      url[0] = _url[0];
                      url[1] = _url[1];
                      url[2] = _url[2];
                      appstate.updateInformation(
                          _name, _birthday, _age, _phoneNumber);
                      appstate.addProfilePics(url);
                      appstate.setCurrentUserName(_name);
                    }).then((value) {
                      Navigator.pop(context);
                      Navigator.pop(context, '/');
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('모든 항목을 체크해주세요.')),
                    );
                  }
                } else {
                  List imageList = [];
                  if (val1.item2 != 1) {
                    imageList.add("1번");
                  }
                  if (val2.item2 != 1) {
                    imageList.add("2번");
                  }
                  if (val3.item2 != 1) {
                    imageList.add("3번");
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            '한명의 얼굴이 있는 이미지를 업로드해주세요.\n(${imageList.join(', ')} 이미지).')),
                  );
                }
              } else {
                List imageList = [];
                if (!val1.item1) {
                  imageList.add("1번");
                }
                if (!val2.item1) {
                  imageList.add("2번");
                }
                if (!val3.item1) {
                  imageList.add("3번");
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(
                          '얼굴이 잘인식되는 이미지를 업로드해주세요.\n(${imageList.join(', ')} 이미지).')),
                );
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('사진 세장을 모두 올려주세요!')),
              );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('모든 항목을 채워주세요!')),
            );
          }
        },
        child: const Padding(
          padding: defaultProceedButtonPadding,
          child: Text(
            'Sign up',
            style: defaultProceedButtonTextStyle,
          ),
        ),
      ),
    );
  }

  Material _nextButton({void Function(int)? setIndex}) {
    return Material(
      borderRadius: defaultSkipButtonBorderRadius,
      color: defaultSkipButtonColor,
      child: InkWell(
        borderRadius: defaultSkipButtonBorderRadius,
        onTap: () {
          if (_formKey.currentState!.validate()) {
            // If the form is valid, display a snackbar. In the real world,
            // you'd often call a server or save the information in a database.
            if (setIndex != null) {
              index++;
              setIndex(index);
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('모든 항목을 채워주세요!')),
            );
          }
        },
        child: const Padding(
          padding: defaultSkipButtonPadding,
          child: Text(
            'Next',
            style: defaultSkipButtonTextStyle,
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime(2006),
    );

    if (picked != null && picked != _selectedDate) {
      _selectedDate = picked;
    }
  }

  void _calculateAge() {
    if (_selectedDate != null) {
      DateTime currentDate = DateTime.now();

      int age = currentDate.year - _selectedDate.year;

      if (currentDate.month < _selectedDate.month ||
          (currentDate.month == _selectedDate.month &&
              currentDate.day < _selectedDate.day)) {
        age--;
      }
      _age = age;
    }
  }
}
