import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bluesky_viewer/providers/bluesky_provider.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BlueskyProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        elevation: 0,
      ),
      body: !provider.isAuthenticated
          ? _buildLoginPrompt()
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.mail_outline,
                    size: 80,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Direct messages coming soon',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32.0),
                    child: Text(
                      'Bluesky does not yet support direct messages. This feature will be added when available in the API.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 24),
                  OutlinedButton(
                    onPressed: () {
                      // Navigate to home screen
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    child: const Text('Go to Home'),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildLoginPrompt() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'You need to log in to view messages',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Navigate to home screen for login
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: const Text('Go to Login'),
          ),
        ],
      ),
    );
  }
}
