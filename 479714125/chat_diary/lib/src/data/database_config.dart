import 'database_provider.dart';
import 'firebase_db.dart';

abstract class DatabaseAccess {
  static final DatabaseProvider databaseProvider = DatabaseProvider();
  static final FirebaseDBProvider firebaseDBProvider = FirebaseDBProvider();
}
