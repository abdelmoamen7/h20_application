import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:io';
import '../../models/HealthMetricsModel.dart';
import '../../models/UserModel.dart';
import '../../models/nutrition_model.dart';
class Fairebaeservices{

  /// Sign in with Google and return a [UserCredential].
  /// Returns null if the user cancels the sign-in flow.
  static Future<UserCredential?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return null; // user cancelled

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return FirebaseAuth.instance.signInWithCredential(credential);
  }

  static Future<UserCredential> registers(String email, String password) async {
    /// this way to make the  user to Register  using the  sign in user and password by firebase  by user and password
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    return userCredential;
  }

  static Future<UserCredential> login(String email, String password) async {
    /// this way to make the  user to login using the  sign in user and password by firebase  by user and password
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return userCredential;
  }
  /// add the user to the firebase firstore
  static addUasertoFireStore(UserModel user) {
    FirebaseFirestore db=FirebaseFirestore.instance;
    CollectionReference<UserModel> usercollection = db.collection("Users").withConverter<UserModel>(
      fromFirestore: (snapshot, _) => UserModel.fromJson(snapshot.data()!),
      toFirestore: (user, _) => user.toJosn(),
    );
    DocumentReference<UserModel> UserDocument = usercollection.doc(user.id);
    return UserDocument.set(user);
  }
  static updateUserPersonalInfo(UserModel user) {
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference<UserModel> usercollection = db
        .collection("Users")
        .withConverter<UserModel>(
      fromFirestore: (snapshot, _) => UserModel.fromJson(snapshot.data()!),
      toFirestore: (user, _) => user.toJosn(),
    );
    DocumentReference<UserModel> UserDocument = usercollection.doc(user.id);
    return UserDocument.update(user.toJosn());
  }
  /// add the user to the firebase firstore
  static addHealthMetricsToforestore(HealthMetricsModel HealthMetrics) {
    FirebaseFirestore db=FirebaseFirestore.instance;
    CollectionReference<HealthMetricsModel> HealthMetricscollection = db.collection("HealthMetrics").withConverter<HealthMetricsModel>(
      fromFirestore: (snapshot, _) => HealthMetricsModel.fromJson(snapshot.data()!),
      toFirestore: (HealthMetrics, _) => HealthMetrics.toJosn(),
    );
    DocumentReference<HealthMetricsModel> HealthDocument = HealthMetricscollection.doc(HealthMetrics.id);
    return HealthDocument.set(HealthMetrics);
  }

  static addnutraionDatatofirstore( NutritionModel nutration) {
    FirebaseFirestore db=FirebaseFirestore.instance;
    CollectionReference<NutritionModel> nutrationscollection = db.collection("nutration").withConverter<NutritionModel>(
      fromFirestore: (snapshot, _) =>NutritionModel .fromJson(snapshot.data()!),
      toFirestore: (nutration, _) => nutration.toJson(),
    );
    DocumentReference<NutritionModel> nutraiondocumnet = nutrationscollection.doc(nutration.id);
    return nutraiondocumnet.set(nutration);
  }


  /// Uploads a profile image to Firebase Storage and saves the URL to Firestore.
  /// Returns the download URL on success, null on failure.
  static Future<String?> uploadProfileImage(File imageFile) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return null;

    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('$uid.jpg');

      await ref.putFile(
        imageFile,
        SettableMetadata(contentType: 'image/jpeg'),
      );

      final downloadUrl = await ref.getDownloadURL();

      // Save URL to Firestore
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(uid)
          .update({'profileImage': downloadUrl});

      // Update in-memory cache
      if (UserModel.currentUser != null) {
        UserModel.currentUser!.profileImage = downloadUrl;
      }

      return downloadUrl;
    } catch (_) {
      return null;
    }
  }

  /// Updates daily calories and water consumed. Resets if it's a new day.
  static Future<void> updateDailyTracking({
    int? addCalories,
    double? addWater,
    int? addProtein,
  }) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    try {
      final db = FirebaseFirestore.instance;
      final doc = db.collection("Users").doc(uid);
      final snapshot = await doc.get();
      if (!snapshot.exists) return;

      final data = snapshot.data() as Map<String, dynamic>?;
      if (data == null) return;

      final now = DateTime.now();
      final todayStr =
          '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
      final lastDate = data['lastTrackingDate'] as String? ?? '';
      final isNewDay = lastDate != todayStr;

      final currentCal = isNewDay ? 0 : (data['dailyCaloriesConsumed'] as num?)?.toInt() ?? 0;
      final currentWater = isNewDay ? 0.0 : (data['dailyWaterConsumed'] as num?)?.toDouble() ?? 0.0;
      final currentProtein = isNewDay ? 0 : (data['dailyProteinConsumed'] as num?)?.toInt() ?? 0;

      final newCal = (currentCal + (addCalories ?? 0)).clamp(0, 99999);
      final newWater = (currentWater + (addWater ?? 0.0)).clamp(0.0, 20.0);
      final newProtein = (currentProtein + (addProtein ?? 0)).clamp(0, 9999);

      await doc.update({
        'dailyCaloriesConsumed': newCal,
        'dailyWaterConsumed': newWater,
        'dailyProteinConsumed': newProtein,
        'lastTrackingDate': todayStr,
      });

      // Keep in-memory cache in sync
      if (UserModel.currentUser != null) {
        UserModel.currentUser!.dailyCaloriesConsumed = newCal;
        UserModel.currentUser!.dailyWaterConsumed = newWater;
        UserModel.currentUser!.dailyProteinConsumed = newProtein;
        UserModel.currentUser!.lastTrackingDate = todayStr;
      }
    } catch (_) {
      // Non-fatal
    }
  }

  /// Updates the daily streak in Firestore on every app open.
  /// - Same day → no change
  /// - Consecutive day → streak + 1
  /// - Missed a day or more → reset to 1
  static Future<void> updateStreak() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    try {
      final db = FirebaseFirestore.instance;
      final doc = db.collection("Users").doc(uid);
      final snapshot = await doc.get();
      if (!snapshot.exists) return;

      final data = snapshot.data() as Map<String, dynamic>?;
      if (data == null) return;

      final now = DateTime.now();
      final todayStr =
          '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

      final lastOpenStr = data['lastOpenDate'] as String?;
      final currentStreak = (data['streakDays'] as num?)?.toInt() ?? 0;

      // Already opened today — nothing to do
      if (lastOpenStr == todayStr) return;

      int newStreak;
      if (lastOpenStr != null) {
        final lastOpen = DateTime.tryParse(lastOpenStr);
        if (lastOpen != null) {
          final diff = DateTime(now.year, now.month, now.day)
              .difference(DateTime(lastOpen.year, lastOpen.month, lastOpen.day))
              .inDays;
          // Consecutive day
          newStreak = diff == 1 ? currentStreak + 1 : 1;
        } else {
          newStreak = 1;
        }
      } else {
        // First ever open
        newStreak = 1;
      }

      await doc.update({
        'streakDays': newStreak,
        'lastOpenDate': todayStr,
      });

      // Keep in-memory cache in sync
      if (UserModel.currentUser != null) {
        UserModel.currentUser!.streakDays = newStreak;
      }
    } catch (_) {
      // Non-fatal — streak update failure should never block the app
    }
  }
  static Future<void> prefetchCurrentUserProfile() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    try {
      UserModel.currentUser = await getUserId(uid);
    } catch (_) {
      // Non-fatal: Home uses streamCurrentUser; login sets user.
    }
  }

/// geting the user by id
  static  getUserId(String id)async {
    FirebaseFirestore db=FirebaseFirestore.instance;
    CollectionReference<UserModel> usercollection = db.collection("Users").withConverter<UserModel>(
      fromFirestore: (snapshot, _) => UserModel.fromJson(snapshot.data()!),
      toFirestore: (user, _) => user.toJosn(),
    );
    DocumentReference<UserModel> UserDocument = usercollection.doc(id);
    DocumentSnapshot<UserModel> documentSnapshot = await  UserDocument.get();
    return  documentSnapshot.data();

  }
  static Stream<UserModel?> streamCurrentUser() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return const Stream.empty();
    FirebaseFirestore db = FirebaseFirestore.instance;
    return db
        .collection("Users")
        .doc(uid)
        .withConverter<UserModel>(
          fromFirestore: (snapshot, _) => UserModel.fromJson(snapshot.data()!),
          toFirestore: (user, _) => user.toJosn(),
        )
        .snapshots()
        .map((snapshot) => snapshot.data());
  }

}