class UserModel {
  final String username;
  final String fullName;
  final String pfpUrl;
  final String email;
  final int followersCount;
  final int followingCount;
  final int postCount;
  final String bio;
  DateTime time;

  // Constructor
  UserModel({
    required this.username,
    required this.fullName,
    required this.pfpUrl,
    required this.email,
    this.followersCount=0,
    this.followingCount=0,
    this.postCount=0,
    this.bio="",
    required this.time,
  });

  // Method to convert Map to UserModel
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      username: map['username'] ?? '',
      fullName: map['fullName'] ?? '',
      pfpUrl: map['pfpUrl'] ?? '',
      email: map['email'] ?? '',
      followersCount: map['followersCount'] ?? 0,
      followingCount: map['followingCount'] ?? 0,
      postCount: map['postCount'] ?? 0,
      bio: map['bio'] ?? '',
      time: DateTime.parse(map['time']),
    );
  }

  // Method to convert UserModel to Map
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'fullName': fullName,
      'pfpUrl': pfpUrl,
      'email': email,
      'followersCount': followersCount,
      'followingCount': followingCount,
      'postCount': postCount,
      'bio': bio,
      'time': time.toIso8601String(),
    };
  }
}
