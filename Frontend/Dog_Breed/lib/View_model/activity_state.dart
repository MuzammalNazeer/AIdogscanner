import 'package:flutter/material.dart';
import '../activity_model.dart';
import '../config/components/saveActivites.dart';

class ActivityState {
  final bool isLoading;
  final List<ActivityLog> activities;
  final String? error;

  const ActivityState({
    this.isLoading = false,
    this.activities = const [],
    this.error,
  });

  ActivityState copyWith({
    bool? isLoading,
    List<ActivityLog>? activities,
    String? error,
  }) {
    return ActivityState(
      isLoading: isLoading ?? this.isLoading,
      activities: activities ?? this.activities,
      error: error,
    );
  }
}
