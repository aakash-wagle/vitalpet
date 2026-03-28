/// Milestone types awarded for streak achievements.
enum MilestoneType { week, twoWeeks, month, quarter }

/// Returns the milestone earned at [streak] days, or null.
/// Pure function.
MilestoneType? detectMilestone(int streak) {
  return switch (streak) {
    7 => MilestoneType.week,
    14 => MilestoneType.twoWeeks,
    30 => MilestoneType.month,
    90 => MilestoneType.quarter,
    _ => null,
  };
}
