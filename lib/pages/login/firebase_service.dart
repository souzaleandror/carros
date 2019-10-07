import 'dart:io';

import 'package:carros/pages/login/api_response.dart';
import 'package:carros/pages/login/usuario.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:path/path.dart' as path;

class FirebaseService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<FirebaseUser> _handleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;
    print("signed in " + user.displayName);
    return user;
  }

  Future<ApiResponse> cadastrar(
      {String nome, String email, String password, File file}) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      final FirebaseUser fuser = result.user;
      final userUpdateInfo = UserUpdateInfo();
      userUpdateInfo.displayName = nome;
      userUpdateInfo.photoUrl =
          "http://s3-east-1.amazonaws.com/livetouch-temp/livrows/foto.png";
      fuser.updateProfile(userUpdateInfo);

      print("Firebase Nome: ${fuser.displayName}");
      print("Firebase Email: ${fuser.email}");
      print("Firebase Foto: ${fuser.photoUrl}");

      if (file != null) {
        userUpdateInfo.photoUrl =
            await FirebaseService.uploadFirebaseStorage(file);
      }

      final user = Usuario(
          nome: fuser.displayName,
          login: fuser.email,
          email: fuser.email,
          urlFoto: fuser.photoUrl,
          id: -1,
          roles: ["NORMA_USER"],
          token: fuser.uid);

      user.save();

      return ApiResponse.ok(result: true, msg: "Usuario criado com sucesso");
    } catch (e, exception) {
      print("Firebase register error $e >> $exception");
      return ApiResponse.error(
          result: false,
          //msg: "Nao foi possivel fazer o cadastro: ${e} >> ${exception}");
          msg:
              "Nao foi possivel fazer o cadastro: ${e.message} >> ${exception}");
    }
  }

  Future<ApiResponse> login(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      final FirebaseUser fuser = result.user;
      print("Firebase Nome: ${fuser.displayName}");
      print("Firebase Email: ${fuser.email}");
      print("Firebase Foto: ${fuser.photoUrl}");

      final user = Usuario(
          nome: fuser.displayName,
          login: fuser.email,
          email: fuser.email,
          urlFoto: fuser.photoUrl);

      user.save();

      return ApiResponse.ok(result: true, msg: "Fazendo o login");
    } catch (e, exception) {
      print("Firebase login error $e >> $exception");
      return ApiResponse.error(
          result: false, msg: "Nao foi possivel fazer o login");
    }
  }

  Future<ApiResponse> loginGoogle() async {
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      print("Google User: ${googleUser.email}");

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      AuthResult result = await _auth.signInWithCredential(credential);
      final FirebaseUser fuser = result.user;
      print("Firebase Nome: ${fuser.displayName}");
      print("Firebase Email: ${fuser.email}");
      print("Firebase Foto: ${fuser.photoUrl}");

      final user = Usuario(
          nome: fuser.displayName,
          login: fuser.email,
          email: fuser.email,
          urlFoto: fuser.photoUrl);

      user.save();

//      final FirebaseUser user =
//          (await _auth.signInWithCredential(credential)).user;
//
//      print("signed in " + user.displayName);

      return ApiResponse.ok();
    } catch (e, exception) {
      print("Firebase error $e >> $exception");
      return ApiResponse.error(msg: "Nao foi possivel fazer o login");
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  static Future<String> uploadFirebaseStorage(File file) async {
    print("Upload to Storage: $file");
    String fileName = path.basename(file.path);
    final storageRef = FirebaseStorage.instance.ref().child(fileName);

    final StorageTaskSnapshot task = await storageRef.putFile(file).onComplete;
    final String urlFoto = await task.ref.getDownloadURL();
    print("Storage > $urlFoto");
    return urlFoto;
  }
}
