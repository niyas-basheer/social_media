import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' as path;
import 'package:test_server_app/features/app/const/app_const.dart';
import 'package:test_server_app/features/app/const/page_const.dart';
import 'package:test_server_app/features/app/home/contacts_page.dart';
import 'package:test_server_app/features/chat/presentation/pages/chat_page.dart';
import 'package:test_server_app/features/status/presentation/pages/status_page.dart';
import 'package:test_server_app/features/user/data/data_sources/remote/user_remote_sharedprefs.dart';
import 'package:test_server_app/features/call/presentation/cubits/my_call_history/my_call_history_cubit.dart';
import 'package:test_server_app/features/app/global/widgets/show_image_and_video_widget.dart';
import 'package:test_server_app/features/app/theme/style.dart';
import 'package:test_server_app/features/user/data/models/user_model.dart';
import 'package:test_server_app/features/user/domain/entities/user_entity.dart';
import 'package:test_server_app/features/user/presentation/cubit/get_single_user/get_single_user_cubit.dart';
import 'package:test_server_app/features/user/presentation/cubit/user/user_cubit.dart';
import 'package:test_server_app/features/call/presentation/pages/calls_history_page.dart';

class HomePage extends StatefulWidget {
  final String uid;
  final int? index;

  const HomePage({super.key, required this.uid, this.index});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin, WidgetsBindingObserver {

  TabController? _tabController;
  int _currentTabIndex = 0;
 String uid='';
  SharedPrefs sharedPrefs = SharedPrefs();
Future<String>getuserid()async{
     uid =  await sharedPrefs.getUid()??'';
    return uid;
  }
  @override
  void initState() {
    getuserid();
    BlocProvider.of<GetSingleUserCubit>(context).getSingleUser(uid: widget.uid);
     BlocProvider.of<MyCallHistoryCubit>(context).getMyCallHistory(uid: uid);

    WidgetsBinding.instance.addObserver(this);
    _tabController = TabController(length: 3, vsync: this);

    _tabController!.addListener(() {
      setState(() {
        _currentTabIndex = _tabController!.index;
      });
    });

    if (widget.index != null) {
      setState(() {
        _currentTabIndex = widget.index!;
        _tabController!.animateTo(1);
      });
    }
    super.initState();
  }

 

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        BlocProvider.of<UserCubit>(context).updateUser(
            user: UserModel(
                uid: uid,
                isOnline: true
            )
        );
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
        BlocProvider.of<UserCubit>(context).updateUser(
            user: UserModel(
                uid: uid,
                isOnline: false
            )
        );
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }



  List<File>? _selectedMedia;
  List<String>? _mediaTypes; 

  Future<void> selectMedia() async {
    setState(() {
      _selectedMedia = null;
      _mediaTypes = null;
    });

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.media,
        allowMultiple: true,
      );
      if (result != null) {
        _selectedMedia = result.files.map((file) => File(file.path!)).toList();

      
        _mediaTypes = List<String>.filled(_selectedMedia!.length, '');

       
        for (int i = 0; i < _selectedMedia!.length; i++) {
          String extension = path.extension(_selectedMedia![i].path)
              .toLowerCase();
          if (extension == '.jpg' || extension == '.jpeg' ||
              extension == '.png') {
            _mediaTypes![i] = 'image';
          } else if (extension == '.mp4' || extension == '.mov' ||
              extension == '.avi') {
            _mediaTypes![i] = 'video';
          }
        }

        setState(() {});
      } else {
      }
    } catch (e) {
      toast(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetSingleUserCubit, GetSingleUserState>(
      builder: (context, state) {
        if(state is GetSingleUserLoaded) {
          final currentUser = state.singleUser;
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                "Learn",
                style: TextStyle(
                    fontSize: 20,
                    color: greyColor,
                    fontWeight: FontWeight.w600),
              ),
              actions: [
                Row(
                  children: [
                    const SizedBox(
                      width: 25,
                    ),
                    const Icon(Icons.search, color: greyColor, size: 28),
                    const SizedBox(
                      width: 10,
                    ),
                    PopupMenuButton<String>(
                      icon: const Icon(
                        Icons.more_vert,
                        color: greyColor,
                        size: 28,
                      ),
                      color: appBarColor,
                      iconSize: 28,
                      onSelected: (value) {},
                      itemBuilder: (context) =>
                      <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          value: "Settings",
                          child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, PageConst.settingsPage, arguments: widget.uid);
                              },
                              child: const Text('Settings')),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
              bottom: TabBar(
                labelColor: tabColor,
                unselectedLabelColor: greyColor,
                indicatorColor: tabColor,
                controller: _tabController,
                tabs: const [
                  Tab(
                    child: Text(
                      "Chats",
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Status",
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Calls",
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],

              ),
            ),
            
            
            floatingActionButton: switchFloatingActionButtonOnTabIndex(
                _currentTabIndex, currentUser),
                
            body: TabBarView(
              controller: _tabController,
              children: [
                
                ChatPage(uid: uid),
                StatusPage(currentUser: currentUser),
                CallHistoryPage(currentUser: currentUser,),
              ],
            ),
          );

        }
        return const Center(
          child: CircularProgressIndicator(
            color: tabColor,
          ),
        );
      },
    );
  }

  switchFloatingActionButtonOnTabIndex(int index, UserEntity currentUser) {
    switch (index) {
      case 0:
        {
          return FloatingActionButton(
            backgroundColor: tabColor,
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) =>  ContactsPage(uid: uid,)));
              Navigator.pushNamed(context, PageConst.contactUsersPage, arguments: uid);
            },
            child: const Icon(
              Icons.message,
              color: Colors.white,
            ),
          );
        }
      case 1:
        {
          return FloatingActionButton(
            backgroundColor: tabColor,
            onPressed: () {
              selectMedia().then(
                    (value) {
                  if (_selectedMedia != null && _selectedMedia!.isNotEmpty) {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      isDismissible: false,
                      enableDrag: false,
                      context: context,
                      builder: (context) {
                        return ShowMultiImageAndVideoPickedWidget(
                          selectedFiles: _selectedMedia!,
                          onTap: () {
                            //_uploadImageStatus(currentUser);
                            Navigator.pop(context);
                          },
                        );
                      },
                    );
                  }
                },
              );
            },
            child: const Icon(
              Icons.camera_alt,
              color: Colors.white,
            ),
          );
        }
      case 2:
        {
          return FloatingActionButton(
            backgroundColor: tabColor,
            onPressed: () {
               Navigator.pushNamed(context, PageConst.callContactsPage);
            },
            child: const Icon(
              Icons.add_call,
              color: Colors.white,
            ),
          );
        }
      default:
        {
          return FloatingActionButton(
            backgroundColor: tabColor,
            onPressed: () {},
            child: const Icon(
              Icons.message,
              color: Colors.white,
            ),
          );
        }
    }
  }

  

}
