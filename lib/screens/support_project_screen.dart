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
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'You did well.\n\n'
                  'This app is developed and supported by a small independent team.\n'
                  'Watching a short ad helps keep it free for everyone.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Theme.of(context).colorScheme.onSurface),
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
                  backgroundColor: Theme.of(context).colorScheme.surface, // если хочешь контраст с бордером
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                    side: const BorderSide(
                      color: Colors.blueAccent,
                      width: 2,
                    ),
                  ),
                ),
                child: Text(
                  'Support the project',
                  style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurface),
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.onInverseSurface,
                ),
                child: Text(
                  'Maybe later',
                  style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurface
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}