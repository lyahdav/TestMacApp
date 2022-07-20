//
//  ViewController.m
//  TestMacApp
//
//  Created by Liron Yahdav on 5/19/21.
//

#import "ViewController.h"

// *****************
// Protocol testing
// *****************
@protocol RCTBackedTextInputViewProtocol
@property (nonatomic, getter=isScrollEnabled) BOOL scrollEnabled;
@end

@interface MyViewWithMouseEvents : NSView
@property (nonatomic) NSPoint enterLocation;
@property (nonatomic, retain) NSTrackingArea *trackingArea;
@end

@interface RCTUITextView : NSTextView <RCTBackedTextInputViewProtocol>
@property (nonatomic, getter=isScrollEnabled) BOOL scrollEnabled;
@end

@implementation RCTUITextView

@end
// *****************


@implementation MyViewWithMouseEvents

- (NSView *)hitTest:(NSPoint)point {
//  RCTUITextView* tv = [RCTUITextView new];
//  tv.scrollEnabled = YES;
  return [super hitTest:point];
}

- (void)viewDidMoveToWindow {
  self.window.acceptsMouseMovedEvents = YES;
}

- (void)mouseEntered:(NSEvent *)event {
  [super mouseEntered:event];
//  NSView *view = self;
//  NSHelpManager *helpManager = [NSHelpManager sharedHelpManager];
//  [helpManager setContextHelp:[[NSAttributedString alloc] initWithString:[view toolTip]] forObject:view];
//  [helpManager showContextHelpForObject:view locationHint:NSEvent.mouseLocation];
//  [helpManager removeContextHelpForObject:view];

//  self.enterLocation = event.mouseLocation;
}

-(void)updateTrackingAreas
{
    [super updateTrackingAreas];
    if(self.trackingArea != nil) {
      [self removeTrackingArea:self.trackingArea];
      self.trackingArea = nil;
    }

    int opts = (NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways);
    self.trackingArea = [ [NSTrackingArea alloc] initWithRect:[self bounds]
                                                 options:opts
                                                   owner:self
                                                userInfo:nil];
    [self addTrackingArea:self.trackingArea];
}

//- (void)mouseMoved:(NSEvent *)event {
//  [super mouseMoved:event];
////  self.toolTip = @"";
////  self.toolTip = @"ToolTip2";
//  NSView *view = self;
//  NSHelpManager *helpManager = [NSHelpManager sharedHelpManager];
//  [helpManager setContextHelp:[[NSAttributedString alloc] initWithString:[view toolTip]] forObject:view];
//  [helpManager showContextHelpForObject:view locationHint:self.enterLocation];
//  [helpManager removeContextHelpForObject:view];
//}

@end

@interface PopUpButton : NSPopUpButton

@property (nonatomic, copy) NSArray<NSString*>* items;
@property (nonatomic, copy) NSNumber* selectedIndex;
//@property (nonatomic, copy) RCTBubblingEventBlock onChange;
@property (nonatomic, copy) NSString* placeholder;

@end

@implementation PopUpButton

- (instancetype)initWithFrame:(CGRect)frame {
  if ((self = [super initWithFrame:frame pullsDown:NO])) {
    self.action = @selector(didSelectItem:);
    self.target = self;
  }
  return self;
}

- (void)didSelectItem:(id)sender {
  NSLog(@"didSelectItem");
//  if (_onChange) {
//    _onChange(@{@"selectedIndex" : @(self.indexOfSelectedItem)});
//  }
}

- (NSNumber*)selectedIndex {
  return @(self.indexOfSelectedItem);
}

- (void)setSelectedIndex:(NSNumber*)selectedIndex {
  NSInteger indexToSelect = selectedIndex ? [selectedIndex integerValue] : -1;
  if (indexToSelect != self.indexOfSelectedItem) {
    [self selectItemAtIndex:indexToSelect];
    if (indexToSelect == -1) {
      self.placeholder = _placeholder;
    }
  }
}

