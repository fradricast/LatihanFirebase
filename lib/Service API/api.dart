import 'package:dio/dio.dart';
import 'package:latihan/Model/user_model.dart';

class FirebaseAPI {
  //mengirim data
  Future<void> putUserData(
      {required String uid, required UserModel userData}) async {
    await Dio().put(
        'https://mobilelato-default-rtdb.firebaseio.com/userData/$uid.json',
        data: userData.toJson());
  }

  // //mengambil data
  // Future<UserModel> getUserData({required uid}) async {
  //   final response = await Dio().get(
  //       'https://mobilelato-default-rtdb.firebaseio.com/userData/$uid.json');
  //   UserModel data = UserModel.fromJson(response.data);
  //   return data;
  // }
  Future<void> putData(
      {required String uid, required UserModel userData}) async {
    await Dio().post(
        'https://mobilelato-default-rtdb.firebaseio.com/Data/$uid.json',
        data: userData.toJson());
  }

  Future<UserModel> getData({required uid}) async {
    // var _dio = Dio();
    // _dio.interceptors
    //     .add(LogInterceptor(responseBody: true, requestBody: true));
    final response = await Dio()
        .get('https://mobilelato-default-rtdb.firebaseio.com/Data/$uid.json');
    UserModel data = UserModel.fromJson(response.data);
    return data;
  }
}
