import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:moapp_team_project/src/app_state.dart';
import 'package:onboarding/onboarding.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';

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
  DateTime _selectedDate = DateTime(2000, 1, 1); // 변수를 초기화합니다.
  int _age = 0;
  late int indexGender=0;
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
          page1(context, spaceLevel,appstate),
          page2(context),
          page3(context, appstate),
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
                  indicatorDesign: IndicatorDesign.line(
                    lineDesign: LineDesign(
                      lineType: DesignType.line_uniform,
                    ),
                  ),
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
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 45.0,
              ),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 90),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Third page',
                        style: pageStyle,
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  PageModel page2(BuildContext context) {
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
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 45.0,
              ),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 90),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Second page',
                        style: pageStyle,
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  PageModel page1(BuildContext context, List<SizedBox> spaceLevel, ApplicationState appstate) {
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

  Column Gender(BuildContext context, ApplicationState appstate) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ToggleSwitch(
          minWidth:  MediaQuery.of(context).size.width * 0.30,
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
            if(appstate.currentGenderIndex != indexGender)
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
        }
        else if(!RegExp(r'^010-([0-9]{4})-([0-9]{4})').hasMatch(value)){
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
        FilteringTextInputFormatter.allow(RegExp(r'[a-z|A-Z|0-9|ㄱ-ㅎ|ㅏ-ㅣ|가-힣|ᆞ|ᆢ|ᄀᆞ|ᄂᆞ|ᄃᆞ|ᄅᆞ|ᄆᆞ|ᄇᆞ|ᄉᆞ|ᄋᆞ|ᄌᆞ|ᄎᆞ|ᄏᆞ|ᄐᆞ|ᄑᆞ|ᄒᆞ]'))
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
                hintText: selected
                    ? _birthday
                    : "YYYY-MM-DD",
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
                     _birthday = "${DateFormat('yyyy-MM-dd').format(_selectedDate)}";
                        selected = true;
                      }));
            },
            icon: Icon(Icons.calendar_month)),
      ],
    );
  }

  Material signupButton(ApplicationState appstate, BuildContext context) {
    return Material(
      borderRadius: defaultProceedButtonBorderRadius,
      color: defaultProceedButtonColor,
      child: InkWell(
        borderRadius: defaultProceedButtonBorderRadius,
        onTap: () {
          if (_formKey.currentState!.validate()) {
            print("name is : " + _name);
            print("bd is : " + _birthday);
            print("age is : ${_age}");
            print("phone num is : " + _phoneNumber);
             appstate.updateInformation(_name, _birthday, _age, _phoneNumber);
             appstate.setCurrentUserName(_name);
             Navigator.pop(context);
             Navigator.pop(context, '/');
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
