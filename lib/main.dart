import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scooter_app/presentation/cubits/scooter_cubit.dart';
import 'package:scooter_app/presentation/screens/scooter_screen.dart';
import 'package:scooter_app/repository/scooter_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const String baseUrl = 'https://2sfgx25mh4.execute-api.us-east-2.amazonaws.com/Prod/scooter';
    final ScooterRepository scooterRepository = ScooterRepository(baseUrl: baseUrl);

    return MultiBlocProvider(
      providers: [
        BlocProvider<ScooterCubit>(
          create: (context) => ScooterCubit(scooterRepository: scooterRepository),
        ),
      ],
      child: MaterialApp(
        title: 'Scooter List',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const ScooterScreen(),
      ),
    );
  }
}