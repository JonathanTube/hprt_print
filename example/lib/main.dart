import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:hprt_print/hprt_print.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter_blue/flutter_blue.dart';
//import 'package:image/image.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  int _status = 0;
  FlutterBlue flutterBlue = FlutterBlue.instance;

  bool isBleOn = false;
  List deviceSet = [];
  @override
  void initState() {
    super.initState();
    initPlatformState();

    flutterBlue.state.listen((state) {
      if (state == BluetoothState.on) {
        print('蓝牙状态为开启');
        isBleOn = true;
      } else if (state == BluetoothState.off) {
        print('蓝牙状态为关闭');
        isBleOn = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: BotToastInit(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: RefreshIndicator(
          onRefresh: () =>
              FlutterBlue.instance.startScan(timeout: Duration(seconds: 4)),
          child: Column(
            children: [
              Text(
                '蓝牙打印设备',
                style: TextStyle(fontSize: 24, color: Colors.black38),
              ),
              Expanded(
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        String id = deviceSet[index]['id'];
                        lanya(id);
                        //lanya('FC:58:FA:2D:77:D8');
                      },
                      title: Text(deviceSet[index]['name']),
                      subtitle: Text(deviceSet[index]['id']),
                      trailing: Icon(Icons.print),
                    );
                  },
                  itemCount: deviceSet.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider();
                  },
                ),
              ),

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  print('打印CE');
                  ce();
                },
                child: Text('打印电子运单'),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
        floatingActionButton: StreamBuilder<bool>(
          stream: FlutterBlue.instance.isScanning,
          initialData: false,
          builder: (c, snapshot) {
            if (snapshot.data!) {
              return FloatingActionButton(
                child: Icon(Icons.stop),
                onPressed: () => FlutterBlue.instance.stopScan(),
                backgroundColor: Colors.red,
              );
            } else {
              return FloatingActionButton(
                  child: Icon(Icons.search), onPressed: () => scanBlue());
            }
          },
        ),
      ),
    );
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;

    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          //await HprtPrint.platformVersion ?? 'Unknown platform version';
          (await HprtPrint.platformVersion(se: '这是传参1'))!;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  scanBlue() {
    deviceSet = [];
    BotToast.showLoading();
    if (isBleOn) {
      print('扫描蓝牙设备');
      flutterBlue.scan().listen((scanResult) {
        // do something with scan result
        var device = scanResult.device;
        if (device.name.length > 8) {
          if (deviceSet.indexOf(device) == -1) {
            print('是什么');
            // print(device);
            String id = device.id.toString().replaceAll('FD:', 'FC:');
            print(id);
            Map ss = {'name': '${device.name}', 'id': '$id'};
            setState(() {
              deviceSet.add(ss);
            });
          }
          print(
              '${device.name} found! rssi: ${scanResult.rssi},address:${device.id}');
        }
      });
      //延时500毫秒执行
      Future.delayed(const Duration(milliseconds: 4000), () {
        if (deviceSet.length <= 0) {
          print('未搜索到蓝牙设备');
          BotToast.closeAllLoading();
          BotToast.showText(text: '未搜索到蓝牙设备');
        } else {
          setState(() {
            //延时更新状态
          });
          BotToast.closeAllLoading();
          flutterBlue.stopScan();
        }
      });
    }
  }

  // 行号 4 * 8 = 32
  Future<void> ce() async {
    // 读取资源文件
    ByteData data = await rootBundle.load("assets/icon/logo.jpg");
    // 转byte
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    ByteData s = await rootBundle.load("assets/icon/s.jpg");
    List<int> sBytes = s.buffer.asUint8List(s.offsetInBytes, s.lengthInBytes);
    ByteData r = await rootBundle.load("assets/icon/r.jpg");
    List<int> rBytes = r.buffer.asUint8List(r.offsetInBytes, r.lengthInBytes);
    ByteData logo2s = await rootBundle.load("assets/icon/logo2.jpg");
    List<int> logo2 =
        logo2s.buffer.asUint8List(logo2s.offsetInBytes, logo2s.lengthInBytes);

    String shopCode = 'CE00001';
    String staffCode = 'CE0085';
    String tel = 'Tel:23921666';
    String city = 'Phonm Penh';
    String dataTime = '2021/5/31';
    
    // 设置标签高
    await HprtPrint.printAreaSize(
        offset: "0",
        horizontal: "200",
        vertical: "200",
        height: "1440",
        qty: "1");
    // 打印页面宽度
    await HprtPrint.pageWidth(pw: "750");
    // 打印矩形框
    await HprtPrint.box(x0: "0", y0: "8", x1: "750", y1: "680", width: "2");
 

    await HprtPrint.printCodepageTextCPCL(
        command: 'TEXT', font: 0, x: '220', y: '16', data: shopCode, n: 0);
    await HprtPrint.printCodepageTextCPCL(
        command: 'TEXT', font: 0, x: '220', y: '48', data: staffCode, n: 0);
    await HprtPrint.printCodepageTextCPCL(
        command: 'TEXT', font: 0, x: '220', y: '85', data: tel, n: 0);

    await HprtPrint.align(align: "RIGHT");
    await HprtPrint.setMag(width: "2", height: "2");
    await HprtPrint.printCodepageTextCPCL(
        command: 'TEXT', font: 1, x: '0', y: '64', data: city, n: 0);

    await HprtPrint.setMag(width: "1", height: "1"); // 关闭放⼤
    await HprtPrint.align(align: "LEFT");
    await HprtPrint.printCodepageTextCPCL(
        command: 'TEXT', font: 0, x: '420', y: '16', data: dataTime, n: 0);

    //打印直线 1
    await HprtPrint.line(x0: "0", y0: "136", x1: "750", y1: "136", width: "2");

    

  
    await HprtPrint.form;
    await HprtPrint.prints;
  }

  lanya(String id) async {
    print('蓝牙id:' + id);
    BotToast.showLoading();
    _status = (await HprtPrint.portOpenBT(portSetting: id))!;
    if (_status == 0) {
      BotToast.cleanAll();
      BotToast.showText(text: "蓝牙打印机链接成功");
    } else {
      BotToast.cleanAll();
      print("失败:$_status");
    }
  }

  lianjie() async {
    BotToast.showLoading();
    _status = (await HprtPrint.portOpenBT(portSetting: 'FC:58:FA:2D:77:D8'))!;
    if (_status == 0) {
      BotToast.cleanAll();
      BotToast.showText(text: "打印机链接成功");
    } else {
      BotToast.showText(text: "连接失败");
      BotToast.cleanAll();
      print("失败:$_status");
    }
  }
}
