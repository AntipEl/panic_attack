import 'package:flutter/foundation.dart';
import 'package:stack_appodeal_flutter/stack_appodeal_flutter.dart';

class AdsService {
  static bool _initialized = false;
  static VoidCallback? _onAdClosed;

  static Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    Appodeal.setInterstitialCallbacks(
      onInterstitialLoaded: (isPrecache) {
        debugPrint('✅ Interstitial LOADED (precache=$isPrecache)');
      },
      onInterstitialFailedToLoad: () {
        debugPrint('❌ Interstitial FAILED to load');
      },
      onInterstitialShown: () {
        debugPrint('📺 Interstitial SHOWN');
      },
      onInterstitialClosed: () {
        debugPrint('🚪 Interstitial CLOSED');
        _onAdClosed?.call();
        _onAdClosed = null;
      },
    );

    await Appodeal.initialize(
      appKey: '41f0c447a887f4b622ca48f6d469bb7d0fd2d5ea0f61bf43',
      adTypes: [AppodealAdType.Interstitial],
      onInitializationFinished: (errors) {
        if (errors != null && errors.isNotEmpty) {
          debugPrint('❌ Init failed: $errors');
        } else {
          debugPrint('✅ Init OK');
        }
      },
    );

    // ✅ ТОЛЬКО ПОСЛЕ init
    //await Appodeal.setTesting(true);
    //debugPrint('🧪 Test mode ON');

  }

  static Future<void> preloadInterstitial() async {
    final isLoaded = await Appodeal.isLoaded(AppodealAdType.Interstitial);

    if (!isLoaded) {
      debugPrint('📥 Preloading interstitial');
      await Appodeal.cache(AppodealAdType.Interstitial);
    } else {
      debugPrint('ℹ️ Interstitial already loaded');
    }
  }

  static Future<void> showInterstitial({
    required VoidCallback onClosed,
  }) async {
    final canShow = await Appodeal.canShow(AppodealAdType.Interstitial);
    debugPrint('🎬 Can show: $canShow');

    if (!canShow) {
      onClosed();
      return;
    }

    _onAdClosed = onClosed;
    await Appodeal.show(AppodealAdType.Interstitial);
  }
}
