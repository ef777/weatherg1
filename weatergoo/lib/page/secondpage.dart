import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';

// ignore: camel_case_types
class secondpage extends StatefulWidget {
  const secondpage({Key? key}) : super(key: key);

  @override
  State<secondpage> createState() => _secondpageState();
}

// ignore: camel_case_types
class _secondpageState extends State<secondpage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int pageview = 0;
  late PageController _pageController;
  @override
  void initState() {
    super.initState();

    _pageController =
        PageController(initialPage: pageview, viewportFraction: 0.6);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 80) / 2.2;
    final double itemWidth = size.width / 2;
    return Scaffold(key: _scaffoldKey, appBar: AppBar(), body: Container());
  }
}
