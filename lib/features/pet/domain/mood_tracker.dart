import 'dart:math';

import 'package:vitalpet/features/check_in/data/check_in_dao.dart';

/// Mood trend detected from recent check-ins.
enum MoodTrend {
  improvingFromBad, // was negative, now positive — "proud of you"
  decliningFromGood, // was positive, now negative — "supportive"
  consistentlyGood,
  consistentlyBad,
  neutral, // not enough data or mixed
}

/// Result of mood analysis.
class MoodAnalysis {
  const MoodAnalysis({
    required this.trend,
    required this.recentCheckins,
    required this.phrase,
    required this.subPhrase,
  });

  final MoodTrend trend;
  final List<MoodPoint> recentCheckins;
  final String phrase;
  final String subPhrase;
}

/// A lightweight point used by the home timeline.
class MoodPoint {
  const MoodPoint({required this.status, required this.daysAgo});

  final String status;
  final int daysAgo;
}

/// Analyzes mood from the last 2-3 days of check-ins and selects phrases.
class MoodTracker {
  const MoodTracker();

  /// Analyze recent check-ins to determine mood trend.
  Future<MoodAnalysis> analyze(CheckInDao checkInDao) async {
    final recent = await checkInDao.findLatest(3);

    if (recent.isEmpty) {
      return MoodAnalysis(
        trend: MoodTrend.neutral,
        recentCheckins: const [],
        phrase: _pickRandom(_welcomePhrases),
        subPhrase: _pickRandom(_welcomeSubPhrases),
      );
    }

    final today = DateTime.now().toUtc();
    final todayUtc = DateTime.utc(today.year, today.month, today.day);
    final points = recent.map((c) {
      final parsedDate = DateTime.tryParse(c.utcDate)?.toUtc();
      final day = parsedDate != null
          ? DateTime.utc(parsedDate.year, parsedDate.month, parsedDate.day)
          : todayUtc;
      final daysAgo = todayUtc.difference(day).inDays.clamp(0, 1000000);
      return MoodPoint(status: c.overallStatus, daysAgo: daysAgo);
    }).toList();

    final statuses = points.map((p) => p.status).toList();

    final trend = _detectTrend(statuses);

    final phrases = switch (trend) {
      MoodTrend.improvingFromBad => _proudPhrases,
      MoodTrend.decliningFromGood => _supportivePhrases,
      MoodTrend.consistentlyGood => _celebratePhrases,
      MoodTrend.consistentlyBad => _encouragingPhrases,
      MoodTrend.neutral => _neutralPhrases,
    };

    final subPhrases = switch (trend) {
      MoodTrend.improvingFromBad => _proudSubPhrases,
      MoodTrend.decliningFromGood => _supportiveSubPhrases,
      MoodTrend.consistentlyGood => _celebrateSubPhrases,
      MoodTrend.consistentlyBad => _encouragingSubPhrases,
      MoodTrend.neutral => _neutralSubPhrases,
    };

    return MoodAnalysis(
      trend: trend,
      recentCheckins: points,
      phrase: _pickRandom(phrases),
      subPhrase: _pickRandom(subPhrases),
    );
  }

  MoodTrend _detectTrend(List<String> statuses) {
    if (statuses.length < 2) return MoodTrend.neutral;

    final latest = statuses.first; // newest
    final older = statuses.sublist(1);

    final olderBadCount = older.where((s) => s == 'not_great').length;
    final olderGoodCount = older.where((s) => s == 'great').length;

    if (latest == 'great' && olderBadCount > olderGoodCount) {
      return MoodTrend.improvingFromBad;
    }
    if (latest == 'not_great' && olderGoodCount > olderBadCount) {
      return MoodTrend.decliningFromGood;
    }
    if (statuses.every((s) => s == 'great')) {
      return MoodTrend.consistentlyGood;
    }
    if (statuses.every((s) => s == 'not_great')) {
      return MoodTrend.consistentlyBad;
    }
    return MoodTrend.neutral;
  }

  static String _pickRandom(List<String> phrases) {
    return phrases[Random().nextInt(phrases.length)];
  }
}

