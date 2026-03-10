import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:http/http.dart' as http;

class GoogleDriveSession {
  const GoogleDriveSession({
    required this.account,
    required this.api,
  });

  final GoogleSignInAccount account;
  final drive.DriveApi api;

  String get accountKey {
    final id = account.id.trim();
    if (id.isNotEmpty) return id;
    return account.email.trim();
  }
}

class GoogleAccountHelper {
  GoogleAccountHelper._();

  static final GoogleSignIn _trialSignIn = GoogleSignIn(
    scopes: [drive.DriveApi.driveAppdataScope],
  );

  static final GoogleSignIn _backupSignIn = GoogleSignIn(
    scopes: [drive.DriveApi.driveFileScope],
  );

  static Future<GoogleDriveSession?> trialDriveSession({
    bool interactive = false,
  }) {
    return _sessionFor(_trialSignIn, interactive: interactive);
  }

  static Future<GoogleDriveSession?> backupDriveSession({
    bool interactive = false,
  }) {
    return _sessionFor(_backupSignIn, interactive: interactive);
  }

  static Future<GoogleDriveSession?> _sessionFor(
    GoogleSignIn signIn, {
    required bool interactive,
  }) async {
    GoogleSignInAccount? account = signIn.currentUser;
    account ??= await signIn.signInSilently();
    if (account == null && interactive) {
      account = await signIn.signIn();
    }
    if (account == null) return null;

    final headers = await account.authHeaders;
    return GoogleDriveSession(
      account: account,
      api: drive.DriveApi(_GoogleAuthClient(headers)),
    );
  }
}

class _GoogleAuthClient extends http.BaseClient {
  _GoogleAuthClient(this._headers);

  final Map<String, String> _headers;
  final http.Client _inner = http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(_headers);
    return _inner.send(request);
  }
}
