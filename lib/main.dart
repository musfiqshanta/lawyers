import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:lawyer/pages/front_pages/category_page.dart';
import 'package:lawyer/pages/front_pages/home_page.dart';
import 'package:lawyer/pages/front_pages/lawyer_page.dart';
import 'package:lawyer/pages/front_pages/login_logout.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lawyer/pages/front_pages/search_page.dart';
import 'package:provider/provider.dart';                  
import 'provider/button_provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Counter()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: const Color(0xff34495e),
        backgroundColor: const Color(0xff34495e),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(
        title: 'Lawyers',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
final  String? title;
 var page;
  MyHomePage({Key? key, this.title, this.page}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late int selectpage;
  @override
  void initState() {
    super.initState();

    selectpage = widget.page ?? 2;
  }

  final _pages = [
    const Categorypage(),
    const ShowAllLawyers(),
    const Homepagem(),
    //MyApps(),
    const SearchPage(),
    const Conditional(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          widget.title.toString(),
        ),
      ),
      body: _pages[selectpage],
      bottomNavigationBar: ConvexAppBar(
          color: Colors.white,
          backgroundColor: Theme.of(context).primaryColor,
          items: const [
            TabItem(icon: Icons.category, title: 'Category'),
            TabItem(icon: Icons.people_outline, title: 'Lawyer'),
            TabItem(icon: Icons.home, title: 'Home'),
            TabItem(icon: Icons.data_usage_sharp, title: 'Search'),
            TabItem(icon: Icons.people, title: 'Profile'),
          ],
          initialActiveIndex: selectpage, //optional, default as 0
          onTap: (int i) {
            debugPrint("click index=$i");
            setState(() {
              selectpage = i;
            });
          }),
    );
  }
}
