
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_server_app/main_injection_container.dart' as di;
import 'package:test_server_app/features/app/const/page_const.dart';
import 'package:test_server_app/features/app/global/widgets/profile_widget.dart';
import 'package:test_server_app/features/call/domain/entities/call_entity.dart';
import 'package:test_server_app/features/call/domain/usecases/get_call_channel_id_usecase.dart';
import 'package:test_server_app/features/call/presentation/cubits/agora/agora_cubit.dart';
import 'package:test_server_app/features/call/presentation/cubits/call/call_cubit.dart';
class PickUpCallPage extends StatefulWidget {
  final String? uid;
  final Widget child;

  const PickUpCallPage({super.key, required this.child, this.uid});

  @override
  State<PickUpCallPage> createState() => _PickUpCallPageState();
}

class _PickUpCallPageState extends State<PickUpCallPage> {


  @override
  void initState() {
    BlocProvider.of<CallCubit>(context).getUserCalling("67372c62ff0eb19eca30fe84");
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CallCubit, CallState>(
      builder: (context, callState) {
        if(callState is CallDialed) {
          final call = callState.userCall;

          if(call.isCallDialed == false) {
            return Scaffold(
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  const Text(
                    'Incoming Call',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 40),
                  profileWidget(imageUrl: call.receiverProfileUrl),
                  const SizedBox(height: 40),
                  Text(
                    "${call.receiverName}",
                    style: const TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () async {
                          BlocProvider.of<AgoraCubit>(context).leaveChannel().then((value) {
                            BlocProvider.of<CallCubit>(context).updateCallHistoryStatus(
                                CallEntity(
                                    callId: call.callId,
                                    callerId: call.callerId,
                                    receiverId: call.receiverId,
                                    isCallDialed: false,
                                    isMissed: true
                                )
                            ).then((value) {
                              BlocProvider.of<CallCubit>(context)
                                  .endCall(CallEntity(
                                callerId: call.callerId,
                                receiverId: call.receiverId,
                              ));
                            });
                          });
                        },
                        icon: const Icon(Icons.call_end,
                            color: Colors.redAccent),
                      ),
                      const SizedBox(width: 25),
                      IconButton(
                        onPressed: () {
                          di.sl<GetCallChannelIdUseCase>().call(call.receiverId!).then((callChannelId) {

                            Navigator.pushNamed(context, PageConst.callPage, arguments: CallEntity(
                                callId: callChannelId,
                                callerId: call.callerId!,
                                receiverId: call.receiverId!
                            ));



                            print("callChannelId = $callChannelId");
                          });
                        },
                        icon: const Icon(
                          Icons.call,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
          return widget.child;
        }
        return widget.child;
      },
    );
  }
}
