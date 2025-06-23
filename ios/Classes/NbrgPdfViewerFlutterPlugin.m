@import UIKit;
@import WebKit;

#import "NbrgPdfViewerFlutterPlugin.h"

@interface NbrgPdfViewerFlutterPlugin ()
@end

@implementation NbrgPdfViewerFlutterPlugin{
    FlutterResult _result;
    UIViewController *_viewController;
    WKWebView *_webView;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"nbrg_pdf_viewer_flutter"
                                     binaryMessenger:[registrar messenger]];
    
    UIViewController *viewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    
    NbrgPdfViewerFlutterPlugin *instance = [[NbrgPdfViewerFlutterPlugin alloc] initWithViewController:viewController];
    
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (instancetype)initWithViewController:(UIViewController *)viewController {
    self = [super init];
    if (self) {
        _viewController = viewController;
    }
    return self;
}

- (CGRect)parseRect:(NSDictionary *)rect {
    return CGRectMake([[rect valueForKey:@"left"] doubleValue],
                      [[rect valueForKey:@"top"] doubleValue],
                      [[rect valueForKey:@"width"] doubleValue],
                      [[rect valueForKey:@"height"] doubleValue]);
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if (_result) {
        _result([FlutterError errorWithCode:@"multiple_request"
                                    message:@"Cancelled by a second request"
                                    details:nil]);
        _result = nil;
    }
    
    
    if ([@"launch" isEqualToString:call.method]) {
        
        NSDictionary *rect = call.arguments[@"rect"];
        NSString *path = call.arguments[@"path"];
        
        CGRect rc = [self parseRect:rect];
        
        if (_webView == nil){
            _webView = [[WKWebView alloc] initWithFrame:rc];
            
            NSURL *targetURL = [NSURL fileURLWithPath:path];

            if (@available(iOS 9.0, *)) {
                [_webView loadFileURL:targetURL allowingReadAccessToURL:targetURL];
            } else {
                // untested.
                // _webView.scalesPageToFit = true;
                NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
                [_webView loadRequest:request];
            }

            
            [_viewController.view addSubview:_webView];
        }
        
    } else if ([@"resize" isEqualToString:call.method]) {
        if (_webView != nil) {
            NSDictionary *rect = call.arguments[@"rect"];
            CGRect rc = [self parseRect:rect];
            _webView.frame = rc;
        }
    } else if ([@"close" isEqualToString:call.method]) {
        [self closeWebView];
        result(nil);
    }
    else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)closeWebView {
    if (_webView != nil) {
        [_webView stopLoading];
        [_webView removeFromSuperview];
        _webView = nil;
    }
}

// @implementation NbrgPdfViewerFlutterPlugin
// + (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
//   FlutterMethodChannel* channel = [FlutterMethodChannel
//       methodChannelWithName:@"nbrg_pdf_viewer_flutter"
//             binaryMessenger:[registrar messenger]];
//   NbrgPdfViewerFlutterPlugin* instance = [[NbrgPdfViewerFlutterPlugin alloc] init];
//   [registrar addMethodCallDelegate:instance channel:channel];
// }

// - (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
//   if ([@"getPlatformVersion" isEqualToString:call.method]) {
//     result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
//   } else {
//     result(FlutterMethodNotImplemented);
//   }
// }

// @end

@end
