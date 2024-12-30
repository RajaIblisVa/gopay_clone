import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appwrite/models.dart' as models;
import '../../providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('User Profile')),
      body: authState.when(
        data: (user) {
          return user != null ? _buildProfileView(context, user) : const Center(child: Text('User not logged in'));
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildProfileView(BuildContext context, models.User user) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: NetworkImage(
              'https://your-image-storage-service.com/images/${user.$id}'), // Ganti dengan link gambar sesuai
          child: user.$id.isEmpty
              ? const Icon(Icons.person, size: 50)
              : null,
        ),
        const SizedBox(height: 16),
        Text(user.name ?? 'No Name', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 8),
        Text(user.email ?? 'No Email', style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            // TODO: Navigate to edit profile screen
          },
          child: const Text('Edit Profile'),
        ),
      ],
    );
  }
}
