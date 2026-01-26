enum ActivityCategory {
  focus,
  study,
  gym,
  reading,
  diy,
  meditate,
  plan,
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
      case ActivityCategory.diy:
        return 'DIY';
      case ActivityCategory.meditate:
        return 'Meditate';
      case ActivityCategory.plan:
        return 'Plan';
    }
  }

  String get value => name; // for DB
}

