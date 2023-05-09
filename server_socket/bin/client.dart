import 'dart:io';
import 'dart:typed_data';

import 'terminal_service.dart';

Future<void> main() async {
  final socket = await Socket.connect("0.0.0.0", 3000);
  print("Clinet: Connected to : ${socket.remoteAddress.address}:${socket.remotePort}");

  socket.listen(
    (Uint8List data) {
      final serverResponse = String.fromCharCodes(data);
      printGreen("Client $serverResponse");
    },
    onError: (error){
      printRed('Clinet: $error');
      socket.destroy();
    },
    onDone: (){
      printRed('Clinet: Server left.');
      socket.destroy();
    },
  );

  String? username;

  do {
    print("Client: Please enter a username");
    username = stdin.readLineSync();
  } while (username == null || username.isEmpty);

  socket.write(username);
}
