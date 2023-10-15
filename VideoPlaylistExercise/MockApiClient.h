//
//  MockApiClient.h
//  VideoPlaylistExercise
//
//  Created by Adrian Hartanto on 12/10/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MockApiClient : NSObject

- (void) executeRequest;
- (int) getNumber;

@end

NS_ASSUME_NONNULL_END
