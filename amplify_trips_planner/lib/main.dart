import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:amplify_trips_planner/models/ModelProvider.dart';
import 'package:amplify_trips_planner/trips_planner_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'amplifyconfiguration.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await _configureAmplify();
  } on AmplifyAlreadyConfiguredException {
    debugPrint('Amplify configuration failed.');
  }

  runApp(
    const ProviderScope(
      child: TripsPlannerApp(),
    ),
  );
}

Future<void> _configureAmplify() async {
  final auth = AmplifyAuthCognito();
  final api = AmplifyAPI(
    options: APIPluginOptions( modelProvider: ModelProvider.instance )
  );
  final s3 = AmplifyStorageS3();
  await Amplify.addPlugins([api, auth, s3]);
  try {
    await Amplify.configure(amplifyconfig);
  } on AmplifyAlreadyConfiguredException {
      safePrint( 'Tried to reconfigure Amplify; this can occur when your app restarts on Android.');
  }
}