import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:meals/data/dummy_data.dart';
import 'package:meals/model/meal.dart';
import 'package:meals/screens/categories_screen.dart';
import 'package:meals/screens/filters.dart';
import 'package:meals/screens/meals_screen.dart';
import 'package:meals/widgets/main_drawer.dart';

const kFilterValues = {
  Filter.gluttenFree: false,
  Filter.lactoseFree: false,
  Filter.vegetarian: false,
  Filter.vegan: false,
};

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
  Map<Filter, bool> _selectedFilters = kFilterValues;

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

  void _setScreen(String identifier) async {
    Navigator.of(context).pop();
    if (identifier == 'filter') {
      final result = await Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(
          builder: (ctx) => FilterScreen(
            currentFilters: _selectedFilters,
          ),
        ),
      );
      setState(() {
        _selectedFilters = result ?? kFilterValues;
      });
    }
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
    final availableMeals = dummyMeals.where((meal) {
      if (_selectedFilters[Filter.gluttenFree]! && !meal.isGlutenFree) {
        return false;
      }
      if (_selectedFilters[Filter.lactoseFree]! && !meal.isLactoseFree) {
        return false;
      }
      if (_selectedFilters[Filter.vegetarian]! && !meal.isVegetarian) {
        return false;
      }
      if (_selectedFilters[Filter.vegan]! && !meal.isVegan) {
        return false;
      }
      return true;
    }).toList();

    Widget activeScreen = CategoriesScreen(
      onMarkAsFavourite: () => _markMealAsFavourite,
      availableMeals: availableMeals,
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
      drawer: MainDrawer(
        onSelectScreen: _setScreen,
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
