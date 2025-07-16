import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/profile_provider.dart';

class ProfileTestPage extends StatefulWidget {
  const ProfileTestPage({super.key});

  @override
  State<ProfileTestPage> createState() => _ProfileTestPageState();
}

class _ProfileTestPageState extends State<ProfileTestPage> {
  @override
  void initState() {
    super.initState();
    // Load profile when page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileProvider>().loadProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Test'),
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, profileProvider, child) {
          if (profileProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (profileProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 64,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${profileProvider.error}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      profileProvider.clearError();
                      profileProvider.loadProfile();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (profileProvider.profile == null) {
            return const Center(
              child: Text('No profile data'),
            );
          }

          final profile = profileProvider.profile!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Profile Information',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 16),
                        _buildInfoRow('ID', profile.id),
                        _buildInfoRow('Name', '${profile.firstName} ${profile.lastName ?? ''}'),
                        _buildInfoRow('Company', profile.companyName ?? 'N/A'),
                        _buildInfoRow('Bio', profile.bio ?? 'N/A'),
                        _buildInfoRow('Email', profile.contactEmail ?? 'N/A'),
                        _buildInfoRow('LinkedIn', profile.linkedInURL ?? 'N/A'),
                        _buildInfoRow('Website', profile.websiteURL ?? 'N/A'),
                        _buildInfoRow('Super Admin', profile.isSuperAdmin ? 'Yes' : 'No'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => profileProvider.loadProfile(),
                  child: const Text('Refresh Profile'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}