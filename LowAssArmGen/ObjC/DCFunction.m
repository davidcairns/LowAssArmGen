//
//  DCFunction.m
//  LowAssArmGen
//
//  Created by David Cairns on 5/19/25.
//

#import "DCFunction.h"

typedef int(*fn)(void);

@interface DCFunction () {
    fn _code;
}
@end

@implementation DCFunction
- (instancetype)initPointer:(uint8_t *)ptr {
    if (self = [super init]) {
        _code = (fn)ptr;
    }
    return self;
}

- (int)run {
    return _code();
}
@end
