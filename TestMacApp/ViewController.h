//
//  ViewController.h
//  TestMacApp
//
//  Created by Liron Yahdav on 5/19/21.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@interface ViewController : NSViewController <NSTextFieldDelegate>

@property (weak) IBOutlet WKWebView *webView;
@property (weak) IBOutlet NSView *view1;

@end

