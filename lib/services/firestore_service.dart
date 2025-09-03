import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/sick_leave_model.dart';
import '../models/reason_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Users collection
  CollectionReference get _users => _db.collection('users');
  CollectionReference get _sickLeaves => _db.collection('sick_leaves');
  CollectionReference get _reasons => _db.collection('reasons');

  // User operations
  Future<void> createUser(UserModel user) async {
    await _users.doc(user.uid).set(user.toMap());
  }

  Future<UserModel?> getUser(String uid) async {
    final doc = await _users.doc(uid).get();
    if (doc.exists) {
      return UserModel.fromMap(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<void> updateUser(UserModel user) async {
    await _users.doc(user.uid).update(user.toMap());
  }

  Future<void> incrementSickDays(String uid) async {
    await _users.doc(uid).update({'totalSickDays': FieldValue.increment(1)});
  }

  // Sick leave operations
  Future<String> addSickLeave(SickLeaveModel sickLeave) async {
    final docRef = await _sickLeaves.add(sickLeave.toMap());
    return docRef.id;
  }

  Future<List<SickLeaveModel>> getUserSickLeaves(String userId) async {
    final querySnapshot =
        await _sickLeaves
            .where('userId', isEqualTo: userId)
            .orderBy('date', descending: true)
            .get();

    return querySnapshot.docs
        .map(
          (doc) => SickLeaveModel.fromMap(
            doc.data() as Map<String, dynamic>,
            doc.id,
          ),
        )
        .toList();
  }

  Future<int> getUserSickLeaveCount(String userId) async {
    final querySnapshot =
        await _sickLeaves.where('userId', isEqualTo: userId).get();
    return querySnapshot.size;
  }

  Future<List<SickLeaveModel>> getUserSickLeavesForMonth(
    String userId,
    DateTime month,
  ) async {
    final startOfMonth = DateTime(month.year, month.month, 1);
    final endOfMonth = DateTime(month.year, month.month + 1, 0);

    final querySnapshot =
        await _sickLeaves
            .where('userId', isEqualTo: userId)
            .where(
              'date',
              isGreaterThanOrEqualTo: startOfMonth.millisecondsSinceEpoch,
            )
            .where(
              'date',
              isLessThanOrEqualTo: endOfMonth.millisecondsSinceEpoch,
            )
            .orderBy('date', descending: true)
            .get();

    return querySnapshot.docs
        .map(
          (doc) => SickLeaveModel.fromMap(
            doc.data() as Map<String, dynamic>,
            doc.id,
          ),
        )
        .toList();
  }

  // Reason operations
  Future<void> addReason(ReasonModel reason) async {
    await _reasons.add(reason.toMap());
  }

  Future<List<ReasonModel>> getAllReasons() async {
    final querySnapshot = await _reasons.get();
    return querySnapshot.docs
        .map(
          (doc) =>
              ReasonModel.fromMap(doc.data() as Map<String, dynamic>, doc.id),
        )
        .toList();
  }

  Future<List<ReasonModel>> getAvailableReasons(String userId) async {
    final querySnapshot =
        await _reasons.where('lastUsedBy', isNotEqualTo: userId).get();

    return querySnapshot.docs
        .map(
          (doc) =>
              ReasonModel.fromMap(doc.data() as Map<String, dynamic>, doc.id),
        )
        .toList();
  }

  Future<void> markReasonAsUsed(String reasonId, String userId) async {
    await _reasons.doc(reasonId).update({
      'lastUsedBy': userId,
      'lastUsedDate': DateTime.now().millisecondsSinceEpoch,
    });
  }

  // Initialize default reasons
  Future<void> initializeDefaultReasons() async {
    final reasonsSnapshot = await _reasons.limit(1).get();
    if (reasonsSnapshot.docs.isEmpty) {
      final defaultReasons = [
        ReasonModel(
          id: '',
          text: 'Feeling under the weather with flu-like symptoms',
          category: 'illness',
        ),
        ReasonModel(
          id: '',
          text: 'Experiencing severe migraine headaches',
          category: 'illness',
        ),
        ReasonModel(
          id: '',
          text: 'Stomach bug preventing me from working effectively',
          category: 'illness',
        ),
        ReasonModel(
          id: '',
          text: 'Food poisoning from last night\'s dinner',
          category: 'illness',
        ),
        ReasonModel(
          id: '',
          text: 'Allergic reaction requiring medical attention',
          category: 'medical',
        ),
        ReasonModel(
          id: '',
          text: 'Back pain making it difficult to sit at desk',
          category: 'physical',
        ),
        ReasonModel(
          id: '',
          text: 'Dental emergency requiring immediate treatment',
          category: 'medical',
        ),
        ReasonModel(
          id: '',
          text: 'Eye infection preventing computer work',
          category: 'medical',
        ),
        ReasonModel(
          id: '',
          text: 'Stress-related symptoms affecting performance',
          category: 'mental_health',
        ),
        ReasonModel(
          id: '',
          text: 'Family emergency requiring immediate attention',
          category: 'family',
        ),
        ReasonModel(
          id: '',
          text: 'Car accident - need to handle insurance matters',
          category: 'emergency',
        ),
        ReasonModel(
          id: '',
          text: 'Home emergency - burst pipe flooding apartment',
          category: 'emergency',
        ),
        ReasonModel(
          id: '',
          text: 'Doctor\'s appointment for routine checkup',
          category: 'medical',
        ),
        ReasonModel(
          id: '',
          text: 'Childcare emergency - babysitter unavailable',
          category: 'family',
        ),
        ReasonModel(
          id: '',
          text: 'Power outage at home affecting work setup',
          category: 'technical',
        ),
      ];

      for (final reason in defaultReasons) {
        await _reasons.add(reason.toMap());
      }
    }
  }
}
