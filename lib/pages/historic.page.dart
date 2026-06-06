import 'package:flutter/material.dart';

class HistoricPage extends StatelessWidget {
  const HistoricPage({super.key, required this.historic});
  final List<String> historic;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: historic.isEmpty
          ? Center(child: Text("Nenhum cálculo realizado", style: TextStyle(fontSize: 18, color: Colors.grey)))
          : ListView.builder(
            itemCount: historic.length,
            itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  child: ListTile(
                    leading: CircleAvatar(child: Text("${index + 1}")),
                    title: Text(historic[index], style: TextStyle(fontSize: 16)),
                  ),
                );
              },
            ),
    );
  }
}
