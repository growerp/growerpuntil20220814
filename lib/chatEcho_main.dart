/*
 * This GrowERP software is in the public domain under CC0 1.0 Universal plus a
 * Grant of Patent License.
 * 
 * To the extent possible under law, the author(s) have dedicated all
 * copyright and related and neighboring rights to this software to the
 * public domain worldwide. This software is distributed without any
 * warranty.
 * 
 * You should have received a copy of the CC0 Public Domain Dedication
 * along with this software (see the LICENSE.md file). If not, see
 * <http://creativecommons.org/publicdomain/zero/1.0/>.
 */

// start with: flutter run -t lib/chatEcho_app.dart

import 'dart:async';

import 'package:core/domains/common/common.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:global_configuration/global_configuration.dart';
import 'generated/l10n.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:core/api_repository.dart';
import 'package:core/services/chat_server.dart';
import 'package:core/styles/themes.dart';
import 'router.dart' as router;
import 'package:flutter_test/flutter_test.dart';
import 'package:core/domains/domains.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GlobalConfiguration().loadFromAsset("app_settings");

  var dbServer = APIRepository();
  ChatServer chatServer = ChatServer();

  runApp(Phoenix(child: ChatApp(dbServer: dbServer, chatServer: chatServer)));
}

class ChatApp extends StatelessWidget {
  const ChatApp({Key? key, required this.dbServer, required this.chatServer})
      : super(key: key);

  final Object dbServer;
  final ChatServer chatServer;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => dbServer),
        RepositoryProvider(create: (context) => chatServer),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
              create: (context) =>
                  AuthBloc(dbServer, chatServer)..add(AuthLoad()),
              lazy: false),
          BlocProvider<ChatRoomBloc>(
            create: (context) => ChatRoomBloc(
                dbServer, chatServer, BlocProvider.of<AuthBloc>(context))
              ..add(ChatRoomFetch()),
          ),
          BlocProvider<ChatMessageBloc>(
            create: (context) => ChatMessageBloc(
                dbServer, chatServer, BlocProvider.of<AuthBloc>(context)),
            lazy: false,
          ),
        ],
        child: MyChatApp(),
      ),
    );
  }
}

class MyChatApp extends StatelessWidget {
  static String title = "GrowERP Chat echo.";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        builder: (context, widget) => ResponsiveWrapper.builder(
            BouncingScrollWrapper.builder(context, widget!),
            maxWidth: 2460,
            minWidth: 450,
            defaultScale: true,
            breakpoints: [
              ResponsiveBreakpoint.resize(450, name: MOBILE),
              ResponsiveBreakpoint.autoScale(800, name: TABLET),
              ResponsiveBreakpoint.resize(1200, name: DESKTOP),
              ResponsiveBreakpoint.autoScale(2460, name: "4K"),
            ],
            background: Container(color: Color(0xFFF5F5F5))),
        theme: Themes.formTheme,
        onGenerateRoute: router.generateRoute,
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state.status == AuthStatus.failure)
              return FatalErrorForm("Internet or server problem?");
            if (state.status == AuthStatus.authenticated)
              return HomeForm(
                  message: state.message, menuItems: menuItems, title: title);
            if (state.status == AuthStatus.unAuthenticated)
              return HomeForm(
                  message: state.message, menuItems: menuItems, title: title);
            if (state.status == AuthStatus.changeIp) return ChangeIpForm();
            return SplashForm();
          },
        ));
  }
}

List<MenuItem> menuItems = [
  MenuItem(
    image: "assets/images/dashBoardGrey.png",
    selectedImage: "assets/images/dashBoard.png",
    title: "Main",
    route: '/',
    readGroups: ["GROWERP_M_ADMIN", "GROWERP_M_EMPLOYEE", "ADMIN"],
    writeGroups: ["GROWERP_M_ADMIN", "ADMIN"],
    child: ChatRooms(),
  ),
  MenuItem(
    image: "assets/images/dashBoardGrey.png",
    selectedImage: "assets/images/dashBoard.png",
    title: "Main",
    route: '/',
    readGroups: ["GROWERP_M_ADMIN", "GROWERP_M_EMPLOYEE", "ADMIN"],
    writeGroups: ["GROWERP_M_ADMIN", "ADMIN"],
    child: ChatRooms(),
  ),
];

