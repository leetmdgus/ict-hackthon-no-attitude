import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ict_hackthon_no_attitude/screens/ar/ar_screen.dart';
import 'package:ict_hackthon_no_attitude/screens/chatbot/chatbot_screen.dart';
import 'package:ict_hackthon_no_attitude/screens/maps/map_screen.dart';
import 'package:ict_hackthon_no_attitude/shared/constants/colors.dart';
import 'shared/widgets/custom_drawer.dart';
import 'theme/app_theme.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const MainApp(),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const HomeScreen());
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final int userId = 3;

  late TabController _tabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '해키와 함께하는 즐거운 양양',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              width: 50,
            )
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Theme.of(context).primaryColor,
          indicatorWeight: 3,
          tabs: const [
            Tab(
              icon: Icon(Icons.view_in_ar),
              text: 'AR',
            ),
            Tab(
              icon: Icon(Icons.chat_outlined),
              text: '대화',
            ),
          ],
        ),
      ),
      drawer: CustomDrawer(userId: userId),
      body: TabBarView(
        controller: _tabController,
        children: [
          ARScreen(),
          ChatScreen(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: _tabController.index == 1
          ? Padding(
              padding: const EdgeInsets.only(bottom: 100.0),
              child: FloatingActionButton(
                heroTag: null,
                // 여러 FloatingActionButton 사용 시 충돌 방지
                backgroundColor: AppColors.primary,
                elevation: 4,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MapScreen()),
                  );
                },
                child: const Icon(
                  Icons.add_location_alt_outlined,
                  color: Colors.white,
                ),
              ),
            )
          : null,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
