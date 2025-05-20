//
//  ArmInstruction.swift
//  LowAssArmGen
//
//  Created by David Cairns on 5/19/25.
//

enum ArmInstruction {
    // Integer ops:
    case add(dest: ArmRegister, op1: ArmRegister, op2: ArmRegister)
    case sub(dest: ArmRegister, op1: ArmRegister, op2: ArmRegister)
    case mul(dest: ArmRegister, op1: ArmRegister, op2: ArmRegister)
    case div(dest: ArmRegister, op1: ArmRegister, op2: ArmRegister)
    case mov(dest: ArmRegister, imm: UInt16)

//    // Float ops:
//    case fadd(dest: ArmRegister, op1: ArmRegister, op2: ArmRegister)

    // Control flow:
    case ret
}

extension ArmInstruction {
    var rawValue: UInt32 {
        switch self {

        // MARK: Integer ops:
        case let .add(dest: dest, op1: op1, op2: op2):
            // 0x0b090100 => add w0, w8, w9
            // 0=32-bit op
            //  0=op
            //   0=S
            //    0 1011
            //           00
            //             1
            //              x xxxx=Rm
            //                     xxx=option
            //                        x xx=imm3
            //                            xx xxx=Rn
            //                                  x xxxx=Rd
            var result: UInt32 = 0
            let bitSizeOp: UInt8 = 0 // 0=>32bit, 1=>64bit
            result = result | UInt32(bitSizeOp) << 31
            let op: UInt8 = 0x0
            result = result | UInt32(op) << 30
            let s: UInt8 = 0x0
            result = result | UInt32(s) << 29

            let dunno1: UInt8 = 0xb
            result = result | UInt32(dunno1) << 24
            let dunno2: UInt32 = 0x0
            result = result | UInt32(dunno2) << 22
            let dunno3: UInt32 = 0x0
            result = result | UInt32(dunno3) << 21

            let rm: UInt32 = UInt32(op2)
            result = result | rm << 16

            let option: UInt8 = 0x0
            result = result | UInt32(option) << 13

            let imm3: UInt8 = 0x0
            result = result | UInt32(imm3) << 10

            let rn: UInt32 = UInt32(op1)
            result = result | rn << 5

            let rd: UInt32 = UInt32(dest)
            result = result | rd << 0

            return result

        case let .sub(dest: dest, op1: op1, op2: op2):
            // 0x6b090100 => sub w0, w8, w9
            // 0110 1011 0000 1001 0000 0001 0000 0000
            // 0=32-bit op
            //  1=op
            //   1=S
            //    0 1011
            //           00
            //             1
            //              x xxxx=Rm
            //                     xxx=option
            //                        x xx=imm3
            //                            xx xxx=Rn
            //                                  x xxxx=Rd
            var result: UInt32 = 0
            let bitSizeOp: UInt8 = 0 // 0=>32bit, 1=>64bit
            result = result | UInt32(bitSizeOp) << 31
            let op: UInt8 = 0x1
            result = result | UInt32(op) << 30
            let s: UInt8 = 0x1
            result = result | UInt32(s) << 29

            let dunno1: UInt8 = 0xb
            result = result | UInt32(dunno1) << 24
            let dunno2: UInt32 = 0x0
            result = result | UInt32(dunno2) << 22
            let dunno3: UInt32 = 0x1
            result = result | UInt32(dunno3) << 21

            let rm: UInt32 = UInt32(op2)
            result = result | rm << 16

            let option: UInt8 = 0x0
            result = result | UInt32(option) << 13

            let imm3: UInt8 = 0x0
            result = result | UInt32(imm3) << 10

            let rn: UInt32 = UInt32(op1)
            result = result | rn << 5

            let rd: UInt32 = UInt32(dest)
            result = result | rd << 0

            return result

        case let .mul(dest: dest, op1: op1, op2: op2):
            // 0x1b097d00 => mul w0, w8, w9
            // 0001 1011 0000 1001 0110 1101 0000 0000
            // 0=32-bit op
            //  00=???
            //    1 1011
            //           000=???
            //              x xxxx=Rm
            //                     0=o0 (?)
            //                      111 11=Ra(addend, if `11111`, then = 0)
            //                            xx xxx=Rn
            //                                  x xxxx=Rd
            var result: UInt32 = 0
            let bitSizeOp: UInt8 = 0 // 0=>32bit, 1=>64bit
            result = result | UInt32(bitSizeOp) << 31
            let _0: UInt8 = 0x0
            result = result | UInt32(_0) << 29
            let _1: UInt8 = 0x1b
            result = result | UInt32(_1) << 24

            let _2: UInt8 = 0x0
            result = result | UInt32(_2) << 21

            let rm: UInt32 = UInt32(op2)
            result = result | rm << 16

            let o0: UInt8 = 0x0
            result = result | UInt32(o0) << 15

            let ra: UInt8 = 0x1f
            result = result | UInt32(ra) << 10

            let rn: UInt32 = UInt32(op1)
            result = result | rn << 5

            let rd: UInt32 = UInt32(dest)
            result = result | rd << 0

            return result

        case let .div(dest: dest, op1: op1, op2: op2):
            // 0x1ac90d00 => div w0, w8, w9 (sdiv — signed integer division)
            // 0001 1010 1100 1001 0000 1101 0000 0000
            // 0=32-bit op
            //  0=???
            //   0=???
            //    1 10101 10
            //              x xxxx=Rm
            //                     0000 1=???
            //                           1=o1
            //                            xx xxx=Rn
            //                                  x xxxx=Rd
            var result: UInt32 = 0
            let bitSizeOp: UInt8 = 0 // 0=>32bit, 1=>64bit
            result = result | UInt32(bitSizeOp) << 31
            let _0: UInt8 = 0x0
            result = result | UInt32(_0) << 30
            let _1: UInt8 = 0x0
            result = result | UInt32(_1) << 29
            let _2: UInt8 = 0xd6
            result = result | UInt32(_2) << 21

            let rm: UInt32 = UInt32(op2)
            result = result | rm << 16

            let _3: UInt8 = 0x1
            result = result | UInt32(_3) << 11
            let o1: UInt8 = 0x0
            result = result | UInt32(o1) << 10

            let rn: UInt32 = UInt32(op1)
            result = result | rn << 5

            let rd: UInt32 = UInt32(dest)
            result = result | rd << 0

            return result

        case let .mov(dest: destReg, imm: srcImm):
            // 0=32-bit op
            //  10=opc
            //    1 0010 1=op code
            //            00=hw
            //              0 0000 0000 0101 010=imm16
            //                                  0 0000=Rd
            var result: UInt32 = 0
            let bitSizeOp: UInt8 = 0 // 0=>32bit, 1=>64bit
            result = result | UInt32(bitSizeOp) << 31
            let opc: UInt8 = 0x2
            result = result | UInt32(opc) << 29
            let opCode: UInt16 = 0x25 // 100101
            result = result | UInt32(opCode) << (2 + 16 + 5)
            let hw: UInt16 = 00
            result = result | UInt32(hw) << (16 + 5)
            let imm16Part: UInt32 = UInt32(srcImm) << 5
            result = result | imm16Part
            let rdPart: UInt32 = UInt32(destReg)
            result = result | rdPart
            return result

            // MARK: Float ops:

//        case let .fadd(dest: dest, op1: op1, op2: op2):
//            // 0x1e212800 => fadd s0, s0, s1
//            // 0001 1110 0010 0001 0010 1000 000 0000
//            // 0
//            //  0
//            //   0
//            //    1 1110
//            //           00=ftype (single-precision)
//            //             1
//            //              x xxxx=Rm
//            //                     001=???
//            //                        0=op
//            //                          10=?
//            //                            xx xxx=Rn
//            //                                  x xxxx=Rd
//            var result: UInt32 = 0
//
//            let _0: UInt8 = 0x0
//            result = result | UInt32(_0) << 31
//            let _1: UInt8 = 0x0
//            result = result | UInt32(_1) << 30
//            let _2: UInt8 = 0x0
//            result = result | UInt32(_2) << 29
//            let _3: UInt8 = 0x1e
//            result = result | UInt32(_3) << 24
//            let ftype: UInt8 = 0x0
//            result = result | UInt32(ftype) << 22
//            let _4: UInt8 = 0x1
//            result = result | UInt32(_4) << 21
//            let rm: UInt8 = op1
//            result = result | UInt32(rm) << 16
//            let _5: UInt8 = 0x1
//            result = result | UInt32(_5) << 13
//            let op: UInt8 = 0x0
//            result = result | UInt32(op) << 12
//            let _6: UInt8 = 0x2
//            result = result | UInt32(_6) << 10
//            let rn: UInt8 = op2
//            result = result | UInt32(rn) << 5
//            let rd: UInt8 = dest
//            result = result | UInt32(rd) << 0
//
//            return result

        // MARK: Control Flow:
        case .ret:
            // 0xd65f03c0
            // 1101 0110 0101 1111 0000 0011 1100 0000
            // TODO: Actually pack this thing??
            return 0xd65f03c0
        }
    }
}

