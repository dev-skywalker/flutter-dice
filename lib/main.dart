import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  static const _primaryColor = Color(0xff052890);
  final themeElement = ThemeData.light().copyWith(
      primaryColor: _primaryColor,
      splashColor: _primaryColor,
      backgroundColor: Colors.white,
      textTheme: TextTheme(
          button: TextStyle(
        fontSize: 24.0,
        letterSpacing: 2.4,
        color: Colors.white,
      )));
  late int pickARandomFace;
  late String dieFaceAssetString;
  late AnimationController animationController;
  late ThemeData _currentTheme;
  late CurvedAnimation animation;

  @override
  void initState() {
    super.initState();
    _currentTheme = themeElement;
    pickARandomFace = Random().nextInt(5) + 1;
    dieFaceAssetString = 'assets/die_face_$pickARandomFace.svg';
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
      lowerBound: 0,
      upperBound: 1,
    );
    animation =
        CurvedAnimation(parent: animationController, curve: Curves.bounceOut);

    animation.addListener(() {
      this.setState(() {
        //print();
      });
    });
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          changeDieFace();
        });
        // print('Completed');
        animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Roll The Die',
        theme: _currentTheme,
        home: Scaffold(
          appBar: AppBar(
            shadowColor: Colors.blueAccent,
            title: Text(
              'LET\'S ROLL IT',
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16.0,
                  letterSpacing: 1.6,
                  color: Color(0xff052890)),
            ),
            centerTitle: true,
            backgroundColor: _currentTheme.backgroundColor,
            elevation: 10,
          ),
          body: Container(
            color: _currentTheme.splashColor,
            width: double.infinity,
            height: double.infinity,
            child: Center(
              child: GestureDetector(
                onTap: roll,
                child: Container(
                  height: 200 - (animation.value) * 200 + 50,
                  width: 200,
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                        color: Colors.white.withAlpha(55),
                        blurRadius: 24.0,
                        offset: Offset(0, 8))
                  ]),
                  child: RotationTransition(
                      turns: animationController,
                      child: SvgPicture.asset(dieFaceAssetString)),
                ),
              ),
            ),
          ),
        ));
  }

  Widget buildButton() {
    return ElevatedButton(
      child: Text("ROLL IT", style: _currentTheme.textTheme.caption),
      onPressed: () {
        roll();
      },
    );
  }

  void roll() {
    animationController.forward();
  }

  void changeDieFace() {
    setState(() {
      dieFaceAssetString = 'assets/die_face_${Random().nextInt(6) + 1}.svg';
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}
