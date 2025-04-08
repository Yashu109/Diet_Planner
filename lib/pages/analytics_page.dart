import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_survices.dart';
import 'dart:math';

class AnalyticsPage extends StatefulWidget {
  final VoidCallback onLoginTap;

  const AnalyticsPage({super.key, required this.onLoginTap});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedTimeframe = 'Week';
  final List<String> _timeframes = ['Week', 'Month', '3 Months', 'Year'];

  // Dummy data for analytics
  final Map<String, dynamic> _nutritionData = {
    'calories': {
      'goal': 2000,
      'current': 1850,
      'average': 1920,
      'trend': 'down',
      'daily': [1950, 1880, 1760, 1900, 1820, 1750, 1850],
    },
    'protein': {
      'goal': 150,
      'current': 142,
      'average': 138,
      'trend': 'up',
      'daily': [130, 145, 135, 142, 140, 138, 142],
    },
    'carbs': {
      'goal': 200,
      'current': 180,
      'average': 195,
      'trend': 'down',
      'daily': [210, 205, 190, 185, 190, 175, 180],
    },
    'fat': {
      'goal': 65,
      'current': 68,
      'average': 64,
      'trend': 'stable',
      'daily': [62, 65, 70, 65, 60, 65, 68],
    },
    'water': {
      'goal': 8,
      'current': 6,
      'average': 7,
      'trend': 'stable',
      'daily': [6, 7, 8, 6, 7, 8, 6],
    },
  };

  // Dummy weekly meal rating data
  final List<Map<String, dynamic>> _mealRatings = [
    {'day': 'Mon', 'breakfast': 4, 'lunch': 5, 'dinner': 3},
    {'day': 'Tue', 'breakfast': 5, 'lunch': 4, 'dinner': 4},
    {'day': 'Wed', 'breakfast': 3, 'lunch': 4, 'dinner': 5},
    {'day': 'Thu', 'breakfast': 4, 'lunch': 3, 'dinner': 4},
    {'day': 'Fri', 'breakfast': 5, 'lunch': 4, 'dinner': 5},
    {'day': 'Sat', 'breakfast': 4, 'lunch': 5, 'dinner': 4},
    {'day': 'Sun', 'breakfast': 3, 'lunch': 4, 'dinner': 5},
  ];

  // Dummy nutrient balance data
  final Map<String, dynamic> _nutrientBalance = {
    'protein': 30,
    'carbs': 45,
    'fat': 25,
  };

  // Dummy weight tracking data
  final List<Map<String, dynamic>> _weightData = [
    {'date': 'Apr 1', 'weight': 180.5},
    {'date': 'Apr 8', 'weight': 179.8},
    {'date': 'Apr 15', 'weight': 178.6},
    {'date': 'Apr 22', 'weight': 178.2},
    {'date': 'Apr 29', 'weight': 177.5},
    {'date': 'May 6', 'weight': 177.0},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isLoggedIn = context.watch<AuthService>().isLoggedIn;

    return Scaffold(
      body:
          isLoggedIn
              ? Column(
                children: [
                  // Tab bar for different analytics views
                  Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        // Timeframe selector
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Analytics Dashboard',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF4CAF50),
                                ),
                              ),
                              DropdownButton<String>(
                                value: _selectedTimeframe,
                                icon: Icon(Icons.arrow_drop_down),
                                elevation: 16,
                                style: TextStyle(color: Color(0xFF4CAF50)),
                                underline: Container(
                                  height: 2,
                                  color: Color(0xFF4CAF50),
                                ),
                                onChanged: (String? value) {
                                  if (value != null) {
                                    setState(() {
                                      _selectedTimeframe = value;
                                    });
                                  }
                                },
                                items:
                                    _timeframes.map<DropdownMenuItem<String>>((
                                      String value,
                                    ) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                              ),
                            ],
                          ),
                        ),

