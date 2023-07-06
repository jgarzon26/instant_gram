import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instant_gram/apis/auth_api.dart';

class Login extends ConsumerWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instant-gram!'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome to Instant-gram!",
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(height: 10),
            const Divider(),
            const SizedBox(height: 10),
            Text(
              "Login into your account using one of the options below.",
              style: Theme.of(context).textTheme.titleSmall,
            ),
            buildLoginButton(
              context: context,
              onPressed: () {},
              icon: const Icon(Icons.facebook),
              label: 'Facebook',
            ),
            buildLoginButton(
              context: context,
              onPressed: () {},
              icon: const Icon(Icons.email),
              label: 'Google',
            ),
            const SizedBox(height: 5),
            const Divider(),
            const SizedBox(height: 5),
            Text(
              "Don't have an account?",
              style: Theme.of(context).textTheme.titleSmall,
            ),
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: "Sign Up on ",
                  ),
                  buildSignUpLinkButton(
                    label: 'Facebook',
                    onPressed: () {},
                  ),
                  const TextSpan(
                    text: " or create an account on ",
                  ),
                  buildSignUpLinkButton(
                    label: "Google",
                    onPressed: () {
                      ref.read(authApiProvider).loginWithGoogle();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextSpan buildSignUpLinkButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return TextSpan(
      text: label,
      style: const TextStyle(
        color: Colors.blue,
        decoration: TextDecoration.underline,
      ),
      recognizer: TapGestureRecognizer()..onTap = onPressed,
    );
  }

  ElevatedButton buildLoginButton({
    required BuildContext context,
    required VoidCallback onPressed,
    required String label,
    required Icon icon,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: icon,
      label: Text(
        label,
        style: Theme.of(context).textTheme.titleSmall,
      ),
    );
  }
}
