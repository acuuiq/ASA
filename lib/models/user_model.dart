// models/user_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String fullName;
  final String email;
  final String phone;
  final String address;
  final int points;
  final String subscriptionDate;
  final String frontIdImage;
  final String backIdImage;
  final String userType;
  final String status;

  UserModel({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.address,
    required this.points,
    required this.subscriptionDate,
    required this.frontIdImage,
    required this.backIdImage,
    required this.userType,
    required this.status,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return UserModel(
      uid: doc.id,
      fullName: data['fullName'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      address: data['address'] ?? '',
      points: data['points'] ?? 0,
      subscriptionDate: data['subscriptionDate'] ?? '',
      frontIdImage: data['frontIdImage'] ?? '',
      backIdImage: data['backIdImage'] ?? '',
      userType: data['userType'] ?? 'citizen',
      status: data['status'] ?? 'under_review',
    );
  }
}