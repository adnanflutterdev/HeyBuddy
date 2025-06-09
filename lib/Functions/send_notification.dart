import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:heybuddy/Notification/get_server_key.dart';


Future<void> sendNotification({
  required String myUid,required String fToken, required String name, required String imageUrl,required String body
}) async{
      const String url =
        'https://fcm.googleapis.com/v1/projects/facebook-42691/messages:send';

    // Define the notification payload
    final Map<String, dynamic> payload = {
      "message": {
        "token": fToken,
        "notification": {
          "body": body,
          "title": name,
        },
        "android": {
          "notification": {"image": imageUrl}
        },
        "data": {'uid': myUid},
      }
    };

    final accessToken = await GetServerKey().serverKey();
    await http.post(
      Uri.parse(url),
      body: json.encode(payload),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $accessToken',
      },
    );

}