import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final VoidCallback onProfileSetupTap;
  final VoidCallback? onMealPlansTap;
  final VoidCallback? onRecipesTap;
  final VoidCallback? onProgressTap;

  const HomePage({
    super.key,
    required this.onProfileSetupTap,
    this.onMealPlansTap,
    this.onRecipesTap,
    this.onProgressTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    final isMediumScreen = screenWidth >= 600 && screenWidth < 900;

    return SingleChildScrollView(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Header
            _buildAppHeader(isSmallScreen),
            const SizedBox(height: 30),

            // Profile Setup Card (for new users)
            _buildProfileSetupCard(context, isSmallScreen),
            const SizedBox(height: 30),

            // Features Grid
            const Text(
              'Features',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildFeaturesGrid(context, isSmallScreen, isMediumScreen),
            const SizedBox(height: 30),

            // Nutritional Insights Section
            _buildNutritionalInsightsCard(isSmallScreen),
            const SizedBox(height: 30),

            // Recipe Recommendations
            _buildRecipeRecommendationsCard(isSmallScreen),
          ],
        ),
      ),
    );
  }

  Widget _buildAppHeader(bool isSmallScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'NutriPlan AI',
          style: TextStyle(
            fontSize: isSmallScreen ? 24 : 28,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Your personalized nutrition and meal planning assistant',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildProfileSetupCard(BuildContext context, bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.person_outline, color: Colors.green, size: 24),
              const SizedBox(width: 10),
              const Text(
                'Get Started',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 15),
          const Text(
            'Complete your profile to get personalized meal plans based on your goals, preferences, and dietary restrictions.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onProfileSetupTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Set up your profile',
                style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesGrid(
    BuildContext context,
    bool isSmallScreen,
    bool isMediumScreen,
  ) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount:
          isSmallScreen
              ? 2
              : isMediumScreen
              ? 3
              : 4,
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      childAspectRatio: isSmallScreen ? 1.1 : 1.2,
      children: [
        _buildFeatureCard(
          icon: Icons.restaurant_menu,
          title: 'AI Meal Plans',
          description: 'Personalized meal plans based on your preferences',
          onTap: onMealPlansTap ?? () {},
          color: Colors.orange,
          isSmallScreen: isSmallScreen,
        ),
        _buildFeatureCard(
          icon: Icons.food_bank,
          title: 'Recipe Engine',
          description: 'Find recipes with ingredients you have',
          onTap: onRecipesTap ?? () {},
          color: Colors.blue,
          isSmallScreen: isSmallScreen,
        ),
        _buildFeatureCard(
          icon: Icons.bar_chart,
          title: 'Progress Tracking',
          description: 'Track your nutrition and fitness goals',
          onTap: onProgressTap ?? () {},
          color: Colors.purple,
          isSmallScreen: isSmallScreen,
        ),
        _buildFeatureCard(
          icon: Icons.access_time,
          title: 'Meal Scheduling',
          description: 'Get reminders for your meals',
          onTap: () {},
          color: Colors.teal,
          isSmallScreen: isSmallScreen,
        ),
      ],
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
    required Color color,
    required bool isSmallScreen,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: EdgeInsets.all(isSmallScreen ? 12 : 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: isSmallScreen ? 28 : 32),
              const SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: isSmallScreen ? 14 : 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                description,
                style: TextStyle(
                  fontSize: isSmallScreen ? 11 : 12,
                  color: Colors.grey,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNutritionalInsightsCard(bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.pie_chart, color: Colors.blue, size: 24),
              const SizedBox(width: 10),
              const Text(
                'Nutritional Insights',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 15),
          const Text(
            'Get detailed breakdown of calories and macronutrients in real-time. Monitor your daily intake and make informed choices.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: isSmallScreen ? 10 : 20,
            runSpacing: 15,
            alignment: WrapAlignment.spaceEvenly,
            children: [
              _buildNutrientIndicator('Protein', '0g', Colors.red),
              _buildNutrientIndicator('Carbs', '0g', Colors.green),
              _buildNutrientIndicator('Fats', '0g', Colors.orange),
              if (!isSmallScreen)
                _buildNutrientIndicator('Calories', '0', Colors.purple),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecipeRecommendationsCard(bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.recommend, color: Colors.amber, size: 24),
              const SizedBox(width: 10),
              const Text(
                'Recipe Recommendations',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 15),
          const Text(
            'AI-powered recipe suggestions based on your available ingredients, preferences, and nutritional goals.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: onRecipesTap ?? () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Explore recipes', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 5),
                  Icon(Icons.arrow_forward, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutrientIndicator(String label, String value, Color color) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              value,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(color: color, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
