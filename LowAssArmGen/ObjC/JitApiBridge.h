//
//  JitApiBridge.h
//  LowAssArmGen
//
//  Created by David Cairns on 5/19/25.
//

#import <pthread/pthread.h>

/// Sets the pthread jit write callback. Can only be called once per compilation unit!
void DC_set_pthread_jit_write_callback(pthread_jit_write_callback_t callback);

/// Invokes the callback that we had earlier added to the allowlist (see: ``DC_set_pthread_jit_write_callback``).
int DC_pthread_jit_write_with_callback_np(pthread_jit_write_callback_t callback, void *ctx);
