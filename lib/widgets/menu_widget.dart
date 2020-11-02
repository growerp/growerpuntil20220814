import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

List options = [
  {"image": "assets/dashBoard.png", "title": "Dash Board", "route": "/home"},
  {"image": "assets/myInfo.png", "title": "User Info", "route": "/user"},
  {"image": "assets/company.png", "title": "Company Info", "route": "/company"},
  {"image": "assets/users.png", "title": "User list", "route": "/users"},
  {"image": "assets/about.png", "title": "About", "route": "/about"},
];

Widget myDrawer(context, authenticate) {
  bool loggedIn = authenticate?.apiKey != null;
  return (loggedIn && ResponsiveWrapper.of(context).isSmallerThan(TABLET))
      ? Drawer(
          child: ListView.builder(
          itemCount: options.length + 1,
          itemBuilder: (context, i) {
            if (i == 0)
              return DrawerHeader(
                  child: Column(children: [
                CircleAvatar(
                    backgroundColor: Colors.green,
                    radius: 40,
                    child: authenticate?.user?.image != null
                        ? Image.memory(authenticate.user?.image)
                        : Text(
                            authenticate.user?.firstName?.substring(0, 1) ?? '',
                            style:
                                TextStyle(fontSize: 30, color: Colors.black))),
                SizedBox(height: 20),
                Text(
                    "${authenticate.user.firstName} "
                    "${authenticate.user.lastName}",
                    style: TextStyle(fontSize: 20, color: Colors.black)),
              ]));
            return ListTile(
                contentPadding: EdgeInsets.all(5.0),
                title: Text(options[i - 1]["title"]),
                leading: Image.asset(
                  options[i - 1]["image"],
                ),
                onTap: () {
                  Navigator.pushNamed(context, options[i - 1]["route"]);
                });
          },
        ))
      : null;
}

Widget myNavigationRail(context, authenticate, widget, selectedIndex) {
  List<NavigationRailDestination> items = [];
  options.forEach((option) => {
        items.add(NavigationRailDestination(
          icon: Image.asset(option["image"]),
          label: Text(option["title"]),
        )),
      });

  return Row(children: <Widget>[
    NavigationRail(
        leading: Center(
            child: Column(children: [
          CircleAvatar(
              backgroundColor: Colors.green,
              radius: 40,
              child: authenticate.user?.image != null
                  ? Image.memory(authenticate?.user?.image)
                  : Text(authenticate?.user?.firstName?.substring(0, 1) ?? '',
                      style: TextStyle(fontSize: 30, color: Colors.black))),
          Text("${authenticate.user.firstName} "
              "${authenticate.user.lastName}"),
        ])),
        selectedIndex: selectedIndex,
        onDestinationSelected: (int index) {
          selectedIndex = index;
          Navigator.pushNamed(context, options[index]["route"]);
        },
        labelType: NavigationRailLabelType.selected,
        destinations: items),
    VerticalDivider(thickness: 1, width: 1),
    // This is the main content.
    Expanded(child: widget)
  ]);
}
