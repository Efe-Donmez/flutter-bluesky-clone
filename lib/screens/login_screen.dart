import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/bluesky_provider.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _attemptLogin() async {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<BlueskyProvider>(context, listen: false);
      final success = await provider.login(
        _identifierController.text.trim(),
        _passwordController.text,
      );
      
      if (success && mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login to Bluesky'),
      ),
      body: Consumer<BlueskyProvider>(
        builder: (context, provider, _) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  Image.asset(
                    'assets/images/bluesky_logo.png', 
                    height: 80,
                  ),
                  const SizedBox(height: 40),
                  TextFormField(
                    controller: _identifierController,
                    decoration: const InputDecoration(
                      labelText: 'Email or Handle',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your email or handle';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock),
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    obscureText: _obscurePassword,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) => _attemptLogin(),
                  ),
                  const SizedBox(height: 24),
                  if (provider.state == LoadingState.error)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        provider.error,
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ElevatedButton(
                    onPressed: provider.state == LoadingState.loading ? null : _attemptLogin,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: provider.state == LoadingState.loading
                        ? const CircularProgressIndicator()
                        : const Text('Login', style: TextStyle(fontSize: 16)),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      // Open sign up page or bluesky website
                    },
                    child: const Text('Don\'t have an account? Sign up on Bluesky.app'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
