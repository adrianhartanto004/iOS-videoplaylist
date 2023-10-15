//
//  MockApiClient.m
//  VideoPlaylistExercise
//
//  Created by Adrian Hartanto on 12/10/23.
//

#import "MockApiClient.h"

@implementation MockApiClient

- (instancetype)init {
  if (self = [super init]) {
    // Do init here
    NSLog(@"Mock api client initialized");
  }
  return self;
}

- (void) executeRequest {
  NSLog(@"The execute request has been called.");
}

- (int)getNumber {
  return 5;
}

@end
