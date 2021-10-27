// import 'dart:async';
// import 'dart:convert';
// import 'dart:developer';

// import 'package:poshyak/Shared/models/user.dart';

// import 'networking.dart';
// import 'storage.dart';

// abstract class AuthBase {
//   Stream<User> get onAuthStateChanged;

//   Future<User> login(String url, Map<String, dynamic> req);

//   Future<void> logOut();
// }

// class Auth implements AuthBase {
//   NetworkService networkService = NetworkService();
//   StorageService storageService = StorageService();

//   final controller = StreamController<User>();

//   Auth() {
//     _initUser();
//   }

//   Future<void> _initUser() async {
//     String str = await StorageService.getUser();

//     if (str != null) {
//       controller.add(User.fromJSON(jsonDecode(str)));
//     } else {
//       controller.add(null);
//     }
//   }

//   @override
//   Stream<User> get onAuthStateChanged {
//     return controller.stream;
//   }

//   static Future<bool> isAuthenticated() async {
//     return await StorageService.getUser() != null;
//   }

//   @override
//   Future<User> login(url, loginObj) async {
//     print("login auth $loginObj");
//     try {
//       var resp = await networkService.post(url, loginObj);
//       print('resp user $resp');
//       if (resp != null) {
//         User user = User.fromJSON(resp);
//         storageService.setToken(user.token);
//         storageService.setUser(user.toMap());
//         controller.add(user);
//         return user;
//       } else {
//         throw new MyException('Something went wrong');
//       }
//     } catch (e) {
//       print(e);
//       rethrow;
//     }
//   }

//   @override
//   Future<void> logOut() async {
//     await StorageService.removeAll();
//     controller.add(null);
//     return null;
//   }
// }

// class MyException implements Exception {
//   String cause;

//   @override
//   String toString() {
//     return cause;
//   }

//   MyException(this.cause);
// }
