enum ActivityCategory {
  focus,
  study,
  gym,
  reading,
}

extension ActivityCategoryX on ActivityCategory {
  String get label {
    switch (this) {
      case ActivityCategory.focus:
        return 'Focus';
      case ActivityCategory.study:
        return 'Study';
      case ActivityCategory.gym:
        return 'Gym';
      case ActivityCategory.reading:
        return 'Reading';
    }
  }

  String get value => name; // for DB
}
