enum StarterEntryMode {
  firstTime,
  returning,
}

class StarterScreenArgs {
  final StarterEntryMode mode;

  const StarterScreenArgs({
    required this.mode,
  });
}
