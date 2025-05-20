//
//  Jit.swift
//  LowAssArmGen
//
//  Created by David Cairns on 5/19/25.
//

import Foundation
import _stdint
import pthread

private let fnBlockSize: size_t = 4096

private struct JitWritingContext {
    let buffer: Data
    var entryPoint: ptrdiff_t = 0

    init(buffer: Data) {
        self.buffer = buffer
    }
}

private var jit_region: UnsafeMutableRawPointer!

final class Jit {
    private init() {
        setup()
    }

    static let shared: Jit = Jit()

    fileprivate var nextHead: ptrdiff_t = 0


    func setup() {
        guard jit_region == nil else { return }

        // Allocate:
        allocateJitRegion()

        // Add our callback to the allow-list.
        DC_set_pthread_jit_write_callback { ctx in jitWritingCallback(ctx) }
    }

    private func allocateJitRegion() {
        jit_region = mmap(
            nil,                                   // address
            fnBlockSize,                            // size
            PROT_READ | PROT_WRITE | PROT_EXEC,
            MAP_PRIVATE | MAP_ANONYMOUS | MAP_JIT,
            -1,                                     // fd (not used here)
            0                                       // offset (not used here)
        )
        if jit_region == MAP_FAILED {
            NSLog("Failed to allocate memory, with errno: %d", errno)
            exit(1)
        }
    }

    func write(commandBuffer: Data) -> DCFunction {
        var context = JitWritingContext(buffer: commandBuffer)

        // Write the machine code to our executable page, via our callback:
        let writeStatus = DC_pthread_jit_write_with_callback_np(jitWritingCallback, &context)
        if writeStatus != 0 {
            NSLog("Failed to write JIT code to executable page!")
            exit(-1)
        }

        let codeStart = jit_region + context.entryPoint

        // Ensure our executable page is invalidated in the cache, so we're processing it fresh:
        sys_icache_invalidate(codeStart, commandBuffer.count)

        return DCFunction(pointer: codeStart)
    }
}

private func jitWritingCallback(_ ctx: UnsafeMutableRawPointer!) -> Int32 {
    let context: UnsafeMutablePointer<JitWritingContext> = ctx.bindMemory(to: JitWritingContext.self, capacity: 1)

    // Ensure we aren't writing past the end of our buffer!
    let remaining: size_t = fnBlockSize - Jit.shared.nextHead;
    if context.pointee.buffer.count >= remaining {
        return -1;
    }

    let srcPtr: UnsafeRawPointer? = context.pointee.buffer.withUnsafeBytes { $0.baseAddress }
    memcpy(
        jit_region + Jit.shared.nextHead,
        srcPtr,
        context.pointee.buffer.count
    )
    context.pointee.entryPoint = Jit.shared.nextHead
    Jit.shared.nextHead += context.pointee.buffer.count
    return 0
}
