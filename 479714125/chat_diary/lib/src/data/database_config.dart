import 'database_provider.dart';
import 'firebase_db.dart';

class DatabaseAccess {
  DatabaseAccess._();

  static final DatabaseAccess instance = DatabaseAccess._();

  final DatabaseProvider _databaseProvider = DatabaseProvider();

  DatabaseProvider get databaseProvider => _databaseProvider;

  final FirebaseDBProvider _firebaseDBProvider = FirebaseDBProvider();

  FirebaseDBProvider get firebaseDBProvider => _firebaseDBProvider;
}
