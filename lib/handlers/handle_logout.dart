import 'package:qr_earth/network/session.dart';
import 'package:qr_earth/router/router.dart';
import 'package:qr_earth/utils/global.dart';

void handleLogout({String? message}) {
  // Clear user session
  Session.clear();
  // Clear user data
  Global.user.clear();
  // Navigate to login screen
  appRouter.goNamed("login", queryParameters: {"message": message});
}
