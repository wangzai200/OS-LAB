	.text

	/*
         * save the old thread's registers,
         * restore the new thread's registers.
         */

	.globl thread_switch
thread_switch:
	/* YOUR CODE HERE */
	/* copy the content in kernel/swtch.S */
swtch:
    sd ra, 0(a0)          // 保存返回地址寄存器
    sd sp, 8(a0)          // 保存栈指针寄存器
    sd s0, 16(a0)         // 保存s0寄存器
    sd s1, 24(a0)         // 保存s1寄存器
    sd s2, 32(a0)         // 保存s2寄存器
    sd s3, 40(a0)         // 保存s3寄存器
    sd s4, 48(a0)         // 保存s4寄存器
    sd s5, 56(a0)         // 保存s5寄存器
    sd s6, 64(a0)         // 保存s6寄存器
    sd s7, 72(a0)         // 保存s7寄存器
    sd s8, 80(a0)         // 保存s8寄存器
    sd s9, 88(a0)         // 保存s9寄存器
    sd s10, 96(a0)        // 保存s10寄存器
    sd s11, 104(a0)       // 保存s11寄存器

    ld ra, 0(a1)          // 恢复返回地址寄存器
    ld sp, 8(a1)          // 恢复栈指针寄存器
    ld s0, 16(a1)         // 恢复s0寄存器
    ld s1, 24(a1)         // 恢复s1寄存器
    ld s2, 32(a1)         // 恢复s2寄存器
    ld s3, 40(a1)         // 恢复s3寄存器
    ld s4, 48(a1)         // 恢复s4寄存器
    ld s5, 56(a1)         // 恢复s5寄存器
    ld s6, 64(a1)         // 恢复s6寄存器
    ld s7, 72(a1)         // 恢复s7寄存器
    ld s8, 80(a1)         // 恢复s8寄存器
    ld s9, 88(a1)         // 恢复s9寄存器
    ld s10, 96(a1)        // 恢复s10寄存器
    ld s11, 104(a1)       // 恢复s11寄存器
    
    ret                   // 返回到ra指示的地址
