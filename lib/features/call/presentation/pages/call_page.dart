import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:test_server_app/features/app/const/agora_config_const.dart';
import 'package:test_server_app/features/call/domain/entities/call_entity.dart';
import 'package:test_server_app/features/call/presentation/cubits/agora/agora_cubit.dart';
import 'package:test_server_app/features/call/presentation/cubits/call/call_cubit.dart';

class CallPage extends StatefulWidget {
  final CallEntity callEntity;
  const CallPage({super.key, required this.callEntity});

  @override
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  late RtcEngine _engine;

  @override
  void initState() {
    super.initState();

    _initAgoraEngine();
    BlocProvider.of<AgoraCubit>(context).initialize(
      channelName: widget.callEntity.callId!,
      tokenUrl: "http://192.168.244.3:3000/get_token?channelName=${widget.callEntity.callId}",
    );
  }

  Future<void> _initAgoraEngine() async {
    await [Permission.microphone, Permission.camera].request();

    _engine = createAgoraRtcEngine();
    await _engine.initialize(
      const RtcEngineContext(appId: Config.agoraAppId),
    );

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
        },
        onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
        },
      ),
    );
    await _engine.enableVideo();
  }

  @override
  Widget build(BuildContext context) {
    final agoraProvider = BlocProvider.of<AgoraCubit>(context);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            _buildLocalPreview(),
            _buildRemoteView(),
            Positioned(
              bottom: 16,
              left: 16,
              child: IconButton(
                color: Colors.red,
                onPressed: () async {
                  await agoraProvider.leaveChannel().then((value) {
                    BlocProvider.of<CallCubit>(context).endCall(
                      CallEntity(
                        callerId: widget.callEntity.callerId,
                        receiverId: widget.callEntity.receiverId,
                      ),
                    );
                  });
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.call_end),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocalPreview() {
    return AgoraVideoView(
      controller: VideoViewController(
        rtcEngine: _engine, // Pass the engine instance here
        canvas: const VideoCanvas(uid: 0),
      ),
    );
  }

  Widget _buildRemoteView() {
    return AgoraVideoView(
      controller: VideoViewController.remote(
        rtcEngine: _engine,
        canvas: const VideoCanvas(uid: 0),
        connection: RtcConnection(
          channelId: widget.callEntity.callId!,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _engine.leaveChannel();
    _engine.release();
    super.dispose();
  }
}
