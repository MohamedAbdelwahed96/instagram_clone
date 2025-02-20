class UserModel {
  final String uid;
  final String username;
  final String fullName;
  final String pfpUrl;
  final String email;
  final List<String> followers;
  final List<String> following;
  final List<String> posts;
  final String bio;
  final String pNumber;
  final String gender;
  final String website;
  final DateTime time;

  // Constructor
  UserModel({
    this.uid = "",
    required this.username,
    required this.fullName,
    required this.pfpUrl,
    required this.email,
    this.followers = const [],
    this.following = const [],
    this.posts = const [],
    this.bio = "",
    this.pNumber = "",
    required this.gender,
    this.website = "",
    required this.time,
  });

  // Convert Firestore Map to UserModel
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      username: map['username'] ?? '',
      fullName: map['fullName'] ?? '',
      pfpUrl: map['pfpUrl'] ?? '',
      email: map['email'] ?? '',
      followers: map['followers'] != null
          ? List<String>.from(map['followers']) // If 'followers' is an array
          : [],
      following: map['following'] != null
          ? List<String>.from(map['following']) // If 'following' is an array
          : [],
      posts: map['posts'] != null
          ? List<String>.from(map['posts']) // If 'posts' is an array
          : [],
      bio: map['bio'] ?? '',
      pNumber: map['pNumber'] ?? '',
      gender: map['gender'] ?? '',
      website: map['website'] ?? '',
      time: map['time'] != null ? DateTime.parse(map['time']) : DateTime.now(),
    );
  }

  // Convert UserModel to Firestore Map
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'fullName': fullName,
      'pfpUrl': pfpUrl,
      'email': email,
      'followers': followers, // Firestore will handle it as an array
      'following': following, // Firestore will handle it as an array
      'posts': posts, // Firestore will handle it as an array
      'bio': bio,
      'pNumber': pNumber,
      'gender': gender,
      'website': website,
      'time': time.toIso8601String(), // Convert DateTime to a string
    };
  }
}
