class News {
  final int id;
  final String main_topic;
  final String subtopic;
  final String image;
  final String date; // Added date field

  News({
    required this.id,
    required this.main_topic,
    required this.subtopic,
    required this.image,
    required this.date, // Updated constructor
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['id'],
      main_topic: json['main_topic'],
      subtopic: json['subtopic'],
      image: json['image'],
      date: json['created_at'], // Updated fromJson method
    );
  }
}


