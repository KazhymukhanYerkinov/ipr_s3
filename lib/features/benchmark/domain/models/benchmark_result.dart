class BenchmarkResult {
  final int sizeMb;
  final int dartMs;
  final int nativeMs;
  final int isolateMs;
  final String? label;

  const BenchmarkResult({
    required this.sizeMb,
    required this.dartMs,
    required this.nativeMs,
    required this.isolateMs,
    this.label,
  });

  String get sizeLabel => label ?? '${sizeMb} MB';
  double get speedup => dartMs > 0 ? dartMs / nativeMs : 0;
}
