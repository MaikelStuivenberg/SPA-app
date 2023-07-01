import 'package:flutter/material.dart';
import 'package:spa_app/routes.dart';
import 'package:spa_app/utils/app_colors.dart';

class DefaultBodyWidget extends StatelessWidget {
  const DefaultBodyWidget(this._childWidget, {this.showMenu = true, super.key});

  final Widget _childWidget;
  final bool showMenu;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: showMenu ? FloatingActionButton(
        backgroundColor: AppColors.buttonColor,
        onPressed: () {
          Navigator.pushNamed(context, Routes.program);
        },
        child: const Icon(Icons.calendar_today, color: Colors.white),
      ) : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      backgroundColor: AppColors.background,
      bottomNavigationBar: showMenu ? _buildNavigationBar(context) : null,
      body: Stack(
        children: <Widget>[
          SizedBox.expand(
            child: Image.asset(
              'assets/background.jpg',
              fit: BoxFit.fill,
            ),
          ),
          _childWidget
        ],
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
