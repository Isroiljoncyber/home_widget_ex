import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:home_widget/home_widget_callback_dispatcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

@pragma("vm:entry-point")
void backgroundCallback(Uri? data) async {
  print(data);
  if (data?.host == 'titleclicked') {
    final pref = await SharedPreferences.getInstance();
    var value = pref.getInt("inc") ?? 0;
    value++;
    await HomeWidget.saveWidgetData<String>('title', (value).toString());
    await HomeWidget.updateWidget(name: 'HomeWidgetExample', iOSName: 'HomeWidgetExample');
    pref.setInt("inc", value);
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(callbackDispatcher);
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    ),
    home: const MyHomePage(title: 'Flutter Demo Home Page'),
  ));
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  @override
  void initState() {
    HomeWidget.setAppGroupId('HOMEWIDGETGROUP');
    HomeWidget.registerBackgroundCallback(backgroundCallback);
    super.initState();
  }

  void _incrementCounter() async {
    setState(() {
      _counter++;
    });
    final pref = await SharedPreferences.getInstance();
    var value = pref.getInt("inc") ?? 0;
    value++;
    await HomeWidget.saveWidgetData<String>('title', (value).toString());
    await HomeWidget.updateWidget(name: 'HomeWidgetExample', iOSName: 'HomeWidgetExample');
    pref.setInt("inc", value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
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
