import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scooter_app/model/scooter_model.dart';
import 'package:scooter_app/presentation/cubits/scooter_cubit.dart';
import 'package:scooter_app/presentation/cubits/scooter_state.dart';
import 'package:scooter_app/presentation/screens/scooter_form.dart';

class ScooterScreen extends StatelessWidget {
  const ScooterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scooters'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<ScooterCubit>().getScooters();
            },
          ),
        ],
      ),
      body: BlocBuilder<ScooterCubit, ScooterState>(
        builder: (context, state) {
          if (state is ScooterInitial) {
            context.read<ScooterCubit>().getScooters();
            return const Center(child: CircularProgressIndicator());
          } else if (state is ScooterLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ScooterSuccess) {
            return ListView.builder(
              itemCount: state.scooters.length,
              itemBuilder: (context, index) {
                final ScooterModel scooter = state.scooters[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: ListTile(
                      title: Text(scooter.model, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Brand: ${scooter.brand}'),
                          Text('Autonomy: ${scooter.autonomy} km'),
                          Text('Weight: ${scooter.weight} kg'),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {                              
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ScooterForm(scooter: scooter),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {                              
                              context.read<ScooterCubit>().deleteScooter(scooter.id);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (state is ScooterError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ScooterForm(),
            ),
          );
        },
        label: const Text('New Scooter'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
