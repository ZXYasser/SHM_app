import 'package:firebase_auth/firebase_auth.dart';

/// خدمة مصادقة بسيطة تمهيداً لتفعيل تسجيل الدخول برقم الجوال.
///
/// حالياً هذه الخدمة لا تُستخدم في أي مكان في التطبيق،
/// ولن تغيّر أي سلوك قائم حتى نربطها لاحقاً في الخطوات القادمة.
class AuthService {
  AuthService._();

  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// المستخدم الحالي (إن وُجد)
  static User? get currentUser => _auth.currentUser;

  /// معرف المستخدم الحالي (uid) أو null إن لم يكن مسجلاً.
  static String? get currentUserId => _auth.currentUser?.uid;

  /// هل المستخدم مسجّل دخول حالياً؟
  static bool get isLoggedIn => _auth.currentUser != null;

  /// تسجيل الخروج (لن نستخدمها الآن لكنها جاهزة للمستقبل).
  static Future<void> signOut() async {
    await _auth.signOut();
  }
}

