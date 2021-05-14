import 'package:flutter/material.dart';
import 'package:fossils_finder/config/global_config.dart';
import 'package:fossils_finder/model/user.dart';
import 'package:fossils_finder/pages/form/password_update.dart';
import 'package:fossils_finder/pages/login/login_page.dart';
import 'package:fossils_finder/widgets/custom_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingPage extends StatefulWidget {
  final User user;

  const SettingPage({Key key, this.user}) : super(key: key);
  
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('设置'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Column(
          children: [
            FListTile('images/icons/password_change_gray.png', '修改密码', (){
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => PasswordUpdatePage(user: widget.user,),
              ));
            }, height: 80, iconSize: 30),
            FListTile('images/icons/logout_gray.png', '退出登陆', (){
              logout();
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => LoginScreen(),
              ));
            }, height: 80, iconSize: 30),
            // ListTile(
            //   leading: new Image.asset(
            //     'images/icons/password_change_gray.png',
            //     width: 21,
            //     height: 21,
            //     fit: BoxFit.fill
            //   ),
            //   title: Text("修改密码"),
            //   onTap: (){
            //     Navigator.of(context).push(MaterialPageRoute(
            //       builder: (context) => PasswordUpdatePage(user: widget.user,),
            //     ));
            //   },
            // ),
            // ListTile(
            //   leading: new Image.asset(
            //     'images/icons/logout_gray.png',
            //     width: 21,
            //     height: 21,
            //     fit: BoxFit.fill
            //   ),
            //   title: Text("退出登陆"),
            //   onTap: (){
            //     logout();
            //     Navigator.of(context).pushReplacement(MaterialPageRoute(
            //       builder: (context) => LoginScreen(),
            //     ));
            //   },
            // ),
          ]
        ),
      )
    );
  }

  logout() async{
    if(localStorage == null) localStorage = await SharedPreferences.getInstance();
    localStorage.remove('token');
  }
}