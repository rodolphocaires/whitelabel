import 'package:flutter/material.dart';

import 'services/brand_config_service.dart';
import 'widgets/brand_logo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Get brand ID from environment variable or use default
  const String brandId = String.fromEnvironment(
    'BRAND_ID',
    defaultValue: 'default',
  );

  // Initialize brand configuration at build time
  await BrandConfigService.initialize(brandId);

  runApp(const WhiteLabelApp());
}

class WhiteLabelApp extends StatefulWidget {
  const WhiteLabelApp({super.key});

  @override
  State<WhiteLabelApp> createState() => _WhiteLabelAppState();
}

class _WhiteLabelAppState extends State<WhiteLabelApp> {
  @override
  Widget build(BuildContext context) {
    final brandConfig = BrandConfigService.currentConfig;

    if (brandConfig == null) {
      return MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    return MaterialApp(
      title: brandConfig.appTitle,
      theme: brandConfig.themeData,
      home: MyHomePage(title: brandConfig.appTitle),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 20),
                  // Brand logo
                  const BrandLogo(width: 120, height: 120),
                  const SizedBox(height: 20),
                  Text(
                    'Welcome to ${BrandConfigService.currentConfig?.brandName ?? "White Label App"}',
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  const Text('You have pushed the button this many times:'),
                  Text(
                    '$_counter',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 20),
                  // Display brand info
                  Card(
                    margin: const EdgeInsets.all(16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Current Brand Configuration:',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Brand: ${BrandConfigService.currentConfig?.brandName ?? "Unknown"}',
                          ),
                          Text(
                            'App Title: ${BrandConfigService.currentConfig?.appTitle ?? "Unknown"}',
                          ),
                          Text(
                            'Primary Color: ${BrandConfigService.currentConfig?.primaryColorHex ?? "Unknown"}',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
