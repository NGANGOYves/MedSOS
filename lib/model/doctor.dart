class Doctor {
  final String name;
  final String specialty;
  final int years;

  final double rating;
  final int reviews;
  final bool isFeatured;
  final bool isOnline;

  Doctor({
    required this.name,
    required this.specialty,
    required this.years,

    required this.rating,
    required this.reviews,
    this.isFeatured = false,
    this.isOnline = true,
  });
}
