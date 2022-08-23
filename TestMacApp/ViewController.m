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
  tv.maxSize = CGSizeMake(300, 100);
  tv.selectable = YES;
  tv.editable = YES;
  [self.view addSubview:tv];
}

@end
