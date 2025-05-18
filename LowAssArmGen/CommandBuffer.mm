//
//  CommandBuffer.mm
//  LowAssArmGen
//
//  Created by David Cairns on 5/14/25.
//

#import "CommandBuffer.h"
#import <stdint.h>
#import <pthread/pthread.h>
#import <libkern/OSCacheControl.h>

typedef int(*fn)();
const size_t fnBlockSize = 4096;

static void *jit_region = NULL;
void allocate_jit_region() {
    jit_region = (char *)mmap(NULL,        // address
                              fnBlockSize, // size
                              PROT_READ | PROT_WRITE | PROT_EXEC,
                              MAP_PRIVATE | MAP_ANONYMOUS | MAP_JIT,
                              -1,          // fd (not used here)
                              0);          // offset (not used here)
    if (jit_region == MAP_FAILED) {
        NSLog(@"Failed to allocate memory, with errno: %d", errno);
        exit(1);
    }
}

int jit_writing_callback(void *context) {
    NSData *buffer = (__bridge NSData *)context;
    memcpy(jit_region, buffer.bytes, buffer.length);
    return 0;
}

void set_up_jit() {
    if (jit_region != NULL) { return; }

    // Allocate:
    allocate_jit_region();

    // Add our callback to the allow-list.
    PTHREAD_JIT_WRITE_ALLOW_CALLBACKS_NP(jit_writing_callback);
}

void release(fn buffer) {
    munmap((void*)buffer, fnBlockSize);
}

@interface DCFunction: NSObject
- (instancetype)initPointer:(uint8_t *)ptr;
- (int)run;
@end

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

@implementation CommandBuffer

- (DCFunction *)compile:(NSData *)buffer {
    set_up_jit();

    // Write the machine code to our executable page, via our callback:
    const int writeStatus = pthread_jit_write_with_callback_np(jit_writing_callback, (__bridge void*)buffer);
    if (writeStatus != 0) {
        NSLog(@"Failed to write JIT code to executable page!");
        exit(-1);
    }

    // Ensure our executable page is invalidated in the cache, so we're processing it fresh:
    sys_icache_invalidate(jit_region, buffer.length);

    return [[DCFunction alloc] initPointer:(uint8_t*)jit_region];
}

- (int)run:(NSData*)buffer {
    DCFunction *function = [self compile:buffer];
    const int result = [function run];

    return result;
}

@end
