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
    String barcode = 'CE000001376';
    String sName = 'មន្ទីរភ្នំពេញ';
    String sPhone = '15492666';
    //String sAddress = 'No 80-82 St.566 Boeung Kok II, រាជធានី​ភ្នំពេញ ';
    String sAddress = 'Ekareach Street 100, Preah Sihanouk ក្រុងព្រះសីហនុ';
    //=========================
    String rName = 'វិទ្យាល័យ';
    String rPhone = '15492666';
    String rAddress = 'វិទ្យាល័យ ហ៊ុន សែន មិត្តភាព ខេត្តព្រះសីហនុ';
    String qrData =
        'http://op.yundasys.com/opserver/pages/waydetail/waydetail.html?openid=4bATXJSiktbxdygnM7ACyCBP&appid=wxapp&mailno=4314475813282';

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
    // 打印图片
    await HprtPrint.printBitmapCPCL(
      bytes: bytes,
      x: 0,
      y: 16,
      type: 0,
      compressType: 0,
      light: 0,
    );

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

    await HprtPrint.barcode(
        command: 'BARCODE',
        type: 'code128',
        width: '2',
        ratio: '2',
        height: '80',
        x: '160',
        y: '145',
        undertext: true,
        number: '0',
        size: '0',
        offset: '1',
        data: barcode);
    //打印直线 2
    await HprtPrint.line(x0: "0", y0: "262", x1: "750", y1: "262", width: "2");

    //打印图片====================================
    // 上面--------
    await HprtPrint.printBitmapCPCL(
      bytes: sBytes,
      x: 20,
      y: 300,
      type: 0,
      compressType: 0,
      light: 0,
    );
    await HprtPrint.printBitmapCPCL(
      bytes: rBytes,
      x: 20,
      y: 415,
      type: 0,
      compressType: 0,
      light: 0,
    );

    // 中间--------
    await HprtPrint.printBitmapCPCL(
      bytes: logo2,
      x: 20,
      y: 704,
      type: 0,
      compressType: 0,
      light: 0,
    );
    await HprtPrint.printBitmapCPCL(
      bytes: sBytes,
      x: 20,
      y: 793,
      type: 0,
      compressType: 0,
      light: 0,
    );
    // 下面---------
    await HprtPrint.printBitmapCPCL(
        bytes: logo2, x: 20, y: 1008, type: 0, compressType: 0, light: 0);
    await HprtPrint.printBitmapCPCL(
        bytes: rBytes, x: 20, y: 1104, type: 0, compressType: 0, light: 0);

    // logo 2;
    // 设置柬文
    await HprtPrint.country(codepage: 'Khemr');
    await HprtPrint.languageEncode(languageEncode: 'UnicodeBigUnmarked');

    await HprtPrint.printCodepageTextCPCL(
        command: 'TEXT', font: 0, x: '100', y: '265', data: 'Name:', n: 0);
    await HprtPrint.printCodepageTextCPCL(
        command: 'TEXT', font: 0, x: '170', y: '265', data: sName, n: 0);
    await HprtPrint.printCodepageTextCPCL(
        command: 'TEXT', font: 0, x: '350', y: '265', data: 'Phone:', n: 0);
    await HprtPrint.printCodepageTextCPCL(
        command: 'TEXT', font: 0, x: '420', y: '265', data: sPhone, n: 0);
    await HprtPrint.printCodepageTextCPCL(
        command: 'TEXT', font: 0, x: '100', y: '297', data: 'Address:', n: 0);
    await HprtPrint.autLine2(
        x: '200',
        y: '297',
        width: '380',
        size: 0,
        isbole: false,
        isdouble: false,
        str: sAddress);

    //打印直线 3 上 收件人信息
    await HprtPrint.line(x0: "0", y0: "395", x1: "750", y1: "395", width: "2");

    await HprtPrint.printCodepageTextCPCL(
        command: 'TEXT', font: 0, x: '100', y: '398', data: 'Name:', n: 0);
    await HprtPrint.printCodepageTextCPCL(
        command: 'TEXT', font: 0, x: '170', y: '398', data: rName, n: 0);
    await HprtPrint.printCodepageTextCPCL(
        command: 'TEXT', font: 0, x: '350', y: '398', data: 'Phone:', n: 0);
    await HprtPrint.printCodepageTextCPCL(
        command: 'TEXT', font: 0, x: '420', y: '398', data: rPhone, n: 0);
    await HprtPrint.printCodepageTextCPCL(
        command: 'TEXT', font: 0, x: '100', y: '430', data: 'Address:', n: 0);
    await HprtPrint.autLine2(
        x: '200',
        y: '430',
        width: '380',
        size: 0,
        isbole: false,
        isdouble: false,
        str: rAddress);

    //打印直线 4
    await HprtPrint.line(x0: "0", y0: "524", x1: "750", y1: "524", width: "2");
    await HprtPrint.printCodepageTextCPCL(
        command: 'TEXT', font: 0, x: '16', y: '530', data: 'Weight:', n: 0);
    await HprtPrint.printCodepageTextCPCL(
        command: 'TEXT', font: 0, x: '116', y: '530', data: '1 KG', n: 0);
    await HprtPrint.printCodepageTextCPCL(
        command: 'TEXT', font: 0, x: '16', y: '562', data: 'Payment:', n: 0);
    await HprtPrint.printCodepageTextCPCL(
        command: 'TEXT', font: 0, x: '116', y: '562', data: 'CODPay', n: 0);

    await HprtPrint.printCodepageTextCPCL(
        command: 'TEXT', font: 0, x: '16', y: '615', data: 'COD:', n: 0);
    await HprtPrint.printCodepageTextCPCL(
        command: 'TEXT', font: 0, x: '85', y: '615', data: '\$ 27.5', n: 0);

    // 反白
    await HprtPrint.inverseLine(
        x0: '10', y0: '610', x1: '190', y1: '610', width: '60');
    // 画竖线1
    await HprtPrint.line(
        x0: "200", y0: "524", x1: "200", y1: "680", width: "2");
    await HprtPrint.printCodepageTextCPCL(
        command: 'TEXT', font: 0, x: '210', y: '530', data: 'Freight:', n: 0);
    await HprtPrint.printCodepageTextCPCL(
        command: 'TEXT', font: 0, x: '328', y: '530', data: '\$ 0.80', n: 0);

    await HprtPrint.printCodepageTextCPCL(
        command: 'TEXT', font: 0, x: '210', y: '562', data: 'Packing:', n: 0);
    await HprtPrint.printCodepageTextCPCL(
        command: 'TEXT', font: 0, x: '328', y: '562', data: '\$ 0.40', n: 0);
    await HprtPrint.printCodepageTextCPCL(
        command: 'TEXT', font: 0, x: '210', y: '594', data: 'Insurance:', n: 0);
    await HprtPrint.printCodepageTextCPCL(
        command: 'TEXT', font: 0, x: '328', y: '594', data: '\$ 0.00', n: 0);

    await HprtPrint.printCodepageTextCPCL(
        command: 'TEXT', font: 0, x: '215', y: '630', data: 'Total:', n: 0);
    await HprtPrint.printCodepageTextCPCL(
        command: 'TEXT', font: 0, x: '312', y: '630', data: '\$ 1.20', n: 0);
    // 反白
    await HprtPrint.inverseLine(
        x0: '210', y0: '630', x1: '408', y1: '630', width: '45');

    // 画竖线2
    await HprtPrint.line(
        x0: "420", y0: "524", x1: "420", y1: "680", width: "2");
    await HprtPrint.printCodepageTextCPCL(
        command: 'TEXT', font: 0, x: '430', y: '530', data: ' Signer:', n: 0);

    /////////上面 结束 =======================
    // 打印矩形框
    await HprtPrint.box(x0: "0", y0: "696", x1: "750", y1: "968", width: "2");

    await HprtPrint.barcode(
        command: 'BARCODE',
        type: 'code128',
        width: '1',
        ratio: '30',
        height: '40',
        x: '400',
        y: '704',
        undertext: true,
        number: '0',
        size: '0',
        offset: '0',
        data: barcode);
    await HprtPrint.line(x0: "0", y0: "776", x1: "750", y1: "776", width: "2");
    // 中间 --- 发件人信息
    await HprtPrint.printCodepageTextCPCL(
        command: 'TEXT', font: 0, x: '100', y: '777', data: 'Name:', n: 0);
    await HprtPrint.printCodepageTextCPCL(
        command: 'TEXT', font: 0, x: '170', y: '777', data: sName, n: 0);
    await HprtPrint.printCodepageTextCPCL(
        command: 'TEXT', font: 0, x: '350', y: '777', data: 'Phone:', n: 0);
    await HprtPrint.printCodepageTextCPCL(
        command: 'TEXT', font: 0, x: '420', y: '777', data: sPhone, n: 0);
    await HprtPrint.printCodepageTextCPCL(
        command: 'TEXT', font: 0, x: '100', y: '809', data: 'Address:', n: 0);
    await HprtPrint.autLine2(
        x: '200',
        y: '809',
        width: '380',
        size: 0,
        isbole: false,
        isdouble: false,
        str: sAddress);
    await HprtPrint.line(x0: "0", y0: "900", x1: "750", y1: "900", width: "2");
    await HprtPrint.printCodepageTextCPCL(
        command: 'TEXT',
        font: 0,
        x: '16',
        y: '916',
        data: 'Total freight:',
        n: 0);
    await HprtPrint.printCodepageTextCPCL(
        command: 'TEXT', font: 0, x: '192', y: '916', data: '\$ 1.20', n: 0);
    await HprtPrint.printCodepageTextCPCL(
        command: 'TEXT', font: 0, x: '322', y: '916', data: 'COD:', n: 0);
    await HprtPrint.printCodepageTextCPCL(
        command: 'TEXT', font: 0, x: '380', y: '916', data: '\$ 27.5', n: 0);
    // 下面==================
    // 打印矩形框
    await HprtPrint.box(x0: "0", y0: "992", x1: "750", y1: "1400", width: "2");
    await HprtPrint.printCodepageTextCPCL(
        command: 'TEXT', font: 0, x: '220', y: '992', data: dataTime, n: 0);
    await HprtPrint.barcode(
        command: 'BARCODE',
        type: 'code128',
        width: '1',
        ratio: '0',
        height: '50',
        x: '400',
        y: '1000',
        undertext: true,
        number: '0',
        size: '0',
        offset: '0',
        data: barcode);
    await HprtPrint.line(
        x0: "0", y0: "1096", x1: "750", y1: "1096", width: "2");
    // 下面 --- 收件人信息
    await HprtPrint.printCodepageTextCPCL(
        command: 'TEXT', font: 0, x: '100', y: '1104', data: 'Name:', n: 0);
    await HprtPrint.printCodepageTextCPCL(
        command: 'TEXT', font: 0, x: '170', y: '1104', data: rName, n: 0);
    await HprtPrint.printCodepageTextCPCL(
        command: 'TEXT', font: 0, x: '350', y: '1104', data: 'Phone:', n: 0);
    await HprtPrint.printCodepageTextCPCL(
        command: 'TEXT', font: 0, x: '420', y: '1104', data: rPhone, n: 0);
    await HprtPrint.printCodepageTextCPCL(
        command: 'TEXT', font: 0, x: '100', y: '1136', data: 'Address:', n: 0);
    await HprtPrint.autLine2(
        x: '200',
        y: '1136',
        width: '380',
        size: 0,
        isbole: false,
        isdouble: false,
        str: rAddress);

    await HprtPrint.line(
        x0: "0", y0: "1244", x1: "750", y1: "1244", width: "2");
    await HprtPrint.printCodepageTextCPCL(
        command: 'TEXT', font: 0, x: '16', y: '1252', data: 'Weight:', n: 0);
    await HprtPrint.printCodepageTextCPCL(
        command: 'TEXT', font: 0, x: '116', y: '1252', data: '1 KG', n: 0);
    await HprtPrint.printCodepageTextCPCL(
        command: 'TEXT', font: 0, x: '16', y: '1284', data: 'Payment:', n: 0);
    await HprtPrint.printCodepageTextCPCL(
        command: 'TEXT', font: 0, x: '116', y: '1284', data: 'CODPay', n: 0);
    await HprtPrint.printCodepageTextCPCL(
        command: 'TEXT', font: 0, x: '16', y: '1316', data: 'COD:', n: 0);
    await HprtPrint.printCodepageTextCPCL(
        command: 'TEXT', font: 0, x: '85', y: '1316', data: '\$ 27.5', n: 0);
    // 画竖线1
    await HprtPrint.line(
        x0: "200", y0: "1244", x1: "200", y1: "1400", width: "2");
    await HprtPrint.printCodepageTextCPCL(
        command: 'TEXT', font: 0, x: '210', y: '1252', data: 'Freight:', n: 0);
    await HprtPrint.printCodepageTextCPCL(
        command: 'TEXT', font: 0, x: '328', y: '1252', data: '\$ 0.80', n: 0);

    await HprtPrint.printCodepageTextCPCL(
        command: 'TEXT', font: 0, x: '210', y: '1284', data: 'Packing:', n: 0);
    await HprtPrint.printCodepageTextCPCL(
        command: 'TEXT', font: 0, x: '328', y: '1284', data: '\$ 0.40', n: 0);
    await HprtPrint.printCodepageTextCPCL(
        command: 'TEXT',
        font: 0,
        x: '210',
        y: '1316',
        data: 'Insurance:',
        n: 0);
    await HprtPrint.printCodepageTextCPCL(
        command: 'TEXT', font: 0, x: '328', y: '1316', data: '\$ 0.00', n: 0);

    await HprtPrint.printCodepageTextCPCL(
        command: 'TEXT', font: 0, x: '215', y: '1348', data: 'Total:', n: 0);
    await HprtPrint.printCodepageTextCPCL(
        command: 'TEXT', font: 0, x: '312', y: '1348', data: '\$ 1.20', n: 0);

    // 画竖线2
    await HprtPrint.line(
        x0: "420", y0: "1244", x1: "420", y1: "1400", width: "2");
    await HprtPrint.setKhemrEnd; // 必须关闭柬文
    await HprtPrint.languageEncode(
        languageEncode: 'gb2312'); // 重新设置编码/否则下一张打不出图像条码
    await HprtPrint.printQR(x: '428', y: '1252', m: '1', u: '3', data: qrData);
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
