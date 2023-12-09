import 'package:flutter/material.dart';
import 'package:spa_app/routes.dart';
import 'package:spa_app/utils/app_colors.dart';
import 'package:spa_app/utils/styles.dart';

class DefaultScaffoldWidget extends StatelessWidget {
  const DefaultScaffoldWidget(this._title, this._childWidget,
      {this.showMenu = true, super.key});

  final Widget _childWidget;
  final String _title;
  final bool showMenu;

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
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          _title,
          style: Styles.pageTitle,
        ),
      ),
    );
  }

  Widget _buildNavigationBar(BuildContext context) {
    return Hero(
      tag: 'bottombar',
      child: Material(
        color: Colors.white,
        child: SafeArea(
          child: Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.checklist),
                    onPressed: () {
                      Navigator.pushNamed(context, Routes.rules);
                    },
                    color: AppColors.mainColor,
                  ),
                  IconButton(
                    icon: const Icon(Icons.image),
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
                    icon: const Icon(Icons.person),
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
      ),
    );
  }
}
