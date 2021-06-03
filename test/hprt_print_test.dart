import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hprt_print/hprt_print.dart';

void main() {
  const MethodChannel channel = MethodChannel('hprt_print');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await HprtPrint.platformVersion, '42');
  });
}
