//
//  CommandBuffer.h
//  LowAssArmGen
//
//  Created by David Cairns on 5/14/25.
//

#import <Foundation/Foundation.h>

@interface CommandBuffer : NSObject

- (int)run:(NSData *)buffer;

@end
