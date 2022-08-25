//
//  ViewController.m
//  TestMacApp
//
//  Created by Liron Yahdav on 5/19/21.
//

#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad {
  NSTextView *tv = [[NSTextView alloc] initWithFrame:CGRectMake(50, 50, 300, 100)];
  tv.selectable = YES;
  tv.editable = NO;

  NSDictionary *attributes = @{NSLinkAttributeName: @"http://www.google.com"};
  [tv.textStorage appendAttributedString:[[NSAttributedString alloc] initWithString:@"http://www.google.com" attributes:attributes]];

  [self.view addSubview:tv];
}

@end
