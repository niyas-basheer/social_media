

import 'package:flutter/material.dart';
import 'package:test_server_app/features/app/const/page_const.dart';
import 'package:test_server_app/features/app/home/contacts_page.dart';
import 'package:test_server_app/features/app/settings/settings_page.dart';
import 'package:test_server_app/features/call/domain/entities/call_entity.dart';
import 'package:test_server_app/features/call/presentation/pages/call_contacts_page.dart';
import 'package:test_server_app/features/call/presentation/pages/call_page.dart';
import 'package:test_server_app/features/chat/domian/entities/message_entity.dart';
import 'package:test_server_app/features/chat/presentation/pages/single_chat_page.dart';
import 'package:test_server_app/features/user/domain/entities/user_entity.dart';
import 'package:test_server_app/features/user/presentation/pages/edit_profile_page.dart';


class OnGenerateRoute {


  static Route<dynamic>? route(RouteSettings settings) {
    final args = settings.arguments;
    final name = settings.name;

    switch (name) {
      case PageConst.contactUsersPage:
        {
          if(args is String) {
            return materialPageBuilder(ContactsPage(uid: args,));

          } else {
            return materialPageBuilder( const ErrorPage());

          }
        }
      case PageConst.settingsPage: {
        if(args is String) {
          return materialPageBuilder( SettingsPage(uid: args));
        } else {
          return materialPageBuilder( const ErrorPage());
        }
      }
      case PageConst.editProfilePage: {
        if(args is UserEntity) {
          return materialPageBuilder( EditProfilePage(currentUser: args));
        } else {
          return materialPageBuilder( const ErrorPage());
        }
      }
      case PageConst.callContactsPage: {
        return materialPageBuilder(const CallContactsPage());

      }
      // case PageConst.myStatusPage: {
      //   if(args is StatusEntity) {
      //     return materialPageBuilder( MyStatusPage(status: args));
      //   } else {
      //     return materialPageBuilder( const ErrorPage());
      //   }
      // }
      case PageConst.callPage: {
        if(args is CallEntity) {
          return materialPageBuilder( CallPage(callEntity: args));
        } else {
          return materialPageBuilder( const ErrorPage());
        }
      }
      case PageConst.singleChatPage: {
        if(args is MessageEntity) {
          return materialPageBuilder( SingleChatPage(message: args));
        } else {
          return materialPageBuilder( const ErrorPage());
        }

      }
    }
    return null;


   }

  }

dynamic materialPageBuilder(Widget child) {
  return MaterialPageRoute(builder: (context) => child);
}

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Error"),
      ),
      body: const Center(
        child: Text("Error"),
      ),
    );
  }
}
