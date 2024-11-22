import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_server_app/features/app/const/page_const.dart';
import 'package:test_server_app/features/app/theme/style.dart';
import 'package:test_server_app/features/user/data/data_sources/remote/user_remote_sharedprefs.dart';
import 'package:test_server_app/features/user/presentation/cubit/get_device_number/get_device_number_cubit.dart';
import 'package:test_server_app/features/user/presentation/cubit/get_single_user/get_single_user_cubit.dart';
import 'package:test_server_app/features/user/presentation/cubit/user/user_cubit.dart';
import 'package:test_server_app/features/chat/domian/entities/message_entity.dart';
import '../global/widgets/profile_widget.dart';

class ContactsPage extends StatefulWidget {
   final String uid;

  const ContactsPage({super.key, required this.uid});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<UserCubit>(context).getAllUsers();
    BlocProvider.of<GetSingleUserCubit>(context).getSingleUser(uid: widget.uid);
    BlocProvider.of<GetDeviceNumberCubit>(context).getDeviceNumber(); 
  }
  String uid='';
  SharedPrefs sharedPrefs = SharedPrefs();
Future<String>getuserid()async{

     uid =  await sharedPrefs.getUid()??'';
  
    return uid;
  }
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Contacts"),
      ),
      body: Column(
        children: [
          BlocBuilder<GetSingleUserCubit, GetSingleUserState>(
            builder: (context, state) {
              if (state is GetSingleUserLoaded) {
                final currentUser = state.singleUser;

                return BlocBuilder<UserCubit, UserState>(
                  builder: (context, state) {
                    if (state is UserLoaded) {
                      final contacts = state.users.where((user) => user.uid != uid).toList();

                      if (contacts.isEmpty) {
                        return const Center(
                          child: Text("No Contacts Yet",style: TextStyle(color:Colors.blue),),
                        );
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: contacts.length,
                        itemBuilder: (context, index) {
                          final contact = contacts[index];
                          return ListTile(
                            onTap: () {
                              Navigator.pushNamed(context, PageConst.singleChatPage,
                                  arguments: MessageEntity(
                                    senderUid: currentUser.uid,
                                    recipientUid: contact.uid,
                                    senderName: currentUser.username,
                                    recipientName: contact.username,
                                    senderProfile: currentUser.profileUrl,
                                    recipientProfile: contact.profileUrl,
                                    uid: uid
                                  ));
                            },
                            leading: SizedBox(
                              width: 50,
                              height: 50,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
                                   child: profileWidget(imageUrl: contact.profileUrl)
                              ),
                            ),
                            title: Text("${contact.username}",style: TextStyle(color:Colors.blue),),
                            subtitle: Text("${contact.status}"),
                          );
                        },
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
              return const Center(
                child: CircularProgressIndicator(
                  color: tabColor,
                ),
              );
            },
          ),
          Expanded(
            child: BlocBuilder<GetDeviceNumberCubit, GetDeviceNumberState>(
              builder: (context, state) {
                if (state is GetDeviceNumberLoaded) {
                  final contacts = state.contacts;

                  return ListView.builder(
                    itemCount: contacts.length,
                    itemBuilder: (context, index) {
                      final contact = contacts[index];
                      return ListTile(
                        leading: SizedBox(
                          width: 50,
                          height: 50,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: Image.memory(
                              contact.photo ?? Uint8List(0),
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset('assets/profile_default.png'); 
                              },
                            ),
                          ),
                        ),
                        title: Text("${contact.name!.first} ${contact.name!.last}",style: TextStyle(color:Colors.blue),),
                        subtitle: const Text("Hey there! I'm using WhatsApp"),
                      );
                    },
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(
                    color: tabColor,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
