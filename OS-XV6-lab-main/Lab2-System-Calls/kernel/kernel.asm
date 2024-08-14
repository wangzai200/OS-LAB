
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	a5013103          	ld	sp,-1456(sp) # 80008a50 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	027050ef          	jal	ra,8000583c <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	ebb9                	bnez	a5,80000082 <kfree+0x66>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00022797          	auipc	a5,0x22
    80000034:	ee078793          	addi	a5,a5,-288 # 80021f10 <end>
    80000038:	04f56563          	bltu	a0,a5,80000082 <kfree+0x66>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	04f57163          	bgeu	a0,a5,80000082 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	00000097          	auipc	ra,0x0
    8000004c:	154080e7          	jalr	340(ra) # 8000019c <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	a5090913          	addi	s2,s2,-1456 # 80008aa0 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	1e2080e7          	jalr	482(ra) # 8000623c <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	282080e7          	jalr	642(ra) # 800062f0 <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	addi	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00008517          	auipc	a0,0x8
    80000086:	f8e50513          	addi	a0,a0,-114 # 80008010 <etext+0x10>
    8000008a:	00006097          	auipc	ra,0x6
    8000008e:	c68080e7          	jalr	-920(ra) # 80005cf2 <panic>

0000000080000092 <freerange>:
{
    80000092:	7179                	addi	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	e84a                	sd	s2,16(sp)
    8000009c:	e44e                	sd	s3,8(sp)
    8000009e:	e052                	sd	s4,0(sp)
    800000a0:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000a2:	6785                	lui	a5,0x1
    800000a4:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    800000a8:	94aa                	add	s1,s1,a0
    800000aa:	757d                	lui	a0,0xfffff
    800000ac:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ae:	94be                	add	s1,s1,a5
    800000b0:	0095ee63          	bltu	a1,s1,800000cc <freerange+0x3a>
    800000b4:	892e                	mv	s2,a1
    kfree(p);
    800000b6:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b8:	6985                	lui	s3,0x1
    kfree(p);
    800000ba:	01448533          	add	a0,s1,s4
    800000be:	00000097          	auipc	ra,0x0
    800000c2:	f5e080e7          	jalr	-162(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000c6:	94ce                	add	s1,s1,s3
    800000c8:	fe9979e3          	bgeu	s2,s1,800000ba <freerange+0x28>
}
    800000cc:	70a2                	ld	ra,40(sp)
    800000ce:	7402                	ld	s0,32(sp)
    800000d0:	64e2                	ld	s1,24(sp)
    800000d2:	6942                	ld	s2,16(sp)
    800000d4:	69a2                	ld	s3,8(sp)
    800000d6:	6a02                	ld	s4,0(sp)
    800000d8:	6145                	addi	sp,sp,48
    800000da:	8082                	ret

00000000800000dc <kinit>:
{
    800000dc:	1141                	addi	sp,sp,-16
    800000de:	e406                	sd	ra,8(sp)
    800000e0:	e022                	sd	s0,0(sp)
    800000e2:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e4:	00008597          	auipc	a1,0x8
    800000e8:	f3458593          	addi	a1,a1,-204 # 80008018 <etext+0x18>
    800000ec:	00009517          	auipc	a0,0x9
    800000f0:	9b450513          	addi	a0,a0,-1612 # 80008aa0 <kmem>
    800000f4:	00006097          	auipc	ra,0x6
    800000f8:	0b8080e7          	jalr	184(ra) # 800061ac <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fc:	45c5                	li	a1,17
    800000fe:	05ee                	slli	a1,a1,0x1b
    80000100:	00022517          	auipc	a0,0x22
    80000104:	e1050513          	addi	a0,a0,-496 # 80021f10 <end>
    80000108:	00000097          	auipc	ra,0x0
    8000010c:	f8a080e7          	jalr	-118(ra) # 80000092 <freerange>
}
    80000110:	60a2                	ld	ra,8(sp)
    80000112:	6402                	ld	s0,0(sp)
    80000114:	0141                	addi	sp,sp,16
    80000116:	8082                	ret

0000000080000118 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000118:	1101                	addi	sp,sp,-32
    8000011a:	ec06                	sd	ra,24(sp)
    8000011c:	e822                	sd	s0,16(sp)
    8000011e:	e426                	sd	s1,8(sp)
    80000120:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000122:	00009497          	auipc	s1,0x9
    80000126:	97e48493          	addi	s1,s1,-1666 # 80008aa0 <kmem>
    8000012a:	8526                	mv	a0,s1
    8000012c:	00006097          	auipc	ra,0x6
    80000130:	110080e7          	jalr	272(ra) # 8000623c <acquire>
  r = kmem.freelist;
    80000134:	6c84                	ld	s1,24(s1)
  if(r)
    80000136:	c885                	beqz	s1,80000166 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000138:	609c                	ld	a5,0(s1)
    8000013a:	00009517          	auipc	a0,0x9
    8000013e:	96650513          	addi	a0,a0,-1690 # 80008aa0 <kmem>
    80000142:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000144:	00006097          	auipc	ra,0x6
    80000148:	1ac080e7          	jalr	428(ra) # 800062f0 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014c:	6605                	lui	a2,0x1
    8000014e:	4595                	li	a1,5
    80000150:	8526                	mv	a0,s1
    80000152:	00000097          	auipc	ra,0x0
    80000156:	04a080e7          	jalr	74(ra) # 8000019c <memset>
  return (void*)r;
}
    8000015a:	8526                	mv	a0,s1
    8000015c:	60e2                	ld	ra,24(sp)
    8000015e:	6442                	ld	s0,16(sp)
    80000160:	64a2                	ld	s1,8(sp)
    80000162:	6105                	addi	sp,sp,32
    80000164:	8082                	ret
  release(&kmem.lock);
    80000166:	00009517          	auipc	a0,0x9
    8000016a:	93a50513          	addi	a0,a0,-1734 # 80008aa0 <kmem>
    8000016e:	00006097          	auipc	ra,0x6
    80000172:	182080e7          	jalr	386(ra) # 800062f0 <release>
  if(r)
    80000176:	b7d5                	j	8000015a <kalloc+0x42>

0000000080000178 <get_freemem>:

uint64
get_freemem(void)
{
    80000178:	1141                	addi	sp,sp,-16
    8000017a:	e422                	sd	s0,8(sp)
    8000017c:	0800                	addi	s0,sp,16
    struct run *p = kmem.freelist;
    8000017e:	00009797          	auipc	a5,0x9
    80000182:	93a7b783          	ld	a5,-1734(a5) # 80008ab8 <kmem+0x18>
    uint64 count = 0;
    while (p) {
    80000186:	cb89                	beqz	a5,80000198 <get_freemem+0x20>
    uint64 count = 0;
    80000188:	4501                	li	a0,0
        count++;
    8000018a:	0505                	addi	a0,a0,1
        p = p->next;
    8000018c:	639c                	ld	a5,0(a5)
    while (p) {
    8000018e:	fff5                	bnez	a5,8000018a <get_freemem+0x12>
    }
    return count * PGSIZE;
}
    80000190:	0532                	slli	a0,a0,0xc
    80000192:	6422                	ld	s0,8(sp)
    80000194:	0141                	addi	sp,sp,16
    80000196:	8082                	ret
    uint64 count = 0;
    80000198:	4501                	li	a0,0
    8000019a:	bfdd                	j	80000190 <get_freemem+0x18>

000000008000019c <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    8000019c:	1141                	addi	sp,sp,-16
    8000019e:	e422                	sd	s0,8(sp)
    800001a0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    800001a2:	ce09                	beqz	a2,800001bc <memset+0x20>
    800001a4:	87aa                	mv	a5,a0
    800001a6:	fff6071b          	addiw	a4,a2,-1
    800001aa:	1702                	slli	a4,a4,0x20
    800001ac:	9301                	srli	a4,a4,0x20
    800001ae:	0705                	addi	a4,a4,1
    800001b0:	972a                	add	a4,a4,a0
    cdst[i] = c;
    800001b2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    800001b6:	0785                	addi	a5,a5,1
    800001b8:	fee79de3          	bne	a5,a4,800001b2 <memset+0x16>
  }
  return dst;
}
    800001bc:	6422                	ld	s0,8(sp)
    800001be:	0141                	addi	sp,sp,16
    800001c0:	8082                	ret

00000000800001c2 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    800001c2:	1141                	addi	sp,sp,-16
    800001c4:	e422                	sd	s0,8(sp)
    800001c6:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001c8:	ca05                	beqz	a2,800001f8 <memcmp+0x36>
    800001ca:	fff6069b          	addiw	a3,a2,-1
    800001ce:	1682                	slli	a3,a3,0x20
    800001d0:	9281                	srli	a3,a3,0x20
    800001d2:	0685                	addi	a3,a3,1
    800001d4:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001d6:	00054783          	lbu	a5,0(a0)
    800001da:	0005c703          	lbu	a4,0(a1)
    800001de:	00e79863          	bne	a5,a4,800001ee <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001e2:	0505                	addi	a0,a0,1
    800001e4:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001e6:	fed518e3          	bne	a0,a3,800001d6 <memcmp+0x14>
  }

  return 0;
    800001ea:	4501                	li	a0,0
    800001ec:	a019                	j	800001f2 <memcmp+0x30>
      return *s1 - *s2;
    800001ee:	40e7853b          	subw	a0,a5,a4
}
    800001f2:	6422                	ld	s0,8(sp)
    800001f4:	0141                	addi	sp,sp,16
    800001f6:	8082                	ret
  return 0;
    800001f8:	4501                	li	a0,0
    800001fa:	bfe5                	j	800001f2 <memcmp+0x30>

00000000800001fc <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001fc:	1141                	addi	sp,sp,-16
    800001fe:	e422                	sd	s0,8(sp)
    80000200:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000202:	ca0d                	beqz	a2,80000234 <memmove+0x38>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000204:	00a5f963          	bgeu	a1,a0,80000216 <memmove+0x1a>
    80000208:	02061693          	slli	a3,a2,0x20
    8000020c:	9281                	srli	a3,a3,0x20
    8000020e:	00d58733          	add	a4,a1,a3
    80000212:	02e56463          	bltu	a0,a4,8000023a <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000216:	fff6079b          	addiw	a5,a2,-1
    8000021a:	1782                	slli	a5,a5,0x20
    8000021c:	9381                	srli	a5,a5,0x20
    8000021e:	0785                	addi	a5,a5,1
    80000220:	97ae                	add	a5,a5,a1
    80000222:	872a                	mv	a4,a0
      *d++ = *s++;
    80000224:	0585                	addi	a1,a1,1
    80000226:	0705                	addi	a4,a4,1
    80000228:	fff5c683          	lbu	a3,-1(a1)
    8000022c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000230:	fef59ae3          	bne	a1,a5,80000224 <memmove+0x28>

  return dst;
}
    80000234:	6422                	ld	s0,8(sp)
    80000236:	0141                	addi	sp,sp,16
    80000238:	8082                	ret
    d += n;
    8000023a:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    8000023c:	fff6079b          	addiw	a5,a2,-1
    80000240:	1782                	slli	a5,a5,0x20
    80000242:	9381                	srli	a5,a5,0x20
    80000244:	fff7c793          	not	a5,a5
    80000248:	97ba                	add	a5,a5,a4
      *--d = *--s;
    8000024a:	177d                	addi	a4,a4,-1
    8000024c:	16fd                	addi	a3,a3,-1
    8000024e:	00074603          	lbu	a2,0(a4)
    80000252:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000256:	fef71ae3          	bne	a4,a5,8000024a <memmove+0x4e>
    8000025a:	bfe9                	j	80000234 <memmove+0x38>

000000008000025c <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    8000025c:	1141                	addi	sp,sp,-16
    8000025e:	e406                	sd	ra,8(sp)
    80000260:	e022                	sd	s0,0(sp)
    80000262:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000264:	00000097          	auipc	ra,0x0
    80000268:	f98080e7          	jalr	-104(ra) # 800001fc <memmove>
}
    8000026c:	60a2                	ld	ra,8(sp)
    8000026e:	6402                	ld	s0,0(sp)
    80000270:	0141                	addi	sp,sp,16
    80000272:	8082                	ret

0000000080000274 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000274:	1141                	addi	sp,sp,-16
    80000276:	e422                	sd	s0,8(sp)
    80000278:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    8000027a:	ce11                	beqz	a2,80000296 <strncmp+0x22>
    8000027c:	00054783          	lbu	a5,0(a0)
    80000280:	cf89                	beqz	a5,8000029a <strncmp+0x26>
    80000282:	0005c703          	lbu	a4,0(a1)
    80000286:	00f71a63          	bne	a4,a5,8000029a <strncmp+0x26>
    n--, p++, q++;
    8000028a:	367d                	addiw	a2,a2,-1
    8000028c:	0505                	addi	a0,a0,1
    8000028e:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000290:	f675                	bnez	a2,8000027c <strncmp+0x8>
  if(n == 0)
    return 0;
    80000292:	4501                	li	a0,0
    80000294:	a809                	j	800002a6 <strncmp+0x32>
    80000296:	4501                	li	a0,0
    80000298:	a039                	j	800002a6 <strncmp+0x32>
  if(n == 0)
    8000029a:	ca09                	beqz	a2,800002ac <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    8000029c:	00054503          	lbu	a0,0(a0)
    800002a0:	0005c783          	lbu	a5,0(a1)
    800002a4:	9d1d                	subw	a0,a0,a5
}
    800002a6:	6422                	ld	s0,8(sp)
    800002a8:	0141                	addi	sp,sp,16
    800002aa:	8082                	ret
    return 0;
    800002ac:	4501                	li	a0,0
    800002ae:	bfe5                	j	800002a6 <strncmp+0x32>

00000000800002b0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    800002b0:	1141                	addi	sp,sp,-16
    800002b2:	e422                	sd	s0,8(sp)
    800002b4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    800002b6:	872a                	mv	a4,a0
    800002b8:	8832                	mv	a6,a2
    800002ba:	367d                	addiw	a2,a2,-1
    800002bc:	01005963          	blez	a6,800002ce <strncpy+0x1e>
    800002c0:	0705                	addi	a4,a4,1
    800002c2:	0005c783          	lbu	a5,0(a1)
    800002c6:	fef70fa3          	sb	a5,-1(a4)
    800002ca:	0585                	addi	a1,a1,1
    800002cc:	f7f5                	bnez	a5,800002b8 <strncpy+0x8>
    ;
  while(n-- > 0)
    800002ce:	00c05d63          	blez	a2,800002e8 <strncpy+0x38>
    800002d2:	86ba                	mv	a3,a4
    *s++ = 0;
    800002d4:	0685                	addi	a3,a3,1
    800002d6:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800002da:	fff6c793          	not	a5,a3
    800002de:	9fb9                	addw	a5,a5,a4
    800002e0:	010787bb          	addw	a5,a5,a6
    800002e4:	fef048e3          	bgtz	a5,800002d4 <strncpy+0x24>
  return os;
}
    800002e8:	6422                	ld	s0,8(sp)
    800002ea:	0141                	addi	sp,sp,16
    800002ec:	8082                	ret

00000000800002ee <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002ee:	1141                	addi	sp,sp,-16
    800002f0:	e422                	sd	s0,8(sp)
    800002f2:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002f4:	02c05363          	blez	a2,8000031a <safestrcpy+0x2c>
    800002f8:	fff6069b          	addiw	a3,a2,-1
    800002fc:	1682                	slli	a3,a3,0x20
    800002fe:	9281                	srli	a3,a3,0x20
    80000300:	96ae                	add	a3,a3,a1
    80000302:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000304:	00d58963          	beq	a1,a3,80000316 <safestrcpy+0x28>
    80000308:	0585                	addi	a1,a1,1
    8000030a:	0785                	addi	a5,a5,1
    8000030c:	fff5c703          	lbu	a4,-1(a1)
    80000310:	fee78fa3          	sb	a4,-1(a5)
    80000314:	fb65                	bnez	a4,80000304 <safestrcpy+0x16>
    ;
  *s = 0;
    80000316:	00078023          	sb	zero,0(a5)
  return os;
}
    8000031a:	6422                	ld	s0,8(sp)
    8000031c:	0141                	addi	sp,sp,16
    8000031e:	8082                	ret

0000000080000320 <strlen>:

int
strlen(const char *s)
{
    80000320:	1141                	addi	sp,sp,-16
    80000322:	e422                	sd	s0,8(sp)
    80000324:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000326:	00054783          	lbu	a5,0(a0)
    8000032a:	cf91                	beqz	a5,80000346 <strlen+0x26>
    8000032c:	0505                	addi	a0,a0,1
    8000032e:	87aa                	mv	a5,a0
    80000330:	4685                	li	a3,1
    80000332:	9e89                	subw	a3,a3,a0
    80000334:	00f6853b          	addw	a0,a3,a5
    80000338:	0785                	addi	a5,a5,1
    8000033a:	fff7c703          	lbu	a4,-1(a5)
    8000033e:	fb7d                	bnez	a4,80000334 <strlen+0x14>
    ;
  return n;
}
    80000340:	6422                	ld	s0,8(sp)
    80000342:	0141                	addi	sp,sp,16
    80000344:	8082                	ret
  for(n = 0; s[n]; n++)
    80000346:	4501                	li	a0,0
    80000348:	bfe5                	j	80000340 <strlen+0x20>

000000008000034a <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    8000034a:	1141                	addi	sp,sp,-16
    8000034c:	e406                	sd	ra,8(sp)
    8000034e:	e022                	sd	s0,0(sp)
    80000350:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000352:	00001097          	auipc	ra,0x1
    80000356:	afe080e7          	jalr	-1282(ra) # 80000e50 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    8000035a:	00008717          	auipc	a4,0x8
    8000035e:	71670713          	addi	a4,a4,1814 # 80008a70 <started>
  if(cpuid() == 0){
    80000362:	c139                	beqz	a0,800003a8 <main+0x5e>
    while(started == 0)
    80000364:	431c                	lw	a5,0(a4)
    80000366:	2781                	sext.w	a5,a5
    80000368:	dff5                	beqz	a5,80000364 <main+0x1a>
      ;
    __sync_synchronize();
    8000036a:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    8000036e:	00001097          	auipc	ra,0x1
    80000372:	ae2080e7          	jalr	-1310(ra) # 80000e50 <cpuid>
    80000376:	85aa                	mv	a1,a0
    80000378:	00008517          	auipc	a0,0x8
    8000037c:	cc050513          	addi	a0,a0,-832 # 80008038 <etext+0x38>
    80000380:	00006097          	auipc	ra,0x6
    80000384:	9bc080e7          	jalr	-1604(ra) # 80005d3c <printf>
    kvminithart();    // turn on paging
    80000388:	00000097          	auipc	ra,0x0
    8000038c:	0d8080e7          	jalr	216(ra) # 80000460 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000390:	00001097          	auipc	ra,0x1
    80000394:	7ba080e7          	jalr	1978(ra) # 80001b4a <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000398:	00005097          	auipc	ra,0x5
    8000039c:	df8080e7          	jalr	-520(ra) # 80005190 <plicinithart>
  }

  scheduler();        
    800003a0:	00001097          	auipc	ra,0x1
    800003a4:	fd6080e7          	jalr	-42(ra) # 80001376 <scheduler>
    consoleinit();
    800003a8:	00006097          	auipc	ra,0x6
    800003ac:	85c080e7          	jalr	-1956(ra) # 80005c04 <consoleinit>
    printfinit();
    800003b0:	00006097          	auipc	ra,0x6
    800003b4:	b72080e7          	jalr	-1166(ra) # 80005f22 <printfinit>
    printf("\n");
    800003b8:	00008517          	auipc	a0,0x8
    800003bc:	c9050513          	addi	a0,a0,-880 # 80008048 <etext+0x48>
    800003c0:	00006097          	auipc	ra,0x6
    800003c4:	97c080e7          	jalr	-1668(ra) # 80005d3c <printf>
    printf("xv6 kernel is booting\n");
    800003c8:	00008517          	auipc	a0,0x8
    800003cc:	c5850513          	addi	a0,a0,-936 # 80008020 <etext+0x20>
    800003d0:	00006097          	auipc	ra,0x6
    800003d4:	96c080e7          	jalr	-1684(ra) # 80005d3c <printf>
    printf("\n");
    800003d8:	00008517          	auipc	a0,0x8
    800003dc:	c7050513          	addi	a0,a0,-912 # 80008048 <etext+0x48>
    800003e0:	00006097          	auipc	ra,0x6
    800003e4:	95c080e7          	jalr	-1700(ra) # 80005d3c <printf>
    kinit();         // physical page allocator
    800003e8:	00000097          	auipc	ra,0x0
    800003ec:	cf4080e7          	jalr	-780(ra) # 800000dc <kinit>
    kvminit();       // create kernel page table
    800003f0:	00000097          	auipc	ra,0x0
    800003f4:	326080e7          	jalr	806(ra) # 80000716 <kvminit>
    kvminithart();   // turn on paging
    800003f8:	00000097          	auipc	ra,0x0
    800003fc:	068080e7          	jalr	104(ra) # 80000460 <kvminithart>
    procinit();      // process table
    80000400:	00001097          	auipc	ra,0x1
    80000404:	99c080e7          	jalr	-1636(ra) # 80000d9c <procinit>
    trapinit();      // trap vectors
    80000408:	00001097          	auipc	ra,0x1
    8000040c:	71a080e7          	jalr	1818(ra) # 80001b22 <trapinit>
    trapinithart();  // install kernel trap vector
    80000410:	00001097          	auipc	ra,0x1
    80000414:	73a080e7          	jalr	1850(ra) # 80001b4a <trapinithart>
    plicinit();      // set up interrupt controller
    80000418:	00005097          	auipc	ra,0x5
    8000041c:	d62080e7          	jalr	-670(ra) # 8000517a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000420:	00005097          	auipc	ra,0x5
    80000424:	d70080e7          	jalr	-656(ra) # 80005190 <plicinithart>
    binit();         // buffer cache
    80000428:	00002097          	auipc	ra,0x2
    8000042c:	f24080e7          	jalr	-220(ra) # 8000234c <binit>
    iinit();         // inode table
    80000430:	00002097          	auipc	ra,0x2
    80000434:	5c8080e7          	jalr	1480(ra) # 800029f8 <iinit>
    fileinit();      // file table
    80000438:	00003097          	auipc	ra,0x3
    8000043c:	566080e7          	jalr	1382(ra) # 8000399e <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000440:	00005097          	auipc	ra,0x5
    80000444:	e58080e7          	jalr	-424(ra) # 80005298 <virtio_disk_init>
    userinit();      // first user process
    80000448:	00001097          	auipc	ra,0x1
    8000044c:	d0c080e7          	jalr	-756(ra) # 80001154 <userinit>
    __sync_synchronize();
    80000450:	0ff0000f          	fence
    started = 1;
    80000454:	4785                	li	a5,1
    80000456:	00008717          	auipc	a4,0x8
    8000045a:	60f72d23          	sw	a5,1562(a4) # 80008a70 <started>
    8000045e:	b789                	j	800003a0 <main+0x56>

0000000080000460 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000460:	1141                	addi	sp,sp,-16
    80000462:	e422                	sd	s0,8(sp)
    80000464:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000466:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    8000046a:	00008797          	auipc	a5,0x8
    8000046e:	60e7b783          	ld	a5,1550(a5) # 80008a78 <kernel_pagetable>
    80000472:	83b1                	srli	a5,a5,0xc
    80000474:	577d                	li	a4,-1
    80000476:	177e                	slli	a4,a4,0x3f
    80000478:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    8000047a:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    8000047e:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000482:	6422                	ld	s0,8(sp)
    80000484:	0141                	addi	sp,sp,16
    80000486:	8082                	ret

0000000080000488 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000488:	7139                	addi	sp,sp,-64
    8000048a:	fc06                	sd	ra,56(sp)
    8000048c:	f822                	sd	s0,48(sp)
    8000048e:	f426                	sd	s1,40(sp)
    80000490:	f04a                	sd	s2,32(sp)
    80000492:	ec4e                	sd	s3,24(sp)
    80000494:	e852                	sd	s4,16(sp)
    80000496:	e456                	sd	s5,8(sp)
    80000498:	e05a                	sd	s6,0(sp)
    8000049a:	0080                	addi	s0,sp,64
    8000049c:	84aa                	mv	s1,a0
    8000049e:	89ae                	mv	s3,a1
    800004a0:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    800004a2:	57fd                	li	a5,-1
    800004a4:	83e9                	srli	a5,a5,0x1a
    800004a6:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800004a8:	4b31                	li	s6,12
  if(va >= MAXVA)
    800004aa:	04b7f263          	bgeu	a5,a1,800004ee <walk+0x66>
    panic("walk");
    800004ae:	00008517          	auipc	a0,0x8
    800004b2:	ba250513          	addi	a0,a0,-1118 # 80008050 <etext+0x50>
    800004b6:	00006097          	auipc	ra,0x6
    800004ba:	83c080e7          	jalr	-1988(ra) # 80005cf2 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800004be:	060a8663          	beqz	s5,8000052a <walk+0xa2>
    800004c2:	00000097          	auipc	ra,0x0
    800004c6:	c56080e7          	jalr	-938(ra) # 80000118 <kalloc>
    800004ca:	84aa                	mv	s1,a0
    800004cc:	c529                	beqz	a0,80000516 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004ce:	6605                	lui	a2,0x1
    800004d0:	4581                	li	a1,0
    800004d2:	00000097          	auipc	ra,0x0
    800004d6:	cca080e7          	jalr	-822(ra) # 8000019c <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004da:	00c4d793          	srli	a5,s1,0xc
    800004de:	07aa                	slli	a5,a5,0xa
    800004e0:	0017e793          	ori	a5,a5,1
    800004e4:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004e8:	3a5d                	addiw	s4,s4,-9
    800004ea:	036a0063          	beq	s4,s6,8000050a <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004ee:	0149d933          	srl	s2,s3,s4
    800004f2:	1ff97913          	andi	s2,s2,511
    800004f6:	090e                	slli	s2,s2,0x3
    800004f8:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004fa:	00093483          	ld	s1,0(s2)
    800004fe:	0014f793          	andi	a5,s1,1
    80000502:	dfd5                	beqz	a5,800004be <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000504:	80a9                	srli	s1,s1,0xa
    80000506:	04b2                	slli	s1,s1,0xc
    80000508:	b7c5                	j	800004e8 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    8000050a:	00c9d513          	srli	a0,s3,0xc
    8000050e:	1ff57513          	andi	a0,a0,511
    80000512:	050e                	slli	a0,a0,0x3
    80000514:	9526                	add	a0,a0,s1
}
    80000516:	70e2                	ld	ra,56(sp)
    80000518:	7442                	ld	s0,48(sp)
    8000051a:	74a2                	ld	s1,40(sp)
    8000051c:	7902                	ld	s2,32(sp)
    8000051e:	69e2                	ld	s3,24(sp)
    80000520:	6a42                	ld	s4,16(sp)
    80000522:	6aa2                	ld	s5,8(sp)
    80000524:	6b02                	ld	s6,0(sp)
    80000526:	6121                	addi	sp,sp,64
    80000528:	8082                	ret
        return 0;
    8000052a:	4501                	li	a0,0
    8000052c:	b7ed                	j	80000516 <walk+0x8e>

000000008000052e <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    8000052e:	57fd                	li	a5,-1
    80000530:	83e9                	srli	a5,a5,0x1a
    80000532:	00b7f463          	bgeu	a5,a1,8000053a <walkaddr+0xc>
    return 0;
    80000536:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000538:	8082                	ret
{
    8000053a:	1141                	addi	sp,sp,-16
    8000053c:	e406                	sd	ra,8(sp)
    8000053e:	e022                	sd	s0,0(sp)
    80000540:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000542:	4601                	li	a2,0
    80000544:	00000097          	auipc	ra,0x0
    80000548:	f44080e7          	jalr	-188(ra) # 80000488 <walk>
  if(pte == 0)
    8000054c:	c105                	beqz	a0,8000056c <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    8000054e:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000550:	0117f693          	andi	a3,a5,17
    80000554:	4745                	li	a4,17
    return 0;
    80000556:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000558:	00e68663          	beq	a3,a4,80000564 <walkaddr+0x36>
}
    8000055c:	60a2                	ld	ra,8(sp)
    8000055e:	6402                	ld	s0,0(sp)
    80000560:	0141                	addi	sp,sp,16
    80000562:	8082                	ret
  pa = PTE2PA(*pte);
    80000564:	00a7d513          	srli	a0,a5,0xa
    80000568:	0532                	slli	a0,a0,0xc
  return pa;
    8000056a:	bfcd                	j	8000055c <walkaddr+0x2e>
    return 0;
    8000056c:	4501                	li	a0,0
    8000056e:	b7fd                	j	8000055c <walkaddr+0x2e>

0000000080000570 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80000570:	715d                	addi	sp,sp,-80
    80000572:	e486                	sd	ra,72(sp)
    80000574:	e0a2                	sd	s0,64(sp)
    80000576:	fc26                	sd	s1,56(sp)
    80000578:	f84a                	sd	s2,48(sp)
    8000057a:	f44e                	sd	s3,40(sp)
    8000057c:	f052                	sd	s4,32(sp)
    8000057e:	ec56                	sd	s5,24(sp)
    80000580:	e85a                	sd	s6,16(sp)
    80000582:	e45e                	sd	s7,8(sp)
    80000584:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    80000586:	c205                	beqz	a2,800005a6 <mappages+0x36>
    80000588:	8aaa                	mv	s5,a0
    8000058a:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    8000058c:	77fd                	lui	a5,0xfffff
    8000058e:	00f5fa33          	and	s4,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    80000592:	15fd                	addi	a1,a1,-1
    80000594:	00c589b3          	add	s3,a1,a2
    80000598:	00f9f9b3          	and	s3,s3,a5
  a = PGROUNDDOWN(va);
    8000059c:	8952                	mv	s2,s4
    8000059e:	41468a33          	sub	s4,a3,s4
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800005a2:	6b85                	lui	s7,0x1
    800005a4:	a015                	j	800005c8 <mappages+0x58>
    panic("mappages: size");
    800005a6:	00008517          	auipc	a0,0x8
    800005aa:	ab250513          	addi	a0,a0,-1358 # 80008058 <etext+0x58>
    800005ae:	00005097          	auipc	ra,0x5
    800005b2:	744080e7          	jalr	1860(ra) # 80005cf2 <panic>
      panic("mappages: remap");
    800005b6:	00008517          	auipc	a0,0x8
    800005ba:	ab250513          	addi	a0,a0,-1358 # 80008068 <etext+0x68>
    800005be:	00005097          	auipc	ra,0x5
    800005c2:	734080e7          	jalr	1844(ra) # 80005cf2 <panic>
    a += PGSIZE;
    800005c6:	995e                	add	s2,s2,s7
  for(;;){
    800005c8:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800005cc:	4605                	li	a2,1
    800005ce:	85ca                	mv	a1,s2
    800005d0:	8556                	mv	a0,s5
    800005d2:	00000097          	auipc	ra,0x0
    800005d6:	eb6080e7          	jalr	-330(ra) # 80000488 <walk>
    800005da:	cd19                	beqz	a0,800005f8 <mappages+0x88>
    if(*pte & PTE_V)
    800005dc:	611c                	ld	a5,0(a0)
    800005de:	8b85                	andi	a5,a5,1
    800005e0:	fbf9                	bnez	a5,800005b6 <mappages+0x46>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800005e2:	80b1                	srli	s1,s1,0xc
    800005e4:	04aa                	slli	s1,s1,0xa
    800005e6:	0164e4b3          	or	s1,s1,s6
    800005ea:	0014e493          	ori	s1,s1,1
    800005ee:	e104                	sd	s1,0(a0)
    if(a == last)
    800005f0:	fd391be3          	bne	s2,s3,800005c6 <mappages+0x56>
    pa += PGSIZE;
  }
  return 0;
    800005f4:	4501                	li	a0,0
    800005f6:	a011                	j	800005fa <mappages+0x8a>
      return -1;
    800005f8:	557d                	li	a0,-1
}
    800005fa:	60a6                	ld	ra,72(sp)
    800005fc:	6406                	ld	s0,64(sp)
    800005fe:	74e2                	ld	s1,56(sp)
    80000600:	7942                	ld	s2,48(sp)
    80000602:	79a2                	ld	s3,40(sp)
    80000604:	7a02                	ld	s4,32(sp)
    80000606:	6ae2                	ld	s5,24(sp)
    80000608:	6b42                	ld	s6,16(sp)
    8000060a:	6ba2                	ld	s7,8(sp)
    8000060c:	6161                	addi	sp,sp,80
    8000060e:	8082                	ret

0000000080000610 <kvmmap>:
{
    80000610:	1141                	addi	sp,sp,-16
    80000612:	e406                	sd	ra,8(sp)
    80000614:	e022                	sd	s0,0(sp)
    80000616:	0800                	addi	s0,sp,16
    80000618:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    8000061a:	86b2                	mv	a3,a2
    8000061c:	863e                	mv	a2,a5
    8000061e:	00000097          	auipc	ra,0x0
    80000622:	f52080e7          	jalr	-174(ra) # 80000570 <mappages>
    80000626:	e509                	bnez	a0,80000630 <kvmmap+0x20>
}
    80000628:	60a2                	ld	ra,8(sp)
    8000062a:	6402                	ld	s0,0(sp)
    8000062c:	0141                	addi	sp,sp,16
    8000062e:	8082                	ret
    panic("kvmmap");
    80000630:	00008517          	auipc	a0,0x8
    80000634:	a4850513          	addi	a0,a0,-1464 # 80008078 <etext+0x78>
    80000638:	00005097          	auipc	ra,0x5
    8000063c:	6ba080e7          	jalr	1722(ra) # 80005cf2 <panic>

0000000080000640 <kvmmake>:
{
    80000640:	1101                	addi	sp,sp,-32
    80000642:	ec06                	sd	ra,24(sp)
    80000644:	e822                	sd	s0,16(sp)
    80000646:	e426                	sd	s1,8(sp)
    80000648:	e04a                	sd	s2,0(sp)
    8000064a:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000064c:	00000097          	auipc	ra,0x0
    80000650:	acc080e7          	jalr	-1332(ra) # 80000118 <kalloc>
    80000654:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000656:	6605                	lui	a2,0x1
    80000658:	4581                	li	a1,0
    8000065a:	00000097          	auipc	ra,0x0
    8000065e:	b42080e7          	jalr	-1214(ra) # 8000019c <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000662:	4719                	li	a4,6
    80000664:	6685                	lui	a3,0x1
    80000666:	10000637          	lui	a2,0x10000
    8000066a:	100005b7          	lui	a1,0x10000
    8000066e:	8526                	mv	a0,s1
    80000670:	00000097          	auipc	ra,0x0
    80000674:	fa0080e7          	jalr	-96(ra) # 80000610 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000678:	4719                	li	a4,6
    8000067a:	6685                	lui	a3,0x1
    8000067c:	10001637          	lui	a2,0x10001
    80000680:	100015b7          	lui	a1,0x10001
    80000684:	8526                	mv	a0,s1
    80000686:	00000097          	auipc	ra,0x0
    8000068a:	f8a080e7          	jalr	-118(ra) # 80000610 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    8000068e:	4719                	li	a4,6
    80000690:	004006b7          	lui	a3,0x400
    80000694:	0c000637          	lui	a2,0xc000
    80000698:	0c0005b7          	lui	a1,0xc000
    8000069c:	8526                	mv	a0,s1
    8000069e:	00000097          	auipc	ra,0x0
    800006a2:	f72080e7          	jalr	-142(ra) # 80000610 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800006a6:	00008917          	auipc	s2,0x8
    800006aa:	95a90913          	addi	s2,s2,-1702 # 80008000 <etext>
    800006ae:	4729                	li	a4,10
    800006b0:	80008697          	auipc	a3,0x80008
    800006b4:	95068693          	addi	a3,a3,-1712 # 8000 <_entry-0x7fff8000>
    800006b8:	4605                	li	a2,1
    800006ba:	067e                	slli	a2,a2,0x1f
    800006bc:	85b2                	mv	a1,a2
    800006be:	8526                	mv	a0,s1
    800006c0:	00000097          	auipc	ra,0x0
    800006c4:	f50080e7          	jalr	-176(ra) # 80000610 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800006c8:	4719                	li	a4,6
    800006ca:	46c5                	li	a3,17
    800006cc:	06ee                	slli	a3,a3,0x1b
    800006ce:	412686b3          	sub	a3,a3,s2
    800006d2:	864a                	mv	a2,s2
    800006d4:	85ca                	mv	a1,s2
    800006d6:	8526                	mv	a0,s1
    800006d8:	00000097          	auipc	ra,0x0
    800006dc:	f38080e7          	jalr	-200(ra) # 80000610 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006e0:	4729                	li	a4,10
    800006e2:	6685                	lui	a3,0x1
    800006e4:	00007617          	auipc	a2,0x7
    800006e8:	91c60613          	addi	a2,a2,-1764 # 80007000 <_trampoline>
    800006ec:	040005b7          	lui	a1,0x4000
    800006f0:	15fd                	addi	a1,a1,-1
    800006f2:	05b2                	slli	a1,a1,0xc
    800006f4:	8526                	mv	a0,s1
    800006f6:	00000097          	auipc	ra,0x0
    800006fa:	f1a080e7          	jalr	-230(ra) # 80000610 <kvmmap>
  proc_mapstacks(kpgtbl);
    800006fe:	8526                	mv	a0,s1
    80000700:	00000097          	auipc	ra,0x0
    80000704:	606080e7          	jalr	1542(ra) # 80000d06 <proc_mapstacks>
}
    80000708:	8526                	mv	a0,s1
    8000070a:	60e2                	ld	ra,24(sp)
    8000070c:	6442                	ld	s0,16(sp)
    8000070e:	64a2                	ld	s1,8(sp)
    80000710:	6902                	ld	s2,0(sp)
    80000712:	6105                	addi	sp,sp,32
    80000714:	8082                	ret

0000000080000716 <kvminit>:
{
    80000716:	1141                	addi	sp,sp,-16
    80000718:	e406                	sd	ra,8(sp)
    8000071a:	e022                	sd	s0,0(sp)
    8000071c:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    8000071e:	00000097          	auipc	ra,0x0
    80000722:	f22080e7          	jalr	-222(ra) # 80000640 <kvmmake>
    80000726:	00008797          	auipc	a5,0x8
    8000072a:	34a7b923          	sd	a0,850(a5) # 80008a78 <kernel_pagetable>
}
    8000072e:	60a2                	ld	ra,8(sp)
    80000730:	6402                	ld	s0,0(sp)
    80000732:	0141                	addi	sp,sp,16
    80000734:	8082                	ret

0000000080000736 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000736:	715d                	addi	sp,sp,-80
    80000738:	e486                	sd	ra,72(sp)
    8000073a:	e0a2                	sd	s0,64(sp)
    8000073c:	fc26                	sd	s1,56(sp)
    8000073e:	f84a                	sd	s2,48(sp)
    80000740:	f44e                	sd	s3,40(sp)
    80000742:	f052                	sd	s4,32(sp)
    80000744:	ec56                	sd	s5,24(sp)
    80000746:	e85a                	sd	s6,16(sp)
    80000748:	e45e                	sd	s7,8(sp)
    8000074a:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000074c:	03459793          	slli	a5,a1,0x34
    80000750:	e795                	bnez	a5,8000077c <uvmunmap+0x46>
    80000752:	8a2a                	mv	s4,a0
    80000754:	892e                	mv	s2,a1
    80000756:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000758:	0632                	slli	a2,a2,0xc
    8000075a:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    8000075e:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000760:	6b05                	lui	s6,0x1
    80000762:	0735e863          	bltu	a1,s3,800007d2 <uvmunmap+0x9c>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80000766:	60a6                	ld	ra,72(sp)
    80000768:	6406                	ld	s0,64(sp)
    8000076a:	74e2                	ld	s1,56(sp)
    8000076c:	7942                	ld	s2,48(sp)
    8000076e:	79a2                	ld	s3,40(sp)
    80000770:	7a02                	ld	s4,32(sp)
    80000772:	6ae2                	ld	s5,24(sp)
    80000774:	6b42                	ld	s6,16(sp)
    80000776:	6ba2                	ld	s7,8(sp)
    80000778:	6161                	addi	sp,sp,80
    8000077a:	8082                	ret
    panic("uvmunmap: not aligned");
    8000077c:	00008517          	auipc	a0,0x8
    80000780:	90450513          	addi	a0,a0,-1788 # 80008080 <etext+0x80>
    80000784:	00005097          	auipc	ra,0x5
    80000788:	56e080e7          	jalr	1390(ra) # 80005cf2 <panic>
      panic("uvmunmap: walk");
    8000078c:	00008517          	auipc	a0,0x8
    80000790:	90c50513          	addi	a0,a0,-1780 # 80008098 <etext+0x98>
    80000794:	00005097          	auipc	ra,0x5
    80000798:	55e080e7          	jalr	1374(ra) # 80005cf2 <panic>
      panic("uvmunmap: not mapped");
    8000079c:	00008517          	auipc	a0,0x8
    800007a0:	90c50513          	addi	a0,a0,-1780 # 800080a8 <etext+0xa8>
    800007a4:	00005097          	auipc	ra,0x5
    800007a8:	54e080e7          	jalr	1358(ra) # 80005cf2 <panic>
      panic("uvmunmap: not a leaf");
    800007ac:	00008517          	auipc	a0,0x8
    800007b0:	91450513          	addi	a0,a0,-1772 # 800080c0 <etext+0xc0>
    800007b4:	00005097          	auipc	ra,0x5
    800007b8:	53e080e7          	jalr	1342(ra) # 80005cf2 <panic>
      uint64 pa = PTE2PA(*pte);
    800007bc:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800007be:	0532                	slli	a0,a0,0xc
    800007c0:	00000097          	auipc	ra,0x0
    800007c4:	85c080e7          	jalr	-1956(ra) # 8000001c <kfree>
    *pte = 0;
    800007c8:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007cc:	995a                	add	s2,s2,s6
    800007ce:	f9397ce3          	bgeu	s2,s3,80000766 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800007d2:	4601                	li	a2,0
    800007d4:	85ca                	mv	a1,s2
    800007d6:	8552                	mv	a0,s4
    800007d8:	00000097          	auipc	ra,0x0
    800007dc:	cb0080e7          	jalr	-848(ra) # 80000488 <walk>
    800007e0:	84aa                	mv	s1,a0
    800007e2:	d54d                	beqz	a0,8000078c <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800007e4:	6108                	ld	a0,0(a0)
    800007e6:	00157793          	andi	a5,a0,1
    800007ea:	dbcd                	beqz	a5,8000079c <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007ec:	3ff57793          	andi	a5,a0,1023
    800007f0:	fb778ee3          	beq	a5,s7,800007ac <uvmunmap+0x76>
    if(do_free){
    800007f4:	fc0a8ae3          	beqz	s5,800007c8 <uvmunmap+0x92>
    800007f8:	b7d1                	j	800007bc <uvmunmap+0x86>

00000000800007fa <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007fa:	1101                	addi	sp,sp,-32
    800007fc:	ec06                	sd	ra,24(sp)
    800007fe:	e822                	sd	s0,16(sp)
    80000800:	e426                	sd	s1,8(sp)
    80000802:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80000804:	00000097          	auipc	ra,0x0
    80000808:	914080e7          	jalr	-1772(ra) # 80000118 <kalloc>
    8000080c:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000080e:	c519                	beqz	a0,8000081c <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000810:	6605                	lui	a2,0x1
    80000812:	4581                	li	a1,0
    80000814:	00000097          	auipc	ra,0x0
    80000818:	988080e7          	jalr	-1656(ra) # 8000019c <memset>
  return pagetable;
}
    8000081c:	8526                	mv	a0,s1
    8000081e:	60e2                	ld	ra,24(sp)
    80000820:	6442                	ld	s0,16(sp)
    80000822:	64a2                	ld	s1,8(sp)
    80000824:	6105                	addi	sp,sp,32
    80000826:	8082                	ret

0000000080000828 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    80000828:	7179                	addi	sp,sp,-48
    8000082a:	f406                	sd	ra,40(sp)
    8000082c:	f022                	sd	s0,32(sp)
    8000082e:	ec26                	sd	s1,24(sp)
    80000830:	e84a                	sd	s2,16(sp)
    80000832:	e44e                	sd	s3,8(sp)
    80000834:	e052                	sd	s4,0(sp)
    80000836:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000838:	6785                	lui	a5,0x1
    8000083a:	04f67863          	bgeu	a2,a5,8000088a <uvmfirst+0x62>
    8000083e:	8a2a                	mv	s4,a0
    80000840:	89ae                	mv	s3,a1
    80000842:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80000844:	00000097          	auipc	ra,0x0
    80000848:	8d4080e7          	jalr	-1836(ra) # 80000118 <kalloc>
    8000084c:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8000084e:	6605                	lui	a2,0x1
    80000850:	4581                	li	a1,0
    80000852:	00000097          	auipc	ra,0x0
    80000856:	94a080e7          	jalr	-1718(ra) # 8000019c <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000085a:	4779                	li	a4,30
    8000085c:	86ca                	mv	a3,s2
    8000085e:	6605                	lui	a2,0x1
    80000860:	4581                	li	a1,0
    80000862:	8552                	mv	a0,s4
    80000864:	00000097          	auipc	ra,0x0
    80000868:	d0c080e7          	jalr	-756(ra) # 80000570 <mappages>
  memmove(mem, src, sz);
    8000086c:	8626                	mv	a2,s1
    8000086e:	85ce                	mv	a1,s3
    80000870:	854a                	mv	a0,s2
    80000872:	00000097          	auipc	ra,0x0
    80000876:	98a080e7          	jalr	-1654(ra) # 800001fc <memmove>
}
    8000087a:	70a2                	ld	ra,40(sp)
    8000087c:	7402                	ld	s0,32(sp)
    8000087e:	64e2                	ld	s1,24(sp)
    80000880:	6942                	ld	s2,16(sp)
    80000882:	69a2                	ld	s3,8(sp)
    80000884:	6a02                	ld	s4,0(sp)
    80000886:	6145                	addi	sp,sp,48
    80000888:	8082                	ret
    panic("uvmfirst: more than a page");
    8000088a:	00008517          	auipc	a0,0x8
    8000088e:	84e50513          	addi	a0,a0,-1970 # 800080d8 <etext+0xd8>
    80000892:	00005097          	auipc	ra,0x5
    80000896:	460080e7          	jalr	1120(ra) # 80005cf2 <panic>

000000008000089a <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000089a:	1101                	addi	sp,sp,-32
    8000089c:	ec06                	sd	ra,24(sp)
    8000089e:	e822                	sd	s0,16(sp)
    800008a0:	e426                	sd	s1,8(sp)
    800008a2:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800008a4:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800008a6:	00b67d63          	bgeu	a2,a1,800008c0 <uvmdealloc+0x26>
    800008aa:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800008ac:	6785                	lui	a5,0x1
    800008ae:	17fd                	addi	a5,a5,-1
    800008b0:	00f60733          	add	a4,a2,a5
    800008b4:	767d                	lui	a2,0xfffff
    800008b6:	8f71                	and	a4,a4,a2
    800008b8:	97ae                	add	a5,a5,a1
    800008ba:	8ff1                	and	a5,a5,a2
    800008bc:	00f76863          	bltu	a4,a5,800008cc <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800008c0:	8526                	mv	a0,s1
    800008c2:	60e2                	ld	ra,24(sp)
    800008c4:	6442                	ld	s0,16(sp)
    800008c6:	64a2                	ld	s1,8(sp)
    800008c8:	6105                	addi	sp,sp,32
    800008ca:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008cc:	8f99                	sub	a5,a5,a4
    800008ce:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008d0:	4685                	li	a3,1
    800008d2:	0007861b          	sext.w	a2,a5
    800008d6:	85ba                	mv	a1,a4
    800008d8:	00000097          	auipc	ra,0x0
    800008dc:	e5e080e7          	jalr	-418(ra) # 80000736 <uvmunmap>
    800008e0:	b7c5                	j	800008c0 <uvmdealloc+0x26>

00000000800008e2 <uvmalloc>:
  if(newsz < oldsz)
    800008e2:	0ab66563          	bltu	a2,a1,8000098c <uvmalloc+0xaa>
{
    800008e6:	7139                	addi	sp,sp,-64
    800008e8:	fc06                	sd	ra,56(sp)
    800008ea:	f822                	sd	s0,48(sp)
    800008ec:	f426                	sd	s1,40(sp)
    800008ee:	f04a                	sd	s2,32(sp)
    800008f0:	ec4e                	sd	s3,24(sp)
    800008f2:	e852                	sd	s4,16(sp)
    800008f4:	e456                	sd	s5,8(sp)
    800008f6:	e05a                	sd	s6,0(sp)
    800008f8:	0080                	addi	s0,sp,64
    800008fa:	8aaa                	mv	s5,a0
    800008fc:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008fe:	6985                	lui	s3,0x1
    80000900:	19fd                	addi	s3,s3,-1
    80000902:	95ce                	add	a1,a1,s3
    80000904:	79fd                	lui	s3,0xfffff
    80000906:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000090a:	08c9f363          	bgeu	s3,a2,80000990 <uvmalloc+0xae>
    8000090e:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000910:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80000914:	00000097          	auipc	ra,0x0
    80000918:	804080e7          	jalr	-2044(ra) # 80000118 <kalloc>
    8000091c:	84aa                	mv	s1,a0
    if(mem == 0){
    8000091e:	c51d                	beqz	a0,8000094c <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    80000920:	6605                	lui	a2,0x1
    80000922:	4581                	li	a1,0
    80000924:	00000097          	auipc	ra,0x0
    80000928:	878080e7          	jalr	-1928(ra) # 8000019c <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000092c:	875a                	mv	a4,s6
    8000092e:	86a6                	mv	a3,s1
    80000930:	6605                	lui	a2,0x1
    80000932:	85ca                	mv	a1,s2
    80000934:	8556                	mv	a0,s5
    80000936:	00000097          	auipc	ra,0x0
    8000093a:	c3a080e7          	jalr	-966(ra) # 80000570 <mappages>
    8000093e:	e90d                	bnez	a0,80000970 <uvmalloc+0x8e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000940:	6785                	lui	a5,0x1
    80000942:	993e                	add	s2,s2,a5
    80000944:	fd4968e3          	bltu	s2,s4,80000914 <uvmalloc+0x32>
  return newsz;
    80000948:	8552                	mv	a0,s4
    8000094a:	a809                	j	8000095c <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    8000094c:	864e                	mv	a2,s3
    8000094e:	85ca                	mv	a1,s2
    80000950:	8556                	mv	a0,s5
    80000952:	00000097          	auipc	ra,0x0
    80000956:	f48080e7          	jalr	-184(ra) # 8000089a <uvmdealloc>
      return 0;
    8000095a:	4501                	li	a0,0
}
    8000095c:	70e2                	ld	ra,56(sp)
    8000095e:	7442                	ld	s0,48(sp)
    80000960:	74a2                	ld	s1,40(sp)
    80000962:	7902                	ld	s2,32(sp)
    80000964:	69e2                	ld	s3,24(sp)
    80000966:	6a42                	ld	s4,16(sp)
    80000968:	6aa2                	ld	s5,8(sp)
    8000096a:	6b02                	ld	s6,0(sp)
    8000096c:	6121                	addi	sp,sp,64
    8000096e:	8082                	ret
      kfree(mem);
    80000970:	8526                	mv	a0,s1
    80000972:	fffff097          	auipc	ra,0xfffff
    80000976:	6aa080e7          	jalr	1706(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000097a:	864e                	mv	a2,s3
    8000097c:	85ca                	mv	a1,s2
    8000097e:	8556                	mv	a0,s5
    80000980:	00000097          	auipc	ra,0x0
    80000984:	f1a080e7          	jalr	-230(ra) # 8000089a <uvmdealloc>
      return 0;
    80000988:	4501                	li	a0,0
    8000098a:	bfc9                	j	8000095c <uvmalloc+0x7a>
    return oldsz;
    8000098c:	852e                	mv	a0,a1
}
    8000098e:	8082                	ret
  return newsz;
    80000990:	8532                	mv	a0,a2
    80000992:	b7e9                	j	8000095c <uvmalloc+0x7a>

0000000080000994 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000994:	7179                	addi	sp,sp,-48
    80000996:	f406                	sd	ra,40(sp)
    80000998:	f022                	sd	s0,32(sp)
    8000099a:	ec26                	sd	s1,24(sp)
    8000099c:	e84a                	sd	s2,16(sp)
    8000099e:	e44e                	sd	s3,8(sp)
    800009a0:	e052                	sd	s4,0(sp)
    800009a2:	1800                	addi	s0,sp,48
    800009a4:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800009a6:	84aa                	mv	s1,a0
    800009a8:	6905                	lui	s2,0x1
    800009aa:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009ac:	4985                	li	s3,1
    800009ae:	a821                	j	800009c6 <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800009b0:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    800009b2:	0532                	slli	a0,a0,0xc
    800009b4:	00000097          	auipc	ra,0x0
    800009b8:	fe0080e7          	jalr	-32(ra) # 80000994 <freewalk>
      pagetable[i] = 0;
    800009bc:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800009c0:	04a1                	addi	s1,s1,8
    800009c2:	03248163          	beq	s1,s2,800009e4 <freewalk+0x50>
    pte_t pte = pagetable[i];
    800009c6:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009c8:	00f57793          	andi	a5,a0,15
    800009cc:	ff3782e3          	beq	a5,s3,800009b0 <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009d0:	8905                	andi	a0,a0,1
    800009d2:	d57d                	beqz	a0,800009c0 <freewalk+0x2c>
      panic("freewalk: leaf");
    800009d4:	00007517          	auipc	a0,0x7
    800009d8:	72450513          	addi	a0,a0,1828 # 800080f8 <etext+0xf8>
    800009dc:	00005097          	auipc	ra,0x5
    800009e0:	316080e7          	jalr	790(ra) # 80005cf2 <panic>
    }
  }
  kfree((void*)pagetable);
    800009e4:	8552                	mv	a0,s4
    800009e6:	fffff097          	auipc	ra,0xfffff
    800009ea:	636080e7          	jalr	1590(ra) # 8000001c <kfree>
}
    800009ee:	70a2                	ld	ra,40(sp)
    800009f0:	7402                	ld	s0,32(sp)
    800009f2:	64e2                	ld	s1,24(sp)
    800009f4:	6942                	ld	s2,16(sp)
    800009f6:	69a2                	ld	s3,8(sp)
    800009f8:	6a02                	ld	s4,0(sp)
    800009fa:	6145                	addi	sp,sp,48
    800009fc:	8082                	ret

00000000800009fe <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009fe:	1101                	addi	sp,sp,-32
    80000a00:	ec06                	sd	ra,24(sp)
    80000a02:	e822                	sd	s0,16(sp)
    80000a04:	e426                	sd	s1,8(sp)
    80000a06:	1000                	addi	s0,sp,32
    80000a08:	84aa                	mv	s1,a0
  if(sz > 0)
    80000a0a:	e999                	bnez	a1,80000a20 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000a0c:	8526                	mv	a0,s1
    80000a0e:	00000097          	auipc	ra,0x0
    80000a12:	f86080e7          	jalr	-122(ra) # 80000994 <freewalk>
}
    80000a16:	60e2                	ld	ra,24(sp)
    80000a18:	6442                	ld	s0,16(sp)
    80000a1a:	64a2                	ld	s1,8(sp)
    80000a1c:	6105                	addi	sp,sp,32
    80000a1e:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000a20:	6605                	lui	a2,0x1
    80000a22:	167d                	addi	a2,a2,-1
    80000a24:	962e                	add	a2,a2,a1
    80000a26:	4685                	li	a3,1
    80000a28:	8231                	srli	a2,a2,0xc
    80000a2a:	4581                	li	a1,0
    80000a2c:	00000097          	auipc	ra,0x0
    80000a30:	d0a080e7          	jalr	-758(ra) # 80000736 <uvmunmap>
    80000a34:	bfe1                	j	80000a0c <uvmfree+0xe>

0000000080000a36 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a36:	c679                	beqz	a2,80000b04 <uvmcopy+0xce>
{
    80000a38:	715d                	addi	sp,sp,-80
    80000a3a:	e486                	sd	ra,72(sp)
    80000a3c:	e0a2                	sd	s0,64(sp)
    80000a3e:	fc26                	sd	s1,56(sp)
    80000a40:	f84a                	sd	s2,48(sp)
    80000a42:	f44e                	sd	s3,40(sp)
    80000a44:	f052                	sd	s4,32(sp)
    80000a46:	ec56                	sd	s5,24(sp)
    80000a48:	e85a                	sd	s6,16(sp)
    80000a4a:	e45e                	sd	s7,8(sp)
    80000a4c:	0880                	addi	s0,sp,80
    80000a4e:	8b2a                	mv	s6,a0
    80000a50:	8aae                	mv	s5,a1
    80000a52:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a54:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a56:	4601                	li	a2,0
    80000a58:	85ce                	mv	a1,s3
    80000a5a:	855a                	mv	a0,s6
    80000a5c:	00000097          	auipc	ra,0x0
    80000a60:	a2c080e7          	jalr	-1492(ra) # 80000488 <walk>
    80000a64:	c531                	beqz	a0,80000ab0 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a66:	6118                	ld	a4,0(a0)
    80000a68:	00177793          	andi	a5,a4,1
    80000a6c:	cbb1                	beqz	a5,80000ac0 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a6e:	00a75593          	srli	a1,a4,0xa
    80000a72:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a76:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a7a:	fffff097          	auipc	ra,0xfffff
    80000a7e:	69e080e7          	jalr	1694(ra) # 80000118 <kalloc>
    80000a82:	892a                	mv	s2,a0
    80000a84:	c939                	beqz	a0,80000ada <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a86:	6605                	lui	a2,0x1
    80000a88:	85de                	mv	a1,s7
    80000a8a:	fffff097          	auipc	ra,0xfffff
    80000a8e:	772080e7          	jalr	1906(ra) # 800001fc <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000a92:	8726                	mv	a4,s1
    80000a94:	86ca                	mv	a3,s2
    80000a96:	6605                	lui	a2,0x1
    80000a98:	85ce                	mv	a1,s3
    80000a9a:	8556                	mv	a0,s5
    80000a9c:	00000097          	auipc	ra,0x0
    80000aa0:	ad4080e7          	jalr	-1324(ra) # 80000570 <mappages>
    80000aa4:	e515                	bnez	a0,80000ad0 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000aa6:	6785                	lui	a5,0x1
    80000aa8:	99be                	add	s3,s3,a5
    80000aaa:	fb49e6e3          	bltu	s3,s4,80000a56 <uvmcopy+0x20>
    80000aae:	a081                	j	80000aee <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000ab0:	00007517          	auipc	a0,0x7
    80000ab4:	65850513          	addi	a0,a0,1624 # 80008108 <etext+0x108>
    80000ab8:	00005097          	auipc	ra,0x5
    80000abc:	23a080e7          	jalr	570(ra) # 80005cf2 <panic>
      panic("uvmcopy: page not present");
    80000ac0:	00007517          	auipc	a0,0x7
    80000ac4:	66850513          	addi	a0,a0,1640 # 80008128 <etext+0x128>
    80000ac8:	00005097          	auipc	ra,0x5
    80000acc:	22a080e7          	jalr	554(ra) # 80005cf2 <panic>
      kfree(mem);
    80000ad0:	854a                	mv	a0,s2
    80000ad2:	fffff097          	auipc	ra,0xfffff
    80000ad6:	54a080e7          	jalr	1354(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000ada:	4685                	li	a3,1
    80000adc:	00c9d613          	srli	a2,s3,0xc
    80000ae0:	4581                	li	a1,0
    80000ae2:	8556                	mv	a0,s5
    80000ae4:	00000097          	auipc	ra,0x0
    80000ae8:	c52080e7          	jalr	-942(ra) # 80000736 <uvmunmap>
  return -1;
    80000aec:	557d                	li	a0,-1
}
    80000aee:	60a6                	ld	ra,72(sp)
    80000af0:	6406                	ld	s0,64(sp)
    80000af2:	74e2                	ld	s1,56(sp)
    80000af4:	7942                	ld	s2,48(sp)
    80000af6:	79a2                	ld	s3,40(sp)
    80000af8:	7a02                	ld	s4,32(sp)
    80000afa:	6ae2                	ld	s5,24(sp)
    80000afc:	6b42                	ld	s6,16(sp)
    80000afe:	6ba2                	ld	s7,8(sp)
    80000b00:	6161                	addi	sp,sp,80
    80000b02:	8082                	ret
  return 0;
    80000b04:	4501                	li	a0,0
}
    80000b06:	8082                	ret

0000000080000b08 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000b08:	1141                	addi	sp,sp,-16
    80000b0a:	e406                	sd	ra,8(sp)
    80000b0c:	e022                	sd	s0,0(sp)
    80000b0e:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000b10:	4601                	li	a2,0
    80000b12:	00000097          	auipc	ra,0x0
    80000b16:	976080e7          	jalr	-1674(ra) # 80000488 <walk>
  if(pte == 0)
    80000b1a:	c901                	beqz	a0,80000b2a <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000b1c:	611c                	ld	a5,0(a0)
    80000b1e:	9bbd                	andi	a5,a5,-17
    80000b20:	e11c                	sd	a5,0(a0)
}
    80000b22:	60a2                	ld	ra,8(sp)
    80000b24:	6402                	ld	s0,0(sp)
    80000b26:	0141                	addi	sp,sp,16
    80000b28:	8082                	ret
    panic("uvmclear");
    80000b2a:	00007517          	auipc	a0,0x7
    80000b2e:	61e50513          	addi	a0,a0,1566 # 80008148 <etext+0x148>
    80000b32:	00005097          	auipc	ra,0x5
    80000b36:	1c0080e7          	jalr	448(ra) # 80005cf2 <panic>

0000000080000b3a <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b3a:	c6bd                	beqz	a3,80000ba8 <copyout+0x6e>
{
    80000b3c:	715d                	addi	sp,sp,-80
    80000b3e:	e486                	sd	ra,72(sp)
    80000b40:	e0a2                	sd	s0,64(sp)
    80000b42:	fc26                	sd	s1,56(sp)
    80000b44:	f84a                	sd	s2,48(sp)
    80000b46:	f44e                	sd	s3,40(sp)
    80000b48:	f052                	sd	s4,32(sp)
    80000b4a:	ec56                	sd	s5,24(sp)
    80000b4c:	e85a                	sd	s6,16(sp)
    80000b4e:	e45e                	sd	s7,8(sp)
    80000b50:	e062                	sd	s8,0(sp)
    80000b52:	0880                	addi	s0,sp,80
    80000b54:	8b2a                	mv	s6,a0
    80000b56:	8c2e                	mv	s8,a1
    80000b58:	8a32                	mv	s4,a2
    80000b5a:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b5c:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b5e:	6a85                	lui	s5,0x1
    80000b60:	a015                	j	80000b84 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b62:	9562                	add	a0,a0,s8
    80000b64:	0004861b          	sext.w	a2,s1
    80000b68:	85d2                	mv	a1,s4
    80000b6a:	41250533          	sub	a0,a0,s2
    80000b6e:	fffff097          	auipc	ra,0xfffff
    80000b72:	68e080e7          	jalr	1678(ra) # 800001fc <memmove>

    len -= n;
    80000b76:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b7a:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b7c:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b80:	02098263          	beqz	s3,80000ba4 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b84:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b88:	85ca                	mv	a1,s2
    80000b8a:	855a                	mv	a0,s6
    80000b8c:	00000097          	auipc	ra,0x0
    80000b90:	9a2080e7          	jalr	-1630(ra) # 8000052e <walkaddr>
    if(pa0 == 0)
    80000b94:	cd01                	beqz	a0,80000bac <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000b96:	418904b3          	sub	s1,s2,s8
    80000b9a:	94d6                	add	s1,s1,s5
    if(n > len)
    80000b9c:	fc99f3e3          	bgeu	s3,s1,80000b62 <copyout+0x28>
    80000ba0:	84ce                	mv	s1,s3
    80000ba2:	b7c1                	j	80000b62 <copyout+0x28>
  }
  return 0;
    80000ba4:	4501                	li	a0,0
    80000ba6:	a021                	j	80000bae <copyout+0x74>
    80000ba8:	4501                	li	a0,0
}
    80000baa:	8082                	ret
      return -1;
    80000bac:	557d                	li	a0,-1
}
    80000bae:	60a6                	ld	ra,72(sp)
    80000bb0:	6406                	ld	s0,64(sp)
    80000bb2:	74e2                	ld	s1,56(sp)
    80000bb4:	7942                	ld	s2,48(sp)
    80000bb6:	79a2                	ld	s3,40(sp)
    80000bb8:	7a02                	ld	s4,32(sp)
    80000bba:	6ae2                	ld	s5,24(sp)
    80000bbc:	6b42                	ld	s6,16(sp)
    80000bbe:	6ba2                	ld	s7,8(sp)
    80000bc0:	6c02                	ld	s8,0(sp)
    80000bc2:	6161                	addi	sp,sp,80
    80000bc4:	8082                	ret

0000000080000bc6 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000bc6:	c6bd                	beqz	a3,80000c34 <copyin+0x6e>
{
    80000bc8:	715d                	addi	sp,sp,-80
    80000bca:	e486                	sd	ra,72(sp)
    80000bcc:	e0a2                	sd	s0,64(sp)
    80000bce:	fc26                	sd	s1,56(sp)
    80000bd0:	f84a                	sd	s2,48(sp)
    80000bd2:	f44e                	sd	s3,40(sp)
    80000bd4:	f052                	sd	s4,32(sp)
    80000bd6:	ec56                	sd	s5,24(sp)
    80000bd8:	e85a                	sd	s6,16(sp)
    80000bda:	e45e                	sd	s7,8(sp)
    80000bdc:	e062                	sd	s8,0(sp)
    80000bde:	0880                	addi	s0,sp,80
    80000be0:	8b2a                	mv	s6,a0
    80000be2:	8a2e                	mv	s4,a1
    80000be4:	8c32                	mv	s8,a2
    80000be6:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000be8:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000bea:	6a85                	lui	s5,0x1
    80000bec:	a015                	j	80000c10 <copyin+0x4a>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000bee:	9562                	add	a0,a0,s8
    80000bf0:	0004861b          	sext.w	a2,s1
    80000bf4:	412505b3          	sub	a1,a0,s2
    80000bf8:	8552                	mv	a0,s4
    80000bfa:	fffff097          	auipc	ra,0xfffff
    80000bfe:	602080e7          	jalr	1538(ra) # 800001fc <memmove>

    len -= n;
    80000c02:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000c06:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000c08:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000c0c:	02098263          	beqz	s3,80000c30 <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    80000c10:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000c14:	85ca                	mv	a1,s2
    80000c16:	855a                	mv	a0,s6
    80000c18:	00000097          	auipc	ra,0x0
    80000c1c:	916080e7          	jalr	-1770(ra) # 8000052e <walkaddr>
    if(pa0 == 0)
    80000c20:	cd01                	beqz	a0,80000c38 <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    80000c22:	418904b3          	sub	s1,s2,s8
    80000c26:	94d6                	add	s1,s1,s5
    if(n > len)
    80000c28:	fc99f3e3          	bgeu	s3,s1,80000bee <copyin+0x28>
    80000c2c:	84ce                	mv	s1,s3
    80000c2e:	b7c1                	j	80000bee <copyin+0x28>
  }
  return 0;
    80000c30:	4501                	li	a0,0
    80000c32:	a021                	j	80000c3a <copyin+0x74>
    80000c34:	4501                	li	a0,0
}
    80000c36:	8082                	ret
      return -1;
    80000c38:	557d                	li	a0,-1
}
    80000c3a:	60a6                	ld	ra,72(sp)
    80000c3c:	6406                	ld	s0,64(sp)
    80000c3e:	74e2                	ld	s1,56(sp)
    80000c40:	7942                	ld	s2,48(sp)
    80000c42:	79a2                	ld	s3,40(sp)
    80000c44:	7a02                	ld	s4,32(sp)
    80000c46:	6ae2                	ld	s5,24(sp)
    80000c48:	6b42                	ld	s6,16(sp)
    80000c4a:	6ba2                	ld	s7,8(sp)
    80000c4c:	6c02                	ld	s8,0(sp)
    80000c4e:	6161                	addi	sp,sp,80
    80000c50:	8082                	ret

0000000080000c52 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c52:	c6c5                	beqz	a3,80000cfa <copyinstr+0xa8>
{
    80000c54:	715d                	addi	sp,sp,-80
    80000c56:	e486                	sd	ra,72(sp)
    80000c58:	e0a2                	sd	s0,64(sp)
    80000c5a:	fc26                	sd	s1,56(sp)
    80000c5c:	f84a                	sd	s2,48(sp)
    80000c5e:	f44e                	sd	s3,40(sp)
    80000c60:	f052                	sd	s4,32(sp)
    80000c62:	ec56                	sd	s5,24(sp)
    80000c64:	e85a                	sd	s6,16(sp)
    80000c66:	e45e                	sd	s7,8(sp)
    80000c68:	0880                	addi	s0,sp,80
    80000c6a:	8a2a                	mv	s4,a0
    80000c6c:	8b2e                	mv	s6,a1
    80000c6e:	8bb2                	mv	s7,a2
    80000c70:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c72:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c74:	6985                	lui	s3,0x1
    80000c76:	a035                	j	80000ca2 <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c78:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c7c:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c7e:	0017b793          	seqz	a5,a5
    80000c82:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000c86:	60a6                	ld	ra,72(sp)
    80000c88:	6406                	ld	s0,64(sp)
    80000c8a:	74e2                	ld	s1,56(sp)
    80000c8c:	7942                	ld	s2,48(sp)
    80000c8e:	79a2                	ld	s3,40(sp)
    80000c90:	7a02                	ld	s4,32(sp)
    80000c92:	6ae2                	ld	s5,24(sp)
    80000c94:	6b42                	ld	s6,16(sp)
    80000c96:	6ba2                	ld	s7,8(sp)
    80000c98:	6161                	addi	sp,sp,80
    80000c9a:	8082                	ret
    srcva = va0 + PGSIZE;
    80000c9c:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000ca0:	c8a9                	beqz	s1,80000cf2 <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000ca2:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000ca6:	85ca                	mv	a1,s2
    80000ca8:	8552                	mv	a0,s4
    80000caa:	00000097          	auipc	ra,0x0
    80000cae:	884080e7          	jalr	-1916(ra) # 8000052e <walkaddr>
    if(pa0 == 0)
    80000cb2:	c131                	beqz	a0,80000cf6 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000cb4:	41790833          	sub	a6,s2,s7
    80000cb8:	984e                	add	a6,a6,s3
    if(n > max)
    80000cba:	0104f363          	bgeu	s1,a6,80000cc0 <copyinstr+0x6e>
    80000cbe:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000cc0:	955e                	add	a0,a0,s7
    80000cc2:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000cc6:	fc080be3          	beqz	a6,80000c9c <copyinstr+0x4a>
    80000cca:	985a                	add	a6,a6,s6
    80000ccc:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000cce:	41650633          	sub	a2,a0,s6
    80000cd2:	14fd                	addi	s1,s1,-1
    80000cd4:	9b26                	add	s6,s6,s1
    80000cd6:	00f60733          	add	a4,a2,a5
    80000cda:	00074703          	lbu	a4,0(a4)
    80000cde:	df49                	beqz	a4,80000c78 <copyinstr+0x26>
        *dst = *p;
    80000ce0:	00e78023          	sb	a4,0(a5)
      --max;
    80000ce4:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000ce8:	0785                	addi	a5,a5,1
    while(n > 0){
    80000cea:	ff0796e3          	bne	a5,a6,80000cd6 <copyinstr+0x84>
      dst++;
    80000cee:	8b42                	mv	s6,a6
    80000cf0:	b775                	j	80000c9c <copyinstr+0x4a>
    80000cf2:	4781                	li	a5,0
    80000cf4:	b769                	j	80000c7e <copyinstr+0x2c>
      return -1;
    80000cf6:	557d                	li	a0,-1
    80000cf8:	b779                	j	80000c86 <copyinstr+0x34>
  int got_null = 0;
    80000cfa:	4781                	li	a5,0
  if(got_null){
    80000cfc:	0017b793          	seqz	a5,a5
    80000d00:	40f00533          	neg	a0,a5
}
    80000d04:	8082                	ret

0000000080000d06 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000d06:	7139                	addi	sp,sp,-64
    80000d08:	fc06                	sd	ra,56(sp)
    80000d0a:	f822                	sd	s0,48(sp)
    80000d0c:	f426                	sd	s1,40(sp)
    80000d0e:	f04a                	sd	s2,32(sp)
    80000d10:	ec4e                	sd	s3,24(sp)
    80000d12:	e852                	sd	s4,16(sp)
    80000d14:	e456                	sd	s5,8(sp)
    80000d16:	e05a                	sd	s6,0(sp)
    80000d18:	0080                	addi	s0,sp,64
    80000d1a:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d1c:	00008497          	auipc	s1,0x8
    80000d20:	1d448493          	addi	s1,s1,468 # 80008ef0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000d24:	8b26                	mv	s6,s1
    80000d26:	00007a97          	auipc	s5,0x7
    80000d2a:	2daa8a93          	addi	s5,s5,730 # 80008000 <etext>
    80000d2e:	04000937          	lui	s2,0x4000
    80000d32:	197d                	addi	s2,s2,-1
    80000d34:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d36:	0000ea17          	auipc	s4,0xe
    80000d3a:	bbaa0a13          	addi	s4,s4,-1094 # 8000e8f0 <tickslock>
    char *pa = kalloc();
    80000d3e:	fffff097          	auipc	ra,0xfffff
    80000d42:	3da080e7          	jalr	986(ra) # 80000118 <kalloc>
    80000d46:	862a                	mv	a2,a0
    if(pa == 0)
    80000d48:	c131                	beqz	a0,80000d8c <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000d4a:	416485b3          	sub	a1,s1,s6
    80000d4e:	858d                	srai	a1,a1,0x3
    80000d50:	000ab783          	ld	a5,0(s5)
    80000d54:	02f585b3          	mul	a1,a1,a5
    80000d58:	2585                	addiw	a1,a1,1
    80000d5a:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d5e:	4719                	li	a4,6
    80000d60:	6685                	lui	a3,0x1
    80000d62:	40b905b3          	sub	a1,s2,a1
    80000d66:	854e                	mv	a0,s3
    80000d68:	00000097          	auipc	ra,0x0
    80000d6c:	8a8080e7          	jalr	-1880(ra) # 80000610 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d70:	16848493          	addi	s1,s1,360
    80000d74:	fd4495e3          	bne	s1,s4,80000d3e <proc_mapstacks+0x38>
  }
}
    80000d78:	70e2                	ld	ra,56(sp)
    80000d7a:	7442                	ld	s0,48(sp)
    80000d7c:	74a2                	ld	s1,40(sp)
    80000d7e:	7902                	ld	s2,32(sp)
    80000d80:	69e2                	ld	s3,24(sp)
    80000d82:	6a42                	ld	s4,16(sp)
    80000d84:	6aa2                	ld	s5,8(sp)
    80000d86:	6b02                	ld	s6,0(sp)
    80000d88:	6121                	addi	sp,sp,64
    80000d8a:	8082                	ret
      panic("kalloc");
    80000d8c:	00007517          	auipc	a0,0x7
    80000d90:	3cc50513          	addi	a0,a0,972 # 80008158 <etext+0x158>
    80000d94:	00005097          	auipc	ra,0x5
    80000d98:	f5e080e7          	jalr	-162(ra) # 80005cf2 <panic>

0000000080000d9c <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000d9c:	7139                	addi	sp,sp,-64
    80000d9e:	fc06                	sd	ra,56(sp)
    80000da0:	f822                	sd	s0,48(sp)
    80000da2:	f426                	sd	s1,40(sp)
    80000da4:	f04a                	sd	s2,32(sp)
    80000da6:	ec4e                	sd	s3,24(sp)
    80000da8:	e852                	sd	s4,16(sp)
    80000daa:	e456                	sd	s5,8(sp)
    80000dac:	e05a                	sd	s6,0(sp)
    80000dae:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000db0:	00007597          	auipc	a1,0x7
    80000db4:	3b058593          	addi	a1,a1,944 # 80008160 <etext+0x160>
    80000db8:	00008517          	auipc	a0,0x8
    80000dbc:	d0850513          	addi	a0,a0,-760 # 80008ac0 <pid_lock>
    80000dc0:	00005097          	auipc	ra,0x5
    80000dc4:	3ec080e7          	jalr	1004(ra) # 800061ac <initlock>
  initlock(&wait_lock, "wait_lock");
    80000dc8:	00007597          	auipc	a1,0x7
    80000dcc:	3a058593          	addi	a1,a1,928 # 80008168 <etext+0x168>
    80000dd0:	00008517          	auipc	a0,0x8
    80000dd4:	d0850513          	addi	a0,a0,-760 # 80008ad8 <wait_lock>
    80000dd8:	00005097          	auipc	ra,0x5
    80000ddc:	3d4080e7          	jalr	980(ra) # 800061ac <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000de0:	00008497          	auipc	s1,0x8
    80000de4:	11048493          	addi	s1,s1,272 # 80008ef0 <proc>
      initlock(&p->lock, "proc");
    80000de8:	00007b17          	auipc	s6,0x7
    80000dec:	390b0b13          	addi	s6,s6,912 # 80008178 <etext+0x178>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000df0:	8aa6                	mv	s5,s1
    80000df2:	00007a17          	auipc	s4,0x7
    80000df6:	20ea0a13          	addi	s4,s4,526 # 80008000 <etext>
    80000dfa:	04000937          	lui	s2,0x4000
    80000dfe:	197d                	addi	s2,s2,-1
    80000e00:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e02:	0000e997          	auipc	s3,0xe
    80000e06:	aee98993          	addi	s3,s3,-1298 # 8000e8f0 <tickslock>
      initlock(&p->lock, "proc");
    80000e0a:	85da                	mv	a1,s6
    80000e0c:	8526                	mv	a0,s1
    80000e0e:	00005097          	auipc	ra,0x5
    80000e12:	39e080e7          	jalr	926(ra) # 800061ac <initlock>
      p->state = UNUSED;
    80000e16:	0004ae23          	sw	zero,28(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000e1a:	415487b3          	sub	a5,s1,s5
    80000e1e:	878d                	srai	a5,a5,0x3
    80000e20:	000a3703          	ld	a4,0(s4)
    80000e24:	02e787b3          	mul	a5,a5,a4
    80000e28:	2785                	addiw	a5,a5,1
    80000e2a:	00d7979b          	slliw	a5,a5,0xd
    80000e2e:	40f907b3          	sub	a5,s2,a5
    80000e32:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e34:	16848493          	addi	s1,s1,360
    80000e38:	fd3499e3          	bne	s1,s3,80000e0a <procinit+0x6e>
  }
}
    80000e3c:	70e2                	ld	ra,56(sp)
    80000e3e:	7442                	ld	s0,48(sp)
    80000e40:	74a2                	ld	s1,40(sp)
    80000e42:	7902                	ld	s2,32(sp)
    80000e44:	69e2                	ld	s3,24(sp)
    80000e46:	6a42                	ld	s4,16(sp)
    80000e48:	6aa2                	ld	s5,8(sp)
    80000e4a:	6b02                	ld	s6,0(sp)
    80000e4c:	6121                	addi	sp,sp,64
    80000e4e:	8082                	ret

0000000080000e50 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e50:	1141                	addi	sp,sp,-16
    80000e52:	e422                	sd	s0,8(sp)
    80000e54:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e56:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e58:	2501                	sext.w	a0,a0
    80000e5a:	6422                	ld	s0,8(sp)
    80000e5c:	0141                	addi	sp,sp,16
    80000e5e:	8082                	ret

0000000080000e60 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000e60:	1141                	addi	sp,sp,-16
    80000e62:	e422                	sd	s0,8(sp)
    80000e64:	0800                	addi	s0,sp,16
    80000e66:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e68:	2781                	sext.w	a5,a5
    80000e6a:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e6c:	00008517          	auipc	a0,0x8
    80000e70:	c8450513          	addi	a0,a0,-892 # 80008af0 <cpus>
    80000e74:	953e                	add	a0,a0,a5
    80000e76:	6422                	ld	s0,8(sp)
    80000e78:	0141                	addi	sp,sp,16
    80000e7a:	8082                	ret

0000000080000e7c <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000e7c:	1101                	addi	sp,sp,-32
    80000e7e:	ec06                	sd	ra,24(sp)
    80000e80:	e822                	sd	s0,16(sp)
    80000e82:	e426                	sd	s1,8(sp)
    80000e84:	1000                	addi	s0,sp,32
  push_off();
    80000e86:	00005097          	auipc	ra,0x5
    80000e8a:	36a080e7          	jalr	874(ra) # 800061f0 <push_off>
    80000e8e:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e90:	2781                	sext.w	a5,a5
    80000e92:	079e                	slli	a5,a5,0x7
    80000e94:	00008717          	auipc	a4,0x8
    80000e98:	c2c70713          	addi	a4,a4,-980 # 80008ac0 <pid_lock>
    80000e9c:	97ba                	add	a5,a5,a4
    80000e9e:	7b84                	ld	s1,48(a5)
  pop_off();
    80000ea0:	00005097          	auipc	ra,0x5
    80000ea4:	3f0080e7          	jalr	1008(ra) # 80006290 <pop_off>
  return p;
}
    80000ea8:	8526                	mv	a0,s1
    80000eaa:	60e2                	ld	ra,24(sp)
    80000eac:	6442                	ld	s0,16(sp)
    80000eae:	64a2                	ld	s1,8(sp)
    80000eb0:	6105                	addi	sp,sp,32
    80000eb2:	8082                	ret

0000000080000eb4 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000eb4:	1141                	addi	sp,sp,-16
    80000eb6:	e406                	sd	ra,8(sp)
    80000eb8:	e022                	sd	s0,0(sp)
    80000eba:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000ebc:	00000097          	auipc	ra,0x0
    80000ec0:	fc0080e7          	jalr	-64(ra) # 80000e7c <myproc>
    80000ec4:	00005097          	auipc	ra,0x5
    80000ec8:	42c080e7          	jalr	1068(ra) # 800062f0 <release>

  if (first) {
    80000ecc:	00008797          	auipc	a5,0x8
    80000ed0:	a447a783          	lw	a5,-1468(a5) # 80008910 <first.1679>
    80000ed4:	eb89                	bnez	a5,80000ee6 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000ed6:	00001097          	auipc	ra,0x1
    80000eda:	c8c080e7          	jalr	-884(ra) # 80001b62 <usertrapret>
}
    80000ede:	60a2                	ld	ra,8(sp)
    80000ee0:	6402                	ld	s0,0(sp)
    80000ee2:	0141                	addi	sp,sp,16
    80000ee4:	8082                	ret
    first = 0;
    80000ee6:	00008797          	auipc	a5,0x8
    80000eea:	a207a523          	sw	zero,-1494(a5) # 80008910 <first.1679>
    fsinit(ROOTDEV);
    80000eee:	4505                	li	a0,1
    80000ef0:	00002097          	auipc	ra,0x2
    80000ef4:	a88080e7          	jalr	-1400(ra) # 80002978 <fsinit>
    80000ef8:	bff9                	j	80000ed6 <forkret+0x22>

0000000080000efa <allocpid>:
{
    80000efa:	1101                	addi	sp,sp,-32
    80000efc:	ec06                	sd	ra,24(sp)
    80000efe:	e822                	sd	s0,16(sp)
    80000f00:	e426                	sd	s1,8(sp)
    80000f02:	e04a                	sd	s2,0(sp)
    80000f04:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000f06:	00008917          	auipc	s2,0x8
    80000f0a:	bba90913          	addi	s2,s2,-1094 # 80008ac0 <pid_lock>
    80000f0e:	854a                	mv	a0,s2
    80000f10:	00005097          	auipc	ra,0x5
    80000f14:	32c080e7          	jalr	812(ra) # 8000623c <acquire>
  pid = nextpid;
    80000f18:	00008797          	auipc	a5,0x8
    80000f1c:	9fc78793          	addi	a5,a5,-1540 # 80008914 <nextpid>
    80000f20:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000f22:	0014871b          	addiw	a4,s1,1
    80000f26:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000f28:	854a                	mv	a0,s2
    80000f2a:	00005097          	auipc	ra,0x5
    80000f2e:	3c6080e7          	jalr	966(ra) # 800062f0 <release>
}
    80000f32:	8526                	mv	a0,s1
    80000f34:	60e2                	ld	ra,24(sp)
    80000f36:	6442                	ld	s0,16(sp)
    80000f38:	64a2                	ld	s1,8(sp)
    80000f3a:	6902                	ld	s2,0(sp)
    80000f3c:	6105                	addi	sp,sp,32
    80000f3e:	8082                	ret

0000000080000f40 <proc_pagetable>:
{
    80000f40:	1101                	addi	sp,sp,-32
    80000f42:	ec06                	sd	ra,24(sp)
    80000f44:	e822                	sd	s0,16(sp)
    80000f46:	e426                	sd	s1,8(sp)
    80000f48:	e04a                	sd	s2,0(sp)
    80000f4a:	1000                	addi	s0,sp,32
    80000f4c:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f4e:	00000097          	auipc	ra,0x0
    80000f52:	8ac080e7          	jalr	-1876(ra) # 800007fa <uvmcreate>
    80000f56:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f58:	c121                	beqz	a0,80000f98 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f5a:	4729                	li	a4,10
    80000f5c:	00006697          	auipc	a3,0x6
    80000f60:	0a468693          	addi	a3,a3,164 # 80007000 <_trampoline>
    80000f64:	6605                	lui	a2,0x1
    80000f66:	040005b7          	lui	a1,0x4000
    80000f6a:	15fd                	addi	a1,a1,-1
    80000f6c:	05b2                	slli	a1,a1,0xc
    80000f6e:	fffff097          	auipc	ra,0xfffff
    80000f72:	602080e7          	jalr	1538(ra) # 80000570 <mappages>
    80000f76:	02054863          	bltz	a0,80000fa6 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f7a:	4719                	li	a4,6
    80000f7c:	05893683          	ld	a3,88(s2)
    80000f80:	6605                	lui	a2,0x1
    80000f82:	020005b7          	lui	a1,0x2000
    80000f86:	15fd                	addi	a1,a1,-1
    80000f88:	05b6                	slli	a1,a1,0xd
    80000f8a:	8526                	mv	a0,s1
    80000f8c:	fffff097          	auipc	ra,0xfffff
    80000f90:	5e4080e7          	jalr	1508(ra) # 80000570 <mappages>
    80000f94:	02054163          	bltz	a0,80000fb6 <proc_pagetable+0x76>
}
    80000f98:	8526                	mv	a0,s1
    80000f9a:	60e2                	ld	ra,24(sp)
    80000f9c:	6442                	ld	s0,16(sp)
    80000f9e:	64a2                	ld	s1,8(sp)
    80000fa0:	6902                	ld	s2,0(sp)
    80000fa2:	6105                	addi	sp,sp,32
    80000fa4:	8082                	ret
    uvmfree(pagetable, 0);
    80000fa6:	4581                	li	a1,0
    80000fa8:	8526                	mv	a0,s1
    80000faa:	00000097          	auipc	ra,0x0
    80000fae:	a54080e7          	jalr	-1452(ra) # 800009fe <uvmfree>
    return 0;
    80000fb2:	4481                	li	s1,0
    80000fb4:	b7d5                	j	80000f98 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fb6:	4681                	li	a3,0
    80000fb8:	4605                	li	a2,1
    80000fba:	040005b7          	lui	a1,0x4000
    80000fbe:	15fd                	addi	a1,a1,-1
    80000fc0:	05b2                	slli	a1,a1,0xc
    80000fc2:	8526                	mv	a0,s1
    80000fc4:	fffff097          	auipc	ra,0xfffff
    80000fc8:	772080e7          	jalr	1906(ra) # 80000736 <uvmunmap>
    uvmfree(pagetable, 0);
    80000fcc:	4581                	li	a1,0
    80000fce:	8526                	mv	a0,s1
    80000fd0:	00000097          	auipc	ra,0x0
    80000fd4:	a2e080e7          	jalr	-1490(ra) # 800009fe <uvmfree>
    return 0;
    80000fd8:	4481                	li	s1,0
    80000fda:	bf7d                	j	80000f98 <proc_pagetable+0x58>

0000000080000fdc <proc_freepagetable>:
{
    80000fdc:	1101                	addi	sp,sp,-32
    80000fde:	ec06                	sd	ra,24(sp)
    80000fe0:	e822                	sd	s0,16(sp)
    80000fe2:	e426                	sd	s1,8(sp)
    80000fe4:	e04a                	sd	s2,0(sp)
    80000fe6:	1000                	addi	s0,sp,32
    80000fe8:	84aa                	mv	s1,a0
    80000fea:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fec:	4681                	li	a3,0
    80000fee:	4605                	li	a2,1
    80000ff0:	040005b7          	lui	a1,0x4000
    80000ff4:	15fd                	addi	a1,a1,-1
    80000ff6:	05b2                	slli	a1,a1,0xc
    80000ff8:	fffff097          	auipc	ra,0xfffff
    80000ffc:	73e080e7          	jalr	1854(ra) # 80000736 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001000:	4681                	li	a3,0
    80001002:	4605                	li	a2,1
    80001004:	020005b7          	lui	a1,0x2000
    80001008:	15fd                	addi	a1,a1,-1
    8000100a:	05b6                	slli	a1,a1,0xd
    8000100c:	8526                	mv	a0,s1
    8000100e:	fffff097          	auipc	ra,0xfffff
    80001012:	728080e7          	jalr	1832(ra) # 80000736 <uvmunmap>
  uvmfree(pagetable, sz);
    80001016:	85ca                	mv	a1,s2
    80001018:	8526                	mv	a0,s1
    8000101a:	00000097          	auipc	ra,0x0
    8000101e:	9e4080e7          	jalr	-1564(ra) # 800009fe <uvmfree>
}
    80001022:	60e2                	ld	ra,24(sp)
    80001024:	6442                	ld	s0,16(sp)
    80001026:	64a2                	ld	s1,8(sp)
    80001028:	6902                	ld	s2,0(sp)
    8000102a:	6105                	addi	sp,sp,32
    8000102c:	8082                	ret

000000008000102e <freeproc>:
{
    8000102e:	1101                	addi	sp,sp,-32
    80001030:	ec06                	sd	ra,24(sp)
    80001032:	e822                	sd	s0,16(sp)
    80001034:	e426                	sd	s1,8(sp)
    80001036:	1000                	addi	s0,sp,32
    80001038:	84aa                	mv	s1,a0
  if(p->trapframe)
    8000103a:	6d28                	ld	a0,88(a0)
    8000103c:	c509                	beqz	a0,80001046 <freeproc+0x18>
    kfree((void*)p->trapframe);
    8000103e:	fffff097          	auipc	ra,0xfffff
    80001042:	fde080e7          	jalr	-34(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001046:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    8000104a:	68a8                	ld	a0,80(s1)
    8000104c:	c511                	beqz	a0,80001058 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    8000104e:	64ac                	ld	a1,72(s1)
    80001050:	00000097          	auipc	ra,0x0
    80001054:	f8c080e7          	jalr	-116(ra) # 80000fdc <proc_freepagetable>
  p->pagetable = 0;
    80001058:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    8000105c:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001060:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001064:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001068:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    8000106c:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001070:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001074:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001078:	0004ae23          	sw	zero,28(s1)
}
    8000107c:	60e2                	ld	ra,24(sp)
    8000107e:	6442                	ld	s0,16(sp)
    80001080:	64a2                	ld	s1,8(sp)
    80001082:	6105                	addi	sp,sp,32
    80001084:	8082                	ret

0000000080001086 <allocproc>:
{
    80001086:	1101                	addi	sp,sp,-32
    80001088:	ec06                	sd	ra,24(sp)
    8000108a:	e822                	sd	s0,16(sp)
    8000108c:	e426                	sd	s1,8(sp)
    8000108e:	e04a                	sd	s2,0(sp)
    80001090:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001092:	00008497          	auipc	s1,0x8
    80001096:	e5e48493          	addi	s1,s1,-418 # 80008ef0 <proc>
    8000109a:	0000e917          	auipc	s2,0xe
    8000109e:	85690913          	addi	s2,s2,-1962 # 8000e8f0 <tickslock>
    acquire(&p->lock);
    800010a2:	8526                	mv	a0,s1
    800010a4:	00005097          	auipc	ra,0x5
    800010a8:	198080e7          	jalr	408(ra) # 8000623c <acquire>
    if(p->state == UNUSED) {
    800010ac:	4cdc                	lw	a5,28(s1)
    800010ae:	cf81                	beqz	a5,800010c6 <allocproc+0x40>
      release(&p->lock);
    800010b0:	8526                	mv	a0,s1
    800010b2:	00005097          	auipc	ra,0x5
    800010b6:	23e080e7          	jalr	574(ra) # 800062f0 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800010ba:	16848493          	addi	s1,s1,360
    800010be:	ff2492e3          	bne	s1,s2,800010a2 <allocproc+0x1c>
  return 0;
    800010c2:	4481                	li	s1,0
    800010c4:	a889                	j	80001116 <allocproc+0x90>
  p->pid = allocpid();
    800010c6:	00000097          	auipc	ra,0x0
    800010ca:	e34080e7          	jalr	-460(ra) # 80000efa <allocpid>
    800010ce:	d888                	sw	a0,48(s1)
  p->state = USED;
    800010d0:	4785                	li	a5,1
    800010d2:	ccdc                	sw	a5,28(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800010d4:	fffff097          	auipc	ra,0xfffff
    800010d8:	044080e7          	jalr	68(ra) # 80000118 <kalloc>
    800010dc:	892a                	mv	s2,a0
    800010de:	eca8                	sd	a0,88(s1)
    800010e0:	c131                	beqz	a0,80001124 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800010e2:	8526                	mv	a0,s1
    800010e4:	00000097          	auipc	ra,0x0
    800010e8:	e5c080e7          	jalr	-420(ra) # 80000f40 <proc_pagetable>
    800010ec:	892a                	mv	s2,a0
    800010ee:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800010f0:	c531                	beqz	a0,8000113c <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800010f2:	07000613          	li	a2,112
    800010f6:	4581                	li	a1,0
    800010f8:	06048513          	addi	a0,s1,96
    800010fc:	fffff097          	auipc	ra,0xfffff
    80001100:	0a0080e7          	jalr	160(ra) # 8000019c <memset>
  p->context.ra = (uint64)forkret;
    80001104:	00000797          	auipc	a5,0x0
    80001108:	db078793          	addi	a5,a5,-592 # 80000eb4 <forkret>
    8000110c:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    8000110e:	60bc                	ld	a5,64(s1)
    80001110:	6705                	lui	a4,0x1
    80001112:	97ba                	add	a5,a5,a4
    80001114:	f4bc                	sd	a5,104(s1)
}
    80001116:	8526                	mv	a0,s1
    80001118:	60e2                	ld	ra,24(sp)
    8000111a:	6442                	ld	s0,16(sp)
    8000111c:	64a2                	ld	s1,8(sp)
    8000111e:	6902                	ld	s2,0(sp)
    80001120:	6105                	addi	sp,sp,32
    80001122:	8082                	ret
    freeproc(p);
    80001124:	8526                	mv	a0,s1
    80001126:	00000097          	auipc	ra,0x0
    8000112a:	f08080e7          	jalr	-248(ra) # 8000102e <freeproc>
    release(&p->lock);
    8000112e:	8526                	mv	a0,s1
    80001130:	00005097          	auipc	ra,0x5
    80001134:	1c0080e7          	jalr	448(ra) # 800062f0 <release>
    return 0;
    80001138:	84ca                	mv	s1,s2
    8000113a:	bff1                	j	80001116 <allocproc+0x90>
    freeproc(p);
    8000113c:	8526                	mv	a0,s1
    8000113e:	00000097          	auipc	ra,0x0
    80001142:	ef0080e7          	jalr	-272(ra) # 8000102e <freeproc>
    release(&p->lock);
    80001146:	8526                	mv	a0,s1
    80001148:	00005097          	auipc	ra,0x5
    8000114c:	1a8080e7          	jalr	424(ra) # 800062f0 <release>
    return 0;
    80001150:	84ca                	mv	s1,s2
    80001152:	b7d1                	j	80001116 <allocproc+0x90>

0000000080001154 <userinit>:
{
    80001154:	1101                	addi	sp,sp,-32
    80001156:	ec06                	sd	ra,24(sp)
    80001158:	e822                	sd	s0,16(sp)
    8000115a:	e426                	sd	s1,8(sp)
    8000115c:	1000                	addi	s0,sp,32
  p = allocproc();
    8000115e:	00000097          	auipc	ra,0x0
    80001162:	f28080e7          	jalr	-216(ra) # 80001086 <allocproc>
    80001166:	84aa                	mv	s1,a0
  initproc = p;
    80001168:	00008797          	auipc	a5,0x8
    8000116c:	90a7bc23          	sd	a0,-1768(a5) # 80008a80 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001170:	03400613          	li	a2,52
    80001174:	00007597          	auipc	a1,0x7
    80001178:	7ac58593          	addi	a1,a1,1964 # 80008920 <initcode>
    8000117c:	6928                	ld	a0,80(a0)
    8000117e:	fffff097          	auipc	ra,0xfffff
    80001182:	6aa080e7          	jalr	1706(ra) # 80000828 <uvmfirst>
  p->sz = PGSIZE;
    80001186:	6785                	lui	a5,0x1
    80001188:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    8000118a:	6cb8                	ld	a4,88(s1)
    8000118c:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001190:	6cb8                	ld	a4,88(s1)
    80001192:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001194:	4641                	li	a2,16
    80001196:	00007597          	auipc	a1,0x7
    8000119a:	fea58593          	addi	a1,a1,-22 # 80008180 <etext+0x180>
    8000119e:	15848513          	addi	a0,s1,344
    800011a2:	fffff097          	auipc	ra,0xfffff
    800011a6:	14c080e7          	jalr	332(ra) # 800002ee <safestrcpy>
  p->cwd = namei("/");
    800011aa:	00007517          	auipc	a0,0x7
    800011ae:	fe650513          	addi	a0,a0,-26 # 80008190 <etext+0x190>
    800011b2:	00002097          	auipc	ra,0x2
    800011b6:	1e8080e7          	jalr	488(ra) # 8000339a <namei>
    800011ba:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800011be:	478d                	li	a5,3
    800011c0:	ccdc                	sw	a5,28(s1)
  release(&p->lock);
    800011c2:	8526                	mv	a0,s1
    800011c4:	00005097          	auipc	ra,0x5
    800011c8:	12c080e7          	jalr	300(ra) # 800062f0 <release>
}
    800011cc:	60e2                	ld	ra,24(sp)
    800011ce:	6442                	ld	s0,16(sp)
    800011d0:	64a2                	ld	s1,8(sp)
    800011d2:	6105                	addi	sp,sp,32
    800011d4:	8082                	ret

00000000800011d6 <growproc>:
{
    800011d6:	1101                	addi	sp,sp,-32
    800011d8:	ec06                	sd	ra,24(sp)
    800011da:	e822                	sd	s0,16(sp)
    800011dc:	e426                	sd	s1,8(sp)
    800011de:	e04a                	sd	s2,0(sp)
    800011e0:	1000                	addi	s0,sp,32
    800011e2:	892a                	mv	s2,a0
  struct proc *p = myproc();
    800011e4:	00000097          	auipc	ra,0x0
    800011e8:	c98080e7          	jalr	-872(ra) # 80000e7c <myproc>
    800011ec:	84aa                	mv	s1,a0
  sz = p->sz;
    800011ee:	652c                	ld	a1,72(a0)
  if(n > 0){
    800011f0:	01204c63          	bgtz	s2,80001208 <growproc+0x32>
  } else if(n < 0){
    800011f4:	02094663          	bltz	s2,80001220 <growproc+0x4a>
  p->sz = sz;
    800011f8:	e4ac                	sd	a1,72(s1)
  return 0;
    800011fa:	4501                	li	a0,0
}
    800011fc:	60e2                	ld	ra,24(sp)
    800011fe:	6442                	ld	s0,16(sp)
    80001200:	64a2                	ld	s1,8(sp)
    80001202:	6902                	ld	s2,0(sp)
    80001204:	6105                	addi	sp,sp,32
    80001206:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001208:	4691                	li	a3,4
    8000120a:	00b90633          	add	a2,s2,a1
    8000120e:	6928                	ld	a0,80(a0)
    80001210:	fffff097          	auipc	ra,0xfffff
    80001214:	6d2080e7          	jalr	1746(ra) # 800008e2 <uvmalloc>
    80001218:	85aa                	mv	a1,a0
    8000121a:	fd79                	bnez	a0,800011f8 <growproc+0x22>
      return -1;
    8000121c:	557d                	li	a0,-1
    8000121e:	bff9                	j	800011fc <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001220:	00b90633          	add	a2,s2,a1
    80001224:	6928                	ld	a0,80(a0)
    80001226:	fffff097          	auipc	ra,0xfffff
    8000122a:	674080e7          	jalr	1652(ra) # 8000089a <uvmdealloc>
    8000122e:	85aa                	mv	a1,a0
    80001230:	b7e1                	j	800011f8 <growproc+0x22>

0000000080001232 <fork>:
{
    80001232:	7179                	addi	sp,sp,-48
    80001234:	f406                	sd	ra,40(sp)
    80001236:	f022                	sd	s0,32(sp)
    80001238:	ec26                	sd	s1,24(sp)
    8000123a:	e84a                	sd	s2,16(sp)
    8000123c:	e44e                	sd	s3,8(sp)
    8000123e:	e052                	sd	s4,0(sp)
    80001240:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001242:	00000097          	auipc	ra,0x0
    80001246:	c3a080e7          	jalr	-966(ra) # 80000e7c <myproc>
    8000124a:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    8000124c:	00000097          	auipc	ra,0x0
    80001250:	e3a080e7          	jalr	-454(ra) # 80001086 <allocproc>
    80001254:	10050f63          	beqz	a0,80001372 <fork+0x140>
    80001258:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000125a:	04893603          	ld	a2,72(s2)
    8000125e:	692c                	ld	a1,80(a0)
    80001260:	05093503          	ld	a0,80(s2)
    80001264:	fffff097          	auipc	ra,0xfffff
    80001268:	7d2080e7          	jalr	2002(ra) # 80000a36 <uvmcopy>
    8000126c:	04054663          	bltz	a0,800012b8 <fork+0x86>
  np->sz = p->sz;
    80001270:	04893783          	ld	a5,72(s2)
    80001274:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    80001278:	05893683          	ld	a3,88(s2)
    8000127c:	87b6                	mv	a5,a3
    8000127e:	0589b703          	ld	a4,88(s3)
    80001282:	12068693          	addi	a3,a3,288
    80001286:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    8000128a:	6788                	ld	a0,8(a5)
    8000128c:	6b8c                	ld	a1,16(a5)
    8000128e:	6f90                	ld	a2,24(a5)
    80001290:	01073023          	sd	a6,0(a4)
    80001294:	e708                	sd	a0,8(a4)
    80001296:	eb0c                	sd	a1,16(a4)
    80001298:	ef10                	sd	a2,24(a4)
    8000129a:	02078793          	addi	a5,a5,32
    8000129e:	02070713          	addi	a4,a4,32
    800012a2:	fed792e3          	bne	a5,a3,80001286 <fork+0x54>
  np->trapframe->a0 = 0;
    800012a6:	0589b783          	ld	a5,88(s3)
    800012aa:	0607b823          	sd	zero,112(a5)
    800012ae:	0d000493          	li	s1,208
  for(i = 0; i < NOFILE; i++)
    800012b2:	15000a13          	li	s4,336
    800012b6:	a03d                	j	800012e4 <fork+0xb2>
    freeproc(np);
    800012b8:	854e                	mv	a0,s3
    800012ba:	00000097          	auipc	ra,0x0
    800012be:	d74080e7          	jalr	-652(ra) # 8000102e <freeproc>
    release(&np->lock);
    800012c2:	854e                	mv	a0,s3
    800012c4:	00005097          	auipc	ra,0x5
    800012c8:	02c080e7          	jalr	44(ra) # 800062f0 <release>
    return -1;
    800012cc:	5a7d                	li	s4,-1
    800012ce:	a849                	j	80001360 <fork+0x12e>
      np->ofile[i] = filedup(p->ofile[i]);
    800012d0:	00002097          	auipc	ra,0x2
    800012d4:	760080e7          	jalr	1888(ra) # 80003a30 <filedup>
    800012d8:	009987b3          	add	a5,s3,s1
    800012dc:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    800012de:	04a1                	addi	s1,s1,8
    800012e0:	01448763          	beq	s1,s4,800012ee <fork+0xbc>
    if(p->ofile[i])
    800012e4:	009907b3          	add	a5,s2,s1
    800012e8:	6388                	ld	a0,0(a5)
    800012ea:	f17d                	bnez	a0,800012d0 <fork+0x9e>
    800012ec:	bfcd                	j	800012de <fork+0xac>
  np->cwd = idup(p->cwd);
    800012ee:	15093503          	ld	a0,336(s2)
    800012f2:	00002097          	auipc	ra,0x2
    800012f6:	8c4080e7          	jalr	-1852(ra) # 80002bb6 <idup>
    800012fa:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800012fe:	4641                	li	a2,16
    80001300:	15890593          	addi	a1,s2,344
    80001304:	15898513          	addi	a0,s3,344
    80001308:	fffff097          	auipc	ra,0xfffff
    8000130c:	fe6080e7          	jalr	-26(ra) # 800002ee <safestrcpy>
  pid = np->pid;
    80001310:	0309aa03          	lw	s4,48(s3)
  np->tracemask = p->tracemask;
    80001314:	01892783          	lw	a5,24(s2)
    80001318:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    8000131c:	854e                	mv	a0,s3
    8000131e:	00005097          	auipc	ra,0x5
    80001322:	fd2080e7          	jalr	-46(ra) # 800062f0 <release>
  acquire(&wait_lock);
    80001326:	00007497          	auipc	s1,0x7
    8000132a:	7b248493          	addi	s1,s1,1970 # 80008ad8 <wait_lock>
    8000132e:	8526                	mv	a0,s1
    80001330:	00005097          	auipc	ra,0x5
    80001334:	f0c080e7          	jalr	-244(ra) # 8000623c <acquire>
  np->parent = p;
    80001338:	0329bc23          	sd	s2,56(s3)
  release(&wait_lock);
    8000133c:	8526                	mv	a0,s1
    8000133e:	00005097          	auipc	ra,0x5
    80001342:	fb2080e7          	jalr	-78(ra) # 800062f0 <release>
  acquire(&np->lock);
    80001346:	854e                	mv	a0,s3
    80001348:	00005097          	auipc	ra,0x5
    8000134c:	ef4080e7          	jalr	-268(ra) # 8000623c <acquire>
  np->state = RUNNABLE;
    80001350:	478d                	li	a5,3
    80001352:	00f9ae23          	sw	a5,28(s3)
  release(&np->lock);
    80001356:	854e                	mv	a0,s3
    80001358:	00005097          	auipc	ra,0x5
    8000135c:	f98080e7          	jalr	-104(ra) # 800062f0 <release>
}
    80001360:	8552                	mv	a0,s4
    80001362:	70a2                	ld	ra,40(sp)
    80001364:	7402                	ld	s0,32(sp)
    80001366:	64e2                	ld	s1,24(sp)
    80001368:	6942                	ld	s2,16(sp)
    8000136a:	69a2                	ld	s3,8(sp)
    8000136c:	6a02                	ld	s4,0(sp)
    8000136e:	6145                	addi	sp,sp,48
    80001370:	8082                	ret
    return -1;
    80001372:	5a7d                	li	s4,-1
    80001374:	b7f5                	j	80001360 <fork+0x12e>

0000000080001376 <scheduler>:
{
    80001376:	7139                	addi	sp,sp,-64
    80001378:	fc06                	sd	ra,56(sp)
    8000137a:	f822                	sd	s0,48(sp)
    8000137c:	f426                	sd	s1,40(sp)
    8000137e:	f04a                	sd	s2,32(sp)
    80001380:	ec4e                	sd	s3,24(sp)
    80001382:	e852                	sd	s4,16(sp)
    80001384:	e456                	sd	s5,8(sp)
    80001386:	e05a                	sd	s6,0(sp)
    80001388:	0080                	addi	s0,sp,64
    8000138a:	8792                	mv	a5,tp
  int id = r_tp();
    8000138c:	2781                	sext.w	a5,a5
  c->proc = 0;
    8000138e:	00779a93          	slli	s5,a5,0x7
    80001392:	00007717          	auipc	a4,0x7
    80001396:	72e70713          	addi	a4,a4,1838 # 80008ac0 <pid_lock>
    8000139a:	9756                	add	a4,a4,s5
    8000139c:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800013a0:	00007717          	auipc	a4,0x7
    800013a4:	75870713          	addi	a4,a4,1880 # 80008af8 <cpus+0x8>
    800013a8:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800013aa:	498d                	li	s3,3
        p->state = RUNNING;
    800013ac:	4b11                	li	s6,4
        c->proc = p;
    800013ae:	079e                	slli	a5,a5,0x7
    800013b0:	00007a17          	auipc	s4,0x7
    800013b4:	710a0a13          	addi	s4,s4,1808 # 80008ac0 <pid_lock>
    800013b8:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800013ba:	0000d917          	auipc	s2,0xd
    800013be:	53690913          	addi	s2,s2,1334 # 8000e8f0 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013c2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013c6:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800013ca:	10079073          	csrw	sstatus,a5
    800013ce:	00008497          	auipc	s1,0x8
    800013d2:	b2248493          	addi	s1,s1,-1246 # 80008ef0 <proc>
    800013d6:	a03d                	j	80001404 <scheduler+0x8e>
        p->state = RUNNING;
    800013d8:	0164ae23          	sw	s6,28(s1)
        c->proc = p;
    800013dc:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800013e0:	06048593          	addi	a1,s1,96
    800013e4:	8556                	mv	a0,s5
    800013e6:	00000097          	auipc	ra,0x0
    800013ea:	6d2080e7          	jalr	1746(ra) # 80001ab8 <swtch>
        c->proc = 0;
    800013ee:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    800013f2:	8526                	mv	a0,s1
    800013f4:	00005097          	auipc	ra,0x5
    800013f8:	efc080e7          	jalr	-260(ra) # 800062f0 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800013fc:	16848493          	addi	s1,s1,360
    80001400:	fd2481e3          	beq	s1,s2,800013c2 <scheduler+0x4c>
      acquire(&p->lock);
    80001404:	8526                	mv	a0,s1
    80001406:	00005097          	auipc	ra,0x5
    8000140a:	e36080e7          	jalr	-458(ra) # 8000623c <acquire>
      if(p->state == RUNNABLE) {
    8000140e:	4cdc                	lw	a5,28(s1)
    80001410:	ff3791e3          	bne	a5,s3,800013f2 <scheduler+0x7c>
    80001414:	b7d1                	j	800013d8 <scheduler+0x62>

0000000080001416 <sched>:
{
    80001416:	7179                	addi	sp,sp,-48
    80001418:	f406                	sd	ra,40(sp)
    8000141a:	f022                	sd	s0,32(sp)
    8000141c:	ec26                	sd	s1,24(sp)
    8000141e:	e84a                	sd	s2,16(sp)
    80001420:	e44e                	sd	s3,8(sp)
    80001422:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001424:	00000097          	auipc	ra,0x0
    80001428:	a58080e7          	jalr	-1448(ra) # 80000e7c <myproc>
    8000142c:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    8000142e:	00005097          	auipc	ra,0x5
    80001432:	d94080e7          	jalr	-620(ra) # 800061c2 <holding>
    80001436:	c93d                	beqz	a0,800014ac <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001438:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000143a:	2781                	sext.w	a5,a5
    8000143c:	079e                	slli	a5,a5,0x7
    8000143e:	00007717          	auipc	a4,0x7
    80001442:	68270713          	addi	a4,a4,1666 # 80008ac0 <pid_lock>
    80001446:	97ba                	add	a5,a5,a4
    80001448:	0a87a703          	lw	a4,168(a5)
    8000144c:	4785                	li	a5,1
    8000144e:	06f71763          	bne	a4,a5,800014bc <sched+0xa6>
  if(p->state == RUNNING)
    80001452:	4cd8                	lw	a4,28(s1)
    80001454:	4791                	li	a5,4
    80001456:	06f70b63          	beq	a4,a5,800014cc <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000145a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000145e:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001460:	efb5                	bnez	a5,800014dc <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001462:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001464:	00007917          	auipc	s2,0x7
    80001468:	65c90913          	addi	s2,s2,1628 # 80008ac0 <pid_lock>
    8000146c:	2781                	sext.w	a5,a5
    8000146e:	079e                	slli	a5,a5,0x7
    80001470:	97ca                	add	a5,a5,s2
    80001472:	0ac7a983          	lw	s3,172(a5)
    80001476:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001478:	2781                	sext.w	a5,a5
    8000147a:	079e                	slli	a5,a5,0x7
    8000147c:	00007597          	auipc	a1,0x7
    80001480:	67c58593          	addi	a1,a1,1660 # 80008af8 <cpus+0x8>
    80001484:	95be                	add	a1,a1,a5
    80001486:	06048513          	addi	a0,s1,96
    8000148a:	00000097          	auipc	ra,0x0
    8000148e:	62e080e7          	jalr	1582(ra) # 80001ab8 <swtch>
    80001492:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001494:	2781                	sext.w	a5,a5
    80001496:	079e                	slli	a5,a5,0x7
    80001498:	97ca                	add	a5,a5,s2
    8000149a:	0b37a623          	sw	s3,172(a5)
}
    8000149e:	70a2                	ld	ra,40(sp)
    800014a0:	7402                	ld	s0,32(sp)
    800014a2:	64e2                	ld	s1,24(sp)
    800014a4:	6942                	ld	s2,16(sp)
    800014a6:	69a2                	ld	s3,8(sp)
    800014a8:	6145                	addi	sp,sp,48
    800014aa:	8082                	ret
    panic("sched p->lock");
    800014ac:	00007517          	auipc	a0,0x7
    800014b0:	cec50513          	addi	a0,a0,-788 # 80008198 <etext+0x198>
    800014b4:	00005097          	auipc	ra,0x5
    800014b8:	83e080e7          	jalr	-1986(ra) # 80005cf2 <panic>
    panic("sched locks");
    800014bc:	00007517          	auipc	a0,0x7
    800014c0:	cec50513          	addi	a0,a0,-788 # 800081a8 <etext+0x1a8>
    800014c4:	00005097          	auipc	ra,0x5
    800014c8:	82e080e7          	jalr	-2002(ra) # 80005cf2 <panic>
    panic("sched running");
    800014cc:	00007517          	auipc	a0,0x7
    800014d0:	cec50513          	addi	a0,a0,-788 # 800081b8 <etext+0x1b8>
    800014d4:	00005097          	auipc	ra,0x5
    800014d8:	81e080e7          	jalr	-2018(ra) # 80005cf2 <panic>
    panic("sched interruptible");
    800014dc:	00007517          	auipc	a0,0x7
    800014e0:	cec50513          	addi	a0,a0,-788 # 800081c8 <etext+0x1c8>
    800014e4:	00005097          	auipc	ra,0x5
    800014e8:	80e080e7          	jalr	-2034(ra) # 80005cf2 <panic>

00000000800014ec <yield>:
{
    800014ec:	1101                	addi	sp,sp,-32
    800014ee:	ec06                	sd	ra,24(sp)
    800014f0:	e822                	sd	s0,16(sp)
    800014f2:	e426                	sd	s1,8(sp)
    800014f4:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800014f6:	00000097          	auipc	ra,0x0
    800014fa:	986080e7          	jalr	-1658(ra) # 80000e7c <myproc>
    800014fe:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001500:	00005097          	auipc	ra,0x5
    80001504:	d3c080e7          	jalr	-708(ra) # 8000623c <acquire>
  p->state = RUNNABLE;
    80001508:	478d                	li	a5,3
    8000150a:	ccdc                	sw	a5,28(s1)
  sched();
    8000150c:	00000097          	auipc	ra,0x0
    80001510:	f0a080e7          	jalr	-246(ra) # 80001416 <sched>
  release(&p->lock);
    80001514:	8526                	mv	a0,s1
    80001516:	00005097          	auipc	ra,0x5
    8000151a:	dda080e7          	jalr	-550(ra) # 800062f0 <release>
}
    8000151e:	60e2                	ld	ra,24(sp)
    80001520:	6442                	ld	s0,16(sp)
    80001522:	64a2                	ld	s1,8(sp)
    80001524:	6105                	addi	sp,sp,32
    80001526:	8082                	ret

0000000080001528 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001528:	7179                	addi	sp,sp,-48
    8000152a:	f406                	sd	ra,40(sp)
    8000152c:	f022                	sd	s0,32(sp)
    8000152e:	ec26                	sd	s1,24(sp)
    80001530:	e84a                	sd	s2,16(sp)
    80001532:	e44e                	sd	s3,8(sp)
    80001534:	1800                	addi	s0,sp,48
    80001536:	89aa                	mv	s3,a0
    80001538:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000153a:	00000097          	auipc	ra,0x0
    8000153e:	942080e7          	jalr	-1726(ra) # 80000e7c <myproc>
    80001542:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001544:	00005097          	auipc	ra,0x5
    80001548:	cf8080e7          	jalr	-776(ra) # 8000623c <acquire>
  release(lk);
    8000154c:	854a                	mv	a0,s2
    8000154e:	00005097          	auipc	ra,0x5
    80001552:	da2080e7          	jalr	-606(ra) # 800062f0 <release>

  // Go to sleep.
  p->chan = chan;
    80001556:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000155a:	4789                	li	a5,2
    8000155c:	ccdc                	sw	a5,28(s1)

  sched();
    8000155e:	00000097          	auipc	ra,0x0
    80001562:	eb8080e7          	jalr	-328(ra) # 80001416 <sched>

  // Tidy up.
  p->chan = 0;
    80001566:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000156a:	8526                	mv	a0,s1
    8000156c:	00005097          	auipc	ra,0x5
    80001570:	d84080e7          	jalr	-636(ra) # 800062f0 <release>
  acquire(lk);
    80001574:	854a                	mv	a0,s2
    80001576:	00005097          	auipc	ra,0x5
    8000157a:	cc6080e7          	jalr	-826(ra) # 8000623c <acquire>
}
    8000157e:	70a2                	ld	ra,40(sp)
    80001580:	7402                	ld	s0,32(sp)
    80001582:	64e2                	ld	s1,24(sp)
    80001584:	6942                	ld	s2,16(sp)
    80001586:	69a2                	ld	s3,8(sp)
    80001588:	6145                	addi	sp,sp,48
    8000158a:	8082                	ret

000000008000158c <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    8000158c:	7139                	addi	sp,sp,-64
    8000158e:	fc06                	sd	ra,56(sp)
    80001590:	f822                	sd	s0,48(sp)
    80001592:	f426                	sd	s1,40(sp)
    80001594:	f04a                	sd	s2,32(sp)
    80001596:	ec4e                	sd	s3,24(sp)
    80001598:	e852                	sd	s4,16(sp)
    8000159a:	e456                	sd	s5,8(sp)
    8000159c:	0080                	addi	s0,sp,64
    8000159e:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800015a0:	00008497          	auipc	s1,0x8
    800015a4:	95048493          	addi	s1,s1,-1712 # 80008ef0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800015a8:	4989                	li	s3,2
        p->state = RUNNABLE;
    800015aa:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800015ac:	0000d917          	auipc	s2,0xd
    800015b0:	34490913          	addi	s2,s2,836 # 8000e8f0 <tickslock>
    800015b4:	a821                	j	800015cc <wakeup+0x40>
        p->state = RUNNABLE;
    800015b6:	0154ae23          	sw	s5,28(s1)
      }
      release(&p->lock);
    800015ba:	8526                	mv	a0,s1
    800015bc:	00005097          	auipc	ra,0x5
    800015c0:	d34080e7          	jalr	-716(ra) # 800062f0 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800015c4:	16848493          	addi	s1,s1,360
    800015c8:	03248463          	beq	s1,s2,800015f0 <wakeup+0x64>
    if(p != myproc()){
    800015cc:	00000097          	auipc	ra,0x0
    800015d0:	8b0080e7          	jalr	-1872(ra) # 80000e7c <myproc>
    800015d4:	fea488e3          	beq	s1,a0,800015c4 <wakeup+0x38>
      acquire(&p->lock);
    800015d8:	8526                	mv	a0,s1
    800015da:	00005097          	auipc	ra,0x5
    800015de:	c62080e7          	jalr	-926(ra) # 8000623c <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800015e2:	4cdc                	lw	a5,28(s1)
    800015e4:	fd379be3          	bne	a5,s3,800015ba <wakeup+0x2e>
    800015e8:	709c                	ld	a5,32(s1)
    800015ea:	fd4798e3          	bne	a5,s4,800015ba <wakeup+0x2e>
    800015ee:	b7e1                	j	800015b6 <wakeup+0x2a>
    }
  }
}
    800015f0:	70e2                	ld	ra,56(sp)
    800015f2:	7442                	ld	s0,48(sp)
    800015f4:	74a2                	ld	s1,40(sp)
    800015f6:	7902                	ld	s2,32(sp)
    800015f8:	69e2                	ld	s3,24(sp)
    800015fa:	6a42                	ld	s4,16(sp)
    800015fc:	6aa2                	ld	s5,8(sp)
    800015fe:	6121                	addi	sp,sp,64
    80001600:	8082                	ret

0000000080001602 <reparent>:
{
    80001602:	7179                	addi	sp,sp,-48
    80001604:	f406                	sd	ra,40(sp)
    80001606:	f022                	sd	s0,32(sp)
    80001608:	ec26                	sd	s1,24(sp)
    8000160a:	e84a                	sd	s2,16(sp)
    8000160c:	e44e                	sd	s3,8(sp)
    8000160e:	e052                	sd	s4,0(sp)
    80001610:	1800                	addi	s0,sp,48
    80001612:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001614:	00008497          	auipc	s1,0x8
    80001618:	8dc48493          	addi	s1,s1,-1828 # 80008ef0 <proc>
      pp->parent = initproc;
    8000161c:	00007a17          	auipc	s4,0x7
    80001620:	464a0a13          	addi	s4,s4,1124 # 80008a80 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001624:	0000d997          	auipc	s3,0xd
    80001628:	2cc98993          	addi	s3,s3,716 # 8000e8f0 <tickslock>
    8000162c:	a029                	j	80001636 <reparent+0x34>
    8000162e:	16848493          	addi	s1,s1,360
    80001632:	01348d63          	beq	s1,s3,8000164c <reparent+0x4a>
    if(pp->parent == p){
    80001636:	7c9c                	ld	a5,56(s1)
    80001638:	ff279be3          	bne	a5,s2,8000162e <reparent+0x2c>
      pp->parent = initproc;
    8000163c:	000a3503          	ld	a0,0(s4)
    80001640:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001642:	00000097          	auipc	ra,0x0
    80001646:	f4a080e7          	jalr	-182(ra) # 8000158c <wakeup>
    8000164a:	b7d5                	j	8000162e <reparent+0x2c>
}
    8000164c:	70a2                	ld	ra,40(sp)
    8000164e:	7402                	ld	s0,32(sp)
    80001650:	64e2                	ld	s1,24(sp)
    80001652:	6942                	ld	s2,16(sp)
    80001654:	69a2                	ld	s3,8(sp)
    80001656:	6a02                	ld	s4,0(sp)
    80001658:	6145                	addi	sp,sp,48
    8000165a:	8082                	ret

000000008000165c <exit>:
{
    8000165c:	7179                	addi	sp,sp,-48
    8000165e:	f406                	sd	ra,40(sp)
    80001660:	f022                	sd	s0,32(sp)
    80001662:	ec26                	sd	s1,24(sp)
    80001664:	e84a                	sd	s2,16(sp)
    80001666:	e44e                	sd	s3,8(sp)
    80001668:	e052                	sd	s4,0(sp)
    8000166a:	1800                	addi	s0,sp,48
    8000166c:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000166e:	00000097          	auipc	ra,0x0
    80001672:	80e080e7          	jalr	-2034(ra) # 80000e7c <myproc>
    80001676:	89aa                	mv	s3,a0
  if(p == initproc)
    80001678:	00007797          	auipc	a5,0x7
    8000167c:	4087b783          	ld	a5,1032(a5) # 80008a80 <initproc>
    80001680:	0d050493          	addi	s1,a0,208
    80001684:	15050913          	addi	s2,a0,336
    80001688:	02a79363          	bne	a5,a0,800016ae <exit+0x52>
    panic("init exiting");
    8000168c:	00007517          	auipc	a0,0x7
    80001690:	b5450513          	addi	a0,a0,-1196 # 800081e0 <etext+0x1e0>
    80001694:	00004097          	auipc	ra,0x4
    80001698:	65e080e7          	jalr	1630(ra) # 80005cf2 <panic>
      fileclose(f);
    8000169c:	00002097          	auipc	ra,0x2
    800016a0:	3e6080e7          	jalr	998(ra) # 80003a82 <fileclose>
      p->ofile[fd] = 0;
    800016a4:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800016a8:	04a1                	addi	s1,s1,8
    800016aa:	01248563          	beq	s1,s2,800016b4 <exit+0x58>
    if(p->ofile[fd]){
    800016ae:	6088                	ld	a0,0(s1)
    800016b0:	f575                	bnez	a0,8000169c <exit+0x40>
    800016b2:	bfdd                	j	800016a8 <exit+0x4c>
  begin_op();
    800016b4:	00002097          	auipc	ra,0x2
    800016b8:	f02080e7          	jalr	-254(ra) # 800035b6 <begin_op>
  iput(p->cwd);
    800016bc:	1509b503          	ld	a0,336(s3)
    800016c0:	00001097          	auipc	ra,0x1
    800016c4:	6ee080e7          	jalr	1774(ra) # 80002dae <iput>
  end_op();
    800016c8:	00002097          	auipc	ra,0x2
    800016cc:	f6e080e7          	jalr	-146(ra) # 80003636 <end_op>
  p->cwd = 0;
    800016d0:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800016d4:	00007497          	auipc	s1,0x7
    800016d8:	40448493          	addi	s1,s1,1028 # 80008ad8 <wait_lock>
    800016dc:	8526                	mv	a0,s1
    800016de:	00005097          	auipc	ra,0x5
    800016e2:	b5e080e7          	jalr	-1186(ra) # 8000623c <acquire>
  reparent(p);
    800016e6:	854e                	mv	a0,s3
    800016e8:	00000097          	auipc	ra,0x0
    800016ec:	f1a080e7          	jalr	-230(ra) # 80001602 <reparent>
  wakeup(p->parent);
    800016f0:	0389b503          	ld	a0,56(s3)
    800016f4:	00000097          	auipc	ra,0x0
    800016f8:	e98080e7          	jalr	-360(ra) # 8000158c <wakeup>
  acquire(&p->lock);
    800016fc:	854e                	mv	a0,s3
    800016fe:	00005097          	auipc	ra,0x5
    80001702:	b3e080e7          	jalr	-1218(ra) # 8000623c <acquire>
  p->xstate = status;
    80001706:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    8000170a:	4795                	li	a5,5
    8000170c:	00f9ae23          	sw	a5,28(s3)
  release(&wait_lock);
    80001710:	8526                	mv	a0,s1
    80001712:	00005097          	auipc	ra,0x5
    80001716:	bde080e7          	jalr	-1058(ra) # 800062f0 <release>
  sched();
    8000171a:	00000097          	auipc	ra,0x0
    8000171e:	cfc080e7          	jalr	-772(ra) # 80001416 <sched>
  panic("zombie exit");
    80001722:	00007517          	auipc	a0,0x7
    80001726:	ace50513          	addi	a0,a0,-1330 # 800081f0 <etext+0x1f0>
    8000172a:	00004097          	auipc	ra,0x4
    8000172e:	5c8080e7          	jalr	1480(ra) # 80005cf2 <panic>

0000000080001732 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001732:	7179                	addi	sp,sp,-48
    80001734:	f406                	sd	ra,40(sp)
    80001736:	f022                	sd	s0,32(sp)
    80001738:	ec26                	sd	s1,24(sp)
    8000173a:	e84a                	sd	s2,16(sp)
    8000173c:	e44e                	sd	s3,8(sp)
    8000173e:	1800                	addi	s0,sp,48
    80001740:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001742:	00007497          	auipc	s1,0x7
    80001746:	7ae48493          	addi	s1,s1,1966 # 80008ef0 <proc>
    8000174a:	0000d997          	auipc	s3,0xd
    8000174e:	1a698993          	addi	s3,s3,422 # 8000e8f0 <tickslock>
    acquire(&p->lock);
    80001752:	8526                	mv	a0,s1
    80001754:	00005097          	auipc	ra,0x5
    80001758:	ae8080e7          	jalr	-1304(ra) # 8000623c <acquire>
    if(p->pid == pid){
    8000175c:	589c                	lw	a5,48(s1)
    8000175e:	01278d63          	beq	a5,s2,80001778 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001762:	8526                	mv	a0,s1
    80001764:	00005097          	auipc	ra,0x5
    80001768:	b8c080e7          	jalr	-1140(ra) # 800062f0 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    8000176c:	16848493          	addi	s1,s1,360
    80001770:	ff3491e3          	bne	s1,s3,80001752 <kill+0x20>
  }
  return -1;
    80001774:	557d                	li	a0,-1
    80001776:	a829                	j	80001790 <kill+0x5e>
      p->killed = 1;
    80001778:	4785                	li	a5,1
    8000177a:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    8000177c:	4cd8                	lw	a4,28(s1)
    8000177e:	4789                	li	a5,2
    80001780:	00f70f63          	beq	a4,a5,8000179e <kill+0x6c>
      release(&p->lock);
    80001784:	8526                	mv	a0,s1
    80001786:	00005097          	auipc	ra,0x5
    8000178a:	b6a080e7          	jalr	-1174(ra) # 800062f0 <release>
      return 0;
    8000178e:	4501                	li	a0,0
}
    80001790:	70a2                	ld	ra,40(sp)
    80001792:	7402                	ld	s0,32(sp)
    80001794:	64e2                	ld	s1,24(sp)
    80001796:	6942                	ld	s2,16(sp)
    80001798:	69a2                	ld	s3,8(sp)
    8000179a:	6145                	addi	sp,sp,48
    8000179c:	8082                	ret
        p->state = RUNNABLE;
    8000179e:	478d                	li	a5,3
    800017a0:	ccdc                	sw	a5,28(s1)
    800017a2:	b7cd                	j	80001784 <kill+0x52>

00000000800017a4 <setkilled>:

void
setkilled(struct proc *p)
{
    800017a4:	1101                	addi	sp,sp,-32
    800017a6:	ec06                	sd	ra,24(sp)
    800017a8:	e822                	sd	s0,16(sp)
    800017aa:	e426                	sd	s1,8(sp)
    800017ac:	1000                	addi	s0,sp,32
    800017ae:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800017b0:	00005097          	auipc	ra,0x5
    800017b4:	a8c080e7          	jalr	-1396(ra) # 8000623c <acquire>
  p->killed = 1;
    800017b8:	4785                	li	a5,1
    800017ba:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    800017bc:	8526                	mv	a0,s1
    800017be:	00005097          	auipc	ra,0x5
    800017c2:	b32080e7          	jalr	-1230(ra) # 800062f0 <release>
}
    800017c6:	60e2                	ld	ra,24(sp)
    800017c8:	6442                	ld	s0,16(sp)
    800017ca:	64a2                	ld	s1,8(sp)
    800017cc:	6105                	addi	sp,sp,32
    800017ce:	8082                	ret

00000000800017d0 <killed>:

int
killed(struct proc *p)
{
    800017d0:	1101                	addi	sp,sp,-32
    800017d2:	ec06                	sd	ra,24(sp)
    800017d4:	e822                	sd	s0,16(sp)
    800017d6:	e426                	sd	s1,8(sp)
    800017d8:	e04a                	sd	s2,0(sp)
    800017da:	1000                	addi	s0,sp,32
    800017dc:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    800017de:	00005097          	auipc	ra,0x5
    800017e2:	a5e080e7          	jalr	-1442(ra) # 8000623c <acquire>
  k = p->killed;
    800017e6:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    800017ea:	8526                	mv	a0,s1
    800017ec:	00005097          	auipc	ra,0x5
    800017f0:	b04080e7          	jalr	-1276(ra) # 800062f0 <release>
  return k;
}
    800017f4:	854a                	mv	a0,s2
    800017f6:	60e2                	ld	ra,24(sp)
    800017f8:	6442                	ld	s0,16(sp)
    800017fa:	64a2                	ld	s1,8(sp)
    800017fc:	6902                	ld	s2,0(sp)
    800017fe:	6105                	addi	sp,sp,32
    80001800:	8082                	ret

0000000080001802 <wait>:
{
    80001802:	715d                	addi	sp,sp,-80
    80001804:	e486                	sd	ra,72(sp)
    80001806:	e0a2                	sd	s0,64(sp)
    80001808:	fc26                	sd	s1,56(sp)
    8000180a:	f84a                	sd	s2,48(sp)
    8000180c:	f44e                	sd	s3,40(sp)
    8000180e:	f052                	sd	s4,32(sp)
    80001810:	ec56                	sd	s5,24(sp)
    80001812:	e85a                	sd	s6,16(sp)
    80001814:	e45e                	sd	s7,8(sp)
    80001816:	e062                	sd	s8,0(sp)
    80001818:	0880                	addi	s0,sp,80
    8000181a:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    8000181c:	fffff097          	auipc	ra,0xfffff
    80001820:	660080e7          	jalr	1632(ra) # 80000e7c <myproc>
    80001824:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001826:	00007517          	auipc	a0,0x7
    8000182a:	2b250513          	addi	a0,a0,690 # 80008ad8 <wait_lock>
    8000182e:	00005097          	auipc	ra,0x5
    80001832:	a0e080e7          	jalr	-1522(ra) # 8000623c <acquire>
    havekids = 0;
    80001836:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    80001838:	4a15                	li	s4,5
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000183a:	0000d997          	auipc	s3,0xd
    8000183e:	0b698993          	addi	s3,s3,182 # 8000e8f0 <tickslock>
        havekids = 1;
    80001842:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001844:	00007c17          	auipc	s8,0x7
    80001848:	294c0c13          	addi	s8,s8,660 # 80008ad8 <wait_lock>
    havekids = 0;
    8000184c:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000184e:	00007497          	auipc	s1,0x7
    80001852:	6a248493          	addi	s1,s1,1698 # 80008ef0 <proc>
    80001856:	a0bd                	j	800018c4 <wait+0xc2>
          pid = pp->pid;
    80001858:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    8000185c:	000b0e63          	beqz	s6,80001878 <wait+0x76>
    80001860:	4691                	li	a3,4
    80001862:	02c48613          	addi	a2,s1,44
    80001866:	85da                	mv	a1,s6
    80001868:	05093503          	ld	a0,80(s2)
    8000186c:	fffff097          	auipc	ra,0xfffff
    80001870:	2ce080e7          	jalr	718(ra) # 80000b3a <copyout>
    80001874:	02054563          	bltz	a0,8000189e <wait+0x9c>
          freeproc(pp);
    80001878:	8526                	mv	a0,s1
    8000187a:	fffff097          	auipc	ra,0xfffff
    8000187e:	7b4080e7          	jalr	1972(ra) # 8000102e <freeproc>
          release(&pp->lock);
    80001882:	8526                	mv	a0,s1
    80001884:	00005097          	auipc	ra,0x5
    80001888:	a6c080e7          	jalr	-1428(ra) # 800062f0 <release>
          release(&wait_lock);
    8000188c:	00007517          	auipc	a0,0x7
    80001890:	24c50513          	addi	a0,a0,588 # 80008ad8 <wait_lock>
    80001894:	00005097          	auipc	ra,0x5
    80001898:	a5c080e7          	jalr	-1444(ra) # 800062f0 <release>
          return pid;
    8000189c:	a0b5                	j	80001908 <wait+0x106>
            release(&pp->lock);
    8000189e:	8526                	mv	a0,s1
    800018a0:	00005097          	auipc	ra,0x5
    800018a4:	a50080e7          	jalr	-1456(ra) # 800062f0 <release>
            release(&wait_lock);
    800018a8:	00007517          	auipc	a0,0x7
    800018ac:	23050513          	addi	a0,a0,560 # 80008ad8 <wait_lock>
    800018b0:	00005097          	auipc	ra,0x5
    800018b4:	a40080e7          	jalr	-1472(ra) # 800062f0 <release>
            return -1;
    800018b8:	59fd                	li	s3,-1
    800018ba:	a0b9                	j	80001908 <wait+0x106>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800018bc:	16848493          	addi	s1,s1,360
    800018c0:	03348463          	beq	s1,s3,800018e8 <wait+0xe6>
      if(pp->parent == p){
    800018c4:	7c9c                	ld	a5,56(s1)
    800018c6:	ff279be3          	bne	a5,s2,800018bc <wait+0xba>
        acquire(&pp->lock);
    800018ca:	8526                	mv	a0,s1
    800018cc:	00005097          	auipc	ra,0x5
    800018d0:	970080e7          	jalr	-1680(ra) # 8000623c <acquire>
        if(pp->state == ZOMBIE){
    800018d4:	4cdc                	lw	a5,28(s1)
    800018d6:	f94781e3          	beq	a5,s4,80001858 <wait+0x56>
        release(&pp->lock);
    800018da:	8526                	mv	a0,s1
    800018dc:	00005097          	auipc	ra,0x5
    800018e0:	a14080e7          	jalr	-1516(ra) # 800062f0 <release>
        havekids = 1;
    800018e4:	8756                	mv	a4,s5
    800018e6:	bfd9                	j	800018bc <wait+0xba>
    if(!havekids || killed(p)){
    800018e8:	c719                	beqz	a4,800018f6 <wait+0xf4>
    800018ea:	854a                	mv	a0,s2
    800018ec:	00000097          	auipc	ra,0x0
    800018f0:	ee4080e7          	jalr	-284(ra) # 800017d0 <killed>
    800018f4:	c51d                	beqz	a0,80001922 <wait+0x120>
      release(&wait_lock);
    800018f6:	00007517          	auipc	a0,0x7
    800018fa:	1e250513          	addi	a0,a0,482 # 80008ad8 <wait_lock>
    800018fe:	00005097          	auipc	ra,0x5
    80001902:	9f2080e7          	jalr	-1550(ra) # 800062f0 <release>
      return -1;
    80001906:	59fd                	li	s3,-1
}
    80001908:	854e                	mv	a0,s3
    8000190a:	60a6                	ld	ra,72(sp)
    8000190c:	6406                	ld	s0,64(sp)
    8000190e:	74e2                	ld	s1,56(sp)
    80001910:	7942                	ld	s2,48(sp)
    80001912:	79a2                	ld	s3,40(sp)
    80001914:	7a02                	ld	s4,32(sp)
    80001916:	6ae2                	ld	s5,24(sp)
    80001918:	6b42                	ld	s6,16(sp)
    8000191a:	6ba2                	ld	s7,8(sp)
    8000191c:	6c02                	ld	s8,0(sp)
    8000191e:	6161                	addi	sp,sp,80
    80001920:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001922:	85e2                	mv	a1,s8
    80001924:	854a                	mv	a0,s2
    80001926:	00000097          	auipc	ra,0x0
    8000192a:	c02080e7          	jalr	-1022(ra) # 80001528 <sleep>
    havekids = 0;
    8000192e:	bf39                	j	8000184c <wait+0x4a>

0000000080001930 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001930:	7179                	addi	sp,sp,-48
    80001932:	f406                	sd	ra,40(sp)
    80001934:	f022                	sd	s0,32(sp)
    80001936:	ec26                	sd	s1,24(sp)
    80001938:	e84a                	sd	s2,16(sp)
    8000193a:	e44e                	sd	s3,8(sp)
    8000193c:	e052                	sd	s4,0(sp)
    8000193e:	1800                	addi	s0,sp,48
    80001940:	84aa                	mv	s1,a0
    80001942:	892e                	mv	s2,a1
    80001944:	89b2                	mv	s3,a2
    80001946:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001948:	fffff097          	auipc	ra,0xfffff
    8000194c:	534080e7          	jalr	1332(ra) # 80000e7c <myproc>
  if(user_dst){
    80001950:	c08d                	beqz	s1,80001972 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001952:	86d2                	mv	a3,s4
    80001954:	864e                	mv	a2,s3
    80001956:	85ca                	mv	a1,s2
    80001958:	6928                	ld	a0,80(a0)
    8000195a:	fffff097          	auipc	ra,0xfffff
    8000195e:	1e0080e7          	jalr	480(ra) # 80000b3a <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001962:	70a2                	ld	ra,40(sp)
    80001964:	7402                	ld	s0,32(sp)
    80001966:	64e2                	ld	s1,24(sp)
    80001968:	6942                	ld	s2,16(sp)
    8000196a:	69a2                	ld	s3,8(sp)
    8000196c:	6a02                	ld	s4,0(sp)
    8000196e:	6145                	addi	sp,sp,48
    80001970:	8082                	ret
    memmove((char *)dst, src, len);
    80001972:	000a061b          	sext.w	a2,s4
    80001976:	85ce                	mv	a1,s3
    80001978:	854a                	mv	a0,s2
    8000197a:	fffff097          	auipc	ra,0xfffff
    8000197e:	882080e7          	jalr	-1918(ra) # 800001fc <memmove>
    return 0;
    80001982:	8526                	mv	a0,s1
    80001984:	bff9                	j	80001962 <either_copyout+0x32>

0000000080001986 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001986:	7179                	addi	sp,sp,-48
    80001988:	f406                	sd	ra,40(sp)
    8000198a:	f022                	sd	s0,32(sp)
    8000198c:	ec26                	sd	s1,24(sp)
    8000198e:	e84a                	sd	s2,16(sp)
    80001990:	e44e                	sd	s3,8(sp)
    80001992:	e052                	sd	s4,0(sp)
    80001994:	1800                	addi	s0,sp,48
    80001996:	892a                	mv	s2,a0
    80001998:	84ae                	mv	s1,a1
    8000199a:	89b2                	mv	s3,a2
    8000199c:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000199e:	fffff097          	auipc	ra,0xfffff
    800019a2:	4de080e7          	jalr	1246(ra) # 80000e7c <myproc>
  if(user_src){
    800019a6:	c08d                	beqz	s1,800019c8 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    800019a8:	86d2                	mv	a3,s4
    800019aa:	864e                	mv	a2,s3
    800019ac:	85ca                	mv	a1,s2
    800019ae:	6928                	ld	a0,80(a0)
    800019b0:	fffff097          	auipc	ra,0xfffff
    800019b4:	216080e7          	jalr	534(ra) # 80000bc6 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800019b8:	70a2                	ld	ra,40(sp)
    800019ba:	7402                	ld	s0,32(sp)
    800019bc:	64e2                	ld	s1,24(sp)
    800019be:	6942                	ld	s2,16(sp)
    800019c0:	69a2                	ld	s3,8(sp)
    800019c2:	6a02                	ld	s4,0(sp)
    800019c4:	6145                	addi	sp,sp,48
    800019c6:	8082                	ret
    memmove(dst, (char*)src, len);
    800019c8:	000a061b          	sext.w	a2,s4
    800019cc:	85ce                	mv	a1,s3
    800019ce:	854a                	mv	a0,s2
    800019d0:	fffff097          	auipc	ra,0xfffff
    800019d4:	82c080e7          	jalr	-2004(ra) # 800001fc <memmove>
    return 0;
    800019d8:	8526                	mv	a0,s1
    800019da:	bff9                	j	800019b8 <either_copyin+0x32>

00000000800019dc <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800019dc:	715d                	addi	sp,sp,-80
    800019de:	e486                	sd	ra,72(sp)
    800019e0:	e0a2                	sd	s0,64(sp)
    800019e2:	fc26                	sd	s1,56(sp)
    800019e4:	f84a                	sd	s2,48(sp)
    800019e6:	f44e                	sd	s3,40(sp)
    800019e8:	f052                	sd	s4,32(sp)
    800019ea:	ec56                	sd	s5,24(sp)
    800019ec:	e85a                	sd	s6,16(sp)
    800019ee:	e45e                	sd	s7,8(sp)
    800019f0:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800019f2:	00006517          	auipc	a0,0x6
    800019f6:	65650513          	addi	a0,a0,1622 # 80008048 <etext+0x48>
    800019fa:	00004097          	auipc	ra,0x4
    800019fe:	342080e7          	jalr	834(ra) # 80005d3c <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a02:	00007497          	auipc	s1,0x7
    80001a06:	64648493          	addi	s1,s1,1606 # 80009048 <proc+0x158>
    80001a0a:	0000d917          	auipc	s2,0xd
    80001a0e:	03e90913          	addi	s2,s2,62 # 8000ea48 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a12:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001a14:	00006997          	auipc	s3,0x6
    80001a18:	7ec98993          	addi	s3,s3,2028 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    80001a1c:	00006a97          	auipc	s5,0x6
    80001a20:	7eca8a93          	addi	s5,s5,2028 # 80008208 <etext+0x208>
    printf("\n");
    80001a24:	00006a17          	auipc	s4,0x6
    80001a28:	624a0a13          	addi	s4,s4,1572 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a2c:	00007b97          	auipc	s7,0x7
    80001a30:	81cb8b93          	addi	s7,s7,-2020 # 80008248 <states.1723>
    80001a34:	a00d                	j	80001a56 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001a36:	ed86a583          	lw	a1,-296(a3)
    80001a3a:	8556                	mv	a0,s5
    80001a3c:	00004097          	auipc	ra,0x4
    80001a40:	300080e7          	jalr	768(ra) # 80005d3c <printf>
    printf("\n");
    80001a44:	8552                	mv	a0,s4
    80001a46:	00004097          	auipc	ra,0x4
    80001a4a:	2f6080e7          	jalr	758(ra) # 80005d3c <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a4e:	16848493          	addi	s1,s1,360
    80001a52:	03248163          	beq	s1,s2,80001a74 <procdump+0x98>
    if(p->state == UNUSED)
    80001a56:	86a6                	mv	a3,s1
    80001a58:	ec44a783          	lw	a5,-316(s1)
    80001a5c:	dbed                	beqz	a5,80001a4e <procdump+0x72>
      state = "???";
    80001a5e:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a60:	fcfb6be3          	bltu	s6,a5,80001a36 <procdump+0x5a>
    80001a64:	1782                	slli	a5,a5,0x20
    80001a66:	9381                	srli	a5,a5,0x20
    80001a68:	078e                	slli	a5,a5,0x3
    80001a6a:	97de                	add	a5,a5,s7
    80001a6c:	6390                	ld	a2,0(a5)
    80001a6e:	f661                	bnez	a2,80001a36 <procdump+0x5a>
      state = "???";
    80001a70:	864e                	mv	a2,s3
    80001a72:	b7d1                	j	80001a36 <procdump+0x5a>
  }
}
    80001a74:	60a6                	ld	ra,72(sp)
    80001a76:	6406                	ld	s0,64(sp)
    80001a78:	74e2                	ld	s1,56(sp)
    80001a7a:	7942                	ld	s2,48(sp)
    80001a7c:	79a2                	ld	s3,40(sp)
    80001a7e:	7a02                	ld	s4,32(sp)
    80001a80:	6ae2                	ld	s5,24(sp)
    80001a82:	6b42                	ld	s6,16(sp)
    80001a84:	6ba2                	ld	s7,8(sp)
    80001a86:	6161                	addi	sp,sp,80
    80001a88:	8082                	ret

0000000080001a8a <get_nproc>:

uint64 
get_nproc()
{
    80001a8a:	1141                	addi	sp,sp,-16
    80001a8c:	e422                	sd	s0,8(sp)
    80001a8e:	0800                	addi	s0,sp,16
    uint64 count = 0;
    for (int i = 0; i < NPROC; i++) {
    80001a90:	00007797          	auipc	a5,0x7
    80001a94:	47c78793          	addi	a5,a5,1148 # 80008f0c <proc+0x1c>
    80001a98:	0000d697          	auipc	a3,0xd
    80001a9c:	e7468693          	addi	a3,a3,-396 # 8000e90c <bcache+0x4>
    uint64 count = 0;
    80001aa0:	4501                	li	a0,0
        if (proc[i].state != UNUSED)
    80001aa2:	4398                	lw	a4,0(a5)
            count++;
    80001aa4:	00e03733          	snez	a4,a4
    80001aa8:	953a                	add	a0,a0,a4
    for (int i = 0; i < NPROC; i++) {
    80001aaa:	16878793          	addi	a5,a5,360
    80001aae:	fed79ae3          	bne	a5,a3,80001aa2 <get_nproc+0x18>
    }
    return count;
}
    80001ab2:	6422                	ld	s0,8(sp)
    80001ab4:	0141                	addi	sp,sp,16
    80001ab6:	8082                	ret

0000000080001ab8 <swtch>:
    80001ab8:	00153023          	sd	ra,0(a0)
    80001abc:	00253423          	sd	sp,8(a0)
    80001ac0:	e900                	sd	s0,16(a0)
    80001ac2:	ed04                	sd	s1,24(a0)
    80001ac4:	03253023          	sd	s2,32(a0)
    80001ac8:	03353423          	sd	s3,40(a0)
    80001acc:	03453823          	sd	s4,48(a0)
    80001ad0:	03553c23          	sd	s5,56(a0)
    80001ad4:	05653023          	sd	s6,64(a0)
    80001ad8:	05753423          	sd	s7,72(a0)
    80001adc:	05853823          	sd	s8,80(a0)
    80001ae0:	05953c23          	sd	s9,88(a0)
    80001ae4:	07a53023          	sd	s10,96(a0)
    80001ae8:	07b53423          	sd	s11,104(a0)
    80001aec:	0005b083          	ld	ra,0(a1)
    80001af0:	0085b103          	ld	sp,8(a1)
    80001af4:	6980                	ld	s0,16(a1)
    80001af6:	6d84                	ld	s1,24(a1)
    80001af8:	0205b903          	ld	s2,32(a1)
    80001afc:	0285b983          	ld	s3,40(a1)
    80001b00:	0305ba03          	ld	s4,48(a1)
    80001b04:	0385ba83          	ld	s5,56(a1)
    80001b08:	0405bb03          	ld	s6,64(a1)
    80001b0c:	0485bb83          	ld	s7,72(a1)
    80001b10:	0505bc03          	ld	s8,80(a1)
    80001b14:	0585bc83          	ld	s9,88(a1)
    80001b18:	0605bd03          	ld	s10,96(a1)
    80001b1c:	0685bd83          	ld	s11,104(a1)
    80001b20:	8082                	ret

0000000080001b22 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001b22:	1141                	addi	sp,sp,-16
    80001b24:	e406                	sd	ra,8(sp)
    80001b26:	e022                	sd	s0,0(sp)
    80001b28:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001b2a:	00006597          	auipc	a1,0x6
    80001b2e:	74e58593          	addi	a1,a1,1870 # 80008278 <states.1723+0x30>
    80001b32:	0000d517          	auipc	a0,0xd
    80001b36:	dbe50513          	addi	a0,a0,-578 # 8000e8f0 <tickslock>
    80001b3a:	00004097          	auipc	ra,0x4
    80001b3e:	672080e7          	jalr	1650(ra) # 800061ac <initlock>
}
    80001b42:	60a2                	ld	ra,8(sp)
    80001b44:	6402                	ld	s0,0(sp)
    80001b46:	0141                	addi	sp,sp,16
    80001b48:	8082                	ret

0000000080001b4a <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001b4a:	1141                	addi	sp,sp,-16
    80001b4c:	e422                	sd	s0,8(sp)
    80001b4e:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b50:	00003797          	auipc	a5,0x3
    80001b54:	57078793          	addi	a5,a5,1392 # 800050c0 <kernelvec>
    80001b58:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001b5c:	6422                	ld	s0,8(sp)
    80001b5e:	0141                	addi	sp,sp,16
    80001b60:	8082                	ret

0000000080001b62 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001b62:	1141                	addi	sp,sp,-16
    80001b64:	e406                	sd	ra,8(sp)
    80001b66:	e022                	sd	s0,0(sp)
    80001b68:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001b6a:	fffff097          	auipc	ra,0xfffff
    80001b6e:	312080e7          	jalr	786(ra) # 80000e7c <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b72:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001b76:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b78:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001b7c:	00005617          	auipc	a2,0x5
    80001b80:	48460613          	addi	a2,a2,1156 # 80007000 <_trampoline>
    80001b84:	00005697          	auipc	a3,0x5
    80001b88:	47c68693          	addi	a3,a3,1148 # 80007000 <_trampoline>
    80001b8c:	8e91                	sub	a3,a3,a2
    80001b8e:	040007b7          	lui	a5,0x4000
    80001b92:	17fd                	addi	a5,a5,-1
    80001b94:	07b2                	slli	a5,a5,0xc
    80001b96:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b98:	10569073          	csrw	stvec,a3
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001b9c:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001b9e:	180026f3          	csrr	a3,satp
    80001ba2:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001ba4:	6d38                	ld	a4,88(a0)
    80001ba6:	6134                	ld	a3,64(a0)
    80001ba8:	6585                	lui	a1,0x1
    80001baa:	96ae                	add	a3,a3,a1
    80001bac:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001bae:	6d38                	ld	a4,88(a0)
    80001bb0:	00000697          	auipc	a3,0x0
    80001bb4:	13068693          	addi	a3,a3,304 # 80001ce0 <usertrap>
    80001bb8:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001bba:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001bbc:	8692                	mv	a3,tp
    80001bbe:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001bc0:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001bc4:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001bc8:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001bcc:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001bd0:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001bd2:	6f18                	ld	a4,24(a4)
    80001bd4:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001bd8:	6928                	ld	a0,80(a0)
    80001bda:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001bdc:	00005717          	auipc	a4,0x5
    80001be0:	4c070713          	addi	a4,a4,1216 # 8000709c <userret>
    80001be4:	8f11                	sub	a4,a4,a2
    80001be6:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001be8:	577d                	li	a4,-1
    80001bea:	177e                	slli	a4,a4,0x3f
    80001bec:	8d59                	or	a0,a0,a4
    80001bee:	9782                	jalr	a5
}
    80001bf0:	60a2                	ld	ra,8(sp)
    80001bf2:	6402                	ld	s0,0(sp)
    80001bf4:	0141                	addi	sp,sp,16
    80001bf6:	8082                	ret

0000000080001bf8 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001bf8:	1101                	addi	sp,sp,-32
    80001bfa:	ec06                	sd	ra,24(sp)
    80001bfc:	e822                	sd	s0,16(sp)
    80001bfe:	e426                	sd	s1,8(sp)
    80001c00:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001c02:	0000d497          	auipc	s1,0xd
    80001c06:	cee48493          	addi	s1,s1,-786 # 8000e8f0 <tickslock>
    80001c0a:	8526                	mv	a0,s1
    80001c0c:	00004097          	auipc	ra,0x4
    80001c10:	630080e7          	jalr	1584(ra) # 8000623c <acquire>
  ticks++;
    80001c14:	00007517          	auipc	a0,0x7
    80001c18:	e7450513          	addi	a0,a0,-396 # 80008a88 <ticks>
    80001c1c:	411c                	lw	a5,0(a0)
    80001c1e:	2785                	addiw	a5,a5,1
    80001c20:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001c22:	00000097          	auipc	ra,0x0
    80001c26:	96a080e7          	jalr	-1686(ra) # 8000158c <wakeup>
  release(&tickslock);
    80001c2a:	8526                	mv	a0,s1
    80001c2c:	00004097          	auipc	ra,0x4
    80001c30:	6c4080e7          	jalr	1732(ra) # 800062f0 <release>
}
    80001c34:	60e2                	ld	ra,24(sp)
    80001c36:	6442                	ld	s0,16(sp)
    80001c38:	64a2                	ld	s1,8(sp)
    80001c3a:	6105                	addi	sp,sp,32
    80001c3c:	8082                	ret

0000000080001c3e <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001c3e:	1101                	addi	sp,sp,-32
    80001c40:	ec06                	sd	ra,24(sp)
    80001c42:	e822                	sd	s0,16(sp)
    80001c44:	e426                	sd	s1,8(sp)
    80001c46:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c48:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001c4c:	00074d63          	bltz	a4,80001c66 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001c50:	57fd                	li	a5,-1
    80001c52:	17fe                	slli	a5,a5,0x3f
    80001c54:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001c56:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001c58:	06f70363          	beq	a4,a5,80001cbe <devintr+0x80>
  }
}
    80001c5c:	60e2                	ld	ra,24(sp)
    80001c5e:	6442                	ld	s0,16(sp)
    80001c60:	64a2                	ld	s1,8(sp)
    80001c62:	6105                	addi	sp,sp,32
    80001c64:	8082                	ret
     (scause & 0xff) == 9){
    80001c66:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001c6a:	46a5                	li	a3,9
    80001c6c:	fed792e3          	bne	a5,a3,80001c50 <devintr+0x12>
    int irq = plic_claim();
    80001c70:	00003097          	auipc	ra,0x3
    80001c74:	558080e7          	jalr	1368(ra) # 800051c8 <plic_claim>
    80001c78:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001c7a:	47a9                	li	a5,10
    80001c7c:	02f50763          	beq	a0,a5,80001caa <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001c80:	4785                	li	a5,1
    80001c82:	02f50963          	beq	a0,a5,80001cb4 <devintr+0x76>
    return 1;
    80001c86:	4505                	li	a0,1
    } else if(irq){
    80001c88:	d8f1                	beqz	s1,80001c5c <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001c8a:	85a6                	mv	a1,s1
    80001c8c:	00006517          	auipc	a0,0x6
    80001c90:	5f450513          	addi	a0,a0,1524 # 80008280 <states.1723+0x38>
    80001c94:	00004097          	auipc	ra,0x4
    80001c98:	0a8080e7          	jalr	168(ra) # 80005d3c <printf>
      plic_complete(irq);
    80001c9c:	8526                	mv	a0,s1
    80001c9e:	00003097          	auipc	ra,0x3
    80001ca2:	54e080e7          	jalr	1358(ra) # 800051ec <plic_complete>
    return 1;
    80001ca6:	4505                	li	a0,1
    80001ca8:	bf55                	j	80001c5c <devintr+0x1e>
      uartintr();
    80001caa:	00004097          	auipc	ra,0x4
    80001cae:	4b2080e7          	jalr	1202(ra) # 8000615c <uartintr>
    80001cb2:	b7ed                	j	80001c9c <devintr+0x5e>
      virtio_disk_intr();
    80001cb4:	00004097          	auipc	ra,0x4
    80001cb8:	a62080e7          	jalr	-1438(ra) # 80005716 <virtio_disk_intr>
    80001cbc:	b7c5                	j	80001c9c <devintr+0x5e>
    if(cpuid() == 0){
    80001cbe:	fffff097          	auipc	ra,0xfffff
    80001cc2:	192080e7          	jalr	402(ra) # 80000e50 <cpuid>
    80001cc6:	c901                	beqz	a0,80001cd6 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001cc8:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001ccc:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001cce:	14479073          	csrw	sip,a5
    return 2;
    80001cd2:	4509                	li	a0,2
    80001cd4:	b761                	j	80001c5c <devintr+0x1e>
      clockintr();
    80001cd6:	00000097          	auipc	ra,0x0
    80001cda:	f22080e7          	jalr	-222(ra) # 80001bf8 <clockintr>
    80001cde:	b7ed                	j	80001cc8 <devintr+0x8a>

0000000080001ce0 <usertrap>:
{
    80001ce0:	1101                	addi	sp,sp,-32
    80001ce2:	ec06                	sd	ra,24(sp)
    80001ce4:	e822                	sd	s0,16(sp)
    80001ce6:	e426                	sd	s1,8(sp)
    80001ce8:	e04a                	sd	s2,0(sp)
    80001cea:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cec:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001cf0:	1007f793          	andi	a5,a5,256
    80001cf4:	e3b1                	bnez	a5,80001d38 <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001cf6:	00003797          	auipc	a5,0x3
    80001cfa:	3ca78793          	addi	a5,a5,970 # 800050c0 <kernelvec>
    80001cfe:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001d02:	fffff097          	auipc	ra,0xfffff
    80001d06:	17a080e7          	jalr	378(ra) # 80000e7c <myproc>
    80001d0a:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001d0c:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d0e:	14102773          	csrr	a4,sepc
    80001d12:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d14:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001d18:	47a1                	li	a5,8
    80001d1a:	02f70763          	beq	a4,a5,80001d48 <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    80001d1e:	00000097          	auipc	ra,0x0
    80001d22:	f20080e7          	jalr	-224(ra) # 80001c3e <devintr>
    80001d26:	892a                	mv	s2,a0
    80001d28:	c151                	beqz	a0,80001dac <usertrap+0xcc>
  if(killed(p))
    80001d2a:	8526                	mv	a0,s1
    80001d2c:	00000097          	auipc	ra,0x0
    80001d30:	aa4080e7          	jalr	-1372(ra) # 800017d0 <killed>
    80001d34:	c929                	beqz	a0,80001d86 <usertrap+0xa6>
    80001d36:	a099                	j	80001d7c <usertrap+0x9c>
    panic("usertrap: not from user mode");
    80001d38:	00006517          	auipc	a0,0x6
    80001d3c:	56850513          	addi	a0,a0,1384 # 800082a0 <states.1723+0x58>
    80001d40:	00004097          	auipc	ra,0x4
    80001d44:	fb2080e7          	jalr	-78(ra) # 80005cf2 <panic>
    if(killed(p))
    80001d48:	00000097          	auipc	ra,0x0
    80001d4c:	a88080e7          	jalr	-1400(ra) # 800017d0 <killed>
    80001d50:	e921                	bnez	a0,80001da0 <usertrap+0xc0>
    p->trapframe->epc += 4;
    80001d52:	6cb8                	ld	a4,88(s1)
    80001d54:	6f1c                	ld	a5,24(a4)
    80001d56:	0791                	addi	a5,a5,4
    80001d58:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d5a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d5e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d62:	10079073          	csrw	sstatus,a5
    syscall();
    80001d66:	00000097          	auipc	ra,0x0
    80001d6a:	2d4080e7          	jalr	724(ra) # 8000203a <syscall>
  if(killed(p))
    80001d6e:	8526                	mv	a0,s1
    80001d70:	00000097          	auipc	ra,0x0
    80001d74:	a60080e7          	jalr	-1440(ra) # 800017d0 <killed>
    80001d78:	c911                	beqz	a0,80001d8c <usertrap+0xac>
    80001d7a:	4901                	li	s2,0
    exit(-1);
    80001d7c:	557d                	li	a0,-1
    80001d7e:	00000097          	auipc	ra,0x0
    80001d82:	8de080e7          	jalr	-1826(ra) # 8000165c <exit>
  if(which_dev == 2)
    80001d86:	4789                	li	a5,2
    80001d88:	04f90f63          	beq	s2,a5,80001de6 <usertrap+0x106>
  usertrapret();
    80001d8c:	00000097          	auipc	ra,0x0
    80001d90:	dd6080e7          	jalr	-554(ra) # 80001b62 <usertrapret>
}
    80001d94:	60e2                	ld	ra,24(sp)
    80001d96:	6442                	ld	s0,16(sp)
    80001d98:	64a2                	ld	s1,8(sp)
    80001d9a:	6902                	ld	s2,0(sp)
    80001d9c:	6105                	addi	sp,sp,32
    80001d9e:	8082                	ret
      exit(-1);
    80001da0:	557d                	li	a0,-1
    80001da2:	00000097          	auipc	ra,0x0
    80001da6:	8ba080e7          	jalr	-1862(ra) # 8000165c <exit>
    80001daa:	b765                	j	80001d52 <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001dac:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001db0:	5890                	lw	a2,48(s1)
    80001db2:	00006517          	auipc	a0,0x6
    80001db6:	50e50513          	addi	a0,a0,1294 # 800082c0 <states.1723+0x78>
    80001dba:	00004097          	auipc	ra,0x4
    80001dbe:	f82080e7          	jalr	-126(ra) # 80005d3c <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001dc2:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001dc6:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001dca:	00006517          	auipc	a0,0x6
    80001dce:	52650513          	addi	a0,a0,1318 # 800082f0 <states.1723+0xa8>
    80001dd2:	00004097          	auipc	ra,0x4
    80001dd6:	f6a080e7          	jalr	-150(ra) # 80005d3c <printf>
    setkilled(p);
    80001dda:	8526                	mv	a0,s1
    80001ddc:	00000097          	auipc	ra,0x0
    80001de0:	9c8080e7          	jalr	-1592(ra) # 800017a4 <setkilled>
    80001de4:	b769                	j	80001d6e <usertrap+0x8e>
    yield();
    80001de6:	fffff097          	auipc	ra,0xfffff
    80001dea:	706080e7          	jalr	1798(ra) # 800014ec <yield>
    80001dee:	bf79                	j	80001d8c <usertrap+0xac>

0000000080001df0 <kerneltrap>:
{
    80001df0:	7179                	addi	sp,sp,-48
    80001df2:	f406                	sd	ra,40(sp)
    80001df4:	f022                	sd	s0,32(sp)
    80001df6:	ec26                	sd	s1,24(sp)
    80001df8:	e84a                	sd	s2,16(sp)
    80001dfa:	e44e                	sd	s3,8(sp)
    80001dfc:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001dfe:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e02:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e06:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001e0a:	1004f793          	andi	a5,s1,256
    80001e0e:	cb85                	beqz	a5,80001e3e <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e10:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e14:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001e16:	ef85                	bnez	a5,80001e4e <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001e18:	00000097          	auipc	ra,0x0
    80001e1c:	e26080e7          	jalr	-474(ra) # 80001c3e <devintr>
    80001e20:	cd1d                	beqz	a0,80001e5e <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e22:	4789                	li	a5,2
    80001e24:	06f50a63          	beq	a0,a5,80001e98 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001e28:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e2c:	10049073          	csrw	sstatus,s1
}
    80001e30:	70a2                	ld	ra,40(sp)
    80001e32:	7402                	ld	s0,32(sp)
    80001e34:	64e2                	ld	s1,24(sp)
    80001e36:	6942                	ld	s2,16(sp)
    80001e38:	69a2                	ld	s3,8(sp)
    80001e3a:	6145                	addi	sp,sp,48
    80001e3c:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001e3e:	00006517          	auipc	a0,0x6
    80001e42:	4d250513          	addi	a0,a0,1234 # 80008310 <states.1723+0xc8>
    80001e46:	00004097          	auipc	ra,0x4
    80001e4a:	eac080e7          	jalr	-340(ra) # 80005cf2 <panic>
    panic("kerneltrap: interrupts enabled");
    80001e4e:	00006517          	auipc	a0,0x6
    80001e52:	4ea50513          	addi	a0,a0,1258 # 80008338 <states.1723+0xf0>
    80001e56:	00004097          	auipc	ra,0x4
    80001e5a:	e9c080e7          	jalr	-356(ra) # 80005cf2 <panic>
    printf("scause %p\n", scause);
    80001e5e:	85ce                	mv	a1,s3
    80001e60:	00006517          	auipc	a0,0x6
    80001e64:	4f850513          	addi	a0,a0,1272 # 80008358 <states.1723+0x110>
    80001e68:	00004097          	auipc	ra,0x4
    80001e6c:	ed4080e7          	jalr	-300(ra) # 80005d3c <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e70:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e74:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e78:	00006517          	auipc	a0,0x6
    80001e7c:	4f050513          	addi	a0,a0,1264 # 80008368 <states.1723+0x120>
    80001e80:	00004097          	auipc	ra,0x4
    80001e84:	ebc080e7          	jalr	-324(ra) # 80005d3c <printf>
    panic("kerneltrap");
    80001e88:	00006517          	auipc	a0,0x6
    80001e8c:	4f850513          	addi	a0,a0,1272 # 80008380 <states.1723+0x138>
    80001e90:	00004097          	auipc	ra,0x4
    80001e94:	e62080e7          	jalr	-414(ra) # 80005cf2 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e98:	fffff097          	auipc	ra,0xfffff
    80001e9c:	fe4080e7          	jalr	-28(ra) # 80000e7c <myproc>
    80001ea0:	d541                	beqz	a0,80001e28 <kerneltrap+0x38>
    80001ea2:	fffff097          	auipc	ra,0xfffff
    80001ea6:	fda080e7          	jalr	-38(ra) # 80000e7c <myproc>
    80001eaa:	4d58                	lw	a4,28(a0)
    80001eac:	4791                	li	a5,4
    80001eae:	f6f71de3          	bne	a4,a5,80001e28 <kerneltrap+0x38>
    yield();
    80001eb2:	fffff097          	auipc	ra,0xfffff
    80001eb6:	63a080e7          	jalr	1594(ra) # 800014ec <yield>
    80001eba:	b7bd                	j	80001e28 <kerneltrap+0x38>

0000000080001ebc <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001ebc:	1101                	addi	sp,sp,-32
    80001ebe:	ec06                	sd	ra,24(sp)
    80001ec0:	e822                	sd	s0,16(sp)
    80001ec2:	e426                	sd	s1,8(sp)
    80001ec4:	1000                	addi	s0,sp,32
    80001ec6:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001ec8:	fffff097          	auipc	ra,0xfffff
    80001ecc:	fb4080e7          	jalr	-76(ra) # 80000e7c <myproc>
  switch (n) {
    80001ed0:	4795                	li	a5,5
    80001ed2:	0497e163          	bltu	a5,s1,80001f14 <argraw+0x58>
    80001ed6:	048a                	slli	s1,s1,0x2
    80001ed8:	00006717          	auipc	a4,0x6
    80001edc:	5a870713          	addi	a4,a4,1448 # 80008480 <states.1723+0x238>
    80001ee0:	94ba                	add	s1,s1,a4
    80001ee2:	409c                	lw	a5,0(s1)
    80001ee4:	97ba                	add	a5,a5,a4
    80001ee6:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001ee8:	6d3c                	ld	a5,88(a0)
    80001eea:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001eec:	60e2                	ld	ra,24(sp)
    80001eee:	6442                	ld	s0,16(sp)
    80001ef0:	64a2                	ld	s1,8(sp)
    80001ef2:	6105                	addi	sp,sp,32
    80001ef4:	8082                	ret
    return p->trapframe->a1;
    80001ef6:	6d3c                	ld	a5,88(a0)
    80001ef8:	7fa8                	ld	a0,120(a5)
    80001efa:	bfcd                	j	80001eec <argraw+0x30>
    return p->trapframe->a2;
    80001efc:	6d3c                	ld	a5,88(a0)
    80001efe:	63c8                	ld	a0,128(a5)
    80001f00:	b7f5                	j	80001eec <argraw+0x30>
    return p->trapframe->a3;
    80001f02:	6d3c                	ld	a5,88(a0)
    80001f04:	67c8                	ld	a0,136(a5)
    80001f06:	b7dd                	j	80001eec <argraw+0x30>
    return p->trapframe->a4;
    80001f08:	6d3c                	ld	a5,88(a0)
    80001f0a:	6bc8                	ld	a0,144(a5)
    80001f0c:	b7c5                	j	80001eec <argraw+0x30>
    return p->trapframe->a5;
    80001f0e:	6d3c                	ld	a5,88(a0)
    80001f10:	6fc8                	ld	a0,152(a5)
    80001f12:	bfe9                	j	80001eec <argraw+0x30>
  panic("argraw");
    80001f14:	00006517          	auipc	a0,0x6
    80001f18:	47c50513          	addi	a0,a0,1148 # 80008390 <states.1723+0x148>
    80001f1c:	00004097          	auipc	ra,0x4
    80001f20:	dd6080e7          	jalr	-554(ra) # 80005cf2 <panic>

0000000080001f24 <fetchaddr>:
{
    80001f24:	1101                	addi	sp,sp,-32
    80001f26:	ec06                	sd	ra,24(sp)
    80001f28:	e822                	sd	s0,16(sp)
    80001f2a:	e426                	sd	s1,8(sp)
    80001f2c:	e04a                	sd	s2,0(sp)
    80001f2e:	1000                	addi	s0,sp,32
    80001f30:	84aa                	mv	s1,a0
    80001f32:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001f34:	fffff097          	auipc	ra,0xfffff
    80001f38:	f48080e7          	jalr	-184(ra) # 80000e7c <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001f3c:	653c                	ld	a5,72(a0)
    80001f3e:	02f4f863          	bgeu	s1,a5,80001f6e <fetchaddr+0x4a>
    80001f42:	00848713          	addi	a4,s1,8
    80001f46:	02e7e663          	bltu	a5,a4,80001f72 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001f4a:	46a1                	li	a3,8
    80001f4c:	8626                	mv	a2,s1
    80001f4e:	85ca                	mv	a1,s2
    80001f50:	6928                	ld	a0,80(a0)
    80001f52:	fffff097          	auipc	ra,0xfffff
    80001f56:	c74080e7          	jalr	-908(ra) # 80000bc6 <copyin>
    80001f5a:	00a03533          	snez	a0,a0
    80001f5e:	40a00533          	neg	a0,a0
}
    80001f62:	60e2                	ld	ra,24(sp)
    80001f64:	6442                	ld	s0,16(sp)
    80001f66:	64a2                	ld	s1,8(sp)
    80001f68:	6902                	ld	s2,0(sp)
    80001f6a:	6105                	addi	sp,sp,32
    80001f6c:	8082                	ret
    return -1;
    80001f6e:	557d                	li	a0,-1
    80001f70:	bfcd                	j	80001f62 <fetchaddr+0x3e>
    80001f72:	557d                	li	a0,-1
    80001f74:	b7fd                	j	80001f62 <fetchaddr+0x3e>

0000000080001f76 <fetchstr>:
{
    80001f76:	7179                	addi	sp,sp,-48
    80001f78:	f406                	sd	ra,40(sp)
    80001f7a:	f022                	sd	s0,32(sp)
    80001f7c:	ec26                	sd	s1,24(sp)
    80001f7e:	e84a                	sd	s2,16(sp)
    80001f80:	e44e                	sd	s3,8(sp)
    80001f82:	1800                	addi	s0,sp,48
    80001f84:	892a                	mv	s2,a0
    80001f86:	84ae                	mv	s1,a1
    80001f88:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001f8a:	fffff097          	auipc	ra,0xfffff
    80001f8e:	ef2080e7          	jalr	-270(ra) # 80000e7c <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001f92:	86ce                	mv	a3,s3
    80001f94:	864a                	mv	a2,s2
    80001f96:	85a6                	mv	a1,s1
    80001f98:	6928                	ld	a0,80(a0)
    80001f9a:	fffff097          	auipc	ra,0xfffff
    80001f9e:	cb8080e7          	jalr	-840(ra) # 80000c52 <copyinstr>
    80001fa2:	00054e63          	bltz	a0,80001fbe <fetchstr+0x48>
  return strlen(buf);
    80001fa6:	8526                	mv	a0,s1
    80001fa8:	ffffe097          	auipc	ra,0xffffe
    80001fac:	378080e7          	jalr	888(ra) # 80000320 <strlen>
}
    80001fb0:	70a2                	ld	ra,40(sp)
    80001fb2:	7402                	ld	s0,32(sp)
    80001fb4:	64e2                	ld	s1,24(sp)
    80001fb6:	6942                	ld	s2,16(sp)
    80001fb8:	69a2                	ld	s3,8(sp)
    80001fba:	6145                	addi	sp,sp,48
    80001fbc:	8082                	ret
    return -1;
    80001fbe:	557d                	li	a0,-1
    80001fc0:	bfc5                	j	80001fb0 <fetchstr+0x3a>

0000000080001fc2 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80001fc2:	1101                	addi	sp,sp,-32
    80001fc4:	ec06                	sd	ra,24(sp)
    80001fc6:	e822                	sd	s0,16(sp)
    80001fc8:	e426                	sd	s1,8(sp)
    80001fca:	1000                	addi	s0,sp,32
    80001fcc:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001fce:	00000097          	auipc	ra,0x0
    80001fd2:	eee080e7          	jalr	-274(ra) # 80001ebc <argraw>
    80001fd6:	c088                	sw	a0,0(s1)
}
    80001fd8:	60e2                	ld	ra,24(sp)
    80001fda:	6442                	ld	s0,16(sp)
    80001fdc:	64a2                	ld	s1,8(sp)
    80001fde:	6105                	addi	sp,sp,32
    80001fe0:	8082                	ret

0000000080001fe2 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80001fe2:	1101                	addi	sp,sp,-32
    80001fe4:	ec06                	sd	ra,24(sp)
    80001fe6:	e822                	sd	s0,16(sp)
    80001fe8:	e426                	sd	s1,8(sp)
    80001fea:	1000                	addi	s0,sp,32
    80001fec:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001fee:	00000097          	auipc	ra,0x0
    80001ff2:	ece080e7          	jalr	-306(ra) # 80001ebc <argraw>
    80001ff6:	e088                	sd	a0,0(s1)
}
    80001ff8:	60e2                	ld	ra,24(sp)
    80001ffa:	6442                	ld	s0,16(sp)
    80001ffc:	64a2                	ld	s1,8(sp)
    80001ffe:	6105                	addi	sp,sp,32
    80002000:	8082                	ret

0000000080002002 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002002:	7179                	addi	sp,sp,-48
    80002004:	f406                	sd	ra,40(sp)
    80002006:	f022                	sd	s0,32(sp)
    80002008:	ec26                	sd	s1,24(sp)
    8000200a:	e84a                	sd	s2,16(sp)
    8000200c:	1800                	addi	s0,sp,48
    8000200e:	84ae                	mv	s1,a1
    80002010:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80002012:	fd840593          	addi	a1,s0,-40
    80002016:	00000097          	auipc	ra,0x0
    8000201a:	fcc080e7          	jalr	-52(ra) # 80001fe2 <argaddr>
  return fetchstr(addr, buf, max);
    8000201e:	864a                	mv	a2,s2
    80002020:	85a6                	mv	a1,s1
    80002022:	fd843503          	ld	a0,-40(s0)
    80002026:	00000097          	auipc	ra,0x0
    8000202a:	f50080e7          	jalr	-176(ra) # 80001f76 <fetchstr>
}
    8000202e:	70a2                	ld	ra,40(sp)
    80002030:	7402                	ld	s0,32(sp)
    80002032:	64e2                	ld	s1,24(sp)
    80002034:	6942                	ld	s2,16(sp)
    80002036:	6145                	addi	sp,sp,48
    80002038:	8082                	ret

000000008000203a <syscall>:
};



void syscall(void)
{
    8000203a:	7179                	addi	sp,sp,-48
    8000203c:	f406                	sd	ra,40(sp)
    8000203e:	f022                	sd	s0,32(sp)
    80002040:	ec26                	sd	s1,24(sp)
    80002042:	e84a                	sd	s2,16(sp)
    80002044:	e44e                	sd	s3,8(sp)
    80002046:	1800                	addi	s0,sp,48
    int num;
    struct proc *p = myproc();
    80002048:	fffff097          	auipc	ra,0xfffff
    8000204c:	e34080e7          	jalr	-460(ra) # 80000e7c <myproc>
    80002050:	84aa                	mv	s1,a0

    num = p->trapframe->a7;
    80002052:	05853903          	ld	s2,88(a0)
    80002056:	0a893783          	ld	a5,168(s2)
    8000205a:	0007899b          	sext.w	s3,a5
    if (num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000205e:	37fd                	addiw	a5,a5,-1
    80002060:	4759                	li	a4,22
    80002062:	04f76763          	bltu	a4,a5,800020b0 <syscall+0x76>
    80002066:	00399713          	slli	a4,s3,0x3
    8000206a:	00006797          	auipc	a5,0x6
    8000206e:	42e78793          	addi	a5,a5,1070 # 80008498 <syscalls>
    80002072:	97ba                	add	a5,a5,a4
    80002074:	639c                	ld	a5,0(a5)
    80002076:	cf8d                	beqz	a5,800020b0 <syscall+0x76>
        // Use num to lookup the system call function for num, call it,
        // and store its return value in p->trapframe->a0

        p->trapframe->a0 = syscalls[num]();
    80002078:	9782                	jalr	a5
    8000207a:	06a93823          	sd	a0,112(s2)
        if (p->tracemask & (1 << num)) {
    8000207e:	4c9c                	lw	a5,24(s1)
    80002080:	4137d7bb          	sraw	a5,a5,s3
    80002084:	8b85                	andi	a5,a5,1
    80002086:	c7a1                	beqz	a5,800020ce <syscall+0x94>
            printf("%d: syscall %s -> %d\n", p->pid, syscalls_name[num], p->trapframe->a0);
    80002088:	6cb8                	ld	a4,88(s1)
    8000208a:	098e                	slli	s3,s3,0x3
    8000208c:	00007797          	auipc	a5,0x7
    80002090:	8cc78793          	addi	a5,a5,-1844 # 80008958 <syscalls_name>
    80002094:	99be                	add	s3,s3,a5
    80002096:	7b34                	ld	a3,112(a4)
    80002098:	0009b603          	ld	a2,0(s3)
    8000209c:	588c                	lw	a1,48(s1)
    8000209e:	00006517          	auipc	a0,0x6
    800020a2:	2fa50513          	addi	a0,a0,762 # 80008398 <states.1723+0x150>
    800020a6:	00004097          	auipc	ra,0x4
    800020aa:	c96080e7          	jalr	-874(ra) # 80005d3c <printf>
    800020ae:	a005                	j	800020ce <syscall+0x94>
        }
    }
    else {
        printf("%d %s: unknown sys call %d\n", p->pid, p->name, num);
    800020b0:	86ce                	mv	a3,s3
    800020b2:	15848613          	addi	a2,s1,344
    800020b6:	588c                	lw	a1,48(s1)
    800020b8:	00006517          	auipc	a0,0x6
    800020bc:	2f850513          	addi	a0,a0,760 # 800083b0 <states.1723+0x168>
    800020c0:	00004097          	auipc	ra,0x4
    800020c4:	c7c080e7          	jalr	-900(ra) # 80005d3c <printf>
        p->trapframe->a0 = -1;
    800020c8:	6cbc                	ld	a5,88(s1)
    800020ca:	577d                	li	a4,-1
    800020cc:	fbb8                	sd	a4,112(a5)
    }
}
    800020ce:	70a2                	ld	ra,40(sp)
    800020d0:	7402                	ld	s0,32(sp)
    800020d2:	64e2                	ld	s1,24(sp)
    800020d4:	6942                	ld	s2,16(sp)
    800020d6:	69a2                	ld	s3,8(sp)
    800020d8:	6145                	addi	sp,sp,48
    800020da:	8082                	ret

00000000800020dc <sys_exit>:
#include "sysinfo.h"


uint64
sys_exit(void)
{
    800020dc:	1101                	addi	sp,sp,-32
    800020de:	ec06                	sd	ra,24(sp)
    800020e0:	e822                	sd	s0,16(sp)
    800020e2:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    800020e4:	fec40593          	addi	a1,s0,-20
    800020e8:	4501                	li	a0,0
    800020ea:	00000097          	auipc	ra,0x0
    800020ee:	ed8080e7          	jalr	-296(ra) # 80001fc2 <argint>
  exit(n);
    800020f2:	fec42503          	lw	a0,-20(s0)
    800020f6:	fffff097          	auipc	ra,0xfffff
    800020fa:	566080e7          	jalr	1382(ra) # 8000165c <exit>
  return 0;  // not reached
}
    800020fe:	4501                	li	a0,0
    80002100:	60e2                	ld	ra,24(sp)
    80002102:	6442                	ld	s0,16(sp)
    80002104:	6105                	addi	sp,sp,32
    80002106:	8082                	ret

0000000080002108 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002108:	1141                	addi	sp,sp,-16
    8000210a:	e406                	sd	ra,8(sp)
    8000210c:	e022                	sd	s0,0(sp)
    8000210e:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002110:	fffff097          	auipc	ra,0xfffff
    80002114:	d6c080e7          	jalr	-660(ra) # 80000e7c <myproc>
}
    80002118:	5908                	lw	a0,48(a0)
    8000211a:	60a2                	ld	ra,8(sp)
    8000211c:	6402                	ld	s0,0(sp)
    8000211e:	0141                	addi	sp,sp,16
    80002120:	8082                	ret

0000000080002122 <sys_fork>:

uint64
sys_fork(void)
{
    80002122:	1141                	addi	sp,sp,-16
    80002124:	e406                	sd	ra,8(sp)
    80002126:	e022                	sd	s0,0(sp)
    80002128:	0800                	addi	s0,sp,16
  return fork();
    8000212a:	fffff097          	auipc	ra,0xfffff
    8000212e:	108080e7          	jalr	264(ra) # 80001232 <fork>
}
    80002132:	60a2                	ld	ra,8(sp)
    80002134:	6402                	ld	s0,0(sp)
    80002136:	0141                	addi	sp,sp,16
    80002138:	8082                	ret

000000008000213a <sys_wait>:

uint64
sys_wait(void)
{
    8000213a:	1101                	addi	sp,sp,-32
    8000213c:	ec06                	sd	ra,24(sp)
    8000213e:	e822                	sd	s0,16(sp)
    80002140:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002142:	fe840593          	addi	a1,s0,-24
    80002146:	4501                	li	a0,0
    80002148:	00000097          	auipc	ra,0x0
    8000214c:	e9a080e7          	jalr	-358(ra) # 80001fe2 <argaddr>
  return wait(p);
    80002150:	fe843503          	ld	a0,-24(s0)
    80002154:	fffff097          	auipc	ra,0xfffff
    80002158:	6ae080e7          	jalr	1710(ra) # 80001802 <wait>
}
    8000215c:	60e2                	ld	ra,24(sp)
    8000215e:	6442                	ld	s0,16(sp)
    80002160:	6105                	addi	sp,sp,32
    80002162:	8082                	ret

0000000080002164 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002164:	7179                	addi	sp,sp,-48
    80002166:	f406                	sd	ra,40(sp)
    80002168:	f022                	sd	s0,32(sp)
    8000216a:	ec26                	sd	s1,24(sp)
    8000216c:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    8000216e:	fdc40593          	addi	a1,s0,-36
    80002172:	4501                	li	a0,0
    80002174:	00000097          	auipc	ra,0x0
    80002178:	e4e080e7          	jalr	-434(ra) # 80001fc2 <argint>
  addr = myproc()->sz;
    8000217c:	fffff097          	auipc	ra,0xfffff
    80002180:	d00080e7          	jalr	-768(ra) # 80000e7c <myproc>
    80002184:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80002186:	fdc42503          	lw	a0,-36(s0)
    8000218a:	fffff097          	auipc	ra,0xfffff
    8000218e:	04c080e7          	jalr	76(ra) # 800011d6 <growproc>
    80002192:	00054863          	bltz	a0,800021a2 <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    80002196:	8526                	mv	a0,s1
    80002198:	70a2                	ld	ra,40(sp)
    8000219a:	7402                	ld	s0,32(sp)
    8000219c:	64e2                	ld	s1,24(sp)
    8000219e:	6145                	addi	sp,sp,48
    800021a0:	8082                	ret
    return -1;
    800021a2:	54fd                	li	s1,-1
    800021a4:	bfcd                	j	80002196 <sys_sbrk+0x32>

00000000800021a6 <sys_sleep>:

uint64
sys_sleep(void)
{
    800021a6:	7139                	addi	sp,sp,-64
    800021a8:	fc06                	sd	ra,56(sp)
    800021aa:	f822                	sd	s0,48(sp)
    800021ac:	f426                	sd	s1,40(sp)
    800021ae:	f04a                	sd	s2,32(sp)
    800021b0:	ec4e                	sd	s3,24(sp)
    800021b2:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    800021b4:	fcc40593          	addi	a1,s0,-52
    800021b8:	4501                	li	a0,0
    800021ba:	00000097          	auipc	ra,0x0
    800021be:	e08080e7          	jalr	-504(ra) # 80001fc2 <argint>
  if(n < 0)
    800021c2:	fcc42783          	lw	a5,-52(s0)
    800021c6:	0607cf63          	bltz	a5,80002244 <sys_sleep+0x9e>
    n = 0;
  acquire(&tickslock);
    800021ca:	0000c517          	auipc	a0,0xc
    800021ce:	72650513          	addi	a0,a0,1830 # 8000e8f0 <tickslock>
    800021d2:	00004097          	auipc	ra,0x4
    800021d6:	06a080e7          	jalr	106(ra) # 8000623c <acquire>
  ticks0 = ticks;
    800021da:	00007917          	auipc	s2,0x7
    800021de:	8ae92903          	lw	s2,-1874(s2) # 80008a88 <ticks>
  while(ticks - ticks0 < n){
    800021e2:	fcc42783          	lw	a5,-52(s0)
    800021e6:	cf9d                	beqz	a5,80002224 <sys_sleep+0x7e>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800021e8:	0000c997          	auipc	s3,0xc
    800021ec:	70898993          	addi	s3,s3,1800 # 8000e8f0 <tickslock>
    800021f0:	00007497          	auipc	s1,0x7
    800021f4:	89848493          	addi	s1,s1,-1896 # 80008a88 <ticks>
    if(killed(myproc())){
    800021f8:	fffff097          	auipc	ra,0xfffff
    800021fc:	c84080e7          	jalr	-892(ra) # 80000e7c <myproc>
    80002200:	fffff097          	auipc	ra,0xfffff
    80002204:	5d0080e7          	jalr	1488(ra) # 800017d0 <killed>
    80002208:	e129                	bnez	a0,8000224a <sys_sleep+0xa4>
    sleep(&ticks, &tickslock);
    8000220a:	85ce                	mv	a1,s3
    8000220c:	8526                	mv	a0,s1
    8000220e:	fffff097          	auipc	ra,0xfffff
    80002212:	31a080e7          	jalr	794(ra) # 80001528 <sleep>
  while(ticks - ticks0 < n){
    80002216:	409c                	lw	a5,0(s1)
    80002218:	412787bb          	subw	a5,a5,s2
    8000221c:	fcc42703          	lw	a4,-52(s0)
    80002220:	fce7ece3          	bltu	a5,a4,800021f8 <sys_sleep+0x52>
  }
  release(&tickslock);
    80002224:	0000c517          	auipc	a0,0xc
    80002228:	6cc50513          	addi	a0,a0,1740 # 8000e8f0 <tickslock>
    8000222c:	00004097          	auipc	ra,0x4
    80002230:	0c4080e7          	jalr	196(ra) # 800062f0 <release>
  return 0;
    80002234:	4501                	li	a0,0
}
    80002236:	70e2                	ld	ra,56(sp)
    80002238:	7442                	ld	s0,48(sp)
    8000223a:	74a2                	ld	s1,40(sp)
    8000223c:	7902                	ld	s2,32(sp)
    8000223e:	69e2                	ld	s3,24(sp)
    80002240:	6121                	addi	sp,sp,64
    80002242:	8082                	ret
    n = 0;
    80002244:	fc042623          	sw	zero,-52(s0)
    80002248:	b749                	j	800021ca <sys_sleep+0x24>
      release(&tickslock);
    8000224a:	0000c517          	auipc	a0,0xc
    8000224e:	6a650513          	addi	a0,a0,1702 # 8000e8f0 <tickslock>
    80002252:	00004097          	auipc	ra,0x4
    80002256:	09e080e7          	jalr	158(ra) # 800062f0 <release>
      return -1;
    8000225a:	557d                	li	a0,-1
    8000225c:	bfe9                	j	80002236 <sys_sleep+0x90>

000000008000225e <sys_kill>:

uint64
sys_kill(void)
{
    8000225e:	1101                	addi	sp,sp,-32
    80002260:	ec06                	sd	ra,24(sp)
    80002262:	e822                	sd	s0,16(sp)
    80002264:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002266:	fec40593          	addi	a1,s0,-20
    8000226a:	4501                	li	a0,0
    8000226c:	00000097          	auipc	ra,0x0
    80002270:	d56080e7          	jalr	-682(ra) # 80001fc2 <argint>
  return kill(pid);
    80002274:	fec42503          	lw	a0,-20(s0)
    80002278:	fffff097          	auipc	ra,0xfffff
    8000227c:	4ba080e7          	jalr	1210(ra) # 80001732 <kill>
}
    80002280:	60e2                	ld	ra,24(sp)
    80002282:	6442                	ld	s0,16(sp)
    80002284:	6105                	addi	sp,sp,32
    80002286:	8082                	ret

0000000080002288 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002288:	1101                	addi	sp,sp,-32
    8000228a:	ec06                	sd	ra,24(sp)
    8000228c:	e822                	sd	s0,16(sp)
    8000228e:	e426                	sd	s1,8(sp)
    80002290:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002292:	0000c517          	auipc	a0,0xc
    80002296:	65e50513          	addi	a0,a0,1630 # 8000e8f0 <tickslock>
    8000229a:	00004097          	auipc	ra,0x4
    8000229e:	fa2080e7          	jalr	-94(ra) # 8000623c <acquire>
  xticks = ticks;
    800022a2:	00006497          	auipc	s1,0x6
    800022a6:	7e64a483          	lw	s1,2022(s1) # 80008a88 <ticks>
  release(&tickslock);
    800022aa:	0000c517          	auipc	a0,0xc
    800022ae:	64650513          	addi	a0,a0,1606 # 8000e8f0 <tickslock>
    800022b2:	00004097          	auipc	ra,0x4
    800022b6:	03e080e7          	jalr	62(ra) # 800062f0 <release>
  return xticks;
}
    800022ba:	02049513          	slli	a0,s1,0x20
    800022be:	9101                	srli	a0,a0,0x20
    800022c0:	60e2                	ld	ra,24(sp)
    800022c2:	6442                	ld	s0,16(sp)
    800022c4:	64a2                	ld	s1,8(sp)
    800022c6:	6105                	addi	sp,sp,32
    800022c8:	8082                	ret

00000000800022ca <sys_trace>:


uint64 sys_trace(void)
{
    800022ca:	1101                	addi	sp,sp,-32
    800022cc:	ec06                	sd	ra,24(sp)
    800022ce:	e822                	sd	s0,16(sp)
    800022d0:	1000                	addi	s0,sp,32
    int mask;
    argint(0, &mask);
    800022d2:	fec40593          	addi	a1,s0,-20
    800022d6:	4501                	li	a0,0
    800022d8:	00000097          	auipc	ra,0x0
    800022dc:	cea080e7          	jalr	-790(ra) # 80001fc2 <argint>
    myproc()->tracemask = mask;
    800022e0:	fffff097          	auipc	ra,0xfffff
    800022e4:	b9c080e7          	jalr	-1124(ra) # 80000e7c <myproc>
    800022e8:	fec42783          	lw	a5,-20(s0)
    800022ec:	cd1c                	sw	a5,24(a0)
    return 0;
}
    800022ee:	4501                	li	a0,0
    800022f0:	60e2                	ld	ra,24(sp)
    800022f2:	6442                	ld	s0,16(sp)
    800022f4:	6105                	addi	sp,sp,32
    800022f6:	8082                	ret

00000000800022f8 <sys_sysinfo>:



uint64 sys_sysinfo(void)
{
    800022f8:	7179                	addi	sp,sp,-48
    800022fa:	f406                	sd	ra,40(sp)
    800022fc:	f022                	sd	s0,32(sp)
    800022fe:	1800                	addi	s0,sp,48
    uint64 addr;
    argaddr(0, &addr);
    80002300:	fe840593          	addi	a1,s0,-24
    80002304:	4501                	li	a0,0
    80002306:	00000097          	auipc	ra,0x0
    8000230a:	cdc080e7          	jalr	-804(ra) # 80001fe2 <argaddr>
    struct sysinfo info;
    info.freemem = get_freemem();
    8000230e:	ffffe097          	auipc	ra,0xffffe
    80002312:	e6a080e7          	jalr	-406(ra) # 80000178 <get_freemem>
    80002316:	fca43c23          	sd	a0,-40(s0)
    info.nproc = get_nproc();
    8000231a:	fffff097          	auipc	ra,0xfffff
    8000231e:	770080e7          	jalr	1904(ra) # 80001a8a <get_nproc>
    80002322:	fea43023          	sd	a0,-32(s0)

    if (copyout(myproc()->pagetable, addr, (char *)&info, sizeof(info)) < 0) {
    80002326:	fffff097          	auipc	ra,0xfffff
    8000232a:	b56080e7          	jalr	-1194(ra) # 80000e7c <myproc>
    8000232e:	46c1                	li	a3,16
    80002330:	fd840613          	addi	a2,s0,-40
    80002334:	fe843583          	ld	a1,-24(s0)
    80002338:	6928                	ld	a0,80(a0)
    8000233a:	fffff097          	auipc	ra,0xfffff
    8000233e:	800080e7          	jalr	-2048(ra) # 80000b3a <copyout>
        return -1;
    }
    return 0;
}
    80002342:	957d                	srai	a0,a0,0x3f
    80002344:	70a2                	ld	ra,40(sp)
    80002346:	7402                	ld	s0,32(sp)
    80002348:	6145                	addi	sp,sp,48
    8000234a:	8082                	ret

000000008000234c <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000234c:	7179                	addi	sp,sp,-48
    8000234e:	f406                	sd	ra,40(sp)
    80002350:	f022                	sd	s0,32(sp)
    80002352:	ec26                	sd	s1,24(sp)
    80002354:	e84a                	sd	s2,16(sp)
    80002356:	e44e                	sd	s3,8(sp)
    80002358:	e052                	sd	s4,0(sp)
    8000235a:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000235c:	00006597          	auipc	a1,0x6
    80002360:	1fc58593          	addi	a1,a1,508 # 80008558 <syscalls+0xc0>
    80002364:	0000c517          	auipc	a0,0xc
    80002368:	5a450513          	addi	a0,a0,1444 # 8000e908 <bcache>
    8000236c:	00004097          	auipc	ra,0x4
    80002370:	e40080e7          	jalr	-448(ra) # 800061ac <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002374:	00014797          	auipc	a5,0x14
    80002378:	59478793          	addi	a5,a5,1428 # 80016908 <bcache+0x8000>
    8000237c:	00014717          	auipc	a4,0x14
    80002380:	7f470713          	addi	a4,a4,2036 # 80016b70 <bcache+0x8268>
    80002384:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002388:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000238c:	0000c497          	auipc	s1,0xc
    80002390:	59448493          	addi	s1,s1,1428 # 8000e920 <bcache+0x18>
    b->next = bcache.head.next;
    80002394:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002396:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002398:	00006a17          	auipc	s4,0x6
    8000239c:	1c8a0a13          	addi	s4,s4,456 # 80008560 <syscalls+0xc8>
    b->next = bcache.head.next;
    800023a0:	2b893783          	ld	a5,696(s2)
    800023a4:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800023a6:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800023aa:	85d2                	mv	a1,s4
    800023ac:	01048513          	addi	a0,s1,16
    800023b0:	00001097          	auipc	ra,0x1
    800023b4:	4c4080e7          	jalr	1220(ra) # 80003874 <initsleeplock>
    bcache.head.next->prev = b;
    800023b8:	2b893783          	ld	a5,696(s2)
    800023bc:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800023be:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800023c2:	45848493          	addi	s1,s1,1112
    800023c6:	fd349de3          	bne	s1,s3,800023a0 <binit+0x54>
  }
}
    800023ca:	70a2                	ld	ra,40(sp)
    800023cc:	7402                	ld	s0,32(sp)
    800023ce:	64e2                	ld	s1,24(sp)
    800023d0:	6942                	ld	s2,16(sp)
    800023d2:	69a2                	ld	s3,8(sp)
    800023d4:	6a02                	ld	s4,0(sp)
    800023d6:	6145                	addi	sp,sp,48
    800023d8:	8082                	ret

00000000800023da <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800023da:	7179                	addi	sp,sp,-48
    800023dc:	f406                	sd	ra,40(sp)
    800023de:	f022                	sd	s0,32(sp)
    800023e0:	ec26                	sd	s1,24(sp)
    800023e2:	e84a                	sd	s2,16(sp)
    800023e4:	e44e                	sd	s3,8(sp)
    800023e6:	1800                	addi	s0,sp,48
    800023e8:	89aa                	mv	s3,a0
    800023ea:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    800023ec:	0000c517          	auipc	a0,0xc
    800023f0:	51c50513          	addi	a0,a0,1308 # 8000e908 <bcache>
    800023f4:	00004097          	auipc	ra,0x4
    800023f8:	e48080e7          	jalr	-440(ra) # 8000623c <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800023fc:	00014497          	auipc	s1,0x14
    80002400:	7c44b483          	ld	s1,1988(s1) # 80016bc0 <bcache+0x82b8>
    80002404:	00014797          	auipc	a5,0x14
    80002408:	76c78793          	addi	a5,a5,1900 # 80016b70 <bcache+0x8268>
    8000240c:	02f48f63          	beq	s1,a5,8000244a <bread+0x70>
    80002410:	873e                	mv	a4,a5
    80002412:	a021                	j	8000241a <bread+0x40>
    80002414:	68a4                	ld	s1,80(s1)
    80002416:	02e48a63          	beq	s1,a4,8000244a <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    8000241a:	449c                	lw	a5,8(s1)
    8000241c:	ff379ce3          	bne	a5,s3,80002414 <bread+0x3a>
    80002420:	44dc                	lw	a5,12(s1)
    80002422:	ff2799e3          	bne	a5,s2,80002414 <bread+0x3a>
      b->refcnt++;
    80002426:	40bc                	lw	a5,64(s1)
    80002428:	2785                	addiw	a5,a5,1
    8000242a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000242c:	0000c517          	auipc	a0,0xc
    80002430:	4dc50513          	addi	a0,a0,1244 # 8000e908 <bcache>
    80002434:	00004097          	auipc	ra,0x4
    80002438:	ebc080e7          	jalr	-324(ra) # 800062f0 <release>
      acquiresleep(&b->lock);
    8000243c:	01048513          	addi	a0,s1,16
    80002440:	00001097          	auipc	ra,0x1
    80002444:	46e080e7          	jalr	1134(ra) # 800038ae <acquiresleep>
      return b;
    80002448:	a8b9                	j	800024a6 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000244a:	00014497          	auipc	s1,0x14
    8000244e:	76e4b483          	ld	s1,1902(s1) # 80016bb8 <bcache+0x82b0>
    80002452:	00014797          	auipc	a5,0x14
    80002456:	71e78793          	addi	a5,a5,1822 # 80016b70 <bcache+0x8268>
    8000245a:	00f48863          	beq	s1,a5,8000246a <bread+0x90>
    8000245e:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002460:	40bc                	lw	a5,64(s1)
    80002462:	cf81                	beqz	a5,8000247a <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002464:	64a4                	ld	s1,72(s1)
    80002466:	fee49de3          	bne	s1,a4,80002460 <bread+0x86>
  panic("bget: no buffers");
    8000246a:	00006517          	auipc	a0,0x6
    8000246e:	0fe50513          	addi	a0,a0,254 # 80008568 <syscalls+0xd0>
    80002472:	00004097          	auipc	ra,0x4
    80002476:	880080e7          	jalr	-1920(ra) # 80005cf2 <panic>
      b->dev = dev;
    8000247a:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    8000247e:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    80002482:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002486:	4785                	li	a5,1
    80002488:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000248a:	0000c517          	auipc	a0,0xc
    8000248e:	47e50513          	addi	a0,a0,1150 # 8000e908 <bcache>
    80002492:	00004097          	auipc	ra,0x4
    80002496:	e5e080e7          	jalr	-418(ra) # 800062f0 <release>
      acquiresleep(&b->lock);
    8000249a:	01048513          	addi	a0,s1,16
    8000249e:	00001097          	auipc	ra,0x1
    800024a2:	410080e7          	jalr	1040(ra) # 800038ae <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800024a6:	409c                	lw	a5,0(s1)
    800024a8:	cb89                	beqz	a5,800024ba <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800024aa:	8526                	mv	a0,s1
    800024ac:	70a2                	ld	ra,40(sp)
    800024ae:	7402                	ld	s0,32(sp)
    800024b0:	64e2                	ld	s1,24(sp)
    800024b2:	6942                	ld	s2,16(sp)
    800024b4:	69a2                	ld	s3,8(sp)
    800024b6:	6145                	addi	sp,sp,48
    800024b8:	8082                	ret
    virtio_disk_rw(b, 0);
    800024ba:	4581                	li	a1,0
    800024bc:	8526                	mv	a0,s1
    800024be:	00003097          	auipc	ra,0x3
    800024c2:	fca080e7          	jalr	-54(ra) # 80005488 <virtio_disk_rw>
    b->valid = 1;
    800024c6:	4785                	li	a5,1
    800024c8:	c09c                	sw	a5,0(s1)
  return b;
    800024ca:	b7c5                	j	800024aa <bread+0xd0>

00000000800024cc <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800024cc:	1101                	addi	sp,sp,-32
    800024ce:	ec06                	sd	ra,24(sp)
    800024d0:	e822                	sd	s0,16(sp)
    800024d2:	e426                	sd	s1,8(sp)
    800024d4:	1000                	addi	s0,sp,32
    800024d6:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800024d8:	0541                	addi	a0,a0,16
    800024da:	00001097          	auipc	ra,0x1
    800024de:	46e080e7          	jalr	1134(ra) # 80003948 <holdingsleep>
    800024e2:	cd01                	beqz	a0,800024fa <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800024e4:	4585                	li	a1,1
    800024e6:	8526                	mv	a0,s1
    800024e8:	00003097          	auipc	ra,0x3
    800024ec:	fa0080e7          	jalr	-96(ra) # 80005488 <virtio_disk_rw>
}
    800024f0:	60e2                	ld	ra,24(sp)
    800024f2:	6442                	ld	s0,16(sp)
    800024f4:	64a2                	ld	s1,8(sp)
    800024f6:	6105                	addi	sp,sp,32
    800024f8:	8082                	ret
    panic("bwrite");
    800024fa:	00006517          	auipc	a0,0x6
    800024fe:	08650513          	addi	a0,a0,134 # 80008580 <syscalls+0xe8>
    80002502:	00003097          	auipc	ra,0x3
    80002506:	7f0080e7          	jalr	2032(ra) # 80005cf2 <panic>

000000008000250a <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000250a:	1101                	addi	sp,sp,-32
    8000250c:	ec06                	sd	ra,24(sp)
    8000250e:	e822                	sd	s0,16(sp)
    80002510:	e426                	sd	s1,8(sp)
    80002512:	e04a                	sd	s2,0(sp)
    80002514:	1000                	addi	s0,sp,32
    80002516:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002518:	01050913          	addi	s2,a0,16
    8000251c:	854a                	mv	a0,s2
    8000251e:	00001097          	auipc	ra,0x1
    80002522:	42a080e7          	jalr	1066(ra) # 80003948 <holdingsleep>
    80002526:	c92d                	beqz	a0,80002598 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80002528:	854a                	mv	a0,s2
    8000252a:	00001097          	auipc	ra,0x1
    8000252e:	3da080e7          	jalr	986(ra) # 80003904 <releasesleep>

  acquire(&bcache.lock);
    80002532:	0000c517          	auipc	a0,0xc
    80002536:	3d650513          	addi	a0,a0,982 # 8000e908 <bcache>
    8000253a:	00004097          	auipc	ra,0x4
    8000253e:	d02080e7          	jalr	-766(ra) # 8000623c <acquire>
  b->refcnt--;
    80002542:	40bc                	lw	a5,64(s1)
    80002544:	37fd                	addiw	a5,a5,-1
    80002546:	0007871b          	sext.w	a4,a5
    8000254a:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000254c:	eb05                	bnez	a4,8000257c <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000254e:	68bc                	ld	a5,80(s1)
    80002550:	64b8                	ld	a4,72(s1)
    80002552:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002554:	64bc                	ld	a5,72(s1)
    80002556:	68b8                	ld	a4,80(s1)
    80002558:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000255a:	00014797          	auipc	a5,0x14
    8000255e:	3ae78793          	addi	a5,a5,942 # 80016908 <bcache+0x8000>
    80002562:	2b87b703          	ld	a4,696(a5)
    80002566:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002568:	00014717          	auipc	a4,0x14
    8000256c:	60870713          	addi	a4,a4,1544 # 80016b70 <bcache+0x8268>
    80002570:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002572:	2b87b703          	ld	a4,696(a5)
    80002576:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002578:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000257c:	0000c517          	auipc	a0,0xc
    80002580:	38c50513          	addi	a0,a0,908 # 8000e908 <bcache>
    80002584:	00004097          	auipc	ra,0x4
    80002588:	d6c080e7          	jalr	-660(ra) # 800062f0 <release>
}
    8000258c:	60e2                	ld	ra,24(sp)
    8000258e:	6442                	ld	s0,16(sp)
    80002590:	64a2                	ld	s1,8(sp)
    80002592:	6902                	ld	s2,0(sp)
    80002594:	6105                	addi	sp,sp,32
    80002596:	8082                	ret
    panic("brelse");
    80002598:	00006517          	auipc	a0,0x6
    8000259c:	ff050513          	addi	a0,a0,-16 # 80008588 <syscalls+0xf0>
    800025a0:	00003097          	auipc	ra,0x3
    800025a4:	752080e7          	jalr	1874(ra) # 80005cf2 <panic>

00000000800025a8 <bpin>:

void
bpin(struct buf *b) {
    800025a8:	1101                	addi	sp,sp,-32
    800025aa:	ec06                	sd	ra,24(sp)
    800025ac:	e822                	sd	s0,16(sp)
    800025ae:	e426                	sd	s1,8(sp)
    800025b0:	1000                	addi	s0,sp,32
    800025b2:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800025b4:	0000c517          	auipc	a0,0xc
    800025b8:	35450513          	addi	a0,a0,852 # 8000e908 <bcache>
    800025bc:	00004097          	auipc	ra,0x4
    800025c0:	c80080e7          	jalr	-896(ra) # 8000623c <acquire>
  b->refcnt++;
    800025c4:	40bc                	lw	a5,64(s1)
    800025c6:	2785                	addiw	a5,a5,1
    800025c8:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800025ca:	0000c517          	auipc	a0,0xc
    800025ce:	33e50513          	addi	a0,a0,830 # 8000e908 <bcache>
    800025d2:	00004097          	auipc	ra,0x4
    800025d6:	d1e080e7          	jalr	-738(ra) # 800062f0 <release>
}
    800025da:	60e2                	ld	ra,24(sp)
    800025dc:	6442                	ld	s0,16(sp)
    800025de:	64a2                	ld	s1,8(sp)
    800025e0:	6105                	addi	sp,sp,32
    800025e2:	8082                	ret

00000000800025e4 <bunpin>:

void
bunpin(struct buf *b) {
    800025e4:	1101                	addi	sp,sp,-32
    800025e6:	ec06                	sd	ra,24(sp)
    800025e8:	e822                	sd	s0,16(sp)
    800025ea:	e426                	sd	s1,8(sp)
    800025ec:	1000                	addi	s0,sp,32
    800025ee:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800025f0:	0000c517          	auipc	a0,0xc
    800025f4:	31850513          	addi	a0,a0,792 # 8000e908 <bcache>
    800025f8:	00004097          	auipc	ra,0x4
    800025fc:	c44080e7          	jalr	-956(ra) # 8000623c <acquire>
  b->refcnt--;
    80002600:	40bc                	lw	a5,64(s1)
    80002602:	37fd                	addiw	a5,a5,-1
    80002604:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002606:	0000c517          	auipc	a0,0xc
    8000260a:	30250513          	addi	a0,a0,770 # 8000e908 <bcache>
    8000260e:	00004097          	auipc	ra,0x4
    80002612:	ce2080e7          	jalr	-798(ra) # 800062f0 <release>
}
    80002616:	60e2                	ld	ra,24(sp)
    80002618:	6442                	ld	s0,16(sp)
    8000261a:	64a2                	ld	s1,8(sp)
    8000261c:	6105                	addi	sp,sp,32
    8000261e:	8082                	ret

0000000080002620 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002620:	1101                	addi	sp,sp,-32
    80002622:	ec06                	sd	ra,24(sp)
    80002624:	e822                	sd	s0,16(sp)
    80002626:	e426                	sd	s1,8(sp)
    80002628:	e04a                	sd	s2,0(sp)
    8000262a:	1000                	addi	s0,sp,32
    8000262c:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000262e:	00d5d59b          	srliw	a1,a1,0xd
    80002632:	00015797          	auipc	a5,0x15
    80002636:	9b27a783          	lw	a5,-1614(a5) # 80016fe4 <sb+0x1c>
    8000263a:	9dbd                	addw	a1,a1,a5
    8000263c:	00000097          	auipc	ra,0x0
    80002640:	d9e080e7          	jalr	-610(ra) # 800023da <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002644:	0074f713          	andi	a4,s1,7
    80002648:	4785                	li	a5,1
    8000264a:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000264e:	14ce                	slli	s1,s1,0x33
    80002650:	90d9                	srli	s1,s1,0x36
    80002652:	00950733          	add	a4,a0,s1
    80002656:	05874703          	lbu	a4,88(a4)
    8000265a:	00e7f6b3          	and	a3,a5,a4
    8000265e:	c69d                	beqz	a3,8000268c <bfree+0x6c>
    80002660:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002662:	94aa                	add	s1,s1,a0
    80002664:	fff7c793          	not	a5,a5
    80002668:	8ff9                	and	a5,a5,a4
    8000266a:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    8000266e:	00001097          	auipc	ra,0x1
    80002672:	120080e7          	jalr	288(ra) # 8000378e <log_write>
  brelse(bp);
    80002676:	854a                	mv	a0,s2
    80002678:	00000097          	auipc	ra,0x0
    8000267c:	e92080e7          	jalr	-366(ra) # 8000250a <brelse>
}
    80002680:	60e2                	ld	ra,24(sp)
    80002682:	6442                	ld	s0,16(sp)
    80002684:	64a2                	ld	s1,8(sp)
    80002686:	6902                	ld	s2,0(sp)
    80002688:	6105                	addi	sp,sp,32
    8000268a:	8082                	ret
    panic("freeing free block");
    8000268c:	00006517          	auipc	a0,0x6
    80002690:	f0450513          	addi	a0,a0,-252 # 80008590 <syscalls+0xf8>
    80002694:	00003097          	auipc	ra,0x3
    80002698:	65e080e7          	jalr	1630(ra) # 80005cf2 <panic>

000000008000269c <balloc>:
{
    8000269c:	711d                	addi	sp,sp,-96
    8000269e:	ec86                	sd	ra,88(sp)
    800026a0:	e8a2                	sd	s0,80(sp)
    800026a2:	e4a6                	sd	s1,72(sp)
    800026a4:	e0ca                	sd	s2,64(sp)
    800026a6:	fc4e                	sd	s3,56(sp)
    800026a8:	f852                	sd	s4,48(sp)
    800026aa:	f456                	sd	s5,40(sp)
    800026ac:	f05a                	sd	s6,32(sp)
    800026ae:	ec5e                	sd	s7,24(sp)
    800026b0:	e862                	sd	s8,16(sp)
    800026b2:	e466                	sd	s9,8(sp)
    800026b4:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800026b6:	00015797          	auipc	a5,0x15
    800026ba:	9167a783          	lw	a5,-1770(a5) # 80016fcc <sb+0x4>
    800026be:	10078163          	beqz	a5,800027c0 <balloc+0x124>
    800026c2:	8baa                	mv	s7,a0
    800026c4:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800026c6:	00015b17          	auipc	s6,0x15
    800026ca:	902b0b13          	addi	s6,s6,-1790 # 80016fc8 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026ce:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800026d0:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026d2:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800026d4:	6c89                	lui	s9,0x2
    800026d6:	a061                	j	8000275e <balloc+0xc2>
        bp->data[bi/8] |= m;  // Mark block in use.
    800026d8:	974a                	add	a4,a4,s2
    800026da:	8fd5                	or	a5,a5,a3
    800026dc:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    800026e0:	854a                	mv	a0,s2
    800026e2:	00001097          	auipc	ra,0x1
    800026e6:	0ac080e7          	jalr	172(ra) # 8000378e <log_write>
        brelse(bp);
    800026ea:	854a                	mv	a0,s2
    800026ec:	00000097          	auipc	ra,0x0
    800026f0:	e1e080e7          	jalr	-482(ra) # 8000250a <brelse>
  bp = bread(dev, bno);
    800026f4:	85a6                	mv	a1,s1
    800026f6:	855e                	mv	a0,s7
    800026f8:	00000097          	auipc	ra,0x0
    800026fc:	ce2080e7          	jalr	-798(ra) # 800023da <bread>
    80002700:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002702:	40000613          	li	a2,1024
    80002706:	4581                	li	a1,0
    80002708:	05850513          	addi	a0,a0,88
    8000270c:	ffffe097          	auipc	ra,0xffffe
    80002710:	a90080e7          	jalr	-1392(ra) # 8000019c <memset>
  log_write(bp);
    80002714:	854a                	mv	a0,s2
    80002716:	00001097          	auipc	ra,0x1
    8000271a:	078080e7          	jalr	120(ra) # 8000378e <log_write>
  brelse(bp);
    8000271e:	854a                	mv	a0,s2
    80002720:	00000097          	auipc	ra,0x0
    80002724:	dea080e7          	jalr	-534(ra) # 8000250a <brelse>
}
    80002728:	8526                	mv	a0,s1
    8000272a:	60e6                	ld	ra,88(sp)
    8000272c:	6446                	ld	s0,80(sp)
    8000272e:	64a6                	ld	s1,72(sp)
    80002730:	6906                	ld	s2,64(sp)
    80002732:	79e2                	ld	s3,56(sp)
    80002734:	7a42                	ld	s4,48(sp)
    80002736:	7aa2                	ld	s5,40(sp)
    80002738:	7b02                	ld	s6,32(sp)
    8000273a:	6be2                	ld	s7,24(sp)
    8000273c:	6c42                	ld	s8,16(sp)
    8000273e:	6ca2                	ld	s9,8(sp)
    80002740:	6125                	addi	sp,sp,96
    80002742:	8082                	ret
    brelse(bp);
    80002744:	854a                	mv	a0,s2
    80002746:	00000097          	auipc	ra,0x0
    8000274a:	dc4080e7          	jalr	-572(ra) # 8000250a <brelse>
  for(b = 0; b < sb.size; b += BPB){
    8000274e:	015c87bb          	addw	a5,s9,s5
    80002752:	00078a9b          	sext.w	s5,a5
    80002756:	004b2703          	lw	a4,4(s6)
    8000275a:	06eaf363          	bgeu	s5,a4,800027c0 <balloc+0x124>
    bp = bread(dev, BBLOCK(b, sb));
    8000275e:	41fad79b          	sraiw	a5,s5,0x1f
    80002762:	0137d79b          	srliw	a5,a5,0x13
    80002766:	015787bb          	addw	a5,a5,s5
    8000276a:	40d7d79b          	sraiw	a5,a5,0xd
    8000276e:	01cb2583          	lw	a1,28(s6)
    80002772:	9dbd                	addw	a1,a1,a5
    80002774:	855e                	mv	a0,s7
    80002776:	00000097          	auipc	ra,0x0
    8000277a:	c64080e7          	jalr	-924(ra) # 800023da <bread>
    8000277e:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002780:	004b2503          	lw	a0,4(s6)
    80002784:	000a849b          	sext.w	s1,s5
    80002788:	8662                	mv	a2,s8
    8000278a:	faa4fde3          	bgeu	s1,a0,80002744 <balloc+0xa8>
      m = 1 << (bi % 8);
    8000278e:	41f6579b          	sraiw	a5,a2,0x1f
    80002792:	01d7d69b          	srliw	a3,a5,0x1d
    80002796:	00c6873b          	addw	a4,a3,a2
    8000279a:	00777793          	andi	a5,a4,7
    8000279e:	9f95                	subw	a5,a5,a3
    800027a0:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800027a4:	4037571b          	sraiw	a4,a4,0x3
    800027a8:	00e906b3          	add	a3,s2,a4
    800027ac:	0586c683          	lbu	a3,88(a3)
    800027b0:	00d7f5b3          	and	a1,a5,a3
    800027b4:	d195                	beqz	a1,800026d8 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800027b6:	2605                	addiw	a2,a2,1
    800027b8:	2485                	addiw	s1,s1,1
    800027ba:	fd4618e3          	bne	a2,s4,8000278a <balloc+0xee>
    800027be:	b759                	j	80002744 <balloc+0xa8>
  printf("balloc: out of blocks\n");
    800027c0:	00006517          	auipc	a0,0x6
    800027c4:	de850513          	addi	a0,a0,-536 # 800085a8 <syscalls+0x110>
    800027c8:	00003097          	auipc	ra,0x3
    800027cc:	574080e7          	jalr	1396(ra) # 80005d3c <printf>
  return 0;
    800027d0:	4481                	li	s1,0
    800027d2:	bf99                	j	80002728 <balloc+0x8c>

00000000800027d4 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800027d4:	7179                	addi	sp,sp,-48
    800027d6:	f406                	sd	ra,40(sp)
    800027d8:	f022                	sd	s0,32(sp)
    800027da:	ec26                	sd	s1,24(sp)
    800027dc:	e84a                	sd	s2,16(sp)
    800027de:	e44e                	sd	s3,8(sp)
    800027e0:	e052                	sd	s4,0(sp)
    800027e2:	1800                	addi	s0,sp,48
    800027e4:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800027e6:	47ad                	li	a5,11
    800027e8:	02b7e763          	bltu	a5,a1,80002816 <bmap+0x42>
    if((addr = ip->addrs[bn]) == 0){
    800027ec:	02059493          	slli	s1,a1,0x20
    800027f0:	9081                	srli	s1,s1,0x20
    800027f2:	048a                	slli	s1,s1,0x2
    800027f4:	94aa                	add	s1,s1,a0
    800027f6:	0504a903          	lw	s2,80(s1)
    800027fa:	06091e63          	bnez	s2,80002876 <bmap+0xa2>
      addr = balloc(ip->dev);
    800027fe:	4108                	lw	a0,0(a0)
    80002800:	00000097          	auipc	ra,0x0
    80002804:	e9c080e7          	jalr	-356(ra) # 8000269c <balloc>
    80002808:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    8000280c:	06090563          	beqz	s2,80002876 <bmap+0xa2>
        return 0;
      ip->addrs[bn] = addr;
    80002810:	0524a823          	sw	s2,80(s1)
    80002814:	a08d                	j	80002876 <bmap+0xa2>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002816:	ff45849b          	addiw	s1,a1,-12
    8000281a:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    8000281e:	0ff00793          	li	a5,255
    80002822:	08e7e563          	bltu	a5,a4,800028ac <bmap+0xd8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002826:	08052903          	lw	s2,128(a0)
    8000282a:	00091d63          	bnez	s2,80002844 <bmap+0x70>
      addr = balloc(ip->dev);
    8000282e:	4108                	lw	a0,0(a0)
    80002830:	00000097          	auipc	ra,0x0
    80002834:	e6c080e7          	jalr	-404(ra) # 8000269c <balloc>
    80002838:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    8000283c:	02090d63          	beqz	s2,80002876 <bmap+0xa2>
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002840:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    80002844:	85ca                	mv	a1,s2
    80002846:	0009a503          	lw	a0,0(s3)
    8000284a:	00000097          	auipc	ra,0x0
    8000284e:	b90080e7          	jalr	-1136(ra) # 800023da <bread>
    80002852:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002854:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002858:	02049593          	slli	a1,s1,0x20
    8000285c:	9181                	srli	a1,a1,0x20
    8000285e:	058a                	slli	a1,a1,0x2
    80002860:	00b784b3          	add	s1,a5,a1
    80002864:	0004a903          	lw	s2,0(s1)
    80002868:	02090063          	beqz	s2,80002888 <bmap+0xb4>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    8000286c:	8552                	mv	a0,s4
    8000286e:	00000097          	auipc	ra,0x0
    80002872:	c9c080e7          	jalr	-868(ra) # 8000250a <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80002876:	854a                	mv	a0,s2
    80002878:	70a2                	ld	ra,40(sp)
    8000287a:	7402                	ld	s0,32(sp)
    8000287c:	64e2                	ld	s1,24(sp)
    8000287e:	6942                	ld	s2,16(sp)
    80002880:	69a2                	ld	s3,8(sp)
    80002882:	6a02                	ld	s4,0(sp)
    80002884:	6145                	addi	sp,sp,48
    80002886:	8082                	ret
      addr = balloc(ip->dev);
    80002888:	0009a503          	lw	a0,0(s3)
    8000288c:	00000097          	auipc	ra,0x0
    80002890:	e10080e7          	jalr	-496(ra) # 8000269c <balloc>
    80002894:	0005091b          	sext.w	s2,a0
      if(addr){
    80002898:	fc090ae3          	beqz	s2,8000286c <bmap+0x98>
        a[bn] = addr;
    8000289c:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    800028a0:	8552                	mv	a0,s4
    800028a2:	00001097          	auipc	ra,0x1
    800028a6:	eec080e7          	jalr	-276(ra) # 8000378e <log_write>
    800028aa:	b7c9                	j	8000286c <bmap+0x98>
  panic("bmap: out of range");
    800028ac:	00006517          	auipc	a0,0x6
    800028b0:	d1450513          	addi	a0,a0,-748 # 800085c0 <syscalls+0x128>
    800028b4:	00003097          	auipc	ra,0x3
    800028b8:	43e080e7          	jalr	1086(ra) # 80005cf2 <panic>

00000000800028bc <iget>:
{
    800028bc:	7179                	addi	sp,sp,-48
    800028be:	f406                	sd	ra,40(sp)
    800028c0:	f022                	sd	s0,32(sp)
    800028c2:	ec26                	sd	s1,24(sp)
    800028c4:	e84a                	sd	s2,16(sp)
    800028c6:	e44e                	sd	s3,8(sp)
    800028c8:	e052                	sd	s4,0(sp)
    800028ca:	1800                	addi	s0,sp,48
    800028cc:	89aa                	mv	s3,a0
    800028ce:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800028d0:	00014517          	auipc	a0,0x14
    800028d4:	71850513          	addi	a0,a0,1816 # 80016fe8 <itable>
    800028d8:	00004097          	auipc	ra,0x4
    800028dc:	964080e7          	jalr	-1692(ra) # 8000623c <acquire>
  empty = 0;
    800028e0:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800028e2:	00014497          	auipc	s1,0x14
    800028e6:	71e48493          	addi	s1,s1,1822 # 80017000 <itable+0x18>
    800028ea:	00016697          	auipc	a3,0x16
    800028ee:	1a668693          	addi	a3,a3,422 # 80018a90 <log>
    800028f2:	a039                	j	80002900 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800028f4:	02090b63          	beqz	s2,8000292a <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800028f8:	08848493          	addi	s1,s1,136
    800028fc:	02d48a63          	beq	s1,a3,80002930 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002900:	449c                	lw	a5,8(s1)
    80002902:	fef059e3          	blez	a5,800028f4 <iget+0x38>
    80002906:	4098                	lw	a4,0(s1)
    80002908:	ff3716e3          	bne	a4,s3,800028f4 <iget+0x38>
    8000290c:	40d8                	lw	a4,4(s1)
    8000290e:	ff4713e3          	bne	a4,s4,800028f4 <iget+0x38>
      ip->ref++;
    80002912:	2785                	addiw	a5,a5,1
    80002914:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002916:	00014517          	auipc	a0,0x14
    8000291a:	6d250513          	addi	a0,a0,1746 # 80016fe8 <itable>
    8000291e:	00004097          	auipc	ra,0x4
    80002922:	9d2080e7          	jalr	-1582(ra) # 800062f0 <release>
      return ip;
    80002926:	8926                	mv	s2,s1
    80002928:	a03d                	j	80002956 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000292a:	f7f9                	bnez	a5,800028f8 <iget+0x3c>
    8000292c:	8926                	mv	s2,s1
    8000292e:	b7e9                	j	800028f8 <iget+0x3c>
  if(empty == 0)
    80002930:	02090c63          	beqz	s2,80002968 <iget+0xac>
  ip->dev = dev;
    80002934:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002938:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    8000293c:	4785                	li	a5,1
    8000293e:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002942:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002946:	00014517          	auipc	a0,0x14
    8000294a:	6a250513          	addi	a0,a0,1698 # 80016fe8 <itable>
    8000294e:	00004097          	auipc	ra,0x4
    80002952:	9a2080e7          	jalr	-1630(ra) # 800062f0 <release>
}
    80002956:	854a                	mv	a0,s2
    80002958:	70a2                	ld	ra,40(sp)
    8000295a:	7402                	ld	s0,32(sp)
    8000295c:	64e2                	ld	s1,24(sp)
    8000295e:	6942                	ld	s2,16(sp)
    80002960:	69a2                	ld	s3,8(sp)
    80002962:	6a02                	ld	s4,0(sp)
    80002964:	6145                	addi	sp,sp,48
    80002966:	8082                	ret
    panic("iget: no inodes");
    80002968:	00006517          	auipc	a0,0x6
    8000296c:	c7050513          	addi	a0,a0,-912 # 800085d8 <syscalls+0x140>
    80002970:	00003097          	auipc	ra,0x3
    80002974:	382080e7          	jalr	898(ra) # 80005cf2 <panic>

0000000080002978 <fsinit>:
fsinit(int dev) {
    80002978:	7179                	addi	sp,sp,-48
    8000297a:	f406                	sd	ra,40(sp)
    8000297c:	f022                	sd	s0,32(sp)
    8000297e:	ec26                	sd	s1,24(sp)
    80002980:	e84a                	sd	s2,16(sp)
    80002982:	e44e                	sd	s3,8(sp)
    80002984:	1800                	addi	s0,sp,48
    80002986:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002988:	4585                	li	a1,1
    8000298a:	00000097          	auipc	ra,0x0
    8000298e:	a50080e7          	jalr	-1456(ra) # 800023da <bread>
    80002992:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002994:	00014997          	auipc	s3,0x14
    80002998:	63498993          	addi	s3,s3,1588 # 80016fc8 <sb>
    8000299c:	02000613          	li	a2,32
    800029a0:	05850593          	addi	a1,a0,88
    800029a4:	854e                	mv	a0,s3
    800029a6:	ffffe097          	auipc	ra,0xffffe
    800029aa:	856080e7          	jalr	-1962(ra) # 800001fc <memmove>
  brelse(bp);
    800029ae:	8526                	mv	a0,s1
    800029b0:	00000097          	auipc	ra,0x0
    800029b4:	b5a080e7          	jalr	-1190(ra) # 8000250a <brelse>
  if(sb.magic != FSMAGIC)
    800029b8:	0009a703          	lw	a4,0(s3)
    800029bc:	102037b7          	lui	a5,0x10203
    800029c0:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800029c4:	02f71263          	bne	a4,a5,800029e8 <fsinit+0x70>
  initlog(dev, &sb);
    800029c8:	00014597          	auipc	a1,0x14
    800029cc:	60058593          	addi	a1,a1,1536 # 80016fc8 <sb>
    800029d0:	854a                	mv	a0,s2
    800029d2:	00001097          	auipc	ra,0x1
    800029d6:	b40080e7          	jalr	-1216(ra) # 80003512 <initlog>
}
    800029da:	70a2                	ld	ra,40(sp)
    800029dc:	7402                	ld	s0,32(sp)
    800029de:	64e2                	ld	s1,24(sp)
    800029e0:	6942                	ld	s2,16(sp)
    800029e2:	69a2                	ld	s3,8(sp)
    800029e4:	6145                	addi	sp,sp,48
    800029e6:	8082                	ret
    panic("invalid file system");
    800029e8:	00006517          	auipc	a0,0x6
    800029ec:	c0050513          	addi	a0,a0,-1024 # 800085e8 <syscalls+0x150>
    800029f0:	00003097          	auipc	ra,0x3
    800029f4:	302080e7          	jalr	770(ra) # 80005cf2 <panic>

00000000800029f8 <iinit>:
{
    800029f8:	7179                	addi	sp,sp,-48
    800029fa:	f406                	sd	ra,40(sp)
    800029fc:	f022                	sd	s0,32(sp)
    800029fe:	ec26                	sd	s1,24(sp)
    80002a00:	e84a                	sd	s2,16(sp)
    80002a02:	e44e                	sd	s3,8(sp)
    80002a04:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002a06:	00006597          	auipc	a1,0x6
    80002a0a:	bfa58593          	addi	a1,a1,-1030 # 80008600 <syscalls+0x168>
    80002a0e:	00014517          	auipc	a0,0x14
    80002a12:	5da50513          	addi	a0,a0,1498 # 80016fe8 <itable>
    80002a16:	00003097          	auipc	ra,0x3
    80002a1a:	796080e7          	jalr	1942(ra) # 800061ac <initlock>
  for(i = 0; i < NINODE; i++) {
    80002a1e:	00014497          	auipc	s1,0x14
    80002a22:	5f248493          	addi	s1,s1,1522 # 80017010 <itable+0x28>
    80002a26:	00016997          	auipc	s3,0x16
    80002a2a:	07a98993          	addi	s3,s3,122 # 80018aa0 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002a2e:	00006917          	auipc	s2,0x6
    80002a32:	bda90913          	addi	s2,s2,-1062 # 80008608 <syscalls+0x170>
    80002a36:	85ca                	mv	a1,s2
    80002a38:	8526                	mv	a0,s1
    80002a3a:	00001097          	auipc	ra,0x1
    80002a3e:	e3a080e7          	jalr	-454(ra) # 80003874 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002a42:	08848493          	addi	s1,s1,136
    80002a46:	ff3498e3          	bne	s1,s3,80002a36 <iinit+0x3e>
}
    80002a4a:	70a2                	ld	ra,40(sp)
    80002a4c:	7402                	ld	s0,32(sp)
    80002a4e:	64e2                	ld	s1,24(sp)
    80002a50:	6942                	ld	s2,16(sp)
    80002a52:	69a2                	ld	s3,8(sp)
    80002a54:	6145                	addi	sp,sp,48
    80002a56:	8082                	ret

0000000080002a58 <ialloc>:
{
    80002a58:	715d                	addi	sp,sp,-80
    80002a5a:	e486                	sd	ra,72(sp)
    80002a5c:	e0a2                	sd	s0,64(sp)
    80002a5e:	fc26                	sd	s1,56(sp)
    80002a60:	f84a                	sd	s2,48(sp)
    80002a62:	f44e                	sd	s3,40(sp)
    80002a64:	f052                	sd	s4,32(sp)
    80002a66:	ec56                	sd	s5,24(sp)
    80002a68:	e85a                	sd	s6,16(sp)
    80002a6a:	e45e                	sd	s7,8(sp)
    80002a6c:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a6e:	00014717          	auipc	a4,0x14
    80002a72:	56672703          	lw	a4,1382(a4) # 80016fd4 <sb+0xc>
    80002a76:	4785                	li	a5,1
    80002a78:	04e7fa63          	bgeu	a5,a4,80002acc <ialloc+0x74>
    80002a7c:	8aaa                	mv	s5,a0
    80002a7e:	8bae                	mv	s7,a1
    80002a80:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002a82:	00014a17          	auipc	s4,0x14
    80002a86:	546a0a13          	addi	s4,s4,1350 # 80016fc8 <sb>
    80002a8a:	00048b1b          	sext.w	s6,s1
    80002a8e:	0044d593          	srli	a1,s1,0x4
    80002a92:	018a2783          	lw	a5,24(s4)
    80002a96:	9dbd                	addw	a1,a1,a5
    80002a98:	8556                	mv	a0,s5
    80002a9a:	00000097          	auipc	ra,0x0
    80002a9e:	940080e7          	jalr	-1728(ra) # 800023da <bread>
    80002aa2:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002aa4:	05850993          	addi	s3,a0,88
    80002aa8:	00f4f793          	andi	a5,s1,15
    80002aac:	079a                	slli	a5,a5,0x6
    80002aae:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002ab0:	00099783          	lh	a5,0(s3)
    80002ab4:	c3a1                	beqz	a5,80002af4 <ialloc+0x9c>
    brelse(bp);
    80002ab6:	00000097          	auipc	ra,0x0
    80002aba:	a54080e7          	jalr	-1452(ra) # 8000250a <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002abe:	0485                	addi	s1,s1,1
    80002ac0:	00ca2703          	lw	a4,12(s4)
    80002ac4:	0004879b          	sext.w	a5,s1
    80002ac8:	fce7e1e3          	bltu	a5,a4,80002a8a <ialloc+0x32>
  printf("ialloc: no inodes\n");
    80002acc:	00006517          	auipc	a0,0x6
    80002ad0:	b4450513          	addi	a0,a0,-1212 # 80008610 <syscalls+0x178>
    80002ad4:	00003097          	auipc	ra,0x3
    80002ad8:	268080e7          	jalr	616(ra) # 80005d3c <printf>
  return 0;
    80002adc:	4501                	li	a0,0
}
    80002ade:	60a6                	ld	ra,72(sp)
    80002ae0:	6406                	ld	s0,64(sp)
    80002ae2:	74e2                	ld	s1,56(sp)
    80002ae4:	7942                	ld	s2,48(sp)
    80002ae6:	79a2                	ld	s3,40(sp)
    80002ae8:	7a02                	ld	s4,32(sp)
    80002aea:	6ae2                	ld	s5,24(sp)
    80002aec:	6b42                	ld	s6,16(sp)
    80002aee:	6ba2                	ld	s7,8(sp)
    80002af0:	6161                	addi	sp,sp,80
    80002af2:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002af4:	04000613          	li	a2,64
    80002af8:	4581                	li	a1,0
    80002afa:	854e                	mv	a0,s3
    80002afc:	ffffd097          	auipc	ra,0xffffd
    80002b00:	6a0080e7          	jalr	1696(ra) # 8000019c <memset>
      dip->type = type;
    80002b04:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002b08:	854a                	mv	a0,s2
    80002b0a:	00001097          	auipc	ra,0x1
    80002b0e:	c84080e7          	jalr	-892(ra) # 8000378e <log_write>
      brelse(bp);
    80002b12:	854a                	mv	a0,s2
    80002b14:	00000097          	auipc	ra,0x0
    80002b18:	9f6080e7          	jalr	-1546(ra) # 8000250a <brelse>
      return iget(dev, inum);
    80002b1c:	85da                	mv	a1,s6
    80002b1e:	8556                	mv	a0,s5
    80002b20:	00000097          	auipc	ra,0x0
    80002b24:	d9c080e7          	jalr	-612(ra) # 800028bc <iget>
    80002b28:	bf5d                	j	80002ade <ialloc+0x86>

0000000080002b2a <iupdate>:
{
    80002b2a:	1101                	addi	sp,sp,-32
    80002b2c:	ec06                	sd	ra,24(sp)
    80002b2e:	e822                	sd	s0,16(sp)
    80002b30:	e426                	sd	s1,8(sp)
    80002b32:	e04a                	sd	s2,0(sp)
    80002b34:	1000                	addi	s0,sp,32
    80002b36:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b38:	415c                	lw	a5,4(a0)
    80002b3a:	0047d79b          	srliw	a5,a5,0x4
    80002b3e:	00014597          	auipc	a1,0x14
    80002b42:	4a25a583          	lw	a1,1186(a1) # 80016fe0 <sb+0x18>
    80002b46:	9dbd                	addw	a1,a1,a5
    80002b48:	4108                	lw	a0,0(a0)
    80002b4a:	00000097          	auipc	ra,0x0
    80002b4e:	890080e7          	jalr	-1904(ra) # 800023da <bread>
    80002b52:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b54:	05850793          	addi	a5,a0,88
    80002b58:	40c8                	lw	a0,4(s1)
    80002b5a:	893d                	andi	a0,a0,15
    80002b5c:	051a                	slli	a0,a0,0x6
    80002b5e:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002b60:	04449703          	lh	a4,68(s1)
    80002b64:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002b68:	04649703          	lh	a4,70(s1)
    80002b6c:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002b70:	04849703          	lh	a4,72(s1)
    80002b74:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002b78:	04a49703          	lh	a4,74(s1)
    80002b7c:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002b80:	44f8                	lw	a4,76(s1)
    80002b82:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002b84:	03400613          	li	a2,52
    80002b88:	05048593          	addi	a1,s1,80
    80002b8c:	0531                	addi	a0,a0,12
    80002b8e:	ffffd097          	auipc	ra,0xffffd
    80002b92:	66e080e7          	jalr	1646(ra) # 800001fc <memmove>
  log_write(bp);
    80002b96:	854a                	mv	a0,s2
    80002b98:	00001097          	auipc	ra,0x1
    80002b9c:	bf6080e7          	jalr	-1034(ra) # 8000378e <log_write>
  brelse(bp);
    80002ba0:	854a                	mv	a0,s2
    80002ba2:	00000097          	auipc	ra,0x0
    80002ba6:	968080e7          	jalr	-1688(ra) # 8000250a <brelse>
}
    80002baa:	60e2                	ld	ra,24(sp)
    80002bac:	6442                	ld	s0,16(sp)
    80002bae:	64a2                	ld	s1,8(sp)
    80002bb0:	6902                	ld	s2,0(sp)
    80002bb2:	6105                	addi	sp,sp,32
    80002bb4:	8082                	ret

0000000080002bb6 <idup>:
{
    80002bb6:	1101                	addi	sp,sp,-32
    80002bb8:	ec06                	sd	ra,24(sp)
    80002bba:	e822                	sd	s0,16(sp)
    80002bbc:	e426                	sd	s1,8(sp)
    80002bbe:	1000                	addi	s0,sp,32
    80002bc0:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002bc2:	00014517          	auipc	a0,0x14
    80002bc6:	42650513          	addi	a0,a0,1062 # 80016fe8 <itable>
    80002bca:	00003097          	auipc	ra,0x3
    80002bce:	672080e7          	jalr	1650(ra) # 8000623c <acquire>
  ip->ref++;
    80002bd2:	449c                	lw	a5,8(s1)
    80002bd4:	2785                	addiw	a5,a5,1
    80002bd6:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002bd8:	00014517          	auipc	a0,0x14
    80002bdc:	41050513          	addi	a0,a0,1040 # 80016fe8 <itable>
    80002be0:	00003097          	auipc	ra,0x3
    80002be4:	710080e7          	jalr	1808(ra) # 800062f0 <release>
}
    80002be8:	8526                	mv	a0,s1
    80002bea:	60e2                	ld	ra,24(sp)
    80002bec:	6442                	ld	s0,16(sp)
    80002bee:	64a2                	ld	s1,8(sp)
    80002bf0:	6105                	addi	sp,sp,32
    80002bf2:	8082                	ret

0000000080002bf4 <ilock>:
{
    80002bf4:	1101                	addi	sp,sp,-32
    80002bf6:	ec06                	sd	ra,24(sp)
    80002bf8:	e822                	sd	s0,16(sp)
    80002bfa:	e426                	sd	s1,8(sp)
    80002bfc:	e04a                	sd	s2,0(sp)
    80002bfe:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002c00:	c115                	beqz	a0,80002c24 <ilock+0x30>
    80002c02:	84aa                	mv	s1,a0
    80002c04:	451c                	lw	a5,8(a0)
    80002c06:	00f05f63          	blez	a5,80002c24 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002c0a:	0541                	addi	a0,a0,16
    80002c0c:	00001097          	auipc	ra,0x1
    80002c10:	ca2080e7          	jalr	-862(ra) # 800038ae <acquiresleep>
  if(ip->valid == 0){
    80002c14:	40bc                	lw	a5,64(s1)
    80002c16:	cf99                	beqz	a5,80002c34 <ilock+0x40>
}
    80002c18:	60e2                	ld	ra,24(sp)
    80002c1a:	6442                	ld	s0,16(sp)
    80002c1c:	64a2                	ld	s1,8(sp)
    80002c1e:	6902                	ld	s2,0(sp)
    80002c20:	6105                	addi	sp,sp,32
    80002c22:	8082                	ret
    panic("ilock");
    80002c24:	00006517          	auipc	a0,0x6
    80002c28:	a0450513          	addi	a0,a0,-1532 # 80008628 <syscalls+0x190>
    80002c2c:	00003097          	auipc	ra,0x3
    80002c30:	0c6080e7          	jalr	198(ra) # 80005cf2 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c34:	40dc                	lw	a5,4(s1)
    80002c36:	0047d79b          	srliw	a5,a5,0x4
    80002c3a:	00014597          	auipc	a1,0x14
    80002c3e:	3a65a583          	lw	a1,934(a1) # 80016fe0 <sb+0x18>
    80002c42:	9dbd                	addw	a1,a1,a5
    80002c44:	4088                	lw	a0,0(s1)
    80002c46:	fffff097          	auipc	ra,0xfffff
    80002c4a:	794080e7          	jalr	1940(ra) # 800023da <bread>
    80002c4e:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c50:	05850593          	addi	a1,a0,88
    80002c54:	40dc                	lw	a5,4(s1)
    80002c56:	8bbd                	andi	a5,a5,15
    80002c58:	079a                	slli	a5,a5,0x6
    80002c5a:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002c5c:	00059783          	lh	a5,0(a1)
    80002c60:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002c64:	00259783          	lh	a5,2(a1)
    80002c68:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002c6c:	00459783          	lh	a5,4(a1)
    80002c70:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002c74:	00659783          	lh	a5,6(a1)
    80002c78:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002c7c:	459c                	lw	a5,8(a1)
    80002c7e:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002c80:	03400613          	li	a2,52
    80002c84:	05b1                	addi	a1,a1,12
    80002c86:	05048513          	addi	a0,s1,80
    80002c8a:	ffffd097          	auipc	ra,0xffffd
    80002c8e:	572080e7          	jalr	1394(ra) # 800001fc <memmove>
    brelse(bp);
    80002c92:	854a                	mv	a0,s2
    80002c94:	00000097          	auipc	ra,0x0
    80002c98:	876080e7          	jalr	-1930(ra) # 8000250a <brelse>
    ip->valid = 1;
    80002c9c:	4785                	li	a5,1
    80002c9e:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002ca0:	04449783          	lh	a5,68(s1)
    80002ca4:	fbb5                	bnez	a5,80002c18 <ilock+0x24>
      panic("ilock: no type");
    80002ca6:	00006517          	auipc	a0,0x6
    80002caa:	98a50513          	addi	a0,a0,-1654 # 80008630 <syscalls+0x198>
    80002cae:	00003097          	auipc	ra,0x3
    80002cb2:	044080e7          	jalr	68(ra) # 80005cf2 <panic>

0000000080002cb6 <iunlock>:
{
    80002cb6:	1101                	addi	sp,sp,-32
    80002cb8:	ec06                	sd	ra,24(sp)
    80002cba:	e822                	sd	s0,16(sp)
    80002cbc:	e426                	sd	s1,8(sp)
    80002cbe:	e04a                	sd	s2,0(sp)
    80002cc0:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002cc2:	c905                	beqz	a0,80002cf2 <iunlock+0x3c>
    80002cc4:	84aa                	mv	s1,a0
    80002cc6:	01050913          	addi	s2,a0,16
    80002cca:	854a                	mv	a0,s2
    80002ccc:	00001097          	auipc	ra,0x1
    80002cd0:	c7c080e7          	jalr	-900(ra) # 80003948 <holdingsleep>
    80002cd4:	cd19                	beqz	a0,80002cf2 <iunlock+0x3c>
    80002cd6:	449c                	lw	a5,8(s1)
    80002cd8:	00f05d63          	blez	a5,80002cf2 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002cdc:	854a                	mv	a0,s2
    80002cde:	00001097          	auipc	ra,0x1
    80002ce2:	c26080e7          	jalr	-986(ra) # 80003904 <releasesleep>
}
    80002ce6:	60e2                	ld	ra,24(sp)
    80002ce8:	6442                	ld	s0,16(sp)
    80002cea:	64a2                	ld	s1,8(sp)
    80002cec:	6902                	ld	s2,0(sp)
    80002cee:	6105                	addi	sp,sp,32
    80002cf0:	8082                	ret
    panic("iunlock");
    80002cf2:	00006517          	auipc	a0,0x6
    80002cf6:	94e50513          	addi	a0,a0,-1714 # 80008640 <syscalls+0x1a8>
    80002cfa:	00003097          	auipc	ra,0x3
    80002cfe:	ff8080e7          	jalr	-8(ra) # 80005cf2 <panic>

0000000080002d02 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002d02:	7179                	addi	sp,sp,-48
    80002d04:	f406                	sd	ra,40(sp)
    80002d06:	f022                	sd	s0,32(sp)
    80002d08:	ec26                	sd	s1,24(sp)
    80002d0a:	e84a                	sd	s2,16(sp)
    80002d0c:	e44e                	sd	s3,8(sp)
    80002d0e:	e052                	sd	s4,0(sp)
    80002d10:	1800                	addi	s0,sp,48
    80002d12:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002d14:	05050493          	addi	s1,a0,80
    80002d18:	08050913          	addi	s2,a0,128
    80002d1c:	a021                	j	80002d24 <itrunc+0x22>
    80002d1e:	0491                	addi	s1,s1,4
    80002d20:	01248d63          	beq	s1,s2,80002d3a <itrunc+0x38>
    if(ip->addrs[i]){
    80002d24:	408c                	lw	a1,0(s1)
    80002d26:	dde5                	beqz	a1,80002d1e <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002d28:	0009a503          	lw	a0,0(s3)
    80002d2c:	00000097          	auipc	ra,0x0
    80002d30:	8f4080e7          	jalr	-1804(ra) # 80002620 <bfree>
      ip->addrs[i] = 0;
    80002d34:	0004a023          	sw	zero,0(s1)
    80002d38:	b7dd                	j	80002d1e <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002d3a:	0809a583          	lw	a1,128(s3)
    80002d3e:	e185                	bnez	a1,80002d5e <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002d40:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002d44:	854e                	mv	a0,s3
    80002d46:	00000097          	auipc	ra,0x0
    80002d4a:	de4080e7          	jalr	-540(ra) # 80002b2a <iupdate>
}
    80002d4e:	70a2                	ld	ra,40(sp)
    80002d50:	7402                	ld	s0,32(sp)
    80002d52:	64e2                	ld	s1,24(sp)
    80002d54:	6942                	ld	s2,16(sp)
    80002d56:	69a2                	ld	s3,8(sp)
    80002d58:	6a02                	ld	s4,0(sp)
    80002d5a:	6145                	addi	sp,sp,48
    80002d5c:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002d5e:	0009a503          	lw	a0,0(s3)
    80002d62:	fffff097          	auipc	ra,0xfffff
    80002d66:	678080e7          	jalr	1656(ra) # 800023da <bread>
    80002d6a:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002d6c:	05850493          	addi	s1,a0,88
    80002d70:	45850913          	addi	s2,a0,1112
    80002d74:	a811                	j	80002d88 <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002d76:	0009a503          	lw	a0,0(s3)
    80002d7a:	00000097          	auipc	ra,0x0
    80002d7e:	8a6080e7          	jalr	-1882(ra) # 80002620 <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002d82:	0491                	addi	s1,s1,4
    80002d84:	01248563          	beq	s1,s2,80002d8e <itrunc+0x8c>
      if(a[j])
    80002d88:	408c                	lw	a1,0(s1)
    80002d8a:	dde5                	beqz	a1,80002d82 <itrunc+0x80>
    80002d8c:	b7ed                	j	80002d76 <itrunc+0x74>
    brelse(bp);
    80002d8e:	8552                	mv	a0,s4
    80002d90:	fffff097          	auipc	ra,0xfffff
    80002d94:	77a080e7          	jalr	1914(ra) # 8000250a <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002d98:	0809a583          	lw	a1,128(s3)
    80002d9c:	0009a503          	lw	a0,0(s3)
    80002da0:	00000097          	auipc	ra,0x0
    80002da4:	880080e7          	jalr	-1920(ra) # 80002620 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002da8:	0809a023          	sw	zero,128(s3)
    80002dac:	bf51                	j	80002d40 <itrunc+0x3e>

0000000080002dae <iput>:
{
    80002dae:	1101                	addi	sp,sp,-32
    80002db0:	ec06                	sd	ra,24(sp)
    80002db2:	e822                	sd	s0,16(sp)
    80002db4:	e426                	sd	s1,8(sp)
    80002db6:	e04a                	sd	s2,0(sp)
    80002db8:	1000                	addi	s0,sp,32
    80002dba:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002dbc:	00014517          	auipc	a0,0x14
    80002dc0:	22c50513          	addi	a0,a0,556 # 80016fe8 <itable>
    80002dc4:	00003097          	auipc	ra,0x3
    80002dc8:	478080e7          	jalr	1144(ra) # 8000623c <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002dcc:	4498                	lw	a4,8(s1)
    80002dce:	4785                	li	a5,1
    80002dd0:	02f70363          	beq	a4,a5,80002df6 <iput+0x48>
  ip->ref--;
    80002dd4:	449c                	lw	a5,8(s1)
    80002dd6:	37fd                	addiw	a5,a5,-1
    80002dd8:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002dda:	00014517          	auipc	a0,0x14
    80002dde:	20e50513          	addi	a0,a0,526 # 80016fe8 <itable>
    80002de2:	00003097          	auipc	ra,0x3
    80002de6:	50e080e7          	jalr	1294(ra) # 800062f0 <release>
}
    80002dea:	60e2                	ld	ra,24(sp)
    80002dec:	6442                	ld	s0,16(sp)
    80002dee:	64a2                	ld	s1,8(sp)
    80002df0:	6902                	ld	s2,0(sp)
    80002df2:	6105                	addi	sp,sp,32
    80002df4:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002df6:	40bc                	lw	a5,64(s1)
    80002df8:	dff1                	beqz	a5,80002dd4 <iput+0x26>
    80002dfa:	04a49783          	lh	a5,74(s1)
    80002dfe:	fbf9                	bnez	a5,80002dd4 <iput+0x26>
    acquiresleep(&ip->lock);
    80002e00:	01048913          	addi	s2,s1,16
    80002e04:	854a                	mv	a0,s2
    80002e06:	00001097          	auipc	ra,0x1
    80002e0a:	aa8080e7          	jalr	-1368(ra) # 800038ae <acquiresleep>
    release(&itable.lock);
    80002e0e:	00014517          	auipc	a0,0x14
    80002e12:	1da50513          	addi	a0,a0,474 # 80016fe8 <itable>
    80002e16:	00003097          	auipc	ra,0x3
    80002e1a:	4da080e7          	jalr	1242(ra) # 800062f0 <release>
    itrunc(ip);
    80002e1e:	8526                	mv	a0,s1
    80002e20:	00000097          	auipc	ra,0x0
    80002e24:	ee2080e7          	jalr	-286(ra) # 80002d02 <itrunc>
    ip->type = 0;
    80002e28:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002e2c:	8526                	mv	a0,s1
    80002e2e:	00000097          	auipc	ra,0x0
    80002e32:	cfc080e7          	jalr	-772(ra) # 80002b2a <iupdate>
    ip->valid = 0;
    80002e36:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002e3a:	854a                	mv	a0,s2
    80002e3c:	00001097          	auipc	ra,0x1
    80002e40:	ac8080e7          	jalr	-1336(ra) # 80003904 <releasesleep>
    acquire(&itable.lock);
    80002e44:	00014517          	auipc	a0,0x14
    80002e48:	1a450513          	addi	a0,a0,420 # 80016fe8 <itable>
    80002e4c:	00003097          	auipc	ra,0x3
    80002e50:	3f0080e7          	jalr	1008(ra) # 8000623c <acquire>
    80002e54:	b741                	j	80002dd4 <iput+0x26>

0000000080002e56 <iunlockput>:
{
    80002e56:	1101                	addi	sp,sp,-32
    80002e58:	ec06                	sd	ra,24(sp)
    80002e5a:	e822                	sd	s0,16(sp)
    80002e5c:	e426                	sd	s1,8(sp)
    80002e5e:	1000                	addi	s0,sp,32
    80002e60:	84aa                	mv	s1,a0
  iunlock(ip);
    80002e62:	00000097          	auipc	ra,0x0
    80002e66:	e54080e7          	jalr	-428(ra) # 80002cb6 <iunlock>
  iput(ip);
    80002e6a:	8526                	mv	a0,s1
    80002e6c:	00000097          	auipc	ra,0x0
    80002e70:	f42080e7          	jalr	-190(ra) # 80002dae <iput>
}
    80002e74:	60e2                	ld	ra,24(sp)
    80002e76:	6442                	ld	s0,16(sp)
    80002e78:	64a2                	ld	s1,8(sp)
    80002e7a:	6105                	addi	sp,sp,32
    80002e7c:	8082                	ret

0000000080002e7e <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002e7e:	1141                	addi	sp,sp,-16
    80002e80:	e422                	sd	s0,8(sp)
    80002e82:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002e84:	411c                	lw	a5,0(a0)
    80002e86:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002e88:	415c                	lw	a5,4(a0)
    80002e8a:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002e8c:	04451783          	lh	a5,68(a0)
    80002e90:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002e94:	04a51783          	lh	a5,74(a0)
    80002e98:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002e9c:	04c56783          	lwu	a5,76(a0)
    80002ea0:	e99c                	sd	a5,16(a1)
}
    80002ea2:	6422                	ld	s0,8(sp)
    80002ea4:	0141                	addi	sp,sp,16
    80002ea6:	8082                	ret

0000000080002ea8 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002ea8:	457c                	lw	a5,76(a0)
    80002eaa:	0ed7e963          	bltu	a5,a3,80002f9c <readi+0xf4>
{
    80002eae:	7159                	addi	sp,sp,-112
    80002eb0:	f486                	sd	ra,104(sp)
    80002eb2:	f0a2                	sd	s0,96(sp)
    80002eb4:	eca6                	sd	s1,88(sp)
    80002eb6:	e8ca                	sd	s2,80(sp)
    80002eb8:	e4ce                	sd	s3,72(sp)
    80002eba:	e0d2                	sd	s4,64(sp)
    80002ebc:	fc56                	sd	s5,56(sp)
    80002ebe:	f85a                	sd	s6,48(sp)
    80002ec0:	f45e                	sd	s7,40(sp)
    80002ec2:	f062                	sd	s8,32(sp)
    80002ec4:	ec66                	sd	s9,24(sp)
    80002ec6:	e86a                	sd	s10,16(sp)
    80002ec8:	e46e                	sd	s11,8(sp)
    80002eca:	1880                	addi	s0,sp,112
    80002ecc:	8b2a                	mv	s6,a0
    80002ece:	8bae                	mv	s7,a1
    80002ed0:	8a32                	mv	s4,a2
    80002ed2:	84b6                	mv	s1,a3
    80002ed4:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002ed6:	9f35                	addw	a4,a4,a3
    return 0;
    80002ed8:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002eda:	0ad76063          	bltu	a4,a3,80002f7a <readi+0xd2>
  if(off + n > ip->size)
    80002ede:	00e7f463          	bgeu	a5,a4,80002ee6 <readi+0x3e>
    n = ip->size - off;
    80002ee2:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ee6:	0a0a8963          	beqz	s5,80002f98 <readi+0xf0>
    80002eea:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002eec:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002ef0:	5c7d                	li	s8,-1
    80002ef2:	a82d                	j	80002f2c <readi+0x84>
    80002ef4:	020d1d93          	slli	s11,s10,0x20
    80002ef8:	020ddd93          	srli	s11,s11,0x20
    80002efc:	05890613          	addi	a2,s2,88
    80002f00:	86ee                	mv	a3,s11
    80002f02:	963a                	add	a2,a2,a4
    80002f04:	85d2                	mv	a1,s4
    80002f06:	855e                	mv	a0,s7
    80002f08:	fffff097          	auipc	ra,0xfffff
    80002f0c:	a28080e7          	jalr	-1496(ra) # 80001930 <either_copyout>
    80002f10:	05850d63          	beq	a0,s8,80002f6a <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002f14:	854a                	mv	a0,s2
    80002f16:	fffff097          	auipc	ra,0xfffff
    80002f1a:	5f4080e7          	jalr	1524(ra) # 8000250a <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f1e:	013d09bb          	addw	s3,s10,s3
    80002f22:	009d04bb          	addw	s1,s10,s1
    80002f26:	9a6e                	add	s4,s4,s11
    80002f28:	0559f763          	bgeu	s3,s5,80002f76 <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80002f2c:	00a4d59b          	srliw	a1,s1,0xa
    80002f30:	855a                	mv	a0,s6
    80002f32:	00000097          	auipc	ra,0x0
    80002f36:	8a2080e7          	jalr	-1886(ra) # 800027d4 <bmap>
    80002f3a:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002f3e:	cd85                	beqz	a1,80002f76 <readi+0xce>
    bp = bread(ip->dev, addr);
    80002f40:	000b2503          	lw	a0,0(s6)
    80002f44:	fffff097          	auipc	ra,0xfffff
    80002f48:	496080e7          	jalr	1174(ra) # 800023da <bread>
    80002f4c:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f4e:	3ff4f713          	andi	a4,s1,1023
    80002f52:	40ec87bb          	subw	a5,s9,a4
    80002f56:	413a86bb          	subw	a3,s5,s3
    80002f5a:	8d3e                	mv	s10,a5
    80002f5c:	2781                	sext.w	a5,a5
    80002f5e:	0006861b          	sext.w	a2,a3
    80002f62:	f8f679e3          	bgeu	a2,a5,80002ef4 <readi+0x4c>
    80002f66:	8d36                	mv	s10,a3
    80002f68:	b771                	j	80002ef4 <readi+0x4c>
      brelse(bp);
    80002f6a:	854a                	mv	a0,s2
    80002f6c:	fffff097          	auipc	ra,0xfffff
    80002f70:	59e080e7          	jalr	1438(ra) # 8000250a <brelse>
      tot = -1;
    80002f74:	59fd                	li	s3,-1
  }
  return tot;
    80002f76:	0009851b          	sext.w	a0,s3
}
    80002f7a:	70a6                	ld	ra,104(sp)
    80002f7c:	7406                	ld	s0,96(sp)
    80002f7e:	64e6                	ld	s1,88(sp)
    80002f80:	6946                	ld	s2,80(sp)
    80002f82:	69a6                	ld	s3,72(sp)
    80002f84:	6a06                	ld	s4,64(sp)
    80002f86:	7ae2                	ld	s5,56(sp)
    80002f88:	7b42                	ld	s6,48(sp)
    80002f8a:	7ba2                	ld	s7,40(sp)
    80002f8c:	7c02                	ld	s8,32(sp)
    80002f8e:	6ce2                	ld	s9,24(sp)
    80002f90:	6d42                	ld	s10,16(sp)
    80002f92:	6da2                	ld	s11,8(sp)
    80002f94:	6165                	addi	sp,sp,112
    80002f96:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f98:	89d6                	mv	s3,s5
    80002f9a:	bff1                	j	80002f76 <readi+0xce>
    return 0;
    80002f9c:	4501                	li	a0,0
}
    80002f9e:	8082                	ret

0000000080002fa0 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002fa0:	457c                	lw	a5,76(a0)
    80002fa2:	10d7e863          	bltu	a5,a3,800030b2 <writei+0x112>
{
    80002fa6:	7159                	addi	sp,sp,-112
    80002fa8:	f486                	sd	ra,104(sp)
    80002faa:	f0a2                	sd	s0,96(sp)
    80002fac:	eca6                	sd	s1,88(sp)
    80002fae:	e8ca                	sd	s2,80(sp)
    80002fb0:	e4ce                	sd	s3,72(sp)
    80002fb2:	e0d2                	sd	s4,64(sp)
    80002fb4:	fc56                	sd	s5,56(sp)
    80002fb6:	f85a                	sd	s6,48(sp)
    80002fb8:	f45e                	sd	s7,40(sp)
    80002fba:	f062                	sd	s8,32(sp)
    80002fbc:	ec66                	sd	s9,24(sp)
    80002fbe:	e86a                	sd	s10,16(sp)
    80002fc0:	e46e                	sd	s11,8(sp)
    80002fc2:	1880                	addi	s0,sp,112
    80002fc4:	8aaa                	mv	s5,a0
    80002fc6:	8bae                	mv	s7,a1
    80002fc8:	8a32                	mv	s4,a2
    80002fca:	8936                	mv	s2,a3
    80002fcc:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002fce:	00e687bb          	addw	a5,a3,a4
    80002fd2:	0ed7e263          	bltu	a5,a3,800030b6 <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002fd6:	00043737          	lui	a4,0x43
    80002fda:	0ef76063          	bltu	a4,a5,800030ba <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002fde:	0c0b0863          	beqz	s6,800030ae <writei+0x10e>
    80002fe2:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002fe4:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002fe8:	5c7d                	li	s8,-1
    80002fea:	a091                	j	8000302e <writei+0x8e>
    80002fec:	020d1d93          	slli	s11,s10,0x20
    80002ff0:	020ddd93          	srli	s11,s11,0x20
    80002ff4:	05848513          	addi	a0,s1,88
    80002ff8:	86ee                	mv	a3,s11
    80002ffa:	8652                	mv	a2,s4
    80002ffc:	85de                	mv	a1,s7
    80002ffe:	953a                	add	a0,a0,a4
    80003000:	fffff097          	auipc	ra,0xfffff
    80003004:	986080e7          	jalr	-1658(ra) # 80001986 <either_copyin>
    80003008:	07850263          	beq	a0,s8,8000306c <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    8000300c:	8526                	mv	a0,s1
    8000300e:	00000097          	auipc	ra,0x0
    80003012:	780080e7          	jalr	1920(ra) # 8000378e <log_write>
    brelse(bp);
    80003016:	8526                	mv	a0,s1
    80003018:	fffff097          	auipc	ra,0xfffff
    8000301c:	4f2080e7          	jalr	1266(ra) # 8000250a <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003020:	013d09bb          	addw	s3,s10,s3
    80003024:	012d093b          	addw	s2,s10,s2
    80003028:	9a6e                	add	s4,s4,s11
    8000302a:	0569f663          	bgeu	s3,s6,80003076 <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    8000302e:	00a9559b          	srliw	a1,s2,0xa
    80003032:	8556                	mv	a0,s5
    80003034:	fffff097          	auipc	ra,0xfffff
    80003038:	7a0080e7          	jalr	1952(ra) # 800027d4 <bmap>
    8000303c:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003040:	c99d                	beqz	a1,80003076 <writei+0xd6>
    bp = bread(ip->dev, addr);
    80003042:	000aa503          	lw	a0,0(s5)
    80003046:	fffff097          	auipc	ra,0xfffff
    8000304a:	394080e7          	jalr	916(ra) # 800023da <bread>
    8000304e:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003050:	3ff97713          	andi	a4,s2,1023
    80003054:	40ec87bb          	subw	a5,s9,a4
    80003058:	413b06bb          	subw	a3,s6,s3
    8000305c:	8d3e                	mv	s10,a5
    8000305e:	2781                	sext.w	a5,a5
    80003060:	0006861b          	sext.w	a2,a3
    80003064:	f8f674e3          	bgeu	a2,a5,80002fec <writei+0x4c>
    80003068:	8d36                	mv	s10,a3
    8000306a:	b749                	j	80002fec <writei+0x4c>
      brelse(bp);
    8000306c:	8526                	mv	a0,s1
    8000306e:	fffff097          	auipc	ra,0xfffff
    80003072:	49c080e7          	jalr	1180(ra) # 8000250a <brelse>
  }

  if(off > ip->size)
    80003076:	04caa783          	lw	a5,76(s5)
    8000307a:	0127f463          	bgeu	a5,s2,80003082 <writei+0xe2>
    ip->size = off;
    8000307e:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003082:	8556                	mv	a0,s5
    80003084:	00000097          	auipc	ra,0x0
    80003088:	aa6080e7          	jalr	-1370(ra) # 80002b2a <iupdate>

  return tot;
    8000308c:	0009851b          	sext.w	a0,s3
}
    80003090:	70a6                	ld	ra,104(sp)
    80003092:	7406                	ld	s0,96(sp)
    80003094:	64e6                	ld	s1,88(sp)
    80003096:	6946                	ld	s2,80(sp)
    80003098:	69a6                	ld	s3,72(sp)
    8000309a:	6a06                	ld	s4,64(sp)
    8000309c:	7ae2                	ld	s5,56(sp)
    8000309e:	7b42                	ld	s6,48(sp)
    800030a0:	7ba2                	ld	s7,40(sp)
    800030a2:	7c02                	ld	s8,32(sp)
    800030a4:	6ce2                	ld	s9,24(sp)
    800030a6:	6d42                	ld	s10,16(sp)
    800030a8:	6da2                	ld	s11,8(sp)
    800030aa:	6165                	addi	sp,sp,112
    800030ac:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800030ae:	89da                	mv	s3,s6
    800030b0:	bfc9                	j	80003082 <writei+0xe2>
    return -1;
    800030b2:	557d                	li	a0,-1
}
    800030b4:	8082                	ret
    return -1;
    800030b6:	557d                	li	a0,-1
    800030b8:	bfe1                	j	80003090 <writei+0xf0>
    return -1;
    800030ba:	557d                	li	a0,-1
    800030bc:	bfd1                	j	80003090 <writei+0xf0>

00000000800030be <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800030be:	1141                	addi	sp,sp,-16
    800030c0:	e406                	sd	ra,8(sp)
    800030c2:	e022                	sd	s0,0(sp)
    800030c4:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800030c6:	4639                	li	a2,14
    800030c8:	ffffd097          	auipc	ra,0xffffd
    800030cc:	1ac080e7          	jalr	428(ra) # 80000274 <strncmp>
}
    800030d0:	60a2                	ld	ra,8(sp)
    800030d2:	6402                	ld	s0,0(sp)
    800030d4:	0141                	addi	sp,sp,16
    800030d6:	8082                	ret

00000000800030d8 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800030d8:	7139                	addi	sp,sp,-64
    800030da:	fc06                	sd	ra,56(sp)
    800030dc:	f822                	sd	s0,48(sp)
    800030de:	f426                	sd	s1,40(sp)
    800030e0:	f04a                	sd	s2,32(sp)
    800030e2:	ec4e                	sd	s3,24(sp)
    800030e4:	e852                	sd	s4,16(sp)
    800030e6:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800030e8:	04451703          	lh	a4,68(a0)
    800030ec:	4785                	li	a5,1
    800030ee:	00f71a63          	bne	a4,a5,80003102 <dirlookup+0x2a>
    800030f2:	892a                	mv	s2,a0
    800030f4:	89ae                	mv	s3,a1
    800030f6:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800030f8:	457c                	lw	a5,76(a0)
    800030fa:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800030fc:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800030fe:	e79d                	bnez	a5,8000312c <dirlookup+0x54>
    80003100:	a8a5                	j	80003178 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003102:	00005517          	auipc	a0,0x5
    80003106:	54650513          	addi	a0,a0,1350 # 80008648 <syscalls+0x1b0>
    8000310a:	00003097          	auipc	ra,0x3
    8000310e:	be8080e7          	jalr	-1048(ra) # 80005cf2 <panic>
      panic("dirlookup read");
    80003112:	00005517          	auipc	a0,0x5
    80003116:	54e50513          	addi	a0,a0,1358 # 80008660 <syscalls+0x1c8>
    8000311a:	00003097          	auipc	ra,0x3
    8000311e:	bd8080e7          	jalr	-1064(ra) # 80005cf2 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003122:	24c1                	addiw	s1,s1,16
    80003124:	04c92783          	lw	a5,76(s2)
    80003128:	04f4f763          	bgeu	s1,a5,80003176 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000312c:	4741                	li	a4,16
    8000312e:	86a6                	mv	a3,s1
    80003130:	fc040613          	addi	a2,s0,-64
    80003134:	4581                	li	a1,0
    80003136:	854a                	mv	a0,s2
    80003138:	00000097          	auipc	ra,0x0
    8000313c:	d70080e7          	jalr	-656(ra) # 80002ea8 <readi>
    80003140:	47c1                	li	a5,16
    80003142:	fcf518e3          	bne	a0,a5,80003112 <dirlookup+0x3a>
    if(de.inum == 0)
    80003146:	fc045783          	lhu	a5,-64(s0)
    8000314a:	dfe1                	beqz	a5,80003122 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    8000314c:	fc240593          	addi	a1,s0,-62
    80003150:	854e                	mv	a0,s3
    80003152:	00000097          	auipc	ra,0x0
    80003156:	f6c080e7          	jalr	-148(ra) # 800030be <namecmp>
    8000315a:	f561                	bnez	a0,80003122 <dirlookup+0x4a>
      if(poff)
    8000315c:	000a0463          	beqz	s4,80003164 <dirlookup+0x8c>
        *poff = off;
    80003160:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003164:	fc045583          	lhu	a1,-64(s0)
    80003168:	00092503          	lw	a0,0(s2)
    8000316c:	fffff097          	auipc	ra,0xfffff
    80003170:	750080e7          	jalr	1872(ra) # 800028bc <iget>
    80003174:	a011                	j	80003178 <dirlookup+0xa0>
  return 0;
    80003176:	4501                	li	a0,0
}
    80003178:	70e2                	ld	ra,56(sp)
    8000317a:	7442                	ld	s0,48(sp)
    8000317c:	74a2                	ld	s1,40(sp)
    8000317e:	7902                	ld	s2,32(sp)
    80003180:	69e2                	ld	s3,24(sp)
    80003182:	6a42                	ld	s4,16(sp)
    80003184:	6121                	addi	sp,sp,64
    80003186:	8082                	ret

0000000080003188 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003188:	711d                	addi	sp,sp,-96
    8000318a:	ec86                	sd	ra,88(sp)
    8000318c:	e8a2                	sd	s0,80(sp)
    8000318e:	e4a6                	sd	s1,72(sp)
    80003190:	e0ca                	sd	s2,64(sp)
    80003192:	fc4e                	sd	s3,56(sp)
    80003194:	f852                	sd	s4,48(sp)
    80003196:	f456                	sd	s5,40(sp)
    80003198:	f05a                	sd	s6,32(sp)
    8000319a:	ec5e                	sd	s7,24(sp)
    8000319c:	e862                	sd	s8,16(sp)
    8000319e:	e466                	sd	s9,8(sp)
    800031a0:	1080                	addi	s0,sp,96
    800031a2:	84aa                	mv	s1,a0
    800031a4:	8b2e                	mv	s6,a1
    800031a6:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800031a8:	00054703          	lbu	a4,0(a0)
    800031ac:	02f00793          	li	a5,47
    800031b0:	02f70363          	beq	a4,a5,800031d6 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800031b4:	ffffe097          	auipc	ra,0xffffe
    800031b8:	cc8080e7          	jalr	-824(ra) # 80000e7c <myproc>
    800031bc:	15053503          	ld	a0,336(a0)
    800031c0:	00000097          	auipc	ra,0x0
    800031c4:	9f6080e7          	jalr	-1546(ra) # 80002bb6 <idup>
    800031c8:	89aa                	mv	s3,a0
  while(*path == '/')
    800031ca:	02f00913          	li	s2,47
  len = path - s;
    800031ce:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    800031d0:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800031d2:	4c05                	li	s8,1
    800031d4:	a865                	j	8000328c <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    800031d6:	4585                	li	a1,1
    800031d8:	4505                	li	a0,1
    800031da:	fffff097          	auipc	ra,0xfffff
    800031de:	6e2080e7          	jalr	1762(ra) # 800028bc <iget>
    800031e2:	89aa                	mv	s3,a0
    800031e4:	b7dd                	j	800031ca <namex+0x42>
      iunlockput(ip);
    800031e6:	854e                	mv	a0,s3
    800031e8:	00000097          	auipc	ra,0x0
    800031ec:	c6e080e7          	jalr	-914(ra) # 80002e56 <iunlockput>
      return 0;
    800031f0:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800031f2:	854e                	mv	a0,s3
    800031f4:	60e6                	ld	ra,88(sp)
    800031f6:	6446                	ld	s0,80(sp)
    800031f8:	64a6                	ld	s1,72(sp)
    800031fa:	6906                	ld	s2,64(sp)
    800031fc:	79e2                	ld	s3,56(sp)
    800031fe:	7a42                	ld	s4,48(sp)
    80003200:	7aa2                	ld	s5,40(sp)
    80003202:	7b02                	ld	s6,32(sp)
    80003204:	6be2                	ld	s7,24(sp)
    80003206:	6c42                	ld	s8,16(sp)
    80003208:	6ca2                	ld	s9,8(sp)
    8000320a:	6125                	addi	sp,sp,96
    8000320c:	8082                	ret
      iunlock(ip);
    8000320e:	854e                	mv	a0,s3
    80003210:	00000097          	auipc	ra,0x0
    80003214:	aa6080e7          	jalr	-1370(ra) # 80002cb6 <iunlock>
      return ip;
    80003218:	bfe9                	j	800031f2 <namex+0x6a>
      iunlockput(ip);
    8000321a:	854e                	mv	a0,s3
    8000321c:	00000097          	auipc	ra,0x0
    80003220:	c3a080e7          	jalr	-966(ra) # 80002e56 <iunlockput>
      return 0;
    80003224:	89d2                	mv	s3,s4
    80003226:	b7f1                	j	800031f2 <namex+0x6a>
  len = path - s;
    80003228:	40b48633          	sub	a2,s1,a1
    8000322c:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    80003230:	094cd463          	bge	s9,s4,800032b8 <namex+0x130>
    memmove(name, s, DIRSIZ);
    80003234:	4639                	li	a2,14
    80003236:	8556                	mv	a0,s5
    80003238:	ffffd097          	auipc	ra,0xffffd
    8000323c:	fc4080e7          	jalr	-60(ra) # 800001fc <memmove>
  while(*path == '/')
    80003240:	0004c783          	lbu	a5,0(s1)
    80003244:	01279763          	bne	a5,s2,80003252 <namex+0xca>
    path++;
    80003248:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000324a:	0004c783          	lbu	a5,0(s1)
    8000324e:	ff278de3          	beq	a5,s2,80003248 <namex+0xc0>
    ilock(ip);
    80003252:	854e                	mv	a0,s3
    80003254:	00000097          	auipc	ra,0x0
    80003258:	9a0080e7          	jalr	-1632(ra) # 80002bf4 <ilock>
    if(ip->type != T_DIR){
    8000325c:	04499783          	lh	a5,68(s3)
    80003260:	f98793e3          	bne	a5,s8,800031e6 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    80003264:	000b0563          	beqz	s6,8000326e <namex+0xe6>
    80003268:	0004c783          	lbu	a5,0(s1)
    8000326c:	d3cd                	beqz	a5,8000320e <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    8000326e:	865e                	mv	a2,s7
    80003270:	85d6                	mv	a1,s5
    80003272:	854e                	mv	a0,s3
    80003274:	00000097          	auipc	ra,0x0
    80003278:	e64080e7          	jalr	-412(ra) # 800030d8 <dirlookup>
    8000327c:	8a2a                	mv	s4,a0
    8000327e:	dd51                	beqz	a0,8000321a <namex+0x92>
    iunlockput(ip);
    80003280:	854e                	mv	a0,s3
    80003282:	00000097          	auipc	ra,0x0
    80003286:	bd4080e7          	jalr	-1068(ra) # 80002e56 <iunlockput>
    ip = next;
    8000328a:	89d2                	mv	s3,s4
  while(*path == '/')
    8000328c:	0004c783          	lbu	a5,0(s1)
    80003290:	05279763          	bne	a5,s2,800032de <namex+0x156>
    path++;
    80003294:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003296:	0004c783          	lbu	a5,0(s1)
    8000329a:	ff278de3          	beq	a5,s2,80003294 <namex+0x10c>
  if(*path == 0)
    8000329e:	c79d                	beqz	a5,800032cc <namex+0x144>
    path++;
    800032a0:	85a6                	mv	a1,s1
  len = path - s;
    800032a2:	8a5e                	mv	s4,s7
    800032a4:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    800032a6:	01278963          	beq	a5,s2,800032b8 <namex+0x130>
    800032aa:	dfbd                	beqz	a5,80003228 <namex+0xa0>
    path++;
    800032ac:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    800032ae:	0004c783          	lbu	a5,0(s1)
    800032b2:	ff279ce3          	bne	a5,s2,800032aa <namex+0x122>
    800032b6:	bf8d                	j	80003228 <namex+0xa0>
    memmove(name, s, len);
    800032b8:	2601                	sext.w	a2,a2
    800032ba:	8556                	mv	a0,s5
    800032bc:	ffffd097          	auipc	ra,0xffffd
    800032c0:	f40080e7          	jalr	-192(ra) # 800001fc <memmove>
    name[len] = 0;
    800032c4:	9a56                	add	s4,s4,s5
    800032c6:	000a0023          	sb	zero,0(s4)
    800032ca:	bf9d                	j	80003240 <namex+0xb8>
  if(nameiparent){
    800032cc:	f20b03e3          	beqz	s6,800031f2 <namex+0x6a>
    iput(ip);
    800032d0:	854e                	mv	a0,s3
    800032d2:	00000097          	auipc	ra,0x0
    800032d6:	adc080e7          	jalr	-1316(ra) # 80002dae <iput>
    return 0;
    800032da:	4981                	li	s3,0
    800032dc:	bf19                	j	800031f2 <namex+0x6a>
  if(*path == 0)
    800032de:	d7fd                	beqz	a5,800032cc <namex+0x144>
  while(*path != '/' && *path != 0)
    800032e0:	0004c783          	lbu	a5,0(s1)
    800032e4:	85a6                	mv	a1,s1
    800032e6:	b7d1                	j	800032aa <namex+0x122>

00000000800032e8 <dirlink>:
{
    800032e8:	7139                	addi	sp,sp,-64
    800032ea:	fc06                	sd	ra,56(sp)
    800032ec:	f822                	sd	s0,48(sp)
    800032ee:	f426                	sd	s1,40(sp)
    800032f0:	f04a                	sd	s2,32(sp)
    800032f2:	ec4e                	sd	s3,24(sp)
    800032f4:	e852                	sd	s4,16(sp)
    800032f6:	0080                	addi	s0,sp,64
    800032f8:	892a                	mv	s2,a0
    800032fa:	8a2e                	mv	s4,a1
    800032fc:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800032fe:	4601                	li	a2,0
    80003300:	00000097          	auipc	ra,0x0
    80003304:	dd8080e7          	jalr	-552(ra) # 800030d8 <dirlookup>
    80003308:	e93d                	bnez	a0,8000337e <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000330a:	04c92483          	lw	s1,76(s2)
    8000330e:	c49d                	beqz	s1,8000333c <dirlink+0x54>
    80003310:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003312:	4741                	li	a4,16
    80003314:	86a6                	mv	a3,s1
    80003316:	fc040613          	addi	a2,s0,-64
    8000331a:	4581                	li	a1,0
    8000331c:	854a                	mv	a0,s2
    8000331e:	00000097          	auipc	ra,0x0
    80003322:	b8a080e7          	jalr	-1142(ra) # 80002ea8 <readi>
    80003326:	47c1                	li	a5,16
    80003328:	06f51163          	bne	a0,a5,8000338a <dirlink+0xa2>
    if(de.inum == 0)
    8000332c:	fc045783          	lhu	a5,-64(s0)
    80003330:	c791                	beqz	a5,8000333c <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003332:	24c1                	addiw	s1,s1,16
    80003334:	04c92783          	lw	a5,76(s2)
    80003338:	fcf4ede3          	bltu	s1,a5,80003312 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    8000333c:	4639                	li	a2,14
    8000333e:	85d2                	mv	a1,s4
    80003340:	fc240513          	addi	a0,s0,-62
    80003344:	ffffd097          	auipc	ra,0xffffd
    80003348:	f6c080e7          	jalr	-148(ra) # 800002b0 <strncpy>
  de.inum = inum;
    8000334c:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003350:	4741                	li	a4,16
    80003352:	86a6                	mv	a3,s1
    80003354:	fc040613          	addi	a2,s0,-64
    80003358:	4581                	li	a1,0
    8000335a:	854a                	mv	a0,s2
    8000335c:	00000097          	auipc	ra,0x0
    80003360:	c44080e7          	jalr	-956(ra) # 80002fa0 <writei>
    80003364:	1541                	addi	a0,a0,-16
    80003366:	00a03533          	snez	a0,a0
    8000336a:	40a00533          	neg	a0,a0
}
    8000336e:	70e2                	ld	ra,56(sp)
    80003370:	7442                	ld	s0,48(sp)
    80003372:	74a2                	ld	s1,40(sp)
    80003374:	7902                	ld	s2,32(sp)
    80003376:	69e2                	ld	s3,24(sp)
    80003378:	6a42                	ld	s4,16(sp)
    8000337a:	6121                	addi	sp,sp,64
    8000337c:	8082                	ret
    iput(ip);
    8000337e:	00000097          	auipc	ra,0x0
    80003382:	a30080e7          	jalr	-1488(ra) # 80002dae <iput>
    return -1;
    80003386:	557d                	li	a0,-1
    80003388:	b7dd                	j	8000336e <dirlink+0x86>
      panic("dirlink read");
    8000338a:	00005517          	auipc	a0,0x5
    8000338e:	2e650513          	addi	a0,a0,742 # 80008670 <syscalls+0x1d8>
    80003392:	00003097          	auipc	ra,0x3
    80003396:	960080e7          	jalr	-1696(ra) # 80005cf2 <panic>

000000008000339a <namei>:

struct inode*
namei(char *path)
{
    8000339a:	1101                	addi	sp,sp,-32
    8000339c:	ec06                	sd	ra,24(sp)
    8000339e:	e822                	sd	s0,16(sp)
    800033a0:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800033a2:	fe040613          	addi	a2,s0,-32
    800033a6:	4581                	li	a1,0
    800033a8:	00000097          	auipc	ra,0x0
    800033ac:	de0080e7          	jalr	-544(ra) # 80003188 <namex>
}
    800033b0:	60e2                	ld	ra,24(sp)
    800033b2:	6442                	ld	s0,16(sp)
    800033b4:	6105                	addi	sp,sp,32
    800033b6:	8082                	ret

00000000800033b8 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800033b8:	1141                	addi	sp,sp,-16
    800033ba:	e406                	sd	ra,8(sp)
    800033bc:	e022                	sd	s0,0(sp)
    800033be:	0800                	addi	s0,sp,16
    800033c0:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800033c2:	4585                	li	a1,1
    800033c4:	00000097          	auipc	ra,0x0
    800033c8:	dc4080e7          	jalr	-572(ra) # 80003188 <namex>
}
    800033cc:	60a2                	ld	ra,8(sp)
    800033ce:	6402                	ld	s0,0(sp)
    800033d0:	0141                	addi	sp,sp,16
    800033d2:	8082                	ret

00000000800033d4 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800033d4:	1101                	addi	sp,sp,-32
    800033d6:	ec06                	sd	ra,24(sp)
    800033d8:	e822                	sd	s0,16(sp)
    800033da:	e426                	sd	s1,8(sp)
    800033dc:	e04a                	sd	s2,0(sp)
    800033de:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800033e0:	00015917          	auipc	s2,0x15
    800033e4:	6b090913          	addi	s2,s2,1712 # 80018a90 <log>
    800033e8:	01892583          	lw	a1,24(s2)
    800033ec:	02892503          	lw	a0,40(s2)
    800033f0:	fffff097          	auipc	ra,0xfffff
    800033f4:	fea080e7          	jalr	-22(ra) # 800023da <bread>
    800033f8:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800033fa:	02c92683          	lw	a3,44(s2)
    800033fe:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003400:	02d05763          	blez	a3,8000342e <write_head+0x5a>
    80003404:	00015797          	auipc	a5,0x15
    80003408:	6bc78793          	addi	a5,a5,1724 # 80018ac0 <log+0x30>
    8000340c:	05c50713          	addi	a4,a0,92
    80003410:	36fd                	addiw	a3,a3,-1
    80003412:	1682                	slli	a3,a3,0x20
    80003414:	9281                	srli	a3,a3,0x20
    80003416:	068a                	slli	a3,a3,0x2
    80003418:	00015617          	auipc	a2,0x15
    8000341c:	6ac60613          	addi	a2,a2,1708 # 80018ac4 <log+0x34>
    80003420:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003422:	4390                	lw	a2,0(a5)
    80003424:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003426:	0791                	addi	a5,a5,4
    80003428:	0711                	addi	a4,a4,4
    8000342a:	fed79ce3          	bne	a5,a3,80003422 <write_head+0x4e>
  }
  bwrite(buf);
    8000342e:	8526                	mv	a0,s1
    80003430:	fffff097          	auipc	ra,0xfffff
    80003434:	09c080e7          	jalr	156(ra) # 800024cc <bwrite>
  brelse(buf);
    80003438:	8526                	mv	a0,s1
    8000343a:	fffff097          	auipc	ra,0xfffff
    8000343e:	0d0080e7          	jalr	208(ra) # 8000250a <brelse>
}
    80003442:	60e2                	ld	ra,24(sp)
    80003444:	6442                	ld	s0,16(sp)
    80003446:	64a2                	ld	s1,8(sp)
    80003448:	6902                	ld	s2,0(sp)
    8000344a:	6105                	addi	sp,sp,32
    8000344c:	8082                	ret

000000008000344e <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000344e:	00015797          	auipc	a5,0x15
    80003452:	66e7a783          	lw	a5,1646(a5) # 80018abc <log+0x2c>
    80003456:	0af05d63          	blez	a5,80003510 <install_trans+0xc2>
{
    8000345a:	7139                	addi	sp,sp,-64
    8000345c:	fc06                	sd	ra,56(sp)
    8000345e:	f822                	sd	s0,48(sp)
    80003460:	f426                	sd	s1,40(sp)
    80003462:	f04a                	sd	s2,32(sp)
    80003464:	ec4e                	sd	s3,24(sp)
    80003466:	e852                	sd	s4,16(sp)
    80003468:	e456                	sd	s5,8(sp)
    8000346a:	e05a                	sd	s6,0(sp)
    8000346c:	0080                	addi	s0,sp,64
    8000346e:	8b2a                	mv	s6,a0
    80003470:	00015a97          	auipc	s5,0x15
    80003474:	650a8a93          	addi	s5,s5,1616 # 80018ac0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003478:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000347a:	00015997          	auipc	s3,0x15
    8000347e:	61698993          	addi	s3,s3,1558 # 80018a90 <log>
    80003482:	a035                	j	800034ae <install_trans+0x60>
      bunpin(dbuf);
    80003484:	8526                	mv	a0,s1
    80003486:	fffff097          	auipc	ra,0xfffff
    8000348a:	15e080e7          	jalr	350(ra) # 800025e4 <bunpin>
    brelse(lbuf);
    8000348e:	854a                	mv	a0,s2
    80003490:	fffff097          	auipc	ra,0xfffff
    80003494:	07a080e7          	jalr	122(ra) # 8000250a <brelse>
    brelse(dbuf);
    80003498:	8526                	mv	a0,s1
    8000349a:	fffff097          	auipc	ra,0xfffff
    8000349e:	070080e7          	jalr	112(ra) # 8000250a <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800034a2:	2a05                	addiw	s4,s4,1
    800034a4:	0a91                	addi	s5,s5,4
    800034a6:	02c9a783          	lw	a5,44(s3)
    800034aa:	04fa5963          	bge	s4,a5,800034fc <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800034ae:	0189a583          	lw	a1,24(s3)
    800034b2:	014585bb          	addw	a1,a1,s4
    800034b6:	2585                	addiw	a1,a1,1
    800034b8:	0289a503          	lw	a0,40(s3)
    800034bc:	fffff097          	auipc	ra,0xfffff
    800034c0:	f1e080e7          	jalr	-226(ra) # 800023da <bread>
    800034c4:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800034c6:	000aa583          	lw	a1,0(s5)
    800034ca:	0289a503          	lw	a0,40(s3)
    800034ce:	fffff097          	auipc	ra,0xfffff
    800034d2:	f0c080e7          	jalr	-244(ra) # 800023da <bread>
    800034d6:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800034d8:	40000613          	li	a2,1024
    800034dc:	05890593          	addi	a1,s2,88
    800034e0:	05850513          	addi	a0,a0,88
    800034e4:	ffffd097          	auipc	ra,0xffffd
    800034e8:	d18080e7          	jalr	-744(ra) # 800001fc <memmove>
    bwrite(dbuf);  // write dst to disk
    800034ec:	8526                	mv	a0,s1
    800034ee:	fffff097          	auipc	ra,0xfffff
    800034f2:	fde080e7          	jalr	-34(ra) # 800024cc <bwrite>
    if(recovering == 0)
    800034f6:	f80b1ce3          	bnez	s6,8000348e <install_trans+0x40>
    800034fa:	b769                	j	80003484 <install_trans+0x36>
}
    800034fc:	70e2                	ld	ra,56(sp)
    800034fe:	7442                	ld	s0,48(sp)
    80003500:	74a2                	ld	s1,40(sp)
    80003502:	7902                	ld	s2,32(sp)
    80003504:	69e2                	ld	s3,24(sp)
    80003506:	6a42                	ld	s4,16(sp)
    80003508:	6aa2                	ld	s5,8(sp)
    8000350a:	6b02                	ld	s6,0(sp)
    8000350c:	6121                	addi	sp,sp,64
    8000350e:	8082                	ret
    80003510:	8082                	ret

0000000080003512 <initlog>:
{
    80003512:	7179                	addi	sp,sp,-48
    80003514:	f406                	sd	ra,40(sp)
    80003516:	f022                	sd	s0,32(sp)
    80003518:	ec26                	sd	s1,24(sp)
    8000351a:	e84a                	sd	s2,16(sp)
    8000351c:	e44e                	sd	s3,8(sp)
    8000351e:	1800                	addi	s0,sp,48
    80003520:	892a                	mv	s2,a0
    80003522:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003524:	00015497          	auipc	s1,0x15
    80003528:	56c48493          	addi	s1,s1,1388 # 80018a90 <log>
    8000352c:	00005597          	auipc	a1,0x5
    80003530:	15458593          	addi	a1,a1,340 # 80008680 <syscalls+0x1e8>
    80003534:	8526                	mv	a0,s1
    80003536:	00003097          	auipc	ra,0x3
    8000353a:	c76080e7          	jalr	-906(ra) # 800061ac <initlock>
  log.start = sb->logstart;
    8000353e:	0149a583          	lw	a1,20(s3)
    80003542:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003544:	0109a783          	lw	a5,16(s3)
    80003548:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000354a:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000354e:	854a                	mv	a0,s2
    80003550:	fffff097          	auipc	ra,0xfffff
    80003554:	e8a080e7          	jalr	-374(ra) # 800023da <bread>
  log.lh.n = lh->n;
    80003558:	4d3c                	lw	a5,88(a0)
    8000355a:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000355c:	02f05563          	blez	a5,80003586 <initlog+0x74>
    80003560:	05c50713          	addi	a4,a0,92
    80003564:	00015697          	auipc	a3,0x15
    80003568:	55c68693          	addi	a3,a3,1372 # 80018ac0 <log+0x30>
    8000356c:	37fd                	addiw	a5,a5,-1
    8000356e:	1782                	slli	a5,a5,0x20
    80003570:	9381                	srli	a5,a5,0x20
    80003572:	078a                	slli	a5,a5,0x2
    80003574:	06050613          	addi	a2,a0,96
    80003578:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    8000357a:	4310                	lw	a2,0(a4)
    8000357c:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    8000357e:	0711                	addi	a4,a4,4
    80003580:	0691                	addi	a3,a3,4
    80003582:	fef71ce3          	bne	a4,a5,8000357a <initlog+0x68>
  brelse(buf);
    80003586:	fffff097          	auipc	ra,0xfffff
    8000358a:	f84080e7          	jalr	-124(ra) # 8000250a <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000358e:	4505                	li	a0,1
    80003590:	00000097          	auipc	ra,0x0
    80003594:	ebe080e7          	jalr	-322(ra) # 8000344e <install_trans>
  log.lh.n = 0;
    80003598:	00015797          	auipc	a5,0x15
    8000359c:	5207a223          	sw	zero,1316(a5) # 80018abc <log+0x2c>
  write_head(); // clear the log
    800035a0:	00000097          	auipc	ra,0x0
    800035a4:	e34080e7          	jalr	-460(ra) # 800033d4 <write_head>
}
    800035a8:	70a2                	ld	ra,40(sp)
    800035aa:	7402                	ld	s0,32(sp)
    800035ac:	64e2                	ld	s1,24(sp)
    800035ae:	6942                	ld	s2,16(sp)
    800035b0:	69a2                	ld	s3,8(sp)
    800035b2:	6145                	addi	sp,sp,48
    800035b4:	8082                	ret

00000000800035b6 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800035b6:	1101                	addi	sp,sp,-32
    800035b8:	ec06                	sd	ra,24(sp)
    800035ba:	e822                	sd	s0,16(sp)
    800035bc:	e426                	sd	s1,8(sp)
    800035be:	e04a                	sd	s2,0(sp)
    800035c0:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800035c2:	00015517          	auipc	a0,0x15
    800035c6:	4ce50513          	addi	a0,a0,1230 # 80018a90 <log>
    800035ca:	00003097          	auipc	ra,0x3
    800035ce:	c72080e7          	jalr	-910(ra) # 8000623c <acquire>
  while(1){
    if(log.committing){
    800035d2:	00015497          	auipc	s1,0x15
    800035d6:	4be48493          	addi	s1,s1,1214 # 80018a90 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035da:	4979                	li	s2,30
    800035dc:	a039                	j	800035ea <begin_op+0x34>
      sleep(&log, &log.lock);
    800035de:	85a6                	mv	a1,s1
    800035e0:	8526                	mv	a0,s1
    800035e2:	ffffe097          	auipc	ra,0xffffe
    800035e6:	f46080e7          	jalr	-186(ra) # 80001528 <sleep>
    if(log.committing){
    800035ea:	50dc                	lw	a5,36(s1)
    800035ec:	fbed                	bnez	a5,800035de <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035ee:	509c                	lw	a5,32(s1)
    800035f0:	0017871b          	addiw	a4,a5,1
    800035f4:	0007069b          	sext.w	a3,a4
    800035f8:	0027179b          	slliw	a5,a4,0x2
    800035fc:	9fb9                	addw	a5,a5,a4
    800035fe:	0017979b          	slliw	a5,a5,0x1
    80003602:	54d8                	lw	a4,44(s1)
    80003604:	9fb9                	addw	a5,a5,a4
    80003606:	00f95963          	bge	s2,a5,80003618 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000360a:	85a6                	mv	a1,s1
    8000360c:	8526                	mv	a0,s1
    8000360e:	ffffe097          	auipc	ra,0xffffe
    80003612:	f1a080e7          	jalr	-230(ra) # 80001528 <sleep>
    80003616:	bfd1                	j	800035ea <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003618:	00015517          	auipc	a0,0x15
    8000361c:	47850513          	addi	a0,a0,1144 # 80018a90 <log>
    80003620:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80003622:	00003097          	auipc	ra,0x3
    80003626:	cce080e7          	jalr	-818(ra) # 800062f0 <release>
      break;
    }
  }
}
    8000362a:	60e2                	ld	ra,24(sp)
    8000362c:	6442                	ld	s0,16(sp)
    8000362e:	64a2                	ld	s1,8(sp)
    80003630:	6902                	ld	s2,0(sp)
    80003632:	6105                	addi	sp,sp,32
    80003634:	8082                	ret

0000000080003636 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003636:	7139                	addi	sp,sp,-64
    80003638:	fc06                	sd	ra,56(sp)
    8000363a:	f822                	sd	s0,48(sp)
    8000363c:	f426                	sd	s1,40(sp)
    8000363e:	f04a                	sd	s2,32(sp)
    80003640:	ec4e                	sd	s3,24(sp)
    80003642:	e852                	sd	s4,16(sp)
    80003644:	e456                	sd	s5,8(sp)
    80003646:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003648:	00015497          	auipc	s1,0x15
    8000364c:	44848493          	addi	s1,s1,1096 # 80018a90 <log>
    80003650:	8526                	mv	a0,s1
    80003652:	00003097          	auipc	ra,0x3
    80003656:	bea080e7          	jalr	-1046(ra) # 8000623c <acquire>
  log.outstanding -= 1;
    8000365a:	509c                	lw	a5,32(s1)
    8000365c:	37fd                	addiw	a5,a5,-1
    8000365e:	0007891b          	sext.w	s2,a5
    80003662:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003664:	50dc                	lw	a5,36(s1)
    80003666:	efb9                	bnez	a5,800036c4 <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    80003668:	06091663          	bnez	s2,800036d4 <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    8000366c:	00015497          	auipc	s1,0x15
    80003670:	42448493          	addi	s1,s1,1060 # 80018a90 <log>
    80003674:	4785                	li	a5,1
    80003676:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003678:	8526                	mv	a0,s1
    8000367a:	00003097          	auipc	ra,0x3
    8000367e:	c76080e7          	jalr	-906(ra) # 800062f0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003682:	54dc                	lw	a5,44(s1)
    80003684:	06f04763          	bgtz	a5,800036f2 <end_op+0xbc>
    acquire(&log.lock);
    80003688:	00015497          	auipc	s1,0x15
    8000368c:	40848493          	addi	s1,s1,1032 # 80018a90 <log>
    80003690:	8526                	mv	a0,s1
    80003692:	00003097          	auipc	ra,0x3
    80003696:	baa080e7          	jalr	-1110(ra) # 8000623c <acquire>
    log.committing = 0;
    8000369a:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000369e:	8526                	mv	a0,s1
    800036a0:	ffffe097          	auipc	ra,0xffffe
    800036a4:	eec080e7          	jalr	-276(ra) # 8000158c <wakeup>
    release(&log.lock);
    800036a8:	8526                	mv	a0,s1
    800036aa:	00003097          	auipc	ra,0x3
    800036ae:	c46080e7          	jalr	-954(ra) # 800062f0 <release>
}
    800036b2:	70e2                	ld	ra,56(sp)
    800036b4:	7442                	ld	s0,48(sp)
    800036b6:	74a2                	ld	s1,40(sp)
    800036b8:	7902                	ld	s2,32(sp)
    800036ba:	69e2                	ld	s3,24(sp)
    800036bc:	6a42                	ld	s4,16(sp)
    800036be:	6aa2                	ld	s5,8(sp)
    800036c0:	6121                	addi	sp,sp,64
    800036c2:	8082                	ret
    panic("log.committing");
    800036c4:	00005517          	auipc	a0,0x5
    800036c8:	fc450513          	addi	a0,a0,-60 # 80008688 <syscalls+0x1f0>
    800036cc:	00002097          	auipc	ra,0x2
    800036d0:	626080e7          	jalr	1574(ra) # 80005cf2 <panic>
    wakeup(&log);
    800036d4:	00015497          	auipc	s1,0x15
    800036d8:	3bc48493          	addi	s1,s1,956 # 80018a90 <log>
    800036dc:	8526                	mv	a0,s1
    800036de:	ffffe097          	auipc	ra,0xffffe
    800036e2:	eae080e7          	jalr	-338(ra) # 8000158c <wakeup>
  release(&log.lock);
    800036e6:	8526                	mv	a0,s1
    800036e8:	00003097          	auipc	ra,0x3
    800036ec:	c08080e7          	jalr	-1016(ra) # 800062f0 <release>
  if(do_commit){
    800036f0:	b7c9                	j	800036b2 <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    800036f2:	00015a97          	auipc	s5,0x15
    800036f6:	3cea8a93          	addi	s5,s5,974 # 80018ac0 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800036fa:	00015a17          	auipc	s4,0x15
    800036fe:	396a0a13          	addi	s4,s4,918 # 80018a90 <log>
    80003702:	018a2583          	lw	a1,24(s4)
    80003706:	012585bb          	addw	a1,a1,s2
    8000370a:	2585                	addiw	a1,a1,1
    8000370c:	028a2503          	lw	a0,40(s4)
    80003710:	fffff097          	auipc	ra,0xfffff
    80003714:	cca080e7          	jalr	-822(ra) # 800023da <bread>
    80003718:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000371a:	000aa583          	lw	a1,0(s5)
    8000371e:	028a2503          	lw	a0,40(s4)
    80003722:	fffff097          	auipc	ra,0xfffff
    80003726:	cb8080e7          	jalr	-840(ra) # 800023da <bread>
    8000372a:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000372c:	40000613          	li	a2,1024
    80003730:	05850593          	addi	a1,a0,88
    80003734:	05848513          	addi	a0,s1,88
    80003738:	ffffd097          	auipc	ra,0xffffd
    8000373c:	ac4080e7          	jalr	-1340(ra) # 800001fc <memmove>
    bwrite(to);  // write the log
    80003740:	8526                	mv	a0,s1
    80003742:	fffff097          	auipc	ra,0xfffff
    80003746:	d8a080e7          	jalr	-630(ra) # 800024cc <bwrite>
    brelse(from);
    8000374a:	854e                	mv	a0,s3
    8000374c:	fffff097          	auipc	ra,0xfffff
    80003750:	dbe080e7          	jalr	-578(ra) # 8000250a <brelse>
    brelse(to);
    80003754:	8526                	mv	a0,s1
    80003756:	fffff097          	auipc	ra,0xfffff
    8000375a:	db4080e7          	jalr	-588(ra) # 8000250a <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000375e:	2905                	addiw	s2,s2,1
    80003760:	0a91                	addi	s5,s5,4
    80003762:	02ca2783          	lw	a5,44(s4)
    80003766:	f8f94ee3          	blt	s2,a5,80003702 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000376a:	00000097          	auipc	ra,0x0
    8000376e:	c6a080e7          	jalr	-918(ra) # 800033d4 <write_head>
    install_trans(0); // Now install writes to home locations
    80003772:	4501                	li	a0,0
    80003774:	00000097          	auipc	ra,0x0
    80003778:	cda080e7          	jalr	-806(ra) # 8000344e <install_trans>
    log.lh.n = 0;
    8000377c:	00015797          	auipc	a5,0x15
    80003780:	3407a023          	sw	zero,832(a5) # 80018abc <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003784:	00000097          	auipc	ra,0x0
    80003788:	c50080e7          	jalr	-944(ra) # 800033d4 <write_head>
    8000378c:	bdf5                	j	80003688 <end_op+0x52>

000000008000378e <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000378e:	1101                	addi	sp,sp,-32
    80003790:	ec06                	sd	ra,24(sp)
    80003792:	e822                	sd	s0,16(sp)
    80003794:	e426                	sd	s1,8(sp)
    80003796:	e04a                	sd	s2,0(sp)
    80003798:	1000                	addi	s0,sp,32
    8000379a:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000379c:	00015917          	auipc	s2,0x15
    800037a0:	2f490913          	addi	s2,s2,756 # 80018a90 <log>
    800037a4:	854a                	mv	a0,s2
    800037a6:	00003097          	auipc	ra,0x3
    800037aa:	a96080e7          	jalr	-1386(ra) # 8000623c <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800037ae:	02c92603          	lw	a2,44(s2)
    800037b2:	47f5                	li	a5,29
    800037b4:	06c7c563          	blt	a5,a2,8000381e <log_write+0x90>
    800037b8:	00015797          	auipc	a5,0x15
    800037bc:	2f47a783          	lw	a5,756(a5) # 80018aac <log+0x1c>
    800037c0:	37fd                	addiw	a5,a5,-1
    800037c2:	04f65e63          	bge	a2,a5,8000381e <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800037c6:	00015797          	auipc	a5,0x15
    800037ca:	2ea7a783          	lw	a5,746(a5) # 80018ab0 <log+0x20>
    800037ce:	06f05063          	blez	a5,8000382e <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800037d2:	4781                	li	a5,0
    800037d4:	06c05563          	blez	a2,8000383e <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037d8:	44cc                	lw	a1,12(s1)
    800037da:	00015717          	auipc	a4,0x15
    800037de:	2e670713          	addi	a4,a4,742 # 80018ac0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800037e2:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037e4:	4314                	lw	a3,0(a4)
    800037e6:	04b68c63          	beq	a3,a1,8000383e <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800037ea:	2785                	addiw	a5,a5,1
    800037ec:	0711                	addi	a4,a4,4
    800037ee:	fef61be3          	bne	a2,a5,800037e4 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800037f2:	0621                	addi	a2,a2,8
    800037f4:	060a                	slli	a2,a2,0x2
    800037f6:	00015797          	auipc	a5,0x15
    800037fa:	29a78793          	addi	a5,a5,666 # 80018a90 <log>
    800037fe:	963e                	add	a2,a2,a5
    80003800:	44dc                	lw	a5,12(s1)
    80003802:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003804:	8526                	mv	a0,s1
    80003806:	fffff097          	auipc	ra,0xfffff
    8000380a:	da2080e7          	jalr	-606(ra) # 800025a8 <bpin>
    log.lh.n++;
    8000380e:	00015717          	auipc	a4,0x15
    80003812:	28270713          	addi	a4,a4,642 # 80018a90 <log>
    80003816:	575c                	lw	a5,44(a4)
    80003818:	2785                	addiw	a5,a5,1
    8000381a:	d75c                	sw	a5,44(a4)
    8000381c:	a835                	j	80003858 <log_write+0xca>
    panic("too big a transaction");
    8000381e:	00005517          	auipc	a0,0x5
    80003822:	e7a50513          	addi	a0,a0,-390 # 80008698 <syscalls+0x200>
    80003826:	00002097          	auipc	ra,0x2
    8000382a:	4cc080e7          	jalr	1228(ra) # 80005cf2 <panic>
    panic("log_write outside of trans");
    8000382e:	00005517          	auipc	a0,0x5
    80003832:	e8250513          	addi	a0,a0,-382 # 800086b0 <syscalls+0x218>
    80003836:	00002097          	auipc	ra,0x2
    8000383a:	4bc080e7          	jalr	1212(ra) # 80005cf2 <panic>
  log.lh.block[i] = b->blockno;
    8000383e:	00878713          	addi	a4,a5,8
    80003842:	00271693          	slli	a3,a4,0x2
    80003846:	00015717          	auipc	a4,0x15
    8000384a:	24a70713          	addi	a4,a4,586 # 80018a90 <log>
    8000384e:	9736                	add	a4,a4,a3
    80003850:	44d4                	lw	a3,12(s1)
    80003852:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003854:	faf608e3          	beq	a2,a5,80003804 <log_write+0x76>
  }
  release(&log.lock);
    80003858:	00015517          	auipc	a0,0x15
    8000385c:	23850513          	addi	a0,a0,568 # 80018a90 <log>
    80003860:	00003097          	auipc	ra,0x3
    80003864:	a90080e7          	jalr	-1392(ra) # 800062f0 <release>
}
    80003868:	60e2                	ld	ra,24(sp)
    8000386a:	6442                	ld	s0,16(sp)
    8000386c:	64a2                	ld	s1,8(sp)
    8000386e:	6902                	ld	s2,0(sp)
    80003870:	6105                	addi	sp,sp,32
    80003872:	8082                	ret

0000000080003874 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003874:	1101                	addi	sp,sp,-32
    80003876:	ec06                	sd	ra,24(sp)
    80003878:	e822                	sd	s0,16(sp)
    8000387a:	e426                	sd	s1,8(sp)
    8000387c:	e04a                	sd	s2,0(sp)
    8000387e:	1000                	addi	s0,sp,32
    80003880:	84aa                	mv	s1,a0
    80003882:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003884:	00005597          	auipc	a1,0x5
    80003888:	e4c58593          	addi	a1,a1,-436 # 800086d0 <syscalls+0x238>
    8000388c:	0521                	addi	a0,a0,8
    8000388e:	00003097          	auipc	ra,0x3
    80003892:	91e080e7          	jalr	-1762(ra) # 800061ac <initlock>
  lk->name = name;
    80003896:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000389a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000389e:	0204a423          	sw	zero,40(s1)
}
    800038a2:	60e2                	ld	ra,24(sp)
    800038a4:	6442                	ld	s0,16(sp)
    800038a6:	64a2                	ld	s1,8(sp)
    800038a8:	6902                	ld	s2,0(sp)
    800038aa:	6105                	addi	sp,sp,32
    800038ac:	8082                	ret

00000000800038ae <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800038ae:	1101                	addi	sp,sp,-32
    800038b0:	ec06                	sd	ra,24(sp)
    800038b2:	e822                	sd	s0,16(sp)
    800038b4:	e426                	sd	s1,8(sp)
    800038b6:	e04a                	sd	s2,0(sp)
    800038b8:	1000                	addi	s0,sp,32
    800038ba:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800038bc:	00850913          	addi	s2,a0,8
    800038c0:	854a                	mv	a0,s2
    800038c2:	00003097          	auipc	ra,0x3
    800038c6:	97a080e7          	jalr	-1670(ra) # 8000623c <acquire>
  while (lk->locked) {
    800038ca:	409c                	lw	a5,0(s1)
    800038cc:	cb89                	beqz	a5,800038de <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800038ce:	85ca                	mv	a1,s2
    800038d0:	8526                	mv	a0,s1
    800038d2:	ffffe097          	auipc	ra,0xffffe
    800038d6:	c56080e7          	jalr	-938(ra) # 80001528 <sleep>
  while (lk->locked) {
    800038da:	409c                	lw	a5,0(s1)
    800038dc:	fbed                	bnez	a5,800038ce <acquiresleep+0x20>
  }
  lk->locked = 1;
    800038de:	4785                	li	a5,1
    800038e0:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800038e2:	ffffd097          	auipc	ra,0xffffd
    800038e6:	59a080e7          	jalr	1434(ra) # 80000e7c <myproc>
    800038ea:	591c                	lw	a5,48(a0)
    800038ec:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800038ee:	854a                	mv	a0,s2
    800038f0:	00003097          	auipc	ra,0x3
    800038f4:	a00080e7          	jalr	-1536(ra) # 800062f0 <release>
}
    800038f8:	60e2                	ld	ra,24(sp)
    800038fa:	6442                	ld	s0,16(sp)
    800038fc:	64a2                	ld	s1,8(sp)
    800038fe:	6902                	ld	s2,0(sp)
    80003900:	6105                	addi	sp,sp,32
    80003902:	8082                	ret

0000000080003904 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003904:	1101                	addi	sp,sp,-32
    80003906:	ec06                	sd	ra,24(sp)
    80003908:	e822                	sd	s0,16(sp)
    8000390a:	e426                	sd	s1,8(sp)
    8000390c:	e04a                	sd	s2,0(sp)
    8000390e:	1000                	addi	s0,sp,32
    80003910:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003912:	00850913          	addi	s2,a0,8
    80003916:	854a                	mv	a0,s2
    80003918:	00003097          	auipc	ra,0x3
    8000391c:	924080e7          	jalr	-1756(ra) # 8000623c <acquire>
  lk->locked = 0;
    80003920:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003924:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003928:	8526                	mv	a0,s1
    8000392a:	ffffe097          	auipc	ra,0xffffe
    8000392e:	c62080e7          	jalr	-926(ra) # 8000158c <wakeup>
  release(&lk->lk);
    80003932:	854a                	mv	a0,s2
    80003934:	00003097          	auipc	ra,0x3
    80003938:	9bc080e7          	jalr	-1604(ra) # 800062f0 <release>
}
    8000393c:	60e2                	ld	ra,24(sp)
    8000393e:	6442                	ld	s0,16(sp)
    80003940:	64a2                	ld	s1,8(sp)
    80003942:	6902                	ld	s2,0(sp)
    80003944:	6105                	addi	sp,sp,32
    80003946:	8082                	ret

0000000080003948 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003948:	7179                	addi	sp,sp,-48
    8000394a:	f406                	sd	ra,40(sp)
    8000394c:	f022                	sd	s0,32(sp)
    8000394e:	ec26                	sd	s1,24(sp)
    80003950:	e84a                	sd	s2,16(sp)
    80003952:	e44e                	sd	s3,8(sp)
    80003954:	1800                	addi	s0,sp,48
    80003956:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003958:	00850913          	addi	s2,a0,8
    8000395c:	854a                	mv	a0,s2
    8000395e:	00003097          	auipc	ra,0x3
    80003962:	8de080e7          	jalr	-1826(ra) # 8000623c <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003966:	409c                	lw	a5,0(s1)
    80003968:	ef99                	bnez	a5,80003986 <holdingsleep+0x3e>
    8000396a:	4481                	li	s1,0
  release(&lk->lk);
    8000396c:	854a                	mv	a0,s2
    8000396e:	00003097          	auipc	ra,0x3
    80003972:	982080e7          	jalr	-1662(ra) # 800062f0 <release>
  return r;
}
    80003976:	8526                	mv	a0,s1
    80003978:	70a2                	ld	ra,40(sp)
    8000397a:	7402                	ld	s0,32(sp)
    8000397c:	64e2                	ld	s1,24(sp)
    8000397e:	6942                	ld	s2,16(sp)
    80003980:	69a2                	ld	s3,8(sp)
    80003982:	6145                	addi	sp,sp,48
    80003984:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003986:	0284a983          	lw	s3,40(s1)
    8000398a:	ffffd097          	auipc	ra,0xffffd
    8000398e:	4f2080e7          	jalr	1266(ra) # 80000e7c <myproc>
    80003992:	5904                	lw	s1,48(a0)
    80003994:	413484b3          	sub	s1,s1,s3
    80003998:	0014b493          	seqz	s1,s1
    8000399c:	bfc1                	j	8000396c <holdingsleep+0x24>

000000008000399e <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    8000399e:	1141                	addi	sp,sp,-16
    800039a0:	e406                	sd	ra,8(sp)
    800039a2:	e022                	sd	s0,0(sp)
    800039a4:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800039a6:	00005597          	auipc	a1,0x5
    800039aa:	d3a58593          	addi	a1,a1,-710 # 800086e0 <syscalls+0x248>
    800039ae:	00015517          	auipc	a0,0x15
    800039b2:	22a50513          	addi	a0,a0,554 # 80018bd8 <ftable>
    800039b6:	00002097          	auipc	ra,0x2
    800039ba:	7f6080e7          	jalr	2038(ra) # 800061ac <initlock>
}
    800039be:	60a2                	ld	ra,8(sp)
    800039c0:	6402                	ld	s0,0(sp)
    800039c2:	0141                	addi	sp,sp,16
    800039c4:	8082                	ret

00000000800039c6 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800039c6:	1101                	addi	sp,sp,-32
    800039c8:	ec06                	sd	ra,24(sp)
    800039ca:	e822                	sd	s0,16(sp)
    800039cc:	e426                	sd	s1,8(sp)
    800039ce:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800039d0:	00015517          	auipc	a0,0x15
    800039d4:	20850513          	addi	a0,a0,520 # 80018bd8 <ftable>
    800039d8:	00003097          	auipc	ra,0x3
    800039dc:	864080e7          	jalr	-1948(ra) # 8000623c <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039e0:	00015497          	auipc	s1,0x15
    800039e4:	21048493          	addi	s1,s1,528 # 80018bf0 <ftable+0x18>
    800039e8:	00016717          	auipc	a4,0x16
    800039ec:	1a870713          	addi	a4,a4,424 # 80019b90 <disk>
    if(f->ref == 0){
    800039f0:	40dc                	lw	a5,4(s1)
    800039f2:	cf99                	beqz	a5,80003a10 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039f4:	02848493          	addi	s1,s1,40
    800039f8:	fee49ce3          	bne	s1,a4,800039f0 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800039fc:	00015517          	auipc	a0,0x15
    80003a00:	1dc50513          	addi	a0,a0,476 # 80018bd8 <ftable>
    80003a04:	00003097          	auipc	ra,0x3
    80003a08:	8ec080e7          	jalr	-1812(ra) # 800062f0 <release>
  return 0;
    80003a0c:	4481                	li	s1,0
    80003a0e:	a819                	j	80003a24 <filealloc+0x5e>
      f->ref = 1;
    80003a10:	4785                	li	a5,1
    80003a12:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003a14:	00015517          	auipc	a0,0x15
    80003a18:	1c450513          	addi	a0,a0,452 # 80018bd8 <ftable>
    80003a1c:	00003097          	auipc	ra,0x3
    80003a20:	8d4080e7          	jalr	-1836(ra) # 800062f0 <release>
}
    80003a24:	8526                	mv	a0,s1
    80003a26:	60e2                	ld	ra,24(sp)
    80003a28:	6442                	ld	s0,16(sp)
    80003a2a:	64a2                	ld	s1,8(sp)
    80003a2c:	6105                	addi	sp,sp,32
    80003a2e:	8082                	ret

0000000080003a30 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003a30:	1101                	addi	sp,sp,-32
    80003a32:	ec06                	sd	ra,24(sp)
    80003a34:	e822                	sd	s0,16(sp)
    80003a36:	e426                	sd	s1,8(sp)
    80003a38:	1000                	addi	s0,sp,32
    80003a3a:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003a3c:	00015517          	auipc	a0,0x15
    80003a40:	19c50513          	addi	a0,a0,412 # 80018bd8 <ftable>
    80003a44:	00002097          	auipc	ra,0x2
    80003a48:	7f8080e7          	jalr	2040(ra) # 8000623c <acquire>
  if(f->ref < 1)
    80003a4c:	40dc                	lw	a5,4(s1)
    80003a4e:	02f05263          	blez	a5,80003a72 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003a52:	2785                	addiw	a5,a5,1
    80003a54:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003a56:	00015517          	auipc	a0,0x15
    80003a5a:	18250513          	addi	a0,a0,386 # 80018bd8 <ftable>
    80003a5e:	00003097          	auipc	ra,0x3
    80003a62:	892080e7          	jalr	-1902(ra) # 800062f0 <release>
  return f;
}
    80003a66:	8526                	mv	a0,s1
    80003a68:	60e2                	ld	ra,24(sp)
    80003a6a:	6442                	ld	s0,16(sp)
    80003a6c:	64a2                	ld	s1,8(sp)
    80003a6e:	6105                	addi	sp,sp,32
    80003a70:	8082                	ret
    panic("filedup");
    80003a72:	00005517          	auipc	a0,0x5
    80003a76:	c7650513          	addi	a0,a0,-906 # 800086e8 <syscalls+0x250>
    80003a7a:	00002097          	auipc	ra,0x2
    80003a7e:	278080e7          	jalr	632(ra) # 80005cf2 <panic>

0000000080003a82 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003a82:	7139                	addi	sp,sp,-64
    80003a84:	fc06                	sd	ra,56(sp)
    80003a86:	f822                	sd	s0,48(sp)
    80003a88:	f426                	sd	s1,40(sp)
    80003a8a:	f04a                	sd	s2,32(sp)
    80003a8c:	ec4e                	sd	s3,24(sp)
    80003a8e:	e852                	sd	s4,16(sp)
    80003a90:	e456                	sd	s5,8(sp)
    80003a92:	0080                	addi	s0,sp,64
    80003a94:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003a96:	00015517          	auipc	a0,0x15
    80003a9a:	14250513          	addi	a0,a0,322 # 80018bd8 <ftable>
    80003a9e:	00002097          	auipc	ra,0x2
    80003aa2:	79e080e7          	jalr	1950(ra) # 8000623c <acquire>
  if(f->ref < 1)
    80003aa6:	40dc                	lw	a5,4(s1)
    80003aa8:	06f05163          	blez	a5,80003b0a <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003aac:	37fd                	addiw	a5,a5,-1
    80003aae:	0007871b          	sext.w	a4,a5
    80003ab2:	c0dc                	sw	a5,4(s1)
    80003ab4:	06e04363          	bgtz	a4,80003b1a <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003ab8:	0004a903          	lw	s2,0(s1)
    80003abc:	0094ca83          	lbu	s5,9(s1)
    80003ac0:	0104ba03          	ld	s4,16(s1)
    80003ac4:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003ac8:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003acc:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003ad0:	00015517          	auipc	a0,0x15
    80003ad4:	10850513          	addi	a0,a0,264 # 80018bd8 <ftable>
    80003ad8:	00003097          	auipc	ra,0x3
    80003adc:	818080e7          	jalr	-2024(ra) # 800062f0 <release>

  if(ff.type == FD_PIPE){
    80003ae0:	4785                	li	a5,1
    80003ae2:	04f90d63          	beq	s2,a5,80003b3c <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003ae6:	3979                	addiw	s2,s2,-2
    80003ae8:	4785                	li	a5,1
    80003aea:	0527e063          	bltu	a5,s2,80003b2a <fileclose+0xa8>
    begin_op();
    80003aee:	00000097          	auipc	ra,0x0
    80003af2:	ac8080e7          	jalr	-1336(ra) # 800035b6 <begin_op>
    iput(ff.ip);
    80003af6:	854e                	mv	a0,s3
    80003af8:	fffff097          	auipc	ra,0xfffff
    80003afc:	2b6080e7          	jalr	694(ra) # 80002dae <iput>
    end_op();
    80003b00:	00000097          	auipc	ra,0x0
    80003b04:	b36080e7          	jalr	-1226(ra) # 80003636 <end_op>
    80003b08:	a00d                	j	80003b2a <fileclose+0xa8>
    panic("fileclose");
    80003b0a:	00005517          	auipc	a0,0x5
    80003b0e:	be650513          	addi	a0,a0,-1050 # 800086f0 <syscalls+0x258>
    80003b12:	00002097          	auipc	ra,0x2
    80003b16:	1e0080e7          	jalr	480(ra) # 80005cf2 <panic>
    release(&ftable.lock);
    80003b1a:	00015517          	auipc	a0,0x15
    80003b1e:	0be50513          	addi	a0,a0,190 # 80018bd8 <ftable>
    80003b22:	00002097          	auipc	ra,0x2
    80003b26:	7ce080e7          	jalr	1998(ra) # 800062f0 <release>
  }
}
    80003b2a:	70e2                	ld	ra,56(sp)
    80003b2c:	7442                	ld	s0,48(sp)
    80003b2e:	74a2                	ld	s1,40(sp)
    80003b30:	7902                	ld	s2,32(sp)
    80003b32:	69e2                	ld	s3,24(sp)
    80003b34:	6a42                	ld	s4,16(sp)
    80003b36:	6aa2                	ld	s5,8(sp)
    80003b38:	6121                	addi	sp,sp,64
    80003b3a:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003b3c:	85d6                	mv	a1,s5
    80003b3e:	8552                	mv	a0,s4
    80003b40:	00000097          	auipc	ra,0x0
    80003b44:	34c080e7          	jalr	844(ra) # 80003e8c <pipeclose>
    80003b48:	b7cd                	j	80003b2a <fileclose+0xa8>

0000000080003b4a <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003b4a:	715d                	addi	sp,sp,-80
    80003b4c:	e486                	sd	ra,72(sp)
    80003b4e:	e0a2                	sd	s0,64(sp)
    80003b50:	fc26                	sd	s1,56(sp)
    80003b52:	f84a                	sd	s2,48(sp)
    80003b54:	f44e                	sd	s3,40(sp)
    80003b56:	0880                	addi	s0,sp,80
    80003b58:	84aa                	mv	s1,a0
    80003b5a:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003b5c:	ffffd097          	auipc	ra,0xffffd
    80003b60:	320080e7          	jalr	800(ra) # 80000e7c <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003b64:	409c                	lw	a5,0(s1)
    80003b66:	37f9                	addiw	a5,a5,-2
    80003b68:	4705                	li	a4,1
    80003b6a:	04f76763          	bltu	a4,a5,80003bb8 <filestat+0x6e>
    80003b6e:	892a                	mv	s2,a0
    ilock(f->ip);
    80003b70:	6c88                	ld	a0,24(s1)
    80003b72:	fffff097          	auipc	ra,0xfffff
    80003b76:	082080e7          	jalr	130(ra) # 80002bf4 <ilock>
    stati(f->ip, &st);
    80003b7a:	fb840593          	addi	a1,s0,-72
    80003b7e:	6c88                	ld	a0,24(s1)
    80003b80:	fffff097          	auipc	ra,0xfffff
    80003b84:	2fe080e7          	jalr	766(ra) # 80002e7e <stati>
    iunlock(f->ip);
    80003b88:	6c88                	ld	a0,24(s1)
    80003b8a:	fffff097          	auipc	ra,0xfffff
    80003b8e:	12c080e7          	jalr	300(ra) # 80002cb6 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003b92:	46e1                	li	a3,24
    80003b94:	fb840613          	addi	a2,s0,-72
    80003b98:	85ce                	mv	a1,s3
    80003b9a:	05093503          	ld	a0,80(s2)
    80003b9e:	ffffd097          	auipc	ra,0xffffd
    80003ba2:	f9c080e7          	jalr	-100(ra) # 80000b3a <copyout>
    80003ba6:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003baa:	60a6                	ld	ra,72(sp)
    80003bac:	6406                	ld	s0,64(sp)
    80003bae:	74e2                	ld	s1,56(sp)
    80003bb0:	7942                	ld	s2,48(sp)
    80003bb2:	79a2                	ld	s3,40(sp)
    80003bb4:	6161                	addi	sp,sp,80
    80003bb6:	8082                	ret
  return -1;
    80003bb8:	557d                	li	a0,-1
    80003bba:	bfc5                	j	80003baa <filestat+0x60>

0000000080003bbc <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003bbc:	7179                	addi	sp,sp,-48
    80003bbe:	f406                	sd	ra,40(sp)
    80003bc0:	f022                	sd	s0,32(sp)
    80003bc2:	ec26                	sd	s1,24(sp)
    80003bc4:	e84a                	sd	s2,16(sp)
    80003bc6:	e44e                	sd	s3,8(sp)
    80003bc8:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003bca:	00854783          	lbu	a5,8(a0)
    80003bce:	c3d5                	beqz	a5,80003c72 <fileread+0xb6>
    80003bd0:	84aa                	mv	s1,a0
    80003bd2:	89ae                	mv	s3,a1
    80003bd4:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003bd6:	411c                	lw	a5,0(a0)
    80003bd8:	4705                	li	a4,1
    80003bda:	04e78963          	beq	a5,a4,80003c2c <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003bde:	470d                	li	a4,3
    80003be0:	04e78d63          	beq	a5,a4,80003c3a <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003be4:	4709                	li	a4,2
    80003be6:	06e79e63          	bne	a5,a4,80003c62 <fileread+0xa6>
    ilock(f->ip);
    80003bea:	6d08                	ld	a0,24(a0)
    80003bec:	fffff097          	auipc	ra,0xfffff
    80003bf0:	008080e7          	jalr	8(ra) # 80002bf4 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003bf4:	874a                	mv	a4,s2
    80003bf6:	5094                	lw	a3,32(s1)
    80003bf8:	864e                	mv	a2,s3
    80003bfa:	4585                	li	a1,1
    80003bfc:	6c88                	ld	a0,24(s1)
    80003bfe:	fffff097          	auipc	ra,0xfffff
    80003c02:	2aa080e7          	jalr	682(ra) # 80002ea8 <readi>
    80003c06:	892a                	mv	s2,a0
    80003c08:	00a05563          	blez	a0,80003c12 <fileread+0x56>
      f->off += r;
    80003c0c:	509c                	lw	a5,32(s1)
    80003c0e:	9fa9                	addw	a5,a5,a0
    80003c10:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003c12:	6c88                	ld	a0,24(s1)
    80003c14:	fffff097          	auipc	ra,0xfffff
    80003c18:	0a2080e7          	jalr	162(ra) # 80002cb6 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003c1c:	854a                	mv	a0,s2
    80003c1e:	70a2                	ld	ra,40(sp)
    80003c20:	7402                	ld	s0,32(sp)
    80003c22:	64e2                	ld	s1,24(sp)
    80003c24:	6942                	ld	s2,16(sp)
    80003c26:	69a2                	ld	s3,8(sp)
    80003c28:	6145                	addi	sp,sp,48
    80003c2a:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003c2c:	6908                	ld	a0,16(a0)
    80003c2e:	00000097          	auipc	ra,0x0
    80003c32:	3ce080e7          	jalr	974(ra) # 80003ffc <piperead>
    80003c36:	892a                	mv	s2,a0
    80003c38:	b7d5                	j	80003c1c <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003c3a:	02451783          	lh	a5,36(a0)
    80003c3e:	03079693          	slli	a3,a5,0x30
    80003c42:	92c1                	srli	a3,a3,0x30
    80003c44:	4725                	li	a4,9
    80003c46:	02d76863          	bltu	a4,a3,80003c76 <fileread+0xba>
    80003c4a:	0792                	slli	a5,a5,0x4
    80003c4c:	00015717          	auipc	a4,0x15
    80003c50:	eec70713          	addi	a4,a4,-276 # 80018b38 <devsw>
    80003c54:	97ba                	add	a5,a5,a4
    80003c56:	639c                	ld	a5,0(a5)
    80003c58:	c38d                	beqz	a5,80003c7a <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003c5a:	4505                	li	a0,1
    80003c5c:	9782                	jalr	a5
    80003c5e:	892a                	mv	s2,a0
    80003c60:	bf75                	j	80003c1c <fileread+0x60>
    panic("fileread");
    80003c62:	00005517          	auipc	a0,0x5
    80003c66:	a9e50513          	addi	a0,a0,-1378 # 80008700 <syscalls+0x268>
    80003c6a:	00002097          	auipc	ra,0x2
    80003c6e:	088080e7          	jalr	136(ra) # 80005cf2 <panic>
    return -1;
    80003c72:	597d                	li	s2,-1
    80003c74:	b765                	j	80003c1c <fileread+0x60>
      return -1;
    80003c76:	597d                	li	s2,-1
    80003c78:	b755                	j	80003c1c <fileread+0x60>
    80003c7a:	597d                	li	s2,-1
    80003c7c:	b745                	j	80003c1c <fileread+0x60>

0000000080003c7e <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003c7e:	715d                	addi	sp,sp,-80
    80003c80:	e486                	sd	ra,72(sp)
    80003c82:	e0a2                	sd	s0,64(sp)
    80003c84:	fc26                	sd	s1,56(sp)
    80003c86:	f84a                	sd	s2,48(sp)
    80003c88:	f44e                	sd	s3,40(sp)
    80003c8a:	f052                	sd	s4,32(sp)
    80003c8c:	ec56                	sd	s5,24(sp)
    80003c8e:	e85a                	sd	s6,16(sp)
    80003c90:	e45e                	sd	s7,8(sp)
    80003c92:	e062                	sd	s8,0(sp)
    80003c94:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003c96:	00954783          	lbu	a5,9(a0)
    80003c9a:	10078663          	beqz	a5,80003da6 <filewrite+0x128>
    80003c9e:	892a                	mv	s2,a0
    80003ca0:	8aae                	mv	s5,a1
    80003ca2:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003ca4:	411c                	lw	a5,0(a0)
    80003ca6:	4705                	li	a4,1
    80003ca8:	02e78263          	beq	a5,a4,80003ccc <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003cac:	470d                	li	a4,3
    80003cae:	02e78663          	beq	a5,a4,80003cda <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003cb2:	4709                	li	a4,2
    80003cb4:	0ee79163          	bne	a5,a4,80003d96 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003cb8:	0ac05d63          	blez	a2,80003d72 <filewrite+0xf4>
    int i = 0;
    80003cbc:	4981                	li	s3,0
    80003cbe:	6b05                	lui	s6,0x1
    80003cc0:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003cc4:	6b85                	lui	s7,0x1
    80003cc6:	c00b8b9b          	addiw	s7,s7,-1024
    80003cca:	a861                	j	80003d62 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003ccc:	6908                	ld	a0,16(a0)
    80003cce:	00000097          	auipc	ra,0x0
    80003cd2:	22e080e7          	jalr	558(ra) # 80003efc <pipewrite>
    80003cd6:	8a2a                	mv	s4,a0
    80003cd8:	a045                	j	80003d78 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003cda:	02451783          	lh	a5,36(a0)
    80003cde:	03079693          	slli	a3,a5,0x30
    80003ce2:	92c1                	srli	a3,a3,0x30
    80003ce4:	4725                	li	a4,9
    80003ce6:	0cd76263          	bltu	a4,a3,80003daa <filewrite+0x12c>
    80003cea:	0792                	slli	a5,a5,0x4
    80003cec:	00015717          	auipc	a4,0x15
    80003cf0:	e4c70713          	addi	a4,a4,-436 # 80018b38 <devsw>
    80003cf4:	97ba                	add	a5,a5,a4
    80003cf6:	679c                	ld	a5,8(a5)
    80003cf8:	cbdd                	beqz	a5,80003dae <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003cfa:	4505                	li	a0,1
    80003cfc:	9782                	jalr	a5
    80003cfe:	8a2a                	mv	s4,a0
    80003d00:	a8a5                	j	80003d78 <filewrite+0xfa>
    80003d02:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003d06:	00000097          	auipc	ra,0x0
    80003d0a:	8b0080e7          	jalr	-1872(ra) # 800035b6 <begin_op>
      ilock(f->ip);
    80003d0e:	01893503          	ld	a0,24(s2)
    80003d12:	fffff097          	auipc	ra,0xfffff
    80003d16:	ee2080e7          	jalr	-286(ra) # 80002bf4 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003d1a:	8762                	mv	a4,s8
    80003d1c:	02092683          	lw	a3,32(s2)
    80003d20:	01598633          	add	a2,s3,s5
    80003d24:	4585                	li	a1,1
    80003d26:	01893503          	ld	a0,24(s2)
    80003d2a:	fffff097          	auipc	ra,0xfffff
    80003d2e:	276080e7          	jalr	630(ra) # 80002fa0 <writei>
    80003d32:	84aa                	mv	s1,a0
    80003d34:	00a05763          	blez	a0,80003d42 <filewrite+0xc4>
        f->off += r;
    80003d38:	02092783          	lw	a5,32(s2)
    80003d3c:	9fa9                	addw	a5,a5,a0
    80003d3e:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003d42:	01893503          	ld	a0,24(s2)
    80003d46:	fffff097          	auipc	ra,0xfffff
    80003d4a:	f70080e7          	jalr	-144(ra) # 80002cb6 <iunlock>
      end_op();
    80003d4e:	00000097          	auipc	ra,0x0
    80003d52:	8e8080e7          	jalr	-1816(ra) # 80003636 <end_op>

      if(r != n1){
    80003d56:	009c1f63          	bne	s8,s1,80003d74 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003d5a:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003d5e:	0149db63          	bge	s3,s4,80003d74 <filewrite+0xf6>
      int n1 = n - i;
    80003d62:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003d66:	84be                	mv	s1,a5
    80003d68:	2781                	sext.w	a5,a5
    80003d6a:	f8fb5ce3          	bge	s6,a5,80003d02 <filewrite+0x84>
    80003d6e:	84de                	mv	s1,s7
    80003d70:	bf49                	j	80003d02 <filewrite+0x84>
    int i = 0;
    80003d72:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003d74:	013a1f63          	bne	s4,s3,80003d92 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003d78:	8552                	mv	a0,s4
    80003d7a:	60a6                	ld	ra,72(sp)
    80003d7c:	6406                	ld	s0,64(sp)
    80003d7e:	74e2                	ld	s1,56(sp)
    80003d80:	7942                	ld	s2,48(sp)
    80003d82:	79a2                	ld	s3,40(sp)
    80003d84:	7a02                	ld	s4,32(sp)
    80003d86:	6ae2                	ld	s5,24(sp)
    80003d88:	6b42                	ld	s6,16(sp)
    80003d8a:	6ba2                	ld	s7,8(sp)
    80003d8c:	6c02                	ld	s8,0(sp)
    80003d8e:	6161                	addi	sp,sp,80
    80003d90:	8082                	ret
    ret = (i == n ? n : -1);
    80003d92:	5a7d                	li	s4,-1
    80003d94:	b7d5                	j	80003d78 <filewrite+0xfa>
    panic("filewrite");
    80003d96:	00005517          	auipc	a0,0x5
    80003d9a:	97a50513          	addi	a0,a0,-1670 # 80008710 <syscalls+0x278>
    80003d9e:	00002097          	auipc	ra,0x2
    80003da2:	f54080e7          	jalr	-172(ra) # 80005cf2 <panic>
    return -1;
    80003da6:	5a7d                	li	s4,-1
    80003da8:	bfc1                	j	80003d78 <filewrite+0xfa>
      return -1;
    80003daa:	5a7d                	li	s4,-1
    80003dac:	b7f1                	j	80003d78 <filewrite+0xfa>
    80003dae:	5a7d                	li	s4,-1
    80003db0:	b7e1                	j	80003d78 <filewrite+0xfa>

0000000080003db2 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003db2:	7179                	addi	sp,sp,-48
    80003db4:	f406                	sd	ra,40(sp)
    80003db6:	f022                	sd	s0,32(sp)
    80003db8:	ec26                	sd	s1,24(sp)
    80003dba:	e84a                	sd	s2,16(sp)
    80003dbc:	e44e                	sd	s3,8(sp)
    80003dbe:	e052                	sd	s4,0(sp)
    80003dc0:	1800                	addi	s0,sp,48
    80003dc2:	84aa                	mv	s1,a0
    80003dc4:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003dc6:	0005b023          	sd	zero,0(a1)
    80003dca:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003dce:	00000097          	auipc	ra,0x0
    80003dd2:	bf8080e7          	jalr	-1032(ra) # 800039c6 <filealloc>
    80003dd6:	e088                	sd	a0,0(s1)
    80003dd8:	c551                	beqz	a0,80003e64 <pipealloc+0xb2>
    80003dda:	00000097          	auipc	ra,0x0
    80003dde:	bec080e7          	jalr	-1044(ra) # 800039c6 <filealloc>
    80003de2:	00aa3023          	sd	a0,0(s4)
    80003de6:	c92d                	beqz	a0,80003e58 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003de8:	ffffc097          	auipc	ra,0xffffc
    80003dec:	330080e7          	jalr	816(ra) # 80000118 <kalloc>
    80003df0:	892a                	mv	s2,a0
    80003df2:	c125                	beqz	a0,80003e52 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003df4:	4985                	li	s3,1
    80003df6:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003dfa:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003dfe:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003e02:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003e06:	00004597          	auipc	a1,0x4
    80003e0a:	5e258593          	addi	a1,a1,1506 # 800083e8 <states.1723+0x1a0>
    80003e0e:	00002097          	auipc	ra,0x2
    80003e12:	39e080e7          	jalr	926(ra) # 800061ac <initlock>
  (*f0)->type = FD_PIPE;
    80003e16:	609c                	ld	a5,0(s1)
    80003e18:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003e1c:	609c                	ld	a5,0(s1)
    80003e1e:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003e22:	609c                	ld	a5,0(s1)
    80003e24:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003e28:	609c                	ld	a5,0(s1)
    80003e2a:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003e2e:	000a3783          	ld	a5,0(s4)
    80003e32:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003e36:	000a3783          	ld	a5,0(s4)
    80003e3a:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003e3e:	000a3783          	ld	a5,0(s4)
    80003e42:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003e46:	000a3783          	ld	a5,0(s4)
    80003e4a:	0127b823          	sd	s2,16(a5)
  return 0;
    80003e4e:	4501                	li	a0,0
    80003e50:	a025                	j	80003e78 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003e52:	6088                	ld	a0,0(s1)
    80003e54:	e501                	bnez	a0,80003e5c <pipealloc+0xaa>
    80003e56:	a039                	j	80003e64 <pipealloc+0xb2>
    80003e58:	6088                	ld	a0,0(s1)
    80003e5a:	c51d                	beqz	a0,80003e88 <pipealloc+0xd6>
    fileclose(*f0);
    80003e5c:	00000097          	auipc	ra,0x0
    80003e60:	c26080e7          	jalr	-986(ra) # 80003a82 <fileclose>
  if(*f1)
    80003e64:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003e68:	557d                	li	a0,-1
  if(*f1)
    80003e6a:	c799                	beqz	a5,80003e78 <pipealloc+0xc6>
    fileclose(*f1);
    80003e6c:	853e                	mv	a0,a5
    80003e6e:	00000097          	auipc	ra,0x0
    80003e72:	c14080e7          	jalr	-1004(ra) # 80003a82 <fileclose>
  return -1;
    80003e76:	557d                	li	a0,-1
}
    80003e78:	70a2                	ld	ra,40(sp)
    80003e7a:	7402                	ld	s0,32(sp)
    80003e7c:	64e2                	ld	s1,24(sp)
    80003e7e:	6942                	ld	s2,16(sp)
    80003e80:	69a2                	ld	s3,8(sp)
    80003e82:	6a02                	ld	s4,0(sp)
    80003e84:	6145                	addi	sp,sp,48
    80003e86:	8082                	ret
  return -1;
    80003e88:	557d                	li	a0,-1
    80003e8a:	b7fd                	j	80003e78 <pipealloc+0xc6>

0000000080003e8c <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003e8c:	1101                	addi	sp,sp,-32
    80003e8e:	ec06                	sd	ra,24(sp)
    80003e90:	e822                	sd	s0,16(sp)
    80003e92:	e426                	sd	s1,8(sp)
    80003e94:	e04a                	sd	s2,0(sp)
    80003e96:	1000                	addi	s0,sp,32
    80003e98:	84aa                	mv	s1,a0
    80003e9a:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003e9c:	00002097          	auipc	ra,0x2
    80003ea0:	3a0080e7          	jalr	928(ra) # 8000623c <acquire>
  if(writable){
    80003ea4:	02090d63          	beqz	s2,80003ede <pipeclose+0x52>
    pi->writeopen = 0;
    80003ea8:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003eac:	21848513          	addi	a0,s1,536
    80003eb0:	ffffd097          	auipc	ra,0xffffd
    80003eb4:	6dc080e7          	jalr	1756(ra) # 8000158c <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003eb8:	2204b783          	ld	a5,544(s1)
    80003ebc:	eb95                	bnez	a5,80003ef0 <pipeclose+0x64>
    release(&pi->lock);
    80003ebe:	8526                	mv	a0,s1
    80003ec0:	00002097          	auipc	ra,0x2
    80003ec4:	430080e7          	jalr	1072(ra) # 800062f0 <release>
    kfree((char*)pi);
    80003ec8:	8526                	mv	a0,s1
    80003eca:	ffffc097          	auipc	ra,0xffffc
    80003ece:	152080e7          	jalr	338(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003ed2:	60e2                	ld	ra,24(sp)
    80003ed4:	6442                	ld	s0,16(sp)
    80003ed6:	64a2                	ld	s1,8(sp)
    80003ed8:	6902                	ld	s2,0(sp)
    80003eda:	6105                	addi	sp,sp,32
    80003edc:	8082                	ret
    pi->readopen = 0;
    80003ede:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003ee2:	21c48513          	addi	a0,s1,540
    80003ee6:	ffffd097          	auipc	ra,0xffffd
    80003eea:	6a6080e7          	jalr	1702(ra) # 8000158c <wakeup>
    80003eee:	b7e9                	j	80003eb8 <pipeclose+0x2c>
    release(&pi->lock);
    80003ef0:	8526                	mv	a0,s1
    80003ef2:	00002097          	auipc	ra,0x2
    80003ef6:	3fe080e7          	jalr	1022(ra) # 800062f0 <release>
}
    80003efa:	bfe1                	j	80003ed2 <pipeclose+0x46>

0000000080003efc <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003efc:	7159                	addi	sp,sp,-112
    80003efe:	f486                	sd	ra,104(sp)
    80003f00:	f0a2                	sd	s0,96(sp)
    80003f02:	eca6                	sd	s1,88(sp)
    80003f04:	e8ca                	sd	s2,80(sp)
    80003f06:	e4ce                	sd	s3,72(sp)
    80003f08:	e0d2                	sd	s4,64(sp)
    80003f0a:	fc56                	sd	s5,56(sp)
    80003f0c:	f85a                	sd	s6,48(sp)
    80003f0e:	f45e                	sd	s7,40(sp)
    80003f10:	f062                	sd	s8,32(sp)
    80003f12:	ec66                	sd	s9,24(sp)
    80003f14:	1880                	addi	s0,sp,112
    80003f16:	84aa                	mv	s1,a0
    80003f18:	8aae                	mv	s5,a1
    80003f1a:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003f1c:	ffffd097          	auipc	ra,0xffffd
    80003f20:	f60080e7          	jalr	-160(ra) # 80000e7c <myproc>
    80003f24:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003f26:	8526                	mv	a0,s1
    80003f28:	00002097          	auipc	ra,0x2
    80003f2c:	314080e7          	jalr	788(ra) # 8000623c <acquire>
  while(i < n){
    80003f30:	0d405463          	blez	s4,80003ff8 <pipewrite+0xfc>
    80003f34:	8ba6                	mv	s7,s1
  int i = 0;
    80003f36:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f38:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003f3a:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003f3e:	21c48c13          	addi	s8,s1,540
    80003f42:	a08d                	j	80003fa4 <pipewrite+0xa8>
      release(&pi->lock);
    80003f44:	8526                	mv	a0,s1
    80003f46:	00002097          	auipc	ra,0x2
    80003f4a:	3aa080e7          	jalr	938(ra) # 800062f0 <release>
      return -1;
    80003f4e:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003f50:	854a                	mv	a0,s2
    80003f52:	70a6                	ld	ra,104(sp)
    80003f54:	7406                	ld	s0,96(sp)
    80003f56:	64e6                	ld	s1,88(sp)
    80003f58:	6946                	ld	s2,80(sp)
    80003f5a:	69a6                	ld	s3,72(sp)
    80003f5c:	6a06                	ld	s4,64(sp)
    80003f5e:	7ae2                	ld	s5,56(sp)
    80003f60:	7b42                	ld	s6,48(sp)
    80003f62:	7ba2                	ld	s7,40(sp)
    80003f64:	7c02                	ld	s8,32(sp)
    80003f66:	6ce2                	ld	s9,24(sp)
    80003f68:	6165                	addi	sp,sp,112
    80003f6a:	8082                	ret
      wakeup(&pi->nread);
    80003f6c:	8566                	mv	a0,s9
    80003f6e:	ffffd097          	auipc	ra,0xffffd
    80003f72:	61e080e7          	jalr	1566(ra) # 8000158c <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003f76:	85de                	mv	a1,s7
    80003f78:	8562                	mv	a0,s8
    80003f7a:	ffffd097          	auipc	ra,0xffffd
    80003f7e:	5ae080e7          	jalr	1454(ra) # 80001528 <sleep>
    80003f82:	a839                	j	80003fa0 <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003f84:	21c4a783          	lw	a5,540(s1)
    80003f88:	0017871b          	addiw	a4,a5,1
    80003f8c:	20e4ae23          	sw	a4,540(s1)
    80003f90:	1ff7f793          	andi	a5,a5,511
    80003f94:	97a6                	add	a5,a5,s1
    80003f96:	f9f44703          	lbu	a4,-97(s0)
    80003f9a:	00e78c23          	sb	a4,24(a5)
      i++;
    80003f9e:	2905                	addiw	s2,s2,1
  while(i < n){
    80003fa0:	05495063          	bge	s2,s4,80003fe0 <pipewrite+0xe4>
    if(pi->readopen == 0 || killed(pr)){
    80003fa4:	2204a783          	lw	a5,544(s1)
    80003fa8:	dfd1                	beqz	a5,80003f44 <pipewrite+0x48>
    80003faa:	854e                	mv	a0,s3
    80003fac:	ffffe097          	auipc	ra,0xffffe
    80003fb0:	824080e7          	jalr	-2012(ra) # 800017d0 <killed>
    80003fb4:	f941                	bnez	a0,80003f44 <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003fb6:	2184a783          	lw	a5,536(s1)
    80003fba:	21c4a703          	lw	a4,540(s1)
    80003fbe:	2007879b          	addiw	a5,a5,512
    80003fc2:	faf705e3          	beq	a4,a5,80003f6c <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003fc6:	4685                	li	a3,1
    80003fc8:	01590633          	add	a2,s2,s5
    80003fcc:	f9f40593          	addi	a1,s0,-97
    80003fd0:	0509b503          	ld	a0,80(s3)
    80003fd4:	ffffd097          	auipc	ra,0xffffd
    80003fd8:	bf2080e7          	jalr	-1038(ra) # 80000bc6 <copyin>
    80003fdc:	fb6514e3          	bne	a0,s6,80003f84 <pipewrite+0x88>
  wakeup(&pi->nread);
    80003fe0:	21848513          	addi	a0,s1,536
    80003fe4:	ffffd097          	auipc	ra,0xffffd
    80003fe8:	5a8080e7          	jalr	1448(ra) # 8000158c <wakeup>
  release(&pi->lock);
    80003fec:	8526                	mv	a0,s1
    80003fee:	00002097          	auipc	ra,0x2
    80003ff2:	302080e7          	jalr	770(ra) # 800062f0 <release>
  return i;
    80003ff6:	bfa9                	j	80003f50 <pipewrite+0x54>
  int i = 0;
    80003ff8:	4901                	li	s2,0
    80003ffa:	b7dd                	j	80003fe0 <pipewrite+0xe4>

0000000080003ffc <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003ffc:	715d                	addi	sp,sp,-80
    80003ffe:	e486                	sd	ra,72(sp)
    80004000:	e0a2                	sd	s0,64(sp)
    80004002:	fc26                	sd	s1,56(sp)
    80004004:	f84a                	sd	s2,48(sp)
    80004006:	f44e                	sd	s3,40(sp)
    80004008:	f052                	sd	s4,32(sp)
    8000400a:	ec56                	sd	s5,24(sp)
    8000400c:	e85a                	sd	s6,16(sp)
    8000400e:	0880                	addi	s0,sp,80
    80004010:	84aa                	mv	s1,a0
    80004012:	892e                	mv	s2,a1
    80004014:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004016:	ffffd097          	auipc	ra,0xffffd
    8000401a:	e66080e7          	jalr	-410(ra) # 80000e7c <myproc>
    8000401e:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004020:	8b26                	mv	s6,s1
    80004022:	8526                	mv	a0,s1
    80004024:	00002097          	auipc	ra,0x2
    80004028:	218080e7          	jalr	536(ra) # 8000623c <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000402c:	2184a703          	lw	a4,536(s1)
    80004030:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004034:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004038:	02f71763          	bne	a4,a5,80004066 <piperead+0x6a>
    8000403c:	2244a783          	lw	a5,548(s1)
    80004040:	c39d                	beqz	a5,80004066 <piperead+0x6a>
    if(killed(pr)){
    80004042:	8552                	mv	a0,s4
    80004044:	ffffd097          	auipc	ra,0xffffd
    80004048:	78c080e7          	jalr	1932(ra) # 800017d0 <killed>
    8000404c:	e941                	bnez	a0,800040dc <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000404e:	85da                	mv	a1,s6
    80004050:	854e                	mv	a0,s3
    80004052:	ffffd097          	auipc	ra,0xffffd
    80004056:	4d6080e7          	jalr	1238(ra) # 80001528 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000405a:	2184a703          	lw	a4,536(s1)
    8000405e:	21c4a783          	lw	a5,540(s1)
    80004062:	fcf70de3          	beq	a4,a5,8000403c <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004066:	09505263          	blez	s5,800040ea <piperead+0xee>
    8000406a:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000406c:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    8000406e:	2184a783          	lw	a5,536(s1)
    80004072:	21c4a703          	lw	a4,540(s1)
    80004076:	02f70d63          	beq	a4,a5,800040b0 <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    8000407a:	0017871b          	addiw	a4,a5,1
    8000407e:	20e4ac23          	sw	a4,536(s1)
    80004082:	1ff7f793          	andi	a5,a5,511
    80004086:	97a6                	add	a5,a5,s1
    80004088:	0187c783          	lbu	a5,24(a5)
    8000408c:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004090:	4685                	li	a3,1
    80004092:	fbf40613          	addi	a2,s0,-65
    80004096:	85ca                	mv	a1,s2
    80004098:	050a3503          	ld	a0,80(s4)
    8000409c:	ffffd097          	auipc	ra,0xffffd
    800040a0:	a9e080e7          	jalr	-1378(ra) # 80000b3a <copyout>
    800040a4:	01650663          	beq	a0,s6,800040b0 <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040a8:	2985                	addiw	s3,s3,1
    800040aa:	0905                	addi	s2,s2,1
    800040ac:	fd3a91e3          	bne	s5,s3,8000406e <piperead+0x72>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800040b0:	21c48513          	addi	a0,s1,540
    800040b4:	ffffd097          	auipc	ra,0xffffd
    800040b8:	4d8080e7          	jalr	1240(ra) # 8000158c <wakeup>
  release(&pi->lock);
    800040bc:	8526                	mv	a0,s1
    800040be:	00002097          	auipc	ra,0x2
    800040c2:	232080e7          	jalr	562(ra) # 800062f0 <release>
  return i;
}
    800040c6:	854e                	mv	a0,s3
    800040c8:	60a6                	ld	ra,72(sp)
    800040ca:	6406                	ld	s0,64(sp)
    800040cc:	74e2                	ld	s1,56(sp)
    800040ce:	7942                	ld	s2,48(sp)
    800040d0:	79a2                	ld	s3,40(sp)
    800040d2:	7a02                	ld	s4,32(sp)
    800040d4:	6ae2                	ld	s5,24(sp)
    800040d6:	6b42                	ld	s6,16(sp)
    800040d8:	6161                	addi	sp,sp,80
    800040da:	8082                	ret
      release(&pi->lock);
    800040dc:	8526                	mv	a0,s1
    800040de:	00002097          	auipc	ra,0x2
    800040e2:	212080e7          	jalr	530(ra) # 800062f0 <release>
      return -1;
    800040e6:	59fd                	li	s3,-1
    800040e8:	bff9                	j	800040c6 <piperead+0xca>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040ea:	4981                	li	s3,0
    800040ec:	b7d1                	j	800040b0 <piperead+0xb4>

00000000800040ee <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    800040ee:	1141                	addi	sp,sp,-16
    800040f0:	e422                	sd	s0,8(sp)
    800040f2:	0800                	addi	s0,sp,16
    800040f4:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    800040f6:	8905                	andi	a0,a0,1
    800040f8:	c111                	beqz	a0,800040fc <flags2perm+0xe>
      perm = PTE_X;
    800040fa:	4521                	li	a0,8
    if(flags & 0x2)
    800040fc:	8b89                	andi	a5,a5,2
    800040fe:	c399                	beqz	a5,80004104 <flags2perm+0x16>
      perm |= PTE_W;
    80004100:	00456513          	ori	a0,a0,4
    return perm;
}
    80004104:	6422                	ld	s0,8(sp)
    80004106:	0141                	addi	sp,sp,16
    80004108:	8082                	ret

000000008000410a <exec>:

int
exec(char *path, char **argv)
{
    8000410a:	df010113          	addi	sp,sp,-528
    8000410e:	20113423          	sd	ra,520(sp)
    80004112:	20813023          	sd	s0,512(sp)
    80004116:	ffa6                	sd	s1,504(sp)
    80004118:	fbca                	sd	s2,496(sp)
    8000411a:	f7ce                	sd	s3,488(sp)
    8000411c:	f3d2                	sd	s4,480(sp)
    8000411e:	efd6                	sd	s5,472(sp)
    80004120:	ebda                	sd	s6,464(sp)
    80004122:	e7de                	sd	s7,456(sp)
    80004124:	e3e2                	sd	s8,448(sp)
    80004126:	ff66                	sd	s9,440(sp)
    80004128:	fb6a                	sd	s10,432(sp)
    8000412a:	f76e                	sd	s11,424(sp)
    8000412c:	0c00                	addi	s0,sp,528
    8000412e:	84aa                	mv	s1,a0
    80004130:	dea43c23          	sd	a0,-520(s0)
    80004134:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004138:	ffffd097          	auipc	ra,0xffffd
    8000413c:	d44080e7          	jalr	-700(ra) # 80000e7c <myproc>
    80004140:	892a                	mv	s2,a0

  begin_op();
    80004142:	fffff097          	auipc	ra,0xfffff
    80004146:	474080e7          	jalr	1140(ra) # 800035b6 <begin_op>

  if((ip = namei(path)) == 0){
    8000414a:	8526                	mv	a0,s1
    8000414c:	fffff097          	auipc	ra,0xfffff
    80004150:	24e080e7          	jalr	590(ra) # 8000339a <namei>
    80004154:	c92d                	beqz	a0,800041c6 <exec+0xbc>
    80004156:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004158:	fffff097          	auipc	ra,0xfffff
    8000415c:	a9c080e7          	jalr	-1380(ra) # 80002bf4 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004160:	04000713          	li	a4,64
    80004164:	4681                	li	a3,0
    80004166:	e5040613          	addi	a2,s0,-432
    8000416a:	4581                	li	a1,0
    8000416c:	8526                	mv	a0,s1
    8000416e:	fffff097          	auipc	ra,0xfffff
    80004172:	d3a080e7          	jalr	-710(ra) # 80002ea8 <readi>
    80004176:	04000793          	li	a5,64
    8000417a:	00f51a63          	bne	a0,a5,8000418e <exec+0x84>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    8000417e:	e5042703          	lw	a4,-432(s0)
    80004182:	464c47b7          	lui	a5,0x464c4
    80004186:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000418a:	04f70463          	beq	a4,a5,800041d2 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000418e:	8526                	mv	a0,s1
    80004190:	fffff097          	auipc	ra,0xfffff
    80004194:	cc6080e7          	jalr	-826(ra) # 80002e56 <iunlockput>
    end_op();
    80004198:	fffff097          	auipc	ra,0xfffff
    8000419c:	49e080e7          	jalr	1182(ra) # 80003636 <end_op>
  }
  return -1;
    800041a0:	557d                	li	a0,-1
}
    800041a2:	20813083          	ld	ra,520(sp)
    800041a6:	20013403          	ld	s0,512(sp)
    800041aa:	74fe                	ld	s1,504(sp)
    800041ac:	795e                	ld	s2,496(sp)
    800041ae:	79be                	ld	s3,488(sp)
    800041b0:	7a1e                	ld	s4,480(sp)
    800041b2:	6afe                	ld	s5,472(sp)
    800041b4:	6b5e                	ld	s6,464(sp)
    800041b6:	6bbe                	ld	s7,456(sp)
    800041b8:	6c1e                	ld	s8,448(sp)
    800041ba:	7cfa                	ld	s9,440(sp)
    800041bc:	7d5a                	ld	s10,432(sp)
    800041be:	7dba                	ld	s11,424(sp)
    800041c0:	21010113          	addi	sp,sp,528
    800041c4:	8082                	ret
    end_op();
    800041c6:	fffff097          	auipc	ra,0xfffff
    800041ca:	470080e7          	jalr	1136(ra) # 80003636 <end_op>
    return -1;
    800041ce:	557d                	li	a0,-1
    800041d0:	bfc9                	j	800041a2 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    800041d2:	854a                	mv	a0,s2
    800041d4:	ffffd097          	auipc	ra,0xffffd
    800041d8:	d6c080e7          	jalr	-660(ra) # 80000f40 <proc_pagetable>
    800041dc:	8baa                	mv	s7,a0
    800041de:	d945                	beqz	a0,8000418e <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800041e0:	e7042983          	lw	s3,-400(s0)
    800041e4:	e8845783          	lhu	a5,-376(s0)
    800041e8:	c7ad                	beqz	a5,80004252 <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800041ea:	4a01                	li	s4,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800041ec:	4b01                	li	s6,0
    if(ph.vaddr % PGSIZE != 0)
    800041ee:	6c85                	lui	s9,0x1
    800041f0:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800041f4:	def43823          	sd	a5,-528(s0)
    800041f8:	ac0d                	j	8000442a <exec+0x320>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    800041fa:	00004517          	auipc	a0,0x4
    800041fe:	52650513          	addi	a0,a0,1318 # 80008720 <syscalls+0x288>
    80004202:	00002097          	auipc	ra,0x2
    80004206:	af0080e7          	jalr	-1296(ra) # 80005cf2 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    8000420a:	8756                	mv	a4,s5
    8000420c:	012d86bb          	addw	a3,s11,s2
    80004210:	4581                	li	a1,0
    80004212:	8526                	mv	a0,s1
    80004214:	fffff097          	auipc	ra,0xfffff
    80004218:	c94080e7          	jalr	-876(ra) # 80002ea8 <readi>
    8000421c:	2501                	sext.w	a0,a0
    8000421e:	1aaa9a63          	bne	s5,a0,800043d2 <exec+0x2c8>
  for(i = 0; i < sz; i += PGSIZE){
    80004222:	6785                	lui	a5,0x1
    80004224:	0127893b          	addw	s2,a5,s2
    80004228:	77fd                	lui	a5,0xfffff
    8000422a:	01478a3b          	addw	s4,a5,s4
    8000422e:	1f897563          	bgeu	s2,s8,80004418 <exec+0x30e>
    pa = walkaddr(pagetable, va + i);
    80004232:	02091593          	slli	a1,s2,0x20
    80004236:	9181                	srli	a1,a1,0x20
    80004238:	95ea                	add	a1,a1,s10
    8000423a:	855e                	mv	a0,s7
    8000423c:	ffffc097          	auipc	ra,0xffffc
    80004240:	2f2080e7          	jalr	754(ra) # 8000052e <walkaddr>
    80004244:	862a                	mv	a2,a0
    if(pa == 0)
    80004246:	d955                	beqz	a0,800041fa <exec+0xf0>
      n = PGSIZE;
    80004248:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    8000424a:	fd9a70e3          	bgeu	s4,s9,8000420a <exec+0x100>
      n = sz - i;
    8000424e:	8ad2                	mv	s5,s4
    80004250:	bf6d                	j	8000420a <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004252:	4a01                	li	s4,0
  iunlockput(ip);
    80004254:	8526                	mv	a0,s1
    80004256:	fffff097          	auipc	ra,0xfffff
    8000425a:	c00080e7          	jalr	-1024(ra) # 80002e56 <iunlockput>
  end_op();
    8000425e:	fffff097          	auipc	ra,0xfffff
    80004262:	3d8080e7          	jalr	984(ra) # 80003636 <end_op>
  p = myproc();
    80004266:	ffffd097          	auipc	ra,0xffffd
    8000426a:	c16080e7          	jalr	-1002(ra) # 80000e7c <myproc>
    8000426e:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004270:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004274:	6785                	lui	a5,0x1
    80004276:	17fd                	addi	a5,a5,-1
    80004278:	9a3e                	add	s4,s4,a5
    8000427a:	757d                	lui	a0,0xfffff
    8000427c:	00aa77b3          	and	a5,s4,a0
    80004280:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004284:	4691                	li	a3,4
    80004286:	6609                	lui	a2,0x2
    80004288:	963e                	add	a2,a2,a5
    8000428a:	85be                	mv	a1,a5
    8000428c:	855e                	mv	a0,s7
    8000428e:	ffffc097          	auipc	ra,0xffffc
    80004292:	654080e7          	jalr	1620(ra) # 800008e2 <uvmalloc>
    80004296:	8b2a                	mv	s6,a0
  ip = 0;
    80004298:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    8000429a:	12050c63          	beqz	a0,800043d2 <exec+0x2c8>
  uvmclear(pagetable, sz-2*PGSIZE);
    8000429e:	75f9                	lui	a1,0xffffe
    800042a0:	95aa                	add	a1,a1,a0
    800042a2:	855e                	mv	a0,s7
    800042a4:	ffffd097          	auipc	ra,0xffffd
    800042a8:	864080e7          	jalr	-1948(ra) # 80000b08 <uvmclear>
  stackbase = sp - PGSIZE;
    800042ac:	7c7d                	lui	s8,0xfffff
    800042ae:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    800042b0:	e0043783          	ld	a5,-512(s0)
    800042b4:	6388                	ld	a0,0(a5)
    800042b6:	c535                	beqz	a0,80004322 <exec+0x218>
    800042b8:	e9040993          	addi	s3,s0,-368
    800042bc:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    800042c0:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    800042c2:	ffffc097          	auipc	ra,0xffffc
    800042c6:	05e080e7          	jalr	94(ra) # 80000320 <strlen>
    800042ca:	2505                	addiw	a0,a0,1
    800042cc:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800042d0:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    800042d4:	13896663          	bltu	s2,s8,80004400 <exec+0x2f6>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800042d8:	e0043d83          	ld	s11,-512(s0)
    800042dc:	000dba03          	ld	s4,0(s11)
    800042e0:	8552                	mv	a0,s4
    800042e2:	ffffc097          	auipc	ra,0xffffc
    800042e6:	03e080e7          	jalr	62(ra) # 80000320 <strlen>
    800042ea:	0015069b          	addiw	a3,a0,1
    800042ee:	8652                	mv	a2,s4
    800042f0:	85ca                	mv	a1,s2
    800042f2:	855e                	mv	a0,s7
    800042f4:	ffffd097          	auipc	ra,0xffffd
    800042f8:	846080e7          	jalr	-1978(ra) # 80000b3a <copyout>
    800042fc:	10054663          	bltz	a0,80004408 <exec+0x2fe>
    ustack[argc] = sp;
    80004300:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004304:	0485                	addi	s1,s1,1
    80004306:	008d8793          	addi	a5,s11,8
    8000430a:	e0f43023          	sd	a5,-512(s0)
    8000430e:	008db503          	ld	a0,8(s11)
    80004312:	c911                	beqz	a0,80004326 <exec+0x21c>
    if(argc >= MAXARG)
    80004314:	09a1                	addi	s3,s3,8
    80004316:	fb3c96e3          	bne	s9,s3,800042c2 <exec+0x1b8>
  sz = sz1;
    8000431a:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000431e:	4481                	li	s1,0
    80004320:	a84d                	j	800043d2 <exec+0x2c8>
  sp = sz;
    80004322:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    80004324:	4481                	li	s1,0
  ustack[argc] = 0;
    80004326:	00349793          	slli	a5,s1,0x3
    8000432a:	f9040713          	addi	a4,s0,-112
    8000432e:	97ba                	add	a5,a5,a4
    80004330:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    80004334:	00148693          	addi	a3,s1,1
    80004338:	068e                	slli	a3,a3,0x3
    8000433a:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    8000433e:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004342:	01897663          	bgeu	s2,s8,8000434e <exec+0x244>
  sz = sz1;
    80004346:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000434a:	4481                	li	s1,0
    8000434c:	a059                	j	800043d2 <exec+0x2c8>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    8000434e:	e9040613          	addi	a2,s0,-368
    80004352:	85ca                	mv	a1,s2
    80004354:	855e                	mv	a0,s7
    80004356:	ffffc097          	auipc	ra,0xffffc
    8000435a:	7e4080e7          	jalr	2020(ra) # 80000b3a <copyout>
    8000435e:	0a054963          	bltz	a0,80004410 <exec+0x306>
  p->trapframe->a1 = sp;
    80004362:	058ab783          	ld	a5,88(s5)
    80004366:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000436a:	df843783          	ld	a5,-520(s0)
    8000436e:	0007c703          	lbu	a4,0(a5)
    80004372:	cf11                	beqz	a4,8000438e <exec+0x284>
    80004374:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004376:	02f00693          	li	a3,47
    8000437a:	a039                	j	80004388 <exec+0x27e>
      last = s+1;
    8000437c:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004380:	0785                	addi	a5,a5,1
    80004382:	fff7c703          	lbu	a4,-1(a5)
    80004386:	c701                	beqz	a4,8000438e <exec+0x284>
    if(*s == '/')
    80004388:	fed71ce3          	bne	a4,a3,80004380 <exec+0x276>
    8000438c:	bfc5                	j	8000437c <exec+0x272>
  safestrcpy(p->name, last, sizeof(p->name));
    8000438e:	4641                	li	a2,16
    80004390:	df843583          	ld	a1,-520(s0)
    80004394:	158a8513          	addi	a0,s5,344
    80004398:	ffffc097          	auipc	ra,0xffffc
    8000439c:	f56080e7          	jalr	-170(ra) # 800002ee <safestrcpy>
  oldpagetable = p->pagetable;
    800043a0:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    800043a4:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    800043a8:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800043ac:	058ab783          	ld	a5,88(s5)
    800043b0:	e6843703          	ld	a4,-408(s0)
    800043b4:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800043b6:	058ab783          	ld	a5,88(s5)
    800043ba:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800043be:	85ea                	mv	a1,s10
    800043c0:	ffffd097          	auipc	ra,0xffffd
    800043c4:	c1c080e7          	jalr	-996(ra) # 80000fdc <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800043c8:	0004851b          	sext.w	a0,s1
    800043cc:	bbd9                	j	800041a2 <exec+0x98>
    800043ce:	e1443423          	sd	s4,-504(s0)
    proc_freepagetable(pagetable, sz);
    800043d2:	e0843583          	ld	a1,-504(s0)
    800043d6:	855e                	mv	a0,s7
    800043d8:	ffffd097          	auipc	ra,0xffffd
    800043dc:	c04080e7          	jalr	-1020(ra) # 80000fdc <proc_freepagetable>
  if(ip){
    800043e0:	da0497e3          	bnez	s1,8000418e <exec+0x84>
  return -1;
    800043e4:	557d                	li	a0,-1
    800043e6:	bb75                	j	800041a2 <exec+0x98>
    800043e8:	e1443423          	sd	s4,-504(s0)
    800043ec:	b7dd                	j	800043d2 <exec+0x2c8>
    800043ee:	e1443423          	sd	s4,-504(s0)
    800043f2:	b7c5                	j	800043d2 <exec+0x2c8>
    800043f4:	e1443423          	sd	s4,-504(s0)
    800043f8:	bfe9                	j	800043d2 <exec+0x2c8>
    800043fa:	e1443423          	sd	s4,-504(s0)
    800043fe:	bfd1                	j	800043d2 <exec+0x2c8>
  sz = sz1;
    80004400:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004404:	4481                	li	s1,0
    80004406:	b7f1                	j	800043d2 <exec+0x2c8>
  sz = sz1;
    80004408:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000440c:	4481                	li	s1,0
    8000440e:	b7d1                	j	800043d2 <exec+0x2c8>
  sz = sz1;
    80004410:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004414:	4481                	li	s1,0
    80004416:	bf75                	j	800043d2 <exec+0x2c8>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004418:	e0843a03          	ld	s4,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000441c:	2b05                	addiw	s6,s6,1
    8000441e:	0389899b          	addiw	s3,s3,56
    80004422:	e8845783          	lhu	a5,-376(s0)
    80004426:	e2fb57e3          	bge	s6,a5,80004254 <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000442a:	2981                	sext.w	s3,s3
    8000442c:	03800713          	li	a4,56
    80004430:	86ce                	mv	a3,s3
    80004432:	e1840613          	addi	a2,s0,-488
    80004436:	4581                	li	a1,0
    80004438:	8526                	mv	a0,s1
    8000443a:	fffff097          	auipc	ra,0xfffff
    8000443e:	a6e080e7          	jalr	-1426(ra) # 80002ea8 <readi>
    80004442:	03800793          	li	a5,56
    80004446:	f8f514e3          	bne	a0,a5,800043ce <exec+0x2c4>
    if(ph.type != ELF_PROG_LOAD)
    8000444a:	e1842783          	lw	a5,-488(s0)
    8000444e:	4705                	li	a4,1
    80004450:	fce796e3          	bne	a5,a4,8000441c <exec+0x312>
    if(ph.memsz < ph.filesz)
    80004454:	e4043903          	ld	s2,-448(s0)
    80004458:	e3843783          	ld	a5,-456(s0)
    8000445c:	f8f966e3          	bltu	s2,a5,800043e8 <exec+0x2de>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004460:	e2843783          	ld	a5,-472(s0)
    80004464:	993e                	add	s2,s2,a5
    80004466:	f8f964e3          	bltu	s2,a5,800043ee <exec+0x2e4>
    if(ph.vaddr % PGSIZE != 0)
    8000446a:	df043703          	ld	a4,-528(s0)
    8000446e:	8ff9                	and	a5,a5,a4
    80004470:	f3d1                	bnez	a5,800043f4 <exec+0x2ea>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004472:	e1c42503          	lw	a0,-484(s0)
    80004476:	00000097          	auipc	ra,0x0
    8000447a:	c78080e7          	jalr	-904(ra) # 800040ee <flags2perm>
    8000447e:	86aa                	mv	a3,a0
    80004480:	864a                	mv	a2,s2
    80004482:	85d2                	mv	a1,s4
    80004484:	855e                	mv	a0,s7
    80004486:	ffffc097          	auipc	ra,0xffffc
    8000448a:	45c080e7          	jalr	1116(ra) # 800008e2 <uvmalloc>
    8000448e:	e0a43423          	sd	a0,-504(s0)
    80004492:	d525                	beqz	a0,800043fa <exec+0x2f0>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004494:	e2843d03          	ld	s10,-472(s0)
    80004498:	e2042d83          	lw	s11,-480(s0)
    8000449c:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800044a0:	f60c0ce3          	beqz	s8,80004418 <exec+0x30e>
    800044a4:	8a62                	mv	s4,s8
    800044a6:	4901                	li	s2,0
    800044a8:	b369                	j	80004232 <exec+0x128>

00000000800044aa <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800044aa:	7179                	addi	sp,sp,-48
    800044ac:	f406                	sd	ra,40(sp)
    800044ae:	f022                	sd	s0,32(sp)
    800044b0:	ec26                	sd	s1,24(sp)
    800044b2:	e84a                	sd	s2,16(sp)
    800044b4:	1800                	addi	s0,sp,48
    800044b6:	892e                	mv	s2,a1
    800044b8:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    800044ba:	fdc40593          	addi	a1,s0,-36
    800044be:	ffffe097          	auipc	ra,0xffffe
    800044c2:	b04080e7          	jalr	-1276(ra) # 80001fc2 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800044c6:	fdc42703          	lw	a4,-36(s0)
    800044ca:	47bd                	li	a5,15
    800044cc:	02e7eb63          	bltu	a5,a4,80004502 <argfd+0x58>
    800044d0:	ffffd097          	auipc	ra,0xffffd
    800044d4:	9ac080e7          	jalr	-1620(ra) # 80000e7c <myproc>
    800044d8:	fdc42703          	lw	a4,-36(s0)
    800044dc:	01a70793          	addi	a5,a4,26
    800044e0:	078e                	slli	a5,a5,0x3
    800044e2:	953e                	add	a0,a0,a5
    800044e4:	611c                	ld	a5,0(a0)
    800044e6:	c385                	beqz	a5,80004506 <argfd+0x5c>
    return -1;
  if(pfd)
    800044e8:	00090463          	beqz	s2,800044f0 <argfd+0x46>
    *pfd = fd;
    800044ec:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800044f0:	4501                	li	a0,0
  if(pf)
    800044f2:	c091                	beqz	s1,800044f6 <argfd+0x4c>
    *pf = f;
    800044f4:	e09c                	sd	a5,0(s1)
}
    800044f6:	70a2                	ld	ra,40(sp)
    800044f8:	7402                	ld	s0,32(sp)
    800044fa:	64e2                	ld	s1,24(sp)
    800044fc:	6942                	ld	s2,16(sp)
    800044fe:	6145                	addi	sp,sp,48
    80004500:	8082                	ret
    return -1;
    80004502:	557d                	li	a0,-1
    80004504:	bfcd                	j	800044f6 <argfd+0x4c>
    80004506:	557d                	li	a0,-1
    80004508:	b7fd                	j	800044f6 <argfd+0x4c>

000000008000450a <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000450a:	1101                	addi	sp,sp,-32
    8000450c:	ec06                	sd	ra,24(sp)
    8000450e:	e822                	sd	s0,16(sp)
    80004510:	e426                	sd	s1,8(sp)
    80004512:	1000                	addi	s0,sp,32
    80004514:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004516:	ffffd097          	auipc	ra,0xffffd
    8000451a:	966080e7          	jalr	-1690(ra) # 80000e7c <myproc>
    8000451e:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004520:	0d050793          	addi	a5,a0,208 # fffffffffffff0d0 <end+0xffffffff7ffdd1c0>
    80004524:	4501                	li	a0,0
    80004526:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004528:	6398                	ld	a4,0(a5)
    8000452a:	cb19                	beqz	a4,80004540 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    8000452c:	2505                	addiw	a0,a0,1
    8000452e:	07a1                	addi	a5,a5,8
    80004530:	fed51ce3          	bne	a0,a3,80004528 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004534:	557d                	li	a0,-1
}
    80004536:	60e2                	ld	ra,24(sp)
    80004538:	6442                	ld	s0,16(sp)
    8000453a:	64a2                	ld	s1,8(sp)
    8000453c:	6105                	addi	sp,sp,32
    8000453e:	8082                	ret
      p->ofile[fd] = f;
    80004540:	01a50793          	addi	a5,a0,26
    80004544:	078e                	slli	a5,a5,0x3
    80004546:	963e                	add	a2,a2,a5
    80004548:	e204                	sd	s1,0(a2)
      return fd;
    8000454a:	b7f5                	j	80004536 <fdalloc+0x2c>

000000008000454c <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    8000454c:	715d                	addi	sp,sp,-80
    8000454e:	e486                	sd	ra,72(sp)
    80004550:	e0a2                	sd	s0,64(sp)
    80004552:	fc26                	sd	s1,56(sp)
    80004554:	f84a                	sd	s2,48(sp)
    80004556:	f44e                	sd	s3,40(sp)
    80004558:	f052                	sd	s4,32(sp)
    8000455a:	ec56                	sd	s5,24(sp)
    8000455c:	e85a                	sd	s6,16(sp)
    8000455e:	0880                	addi	s0,sp,80
    80004560:	8b2e                	mv	s6,a1
    80004562:	89b2                	mv	s3,a2
    80004564:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004566:	fb040593          	addi	a1,s0,-80
    8000456a:	fffff097          	auipc	ra,0xfffff
    8000456e:	e4e080e7          	jalr	-434(ra) # 800033b8 <nameiparent>
    80004572:	84aa                	mv	s1,a0
    80004574:	16050063          	beqz	a0,800046d4 <create+0x188>
    return 0;

  ilock(dp);
    80004578:	ffffe097          	auipc	ra,0xffffe
    8000457c:	67c080e7          	jalr	1660(ra) # 80002bf4 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004580:	4601                	li	a2,0
    80004582:	fb040593          	addi	a1,s0,-80
    80004586:	8526                	mv	a0,s1
    80004588:	fffff097          	auipc	ra,0xfffff
    8000458c:	b50080e7          	jalr	-1200(ra) # 800030d8 <dirlookup>
    80004590:	8aaa                	mv	s5,a0
    80004592:	c931                	beqz	a0,800045e6 <create+0x9a>
    iunlockput(dp);
    80004594:	8526                	mv	a0,s1
    80004596:	fffff097          	auipc	ra,0xfffff
    8000459a:	8c0080e7          	jalr	-1856(ra) # 80002e56 <iunlockput>
    ilock(ip);
    8000459e:	8556                	mv	a0,s5
    800045a0:	ffffe097          	auipc	ra,0xffffe
    800045a4:	654080e7          	jalr	1620(ra) # 80002bf4 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800045a8:	000b059b          	sext.w	a1,s6
    800045ac:	4789                	li	a5,2
    800045ae:	02f59563          	bne	a1,a5,800045d8 <create+0x8c>
    800045b2:	044ad783          	lhu	a5,68(s5)
    800045b6:	37f9                	addiw	a5,a5,-2
    800045b8:	17c2                	slli	a5,a5,0x30
    800045ba:	93c1                	srli	a5,a5,0x30
    800045bc:	4705                	li	a4,1
    800045be:	00f76d63          	bltu	a4,a5,800045d8 <create+0x8c>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    800045c2:	8556                	mv	a0,s5
    800045c4:	60a6                	ld	ra,72(sp)
    800045c6:	6406                	ld	s0,64(sp)
    800045c8:	74e2                	ld	s1,56(sp)
    800045ca:	7942                	ld	s2,48(sp)
    800045cc:	79a2                	ld	s3,40(sp)
    800045ce:	7a02                	ld	s4,32(sp)
    800045d0:	6ae2                	ld	s5,24(sp)
    800045d2:	6b42                	ld	s6,16(sp)
    800045d4:	6161                	addi	sp,sp,80
    800045d6:	8082                	ret
    iunlockput(ip);
    800045d8:	8556                	mv	a0,s5
    800045da:	fffff097          	auipc	ra,0xfffff
    800045de:	87c080e7          	jalr	-1924(ra) # 80002e56 <iunlockput>
    return 0;
    800045e2:	4a81                	li	s5,0
    800045e4:	bff9                	j	800045c2 <create+0x76>
  if((ip = ialloc(dp->dev, type)) == 0){
    800045e6:	85da                	mv	a1,s6
    800045e8:	4088                	lw	a0,0(s1)
    800045ea:	ffffe097          	auipc	ra,0xffffe
    800045ee:	46e080e7          	jalr	1134(ra) # 80002a58 <ialloc>
    800045f2:	8a2a                	mv	s4,a0
    800045f4:	c921                	beqz	a0,80004644 <create+0xf8>
  ilock(ip);
    800045f6:	ffffe097          	auipc	ra,0xffffe
    800045fa:	5fe080e7          	jalr	1534(ra) # 80002bf4 <ilock>
  ip->major = major;
    800045fe:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80004602:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80004606:	4785                	li	a5,1
    80004608:	04fa1523          	sh	a5,74(s4)
  iupdate(ip);
    8000460c:	8552                	mv	a0,s4
    8000460e:	ffffe097          	auipc	ra,0xffffe
    80004612:	51c080e7          	jalr	1308(ra) # 80002b2a <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004616:	000b059b          	sext.w	a1,s6
    8000461a:	4785                	li	a5,1
    8000461c:	02f58b63          	beq	a1,a5,80004652 <create+0x106>
  if(dirlink(dp, name, ip->inum) < 0)
    80004620:	004a2603          	lw	a2,4(s4)
    80004624:	fb040593          	addi	a1,s0,-80
    80004628:	8526                	mv	a0,s1
    8000462a:	fffff097          	auipc	ra,0xfffff
    8000462e:	cbe080e7          	jalr	-834(ra) # 800032e8 <dirlink>
    80004632:	06054f63          	bltz	a0,800046b0 <create+0x164>
  iunlockput(dp);
    80004636:	8526                	mv	a0,s1
    80004638:	fffff097          	auipc	ra,0xfffff
    8000463c:	81e080e7          	jalr	-2018(ra) # 80002e56 <iunlockput>
  return ip;
    80004640:	8ad2                	mv	s5,s4
    80004642:	b741                	j	800045c2 <create+0x76>
    iunlockput(dp);
    80004644:	8526                	mv	a0,s1
    80004646:	fffff097          	auipc	ra,0xfffff
    8000464a:	810080e7          	jalr	-2032(ra) # 80002e56 <iunlockput>
    return 0;
    8000464e:	8ad2                	mv	s5,s4
    80004650:	bf8d                	j	800045c2 <create+0x76>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004652:	004a2603          	lw	a2,4(s4)
    80004656:	00004597          	auipc	a1,0x4
    8000465a:	0ea58593          	addi	a1,a1,234 # 80008740 <syscalls+0x2a8>
    8000465e:	8552                	mv	a0,s4
    80004660:	fffff097          	auipc	ra,0xfffff
    80004664:	c88080e7          	jalr	-888(ra) # 800032e8 <dirlink>
    80004668:	04054463          	bltz	a0,800046b0 <create+0x164>
    8000466c:	40d0                	lw	a2,4(s1)
    8000466e:	00004597          	auipc	a1,0x4
    80004672:	0da58593          	addi	a1,a1,218 # 80008748 <syscalls+0x2b0>
    80004676:	8552                	mv	a0,s4
    80004678:	fffff097          	auipc	ra,0xfffff
    8000467c:	c70080e7          	jalr	-912(ra) # 800032e8 <dirlink>
    80004680:	02054863          	bltz	a0,800046b0 <create+0x164>
  if(dirlink(dp, name, ip->inum) < 0)
    80004684:	004a2603          	lw	a2,4(s4)
    80004688:	fb040593          	addi	a1,s0,-80
    8000468c:	8526                	mv	a0,s1
    8000468e:	fffff097          	auipc	ra,0xfffff
    80004692:	c5a080e7          	jalr	-934(ra) # 800032e8 <dirlink>
    80004696:	00054d63          	bltz	a0,800046b0 <create+0x164>
    dp->nlink++;  // for ".."
    8000469a:	04a4d783          	lhu	a5,74(s1)
    8000469e:	2785                	addiw	a5,a5,1
    800046a0:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800046a4:	8526                	mv	a0,s1
    800046a6:	ffffe097          	auipc	ra,0xffffe
    800046aa:	484080e7          	jalr	1156(ra) # 80002b2a <iupdate>
    800046ae:	b761                	j	80004636 <create+0xea>
  ip->nlink = 0;
    800046b0:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    800046b4:	8552                	mv	a0,s4
    800046b6:	ffffe097          	auipc	ra,0xffffe
    800046ba:	474080e7          	jalr	1140(ra) # 80002b2a <iupdate>
  iunlockput(ip);
    800046be:	8552                	mv	a0,s4
    800046c0:	ffffe097          	auipc	ra,0xffffe
    800046c4:	796080e7          	jalr	1942(ra) # 80002e56 <iunlockput>
  iunlockput(dp);
    800046c8:	8526                	mv	a0,s1
    800046ca:	ffffe097          	auipc	ra,0xffffe
    800046ce:	78c080e7          	jalr	1932(ra) # 80002e56 <iunlockput>
  return 0;
    800046d2:	bdc5                	j	800045c2 <create+0x76>
    return 0;
    800046d4:	8aaa                	mv	s5,a0
    800046d6:	b5f5                	j	800045c2 <create+0x76>

00000000800046d8 <sys_dup>:
{
    800046d8:	7179                	addi	sp,sp,-48
    800046da:	f406                	sd	ra,40(sp)
    800046dc:	f022                	sd	s0,32(sp)
    800046de:	ec26                	sd	s1,24(sp)
    800046e0:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800046e2:	fd840613          	addi	a2,s0,-40
    800046e6:	4581                	li	a1,0
    800046e8:	4501                	li	a0,0
    800046ea:	00000097          	auipc	ra,0x0
    800046ee:	dc0080e7          	jalr	-576(ra) # 800044aa <argfd>
    return -1;
    800046f2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800046f4:	02054363          	bltz	a0,8000471a <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    800046f8:	fd843503          	ld	a0,-40(s0)
    800046fc:	00000097          	auipc	ra,0x0
    80004700:	e0e080e7          	jalr	-498(ra) # 8000450a <fdalloc>
    80004704:	84aa                	mv	s1,a0
    return -1;
    80004706:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004708:	00054963          	bltz	a0,8000471a <sys_dup+0x42>
  filedup(f);
    8000470c:	fd843503          	ld	a0,-40(s0)
    80004710:	fffff097          	auipc	ra,0xfffff
    80004714:	320080e7          	jalr	800(ra) # 80003a30 <filedup>
  return fd;
    80004718:	87a6                	mv	a5,s1
}
    8000471a:	853e                	mv	a0,a5
    8000471c:	70a2                	ld	ra,40(sp)
    8000471e:	7402                	ld	s0,32(sp)
    80004720:	64e2                	ld	s1,24(sp)
    80004722:	6145                	addi	sp,sp,48
    80004724:	8082                	ret

0000000080004726 <sys_read>:
{
    80004726:	7179                	addi	sp,sp,-48
    80004728:	f406                	sd	ra,40(sp)
    8000472a:	f022                	sd	s0,32(sp)
    8000472c:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000472e:	fd840593          	addi	a1,s0,-40
    80004732:	4505                	li	a0,1
    80004734:	ffffe097          	auipc	ra,0xffffe
    80004738:	8ae080e7          	jalr	-1874(ra) # 80001fe2 <argaddr>
  argint(2, &n);
    8000473c:	fe440593          	addi	a1,s0,-28
    80004740:	4509                	li	a0,2
    80004742:	ffffe097          	auipc	ra,0xffffe
    80004746:	880080e7          	jalr	-1920(ra) # 80001fc2 <argint>
  if(argfd(0, 0, &f) < 0)
    8000474a:	fe840613          	addi	a2,s0,-24
    8000474e:	4581                	li	a1,0
    80004750:	4501                	li	a0,0
    80004752:	00000097          	auipc	ra,0x0
    80004756:	d58080e7          	jalr	-680(ra) # 800044aa <argfd>
    8000475a:	87aa                	mv	a5,a0
    return -1;
    8000475c:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000475e:	0007cc63          	bltz	a5,80004776 <sys_read+0x50>
  return fileread(f, p, n);
    80004762:	fe442603          	lw	a2,-28(s0)
    80004766:	fd843583          	ld	a1,-40(s0)
    8000476a:	fe843503          	ld	a0,-24(s0)
    8000476e:	fffff097          	auipc	ra,0xfffff
    80004772:	44e080e7          	jalr	1102(ra) # 80003bbc <fileread>
}
    80004776:	70a2                	ld	ra,40(sp)
    80004778:	7402                	ld	s0,32(sp)
    8000477a:	6145                	addi	sp,sp,48
    8000477c:	8082                	ret

000000008000477e <sys_write>:
{
    8000477e:	7179                	addi	sp,sp,-48
    80004780:	f406                	sd	ra,40(sp)
    80004782:	f022                	sd	s0,32(sp)
    80004784:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004786:	fd840593          	addi	a1,s0,-40
    8000478a:	4505                	li	a0,1
    8000478c:	ffffe097          	auipc	ra,0xffffe
    80004790:	856080e7          	jalr	-1962(ra) # 80001fe2 <argaddr>
  argint(2, &n);
    80004794:	fe440593          	addi	a1,s0,-28
    80004798:	4509                	li	a0,2
    8000479a:	ffffe097          	auipc	ra,0xffffe
    8000479e:	828080e7          	jalr	-2008(ra) # 80001fc2 <argint>
  if(argfd(0, 0, &f) < 0)
    800047a2:	fe840613          	addi	a2,s0,-24
    800047a6:	4581                	li	a1,0
    800047a8:	4501                	li	a0,0
    800047aa:	00000097          	auipc	ra,0x0
    800047ae:	d00080e7          	jalr	-768(ra) # 800044aa <argfd>
    800047b2:	87aa                	mv	a5,a0
    return -1;
    800047b4:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800047b6:	0007cc63          	bltz	a5,800047ce <sys_write+0x50>
  return filewrite(f, p, n);
    800047ba:	fe442603          	lw	a2,-28(s0)
    800047be:	fd843583          	ld	a1,-40(s0)
    800047c2:	fe843503          	ld	a0,-24(s0)
    800047c6:	fffff097          	auipc	ra,0xfffff
    800047ca:	4b8080e7          	jalr	1208(ra) # 80003c7e <filewrite>
}
    800047ce:	70a2                	ld	ra,40(sp)
    800047d0:	7402                	ld	s0,32(sp)
    800047d2:	6145                	addi	sp,sp,48
    800047d4:	8082                	ret

00000000800047d6 <sys_close>:
{
    800047d6:	1101                	addi	sp,sp,-32
    800047d8:	ec06                	sd	ra,24(sp)
    800047da:	e822                	sd	s0,16(sp)
    800047dc:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800047de:	fe040613          	addi	a2,s0,-32
    800047e2:	fec40593          	addi	a1,s0,-20
    800047e6:	4501                	li	a0,0
    800047e8:	00000097          	auipc	ra,0x0
    800047ec:	cc2080e7          	jalr	-830(ra) # 800044aa <argfd>
    return -1;
    800047f0:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800047f2:	02054463          	bltz	a0,8000481a <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800047f6:	ffffc097          	auipc	ra,0xffffc
    800047fa:	686080e7          	jalr	1670(ra) # 80000e7c <myproc>
    800047fe:	fec42783          	lw	a5,-20(s0)
    80004802:	07e9                	addi	a5,a5,26
    80004804:	078e                	slli	a5,a5,0x3
    80004806:	97aa                	add	a5,a5,a0
    80004808:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    8000480c:	fe043503          	ld	a0,-32(s0)
    80004810:	fffff097          	auipc	ra,0xfffff
    80004814:	272080e7          	jalr	626(ra) # 80003a82 <fileclose>
  return 0;
    80004818:	4781                	li	a5,0
}
    8000481a:	853e                	mv	a0,a5
    8000481c:	60e2                	ld	ra,24(sp)
    8000481e:	6442                	ld	s0,16(sp)
    80004820:	6105                	addi	sp,sp,32
    80004822:	8082                	ret

0000000080004824 <sys_fstat>:
{
    80004824:	1101                	addi	sp,sp,-32
    80004826:	ec06                	sd	ra,24(sp)
    80004828:	e822                	sd	s0,16(sp)
    8000482a:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    8000482c:	fe040593          	addi	a1,s0,-32
    80004830:	4505                	li	a0,1
    80004832:	ffffd097          	auipc	ra,0xffffd
    80004836:	7b0080e7          	jalr	1968(ra) # 80001fe2 <argaddr>
  if(argfd(0, 0, &f) < 0)
    8000483a:	fe840613          	addi	a2,s0,-24
    8000483e:	4581                	li	a1,0
    80004840:	4501                	li	a0,0
    80004842:	00000097          	auipc	ra,0x0
    80004846:	c68080e7          	jalr	-920(ra) # 800044aa <argfd>
    8000484a:	87aa                	mv	a5,a0
    return -1;
    8000484c:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000484e:	0007ca63          	bltz	a5,80004862 <sys_fstat+0x3e>
  return filestat(f, st);
    80004852:	fe043583          	ld	a1,-32(s0)
    80004856:	fe843503          	ld	a0,-24(s0)
    8000485a:	fffff097          	auipc	ra,0xfffff
    8000485e:	2f0080e7          	jalr	752(ra) # 80003b4a <filestat>
}
    80004862:	60e2                	ld	ra,24(sp)
    80004864:	6442                	ld	s0,16(sp)
    80004866:	6105                	addi	sp,sp,32
    80004868:	8082                	ret

000000008000486a <sys_link>:
{
    8000486a:	7169                	addi	sp,sp,-304
    8000486c:	f606                	sd	ra,296(sp)
    8000486e:	f222                	sd	s0,288(sp)
    80004870:	ee26                	sd	s1,280(sp)
    80004872:	ea4a                	sd	s2,272(sp)
    80004874:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004876:	08000613          	li	a2,128
    8000487a:	ed040593          	addi	a1,s0,-304
    8000487e:	4501                	li	a0,0
    80004880:	ffffd097          	auipc	ra,0xffffd
    80004884:	782080e7          	jalr	1922(ra) # 80002002 <argstr>
    return -1;
    80004888:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000488a:	10054e63          	bltz	a0,800049a6 <sys_link+0x13c>
    8000488e:	08000613          	li	a2,128
    80004892:	f5040593          	addi	a1,s0,-176
    80004896:	4505                	li	a0,1
    80004898:	ffffd097          	auipc	ra,0xffffd
    8000489c:	76a080e7          	jalr	1898(ra) # 80002002 <argstr>
    return -1;
    800048a0:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800048a2:	10054263          	bltz	a0,800049a6 <sys_link+0x13c>
  begin_op();
    800048a6:	fffff097          	auipc	ra,0xfffff
    800048aa:	d10080e7          	jalr	-752(ra) # 800035b6 <begin_op>
  if((ip = namei(old)) == 0){
    800048ae:	ed040513          	addi	a0,s0,-304
    800048b2:	fffff097          	auipc	ra,0xfffff
    800048b6:	ae8080e7          	jalr	-1304(ra) # 8000339a <namei>
    800048ba:	84aa                	mv	s1,a0
    800048bc:	c551                	beqz	a0,80004948 <sys_link+0xde>
  ilock(ip);
    800048be:	ffffe097          	auipc	ra,0xffffe
    800048c2:	336080e7          	jalr	822(ra) # 80002bf4 <ilock>
  if(ip->type == T_DIR){
    800048c6:	04449703          	lh	a4,68(s1)
    800048ca:	4785                	li	a5,1
    800048cc:	08f70463          	beq	a4,a5,80004954 <sys_link+0xea>
  ip->nlink++;
    800048d0:	04a4d783          	lhu	a5,74(s1)
    800048d4:	2785                	addiw	a5,a5,1
    800048d6:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800048da:	8526                	mv	a0,s1
    800048dc:	ffffe097          	auipc	ra,0xffffe
    800048e0:	24e080e7          	jalr	590(ra) # 80002b2a <iupdate>
  iunlock(ip);
    800048e4:	8526                	mv	a0,s1
    800048e6:	ffffe097          	auipc	ra,0xffffe
    800048ea:	3d0080e7          	jalr	976(ra) # 80002cb6 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800048ee:	fd040593          	addi	a1,s0,-48
    800048f2:	f5040513          	addi	a0,s0,-176
    800048f6:	fffff097          	auipc	ra,0xfffff
    800048fa:	ac2080e7          	jalr	-1342(ra) # 800033b8 <nameiparent>
    800048fe:	892a                	mv	s2,a0
    80004900:	c935                	beqz	a0,80004974 <sys_link+0x10a>
  ilock(dp);
    80004902:	ffffe097          	auipc	ra,0xffffe
    80004906:	2f2080e7          	jalr	754(ra) # 80002bf4 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    8000490a:	00092703          	lw	a4,0(s2)
    8000490e:	409c                	lw	a5,0(s1)
    80004910:	04f71d63          	bne	a4,a5,8000496a <sys_link+0x100>
    80004914:	40d0                	lw	a2,4(s1)
    80004916:	fd040593          	addi	a1,s0,-48
    8000491a:	854a                	mv	a0,s2
    8000491c:	fffff097          	auipc	ra,0xfffff
    80004920:	9cc080e7          	jalr	-1588(ra) # 800032e8 <dirlink>
    80004924:	04054363          	bltz	a0,8000496a <sys_link+0x100>
  iunlockput(dp);
    80004928:	854a                	mv	a0,s2
    8000492a:	ffffe097          	auipc	ra,0xffffe
    8000492e:	52c080e7          	jalr	1324(ra) # 80002e56 <iunlockput>
  iput(ip);
    80004932:	8526                	mv	a0,s1
    80004934:	ffffe097          	auipc	ra,0xffffe
    80004938:	47a080e7          	jalr	1146(ra) # 80002dae <iput>
  end_op();
    8000493c:	fffff097          	auipc	ra,0xfffff
    80004940:	cfa080e7          	jalr	-774(ra) # 80003636 <end_op>
  return 0;
    80004944:	4781                	li	a5,0
    80004946:	a085                	j	800049a6 <sys_link+0x13c>
    end_op();
    80004948:	fffff097          	auipc	ra,0xfffff
    8000494c:	cee080e7          	jalr	-786(ra) # 80003636 <end_op>
    return -1;
    80004950:	57fd                	li	a5,-1
    80004952:	a891                	j	800049a6 <sys_link+0x13c>
    iunlockput(ip);
    80004954:	8526                	mv	a0,s1
    80004956:	ffffe097          	auipc	ra,0xffffe
    8000495a:	500080e7          	jalr	1280(ra) # 80002e56 <iunlockput>
    end_op();
    8000495e:	fffff097          	auipc	ra,0xfffff
    80004962:	cd8080e7          	jalr	-808(ra) # 80003636 <end_op>
    return -1;
    80004966:	57fd                	li	a5,-1
    80004968:	a83d                	j	800049a6 <sys_link+0x13c>
    iunlockput(dp);
    8000496a:	854a                	mv	a0,s2
    8000496c:	ffffe097          	auipc	ra,0xffffe
    80004970:	4ea080e7          	jalr	1258(ra) # 80002e56 <iunlockput>
  ilock(ip);
    80004974:	8526                	mv	a0,s1
    80004976:	ffffe097          	auipc	ra,0xffffe
    8000497a:	27e080e7          	jalr	638(ra) # 80002bf4 <ilock>
  ip->nlink--;
    8000497e:	04a4d783          	lhu	a5,74(s1)
    80004982:	37fd                	addiw	a5,a5,-1
    80004984:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004988:	8526                	mv	a0,s1
    8000498a:	ffffe097          	auipc	ra,0xffffe
    8000498e:	1a0080e7          	jalr	416(ra) # 80002b2a <iupdate>
  iunlockput(ip);
    80004992:	8526                	mv	a0,s1
    80004994:	ffffe097          	auipc	ra,0xffffe
    80004998:	4c2080e7          	jalr	1218(ra) # 80002e56 <iunlockput>
  end_op();
    8000499c:	fffff097          	auipc	ra,0xfffff
    800049a0:	c9a080e7          	jalr	-870(ra) # 80003636 <end_op>
  return -1;
    800049a4:	57fd                	li	a5,-1
}
    800049a6:	853e                	mv	a0,a5
    800049a8:	70b2                	ld	ra,296(sp)
    800049aa:	7412                	ld	s0,288(sp)
    800049ac:	64f2                	ld	s1,280(sp)
    800049ae:	6952                	ld	s2,272(sp)
    800049b0:	6155                	addi	sp,sp,304
    800049b2:	8082                	ret

00000000800049b4 <sys_unlink>:
{
    800049b4:	7151                	addi	sp,sp,-240
    800049b6:	f586                	sd	ra,232(sp)
    800049b8:	f1a2                	sd	s0,224(sp)
    800049ba:	eda6                	sd	s1,216(sp)
    800049bc:	e9ca                	sd	s2,208(sp)
    800049be:	e5ce                	sd	s3,200(sp)
    800049c0:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800049c2:	08000613          	li	a2,128
    800049c6:	f3040593          	addi	a1,s0,-208
    800049ca:	4501                	li	a0,0
    800049cc:	ffffd097          	auipc	ra,0xffffd
    800049d0:	636080e7          	jalr	1590(ra) # 80002002 <argstr>
    800049d4:	18054163          	bltz	a0,80004b56 <sys_unlink+0x1a2>
  begin_op();
    800049d8:	fffff097          	auipc	ra,0xfffff
    800049dc:	bde080e7          	jalr	-1058(ra) # 800035b6 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800049e0:	fb040593          	addi	a1,s0,-80
    800049e4:	f3040513          	addi	a0,s0,-208
    800049e8:	fffff097          	auipc	ra,0xfffff
    800049ec:	9d0080e7          	jalr	-1584(ra) # 800033b8 <nameiparent>
    800049f0:	84aa                	mv	s1,a0
    800049f2:	c979                	beqz	a0,80004ac8 <sys_unlink+0x114>
  ilock(dp);
    800049f4:	ffffe097          	auipc	ra,0xffffe
    800049f8:	200080e7          	jalr	512(ra) # 80002bf4 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800049fc:	00004597          	auipc	a1,0x4
    80004a00:	d4458593          	addi	a1,a1,-700 # 80008740 <syscalls+0x2a8>
    80004a04:	fb040513          	addi	a0,s0,-80
    80004a08:	ffffe097          	auipc	ra,0xffffe
    80004a0c:	6b6080e7          	jalr	1718(ra) # 800030be <namecmp>
    80004a10:	14050a63          	beqz	a0,80004b64 <sys_unlink+0x1b0>
    80004a14:	00004597          	auipc	a1,0x4
    80004a18:	d3458593          	addi	a1,a1,-716 # 80008748 <syscalls+0x2b0>
    80004a1c:	fb040513          	addi	a0,s0,-80
    80004a20:	ffffe097          	auipc	ra,0xffffe
    80004a24:	69e080e7          	jalr	1694(ra) # 800030be <namecmp>
    80004a28:	12050e63          	beqz	a0,80004b64 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004a2c:	f2c40613          	addi	a2,s0,-212
    80004a30:	fb040593          	addi	a1,s0,-80
    80004a34:	8526                	mv	a0,s1
    80004a36:	ffffe097          	auipc	ra,0xffffe
    80004a3a:	6a2080e7          	jalr	1698(ra) # 800030d8 <dirlookup>
    80004a3e:	892a                	mv	s2,a0
    80004a40:	12050263          	beqz	a0,80004b64 <sys_unlink+0x1b0>
  ilock(ip);
    80004a44:	ffffe097          	auipc	ra,0xffffe
    80004a48:	1b0080e7          	jalr	432(ra) # 80002bf4 <ilock>
  if(ip->nlink < 1)
    80004a4c:	04a91783          	lh	a5,74(s2)
    80004a50:	08f05263          	blez	a5,80004ad4 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004a54:	04491703          	lh	a4,68(s2)
    80004a58:	4785                	li	a5,1
    80004a5a:	08f70563          	beq	a4,a5,80004ae4 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004a5e:	4641                	li	a2,16
    80004a60:	4581                	li	a1,0
    80004a62:	fc040513          	addi	a0,s0,-64
    80004a66:	ffffb097          	auipc	ra,0xffffb
    80004a6a:	736080e7          	jalr	1846(ra) # 8000019c <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a6e:	4741                	li	a4,16
    80004a70:	f2c42683          	lw	a3,-212(s0)
    80004a74:	fc040613          	addi	a2,s0,-64
    80004a78:	4581                	li	a1,0
    80004a7a:	8526                	mv	a0,s1
    80004a7c:	ffffe097          	auipc	ra,0xffffe
    80004a80:	524080e7          	jalr	1316(ra) # 80002fa0 <writei>
    80004a84:	47c1                	li	a5,16
    80004a86:	0af51563          	bne	a0,a5,80004b30 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004a8a:	04491703          	lh	a4,68(s2)
    80004a8e:	4785                	li	a5,1
    80004a90:	0af70863          	beq	a4,a5,80004b40 <sys_unlink+0x18c>
  iunlockput(dp);
    80004a94:	8526                	mv	a0,s1
    80004a96:	ffffe097          	auipc	ra,0xffffe
    80004a9a:	3c0080e7          	jalr	960(ra) # 80002e56 <iunlockput>
  ip->nlink--;
    80004a9e:	04a95783          	lhu	a5,74(s2)
    80004aa2:	37fd                	addiw	a5,a5,-1
    80004aa4:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004aa8:	854a                	mv	a0,s2
    80004aaa:	ffffe097          	auipc	ra,0xffffe
    80004aae:	080080e7          	jalr	128(ra) # 80002b2a <iupdate>
  iunlockput(ip);
    80004ab2:	854a                	mv	a0,s2
    80004ab4:	ffffe097          	auipc	ra,0xffffe
    80004ab8:	3a2080e7          	jalr	930(ra) # 80002e56 <iunlockput>
  end_op();
    80004abc:	fffff097          	auipc	ra,0xfffff
    80004ac0:	b7a080e7          	jalr	-1158(ra) # 80003636 <end_op>
  return 0;
    80004ac4:	4501                	li	a0,0
    80004ac6:	a84d                	j	80004b78 <sys_unlink+0x1c4>
    end_op();
    80004ac8:	fffff097          	auipc	ra,0xfffff
    80004acc:	b6e080e7          	jalr	-1170(ra) # 80003636 <end_op>
    return -1;
    80004ad0:	557d                	li	a0,-1
    80004ad2:	a05d                	j	80004b78 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004ad4:	00004517          	auipc	a0,0x4
    80004ad8:	c7c50513          	addi	a0,a0,-900 # 80008750 <syscalls+0x2b8>
    80004adc:	00001097          	auipc	ra,0x1
    80004ae0:	216080e7          	jalr	534(ra) # 80005cf2 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004ae4:	04c92703          	lw	a4,76(s2)
    80004ae8:	02000793          	li	a5,32
    80004aec:	f6e7f9e3          	bgeu	a5,a4,80004a5e <sys_unlink+0xaa>
    80004af0:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004af4:	4741                	li	a4,16
    80004af6:	86ce                	mv	a3,s3
    80004af8:	f1840613          	addi	a2,s0,-232
    80004afc:	4581                	li	a1,0
    80004afe:	854a                	mv	a0,s2
    80004b00:	ffffe097          	auipc	ra,0xffffe
    80004b04:	3a8080e7          	jalr	936(ra) # 80002ea8 <readi>
    80004b08:	47c1                	li	a5,16
    80004b0a:	00f51b63          	bne	a0,a5,80004b20 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004b0e:	f1845783          	lhu	a5,-232(s0)
    80004b12:	e7a1                	bnez	a5,80004b5a <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004b14:	29c1                	addiw	s3,s3,16
    80004b16:	04c92783          	lw	a5,76(s2)
    80004b1a:	fcf9ede3          	bltu	s3,a5,80004af4 <sys_unlink+0x140>
    80004b1e:	b781                	j	80004a5e <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004b20:	00004517          	auipc	a0,0x4
    80004b24:	c4850513          	addi	a0,a0,-952 # 80008768 <syscalls+0x2d0>
    80004b28:	00001097          	auipc	ra,0x1
    80004b2c:	1ca080e7          	jalr	458(ra) # 80005cf2 <panic>
    panic("unlink: writei");
    80004b30:	00004517          	auipc	a0,0x4
    80004b34:	c5050513          	addi	a0,a0,-944 # 80008780 <syscalls+0x2e8>
    80004b38:	00001097          	auipc	ra,0x1
    80004b3c:	1ba080e7          	jalr	442(ra) # 80005cf2 <panic>
    dp->nlink--;
    80004b40:	04a4d783          	lhu	a5,74(s1)
    80004b44:	37fd                	addiw	a5,a5,-1
    80004b46:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004b4a:	8526                	mv	a0,s1
    80004b4c:	ffffe097          	auipc	ra,0xffffe
    80004b50:	fde080e7          	jalr	-34(ra) # 80002b2a <iupdate>
    80004b54:	b781                	j	80004a94 <sys_unlink+0xe0>
    return -1;
    80004b56:	557d                	li	a0,-1
    80004b58:	a005                	j	80004b78 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004b5a:	854a                	mv	a0,s2
    80004b5c:	ffffe097          	auipc	ra,0xffffe
    80004b60:	2fa080e7          	jalr	762(ra) # 80002e56 <iunlockput>
  iunlockput(dp);
    80004b64:	8526                	mv	a0,s1
    80004b66:	ffffe097          	auipc	ra,0xffffe
    80004b6a:	2f0080e7          	jalr	752(ra) # 80002e56 <iunlockput>
  end_op();
    80004b6e:	fffff097          	auipc	ra,0xfffff
    80004b72:	ac8080e7          	jalr	-1336(ra) # 80003636 <end_op>
  return -1;
    80004b76:	557d                	li	a0,-1
}
    80004b78:	70ae                	ld	ra,232(sp)
    80004b7a:	740e                	ld	s0,224(sp)
    80004b7c:	64ee                	ld	s1,216(sp)
    80004b7e:	694e                	ld	s2,208(sp)
    80004b80:	69ae                	ld	s3,200(sp)
    80004b82:	616d                	addi	sp,sp,240
    80004b84:	8082                	ret

0000000080004b86 <sys_open>:

uint64
sys_open(void)
{
    80004b86:	7131                	addi	sp,sp,-192
    80004b88:	fd06                	sd	ra,184(sp)
    80004b8a:	f922                	sd	s0,176(sp)
    80004b8c:	f526                	sd	s1,168(sp)
    80004b8e:	f14a                	sd	s2,160(sp)
    80004b90:	ed4e                	sd	s3,152(sp)
    80004b92:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004b94:	f4c40593          	addi	a1,s0,-180
    80004b98:	4505                	li	a0,1
    80004b9a:	ffffd097          	auipc	ra,0xffffd
    80004b9e:	428080e7          	jalr	1064(ra) # 80001fc2 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004ba2:	08000613          	li	a2,128
    80004ba6:	f5040593          	addi	a1,s0,-176
    80004baa:	4501                	li	a0,0
    80004bac:	ffffd097          	auipc	ra,0xffffd
    80004bb0:	456080e7          	jalr	1110(ra) # 80002002 <argstr>
    80004bb4:	87aa                	mv	a5,a0
    return -1;
    80004bb6:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004bb8:	0a07c963          	bltz	a5,80004c6a <sys_open+0xe4>

  begin_op();
    80004bbc:	fffff097          	auipc	ra,0xfffff
    80004bc0:	9fa080e7          	jalr	-1542(ra) # 800035b6 <begin_op>

  if(omode & O_CREATE){
    80004bc4:	f4c42783          	lw	a5,-180(s0)
    80004bc8:	2007f793          	andi	a5,a5,512
    80004bcc:	cfc5                	beqz	a5,80004c84 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004bce:	4681                	li	a3,0
    80004bd0:	4601                	li	a2,0
    80004bd2:	4589                	li	a1,2
    80004bd4:	f5040513          	addi	a0,s0,-176
    80004bd8:	00000097          	auipc	ra,0x0
    80004bdc:	974080e7          	jalr	-1676(ra) # 8000454c <create>
    80004be0:	84aa                	mv	s1,a0
    if(ip == 0){
    80004be2:	c959                	beqz	a0,80004c78 <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004be4:	04449703          	lh	a4,68(s1)
    80004be8:	478d                	li	a5,3
    80004bea:	00f71763          	bne	a4,a5,80004bf8 <sys_open+0x72>
    80004bee:	0464d703          	lhu	a4,70(s1)
    80004bf2:	47a5                	li	a5,9
    80004bf4:	0ce7ed63          	bltu	a5,a4,80004cce <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004bf8:	fffff097          	auipc	ra,0xfffff
    80004bfc:	dce080e7          	jalr	-562(ra) # 800039c6 <filealloc>
    80004c00:	89aa                	mv	s3,a0
    80004c02:	10050363          	beqz	a0,80004d08 <sys_open+0x182>
    80004c06:	00000097          	auipc	ra,0x0
    80004c0a:	904080e7          	jalr	-1788(ra) # 8000450a <fdalloc>
    80004c0e:	892a                	mv	s2,a0
    80004c10:	0e054763          	bltz	a0,80004cfe <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004c14:	04449703          	lh	a4,68(s1)
    80004c18:	478d                	li	a5,3
    80004c1a:	0cf70563          	beq	a4,a5,80004ce4 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004c1e:	4789                	li	a5,2
    80004c20:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004c24:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004c28:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004c2c:	f4c42783          	lw	a5,-180(s0)
    80004c30:	0017c713          	xori	a4,a5,1
    80004c34:	8b05                	andi	a4,a4,1
    80004c36:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004c3a:	0037f713          	andi	a4,a5,3
    80004c3e:	00e03733          	snez	a4,a4
    80004c42:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004c46:	4007f793          	andi	a5,a5,1024
    80004c4a:	c791                	beqz	a5,80004c56 <sys_open+0xd0>
    80004c4c:	04449703          	lh	a4,68(s1)
    80004c50:	4789                	li	a5,2
    80004c52:	0af70063          	beq	a4,a5,80004cf2 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004c56:	8526                	mv	a0,s1
    80004c58:	ffffe097          	auipc	ra,0xffffe
    80004c5c:	05e080e7          	jalr	94(ra) # 80002cb6 <iunlock>
  end_op();
    80004c60:	fffff097          	auipc	ra,0xfffff
    80004c64:	9d6080e7          	jalr	-1578(ra) # 80003636 <end_op>

  return fd;
    80004c68:	854a                	mv	a0,s2
}
    80004c6a:	70ea                	ld	ra,184(sp)
    80004c6c:	744a                	ld	s0,176(sp)
    80004c6e:	74aa                	ld	s1,168(sp)
    80004c70:	790a                	ld	s2,160(sp)
    80004c72:	69ea                	ld	s3,152(sp)
    80004c74:	6129                	addi	sp,sp,192
    80004c76:	8082                	ret
      end_op();
    80004c78:	fffff097          	auipc	ra,0xfffff
    80004c7c:	9be080e7          	jalr	-1602(ra) # 80003636 <end_op>
      return -1;
    80004c80:	557d                	li	a0,-1
    80004c82:	b7e5                	j	80004c6a <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004c84:	f5040513          	addi	a0,s0,-176
    80004c88:	ffffe097          	auipc	ra,0xffffe
    80004c8c:	712080e7          	jalr	1810(ra) # 8000339a <namei>
    80004c90:	84aa                	mv	s1,a0
    80004c92:	c905                	beqz	a0,80004cc2 <sys_open+0x13c>
    ilock(ip);
    80004c94:	ffffe097          	auipc	ra,0xffffe
    80004c98:	f60080e7          	jalr	-160(ra) # 80002bf4 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004c9c:	04449703          	lh	a4,68(s1)
    80004ca0:	4785                	li	a5,1
    80004ca2:	f4f711e3          	bne	a4,a5,80004be4 <sys_open+0x5e>
    80004ca6:	f4c42783          	lw	a5,-180(s0)
    80004caa:	d7b9                	beqz	a5,80004bf8 <sys_open+0x72>
      iunlockput(ip);
    80004cac:	8526                	mv	a0,s1
    80004cae:	ffffe097          	auipc	ra,0xffffe
    80004cb2:	1a8080e7          	jalr	424(ra) # 80002e56 <iunlockput>
      end_op();
    80004cb6:	fffff097          	auipc	ra,0xfffff
    80004cba:	980080e7          	jalr	-1664(ra) # 80003636 <end_op>
      return -1;
    80004cbe:	557d                	li	a0,-1
    80004cc0:	b76d                	j	80004c6a <sys_open+0xe4>
      end_op();
    80004cc2:	fffff097          	auipc	ra,0xfffff
    80004cc6:	974080e7          	jalr	-1676(ra) # 80003636 <end_op>
      return -1;
    80004cca:	557d                	li	a0,-1
    80004ccc:	bf79                	j	80004c6a <sys_open+0xe4>
    iunlockput(ip);
    80004cce:	8526                	mv	a0,s1
    80004cd0:	ffffe097          	auipc	ra,0xffffe
    80004cd4:	186080e7          	jalr	390(ra) # 80002e56 <iunlockput>
    end_op();
    80004cd8:	fffff097          	auipc	ra,0xfffff
    80004cdc:	95e080e7          	jalr	-1698(ra) # 80003636 <end_op>
    return -1;
    80004ce0:	557d                	li	a0,-1
    80004ce2:	b761                	j	80004c6a <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004ce4:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004ce8:	04649783          	lh	a5,70(s1)
    80004cec:	02f99223          	sh	a5,36(s3)
    80004cf0:	bf25                	j	80004c28 <sys_open+0xa2>
    itrunc(ip);
    80004cf2:	8526                	mv	a0,s1
    80004cf4:	ffffe097          	auipc	ra,0xffffe
    80004cf8:	00e080e7          	jalr	14(ra) # 80002d02 <itrunc>
    80004cfc:	bfa9                	j	80004c56 <sys_open+0xd0>
      fileclose(f);
    80004cfe:	854e                	mv	a0,s3
    80004d00:	fffff097          	auipc	ra,0xfffff
    80004d04:	d82080e7          	jalr	-638(ra) # 80003a82 <fileclose>
    iunlockput(ip);
    80004d08:	8526                	mv	a0,s1
    80004d0a:	ffffe097          	auipc	ra,0xffffe
    80004d0e:	14c080e7          	jalr	332(ra) # 80002e56 <iunlockput>
    end_op();
    80004d12:	fffff097          	auipc	ra,0xfffff
    80004d16:	924080e7          	jalr	-1756(ra) # 80003636 <end_op>
    return -1;
    80004d1a:	557d                	li	a0,-1
    80004d1c:	b7b9                	j	80004c6a <sys_open+0xe4>

0000000080004d1e <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004d1e:	7175                	addi	sp,sp,-144
    80004d20:	e506                	sd	ra,136(sp)
    80004d22:	e122                	sd	s0,128(sp)
    80004d24:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004d26:	fffff097          	auipc	ra,0xfffff
    80004d2a:	890080e7          	jalr	-1904(ra) # 800035b6 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004d2e:	08000613          	li	a2,128
    80004d32:	f7040593          	addi	a1,s0,-144
    80004d36:	4501                	li	a0,0
    80004d38:	ffffd097          	auipc	ra,0xffffd
    80004d3c:	2ca080e7          	jalr	714(ra) # 80002002 <argstr>
    80004d40:	02054963          	bltz	a0,80004d72 <sys_mkdir+0x54>
    80004d44:	4681                	li	a3,0
    80004d46:	4601                	li	a2,0
    80004d48:	4585                	li	a1,1
    80004d4a:	f7040513          	addi	a0,s0,-144
    80004d4e:	fffff097          	auipc	ra,0xfffff
    80004d52:	7fe080e7          	jalr	2046(ra) # 8000454c <create>
    80004d56:	cd11                	beqz	a0,80004d72 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d58:	ffffe097          	auipc	ra,0xffffe
    80004d5c:	0fe080e7          	jalr	254(ra) # 80002e56 <iunlockput>
  end_op();
    80004d60:	fffff097          	auipc	ra,0xfffff
    80004d64:	8d6080e7          	jalr	-1834(ra) # 80003636 <end_op>
  return 0;
    80004d68:	4501                	li	a0,0
}
    80004d6a:	60aa                	ld	ra,136(sp)
    80004d6c:	640a                	ld	s0,128(sp)
    80004d6e:	6149                	addi	sp,sp,144
    80004d70:	8082                	ret
    end_op();
    80004d72:	fffff097          	auipc	ra,0xfffff
    80004d76:	8c4080e7          	jalr	-1852(ra) # 80003636 <end_op>
    return -1;
    80004d7a:	557d                	li	a0,-1
    80004d7c:	b7fd                	j	80004d6a <sys_mkdir+0x4c>

0000000080004d7e <sys_mknod>:

uint64
sys_mknod(void)
{
    80004d7e:	7135                	addi	sp,sp,-160
    80004d80:	ed06                	sd	ra,152(sp)
    80004d82:	e922                	sd	s0,144(sp)
    80004d84:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004d86:	fffff097          	auipc	ra,0xfffff
    80004d8a:	830080e7          	jalr	-2000(ra) # 800035b6 <begin_op>
  argint(1, &major);
    80004d8e:	f6c40593          	addi	a1,s0,-148
    80004d92:	4505                	li	a0,1
    80004d94:	ffffd097          	auipc	ra,0xffffd
    80004d98:	22e080e7          	jalr	558(ra) # 80001fc2 <argint>
  argint(2, &minor);
    80004d9c:	f6840593          	addi	a1,s0,-152
    80004da0:	4509                	li	a0,2
    80004da2:	ffffd097          	auipc	ra,0xffffd
    80004da6:	220080e7          	jalr	544(ra) # 80001fc2 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004daa:	08000613          	li	a2,128
    80004dae:	f7040593          	addi	a1,s0,-144
    80004db2:	4501                	li	a0,0
    80004db4:	ffffd097          	auipc	ra,0xffffd
    80004db8:	24e080e7          	jalr	590(ra) # 80002002 <argstr>
    80004dbc:	02054b63          	bltz	a0,80004df2 <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004dc0:	f6841683          	lh	a3,-152(s0)
    80004dc4:	f6c41603          	lh	a2,-148(s0)
    80004dc8:	458d                	li	a1,3
    80004dca:	f7040513          	addi	a0,s0,-144
    80004dce:	fffff097          	auipc	ra,0xfffff
    80004dd2:	77e080e7          	jalr	1918(ra) # 8000454c <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004dd6:	cd11                	beqz	a0,80004df2 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004dd8:	ffffe097          	auipc	ra,0xffffe
    80004ddc:	07e080e7          	jalr	126(ra) # 80002e56 <iunlockput>
  end_op();
    80004de0:	fffff097          	auipc	ra,0xfffff
    80004de4:	856080e7          	jalr	-1962(ra) # 80003636 <end_op>
  return 0;
    80004de8:	4501                	li	a0,0
}
    80004dea:	60ea                	ld	ra,152(sp)
    80004dec:	644a                	ld	s0,144(sp)
    80004dee:	610d                	addi	sp,sp,160
    80004df0:	8082                	ret
    end_op();
    80004df2:	fffff097          	auipc	ra,0xfffff
    80004df6:	844080e7          	jalr	-1980(ra) # 80003636 <end_op>
    return -1;
    80004dfa:	557d                	li	a0,-1
    80004dfc:	b7fd                	j	80004dea <sys_mknod+0x6c>

0000000080004dfe <sys_chdir>:

uint64
sys_chdir(void)
{
    80004dfe:	7135                	addi	sp,sp,-160
    80004e00:	ed06                	sd	ra,152(sp)
    80004e02:	e922                	sd	s0,144(sp)
    80004e04:	e526                	sd	s1,136(sp)
    80004e06:	e14a                	sd	s2,128(sp)
    80004e08:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004e0a:	ffffc097          	auipc	ra,0xffffc
    80004e0e:	072080e7          	jalr	114(ra) # 80000e7c <myproc>
    80004e12:	892a                	mv	s2,a0
  
  begin_op();
    80004e14:	ffffe097          	auipc	ra,0xffffe
    80004e18:	7a2080e7          	jalr	1954(ra) # 800035b6 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004e1c:	08000613          	li	a2,128
    80004e20:	f6040593          	addi	a1,s0,-160
    80004e24:	4501                	li	a0,0
    80004e26:	ffffd097          	auipc	ra,0xffffd
    80004e2a:	1dc080e7          	jalr	476(ra) # 80002002 <argstr>
    80004e2e:	04054b63          	bltz	a0,80004e84 <sys_chdir+0x86>
    80004e32:	f6040513          	addi	a0,s0,-160
    80004e36:	ffffe097          	auipc	ra,0xffffe
    80004e3a:	564080e7          	jalr	1380(ra) # 8000339a <namei>
    80004e3e:	84aa                	mv	s1,a0
    80004e40:	c131                	beqz	a0,80004e84 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004e42:	ffffe097          	auipc	ra,0xffffe
    80004e46:	db2080e7          	jalr	-590(ra) # 80002bf4 <ilock>
  if(ip->type != T_DIR){
    80004e4a:	04449703          	lh	a4,68(s1)
    80004e4e:	4785                	li	a5,1
    80004e50:	04f71063          	bne	a4,a5,80004e90 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004e54:	8526                	mv	a0,s1
    80004e56:	ffffe097          	auipc	ra,0xffffe
    80004e5a:	e60080e7          	jalr	-416(ra) # 80002cb6 <iunlock>
  iput(p->cwd);
    80004e5e:	15093503          	ld	a0,336(s2)
    80004e62:	ffffe097          	auipc	ra,0xffffe
    80004e66:	f4c080e7          	jalr	-180(ra) # 80002dae <iput>
  end_op();
    80004e6a:	ffffe097          	auipc	ra,0xffffe
    80004e6e:	7cc080e7          	jalr	1996(ra) # 80003636 <end_op>
  p->cwd = ip;
    80004e72:	14993823          	sd	s1,336(s2)
  return 0;
    80004e76:	4501                	li	a0,0
}
    80004e78:	60ea                	ld	ra,152(sp)
    80004e7a:	644a                	ld	s0,144(sp)
    80004e7c:	64aa                	ld	s1,136(sp)
    80004e7e:	690a                	ld	s2,128(sp)
    80004e80:	610d                	addi	sp,sp,160
    80004e82:	8082                	ret
    end_op();
    80004e84:	ffffe097          	auipc	ra,0xffffe
    80004e88:	7b2080e7          	jalr	1970(ra) # 80003636 <end_op>
    return -1;
    80004e8c:	557d                	li	a0,-1
    80004e8e:	b7ed                	j	80004e78 <sys_chdir+0x7a>
    iunlockput(ip);
    80004e90:	8526                	mv	a0,s1
    80004e92:	ffffe097          	auipc	ra,0xffffe
    80004e96:	fc4080e7          	jalr	-60(ra) # 80002e56 <iunlockput>
    end_op();
    80004e9a:	ffffe097          	auipc	ra,0xffffe
    80004e9e:	79c080e7          	jalr	1948(ra) # 80003636 <end_op>
    return -1;
    80004ea2:	557d                	li	a0,-1
    80004ea4:	bfd1                	j	80004e78 <sys_chdir+0x7a>

0000000080004ea6 <sys_exec>:

uint64
sys_exec(void)
{
    80004ea6:	7145                	addi	sp,sp,-464
    80004ea8:	e786                	sd	ra,456(sp)
    80004eaa:	e3a2                	sd	s0,448(sp)
    80004eac:	ff26                	sd	s1,440(sp)
    80004eae:	fb4a                	sd	s2,432(sp)
    80004eb0:	f74e                	sd	s3,424(sp)
    80004eb2:	f352                	sd	s4,416(sp)
    80004eb4:	ef56                	sd	s5,408(sp)
    80004eb6:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004eb8:	e3840593          	addi	a1,s0,-456
    80004ebc:	4505                	li	a0,1
    80004ebe:	ffffd097          	auipc	ra,0xffffd
    80004ec2:	124080e7          	jalr	292(ra) # 80001fe2 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004ec6:	08000613          	li	a2,128
    80004eca:	f4040593          	addi	a1,s0,-192
    80004ece:	4501                	li	a0,0
    80004ed0:	ffffd097          	auipc	ra,0xffffd
    80004ed4:	132080e7          	jalr	306(ra) # 80002002 <argstr>
    80004ed8:	87aa                	mv	a5,a0
    return -1;
    80004eda:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004edc:	0c07c263          	bltz	a5,80004fa0 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80004ee0:	10000613          	li	a2,256
    80004ee4:	4581                	li	a1,0
    80004ee6:	e4040513          	addi	a0,s0,-448
    80004eea:	ffffb097          	auipc	ra,0xffffb
    80004eee:	2b2080e7          	jalr	690(ra) # 8000019c <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004ef2:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004ef6:	89a6                	mv	s3,s1
    80004ef8:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004efa:	02000a13          	li	s4,32
    80004efe:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004f02:	00391513          	slli	a0,s2,0x3
    80004f06:	e3040593          	addi	a1,s0,-464
    80004f0a:	e3843783          	ld	a5,-456(s0)
    80004f0e:	953e                	add	a0,a0,a5
    80004f10:	ffffd097          	auipc	ra,0xffffd
    80004f14:	014080e7          	jalr	20(ra) # 80001f24 <fetchaddr>
    80004f18:	02054a63          	bltz	a0,80004f4c <sys_exec+0xa6>
      goto bad;
    }
    if(uarg == 0){
    80004f1c:	e3043783          	ld	a5,-464(s0)
    80004f20:	c3b9                	beqz	a5,80004f66 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004f22:	ffffb097          	auipc	ra,0xffffb
    80004f26:	1f6080e7          	jalr	502(ra) # 80000118 <kalloc>
    80004f2a:	85aa                	mv	a1,a0
    80004f2c:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004f30:	cd11                	beqz	a0,80004f4c <sys_exec+0xa6>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004f32:	6605                	lui	a2,0x1
    80004f34:	e3043503          	ld	a0,-464(s0)
    80004f38:	ffffd097          	auipc	ra,0xffffd
    80004f3c:	03e080e7          	jalr	62(ra) # 80001f76 <fetchstr>
    80004f40:	00054663          	bltz	a0,80004f4c <sys_exec+0xa6>
    if(i >= NELEM(argv)){
    80004f44:	0905                	addi	s2,s2,1
    80004f46:	09a1                	addi	s3,s3,8
    80004f48:	fb491be3          	bne	s2,s4,80004efe <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f4c:	10048913          	addi	s2,s1,256
    80004f50:	6088                	ld	a0,0(s1)
    80004f52:	c531                	beqz	a0,80004f9e <sys_exec+0xf8>
    kfree(argv[i]);
    80004f54:	ffffb097          	auipc	ra,0xffffb
    80004f58:	0c8080e7          	jalr	200(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f5c:	04a1                	addi	s1,s1,8
    80004f5e:	ff2499e3          	bne	s1,s2,80004f50 <sys_exec+0xaa>
  return -1;
    80004f62:	557d                	li	a0,-1
    80004f64:	a835                	j	80004fa0 <sys_exec+0xfa>
      argv[i] = 0;
    80004f66:	0a8e                	slli	s5,s5,0x3
    80004f68:	fc040793          	addi	a5,s0,-64
    80004f6c:	9abe                	add	s5,s5,a5
    80004f6e:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80004f72:	e4040593          	addi	a1,s0,-448
    80004f76:	f4040513          	addi	a0,s0,-192
    80004f7a:	fffff097          	auipc	ra,0xfffff
    80004f7e:	190080e7          	jalr	400(ra) # 8000410a <exec>
    80004f82:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f84:	10048993          	addi	s3,s1,256
    80004f88:	6088                	ld	a0,0(s1)
    80004f8a:	c901                	beqz	a0,80004f9a <sys_exec+0xf4>
    kfree(argv[i]);
    80004f8c:	ffffb097          	auipc	ra,0xffffb
    80004f90:	090080e7          	jalr	144(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f94:	04a1                	addi	s1,s1,8
    80004f96:	ff3499e3          	bne	s1,s3,80004f88 <sys_exec+0xe2>
  return ret;
    80004f9a:	854a                	mv	a0,s2
    80004f9c:	a011                	j	80004fa0 <sys_exec+0xfa>
  return -1;
    80004f9e:	557d                	li	a0,-1
}
    80004fa0:	60be                	ld	ra,456(sp)
    80004fa2:	641e                	ld	s0,448(sp)
    80004fa4:	74fa                	ld	s1,440(sp)
    80004fa6:	795a                	ld	s2,432(sp)
    80004fa8:	79ba                	ld	s3,424(sp)
    80004faa:	7a1a                	ld	s4,416(sp)
    80004fac:	6afa                	ld	s5,408(sp)
    80004fae:	6179                	addi	sp,sp,464
    80004fb0:	8082                	ret

0000000080004fb2 <sys_pipe>:

uint64
sys_pipe(void)
{
    80004fb2:	7139                	addi	sp,sp,-64
    80004fb4:	fc06                	sd	ra,56(sp)
    80004fb6:	f822                	sd	s0,48(sp)
    80004fb8:	f426                	sd	s1,40(sp)
    80004fba:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004fbc:	ffffc097          	auipc	ra,0xffffc
    80004fc0:	ec0080e7          	jalr	-320(ra) # 80000e7c <myproc>
    80004fc4:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80004fc6:	fd840593          	addi	a1,s0,-40
    80004fca:	4501                	li	a0,0
    80004fcc:	ffffd097          	auipc	ra,0xffffd
    80004fd0:	016080e7          	jalr	22(ra) # 80001fe2 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80004fd4:	fc840593          	addi	a1,s0,-56
    80004fd8:	fd040513          	addi	a0,s0,-48
    80004fdc:	fffff097          	auipc	ra,0xfffff
    80004fe0:	dd6080e7          	jalr	-554(ra) # 80003db2 <pipealloc>
    return -1;
    80004fe4:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004fe6:	0c054463          	bltz	a0,800050ae <sys_pipe+0xfc>
  fd0 = -1;
    80004fea:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004fee:	fd043503          	ld	a0,-48(s0)
    80004ff2:	fffff097          	auipc	ra,0xfffff
    80004ff6:	518080e7          	jalr	1304(ra) # 8000450a <fdalloc>
    80004ffa:	fca42223          	sw	a0,-60(s0)
    80004ffe:	08054b63          	bltz	a0,80005094 <sys_pipe+0xe2>
    80005002:	fc843503          	ld	a0,-56(s0)
    80005006:	fffff097          	auipc	ra,0xfffff
    8000500a:	504080e7          	jalr	1284(ra) # 8000450a <fdalloc>
    8000500e:	fca42023          	sw	a0,-64(s0)
    80005012:	06054863          	bltz	a0,80005082 <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005016:	4691                	li	a3,4
    80005018:	fc440613          	addi	a2,s0,-60
    8000501c:	fd843583          	ld	a1,-40(s0)
    80005020:	68a8                	ld	a0,80(s1)
    80005022:	ffffc097          	auipc	ra,0xffffc
    80005026:	b18080e7          	jalr	-1256(ra) # 80000b3a <copyout>
    8000502a:	02054063          	bltz	a0,8000504a <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000502e:	4691                	li	a3,4
    80005030:	fc040613          	addi	a2,s0,-64
    80005034:	fd843583          	ld	a1,-40(s0)
    80005038:	0591                	addi	a1,a1,4
    8000503a:	68a8                	ld	a0,80(s1)
    8000503c:	ffffc097          	auipc	ra,0xffffc
    80005040:	afe080e7          	jalr	-1282(ra) # 80000b3a <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005044:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005046:	06055463          	bgez	a0,800050ae <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    8000504a:	fc442783          	lw	a5,-60(s0)
    8000504e:	07e9                	addi	a5,a5,26
    80005050:	078e                	slli	a5,a5,0x3
    80005052:	97a6                	add	a5,a5,s1
    80005054:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005058:	fc042503          	lw	a0,-64(s0)
    8000505c:	0569                	addi	a0,a0,26
    8000505e:	050e                	slli	a0,a0,0x3
    80005060:	94aa                	add	s1,s1,a0
    80005062:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005066:	fd043503          	ld	a0,-48(s0)
    8000506a:	fffff097          	auipc	ra,0xfffff
    8000506e:	a18080e7          	jalr	-1512(ra) # 80003a82 <fileclose>
    fileclose(wf);
    80005072:	fc843503          	ld	a0,-56(s0)
    80005076:	fffff097          	auipc	ra,0xfffff
    8000507a:	a0c080e7          	jalr	-1524(ra) # 80003a82 <fileclose>
    return -1;
    8000507e:	57fd                	li	a5,-1
    80005080:	a03d                	j	800050ae <sys_pipe+0xfc>
    if(fd0 >= 0)
    80005082:	fc442783          	lw	a5,-60(s0)
    80005086:	0007c763          	bltz	a5,80005094 <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    8000508a:	07e9                	addi	a5,a5,26
    8000508c:	078e                	slli	a5,a5,0x3
    8000508e:	94be                	add	s1,s1,a5
    80005090:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005094:	fd043503          	ld	a0,-48(s0)
    80005098:	fffff097          	auipc	ra,0xfffff
    8000509c:	9ea080e7          	jalr	-1558(ra) # 80003a82 <fileclose>
    fileclose(wf);
    800050a0:	fc843503          	ld	a0,-56(s0)
    800050a4:	fffff097          	auipc	ra,0xfffff
    800050a8:	9de080e7          	jalr	-1570(ra) # 80003a82 <fileclose>
    return -1;
    800050ac:	57fd                	li	a5,-1
}
    800050ae:	853e                	mv	a0,a5
    800050b0:	70e2                	ld	ra,56(sp)
    800050b2:	7442                	ld	s0,48(sp)
    800050b4:	74a2                	ld	s1,40(sp)
    800050b6:	6121                	addi	sp,sp,64
    800050b8:	8082                	ret
    800050ba:	0000                	unimp
    800050bc:	0000                	unimp
	...

00000000800050c0 <kernelvec>:
    800050c0:	7111                	addi	sp,sp,-256
    800050c2:	e006                	sd	ra,0(sp)
    800050c4:	e40a                	sd	sp,8(sp)
    800050c6:	e80e                	sd	gp,16(sp)
    800050c8:	ec12                	sd	tp,24(sp)
    800050ca:	f016                	sd	t0,32(sp)
    800050cc:	f41a                	sd	t1,40(sp)
    800050ce:	f81e                	sd	t2,48(sp)
    800050d0:	fc22                	sd	s0,56(sp)
    800050d2:	e0a6                	sd	s1,64(sp)
    800050d4:	e4aa                	sd	a0,72(sp)
    800050d6:	e8ae                	sd	a1,80(sp)
    800050d8:	ecb2                	sd	a2,88(sp)
    800050da:	f0b6                	sd	a3,96(sp)
    800050dc:	f4ba                	sd	a4,104(sp)
    800050de:	f8be                	sd	a5,112(sp)
    800050e0:	fcc2                	sd	a6,120(sp)
    800050e2:	e146                	sd	a7,128(sp)
    800050e4:	e54a                	sd	s2,136(sp)
    800050e6:	e94e                	sd	s3,144(sp)
    800050e8:	ed52                	sd	s4,152(sp)
    800050ea:	f156                	sd	s5,160(sp)
    800050ec:	f55a                	sd	s6,168(sp)
    800050ee:	f95e                	sd	s7,176(sp)
    800050f0:	fd62                	sd	s8,184(sp)
    800050f2:	e1e6                	sd	s9,192(sp)
    800050f4:	e5ea                	sd	s10,200(sp)
    800050f6:	e9ee                	sd	s11,208(sp)
    800050f8:	edf2                	sd	t3,216(sp)
    800050fa:	f1f6                	sd	t4,224(sp)
    800050fc:	f5fa                	sd	t5,232(sp)
    800050fe:	f9fe                	sd	t6,240(sp)
    80005100:	cf1fc0ef          	jal	ra,80001df0 <kerneltrap>
    80005104:	6082                	ld	ra,0(sp)
    80005106:	6122                	ld	sp,8(sp)
    80005108:	61c2                	ld	gp,16(sp)
    8000510a:	7282                	ld	t0,32(sp)
    8000510c:	7322                	ld	t1,40(sp)
    8000510e:	73c2                	ld	t2,48(sp)
    80005110:	7462                	ld	s0,56(sp)
    80005112:	6486                	ld	s1,64(sp)
    80005114:	6526                	ld	a0,72(sp)
    80005116:	65c6                	ld	a1,80(sp)
    80005118:	6666                	ld	a2,88(sp)
    8000511a:	7686                	ld	a3,96(sp)
    8000511c:	7726                	ld	a4,104(sp)
    8000511e:	77c6                	ld	a5,112(sp)
    80005120:	7866                	ld	a6,120(sp)
    80005122:	688a                	ld	a7,128(sp)
    80005124:	692a                	ld	s2,136(sp)
    80005126:	69ca                	ld	s3,144(sp)
    80005128:	6a6a                	ld	s4,152(sp)
    8000512a:	7a8a                	ld	s5,160(sp)
    8000512c:	7b2a                	ld	s6,168(sp)
    8000512e:	7bca                	ld	s7,176(sp)
    80005130:	7c6a                	ld	s8,184(sp)
    80005132:	6c8e                	ld	s9,192(sp)
    80005134:	6d2e                	ld	s10,200(sp)
    80005136:	6dce                	ld	s11,208(sp)
    80005138:	6e6e                	ld	t3,216(sp)
    8000513a:	7e8e                	ld	t4,224(sp)
    8000513c:	7f2e                	ld	t5,232(sp)
    8000513e:	7fce                	ld	t6,240(sp)
    80005140:	6111                	addi	sp,sp,256
    80005142:	10200073          	sret
    80005146:	00000013          	nop
    8000514a:	00000013          	nop
    8000514e:	0001                	nop

0000000080005150 <timervec>:
    80005150:	34051573          	csrrw	a0,mscratch,a0
    80005154:	e10c                	sd	a1,0(a0)
    80005156:	e510                	sd	a2,8(a0)
    80005158:	e914                	sd	a3,16(a0)
    8000515a:	6d0c                	ld	a1,24(a0)
    8000515c:	7110                	ld	a2,32(a0)
    8000515e:	6194                	ld	a3,0(a1)
    80005160:	96b2                	add	a3,a3,a2
    80005162:	e194                	sd	a3,0(a1)
    80005164:	4589                	li	a1,2
    80005166:	14459073          	csrw	sip,a1
    8000516a:	6914                	ld	a3,16(a0)
    8000516c:	6510                	ld	a2,8(a0)
    8000516e:	610c                	ld	a1,0(a0)
    80005170:	34051573          	csrrw	a0,mscratch,a0
    80005174:	30200073          	mret
	...

000000008000517a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000517a:	1141                	addi	sp,sp,-16
    8000517c:	e422                	sd	s0,8(sp)
    8000517e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005180:	0c0007b7          	lui	a5,0xc000
    80005184:	4705                	li	a4,1
    80005186:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005188:	c3d8                	sw	a4,4(a5)
}
    8000518a:	6422                	ld	s0,8(sp)
    8000518c:	0141                	addi	sp,sp,16
    8000518e:	8082                	ret

0000000080005190 <plicinithart>:

void
plicinithart(void)
{
    80005190:	1141                	addi	sp,sp,-16
    80005192:	e406                	sd	ra,8(sp)
    80005194:	e022                	sd	s0,0(sp)
    80005196:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005198:	ffffc097          	auipc	ra,0xffffc
    8000519c:	cb8080e7          	jalr	-840(ra) # 80000e50 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800051a0:	0085171b          	slliw	a4,a0,0x8
    800051a4:	0c0027b7          	lui	a5,0xc002
    800051a8:	97ba                	add	a5,a5,a4
    800051aa:	40200713          	li	a4,1026
    800051ae:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800051b2:	00d5151b          	slliw	a0,a0,0xd
    800051b6:	0c2017b7          	lui	a5,0xc201
    800051ba:	953e                	add	a0,a0,a5
    800051bc:	00052023          	sw	zero,0(a0)
}
    800051c0:	60a2                	ld	ra,8(sp)
    800051c2:	6402                	ld	s0,0(sp)
    800051c4:	0141                	addi	sp,sp,16
    800051c6:	8082                	ret

00000000800051c8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800051c8:	1141                	addi	sp,sp,-16
    800051ca:	e406                	sd	ra,8(sp)
    800051cc:	e022                	sd	s0,0(sp)
    800051ce:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800051d0:	ffffc097          	auipc	ra,0xffffc
    800051d4:	c80080e7          	jalr	-896(ra) # 80000e50 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800051d8:	00d5179b          	slliw	a5,a0,0xd
    800051dc:	0c201537          	lui	a0,0xc201
    800051e0:	953e                	add	a0,a0,a5
  return irq;
}
    800051e2:	4148                	lw	a0,4(a0)
    800051e4:	60a2                	ld	ra,8(sp)
    800051e6:	6402                	ld	s0,0(sp)
    800051e8:	0141                	addi	sp,sp,16
    800051ea:	8082                	ret

00000000800051ec <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800051ec:	1101                	addi	sp,sp,-32
    800051ee:	ec06                	sd	ra,24(sp)
    800051f0:	e822                	sd	s0,16(sp)
    800051f2:	e426                	sd	s1,8(sp)
    800051f4:	1000                	addi	s0,sp,32
    800051f6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800051f8:	ffffc097          	auipc	ra,0xffffc
    800051fc:	c58080e7          	jalr	-936(ra) # 80000e50 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005200:	00d5151b          	slliw	a0,a0,0xd
    80005204:	0c2017b7          	lui	a5,0xc201
    80005208:	97aa                	add	a5,a5,a0
    8000520a:	c3c4                	sw	s1,4(a5)
}
    8000520c:	60e2                	ld	ra,24(sp)
    8000520e:	6442                	ld	s0,16(sp)
    80005210:	64a2                	ld	s1,8(sp)
    80005212:	6105                	addi	sp,sp,32
    80005214:	8082                	ret

0000000080005216 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005216:	1141                	addi	sp,sp,-16
    80005218:	e406                	sd	ra,8(sp)
    8000521a:	e022                	sd	s0,0(sp)
    8000521c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000521e:	479d                	li	a5,7
    80005220:	04a7cc63          	blt	a5,a0,80005278 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80005224:	00015797          	auipc	a5,0x15
    80005228:	96c78793          	addi	a5,a5,-1684 # 80019b90 <disk>
    8000522c:	97aa                	add	a5,a5,a0
    8000522e:	0187c783          	lbu	a5,24(a5)
    80005232:	ebb9                	bnez	a5,80005288 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005234:	00451613          	slli	a2,a0,0x4
    80005238:	00015797          	auipc	a5,0x15
    8000523c:	95878793          	addi	a5,a5,-1704 # 80019b90 <disk>
    80005240:	6394                	ld	a3,0(a5)
    80005242:	96b2                	add	a3,a3,a2
    80005244:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    80005248:	6398                	ld	a4,0(a5)
    8000524a:	9732                	add	a4,a4,a2
    8000524c:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005250:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005254:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005258:	953e                	add	a0,a0,a5
    8000525a:	4785                	li	a5,1
    8000525c:	00f50c23          	sb	a5,24(a0) # c201018 <_entry-0x73dfefe8>
  wakeup(&disk.free[0]);
    80005260:	00015517          	auipc	a0,0x15
    80005264:	94850513          	addi	a0,a0,-1720 # 80019ba8 <disk+0x18>
    80005268:	ffffc097          	auipc	ra,0xffffc
    8000526c:	324080e7          	jalr	804(ra) # 8000158c <wakeup>
}
    80005270:	60a2                	ld	ra,8(sp)
    80005272:	6402                	ld	s0,0(sp)
    80005274:	0141                	addi	sp,sp,16
    80005276:	8082                	ret
    panic("free_desc 1");
    80005278:	00003517          	auipc	a0,0x3
    8000527c:	51850513          	addi	a0,a0,1304 # 80008790 <syscalls+0x2f8>
    80005280:	00001097          	auipc	ra,0x1
    80005284:	a72080e7          	jalr	-1422(ra) # 80005cf2 <panic>
    panic("free_desc 2");
    80005288:	00003517          	auipc	a0,0x3
    8000528c:	51850513          	addi	a0,a0,1304 # 800087a0 <syscalls+0x308>
    80005290:	00001097          	auipc	ra,0x1
    80005294:	a62080e7          	jalr	-1438(ra) # 80005cf2 <panic>

0000000080005298 <virtio_disk_init>:
{
    80005298:	1101                	addi	sp,sp,-32
    8000529a:	ec06                	sd	ra,24(sp)
    8000529c:	e822                	sd	s0,16(sp)
    8000529e:	e426                	sd	s1,8(sp)
    800052a0:	e04a                	sd	s2,0(sp)
    800052a2:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800052a4:	00003597          	auipc	a1,0x3
    800052a8:	50c58593          	addi	a1,a1,1292 # 800087b0 <syscalls+0x318>
    800052ac:	00015517          	auipc	a0,0x15
    800052b0:	a0c50513          	addi	a0,a0,-1524 # 80019cb8 <disk+0x128>
    800052b4:	00001097          	auipc	ra,0x1
    800052b8:	ef8080e7          	jalr	-264(ra) # 800061ac <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800052bc:	100017b7          	lui	a5,0x10001
    800052c0:	4398                	lw	a4,0(a5)
    800052c2:	2701                	sext.w	a4,a4
    800052c4:	747277b7          	lui	a5,0x74727
    800052c8:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800052cc:	14f71e63          	bne	a4,a5,80005428 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800052d0:	100017b7          	lui	a5,0x10001
    800052d4:	43dc                	lw	a5,4(a5)
    800052d6:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800052d8:	4709                	li	a4,2
    800052da:	14e79763          	bne	a5,a4,80005428 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800052de:	100017b7          	lui	a5,0x10001
    800052e2:	479c                	lw	a5,8(a5)
    800052e4:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800052e6:	14e79163          	bne	a5,a4,80005428 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800052ea:	100017b7          	lui	a5,0x10001
    800052ee:	47d8                	lw	a4,12(a5)
    800052f0:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800052f2:	554d47b7          	lui	a5,0x554d4
    800052f6:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800052fa:	12f71763          	bne	a4,a5,80005428 <virtio_disk_init+0x190>
  *R(VIRTIO_MMIO_STATUS) = status;
    800052fe:	100017b7          	lui	a5,0x10001
    80005302:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005306:	4705                	li	a4,1
    80005308:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000530a:	470d                	li	a4,3
    8000530c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000530e:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005310:	c7ffe737          	lui	a4,0xc7ffe
    80005314:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdc84f>
    80005318:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    8000531a:	2701                	sext.w	a4,a4
    8000531c:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000531e:	472d                	li	a4,11
    80005320:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80005322:	0707a903          	lw	s2,112(a5)
    80005326:	2901                	sext.w	s2,s2
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005328:	00897793          	andi	a5,s2,8
    8000532c:	10078663          	beqz	a5,80005438 <virtio_disk_init+0x1a0>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005330:	100017b7          	lui	a5,0x10001
    80005334:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005338:	43fc                	lw	a5,68(a5)
    8000533a:	2781                	sext.w	a5,a5
    8000533c:	10079663          	bnez	a5,80005448 <virtio_disk_init+0x1b0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005340:	100017b7          	lui	a5,0x10001
    80005344:	5bdc                	lw	a5,52(a5)
    80005346:	2781                	sext.w	a5,a5
  if(max == 0)
    80005348:	10078863          	beqz	a5,80005458 <virtio_disk_init+0x1c0>
  if(max < NUM)
    8000534c:	471d                	li	a4,7
    8000534e:	10f77d63          	bgeu	a4,a5,80005468 <virtio_disk_init+0x1d0>
  disk.desc = kalloc();
    80005352:	ffffb097          	auipc	ra,0xffffb
    80005356:	dc6080e7          	jalr	-570(ra) # 80000118 <kalloc>
    8000535a:	00015497          	auipc	s1,0x15
    8000535e:	83648493          	addi	s1,s1,-1994 # 80019b90 <disk>
    80005362:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005364:	ffffb097          	auipc	ra,0xffffb
    80005368:	db4080e7          	jalr	-588(ra) # 80000118 <kalloc>
    8000536c:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000536e:	ffffb097          	auipc	ra,0xffffb
    80005372:	daa080e7          	jalr	-598(ra) # 80000118 <kalloc>
    80005376:	87aa                	mv	a5,a0
    80005378:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    8000537a:	6088                	ld	a0,0(s1)
    8000537c:	cd75                	beqz	a0,80005478 <virtio_disk_init+0x1e0>
    8000537e:	00015717          	auipc	a4,0x15
    80005382:	81a73703          	ld	a4,-2022(a4) # 80019b98 <disk+0x8>
    80005386:	cb6d                	beqz	a4,80005478 <virtio_disk_init+0x1e0>
    80005388:	cbe5                	beqz	a5,80005478 <virtio_disk_init+0x1e0>
  memset(disk.desc, 0, PGSIZE);
    8000538a:	6605                	lui	a2,0x1
    8000538c:	4581                	li	a1,0
    8000538e:	ffffb097          	auipc	ra,0xffffb
    80005392:	e0e080e7          	jalr	-498(ra) # 8000019c <memset>
  memset(disk.avail, 0, PGSIZE);
    80005396:	00014497          	auipc	s1,0x14
    8000539a:	7fa48493          	addi	s1,s1,2042 # 80019b90 <disk>
    8000539e:	6605                	lui	a2,0x1
    800053a0:	4581                	li	a1,0
    800053a2:	6488                	ld	a0,8(s1)
    800053a4:	ffffb097          	auipc	ra,0xffffb
    800053a8:	df8080e7          	jalr	-520(ra) # 8000019c <memset>
  memset(disk.used, 0, PGSIZE);
    800053ac:	6605                	lui	a2,0x1
    800053ae:	4581                	li	a1,0
    800053b0:	6888                	ld	a0,16(s1)
    800053b2:	ffffb097          	auipc	ra,0xffffb
    800053b6:	dea080e7          	jalr	-534(ra) # 8000019c <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800053ba:	100017b7          	lui	a5,0x10001
    800053be:	4721                	li	a4,8
    800053c0:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800053c2:	4098                	lw	a4,0(s1)
    800053c4:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800053c8:	40d8                	lw	a4,4(s1)
    800053ca:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800053ce:	6498                	ld	a4,8(s1)
    800053d0:	0007069b          	sext.w	a3,a4
    800053d4:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800053d8:	9701                	srai	a4,a4,0x20
    800053da:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800053de:	6898                	ld	a4,16(s1)
    800053e0:	0007069b          	sext.w	a3,a4
    800053e4:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800053e8:	9701                	srai	a4,a4,0x20
    800053ea:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800053ee:	4685                	li	a3,1
    800053f0:	c3f4                	sw	a3,68(a5)
    disk.free[i] = 1;
    800053f2:	4705                	li	a4,1
    800053f4:	00d48c23          	sb	a3,24(s1)
    800053f8:	00e48ca3          	sb	a4,25(s1)
    800053fc:	00e48d23          	sb	a4,26(s1)
    80005400:	00e48da3          	sb	a4,27(s1)
    80005404:	00e48e23          	sb	a4,28(s1)
    80005408:	00e48ea3          	sb	a4,29(s1)
    8000540c:	00e48f23          	sb	a4,30(s1)
    80005410:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005414:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005418:	0727a823          	sw	s2,112(a5)
}
    8000541c:	60e2                	ld	ra,24(sp)
    8000541e:	6442                	ld	s0,16(sp)
    80005420:	64a2                	ld	s1,8(sp)
    80005422:	6902                	ld	s2,0(sp)
    80005424:	6105                	addi	sp,sp,32
    80005426:	8082                	ret
    panic("could not find virtio disk");
    80005428:	00003517          	auipc	a0,0x3
    8000542c:	39850513          	addi	a0,a0,920 # 800087c0 <syscalls+0x328>
    80005430:	00001097          	auipc	ra,0x1
    80005434:	8c2080e7          	jalr	-1854(ra) # 80005cf2 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005438:	00003517          	auipc	a0,0x3
    8000543c:	3a850513          	addi	a0,a0,936 # 800087e0 <syscalls+0x348>
    80005440:	00001097          	auipc	ra,0x1
    80005444:	8b2080e7          	jalr	-1870(ra) # 80005cf2 <panic>
    panic("virtio disk should not be ready");
    80005448:	00003517          	auipc	a0,0x3
    8000544c:	3b850513          	addi	a0,a0,952 # 80008800 <syscalls+0x368>
    80005450:	00001097          	auipc	ra,0x1
    80005454:	8a2080e7          	jalr	-1886(ra) # 80005cf2 <panic>
    panic("virtio disk has no queue 0");
    80005458:	00003517          	auipc	a0,0x3
    8000545c:	3c850513          	addi	a0,a0,968 # 80008820 <syscalls+0x388>
    80005460:	00001097          	auipc	ra,0x1
    80005464:	892080e7          	jalr	-1902(ra) # 80005cf2 <panic>
    panic("virtio disk max queue too short");
    80005468:	00003517          	auipc	a0,0x3
    8000546c:	3d850513          	addi	a0,a0,984 # 80008840 <syscalls+0x3a8>
    80005470:	00001097          	auipc	ra,0x1
    80005474:	882080e7          	jalr	-1918(ra) # 80005cf2 <panic>
    panic("virtio disk kalloc");
    80005478:	00003517          	auipc	a0,0x3
    8000547c:	3e850513          	addi	a0,a0,1000 # 80008860 <syscalls+0x3c8>
    80005480:	00001097          	auipc	ra,0x1
    80005484:	872080e7          	jalr	-1934(ra) # 80005cf2 <panic>

0000000080005488 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005488:	7159                	addi	sp,sp,-112
    8000548a:	f486                	sd	ra,104(sp)
    8000548c:	f0a2                	sd	s0,96(sp)
    8000548e:	eca6                	sd	s1,88(sp)
    80005490:	e8ca                	sd	s2,80(sp)
    80005492:	e4ce                	sd	s3,72(sp)
    80005494:	e0d2                	sd	s4,64(sp)
    80005496:	fc56                	sd	s5,56(sp)
    80005498:	f85a                	sd	s6,48(sp)
    8000549a:	f45e                	sd	s7,40(sp)
    8000549c:	f062                	sd	s8,32(sp)
    8000549e:	ec66                	sd	s9,24(sp)
    800054a0:	e86a                	sd	s10,16(sp)
    800054a2:	1880                	addi	s0,sp,112
    800054a4:	892a                	mv	s2,a0
    800054a6:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800054a8:	00c52c83          	lw	s9,12(a0)
    800054ac:	001c9c9b          	slliw	s9,s9,0x1
    800054b0:	1c82                	slli	s9,s9,0x20
    800054b2:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800054b6:	00015517          	auipc	a0,0x15
    800054ba:	80250513          	addi	a0,a0,-2046 # 80019cb8 <disk+0x128>
    800054be:	00001097          	auipc	ra,0x1
    800054c2:	d7e080e7          	jalr	-642(ra) # 8000623c <acquire>
  for(int i = 0; i < 3; i++){
    800054c6:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800054c8:	4ba1                	li	s7,8
      disk.free[i] = 0;
    800054ca:	00014b17          	auipc	s6,0x14
    800054ce:	6c6b0b13          	addi	s6,s6,1734 # 80019b90 <disk>
  for(int i = 0; i < 3; i++){
    800054d2:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    800054d4:	8a4e                	mv	s4,s3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800054d6:	00014c17          	auipc	s8,0x14
    800054da:	7e2c0c13          	addi	s8,s8,2018 # 80019cb8 <disk+0x128>
    800054de:	a8b5                	j	8000555a <virtio_disk_rw+0xd2>
      disk.free[i] = 0;
    800054e0:	00fb06b3          	add	a3,s6,a5
    800054e4:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    800054e8:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    800054ea:	0207c563          	bltz	a5,80005514 <virtio_disk_rw+0x8c>
  for(int i = 0; i < 3; i++){
    800054ee:	2485                	addiw	s1,s1,1
    800054f0:	0711                	addi	a4,a4,4
    800054f2:	1f548a63          	beq	s1,s5,800056e6 <virtio_disk_rw+0x25e>
    idx[i] = alloc_desc();
    800054f6:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    800054f8:	00014697          	auipc	a3,0x14
    800054fc:	69868693          	addi	a3,a3,1688 # 80019b90 <disk>
    80005500:	87d2                	mv	a5,s4
    if(disk.free[i]){
    80005502:	0186c583          	lbu	a1,24(a3)
    80005506:	fde9                	bnez	a1,800054e0 <virtio_disk_rw+0x58>
  for(int i = 0; i < NUM; i++){
    80005508:	2785                	addiw	a5,a5,1
    8000550a:	0685                	addi	a3,a3,1
    8000550c:	ff779be3          	bne	a5,s7,80005502 <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    80005510:	57fd                	li	a5,-1
    80005512:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    80005514:	02905a63          	blez	s1,80005548 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    80005518:	f9042503          	lw	a0,-112(s0)
    8000551c:	00000097          	auipc	ra,0x0
    80005520:	cfa080e7          	jalr	-774(ra) # 80005216 <free_desc>
      for(int j = 0; j < i; j++)
    80005524:	4785                	li	a5,1
    80005526:	0297d163          	bge	a5,s1,80005548 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    8000552a:	f9442503          	lw	a0,-108(s0)
    8000552e:	00000097          	auipc	ra,0x0
    80005532:	ce8080e7          	jalr	-792(ra) # 80005216 <free_desc>
      for(int j = 0; j < i; j++)
    80005536:	4789                	li	a5,2
    80005538:	0097d863          	bge	a5,s1,80005548 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    8000553c:	f9842503          	lw	a0,-104(s0)
    80005540:	00000097          	auipc	ra,0x0
    80005544:	cd6080e7          	jalr	-810(ra) # 80005216 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005548:	85e2                	mv	a1,s8
    8000554a:	00014517          	auipc	a0,0x14
    8000554e:	65e50513          	addi	a0,a0,1630 # 80019ba8 <disk+0x18>
    80005552:	ffffc097          	auipc	ra,0xffffc
    80005556:	fd6080e7          	jalr	-42(ra) # 80001528 <sleep>
  for(int i = 0; i < 3; i++){
    8000555a:	f9040713          	addi	a4,s0,-112
    8000555e:	84ce                	mv	s1,s3
    80005560:	bf59                	j	800054f6 <virtio_disk_rw+0x6e>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    80005562:	00a60793          	addi	a5,a2,10 # 100a <_entry-0x7fffeff6>
    80005566:	00479693          	slli	a3,a5,0x4
    8000556a:	00014797          	auipc	a5,0x14
    8000556e:	62678793          	addi	a5,a5,1574 # 80019b90 <disk>
    80005572:	97b6                	add	a5,a5,a3
    80005574:	4685                	li	a3,1
    80005576:	c794                	sw	a3,8(a5)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005578:	00014597          	auipc	a1,0x14
    8000557c:	61858593          	addi	a1,a1,1560 # 80019b90 <disk>
    80005580:	00a60793          	addi	a5,a2,10
    80005584:	0792                	slli	a5,a5,0x4
    80005586:	97ae                	add	a5,a5,a1
    80005588:	0007a623          	sw	zero,12(a5)
  buf0->sector = sector;
    8000558c:	0197b823          	sd	s9,16(a5)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005590:	f6070693          	addi	a3,a4,-160
    80005594:	619c                	ld	a5,0(a1)
    80005596:	97b6                	add	a5,a5,a3
    80005598:	e388                	sd	a0,0(a5)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000559a:	6188                	ld	a0,0(a1)
    8000559c:	96aa                	add	a3,a3,a0
    8000559e:	47c1                	li	a5,16
    800055a0:	c69c                	sw	a5,8(a3)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800055a2:	4785                	li	a5,1
    800055a4:	00f69623          	sh	a5,12(a3)
  disk.desc[idx[0]].next = idx[1];
    800055a8:	f9442783          	lw	a5,-108(s0)
    800055ac:	00f69723          	sh	a5,14(a3)

  disk.desc[idx[1]].addr = (uint64) b->data;
    800055b0:	0792                	slli	a5,a5,0x4
    800055b2:	953e                	add	a0,a0,a5
    800055b4:	05890693          	addi	a3,s2,88
    800055b8:	e114                	sd	a3,0(a0)
  disk.desc[idx[1]].len = BSIZE;
    800055ba:	6188                	ld	a0,0(a1)
    800055bc:	97aa                	add	a5,a5,a0
    800055be:	40000693          	li	a3,1024
    800055c2:	c794                	sw	a3,8(a5)
  if(write)
    800055c4:	100d0d63          	beqz	s10,800056de <virtio_disk_rw+0x256>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800055c8:	00079623          	sh	zero,12(a5)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800055cc:	00c7d683          	lhu	a3,12(a5)
    800055d0:	0016e693          	ori	a3,a3,1
    800055d4:	00d79623          	sh	a3,12(a5)
  disk.desc[idx[1]].next = idx[2];
    800055d8:	f9842583          	lw	a1,-104(s0)
    800055dc:	00b79723          	sh	a1,14(a5)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800055e0:	00014697          	auipc	a3,0x14
    800055e4:	5b068693          	addi	a3,a3,1456 # 80019b90 <disk>
    800055e8:	00260793          	addi	a5,a2,2
    800055ec:	0792                	slli	a5,a5,0x4
    800055ee:	97b6                	add	a5,a5,a3
    800055f0:	587d                	li	a6,-1
    800055f2:	01078823          	sb	a6,16(a5)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800055f6:	0592                	slli	a1,a1,0x4
    800055f8:	952e                	add	a0,a0,a1
    800055fa:	f9070713          	addi	a4,a4,-112
    800055fe:	9736                	add	a4,a4,a3
    80005600:	e118                	sd	a4,0(a0)
  disk.desc[idx[2]].len = 1;
    80005602:	6298                	ld	a4,0(a3)
    80005604:	972e                	add	a4,a4,a1
    80005606:	4585                	li	a1,1
    80005608:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000560a:	4509                	li	a0,2
    8000560c:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[2]].next = 0;
    80005610:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005614:	00b92223          	sw	a1,4(s2)
  disk.info[idx[0]].b = b;
    80005618:	0127b423          	sd	s2,8(a5)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    8000561c:	6698                	ld	a4,8(a3)
    8000561e:	00275783          	lhu	a5,2(a4)
    80005622:	8b9d                	andi	a5,a5,7
    80005624:	0786                	slli	a5,a5,0x1
    80005626:	97ba                	add	a5,a5,a4
    80005628:	00c79223          	sh	a2,4(a5)

  __sync_synchronize();
    8000562c:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005630:	6698                	ld	a4,8(a3)
    80005632:	00275783          	lhu	a5,2(a4)
    80005636:	2785                	addiw	a5,a5,1
    80005638:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    8000563c:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005640:	100017b7          	lui	a5,0x10001
    80005644:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005648:	00492703          	lw	a4,4(s2)
    8000564c:	4785                	li	a5,1
    8000564e:	02f71163          	bne	a4,a5,80005670 <virtio_disk_rw+0x1e8>
    sleep(b, &disk.vdisk_lock);
    80005652:	00014997          	auipc	s3,0x14
    80005656:	66698993          	addi	s3,s3,1638 # 80019cb8 <disk+0x128>
  while(b->disk == 1) {
    8000565a:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    8000565c:	85ce                	mv	a1,s3
    8000565e:	854a                	mv	a0,s2
    80005660:	ffffc097          	auipc	ra,0xffffc
    80005664:	ec8080e7          	jalr	-312(ra) # 80001528 <sleep>
  while(b->disk == 1) {
    80005668:	00492783          	lw	a5,4(s2)
    8000566c:	fe9788e3          	beq	a5,s1,8000565c <virtio_disk_rw+0x1d4>
  }

  disk.info[idx[0]].b = 0;
    80005670:	f9042903          	lw	s2,-112(s0)
    80005674:	00290793          	addi	a5,s2,2
    80005678:	00479713          	slli	a4,a5,0x4
    8000567c:	00014797          	auipc	a5,0x14
    80005680:	51478793          	addi	a5,a5,1300 # 80019b90 <disk>
    80005684:	97ba                	add	a5,a5,a4
    80005686:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    8000568a:	00014997          	auipc	s3,0x14
    8000568e:	50698993          	addi	s3,s3,1286 # 80019b90 <disk>
    80005692:	00491713          	slli	a4,s2,0x4
    80005696:	0009b783          	ld	a5,0(s3)
    8000569a:	97ba                	add	a5,a5,a4
    8000569c:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800056a0:	854a                	mv	a0,s2
    800056a2:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800056a6:	00000097          	auipc	ra,0x0
    800056aa:	b70080e7          	jalr	-1168(ra) # 80005216 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800056ae:	8885                	andi	s1,s1,1
    800056b0:	f0ed                	bnez	s1,80005692 <virtio_disk_rw+0x20a>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800056b2:	00014517          	auipc	a0,0x14
    800056b6:	60650513          	addi	a0,a0,1542 # 80019cb8 <disk+0x128>
    800056ba:	00001097          	auipc	ra,0x1
    800056be:	c36080e7          	jalr	-970(ra) # 800062f0 <release>
}
    800056c2:	70a6                	ld	ra,104(sp)
    800056c4:	7406                	ld	s0,96(sp)
    800056c6:	64e6                	ld	s1,88(sp)
    800056c8:	6946                	ld	s2,80(sp)
    800056ca:	69a6                	ld	s3,72(sp)
    800056cc:	6a06                	ld	s4,64(sp)
    800056ce:	7ae2                	ld	s5,56(sp)
    800056d0:	7b42                	ld	s6,48(sp)
    800056d2:	7ba2                	ld	s7,40(sp)
    800056d4:	7c02                	ld	s8,32(sp)
    800056d6:	6ce2                	ld	s9,24(sp)
    800056d8:	6d42                	ld	s10,16(sp)
    800056da:	6165                	addi	sp,sp,112
    800056dc:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    800056de:	4689                	li	a3,2
    800056e0:	00d79623          	sh	a3,12(a5)
    800056e4:	b5e5                	j	800055cc <virtio_disk_rw+0x144>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800056e6:	f9042603          	lw	a2,-112(s0)
    800056ea:	00a60713          	addi	a4,a2,10
    800056ee:	0712                	slli	a4,a4,0x4
    800056f0:	00014517          	auipc	a0,0x14
    800056f4:	4a850513          	addi	a0,a0,1192 # 80019b98 <disk+0x8>
    800056f8:	953a                	add	a0,a0,a4
  if(write)
    800056fa:	e60d14e3          	bnez	s10,80005562 <virtio_disk_rw+0xda>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    800056fe:	00a60793          	addi	a5,a2,10
    80005702:	00479693          	slli	a3,a5,0x4
    80005706:	00014797          	auipc	a5,0x14
    8000570a:	48a78793          	addi	a5,a5,1162 # 80019b90 <disk>
    8000570e:	97b6                	add	a5,a5,a3
    80005710:	0007a423          	sw	zero,8(a5)
    80005714:	b595                	j	80005578 <virtio_disk_rw+0xf0>

0000000080005716 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005716:	1101                	addi	sp,sp,-32
    80005718:	ec06                	sd	ra,24(sp)
    8000571a:	e822                	sd	s0,16(sp)
    8000571c:	e426                	sd	s1,8(sp)
    8000571e:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005720:	00014497          	auipc	s1,0x14
    80005724:	47048493          	addi	s1,s1,1136 # 80019b90 <disk>
    80005728:	00014517          	auipc	a0,0x14
    8000572c:	59050513          	addi	a0,a0,1424 # 80019cb8 <disk+0x128>
    80005730:	00001097          	auipc	ra,0x1
    80005734:	b0c080e7          	jalr	-1268(ra) # 8000623c <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005738:	10001737          	lui	a4,0x10001
    8000573c:	533c                	lw	a5,96(a4)
    8000573e:	8b8d                	andi	a5,a5,3
    80005740:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005742:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005746:	689c                	ld	a5,16(s1)
    80005748:	0204d703          	lhu	a4,32(s1)
    8000574c:	0027d783          	lhu	a5,2(a5)
    80005750:	04f70863          	beq	a4,a5,800057a0 <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80005754:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005758:	6898                	ld	a4,16(s1)
    8000575a:	0204d783          	lhu	a5,32(s1)
    8000575e:	8b9d                	andi	a5,a5,7
    80005760:	078e                	slli	a5,a5,0x3
    80005762:	97ba                	add	a5,a5,a4
    80005764:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005766:	00278713          	addi	a4,a5,2
    8000576a:	0712                	slli	a4,a4,0x4
    8000576c:	9726                	add	a4,a4,s1
    8000576e:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80005772:	e721                	bnez	a4,800057ba <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005774:	0789                	addi	a5,a5,2
    80005776:	0792                	slli	a5,a5,0x4
    80005778:	97a6                	add	a5,a5,s1
    8000577a:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    8000577c:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005780:	ffffc097          	auipc	ra,0xffffc
    80005784:	e0c080e7          	jalr	-500(ra) # 8000158c <wakeup>

    disk.used_idx += 1;
    80005788:	0204d783          	lhu	a5,32(s1)
    8000578c:	2785                	addiw	a5,a5,1
    8000578e:	17c2                	slli	a5,a5,0x30
    80005790:	93c1                	srli	a5,a5,0x30
    80005792:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005796:	6898                	ld	a4,16(s1)
    80005798:	00275703          	lhu	a4,2(a4)
    8000579c:	faf71ce3          	bne	a4,a5,80005754 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    800057a0:	00014517          	auipc	a0,0x14
    800057a4:	51850513          	addi	a0,a0,1304 # 80019cb8 <disk+0x128>
    800057a8:	00001097          	auipc	ra,0x1
    800057ac:	b48080e7          	jalr	-1208(ra) # 800062f0 <release>
}
    800057b0:	60e2                	ld	ra,24(sp)
    800057b2:	6442                	ld	s0,16(sp)
    800057b4:	64a2                	ld	s1,8(sp)
    800057b6:	6105                	addi	sp,sp,32
    800057b8:	8082                	ret
      panic("virtio_disk_intr status");
    800057ba:	00003517          	auipc	a0,0x3
    800057be:	0be50513          	addi	a0,a0,190 # 80008878 <syscalls+0x3e0>
    800057c2:	00000097          	auipc	ra,0x0
    800057c6:	530080e7          	jalr	1328(ra) # 80005cf2 <panic>

00000000800057ca <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    800057ca:	1141                	addi	sp,sp,-16
    800057cc:	e422                	sd	s0,8(sp)
    800057ce:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800057d0:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    800057d4:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    800057d8:	0037979b          	slliw	a5,a5,0x3
    800057dc:	02004737          	lui	a4,0x2004
    800057e0:	97ba                	add	a5,a5,a4
    800057e2:	0200c737          	lui	a4,0x200c
    800057e6:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    800057ea:	000f4637          	lui	a2,0xf4
    800057ee:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    800057f2:	95b2                	add	a1,a1,a2
    800057f4:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    800057f6:	00269713          	slli	a4,a3,0x2
    800057fa:	9736                	add	a4,a4,a3
    800057fc:	00371693          	slli	a3,a4,0x3
    80005800:	00014717          	auipc	a4,0x14
    80005804:	4d070713          	addi	a4,a4,1232 # 80019cd0 <timer_scratch>
    80005808:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    8000580a:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000580c:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000580e:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005812:	00000797          	auipc	a5,0x0
    80005816:	93e78793          	addi	a5,a5,-1730 # 80005150 <timervec>
    8000581a:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000581e:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005822:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005826:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    8000582a:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000582e:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005832:	30479073          	csrw	mie,a5
}
    80005836:	6422                	ld	s0,8(sp)
    80005838:	0141                	addi	sp,sp,16
    8000583a:	8082                	ret

000000008000583c <start>:
{
    8000583c:	1141                	addi	sp,sp,-16
    8000583e:	e406                	sd	ra,8(sp)
    80005840:	e022                	sd	s0,0(sp)
    80005842:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005844:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005848:	7779                	lui	a4,0xffffe
    8000584a:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdc8ef>
    8000584e:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005850:	6705                	lui	a4,0x1
    80005852:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005856:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005858:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    8000585c:	ffffb797          	auipc	a5,0xffffb
    80005860:	aee78793          	addi	a5,a5,-1298 # 8000034a <main>
    80005864:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005868:	4781                	li	a5,0
    8000586a:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    8000586e:	67c1                	lui	a5,0x10
    80005870:	17fd                	addi	a5,a5,-1
    80005872:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005876:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    8000587a:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    8000587e:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005882:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005886:	57fd                	li	a5,-1
    80005888:	83a9                	srli	a5,a5,0xa
    8000588a:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    8000588e:	47bd                	li	a5,15
    80005890:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005894:	00000097          	auipc	ra,0x0
    80005898:	f36080e7          	jalr	-202(ra) # 800057ca <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000589c:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800058a0:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    800058a2:	823e                	mv	tp,a5
  asm volatile("mret");
    800058a4:	30200073          	mret
}
    800058a8:	60a2                	ld	ra,8(sp)
    800058aa:	6402                	ld	s0,0(sp)
    800058ac:	0141                	addi	sp,sp,16
    800058ae:	8082                	ret

00000000800058b0 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800058b0:	715d                	addi	sp,sp,-80
    800058b2:	e486                	sd	ra,72(sp)
    800058b4:	e0a2                	sd	s0,64(sp)
    800058b6:	fc26                	sd	s1,56(sp)
    800058b8:	f84a                	sd	s2,48(sp)
    800058ba:	f44e                	sd	s3,40(sp)
    800058bc:	f052                	sd	s4,32(sp)
    800058be:	ec56                	sd	s5,24(sp)
    800058c0:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    800058c2:	04c05663          	blez	a2,8000590e <consolewrite+0x5e>
    800058c6:	8a2a                	mv	s4,a0
    800058c8:	84ae                	mv	s1,a1
    800058ca:	89b2                	mv	s3,a2
    800058cc:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    800058ce:	5afd                	li	s5,-1
    800058d0:	4685                	li	a3,1
    800058d2:	8626                	mv	a2,s1
    800058d4:	85d2                	mv	a1,s4
    800058d6:	fbf40513          	addi	a0,s0,-65
    800058da:	ffffc097          	auipc	ra,0xffffc
    800058de:	0ac080e7          	jalr	172(ra) # 80001986 <either_copyin>
    800058e2:	01550c63          	beq	a0,s5,800058fa <consolewrite+0x4a>
      break;
    uartputc(c);
    800058e6:	fbf44503          	lbu	a0,-65(s0)
    800058ea:	00000097          	auipc	ra,0x0
    800058ee:	794080e7          	jalr	1940(ra) # 8000607e <uartputc>
  for(i = 0; i < n; i++){
    800058f2:	2905                	addiw	s2,s2,1
    800058f4:	0485                	addi	s1,s1,1
    800058f6:	fd299de3          	bne	s3,s2,800058d0 <consolewrite+0x20>
  }

  return i;
}
    800058fa:	854a                	mv	a0,s2
    800058fc:	60a6                	ld	ra,72(sp)
    800058fe:	6406                	ld	s0,64(sp)
    80005900:	74e2                	ld	s1,56(sp)
    80005902:	7942                	ld	s2,48(sp)
    80005904:	79a2                	ld	s3,40(sp)
    80005906:	7a02                	ld	s4,32(sp)
    80005908:	6ae2                	ld	s5,24(sp)
    8000590a:	6161                	addi	sp,sp,80
    8000590c:	8082                	ret
  for(i = 0; i < n; i++){
    8000590e:	4901                	li	s2,0
    80005910:	b7ed                	j	800058fa <consolewrite+0x4a>

0000000080005912 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005912:	7119                	addi	sp,sp,-128
    80005914:	fc86                	sd	ra,120(sp)
    80005916:	f8a2                	sd	s0,112(sp)
    80005918:	f4a6                	sd	s1,104(sp)
    8000591a:	f0ca                	sd	s2,96(sp)
    8000591c:	ecce                	sd	s3,88(sp)
    8000591e:	e8d2                	sd	s4,80(sp)
    80005920:	e4d6                	sd	s5,72(sp)
    80005922:	e0da                	sd	s6,64(sp)
    80005924:	fc5e                	sd	s7,56(sp)
    80005926:	f862                	sd	s8,48(sp)
    80005928:	f466                	sd	s9,40(sp)
    8000592a:	f06a                	sd	s10,32(sp)
    8000592c:	ec6e                	sd	s11,24(sp)
    8000592e:	0100                	addi	s0,sp,128
    80005930:	8b2a                	mv	s6,a0
    80005932:	8aae                	mv	s5,a1
    80005934:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005936:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    8000593a:	0001c517          	auipc	a0,0x1c
    8000593e:	4d650513          	addi	a0,a0,1238 # 80021e10 <cons>
    80005942:	00001097          	auipc	ra,0x1
    80005946:	8fa080e7          	jalr	-1798(ra) # 8000623c <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000594a:	0001c497          	auipc	s1,0x1c
    8000594e:	4c648493          	addi	s1,s1,1222 # 80021e10 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005952:	89a6                	mv	s3,s1
    80005954:	0001c917          	auipc	s2,0x1c
    80005958:	55490913          	addi	s2,s2,1364 # 80021ea8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    8000595c:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    8000595e:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005960:	4da9                	li	s11,10
  while(n > 0){
    80005962:	07405b63          	blez	s4,800059d8 <consoleread+0xc6>
    while(cons.r == cons.w){
    80005966:	0984a783          	lw	a5,152(s1)
    8000596a:	09c4a703          	lw	a4,156(s1)
    8000596e:	02f71763          	bne	a4,a5,8000599c <consoleread+0x8a>
      if(killed(myproc())){
    80005972:	ffffb097          	auipc	ra,0xffffb
    80005976:	50a080e7          	jalr	1290(ra) # 80000e7c <myproc>
    8000597a:	ffffc097          	auipc	ra,0xffffc
    8000597e:	e56080e7          	jalr	-426(ra) # 800017d0 <killed>
    80005982:	e535                	bnez	a0,800059ee <consoleread+0xdc>
      sleep(&cons.r, &cons.lock);
    80005984:	85ce                	mv	a1,s3
    80005986:	854a                	mv	a0,s2
    80005988:	ffffc097          	auipc	ra,0xffffc
    8000598c:	ba0080e7          	jalr	-1120(ra) # 80001528 <sleep>
    while(cons.r == cons.w){
    80005990:	0984a783          	lw	a5,152(s1)
    80005994:	09c4a703          	lw	a4,156(s1)
    80005998:	fcf70de3          	beq	a4,a5,80005972 <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    8000599c:	0017871b          	addiw	a4,a5,1
    800059a0:	08e4ac23          	sw	a4,152(s1)
    800059a4:	07f7f713          	andi	a4,a5,127
    800059a8:	9726                	add	a4,a4,s1
    800059aa:	01874703          	lbu	a4,24(a4)
    800059ae:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    800059b2:	079c0663          	beq	s8,s9,80005a1e <consoleread+0x10c>
    cbuf = c;
    800059b6:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800059ba:	4685                	li	a3,1
    800059bc:	f8f40613          	addi	a2,s0,-113
    800059c0:	85d6                	mv	a1,s5
    800059c2:	855a                	mv	a0,s6
    800059c4:	ffffc097          	auipc	ra,0xffffc
    800059c8:	f6c080e7          	jalr	-148(ra) # 80001930 <either_copyout>
    800059cc:	01a50663          	beq	a0,s10,800059d8 <consoleread+0xc6>
    dst++;
    800059d0:	0a85                	addi	s5,s5,1
    --n;
    800059d2:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    800059d4:	f9bc17e3          	bne	s8,s11,80005962 <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    800059d8:	0001c517          	auipc	a0,0x1c
    800059dc:	43850513          	addi	a0,a0,1080 # 80021e10 <cons>
    800059e0:	00001097          	auipc	ra,0x1
    800059e4:	910080e7          	jalr	-1776(ra) # 800062f0 <release>

  return target - n;
    800059e8:	414b853b          	subw	a0,s7,s4
    800059ec:	a811                	j	80005a00 <consoleread+0xee>
        release(&cons.lock);
    800059ee:	0001c517          	auipc	a0,0x1c
    800059f2:	42250513          	addi	a0,a0,1058 # 80021e10 <cons>
    800059f6:	00001097          	auipc	ra,0x1
    800059fa:	8fa080e7          	jalr	-1798(ra) # 800062f0 <release>
        return -1;
    800059fe:	557d                	li	a0,-1
}
    80005a00:	70e6                	ld	ra,120(sp)
    80005a02:	7446                	ld	s0,112(sp)
    80005a04:	74a6                	ld	s1,104(sp)
    80005a06:	7906                	ld	s2,96(sp)
    80005a08:	69e6                	ld	s3,88(sp)
    80005a0a:	6a46                	ld	s4,80(sp)
    80005a0c:	6aa6                	ld	s5,72(sp)
    80005a0e:	6b06                	ld	s6,64(sp)
    80005a10:	7be2                	ld	s7,56(sp)
    80005a12:	7c42                	ld	s8,48(sp)
    80005a14:	7ca2                	ld	s9,40(sp)
    80005a16:	7d02                	ld	s10,32(sp)
    80005a18:	6de2                	ld	s11,24(sp)
    80005a1a:	6109                	addi	sp,sp,128
    80005a1c:	8082                	ret
      if(n < target){
    80005a1e:	000a071b          	sext.w	a4,s4
    80005a22:	fb777be3          	bgeu	a4,s7,800059d8 <consoleread+0xc6>
        cons.r--;
    80005a26:	0001c717          	auipc	a4,0x1c
    80005a2a:	48f72123          	sw	a5,1154(a4) # 80021ea8 <cons+0x98>
    80005a2e:	b76d                	j	800059d8 <consoleread+0xc6>

0000000080005a30 <consputc>:
{
    80005a30:	1141                	addi	sp,sp,-16
    80005a32:	e406                	sd	ra,8(sp)
    80005a34:	e022                	sd	s0,0(sp)
    80005a36:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005a38:	10000793          	li	a5,256
    80005a3c:	00f50a63          	beq	a0,a5,80005a50 <consputc+0x20>
    uartputc_sync(c);
    80005a40:	00000097          	auipc	ra,0x0
    80005a44:	564080e7          	jalr	1380(ra) # 80005fa4 <uartputc_sync>
}
    80005a48:	60a2                	ld	ra,8(sp)
    80005a4a:	6402                	ld	s0,0(sp)
    80005a4c:	0141                	addi	sp,sp,16
    80005a4e:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005a50:	4521                	li	a0,8
    80005a52:	00000097          	auipc	ra,0x0
    80005a56:	552080e7          	jalr	1362(ra) # 80005fa4 <uartputc_sync>
    80005a5a:	02000513          	li	a0,32
    80005a5e:	00000097          	auipc	ra,0x0
    80005a62:	546080e7          	jalr	1350(ra) # 80005fa4 <uartputc_sync>
    80005a66:	4521                	li	a0,8
    80005a68:	00000097          	auipc	ra,0x0
    80005a6c:	53c080e7          	jalr	1340(ra) # 80005fa4 <uartputc_sync>
    80005a70:	bfe1                	j	80005a48 <consputc+0x18>

0000000080005a72 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005a72:	1101                	addi	sp,sp,-32
    80005a74:	ec06                	sd	ra,24(sp)
    80005a76:	e822                	sd	s0,16(sp)
    80005a78:	e426                	sd	s1,8(sp)
    80005a7a:	e04a                	sd	s2,0(sp)
    80005a7c:	1000                	addi	s0,sp,32
    80005a7e:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005a80:	0001c517          	auipc	a0,0x1c
    80005a84:	39050513          	addi	a0,a0,912 # 80021e10 <cons>
    80005a88:	00000097          	auipc	ra,0x0
    80005a8c:	7b4080e7          	jalr	1972(ra) # 8000623c <acquire>

  switch(c){
    80005a90:	47d5                	li	a5,21
    80005a92:	0af48663          	beq	s1,a5,80005b3e <consoleintr+0xcc>
    80005a96:	0297ca63          	blt	a5,s1,80005aca <consoleintr+0x58>
    80005a9a:	47a1                	li	a5,8
    80005a9c:	0ef48763          	beq	s1,a5,80005b8a <consoleintr+0x118>
    80005aa0:	47c1                	li	a5,16
    80005aa2:	10f49a63          	bne	s1,a5,80005bb6 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005aa6:	ffffc097          	auipc	ra,0xffffc
    80005aaa:	f36080e7          	jalr	-202(ra) # 800019dc <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005aae:	0001c517          	auipc	a0,0x1c
    80005ab2:	36250513          	addi	a0,a0,866 # 80021e10 <cons>
    80005ab6:	00001097          	auipc	ra,0x1
    80005aba:	83a080e7          	jalr	-1990(ra) # 800062f0 <release>
}
    80005abe:	60e2                	ld	ra,24(sp)
    80005ac0:	6442                	ld	s0,16(sp)
    80005ac2:	64a2                	ld	s1,8(sp)
    80005ac4:	6902                	ld	s2,0(sp)
    80005ac6:	6105                	addi	sp,sp,32
    80005ac8:	8082                	ret
  switch(c){
    80005aca:	07f00793          	li	a5,127
    80005ace:	0af48e63          	beq	s1,a5,80005b8a <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005ad2:	0001c717          	auipc	a4,0x1c
    80005ad6:	33e70713          	addi	a4,a4,830 # 80021e10 <cons>
    80005ada:	0a072783          	lw	a5,160(a4)
    80005ade:	09872703          	lw	a4,152(a4)
    80005ae2:	9f99                	subw	a5,a5,a4
    80005ae4:	07f00713          	li	a4,127
    80005ae8:	fcf763e3          	bltu	a4,a5,80005aae <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005aec:	47b5                	li	a5,13
    80005aee:	0cf48763          	beq	s1,a5,80005bbc <consoleintr+0x14a>
      consputc(c);
    80005af2:	8526                	mv	a0,s1
    80005af4:	00000097          	auipc	ra,0x0
    80005af8:	f3c080e7          	jalr	-196(ra) # 80005a30 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005afc:	0001c797          	auipc	a5,0x1c
    80005b00:	31478793          	addi	a5,a5,788 # 80021e10 <cons>
    80005b04:	0a07a683          	lw	a3,160(a5)
    80005b08:	0016871b          	addiw	a4,a3,1
    80005b0c:	0007061b          	sext.w	a2,a4
    80005b10:	0ae7a023          	sw	a4,160(a5)
    80005b14:	07f6f693          	andi	a3,a3,127
    80005b18:	97b6                	add	a5,a5,a3
    80005b1a:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005b1e:	47a9                	li	a5,10
    80005b20:	0cf48563          	beq	s1,a5,80005bea <consoleintr+0x178>
    80005b24:	4791                	li	a5,4
    80005b26:	0cf48263          	beq	s1,a5,80005bea <consoleintr+0x178>
    80005b2a:	0001c797          	auipc	a5,0x1c
    80005b2e:	37e7a783          	lw	a5,894(a5) # 80021ea8 <cons+0x98>
    80005b32:	9f1d                	subw	a4,a4,a5
    80005b34:	08000793          	li	a5,128
    80005b38:	f6f71be3          	bne	a4,a5,80005aae <consoleintr+0x3c>
    80005b3c:	a07d                	j	80005bea <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005b3e:	0001c717          	auipc	a4,0x1c
    80005b42:	2d270713          	addi	a4,a4,722 # 80021e10 <cons>
    80005b46:	0a072783          	lw	a5,160(a4)
    80005b4a:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005b4e:	0001c497          	auipc	s1,0x1c
    80005b52:	2c248493          	addi	s1,s1,706 # 80021e10 <cons>
    while(cons.e != cons.w &&
    80005b56:	4929                	li	s2,10
    80005b58:	f4f70be3          	beq	a4,a5,80005aae <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005b5c:	37fd                	addiw	a5,a5,-1
    80005b5e:	07f7f713          	andi	a4,a5,127
    80005b62:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005b64:	01874703          	lbu	a4,24(a4)
    80005b68:	f52703e3          	beq	a4,s2,80005aae <consoleintr+0x3c>
      cons.e--;
    80005b6c:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005b70:	10000513          	li	a0,256
    80005b74:	00000097          	auipc	ra,0x0
    80005b78:	ebc080e7          	jalr	-324(ra) # 80005a30 <consputc>
    while(cons.e != cons.w &&
    80005b7c:	0a04a783          	lw	a5,160(s1)
    80005b80:	09c4a703          	lw	a4,156(s1)
    80005b84:	fcf71ce3          	bne	a4,a5,80005b5c <consoleintr+0xea>
    80005b88:	b71d                	j	80005aae <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005b8a:	0001c717          	auipc	a4,0x1c
    80005b8e:	28670713          	addi	a4,a4,646 # 80021e10 <cons>
    80005b92:	0a072783          	lw	a5,160(a4)
    80005b96:	09c72703          	lw	a4,156(a4)
    80005b9a:	f0f70ae3          	beq	a4,a5,80005aae <consoleintr+0x3c>
      cons.e--;
    80005b9e:	37fd                	addiw	a5,a5,-1
    80005ba0:	0001c717          	auipc	a4,0x1c
    80005ba4:	30f72823          	sw	a5,784(a4) # 80021eb0 <cons+0xa0>
      consputc(BACKSPACE);
    80005ba8:	10000513          	li	a0,256
    80005bac:	00000097          	auipc	ra,0x0
    80005bb0:	e84080e7          	jalr	-380(ra) # 80005a30 <consputc>
    80005bb4:	bded                	j	80005aae <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005bb6:	ee048ce3          	beqz	s1,80005aae <consoleintr+0x3c>
    80005bba:	bf21                	j	80005ad2 <consoleintr+0x60>
      consputc(c);
    80005bbc:	4529                	li	a0,10
    80005bbe:	00000097          	auipc	ra,0x0
    80005bc2:	e72080e7          	jalr	-398(ra) # 80005a30 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005bc6:	0001c797          	auipc	a5,0x1c
    80005bca:	24a78793          	addi	a5,a5,586 # 80021e10 <cons>
    80005bce:	0a07a703          	lw	a4,160(a5)
    80005bd2:	0017069b          	addiw	a3,a4,1
    80005bd6:	0006861b          	sext.w	a2,a3
    80005bda:	0ad7a023          	sw	a3,160(a5)
    80005bde:	07f77713          	andi	a4,a4,127
    80005be2:	97ba                	add	a5,a5,a4
    80005be4:	4729                	li	a4,10
    80005be6:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005bea:	0001c797          	auipc	a5,0x1c
    80005bee:	2cc7a123          	sw	a2,706(a5) # 80021eac <cons+0x9c>
        wakeup(&cons.r);
    80005bf2:	0001c517          	auipc	a0,0x1c
    80005bf6:	2b650513          	addi	a0,a0,694 # 80021ea8 <cons+0x98>
    80005bfa:	ffffc097          	auipc	ra,0xffffc
    80005bfe:	992080e7          	jalr	-1646(ra) # 8000158c <wakeup>
    80005c02:	b575                	j	80005aae <consoleintr+0x3c>

0000000080005c04 <consoleinit>:

void
consoleinit(void)
{
    80005c04:	1141                	addi	sp,sp,-16
    80005c06:	e406                	sd	ra,8(sp)
    80005c08:	e022                	sd	s0,0(sp)
    80005c0a:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005c0c:	00003597          	auipc	a1,0x3
    80005c10:	c8458593          	addi	a1,a1,-892 # 80008890 <syscalls+0x3f8>
    80005c14:	0001c517          	auipc	a0,0x1c
    80005c18:	1fc50513          	addi	a0,a0,508 # 80021e10 <cons>
    80005c1c:	00000097          	auipc	ra,0x0
    80005c20:	590080e7          	jalr	1424(ra) # 800061ac <initlock>

  uartinit();
    80005c24:	00000097          	auipc	ra,0x0
    80005c28:	330080e7          	jalr	816(ra) # 80005f54 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005c2c:	00013797          	auipc	a5,0x13
    80005c30:	f0c78793          	addi	a5,a5,-244 # 80018b38 <devsw>
    80005c34:	00000717          	auipc	a4,0x0
    80005c38:	cde70713          	addi	a4,a4,-802 # 80005912 <consoleread>
    80005c3c:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005c3e:	00000717          	auipc	a4,0x0
    80005c42:	c7270713          	addi	a4,a4,-910 # 800058b0 <consolewrite>
    80005c46:	ef98                	sd	a4,24(a5)
}
    80005c48:	60a2                	ld	ra,8(sp)
    80005c4a:	6402                	ld	s0,0(sp)
    80005c4c:	0141                	addi	sp,sp,16
    80005c4e:	8082                	ret

0000000080005c50 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005c50:	7179                	addi	sp,sp,-48
    80005c52:	f406                	sd	ra,40(sp)
    80005c54:	f022                	sd	s0,32(sp)
    80005c56:	ec26                	sd	s1,24(sp)
    80005c58:	e84a                	sd	s2,16(sp)
    80005c5a:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005c5c:	c219                	beqz	a2,80005c62 <printint+0x12>
    80005c5e:	08054663          	bltz	a0,80005cea <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005c62:	2501                	sext.w	a0,a0
    80005c64:	4881                	li	a7,0
    80005c66:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005c6a:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005c6c:	2581                	sext.w	a1,a1
    80005c6e:	00003617          	auipc	a2,0x3
    80005c72:	c5260613          	addi	a2,a2,-942 # 800088c0 <digits>
    80005c76:	883a                	mv	a6,a4
    80005c78:	2705                	addiw	a4,a4,1
    80005c7a:	02b577bb          	remuw	a5,a0,a1
    80005c7e:	1782                	slli	a5,a5,0x20
    80005c80:	9381                	srli	a5,a5,0x20
    80005c82:	97b2                	add	a5,a5,a2
    80005c84:	0007c783          	lbu	a5,0(a5)
    80005c88:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005c8c:	0005079b          	sext.w	a5,a0
    80005c90:	02b5553b          	divuw	a0,a0,a1
    80005c94:	0685                	addi	a3,a3,1
    80005c96:	feb7f0e3          	bgeu	a5,a1,80005c76 <printint+0x26>

  if(sign)
    80005c9a:	00088b63          	beqz	a7,80005cb0 <printint+0x60>
    buf[i++] = '-';
    80005c9e:	fe040793          	addi	a5,s0,-32
    80005ca2:	973e                	add	a4,a4,a5
    80005ca4:	02d00793          	li	a5,45
    80005ca8:	fef70823          	sb	a5,-16(a4)
    80005cac:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005cb0:	02e05763          	blez	a4,80005cde <printint+0x8e>
    80005cb4:	fd040793          	addi	a5,s0,-48
    80005cb8:	00e784b3          	add	s1,a5,a4
    80005cbc:	fff78913          	addi	s2,a5,-1
    80005cc0:	993a                	add	s2,s2,a4
    80005cc2:	377d                	addiw	a4,a4,-1
    80005cc4:	1702                	slli	a4,a4,0x20
    80005cc6:	9301                	srli	a4,a4,0x20
    80005cc8:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005ccc:	fff4c503          	lbu	a0,-1(s1)
    80005cd0:	00000097          	auipc	ra,0x0
    80005cd4:	d60080e7          	jalr	-672(ra) # 80005a30 <consputc>
  while(--i >= 0)
    80005cd8:	14fd                	addi	s1,s1,-1
    80005cda:	ff2499e3          	bne	s1,s2,80005ccc <printint+0x7c>
}
    80005cde:	70a2                	ld	ra,40(sp)
    80005ce0:	7402                	ld	s0,32(sp)
    80005ce2:	64e2                	ld	s1,24(sp)
    80005ce4:	6942                	ld	s2,16(sp)
    80005ce6:	6145                	addi	sp,sp,48
    80005ce8:	8082                	ret
    x = -xx;
    80005cea:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005cee:	4885                	li	a7,1
    x = -xx;
    80005cf0:	bf9d                	j	80005c66 <printint+0x16>

0000000080005cf2 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005cf2:	1101                	addi	sp,sp,-32
    80005cf4:	ec06                	sd	ra,24(sp)
    80005cf6:	e822                	sd	s0,16(sp)
    80005cf8:	e426                	sd	s1,8(sp)
    80005cfa:	1000                	addi	s0,sp,32
    80005cfc:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005cfe:	0001c797          	auipc	a5,0x1c
    80005d02:	1c07a923          	sw	zero,466(a5) # 80021ed0 <pr+0x18>
  printf("panic: ");
    80005d06:	00003517          	auipc	a0,0x3
    80005d0a:	b9250513          	addi	a0,a0,-1134 # 80008898 <syscalls+0x400>
    80005d0e:	00000097          	auipc	ra,0x0
    80005d12:	02e080e7          	jalr	46(ra) # 80005d3c <printf>
  printf(s);
    80005d16:	8526                	mv	a0,s1
    80005d18:	00000097          	auipc	ra,0x0
    80005d1c:	024080e7          	jalr	36(ra) # 80005d3c <printf>
  printf("\n");
    80005d20:	00002517          	auipc	a0,0x2
    80005d24:	32850513          	addi	a0,a0,808 # 80008048 <etext+0x48>
    80005d28:	00000097          	auipc	ra,0x0
    80005d2c:	014080e7          	jalr	20(ra) # 80005d3c <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005d30:	4785                	li	a5,1
    80005d32:	00003717          	auipc	a4,0x3
    80005d36:	d4f72d23          	sw	a5,-678(a4) # 80008a8c <panicked>
  for(;;)
    80005d3a:	a001                	j	80005d3a <panic+0x48>

0000000080005d3c <printf>:
{
    80005d3c:	7131                	addi	sp,sp,-192
    80005d3e:	fc86                	sd	ra,120(sp)
    80005d40:	f8a2                	sd	s0,112(sp)
    80005d42:	f4a6                	sd	s1,104(sp)
    80005d44:	f0ca                	sd	s2,96(sp)
    80005d46:	ecce                	sd	s3,88(sp)
    80005d48:	e8d2                	sd	s4,80(sp)
    80005d4a:	e4d6                	sd	s5,72(sp)
    80005d4c:	e0da                	sd	s6,64(sp)
    80005d4e:	fc5e                	sd	s7,56(sp)
    80005d50:	f862                	sd	s8,48(sp)
    80005d52:	f466                	sd	s9,40(sp)
    80005d54:	f06a                	sd	s10,32(sp)
    80005d56:	ec6e                	sd	s11,24(sp)
    80005d58:	0100                	addi	s0,sp,128
    80005d5a:	8a2a                	mv	s4,a0
    80005d5c:	e40c                	sd	a1,8(s0)
    80005d5e:	e810                	sd	a2,16(s0)
    80005d60:	ec14                	sd	a3,24(s0)
    80005d62:	f018                	sd	a4,32(s0)
    80005d64:	f41c                	sd	a5,40(s0)
    80005d66:	03043823          	sd	a6,48(s0)
    80005d6a:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005d6e:	0001cd97          	auipc	s11,0x1c
    80005d72:	162dad83          	lw	s11,354(s11) # 80021ed0 <pr+0x18>
  if(locking)
    80005d76:	020d9b63          	bnez	s11,80005dac <printf+0x70>
  if (fmt == 0)
    80005d7a:	040a0263          	beqz	s4,80005dbe <printf+0x82>
  va_start(ap, fmt);
    80005d7e:	00840793          	addi	a5,s0,8
    80005d82:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005d86:	000a4503          	lbu	a0,0(s4)
    80005d8a:	16050263          	beqz	a0,80005eee <printf+0x1b2>
    80005d8e:	4481                	li	s1,0
    if(c != '%'){
    80005d90:	02500a93          	li	s5,37
    switch(c){
    80005d94:	07000b13          	li	s6,112
  consputc('x');
    80005d98:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005d9a:	00003b97          	auipc	s7,0x3
    80005d9e:	b26b8b93          	addi	s7,s7,-1242 # 800088c0 <digits>
    switch(c){
    80005da2:	07300c93          	li	s9,115
    80005da6:	06400c13          	li	s8,100
    80005daa:	a82d                	j	80005de4 <printf+0xa8>
    acquire(&pr.lock);
    80005dac:	0001c517          	auipc	a0,0x1c
    80005db0:	10c50513          	addi	a0,a0,268 # 80021eb8 <pr>
    80005db4:	00000097          	auipc	ra,0x0
    80005db8:	488080e7          	jalr	1160(ra) # 8000623c <acquire>
    80005dbc:	bf7d                	j	80005d7a <printf+0x3e>
    panic("null fmt");
    80005dbe:	00003517          	auipc	a0,0x3
    80005dc2:	aea50513          	addi	a0,a0,-1302 # 800088a8 <syscalls+0x410>
    80005dc6:	00000097          	auipc	ra,0x0
    80005dca:	f2c080e7          	jalr	-212(ra) # 80005cf2 <panic>
      consputc(c);
    80005dce:	00000097          	auipc	ra,0x0
    80005dd2:	c62080e7          	jalr	-926(ra) # 80005a30 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005dd6:	2485                	addiw	s1,s1,1
    80005dd8:	009a07b3          	add	a5,s4,s1
    80005ddc:	0007c503          	lbu	a0,0(a5)
    80005de0:	10050763          	beqz	a0,80005eee <printf+0x1b2>
    if(c != '%'){
    80005de4:	ff5515e3          	bne	a0,s5,80005dce <printf+0x92>
    c = fmt[++i] & 0xff;
    80005de8:	2485                	addiw	s1,s1,1
    80005dea:	009a07b3          	add	a5,s4,s1
    80005dee:	0007c783          	lbu	a5,0(a5)
    80005df2:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80005df6:	cfe5                	beqz	a5,80005eee <printf+0x1b2>
    switch(c){
    80005df8:	05678a63          	beq	a5,s6,80005e4c <printf+0x110>
    80005dfc:	02fb7663          	bgeu	s6,a5,80005e28 <printf+0xec>
    80005e00:	09978963          	beq	a5,s9,80005e92 <printf+0x156>
    80005e04:	07800713          	li	a4,120
    80005e08:	0ce79863          	bne	a5,a4,80005ed8 <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80005e0c:	f8843783          	ld	a5,-120(s0)
    80005e10:	00878713          	addi	a4,a5,8
    80005e14:	f8e43423          	sd	a4,-120(s0)
    80005e18:	4605                	li	a2,1
    80005e1a:	85ea                	mv	a1,s10
    80005e1c:	4388                	lw	a0,0(a5)
    80005e1e:	00000097          	auipc	ra,0x0
    80005e22:	e32080e7          	jalr	-462(ra) # 80005c50 <printint>
      break;
    80005e26:	bf45                	j	80005dd6 <printf+0x9a>
    switch(c){
    80005e28:	0b578263          	beq	a5,s5,80005ecc <printf+0x190>
    80005e2c:	0b879663          	bne	a5,s8,80005ed8 <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80005e30:	f8843783          	ld	a5,-120(s0)
    80005e34:	00878713          	addi	a4,a5,8
    80005e38:	f8e43423          	sd	a4,-120(s0)
    80005e3c:	4605                	li	a2,1
    80005e3e:	45a9                	li	a1,10
    80005e40:	4388                	lw	a0,0(a5)
    80005e42:	00000097          	auipc	ra,0x0
    80005e46:	e0e080e7          	jalr	-498(ra) # 80005c50 <printint>
      break;
    80005e4a:	b771                	j	80005dd6 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005e4c:	f8843783          	ld	a5,-120(s0)
    80005e50:	00878713          	addi	a4,a5,8
    80005e54:	f8e43423          	sd	a4,-120(s0)
    80005e58:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005e5c:	03000513          	li	a0,48
    80005e60:	00000097          	auipc	ra,0x0
    80005e64:	bd0080e7          	jalr	-1072(ra) # 80005a30 <consputc>
  consputc('x');
    80005e68:	07800513          	li	a0,120
    80005e6c:	00000097          	auipc	ra,0x0
    80005e70:	bc4080e7          	jalr	-1084(ra) # 80005a30 <consputc>
    80005e74:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005e76:	03c9d793          	srli	a5,s3,0x3c
    80005e7a:	97de                	add	a5,a5,s7
    80005e7c:	0007c503          	lbu	a0,0(a5)
    80005e80:	00000097          	auipc	ra,0x0
    80005e84:	bb0080e7          	jalr	-1104(ra) # 80005a30 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005e88:	0992                	slli	s3,s3,0x4
    80005e8a:	397d                	addiw	s2,s2,-1
    80005e8c:	fe0915e3          	bnez	s2,80005e76 <printf+0x13a>
    80005e90:	b799                	j	80005dd6 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005e92:	f8843783          	ld	a5,-120(s0)
    80005e96:	00878713          	addi	a4,a5,8
    80005e9a:	f8e43423          	sd	a4,-120(s0)
    80005e9e:	0007b903          	ld	s2,0(a5)
    80005ea2:	00090e63          	beqz	s2,80005ebe <printf+0x182>
      for(; *s; s++)
    80005ea6:	00094503          	lbu	a0,0(s2)
    80005eaa:	d515                	beqz	a0,80005dd6 <printf+0x9a>
        consputc(*s);
    80005eac:	00000097          	auipc	ra,0x0
    80005eb0:	b84080e7          	jalr	-1148(ra) # 80005a30 <consputc>
      for(; *s; s++)
    80005eb4:	0905                	addi	s2,s2,1
    80005eb6:	00094503          	lbu	a0,0(s2)
    80005eba:	f96d                	bnez	a0,80005eac <printf+0x170>
    80005ebc:	bf29                	j	80005dd6 <printf+0x9a>
        s = "(null)";
    80005ebe:	00003917          	auipc	s2,0x3
    80005ec2:	9e290913          	addi	s2,s2,-1566 # 800088a0 <syscalls+0x408>
      for(; *s; s++)
    80005ec6:	02800513          	li	a0,40
    80005eca:	b7cd                	j	80005eac <printf+0x170>
      consputc('%');
    80005ecc:	8556                	mv	a0,s5
    80005ece:	00000097          	auipc	ra,0x0
    80005ed2:	b62080e7          	jalr	-1182(ra) # 80005a30 <consputc>
      break;
    80005ed6:	b701                	j	80005dd6 <printf+0x9a>
      consputc('%');
    80005ed8:	8556                	mv	a0,s5
    80005eda:	00000097          	auipc	ra,0x0
    80005ede:	b56080e7          	jalr	-1194(ra) # 80005a30 <consputc>
      consputc(c);
    80005ee2:	854a                	mv	a0,s2
    80005ee4:	00000097          	auipc	ra,0x0
    80005ee8:	b4c080e7          	jalr	-1204(ra) # 80005a30 <consputc>
      break;
    80005eec:	b5ed                	j	80005dd6 <printf+0x9a>
  if(locking)
    80005eee:	020d9163          	bnez	s11,80005f10 <printf+0x1d4>
}
    80005ef2:	70e6                	ld	ra,120(sp)
    80005ef4:	7446                	ld	s0,112(sp)
    80005ef6:	74a6                	ld	s1,104(sp)
    80005ef8:	7906                	ld	s2,96(sp)
    80005efa:	69e6                	ld	s3,88(sp)
    80005efc:	6a46                	ld	s4,80(sp)
    80005efe:	6aa6                	ld	s5,72(sp)
    80005f00:	6b06                	ld	s6,64(sp)
    80005f02:	7be2                	ld	s7,56(sp)
    80005f04:	7c42                	ld	s8,48(sp)
    80005f06:	7ca2                	ld	s9,40(sp)
    80005f08:	7d02                	ld	s10,32(sp)
    80005f0a:	6de2                	ld	s11,24(sp)
    80005f0c:	6129                	addi	sp,sp,192
    80005f0e:	8082                	ret
    release(&pr.lock);
    80005f10:	0001c517          	auipc	a0,0x1c
    80005f14:	fa850513          	addi	a0,a0,-88 # 80021eb8 <pr>
    80005f18:	00000097          	auipc	ra,0x0
    80005f1c:	3d8080e7          	jalr	984(ra) # 800062f0 <release>
}
    80005f20:	bfc9                	j	80005ef2 <printf+0x1b6>

0000000080005f22 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005f22:	1101                	addi	sp,sp,-32
    80005f24:	ec06                	sd	ra,24(sp)
    80005f26:	e822                	sd	s0,16(sp)
    80005f28:	e426                	sd	s1,8(sp)
    80005f2a:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005f2c:	0001c497          	auipc	s1,0x1c
    80005f30:	f8c48493          	addi	s1,s1,-116 # 80021eb8 <pr>
    80005f34:	00003597          	auipc	a1,0x3
    80005f38:	98458593          	addi	a1,a1,-1660 # 800088b8 <syscalls+0x420>
    80005f3c:	8526                	mv	a0,s1
    80005f3e:	00000097          	auipc	ra,0x0
    80005f42:	26e080e7          	jalr	622(ra) # 800061ac <initlock>
  pr.locking = 1;
    80005f46:	4785                	li	a5,1
    80005f48:	cc9c                	sw	a5,24(s1)
}
    80005f4a:	60e2                	ld	ra,24(sp)
    80005f4c:	6442                	ld	s0,16(sp)
    80005f4e:	64a2                	ld	s1,8(sp)
    80005f50:	6105                	addi	sp,sp,32
    80005f52:	8082                	ret

0000000080005f54 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005f54:	1141                	addi	sp,sp,-16
    80005f56:	e406                	sd	ra,8(sp)
    80005f58:	e022                	sd	s0,0(sp)
    80005f5a:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005f5c:	100007b7          	lui	a5,0x10000
    80005f60:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005f64:	f8000713          	li	a4,-128
    80005f68:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005f6c:	470d                	li	a4,3
    80005f6e:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005f72:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005f76:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005f7a:	469d                	li	a3,7
    80005f7c:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005f80:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005f84:	00003597          	auipc	a1,0x3
    80005f88:	95458593          	addi	a1,a1,-1708 # 800088d8 <digits+0x18>
    80005f8c:	0001c517          	auipc	a0,0x1c
    80005f90:	f4c50513          	addi	a0,a0,-180 # 80021ed8 <uart_tx_lock>
    80005f94:	00000097          	auipc	ra,0x0
    80005f98:	218080e7          	jalr	536(ra) # 800061ac <initlock>
}
    80005f9c:	60a2                	ld	ra,8(sp)
    80005f9e:	6402                	ld	s0,0(sp)
    80005fa0:	0141                	addi	sp,sp,16
    80005fa2:	8082                	ret

0000000080005fa4 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005fa4:	1101                	addi	sp,sp,-32
    80005fa6:	ec06                	sd	ra,24(sp)
    80005fa8:	e822                	sd	s0,16(sp)
    80005faa:	e426                	sd	s1,8(sp)
    80005fac:	1000                	addi	s0,sp,32
    80005fae:	84aa                	mv	s1,a0
  push_off();
    80005fb0:	00000097          	auipc	ra,0x0
    80005fb4:	240080e7          	jalr	576(ra) # 800061f0 <push_off>

  if(panicked){
    80005fb8:	00003797          	auipc	a5,0x3
    80005fbc:	ad47a783          	lw	a5,-1324(a5) # 80008a8c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005fc0:	10000737          	lui	a4,0x10000
  if(panicked){
    80005fc4:	c391                	beqz	a5,80005fc8 <uartputc_sync+0x24>
    for(;;)
    80005fc6:	a001                	j	80005fc6 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005fc8:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80005fcc:	0ff7f793          	andi	a5,a5,255
    80005fd0:	0207f793          	andi	a5,a5,32
    80005fd4:	dbf5                	beqz	a5,80005fc8 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80005fd6:	0ff4f793          	andi	a5,s1,255
    80005fda:	10000737          	lui	a4,0x10000
    80005fde:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    80005fe2:	00000097          	auipc	ra,0x0
    80005fe6:	2ae080e7          	jalr	686(ra) # 80006290 <pop_off>
}
    80005fea:	60e2                	ld	ra,24(sp)
    80005fec:	6442                	ld	s0,16(sp)
    80005fee:	64a2                	ld	s1,8(sp)
    80005ff0:	6105                	addi	sp,sp,32
    80005ff2:	8082                	ret

0000000080005ff4 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005ff4:	00003717          	auipc	a4,0x3
    80005ff8:	a9c73703          	ld	a4,-1380(a4) # 80008a90 <uart_tx_r>
    80005ffc:	00003797          	auipc	a5,0x3
    80006000:	a9c7b783          	ld	a5,-1380(a5) # 80008a98 <uart_tx_w>
    80006004:	06e78c63          	beq	a5,a4,8000607c <uartstart+0x88>
{
    80006008:	7139                	addi	sp,sp,-64
    8000600a:	fc06                	sd	ra,56(sp)
    8000600c:	f822                	sd	s0,48(sp)
    8000600e:	f426                	sd	s1,40(sp)
    80006010:	f04a                	sd	s2,32(sp)
    80006012:	ec4e                	sd	s3,24(sp)
    80006014:	e852                	sd	s4,16(sp)
    80006016:	e456                	sd	s5,8(sp)
    80006018:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000601a:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000601e:	0001ca17          	auipc	s4,0x1c
    80006022:	ebaa0a13          	addi	s4,s4,-326 # 80021ed8 <uart_tx_lock>
    uart_tx_r += 1;
    80006026:	00003497          	auipc	s1,0x3
    8000602a:	a6a48493          	addi	s1,s1,-1430 # 80008a90 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    8000602e:	00003997          	auipc	s3,0x3
    80006032:	a6a98993          	addi	s3,s3,-1430 # 80008a98 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006036:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    8000603a:	0ff7f793          	andi	a5,a5,255
    8000603e:	0207f793          	andi	a5,a5,32
    80006042:	c785                	beqz	a5,8000606a <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006044:	01f77793          	andi	a5,a4,31
    80006048:	97d2                	add	a5,a5,s4
    8000604a:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    8000604e:	0705                	addi	a4,a4,1
    80006050:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80006052:	8526                	mv	a0,s1
    80006054:	ffffb097          	auipc	ra,0xffffb
    80006058:	538080e7          	jalr	1336(ra) # 8000158c <wakeup>
    
    WriteReg(THR, c);
    8000605c:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80006060:	6098                	ld	a4,0(s1)
    80006062:	0009b783          	ld	a5,0(s3)
    80006066:	fce798e3          	bne	a5,a4,80006036 <uartstart+0x42>
  }
}
    8000606a:	70e2                	ld	ra,56(sp)
    8000606c:	7442                	ld	s0,48(sp)
    8000606e:	74a2                	ld	s1,40(sp)
    80006070:	7902                	ld	s2,32(sp)
    80006072:	69e2                	ld	s3,24(sp)
    80006074:	6a42                	ld	s4,16(sp)
    80006076:	6aa2                	ld	s5,8(sp)
    80006078:	6121                	addi	sp,sp,64
    8000607a:	8082                	ret
    8000607c:	8082                	ret

000000008000607e <uartputc>:
{
    8000607e:	7179                	addi	sp,sp,-48
    80006080:	f406                	sd	ra,40(sp)
    80006082:	f022                	sd	s0,32(sp)
    80006084:	ec26                	sd	s1,24(sp)
    80006086:	e84a                	sd	s2,16(sp)
    80006088:	e44e                	sd	s3,8(sp)
    8000608a:	e052                	sd	s4,0(sp)
    8000608c:	1800                	addi	s0,sp,48
    8000608e:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    80006090:	0001c517          	auipc	a0,0x1c
    80006094:	e4850513          	addi	a0,a0,-440 # 80021ed8 <uart_tx_lock>
    80006098:	00000097          	auipc	ra,0x0
    8000609c:	1a4080e7          	jalr	420(ra) # 8000623c <acquire>
  if(panicked){
    800060a0:	00003797          	auipc	a5,0x3
    800060a4:	9ec7a783          	lw	a5,-1556(a5) # 80008a8c <panicked>
    800060a8:	e7c9                	bnez	a5,80006132 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800060aa:	00003797          	auipc	a5,0x3
    800060ae:	9ee7b783          	ld	a5,-1554(a5) # 80008a98 <uart_tx_w>
    800060b2:	00003717          	auipc	a4,0x3
    800060b6:	9de73703          	ld	a4,-1570(a4) # 80008a90 <uart_tx_r>
    800060ba:	02070713          	addi	a4,a4,32
    sleep(&uart_tx_r, &uart_tx_lock);
    800060be:	0001ca17          	auipc	s4,0x1c
    800060c2:	e1aa0a13          	addi	s4,s4,-486 # 80021ed8 <uart_tx_lock>
    800060c6:	00003497          	auipc	s1,0x3
    800060ca:	9ca48493          	addi	s1,s1,-1590 # 80008a90 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800060ce:	00003917          	auipc	s2,0x3
    800060d2:	9ca90913          	addi	s2,s2,-1590 # 80008a98 <uart_tx_w>
    800060d6:	00f71f63          	bne	a4,a5,800060f4 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    800060da:	85d2                	mv	a1,s4
    800060dc:	8526                	mv	a0,s1
    800060de:	ffffb097          	auipc	ra,0xffffb
    800060e2:	44a080e7          	jalr	1098(ra) # 80001528 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800060e6:	00093783          	ld	a5,0(s2)
    800060ea:	6098                	ld	a4,0(s1)
    800060ec:	02070713          	addi	a4,a4,32
    800060f0:	fef705e3          	beq	a4,a5,800060da <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800060f4:	0001c497          	auipc	s1,0x1c
    800060f8:	de448493          	addi	s1,s1,-540 # 80021ed8 <uart_tx_lock>
    800060fc:	01f7f713          	andi	a4,a5,31
    80006100:	9726                	add	a4,a4,s1
    80006102:	01370c23          	sb	s3,24(a4)
  uart_tx_w += 1;
    80006106:	0785                	addi	a5,a5,1
    80006108:	00003717          	auipc	a4,0x3
    8000610c:	98f73823          	sd	a5,-1648(a4) # 80008a98 <uart_tx_w>
  uartstart();
    80006110:	00000097          	auipc	ra,0x0
    80006114:	ee4080e7          	jalr	-284(ra) # 80005ff4 <uartstart>
  release(&uart_tx_lock);
    80006118:	8526                	mv	a0,s1
    8000611a:	00000097          	auipc	ra,0x0
    8000611e:	1d6080e7          	jalr	470(ra) # 800062f0 <release>
}
    80006122:	70a2                	ld	ra,40(sp)
    80006124:	7402                	ld	s0,32(sp)
    80006126:	64e2                	ld	s1,24(sp)
    80006128:	6942                	ld	s2,16(sp)
    8000612a:	69a2                	ld	s3,8(sp)
    8000612c:	6a02                	ld	s4,0(sp)
    8000612e:	6145                	addi	sp,sp,48
    80006130:	8082                	ret
    for(;;)
    80006132:	a001                	j	80006132 <uartputc+0xb4>

0000000080006134 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006134:	1141                	addi	sp,sp,-16
    80006136:	e422                	sd	s0,8(sp)
    80006138:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    8000613a:	100007b7          	lui	a5,0x10000
    8000613e:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80006142:	8b85                	andi	a5,a5,1
    80006144:	cb91                	beqz	a5,80006158 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80006146:	100007b7          	lui	a5,0x10000
    8000614a:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    8000614e:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    80006152:	6422                	ld	s0,8(sp)
    80006154:	0141                	addi	sp,sp,16
    80006156:	8082                	ret
    return -1;
    80006158:	557d                	li	a0,-1
    8000615a:	bfe5                	j	80006152 <uartgetc+0x1e>

000000008000615c <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    8000615c:	1101                	addi	sp,sp,-32
    8000615e:	ec06                	sd	ra,24(sp)
    80006160:	e822                	sd	s0,16(sp)
    80006162:	e426                	sd	s1,8(sp)
    80006164:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80006166:	54fd                	li	s1,-1
    int c = uartgetc();
    80006168:	00000097          	auipc	ra,0x0
    8000616c:	fcc080e7          	jalr	-52(ra) # 80006134 <uartgetc>
    if(c == -1)
    80006170:	00950763          	beq	a0,s1,8000617e <uartintr+0x22>
      break;
    consoleintr(c);
    80006174:	00000097          	auipc	ra,0x0
    80006178:	8fe080e7          	jalr	-1794(ra) # 80005a72 <consoleintr>
  while(1){
    8000617c:	b7f5                	j	80006168 <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    8000617e:	0001c497          	auipc	s1,0x1c
    80006182:	d5a48493          	addi	s1,s1,-678 # 80021ed8 <uart_tx_lock>
    80006186:	8526                	mv	a0,s1
    80006188:	00000097          	auipc	ra,0x0
    8000618c:	0b4080e7          	jalr	180(ra) # 8000623c <acquire>
  uartstart();
    80006190:	00000097          	auipc	ra,0x0
    80006194:	e64080e7          	jalr	-412(ra) # 80005ff4 <uartstart>
  release(&uart_tx_lock);
    80006198:	8526                	mv	a0,s1
    8000619a:	00000097          	auipc	ra,0x0
    8000619e:	156080e7          	jalr	342(ra) # 800062f0 <release>
}
    800061a2:	60e2                	ld	ra,24(sp)
    800061a4:	6442                	ld	s0,16(sp)
    800061a6:	64a2                	ld	s1,8(sp)
    800061a8:	6105                	addi	sp,sp,32
    800061aa:	8082                	ret

00000000800061ac <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800061ac:	1141                	addi	sp,sp,-16
    800061ae:	e422                	sd	s0,8(sp)
    800061b0:	0800                	addi	s0,sp,16
  lk->name = name;
    800061b2:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800061b4:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800061b8:	00053823          	sd	zero,16(a0)
}
    800061bc:	6422                	ld	s0,8(sp)
    800061be:	0141                	addi	sp,sp,16
    800061c0:	8082                	ret

00000000800061c2 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800061c2:	411c                	lw	a5,0(a0)
    800061c4:	e399                	bnez	a5,800061ca <holding+0x8>
    800061c6:	4501                	li	a0,0
  return r;
}
    800061c8:	8082                	ret
{
    800061ca:	1101                	addi	sp,sp,-32
    800061cc:	ec06                	sd	ra,24(sp)
    800061ce:	e822                	sd	s0,16(sp)
    800061d0:	e426                	sd	s1,8(sp)
    800061d2:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800061d4:	6904                	ld	s1,16(a0)
    800061d6:	ffffb097          	auipc	ra,0xffffb
    800061da:	c8a080e7          	jalr	-886(ra) # 80000e60 <mycpu>
    800061de:	40a48533          	sub	a0,s1,a0
    800061e2:	00153513          	seqz	a0,a0
}
    800061e6:	60e2                	ld	ra,24(sp)
    800061e8:	6442                	ld	s0,16(sp)
    800061ea:	64a2                	ld	s1,8(sp)
    800061ec:	6105                	addi	sp,sp,32
    800061ee:	8082                	ret

00000000800061f0 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800061f0:	1101                	addi	sp,sp,-32
    800061f2:	ec06                	sd	ra,24(sp)
    800061f4:	e822                	sd	s0,16(sp)
    800061f6:	e426                	sd	s1,8(sp)
    800061f8:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800061fa:	100024f3          	csrr	s1,sstatus
    800061fe:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006202:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006204:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80006208:	ffffb097          	auipc	ra,0xffffb
    8000620c:	c58080e7          	jalr	-936(ra) # 80000e60 <mycpu>
    80006210:	5d3c                	lw	a5,120(a0)
    80006212:	cf89                	beqz	a5,8000622c <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80006214:	ffffb097          	auipc	ra,0xffffb
    80006218:	c4c080e7          	jalr	-948(ra) # 80000e60 <mycpu>
    8000621c:	5d3c                	lw	a5,120(a0)
    8000621e:	2785                	addiw	a5,a5,1
    80006220:	dd3c                	sw	a5,120(a0)
}
    80006222:	60e2                	ld	ra,24(sp)
    80006224:	6442                	ld	s0,16(sp)
    80006226:	64a2                	ld	s1,8(sp)
    80006228:	6105                	addi	sp,sp,32
    8000622a:	8082                	ret
    mycpu()->intena = old;
    8000622c:	ffffb097          	auipc	ra,0xffffb
    80006230:	c34080e7          	jalr	-972(ra) # 80000e60 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80006234:	8085                	srli	s1,s1,0x1
    80006236:	8885                	andi	s1,s1,1
    80006238:	dd64                	sw	s1,124(a0)
    8000623a:	bfe9                	j	80006214 <push_off+0x24>

000000008000623c <acquire>:
{
    8000623c:	1101                	addi	sp,sp,-32
    8000623e:	ec06                	sd	ra,24(sp)
    80006240:	e822                	sd	s0,16(sp)
    80006242:	e426                	sd	s1,8(sp)
    80006244:	1000                	addi	s0,sp,32
    80006246:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80006248:	00000097          	auipc	ra,0x0
    8000624c:	fa8080e7          	jalr	-88(ra) # 800061f0 <push_off>
  if(holding(lk))
    80006250:	8526                	mv	a0,s1
    80006252:	00000097          	auipc	ra,0x0
    80006256:	f70080e7          	jalr	-144(ra) # 800061c2 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000625a:	4705                	li	a4,1
  if(holding(lk))
    8000625c:	e115                	bnez	a0,80006280 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000625e:	87ba                	mv	a5,a4
    80006260:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80006264:	2781                	sext.w	a5,a5
    80006266:	ffe5                	bnez	a5,8000625e <acquire+0x22>
  __sync_synchronize();
    80006268:	0ff0000f          	fence
  lk->cpu = mycpu();
    8000626c:	ffffb097          	auipc	ra,0xffffb
    80006270:	bf4080e7          	jalr	-1036(ra) # 80000e60 <mycpu>
    80006274:	e888                	sd	a0,16(s1)
}
    80006276:	60e2                	ld	ra,24(sp)
    80006278:	6442                	ld	s0,16(sp)
    8000627a:	64a2                	ld	s1,8(sp)
    8000627c:	6105                	addi	sp,sp,32
    8000627e:	8082                	ret
    panic("acquire");
    80006280:	00002517          	auipc	a0,0x2
    80006284:	66050513          	addi	a0,a0,1632 # 800088e0 <digits+0x20>
    80006288:	00000097          	auipc	ra,0x0
    8000628c:	a6a080e7          	jalr	-1430(ra) # 80005cf2 <panic>

0000000080006290 <pop_off>:

void
pop_off(void)
{
    80006290:	1141                	addi	sp,sp,-16
    80006292:	e406                	sd	ra,8(sp)
    80006294:	e022                	sd	s0,0(sp)
    80006296:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006298:	ffffb097          	auipc	ra,0xffffb
    8000629c:	bc8080e7          	jalr	-1080(ra) # 80000e60 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800062a0:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800062a4:	8b89                	andi	a5,a5,2
  if(intr_get())
    800062a6:	e78d                	bnez	a5,800062d0 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800062a8:	5d3c                	lw	a5,120(a0)
    800062aa:	02f05b63          	blez	a5,800062e0 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    800062ae:	37fd                	addiw	a5,a5,-1
    800062b0:	0007871b          	sext.w	a4,a5
    800062b4:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800062b6:	eb09                	bnez	a4,800062c8 <pop_off+0x38>
    800062b8:	5d7c                	lw	a5,124(a0)
    800062ba:	c799                	beqz	a5,800062c8 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800062bc:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800062c0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800062c4:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800062c8:	60a2                	ld	ra,8(sp)
    800062ca:	6402                	ld	s0,0(sp)
    800062cc:	0141                	addi	sp,sp,16
    800062ce:	8082                	ret
    panic("pop_off - interruptible");
    800062d0:	00002517          	auipc	a0,0x2
    800062d4:	61850513          	addi	a0,a0,1560 # 800088e8 <digits+0x28>
    800062d8:	00000097          	auipc	ra,0x0
    800062dc:	a1a080e7          	jalr	-1510(ra) # 80005cf2 <panic>
    panic("pop_off");
    800062e0:	00002517          	auipc	a0,0x2
    800062e4:	62050513          	addi	a0,a0,1568 # 80008900 <digits+0x40>
    800062e8:	00000097          	auipc	ra,0x0
    800062ec:	a0a080e7          	jalr	-1526(ra) # 80005cf2 <panic>

00000000800062f0 <release>:
{
    800062f0:	1101                	addi	sp,sp,-32
    800062f2:	ec06                	sd	ra,24(sp)
    800062f4:	e822                	sd	s0,16(sp)
    800062f6:	e426                	sd	s1,8(sp)
    800062f8:	1000                	addi	s0,sp,32
    800062fa:	84aa                	mv	s1,a0
  if(!holding(lk))
    800062fc:	00000097          	auipc	ra,0x0
    80006300:	ec6080e7          	jalr	-314(ra) # 800061c2 <holding>
    80006304:	c115                	beqz	a0,80006328 <release+0x38>
  lk->cpu = 0;
    80006306:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    8000630a:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    8000630e:	0f50000f          	fence	iorw,ow
    80006312:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80006316:	00000097          	auipc	ra,0x0
    8000631a:	f7a080e7          	jalr	-134(ra) # 80006290 <pop_off>
}
    8000631e:	60e2                	ld	ra,24(sp)
    80006320:	6442                	ld	s0,16(sp)
    80006322:	64a2                	ld	s1,8(sp)
    80006324:	6105                	addi	sp,sp,32
    80006326:	8082                	ret
    panic("release");
    80006328:	00002517          	auipc	a0,0x2
    8000632c:	5e050513          	addi	a0,a0,1504 # 80008908 <digits+0x48>
    80006330:	00000097          	auipc	ra,0x0
    80006334:	9c2080e7          	jalr	-1598(ra) # 80005cf2 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0) # 2000028 <_entry-0x7dffffd8>
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addiw	a0,a0,-1
    800070ae:	0536                	slli	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0) # 2000028 <_entry-0x7dffffd8>
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
