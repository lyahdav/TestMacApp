//
//  ViewController.m
//  TestMacApp
//
//  Created by Liron Yahdav on 5/19/21.
//

#import "ViewController.h"

@implementation ViewController

- (void)addButton:(CGFloat)y {
  NSButton *btn = [[NSButton alloc] initWithFrame:CGRectMake(50, y, 300, 50)];
  btn.title = @"Button";
  [self.view addSubview:btn];
}

- (void)viewDidLoad {
  [self addButton:0];
  
  NSTextView *tv = [[NSTextView alloc] initWithFrame:CGRectMake(50, 60, 300, 40)];
  [tv.textStorage appendAttributedString:[[NSAttributedString alloc] initWithString:@"NSTextView"]];
  tv.maxSize = CGSizeMake(300, 100);
  tv.selectable = YES;
  tv.editable = NO;
  [self.view addSubview:tv];


  NSTextField *tf = [[NSTextField alloc] initWithFrame:CGRectMake(50, 100, 300, 40)];
  tf.selectable = YES;
  tf.editable = NO;
  tf.stringValue = @"NSTextField";
  [self.view addSubview:tf];

  
  [self addButton:200];
}

@end
