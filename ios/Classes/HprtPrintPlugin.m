#import "HprtPrintPlugin.h"
#if __has_include(<hprt_print/hprt_print-Swift.h>)
#import <hprt_print/hprt_print-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "hprt_print-Swift.h"
#endif

@implementation HprtPrintPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftHprtPrintPlugin registerWithRegistrar:registrar];
}
@end
