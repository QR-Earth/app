import 'package:qr_earth/scanner/pages/scanner_page.dart';
import 'package:qr_earth/scanner/pages/scanner_success.dart';
import 'package:go_router/go_router.dart';

GoRoute scannerRoute = GoRoute(
  name: "scanner",
  path: "/scanner",
  pageBuilder: (context, state) => const NoTransitionPage(
    child: ScannerPage(),
  ),
  routes: [
    GoRoute(
      name: "scanner_success",
      path: "success",
      pageBuilder: (context, state) => const NoTransitionPage(
        child: ScannerSuccessPage(),
      ),
    ),
  ],
);
