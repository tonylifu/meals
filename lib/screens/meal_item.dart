import 'package:flutter/material.dart';
import 'package:meals/model/meal.dart';

class MealItem extends StatelessWidget {
  final Meal meal;
  const MealItem({
    super.key,
    required this.meal,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {},
        child: Stack(
          children: [],
        ),
      ),
    );
  }
}
