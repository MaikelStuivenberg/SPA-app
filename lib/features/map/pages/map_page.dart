import 'package:flutter/material.dart';
import 'package:spa_app/features/rules/widgets/rule_container.dart';
import 'package:spa_app/shared/widgets/default_body.dart';
import 'package:spa_app/utils/styles.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  MapPageState createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return DefaultBodyWidget(
      SafeArea(
        child: Column(
          children: [
            const Text(
              'Kaart',
              style: Styles.pageTitle,
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: InteractiveViewer(
                panEnabled: false, // Set it to false
                boundaryMargin: EdgeInsets.all(100),
                minScale: 0.5,
                maxScale: 2,
                child: Image.asset('assets/map.png'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
