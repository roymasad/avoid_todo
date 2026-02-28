enum TipContext { relapse, streak, health, social, productivity, general }

class AvoidanceTip {
  final String text;
  final TipContext context;
  const AvoidanceTip(this.text, this.context);
}

const List<AvoidanceTip> avoidanceTips = [
  // Relapse tips
  AvoidanceTip(
      "A relapse is data, not failure. What does it tell you about your triggers?",
      TipContext.relapse),
  AvoidanceTip("The chain is broken but not gone — start a new one right now.",
      TipContext.relapse),
  AvoidanceTip("One slip doesn't erase your progress. Progress isn't linear.",
      TipContext.relapse),
  AvoidanceTip(
      "Be curious about what happened — judgment makes it harder to change.",
      TipContext.relapse),
  AvoidanceTip("Tomorrow is a fresh start. Right now, choose differently.",
      TipContext.relapse),
  AvoidanceTip("Every great streak started the day after a slip.",
      TipContext.relapse),

  // Streak / milestone tips
  AvoidanceTip(
      "Every day you avoid it is a vote for the person you want to become.",
      TipContext.streak),
  AvoidanceTip(
      "Urges last an average of 15–20 minutes. Outlasting them gets easier each time.",
      TipContext.streak),
  AvoidanceTip(
      "The gap between stimulus and response is where your freedom lives.",
      TipContext.streak),
  AvoidanceTip(
      "Anticipate your triggers — knowing when they come lets you prepare.",
      TipContext.streak),
  AvoidanceTip("Celebrate the small wins. 1 day avoided is 1 day won.",
      TipContext.streak),
  AvoidanceTip("Streaks don't build habits — habits build streaks.",
      TipContext.streak),

  // Health tips
  AvoidanceTip(
      "Drink a glass of water when the urge hits — dehydration often mimics cravings.",
      TipContext.health),
  AvoidanceTip(
      "Take 10 deep breaths. Your urge will peak and pass within 5–10 minutes.",
      TipContext.health),
  AvoidanceTip(
      "Step outside for 2 minutes — fresh air breaks the mental loop.",
      TipContext.health),
  AvoidanceTip("Do 20 jumping jacks — movement shifts your brain chemistry.",
      TipContext.health),
  AvoidanceTip("Sleep deprivation multiplies cravings. Prioritize rest.",
      TipContext.health),

  // Social tips
  AvoidanceTip(
      "Practice the 'pause and respond' rule — wait 24 hours before engaging.",
      TipContext.social),
  AvoidanceTip(
      "Set a 15-minute timer before responding to anything that stirs you up.",
      TipContext.social),
  AvoidanceTip("Ask yourself: Will this matter in 5 years?",
      TipContext.social),
  AvoidanceTip("Write it in a journal instead of saying it out loud.",
      TipContext.social),
  AvoidanceTip(
      "Boundaries are not walls — they're guidelines for healthy interaction.",
      TipContext.social),

  // Productivity tips
  AvoidanceTip("Close the tab. Out of sight is genuinely out of mind.",
      TipContext.productivity),
  AvoidanceTip(
      "Schedule a specific 'allowed' time so it doesn't feel like deprivation.",
      TipContext.productivity),
  AvoidanceTip(
      "Track your time for one day — you may be surprised how much this costs you.",
      TipContext.productivity),
  AvoidanceTip("Replace the habit with something that gives a similar reward.",
      TipContext.productivity),
  AvoidanceTip("Use the 2-minute rule to reclaim momentum.",
      TipContext.productivity),

  // General tips
  AvoidanceTip(
      "Visualize what you'd spend your savings on — make it concrete.",
      TipContext.general),
  AvoidanceTip("How will you feel about this in 3 hours? Lead with that feeling.",
      TipContext.general),
  AvoidanceTip(
      "Every hour avoided is an hour gifted back to something you love.",
      TipContext.general),
];

String? getTipForRelapse() {
  final tips =
      avoidanceTips.where((t) => t.context == TipContext.relapse).toList();
  if (tips.isEmpty) return null;
  return tips[DateTime.now().second % tips.length].text;
}

String? getTipForStreak(int streakDays) {
  if (streakDays < 3) return null;
  final tips =
      avoidanceTips.where((t) => t.context == TipContext.streak).toList();
  if (tips.isEmpty) return null;
  return tips[streakDays % tips.length].text;
}

String? getTipForTagId(String tagId) {
  TipContext? ctx;
  if (tagId == 'health') ctx = TipContext.health;
  if (tagId == 'productivity') ctx = TipContext.productivity;
  if (tagId == 'social') ctx = TipContext.social;
  if (ctx == null) return null;

  final tips = avoidanceTips.where((t) => t.context == ctx).toList();
  if (tips.isEmpty) return null;
  return tips[DateTime.now().millisecond % tips.length].text;
}