class ChatRooms extends StatefulWidget {
  @override
  _ChatRoomsState createState() => _ChatRoomsState();
}

class _ChatRoomsState extends State<ChatRooms> {
  late ChatRoomBloc _chatRoomBloc;
  List<ChatMessage> messages = [];
  Authenticate authenticate = Authenticate();
  late ChatMessageBloc _chatMessageBloc;
  List<ChatRoom> chatRooms = [];
  int limit = 20;
  late bool search;
  String? searchString;
  String classificationId = GlobalConfiguration().getValue("classificationId");
  late String entityName;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    entityName = classificationId == 'AppHotel' ? 'Room' : 'ChatRoom';
    _chatRoomBloc = BlocProvider.of<ChatRoomBloc>(context)
      ..add(ChatRoomFetch(limit: limit));
    search = false;
    limit = 20;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      if (state.status == AuthStatus.authenticated) {
        authenticate = state.authenticate!;
        return BlocBuilder<ChatRoomBloc, ChatRoomState>(
            builder: (context, state) {
          if (state.status == ChatRoomStatus.success) {
            chatRooms = state.chatRooms;
            if (chatRooms.length == 0)
              return Center(
                  heightFactor: 20,
                  child: Text("waiting for chats to arrive....",
                      key: Key('empty'), textAlign: TextAlign.center));
            // receive chat message (caused chatroom added on the list)
            _chatMessageBloc = BlocProvider.of<ChatMessageBloc>(context)
              ..add(ChatMessageFetch(
                  chatRoomId: chatRooms[0].chatRoomId!, limit: limit));
            return BlocBuilder<ChatMessageBloc, ChatMessageState>(
                builder: (context, state) {
              if (state.status == ChatMessageStatus.success) {
                messages = state.chatMessages;
                if (messages.length > 0) {
                  // echo message
                  print("####receive => echo message");
                  _chatMessageBloc.add(ChatMessageSendWs(WsChatMessage(
                      toUserId:
                          chatRooms[0].getToUserId(authenticate.user!.userId!),
                      fromUserId: authenticate.user!.userId!,
                      chatRoomId: chatRooms[0].chatRoomId,
                      content: messages[0].content!)));
                  // remove chat room from list, reset isActive flag
                  print("#### remove room from list");
                  int ind =
                      chatRooms[0].getMemberIndex(authenticate.user!.userId!);
                  // new member with update
                  ChatRoomMember newMember = chatRooms[0]
                      .members[ind]
                      .copyWith(isActive: false, hasRead: true);
                  List<ChatRoomMember> newMembers = chatRooms[0].members;
                  newMembers[ind] = newMember;
                  // copy members pdate copy
                  _chatRoomBloc.add(
                    ChatRoomUpdate(chatRooms[0].copyWith(members: newMembers),
                        authenticate.user!.userId!),
                  );
                }
              }
              Timer(Duration(seconds: 1), () => print("== wait a second==="));
              return Center(child: Text(" processing"));
            });
          } else
            return Center(child: Text(" processing"));
        });
      }
      return Container(child: Center(child: Text("Not Authorized!")));
    });
  }
}
/*
Future<void> main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await GlobalConfiguration().loadFromAsset("app_settings");
    Bloc.observer = SimpleBlocObserver();
  });

  tearDown(() async => {
        // not tear down, control C to stop
        await Future.delayed(Duration(seconds: 1000000))
      });

  testWidgets("create chat echo for user John doe>>>>>",
      (WidgetTester tester) async {
    await tester.pumpWidget(ChatApp(
        dbServer: MoquiServer(client: Dio()), chatServer: ChatServer()));
    await tester.pumpAndSettle(Duration(seconds: 10));
    try {
      expect(find.byKey(Key('HomeFormUnAuth')), findsOneWidget);
      await Test.tap(tester, 'loginButton');
      await tester.pump(Duration(seconds: 1));
      await Test.enterText(tester, 'username', 'test@example.com');
      await Test.enterText(tester, 'password', 'qqqqqq9!');
      await Test.tap(tester, 'login');
      await tester.pumpAndSettle(Duration(seconds: 5));
    } catch (_) {
      print("already logged in, fine!");
    }
  });
}
*/
