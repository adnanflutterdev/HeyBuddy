import 'package:googleapis_auth/auth_io.dart';
import 'package:heybuddy/Notification/server_key.dart';

class GetServerKey {
  Future<String> serverKey() async {
    final scopes = [
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/firebase.database',
      'https://www.googleapis.com/auth/firebase.messaging',
    ];

    final client = await clientViaServiceAccount(
        ServiceAccountCredentials.fromJson(yourServerKey),
        scopes);
    final serverkey = client.credentials.accessToken.data;
    return serverkey;
  }
}
