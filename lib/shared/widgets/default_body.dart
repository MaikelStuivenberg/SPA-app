import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spa_app/routes.dart';
import 'package:spa_app/shared/widgets/app_bar_shape.dart';

class DefaultScaffoldWidget extends StatelessWidget {
  const DefaultScaffoldWidget(
    this._title,
    this._childWidget, {
    this.showMenu = true,
    this.actions,
    this.back = false,
    super.key,
  });

  final Widget _childWidget;
  final String? _title;
  final bool showMenu;
  final List<Widget>? actions;
  final bool back;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      floatingActionButton: showMenu
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pushNamed(Routes.home);
              },
              child: const Icon(
                Icons.home,
                size: 32,
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // backgroundColor: Colors.transparent,
      bottomNavigationBar: showMenu ? _buildNavigationBar(context) : null,
      body:  Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.secondary.withOpacity(0),
              colorScheme.secondary.withOpacity(0.05),
              colorScheme.secondary.withOpacity(0.1),
            ],
          ),
        ),
        child: _childWidget,
      ),
      extendBodyBehindAppBar: true,
      extendBody: true,
      resizeToAvoidBottomInset: true,
      appBar: _title == null
          ? null
          : AppBar(
              shape: AppBarShape(),
              automaticallyImplyLeading: false,
              elevation: 1,
              shadowColor: Colors.black,
              // elevation: 0,
              leading: !back
                  ? null
                  : Builder(
                      builder: (BuildContext context) {
                        if (Navigator.canPop(context)) {
                          return IconButton(
                            icon: const Icon(
                              FontAwesomeIcons.arrowLeft,
                            ), // Put icon of your preference.
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          );
                        } else {
                          return const SizedBox();
                        }
                      },
                    ),
              // iconTheme: const IconThemeData(color: Colors.white),
              title: Text(
                _title!,
              ),
              actions: actions ?? [
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.solidUser),
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.userDetails);
                  },
                  color: Colors.white,
                ),
              ],
            ),
    );
  }

  Widget _buildNavigationBar(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () {
              Navigator.of(context).pushNamed(Routes.program);
            },
          ),
          IconButton(
            icon: const Icon(Icons.image),
            onPressed: () {
              Navigator.of(context).pushNamed(Routes.photos);
            },
          ),
          const SizedBox(width: 32, height: 32),
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () {
              Navigator.of(context).pushNamed(Routes.map);
            },
          ),
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {
              Navigator.of(context).pushNamed(Routes.rules);
            },
          ),
        ],
      ),
    );
  }
}
