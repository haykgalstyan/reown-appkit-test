import 'package:flutter/material.dart';
import 'package:reown_appkit/reown_appkit.dart';
import 'package:reown_appkit_test/deep_link_handler.dart';

const appkitProjectId = String.fromEnvironment('PROJECT_ID');

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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
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
  late final ReownAppKitModal _appKitModal;

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: FutureBuilder(
        future: _appKitModal.init(),
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
                )
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
