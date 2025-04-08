import 'package:flutter/material.dart';

class ResponsiveNavigationHeader extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;
  final VoidCallback onLoginTap;
  final bool isLoggedIn;

  const ResponsiveNavigationHeader({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
    required this.onLoginTap,
    this.isLoggedIn = false,
  });

  @override
  Widget build(BuildContext context) {
    // Get screen width to make responsive decisions
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Container(
      height: 70,
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 10 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: isMobile ? _buildMobileHeader(context) : _buildWebHeader(context),
    );
  }

  // Web layout with full horizontal navigation
  Widget _buildWebHeader(BuildContext context) {
    return Row(
      children: [
        // Logo section
        _buildLogo(),

        // Spacer that pushes navigation to center
        const SizedBox(width: 40),

        // Navigation tabs - centered section
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildNavItem(0, Icons.home, 'Home'),
              _buildNavItem(
                1,
                Icons.restaurant_menu,
                'Meal Plans',
                hasDropdown: true,
              ),
              _buildNavItem(2, Icons.book, 'Recipes'),
              _buildNavItem(3, Icons.analytics, 'Analytics'),
              _buildNavItem(4, Icons.schedule, 'Scheduling'),
              _buildNavItem(5, Icons.person, 'Profile', requiresAuth: true),
            ],
          ),
        ),

        // Login/Logout button - right aligned
        _buildAuthButton(),
      ],
    );
  }

  // Mobile layout with hamburger menu
  Widget _buildMobileHeader(BuildContext context) {
    return Row(
      children: [
        // Logo section
        _buildLogo(),

        // Spacer that pushes icons to right
        const Spacer(),

        // Selected page indicator text
        Text(
          _getPageName(selectedIndex),
          style: const TextStyle(
            color: Color(0xFF4CAF50),
            fontWeight: FontWeight.bold,
          ),
        ),

        const Spacer(),

        // Login/Logout button
        IconButton(
          icon: Icon(
            isLoggedIn ? Icons.logout : Icons.login,
            color: isLoggedIn ? Colors.red : Color(0xFF4CAF50),
          ),
          onPressed: onLoginTap,
        ),

        // Menu button that opens drawer
        IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            // Open drawer
            Scaffold.of(context).openEndDrawer();
          },
        ),
      ],
    );
  }

  // Common logo widget
  Widget _buildLogo() {
    return Row(
      children: [
        // Logo icon
        const Icon(Icons.spa, color: Color(0xFF4CAF50), size: 30),
        const SizedBox(width: 8),
        // App name
        RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'Nutri',
                style: TextStyle(
                  color: Color(0xFF4CAF50),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: 'Plan AI',
                style: TextStyle(
                  color: Color(0xFF2E7D32),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Navigation item
  Widget _buildNavItem(
    int index,
    IconData icon,
    String label, {
    bool hasDropdown = false,
    bool requiresAuth = false,
  }) {
    final isSelected = selectedIndex == index;
    final isDisabled = requiresAuth && !isLoggedIn;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: InkWell(
        onTap: isDisabled ? null : () => onTabSelected(index),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFE8F5E9) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color:
                    isDisabled
                        ? Colors.grey.withOpacity(0.5)
                        : (isSelected ? const Color(0xFF4CAF50) : Colors.grey),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color:
                      isDisabled
                          ? Colors.grey.withOpacity(0.5)
                          : (isSelected
                              ? const Color(0xFF4CAF50)
                              : Colors.grey[700]),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
              if (hasDropdown) ...[
                const SizedBox(width: 2),
                Icon(
                  Icons.arrow_drop_down,
                  color:
                      isDisabled
                          ? Colors.grey.withOpacity(0.5)
                          : (isSelected
                              ? const Color(0xFF4CAF50)
                              : Colors.grey),
                  size: 20,
                ),
              ],
              if (requiresAuth && !isLoggedIn) ...[
                const SizedBox(width: 4),
                Icon(Icons.lock, color: Colors.grey.withOpacity(0.7), size: 14),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // Login/Logout button
  Widget _buildAuthButton() {
    return ElevatedButton.icon(
      onPressed: onLoginTap,
      icon: Icon(isLoggedIn ? Icons.logout : Icons.login, size: 18),
      label: Text(isLoggedIn ? 'Logout' : 'Login'),
      style: ElevatedButton.styleFrom(
        backgroundColor: isLoggedIn ? Colors.red : const Color(0xFF4CAF50),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  // Helper to get page name from index
  String _getPageName(int index) {
    switch (index) {
      case 0:
        return 'Home';
      case 1:
        return 'Meal Plans';
      case 2:
        return 'Recipes';
      case 3:
        return 'Analytics';
      case 4:
        return 'Scheduling';
      case 5:
        return 'Profile';
      default:
        return 'Home';
    }
  }
}
