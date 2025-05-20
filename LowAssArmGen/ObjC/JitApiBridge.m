//
//  JitApiBridge.m
//  LowAssArmGen
//
//  Created by David Cairns on 5/19/25.
//

#import <pthread/pthread.h>

static pthread_jit_write_callback_t __callback;

static int DC_jit_writing_callback_springboard(void *ctx) {
    return __callback(ctx);
}

void DC_set_pthread_jit_write_callback(pthread_jit_write_callback_t callback) {
    __callback = callback;
    PTHREAD_JIT_WRITE_ALLOW_CALLBACKS_NP(DC_jit_writing_callback_springboard);
}

int DC_pthread_jit_write_with_callback_np(pthread_jit_write_callback_t callback, void *ctx) {
    return pthread_jit_write_with_callback_np(callback, ctx);
}
