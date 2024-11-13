

import 'package:get_it/get_it.dart';
import 'package:test_server_app/features/chat/chat_injection_container.dart';
import 'package:test_server_app/features/status/status_injection_container.dart';
import 'package:test_server_app/features/user/user_injection_container.dart';
import 'package:test_server_app/features/call/call_injection_container.dart';


final sl = GetIt.instance;

Future<void> init() async {

  

  await userInjectionContainer();
  await chatInjectionContainer();
  await statusInjectionContainer();
  await callInjectionContainer();

}
