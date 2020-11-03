import '../routing_constants.dart';

class MenuItem {
  int menuItemId;
  String image;
  String selectedImage;
  String title;
  String route;
  List userGroups;

  MenuItem(
      {this.menuItemId,
      this.image,
      this.selectedImage,
      this.title,
      this.route,
      this.userGroups});

  @override
  String toString() => 'MenuItem name: $title [$menuItemId]';
}

List<MenuItem> menuItems = [
  MenuItem(
      menuItemId: 100,
      image: "assets/dashBoardGrey.png",
      selectedImage: "assets/dashBoard.png",
      title: "Dash Board",
      route: HomeRoute,
      userGroups: ["GROWERP_M_ADMIN", "GROWERP_M_EMPLOYEE"]),
  MenuItem(
      menuItemId: 200,
      image: "assets/myInfoGrey.png",
      selectedImage: "assets/myInfo.png",
      title: "User Info",
      route: UserRoute,
      userGroups: ["GROWERP_M_ADMIN", "GROWERP_M_EMPLOYEE"]),
  MenuItem(
      menuItemId: 300,
      image: "assets/companyGrey.png",
      selectedImage: "assets/company.png",
      title: "Company Info",
      route: CompanyRoute,
      userGroups: ["GROWERP_M_ADMIN", "GROWERP_M_EMPLOYEE"]),
  MenuItem(
      menuItemId: 400,
      image: "assets/usersGrey.png",
      selectedImage: "assets/users.png",
      title: "User list",
      route: UsersRoute,
      userGroups: ["GROWERP_M_ADMIN", "GROWERP_M_EMPLOYEE"]),
  MenuItem(
      menuItemId: 500,
      image: "assets/aboutGrey.png",
      selectedImage: "assets/about.png",
      title: "About",
      route: AboutRoute,
      userGroups: ["GROWERP_M_ADMIN", "GROWERP_M_EMPLOYEE"]),
];
