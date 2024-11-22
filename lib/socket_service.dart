import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket socket;

  void initializeSocket() {
    socket = IO.io('http://10.0.2.2:5001', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();

    socket.onConnect((_) {
      print('Connected to socket server');
    });

    socket.on('message', (data) {
      print('Message received: $data');
    });

    socket.onDisconnect((_) {
      print('Disconnected from socket server');
    });
  }

  void sendMessage(String event, dynamic data) {
    socket.emit(event, data);
  }
}
