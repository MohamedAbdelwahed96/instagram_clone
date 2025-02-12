import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String postId;
  final String uid;
  final String username;
  final String userProfileImage;
  final String postImageUrl;
  final String caption;
  final DateTime createdAt;
  final List<String> likes;
  final int commentCount;

  PostModel({
    required this.postId,
    required this.uid,
    required this.username,
    required this.userProfileImage,
    required this.postImageUrl,
    required this.caption,
    required this.createdAt,
    required this.likes,
    required this.commentCount,
  });

  /// Convert Firestore/Supabase data to PostModel
  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      postId: map['postId'] ?? '',
      uid: map['userId'] ?? '',
      username: map['username'] ?? '',
      userProfileImage: map['userProfileImage'] ?? '',
      postImageUrl: map['postImageUrl'] ?? '',
      caption: map['caption'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      likes: List<String>.from(map['likes'] ?? []),
      commentCount: map['commentCount'] ?? 0,
    );
  }

  /// Convert PostModel to Map for Firestore/Supabase storage
  Map<String, dynamic> toMap() {
    return {
      'postId': postId,
      'userId': uid,
      'username': username,
      'userProfileImage': userProfileImage,
      'postImageUrl': postImageUrl,
      'caption': caption,
      'createdAt': Timestamp.fromDate(createdAt),
      'likes': likes,
      'commentCount': commentCount,
    };
  }
}
