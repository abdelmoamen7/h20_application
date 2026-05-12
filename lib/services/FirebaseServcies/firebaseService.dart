import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
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


/// Loads [UserModel.currentUser] when already signed in; safe to unawait after [Firebase.initializeApp].
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
  /// stream the user data
  static Stream<UserModel?>
  streamCurrentUser() {
    FirebaseFirestore db = FirebaseFirestore.instance;
    return db.collection("Users").doc(
      FirebaseAuth.instance.currentUser!.uid,)
        .withConverter<UserModel>(fromFirestore: (snapshot, _) => UserModel.fromJson(
            snapshot.data()!,
          ),
      toFirestore:
          (user, _) =>
          user.toJosn(),
    )
        .snapshots()
        .map(

          (snapshot) {

        return snapshot.data();
      },
    );
  }

}