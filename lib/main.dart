import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mycookcoach/config/set_up.dart';
import 'package:mycookcoach/features/authentication/presentation/blocs/bloc_providers.dart';

import 'app.dart';

void main() async {
  await setup();
  runApp(
    MultiBlocProvider(
      providers: getAppBlocProviders(),
      child: const MyApp(),
    ),
  );
}
