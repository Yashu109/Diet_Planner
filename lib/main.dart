import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'services/auth_survices.dart';
import 'widgets/navigation_header.dart';
import 'pages/home_page.dart';
import 'pages/profile_page.dart';
import 'pages/login_page.dart';
import 'pages/meal_plans_page.dart';
import 'pages/recipes_page.dart';
import 'pages/analytics_page.dart';
import 'pages/scheduling_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthService(),
      child: MaterialApp(
        title: 'NutriPlan AI',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color(0xFF4CAF50),
          scaffoldBackgroundColor: Colors.white,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF4CAF50),
            primary: const Color(0xFF4CAF50),
            secondary: const Color(0xFF66BB6A),
          ),
          fontFamily: 'Roboto',
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              foregroundColor: Colors.white,
            ),
          ),
        ),
        home: const NutritionApp(),
      ),
    );
  }
}

class NutritionApp extends StatefulWidget {
  const NutritionApp({super.key});

  @override
  State<NutritionApp> createState() => _NutritionAppState();
}

class _NutritionAppState extends State<NutritionApp> {
  int _selectedIndex = 0;

  // Navigation to Profile page
  void _navigateToProfile() {
    final authService = Provider.of<AuthService>(context, listen: false);
    if (authService.isLoggedIn) {
      setState(() {
        _selectedIndex = 5; // Profile page index
      });
    } else {
      // Show login if not logged in
      _showLoginPage();
    }
  }

  // Show login page method
  void _showLoginPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => LoginPage(
              onLoginStateChanged: (isLoggedIn) {
                if (isLoggedIn) {
                  Provider.of<AuthService>(context, listen: false).login();
                  Navigator.pop(context); // Close login page
                }
              },
            ),
      ),
    );
  }

  // Handle logout
  void _handleLogout() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Logout'),
            content: const Text('Are you sure you want to logout?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Provider.of<AuthService>(context, listen: false).logout();
                  // Go back to home page
                  setState(() {
                    _selectedIndex = 0;
                  });
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Logout'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = context.watch<AuthService>().isLoggedIn;

    // Main content pages - initialize here to have access to _navigateToProfile
    final List<Widget> pages = [
      HomePage(onProfileSetupTap: _navigateToProfile),
      MealPlansPage(onLoginTap: _showLoginPage),
      RecipesPage(),
      AnalyticsPage(onLoginTap: _showLoginPage),
      SchedulingPage(onLoginTap: _showLoginPage),
      isLoggedIn
          ? const ProfilePage()
          : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lock, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                const Text(
                  'You need to login to access your profile',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _showLoginPage,
                  child: const Text('Login Now'),
                ),
              ],
            ),
          ),
    ];

    return Scaffold(
      // End drawer for mobile navigation
      endDrawer: _buildNavigationDrawer(),
      body: Column(
        children: [
          // Responsive navigation header
          ResponsiveNavigationHeader(
            selectedIndex: _selectedIndex,
            onTabSelected: (index) {
              // If trying to access profile and not logged in, show login
              if (index == 5 && !isLoggedIn) {
                _showLoginPage();
              } else {
                setState(() {
                  _selectedIndex = index;
                });
              }
            },
            onLoginTap: isLoggedIn ? _handleLogout : _showLoginPage,
            isLoggedIn: isLoggedIn,
          ),

          // Page content
          Expanded(child: pages[_selectedIndex]),
        ],
      ),
    );
  }

  // Mobile navigation drawer
  Widget _buildNavigationDrawer() {
    final isLoggedIn = context.watch<AuthService>().isLoggedIn;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Color(0xFF4CAF50)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    const Icon(Icons.spa, color: Colors.white, size: 30),
                    const SizedBox(width: 10),
                    RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: 'Nutri',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: 'Plan AI',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'Your Personalized Nutrition Assistant',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),
          _buildDrawerItem(0, Icons.home, 'Home'),
          _buildDrawerItem(1, Icons.restaurant_menu, 'Meal Plans'),
          _buildDrawerItem(2, Icons.book, 'Recipes'),
          _buildDrawerItem(3, Icons.analytics, 'Analytics'),
          _buildDrawerItem(4, Icons.schedule, 'Scheduling'),
          _buildDrawerItem(5, Icons.person, 'Profile'),
          const Divider(),
          ListTile(
            leading: Icon(
              isLoggedIn ? Icons.logout : Icons.login,
              color: isLoggedIn ? Colors.red : Colors.grey,
            ),
            title: Text(
              isLoggedIn ? 'Logout' : 'Login',
              style: TextStyle(color: isLoggedIn ? Colors.red : Colors.black87),
            ),
            onTap: () {
              Navigator.pop(context); // Close drawer
              if (isLoggedIn) {
                _handleLogout();
              } else {
                _showLoginPage();
              }
            },
          ),
        ],
      ),
    );
  }

  // Drawer item
  Widget _buildDrawerItem(int index, IconData icon, String label) {
    final isLoggedIn = context.watch<AuthService>().isLoggedIn;
    final bool requiresAuth =
        index == 5; // Profile page requires authentication
    final bool isDisabled = requiresAuth && !isLoggedIn;

    return ListTile(
      leading: Icon(
        icon,
        color:
            isDisabled
                ? Colors.grey.withOpacity(0.5)
                : (_selectedIndex == index
                    ? const Color(0xFF4CAF50)
                    : Colors.grey),
      ),
      title: Text(
        label,
        style: TextStyle(
          color:
              isDisabled
                  ? Colors.grey.withOpacity(0.5)
                  : (_selectedIndex == index
                      ? const Color(0xFF4CAF50)
                      : Colors.black87),
          fontWeight:
              _selectedIndex == index ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: _selectedIndex == index,
      selectedTileColor: const Color(0xFFE8F5E9),
      onTap:
          isDisabled
              ? () {
                Navigator.pop(context); // Close drawer
                _showLoginPage(); // Show login page instead
              }
              : () {
                setState(() {
                  _selectedIndex = index;
                });
                Navigator.pop(context); // Close the drawer
              },
    );
  }
}
