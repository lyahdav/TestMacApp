//
//  ViewController.m
//  TestMacApp
//
//  Created by Liron Yahdav on 5/19/21.
//

#import "ViewController.h"

@implementation ViewController {
  NSPopover* _popover;
}

- (IBAction)button1Tapped:(id)sender {
  _popover = [NSPopover new];
  NSViewController *vc = [NSViewController new];
  vc.view = [NSView new];
  vc.view.frame = CGRectMake(0, 0, 100, 100);
  _popover.contentViewController = vc;
  _popover.contentSize = CGSizeMake(100, 100);
  _popover.delegate = self;
  
  [_popover showRelativeToRect:CGRectMake(0, 0, 10, 10) ofView:self.view preferredEdge:NSRectEdgeMinX];
}

- (void)popoverDidClose:(NSNotification*)notification {
  NSLog(@"popoverDidClose");
}

- (IBAction)button2Tapped:(id)sender {
  NSPopover* _popover2;
  _popover2 = [NSPopover new];
  NSViewController *vc = [NSViewController new];
  vc.view = [NSView new];
  vc.view.frame = CGRectMake(0, 0, 100, 100);
  _popover2.contentViewController = vc;
  _popover2.contentSize = CGSizeMake(100, 100);
  _popover2.delegate = self;
  
  [_popover2 showRelativeToRect:CGRectMake(0, 0, 10, 10) ofView:self.view preferredEdge:NSRectEdgeMaxX];
}

@end
