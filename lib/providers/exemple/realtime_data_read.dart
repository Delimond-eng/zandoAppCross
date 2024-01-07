import 'package:flutter/material.dart';

import '../realtime_provider.dart';

class RealtimeDataRead extends StatefulWidget {
  const RealtimeDataRead({super.key});

  @override
  State<RealtimeDataRead> createState() => _RealtimeDataReadState();
}

class _RealtimeDataReadState extends State<RealtimeDataRead> {
  RealtimeDataProvider<List<dynamic>> provider =
      RealtimeDataProvider<List<dynamic>>(
          url: 'http://127.0.0.1:8000/api/users.all');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Realtime data read test"),
      ),
      body: Center(
        child: StreamBuilder<List<dynamic>>(
          stream: provider.dataStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // Affiche les données reçues
              return ListView.builder(
                padding: const EdgeInsets.all(10.0),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  var item = snapshot.data![index];
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(item['name']),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              // Gère les erreurs éventuelles
              return Center(child: Text('Erreur: ${snapshot.error}'));
            }
            // Affiche un indicateur de chargement si les données n'ont pas encore été reçues
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
