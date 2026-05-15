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
/* simpasm: header-end */

.intel_syntax noprefix
.text
.balign 4
.global MLD_ASM_NAMESPACE(poly_decompose_88_avx2)
MLD_ASM_FN_SYMBOL(poly_decompose_88_avx2)

        mov eax, 8285184
        vmovd xmm4, eax
        vpbroadcastd ymm4, xmm4

        mov eax, 11275
        vmovd xmm5, eax
        vpbroadcastd ymm5, xmm5

        mov eax, 190464
        vmovd xmm6, eax
        vpbroadcastd ymm6, xmm6

        mov eax, 127
        vmovd xmm7, eax
        vpbroadcastd ymm7, xmm7

        mov eax, 128
        vmovd xmm8, eax
        vpbroadcastd ymm8, xmm8

        mov ecx, (256/8)
poly_decompose_88_avx2_loop:
        vmovdqa ymm0, [rsi]
        vpaddd ymm1, ymm0, ymm7
        vpsrld ymm1, ymm1, 7
        vpmulhuw ymm1, ymm1, ymm5
        vpmulhrsw ymm1, ymm1, ymm8
        vpcmpgtd ymm2, ymm0, ymm4
        vpmulld ymm3, ymm1, ymm6
        vpsubd ymm0, ymm0, ymm3
        vpandn ymm1, ymm2, ymm1
        vpaddd ymm0, ymm0, ymm2
        vmovdqa [rdi], ymm1
        vmovdqa [rsi], ymm0
        add rdi, 32
        add rsi, 32
        dec ecx
        jnz poly_decompose_88_avx2_loop
        ret

/* simpasm: footer-start */
#endif /* MLD_ARITH_BACKEND_X86_64_DEFAULT && !MLD_CONFIG_MULTILEVEL_NO_SHARED \
          && (MLD_CONFIG_MULTILEVEL_WITH_SHARED || MLD_CONFIG_PARAMETER_SET == \
          44) */
