import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instant_gram/screens/auth/controller/auth_controller.dart';
import 'package:instant_gram/theme/theme.dart';

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
            const SizedBox(height: 20),
            Text(
              "Welcome to Instant-gram!",
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(height: 40),
            const Divider(),
            const SizedBox(height: 40),
            Text(
              "Login into your account using one of the options below.",
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 20),
            buildLoginButton(
              context: context,
              onPressed: () {},
              icon: const Icon(
                Icons.facebook,
                color: Color.fromARGB(255, 23, 82, 129),
                size: 30,
              ),
              label: 'Facebook',
            ),
            const SizedBox(height: 20),
            buildLoginButton(
              context: context,
              onPressed: () {
                ref.read(authControllerProvider.notifier).loginWithGoogle(ref);
              },
              icon: const ImageIcon(
                AssetImage('assets/icons/google_blue.png'),
                color: Colors.blue,
                size: 40,
              ),
              label: 'Google',
            ),
            const SizedBox(height: 40),
            const Divider(),
            const SizedBox(height: 40),
            Text(
              "Don't have an account?",
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 10),
            RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.titleSmall,
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
                    onPressed: () {},
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
    required Widget icon,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: kForegroundColor,
        minimumSize: const Size(double.infinity, 55),
      ),
      icon: icon,
      label: Text(
        label,
        style: Theme.of(context).textTheme.titleSmall!.copyWith(
              color: kBackgroundColor,
            ),
      ),
    );
  }
}
