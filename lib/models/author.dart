class Author {
  final String id;
  final String fName;
  final String lName;
  final String dob;
  final String dod;

  Author({
    this.id,
    this.fName,
    this.lName,
    this.dob,
    this.dod,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json['id'],
      fName: json['first_name'],
      lName: json['last_name'],
      dob: json['dob'],
      dod: json['dod'],
    );
  }
}
