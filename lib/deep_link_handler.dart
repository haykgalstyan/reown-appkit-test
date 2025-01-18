import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:reown_appkit/modal/i_appkit_modal_impl.dart';

class DeepLinkHandler {
  static const _eventChannel = EventChannel('com.exampledapp/events');
  static late IReownAppKitModal _appKitModal;

  static void initListener() {
    try {
      _eventChannel.receiveBroadcastStream().listen(
            _onLink,
            onError: _onError,
          );
    } catch (e) {
      debugPrint('[SampleDapp] checkInitialLink $e');
    }
  }

  static void init(IReownAppKitModal appKitModal) {
    if (kIsWeb) return;
    _appKitModal = appKitModal;
  }

  static void _onLink(dynamic link) async {
    try {
      _appKitModal.dispatchEnvelope(link);
    } catch (e) {
      print(e);
    }
  }

  static void _onError(dynamic error) {
    debugPrint('[SampleDapp] _onError $error');
  }
}
