import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.deepPurple,
        elevation: 5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Profile Section
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.deepPurple.shade100,
                  child: const Icon(Icons.person, color: Colors.deepPurple),
                ),
                title: const Text(
                  'Profile',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: const Text('Manage your profile details'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Navigate to Profile Settings
                },
              ),
            ),
            const SizedBox(height: 20),

            // General Settings Section
            const Text(
              'General',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            SwitchListTile(
              activeColor: Colors.deepPurple,
              title: const Text('Dark Theme'),
              subtitle: const Text('Switch between light and dark mode'),
              value: true, // Placeholder for dark theme state
              onChanged: (bool value) {
                // Handle theme change
              },
            ),
            ListTile(
              leading: const Icon(Icons.language, color: Colors.deepPurple),
              title: const Text('Language'),
              subtitle: const Text('Select your preferred language'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Handle language selection
              },
            ),
            const SizedBox(height: 20),

            // Notifications Section
            const Text(
              'Notifications',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            SwitchListTile(
              activeColor: Colors.deepPurple,
              title: const Text('Receive Notifications'),
              subtitle: const Text('Turn on/off app notifications'),
              value: true, // Placeholder for notification state
              onChanged: (bool value) {
                // Handle notification toggle
              },
            ),
            SwitchListTile(
              activeColor: Colors.deepPurple,
              title: const Text('Sound'),
              subtitle: const Text('Enable sound for notifications'),
              value: false, // Placeholder for sound state
              onChanged: (bool value) {
                // Handle sound toggle
              },
            ),
            const SizedBox(height: 20),

            // App Information Section
            const Text(
              'About',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            const ListTile(
              leading: Icon(Icons.info, color: Colors.deepPurple),
              title: Text('App Version'),
              subtitle: Text('1.0.0'),
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip, color: Colors.deepPurple),
              title: const Text('Privacy Policy'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navigate to Privacy Policy
              },
            ),
            ListTile(
              leading: const Icon(Icons.feedback, color: Colors.deepPurple),
              title: const Text('Send Feedback'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navigate to Feedback Section
              },
            ),
            const SizedBox(height: 30),

            // Logout Section
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Handle logout
                },
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 24,
                  ),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
