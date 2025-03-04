import 'package:flutter/material.dart';
import 'package:reown_appkit/reown_appkit.dart';
import 'package:reown_appkit_test/deep_link_handler.dart';

const appkitProjectId = '';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  DeepLinkHandler.initListener();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late ReownAppKitModal _appKitModal;
  late Future<void> _appKitInit;

  @override
  void initState() {
    super.initState();
    _initAppKit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _appKitInit,
        builder: (context, snapshot) {
          debugPrint('=================Rebuild================: $snapshot');
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppKitModalNetworkSelectButton(appKit: _appKitModal),
                AppKitModalConnectButton(appKit: _appKitModal),
                Visibility(
                  visible: _appKitModal.isConnected,
                  child: AppKitModalAccountButton(
                    appKitModal: _appKitModal,
                  ),
                ),
                OutlinedButton(
                  onPressed: () async {
                    // debugPrint('Removing Solana networks...');
                    // ReownAppKitModalNetworks.removeSupportedNetworks('solana');
                    // debugPrint('AppKit dispose...');
                    await _appKitModal.dispose();

                    await Future.delayed(const Duration(seconds: 5));

                    debugPrint('AppKit init...');
                    _initAppKit();
                  },
                  child: Text('Remove Solana networks'),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  void _initAppKit() {
    _appKitModal = ReownAppKitModal(
      context: context,
      projectId: appkitProjectId,
      metadata: const PairingMetadata(
        name: 'Example App',
        description: 'Example app description',
        url: 'https://example.com/',
        icons: ['https://example.com/logo.png'],
        redirect: Redirect(
          native: 'exampleapp://',
          linkMode: false,
        ),
      ),
      enableAnalytics: false,
      logLevel: LogLevel.all,
    );

    _appKitInit = _appKitModal.init();

    DeepLinkHandler.init(_appKitModal);

    _appKitModal.onModalConnect.subscribe((event) {
      setState(() {});
    });
    _appKitModal.onModalDisconnect.subscribe((event) {
      setState(() {});
    });
    _appKitModal.onModalUpdate.subscribe((event) {
      setState(() {});
    });
    _appKitModal.onModalNetworkChange.subscribe((event) {
      setState(() {});
    });
    _appKitModal.onModalError.subscribe((event) {
      setState(() {});
    });
  }
}