// ---------------------------------------------------------------------------
// Phrase bank — diverse enough to avoid repetition across days
// ---------------------------------------------------------------------------

const _welcomePhrases = [
  'Welcome to VitalPet',
  'Let\'s get started',
  'Your health journey begins here',
  'Ready when you are',
  'A fresh start today',
];

const _welcomeSubPhrases = [
  'Check in with yourself today.',
  'How are you feeling?',
  'Your pet is waiting for you.',
  'Take a moment for yourself.',
  'Small steps, big impact.',
];

/// Improving from bad — celebrate the turnaround
const _proudPhrases = [
  'Look at you bouncing back!',
  'You\'re doing amazing',
  'So proud of your progress',
  'What a turnaround!',
  'You\'re stronger than you know',
  'The hard days are paying off',
  'Your resilience is inspiring',
  'Things are looking up!',
  'You\'re on the upswing',
  'Every step forward counts',
  'You fought through — well done',
  'The clouds are clearing',
];

const _proudSubPhrases = [
  'Your recent check-ins show real improvement.',
  'Keep that momentum going!',
  'Your pet is thriving along with you.',
  'You should be proud of yourself.',
  'Recovery isn\'t linear, but you\'re heading the right way.',
  'It takes courage to keep going — and you did.',
];

/// Declining from good — gentle support
const _supportivePhrases = [
  'We\'re here for you',
  'Tough days happen to everyone',
  'It\'s okay to not be okay',
  'You don\'t have to face this alone',
  'One day at a time',
  'Be gentle with yourself today',
  'This too shall pass',
  'You\'re not a burden',
  'Rest is productive too',
  'Your feelings are valid',
  'A setback isn\'t a failure',
  'Healing isn\'t always forward',
];

const _supportiveSubPhrases = [
  'We noticed things have been harder lately.',
  'Take it easy — there\'s no rush.',
  'Your pet is here, no matter what.',
  'Sometimes the bravest thing is just showing up.',
  'Checking in when it\'s hard takes real strength.',
  'Let us know how we can help.',
];

/// Consistently good — celebrate the streak
const _celebratePhrases = [
  'You\'re on a roll!',
  'Consistency looks good on you',
  'Keep shining!',
  'What a streak of great days',
  'You\'re in a good groove',
  'Feeling great? You earned it',
  'Your dedication shows',
  'Three cheers for you!',
  'Living your best life',
  'Wellness champion!',
  'You\'re making it look easy',
  'Your pet is living the dream',
];

const _celebrateSubPhrases = [
  'Your recent days have been fantastic.',
  'Keep doing what you\'re doing!',
  'Your consistency is paying off.',
  'Your pet is at its happiest.',
  'Great days are built on good habits.',
  'You\'re proof that small steps work.',
];

/// Consistently bad — deep encouragement
const _encouragingPhrases = [
  'Hang in there',
  'You\'re tougher than this moment',
  'Better days are coming',
  'We believe in you',
  'You\'re not alone in this',
  'Every check-in is an act of courage',
  'Small victories matter',
  'Your strength is quiet but real',
  'Don\'t give up — you matter',
  'Each day is a new chance',
  'You\'re still here, and that\'s enough',
  'Pain is temporary, you are not',
];

const _encouragingSubPhrases = [
  'It\'s been a rough stretch — we see you.',
  'Checking in during hard times takes real bravery.',
  'If you need support, please reach out to someone you trust.',
  'Your pet is here to keep you company.',
  'You don\'t have to fix everything today.',
  'Just showing up matters more than you know.',
];

/// Neutral / mixed — balanced
const _neutralPhrases = [
  'Good to see you',
  'Let\'s check in together',
  'Another day, another step',
  'Here when you need us',
  'How\'s today treating you?',
  'Ready for today\'s check-in?',
  'Welcome back!',
  'Your pet missed you',
  'Let\'s see how you\'re doing',
  'Taking time for yourself — smart move',
];

const _neutralSubPhrases = [
  'Every check-in helps build the picture.',
  'Your pet perks up when you visit.',
  'Consistency is key — you\'re doing great.',
  'Take a moment to reflect on today.',
  'Your data helps you understand patterns.',
  'Ready when you are!',
];
