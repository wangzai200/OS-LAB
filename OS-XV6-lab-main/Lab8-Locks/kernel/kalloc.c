// Physical memory allocator, for user processes,
// kernel stacks, page-table pages,
// and pipe buffers. Allocates whole 4096-byte pages.

#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "riscv.h"
#include "defs.h"

void freerange(void *pa_start, void *pa_end);

extern char end[]; // first address after kernel.
                   // defined by kernel.ld.

struct run {
  struct run *next;
};

struct {
    struct spinlock lock;
    struct run *freelist;
} kmem[NCPU]; // 每个CPU都有维护独有的kmem

void kinit()
{
    // 每个CPU列表初始化
    char kmem_name[32];
    for (int i = 0; i < NCPU; i++) {
        snprintf(kmem_name, 32, "kmem_%d", i);
        initlock(&kmem[i].lock, kmem_name);
    }
    freerange(end, (void *)PHYSTOP);
}
void
freerange(void *pa_start, void *pa_end)
{
  char *p;
  p = (char*)PGROUNDUP((uint64)pa_start);
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    kfree(p);
}

// Free the page of physical memory pointed at by pa,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void kfree(void *pa)
{
    struct run *r;

    // 检查给定的地址是否有效
    if (((uint64)pa % PGSIZE) != 0 || (char *)pa < end || (uint64)pa >= PHYSTOP)
        panic("kfree");

    // 用垃圾数据填充页，以捕获悬空引用
    memset(pa, 1, PGSIZE);

    r = (struct run *)pa;

    // 关闭中断，防止中断过程中修改共享数据
    push_off();

    // 获取当前CPU的ID
    int CPUID = cpuid();
    
    // 获取当前CPU的kmem锁，保护共享数据
    acquire(&kmem[CPUID].lock);
    
    // 从链表头插入空闲页
    r->next = kmem[CPUID].freelist;
    kmem[CPUID].freelist = r;
    
    // 释放当前CPU的kmem锁
    release(&kmem[CPUID].lock);

    // 恢复中断
    pop_off();
}

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *kalloc(void)
{
    struct run *r;

    // 关闭中断，防止中断过程中修改共享数据
    push_off();
    
    // 获取当前CPU的ID
    int CPUID = cpuid();
    
    // 获取当前CPU的kmem锁，保护共享数据
    acquire(&kmem[CPUID].lock);

    // 在当前CPU的自由列表中查找空闲页
    r = kmem[CPUID].freelist;
    
    // 如果在当前CPU的自由列表中找到空闲页
    if (r)
        kmem[CPUID].freelist = r->next;

    // 如果当前CPU的自由列表中没有空闲页
    if (r == 0) {
        // 在其他CPU的自由列表中查找空闲页
        for (int i = 0; i < NCPU; i++) {
            if (i == CPUID)
                continue; // 跳过当前CPU

            // 获取其他CPU的kmem锁
            acquire(&kmem[i].lock);
            
            // 在其他CPU的自由列表中查找空闲页
            r = kmem[i].freelist;
            if (r)
                kmem[i].freelist = r->next;
            
            // 释放其他CPU的kmem锁
            release(&kmem[i].lock);
            
            // 如果找到空闲页，跳出循环
            if (r)
                break;
        }
    }

    // 释放当前CPU的kmem锁
    release(&kmem[CPUID].lock);
    
    // 恢复中断
    pop_off();

    // 如果找到了空闲页，用垃圾数据填充该页
    if (r)
        memset((char *)r, 5, PGSIZE);
    
    // 返回找到的空闲页的地址
    return (void *)r;
}

