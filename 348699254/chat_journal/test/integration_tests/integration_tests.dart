import 'package:chat_journal_cubit/data/models/activity_page.dart';
import 'package:chat_journal_cubit/data/repository/page_repository.dart';
import 'package:chat_journal_cubit/main.dart' as app;
import 'package:chat_journal_cubit/pages/add_page/add_page_screen.dart';
import 'package:chat_journal_cubit/pages/main_page/main_page_screen.dart';
import 'package:chat_journal_cubit/pages/settings/settings_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database_mocks/firebase_database_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef Callback = void Function(MethodCall call);

class FirebaseAuthMock extends Mock implements FirebaseAuth {}

class MockActivityPageRepository extends Mock
    implements ActivityPageRepository {}

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
  SharedPreferences.setMockInitialValues({});
  const MethodChannel('plugins.flutter.io/shared_preferences')
      .setMockMethodCallHandler((methodCall) async {
    if (methodCall.method == 'getAll') {
      return <String, dynamic>{};
    }
    return null;
  });
  setupFirebaseAuthMocks();

  const fakeData = {
    'activity_pages': {
      '01280de7-f94b-43a6-8f6f-b0f65da04177': {
        '-MrxFdbC7wIa44z5TFFC': {
          'creation_date': '2021-12-27 18:59:00.173343',
          'icon_index': 0,
          'id': '01280de7-f94b-43a6-8f6f-b0f65da04177',
          'is_pinned': 0,
          'name': 'gg'
        }
      },
      '5b674b17-5812-4edb-b53c-4afdf3999384': {
        '-MrWNDIreESE6T0qbWF8': {
          'creation_date': '2021-12-22 09:02:43.447602',
          'icon_index': 1,
          'id': '5b674b17-5812-4edb-b53c-4afdf3999384',
          'is_pinned': 0,
          'name': '3'
        }
      },
      '7ca8c502-01ec-49a1-a457-460aa7b4a4f7': {
        '-MrWNAqf2LBuwUZWdpXB': {
          'creation_date': '2021-12-22 09:02:33.387071',
          'icon_index': 2,
          'id': '7ca8c502-01ec-49a1-a457-460aa7b4a4f7',
          'is_pinned': 0,
          'name': '2'
        }
      },
      'b9ff3b0c-155e-43f9-870d-49379a5a44ef': {
        '-MrWNFJJaLDksytvGjPf': {
          'creation_date': '2021-12-22 09:02:51.668738',
          'icon_index': 13,
          'id': 'b9ff3b0c-155e-43f9-870d-49379a5a44ef',
          'is_pinned': 0,
          'name': '4'
        }
      },
      'd267b8ca-08c2-4154-a1ba-ed575fcbf53c': {
        '-MrxFbOu2HT82CIPrTtk': {
          'creation_date': '2021-12-27 18:58:51.122737',
          'icon_index': 0,
          'id': 'd267b8ca-08c2-4154-a1ba-ed575fcbf53c',
          'is_pinned': 0,
          'name': 'wyg'
        }
      },
    },
  };

  MockFirebaseDatabase.instance.ref().set(fakeData);
  setUpAll(() async {
    await Firebase.initializeApp();
    firebaseDatabase = MockFirebaseDatabase.instance;
  });

  final pageList = [
    ActivityPage(
      id: '',
      name: 'page_1',
      iconIndex: 1,
      creationDate: '',
      isPinned: false,
    ),
    ActivityPage(
      id: '',
      name: 'page_2',
      iconIndex: 4,
      creationDate: '',
      isPinned: false,
    ),
    ActivityPage(
      id: '',
      name: 'page_3',
      iconIndex: 10,
      creationDate: '',
      isPinned: false,
    ),
  ];

  final futurePageList = Future<List<ActivityPage>>(() {
    return pageList;
  });

  late ActivityPageRepository pageRepository;

  group('end-to-end test', () {
    setUp(() {
      pageRepository = MockActivityPageRepository();
    });

    testWidgets('tap on the floating action button go to AddPageScreen',
        (tester) async {
      when(pageRepository.fetchActivityPageList()).thenReturn(futurePageList);
      app.main();
      await tester.pumpAndSettle();
      expect(find.byType(MainPageScreen), findsOneWidget);
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      expect(find.byType(AddPageScreen), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byType(GridTile), findsNWidgets(12));
      expect(find.byType(CircleAvatar), findsNWidgets(13));
      await tester.enterText(find.byType(TextField), 'Some text to input');
      expect(find.text('Some text to input'), findsOneWidget);
      await tester.pumpAndSettle();
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      expect(find.byType(MainPageScreen), findsOneWidget);
    });

    testWidgets('tap on the settings button from Burger-menu', (tester) async {
      when(pageRepository.fetchActivityPageList()).thenReturn(futurePageList);
      app.main();
      await tester.pumpAndSettle();
      expect(find.byType(MainPageScreen), findsOneWidget);
      await tester.tap(find.byType(Drawer));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();
      expect(find.byType(SettingsScreen), findsOneWidget);
      expect(find.byIcon(Icons.text_fields), findsOneWidget);
      await tester.tap(find.byIcon(Icons.text_fields));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.fingerprint), findsOneWidget);
    });
  });
}
