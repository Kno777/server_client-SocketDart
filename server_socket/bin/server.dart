import 'dart:io';
import 'dart:typed_data';

import 'terminal_service.dart';

Future<void> main() async {
  final ip = InternetAddress.anyIPv4;

  final server = await ServerSocket.bind(ip, 3000);
  print("Server is running on: ${ip.address}:3000");
  
  server.listen((event) {
    handelConnection(event);
  });
}

List<Socket> clinets = [];

void handelConnection(Socket client){

  printGreen("Server: Connection from ${client.remoteAddress.address}:${client.remotePort}");

  client.listen(
    (Uint8List data) {
      final message = String.fromCharCodes(data);

      for(final c in clinets){
        c.write("Server: $message joined the party!");
      }

      clinets.add(client);
      client.write("Server: You are logged in as $message");
    },
    onError: (error){
      printRed(error);
      client.close();
    },
    onDone: (){
      printRed('Server: Clinet left.');
      client.close();
    }
  );
}