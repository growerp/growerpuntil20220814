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

import 'package:core/domains/common/functions/helper_functions.dart';
import 'package:core/services/api_result.dart';
import 'package:core/widgets/dialogCloseButton.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:core/domains/domains.dart';

class ChatRoomDialog extends StatelessWidget {
  final FormArguments formArguments;
  const ChatRoomDialog({Key? key, required this.formArguments})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChatRoomPage(
        formArguments.message, formArguments.object as ChatRoom?);
  }
}

class ChatRoomPage extends StatefulWidget {
  final String? message;
  final ChatRoom? chatRoom;
  ChatRoomPage(this.message, this.chatRoom);
  @override
  _ChatRoomState createState() => _ChatRoomState(message, chatRoom);
}

class _ChatRoomState extends State<ChatRoomPage> {
  final String? message;
  final ChatRoom? chatRoom;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _chatRoomSearchBoxController = TextEditingController();
  TextEditingController _userSearchBoxController = TextEditingController();

  bool loading = false;
  User? _selectedUser;
  Authenticate? authenticate;

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  _ChatRoomState(this.message, this.chatRoom) {
    HelperFunctions.showTopMessage(scaffoldMessengerKey, message);
  }

  @override
  void initState() {
    super.initState();
    if (chatRoom != null) {
      _nameController.text = chatRoom!.chatRoomName ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isPhone = ResponsiveWrapper.of(context).isSmallerThan(TABLET);
    var repos = context.read<Object>();
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      if (state.status == AuthStatus.authenticated)
        authenticate = state.authenticate!;
      return BlocConsumer<ChatRoomBloc, ChatRoomState>(
          listener: (context, state) {
        if (state.status == ChatRoomStatus.failure) {
          loading = false;
          HelperFunctions.showMessage(context, '${state.message}', Colors.red);
        }
        if (state.status == ChatRoomStatus.success) {
          HelperFunctions.showMessage(
              context, '${state.message}', Colors.green);
          Navigator.of(context).pop();
        }
      }, builder: (BuildContext context, state) {
        return Container(
            padding: EdgeInsets.all(20),
            child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: GestureDetector(
                    onTap: () {},
                    child: Dialog(
                      key: Key('ChatRoomDialog'),
                      insetPadding: EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Stack(clipBehavior: Clip.none, children: <Widget>[
                        Container(
                            padding: EdgeInsets.all(20),
                            width: 500,
                            height: 500,
                            child: ScaffoldMessenger(
                                key: scaffoldMessengerKey,
                                child: Scaffold(
                                  backgroundColor: Colors.transparent,
                                  body:
                                      _showForm(authenticate!, repos, isPhone),
                                ))),
                        Positioned(
                            top: -10, right: -10, child: DialogCloseButton())
                      ]),
                    ))));
      });
    });
  }

  Widget _showForm(Authenticate authenticate, var repos, bool isPhone) {
    return Center(
        child: Container(
            child: Form(
                key: _formKey,
                child: ListView(key: Key('listView'), children: <Widget>[
                  Center(
                      child: Text(
                          "Chat# " +
                              (chatRoom == null
                                  ? "New"
                                  : "${chatRoom!.chatRoomName}"),
                          style: TextStyle(
                              fontSize: isPhone ? 10 : 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold))),
                  SizedBox(height: 30),
                  DropdownSearch<User>(
                    key: Key('userDropDown'),
                    popupShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    label: 'Private chat with Other User',
                    dialogMaxWidth: 300,
                    autoFocusSearchBox: true,
                    selectedItem: _selectedUser,
                    dropdownSearchDecoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0)),
                    ),
                    searchBoxDecoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0)),
                    ),
                    showSearchBox: true,
                    searchBoxController: _userSearchBoxController,
                    isFilteredOnline: true,
                    showClearButton: false,
                    itemAsString: (User? u) => "${u!.firstName} ${u.lastName}",
                    onFind: (String filter) async {
                      ApiResult<List<User>> result = await repos.getUser(
                          filter: _chatRoomSearchBoxController.text);
                      return result.when(
                          success: (data) => data,
                          failure: (_) => [User(lastName: 'get data error!')]);
                    },
                    validator: (value) =>
                        _nameController.text.isEmpty && value == null
                            ? 'field required'
                            : null,
                    onChanged: (User? newValue) {
                      _selectedUser = newValue;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                      key: Key('update'),
                      child: Text(
                          chatRoom?.chatRoomId == null ? 'Create' : 'Update'),
                      onPressed: () async {
                        if (_formKey.currentState!.validate() && !loading) {
                          ChatRoom newChatRoom = ChatRoom(
                              chatRoomId: chatRoom != null
                                  ? chatRoom!.chatRoomId
                                  : null,
                              chatRoomName: _nameController.text.isEmpty
                                  ? null
                                  : _nameController.text,
                              isPrivate: _selectedUser != null ? true : false,
                              members: []);
                          newChatRoom.members.add(ChatRoomMember(
                              member: authenticate.user!,
                              hasRead: true,
                              isActive: true));
                          if (_selectedUser != null)
                            newChatRoom.members.add(ChatRoomMember(
                                member: _selectedUser!,
                                hasRead: false,
                                isActive: true));
                          if (newChatRoom.chatRoomId == null)
                            BlocProvider.of<ChatRoomBloc>(context).add(
                                ChatRoomCreate(
                                    newChatRoom, authenticate.user!.userId!));
                          else
                            BlocProvider.of<ChatRoomBloc>(context).add(
                                ChatRoomUpdate(
                                    newChatRoom, authenticate.user!.userId!));
                        }
                      }),
                ]))));
  }
}
