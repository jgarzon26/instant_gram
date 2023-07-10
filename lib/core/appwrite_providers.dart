import 'package:appwrite/appwrite.dart';
import 'package:instant_gram/constants/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _clientProvider = Provider((ref) {
  Client client = Client();
  return client
      .setEndpoint(Appwrite.endpoint)
      .setProject(Appwrite.projectId)
      .setSelfSigned(status: true);
});

final accountProvider = Provider((ref) {
  final client = ref.watch(_clientProvider);
  return Account(client);
});
