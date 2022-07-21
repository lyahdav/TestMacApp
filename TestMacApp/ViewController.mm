//
//  ViewController.m
//  TestMacApp
//
//  Created by Liron Yahdav on 5/19/21.
//

#import "ViewController.h"

#include <mutex>
#include <thread>

std::mutex g_mutex;

void bg_thread_execute()
{
  uint64_t tid;
  pthread_threadid_np(NULL, &tid);
  
  NSLog(@"bg_thread_execute start");
  g_mutex.lock();
  NSLog(@"bg_thread_execute end");
}

@implementation ViewController

- (IBAction)deadlockMainThreadButtonTapped:(id)sender {
  g_mutex.lock();
  std::thread t1(bg_thread_execute);
  t1.join();
}

- (IBAction)buttonTapped:(id)sender {
  std::thread t1(bg_thread_execute);
  std::thread t2(bg_thread_execute);
  t1.detach();
  t2.detach();
  NSLog(@"buttonTapped end");
}

@end
