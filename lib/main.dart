import 'dart:io';

import 'package:dxf/dxf.dart' hide XFile;
import 'package:dxf_2d_tool/ui/canvas_drawer.dart';
import 'package:dxf_2d_tool/ui/rectangle_element.dart';
import 'package:flutter/material.dart' hide XFile;
import 'package:flutter/services.dart' hide XFile;
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart' hide XFile;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '2D to DFX Test',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: '2D to DFX Test'),
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
  int _mode = 0; //0 for Kitchen Countertop and 1 for Island
  static double COUNTERTOP_DEF_WIDTH_IN_INCHES = 25.5;
  static double ISLAND_DEF_WIDTH_IN_INCHES = 30;

  RectangleElement? test;
  late List<RectangleElement> elements;

  @override
  void initState() {
    elements = <RectangleElement>[];
    super.initState();
  }

  Future<void> _export() async {
    final dxf = DXF.create();
    for (RectangleElement element in elements)
      dxf.addEntities(element.dumpToCad());
    print(dxf.dxfString);
    final box = context.findRenderObject() as RenderBox?;
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    // List<int> list = dxf.dxfString.codeUnits;
    // Uint8List bytes = Uint8List.fromList(list);


    final Directory output = await getTemporaryDirectory();
    final String screenshotFilePath = '${output.path}/sample_export.dxf';
    final File screenshotFile = File(screenshotFilePath);
    //await screenshotFile.writeAsBytes(bytes!);
    await screenshotFile.writeAsString(dxf.dxfString);

    final shareResult = await Share.shareXFiles(
      subject: 'Export from 2D to DFX Test App',
      text: 'sample_export.dxf file',
      [
        // XFile.fromData(
        //   bytes,
        //   name: 'sample_export.dxf',
        //   mimeType: 'image/x-dxf',
        // ),
        XFile(screenshotFilePath)
      ],
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );

    scaffoldMessenger.showSnackBar(getResultSnackBar(shareResult));
    setState(() {});
  }

  SnackBar getResultSnackBar(ShareResult result) {
    return SnackBar(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Share result: ${result.status}"),
          if (result.status == ShareResultStatus.success)
            Text("Shared to: ${result.raw}")
        ],
      ),
    );
  }

  void _modeCountertop() {
    setState(() {
      _mode = 0;
    });
  }

  void _clean() {
    setState(() {
      elements.clear();
      test = null;
    });
  }

  void _modeIsland() {
    setState(() {
      _mode = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: GestureDetector(
        // onDoubleTap: () {
        //   print('onDoubleTap');
        // },
        onDoubleTapDown: (details) {
          final RenderBox renderBox = context.findRenderObject() as RenderBox;
          if (renderBox != null) {
            for (RectangleElement element in elements) {
              if (renderBox.globalToLocal(details.localPosition).dx >
                      element.left &&
                  renderBox.globalToLocal(details.localPosition).dx <
                      (element.right ?? element.left + element.width!) &&
                  renderBox.globalToLocal(details.localPosition).dy >
                      element.top &&
                  renderBox.globalToLocal(details.localPosition).dy <
                      (element.bottom ?? element.top + element.height!)) {
                setState(() {
                  test = element;
                  _dialogBuilder(context);
                });
                return;
              }
            }
          }
        },
        onPanDown: (details) {
          RenderBox renderBox = context.findRenderObject() as RenderBox;
          if (renderBox != null) {
            for (RectangleElement element in elements) {
              if (renderBox.globalToLocal(details.localPosition).dx >
                      element.left &&
                  renderBox.globalToLocal(details.localPosition).dx <
                      (element.right ?? element.left + element.width!) &&
                  renderBox.globalToLocal(details.localPosition).dy >
                      element.top &&
                  renderBox.globalToLocal(details.localPosition).dy <
                      (element.bottom ?? element.top + element.height!)) {
                setState(() {
                  test = element;
                });
                return;
              }
            }
          }
        },
        onPanStart: (details) {
          RenderBox renderBox = context.findRenderObject() as RenderBox;
          if (renderBox != null) {
            setState(() {
              if (test == null) {
                test = RectangleElement(
                    left: renderBox.globalToLocal(details.localPosition).dx,
                    top: renderBox.globalToLocal(details.localPosition).dy,
                    bottom: renderBox.globalToLocal(details.localPosition).dy +
                        (_mode == 0
                            ? COUNTERTOP_DEF_WIDTH_IN_INCHES
                            : ISLAND_DEF_WIDTH_IN_INCHES));
                elements.add(test!);
              }
            });
          }
        },
        onPanUpdate: (details) {
          RenderBox? renderBox = context.findRenderObject() as RenderBox?;
          if (renderBox != null) {
            setState(() {
              // test!.bottom = test!.top + (_mode == 0
              //     ? COUNTERTOP_DEF_WIDTH_IN_INCHES
              //     : ISLAND_DEF_WIDTH_IN_INCHES); //renderBox.globalToLocal(details.localPosition).dx;
              test!.right = renderBox.globalToLocal(details.localPosition).dx;
            });
          }
        },
        onPanEnd: (details) {
          setState(() {
            //seal?
            test = null;
          });
        },
        child: CustomPaint(
          painter: CanvasDrawer(elements: elements),
          child: Container(),
        ),
      ),
      floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              width: 20,
            ),
            FloatingActionButton(
              onPressed: _clean,
              tooltip: 'Clean',
              child: Icon(Icons.delete_forever_outlined),
            ),
            Spacer(),
            FloatingActionButton(
              onPressed: _modeCountertop,
              tooltip: 'Countertop',
              child: Icon(
                  _mode == 0 ? Icons.countertops : Icons.countertops_outlined),
            ),
            SizedBox(
              width: 10,
            ),
            FloatingActionButton(
              onPressed: _modeIsland,
              tooltip: 'Island',
              child: Icon(
                  _mode == 1 ? Icons.border_all_outlined : Icons.border_top),
            ),
            SizedBox(
              width: 10,
            ),
            FloatingActionButton(
              onPressed: _export,
              tooltip: 'Export DFX',
              child: const Icon(Icons.drafts_outlined),
            ),
            SizedBox(
              width: 10,
            )
          ]), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        double width = test!.width ?? (test!.right! - test!.left!);
        double height = test!.height ?? (test!.bottom! - test!.top!);
        TextEditingController widthController =
            new TextEditingController(text: width.toStringAsFixed(2));
        TextEditingController heightController =
            new TextEditingController(text: height.toStringAsFixed(2));

        return AlertDialog(
          title: const Text('Edit element?'),
          content: SizedBox(
              width: 300,
              height: 200,
              child: Column(children: [
                const Text(
                  'Change width and height of a '
                  'selected element or remove it clicking delete.',
                ),
                SizedBox(
                    width: 300,
                    height: 100,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                            width: 100,
                            height: 100,
                            child: TextField(controller: widthController)),
                        Spacer(),
                        SizedBox(
                            width: 100,
                            height: 100,
                            child: TextField(controller: heightController)),
                      ],
                    ))
              ])),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Save'),
              onPressed: () {
                setState(() {
                  //test!.width = double.parse(widthController.text);
                  //test!.height = double.parse(heightController.text);
                  test!.right = test!.left + double.parse(widthController.text);
                  test!.bottom =
                      test!.top + double.parse(heightController.text);
                });
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Delete'),
              onPressed: () {
                setState(() {
                  elements.remove(test);
                  test = null;
                  Navigator.of(context).pop();
                });
              },
            ),
          ],
        );
      },
    );
  }
}
