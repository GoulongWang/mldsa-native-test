/*
 * Copyright (c) The mldsa-native project authors
 * SPDX-License-Identifier: Apache-2.0 OR ISC OR MIT
 */

/* References
 * ==========
 *
 * - [REF_AVX2]
 *   CRYSTALS-Dilithium optimized AVX2 implementation
 *   Bai, Ducas, Kiltz, Lepoint, Lyubashevsky, Schwabe, Seiler, Stehlé
 *   https://github.com/pq-crystals/dilithium/tree/master/avx2
 */

/*
 * This file is derived from the public domain
 * AVX2 Dilithium implementation @[REF_AVX2].
 *
 * The algorithm for Decompose(r) (more specifically the handling for the
 * wrap-around cases) are modified. See the "Reference" section in the comments
 * below for a more detailed comparison.
 */

#include "../../../common.h"

#if defined(MLD_ARITH_BACKEND_X86_64_DEFAULT) &&   \
    !defined(MLD_CONFIG_MULTILEVEL_NO_SHARED) &&   \
    (defined(MLD_CONFIG_MULTILEVEL_WITH_SHARED) || \
     MLD_CONFIG_PARAMETER_SET == 44)

/*
 * WARNING: This file is auto-derived from the mldsa-native source file
 *   dev/x86_64/src/poly_decompose_88_avx2_asm.S using scripts/simpasm. Do not modify it directly.
 */

.text
.balign 4
.global MLD_ASM_NAMESPACE(poly_decompose_88_avx2)
MLD_ASM_FN_SYMBOL(poly_decompose_88_avx2)

        .cfi_startproc
        movl $0x7e6c00, %eax         # imm = 0x7E6C00
        vmovd %eax, %xmm4
        vpbroadcastd %xmm4, %ymm4
        movl $0x2c0b, %eax           # imm = 0x2C0B
        vmovd %eax, %xmm5
        vpbroadcastd %xmm5, %ymm5
        movl $0x2e800, %eax          # imm = 0x2E800
        vmovd %eax, %xmm6
        vpbroadcastd %xmm6, %ymm6
        movl $0x7f, %eax
        vmovd %eax, %xmm7
        vpbroadcastd %xmm7, %ymm7
        movl $0x80, %eax
        vmovd %eax, %xmm8
        vpbroadcastd %xmm8, %ymm8
        movl $0x20, %ecx

Lpoly_decompose_88_avx2_loop:
        vmovdqa (%rsi), %ymm0
        vpaddd %ymm7, %ymm0, %ymm1
        vpsrld $0x7, %ymm1, %ymm1
        vpmulhuw %ymm5, %ymm1, %ymm1
        vpmulhrsw %ymm8, %ymm1, %ymm1
        vpcmpgtd %ymm4, %ymm0, %ymm2
        vpmulld %ymm6, %ymm1, %ymm3
        vpsubd %ymm3, %ymm0, %ymm0
        vpandn %ymm1, %ymm2, %ymm1
        vpaddd %ymm2, %ymm0, %ymm0
        vmovdqa %ymm1, (%rdi)
        vmovdqa %ymm0, (%rsi)
        addq $0x20, %rdi
        addq $0x20, %rsi
        decl %ecx
        jne Lpoly_decompose_88_avx2_loop
        retq
        .cfi_endproc

MLD_ASM_FN_SIZE(poly_decompose_88_avx2)

#endif /* MLD_ARITH_BACKEND_X86_64_DEFAULT && !MLD_CONFIG_MULTILEVEL_NO_SHARED \
          && (MLD_CONFIG_MULTILEVEL_WITH_SHARED || MLD_CONFIG_PARAMETER_SET == \
          44) */

#if defined(__ELF__)
.section .note.GNU-stack,"",%progbits
#endif
