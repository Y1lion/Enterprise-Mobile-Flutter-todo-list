
import 'package:material_ui/material_ui.dart';
import 'screens/activity_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ActivityListScreen(),
    );
  }
}