- (void)setPlaceholder:(NSString*)placeholder {
  _placeholder = placeholder;
  if (placeholder) {
    // Adapted from
    // https://stackoverflow.com/questions/4184605/nspopupbutton-placeholder-value#comment88899043_4185141.
    [(NSPopUpButtonCell*)self.cell setMenuItem:[[NSMenuItem alloc] initWithTitle:placeholder
                                                                          action:nil
                                                                   keyEquivalent:@""]];
  }
}

- (NSArray<NSString*>*)items {
  return self.itemTitles;
}

- (void)setItems:(NSArray<NSString*>*)items {
  NSInteger indexOfSelectedItem = self.indexOfSelectedItem;
  [self removeAllItems];

  // Workaround NSPopupButton limitation that attempts to enforce unique titles.
  for (NSUInteger i = 0; i < items.count; i++) {
    [self addItemWithTitle:@(i).stringValue];
  }
  for (NSUInteger i = 0; i < items.count; i++) {
    self.itemArray[i].title = items[i];
  }

  // Removing all items resets the index to 0, so we have to restore it if it was something else
  if (indexOfSelectedItem != self.indexOfSelectedItem && indexOfSelectedItem < items.count) {
    [self setSelectedIndex:@(indexOfSelectedItem)];
  }

  self.placeholder = _placeholder;
}

@end

typedef void (^SimpleBlock)(void);

enum : NSUInteger
{
  UIViewAutoresizingNone                 = NSViewNotSizable,
  UIViewAutoresizingFlexibleLeftMargin   = NSViewMinXMargin,
  UIViewAutoresizingFlexibleWidth        = NSViewWidthSizable,
  UIViewAutoresizingFlexibleRightMargin  = NSViewMaxXMargin,
  UIViewAutoresizingFlexibleTopMargin    = NSViewMinYMargin,
  UIViewAutoresizingFlexibleHeight       = NSViewHeightSizable,
  UIViewAutoresizingFlexibleBottomMargin = NSViewMaxYMargin,
};

@implementation ViewController {
  NSMutableArray<SimpleBlock> *_eventQueue;
  __unsafe_unretained IBOutlet NSTextView *_textView;
  __weak IBOutlet NSTextField *_textField;
  __unsafe_unretained IBOutlet NSTextView *_textView2;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
  if (self = [super initWithCoder:coder]) {
    _eventQueue = [NSMutableArray array];
  }
  return self;
}

- (void)flushEventQueueAsync
{
  __weak typeof(self) weakSelf = self;
  dispatch_async(dispatch_get_main_queue(), ^{
    if (weakSelf) {
      __strong typeof(self) strongSelf = weakSelf;
      for (SimpleBlock eventBlock in strongSelf->_eventQueue) {
        eventBlock();
      }
      [strongSelf->_eventQueue removeAllObjects];
    }
  });
}

- (IBAction)buttonClicked:(id)sender {
  NSHashTable *h = [NSHashTable weakObjectsHashTable];
  [h addObject:nil];
}

