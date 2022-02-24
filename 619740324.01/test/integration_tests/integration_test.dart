import 'package:my_project/data/database_provider.dart';
import 'package:my_project/data/shared_preferences_provider.dart';
import 'package:my_project/note.dart';
import 'package:my_project/pages/home_page/home_page.dart';
import 'package:my_project/pages/home_page/cubit_home_page.dart';
import 'package:my_project/pages/create_page/create_page.dart';
import 'package:my_project/main.dart' as app;
import 'package:my_project/pages/event_page/event_page.dart';
import 'package:my_project/pages/settings_page/settings_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:firebase_database_mocks/firebase_database_mocks.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


typedef Callback = void Function(MethodCall call);

class FirebaseAuthMock extends Mock implements FirebaseAuth {}

class MockDatabaseProvider extends Mock implements DatabaseProvider {}

void setupFirebaseAuthMocks([Callback? customHandlers]) {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelFirebase.channel.setMockMethodCallHandler((call) async {
    if (call.method == 'Firebase#initializeCore') {
      return [
        {
          'name': defaultFirebaseAppName,
          'options': {
            'apiKey': '123',
            'appId': '123',
            'messagingSenderId': '123',
            'projectId': '123',
          },
          'pluginConstants': {},
        }
      ];
    }
    if (call.method == 'Firebase#initializeApp') {
      return {
        'name': call.arguments['appName'],
        'options': call.arguments['options'],
        'pluginConstants': {},
      };
    }
    if (customHandlers != null) {
      customHandlers(call);
    }
    return null;
  });
}

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  FirebaseDatabase firebaseDatabase;
  FirebaseStorage firebaseStorage;
  SharedPreferences.setMockInitialValues({});
  const MethodChannel('plugins.flutter.io/firebase_core')
      .setMockMethodCallHandler((methodCall) async {
    if (methodCall.method == 'getAll') {
      return <String, dynamic>{};
    }
    return null;
  });
  setupFirebaseAuthMocks();

  const fakeData = {
    'Notes': {
      '-MuQH1RW49wgDSTIlWax': {
        'Events': {
          '332cbef9-1b84-4d6f-9bb5-34e349a4c655': {
            'bookmark_index': 0,
            'date_format': 'Feb 8, 2022',
            'event_circle_avatar': -1,
            'event_id': "332cbef9-1b84-4d6f-9bb5-34e349a4c655",
            'image_path': "",
            'note_id': "-MuQH1RW49wgDSTIlWax",
            'text': "#74; jdnr",
            'time': "4:43:53 PM"
          }
        },
        'circle_avatar_index': 6,
        'date_format': 'Jan 27, 2022',
        'id': 'MuQH1RW49wgDSTIlWax',
        'name': 'лвп',
        'sub_tittle_name': 'gg'
      },
      '-MuQH1RW49wgDSTIlWar': {
        'Events': {
          '332cbef9-1b84-4d6f-9bb5-34e349a4c666': {
            'bookmark_index': 0,
            'date_format': 'Feb 2, 2022',
            'event_circle_avatar': -1,
            'event_id': "332cbef9-1b84-4d6f-9bb5-34e349a4c666",
            'image_path': "",
            'note_id': "-MuQH1RW49wgDSTIlWar",
            'text': "sc",
            'time': "4:43:53 PM"
          }
        },
        'circle_avatar_index': 5,
        'date_format': 'Jan 22, 2022',
        'id': 'MuQH1RW49wgDSTIlWar',
        'name': 'dsr',
        'sub_tittle_name': 'xc'
      },
    },
  };

  MockFirebaseDatabase.instance.ref().set(fakeData);

  setUpAll(() async {
    await Firebase.initializeApp();
    firebaseDatabase = MockFirebaseDatabase.instance;
    firebaseStorage = MockFirebaseStorage();
  });

  final noteList = [
    Note(
      eventName: 'se',
      id: '',
      date: 'Feb 5, 2022',
      indexOfCircleAvatar: 3,
      subTittleEvent: 'Add event',
    ),
    Note(
      eventName: 'se',
      id: '',
      date: 'Feb 2, 2022',
      indexOfCircleAvatar: 3,
      subTittleEvent: 'Add event',
    ),
  ];

  final futureNoteList = Future<List<Note>>(() {
    return noteList;
  });

  late DatabaseProvider databaseProvider;

  group('end-to-end test', () {
    setUp(() {
      databaseProvider = MockDatabaseProvider();
    });

    testWidgets('tap on the floating action button go to CreatePage',
        (tester) async {
      when(databaseProvider.dbNotesList()).thenReturn(futurePageList);
      app.main();
      await tester.pumpAndSettle();
      expect(find.byKey(Key('text')), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
      expect(find.byType(HomePage), findsOneWidget);
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
        expect(find.byType(CreatePage), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byType(CircleAvatar), findsNWidgets(10));
      await tester.enterText(find.byType(TextField), 'Some text to input');
      expect(find.text('Some text to input'), findsOneWidget);
      await tester.pumpAndSettle();
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
       expect(find.byType(HomePage), findsOneWidget);
    });

    testWidgets('tap on the settings button from Drawer', (tester) async {
      when(databaseProvider.dbNotesList()).thenReturn(futureNoteList);
      app.main();
      await tester.pumpAndSettle();
      expect(find.byKey(Key('text')), findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.byKey(Key('Home')), findsOneWidget);
      expect(find.byType(HomePage), findsOneWidget);
      await tester.tap(find.byType(Drawer));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('settings'));
      await tester.pumpAndSettle();
      expect(find.byType(SettingsPage), findsOneWidget);
    });
  });
}