                        // Tab bar
                        TabBar(
                          controller: _tabController,
                          labelColor: Color(0xFF4CAF50),
                          unselectedLabelColor: Colors.grey,
                          indicatorColor: Color(0xFF4CAF50),
                          tabs: [
                            Tab(text: 'Nutrition', icon: Icon(Icons.pie_chart)),
                            Tab(text: 'Goals', icon: Icon(Icons.flag)),
                            Tab(
                              text: 'Progress',
                              icon: Icon(Icons.trending_up),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Tab content
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // Nutrition tab
                        _buildNutritionTab(isMobile),

                        // Goals tab
                        _buildGoalsTab(isMobile),

                        // Progress tab
                        _buildProgressTab(isMobile),
                      ],
                    ),
                  ),
                ],
              )
              : _buildLoginPrompt(),
    );
  }

  // Nutrition analysis tab
  Widget _buildNutritionTab(bool isMobile) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Daily calorie summary card
          _buildSummaryCard(
            title: 'Daily Calories',
            currentValue: _nutritionData['calories']['current'],
            goalValue: _nutritionData['calories']['goal'],
            unit: 'cal',
            iconData: Icons.local_fire_department,
            trendDirection: _nutritionData['calories']['trend'],
            color: Colors.orange,
          ),

          SizedBox(height: 24),

          // Macro cards (protein, carbs, fat)
          Text(
            'Macronutrients',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          isMobile
              ? Column(
                children: [
                  _buildSummaryCard(
                    title: 'Protein',
                    currentValue: _nutritionData['protein']['current'],
                    goalValue: _nutritionData['protein']['goal'],
                    unit: 'g',
                    iconData: Icons.fitness_center,
                    trendDirection: _nutritionData['protein']['trend'],
                    color: Colors.red,
                  ),
                  SizedBox(height: 16),
                  _buildSummaryCard(
                    title: 'Carbohydrates',
                    currentValue: _nutritionData['carbs']['current'],
                    goalValue: _nutritionData['carbs']['goal'],
                    unit: 'g',
                    iconData: Icons.grain,
                    trendDirection: _nutritionData['carbs']['trend'],
                    color: Colors.amber,
                  ),
                  SizedBox(height: 16),
                  _buildSummaryCard(
                    title: 'Fat',
                    currentValue: _nutritionData['fat']['current'],
                    goalValue: _nutritionData['fat']['goal'],
                    unit: 'g',
                    iconData: Icons.opacity,
                    trendDirection: _nutritionData['fat']['trend'],
                    color: Colors.blue,
                  ),
                ],
              )
              : Row(
                children: [
                  Expanded(
                    child: _buildSummaryCard(
                      title: 'Protein',
                      currentValue: _nutritionData['protein']['current'],
                      goalValue: _nutritionData['protein']['goal'],
                      unit: 'g',
                      iconData: Icons.fitness_center,
                      trendDirection: _nutritionData['protein']['trend'],
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildSummaryCard(
                      title: 'Carbohydrates',
                      currentValue: _nutritionData['carbs']['current'],
                      goalValue: _nutritionData['carbs']['goal'],
                      unit: 'g',
                      iconData: Icons.grain,
                      trendDirection: _nutritionData['carbs']['trend'],
                      color: Colors.amber,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildSummaryCard(
                      title: 'Fat',
                      currentValue: _nutritionData['fat']['current'],
                      goalValue: _nutritionData['fat']['goal'],
                      unit: 'g',
                      iconData: Icons.opacity,
                      trendDirection: _nutritionData['fat']['trend'],
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),

          SizedBox(height: 24),

          // Calorie trend chart
          Text(
            'Calorie Trends',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Container(
            height: 200,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: _buildCalorieChart(),
          ),

          SizedBox(height: 24),

          // Nutrient balance chart
          Text(
            'Nutrient Balance',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildLegendItem('Protein', Colors.red),
                      _buildLegendItem('Carbs', Colors.amber),
                      _buildLegendItem('Fat', Colors.blue),
                    ],
                  ),
                  SizedBox(height: 16),
                  Container(
                    height: 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[200],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: _nutrientBalance['protein'],
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                              color: Colors.red,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: _nutrientBalance['carbs'],
                          child: Container(color: Colors.amber),
                        ),
                        Expanded(
                          flex: _nutrientBalance['fat'],
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Your macronutrient distribution is within recommended range',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 24),

          // Water intake
          _buildSummaryCard(
            title: 'Water Intake',
            currentValue: _nutritionData['water']['current'],
            goalValue: _nutritionData['water']['goal'],
            unit: 'cups',
            iconData: Icons.water_drop,
            trendDirection: _nutritionData['water']['trend'],
            color: Colors.blue,
          ),

          SizedBox(height: 24),

          // Insights card
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lightbulb, color: Color(0xFF4CAF50)),
                      SizedBox(width: 8),
                      Text(
                        'Nutrition Insights',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  _buildInsightItem(
                    icon: Icons.thumb_up,
                    title: 'Good job!',
                    description:
                        'You\'ve been consistent with your protein intake this week.',
                  ),
                  SizedBox(height: 12),
                  _buildInsightItem(
                    icon: Icons.trending_down,
                    title: 'Watch your carbs',
                    description:
                        'Your carbohydrate intake has been trending down. Consider adding more whole grains to your diet.',
                  ),
                  SizedBox(height: 12),
                  _buildInsightItem(
                    icon: Icons.water_drop,
                    title: 'Stay hydrated',
                    description:
                        'Try to drink 2 more cups of water daily to reach your hydration goal.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Goals tracking tab
  Widget _buildGoalsTab(bool isMobile) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Weight goal card
          _buildGoalCard(
            title: 'Weight Goal',
            currentValue: '177 lbs',
            targetValue: '170 lbs',
            progress: 0.3,
            iconData: Icons.monitor_weight,
            subtitle: 'Lost 3.5 lbs (3.5 lbs to go)',
            colorStart: Colors.blue,
            colorEnd: Colors.green,
          ),

          SizedBox(height: 24),

          // Nutritional goals
          Text(
            'Nutritional Goals',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _buildSmallGoalCard(
                title: 'Protein',
                currentValue: '142g',
                targetValue: '150g',
                progress: 0.95,
                color: Colors.red,
              ),
              _buildSmallGoalCard(
                title: 'Carbs',
                currentValue: '180g',
                targetValue: '200g',
                progress: 0.9,
                color: Colors.amber,
              ),
              _buildSmallGoalCard(
                title: 'Fat',
                currentValue: '68g',
                targetValue: '65g',
                progress: 1.05,
                color: Colors.blue,
              ),
              _buildSmallGoalCard(
                title: 'Fiber',
                currentValue: '22g',
                targetValue: '30g',
                progress: 0.73,
                color: Colors.green,
              ),
            ],
          ),

          SizedBox(height: 24),

          // Habit tracker
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Healthy Habits',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.add),
                        label: Text('Add'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Color(0xFF4CAF50),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  _buildHabitTracker(
                    habit: 'Drink 8 glasses of water',
                    completedDays: [0, 1, 3, 4, 6],
                    color: Colors.blue,
                  ),
                  SizedBox(height: 12),
                  _buildHabitTracker(
                    habit: 'No added sugar',
                    completedDays: [0, 2, 3, 5],
                    color: Colors.purple,
                  ),
                  SizedBox(height: 12),
                  _buildHabitTracker(
                    habit: 'Exercise 30 minutes',
                    completedDays: [1, 3, 5],
                    color: Colors.orange,
                  ),
                  SizedBox(height: 12),
                  _buildHabitTracker(
                    habit: 'Eat 5 servings of vegetables',
                    completedDays: [2, 4, 6],
                    color: Colors.green,
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 24),

          // Meal ratings
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Meal Satisfaction',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Container(height: 250, child: _buildMealRatingChart()),
                  SizedBox(height: 8),
                  Center(
                    child: Wrap(
                      spacing: 16,
                      children: [
                        _buildLegendItem('Breakfast', Colors.green),
                        _buildLegendItem('Lunch', Colors.blue),
                        _buildLegendItem('Dinner', Colors.purple),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Progress tracking tab
  Widget _buildProgressTab(bool isMobile) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Weight progress chart
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Weight Progress',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.add),
                        label: Text('Add'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Color(0xFF4CAF50),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'From 180.5 lbs to 177.0 lbs (-3.5 lbs)',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 16),
                  Container(height: 200, child: _buildWeightChart()),
                ],
              ),
            ),
          ),

          SizedBox(height: 24),

          // Streak and achievement stats
          isMobile
              ? Column(
                children: [
                  _buildStatCard(
                    title: 'Current Streak',
                    value: '14',
                    subtitle: 'days',
                    icon: Icons.local_fire_department,
                    color: Colors.orange,
                  ),
                  SizedBox(height: 16),
                  _buildStatCard(
                    title: 'Logged Meals',
                    value: '98',
                    subtitle: 'meals',
                    icon: Icons.restaurant_menu,
                    color: Colors.purple,
                  ),
                  SizedBox(height: 16),
                  _buildStatCard(
                    title: 'Achievements',
                    value: '8',
                    subtitle: 'unlocked',
                    icon: Icons.emoji_events,
                    color: Colors.amber,
                  ),
                ],
              )
              : Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      title: 'Current Streak',
                      value: '14',
                      subtitle: 'days',
                      icon: Icons.local_fire_department,
                      color: Colors.orange,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      title: 'Logged Meals',
                      value: '98',
                      subtitle: 'meals',
                      icon: Icons.restaurant_menu,
                      color: Colors.purple,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      title: 'Achievements',
                      value: '8',
                      subtitle: 'unlocked',
                      icon: Icons.emoji_events,
                      color: Colors.amber,
                    ),
                  ),
                ],
              ),

          SizedBox(height: 24),

          // Recent achievements
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recent Achievements',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  _buildAchievementItem(
                    title: 'Two-Week Streak',
                    description: 'Logged your meals for 14 consecutive days',
                    icon: Icons.local_fire_department,
                    date: 'Today',
                    color: Colors.orange,
                  ),
                  Divider(),
                  _buildAchievementItem(
                    title: 'Protein Champion',
                    description: 'Met your protein goal for 7 days in a row',
                    icon: Icons.fitness_center,
                    date: '3 days ago',
                    color: Colors.red,
                  ),
                  Divider(),
                  _buildAchievementItem(
                    title: 'First Pound Down',
                    description: 'Lost your first pound since starting',
                    icon: Icons.trending_down,
                    date: '1 week ago',
                    color: Colors.green,
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 24),

          // Wellness score
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Wellness Score',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [Colors.green, Color(0xFF4CAF50)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withOpacity(0.3),
                              blurRadius: 10,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            '85',
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Your wellness score is calculated based on your nutrition, exercise, sleep, and stress levels. Your score indicates that you\'re on track with your health goals!',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildScoreItem('Nutrition', 88),
                      _buildScoreItem('Exercise', 75),
                      _buildScoreItem('Sleep', 82),
                      _buildScoreItem('Stress', 90),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget shown when user is not logged in
  Widget _buildLoginPrompt() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.lock, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Login to view your analytics',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: widget.onLoginTap,
            child: Text('Login Now'),
          ),
        ],
      ),
    );
  }

  // Nutrition summary card widget
  Widget _buildSummaryCard({
    required String title,
    required int currentValue,
    required int goalValue,
    required String unit,
    required IconData iconData,
    required String trendDirection,
    required Color color,
  }) {
    final double percentage = currentValue / goalValue;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(iconData, color: color),
                    SizedBox(width: 8),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      trendDirection == 'up'
                          ? Icons.trending_up
                          : trendDirection == 'down'
                          ? Icons.trending_down
                          : Icons.trending_flat,
                      color:
                          trendDirection == 'up'
                              ? Colors.green
                              : trendDirection == 'down'
                              ? Colors.red
                              : Colors.grey,
                      size: 20,
                    ),
                    SizedBox(width: 4),
                    Text(
                      '$currentValue of $goalValue $unit',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            LinearProgressIndicator(
              value: percentage > 1.0 ? 1.0 : percentage,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            SizedBox(height: 8),
            Text(
              '${(percentage * 100).toInt()}% of daily goal',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  // Fitness goal card widget
  Widget _buildGoalCard({
    required String title,
    required String currentValue,
    required String targetValue,
    required double progress,
    required IconData iconData,
    required String subtitle,
    required Color colorStart,
    required Color colorEnd,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(iconData, color: colorStart),
                SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  currentValue,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  targetValue,
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ],
            ),
            SizedBox(height: 16),
            Container(
              height: 12,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.grey[200],
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: (progress * 100).toInt(),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        gradient: LinearGradient(
                          colors: [colorStart, colorEnd],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: (100 - progress * 100).toInt(),
                    child: Container(),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  // Small goal card widget
  Widget _buildSmallGoalCard({
    required String title,
    required String currentValue,
    required String targetValue,
    required double progress,
    required Color color,
  }) {
    return Container(
      width: 150,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    currentValue,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  Text(
                    targetValue,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
              SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress > 1.0 ? 1.0 : progress,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  minHeight: 8,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '${(progress * 100).toInt()}%',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Stat card widget
  Widget _buildStatCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  // Habit tracker widget
  Widget _buildHabitTracker({
    required String habit,
    required List<int> completedDays,
    required Color color,
  }) {
    final daysOfWeek = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    return Row(
      children: [
        Expanded(flex: 6, child: Text(habit, style: TextStyle(fontSize: 16))),
        Expanded(
          flex: 7,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(7, (index) {
              final isCompleted = completedDays.contains(index);
              return Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCompleted ? color : Colors.grey[200],
                  border: Border.all(
                    color: isCompleted ? color : Colors.grey[400]!,
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    daysOfWeek[index],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isCompleted ? Colors.white : Colors.grey[600],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  // Achievement item widget
  Widget _buildAchievementItem({
    required String title,
    required String description,
    required IconData icon,
    required String date,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.1),
            ),
            child: Center(child: Icon(icon, color: color, size: 24)),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          SizedBox(width: 8),
          Text(date, style: TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  // Insight item widget
  Widget _buildInsightItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Color(0xFF4CAF50), size: 20),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Legend item widget
  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
      ],
    );
  }

  // Score item widget
  Widget _buildScoreItem(String label, int score) {
    Color color;
    if (score >= 85) {
      color = Colors.green;
    } else if (score >= 70) {
      color = Colors.amber;
    } else {
      color = Colors.red;
    }

    return Column(
      children: [
        Text(
          score.toString(),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }

  // Calorie chart widget
  Widget _buildCalorieChart() {
    final List<int> calorieData = _nutritionData['calories']['daily'];
    final List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final double maxCalorie = calorieData.reduce(max).toDouble();

    return Row(
      children: [
        // Y-axis labels
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${maxCalorie.toInt()}',
              style: TextStyle(fontSize: 10, color: Colors.grey),
            ),
            Text(
              '${(maxCalorie * 0.75).toInt()}',
              style: TextStyle(fontSize: 10, color: Colors.grey),
            ),
            Text(
              '${(maxCalorie * 0.5).toInt()}',
              style: TextStyle(fontSize: 10, color: Colors.grey),
            ),
            Text(
              '${(maxCalorie * 0.25).toInt()}',
              style: TextStyle(fontSize: 10, color: Colors.grey),
            ),
            Text('0', style: TextStyle(fontSize: 10, color: Colors.grey)),
          ],
        ),
        SizedBox(width: 8),

        // Chart
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List.generate(calorieData.length, (index) {
                    final double height = calorieData[index] / maxCalorie;
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 20,
                          height: height * 160,
                          decoration: BoxDecoration(
                            color:
                                calorieData[index] >
                                        _nutritionData['calories']['goal']
                                    ? Colors.red[300]
                                    : Color(0xFF4CAF50),
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(4),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(days.length, (index) {
                  return Text(
                    days[index],
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  );
                }),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Meal rating chart widget
  Widget _buildMealRatingChart() {
    final List<String> days =
        _mealRatings.map((item) => item['day'] as String).toList();

    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              // Y-axis labels
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('5', style: TextStyle(fontSize: 10, color: Colors.grey)),
                  Text('4', style: TextStyle(fontSize: 10, color: Colors.grey)),
                  Text('3', style: TextStyle(fontSize: 10, color: Colors.grey)),
                  Text('2', style: TextStyle(fontSize: 10, color: Colors.grey)),
                  Text('1', style: TextStyle(fontSize: 10, color: Colors.grey)),
                  Text('0', style: TextStyle(fontSize: 10, color: Colors.grey)),
                ],
              ),
              SizedBox(width: 8),

              // Chart
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List.generate(_mealRatings.length, (dayIndex) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 8,
                          height: _mealRatings[dayIndex]['breakfast'] * 36.0,
                          color: Colors.green,
                        ),
                        SizedBox(width: 24),
                        Container(
                          width: 8,
                          height: _mealRatings[dayIndex]['lunch'] * 36.0,
                          color: Colors.blue,
                        ),
                        SizedBox(width: 24),
                        Container(
                          width: 8,
                          height: _mealRatings[dayIndex]['dinner'] * 36.0,
                          color: Colors.purple,
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(days.length, (index) {
            return Text(
              days[index],
              style: TextStyle(fontSize: 10, color: Colors.grey),
            );
          }),
        ),
      ],
    );
  }

  // Weight chart widget
  Widget _buildWeightChart() {
    final List<String> dates =
        _weightData.map((item) => item['date'] as String).toList();
    final List<double> weights =
        _weightData.map((item) => item['weight'] as double).toList();

    final double maxWeight = weights.reduce(max);
    final double minWeight = weights.reduce(min);
    final double range = maxWeight - minWeight;

    return Row(
      children: [
        // Y-axis labels
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${maxWeight.toStringAsFixed(1)}',
              style: TextStyle(fontSize: 10, color: Colors.grey),
            ),
            Text(
              '${(maxWeight - range / 3).toStringAsFixed(1)}',
              style: TextStyle(fontSize: 10, color: Colors.grey),
            ),
            Text(
              '${(maxWeight - 2 * range / 3).toStringAsFixed(1)}',
              style: TextStyle(fontSize: 10, color: Colors.grey),
            ),
            Text(
              '${minWeight.toStringAsFixed(1)}',
              style: TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
        SizedBox(width: 8),

        // Chart
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: CustomPaint(
                  size: Size(double.infinity, double.infinity),
                  painter: WeightChartPainter(weights, maxWeight, minWeight),
                ),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(dates.length, (index) {
                  return Text(
                    dates[index],
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  );
                }),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Custom painter for weight chart
class WeightChartPainter extends CustomPainter {
  final List<double> weights;
  final double maxWeight;
  final double minWeight;

  WeightChartPainter(this.weights, this.maxWeight, this.minWeight);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint linePaint =
        Paint()
          ..color = Color(0xFF4CAF50)
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke;

    final Paint dotPaint =
        Paint()
          ..color = Color(0xFF4CAF50)
          ..style = PaintingStyle.fill;

    final Path path = Path();

    for (int i = 0; i < weights.length; i++) {
      final double x = i * (size.width / (weights.length - 1));
      final double normalizedWeight =
          (weights[i] - minWeight) / (maxWeight - minWeight);
      final double y = size.height - (normalizedWeight * size.height);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }

      canvas.drawCircle(Offset(x, y), 4, dotPaint);
    }

    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
