import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/UserModel.dart';
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
  static addUasertoFireStore(UserModel user) {
    FirebaseFirestore db=FirebaseFirestore.instance;
    CollectionReference<UserModel> usercollection = db.collection("Users").withConverter<UserModel>(
      fromFirestore: (snapshot, _) => UserModel.fromjson(snapshot.data()!),
      toFirestore: (user, _) => user.toJosn(),
    );
    DocumentReference<UserModel> UserDocument = usercollection.doc(user.id);
    return UserDocument.set(user);
  }



  static  getUserId(String id)async {
    FirebaseFirestore db=FirebaseFirestore.instance;
    CollectionReference<UserModel> usercollection = db.collection("Users").withConverter<UserModel>(
      fromFirestore: (snapshot, _) => UserModel.fromjson(snapshot.data()!),
      toFirestore: (user, _) => user.toJosn(),
    );
    DocumentReference<UserModel> UserDocument = usercollection.doc(id);
    DocumentSnapshot<UserModel> documentSnapshot = await  UserDocument.get();
    return  documentSnapshot.data();

  }

}