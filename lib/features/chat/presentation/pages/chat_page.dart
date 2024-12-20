import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:test_server_app/features/app/const/page_const.dart';
import 'package:test_server_app/features/app/global/widgets/profile_widget.dart';
import 'package:test_server_app/features/app/theme/style.dart';
import 'package:test_server_app/features/chat/domian/entities/chat_entity.dart';
import 'package:test_server_app/features/chat/domian/entities/message_entity.dart';
import 'package:test_server_app/features/chat/presentation/cubit/chat/chat_cubit.dart';


class ChatPage extends StatefulWidget {
  final String uid;
  const ChatPage({super.key, required this.uid});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  @override
  void initState() {
    
    BlocProvider.of<ChatCubit>(context).getMyChat(chat: ChatEntity(senderUid: widget.uid,participants: [widget.uid],));
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocBuilder<ChatCubit, ChatState>(
          builder: (context, state) {
            if(state is ChatLoaded) {
              final myChat = state.chatContacts;

              if(myChat.isEmpty) {
                return const Center(
                  child: Text("No Conversation Yet",style: TextStyle(color:Colors.blue)),
                );
              }

              return ListView.builder(itemCount: myChat.length, itemBuilder: (context, index) {

                final chat = myChat[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, PageConst.singleChatPage,
                        arguments: MessageEntity(
                          senderUid: chat.senderUid,
                          recipientUid:chat.recipientUid,
                          senderName: chat.senderName,
                          recipientName: chat.recipientName,
                          senderProfile: chat.senderProfile,
                          recipientProfile: chat.recipientProfile,
                          uid: widget.uid
                    ));
                  },
                  child: ListTile(
                    leading: SizedBox(
                      width: 50,
                      height: 50,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: profileWidget(imageUrl: chat.recipientProfile),
                      ),
                    ),
                    title: Text("${chat.recipientName}",style: const TextStyle(color: Colors.black),),
                    subtitle: Text("${chat.recentTextMessage}", maxLines: 1, overflow: TextOverflow.ellipsis,style: const TextStyle(color: Colors.grey )),
                    trailing: Text(
                      DateFormat.jm().format(chat.createdAt!),
                      style: const TextStyle(color: Colors.black, fontSize: 13),
                    ),
                  ),
                );
              });

            }
            return const Center(
              child: CircularProgressIndicator(
                color: tabColor,
              ),
            );
          },
        )
    );
  }
}
