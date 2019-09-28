import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:milo_github_app_flutter/common/style/milo_style.dart';
import 'package:milo_github_app_flutter/common/utils/navigator_utils.dart';

class WelcomePage extends StatefulWidget {
  static const String sName = '/';

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2, milliseconds: 500), () {
      NavigatorUtils.goHome(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    const double size = 200;
    return Container(
      color: Color(MILOColors.white),
      child: Stack(
        children: <Widget>[
          Center(
            child: Image(image: AssetImage('static/images/welcome.png')),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: size,
              height: size,
              child: FlareActor(
                'static/file/flare_flutter_logo_.flr',
                alignment: Alignment.center,
                fit: BoxFit.fill,
                animation: "Placeholder",
              ),
            ),
          )
        ],
      ),
    );
  }
}
