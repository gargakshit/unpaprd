class Reader {
  final String readerId;
  final String displayName;

  Reader({
    this.readerId,
    this.displayName,
  });

  factory Reader.fromJson(Map<String, dynamic> json) {
    return Reader(
      readerId: json['reader_id'],
      displayName: json['display_name'],
    );
  }
}
