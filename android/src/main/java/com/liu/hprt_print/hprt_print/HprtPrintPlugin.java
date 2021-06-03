package com.liu.hprt_print.hprt_print;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

import android.content.Context;
import android.content.res.AssetManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.widget.Toast;
//import cpcl.IPort;
import java.io.InputStream;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Set;

import cpcl.PrinterHelper;
//import cpcl.PublicFunction;
/** HprtPrintPlugin */
public class HprtPrintPlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;

    // 上下文 Context
    private Context context;
    FlutterPluginBinding flutt;
    String p;

    public void main(@NonNull FlutterPluginBinding flutterPluginBinding) {
        System.out.println("执行main方法");
        this.context = flutterPluginBinding.getApplicationContext();
    }

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        this.flutt = flutterPluginBinding;
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "hprt_print");
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {

    if (call.method.equals("getPlatformVersion")) {
        String message = call.arguments();
      //result.success("Android " + android.os.Build.VERSION.RELEASE);
      result.success("Android " + message);

    }else if(call.method.equals("printAreaSize")) {
        // 设置标签⾼度
        Map arg = call.arguments();
        //System.out.println("是不是map:"+arg.get("height"));
        try {
            PrinterHelper.printAreaSize((String) arg.get("offset"), (String) arg.get("horizontal"), (String) arg.get("vertical"), (String) arg.get("height"), (String) arg.get("qty"));
            result.success(1);
        } catch (Exception e) {
            e.printStackTrace();
            result.error( "1", e.getMessage(),"");
        }
    }else if(call.method.equals("prints")) {
        // 打印
        try {
            System.out.println("开始打印1");
            final int p = PrinterHelper.Print();
            System.out.println("开始打印2");
            result.success(p);
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println(e.getMessage());
            result.error( "1", e.getMessage(),"");
        }

    }else if(call.method.equals("encoding")) {
        // 设置编码
        Map arg = call.arguments();
        try {
            PrinterHelper.Encoding((String) arg.get("code"));
            result.success(1);
        } catch (Exception e) {
            e.printStackTrace();
            result.error( "1", e.getMessage(),"");
        }

    }else if(call.method.equals("form")) {
        // 标签定位
        try {
            PrinterHelper.Form();
            result.success(1);
        } catch (Exception e) {
            e.printStackTrace();
            result.error( "1", e.getMessage(),"");
        }

    }else if(call.method.equals("note")) {
        // 注释
        Map arg = call.arguments();
        try {
            PrinterHelper.Note((String) arg.get("note"));
            result.success(1);
        } catch (Exception e) {
            e.printStackTrace();
            result.error( "1", e.getMessage(),"");
        }
    }else if(call.method.equals("abort")) {
        try {
            PrinterHelper.Abort();
            result.success(1);
        } catch (Exception e) {
            e.printStackTrace();
            result.error( "1", e.getMessage(),"");
        }
    }else if(call.method.equals("portOpenBT")) {
        // 蓝牙链接
        //portOpenBT(Context context, 'FC:58:FA:2D:77:D8')
        Map arg = call.arguments();
        try {
            final int p = PrinterHelper.portOpenBT(context, (String) arg.get("portSetting"));
            result.success(p);
        } catch (Exception e) {
            result.error( "0", e.getMessage(),"");
        }
    }else if (call.method.equals("text")) {
        Map arg = call.arguments();
        try {

            String command = null;
            if(arg.get("command").equals("TEXT")){
                command = PrinterHelper.TEXT;
                System.out.println("参数:"+command);
            }else if(arg.get("command").equals("TEXT90")){
                command = PrinterHelper.TEXT90;
            }else if(arg.get("command").equals("TEXT180")){
                command = PrinterHelper.TEXT180;
            }else if(arg.get("command").equals("TEXT270")){
                command = PrinterHelper.TEXT270;
            }

            PrinterHelper.Text(command,(String) arg.get("font"),(String) arg.get("size"),(String) arg.get("x"),(String) arg.get("y"),(String) arg.get("data"));

            result.success(1);
        } catch (Exception e) {
            result.error( "0", e.getMessage(),"");
        }
    }else if(call.method.equals("setMag")) {
        Map arg = call.arguments();
        try {
            PrinterHelper.SetMag((String) arg.get("width"),(String) arg.get("height"));
            result.success(1);
        } catch (Exception e) {
            e.printStackTrace();
            result.error( "0", e.getMessage(),"");
        }

    }else if(call.method.equals("align")) {
        Map arg = call.arguments();
        String align;
        if(arg.get("align").equals("LEFT")){
            align = PrinterHelper.LEFT;
        } else if(arg.get("align").equals("CENTER")){
            align = PrinterHelper.CENTER;
        } else {
            align = PrinterHelper.RIGHT;
        }
        try {
            PrinterHelper.Align(align);
            result.success(1);
        } catch (Exception e) {
            result.error( "0", e.getMessage(),"");
        }

    }if(call.method.equals("barcode")) {
        // 打印条形码
        Map arg = call.arguments();
          String command;
          if(arg.get("command").equals("BARCODE")) {
              command = PrinterHelper.BARCODE;
          } else {
              command = PrinterHelper.VBARCODE;
          }
        try {
            PrinterHelper.Barcode(command, PrinterHelper.code128, (String) arg.get("width"), (String) arg.get("ratio"), (String) arg.get("height"), (String) arg.get("x"), (String) arg.get("y"), (boolean) arg.get("undertext"), (String) arg.get("number"), (String) arg.get("size"), (String) arg.get("offset"), (String) arg.get("data"));
            result.success(1);
        } catch (Exception e) {
            result.error( "0", e.getMessage(),"");
        }

    }else if(call.method.equals("printBitmap")) {
        // 打印图片
        Map arg = call.arguments();
        final Bitmap bmp = BitmapFactory.decodeFile((String) arg.get("imgPath"));
        if (bmp == null) {
            System.out.println("图片为空"+arg.get("imgPath"));
            result.error("111", "读取不到图片", "");
        }
        try {
            PrinterHelper.printBitmap((int) arg.get("x"), (int) arg.get("y"), (int) arg.get("type"), bmp, (int) arg.get("compressType"), (boolean) arg.get("isform"), (int) arg.get("segments"));
            result.success(1);
        } catch (Exception e) {
            result.error("0", e.getMessage(), "");
        }

    }else if(call.method.equals("box")) {
          Map arg = call.arguments();
       try {
           System.out.println("box1");
            PrinterHelper.Box((String) arg.get("x0"), (String) arg.get("y0"), (String) arg.get("x1"), (String) arg.get("y1"), (String) arg.get("width"));
           System.out.println("box1");
           result.success(1);
       } catch (Exception e) {
            result.error( "0", e.getMessage(),"");
       }

    }else if(call.method.equals("printBitmapCPCL")) {
          Map arg = call.arguments();
          byte[] b = (byte[]) arg.get("bytes");
          Bitmap bmp = null;
          System.out.println("图片byte:"+b);
          if (b.length != 0) {
              bmp =  BitmapFactory.decodeByteArray(b, 0, b.length);
          }
          try {
              final int p = PrinterHelper.printBitmapCPCL(bmp, (int) arg.get("x"), (int) arg.get("y"), (int) arg.get("type"), (int) arg.get("compressType"),(int) arg.get("light"));
              result.success(1);
          } catch (Exception e) {
              System.out.println("jun:"+e.getMessage());
              e.printStackTrace();
              result.error( "1", e.getMessage(),"");
          }
    }else  if(call.method.equals("line")) {
          Map arg = call.arguments();
          try {
              PrinterHelper.Line((String) arg.get("x0"),(String) arg.get("y0"),(String) arg.get("x1"),(String) arg.get("y1"),(String) arg.get("width"));
              result.success(1);
          } catch (Exception e) {
              e.printStackTrace();
              result.error( "1", e.getMessage(),"");
          }
    }else if (call.method.equals("printCodepageTextCPCL")) {
          Map arg = call.arguments();
          String command;
          if(arg.get("command").equals("TEXT")){
              command = PrinterHelper.TEXT;
          }else{
              command = PrinterHelper.TEXT270;
          }

          try {
              PrinterHelper.PrintCodepageTextCPCL(command, (int) arg.get("font"), (String) arg.get("x"), (String) arg.get("y"), (String) arg.get("data"), (int) arg.get("n"));
              result.success(1);
          } catch (Exception e) {
              e.printStackTrace();
              result.error( "1", e.getMessage(),"");
          }
    }else if(call.method.equals("pageWidth")) {
          Map arg = call.arguments();
          try {
              PrinterHelper.PageWidth((String) arg.get("pw"));
              result.success(1);
          } catch (Exception e) {
              e.printStackTrace();
              result.error( "1", e.getMessage(),"");
          }

    }else if(call.method.equals("autCenter")) {
          Map arg = call.arguments();
          String command;
          if(arg.get("command").equals("TEXT")){
              command = PrinterHelper.TEXT;
          }else{
              command = PrinterHelper.TEXT270;
          }
          try {
              PrinterHelper.AutCenter(command, (String) arg.get("x"), (String) arg.get("y"), (int) arg.get("width"), (int) arg.get("size"),(String) arg.get("str"));
              result.success(1);
          } catch (Exception e) {
              e.printStackTrace();
              result.error( "1", e.getMessage(),"");
          }
    }else if(call.method.equals("country")) {
          Map arg = call.arguments();
          try {
              PrinterHelper.Country((String) arg.get("codepage"));
              result.success(1);
          } catch (Exception e) {
              e.printStackTrace();
              result.error( "1", e.getMessage(),"");
          }

    }else if(call.method.equals("languageEncode")) {
          Map arg = call.arguments();
          PrinterHelper.LanguageEncode = (String) arg.get("languageEncode");
          result.success(1);

    }else if(call.method.equals("setKhemrEnd")) {
          try {
              PrinterHelper.setKhemrEnd();
              result.success(1);
          } catch (Exception e) {
              e.printStackTrace();
              result.error( "1", e.getMessage(),"");
          }
    }else if(call.method.equals("autLine")) {
          Map arg = call.arguments();
          try {
              PrinterHelper.AutLine((String) arg.get("x"),(String) arg.get("y"),(int) arg.get("width"),(int) arg.get("size"),(boolean) arg.get("isbole"),(boolean) arg.get("isdouble"),(String) arg.get("str"));
              result.success(1);
          } catch (Exception e) {
              e.printStackTrace();
              result.error( "1", e.getMessage(),"");
          }

    }else if(call.method.equals("autLine2")) {
          Map arg = call.arguments();
          System.out.println("是不是map:"+arg);
          try {
              //PrinterHelper.LanguageEncode = "UnicodeBigUnmarked";
              //PrinterHelper.Country("Khemr");
              PrinterHelper.AutLine2((String) arg.get("x"),(String) arg.get("y"),(String) arg.get("width"),(int) arg.get("size"),(boolean) arg.get("isbole"),(boolean) arg.get("isdouble"),(String) arg.get("str"));
              result.success(1);
          } catch (Exception e) {
              e.printStackTrace();
              result.error( "1", e.getMessage(),"");
          }
    }else if(call.method.equals("inverseLine")) {
          Map arg = call.arguments();
          try {
              PrinterHelper.InverseLine((String) arg.get("x0"), (String) arg.get("y0"), (String) arg.get("x1"), (String) arg.get("y1"), (String) arg.get("width"));
              result.success(1);
          } catch (Exception e) {
              e.printStackTrace();
              result.error( "1", e.getMessage(),"");
          }

    }else if(call.method.equals("printQR")) {
        Map arg = call.arguments();
        try {
            PrinterHelper.PrintQR(PrinterHelper.BARCODE, (String) arg.get("x"), (String) arg.get("y"), (String) arg.get("m"), (String) arg.get("u"), (String) arg.get("data"));
            result.success(1);
        } catch (Exception e) {
            e.printStackTrace();
            result.error( "1", e.getMessage(),"");
        }

    }else if(call.method.equals("portClose")) {
        try {
            PrinterHelper.portClose();
            result.success(1);
        } catch (Exception e) {
            e.printStackTrace();
            result.error( "1", e.getMessage(),"");
        }
    }else {
        result.notImplemented();
    }
  }












    @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }
}
