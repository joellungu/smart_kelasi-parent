class Period {
  final String name;
  final double score;
  final double total;
  final DateTime startDate;
  final DateTime endDate;
  final List<CourseResult> courses;

  Period(
    this.name,
    this.score,
    this.total,
    this.startDate,
    this.endDate,
    this.courses,
  );
}

class CourseResult {
  final String name;
  final double score;
  final double total;

  CourseResult(this.name, this.score, this.total);
}
