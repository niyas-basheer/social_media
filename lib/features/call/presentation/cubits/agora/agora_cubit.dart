import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_server_app/features/app/const/agora_config_const.dart';


part 'agora_state.dart';

class AgoraCubit extends Cubit<AgoraState> {
  static final AgoraCubit _instance = AgoraCubit._internal();
  late final RtcEngine _engine;

  factory AgoraCubit() => _instance;

  AgoraCubit._internal() : super(AgoraInitial());

  Future<void> initialize({String? token, required String channelName, required String tokenUrl}) async {
    _engine = createAgoraRtcEngine();
    await _engine.initialize(
      const RtcEngineContext(appId: Config.agoraAppId),
    );

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          print('Local user ${connection.localUid} joined channel ${connection.channelId}');
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          print('Remote user $remoteUid joined');
        },
        onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
          print('Remote user $remoteUid left the channel');
        },
      ),
    );
    await _engine.enableVideo();
    await _engine.joinChannel(
      token: token??'',
      channelId: channelName,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  Future<void> leaveChannel() async {
    await _engine.leaveChannel();
    await _engine.release();
  }

  RtcEngine get getRtcEngine => _engine;
}
