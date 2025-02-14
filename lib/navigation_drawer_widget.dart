import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nearsq/navigation_controller.dart';
import 'package:nearsq/drawer_items.dart';
import 'package:nearsq/drawer_item.dart';

// import 'package:nearsq/page/deployment_page.dart';
// import 'package:nearsq/page/get_started_page.dart';
// import 'package:nearsq/page/performance_page.dart';
// import 'package:nearsq/page/resources_page.dart';
// import 'package:nearsq/page/samples_page.dart';
// import 'package:nearsq/page/testing_page.dart';

class NavigationDrawerWidget extends StatelessWidget {
   EdgeInsets padding = EdgeInsets.symmetric(horizontal: 20);

  NavigationDrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final safeArea =
        EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top);

    // Access the NavigationController using GetX
    final NavigationController navigationController = Get.find();

    return Container(
      width: navigationController.isCollapsed.value
          ? MediaQuery.of(context).size.width * 0.2
          : null,
      child: Drawer(
        child: Container(
          color: Colors.black,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 24).add(safeArea),
                width: double.infinity,
                color: Colors.white12,
                child: buildHeader(navigationController.isCollapsed.value),
              ),
              const SizedBox(height: 24),
              buildList(
                items: itemsFirst,
                isCollapsed: navigationController.isCollapsed.value,
              ),
              const SizedBox(height: 24),
              Divider(color: Colors.white70),
              const SizedBox(height: 24),
              buildList(
                indexOffset: itemsFirst.length,
                items: itemsSecond,
                isCollapsed: navigationController.isCollapsed.value,
              ),
              Spacer(),
              buildCollapseIcon(context, navigationController),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildList({
    required bool isCollapsed,
    required List<DrawerItem> items,
    int indexOffset = 0,
  }) =>
      ListView.separated(
        padding: isCollapsed ? EdgeInsets.zero : padding,
        shrinkWrap: true,
        primary: false,
        itemCount: items.length,
        separatorBuilder: (context, index) => SizedBox(height: 16),
        itemBuilder: (context, index) {
          final item = items[index];

          return buildMenuItem(
            isCollapsed: isCollapsed,
            text: item.title,
            icon: item.icon,
            onClicked: () => selectItem(context, indexOffset + index),
          );
        },
      );

  void selectItem(BuildContext context, int index) {
    final navigateTo = (page) => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => page,
        ));

    Navigator.of(context).pop();

    switch (index) {
      case 0:
        navigateTo(GetStartedPage());
        break;
      case 1:
        navigateTo(SamplesPage());
        break;
      // case 2:
      //   navigateTo(TestingPage());
      //   break;
      // case 3:
      //   navigateTo(PerformancePage());
      //   break;
      // case 4:
      //   navigateTo(DeploymentPage());
      //   break;
      // case 5:
      //   navigateTo(ResourcesPage());
      //   break;
    }
  }

  Widget buildMenuItem({
    required bool isCollapsed,
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    final color = Colors.white;
    final leading = Icon(icon, color: color);

    return Material(
      color: Colors.transparent,
      child: isCollapsed
          ? ListTile(
              title: leading,
              onTap: onClicked,
            )
          : ListTile(
              leading: leading,
              title: Text(text, style: TextStyle(color: color, fontSize: 16)),
              onTap: onClicked,
            ),
    );
  }

  Widget buildCollapseIcon(BuildContext context, NavigationController controller) {
    final double size = 52;
    final icon = controller.isCollapsed.value
        ? Icons.arrow_forward_ios
        : Icons.arrow_back_ios;
    final alignment =
        controller.isCollapsed.value ? Alignment.center : Alignment.centerRight;
    final margin = controller.isCollapsed.value ? null : EdgeInsets.only(right: 16);
    final width = controller.isCollapsed.value ? double.infinity : size;

    return Container(
      alignment: alignment,
      margin: margin,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          child: Container(
            width: width,
            height: size,
            child: Icon(icon, color: Colors.white),
          ),
          onTap: () {
            controller.toggleIsCollapsed();
          },
        ),
      ),
    );
  }

  Widget buildHeader(bool isCollapsed) => isCollapsed
      ? FlutterLogo(size: 48)
      : Row(
          children: [
            const SizedBox(width: 24),
            FlutterLogo(size: 48),
            const SizedBox(width: 16),
            Text(
              'Flutter',
              style: TextStyle(fontSize: 32, color: Colors.white),
            ),
          ],
        );
}


class GetStartedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Get Started'),
          centerTitle: true,
          backgroundColor: Colors.green,
        ),
      );
}
class SamplesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Samples & Tutorials'),
          centerTitle: true,
          backgroundColor: Colors.orange,
        ),
      );
}