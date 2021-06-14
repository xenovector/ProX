import '../Api/response.dart';

class NotificationData extends RData {
  final String title;
  final String message;
  final String id;
  final Map<String, dynamic>? payload;

  NotificationData(this.title, this.message, this.id, {this.payload});
}