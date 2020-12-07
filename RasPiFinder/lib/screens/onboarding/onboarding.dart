import 'package:RasPiFinder/screens/onboarding/sharedPreferences.dart';
import 'package:RasPiFinder/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';


class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
  
}

class _OnBoardingPageState extends State<OnBoardingPage> {

  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    MSharedPreferences.instance.setBooleanValue("firstTimeOpen", true);
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Wrapper()),
    (Route<dynamic> route) => false,);
  }

  Widget _buildImage(String assetName) {
    return Align(
      child: Image.asset('assets/$assetName.jpg', width: 350.0),
      alignment: Alignment.bottomCenter,
    );
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);
    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      pages: [
        PageViewModel(
          title: "Looking for Raspberry Pies",
          body:
              "Instead of having to buy a new Raspberry pie, use the app and search for Raspberry pies.",
          image: _buildImage('searching'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Add multiple Raspberry pies",
          body:
              "Add rasp according to your need",
          image: _buildImage('add'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Update the rasp information",
          body:
              "Track your raspberry and update information.",
          image: _buildImage('locate'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "See list of all available and used rasp",
          body: "View the rasp info, availability and location",
          image: _buildImage('list'),
          footer: RaisedButton(
            onPressed: () {
              introKey.currentState?.animateScroll(0);
            },
            child: const Text(
              'Read again',
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.lightBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Scan for QR code and register a rasp",
          bodyWidget: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("Scan ", style: bodyStyle),
              Icon(Icons.camera_alt),
            ],
          ),
          image: _buildImage('scan'),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      skip: const Text('Skip'),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}
 