import 'package:flutter/material.dart';
import '../../core/constants/app_icons.dart';
import 'app_icon_widget.dart';

class IconExamples extends StatelessWidget {
  const IconExamples({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Venyu Icons'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 4,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: [
            // Navigation Icons
            _buildIconExample('Home', AppIcons.homeRegular),
            _buildIconExample('Profile', AppIcons.profileRegular),
            _buildIconExample('Settings', AppIcons.settingsRegular),
            _buildIconExample('Search', AppIcons.searchRegular),
            
            // Action Icons
            _buildIconExample('Camera', AppIcons.cameraRegular),
            _buildIconExample('Edit', AppIcons.editRegular),
            _buildIconExample('Delete', AppIcons.deleteRegular),
            _buildIconExample('Add', AppIcons.plusRegular),
            
            // Communication Icons
            _buildIconExample('Chat', AppIcons.chatRegular),
            _buildIconExample('Email', AppIcons.emailRegular),
            _buildIconExample('Phone', AppIcons.phoneRegular),
            _buildIconExample('Send', AppIcons.sendRegular),
            
            // Status Icons
            _buildIconExample('Verified', AppIcons.verifiedRegular),
            _buildIconExample('Notification', AppIcons.notificationRegular),
            _buildIconExample('Pending', AppIcons.pendingRegular),
            _buildIconExample('Decline', AppIcons.declineRegular),
            
            // Business Icons
            _buildIconExample('Company', AppIcons.companyRegular),
            _buildIconExample('Role', AppIcons.roleRegular),
            _buildIconExample('Handshake', AppIcons.handshakeRegular),
            _buildIconExample('Interest', AppIcons.interestRegular),
            
            // Location Icons
            _buildIconExample('Location', AppIcons.locationRegular),
            _buildIconExample('Target', AppIcons.targetRegular),
            _buildIconExample('Walk', AppIcons.walkRegular),
            
            // Social Icons
            _buildIconExample('Coffee', AppIcons.coffeeRegular),
            _buildIconExample('Hashtag', AppIcons.hashtagRegular),
            _buildIconExample('Post', AppIcons.postRegular),
            _buildIconExample('Link', AppIcons.linkRegular),
          ],
        ),
      ),
    );
  }

  Widget _buildIconExample(String title, String iconPath) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppIconWidget(
          iconPath: iconPath,
          width: 32,
          height: 32,
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 12),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

// Example of using icons with different variants
class IconVariantExample extends StatelessWidget {
  const IconVariantExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Icon Variants'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Home Icon Variants:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildVariantExample('Regular', AppIcons.homeRegular),
                _buildVariantExample('Outlined', AppIcons.homeOutlined),
                _buildVariantExample('Selected', AppIcons.homeSelected),
                _buildVariantExample('Accent', AppIcons.homeAccent),
              ],
            ),
            const SizedBox(height: 32),
            const Text(
              'Profile Icon Variants:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildVariantExample('Regular', AppIcons.profileRegular),
                _buildVariantExample('Outlined', AppIcons.profileOutlined),
                _buildVariantExample('Selected', AppIcons.profileSelected),
                _buildVariantExample('Accent', AppIcons.profileAccent),
              ],
            ),
            const SizedBox(height: 32),
            const Text(
              'Using Extension Method:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                AppIcons.chatRegular.toIcon(width: 40, height: 40),
                AppIcons.emailRegular.toIcon(width: 40, height: 40, color: Colors.blue),
                AppIcons.phoneRegular.toIcon(width: 40, height: 40, color: Colors.green),
                AppIcons.sendRegular.toIcon(width: 40, height: 40, color: Colors.red),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVariantExample(String title, String iconPath) {
    return Column(
      children: [
        AppIconWidget(
          iconPath: iconPath,
          width: 40,
          height: 40,
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}