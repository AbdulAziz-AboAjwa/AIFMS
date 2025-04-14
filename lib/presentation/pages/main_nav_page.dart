import 'package:ai_financial_management_system/presentation/pages/report_page.dart';
import 'package:ai_financial_management_system/presentation/components/colors.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
// ignore: depend_on_referenced_packages
import 'package:page_transition/page_transition.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

import 'ai_chat_page.dart';
import 'home_page.dart';

class HomeMain extends StatefulWidget {
  const HomeMain({super.key});

  @override
  State<HomeMain> createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain> {


  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Image.asset('assets/images/AIFMS.png'),
      splashTransition: SplashTransition.fadeTransition,
      pageTransitionType: PageTransitionType.fade,
      duration: 2500,
      splashIconSize: 110,
      backgroundColor: const Color.fromARGB(255, 20, 17, 24),
      nextScreen: NavigationPage(),
    );
  }
}

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {

    final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    ReportPage(),
    AiChatPage(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          animationDuration: const Duration(milliseconds: 500),
          height: 55,
          backgroundColor: const Color.fromARGB(0, 0, 0, 0),
          color: mainGreen,
          index: _currentIndex,
          items: [
            Icon(
              Icons.home_rounded,
              size: 30,
              color: mainWhite,
            ),
            Icon(
              Icons.bar_chart_rounded,
              size: 30,
              color: mainWhite,
            ),
            Icon(
              Icons.chat,
              size: 27,
              color: mainWhite,
            ),
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            });
          },
        ),
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          children: _pages,
        ),
      ),
    );
  }
}
