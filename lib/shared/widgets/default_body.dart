import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spa_app/routes.dart';
import 'package:spa_app/utils/app_colors.dart';
import 'package:spa_app/utils/styles.dart';

class DefaultScaffoldWidget extends StatelessWidget {
  const DefaultScaffoldWidget(
    this._title,
    this._childWidget, {
    this.showMenu = true,
    this.actions = const [],
    super.key,
  });

  final Widget _childWidget;
  final String _title;
  final bool showMenu;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: showMenu
          ? FloatingActionButton(
              backgroundColor: AppColors.buttonColor,
              onPressed: () {
                Navigator.pushNamed(context, Routes.program);
              },
              child: const Icon(Icons.calendar_today, color: Colors.white),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      backgroundColor: Colors.transparent,
      bottomNavigationBar: showMenu ? _buildNavigationBar(context) : null,
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              'assets/background.jpg',
              height: double.infinity,
              alignment: Alignment.topCenter,
              fit: BoxFit.fill,
            ),
          ),
          _childWidget,
        ],
      ),
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            if (Navigator.canPop(context)) {
              return IconButton(
                icon: const Icon(
                    FontAwesomeIcons.arrowLeft), // Put icon of your preference.
                onPressed: () {
                  Navigator.pop(context);
                },
              );
            } else {
              return Container();
            }
          },
        ),
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text(
          _title,
          style: Styles.pageTitle,
        ),
        actions: [
          ...actions,
          // IconButton(
          //   icon: const Icon(FontAwesomeIcons.bell),
          //   onPressed: () {
          //     Navigator.pushNamed(context, Routes.program);
          //   },
          //   color: Colors.white,
          // ),
          // IconButton(
          //   icon: const Icon(FontAwesomeIcons.userLarge, size: 18),
          //   onPressed: () {
          //     Navigator.pushNamed(context, Routes.program);
          //   },
          //   color: Colors.white,
          // ),
        ],
      ),
    );
  }

  Widget _buildNavigationBar(BuildContext context) {
    return Hero(
      tag: 'bottombar',
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4),
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 245, 245, 245),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                  icon: const Icon(FontAwesomeIcons.listOl, size: 20),
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.rules);
                  },
                  color: AppColors.mainColor,
                ),
                IconButton(
                  icon: const Icon(FontAwesomeIcons.solidImage, size: 20),
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.photos);
                  },
                  color: AppColors.mainColor,
                ),
                const SizedBox(width: 32, height: 32),
                IconButton(
                  icon: const Icon(Icons.map),
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.map);
                  },
                  color: AppColors.mainColor,
                ),
                IconButton(
                  icon: const Icon(FontAwesomeIcons.userLarge, size: 18),
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.userDetails);
                  },
                  color: AppColors.mainColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
