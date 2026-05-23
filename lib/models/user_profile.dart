class UserProfile {
  const UserProfile({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.photoUrl,
  });

  final String uid;
  final String name;
  final String email;
  final String phone;
  final String photoUrl;

  factory UserProfile.empty() {
    return const UserProfile(
      uid: '',
      name: 'Guest User',
      email: 'Not signed in',
      phone: '',
      photoUrl: '',
    );
  }

  factory UserProfile.fromMap(String uid, Map<String, dynamic> data) {
    return UserProfile(
      uid: uid,
      name: data['name'] as String? ?? 'Fashion User',
      email: data['email'] as String? ?? '',
      phone: data['phone'] as String? ?? '',
      photoUrl: data['photoUrl'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'email': email, 'phone': phone, 'photoUrl': photoUrl};
  }
}
