class UxTrackerSetup {
  final double? flushInterval;
  final int? batchSize;

  const UxTrackerSetup({
    this.flushInterval = 10,
    this.batchSize = 5,
  });

  Map<String, dynamic> toMap() {
    return {
      'flushInterval': flushInterval,
      'batchSize': batchSize,
    };
  }
}
