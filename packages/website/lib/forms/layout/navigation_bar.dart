import 'package:flutter/material.dart';
import '../../routing/route_names.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'nav_bar_item.dart';

class NavigationBar extends StatelessWidget {
  const NavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: NavigationBarMobile(),
      tablet: NavigationBarTabletDesktop(20),
      desktop: NavigationBarTabletDesktop(50),
    );
  }
}

class NavigationBarMobile extends StatelessWidget {
  const NavigationBarMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
          NavBarLogo()
        ],
      ),
    );
  }
}

class NavigationBarTabletDesktop extends StatelessWidget {
  final double spacing;
  const NavigationBarTabletDesktop(this.spacing);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          NavBarLogo(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              NavBarItem('Home', HomeRoute),
              SizedBox(width: spacing),
              NavBarItem('About', AboutRoute),
              SizedBox(width: spacing),
              NavBarItem('Moqui', MoquiRoute),
              SizedBox(width: spacing),
              NavBarItem('OFBiz', OfbizRoute),
            ],
          )
        ],
      ),
    );
  }
}

class NavBarLogo extends StatelessWidget {
  const NavBarLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        mouseCursor: MaterialStateMouseCursor.clickable,
        onTap: () {
          Navigator.pushNamed(context, HomeRoute);
        },
        child: SizedBox(
          child: Image.asset('assets/growerp.png'),
        ));
  }
}
