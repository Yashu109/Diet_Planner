import 'package:flutter/material.dart';

class RecipesPage extends StatefulWidget {
  const RecipesPage({super.key});

  @override
  State<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  String _selectedDifficulty = 'All';
  String _selectedTime = 'All';
  bool _isVegetarian = false;

  // Mock recipe data
  final List<Map<String, dynamic>> _recipes = [
    {
      'id': 1,
      'name': 'Mediterranean Quinoa Bowl',
      'image': 'quinoa_bowl.jpg',
      'time': '25 mins',
      'difficulty': 'Easy',
      'category': 'Lunch',
      'calories': 420,
      'protein': 18,
      'carbs': 52,
      'fat': 12,
      'isVegetarian': true,
      'rating': 4.7,
      'reviews': 42,
      'description':
          'A healthy Mediterranean bowl with quinoa, chickpeas, cucumbers, tomatoes, and feta cheese.',
      'ingredients': [
        '1 cup cooked quinoa',
        '1/2 cup chickpeas',
        '1/2 cucumber, diced',
        '1 tomato, diced',
        '1/4 cup feta cheese, crumbled',
        '2 tbsp olive oil',
        'Fresh lemon juice',
        'Salt and pepper to taste',
      ],
      'instructions': [
        'Cook quinoa according to package instructions and let cool.',
        'In a large bowl, combine quinoa, chickpeas, cucumber, and tomato.',
        'Drizzle with olive oil and lemon juice.',
        'Season with salt and pepper.',
        'Top with crumbled feta cheese and serve.',
      ],
    },
    {
      'id': 2,
      'name': 'Grilled Chicken with Avocado Salsa',
      'image': 'grilled_chicken.jpg',
      'time': '35 mins',
      'difficulty': 'Medium',
      'category': 'Dinner',
      'calories': 350,
      'protein': 32,
      'carbs': 12,
      'fat': 15,
      'isVegetarian': false,
      'rating': 4.9,
      'reviews': 87,
      'description':
          'Juicy grilled chicken breast topped with fresh avocado salsa.',
      'ingredients': [
        '2 chicken breasts',
        '1 ripe avocado, diced',
        '1/2 red onion, finely chopped',
        '1 tomato, diced',
        '1 jalapeño, seeded and minced',
        'Fresh cilantro, chopped',
        'Lime juice',
        'Olive oil',
        'Salt and pepper',
      ],
      'instructions': [
        'Season chicken breasts with salt, pepper, and olive oil.',
        'Grill chicken for 6-7 minutes per side until internal temperature reaches 165°F.',
        'In a bowl, combine avocado, red onion, tomato, jalapeño, and cilantro.',
        'Add lime juice, salt, and pepper to taste.',
        'Let chicken rest for 5 minutes, then top with avocado salsa.',
      ],
    },
    {
      'id': 3,
      'name': 'Berry Protein Smoothie Bowl',
      'image': 'smoothie_bowl.jpg',
      'time': '10 mins',
      'difficulty': 'Easy',
      'category': 'Breakfast',
      'calories': 280,
      'protein': 24,
      'carbs': 38,
      'fat': 5,
      'isVegetarian': true,
      'rating': 4.5,
      'reviews': 31,
      'description':
          'A nutritious protein-packed smoothie bowl topped with fresh berries and granola.',
      'ingredients': [
        '1 scoop protein powder',
        '1/2 frozen banana',
        '1 cup mixed frozen berries',
        '1/4 cup Greek yogurt',
        '1/4 cup almond milk',
        'Toppings: fresh berries, granola, chia seeds',
      ],
      'instructions': [
        'Blend protein powder, frozen banana, frozen berries, Greek yogurt, and almond milk until smooth.',
        'Pour into a bowl.',
        'Top with fresh berries, granola, and chia seeds.',
      ],
    },
    {
      'id': 4,
      'name': 'Baked Salmon with Roasted Vegetables',
      'image': 'baked_salmon.jpg',
      'time': '40 mins',
      'difficulty': 'Medium',
      'category': 'Dinner',
      'calories': 380,
      'protein': 35,
      'carbs': 18,
      'fat': 16,
      'isVegetarian': false,
      'rating': 4.8,
      'reviews': 64,
      'description':
          'Oven-baked salmon fillet with a medley of roasted seasonal vegetables.',
      'ingredients': [
        '1 salmon fillet (6 oz)',
        '1 cup Brussels sprouts, halved',
        '1 cup sweet potato, cubed',
        '1 red bell pepper, sliced',
        '2 tbsp olive oil',
        'Fresh dill',
        'Lemon',
        'Salt and pepper',
      ],
      'instructions': [
        'Preheat oven to 400°F.',
        'Toss vegetables in olive oil, salt, and pepper. Spread on baking sheet.',
        'Roast vegetables for 15 minutes.',
        'Add salmon to the sheet, skin-side down. Season with salt, pepper, and dill.',
        'Bake for another 12-15 minutes until salmon is cooked through.',
        'Squeeze fresh lemon juice over before serving.',
      ],
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 900;

    return Scaffold(
      body: Column(
        children: [
          // Search and filter area
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                // Search bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search recipes, ingredients, cuisines...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    fillColor: Colors.grey[200],
                    filled: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 0),
                  ),
                ),
                SizedBox(height: 16),

                // Filter row
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // Category filter
                      _buildFilterChip(
                        label: 'Category: $_selectedCategory',
                        icon: Icons.restaurant_menu,
                        onTap: () {
                          _showFilterDialog(
                            title: 'Select Category',
                            options: [
                              'All',
                              'Breakfast',
                              'Lunch',
                              'Dinner',
                              'Snacks',
                              'Desserts',
                            ],
                            selectedValue: _selectedCategory,
                            onSelect: (value) {
                              setState(() {
                                _selectedCategory = value;
                              });
                            },
                          );
                        },
                      ),
                      SizedBox(width: 8),

                      // Difficulty filter
                      _buildFilterChip(
                        label: 'Difficulty: $_selectedDifficulty',
                        icon: Icons.trending_up,
                        onTap: () {
                          _showFilterDialog(
                            title: 'Select Difficulty',
                            options: ['All', 'Easy', 'Medium', 'Hard'],
                            selectedValue: _selectedDifficulty,
                            onSelect: (value) {
                              setState(() {
                                _selectedDifficulty = value;
                              });
                            },
                          );
                        },
                      ),
                      SizedBox(width: 8),

                      // Time filter
                      _buildFilterChip(
                        label: 'Time: $_selectedTime',
                        icon: Icons.access_time,
                        onTap: () {
                          _showFilterDialog(
                            title: 'Select Time',
                            options: [
                              'All',
                              'Under 15 mins',
                              'Under 30 mins',
                              'Under 45 mins',
                              'Under 60 mins',
                            ],
                            selectedValue: _selectedTime,
                            onSelect: (value) {
                              setState(() {
                                _selectedTime = value;
                              });
                            },
                          );
                        },
                      ),
                      SizedBox(width: 8),

                      // Vegetarian filter
                      FilterChip(
                        label: Text('Vegetarian'),
                        selected: _isVegetarian,
                        onSelected: (selected) {
                          setState(() {
                            _isVegetarian = selected;
                          });
                        },
                        selectedColor: Color(0xFFE8F5E9),
                        checkmarkColor: Color(0xFF4CAF50),
                        avatar: Icon(
                          Icons.eco,
                          color:
                              _isVegetarian ? Color(0xFF4CAF50) : Colors.grey,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Recipe grid
          Expanded(
            child:
                isMobile
                    ? _buildRecipeListView()
                    : _buildRecipeGridView(isTablet),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAIRecipeModal(context);
        },
        backgroundColor: Color(0xFF4CAF50),
        child: Icon(Icons.auto_awesome),
        tooltip: 'Generate AI Recipe',
      ),
    );
  }

  // Filter chip widget
  Widget _buildFilterChip({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: Color(0xFF4CAF50)),
            SizedBox(width: 4),
            Text(label),
          ],
        ),
      ),
    );
  }

  // Show filter dialog
  void _showFilterDialog({
    required String title,
    required List<String> options,
    required String selectedValue,
    required Function(String) onSelect,
  }) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(title),
            content: SizedBox(
              width: double.minPositive,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (context, index) {
                  return RadioListTile<String>(
                    title: Text(options[index]),
                    value: options[index],
                    groupValue: selectedValue,
                    activeColor: Color(0xFF4CAF50),
                    onChanged: (value) {
                      onSelect(value!);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
            ],
          ),
    );
  }

  // Recipe list view for mobile
  Widget _buildRecipeListView() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: _recipes.length,
      itemBuilder: (context, index) {
        final recipe = _recipes[index];
        return Card(
          margin: EdgeInsets.only(bottom: 16),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: () => _showRecipeDetails(recipe),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Recipe image
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.restaurant,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                ),

                // Recipe info
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (recipe['isVegetarian'])
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xFFE8F5E9),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.eco,
                                    size: 12,
                                    color: Color(0xFF4CAF50),
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'Vegetarian',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF4CAF50),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          Spacer(),
                          Row(
                            children: [
                              Icon(Icons.star, size: 16, color: Colors.amber),
                              SizedBox(width: 4),
                              Text(
                                recipe['rating'].toString(),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: 4),
                              Text(
                                '(${recipe['reviews']})',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        recipe['name'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        recipe['description'],
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 12),
                      Wrap(
                        spacing: 12,
                        children: [
                          _buildInfoChip(Icons.access_time, recipe['time']),
                          _buildInfoChip(
                            Icons.trending_up,
                            recipe['difficulty'],
                          ),
                          _buildInfoChip(
                            Icons.local_fire_department,
                            '${recipe['calories']} cal',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Recipe grid view for tablet/desktop
  Widget _buildRecipeGridView(bool isTablet) {
    return GridView.builder(
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isTablet ? 2 : 3,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _recipes.length,
      itemBuilder: (context, index) {
        final recipe = _recipes[index];
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: () => _showRecipeDetails(recipe),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Recipe image
                Expanded(
                  flex: 5,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.restaurant,
                        size: 48,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                // Recipe info
                Expanded(
                  flex: 6,
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            if (recipe['isVegetarian'])
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Color(0xFFE8F5E9),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.eco,
                                      size: 10,
                                      color: Color(0xFF4CAF50),
                                    ),
                                    SizedBox(width: 2),
                                    Text(
                                      'Veg',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Color(0xFF4CAF50),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            Spacer(),
                            Row(
                              children: [
                                Icon(Icons.star, size: 14, color: Colors.amber),
                                SizedBox(width: 2),
                                Text(
                                  recipe['rating'].toString(),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          recipe['name'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                        Expanded(
                          child: Text(
                            recipe['description'],
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildInfoChip(
                              Icons.access_time,
                              recipe['time'],
                              small: true,
                            ),
                            _buildInfoChip(
                              Icons.local_fire_department,
                              '${recipe['calories']} cal',
                              small: true,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Info chip helper widget
  Widget _buildInfoChip(IconData icon, String label, {bool small = false}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: small ? 14 : 16, color: Colors.grey[600]),
        SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(fontSize: small ? 12 : 14, color: Colors.grey[600]),
        ),
      ],
    );
  }

  // Method to show recipe details
  void _showRecipeDetails(Map<String, dynamic> recipe) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Recipe image header
                  Stack(
                    children: [
                      Container(
                        height: 250,
                        width: double.infinity,
                        color: Colors.grey[300],
                        child: Center(
                          child: Icon(
                            Icons.restaurant,
                            size: 64,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 16,
                        right: 16,
                        child: IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                          color: Colors.white,
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.black54,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 16,
                        right: 16,
                        child: Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.bookmark_border),
                              onPressed: () {},
                              color: Colors.white,
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.black54,
                              ),
                            ),
                            SizedBox(width: 8),
                            IconButton(
                              icon: Icon(Icons.share),
                              onPressed: () {},
                              color: Colors.white,
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Recipe details
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Recipe title and rating
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    recipe['name'],
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    recipe['category'],
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      size: 24,
                                      color: Colors.amber,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      recipe['rating'].toString(),
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  '${recipe['reviews']} reviews',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 16),

                        // Recipe badges
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _buildBadge(
                              icon: Icons.access_time,
                              label: recipe['time'],
                              color: Colors.blue,
                            ),
                            _buildBadge(
                              icon: Icons.trending_up,
                              label: recipe['difficulty'],
                              color: Colors.orange,
                            ),
                            _buildBadge(
                              icon: Icons.local_fire_department,
                              label: '${recipe['calories']} cal',
                              color: Colors.red,
                            ),
                            if (recipe['isVegetarian'])
                              _buildBadge(
                                icon: Icons.eco,
                                label: 'Vegetarian',
                                color: Colors.green,
                              ),
                          ],
                        ),
                        SizedBox(height: 16),

                        // Nutrition information
                        Card(
                          elevation: 0,
                          color: Colors.grey[100],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Nutrition Information',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    _buildNutritionItem(
                                      'Calories',
                                      '${recipe['calories']}',
                                      'cal',
                                    ),
                                    _buildNutritionItem(
                                      'Protein',
                                      '${recipe['protein']}',
                                      'g',
                                    ),
                                    _buildNutritionItem(
                                      'Carbs',
                                      '${recipe['carbs']}',
                                      'g',
                                    ),
                                    _buildNutritionItem(
                                      'Fat',
                                      '${recipe['fat']}',
                                      'g',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 24),

                        // Description
                        Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          recipe['description'],
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[800],
                          ),
                        ),
                        SizedBox(height: 24),

                        // Ingredients
                        Text(
                          'Ingredients',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 12),
                        ...List.generate(
                          recipe['ingredients'].length,
                          (index) => Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.fiber_manual_record,
                                  size: 12,
                                  color: Color(0xFF4CAF50),
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    recipe['ingredients'][index],
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 24),

                        // Instructions
                        Text(
                          'Instructions',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 12),
                        ...List.generate(
                          recipe['instructions'].length,
                          (index) => Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 24,
                                  height: 24,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF4CAF50),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    '${index + 1}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    recipe['instructions'][index],
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 32),

                        // Action buttons
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {},
                                icon: Icon(Icons.shopping_cart),
                                label: Text('Add to Shopping List'),
                                style: OutlinedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  foregroundColor: Color(0xFF4CAF50),
                                  side: BorderSide(color: Color(0xFF4CAF50)),
                                ),
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {},
                                icon: Icon(Icons.add),
                                label: Text('Add to Meal Plan'),
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Badge widget for recipe details
  Widget _buildBadge({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(color: color, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  // Nutrition item widget
  Widget _buildNutritionItem(String label, String value, String unit) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4CAF50),
          ),
        ),
        Text(unit, style: TextStyle(fontSize: 14, color: Colors.grey)),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  // Show AI recipe generator modal
  void _showAIRecipeModal(BuildContext context) {
    final TextEditingController ingredientsController = TextEditingController();
    bool isGenerating = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Row(
                children: [
                  Icon(Icons.auto_awesome, color: Color(0xFF4CAF50)),
                  SizedBox(width: 8),
                  Text('AI Recipe Generator'),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Enter ingredients you have on hand, and our AI will generate a custom recipe for you.',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: ingredientsController,
                      decoration: InputDecoration(
                        labelText: 'Ingredients',
                        hintText: 'e.g. chicken, spinach, tomatoes',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Dietary Preferences',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        ChoiceChip(
                          label: Text('Any'),
                          selected: true,
                          selectedColor: Color(0xFFE8F5E9),
                          labelStyle: TextStyle(color: Color(0xFF4CAF50)),
                        ),
                        ChoiceChip(label: Text('Vegetarian'), selected: false),
                        ChoiceChip(label: Text('Vegan'), selected: false),
                        ChoiceChip(label: Text('Gluten-Free'), selected: false),
                      ],
                    ),
                    SizedBox(height: 16),
                    isGenerating
                        ? Center(
                          child: Column(
                            children: [
                              CircularProgressIndicator(
                                color: Color(0xFF4CAF50),
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Creating your recipe...',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ],
                          ),
                        )
                        : Container(),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed:
                      isGenerating
                          ? null
                          : () {
                            setState(() {
                              isGenerating = true;
                            });

                            // Simulate AI generation
                            Future.delayed(Duration(seconds: 3), () {
                              Navigator.pop(context);

                              // Show success snackbar
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Recipe created successfully!'),
                                  backgroundColor: Color(0xFF4CAF50),
                                ),
                              );
                            });
                          },
                  child: Text('Generate Recipe'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
