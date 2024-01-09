import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:spa_app/routes.dart';
import 'package:spa_app/shared/widgets/app_bar_shape.dart';

class DefaultScaffoldWidget extends StatelessWidget {
  const DefaultScaffoldWidget(
    this._title,
    this._childWidget, {
    this.showMenu = true,
    this.actions = const [],
    this.back = false,
    super.key,
  });

  final Widget _childWidget;
  final String? _title;
  final bool showMenu;
  final List<Widget> actions;
  final bool back;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: showMenu
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pushNamed(Routes.program);
              },
              child: const Icon(Icons.calendar_today),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // backgroundColor: Colors.transparent,
      bottomNavigationBar: showMenu ? _buildNavigationBar(context) : null,
      body: _childWidget,
      extendBodyBehindAppBar: true,
      extendBody: true,
      resizeToAvoidBottomInset: false,
      appBar: _title == null ? null : AppBar(
        shape: AppBarShape(),
        automaticallyImplyLeading: false,
        elevation: 1,
        shadowColor: Colors.black,
        // elevation: 0,
        leading: !back ? null: Builder(
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
          //   icon: const Icon(FontAwesomeIcons.userLarge),
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
    return BottomAppBar(
      notchMargin: 0,
      shape: AutomaticNotchedShape(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {
              Navigator.of(context).pushNamed(Routes.rules);
            },
            
          ),
          IconButton(
            icon: const Icon(Icons.image),
            onPressed: () {
              Navigator.of(context).pushNamed(Routes.photos);
            },
          ),
          const SizedBox(width: 32, height: 32),
          // IconButton(
          //   onPressed: () {
          //     Navigator.of(context).pushNamed(Routes.program);
          //   },
          //   icon: const Icon(Icons.calendar_today),
          //   // Use main iconbutton style, but add background color
          //   // style: ButtonStyle(
          //   //   backgroundColor: MaterialStateProperty.all<Color>(
          //   //     Theme.of(context).highlightColor,
          //   //   ),
          //   //   shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          //   //     RoundedRectangleBorder(
          //   //       borderRadius: BorderRadius.circular(8.0),
          //   //     ),
          //   //   ),
          //   //   padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          //   //     const EdgeInsets.all(16),
          //   //   ),
          //   // ),
          // ),
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () {
              Navigator.of(context).pushNamed(Routes.map);
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_2),
            onPressed: () {
              Navigator.of(context).pushNamed(Routes.userDetails);
            },
          ),
        ],
      ),
    );
  }
}
