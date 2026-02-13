import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../services/ads_service.dart';

class SupportProjectScreen extends StatefulWidget {
  const SupportProjectScreen({super.key});

  @override
  State<SupportProjectScreen> createState() => _SupportProjectScreenState();
}

class _SupportProjectScreenState extends State<SupportProjectScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'You did well.\n\n'
                  'This app is developed and supported by a small independent team.\n'
                  'Watching a short ad helps keep it free for everyone.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 40),
            // PRIMARY — поддержка проекта (реклама)
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () async {
                  await AdsService.showInterstitial(
                    onClosed: () {
                      Navigator.popUntil(context, (r) => r.isFirst);
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // если хочешь контраст с бордером
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                    side: const BorderSide(
                      color: Colors.blueAccent,
                      width: 2,
                    ),
                  ),
                ),
                child: const Text(
                  'Support the project',
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ),
            ),

            const SizedBox(height: 20),

// SECONDARY — пропустить
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, (r) => r.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  //side: BorderSide.none,
                  // backgroundColor: Colors.white60,
                  // side: const BorderSide(
                  //   color: Colors.blueAccent,
                  //   width: 2,
                  // ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: const Text(
                  'Maybe later',
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}