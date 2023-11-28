import 'package:flutter/material.dart';
import 'package:moapp_team_project/controller/auth_controller.dart';
import 'package:moapp_team_project/pages/profile_page/logout.dart';
import 'package:moapp_team_project/pages/profile_page/matching_onboarding.dart';
import 'package:moapp_team_project/pages/profile_page/reprot_bug.dart';
import 'package:provider/provider.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: ListTile(
            leading: const SizedBox(
              width: 24,
              height: 24,
            ),
            title: const Text(
              '매칭 방법 확인하기',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w400,
                color: Color(0xff3E3E3E),
              ),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MatchingOnboarding()));
            },
          ),
        ),
        const Divider(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: ListTile(
            leading: SizedBox(
                width: 24,
                height: 24,
                child: Image.asset("assets/icons/help.png")),
            title: const Text(
              '고객센터',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w400,
                color: Color(0xff3E3E3E),
              ),
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ReportBug()));
            },
          ),
        ),
        const Divider(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: ListTile(
            leading: SizedBox(
                width: 24,
                height: 24,
                child: Image.asset("assets/icons/exit.png")),
            title: const Text(
              '로그아웃',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w400,
                color: Color(0xff3E3E3E),
              ),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => Logout(
                  authController: authController,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
