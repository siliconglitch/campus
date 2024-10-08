import 'package:campus/api/apis.dart';
import 'package:campus/api/user_controller.dart';
import 'package:campus/login/login.dart';
import 'package:campus/utils/Style/Header_page.dart';
import 'package:campus/utils/Style/Iconwidget.dart';
import 'package:campus/utils/Style/welcome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screen_ex/flutter_settings_screen_ex.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'AccountPage.dart';
import 'Utils.datr.dart';

class Settingspage extends StatefulWidget {
  @override
  _SettingpageState createState() => _SettingpageState();
}

class _SettingpageState extends State<Settingspage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: ListView(
            padding: EdgeInsets.all(24),
            children: [
              HeaderPage(),
              SettingsGroup(title: 'GENERAL', children: <Widget>[
                AccountPage(),
                buildLogout(),
                buildDeleteAccount(),
              ]),
              const SizedBox(height: 32),
              SettingsGroup(title: 'FEEDBACK', children: <Widget>[
                const SizedBox(height: 8),
                buildReportBug(),
                buildSendFeedback(),
              ]),
            ],
          ),
        ),
      );

  Widget buildLogout() => SimpleSettingsTile(
      title: 'Logout',
      subtitle: '',
      leading: IconWidget(icon: Icons.logout, color: Colors.blueAccent),
      onTap: () async {
        FirebaseAuth.instance.signOut();
        await APIs.updateActiveStatus(false);

        //sign out from app
        await APIs.auth.signOut().then((value) async {
          await GoogleSignIn().signOut().then((value) {
            //for hiding progress dialog
            Navigator.pop(context);

            //for moving to home screen
            Navigator.pop(context);
            // APIs.auth = FirebaseAuth.instance;
            Get.put(UserController());

            final userController = Get.find<UserController>();
            userController.signOut();

            //replacing home screen with login screen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          });
        });
      });

  Widget buildDeleteAccount() => SimpleSettingsTile(
        title: 'Delete Account',
        subtitle: '',
        leading: IconWidget(
          icon: Icons.delete,
          color: Colors.pink,
        ),
        onTap: () => Utils.showSnackbar(context, 'Clicked Delete'),
      );
  Widget buildReportBug() => SimpleSettingsTile(
        title: 'Report Bug',
        subtitle: '',
        leading: IconWidget(
          icon: Icons.bug_report,
          color: Colors.teal,
        ),
        onTap: () => Utils.showSnackbar(context, 'Clicked Report Bug'),
      );
  Widget buildSendFeedback() => SimpleSettingsTile(
        title: 'Send Feedback',
        subtitle: '',
        leading: IconWidget(
          icon: Icons.thumb_up,
          color: Colors.purple,
        ),
        onTap: () => Utils.showSnackbar(context, 'Clicked SendFeedback'),
      );
}
