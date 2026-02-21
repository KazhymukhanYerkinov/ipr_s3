import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipr_s3/core/localization/localization_x.dart';
import 'package:ipr_s3/features/auth/domain/entities/user.dart';
import 'package:ipr_s3/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ipr_s3/features/auth/presentation/bloc/auth_event.dart';

@RoutePage()
class AuthHomeScreen extends StatelessWidget {
  final UserEntity user;
  const AuthHomeScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.locale.home),
        actions: [
          IconButton(
            onPressed: () {
              context.read<AuthBloc>().add(SignOutRequested());
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (user.photoUrl != null)
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(user.photoUrl!),
              ),
            const SizedBox(height: 16),
            Text(user.displayName, style: const TextStyle(fontSize: 22)),
            Text(user.email, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 32),
            Card(
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.locale.securityFeatures,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(context.locale.securityTokenStorage),
                    Text(context.locale.securityHttpsOnly),
                    Text(context.locale.securityOAuth),
                    Text(context.locale.securityMaskedLogs),
                    Text(context.locale.securityEncryptedData),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
