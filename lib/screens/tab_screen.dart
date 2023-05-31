import 'package:flutter/material.dart';
import 'package:meals/model/meal.dart';
import 'package:meals/screens/categories_screen.dart';
import 'package:meals/screens/meals_screen.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({super.key});
  @override
  State<TabScreen> createState() {
    return _TabScreenState();
  }
}

class _TabScreenState extends State<TabScreen> {
  int _selectedTabIndex = 0;
  final List<Meal> _favouriteMeals = [];

  void _showInfoMessage(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
        ),
      ),
    );
  }

  void _markMealAsFavourite(Meal meal) {
    final isNotContain = !_favouriteMeals.contains(meal);
    setState(() {
      if (isNotContain) {
        _favouriteMeals.add(meal);
        _showInfoMessage('${meal.title} is marked as favourite!');
      } else {
        _favouriteMeals.remove(meal);
        _showInfoMessage('${meal.title} is no longer marked as favourite!');
      }
    });
  }

  void _selectTab(int index) {
    if (_selectedTabIndex != index) {
      setState(() {
        _selectedTabIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget activeScreen = CategoriesScreen(
      onMarkAsFavourite: () => _markMealAsFavourite,
    );
    var activeScreenTitle = "Categories";
    if (_selectedTabIndex == 1) {
      activeScreenTitle = "Your Favourites";
      activeScreen = MealScreen(
        meals: _favouriteMeals,
        onMarkAsFavourite: () => _markMealAsFavourite,
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(activeScreenTitle),
      ),
      body: activeScreen,
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) => _selectTab(index),
        currentIndex: _selectedTabIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.set_meal,
            ),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.star,
            ),
            label: 'Favourites',
          ),
        ],
      ),
    );
  }
}
