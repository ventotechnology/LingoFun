import 'package:flutter/material.dart';
import 'exercise.dart';

class Lesson {
  final String id;
  final String title;
  final String description;
  final int xpReward;
  final IconData icon;
  final List<Exercise> exercises;

  const Lesson({
    required this.id,
    required this.title,
    required this.description,
    this.xpReward = 15,
    required this.icon,
    required this.exercises,
  });
}

class Unit {
  final String id;
  final int unitNumber;
  final String title;
  final String description;
  final Color themeColor;
  final List<Lesson> lessons;
  final String? levelTitle;
  final String? levelBadge;

  const Unit({
    required this.id,
    required this.unitNumber,
    required this.title,
    required this.description,
    required this.themeColor,
    required this.lessons,
    this.levelTitle,
    this.levelBadge,
  });
}

class Course {
  final String id;
  final String title;
  final String flag;
  final String description;
  final String ttsLocale;
  final List<Unit> units;

  const Course({
    required this.id,
    required this.title,
    required this.flag,
    required this.description,
    this.ttsLocale = 'es-ES',
    required this.units,
  });
}
