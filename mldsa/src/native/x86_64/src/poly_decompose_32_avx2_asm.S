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
    !defined(MLD_CONFIG_NO_SIGN_API) &&            \
    !defined(MLD_CONFIG_MULTILEVEL_NO_SHARED) &&   \
    (defined(MLD_CONFIG_MULTILEVEL_WITH_SHARED) || \
     (MLD_CONFIG_PARAMETER_SET == 65 || MLD_CONFIG_PARAMETER_SET == 87))


/*
 * WARNING: This file is auto-derived from the mldsa-native source file
 *   dev/x86_64/src/poly_decompose_32_avx2_asm.S using scripts/simpasm. Do not modify it directly.
 */

.text
.balign 4
.global MLD_ASM_NAMESPACE(poly_decompose_32_avx2)
MLD_ASM_FN_SYMBOL(poly_decompose_32_avx2)

        .cfi_startproc
        movl $0x7be100, %eax         # imm = 0x7BE100
        vmovd %eax, %xmm4
        vpbroadcastd %xmm4, %ymm4
        movl $0x401, %eax            # imm = 0x401
        vmovd %eax, %xmm5
        vpbroadcastd %xmm5, %ymm5
        movl $0x7f, %eax
        vmovd %eax, %xmm7
        vpbroadcastd %xmm7, %ymm7
        movl $0x200, %eax            # imm = 0x200
        vmovd %eax, %xmm8
        vpbroadcastd %xmm8, %ymm8
        movl $0x20, %ecx

Lpoly_decompose_32_avx2_loop:
        vmovdqa (%rsi), %ymm0
        vpaddd %ymm7, %ymm0, %ymm1
        vpsrld $0x7, %ymm1, %ymm1
        vpmulhuw %ymm5, %ymm1, %ymm1
        vpmulhrsw %ymm8, %ymm1, %ymm1
        vpcmpgtd %ymm4, %ymm0, %ymm3
        vpslld $0xa, %ymm1, %ymm2
        vpsubd %ymm1, %ymm2, %ymm2
        vpslld $0x9, %ymm2, %ymm2
        vpsubd %ymm2, %ymm0, %ymm2
        vpandn %ymm1, %ymm3, %ymm1
        vpaddd %ymm3, %ymm2, %ymm2
        vmovdqa %ymm1, (%rdi)
        vmovdqa %ymm2, (%rsi)
        addq $0x20, %rdi
        addq $0x20, %rsi
        decl %ecx
        jne Lpoly_decompose_32_avx2_loop
        retq
        .cfi_endproc

MLD_ASM_FN_SIZE(poly_decompose_32_avx2)

#endif /* MLD_ARITH_BACKEND_X86_64_DEFAULT && !MLD_CONFIG_NO_SIGN_API && \
          !MLD_CONFIG_MULTILEVEL_NO_SHARED && \
          (MLD_CONFIG_MULTILEVEL_WITH_SHARED || MLD_CONFIG_PARAMETER_SET == 65 \
          || MLD_CONFIG_PARAMETER_SET == 87) */

#if defined(__ELF__)
.section .note.GNU-stack,"",%progbits
#endif
