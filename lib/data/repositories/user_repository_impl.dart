import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:spa_app/data/mappers/user_mapper.dart';
import 'package:spa_app/data/services/auth_service.dart';
import 'package:spa_app/domain/repositories/user_repository.dart';
import 'package:spa_app/ui/features/user/models/user.dart';

class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl({
    required AuthService authService,
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
  })  : _authService = authService,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance;

  final AuthService _authService;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final Map<String, UserData> _sessionCache = {};

  CollectionReference<Map<String, dynamic>> get _usersCollection =>
      _firestore.collection('users');

  @override
  void clearSessionCache() {
    _sessionCache.clear();
  }

  void _cacheUser(UserData user) {
    final id = user.id;
    if (id != null && id.isNotEmpty) {
      _sessionCache[id] = user;
    }
  }

  @override
  Future<UserData> getUser() async {
    final uid = _requireUid();
    final cached = _sessionCache[uid];
    if (cached != null) {
      return cached;
    }

    final snapshot = await _getOrCreateUserDocument();
    final data = snapshot.data()!;
    final user = UserMapper.fromFirestore(snapshot.id, data);
    _cacheUser(user);
    return user;
  }

  @override
  Future<void> updateUser(UserData user) async {
    final uid = _requireUid();
    await _usersCollection.doc(uid).update({
      'firstname': user.firstname,
      'lastname': user.lastname,
      'age': user.age,
      'major': user.major,
      'minor': user.minor,
      if (user.onboardingComplete != null)
        'onboardingComplete': user.onboardingComplete,
    });
    _cacheUser(user);
  }

  @override
  Future<void> setProfileImage(Uint8List imageBytes) async {
    final datestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final uid = _requireUid();

    await _storage
        .ref()
        .child('users')
        .child(uid)
        .child('profile')
        .child(datestamp)
        .putData(imageBytes, SettableMetadata(contentType: 'image/jpeg'));

    await _usersCollection.doc(uid).update({'image': datestamp});

    final cached = _sessionCache[uid];
    if (cached != null) {
      cached.image = datestamp;
    }
  }

  @override
  Future<String> getCurrentUserId() async {
    return _requireUid();
  }

  @override
  Future<void> deleteCurrentUserData() async {
    final uid = _requireUid();
    await _usersCollection.doc(uid).delete();
    _sessionCache.remove(uid);

    final storageRef =
        _storage.ref().child('users').child(uid).child('profile');
    try {
      final items = await storageRef.listAll();
      for (final item in items.items) {
        await item.delete();
      }
    } catch (_) {
      // Ignore if folder does not exist.
    }
  }

  @override
  Future<List<UserData>> getUsersByIds(List<String> userIds) async {
    if (userIds.isEmpty) return [];

    final missingIds = userIds
        .toSet()
        .where((id) => !_sessionCache.containsKey(id))
        .toList();

    if (missingIds.isNotEmpty) {
      final fetched = await _fetchUsersFromFirestore(missingIds);
      for (final user in fetched) {
        _cacheUser(user);
      }
    }

    return [
      for (final id in userIds)
        if (_sessionCache.containsKey(id)) _sessionCache[id]!,
    ];
  }

  Future<List<UserData>> _fetchUsersFromFirestore(List<String> userIds) async {
    const batchSize = 10;
    final users = <UserData>[];

    for (var i = 0; i < userIds.length; i += batchSize) {
      final batch = userIds.skip(i).take(batchSize).toList();
      if (batch.isEmpty) continue;

      try {
        final query = await _usersCollection
            .where(FieldPath.documentId, whereIn: batch)
            .get();

        for (final doc in query.docs) {
          users.add(UserMapper.fromFirestore(doc.id, doc.data()));
        }
      } catch (_) {
        for (final userId in batch) {
          final doc = await _usersCollection.doc(userId).get();
          if (doc.exists) {
            users.add(UserMapper.fromFirestore(doc.id, doc.data()!));
          }
        }
      }
    }

    return users;
  }

  String _requireUid() {
    final uid = _authService.currentUser?.uid;
    if (uid == null) {
      throw Exception('No authenticated user');
    }
    return uid;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> _getOrCreateUserDocument() async {
    final uid = _requireUid();
    final user = await _usersCollection.doc(uid).get();

    if (!user.exists) {
      await _usersCollection.doc(uid).set({
        'firstname': '',
        'lastname': '',
        'age': '',
        'major': '',
        'minor': '',
        'image': '',
        'biblestudyGroup': '',
        'biblestudyLeader': false,
        'tent': '',
        'tentLeader': false,
        'staff': false,
        'onboardingComplete': false,
      });
      return _getOrCreateUserDocument();
    }

    return user;
  }
}
