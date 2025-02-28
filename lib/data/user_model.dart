class UserModel {
  final String uid;
  final String username;
  final String fullName;
  final String pfpUrl;
  final String email;
  final List<String> followers;
  final List<String> following;
  final List<String> posts;
  final List<String> stories;
  final String bio;
  final String pNumber;
  final String gender;
  final String website;
  final DateTime time;
  final bool darkTheme;
  final String language;

  UserModel({
    this.uid = "",
    required this.username,
    required this.fullName,
    required this.pfpUrl,
    required this.email,
    this.followers = const [],
    this.following = const [],
    this.posts = const [],
    this.stories = const [],
    this.bio = "",
    this.pNumber = "",
    required this.gender,
    this.website = "",
    required this.time,
    this.darkTheme = false,
    this.language = "en",
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      username: map['username'] ?? '',
      fullName: map['fullName'] ?? '',
      pfpUrl: map['pfpUrl'] ?? '',
      email: map['email'] ?? '',
      followers: map['followers'] != null ? List<String>.from(map['followers']) : [],
      following: map['following'] != null ? List<String>.from(map['following']) : [],
      posts: map['posts'] != null ? List<String>.from(map['posts']) : [],
      stories: map['stories'] != null ? List<String>.from(map['stories']) : [],
      bio: map['bio'] ?? '',
      pNumber: map['pNumber'] ?? '',
      gender: map['gender'] ?? '',
      website: map['website'] ?? '',
      time: map['time'] != null ? DateTime.parse(map['time']) : DateTime.now(),
      darkTheme: map['darkTheme'] ?? false,
      language: map['language'] ?? 'en',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'fullName': fullName,
      'pfpUrl': pfpUrl,
      'email': email,
      'followers': followers,
      'following': following,
      'posts': posts,
      'stories': stories,
      'bio': bio,
      'pNumber': pNumber,
      'gender': gender,
      'website': website,
      'time': time.toIso8601String(),
      'darkTheme': darkTheme,
      'language': language,
    };
  }
}
