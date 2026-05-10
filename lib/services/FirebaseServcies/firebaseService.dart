import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:h20_application/models/HealthMetricsModel.dart';
import '../../models/HealthMetricsModel.dart';
import '../../models/UserModel.dart';
class Fairebaeservices{
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