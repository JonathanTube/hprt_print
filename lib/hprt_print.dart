import 'dart:async';

import 'package:flutter/services.dart';
//import 'package:path_provider/path_provider.dart';

class HprtPrint {
  static const MethodChannel _channel = const MethodChannel('hprt_print');

  static Future<String?> platformVersion({String? se}) async {
    final String? version =
        await _channel.invokeMethod('getPlatformVersion', se);
    return version;
  }

  // 设置标签高度
  static Future<int?> printAreaSize(
      {offset, horizontal, vertical, height, qty}) async {
    final int? p = await _channel.invokeMethod('printAreaSize', {
      'offset': offset,
      'horizontal': horizontal,
      'vertical': vertical,
      'height': height,
      'qty': qty
    });
    return p;
  }

  static Future<int?> get prints async {
    final int? p = await _channel.invokeMethod('prints');
    return p;
  }

  static Future<int?> encoding({code}) async {
    final int? p = await _channel.invokeMethod('encoding', {'code': code});
    return p;
  }

  static Future<int?> get form async {
    final int? p = await _channel.invokeMethod('form');
    return p;
  }

  static Future<int?> portOpenBT({portSetting}) async {
    final int? p =
        await _channel.invokeMethod('portOpenBT', {'portSetting': portSetting});
    return p;
  }

  static Future<int?> text({command, font, size, x, y, data}) async {
    final int? p = await _channel.invokeMethod('text', {
      'command': command,
      'font': font,
      'size': size,
      'x': x,
      'y': y,
      'data': data
    });
    return p;
  }

  static Future<int?> setMag({width, height}) async {
    final int? p = await _channel
        .invokeMethod('setMag', {'width': width, 'height': height});
    return p;
  }

  static Future<int?> align({align}) async {
    final int? p = await _channel.invokeMethod('align', {'align': align});
    return p;
  }

  // 打印条形码
  static Future<int?> barcode(
      {command,
      type,
      width,
      ratio,
      height,
      x,
      y,
      undertext,
      number,
      size,
      offset,
      data}) async {
    final int? p = await _channel.invokeMethod('barcode', {
      'command': command,
      'type': type,
      'width': width,
      'ratio': ratio,
      'height': height,
      'x': x,
      'y': y,
      'undertext': undertext,
      'number': number,
      'size': size,
      'offset': offset,
      'data': data
    });
    return p;
  }

  // 打印图片
  // static Future<int?> printBitmap(
  //     {x, y, type, bytes, compressType, isform, segments}) async {
  //   // 读取缓存路径List<int> bytes
  //   // int x,int y,int type,List<int> bytes, int compressType,bool isform, int segments
  //   // Directory tempDir = await getTemporaryDirectory();
  //   // // 创建目录
  //   // Directory('${tempDir.path}/testhy').create(recursive: true);
  //   // // 写入文件
  //   // await File('${tempDir.path}/testhy/img.jpg').writeAsBytes(bytes);

  //   final Directory directory = await getApplicationDocumentsDirectory();
  //   final File file = File('${directory.path}/img.jpg');
  //   await file.writeAsBytes(bytes);

  //   final int? p = await _channel.invokeMethod('printBitmap', {
  //     'x': x,
  //     'y': y,
  //     'type': type,
  //     'imgPath': "${directory.path}/img.jpg",
  //     'compressType': compressType,
  //     'isform': isform,
  //     'segments': segments
  //   });
  //   return p;
  // }

  // 打印图片
  static Future<int?> printBitmapCPCL(
      {bytes, x, y, type, compressType, light}) async {
    // final Directory directory = await getApplicationDocumentsDirectory();
    // final File file = File('${directory.path}/img.jpg');
    // await file.writeAsBytes(bytes);

    final int? p = await _channel.invokeMethod('printBitmapCPCL', {
      'bytes': bytes,
      'x': x,
      'y': y,
      'type': type,
      'compressType': compressType,
      'light': light,
    });
    return p;
  }

  static Future<int?> box({x0, y0, x1, y1, width}) async {
    final int? p = await _channel.invokeMethod(
        'box', {'x0': x0, 'y0': y0, 'x1': x1, 'y1': y1, 'width': width});
    return p;
  }

  static Future<int?> line({x0, y0, x1, y1, width}) async {
    final int? p = await _channel.invokeMethod('line', {
      'x0': x0,
      'y0': y0,
      'x1': x1,
      'y1': y1,
      'width': width,
    });
    return p;
  }

  // 打印文本
  static Future<int?> printCodepageTextCPCL(
      {command, font, x, y, data, n}) async {
    final int? p = await _channel.invokeMethod('printCodepageTextCPCL', {
      'command': command,
      'font': font,
      'x': x,
      'y': y,
      'data': data,
      'n': n,
    });
    return p;
  }

  static Future<int?> pageWidth({pw}) async {
    final int? p = await _channel.invokeMethod('pageWidth', {
      'pw': pw,
    });
    return p;
  }

  static Future<int?> autCenter({command, x, y, width, size, str}) async {
    final int? p = await _channel.invokeMethod('autCenter', {
      'command': command,
      'x': x,
      'y': y,
      'width': width,
      'size': size,
      'str': str,
    });
    return p;
  }

  static Future<int?> country({codepage}) async {
    final int? p = await _channel.invokeMethod('country', {
      'codepage': codepage,
    });
    return p;
  }

  static Future<int?> languageEncode({languageEncode}) async {
    final int? p = await _channel.invokeMethod('languageEncode', {
      'languageEncode': languageEncode,
    });
    return p;
  }

  static Future<int?> get setKhemrEnd async {
    final int? p = await _channel.invokeMethod('setKhemrEnd');
    return p;
  }

  static Future<int?> autLine(
      {x, y, width, size, isbole, isdouble, str}) async {
    final int? p = await _channel.invokeMethod('autLine', {
      'x': x,
      'y': y,
      'width': width,
      'size': size,
      'isbole': isbole,
      'isdouble': isdouble,
      'str': str
    });
    return p;
  }

  static Future<int?> autLine2(
      {x, y, width, size, isbole, isdouble, str}) async {
    final int? p = await _channel.invokeMethod('autLine2', {
      'x': x,
      'y': y,
      'width': width,
      'size': size,
      'isbole': isbole,
      'isdouble': isdouble,
      'str': str
    });
    return p;
  }

  static Future<int?> inverseLine({x0, y0, x1, y1, width}) async {
    final int? p = await _channel.invokeMethod('inverseLine', {
      'x0': x0,
      'y0': y0,
      'x1': x1,
      'y1': y1,
      'width': width,
    });
    return p;
  }

  static Future<int?> printQR({x, y, m, u, data}) async {
    final int? p = await _channel.invokeMethod('printQR', {
      'x': x,
      'y': y,
      'm': m,
      'u': u,
      'data': data,
    });
    return p;
  }

  static Future<int?> get portClose async {
    final int? p = await _channel.invokeMethod('portClose');
    return p;
  }



  // // 打印
  // static Future<String?> prints(var data) async {
  //   final String? p = await _channel.invokeMethod('prints', data);
  //   return p;
  // }
  // // 终⽌指令
  // static Future<String?> get abort async {
  //   final String? p = await _channel.invokeMethod('Abort');
  //   return p;
  // }

  // // 打印
  // static Future<String?> get hPrint async {
  //   final String? p = await _channel.invokeMethod('hPrint');
  //   return p;
  // }
}
