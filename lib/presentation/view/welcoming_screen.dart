import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WelcomingScreen extends StatelessWidget {
  const WelcomingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // welcomin screen with button to login as mitra or customer
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "images/welcoming2.png",
            ),
            const Text(
              "Welcome to Shoes Care",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                const Spacer(),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {
                      context.push("/login-customer");
                    },
                    child: const Text("Login as Customer"),
                  ),
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              "or",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Spacer(),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {
                      context.push("/login-mitra");
                    },
                    child: const Text("Login as Mitra"),
                  ),
                ),
                const Spacer()
              ],
            ),
          ],
        ),
      ),
    );
  }
}
