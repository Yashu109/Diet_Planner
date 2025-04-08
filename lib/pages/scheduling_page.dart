import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_survices.dart';

class SchedulingPage extends StatefulWidget {
  final VoidCallback onLoginTap;

  const SchedulingPage({super.key, required this.onLoginTap});

  @override
  State<SchedulingPage> createState() => _SchedulingPageState();
}

class _SchedulingPageState extends State<SchedulingPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime _selectedDate = DateTime.now();
  int _selectedDay = DateTime.now().day;
  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;
  TimeOfDay _selectedTime = TimeOfDay.now();
  String _selectedMealType = 'Breakfast';
  String _selectedRepeat = 'Once';
  bool _notificationsEnabled = true;

  // Meal types for scheduling
  final List<String> _mealTypes = [
    'Breakfast',
    'Morning Snack',
    'Lunch',
    'Afternoon Snack',
    'Dinner',
    'Evening Snack',
  ];

  // Repeat options
  final List<String> _repeatOptions = [
    'Once',
    'Daily',
    'Weekdays',
    'Weekends',
    'Weekly',
    'Monthly',
  ];

  // Notification time options
  final List<String> _reminderTimeOptions = [
    '5 minutes before',
    '15 minutes before',
    '30 minutes before',
    '1 hour before',
    'At meal time',
  ];

  // Mock scheduled meals
  final List<Map<String, dynamic>> _scheduledMeals = [
    {
      'id': 1,
      'mealType': 'Breakfast',
      'mealName': 'Greek Yogurt with Berries',
      'date': '2025-04-07',
      'time': '08:00',
      'repeat': 'Weekdays',
      'notification': true,
      'reminderTime': '15 minutes before',
    },
    {
      'id': 2,
      'mealType': 'Lunch',
      'mealName': 'Grilled Chicken Salad',
      'date': '2025-04-07',
      'time': '12:30',
      'repeat': 'Weekdays',
      'notification': true,
      'reminderTime': '30 minutes before',
    },
    {
      'id': 3,
      'mealType': 'Dinner',
      'mealName': 'Baked Salmon with Vegetables',
      'date': '2025-04-07',
      'time': '19:00',
      'repeat': 'Daily',
      'notification': true,
      'reminderTime': '1 hour before',
    },
    {
      'id': 4,
      'mealType': 'Morning Snack',
      'mealName': 'Apple with Almond Butter',
      'date': '2025-04-07',
      'time': '10:30',
      'repeat': 'Weekdays',
      'notification': false,
      'reminderTime': 'At meal time',
    },
    {
      'id': 5,
      'mealType': 'Breakfast',
      'mealName': 'Oatmeal with Honey',
      'date': '2025-04-08',
      'time': '08:00',
      'repeat': 'Once',
      'notification': true,
      'reminderTime': '15 minutes before',
    },
    {
      'id': 6,
      'mealType': 'Lunch',
      'mealName': 'Turkey Sandwich',
      'date': '2025-04-08',
      'time': '12:30',
      'repeat': 'Once',
      'notification': true,
      'reminderTime': '30 minutes before',
    },
  ];

  // Mock meal suggestions for autocomplete
  final List<String> _mealSuggestions = [
    'Greek Yogurt with Berries',
    'Oatmeal with Honey',
    'Scrambled Eggs with Avocado Toast',
    'Protein Smoothie',
    'Grilled Chicken Salad',
    'Turkey Sandwich',
    'Tuna Wrap',
    'Lentil Soup',
    'Baked Salmon with Vegetables',
    'Stir-Fried Tofu with Rice',
    'Pasta with Tomato Sauce',
    'Steak with Sweet Potato',
    'Apple with Almond Butter',
    'Protein Bar',
    'Hummus with Carrot Sticks',
    'Greek Yogurt with Nuts',
  ];

  // Text controller for meal name
  final TextEditingController _mealNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _mealNameController.dispose();
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
                  // Tab bar for scheduling views
                  Container(
                    color: Colors.white,
                    child: TabBar(
                      controller: _tabController,
                      labelColor: const Color(0xFF4CAF50),
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: const Color(0xFF4CAF50),
                      tabs: const [
                        Tab(
                          text: 'Calendar View',
                          icon: Icon(Icons.calendar_today),
                        ),
                        Tab(text: 'Schedule Meal', icon: Icon(Icons.add_alert)),
                      ],
                    ),
                  ),

                  // Tab bar view content
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // Calendar view tab
                        _buildCalendarView(isMobile),

                        // Schedule meal tab
                        _buildScheduleMealForm(isMobile),
                      ],
                    ),
                  ),
                ],
              )
              : _buildLoginPrompt(),
    );
  }

  // Calendar view with scheduled meals
  Widget _buildCalendarView(bool isMobile) {
    final now = DateTime.now();
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final firstDayOfMonth = DateTime(now.year, now.month, 1).weekday;
    final currentDate = DateTime(now.year, now.month, now.day);

    // Get meals for the selected date
    final selectedDateString = _getFormattedDate(
      DateTime(_selectedYear, _selectedMonth, _selectedDay),
    );
    final mealsForSelectedDate =
        _scheduledMeals
            .where((meal) => meal['date'] == selectedDateString)
            .toList();

    return Column(
      children: [
        // Month selector and calendar
        Card(
          margin: EdgeInsets.all(16),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                // Month selector
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: () {
                        // Navigate to previous month
                      },
                    ),
                    Text(
                      '${_getMonthName(now.month)} ${now.year}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: () {
                        // Navigate to next month
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Weekday headers
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    Text('M', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('T', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('W', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('T', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('F', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('S', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('S', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 8),

                // Calendar grid
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    childAspectRatio: 1,
                  ),
                  itemCount: firstDayOfMonth - 1 + daysInMonth,
                  itemBuilder: (context, index) {
                    if (index < firstDayOfMonth - 1) {
                      // Empty cells before the first day of month
                      return Container();
                    }

                    final day = index - (firstDayOfMonth - 2);
                    final date = DateTime(now.year, now.month, day);
                    final isSelected =
                        _selectedDay == day &&
                        _selectedMonth == now.month &&
                        _selectedYear == now.year;
                    final isToday =
                        date.year == currentDate.year &&
                        date.month == currentDate.month &&
                        date.day == currentDate.day;

                    // Check if day has scheduled meals
                    final dateString = _getFormattedDate(date);
                    final hasMeals = _scheduledMeals.any(
                      (meal) => meal['date'] == dateString,
                    );

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedDay = day;
                          _selectedMonth = now.month;
                          _selectedYear = now.year;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color:
                              isSelected
                                  ? const Color(0xFF4CAF50)
                                  : isToday
                                  ? const Color(0xFFE8F5E9)
                                  : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color:
                                isToday && !isSelected
                                    ? const Color(0xFF4CAF50)
                                    : Colors.transparent,
                          ),
                        ),
                        child: Stack(
                          children: [
                            Center(
                              child: Text(
                                day.toString(),
                                style: TextStyle(
                                  color:
                                      isSelected
                                          ? Colors.white
                                          : isToday
                                          ? const Color(0xFF4CAF50)
                                          : Colors.black87,
                                  fontWeight:
                                      isSelected || isToday
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                ),
                              ),
                            ),
                            if (hasMeals)
                              Positioned(
                                bottom: 4,
                                right: 0,
                                left: 0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 6,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color:
                                            isSelected
                                                ? Colors.white
                                                : const Color(0xFF4CAF50),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),

        // Date indicator
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Text(
                '${_getDayOfWeek(DateTime(_selectedYear, _selectedMonth, _selectedDay).weekday)}, ${_getMonthName(_selectedMonth)} $_selectedDay',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4CAF50),
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () {
                  // Switch to schedule meal tab and pre-fill the date
                  _tabController.animateTo(1);
                },
                icon: const Icon(Icons.add),
                label: const Text('Add Meal'),
              ),
            ],
          ),
        ),

        // Scheduled meals for selected date
        Expanded(
          child:
              mealsForSelectedDate.isEmpty
                  ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.event_busy,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No meals scheduled for this day',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () {
                            _tabController.animateTo(1);
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Schedule a Meal'),
                        ),
                      ],
                    ),
                  )
                  : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: mealsForSelectedDate.length,
                    itemBuilder: (context, index) {
                      final meal = mealsForSelectedDate[index];
                      return _buildScheduledMealCard(meal, isMobile);
                    },
                  ),
        ),
      ],
    );
  }

  // Schedule meal form
  Widget _buildScheduleMealForm(bool isMobile) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Form title
          const Text(
            'Schedule a Meal',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4CAF50),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Set up meal times and get reminders',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 24),

          // Meal type selector
          const Text(
            'Meal Type',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                _mealTypes.map((type) {
                  return ChoiceChip(
                    label: Text(type),
                    selected: _selectedMealType == type,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedMealType = type;
                        });
                      }
                    },
                    selectedColor: const Color(0xFFE8F5E9),
                    labelStyle: TextStyle(
                      color:
                          _selectedMealType == type
                              ? const Color(0xFF4CAF50)
                              : Colors.black87,
                    ),
                  );
                }).toList(),
          ),
          const SizedBox(height: 24),

          // Meal name input with autocomplete
          const Text(
            'Meal Name',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Autocomplete<String>(
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text.isEmpty) {
                return const Iterable<String>.empty();
              }
              return _mealSuggestions.where((meal) {
                return meal.toLowerCase().contains(
                  textEditingValue.text.toLowerCase(),
                );
              });
            },
            onSelected: (String selection) {
              _mealNameController.text = selection;
            },
            fieldViewBuilder: (
              BuildContext context,
              TextEditingController controller,
              FocusNode focusNode,
              VoidCallback onFieldSubmitted,
            ) {
              _mealNameController.text = controller.text;
              return TextFormField(
                controller: controller,
                focusNode: focusNode,
                decoration: InputDecoration(
                  hintText: 'Enter meal name or select from your recipes',
                  prefixIcon: const Icon(Icons.restaurant_menu),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {},
                    tooltip: 'Browse your recipes',
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),

          // Date and time selectors
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Date',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(
                            const Duration(days: 365),
                          ),
                        );
                        if (picked != null && picked != _selectedDate) {
                          setState(() {
                            _selectedDate = picked;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 15,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Time',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () async {
                        final TimeOfDay? picked = await showTimePicker(
                          context: context,
                          initialTime: _selectedTime,
                        );
                        if (picked != null && picked != _selectedTime) {
                          setState(() {
                            _selectedTime = picked;
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 15,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.access_time, color: Colors.grey),
                            const SizedBox(width: 8),
                            Text(
                              '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Repeat options
          const Text(
            'Repeat',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                _repeatOptions.map((option) {
                  return ChoiceChip(
                    label: Text(option),
                    selected: _selectedRepeat == option,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedRepeat = option;
                        });
                      }
                    },
                    selectedColor: const Color(0xFFE8F5E9),
                    labelStyle: TextStyle(
                      color:
                          _selectedRepeat == option
                              ? const Color(0xFF4CAF50)
                              : Colors.black87,
                    ),
                  );
                }).toList(),
          ),
          const SizedBox(height: 24),

          // Notification settings
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Notifications',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SwitchListTile(
                      title: const Text('Enable reminders'),
                      value: _notificationsEnabled,
                      onChanged: (value) {
                        setState(() {
                          _notificationsEnabled = value;
                        });
                      },
                      activeColor: const Color(0xFF4CAF50),
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Reminder time options (visible only if notifications are enabled)
          if (_notificationsEnabled) ...[
            const SizedBox(height: 16),
            const Text(
              'Remind me',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  _reminderTimeOptions.map((option) {
                    return ChoiceChip(
                      label: Text(option),
                      selected:
                          option ==
                          _reminderTimeOptions[1], // Default to 15 mins
                      onSelected: (selected) {
                        // Set reminder time
                      },
                      selectedColor: const Color(0xFFE8F5E9),
                      labelStyle: TextStyle(
                        color:
                            option == _reminderTimeOptions[1]
                                ? const Color(0xFF4CAF50)
                                : Colors.black87,
                      ),
                    );
                  }).toList(),
            ),
          ],

          const SizedBox(height: 32),

          // Submit button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                // Validate and save the scheduled meal
                final snackBar = SnackBar(
                  content: const Text('Meal scheduled successfully!'),
                  backgroundColor: const Color(0xFF4CAF50),
                  action: SnackBarAction(
                    label: 'View',
                    textColor: Colors.white,
                    onPressed: () {
                      _tabController.animateTo(0); // Switch to calendar view
                    },
                  ),
                );

                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                _tabController.animateTo(0); // Switch to calendar view
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Schedule Meal'),
            ),
          ),
        ],
      ),
    );
  }

  // Scheduled meal card
  Widget _buildScheduledMealCard(Map<String, dynamic> meal, bool isMobile) {
    final timeStr = meal['time'];
    final repeatStr = meal['repeat'];
    final bool hasNotification = meal['notification'];

    // Parse hour and minute from time string "HH:MM"
    final timeParts = timeStr.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);

    // Format time to 12-hour format with AM/PM
    final formattedHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    final amPm = hour >= 12 ? 'PM' : 'AM';
    final formattedTime =
        '$formattedHour:${minute.toString().padLeft(2, '0')} $amPm';

    // Get color based on meal type
    Color mealColor;
    switch (meal['mealType']) {
      case 'Breakfast':
        mealColor = Colors.orange;
        break;
      case 'Lunch':
        mealColor = Colors.blue;
        break;
      case 'Dinner':
        mealColor = Colors.purple;
        break;
      case 'Morning Snack':
      case 'Afternoon Snack':
      case 'Evening Snack':
        mealColor = Colors.teal;
        break;
      default:
        mealColor = const Color(0xFF4CAF50);
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          // Show meal details or edit options
          _showMealDetailsDialog(meal);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Time indicator
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: mealColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      formattedHour.toString(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: mealColor,
                      ),
                    ),
                    Text(
                      '${minute.toString().padLeft(2, '0')} $amPm',
                      style: TextStyle(fontSize: 12, color: mealColor),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),

              // Meal info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: mealColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            meal['mealType'],
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: mealColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (repeatStr != 'Once')
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              repeatStr,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      meal['mealName'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        if (hasNotification) ...[
                          const Icon(
                            Icons.notifications_active,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            meal['reminderTime'],
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              // Actions
              Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      // Edit meal schedule
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      // Delete meal schedule
                      _showDeleteConfirmDialog(meal);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Show meal details dialog
  void _showMealDetailsDialog(Map<String, dynamic> meal) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            meal['mealName'],
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF4CAF50),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Meal Type', meal['mealType']),
              const SizedBox(height: 8),
              _buildDetailRow('Date', meal['date']),
              const SizedBox(height: 8),
              _buildDetailRow('Time', meal['time']),
              const SizedBox(height: 8),
              _buildDetailRow('Repeat', meal['repeat']),
              const SizedBox(height: 8),
              _buildDetailRow(
                'Notification',
                meal['notification'] ? meal['reminderTime'] : 'Disabled',
              ),
              const SizedBox(height: 16),
              const Text(
                'Note: This is a scheduled meal reminder. View the Recipes section to see detailed recipe information.',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                // Navigate to recipe details
              },
              icon: const Icon(Icons.restaurant_menu),
              label: const Text('View Recipe'),
            ),
          ],
        );
      },
    );
  }

  // Show delete confirmation dialog
  void _showDeleteConfirmDialog(Map<String, dynamic> meal) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Scheduled Meal'),
          content: Text(
            'Are you sure you want to delete "${meal['mealName']}" scheduled for ${meal['time']}?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Delete the meal and update UI
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Meal schedule deleted'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  // Helper method to build detail rows in dialog
  Widget _buildDetailRow(String label, String value) {
    return Row(
      children: [
        Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(value),
      ],
    );
  }

  // Widget shown when user is not logged in
  Widget _buildLoginPrompt() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.lock, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'You need to login to access scheduling',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: widget.onLoginTap,
            child: const Text('Login Now'),
          ),
        ],
      ),
    );
  }

  // Helper methods for date formatting
  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return '';
    }
  }

  String _getDayOfWeek(int day) {
    switch (day) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return '';
    }
  }

  String _getFormattedDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
