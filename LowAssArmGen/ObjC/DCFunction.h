//
//  DCFunction.h
//  LowAssArmGen
//
//  Created by David Cairns on 5/19/25.
//

#import <Foundation/Foundation.h>

@interface DCFunction: NSObject
- (instancetype)initPointer:(uint8_t *)ptr;
- (int)run;
@end
