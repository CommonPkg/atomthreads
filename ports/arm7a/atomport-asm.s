/*
 * Copyright (c) 2010, Atomthreads Project. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. No personal names or organizations' names associated with the
 *    Atomthreads project may be used to endorse or promote products
 *    derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE ATOMTHREADS PROJECT AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
 * TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE PROJECT OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

#include <arm_asm_macro.h>

	.section .text

/**
 * uint32_t archGetCPSR(void)
 */
	.globl archGetCPSR
archGetCPSR:
	mrs	r0, cpsr_all
	bx	lr

/**
 * int archSetJumpLowLevel(pt_regs_t *regs)
 */
	.globl archSetJumpLowLevel
archSetJumpLowLevel:
	add	r0, r0, #(4 * 16)
	str	lr, [r0]
	sub	r0, r0, #(4 * 14)
	stm	r0, {r1-r14}
	mov	r0, r0 /* NOP */
	sub	sp, sp, #4
	str	r1, [sp]
	mov	r1, #0
	sub	r0, r0, #4
	str	r1, [r0]
	mrs	r1, cpsr_all
	add	r0, r0, #4
	str	r1, [r0]
	ldr	r1, [sp]
	sub	sp, sp, #4
	mov	r0, #1
	bx	lr

/**
 * void archLongJumpLowLevel(pt_regs_t *regs)
 */
	.globl archLongJumpLowLevel
archLongJumpLowLevel:
	add	r0, r0, #(4 * 17)
	mrs	r1, cpsr_all
	SET_CURRENT_MODE CPSR_MODE_UNDEFINED
	mov	sp, r0
	SET_CURRENT_MODE CPSR_MODE_ABORT
	mov	sp, r0
	SET_CURRENT_MODE CPSR_MODE_IRQ
	mov	sp, r0
	SET_CURRENT_MODE CPSR_MODE_FIQ
	mov	sp, r0
	msr	cpsr_all, r1
	sub	r0, r0, #(4 * 17)
	ldr     r1, [r0], #4 /* Get CPSR from stack */
	msr	cpsr_all, r1
	ldm	r0, {r0-r15}
	mov	r0, r0 /* NOP */