- (void)forceCrash {
  NSString *a = @"afdsafz";
  NSString *b = [[a mutableCopy] copy];
  NSString *s = @("foo");
//  [s release];
//  CFRelease((__bridge CFStringRef)s);
//  memset((__bridge void*)s, 0, 1);
//  __unsafe_unretained NSArray *array = [[NSArray alloc] initWithObjects:@"test", nil];
  NSData *f = [s dataUsingEncoding:NSUTF8StringEncoding];
  NSLog(@"string: %lu", (unsigned long)f.length);
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.view1.wantsLayer = YES;
  self.view1.layer.backgroundColor = NSColor.redColor.CGColor;
  self.view1.toolTip = @"ToolTip";
  
//  [self forceCrash];

//  NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.apple.com"]];
//  [self.webView loadRequest:request];
  
//  __unsafe_unretained NSArray *array = [[NSArray alloc] initWithObjects:@"test", nil];
//  __unsafe_unretained NSString *s = @"foo";
//  id s = nil;
//  if (s == nil || s == (id)kCFNull) {
//    NSLog(@"nil");
//  } else if ([s isKindOfClass:[NSString class]]) {
//    NSData *f = [s dataUsingEncoding:NSUTF8StringEncoding];
//    NSLog(@"string: %lu", (unsigned long)f.length);
//  } else {
//    NSLog(@"else");
//  }
//
//  PopUpButton *p = [[PopUpButton alloc] initWithFrame:CGRectMake(0, 0, 200, 21)];
//  p.accessibilityLabel = @"accessibilityLabel";
//  p.placeholder = @"placeholder";
//  p.selectedIndex = @(-1);
//  p.items = @[@"a", @"b"];
//    [self.view addSubview:p];

  

//  NSTextField *_backedTextInputView = [[NSTextField alloc] initWithFrame:CGRectMake(0, 0, 200, 21)];
//  _backedTextInputView.cell.scrollable = YES;
//  _backedTextInputView.cell.usesSingleLineMode = YES;
//  NSDictionary *placeholderAttributes = @{
//      NSForegroundColorAttributeName: NSColor.blueColor
//
//  NSAttributedString *placeholderAttributedString = [[NSAttributedString alloc] initWithString:@"placeholder" attributes:placeholderAttributes];
//
//  _backedTextInputView.placeholderAttributedString = placeholderAttributedString;
//  _backedTextInputView.textColor = NSColor.blueColor;
//  _backedTextInputView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//  [self.view addSubview:_backedTextInputView];

//  NSTextField *_backedTextInputView2 = [[NSTextField alloc] initWithFrame:CGRectMake(0, 21, 200, 21)];
//  [self.view addSubview:_backedTextInputView2];
  
  //  tv.textContainer.maximumNumberOfLines = 1;
  //  tv.focusRingType = NSFocusRingTypeDefault;

  NSTextView *tv = [[NSTextView alloc] initWithFrame:CGRectMake(0, 0, 131, 21)];
  NSDictionary *attributes = @{NSLinkAttributeName: @"http://www.google.com"};
//  NSDictionary *attributes = @{NSLinkAttributeName: @"http://www.google.com", NSToolTipAttributeName: @""};
//  [tv.textStorage appendAttributedString:[[NSAttributedString alloc] initWithString:@"(Tooltip set to blank) http://www.google.com" attributes:attributes]];
    [tv.textStorage appendAttributedString:[[NSAttributedString alloc] initWithString:@"http://www.google.com" attributes:attributes]];
  tv.selectable = YES;
  tv.editable = NO;
  [self.view1 addSubview:tv];

//  NSTextView *tv2 = [[NSTextView alloc] initWithFrame:CGRectMake(0, 40, 200, 21)];
//  NSDictionary *attributes2 = @{NSLinkAttributeName: @"http://www.google.com"};
//  [tv2.textStorage appendAttributedString:[[NSAttributedString alloc] initWithString:@"Plain text"]];
//  [tv2.textStorage appendAttributedString:[[NSAttributedString alloc] initWithString:@"(Tooltip not specified) http://www.google.com" attributes:attributes2]];
//  tv2.selectable = YES;
//  tv2.editable = NO;
//  [self.view1 addSubview:tv2];
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (void)textDidChange:(NSNotification *)notification {
  [self->_eventQueue insertObject:^void () {
    NSLog(@"textDidChange");
  } atIndex:0];
  [self flushEventQueueAsync];
}

- (void)textViewDidChangeSelection:(NSNotification *)notification {
  [self->_eventQueue addObject:^void () {
    NSLog(@"textViewDidChangeSelection");
  }];
  [self flushEventQueueAsync];
}

- (IBAction)didPressButton:(NSButton *)sender {
  [_textView.textStorage setAttributedString:[[NSAttributedString alloc] initWithString:@"Some text @mention text text"]];
}

#pragma mark - NSTextFieldDelegate

- (void)controlTextDidChange:(NSNotification *)obj {
  NSLog(@"%@", [NSString stringWithFormat:@"controlTextDidChange: %@", _textField.attributedStringValue.string]);
}

@end
