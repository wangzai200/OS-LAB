
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	90013103          	ld	sp,-1792(sp) # 80008900 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	1b7050ef          	jal	ra,800059cc <start>

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
    80000034:	f9078793          	addi	a5,a5,-112 # 80021fc0 <end>
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
    8000004c:	130080e7          	jalr	304(ra) # 80000178 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	90090913          	addi	s2,s2,-1792 # 80008950 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	372080e7          	jalr	882(ra) # 800063cc <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	412080e7          	jalr	1042(ra) # 80006480 <release>
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
    8000008e:	df8080e7          	jalr	-520(ra) # 80005e82 <panic>

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
    800000f0:	86450513          	addi	a0,a0,-1948 # 80008950 <kmem>
    800000f4:	00006097          	auipc	ra,0x6
    800000f8:	248080e7          	jalr	584(ra) # 8000633c <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fc:	45c5                	li	a1,17
    800000fe:	05ee                	slli	a1,a1,0x1b
    80000100:	00022517          	auipc	a0,0x22
    80000104:	ec050513          	addi	a0,a0,-320 # 80021fc0 <end>
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
    80000126:	82e48493          	addi	s1,s1,-2002 # 80008950 <kmem>
    8000012a:	8526                	mv	a0,s1
    8000012c:	00006097          	auipc	ra,0x6
    80000130:	2a0080e7          	jalr	672(ra) # 800063cc <acquire>
  r = kmem.freelist;
    80000134:	6c84                	ld	s1,24(s1)
  if(r)
    80000136:	c885                	beqz	s1,80000166 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000138:	609c                	ld	a5,0(s1)
    8000013a:	00009517          	auipc	a0,0x9
    8000013e:	81650513          	addi	a0,a0,-2026 # 80008950 <kmem>
    80000142:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000144:	00006097          	auipc	ra,0x6
    80000148:	33c080e7          	jalr	828(ra) # 80006480 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014c:	6605                	lui	a2,0x1
    8000014e:	4595                	li	a1,5
    80000150:	8526                	mv	a0,s1
    80000152:	00000097          	auipc	ra,0x0
    80000156:	026080e7          	jalr	38(ra) # 80000178 <memset>
  return (void*)r;
}
    8000015a:	8526                	mv	a0,s1
    8000015c:	60e2                	ld	ra,24(sp)
    8000015e:	6442                	ld	s0,16(sp)
    80000160:	64a2                	ld	s1,8(sp)
    80000162:	6105                	addi	sp,sp,32
    80000164:	8082                	ret
  release(&kmem.lock);
    80000166:	00008517          	auipc	a0,0x8
    8000016a:	7ea50513          	addi	a0,a0,2026 # 80008950 <kmem>
    8000016e:	00006097          	auipc	ra,0x6
    80000172:	312080e7          	jalr	786(ra) # 80006480 <release>
  if(r)
    80000176:	b7d5                	j	8000015a <kalloc+0x42>

0000000080000178 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000178:	1141                	addi	sp,sp,-16
    8000017a:	e422                	sd	s0,8(sp)
    8000017c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    8000017e:	ce09                	beqz	a2,80000198 <memset+0x20>
    80000180:	87aa                	mv	a5,a0
    80000182:	fff6071b          	addiw	a4,a2,-1
    80000186:	1702                	slli	a4,a4,0x20
    80000188:	9301                	srli	a4,a4,0x20
    8000018a:	0705                	addi	a4,a4,1
    8000018c:	972a                	add	a4,a4,a0
    cdst[i] = c;
    8000018e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000192:	0785                	addi	a5,a5,1
    80000194:	fee79de3          	bne	a5,a4,8000018e <memset+0x16>
  }
  return dst;
}
    80000198:	6422                	ld	s0,8(sp)
    8000019a:	0141                	addi	sp,sp,16
    8000019c:	8082                	ret

000000008000019e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    8000019e:	1141                	addi	sp,sp,-16
    800001a0:	e422                	sd	s0,8(sp)
    800001a2:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001a4:	ca05                	beqz	a2,800001d4 <memcmp+0x36>
    800001a6:	fff6069b          	addiw	a3,a2,-1
    800001aa:	1682                	slli	a3,a3,0x20
    800001ac:	9281                	srli	a3,a3,0x20
    800001ae:	0685                	addi	a3,a3,1
    800001b0:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001b2:	00054783          	lbu	a5,0(a0)
    800001b6:	0005c703          	lbu	a4,0(a1)
    800001ba:	00e79863          	bne	a5,a4,800001ca <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001be:	0505                	addi	a0,a0,1
    800001c0:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001c2:	fed518e3          	bne	a0,a3,800001b2 <memcmp+0x14>
  }

  return 0;
    800001c6:	4501                	li	a0,0
    800001c8:	a019                	j	800001ce <memcmp+0x30>
      return *s1 - *s2;
    800001ca:	40e7853b          	subw	a0,a5,a4
}
    800001ce:	6422                	ld	s0,8(sp)
    800001d0:	0141                	addi	sp,sp,16
    800001d2:	8082                	ret
  return 0;
    800001d4:	4501                	li	a0,0
    800001d6:	bfe5                	j	800001ce <memcmp+0x30>

00000000800001d8 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001d8:	1141                	addi	sp,sp,-16
    800001da:	e422                	sd	s0,8(sp)
    800001dc:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001de:	ca0d                	beqz	a2,80000210 <memmove+0x38>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001e0:	00a5f963          	bgeu	a1,a0,800001f2 <memmove+0x1a>
    800001e4:	02061693          	slli	a3,a2,0x20
    800001e8:	9281                	srli	a3,a3,0x20
    800001ea:	00d58733          	add	a4,a1,a3
    800001ee:	02e56463          	bltu	a0,a4,80000216 <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001f2:	fff6079b          	addiw	a5,a2,-1
    800001f6:	1782                	slli	a5,a5,0x20
    800001f8:	9381                	srli	a5,a5,0x20
    800001fa:	0785                	addi	a5,a5,1
    800001fc:	97ae                	add	a5,a5,a1
    800001fe:	872a                	mv	a4,a0
      *d++ = *s++;
    80000200:	0585                	addi	a1,a1,1
    80000202:	0705                	addi	a4,a4,1
    80000204:	fff5c683          	lbu	a3,-1(a1)
    80000208:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    8000020c:	fef59ae3          	bne	a1,a5,80000200 <memmove+0x28>

  return dst;
}
    80000210:	6422                	ld	s0,8(sp)
    80000212:	0141                	addi	sp,sp,16
    80000214:	8082                	ret
    d += n;
    80000216:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000218:	fff6079b          	addiw	a5,a2,-1
    8000021c:	1782                	slli	a5,a5,0x20
    8000021e:	9381                	srli	a5,a5,0x20
    80000220:	fff7c793          	not	a5,a5
    80000224:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000226:	177d                	addi	a4,a4,-1
    80000228:	16fd                	addi	a3,a3,-1
    8000022a:	00074603          	lbu	a2,0(a4)
    8000022e:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000232:	fef71ae3          	bne	a4,a5,80000226 <memmove+0x4e>
    80000236:	bfe9                	j	80000210 <memmove+0x38>

0000000080000238 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000238:	1141                	addi	sp,sp,-16
    8000023a:	e406                	sd	ra,8(sp)
    8000023c:	e022                	sd	s0,0(sp)
    8000023e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000240:	00000097          	auipc	ra,0x0
    80000244:	f98080e7          	jalr	-104(ra) # 800001d8 <memmove>
}
    80000248:	60a2                	ld	ra,8(sp)
    8000024a:	6402                	ld	s0,0(sp)
    8000024c:	0141                	addi	sp,sp,16
    8000024e:	8082                	ret

0000000080000250 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000250:	1141                	addi	sp,sp,-16
    80000252:	e422                	sd	s0,8(sp)
    80000254:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000256:	ce11                	beqz	a2,80000272 <strncmp+0x22>
    80000258:	00054783          	lbu	a5,0(a0)
    8000025c:	cf89                	beqz	a5,80000276 <strncmp+0x26>
    8000025e:	0005c703          	lbu	a4,0(a1)
    80000262:	00f71a63          	bne	a4,a5,80000276 <strncmp+0x26>
    n--, p++, q++;
    80000266:	367d                	addiw	a2,a2,-1
    80000268:	0505                	addi	a0,a0,1
    8000026a:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    8000026c:	f675                	bnez	a2,80000258 <strncmp+0x8>
  if(n == 0)
    return 0;
    8000026e:	4501                	li	a0,0
    80000270:	a809                	j	80000282 <strncmp+0x32>
    80000272:	4501                	li	a0,0
    80000274:	a039                	j	80000282 <strncmp+0x32>
  if(n == 0)
    80000276:	ca09                	beqz	a2,80000288 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000278:	00054503          	lbu	a0,0(a0)
    8000027c:	0005c783          	lbu	a5,0(a1)
    80000280:	9d1d                	subw	a0,a0,a5
}
    80000282:	6422                	ld	s0,8(sp)
    80000284:	0141                	addi	sp,sp,16
    80000286:	8082                	ret
    return 0;
    80000288:	4501                	li	a0,0
    8000028a:	bfe5                	j	80000282 <strncmp+0x32>

000000008000028c <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    8000028c:	1141                	addi	sp,sp,-16
    8000028e:	e422                	sd	s0,8(sp)
    80000290:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000292:	872a                	mv	a4,a0
    80000294:	8832                	mv	a6,a2
    80000296:	367d                	addiw	a2,a2,-1
    80000298:	01005963          	blez	a6,800002aa <strncpy+0x1e>
    8000029c:	0705                	addi	a4,a4,1
    8000029e:	0005c783          	lbu	a5,0(a1)
    800002a2:	fef70fa3          	sb	a5,-1(a4)
    800002a6:	0585                	addi	a1,a1,1
    800002a8:	f7f5                	bnez	a5,80000294 <strncpy+0x8>
    ;
  while(n-- > 0)
    800002aa:	00c05d63          	blez	a2,800002c4 <strncpy+0x38>
    800002ae:	86ba                	mv	a3,a4
    *s++ = 0;
    800002b0:	0685                	addi	a3,a3,1
    800002b2:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800002b6:	fff6c793          	not	a5,a3
    800002ba:	9fb9                	addw	a5,a5,a4
    800002bc:	010787bb          	addw	a5,a5,a6
    800002c0:	fef048e3          	bgtz	a5,800002b0 <strncpy+0x24>
  return os;
}
    800002c4:	6422                	ld	s0,8(sp)
    800002c6:	0141                	addi	sp,sp,16
    800002c8:	8082                	ret

00000000800002ca <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002ca:	1141                	addi	sp,sp,-16
    800002cc:	e422                	sd	s0,8(sp)
    800002ce:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002d0:	02c05363          	blez	a2,800002f6 <safestrcpy+0x2c>
    800002d4:	fff6069b          	addiw	a3,a2,-1
    800002d8:	1682                	slli	a3,a3,0x20
    800002da:	9281                	srli	a3,a3,0x20
    800002dc:	96ae                	add	a3,a3,a1
    800002de:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002e0:	00d58963          	beq	a1,a3,800002f2 <safestrcpy+0x28>
    800002e4:	0585                	addi	a1,a1,1
    800002e6:	0785                	addi	a5,a5,1
    800002e8:	fff5c703          	lbu	a4,-1(a1)
    800002ec:	fee78fa3          	sb	a4,-1(a5)
    800002f0:	fb65                	bnez	a4,800002e0 <safestrcpy+0x16>
    ;
  *s = 0;
    800002f2:	00078023          	sb	zero,0(a5)
  return os;
}
    800002f6:	6422                	ld	s0,8(sp)
    800002f8:	0141                	addi	sp,sp,16
    800002fa:	8082                	ret

00000000800002fc <strlen>:

int
strlen(const char *s)
{
    800002fc:	1141                	addi	sp,sp,-16
    800002fe:	e422                	sd	s0,8(sp)
    80000300:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000302:	00054783          	lbu	a5,0(a0)
    80000306:	cf91                	beqz	a5,80000322 <strlen+0x26>
    80000308:	0505                	addi	a0,a0,1
    8000030a:	87aa                	mv	a5,a0
    8000030c:	4685                	li	a3,1
    8000030e:	9e89                	subw	a3,a3,a0
    80000310:	00f6853b          	addw	a0,a3,a5
    80000314:	0785                	addi	a5,a5,1
    80000316:	fff7c703          	lbu	a4,-1(a5)
    8000031a:	fb7d                	bnez	a4,80000310 <strlen+0x14>
    ;
  return n;
}
    8000031c:	6422                	ld	s0,8(sp)
    8000031e:	0141                	addi	sp,sp,16
    80000320:	8082                	ret
  for(n = 0; s[n]; n++)
    80000322:	4501                	li	a0,0
    80000324:	bfe5                	j	8000031c <strlen+0x20>

0000000080000326 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000326:	1141                	addi	sp,sp,-16
    80000328:	e406                	sd	ra,8(sp)
    8000032a:	e022                	sd	s0,0(sp)
    8000032c:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    8000032e:	00001097          	auipc	ra,0x1
    80000332:	bda080e7          	jalr	-1062(ra) # 80000f08 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000336:	00008717          	auipc	a4,0x8
    8000033a:	5ea70713          	addi	a4,a4,1514 # 80008920 <started>
  if(cpuid() == 0){
    8000033e:	c139                	beqz	a0,80000384 <main+0x5e>
    while(started == 0)
    80000340:	431c                	lw	a5,0(a4)
    80000342:	2781                	sext.w	a5,a5
    80000344:	dff5                	beqz	a5,80000340 <main+0x1a>
      ;
    __sync_synchronize();
    80000346:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    8000034a:	00001097          	auipc	ra,0x1
    8000034e:	bbe080e7          	jalr	-1090(ra) # 80000f08 <cpuid>
    80000352:	85aa                	mv	a1,a0
    80000354:	00008517          	auipc	a0,0x8
    80000358:	ce450513          	addi	a0,a0,-796 # 80008038 <etext+0x38>
    8000035c:	00006097          	auipc	ra,0x6
    80000360:	b70080e7          	jalr	-1168(ra) # 80005ecc <printf>
    kvminithart();    // turn on paging
    80000364:	00000097          	auipc	ra,0x0
    80000368:	0d8080e7          	jalr	216(ra) # 8000043c <kvminithart>
    trapinithart();   // install kernel trap vector
    8000036c:	00002097          	auipc	ra,0x2
    80000370:	91c080e7          	jalr	-1764(ra) # 80001c88 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000374:	00005097          	auipc	ra,0x5
    80000378:	fac080e7          	jalr	-84(ra) # 80005320 <plicinithart>
  }

  scheduler();        
    8000037c:	00001097          	auipc	ra,0x1
    80000380:	166080e7          	jalr	358(ra) # 800014e2 <scheduler>
    consoleinit();
    80000384:	00006097          	auipc	ra,0x6
    80000388:	a10080e7          	jalr	-1520(ra) # 80005d94 <consoleinit>
    printfinit();
    8000038c:	00006097          	auipc	ra,0x6
    80000390:	d26080e7          	jalr	-730(ra) # 800060b2 <printfinit>
    printf("\n");
    80000394:	00008517          	auipc	a0,0x8
    80000398:	cb450513          	addi	a0,a0,-844 # 80008048 <etext+0x48>
    8000039c:	00006097          	auipc	ra,0x6
    800003a0:	b30080e7          	jalr	-1232(ra) # 80005ecc <printf>
    printf("xv6 kernel is booting\n");
    800003a4:	00008517          	auipc	a0,0x8
    800003a8:	c7c50513          	addi	a0,a0,-900 # 80008020 <etext+0x20>
    800003ac:	00006097          	auipc	ra,0x6
    800003b0:	b20080e7          	jalr	-1248(ra) # 80005ecc <printf>
    printf("\n");
    800003b4:	00008517          	auipc	a0,0x8
    800003b8:	c9450513          	addi	a0,a0,-876 # 80008048 <etext+0x48>
    800003bc:	00006097          	auipc	ra,0x6
    800003c0:	b10080e7          	jalr	-1264(ra) # 80005ecc <printf>
    kinit();         // physical page allocator
    800003c4:	00000097          	auipc	ra,0x0
    800003c8:	d18080e7          	jalr	-744(ra) # 800000dc <kinit>
    kvminit();       // create kernel page table
    800003cc:	00000097          	auipc	ra,0x0
    800003d0:	326080e7          	jalr	806(ra) # 800006f2 <kvminit>
    kvminithart();   // turn on paging
    800003d4:	00000097          	auipc	ra,0x0
    800003d8:	068080e7          	jalr	104(ra) # 8000043c <kvminithart>
    procinit();      // process table
    800003dc:	00001097          	auipc	ra,0x1
    800003e0:	a7a080e7          	jalr	-1414(ra) # 80000e56 <procinit>
    trapinit();      // trap vectors
    800003e4:	00002097          	auipc	ra,0x2
    800003e8:	87c080e7          	jalr	-1924(ra) # 80001c60 <trapinit>
    trapinithart();  // install kernel trap vector
    800003ec:	00002097          	auipc	ra,0x2
    800003f0:	89c080e7          	jalr	-1892(ra) # 80001c88 <trapinithart>
    plicinit();      // set up interrupt controller
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	f16080e7          	jalr	-234(ra) # 8000530a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003fc:	00005097          	auipc	ra,0x5
    80000400:	f24080e7          	jalr	-220(ra) # 80005320 <plicinithart>
    binit();         // buffer cache
    80000404:	00002097          	auipc	ra,0x2
    80000408:	0ac080e7          	jalr	172(ra) # 800024b0 <binit>
    iinit();         // inode table
    8000040c:	00002097          	auipc	ra,0x2
    80000410:	750080e7          	jalr	1872(ra) # 80002b5c <iinit>
    fileinit();      // file table
    80000414:	00003097          	auipc	ra,0x3
    80000418:	6ee080e7          	jalr	1774(ra) # 80003b02 <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000041c:	00005097          	auipc	ra,0x5
    80000420:	00c080e7          	jalr	12(ra) # 80005428 <virtio_disk_init>
    userinit();      // first user process
    80000424:	00001097          	auipc	ra,0x1
    80000428:	ea4080e7          	jalr	-348(ra) # 800012c8 <userinit>
    __sync_synchronize();
    8000042c:	0ff0000f          	fence
    started = 1;
    80000430:	4785                	li	a5,1
    80000432:	00008717          	auipc	a4,0x8
    80000436:	4ef72723          	sw	a5,1262(a4) # 80008920 <started>
    8000043a:	b789                	j	8000037c <main+0x56>

000000008000043c <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    8000043c:	1141                	addi	sp,sp,-16
    8000043e:	e422                	sd	s0,8(sp)
    80000440:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000442:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000446:	00008797          	auipc	a5,0x8
    8000044a:	4e27b783          	ld	a5,1250(a5) # 80008928 <kernel_pagetable>
    8000044e:	83b1                	srli	a5,a5,0xc
    80000450:	577d                	li	a4,-1
    80000452:	177e                	slli	a4,a4,0x3f
    80000454:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000456:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    8000045a:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    8000045e:	6422                	ld	s0,8(sp)
    80000460:	0141                	addi	sp,sp,16
    80000462:	8082                	ret

0000000080000464 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000464:	7139                	addi	sp,sp,-64
    80000466:	fc06                	sd	ra,56(sp)
    80000468:	f822                	sd	s0,48(sp)
    8000046a:	f426                	sd	s1,40(sp)
    8000046c:	f04a                	sd	s2,32(sp)
    8000046e:	ec4e                	sd	s3,24(sp)
    80000470:	e852                	sd	s4,16(sp)
    80000472:	e456                	sd	s5,8(sp)
    80000474:	e05a                	sd	s6,0(sp)
    80000476:	0080                	addi	s0,sp,64
    80000478:	84aa                	mv	s1,a0
    8000047a:	89ae                	mv	s3,a1
    8000047c:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    8000047e:	57fd                	li	a5,-1
    80000480:	83e9                	srli	a5,a5,0x1a
    80000482:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000484:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000486:	04b7f263          	bgeu	a5,a1,800004ca <walk+0x66>
    panic("walk");
    8000048a:	00008517          	auipc	a0,0x8
    8000048e:	bc650513          	addi	a0,a0,-1082 # 80008050 <etext+0x50>
    80000492:	00006097          	auipc	ra,0x6
    80000496:	9f0080e7          	jalr	-1552(ra) # 80005e82 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    8000049a:	060a8663          	beqz	s5,80000506 <walk+0xa2>
    8000049e:	00000097          	auipc	ra,0x0
    800004a2:	c7a080e7          	jalr	-902(ra) # 80000118 <kalloc>
    800004a6:	84aa                	mv	s1,a0
    800004a8:	c529                	beqz	a0,800004f2 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004aa:	6605                	lui	a2,0x1
    800004ac:	4581                	li	a1,0
    800004ae:	00000097          	auipc	ra,0x0
    800004b2:	cca080e7          	jalr	-822(ra) # 80000178 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004b6:	00c4d793          	srli	a5,s1,0xc
    800004ba:	07aa                	slli	a5,a5,0xa
    800004bc:	0017e793          	ori	a5,a5,1
    800004c0:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004c4:	3a5d                	addiw	s4,s4,-9
    800004c6:	036a0063          	beq	s4,s6,800004e6 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004ca:	0149d933          	srl	s2,s3,s4
    800004ce:	1ff97913          	andi	s2,s2,511
    800004d2:	090e                	slli	s2,s2,0x3
    800004d4:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004d6:	00093483          	ld	s1,0(s2)
    800004da:	0014f793          	andi	a5,s1,1
    800004de:	dfd5                	beqz	a5,8000049a <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004e0:	80a9                	srli	s1,s1,0xa
    800004e2:	04b2                	slli	s1,s1,0xc
    800004e4:	b7c5                	j	800004c4 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800004e6:	00c9d513          	srli	a0,s3,0xc
    800004ea:	1ff57513          	andi	a0,a0,511
    800004ee:	050e                	slli	a0,a0,0x3
    800004f0:	9526                	add	a0,a0,s1
}
    800004f2:	70e2                	ld	ra,56(sp)
    800004f4:	7442                	ld	s0,48(sp)
    800004f6:	74a2                	ld	s1,40(sp)
    800004f8:	7902                	ld	s2,32(sp)
    800004fa:	69e2                	ld	s3,24(sp)
    800004fc:	6a42                	ld	s4,16(sp)
    800004fe:	6aa2                	ld	s5,8(sp)
    80000500:	6b02                	ld	s6,0(sp)
    80000502:	6121                	addi	sp,sp,64
    80000504:	8082                	ret
        return 0;
    80000506:	4501                	li	a0,0
    80000508:	b7ed                	j	800004f2 <walk+0x8e>

000000008000050a <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    8000050a:	57fd                	li	a5,-1
    8000050c:	83e9                	srli	a5,a5,0x1a
    8000050e:	00b7f463          	bgeu	a5,a1,80000516 <walkaddr+0xc>
    return 0;
    80000512:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000514:	8082                	ret
{
    80000516:	1141                	addi	sp,sp,-16
    80000518:	e406                	sd	ra,8(sp)
    8000051a:	e022                	sd	s0,0(sp)
    8000051c:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000051e:	4601                	li	a2,0
    80000520:	00000097          	auipc	ra,0x0
    80000524:	f44080e7          	jalr	-188(ra) # 80000464 <walk>
  if(pte == 0)
    80000528:	c105                	beqz	a0,80000548 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    8000052a:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000052c:	0117f693          	andi	a3,a5,17
    80000530:	4745                	li	a4,17
    return 0;
    80000532:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000534:	00e68663          	beq	a3,a4,80000540 <walkaddr+0x36>
}
    80000538:	60a2                	ld	ra,8(sp)
    8000053a:	6402                	ld	s0,0(sp)
    8000053c:	0141                	addi	sp,sp,16
    8000053e:	8082                	ret
  pa = PTE2PA(*pte);
    80000540:	00a7d513          	srli	a0,a5,0xa
    80000544:	0532                	slli	a0,a0,0xc
  return pa;
    80000546:	bfcd                	j	80000538 <walkaddr+0x2e>
    return 0;
    80000548:	4501                	li	a0,0
    8000054a:	b7fd                	j	80000538 <walkaddr+0x2e>

000000008000054c <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000054c:	715d                	addi	sp,sp,-80
    8000054e:	e486                	sd	ra,72(sp)
    80000550:	e0a2                	sd	s0,64(sp)
    80000552:	fc26                	sd	s1,56(sp)
    80000554:	f84a                	sd	s2,48(sp)
    80000556:	f44e                	sd	s3,40(sp)
    80000558:	f052                	sd	s4,32(sp)
    8000055a:	ec56                	sd	s5,24(sp)
    8000055c:	e85a                	sd	s6,16(sp)
    8000055e:	e45e                	sd	s7,8(sp)
    80000560:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    80000562:	c205                	beqz	a2,80000582 <mappages+0x36>
    80000564:	8aaa                	mv	s5,a0
    80000566:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80000568:	77fd                	lui	a5,0xfffff
    8000056a:	00f5fa33          	and	s4,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    8000056e:	15fd                	addi	a1,a1,-1
    80000570:	00c589b3          	add	s3,a1,a2
    80000574:	00f9f9b3          	and	s3,s3,a5
  a = PGROUNDDOWN(va);
    80000578:	8952                	mv	s2,s4
    8000057a:	41468a33          	sub	s4,a3,s4
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    8000057e:	6b85                	lui	s7,0x1
    80000580:	a015                	j	800005a4 <mappages+0x58>
    panic("mappages: size");
    80000582:	00008517          	auipc	a0,0x8
    80000586:	ad650513          	addi	a0,a0,-1322 # 80008058 <etext+0x58>
    8000058a:	00006097          	auipc	ra,0x6
    8000058e:	8f8080e7          	jalr	-1800(ra) # 80005e82 <panic>
      panic("mappages: remap");
    80000592:	00008517          	auipc	a0,0x8
    80000596:	ad650513          	addi	a0,a0,-1322 # 80008068 <etext+0x68>
    8000059a:	00006097          	auipc	ra,0x6
    8000059e:	8e8080e7          	jalr	-1816(ra) # 80005e82 <panic>
    a += PGSIZE;
    800005a2:	995e                	add	s2,s2,s7
  for(;;){
    800005a4:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800005a8:	4605                	li	a2,1
    800005aa:	85ca                	mv	a1,s2
    800005ac:	8556                	mv	a0,s5
    800005ae:	00000097          	auipc	ra,0x0
    800005b2:	eb6080e7          	jalr	-330(ra) # 80000464 <walk>
    800005b6:	cd19                	beqz	a0,800005d4 <mappages+0x88>
    if(*pte & PTE_V)
    800005b8:	611c                	ld	a5,0(a0)
    800005ba:	8b85                	andi	a5,a5,1
    800005bc:	fbf9                	bnez	a5,80000592 <mappages+0x46>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800005be:	80b1                	srli	s1,s1,0xc
    800005c0:	04aa                	slli	s1,s1,0xa
    800005c2:	0164e4b3          	or	s1,s1,s6
    800005c6:	0014e493          	ori	s1,s1,1
    800005ca:	e104                	sd	s1,0(a0)
    if(a == last)
    800005cc:	fd391be3          	bne	s2,s3,800005a2 <mappages+0x56>
    pa += PGSIZE;
  }
  return 0;
    800005d0:	4501                	li	a0,0
    800005d2:	a011                	j	800005d6 <mappages+0x8a>
      return -1;
    800005d4:	557d                	li	a0,-1
}
    800005d6:	60a6                	ld	ra,72(sp)
    800005d8:	6406                	ld	s0,64(sp)
    800005da:	74e2                	ld	s1,56(sp)
    800005dc:	7942                	ld	s2,48(sp)
    800005de:	79a2                	ld	s3,40(sp)
    800005e0:	7a02                	ld	s4,32(sp)
    800005e2:	6ae2                	ld	s5,24(sp)
    800005e4:	6b42                	ld	s6,16(sp)
    800005e6:	6ba2                	ld	s7,8(sp)
    800005e8:	6161                	addi	sp,sp,80
    800005ea:	8082                	ret

00000000800005ec <kvmmap>:
{
    800005ec:	1141                	addi	sp,sp,-16
    800005ee:	e406                	sd	ra,8(sp)
    800005f0:	e022                	sd	s0,0(sp)
    800005f2:	0800                	addi	s0,sp,16
    800005f4:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800005f6:	86b2                	mv	a3,a2
    800005f8:	863e                	mv	a2,a5
    800005fa:	00000097          	auipc	ra,0x0
    800005fe:	f52080e7          	jalr	-174(ra) # 8000054c <mappages>
    80000602:	e509                	bnez	a0,8000060c <kvmmap+0x20>
}
    80000604:	60a2                	ld	ra,8(sp)
    80000606:	6402                	ld	s0,0(sp)
    80000608:	0141                	addi	sp,sp,16
    8000060a:	8082                	ret
    panic("kvmmap");
    8000060c:	00008517          	auipc	a0,0x8
    80000610:	a6c50513          	addi	a0,a0,-1428 # 80008078 <etext+0x78>
    80000614:	00006097          	auipc	ra,0x6
    80000618:	86e080e7          	jalr	-1938(ra) # 80005e82 <panic>

000000008000061c <kvmmake>:
{
    8000061c:	1101                	addi	sp,sp,-32
    8000061e:	ec06                	sd	ra,24(sp)
    80000620:	e822                	sd	s0,16(sp)
    80000622:	e426                	sd	s1,8(sp)
    80000624:	e04a                	sd	s2,0(sp)
    80000626:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000628:	00000097          	auipc	ra,0x0
    8000062c:	af0080e7          	jalr	-1296(ra) # 80000118 <kalloc>
    80000630:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000632:	6605                	lui	a2,0x1
    80000634:	4581                	li	a1,0
    80000636:	00000097          	auipc	ra,0x0
    8000063a:	b42080e7          	jalr	-1214(ra) # 80000178 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000063e:	4719                	li	a4,6
    80000640:	6685                	lui	a3,0x1
    80000642:	10000637          	lui	a2,0x10000
    80000646:	100005b7          	lui	a1,0x10000
    8000064a:	8526                	mv	a0,s1
    8000064c:	00000097          	auipc	ra,0x0
    80000650:	fa0080e7          	jalr	-96(ra) # 800005ec <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000654:	4719                	li	a4,6
    80000656:	6685                	lui	a3,0x1
    80000658:	10001637          	lui	a2,0x10001
    8000065c:	100015b7          	lui	a1,0x10001
    80000660:	8526                	mv	a0,s1
    80000662:	00000097          	auipc	ra,0x0
    80000666:	f8a080e7          	jalr	-118(ra) # 800005ec <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    8000066a:	4719                	li	a4,6
    8000066c:	004006b7          	lui	a3,0x400
    80000670:	0c000637          	lui	a2,0xc000
    80000674:	0c0005b7          	lui	a1,0xc000
    80000678:	8526                	mv	a0,s1
    8000067a:	00000097          	auipc	ra,0x0
    8000067e:	f72080e7          	jalr	-142(ra) # 800005ec <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80000682:	00008917          	auipc	s2,0x8
    80000686:	97e90913          	addi	s2,s2,-1666 # 80008000 <etext>
    8000068a:	4729                	li	a4,10
    8000068c:	80008697          	auipc	a3,0x80008
    80000690:	97468693          	addi	a3,a3,-1676 # 8000 <_entry-0x7fff8000>
    80000694:	4605                	li	a2,1
    80000696:	067e                	slli	a2,a2,0x1f
    80000698:	85b2                	mv	a1,a2
    8000069a:	8526                	mv	a0,s1
    8000069c:	00000097          	auipc	ra,0x0
    800006a0:	f50080e7          	jalr	-176(ra) # 800005ec <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800006a4:	4719                	li	a4,6
    800006a6:	46c5                	li	a3,17
    800006a8:	06ee                	slli	a3,a3,0x1b
    800006aa:	412686b3          	sub	a3,a3,s2
    800006ae:	864a                	mv	a2,s2
    800006b0:	85ca                	mv	a1,s2
    800006b2:	8526                	mv	a0,s1
    800006b4:	00000097          	auipc	ra,0x0
    800006b8:	f38080e7          	jalr	-200(ra) # 800005ec <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006bc:	4729                	li	a4,10
    800006be:	6685                	lui	a3,0x1
    800006c0:	00007617          	auipc	a2,0x7
    800006c4:	94060613          	addi	a2,a2,-1728 # 80007000 <_trampoline>
    800006c8:	040005b7          	lui	a1,0x4000
    800006cc:	15fd                	addi	a1,a1,-1
    800006ce:	05b2                	slli	a1,a1,0xc
    800006d0:	8526                	mv	a0,s1
    800006d2:	00000097          	auipc	ra,0x0
    800006d6:	f1a080e7          	jalr	-230(ra) # 800005ec <kvmmap>
  proc_mapstacks(kpgtbl);
    800006da:	8526                	mv	a0,s1
    800006dc:	00000097          	auipc	ra,0x0
    800006e0:	6e6080e7          	jalr	1766(ra) # 80000dc2 <proc_mapstacks>
}
    800006e4:	8526                	mv	a0,s1
    800006e6:	60e2                	ld	ra,24(sp)
    800006e8:	6442                	ld	s0,16(sp)
    800006ea:	64a2                	ld	s1,8(sp)
    800006ec:	6902                	ld	s2,0(sp)
    800006ee:	6105                	addi	sp,sp,32
    800006f0:	8082                	ret

00000000800006f2 <kvminit>:
{
    800006f2:	1141                	addi	sp,sp,-16
    800006f4:	e406                	sd	ra,8(sp)
    800006f6:	e022                	sd	s0,0(sp)
    800006f8:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800006fa:	00000097          	auipc	ra,0x0
    800006fe:	f22080e7          	jalr	-222(ra) # 8000061c <kvmmake>
    80000702:	00008797          	auipc	a5,0x8
    80000706:	22a7b323          	sd	a0,550(a5) # 80008928 <kernel_pagetable>
}
    8000070a:	60a2                	ld	ra,8(sp)
    8000070c:	6402                	ld	s0,0(sp)
    8000070e:	0141                	addi	sp,sp,16
    80000710:	8082                	ret

0000000080000712 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000712:	715d                	addi	sp,sp,-80
    80000714:	e486                	sd	ra,72(sp)
    80000716:	e0a2                	sd	s0,64(sp)
    80000718:	fc26                	sd	s1,56(sp)
    8000071a:	f84a                	sd	s2,48(sp)
    8000071c:	f44e                	sd	s3,40(sp)
    8000071e:	f052                	sd	s4,32(sp)
    80000720:	ec56                	sd	s5,24(sp)
    80000722:	e85a                	sd	s6,16(sp)
    80000724:	e45e                	sd	s7,8(sp)
    80000726:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000728:	03459793          	slli	a5,a1,0x34
    8000072c:	e795                	bnez	a5,80000758 <uvmunmap+0x46>
    8000072e:	8a2a                	mv	s4,a0
    80000730:	892e                	mv	s2,a1
    80000732:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000734:	0632                	slli	a2,a2,0xc
    80000736:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    8000073a:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000073c:	6b05                	lui	s6,0x1
    8000073e:	0735e863          	bltu	a1,s3,800007ae <uvmunmap+0x9c>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80000742:	60a6                	ld	ra,72(sp)
    80000744:	6406                	ld	s0,64(sp)
    80000746:	74e2                	ld	s1,56(sp)
    80000748:	7942                	ld	s2,48(sp)
    8000074a:	79a2                	ld	s3,40(sp)
    8000074c:	7a02                	ld	s4,32(sp)
    8000074e:	6ae2                	ld	s5,24(sp)
    80000750:	6b42                	ld	s6,16(sp)
    80000752:	6ba2                	ld	s7,8(sp)
    80000754:	6161                	addi	sp,sp,80
    80000756:	8082                	ret
    panic("uvmunmap: not aligned");
    80000758:	00008517          	auipc	a0,0x8
    8000075c:	92850513          	addi	a0,a0,-1752 # 80008080 <etext+0x80>
    80000760:	00005097          	auipc	ra,0x5
    80000764:	722080e7          	jalr	1826(ra) # 80005e82 <panic>
      panic("uvmunmap: walk");
    80000768:	00008517          	auipc	a0,0x8
    8000076c:	93050513          	addi	a0,a0,-1744 # 80008098 <etext+0x98>
    80000770:	00005097          	auipc	ra,0x5
    80000774:	712080e7          	jalr	1810(ra) # 80005e82 <panic>
      panic("uvmunmap: not mapped");
    80000778:	00008517          	auipc	a0,0x8
    8000077c:	93050513          	addi	a0,a0,-1744 # 800080a8 <etext+0xa8>
    80000780:	00005097          	auipc	ra,0x5
    80000784:	702080e7          	jalr	1794(ra) # 80005e82 <panic>
      panic("uvmunmap: not a leaf");
    80000788:	00008517          	auipc	a0,0x8
    8000078c:	93850513          	addi	a0,a0,-1736 # 800080c0 <etext+0xc0>
    80000790:	00005097          	auipc	ra,0x5
    80000794:	6f2080e7          	jalr	1778(ra) # 80005e82 <panic>
      uint64 pa = PTE2PA(*pte);
    80000798:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    8000079a:	0532                	slli	a0,a0,0xc
    8000079c:	00000097          	auipc	ra,0x0
    800007a0:	880080e7          	jalr	-1920(ra) # 8000001c <kfree>
    *pte = 0;
    800007a4:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007a8:	995a                	add	s2,s2,s6
    800007aa:	f9397ce3          	bgeu	s2,s3,80000742 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800007ae:	4601                	li	a2,0
    800007b0:	85ca                	mv	a1,s2
    800007b2:	8552                	mv	a0,s4
    800007b4:	00000097          	auipc	ra,0x0
    800007b8:	cb0080e7          	jalr	-848(ra) # 80000464 <walk>
    800007bc:	84aa                	mv	s1,a0
    800007be:	d54d                	beqz	a0,80000768 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800007c0:	6108                	ld	a0,0(a0)
    800007c2:	00157793          	andi	a5,a0,1
    800007c6:	dbcd                	beqz	a5,80000778 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007c8:	3ff57793          	andi	a5,a0,1023
    800007cc:	fb778ee3          	beq	a5,s7,80000788 <uvmunmap+0x76>
    if(do_free){
    800007d0:	fc0a8ae3          	beqz	s5,800007a4 <uvmunmap+0x92>
    800007d4:	b7d1                	j	80000798 <uvmunmap+0x86>

00000000800007d6 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007d6:	1101                	addi	sp,sp,-32
    800007d8:	ec06                	sd	ra,24(sp)
    800007da:	e822                	sd	s0,16(sp)
    800007dc:	e426                	sd	s1,8(sp)
    800007de:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800007e0:	00000097          	auipc	ra,0x0
    800007e4:	938080e7          	jalr	-1736(ra) # 80000118 <kalloc>
    800007e8:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800007ea:	c519                	beqz	a0,800007f8 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800007ec:	6605                	lui	a2,0x1
    800007ee:	4581                	li	a1,0
    800007f0:	00000097          	auipc	ra,0x0
    800007f4:	988080e7          	jalr	-1656(ra) # 80000178 <memset>
  return pagetable;
}
    800007f8:	8526                	mv	a0,s1
    800007fa:	60e2                	ld	ra,24(sp)
    800007fc:	6442                	ld	s0,16(sp)
    800007fe:	64a2                	ld	s1,8(sp)
    80000800:	6105                	addi	sp,sp,32
    80000802:	8082                	ret

0000000080000804 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    80000804:	7179                	addi	sp,sp,-48
    80000806:	f406                	sd	ra,40(sp)
    80000808:	f022                	sd	s0,32(sp)
    8000080a:	ec26                	sd	s1,24(sp)
    8000080c:	e84a                	sd	s2,16(sp)
    8000080e:	e44e                	sd	s3,8(sp)
    80000810:	e052                	sd	s4,0(sp)
    80000812:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000814:	6785                	lui	a5,0x1
    80000816:	04f67863          	bgeu	a2,a5,80000866 <uvmfirst+0x62>
    8000081a:	8a2a                	mv	s4,a0
    8000081c:	89ae                	mv	s3,a1
    8000081e:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80000820:	00000097          	auipc	ra,0x0
    80000824:	8f8080e7          	jalr	-1800(ra) # 80000118 <kalloc>
    80000828:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8000082a:	6605                	lui	a2,0x1
    8000082c:	4581                	li	a1,0
    8000082e:	00000097          	auipc	ra,0x0
    80000832:	94a080e7          	jalr	-1718(ra) # 80000178 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000836:	4779                	li	a4,30
    80000838:	86ca                	mv	a3,s2
    8000083a:	6605                	lui	a2,0x1
    8000083c:	4581                	li	a1,0
    8000083e:	8552                	mv	a0,s4
    80000840:	00000097          	auipc	ra,0x0
    80000844:	d0c080e7          	jalr	-756(ra) # 8000054c <mappages>
  memmove(mem, src, sz);
    80000848:	8626                	mv	a2,s1
    8000084a:	85ce                	mv	a1,s3
    8000084c:	854a                	mv	a0,s2
    8000084e:	00000097          	auipc	ra,0x0
    80000852:	98a080e7          	jalr	-1654(ra) # 800001d8 <memmove>
}
    80000856:	70a2                	ld	ra,40(sp)
    80000858:	7402                	ld	s0,32(sp)
    8000085a:	64e2                	ld	s1,24(sp)
    8000085c:	6942                	ld	s2,16(sp)
    8000085e:	69a2                	ld	s3,8(sp)
    80000860:	6a02                	ld	s4,0(sp)
    80000862:	6145                	addi	sp,sp,48
    80000864:	8082                	ret
    panic("uvmfirst: more than a page");
    80000866:	00008517          	auipc	a0,0x8
    8000086a:	87250513          	addi	a0,a0,-1934 # 800080d8 <etext+0xd8>
    8000086e:	00005097          	auipc	ra,0x5
    80000872:	614080e7          	jalr	1556(ra) # 80005e82 <panic>

0000000080000876 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000876:	1101                	addi	sp,sp,-32
    80000878:	ec06                	sd	ra,24(sp)
    8000087a:	e822                	sd	s0,16(sp)
    8000087c:	e426                	sd	s1,8(sp)
    8000087e:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80000880:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80000882:	00b67d63          	bgeu	a2,a1,8000089c <uvmdealloc+0x26>
    80000886:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000888:	6785                	lui	a5,0x1
    8000088a:	17fd                	addi	a5,a5,-1
    8000088c:	00f60733          	add	a4,a2,a5
    80000890:	767d                	lui	a2,0xfffff
    80000892:	8f71                	and	a4,a4,a2
    80000894:	97ae                	add	a5,a5,a1
    80000896:	8ff1                	and	a5,a5,a2
    80000898:	00f76863          	bltu	a4,a5,800008a8 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    8000089c:	8526                	mv	a0,s1
    8000089e:	60e2                	ld	ra,24(sp)
    800008a0:	6442                	ld	s0,16(sp)
    800008a2:	64a2                	ld	s1,8(sp)
    800008a4:	6105                	addi	sp,sp,32
    800008a6:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008a8:	8f99                	sub	a5,a5,a4
    800008aa:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008ac:	4685                	li	a3,1
    800008ae:	0007861b          	sext.w	a2,a5
    800008b2:	85ba                	mv	a1,a4
    800008b4:	00000097          	auipc	ra,0x0
    800008b8:	e5e080e7          	jalr	-418(ra) # 80000712 <uvmunmap>
    800008bc:	b7c5                	j	8000089c <uvmdealloc+0x26>

00000000800008be <uvmalloc>:
  if(newsz < oldsz)
    800008be:	0ab66563          	bltu	a2,a1,80000968 <uvmalloc+0xaa>
{
    800008c2:	7139                	addi	sp,sp,-64
    800008c4:	fc06                	sd	ra,56(sp)
    800008c6:	f822                	sd	s0,48(sp)
    800008c8:	f426                	sd	s1,40(sp)
    800008ca:	f04a                	sd	s2,32(sp)
    800008cc:	ec4e                	sd	s3,24(sp)
    800008ce:	e852                	sd	s4,16(sp)
    800008d0:	e456                	sd	s5,8(sp)
    800008d2:	e05a                	sd	s6,0(sp)
    800008d4:	0080                	addi	s0,sp,64
    800008d6:	8aaa                	mv	s5,a0
    800008d8:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008da:	6985                	lui	s3,0x1
    800008dc:	19fd                	addi	s3,s3,-1
    800008de:	95ce                	add	a1,a1,s3
    800008e0:	79fd                	lui	s3,0xfffff
    800008e2:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    800008e6:	08c9f363          	bgeu	s3,a2,8000096c <uvmalloc+0xae>
    800008ea:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800008ec:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    800008f0:	00000097          	auipc	ra,0x0
    800008f4:	828080e7          	jalr	-2008(ra) # 80000118 <kalloc>
    800008f8:	84aa                	mv	s1,a0
    if(mem == 0){
    800008fa:	c51d                	beqz	a0,80000928 <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    800008fc:	6605                	lui	a2,0x1
    800008fe:	4581                	li	a1,0
    80000900:	00000097          	auipc	ra,0x0
    80000904:	878080e7          	jalr	-1928(ra) # 80000178 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000908:	875a                	mv	a4,s6
    8000090a:	86a6                	mv	a3,s1
    8000090c:	6605                	lui	a2,0x1
    8000090e:	85ca                	mv	a1,s2
    80000910:	8556                	mv	a0,s5
    80000912:	00000097          	auipc	ra,0x0
    80000916:	c3a080e7          	jalr	-966(ra) # 8000054c <mappages>
    8000091a:	e90d                	bnez	a0,8000094c <uvmalloc+0x8e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000091c:	6785                	lui	a5,0x1
    8000091e:	993e                	add	s2,s2,a5
    80000920:	fd4968e3          	bltu	s2,s4,800008f0 <uvmalloc+0x32>
  return newsz;
    80000924:	8552                	mv	a0,s4
    80000926:	a809                	j	80000938 <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    80000928:	864e                	mv	a2,s3
    8000092a:	85ca                	mv	a1,s2
    8000092c:	8556                	mv	a0,s5
    8000092e:	00000097          	auipc	ra,0x0
    80000932:	f48080e7          	jalr	-184(ra) # 80000876 <uvmdealloc>
      return 0;
    80000936:	4501                	li	a0,0
}
    80000938:	70e2                	ld	ra,56(sp)
    8000093a:	7442                	ld	s0,48(sp)
    8000093c:	74a2                	ld	s1,40(sp)
    8000093e:	7902                	ld	s2,32(sp)
    80000940:	69e2                	ld	s3,24(sp)
    80000942:	6a42                	ld	s4,16(sp)
    80000944:	6aa2                	ld	s5,8(sp)
    80000946:	6b02                	ld	s6,0(sp)
    80000948:	6121                	addi	sp,sp,64
    8000094a:	8082                	ret
      kfree(mem);
    8000094c:	8526                	mv	a0,s1
    8000094e:	fffff097          	auipc	ra,0xfffff
    80000952:	6ce080e7          	jalr	1742(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000956:	864e                	mv	a2,s3
    80000958:	85ca                	mv	a1,s2
    8000095a:	8556                	mv	a0,s5
    8000095c:	00000097          	auipc	ra,0x0
    80000960:	f1a080e7          	jalr	-230(ra) # 80000876 <uvmdealloc>
      return 0;
    80000964:	4501                	li	a0,0
    80000966:	bfc9                	j	80000938 <uvmalloc+0x7a>
    return oldsz;
    80000968:	852e                	mv	a0,a1
}
    8000096a:	8082                	ret
  return newsz;
    8000096c:	8532                	mv	a0,a2
    8000096e:	b7e9                	j	80000938 <uvmalloc+0x7a>

0000000080000970 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000970:	7179                	addi	sp,sp,-48
    80000972:	f406                	sd	ra,40(sp)
    80000974:	f022                	sd	s0,32(sp)
    80000976:	ec26                	sd	s1,24(sp)
    80000978:	e84a                	sd	s2,16(sp)
    8000097a:	e44e                	sd	s3,8(sp)
    8000097c:	e052                	sd	s4,0(sp)
    8000097e:	1800                	addi	s0,sp,48
    80000980:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000982:	84aa                	mv	s1,a0
    80000984:	6905                	lui	s2,0x1
    80000986:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000988:	4985                	li	s3,1
    8000098a:	a821                	j	800009a2 <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    8000098c:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    8000098e:	0532                	slli	a0,a0,0xc
    80000990:	00000097          	auipc	ra,0x0
    80000994:	fe0080e7          	jalr	-32(ra) # 80000970 <freewalk>
      pagetable[i] = 0;
    80000998:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    8000099c:	04a1                	addi	s1,s1,8
    8000099e:	03248163          	beq	s1,s2,800009c0 <freewalk+0x50>
    pte_t pte = pagetable[i];
    800009a2:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009a4:	00f57793          	andi	a5,a0,15
    800009a8:	ff3782e3          	beq	a5,s3,8000098c <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009ac:	8905                	andi	a0,a0,1
    800009ae:	d57d                	beqz	a0,8000099c <freewalk+0x2c>
      panic("freewalk: leaf");
    800009b0:	00007517          	auipc	a0,0x7
    800009b4:	74850513          	addi	a0,a0,1864 # 800080f8 <etext+0xf8>
    800009b8:	00005097          	auipc	ra,0x5
    800009bc:	4ca080e7          	jalr	1226(ra) # 80005e82 <panic>
    }
  }
  kfree((void*)pagetable);
    800009c0:	8552                	mv	a0,s4
    800009c2:	fffff097          	auipc	ra,0xfffff
    800009c6:	65a080e7          	jalr	1626(ra) # 8000001c <kfree>
}
    800009ca:	70a2                	ld	ra,40(sp)
    800009cc:	7402                	ld	s0,32(sp)
    800009ce:	64e2                	ld	s1,24(sp)
    800009d0:	6942                	ld	s2,16(sp)
    800009d2:	69a2                	ld	s3,8(sp)
    800009d4:	6a02                	ld	s4,0(sp)
    800009d6:	6145                	addi	sp,sp,48
    800009d8:	8082                	ret

00000000800009da <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009da:	1101                	addi	sp,sp,-32
    800009dc:	ec06                	sd	ra,24(sp)
    800009de:	e822                	sd	s0,16(sp)
    800009e0:	e426                	sd	s1,8(sp)
    800009e2:	1000                	addi	s0,sp,32
    800009e4:	84aa                	mv	s1,a0
  if(sz > 0)
    800009e6:	e999                	bnez	a1,800009fc <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800009e8:	8526                	mv	a0,s1
    800009ea:	00000097          	auipc	ra,0x0
    800009ee:	f86080e7          	jalr	-122(ra) # 80000970 <freewalk>
}
    800009f2:	60e2                	ld	ra,24(sp)
    800009f4:	6442                	ld	s0,16(sp)
    800009f6:	64a2                	ld	s1,8(sp)
    800009f8:	6105                	addi	sp,sp,32
    800009fa:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800009fc:	6605                	lui	a2,0x1
    800009fe:	167d                	addi	a2,a2,-1
    80000a00:	962e                	add	a2,a2,a1
    80000a02:	4685                	li	a3,1
    80000a04:	8231                	srli	a2,a2,0xc
    80000a06:	4581                	li	a1,0
    80000a08:	00000097          	auipc	ra,0x0
    80000a0c:	d0a080e7          	jalr	-758(ra) # 80000712 <uvmunmap>
    80000a10:	bfe1                	j	800009e8 <uvmfree+0xe>

0000000080000a12 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a12:	c679                	beqz	a2,80000ae0 <uvmcopy+0xce>
{
    80000a14:	715d                	addi	sp,sp,-80
    80000a16:	e486                	sd	ra,72(sp)
    80000a18:	e0a2                	sd	s0,64(sp)
    80000a1a:	fc26                	sd	s1,56(sp)
    80000a1c:	f84a                	sd	s2,48(sp)
    80000a1e:	f44e                	sd	s3,40(sp)
    80000a20:	f052                	sd	s4,32(sp)
    80000a22:	ec56                	sd	s5,24(sp)
    80000a24:	e85a                	sd	s6,16(sp)
    80000a26:	e45e                	sd	s7,8(sp)
    80000a28:	0880                	addi	s0,sp,80
    80000a2a:	8b2a                	mv	s6,a0
    80000a2c:	8aae                	mv	s5,a1
    80000a2e:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a30:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a32:	4601                	li	a2,0
    80000a34:	85ce                	mv	a1,s3
    80000a36:	855a                	mv	a0,s6
    80000a38:	00000097          	auipc	ra,0x0
    80000a3c:	a2c080e7          	jalr	-1492(ra) # 80000464 <walk>
    80000a40:	c531                	beqz	a0,80000a8c <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a42:	6118                	ld	a4,0(a0)
    80000a44:	00177793          	andi	a5,a4,1
    80000a48:	cbb1                	beqz	a5,80000a9c <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a4a:	00a75593          	srli	a1,a4,0xa
    80000a4e:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a52:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a56:	fffff097          	auipc	ra,0xfffff
    80000a5a:	6c2080e7          	jalr	1730(ra) # 80000118 <kalloc>
    80000a5e:	892a                	mv	s2,a0
    80000a60:	c939                	beqz	a0,80000ab6 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a62:	6605                	lui	a2,0x1
    80000a64:	85de                	mv	a1,s7
    80000a66:	fffff097          	auipc	ra,0xfffff
    80000a6a:	772080e7          	jalr	1906(ra) # 800001d8 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000a6e:	8726                	mv	a4,s1
    80000a70:	86ca                	mv	a3,s2
    80000a72:	6605                	lui	a2,0x1
    80000a74:	85ce                	mv	a1,s3
    80000a76:	8556                	mv	a0,s5
    80000a78:	00000097          	auipc	ra,0x0
    80000a7c:	ad4080e7          	jalr	-1324(ra) # 8000054c <mappages>
    80000a80:	e515                	bnez	a0,80000aac <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000a82:	6785                	lui	a5,0x1
    80000a84:	99be                	add	s3,s3,a5
    80000a86:	fb49e6e3          	bltu	s3,s4,80000a32 <uvmcopy+0x20>
    80000a8a:	a081                	j	80000aca <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000a8c:	00007517          	auipc	a0,0x7
    80000a90:	67c50513          	addi	a0,a0,1660 # 80008108 <etext+0x108>
    80000a94:	00005097          	auipc	ra,0x5
    80000a98:	3ee080e7          	jalr	1006(ra) # 80005e82 <panic>
      panic("uvmcopy: page not present");
    80000a9c:	00007517          	auipc	a0,0x7
    80000aa0:	68c50513          	addi	a0,a0,1676 # 80008128 <etext+0x128>
    80000aa4:	00005097          	auipc	ra,0x5
    80000aa8:	3de080e7          	jalr	990(ra) # 80005e82 <panic>
      kfree(mem);
    80000aac:	854a                	mv	a0,s2
    80000aae:	fffff097          	auipc	ra,0xfffff
    80000ab2:	56e080e7          	jalr	1390(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000ab6:	4685                	li	a3,1
    80000ab8:	00c9d613          	srli	a2,s3,0xc
    80000abc:	4581                	li	a1,0
    80000abe:	8556                	mv	a0,s5
    80000ac0:	00000097          	auipc	ra,0x0
    80000ac4:	c52080e7          	jalr	-942(ra) # 80000712 <uvmunmap>
  return -1;
    80000ac8:	557d                	li	a0,-1
}
    80000aca:	60a6                	ld	ra,72(sp)
    80000acc:	6406                	ld	s0,64(sp)
    80000ace:	74e2                	ld	s1,56(sp)
    80000ad0:	7942                	ld	s2,48(sp)
    80000ad2:	79a2                	ld	s3,40(sp)
    80000ad4:	7a02                	ld	s4,32(sp)
    80000ad6:	6ae2                	ld	s5,24(sp)
    80000ad8:	6b42                	ld	s6,16(sp)
    80000ada:	6ba2                	ld	s7,8(sp)
    80000adc:	6161                	addi	sp,sp,80
    80000ade:	8082                	ret
  return 0;
    80000ae0:	4501                	li	a0,0
}
    80000ae2:	8082                	ret

0000000080000ae4 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000ae4:	1141                	addi	sp,sp,-16
    80000ae6:	e406                	sd	ra,8(sp)
    80000ae8:	e022                	sd	s0,0(sp)
    80000aea:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000aec:	4601                	li	a2,0
    80000aee:	00000097          	auipc	ra,0x0
    80000af2:	976080e7          	jalr	-1674(ra) # 80000464 <walk>
  if(pte == 0)
    80000af6:	c901                	beqz	a0,80000b06 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000af8:	611c                	ld	a5,0(a0)
    80000afa:	9bbd                	andi	a5,a5,-17
    80000afc:	e11c                	sd	a5,0(a0)
}
    80000afe:	60a2                	ld	ra,8(sp)
    80000b00:	6402                	ld	s0,0(sp)
    80000b02:	0141                	addi	sp,sp,16
    80000b04:	8082                	ret
    panic("uvmclear");
    80000b06:	00007517          	auipc	a0,0x7
    80000b0a:	64250513          	addi	a0,a0,1602 # 80008148 <etext+0x148>
    80000b0e:	00005097          	auipc	ra,0x5
    80000b12:	374080e7          	jalr	884(ra) # 80005e82 <panic>

0000000080000b16 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b16:	c6bd                	beqz	a3,80000b84 <copyout+0x6e>
{
    80000b18:	715d                	addi	sp,sp,-80
    80000b1a:	e486                	sd	ra,72(sp)
    80000b1c:	e0a2                	sd	s0,64(sp)
    80000b1e:	fc26                	sd	s1,56(sp)
    80000b20:	f84a                	sd	s2,48(sp)
    80000b22:	f44e                	sd	s3,40(sp)
    80000b24:	f052                	sd	s4,32(sp)
    80000b26:	ec56                	sd	s5,24(sp)
    80000b28:	e85a                	sd	s6,16(sp)
    80000b2a:	e45e                	sd	s7,8(sp)
    80000b2c:	e062                	sd	s8,0(sp)
    80000b2e:	0880                	addi	s0,sp,80
    80000b30:	8b2a                	mv	s6,a0
    80000b32:	8c2e                	mv	s8,a1
    80000b34:	8a32                	mv	s4,a2
    80000b36:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b38:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b3a:	6a85                	lui	s5,0x1
    80000b3c:	a015                	j	80000b60 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b3e:	9562                	add	a0,a0,s8
    80000b40:	0004861b          	sext.w	a2,s1
    80000b44:	85d2                	mv	a1,s4
    80000b46:	41250533          	sub	a0,a0,s2
    80000b4a:	fffff097          	auipc	ra,0xfffff
    80000b4e:	68e080e7          	jalr	1678(ra) # 800001d8 <memmove>

    len -= n;
    80000b52:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b56:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b58:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b5c:	02098263          	beqz	s3,80000b80 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b60:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b64:	85ca                	mv	a1,s2
    80000b66:	855a                	mv	a0,s6
    80000b68:	00000097          	auipc	ra,0x0
    80000b6c:	9a2080e7          	jalr	-1630(ra) # 8000050a <walkaddr>
    if(pa0 == 0)
    80000b70:	cd01                	beqz	a0,80000b88 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000b72:	418904b3          	sub	s1,s2,s8
    80000b76:	94d6                	add	s1,s1,s5
    if(n > len)
    80000b78:	fc99f3e3          	bgeu	s3,s1,80000b3e <copyout+0x28>
    80000b7c:	84ce                	mv	s1,s3
    80000b7e:	b7c1                	j	80000b3e <copyout+0x28>
  }
  return 0;
    80000b80:	4501                	li	a0,0
    80000b82:	a021                	j	80000b8a <copyout+0x74>
    80000b84:	4501                	li	a0,0
}
    80000b86:	8082                	ret
      return -1;
    80000b88:	557d                	li	a0,-1
}
    80000b8a:	60a6                	ld	ra,72(sp)
    80000b8c:	6406                	ld	s0,64(sp)
    80000b8e:	74e2                	ld	s1,56(sp)
    80000b90:	7942                	ld	s2,48(sp)
    80000b92:	79a2                	ld	s3,40(sp)
    80000b94:	7a02                	ld	s4,32(sp)
    80000b96:	6ae2                	ld	s5,24(sp)
    80000b98:	6b42                	ld	s6,16(sp)
    80000b9a:	6ba2                	ld	s7,8(sp)
    80000b9c:	6c02                	ld	s8,0(sp)
    80000b9e:	6161                	addi	sp,sp,80
    80000ba0:	8082                	ret

0000000080000ba2 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000ba2:	c6bd                	beqz	a3,80000c10 <copyin+0x6e>
{
    80000ba4:	715d                	addi	sp,sp,-80
    80000ba6:	e486                	sd	ra,72(sp)
    80000ba8:	e0a2                	sd	s0,64(sp)
    80000baa:	fc26                	sd	s1,56(sp)
    80000bac:	f84a                	sd	s2,48(sp)
    80000bae:	f44e                	sd	s3,40(sp)
    80000bb0:	f052                	sd	s4,32(sp)
    80000bb2:	ec56                	sd	s5,24(sp)
    80000bb4:	e85a                	sd	s6,16(sp)
    80000bb6:	e45e                	sd	s7,8(sp)
    80000bb8:	e062                	sd	s8,0(sp)
    80000bba:	0880                	addi	s0,sp,80
    80000bbc:	8b2a                	mv	s6,a0
    80000bbe:	8a2e                	mv	s4,a1
    80000bc0:	8c32                	mv	s8,a2
    80000bc2:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000bc4:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000bc6:	6a85                	lui	s5,0x1
    80000bc8:	a015                	j	80000bec <copyin+0x4a>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000bca:	9562                	add	a0,a0,s8
    80000bcc:	0004861b          	sext.w	a2,s1
    80000bd0:	412505b3          	sub	a1,a0,s2
    80000bd4:	8552                	mv	a0,s4
    80000bd6:	fffff097          	auipc	ra,0xfffff
    80000bda:	602080e7          	jalr	1538(ra) # 800001d8 <memmove>

    len -= n;
    80000bde:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000be2:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000be4:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000be8:	02098263          	beqz	s3,80000c0c <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    80000bec:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000bf0:	85ca                	mv	a1,s2
    80000bf2:	855a                	mv	a0,s6
    80000bf4:	00000097          	auipc	ra,0x0
    80000bf8:	916080e7          	jalr	-1770(ra) # 8000050a <walkaddr>
    if(pa0 == 0)
    80000bfc:	cd01                	beqz	a0,80000c14 <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    80000bfe:	418904b3          	sub	s1,s2,s8
    80000c02:	94d6                	add	s1,s1,s5
    if(n > len)
    80000c04:	fc99f3e3          	bgeu	s3,s1,80000bca <copyin+0x28>
    80000c08:	84ce                	mv	s1,s3
    80000c0a:	b7c1                	j	80000bca <copyin+0x28>
  }
  return 0;
    80000c0c:	4501                	li	a0,0
    80000c0e:	a021                	j	80000c16 <copyin+0x74>
    80000c10:	4501                	li	a0,0
}
    80000c12:	8082                	ret
      return -1;
    80000c14:	557d                	li	a0,-1
}
    80000c16:	60a6                	ld	ra,72(sp)
    80000c18:	6406                	ld	s0,64(sp)
    80000c1a:	74e2                	ld	s1,56(sp)
    80000c1c:	7942                	ld	s2,48(sp)
    80000c1e:	79a2                	ld	s3,40(sp)
    80000c20:	7a02                	ld	s4,32(sp)
    80000c22:	6ae2                	ld	s5,24(sp)
    80000c24:	6b42                	ld	s6,16(sp)
    80000c26:	6ba2                	ld	s7,8(sp)
    80000c28:	6c02                	ld	s8,0(sp)
    80000c2a:	6161                	addi	sp,sp,80
    80000c2c:	8082                	ret

0000000080000c2e <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c2e:	c6c5                	beqz	a3,80000cd6 <copyinstr+0xa8>
{
    80000c30:	715d                	addi	sp,sp,-80
    80000c32:	e486                	sd	ra,72(sp)
    80000c34:	e0a2                	sd	s0,64(sp)
    80000c36:	fc26                	sd	s1,56(sp)
    80000c38:	f84a                	sd	s2,48(sp)
    80000c3a:	f44e                	sd	s3,40(sp)
    80000c3c:	f052                	sd	s4,32(sp)
    80000c3e:	ec56                	sd	s5,24(sp)
    80000c40:	e85a                	sd	s6,16(sp)
    80000c42:	e45e                	sd	s7,8(sp)
    80000c44:	0880                	addi	s0,sp,80
    80000c46:	8a2a                	mv	s4,a0
    80000c48:	8b2e                	mv	s6,a1
    80000c4a:	8bb2                	mv	s7,a2
    80000c4c:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c4e:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c50:	6985                	lui	s3,0x1
    80000c52:	a035                	j	80000c7e <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c54:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c58:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c5a:	0017b793          	seqz	a5,a5
    80000c5e:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000c62:	60a6                	ld	ra,72(sp)
    80000c64:	6406                	ld	s0,64(sp)
    80000c66:	74e2                	ld	s1,56(sp)
    80000c68:	7942                	ld	s2,48(sp)
    80000c6a:	79a2                	ld	s3,40(sp)
    80000c6c:	7a02                	ld	s4,32(sp)
    80000c6e:	6ae2                	ld	s5,24(sp)
    80000c70:	6b42                	ld	s6,16(sp)
    80000c72:	6ba2                	ld	s7,8(sp)
    80000c74:	6161                	addi	sp,sp,80
    80000c76:	8082                	ret
    srcva = va0 + PGSIZE;
    80000c78:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000c7c:	c8a9                	beqz	s1,80000cce <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80000c7e:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000c82:	85ca                	mv	a1,s2
    80000c84:	8552                	mv	a0,s4
    80000c86:	00000097          	auipc	ra,0x0
    80000c8a:	884080e7          	jalr	-1916(ra) # 8000050a <walkaddr>
    if(pa0 == 0)
    80000c8e:	c131                	beqz	a0,80000cd2 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000c90:	41790833          	sub	a6,s2,s7
    80000c94:	984e                	add	a6,a6,s3
    if(n > max)
    80000c96:	0104f363          	bgeu	s1,a6,80000c9c <copyinstr+0x6e>
    80000c9a:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000c9c:	955e                	add	a0,a0,s7
    80000c9e:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000ca2:	fc080be3          	beqz	a6,80000c78 <copyinstr+0x4a>
    80000ca6:	985a                	add	a6,a6,s6
    80000ca8:	87da                	mv	a5,s6
      if(*p == '\0'){
    80000caa:	41650633          	sub	a2,a0,s6
    80000cae:	14fd                	addi	s1,s1,-1
    80000cb0:	9b26                	add	s6,s6,s1
    80000cb2:	00f60733          	add	a4,a2,a5
    80000cb6:	00074703          	lbu	a4,0(a4)
    80000cba:	df49                	beqz	a4,80000c54 <copyinstr+0x26>
        *dst = *p;
    80000cbc:	00e78023          	sb	a4,0(a5)
      --max;
    80000cc0:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80000cc4:	0785                	addi	a5,a5,1
    while(n > 0){
    80000cc6:	ff0796e3          	bne	a5,a6,80000cb2 <copyinstr+0x84>
      dst++;
    80000cca:	8b42                	mv	s6,a6
    80000ccc:	b775                	j	80000c78 <copyinstr+0x4a>
    80000cce:	4781                	li	a5,0
    80000cd0:	b769                	j	80000c5a <copyinstr+0x2c>
      return -1;
    80000cd2:	557d                	li	a0,-1
    80000cd4:	b779                	j	80000c62 <copyinstr+0x34>
  int got_null = 0;
    80000cd6:	4781                	li	a5,0
  if(got_null){
    80000cd8:	0017b793          	seqz	a5,a5
    80000cdc:	40f00533          	neg	a0,a5
}
    80000ce0:	8082                	ret

0000000080000ce2 <vmprint>:
void vmprint(pagetable_t pgtbl, int level)
{
    80000ce2:	7159                	addi	sp,sp,-112
    80000ce4:	f486                	sd	ra,104(sp)
    80000ce6:	f0a2                	sd	s0,96(sp)
    80000ce8:	eca6                	sd	s1,88(sp)
    80000cea:	e8ca                	sd	s2,80(sp)
    80000cec:	e4ce                	sd	s3,72(sp)
    80000cee:	e0d2                	sd	s4,64(sp)
    80000cf0:	fc56                	sd	s5,56(sp)
    80000cf2:	f85a                	sd	s6,48(sp)
    80000cf4:	f45e                	sd	s7,40(sp)
    80000cf6:	f062                	sd	s8,32(sp)
    80000cf8:	ec66                	sd	s9,24(sp)
    80000cfa:	e86a                	sd	s10,16(sp)
    80000cfc:	e46e                	sd	s11,8(sp)
    80000cfe:	1880                	addi	s0,sp,112
    80000d00:	89ae                	mv	s3,a1
    // there are 2^9 = 512 PTEs in a page table.
    for (int i = 0; i < 512; i++) {
    80000d02:	8b2a                	mv	s6,a0
    80000d04:	4a01                	li	s4,0

        pte_t pte = pgtbl[i];
        if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    80000d06:	4c05                	li	s8,1
        else if (pte & PTE_V) {
            uint64 child = PTE2PA(pte);
            for (int j = 0; j < level; j++) {
                printf("..");
            }
            printf("%d: pte %p pa %p\n", i, pte, child);
    80000d08:	00007c97          	auipc	s9,0x7
    80000d0c:	458c8c93          	addi	s9,s9,1112 # 80008160 <etext+0x160>
                printf("..");
    80000d10:	00007a97          	auipc	s5,0x7
    80000d14:	448a8a93          	addi	s5,s5,1096 # 80008158 <etext+0x158>
            vmprint((pagetable_t)child, level + 1);
    80000d18:	00158d1b          	addiw	s10,a1,1
    for (int i = 0; i < 512; i++) {
    80000d1c:	20000b93          	li	s7,512
    80000d20:	a891                	j	80000d74 <vmprint+0x92>
            uint64 child = PTE2PA(pte);
    80000d22:	00a95d93          	srli	s11,s2,0xa
    80000d26:	0db2                	slli	s11,s11,0xc
            for (int j = 0; j < level; j++) {
    80000d28:	01305b63          	blez	s3,80000d3e <vmprint+0x5c>
    80000d2c:	4481                	li	s1,0
                printf("..");
    80000d2e:	8556                	mv	a0,s5
    80000d30:	00005097          	auipc	ra,0x5
    80000d34:	19c080e7          	jalr	412(ra) # 80005ecc <printf>
            for (int j = 0; j < level; j++) {
    80000d38:	2485                	addiw	s1,s1,1
    80000d3a:	fe999ae3          	bne	s3,s1,80000d2e <vmprint+0x4c>
            printf("%d: pte %p pa %p\n", i, pte, child);
    80000d3e:	86ee                	mv	a3,s11
    80000d40:	864a                	mv	a2,s2
    80000d42:	85d2                	mv	a1,s4
    80000d44:	8566                	mv	a0,s9
    80000d46:	00005097          	auipc	ra,0x5
    80000d4a:	186080e7          	jalr	390(ra) # 80005ecc <printf>
            vmprint((pagetable_t)child, level + 1);
    80000d4e:	85ea                	mv	a1,s10
    80000d50:	856e                	mv	a0,s11
    80000d52:	00000097          	auipc	ra,0x0
    80000d56:	f90080e7          	jalr	-112(ra) # 80000ce2 <vmprint>
    80000d5a:	a809                	j	80000d6c <vmprint+0x8a>
            printf("%d: pte %p pa %p\n", i, pte, child);
    80000d5c:	86ee                	mv	a3,s11
    80000d5e:	864a                	mv	a2,s2
    80000d60:	85d2                	mv	a1,s4
    80000d62:	8566                	mv	a0,s9
    80000d64:	00005097          	auipc	ra,0x5
    80000d68:	168080e7          	jalr	360(ra) # 80005ecc <printf>
    for (int i = 0; i < 512; i++) {
    80000d6c:	2a05                	addiw	s4,s4,1
    80000d6e:	0b21                	addi	s6,s6,8
    80000d70:	037a0a63          	beq	s4,s7,80000da4 <vmprint+0xc2>
        pte_t pte = pgtbl[i];
    80000d74:	000b3903          	ld	s2,0(s6) # 1000 <_entry-0x7ffff000>
        if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    80000d78:	00f97793          	andi	a5,s2,15
    80000d7c:	fb8783e3          	beq	a5,s8,80000d22 <vmprint+0x40>
        else if (pte & PTE_V) {
    80000d80:	00197793          	andi	a5,s2,1
    80000d84:	d7e5                	beqz	a5,80000d6c <vmprint+0x8a>
            uint64 child = PTE2PA(pte);
    80000d86:	00a95d93          	srli	s11,s2,0xa
    80000d8a:	0db2                	slli	s11,s11,0xc
            for (int j = 0; j < level; j++) {
    80000d8c:	fd3058e3          	blez	s3,80000d5c <vmprint+0x7a>
    80000d90:	4481                	li	s1,0
                printf("..");
    80000d92:	8556                	mv	a0,s5
    80000d94:	00005097          	auipc	ra,0x5
    80000d98:	138080e7          	jalr	312(ra) # 80005ecc <printf>
            for (int j = 0; j < level; j++) {
    80000d9c:	2485                	addiw	s1,s1,1
    80000d9e:	fe999ae3          	bne	s3,s1,80000d92 <vmprint+0xb0>
    80000da2:	bf6d                	j	80000d5c <vmprint+0x7a>
        }
    }
    80000da4:	70a6                	ld	ra,104(sp)
    80000da6:	7406                	ld	s0,96(sp)
    80000da8:	64e6                	ld	s1,88(sp)
    80000daa:	6946                	ld	s2,80(sp)
    80000dac:	69a6                	ld	s3,72(sp)
    80000dae:	6a06                	ld	s4,64(sp)
    80000db0:	7ae2                	ld	s5,56(sp)
    80000db2:	7b42                	ld	s6,48(sp)
    80000db4:	7ba2                	ld	s7,40(sp)
    80000db6:	7c02                	ld	s8,32(sp)
    80000db8:	6ce2                	ld	s9,24(sp)
    80000dba:	6d42                	ld	s10,16(sp)
    80000dbc:	6da2                	ld	s11,8(sp)
    80000dbe:	6165                	addi	sp,sp,112
    80000dc0:	8082                	ret

0000000080000dc2 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000dc2:	7139                	addi	sp,sp,-64
    80000dc4:	fc06                	sd	ra,56(sp)
    80000dc6:	f822                	sd	s0,48(sp)
    80000dc8:	f426                	sd	s1,40(sp)
    80000dca:	f04a                	sd	s2,32(sp)
    80000dcc:	ec4e                	sd	s3,24(sp)
    80000dce:	e852                	sd	s4,16(sp)
    80000dd0:	e456                	sd	s5,8(sp)
    80000dd2:	e05a                	sd	s6,0(sp)
    80000dd4:	0080                	addi	s0,sp,64
    80000dd6:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dd8:	00008497          	auipc	s1,0x8
    80000ddc:	fc848493          	addi	s1,s1,-56 # 80008da0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000de0:	8b26                	mv	s6,s1
    80000de2:	00007a97          	auipc	s5,0x7
    80000de6:	21ea8a93          	addi	s5,s5,542 # 80008000 <etext>
    80000dea:	01000937          	lui	s2,0x1000
    80000dee:	197d                	addi	s2,s2,-1
    80000df0:	093a                	slli	s2,s2,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000df2:	0000ea17          	auipc	s4,0xe
    80000df6:	baea0a13          	addi	s4,s4,-1106 # 8000e9a0 <tickslock>
    char *pa = kalloc();
    80000dfa:	fffff097          	auipc	ra,0xfffff
    80000dfe:	31e080e7          	jalr	798(ra) # 80000118 <kalloc>
    80000e02:	862a                	mv	a2,a0
    if(pa == 0)
    80000e04:	c129                	beqz	a0,80000e46 <proc_mapstacks+0x84>
    uint64 va = KSTACK((int) (p - proc));
    80000e06:	416485b3          	sub	a1,s1,s6
    80000e0a:	8591                	srai	a1,a1,0x4
    80000e0c:	000ab783          	ld	a5,0(s5)
    80000e10:	02f585b3          	mul	a1,a1,a5
    80000e14:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000e18:	4719                	li	a4,6
    80000e1a:	6685                	lui	a3,0x1
    80000e1c:	40b905b3          	sub	a1,s2,a1
    80000e20:	854e                	mv	a0,s3
    80000e22:	fffff097          	auipc	ra,0xfffff
    80000e26:	7ca080e7          	jalr	1994(ra) # 800005ec <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e2a:	17048493          	addi	s1,s1,368
    80000e2e:	fd4496e3          	bne	s1,s4,80000dfa <proc_mapstacks+0x38>
  }
}
    80000e32:	70e2                	ld	ra,56(sp)
    80000e34:	7442                	ld	s0,48(sp)
    80000e36:	74a2                	ld	s1,40(sp)
    80000e38:	7902                	ld	s2,32(sp)
    80000e3a:	69e2                	ld	s3,24(sp)
    80000e3c:	6a42                	ld	s4,16(sp)
    80000e3e:	6aa2                	ld	s5,8(sp)
    80000e40:	6b02                	ld	s6,0(sp)
    80000e42:	6121                	addi	sp,sp,64
    80000e44:	8082                	ret
      panic("kalloc");
    80000e46:	00007517          	auipc	a0,0x7
    80000e4a:	33250513          	addi	a0,a0,818 # 80008178 <etext+0x178>
    80000e4e:	00005097          	auipc	ra,0x5
    80000e52:	034080e7          	jalr	52(ra) # 80005e82 <panic>

0000000080000e56 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000e56:	7139                	addi	sp,sp,-64
    80000e58:	fc06                	sd	ra,56(sp)
    80000e5a:	f822                	sd	s0,48(sp)
    80000e5c:	f426                	sd	s1,40(sp)
    80000e5e:	f04a                	sd	s2,32(sp)
    80000e60:	ec4e                	sd	s3,24(sp)
    80000e62:	e852                	sd	s4,16(sp)
    80000e64:	e456                	sd	s5,8(sp)
    80000e66:	e05a                	sd	s6,0(sp)
    80000e68:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000e6a:	00007597          	auipc	a1,0x7
    80000e6e:	31658593          	addi	a1,a1,790 # 80008180 <etext+0x180>
    80000e72:	00008517          	auipc	a0,0x8
    80000e76:	afe50513          	addi	a0,a0,-1282 # 80008970 <pid_lock>
    80000e7a:	00005097          	auipc	ra,0x5
    80000e7e:	4c2080e7          	jalr	1218(ra) # 8000633c <initlock>
  initlock(&wait_lock, "wait_lock");
    80000e82:	00007597          	auipc	a1,0x7
    80000e86:	30658593          	addi	a1,a1,774 # 80008188 <etext+0x188>
    80000e8a:	00008517          	auipc	a0,0x8
    80000e8e:	afe50513          	addi	a0,a0,-1282 # 80008988 <wait_lock>
    80000e92:	00005097          	auipc	ra,0x5
    80000e96:	4aa080e7          	jalr	1194(ra) # 8000633c <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e9a:	00008497          	auipc	s1,0x8
    80000e9e:	f0648493          	addi	s1,s1,-250 # 80008da0 <proc>
      initlock(&p->lock, "proc");
    80000ea2:	00007b17          	auipc	s6,0x7
    80000ea6:	2f6b0b13          	addi	s6,s6,758 # 80008198 <etext+0x198>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000eaa:	8aa6                	mv	s5,s1
    80000eac:	00007a17          	auipc	s4,0x7
    80000eb0:	154a0a13          	addi	s4,s4,340 # 80008000 <etext>
    80000eb4:	01000937          	lui	s2,0x1000
    80000eb8:	197d                	addi	s2,s2,-1
    80000eba:	093a                	slli	s2,s2,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ebc:	0000e997          	auipc	s3,0xe
    80000ec0:	ae498993          	addi	s3,s3,-1308 # 8000e9a0 <tickslock>
      initlock(&p->lock, "proc");
    80000ec4:	85da                	mv	a1,s6
    80000ec6:	8526                	mv	a0,s1
    80000ec8:	00005097          	auipc	ra,0x5
    80000ecc:	474080e7          	jalr	1140(ra) # 8000633c <initlock>
      p->state = UNUSED;
    80000ed0:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000ed4:	415487b3          	sub	a5,s1,s5
    80000ed8:	8791                	srai	a5,a5,0x4
    80000eda:	000a3703          	ld	a4,0(s4)
    80000ede:	02e787b3          	mul	a5,a5,a4
    80000ee2:	00d7979b          	slliw	a5,a5,0xd
    80000ee6:	40f907b3          	sub	a5,s2,a5
    80000eea:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000eec:	17048493          	addi	s1,s1,368
    80000ef0:	fd349ae3          	bne	s1,s3,80000ec4 <procinit+0x6e>
  }
}
    80000ef4:	70e2                	ld	ra,56(sp)
    80000ef6:	7442                	ld	s0,48(sp)
    80000ef8:	74a2                	ld	s1,40(sp)
    80000efa:	7902                	ld	s2,32(sp)
    80000efc:	69e2                	ld	s3,24(sp)
    80000efe:	6a42                	ld	s4,16(sp)
    80000f00:	6aa2                	ld	s5,8(sp)
    80000f02:	6b02                	ld	s6,0(sp)
    80000f04:	6121                	addi	sp,sp,64
    80000f06:	8082                	ret

0000000080000f08 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000f08:	1141                	addi	sp,sp,-16
    80000f0a:	e422                	sd	s0,8(sp)
    80000f0c:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000f0e:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000f10:	2501                	sext.w	a0,a0
    80000f12:	6422                	ld	s0,8(sp)
    80000f14:	0141                	addi	sp,sp,16
    80000f16:	8082                	ret

0000000080000f18 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000f18:	1141                	addi	sp,sp,-16
    80000f1a:	e422                	sd	s0,8(sp)
    80000f1c:	0800                	addi	s0,sp,16
    80000f1e:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000f20:	2781                	sext.w	a5,a5
    80000f22:	079e                	slli	a5,a5,0x7
  return c;
}
    80000f24:	00008517          	auipc	a0,0x8
    80000f28:	a7c50513          	addi	a0,a0,-1412 # 800089a0 <cpus>
    80000f2c:	953e                	add	a0,a0,a5
    80000f2e:	6422                	ld	s0,8(sp)
    80000f30:	0141                	addi	sp,sp,16
    80000f32:	8082                	ret

0000000080000f34 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000f34:	1101                	addi	sp,sp,-32
    80000f36:	ec06                	sd	ra,24(sp)
    80000f38:	e822                	sd	s0,16(sp)
    80000f3a:	e426                	sd	s1,8(sp)
    80000f3c:	1000                	addi	s0,sp,32
  push_off();
    80000f3e:	00005097          	auipc	ra,0x5
    80000f42:	442080e7          	jalr	1090(ra) # 80006380 <push_off>
    80000f46:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000f48:	2781                	sext.w	a5,a5
    80000f4a:	079e                	slli	a5,a5,0x7
    80000f4c:	00008717          	auipc	a4,0x8
    80000f50:	a2470713          	addi	a4,a4,-1500 # 80008970 <pid_lock>
    80000f54:	97ba                	add	a5,a5,a4
    80000f56:	7b84                	ld	s1,48(a5)
  pop_off();
    80000f58:	00005097          	auipc	ra,0x5
    80000f5c:	4c8080e7          	jalr	1224(ra) # 80006420 <pop_off>
  return p;
}
    80000f60:	8526                	mv	a0,s1
    80000f62:	60e2                	ld	ra,24(sp)
    80000f64:	6442                	ld	s0,16(sp)
    80000f66:	64a2                	ld	s1,8(sp)
    80000f68:	6105                	addi	sp,sp,32
    80000f6a:	8082                	ret

0000000080000f6c <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000f6c:	1141                	addi	sp,sp,-16
    80000f6e:	e406                	sd	ra,8(sp)
    80000f70:	e022                	sd	s0,0(sp)
    80000f72:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000f74:	00000097          	auipc	ra,0x0
    80000f78:	fc0080e7          	jalr	-64(ra) # 80000f34 <myproc>
    80000f7c:	00005097          	auipc	ra,0x5
    80000f80:	504080e7          	jalr	1284(ra) # 80006480 <release>

  if (first) {
    80000f84:	00008797          	auipc	a5,0x8
    80000f88:	92c7a783          	lw	a5,-1748(a5) # 800088b0 <first.1684>
    80000f8c:	eb89                	bnez	a5,80000f9e <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000f8e:	00001097          	auipc	ra,0x1
    80000f92:	d12080e7          	jalr	-750(ra) # 80001ca0 <usertrapret>
}
    80000f96:	60a2                	ld	ra,8(sp)
    80000f98:	6402                	ld	s0,0(sp)
    80000f9a:	0141                	addi	sp,sp,16
    80000f9c:	8082                	ret
    first = 0;
    80000f9e:	00008797          	auipc	a5,0x8
    80000fa2:	9007a923          	sw	zero,-1774(a5) # 800088b0 <first.1684>
    fsinit(ROOTDEV);
    80000fa6:	4505                	li	a0,1
    80000fa8:	00002097          	auipc	ra,0x2
    80000fac:	b34080e7          	jalr	-1228(ra) # 80002adc <fsinit>
    80000fb0:	bff9                	j	80000f8e <forkret+0x22>

0000000080000fb2 <allocpid>:
{
    80000fb2:	1101                	addi	sp,sp,-32
    80000fb4:	ec06                	sd	ra,24(sp)
    80000fb6:	e822                	sd	s0,16(sp)
    80000fb8:	e426                	sd	s1,8(sp)
    80000fba:	e04a                	sd	s2,0(sp)
    80000fbc:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000fbe:	00008917          	auipc	s2,0x8
    80000fc2:	9b290913          	addi	s2,s2,-1614 # 80008970 <pid_lock>
    80000fc6:	854a                	mv	a0,s2
    80000fc8:	00005097          	auipc	ra,0x5
    80000fcc:	404080e7          	jalr	1028(ra) # 800063cc <acquire>
  pid = nextpid;
    80000fd0:	00008797          	auipc	a5,0x8
    80000fd4:	8e478793          	addi	a5,a5,-1820 # 800088b4 <nextpid>
    80000fd8:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000fda:	0014871b          	addiw	a4,s1,1
    80000fde:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000fe0:	854a                	mv	a0,s2
    80000fe2:	00005097          	auipc	ra,0x5
    80000fe6:	49e080e7          	jalr	1182(ra) # 80006480 <release>
}
    80000fea:	8526                	mv	a0,s1
    80000fec:	60e2                	ld	ra,24(sp)
    80000fee:	6442                	ld	s0,16(sp)
    80000ff0:	64a2                	ld	s1,8(sp)
    80000ff2:	6902                	ld	s2,0(sp)
    80000ff4:	6105                	addi	sp,sp,32
    80000ff6:	8082                	ret

0000000080000ff8 <proc_pagetable>:
{
    80000ff8:	1101                	addi	sp,sp,-32
    80000ffa:	ec06                	sd	ra,24(sp)
    80000ffc:	e822                	sd	s0,16(sp)
    80000ffe:	e426                	sd	s1,8(sp)
    80001000:	e04a                	sd	s2,0(sp)
    80001002:	1000                	addi	s0,sp,32
    80001004:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001006:	fffff097          	auipc	ra,0xfffff
    8000100a:	7d0080e7          	jalr	2000(ra) # 800007d6 <uvmcreate>
    8000100e:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001010:	cd39                	beqz	a0,8000106e <proc_pagetable+0x76>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001012:	4729                	li	a4,10
    80001014:	00006697          	auipc	a3,0x6
    80001018:	fec68693          	addi	a3,a3,-20 # 80007000 <_trampoline>
    8000101c:	6605                	lui	a2,0x1
    8000101e:	040005b7          	lui	a1,0x4000
    80001022:	15fd                	addi	a1,a1,-1
    80001024:	05b2                	slli	a1,a1,0xc
    80001026:	fffff097          	auipc	ra,0xfffff
    8000102a:	526080e7          	jalr	1318(ra) # 8000054c <mappages>
    8000102e:	04054763          	bltz	a0,8000107c <proc_pagetable+0x84>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001032:	4719                	li	a4,6
    80001034:	05893683          	ld	a3,88(s2)
    80001038:	6605                	lui	a2,0x1
    8000103a:	020005b7          	lui	a1,0x2000
    8000103e:	15fd                	addi	a1,a1,-1
    80001040:	05b6                	slli	a1,a1,0xd
    80001042:	8526                	mv	a0,s1
    80001044:	fffff097          	auipc	ra,0xfffff
    80001048:	508080e7          	jalr	1288(ra) # 8000054c <mappages>
    8000104c:	04054063          	bltz	a0,8000108c <proc_pagetable+0x94>
  if (mappages(pagetable, USYSCALL, PGSIZE, (uint64)(p->usys), PTE_R | PTE_U) < 0) {
    80001050:	4749                	li	a4,18
    80001052:	16893683          	ld	a3,360(s2)
    80001056:	6605                	lui	a2,0x1
    80001058:	040005b7          	lui	a1,0x4000
    8000105c:	15f5                	addi	a1,a1,-3
    8000105e:	05b2                	slli	a1,a1,0xc
    80001060:	8526                	mv	a0,s1
    80001062:	fffff097          	auipc	ra,0xfffff
    80001066:	4ea080e7          	jalr	1258(ra) # 8000054c <mappages>
    8000106a:	04054463          	bltz	a0,800010b2 <proc_pagetable+0xba>
}
    8000106e:	8526                	mv	a0,s1
    80001070:	60e2                	ld	ra,24(sp)
    80001072:	6442                	ld	s0,16(sp)
    80001074:	64a2                	ld	s1,8(sp)
    80001076:	6902                	ld	s2,0(sp)
    80001078:	6105                	addi	sp,sp,32
    8000107a:	8082                	ret
    uvmfree(pagetable, 0);
    8000107c:	4581                	li	a1,0
    8000107e:	8526                	mv	a0,s1
    80001080:	00000097          	auipc	ra,0x0
    80001084:	95a080e7          	jalr	-1702(ra) # 800009da <uvmfree>
    return 0;
    80001088:	4481                	li	s1,0
    8000108a:	b7d5                	j	8000106e <proc_pagetable+0x76>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000108c:	4681                	li	a3,0
    8000108e:	4605                	li	a2,1
    80001090:	040005b7          	lui	a1,0x4000
    80001094:	15fd                	addi	a1,a1,-1
    80001096:	05b2                	slli	a1,a1,0xc
    80001098:	8526                	mv	a0,s1
    8000109a:	fffff097          	auipc	ra,0xfffff
    8000109e:	678080e7          	jalr	1656(ra) # 80000712 <uvmunmap>
    uvmfree(pagetable, 0);
    800010a2:	4581                	li	a1,0
    800010a4:	8526                	mv	a0,s1
    800010a6:	00000097          	auipc	ra,0x0
    800010aa:	934080e7          	jalr	-1740(ra) # 800009da <uvmfree>
    return 0;
    800010ae:	4481                	li	s1,0
    800010b0:	bf7d                	j	8000106e <proc_pagetable+0x76>
        uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800010b2:	4681                	li	a3,0
    800010b4:	4605                	li	a2,1
    800010b6:	040005b7          	lui	a1,0x4000
    800010ba:	15fd                	addi	a1,a1,-1
    800010bc:	05b2                	slli	a1,a1,0xc
    800010be:	8526                	mv	a0,s1
    800010c0:	fffff097          	auipc	ra,0xfffff
    800010c4:	652080e7          	jalr	1618(ra) # 80000712 <uvmunmap>
        uvmunmap(pagetable, TRAPFRAME, 1, 0);
    800010c8:	4681                	li	a3,0
    800010ca:	4605                	li	a2,1
    800010cc:	020005b7          	lui	a1,0x2000
    800010d0:	15fd                	addi	a1,a1,-1
    800010d2:	05b6                	slli	a1,a1,0xd
    800010d4:	8526                	mv	a0,s1
    800010d6:	fffff097          	auipc	ra,0xfffff
    800010da:	63c080e7          	jalr	1596(ra) # 80000712 <uvmunmap>
        uvmfree(pagetable, 0);
    800010de:	4581                	li	a1,0
    800010e0:	8526                	mv	a0,s1
    800010e2:	00000097          	auipc	ra,0x0
    800010e6:	8f8080e7          	jalr	-1800(ra) # 800009da <uvmfree>
        return 0;
    800010ea:	4481                	li	s1,0
    800010ec:	b749                	j	8000106e <proc_pagetable+0x76>

00000000800010ee <proc_freepagetable>:
{
    800010ee:	7179                	addi	sp,sp,-48
    800010f0:	f406                	sd	ra,40(sp)
    800010f2:	f022                	sd	s0,32(sp)
    800010f4:	ec26                	sd	s1,24(sp)
    800010f6:	e84a                	sd	s2,16(sp)
    800010f8:	e44e                	sd	s3,8(sp)
    800010fa:	1800                	addi	s0,sp,48
    800010fc:	84aa                	mv	s1,a0
    800010fe:	89ae                	mv	s3,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001100:	4681                	li	a3,0
    80001102:	4605                	li	a2,1
    80001104:	04000937          	lui	s2,0x4000
    80001108:	fff90593          	addi	a1,s2,-1 # 3ffffff <_entry-0x7c000001>
    8000110c:	05b2                	slli	a1,a1,0xc
    8000110e:	fffff097          	auipc	ra,0xfffff
    80001112:	604080e7          	jalr	1540(ra) # 80000712 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001116:	4681                	li	a3,0
    80001118:	4605                	li	a2,1
    8000111a:	020005b7          	lui	a1,0x2000
    8000111e:	15fd                	addi	a1,a1,-1
    80001120:	05b6                	slli	a1,a1,0xd
    80001122:	8526                	mv	a0,s1
    80001124:	fffff097          	auipc	ra,0xfffff
    80001128:	5ee080e7          	jalr	1518(ra) # 80000712 <uvmunmap>
  uvmunmap(pagetable, USYSCALL, 1, 0);
    8000112c:	4681                	li	a3,0
    8000112e:	4605                	li	a2,1
    80001130:	1975                	addi	s2,s2,-3
    80001132:	00c91593          	slli	a1,s2,0xc
    80001136:	8526                	mv	a0,s1
    80001138:	fffff097          	auipc	ra,0xfffff
    8000113c:	5da080e7          	jalr	1498(ra) # 80000712 <uvmunmap>
  uvmfree(pagetable, sz);
    80001140:	85ce                	mv	a1,s3
    80001142:	8526                	mv	a0,s1
    80001144:	00000097          	auipc	ra,0x0
    80001148:	896080e7          	jalr	-1898(ra) # 800009da <uvmfree>
}
    8000114c:	70a2                	ld	ra,40(sp)
    8000114e:	7402                	ld	s0,32(sp)
    80001150:	64e2                	ld	s1,24(sp)
    80001152:	6942                	ld	s2,16(sp)
    80001154:	69a2                	ld	s3,8(sp)
    80001156:	6145                	addi	sp,sp,48
    80001158:	8082                	ret

000000008000115a <freeproc>:
{
    8000115a:	1101                	addi	sp,sp,-32
    8000115c:	ec06                	sd	ra,24(sp)
    8000115e:	e822                	sd	s0,16(sp)
    80001160:	e426                	sd	s1,8(sp)
    80001162:	1000                	addi	s0,sp,32
    80001164:	84aa                	mv	s1,a0
  if (p->usys) {
    80001166:	16853503          	ld	a0,360(a0)
    8000116a:	c509                	beqz	a0,80001174 <freeproc+0x1a>
        kfree((void *)p->usys);
    8000116c:	fffff097          	auipc	ra,0xfffff
    80001170:	eb0080e7          	jalr	-336(ra) # 8000001c <kfree>
  p->usys = 0;
    80001174:	1604b423          	sd	zero,360(s1)
  if(p->trapframe)
    80001178:	6ca8                	ld	a0,88(s1)
    8000117a:	c509                	beqz	a0,80001184 <freeproc+0x2a>
    kfree((void*)p->trapframe);
    8000117c:	fffff097          	auipc	ra,0xfffff
    80001180:	ea0080e7          	jalr	-352(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001184:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001188:	68a8                	ld	a0,80(s1)
    8000118a:	c511                	beqz	a0,80001196 <freeproc+0x3c>
    proc_freepagetable(p->pagetable, p->sz);
    8000118c:	64ac                	ld	a1,72(s1)
    8000118e:	00000097          	auipc	ra,0x0
    80001192:	f60080e7          	jalr	-160(ra) # 800010ee <proc_freepagetable>
  p->pagetable = 0;
    80001196:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    8000119a:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    8000119e:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    800011a2:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    800011a6:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    800011aa:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    800011ae:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    800011b2:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    800011b6:	0004ac23          	sw	zero,24(s1)
}
    800011ba:	60e2                	ld	ra,24(sp)
    800011bc:	6442                	ld	s0,16(sp)
    800011be:	64a2                	ld	s1,8(sp)
    800011c0:	6105                	addi	sp,sp,32
    800011c2:	8082                	ret

00000000800011c4 <allocproc>:
{
    800011c4:	1101                	addi	sp,sp,-32
    800011c6:	ec06                	sd	ra,24(sp)
    800011c8:	e822                	sd	s0,16(sp)
    800011ca:	e426                	sd	s1,8(sp)
    800011cc:	e04a                	sd	s2,0(sp)
    800011ce:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800011d0:	00008497          	auipc	s1,0x8
    800011d4:	bd048493          	addi	s1,s1,-1072 # 80008da0 <proc>
    800011d8:	0000d917          	auipc	s2,0xd
    800011dc:	7c890913          	addi	s2,s2,1992 # 8000e9a0 <tickslock>
    acquire(&p->lock);
    800011e0:	8526                	mv	a0,s1
    800011e2:	00005097          	auipc	ra,0x5
    800011e6:	1ea080e7          	jalr	490(ra) # 800063cc <acquire>
    if(p->state == UNUSED) {
    800011ea:	4c9c                	lw	a5,24(s1)
    800011ec:	cf81                	beqz	a5,80001204 <allocproc+0x40>
      release(&p->lock);
    800011ee:	8526                	mv	a0,s1
    800011f0:	00005097          	auipc	ra,0x5
    800011f4:	290080e7          	jalr	656(ra) # 80006480 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800011f8:	17048493          	addi	s1,s1,368
    800011fc:	ff2492e3          	bne	s1,s2,800011e0 <allocproc+0x1c>
  return 0;
    80001200:	4481                	li	s1,0
    80001202:	a885                	j	80001272 <allocproc+0xae>
  p->pid = allocpid();
    80001204:	00000097          	auipc	ra,0x0
    80001208:	dae080e7          	jalr	-594(ra) # 80000fb2 <allocpid>
    8000120c:	d888                	sw	a0,48(s1)
  p->state = USED;
    8000120e:	4785                	li	a5,1
    80001210:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001212:	fffff097          	auipc	ra,0xfffff
    80001216:	f06080e7          	jalr	-250(ra) # 80000118 <kalloc>
    8000121a:	892a                	mv	s2,a0
    8000121c:	eca8                	sd	a0,88(s1)
    8000121e:	c12d                	beqz	a0,80001280 <allocproc+0xbc>
  if ((p->usys = (struct usyscall *)kalloc()) == 0) {
    80001220:	fffff097          	auipc	ra,0xfffff
    80001224:	ef8080e7          	jalr	-264(ra) # 80000118 <kalloc>
    80001228:	892a                	mv	s2,a0
    8000122a:	16a4b423          	sd	a0,360(s1)
    8000122e:	c52d                	beqz	a0,80001298 <allocproc+0xd4>
  memmove(p->usys, &p->pid, sizeof(int));// 将pid移动至共享页中
    80001230:	4611                	li	a2,4
    80001232:	03048593          	addi	a1,s1,48
    80001236:	fffff097          	auipc	ra,0xfffff
    8000123a:	fa2080e7          	jalr	-94(ra) # 800001d8 <memmove>
  p->pagetable = proc_pagetable(p);
    8000123e:	8526                	mv	a0,s1
    80001240:	00000097          	auipc	ra,0x0
    80001244:	db8080e7          	jalr	-584(ra) # 80000ff8 <proc_pagetable>
    80001248:	892a                	mv	s2,a0
    8000124a:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    8000124c:	c135                	beqz	a0,800012b0 <allocproc+0xec>
  memset(&p->context, 0, sizeof(p->context));
    8000124e:	07000613          	li	a2,112
    80001252:	4581                	li	a1,0
    80001254:	06048513          	addi	a0,s1,96
    80001258:	fffff097          	auipc	ra,0xfffff
    8000125c:	f20080e7          	jalr	-224(ra) # 80000178 <memset>
  p->context.ra = (uint64)forkret;
    80001260:	00000797          	auipc	a5,0x0
    80001264:	d0c78793          	addi	a5,a5,-756 # 80000f6c <forkret>
    80001268:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    8000126a:	60bc                	ld	a5,64(s1)
    8000126c:	6705                	lui	a4,0x1
    8000126e:	97ba                	add	a5,a5,a4
    80001270:	f4bc                	sd	a5,104(s1)
}
    80001272:	8526                	mv	a0,s1
    80001274:	60e2                	ld	ra,24(sp)
    80001276:	6442                	ld	s0,16(sp)
    80001278:	64a2                	ld	s1,8(sp)
    8000127a:	6902                	ld	s2,0(sp)
    8000127c:	6105                	addi	sp,sp,32
    8000127e:	8082                	ret
    freeproc(p);
    80001280:	8526                	mv	a0,s1
    80001282:	00000097          	auipc	ra,0x0
    80001286:	ed8080e7          	jalr	-296(ra) # 8000115a <freeproc>
    release(&p->lock);
    8000128a:	8526                	mv	a0,s1
    8000128c:	00005097          	auipc	ra,0x5
    80001290:	1f4080e7          	jalr	500(ra) # 80006480 <release>
    return 0;
    80001294:	84ca                	mv	s1,s2
    80001296:	bff1                	j	80001272 <allocproc+0xae>
        freeproc(p);
    80001298:	8526                	mv	a0,s1
    8000129a:	00000097          	auipc	ra,0x0
    8000129e:	ec0080e7          	jalr	-320(ra) # 8000115a <freeproc>
        release(&p->lock);
    800012a2:	8526                	mv	a0,s1
    800012a4:	00005097          	auipc	ra,0x5
    800012a8:	1dc080e7          	jalr	476(ra) # 80006480 <release>
        return 0;
    800012ac:	84ca                	mv	s1,s2
    800012ae:	b7d1                	j	80001272 <allocproc+0xae>
    freeproc(p);
    800012b0:	8526                	mv	a0,s1
    800012b2:	00000097          	auipc	ra,0x0
    800012b6:	ea8080e7          	jalr	-344(ra) # 8000115a <freeproc>
    release(&p->lock);
    800012ba:	8526                	mv	a0,s1
    800012bc:	00005097          	auipc	ra,0x5
    800012c0:	1c4080e7          	jalr	452(ra) # 80006480 <release>
    return 0;
    800012c4:	84ca                	mv	s1,s2
    800012c6:	b775                	j	80001272 <allocproc+0xae>

00000000800012c8 <userinit>:
{
    800012c8:	1101                	addi	sp,sp,-32
    800012ca:	ec06                	sd	ra,24(sp)
    800012cc:	e822                	sd	s0,16(sp)
    800012ce:	e426                	sd	s1,8(sp)
    800012d0:	1000                	addi	s0,sp,32
  p = allocproc();
    800012d2:	00000097          	auipc	ra,0x0
    800012d6:	ef2080e7          	jalr	-270(ra) # 800011c4 <allocproc>
    800012da:	84aa                	mv	s1,a0
  initproc = p;
    800012dc:	00007797          	auipc	a5,0x7
    800012e0:	64a7ba23          	sd	a0,1620(a5) # 80008930 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    800012e4:	03400613          	li	a2,52
    800012e8:	00007597          	auipc	a1,0x7
    800012ec:	5d858593          	addi	a1,a1,1496 # 800088c0 <initcode>
    800012f0:	6928                	ld	a0,80(a0)
    800012f2:	fffff097          	auipc	ra,0xfffff
    800012f6:	512080e7          	jalr	1298(ra) # 80000804 <uvmfirst>
  p->sz = PGSIZE;
    800012fa:	6785                	lui	a5,0x1
    800012fc:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    800012fe:	6cb8                	ld	a4,88(s1)
    80001300:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001304:	6cb8                	ld	a4,88(s1)
    80001306:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001308:	4641                	li	a2,16
    8000130a:	00007597          	auipc	a1,0x7
    8000130e:	e9658593          	addi	a1,a1,-362 # 800081a0 <etext+0x1a0>
    80001312:	15848513          	addi	a0,s1,344
    80001316:	fffff097          	auipc	ra,0xfffff
    8000131a:	fb4080e7          	jalr	-76(ra) # 800002ca <safestrcpy>
  p->cwd = namei("/");
    8000131e:	00007517          	auipc	a0,0x7
    80001322:	e9250513          	addi	a0,a0,-366 # 800081b0 <etext+0x1b0>
    80001326:	00002097          	auipc	ra,0x2
    8000132a:	1d8080e7          	jalr	472(ra) # 800034fe <namei>
    8000132e:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001332:	478d                	li	a5,3
    80001334:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001336:	8526                	mv	a0,s1
    80001338:	00005097          	auipc	ra,0x5
    8000133c:	148080e7          	jalr	328(ra) # 80006480 <release>
}
    80001340:	60e2                	ld	ra,24(sp)
    80001342:	6442                	ld	s0,16(sp)
    80001344:	64a2                	ld	s1,8(sp)
    80001346:	6105                	addi	sp,sp,32
    80001348:	8082                	ret

000000008000134a <growproc>:
{
    8000134a:	1101                	addi	sp,sp,-32
    8000134c:	ec06                	sd	ra,24(sp)
    8000134e:	e822                	sd	s0,16(sp)
    80001350:	e426                	sd	s1,8(sp)
    80001352:	e04a                	sd	s2,0(sp)
    80001354:	1000                	addi	s0,sp,32
    80001356:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001358:	00000097          	auipc	ra,0x0
    8000135c:	bdc080e7          	jalr	-1060(ra) # 80000f34 <myproc>
    80001360:	84aa                	mv	s1,a0
  sz = p->sz;
    80001362:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001364:	01204c63          	bgtz	s2,8000137c <growproc+0x32>
  } else if(n < 0){
    80001368:	02094663          	bltz	s2,80001394 <growproc+0x4a>
  p->sz = sz;
    8000136c:	e4ac                	sd	a1,72(s1)
  return 0;
    8000136e:	4501                	li	a0,0
}
    80001370:	60e2                	ld	ra,24(sp)
    80001372:	6442                	ld	s0,16(sp)
    80001374:	64a2                	ld	s1,8(sp)
    80001376:	6902                	ld	s2,0(sp)
    80001378:	6105                	addi	sp,sp,32
    8000137a:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    8000137c:	4691                	li	a3,4
    8000137e:	00b90633          	add	a2,s2,a1
    80001382:	6928                	ld	a0,80(a0)
    80001384:	fffff097          	auipc	ra,0xfffff
    80001388:	53a080e7          	jalr	1338(ra) # 800008be <uvmalloc>
    8000138c:	85aa                	mv	a1,a0
    8000138e:	fd79                	bnez	a0,8000136c <growproc+0x22>
      return -1;
    80001390:	557d                	li	a0,-1
    80001392:	bff9                	j	80001370 <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001394:	00b90633          	add	a2,s2,a1
    80001398:	6928                	ld	a0,80(a0)
    8000139a:	fffff097          	auipc	ra,0xfffff
    8000139e:	4dc080e7          	jalr	1244(ra) # 80000876 <uvmdealloc>
    800013a2:	85aa                	mv	a1,a0
    800013a4:	b7e1                	j	8000136c <growproc+0x22>

00000000800013a6 <fork>:
{
    800013a6:	7179                	addi	sp,sp,-48
    800013a8:	f406                	sd	ra,40(sp)
    800013aa:	f022                	sd	s0,32(sp)
    800013ac:	ec26                	sd	s1,24(sp)
    800013ae:	e84a                	sd	s2,16(sp)
    800013b0:	e44e                	sd	s3,8(sp)
    800013b2:	e052                	sd	s4,0(sp)
    800013b4:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800013b6:	00000097          	auipc	ra,0x0
    800013ba:	b7e080e7          	jalr	-1154(ra) # 80000f34 <myproc>
    800013be:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    800013c0:	00000097          	auipc	ra,0x0
    800013c4:	e04080e7          	jalr	-508(ra) # 800011c4 <allocproc>
    800013c8:	10050b63          	beqz	a0,800014de <fork+0x138>
    800013cc:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800013ce:	04893603          	ld	a2,72(s2)
    800013d2:	692c                	ld	a1,80(a0)
    800013d4:	05093503          	ld	a0,80(s2)
    800013d8:	fffff097          	auipc	ra,0xfffff
    800013dc:	63a080e7          	jalr	1594(ra) # 80000a12 <uvmcopy>
    800013e0:	04054663          	bltz	a0,8000142c <fork+0x86>
  np->sz = p->sz;
    800013e4:	04893783          	ld	a5,72(s2)
    800013e8:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    800013ec:	05893683          	ld	a3,88(s2)
    800013f0:	87b6                	mv	a5,a3
    800013f2:	0589b703          	ld	a4,88(s3)
    800013f6:	12068693          	addi	a3,a3,288
    800013fa:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800013fe:	6788                	ld	a0,8(a5)
    80001400:	6b8c                	ld	a1,16(a5)
    80001402:	6f90                	ld	a2,24(a5)
    80001404:	01073023          	sd	a6,0(a4)
    80001408:	e708                	sd	a0,8(a4)
    8000140a:	eb0c                	sd	a1,16(a4)
    8000140c:	ef10                	sd	a2,24(a4)
    8000140e:	02078793          	addi	a5,a5,32
    80001412:	02070713          	addi	a4,a4,32
    80001416:	fed792e3          	bne	a5,a3,800013fa <fork+0x54>
  np->trapframe->a0 = 0;
    8000141a:	0589b783          	ld	a5,88(s3)
    8000141e:	0607b823          	sd	zero,112(a5)
    80001422:	0d000493          	li	s1,208
  for(i = 0; i < NOFILE; i++)
    80001426:	15000a13          	li	s4,336
    8000142a:	a03d                	j	80001458 <fork+0xb2>
    freeproc(np);
    8000142c:	854e                	mv	a0,s3
    8000142e:	00000097          	auipc	ra,0x0
    80001432:	d2c080e7          	jalr	-724(ra) # 8000115a <freeproc>
    release(&np->lock);
    80001436:	854e                	mv	a0,s3
    80001438:	00005097          	auipc	ra,0x5
    8000143c:	048080e7          	jalr	72(ra) # 80006480 <release>
    return -1;
    80001440:	5a7d                	li	s4,-1
    80001442:	a069                	j	800014cc <fork+0x126>
      np->ofile[i] = filedup(p->ofile[i]);
    80001444:	00002097          	auipc	ra,0x2
    80001448:	750080e7          	jalr	1872(ra) # 80003b94 <filedup>
    8000144c:	009987b3          	add	a5,s3,s1
    80001450:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    80001452:	04a1                	addi	s1,s1,8
    80001454:	01448763          	beq	s1,s4,80001462 <fork+0xbc>
    if(p->ofile[i])
    80001458:	009907b3          	add	a5,s2,s1
    8000145c:	6388                	ld	a0,0(a5)
    8000145e:	f17d                	bnez	a0,80001444 <fork+0x9e>
    80001460:	bfcd                	j	80001452 <fork+0xac>
  np->cwd = idup(p->cwd);
    80001462:	15093503          	ld	a0,336(s2)
    80001466:	00002097          	auipc	ra,0x2
    8000146a:	8b4080e7          	jalr	-1868(ra) # 80002d1a <idup>
    8000146e:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001472:	4641                	li	a2,16
    80001474:	15890593          	addi	a1,s2,344
    80001478:	15898513          	addi	a0,s3,344
    8000147c:	fffff097          	auipc	ra,0xfffff
    80001480:	e4e080e7          	jalr	-434(ra) # 800002ca <safestrcpy>
  pid = np->pid;
    80001484:	0309aa03          	lw	s4,48(s3)
  release(&np->lock);
    80001488:	854e                	mv	a0,s3
    8000148a:	00005097          	auipc	ra,0x5
    8000148e:	ff6080e7          	jalr	-10(ra) # 80006480 <release>
  acquire(&wait_lock);
    80001492:	00007497          	auipc	s1,0x7
    80001496:	4f648493          	addi	s1,s1,1270 # 80008988 <wait_lock>
    8000149a:	8526                	mv	a0,s1
    8000149c:	00005097          	auipc	ra,0x5
    800014a0:	f30080e7          	jalr	-208(ra) # 800063cc <acquire>
  np->parent = p;
    800014a4:	0329bc23          	sd	s2,56(s3)
  release(&wait_lock);
    800014a8:	8526                	mv	a0,s1
    800014aa:	00005097          	auipc	ra,0x5
    800014ae:	fd6080e7          	jalr	-42(ra) # 80006480 <release>
  acquire(&np->lock);
    800014b2:	854e                	mv	a0,s3
    800014b4:	00005097          	auipc	ra,0x5
    800014b8:	f18080e7          	jalr	-232(ra) # 800063cc <acquire>
  np->state = RUNNABLE;
    800014bc:	478d                	li	a5,3
    800014be:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    800014c2:	854e                	mv	a0,s3
    800014c4:	00005097          	auipc	ra,0x5
    800014c8:	fbc080e7          	jalr	-68(ra) # 80006480 <release>
}
    800014cc:	8552                	mv	a0,s4
    800014ce:	70a2                	ld	ra,40(sp)
    800014d0:	7402                	ld	s0,32(sp)
    800014d2:	64e2                	ld	s1,24(sp)
    800014d4:	6942                	ld	s2,16(sp)
    800014d6:	69a2                	ld	s3,8(sp)
    800014d8:	6a02                	ld	s4,0(sp)
    800014da:	6145                	addi	sp,sp,48
    800014dc:	8082                	ret
    return -1;
    800014de:	5a7d                	li	s4,-1
    800014e0:	b7f5                	j	800014cc <fork+0x126>

00000000800014e2 <scheduler>:
{
    800014e2:	7139                	addi	sp,sp,-64
    800014e4:	fc06                	sd	ra,56(sp)
    800014e6:	f822                	sd	s0,48(sp)
    800014e8:	f426                	sd	s1,40(sp)
    800014ea:	f04a                	sd	s2,32(sp)
    800014ec:	ec4e                	sd	s3,24(sp)
    800014ee:	e852                	sd	s4,16(sp)
    800014f0:	e456                	sd	s5,8(sp)
    800014f2:	e05a                	sd	s6,0(sp)
    800014f4:	0080                	addi	s0,sp,64
    800014f6:	8792                	mv	a5,tp
  int id = r_tp();
    800014f8:	2781                	sext.w	a5,a5
  c->proc = 0;
    800014fa:	00779a93          	slli	s5,a5,0x7
    800014fe:	00007717          	auipc	a4,0x7
    80001502:	47270713          	addi	a4,a4,1138 # 80008970 <pid_lock>
    80001506:	9756                	add	a4,a4,s5
    80001508:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    8000150c:	00007717          	auipc	a4,0x7
    80001510:	49c70713          	addi	a4,a4,1180 # 800089a8 <cpus+0x8>
    80001514:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80001516:	498d                	li	s3,3
        p->state = RUNNING;
    80001518:	4b11                	li	s6,4
        c->proc = p;
    8000151a:	079e                	slli	a5,a5,0x7
    8000151c:	00007a17          	auipc	s4,0x7
    80001520:	454a0a13          	addi	s4,s4,1108 # 80008970 <pid_lock>
    80001524:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001526:	0000d917          	auipc	s2,0xd
    8000152a:	47a90913          	addi	s2,s2,1146 # 8000e9a0 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000152e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001532:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001536:	10079073          	csrw	sstatus,a5
    8000153a:	00008497          	auipc	s1,0x8
    8000153e:	86648493          	addi	s1,s1,-1946 # 80008da0 <proc>
    80001542:	a03d                	j	80001570 <scheduler+0x8e>
        p->state = RUNNING;
    80001544:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001548:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    8000154c:	06048593          	addi	a1,s1,96
    80001550:	8556                	mv	a0,s5
    80001552:	00000097          	auipc	ra,0x0
    80001556:	6a4080e7          	jalr	1700(ra) # 80001bf6 <swtch>
        c->proc = 0;
    8000155a:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    8000155e:	8526                	mv	a0,s1
    80001560:	00005097          	auipc	ra,0x5
    80001564:	f20080e7          	jalr	-224(ra) # 80006480 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001568:	17048493          	addi	s1,s1,368
    8000156c:	fd2481e3          	beq	s1,s2,8000152e <scheduler+0x4c>
      acquire(&p->lock);
    80001570:	8526                	mv	a0,s1
    80001572:	00005097          	auipc	ra,0x5
    80001576:	e5a080e7          	jalr	-422(ra) # 800063cc <acquire>
      if(p->state == RUNNABLE) {
    8000157a:	4c9c                	lw	a5,24(s1)
    8000157c:	ff3791e3          	bne	a5,s3,8000155e <scheduler+0x7c>
    80001580:	b7d1                	j	80001544 <scheduler+0x62>

0000000080001582 <sched>:
{
    80001582:	7179                	addi	sp,sp,-48
    80001584:	f406                	sd	ra,40(sp)
    80001586:	f022                	sd	s0,32(sp)
    80001588:	ec26                	sd	s1,24(sp)
    8000158a:	e84a                	sd	s2,16(sp)
    8000158c:	e44e                	sd	s3,8(sp)
    8000158e:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001590:	00000097          	auipc	ra,0x0
    80001594:	9a4080e7          	jalr	-1628(ra) # 80000f34 <myproc>
    80001598:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    8000159a:	00005097          	auipc	ra,0x5
    8000159e:	db8080e7          	jalr	-584(ra) # 80006352 <holding>
    800015a2:	c93d                	beqz	a0,80001618 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    800015a4:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800015a6:	2781                	sext.w	a5,a5
    800015a8:	079e                	slli	a5,a5,0x7
    800015aa:	00007717          	auipc	a4,0x7
    800015ae:	3c670713          	addi	a4,a4,966 # 80008970 <pid_lock>
    800015b2:	97ba                	add	a5,a5,a4
    800015b4:	0a87a703          	lw	a4,168(a5)
    800015b8:	4785                	li	a5,1
    800015ba:	06f71763          	bne	a4,a5,80001628 <sched+0xa6>
  if(p->state == RUNNING)
    800015be:	4c98                	lw	a4,24(s1)
    800015c0:	4791                	li	a5,4
    800015c2:	06f70b63          	beq	a4,a5,80001638 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800015c6:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800015ca:	8b89                	andi	a5,a5,2
  if(intr_get())
    800015cc:	efb5                	bnez	a5,80001648 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    800015ce:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800015d0:	00007917          	auipc	s2,0x7
    800015d4:	3a090913          	addi	s2,s2,928 # 80008970 <pid_lock>
    800015d8:	2781                	sext.w	a5,a5
    800015da:	079e                	slli	a5,a5,0x7
    800015dc:	97ca                	add	a5,a5,s2
    800015de:	0ac7a983          	lw	s3,172(a5)
    800015e2:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800015e4:	2781                	sext.w	a5,a5
    800015e6:	079e                	slli	a5,a5,0x7
    800015e8:	00007597          	auipc	a1,0x7
    800015ec:	3c058593          	addi	a1,a1,960 # 800089a8 <cpus+0x8>
    800015f0:	95be                	add	a1,a1,a5
    800015f2:	06048513          	addi	a0,s1,96
    800015f6:	00000097          	auipc	ra,0x0
    800015fa:	600080e7          	jalr	1536(ra) # 80001bf6 <swtch>
    800015fe:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001600:	2781                	sext.w	a5,a5
    80001602:	079e                	slli	a5,a5,0x7
    80001604:	97ca                	add	a5,a5,s2
    80001606:	0b37a623          	sw	s3,172(a5)
}
    8000160a:	70a2                	ld	ra,40(sp)
    8000160c:	7402                	ld	s0,32(sp)
    8000160e:	64e2                	ld	s1,24(sp)
    80001610:	6942                	ld	s2,16(sp)
    80001612:	69a2                	ld	s3,8(sp)
    80001614:	6145                	addi	sp,sp,48
    80001616:	8082                	ret
    panic("sched p->lock");
    80001618:	00007517          	auipc	a0,0x7
    8000161c:	ba050513          	addi	a0,a0,-1120 # 800081b8 <etext+0x1b8>
    80001620:	00005097          	auipc	ra,0x5
    80001624:	862080e7          	jalr	-1950(ra) # 80005e82 <panic>
    panic("sched locks");
    80001628:	00007517          	auipc	a0,0x7
    8000162c:	ba050513          	addi	a0,a0,-1120 # 800081c8 <etext+0x1c8>
    80001630:	00005097          	auipc	ra,0x5
    80001634:	852080e7          	jalr	-1966(ra) # 80005e82 <panic>
    panic("sched running");
    80001638:	00007517          	auipc	a0,0x7
    8000163c:	ba050513          	addi	a0,a0,-1120 # 800081d8 <etext+0x1d8>
    80001640:	00005097          	auipc	ra,0x5
    80001644:	842080e7          	jalr	-1982(ra) # 80005e82 <panic>
    panic("sched interruptible");
    80001648:	00007517          	auipc	a0,0x7
    8000164c:	ba050513          	addi	a0,a0,-1120 # 800081e8 <etext+0x1e8>
    80001650:	00005097          	auipc	ra,0x5
    80001654:	832080e7          	jalr	-1998(ra) # 80005e82 <panic>

0000000080001658 <yield>:
{
    80001658:	1101                	addi	sp,sp,-32
    8000165a:	ec06                	sd	ra,24(sp)
    8000165c:	e822                	sd	s0,16(sp)
    8000165e:	e426                	sd	s1,8(sp)
    80001660:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001662:	00000097          	auipc	ra,0x0
    80001666:	8d2080e7          	jalr	-1838(ra) # 80000f34 <myproc>
    8000166a:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000166c:	00005097          	auipc	ra,0x5
    80001670:	d60080e7          	jalr	-672(ra) # 800063cc <acquire>
  p->state = RUNNABLE;
    80001674:	478d                	li	a5,3
    80001676:	cc9c                	sw	a5,24(s1)
  sched();
    80001678:	00000097          	auipc	ra,0x0
    8000167c:	f0a080e7          	jalr	-246(ra) # 80001582 <sched>
  release(&p->lock);
    80001680:	8526                	mv	a0,s1
    80001682:	00005097          	auipc	ra,0x5
    80001686:	dfe080e7          	jalr	-514(ra) # 80006480 <release>
}
    8000168a:	60e2                	ld	ra,24(sp)
    8000168c:	6442                	ld	s0,16(sp)
    8000168e:	64a2                	ld	s1,8(sp)
    80001690:	6105                	addi	sp,sp,32
    80001692:	8082                	ret

0000000080001694 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001694:	7179                	addi	sp,sp,-48
    80001696:	f406                	sd	ra,40(sp)
    80001698:	f022                	sd	s0,32(sp)
    8000169a:	ec26                	sd	s1,24(sp)
    8000169c:	e84a                	sd	s2,16(sp)
    8000169e:	e44e                	sd	s3,8(sp)
    800016a0:	1800                	addi	s0,sp,48
    800016a2:	89aa                	mv	s3,a0
    800016a4:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800016a6:	00000097          	auipc	ra,0x0
    800016aa:	88e080e7          	jalr	-1906(ra) # 80000f34 <myproc>
    800016ae:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800016b0:	00005097          	auipc	ra,0x5
    800016b4:	d1c080e7          	jalr	-740(ra) # 800063cc <acquire>
  release(lk);
    800016b8:	854a                	mv	a0,s2
    800016ba:	00005097          	auipc	ra,0x5
    800016be:	dc6080e7          	jalr	-570(ra) # 80006480 <release>

  // Go to sleep.
  p->chan = chan;
    800016c2:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800016c6:	4789                	li	a5,2
    800016c8:	cc9c                	sw	a5,24(s1)

  sched();
    800016ca:	00000097          	auipc	ra,0x0
    800016ce:	eb8080e7          	jalr	-328(ra) # 80001582 <sched>

  // Tidy up.
  p->chan = 0;
    800016d2:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800016d6:	8526                	mv	a0,s1
    800016d8:	00005097          	auipc	ra,0x5
    800016dc:	da8080e7          	jalr	-600(ra) # 80006480 <release>
  acquire(lk);
    800016e0:	854a                	mv	a0,s2
    800016e2:	00005097          	auipc	ra,0x5
    800016e6:	cea080e7          	jalr	-790(ra) # 800063cc <acquire>
}
    800016ea:	70a2                	ld	ra,40(sp)
    800016ec:	7402                	ld	s0,32(sp)
    800016ee:	64e2                	ld	s1,24(sp)
    800016f0:	6942                	ld	s2,16(sp)
    800016f2:	69a2                	ld	s3,8(sp)
    800016f4:	6145                	addi	sp,sp,48
    800016f6:	8082                	ret

00000000800016f8 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800016f8:	7139                	addi	sp,sp,-64
    800016fa:	fc06                	sd	ra,56(sp)
    800016fc:	f822                	sd	s0,48(sp)
    800016fe:	f426                	sd	s1,40(sp)
    80001700:	f04a                	sd	s2,32(sp)
    80001702:	ec4e                	sd	s3,24(sp)
    80001704:	e852                	sd	s4,16(sp)
    80001706:	e456                	sd	s5,8(sp)
    80001708:	0080                	addi	s0,sp,64
    8000170a:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    8000170c:	00007497          	auipc	s1,0x7
    80001710:	69448493          	addi	s1,s1,1684 # 80008da0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001714:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001716:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001718:	0000d917          	auipc	s2,0xd
    8000171c:	28890913          	addi	s2,s2,648 # 8000e9a0 <tickslock>
    80001720:	a821                	j	80001738 <wakeup+0x40>
        p->state = RUNNABLE;
    80001722:	0154ac23          	sw	s5,24(s1)
      }
      release(&p->lock);
    80001726:	8526                	mv	a0,s1
    80001728:	00005097          	auipc	ra,0x5
    8000172c:	d58080e7          	jalr	-680(ra) # 80006480 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001730:	17048493          	addi	s1,s1,368
    80001734:	03248463          	beq	s1,s2,8000175c <wakeup+0x64>
    if(p != myproc()){
    80001738:	fffff097          	auipc	ra,0xfffff
    8000173c:	7fc080e7          	jalr	2044(ra) # 80000f34 <myproc>
    80001740:	fea488e3          	beq	s1,a0,80001730 <wakeup+0x38>
      acquire(&p->lock);
    80001744:	8526                	mv	a0,s1
    80001746:	00005097          	auipc	ra,0x5
    8000174a:	c86080e7          	jalr	-890(ra) # 800063cc <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    8000174e:	4c9c                	lw	a5,24(s1)
    80001750:	fd379be3          	bne	a5,s3,80001726 <wakeup+0x2e>
    80001754:	709c                	ld	a5,32(s1)
    80001756:	fd4798e3          	bne	a5,s4,80001726 <wakeup+0x2e>
    8000175a:	b7e1                	j	80001722 <wakeup+0x2a>
    }
  }
}
    8000175c:	70e2                	ld	ra,56(sp)
    8000175e:	7442                	ld	s0,48(sp)
    80001760:	74a2                	ld	s1,40(sp)
    80001762:	7902                	ld	s2,32(sp)
    80001764:	69e2                	ld	s3,24(sp)
    80001766:	6a42                	ld	s4,16(sp)
    80001768:	6aa2                	ld	s5,8(sp)
    8000176a:	6121                	addi	sp,sp,64
    8000176c:	8082                	ret

000000008000176e <reparent>:
{
    8000176e:	7179                	addi	sp,sp,-48
    80001770:	f406                	sd	ra,40(sp)
    80001772:	f022                	sd	s0,32(sp)
    80001774:	ec26                	sd	s1,24(sp)
    80001776:	e84a                	sd	s2,16(sp)
    80001778:	e44e                	sd	s3,8(sp)
    8000177a:	e052                	sd	s4,0(sp)
    8000177c:	1800                	addi	s0,sp,48
    8000177e:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001780:	00007497          	auipc	s1,0x7
    80001784:	62048493          	addi	s1,s1,1568 # 80008da0 <proc>
      pp->parent = initproc;
    80001788:	00007a17          	auipc	s4,0x7
    8000178c:	1a8a0a13          	addi	s4,s4,424 # 80008930 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001790:	0000d997          	auipc	s3,0xd
    80001794:	21098993          	addi	s3,s3,528 # 8000e9a0 <tickslock>
    80001798:	a029                	j	800017a2 <reparent+0x34>
    8000179a:	17048493          	addi	s1,s1,368
    8000179e:	01348d63          	beq	s1,s3,800017b8 <reparent+0x4a>
    if(pp->parent == p){
    800017a2:	7c9c                	ld	a5,56(s1)
    800017a4:	ff279be3          	bne	a5,s2,8000179a <reparent+0x2c>
      pp->parent = initproc;
    800017a8:	000a3503          	ld	a0,0(s4)
    800017ac:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800017ae:	00000097          	auipc	ra,0x0
    800017b2:	f4a080e7          	jalr	-182(ra) # 800016f8 <wakeup>
    800017b6:	b7d5                	j	8000179a <reparent+0x2c>
}
    800017b8:	70a2                	ld	ra,40(sp)
    800017ba:	7402                	ld	s0,32(sp)
    800017bc:	64e2                	ld	s1,24(sp)
    800017be:	6942                	ld	s2,16(sp)
    800017c0:	69a2                	ld	s3,8(sp)
    800017c2:	6a02                	ld	s4,0(sp)
    800017c4:	6145                	addi	sp,sp,48
    800017c6:	8082                	ret

00000000800017c8 <exit>:
{
    800017c8:	7179                	addi	sp,sp,-48
    800017ca:	f406                	sd	ra,40(sp)
    800017cc:	f022                	sd	s0,32(sp)
    800017ce:	ec26                	sd	s1,24(sp)
    800017d0:	e84a                	sd	s2,16(sp)
    800017d2:	e44e                	sd	s3,8(sp)
    800017d4:	e052                	sd	s4,0(sp)
    800017d6:	1800                	addi	s0,sp,48
    800017d8:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800017da:	fffff097          	auipc	ra,0xfffff
    800017de:	75a080e7          	jalr	1882(ra) # 80000f34 <myproc>
    800017e2:	89aa                	mv	s3,a0
  if(p == initproc)
    800017e4:	00007797          	auipc	a5,0x7
    800017e8:	14c7b783          	ld	a5,332(a5) # 80008930 <initproc>
    800017ec:	0d050493          	addi	s1,a0,208
    800017f0:	15050913          	addi	s2,a0,336
    800017f4:	02a79363          	bne	a5,a0,8000181a <exit+0x52>
    panic("init exiting");
    800017f8:	00007517          	auipc	a0,0x7
    800017fc:	a0850513          	addi	a0,a0,-1528 # 80008200 <etext+0x200>
    80001800:	00004097          	auipc	ra,0x4
    80001804:	682080e7          	jalr	1666(ra) # 80005e82 <panic>
      fileclose(f);
    80001808:	00002097          	auipc	ra,0x2
    8000180c:	3de080e7          	jalr	990(ra) # 80003be6 <fileclose>
      p->ofile[fd] = 0;
    80001810:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001814:	04a1                	addi	s1,s1,8
    80001816:	01248563          	beq	s1,s2,80001820 <exit+0x58>
    if(p->ofile[fd]){
    8000181a:	6088                	ld	a0,0(s1)
    8000181c:	f575                	bnez	a0,80001808 <exit+0x40>
    8000181e:	bfdd                	j	80001814 <exit+0x4c>
  begin_op();
    80001820:	00002097          	auipc	ra,0x2
    80001824:	efa080e7          	jalr	-262(ra) # 8000371a <begin_op>
  iput(p->cwd);
    80001828:	1509b503          	ld	a0,336(s3)
    8000182c:	00001097          	auipc	ra,0x1
    80001830:	6e6080e7          	jalr	1766(ra) # 80002f12 <iput>
  end_op();
    80001834:	00002097          	auipc	ra,0x2
    80001838:	f66080e7          	jalr	-154(ra) # 8000379a <end_op>
  p->cwd = 0;
    8000183c:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001840:	00007497          	auipc	s1,0x7
    80001844:	14848493          	addi	s1,s1,328 # 80008988 <wait_lock>
    80001848:	8526                	mv	a0,s1
    8000184a:	00005097          	auipc	ra,0x5
    8000184e:	b82080e7          	jalr	-1150(ra) # 800063cc <acquire>
  reparent(p);
    80001852:	854e                	mv	a0,s3
    80001854:	00000097          	auipc	ra,0x0
    80001858:	f1a080e7          	jalr	-230(ra) # 8000176e <reparent>
  wakeup(p->parent);
    8000185c:	0389b503          	ld	a0,56(s3)
    80001860:	00000097          	auipc	ra,0x0
    80001864:	e98080e7          	jalr	-360(ra) # 800016f8 <wakeup>
  acquire(&p->lock);
    80001868:	854e                	mv	a0,s3
    8000186a:	00005097          	auipc	ra,0x5
    8000186e:	b62080e7          	jalr	-1182(ra) # 800063cc <acquire>
  p->xstate = status;
    80001872:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001876:	4795                	li	a5,5
    80001878:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    8000187c:	8526                	mv	a0,s1
    8000187e:	00005097          	auipc	ra,0x5
    80001882:	c02080e7          	jalr	-1022(ra) # 80006480 <release>
  sched();
    80001886:	00000097          	auipc	ra,0x0
    8000188a:	cfc080e7          	jalr	-772(ra) # 80001582 <sched>
  panic("zombie exit");
    8000188e:	00007517          	auipc	a0,0x7
    80001892:	98250513          	addi	a0,a0,-1662 # 80008210 <etext+0x210>
    80001896:	00004097          	auipc	ra,0x4
    8000189a:	5ec080e7          	jalr	1516(ra) # 80005e82 <panic>

000000008000189e <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    8000189e:	7179                	addi	sp,sp,-48
    800018a0:	f406                	sd	ra,40(sp)
    800018a2:	f022                	sd	s0,32(sp)
    800018a4:	ec26                	sd	s1,24(sp)
    800018a6:	e84a                	sd	s2,16(sp)
    800018a8:	e44e                	sd	s3,8(sp)
    800018aa:	1800                	addi	s0,sp,48
    800018ac:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800018ae:	00007497          	auipc	s1,0x7
    800018b2:	4f248493          	addi	s1,s1,1266 # 80008da0 <proc>
    800018b6:	0000d997          	auipc	s3,0xd
    800018ba:	0ea98993          	addi	s3,s3,234 # 8000e9a0 <tickslock>
    acquire(&p->lock);
    800018be:	8526                	mv	a0,s1
    800018c0:	00005097          	auipc	ra,0x5
    800018c4:	b0c080e7          	jalr	-1268(ra) # 800063cc <acquire>
    if(p->pid == pid){
    800018c8:	589c                	lw	a5,48(s1)
    800018ca:	01278d63          	beq	a5,s2,800018e4 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800018ce:	8526                	mv	a0,s1
    800018d0:	00005097          	auipc	ra,0x5
    800018d4:	bb0080e7          	jalr	-1104(ra) # 80006480 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800018d8:	17048493          	addi	s1,s1,368
    800018dc:	ff3491e3          	bne	s1,s3,800018be <kill+0x20>
  }
  return -1;
    800018e0:	557d                	li	a0,-1
    800018e2:	a829                	j	800018fc <kill+0x5e>
      p->killed = 1;
    800018e4:	4785                	li	a5,1
    800018e6:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800018e8:	4c98                	lw	a4,24(s1)
    800018ea:	4789                	li	a5,2
    800018ec:	00f70f63          	beq	a4,a5,8000190a <kill+0x6c>
      release(&p->lock);
    800018f0:	8526                	mv	a0,s1
    800018f2:	00005097          	auipc	ra,0x5
    800018f6:	b8e080e7          	jalr	-1138(ra) # 80006480 <release>
      return 0;
    800018fa:	4501                	li	a0,0
}
    800018fc:	70a2                	ld	ra,40(sp)
    800018fe:	7402                	ld	s0,32(sp)
    80001900:	64e2                	ld	s1,24(sp)
    80001902:	6942                	ld	s2,16(sp)
    80001904:	69a2                	ld	s3,8(sp)
    80001906:	6145                	addi	sp,sp,48
    80001908:	8082                	ret
        p->state = RUNNABLE;
    8000190a:	478d                	li	a5,3
    8000190c:	cc9c                	sw	a5,24(s1)
    8000190e:	b7cd                	j	800018f0 <kill+0x52>

0000000080001910 <setkilled>:

void
setkilled(struct proc *p)
{
    80001910:	1101                	addi	sp,sp,-32
    80001912:	ec06                	sd	ra,24(sp)
    80001914:	e822                	sd	s0,16(sp)
    80001916:	e426                	sd	s1,8(sp)
    80001918:	1000                	addi	s0,sp,32
    8000191a:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000191c:	00005097          	auipc	ra,0x5
    80001920:	ab0080e7          	jalr	-1360(ra) # 800063cc <acquire>
  p->killed = 1;
    80001924:	4785                	li	a5,1
    80001926:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80001928:	8526                	mv	a0,s1
    8000192a:	00005097          	auipc	ra,0x5
    8000192e:	b56080e7          	jalr	-1194(ra) # 80006480 <release>
}
    80001932:	60e2                	ld	ra,24(sp)
    80001934:	6442                	ld	s0,16(sp)
    80001936:	64a2                	ld	s1,8(sp)
    80001938:	6105                	addi	sp,sp,32
    8000193a:	8082                	ret

000000008000193c <killed>:

int
killed(struct proc *p)
{
    8000193c:	1101                	addi	sp,sp,-32
    8000193e:	ec06                	sd	ra,24(sp)
    80001940:	e822                	sd	s0,16(sp)
    80001942:	e426                	sd	s1,8(sp)
    80001944:	e04a                	sd	s2,0(sp)
    80001946:	1000                	addi	s0,sp,32
    80001948:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    8000194a:	00005097          	auipc	ra,0x5
    8000194e:	a82080e7          	jalr	-1406(ra) # 800063cc <acquire>
  k = p->killed;
    80001952:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80001956:	8526                	mv	a0,s1
    80001958:	00005097          	auipc	ra,0x5
    8000195c:	b28080e7          	jalr	-1240(ra) # 80006480 <release>
  return k;
}
    80001960:	854a                	mv	a0,s2
    80001962:	60e2                	ld	ra,24(sp)
    80001964:	6442                	ld	s0,16(sp)
    80001966:	64a2                	ld	s1,8(sp)
    80001968:	6902                	ld	s2,0(sp)
    8000196a:	6105                	addi	sp,sp,32
    8000196c:	8082                	ret

000000008000196e <wait>:
{
    8000196e:	715d                	addi	sp,sp,-80
    80001970:	e486                	sd	ra,72(sp)
    80001972:	e0a2                	sd	s0,64(sp)
    80001974:	fc26                	sd	s1,56(sp)
    80001976:	f84a                	sd	s2,48(sp)
    80001978:	f44e                	sd	s3,40(sp)
    8000197a:	f052                	sd	s4,32(sp)
    8000197c:	ec56                	sd	s5,24(sp)
    8000197e:	e85a                	sd	s6,16(sp)
    80001980:	e45e                	sd	s7,8(sp)
    80001982:	e062                	sd	s8,0(sp)
    80001984:	0880                	addi	s0,sp,80
    80001986:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80001988:	fffff097          	auipc	ra,0xfffff
    8000198c:	5ac080e7          	jalr	1452(ra) # 80000f34 <myproc>
    80001990:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001992:	00007517          	auipc	a0,0x7
    80001996:	ff650513          	addi	a0,a0,-10 # 80008988 <wait_lock>
    8000199a:	00005097          	auipc	ra,0x5
    8000199e:	a32080e7          	jalr	-1486(ra) # 800063cc <acquire>
    havekids = 0;
    800019a2:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    800019a4:	4a15                	li	s4,5
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800019a6:	0000d997          	auipc	s3,0xd
    800019aa:	ffa98993          	addi	s3,s3,-6 # 8000e9a0 <tickslock>
        havekids = 1;
    800019ae:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800019b0:	00007c17          	auipc	s8,0x7
    800019b4:	fd8c0c13          	addi	s8,s8,-40 # 80008988 <wait_lock>
    havekids = 0;
    800019b8:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800019ba:	00007497          	auipc	s1,0x7
    800019be:	3e648493          	addi	s1,s1,998 # 80008da0 <proc>
    800019c2:	a0bd                	j	80001a30 <wait+0xc2>
          pid = pp->pid;
    800019c4:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800019c8:	000b0e63          	beqz	s6,800019e4 <wait+0x76>
    800019cc:	4691                	li	a3,4
    800019ce:	02c48613          	addi	a2,s1,44
    800019d2:	85da                	mv	a1,s6
    800019d4:	05093503          	ld	a0,80(s2)
    800019d8:	fffff097          	auipc	ra,0xfffff
    800019dc:	13e080e7          	jalr	318(ra) # 80000b16 <copyout>
    800019e0:	02054563          	bltz	a0,80001a0a <wait+0x9c>
          freeproc(pp);
    800019e4:	8526                	mv	a0,s1
    800019e6:	fffff097          	auipc	ra,0xfffff
    800019ea:	774080e7          	jalr	1908(ra) # 8000115a <freeproc>
          release(&pp->lock);
    800019ee:	8526                	mv	a0,s1
    800019f0:	00005097          	auipc	ra,0x5
    800019f4:	a90080e7          	jalr	-1392(ra) # 80006480 <release>
          release(&wait_lock);
    800019f8:	00007517          	auipc	a0,0x7
    800019fc:	f9050513          	addi	a0,a0,-112 # 80008988 <wait_lock>
    80001a00:	00005097          	auipc	ra,0x5
    80001a04:	a80080e7          	jalr	-1408(ra) # 80006480 <release>
          return pid;
    80001a08:	a0b5                	j	80001a74 <wait+0x106>
            release(&pp->lock);
    80001a0a:	8526                	mv	a0,s1
    80001a0c:	00005097          	auipc	ra,0x5
    80001a10:	a74080e7          	jalr	-1420(ra) # 80006480 <release>
            release(&wait_lock);
    80001a14:	00007517          	auipc	a0,0x7
    80001a18:	f7450513          	addi	a0,a0,-140 # 80008988 <wait_lock>
    80001a1c:	00005097          	auipc	ra,0x5
    80001a20:	a64080e7          	jalr	-1436(ra) # 80006480 <release>
            return -1;
    80001a24:	59fd                	li	s3,-1
    80001a26:	a0b9                	j	80001a74 <wait+0x106>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001a28:	17048493          	addi	s1,s1,368
    80001a2c:	03348463          	beq	s1,s3,80001a54 <wait+0xe6>
      if(pp->parent == p){
    80001a30:	7c9c                	ld	a5,56(s1)
    80001a32:	ff279be3          	bne	a5,s2,80001a28 <wait+0xba>
        acquire(&pp->lock);
    80001a36:	8526                	mv	a0,s1
    80001a38:	00005097          	auipc	ra,0x5
    80001a3c:	994080e7          	jalr	-1644(ra) # 800063cc <acquire>
        if(pp->state == ZOMBIE){
    80001a40:	4c9c                	lw	a5,24(s1)
    80001a42:	f94781e3          	beq	a5,s4,800019c4 <wait+0x56>
        release(&pp->lock);
    80001a46:	8526                	mv	a0,s1
    80001a48:	00005097          	auipc	ra,0x5
    80001a4c:	a38080e7          	jalr	-1480(ra) # 80006480 <release>
        havekids = 1;
    80001a50:	8756                	mv	a4,s5
    80001a52:	bfd9                	j	80001a28 <wait+0xba>
    if(!havekids || killed(p)){
    80001a54:	c719                	beqz	a4,80001a62 <wait+0xf4>
    80001a56:	854a                	mv	a0,s2
    80001a58:	00000097          	auipc	ra,0x0
    80001a5c:	ee4080e7          	jalr	-284(ra) # 8000193c <killed>
    80001a60:	c51d                	beqz	a0,80001a8e <wait+0x120>
      release(&wait_lock);
    80001a62:	00007517          	auipc	a0,0x7
    80001a66:	f2650513          	addi	a0,a0,-218 # 80008988 <wait_lock>
    80001a6a:	00005097          	auipc	ra,0x5
    80001a6e:	a16080e7          	jalr	-1514(ra) # 80006480 <release>
      return -1;
    80001a72:	59fd                	li	s3,-1
}
    80001a74:	854e                	mv	a0,s3
    80001a76:	60a6                	ld	ra,72(sp)
    80001a78:	6406                	ld	s0,64(sp)
    80001a7a:	74e2                	ld	s1,56(sp)
    80001a7c:	7942                	ld	s2,48(sp)
    80001a7e:	79a2                	ld	s3,40(sp)
    80001a80:	7a02                	ld	s4,32(sp)
    80001a82:	6ae2                	ld	s5,24(sp)
    80001a84:	6b42                	ld	s6,16(sp)
    80001a86:	6ba2                	ld	s7,8(sp)
    80001a88:	6c02                	ld	s8,0(sp)
    80001a8a:	6161                	addi	sp,sp,80
    80001a8c:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001a8e:	85e2                	mv	a1,s8
    80001a90:	854a                	mv	a0,s2
    80001a92:	00000097          	auipc	ra,0x0
    80001a96:	c02080e7          	jalr	-1022(ra) # 80001694 <sleep>
    havekids = 0;
    80001a9a:	bf39                	j	800019b8 <wait+0x4a>

0000000080001a9c <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001a9c:	7179                	addi	sp,sp,-48
    80001a9e:	f406                	sd	ra,40(sp)
    80001aa0:	f022                	sd	s0,32(sp)
    80001aa2:	ec26                	sd	s1,24(sp)
    80001aa4:	e84a                	sd	s2,16(sp)
    80001aa6:	e44e                	sd	s3,8(sp)
    80001aa8:	e052                	sd	s4,0(sp)
    80001aaa:	1800                	addi	s0,sp,48
    80001aac:	84aa                	mv	s1,a0
    80001aae:	892e                	mv	s2,a1
    80001ab0:	89b2                	mv	s3,a2
    80001ab2:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001ab4:	fffff097          	auipc	ra,0xfffff
    80001ab8:	480080e7          	jalr	1152(ra) # 80000f34 <myproc>
  if(user_dst){
    80001abc:	c08d                	beqz	s1,80001ade <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001abe:	86d2                	mv	a3,s4
    80001ac0:	864e                	mv	a2,s3
    80001ac2:	85ca                	mv	a1,s2
    80001ac4:	6928                	ld	a0,80(a0)
    80001ac6:	fffff097          	auipc	ra,0xfffff
    80001aca:	050080e7          	jalr	80(ra) # 80000b16 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001ace:	70a2                	ld	ra,40(sp)
    80001ad0:	7402                	ld	s0,32(sp)
    80001ad2:	64e2                	ld	s1,24(sp)
    80001ad4:	6942                	ld	s2,16(sp)
    80001ad6:	69a2                	ld	s3,8(sp)
    80001ad8:	6a02                	ld	s4,0(sp)
    80001ada:	6145                	addi	sp,sp,48
    80001adc:	8082                	ret
    memmove((char *)dst, src, len);
    80001ade:	000a061b          	sext.w	a2,s4
    80001ae2:	85ce                	mv	a1,s3
    80001ae4:	854a                	mv	a0,s2
    80001ae6:	ffffe097          	auipc	ra,0xffffe
    80001aea:	6f2080e7          	jalr	1778(ra) # 800001d8 <memmove>
    return 0;
    80001aee:	8526                	mv	a0,s1
    80001af0:	bff9                	j	80001ace <either_copyout+0x32>

0000000080001af2 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001af2:	7179                	addi	sp,sp,-48
    80001af4:	f406                	sd	ra,40(sp)
    80001af6:	f022                	sd	s0,32(sp)
    80001af8:	ec26                	sd	s1,24(sp)
    80001afa:	e84a                	sd	s2,16(sp)
    80001afc:	e44e                	sd	s3,8(sp)
    80001afe:	e052                	sd	s4,0(sp)
    80001b00:	1800                	addi	s0,sp,48
    80001b02:	892a                	mv	s2,a0
    80001b04:	84ae                	mv	s1,a1
    80001b06:	89b2                	mv	s3,a2
    80001b08:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001b0a:	fffff097          	auipc	ra,0xfffff
    80001b0e:	42a080e7          	jalr	1066(ra) # 80000f34 <myproc>
  if(user_src){
    80001b12:	c08d                	beqz	s1,80001b34 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001b14:	86d2                	mv	a3,s4
    80001b16:	864e                	mv	a2,s3
    80001b18:	85ca                	mv	a1,s2
    80001b1a:	6928                	ld	a0,80(a0)
    80001b1c:	fffff097          	auipc	ra,0xfffff
    80001b20:	086080e7          	jalr	134(ra) # 80000ba2 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001b24:	70a2                	ld	ra,40(sp)
    80001b26:	7402                	ld	s0,32(sp)
    80001b28:	64e2                	ld	s1,24(sp)
    80001b2a:	6942                	ld	s2,16(sp)
    80001b2c:	69a2                	ld	s3,8(sp)
    80001b2e:	6a02                	ld	s4,0(sp)
    80001b30:	6145                	addi	sp,sp,48
    80001b32:	8082                	ret
    memmove(dst, (char*)src, len);
    80001b34:	000a061b          	sext.w	a2,s4
    80001b38:	85ce                	mv	a1,s3
    80001b3a:	854a                	mv	a0,s2
    80001b3c:	ffffe097          	auipc	ra,0xffffe
    80001b40:	69c080e7          	jalr	1692(ra) # 800001d8 <memmove>
    return 0;
    80001b44:	8526                	mv	a0,s1
    80001b46:	bff9                	j	80001b24 <either_copyin+0x32>

0000000080001b48 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001b48:	715d                	addi	sp,sp,-80
    80001b4a:	e486                	sd	ra,72(sp)
    80001b4c:	e0a2                	sd	s0,64(sp)
    80001b4e:	fc26                	sd	s1,56(sp)
    80001b50:	f84a                	sd	s2,48(sp)
    80001b52:	f44e                	sd	s3,40(sp)
    80001b54:	f052                	sd	s4,32(sp)
    80001b56:	ec56                	sd	s5,24(sp)
    80001b58:	e85a                	sd	s6,16(sp)
    80001b5a:	e45e                	sd	s7,8(sp)
    80001b5c:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001b5e:	00006517          	auipc	a0,0x6
    80001b62:	4ea50513          	addi	a0,a0,1258 # 80008048 <etext+0x48>
    80001b66:	00004097          	auipc	ra,0x4
    80001b6a:	366080e7          	jalr	870(ra) # 80005ecc <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b6e:	00007497          	auipc	s1,0x7
    80001b72:	38a48493          	addi	s1,s1,906 # 80008ef8 <proc+0x158>
    80001b76:	0000d917          	auipc	s2,0xd
    80001b7a:	f8290913          	addi	s2,s2,-126 # 8000eaf8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b7e:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001b80:	00006997          	auipc	s3,0x6
    80001b84:	6a098993          	addi	s3,s3,1696 # 80008220 <etext+0x220>
    printf("%d %s %s", p->pid, state, p->name);
    80001b88:	00006a97          	auipc	s5,0x6
    80001b8c:	6a0a8a93          	addi	s5,s5,1696 # 80008228 <etext+0x228>
    printf("\n");
    80001b90:	00006a17          	auipc	s4,0x6
    80001b94:	4b8a0a13          	addi	s4,s4,1208 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001b98:	00006b97          	auipc	s7,0x6
    80001b9c:	6d0b8b93          	addi	s7,s7,1744 # 80008268 <states.1728>
    80001ba0:	a00d                	j	80001bc2 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001ba2:	ed86a583          	lw	a1,-296(a3)
    80001ba6:	8556                	mv	a0,s5
    80001ba8:	00004097          	auipc	ra,0x4
    80001bac:	324080e7          	jalr	804(ra) # 80005ecc <printf>
    printf("\n");
    80001bb0:	8552                	mv	a0,s4
    80001bb2:	00004097          	auipc	ra,0x4
    80001bb6:	31a080e7          	jalr	794(ra) # 80005ecc <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001bba:	17048493          	addi	s1,s1,368
    80001bbe:	03248163          	beq	s1,s2,80001be0 <procdump+0x98>
    if(p->state == UNUSED)
    80001bc2:	86a6                	mv	a3,s1
    80001bc4:	ec04a783          	lw	a5,-320(s1)
    80001bc8:	dbed                	beqz	a5,80001bba <procdump+0x72>
      state = "???";
    80001bca:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001bcc:	fcfb6be3          	bltu	s6,a5,80001ba2 <procdump+0x5a>
    80001bd0:	1782                	slli	a5,a5,0x20
    80001bd2:	9381                	srli	a5,a5,0x20
    80001bd4:	078e                	slli	a5,a5,0x3
    80001bd6:	97de                	add	a5,a5,s7
    80001bd8:	6390                	ld	a2,0(a5)
    80001bda:	f661                	bnez	a2,80001ba2 <procdump+0x5a>
      state = "???";
    80001bdc:	864e                	mv	a2,s3
    80001bde:	b7d1                	j	80001ba2 <procdump+0x5a>
  }
}
    80001be0:	60a6                	ld	ra,72(sp)
    80001be2:	6406                	ld	s0,64(sp)
    80001be4:	74e2                	ld	s1,56(sp)
    80001be6:	7942                	ld	s2,48(sp)
    80001be8:	79a2                	ld	s3,40(sp)
    80001bea:	7a02                	ld	s4,32(sp)
    80001bec:	6ae2                	ld	s5,24(sp)
    80001bee:	6b42                	ld	s6,16(sp)
    80001bf0:	6ba2                	ld	s7,8(sp)
    80001bf2:	6161                	addi	sp,sp,80
    80001bf4:	8082                	ret

0000000080001bf6 <swtch>:
    80001bf6:	00153023          	sd	ra,0(a0)
    80001bfa:	00253423          	sd	sp,8(a0)
    80001bfe:	e900                	sd	s0,16(a0)
    80001c00:	ed04                	sd	s1,24(a0)
    80001c02:	03253023          	sd	s2,32(a0)
    80001c06:	03353423          	sd	s3,40(a0)
    80001c0a:	03453823          	sd	s4,48(a0)
    80001c0e:	03553c23          	sd	s5,56(a0)
    80001c12:	05653023          	sd	s6,64(a0)
    80001c16:	05753423          	sd	s7,72(a0)
    80001c1a:	05853823          	sd	s8,80(a0)
    80001c1e:	05953c23          	sd	s9,88(a0)
    80001c22:	07a53023          	sd	s10,96(a0)
    80001c26:	07b53423          	sd	s11,104(a0)
    80001c2a:	0005b083          	ld	ra,0(a1)
    80001c2e:	0085b103          	ld	sp,8(a1)
    80001c32:	6980                	ld	s0,16(a1)
    80001c34:	6d84                	ld	s1,24(a1)
    80001c36:	0205b903          	ld	s2,32(a1)
    80001c3a:	0285b983          	ld	s3,40(a1)
    80001c3e:	0305ba03          	ld	s4,48(a1)
    80001c42:	0385ba83          	ld	s5,56(a1)
    80001c46:	0405bb03          	ld	s6,64(a1)
    80001c4a:	0485bb83          	ld	s7,72(a1)
    80001c4e:	0505bc03          	ld	s8,80(a1)
    80001c52:	0585bc83          	ld	s9,88(a1)
    80001c56:	0605bd03          	ld	s10,96(a1)
    80001c5a:	0685bd83          	ld	s11,104(a1)
    80001c5e:	8082                	ret

0000000080001c60 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001c60:	1141                	addi	sp,sp,-16
    80001c62:	e406                	sd	ra,8(sp)
    80001c64:	e022                	sd	s0,0(sp)
    80001c66:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001c68:	00006597          	auipc	a1,0x6
    80001c6c:	63058593          	addi	a1,a1,1584 # 80008298 <states.1728+0x30>
    80001c70:	0000d517          	auipc	a0,0xd
    80001c74:	d3050513          	addi	a0,a0,-720 # 8000e9a0 <tickslock>
    80001c78:	00004097          	auipc	ra,0x4
    80001c7c:	6c4080e7          	jalr	1732(ra) # 8000633c <initlock>
}
    80001c80:	60a2                	ld	ra,8(sp)
    80001c82:	6402                	ld	s0,0(sp)
    80001c84:	0141                	addi	sp,sp,16
    80001c86:	8082                	ret

0000000080001c88 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001c88:	1141                	addi	sp,sp,-16
    80001c8a:	e422                	sd	s0,8(sp)
    80001c8c:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001c8e:	00003797          	auipc	a5,0x3
    80001c92:	5c278793          	addi	a5,a5,1474 # 80005250 <kernelvec>
    80001c96:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001c9a:	6422                	ld	s0,8(sp)
    80001c9c:	0141                	addi	sp,sp,16
    80001c9e:	8082                	ret

0000000080001ca0 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001ca0:	1141                	addi	sp,sp,-16
    80001ca2:	e406                	sd	ra,8(sp)
    80001ca4:	e022                	sd	s0,0(sp)
    80001ca6:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001ca8:	fffff097          	auipc	ra,0xfffff
    80001cac:	28c080e7          	jalr	652(ra) # 80000f34 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cb0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001cb4:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001cb6:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001cba:	00005617          	auipc	a2,0x5
    80001cbe:	34660613          	addi	a2,a2,838 # 80007000 <_trampoline>
    80001cc2:	00005697          	auipc	a3,0x5
    80001cc6:	33e68693          	addi	a3,a3,830 # 80007000 <_trampoline>
    80001cca:	8e91                	sub	a3,a3,a2
    80001ccc:	040007b7          	lui	a5,0x4000
    80001cd0:	17fd                	addi	a5,a5,-1
    80001cd2:	07b2                	slli	a5,a5,0xc
    80001cd4:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001cd6:	10569073          	csrw	stvec,a3
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001cda:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001cdc:	180026f3          	csrr	a3,satp
    80001ce0:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001ce2:	6d38                	ld	a4,88(a0)
    80001ce4:	6134                	ld	a3,64(a0)
    80001ce6:	6585                	lui	a1,0x1
    80001ce8:	96ae                	add	a3,a3,a1
    80001cea:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001cec:	6d38                	ld	a4,88(a0)
    80001cee:	00000697          	auipc	a3,0x0
    80001cf2:	13068693          	addi	a3,a3,304 # 80001e1e <usertrap>
    80001cf6:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001cf8:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001cfa:	8692                	mv	a3,tp
    80001cfc:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cfe:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001d02:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001d06:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d0a:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001d0e:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001d10:	6f18                	ld	a4,24(a4)
    80001d12:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001d16:	6928                	ld	a0,80(a0)
    80001d18:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001d1a:	00005717          	auipc	a4,0x5
    80001d1e:	38270713          	addi	a4,a4,898 # 8000709c <userret>
    80001d22:	8f11                	sub	a4,a4,a2
    80001d24:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001d26:	577d                	li	a4,-1
    80001d28:	177e                	slli	a4,a4,0x3f
    80001d2a:	8d59                	or	a0,a0,a4
    80001d2c:	9782                	jalr	a5
}
    80001d2e:	60a2                	ld	ra,8(sp)
    80001d30:	6402                	ld	s0,0(sp)
    80001d32:	0141                	addi	sp,sp,16
    80001d34:	8082                	ret

0000000080001d36 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001d36:	1101                	addi	sp,sp,-32
    80001d38:	ec06                	sd	ra,24(sp)
    80001d3a:	e822                	sd	s0,16(sp)
    80001d3c:	e426                	sd	s1,8(sp)
    80001d3e:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001d40:	0000d497          	auipc	s1,0xd
    80001d44:	c6048493          	addi	s1,s1,-928 # 8000e9a0 <tickslock>
    80001d48:	8526                	mv	a0,s1
    80001d4a:	00004097          	auipc	ra,0x4
    80001d4e:	682080e7          	jalr	1666(ra) # 800063cc <acquire>
  ticks++;
    80001d52:	00007517          	auipc	a0,0x7
    80001d56:	be650513          	addi	a0,a0,-1050 # 80008938 <ticks>
    80001d5a:	411c                	lw	a5,0(a0)
    80001d5c:	2785                	addiw	a5,a5,1
    80001d5e:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001d60:	00000097          	auipc	ra,0x0
    80001d64:	998080e7          	jalr	-1640(ra) # 800016f8 <wakeup>
  release(&tickslock);
    80001d68:	8526                	mv	a0,s1
    80001d6a:	00004097          	auipc	ra,0x4
    80001d6e:	716080e7          	jalr	1814(ra) # 80006480 <release>
}
    80001d72:	60e2                	ld	ra,24(sp)
    80001d74:	6442                	ld	s0,16(sp)
    80001d76:	64a2                	ld	s1,8(sp)
    80001d78:	6105                	addi	sp,sp,32
    80001d7a:	8082                	ret

0000000080001d7c <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001d7c:	1101                	addi	sp,sp,-32
    80001d7e:	ec06                	sd	ra,24(sp)
    80001d80:	e822                	sd	s0,16(sp)
    80001d82:	e426                	sd	s1,8(sp)
    80001d84:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d86:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001d8a:	00074d63          	bltz	a4,80001da4 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001d8e:	57fd                	li	a5,-1
    80001d90:	17fe                	slli	a5,a5,0x3f
    80001d92:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001d94:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001d96:	06f70363          	beq	a4,a5,80001dfc <devintr+0x80>
  }
}
    80001d9a:	60e2                	ld	ra,24(sp)
    80001d9c:	6442                	ld	s0,16(sp)
    80001d9e:	64a2                	ld	s1,8(sp)
    80001da0:	6105                	addi	sp,sp,32
    80001da2:	8082                	ret
     (scause & 0xff) == 9){
    80001da4:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001da8:	46a5                	li	a3,9
    80001daa:	fed792e3          	bne	a5,a3,80001d8e <devintr+0x12>
    int irq = plic_claim();
    80001dae:	00003097          	auipc	ra,0x3
    80001db2:	5aa080e7          	jalr	1450(ra) # 80005358 <plic_claim>
    80001db6:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001db8:	47a9                	li	a5,10
    80001dba:	02f50763          	beq	a0,a5,80001de8 <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001dbe:	4785                	li	a5,1
    80001dc0:	02f50963          	beq	a0,a5,80001df2 <devintr+0x76>
    return 1;
    80001dc4:	4505                	li	a0,1
    } else if(irq){
    80001dc6:	d8f1                	beqz	s1,80001d9a <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001dc8:	85a6                	mv	a1,s1
    80001dca:	00006517          	auipc	a0,0x6
    80001dce:	4d650513          	addi	a0,a0,1238 # 800082a0 <states.1728+0x38>
    80001dd2:	00004097          	auipc	ra,0x4
    80001dd6:	0fa080e7          	jalr	250(ra) # 80005ecc <printf>
      plic_complete(irq);
    80001dda:	8526                	mv	a0,s1
    80001ddc:	00003097          	auipc	ra,0x3
    80001de0:	5a0080e7          	jalr	1440(ra) # 8000537c <plic_complete>
    return 1;
    80001de4:	4505                	li	a0,1
    80001de6:	bf55                	j	80001d9a <devintr+0x1e>
      uartintr();
    80001de8:	00004097          	auipc	ra,0x4
    80001dec:	504080e7          	jalr	1284(ra) # 800062ec <uartintr>
    80001df0:	b7ed                	j	80001dda <devintr+0x5e>
      virtio_disk_intr();
    80001df2:	00004097          	auipc	ra,0x4
    80001df6:	ab4080e7          	jalr	-1356(ra) # 800058a6 <virtio_disk_intr>
    80001dfa:	b7c5                	j	80001dda <devintr+0x5e>
    if(cpuid() == 0){
    80001dfc:	fffff097          	auipc	ra,0xfffff
    80001e00:	10c080e7          	jalr	268(ra) # 80000f08 <cpuid>
    80001e04:	c901                	beqz	a0,80001e14 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001e06:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001e0a:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001e0c:	14479073          	csrw	sip,a5
    return 2;
    80001e10:	4509                	li	a0,2
    80001e12:	b761                	j	80001d9a <devintr+0x1e>
      clockintr();
    80001e14:	00000097          	auipc	ra,0x0
    80001e18:	f22080e7          	jalr	-222(ra) # 80001d36 <clockintr>
    80001e1c:	b7ed                	j	80001e06 <devintr+0x8a>

0000000080001e1e <usertrap>:
{
    80001e1e:	1101                	addi	sp,sp,-32
    80001e20:	ec06                	sd	ra,24(sp)
    80001e22:	e822                	sd	s0,16(sp)
    80001e24:	e426                	sd	s1,8(sp)
    80001e26:	e04a                	sd	s2,0(sp)
    80001e28:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e2a:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001e2e:	1007f793          	andi	a5,a5,256
    80001e32:	e3b1                	bnez	a5,80001e76 <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001e34:	00003797          	auipc	a5,0x3
    80001e38:	41c78793          	addi	a5,a5,1052 # 80005250 <kernelvec>
    80001e3c:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001e40:	fffff097          	auipc	ra,0xfffff
    80001e44:	0f4080e7          	jalr	244(ra) # 80000f34 <myproc>
    80001e48:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001e4a:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e4c:	14102773          	csrr	a4,sepc
    80001e50:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e52:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001e56:	47a1                	li	a5,8
    80001e58:	02f70763          	beq	a4,a5,80001e86 <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    80001e5c:	00000097          	auipc	ra,0x0
    80001e60:	f20080e7          	jalr	-224(ra) # 80001d7c <devintr>
    80001e64:	892a                	mv	s2,a0
    80001e66:	c151                	beqz	a0,80001eea <usertrap+0xcc>
  if(killed(p))
    80001e68:	8526                	mv	a0,s1
    80001e6a:	00000097          	auipc	ra,0x0
    80001e6e:	ad2080e7          	jalr	-1326(ra) # 8000193c <killed>
    80001e72:	c929                	beqz	a0,80001ec4 <usertrap+0xa6>
    80001e74:	a099                	j	80001eba <usertrap+0x9c>
    panic("usertrap: not from user mode");
    80001e76:	00006517          	auipc	a0,0x6
    80001e7a:	44a50513          	addi	a0,a0,1098 # 800082c0 <states.1728+0x58>
    80001e7e:	00004097          	auipc	ra,0x4
    80001e82:	004080e7          	jalr	4(ra) # 80005e82 <panic>
    if(killed(p))
    80001e86:	00000097          	auipc	ra,0x0
    80001e8a:	ab6080e7          	jalr	-1354(ra) # 8000193c <killed>
    80001e8e:	e921                	bnez	a0,80001ede <usertrap+0xc0>
    p->trapframe->epc += 4;
    80001e90:	6cb8                	ld	a4,88(s1)
    80001e92:	6f1c                	ld	a5,24(a4)
    80001e94:	0791                	addi	a5,a5,4
    80001e96:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e98:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001e9c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ea0:	10079073          	csrw	sstatus,a5
    syscall();
    80001ea4:	00000097          	auipc	ra,0x0
    80001ea8:	2d4080e7          	jalr	724(ra) # 80002178 <syscall>
  if(killed(p))
    80001eac:	8526                	mv	a0,s1
    80001eae:	00000097          	auipc	ra,0x0
    80001eb2:	a8e080e7          	jalr	-1394(ra) # 8000193c <killed>
    80001eb6:	c911                	beqz	a0,80001eca <usertrap+0xac>
    80001eb8:	4901                	li	s2,0
    exit(-1);
    80001eba:	557d                	li	a0,-1
    80001ebc:	00000097          	auipc	ra,0x0
    80001ec0:	90c080e7          	jalr	-1780(ra) # 800017c8 <exit>
  if(which_dev == 2)
    80001ec4:	4789                	li	a5,2
    80001ec6:	04f90f63          	beq	s2,a5,80001f24 <usertrap+0x106>
  usertrapret();
    80001eca:	00000097          	auipc	ra,0x0
    80001ece:	dd6080e7          	jalr	-554(ra) # 80001ca0 <usertrapret>
}
    80001ed2:	60e2                	ld	ra,24(sp)
    80001ed4:	6442                	ld	s0,16(sp)
    80001ed6:	64a2                	ld	s1,8(sp)
    80001ed8:	6902                	ld	s2,0(sp)
    80001eda:	6105                	addi	sp,sp,32
    80001edc:	8082                	ret
      exit(-1);
    80001ede:	557d                	li	a0,-1
    80001ee0:	00000097          	auipc	ra,0x0
    80001ee4:	8e8080e7          	jalr	-1816(ra) # 800017c8 <exit>
    80001ee8:	b765                	j	80001e90 <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001eea:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001eee:	5890                	lw	a2,48(s1)
    80001ef0:	00006517          	auipc	a0,0x6
    80001ef4:	3f050513          	addi	a0,a0,1008 # 800082e0 <states.1728+0x78>
    80001ef8:	00004097          	auipc	ra,0x4
    80001efc:	fd4080e7          	jalr	-44(ra) # 80005ecc <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f00:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f04:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001f08:	00006517          	auipc	a0,0x6
    80001f0c:	40850513          	addi	a0,a0,1032 # 80008310 <states.1728+0xa8>
    80001f10:	00004097          	auipc	ra,0x4
    80001f14:	fbc080e7          	jalr	-68(ra) # 80005ecc <printf>
    setkilled(p);
    80001f18:	8526                	mv	a0,s1
    80001f1a:	00000097          	auipc	ra,0x0
    80001f1e:	9f6080e7          	jalr	-1546(ra) # 80001910 <setkilled>
    80001f22:	b769                	j	80001eac <usertrap+0x8e>
    yield();
    80001f24:	fffff097          	auipc	ra,0xfffff
    80001f28:	734080e7          	jalr	1844(ra) # 80001658 <yield>
    80001f2c:	bf79                	j	80001eca <usertrap+0xac>

0000000080001f2e <kerneltrap>:
{
    80001f2e:	7179                	addi	sp,sp,-48
    80001f30:	f406                	sd	ra,40(sp)
    80001f32:	f022                	sd	s0,32(sp)
    80001f34:	ec26                	sd	s1,24(sp)
    80001f36:	e84a                	sd	s2,16(sp)
    80001f38:	e44e                	sd	s3,8(sp)
    80001f3a:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f3c:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f40:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001f44:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001f48:	1004f793          	andi	a5,s1,256
    80001f4c:	cb85                	beqz	a5,80001f7c <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f4e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001f52:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001f54:	ef85                	bnez	a5,80001f8c <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001f56:	00000097          	auipc	ra,0x0
    80001f5a:	e26080e7          	jalr	-474(ra) # 80001d7c <devintr>
    80001f5e:	cd1d                	beqz	a0,80001f9c <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f60:	4789                	li	a5,2
    80001f62:	06f50a63          	beq	a0,a5,80001fd6 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001f66:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f6a:	10049073          	csrw	sstatus,s1
}
    80001f6e:	70a2                	ld	ra,40(sp)
    80001f70:	7402                	ld	s0,32(sp)
    80001f72:	64e2                	ld	s1,24(sp)
    80001f74:	6942                	ld	s2,16(sp)
    80001f76:	69a2                	ld	s3,8(sp)
    80001f78:	6145                	addi	sp,sp,48
    80001f7a:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001f7c:	00006517          	auipc	a0,0x6
    80001f80:	3b450513          	addi	a0,a0,948 # 80008330 <states.1728+0xc8>
    80001f84:	00004097          	auipc	ra,0x4
    80001f88:	efe080e7          	jalr	-258(ra) # 80005e82 <panic>
    panic("kerneltrap: interrupts enabled");
    80001f8c:	00006517          	auipc	a0,0x6
    80001f90:	3cc50513          	addi	a0,a0,972 # 80008358 <states.1728+0xf0>
    80001f94:	00004097          	auipc	ra,0x4
    80001f98:	eee080e7          	jalr	-274(ra) # 80005e82 <panic>
    printf("scause %p\n", scause);
    80001f9c:	85ce                	mv	a1,s3
    80001f9e:	00006517          	auipc	a0,0x6
    80001fa2:	3da50513          	addi	a0,a0,986 # 80008378 <states.1728+0x110>
    80001fa6:	00004097          	auipc	ra,0x4
    80001faa:	f26080e7          	jalr	-218(ra) # 80005ecc <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001fae:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001fb2:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001fb6:	00006517          	auipc	a0,0x6
    80001fba:	3d250513          	addi	a0,a0,978 # 80008388 <states.1728+0x120>
    80001fbe:	00004097          	auipc	ra,0x4
    80001fc2:	f0e080e7          	jalr	-242(ra) # 80005ecc <printf>
    panic("kerneltrap");
    80001fc6:	00006517          	auipc	a0,0x6
    80001fca:	3da50513          	addi	a0,a0,986 # 800083a0 <states.1728+0x138>
    80001fce:	00004097          	auipc	ra,0x4
    80001fd2:	eb4080e7          	jalr	-332(ra) # 80005e82 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001fd6:	fffff097          	auipc	ra,0xfffff
    80001fda:	f5e080e7          	jalr	-162(ra) # 80000f34 <myproc>
    80001fde:	d541                	beqz	a0,80001f66 <kerneltrap+0x38>
    80001fe0:	fffff097          	auipc	ra,0xfffff
    80001fe4:	f54080e7          	jalr	-172(ra) # 80000f34 <myproc>
    80001fe8:	4d18                	lw	a4,24(a0)
    80001fea:	4791                	li	a5,4
    80001fec:	f6f71de3          	bne	a4,a5,80001f66 <kerneltrap+0x38>
    yield();
    80001ff0:	fffff097          	auipc	ra,0xfffff
    80001ff4:	668080e7          	jalr	1640(ra) # 80001658 <yield>
    80001ff8:	b7bd                	j	80001f66 <kerneltrap+0x38>

0000000080001ffa <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001ffa:	1101                	addi	sp,sp,-32
    80001ffc:	ec06                	sd	ra,24(sp)
    80001ffe:	e822                	sd	s0,16(sp)
    80002000:	e426                	sd	s1,8(sp)
    80002002:	1000                	addi	s0,sp,32
    80002004:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002006:	fffff097          	auipc	ra,0xfffff
    8000200a:	f2e080e7          	jalr	-210(ra) # 80000f34 <myproc>
  switch (n) {
    8000200e:	4795                	li	a5,5
    80002010:	0497e163          	bltu	a5,s1,80002052 <argraw+0x58>
    80002014:	048a                	slli	s1,s1,0x2
    80002016:	00006717          	auipc	a4,0x6
    8000201a:	3c270713          	addi	a4,a4,962 # 800083d8 <states.1728+0x170>
    8000201e:	94ba                	add	s1,s1,a4
    80002020:	409c                	lw	a5,0(s1)
    80002022:	97ba                	add	a5,a5,a4
    80002024:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002026:	6d3c                	ld	a5,88(a0)
    80002028:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    8000202a:	60e2                	ld	ra,24(sp)
    8000202c:	6442                	ld	s0,16(sp)
    8000202e:	64a2                	ld	s1,8(sp)
    80002030:	6105                	addi	sp,sp,32
    80002032:	8082                	ret
    return p->trapframe->a1;
    80002034:	6d3c                	ld	a5,88(a0)
    80002036:	7fa8                	ld	a0,120(a5)
    80002038:	bfcd                	j	8000202a <argraw+0x30>
    return p->trapframe->a2;
    8000203a:	6d3c                	ld	a5,88(a0)
    8000203c:	63c8                	ld	a0,128(a5)
    8000203e:	b7f5                	j	8000202a <argraw+0x30>
    return p->trapframe->a3;
    80002040:	6d3c                	ld	a5,88(a0)
    80002042:	67c8                	ld	a0,136(a5)
    80002044:	b7dd                	j	8000202a <argraw+0x30>
    return p->trapframe->a4;
    80002046:	6d3c                	ld	a5,88(a0)
    80002048:	6bc8                	ld	a0,144(a5)
    8000204a:	b7c5                	j	8000202a <argraw+0x30>
    return p->trapframe->a5;
    8000204c:	6d3c                	ld	a5,88(a0)
    8000204e:	6fc8                	ld	a0,152(a5)
    80002050:	bfe9                	j	8000202a <argraw+0x30>
  panic("argraw");
    80002052:	00006517          	auipc	a0,0x6
    80002056:	35e50513          	addi	a0,a0,862 # 800083b0 <states.1728+0x148>
    8000205a:	00004097          	auipc	ra,0x4
    8000205e:	e28080e7          	jalr	-472(ra) # 80005e82 <panic>

0000000080002062 <fetchaddr>:
{
    80002062:	1101                	addi	sp,sp,-32
    80002064:	ec06                	sd	ra,24(sp)
    80002066:	e822                	sd	s0,16(sp)
    80002068:	e426                	sd	s1,8(sp)
    8000206a:	e04a                	sd	s2,0(sp)
    8000206c:	1000                	addi	s0,sp,32
    8000206e:	84aa                	mv	s1,a0
    80002070:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002072:	fffff097          	auipc	ra,0xfffff
    80002076:	ec2080e7          	jalr	-318(ra) # 80000f34 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    8000207a:	653c                	ld	a5,72(a0)
    8000207c:	02f4f863          	bgeu	s1,a5,800020ac <fetchaddr+0x4a>
    80002080:	00848713          	addi	a4,s1,8
    80002084:	02e7e663          	bltu	a5,a4,800020b0 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002088:	46a1                	li	a3,8
    8000208a:	8626                	mv	a2,s1
    8000208c:	85ca                	mv	a1,s2
    8000208e:	6928                	ld	a0,80(a0)
    80002090:	fffff097          	auipc	ra,0xfffff
    80002094:	b12080e7          	jalr	-1262(ra) # 80000ba2 <copyin>
    80002098:	00a03533          	snez	a0,a0
    8000209c:	40a00533          	neg	a0,a0
}
    800020a0:	60e2                	ld	ra,24(sp)
    800020a2:	6442                	ld	s0,16(sp)
    800020a4:	64a2                	ld	s1,8(sp)
    800020a6:	6902                	ld	s2,0(sp)
    800020a8:	6105                	addi	sp,sp,32
    800020aa:	8082                	ret
    return -1;
    800020ac:	557d                	li	a0,-1
    800020ae:	bfcd                	j	800020a0 <fetchaddr+0x3e>
    800020b0:	557d                	li	a0,-1
    800020b2:	b7fd                	j	800020a0 <fetchaddr+0x3e>

00000000800020b4 <fetchstr>:
{
    800020b4:	7179                	addi	sp,sp,-48
    800020b6:	f406                	sd	ra,40(sp)
    800020b8:	f022                	sd	s0,32(sp)
    800020ba:	ec26                	sd	s1,24(sp)
    800020bc:	e84a                	sd	s2,16(sp)
    800020be:	e44e                	sd	s3,8(sp)
    800020c0:	1800                	addi	s0,sp,48
    800020c2:	892a                	mv	s2,a0
    800020c4:	84ae                	mv	s1,a1
    800020c6:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    800020c8:	fffff097          	auipc	ra,0xfffff
    800020cc:	e6c080e7          	jalr	-404(ra) # 80000f34 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    800020d0:	86ce                	mv	a3,s3
    800020d2:	864a                	mv	a2,s2
    800020d4:	85a6                	mv	a1,s1
    800020d6:	6928                	ld	a0,80(a0)
    800020d8:	fffff097          	auipc	ra,0xfffff
    800020dc:	b56080e7          	jalr	-1194(ra) # 80000c2e <copyinstr>
    800020e0:	00054e63          	bltz	a0,800020fc <fetchstr+0x48>
  return strlen(buf);
    800020e4:	8526                	mv	a0,s1
    800020e6:	ffffe097          	auipc	ra,0xffffe
    800020ea:	216080e7          	jalr	534(ra) # 800002fc <strlen>
}
    800020ee:	70a2                	ld	ra,40(sp)
    800020f0:	7402                	ld	s0,32(sp)
    800020f2:	64e2                	ld	s1,24(sp)
    800020f4:	6942                	ld	s2,16(sp)
    800020f6:	69a2                	ld	s3,8(sp)
    800020f8:	6145                	addi	sp,sp,48
    800020fa:	8082                	ret
    return -1;
    800020fc:	557d                	li	a0,-1
    800020fe:	bfc5                	j	800020ee <fetchstr+0x3a>

0000000080002100 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80002100:	1101                	addi	sp,sp,-32
    80002102:	ec06                	sd	ra,24(sp)
    80002104:	e822                	sd	s0,16(sp)
    80002106:	e426                	sd	s1,8(sp)
    80002108:	1000                	addi	s0,sp,32
    8000210a:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000210c:	00000097          	auipc	ra,0x0
    80002110:	eee080e7          	jalr	-274(ra) # 80001ffa <argraw>
    80002114:	c088                	sw	a0,0(s1)
}
    80002116:	60e2                	ld	ra,24(sp)
    80002118:	6442                	ld	s0,16(sp)
    8000211a:	64a2                	ld	s1,8(sp)
    8000211c:	6105                	addi	sp,sp,32
    8000211e:	8082                	ret

0000000080002120 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80002120:	1101                	addi	sp,sp,-32
    80002122:	ec06                	sd	ra,24(sp)
    80002124:	e822                	sd	s0,16(sp)
    80002126:	e426                	sd	s1,8(sp)
    80002128:	1000                	addi	s0,sp,32
    8000212a:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000212c:	00000097          	auipc	ra,0x0
    80002130:	ece080e7          	jalr	-306(ra) # 80001ffa <argraw>
    80002134:	e088                	sd	a0,0(s1)
}
    80002136:	60e2                	ld	ra,24(sp)
    80002138:	6442                	ld	s0,16(sp)
    8000213a:	64a2                	ld	s1,8(sp)
    8000213c:	6105                	addi	sp,sp,32
    8000213e:	8082                	ret

0000000080002140 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002140:	7179                	addi	sp,sp,-48
    80002142:	f406                	sd	ra,40(sp)
    80002144:	f022                	sd	s0,32(sp)
    80002146:	ec26                	sd	s1,24(sp)
    80002148:	e84a                	sd	s2,16(sp)
    8000214a:	1800                	addi	s0,sp,48
    8000214c:	84ae                	mv	s1,a1
    8000214e:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80002150:	fd840593          	addi	a1,s0,-40
    80002154:	00000097          	auipc	ra,0x0
    80002158:	fcc080e7          	jalr	-52(ra) # 80002120 <argaddr>
  return fetchstr(addr, buf, max);
    8000215c:	864a                	mv	a2,s2
    8000215e:	85a6                	mv	a1,s1
    80002160:	fd843503          	ld	a0,-40(s0)
    80002164:	00000097          	auipc	ra,0x0
    80002168:	f50080e7          	jalr	-176(ra) # 800020b4 <fetchstr>
}
    8000216c:	70a2                	ld	ra,40(sp)
    8000216e:	7402                	ld	s0,32(sp)
    80002170:	64e2                	ld	s1,24(sp)
    80002172:	6942                	ld	s2,16(sp)
    80002174:	6145                	addi	sp,sp,48
    80002176:	8082                	ret

0000000080002178 <syscall>:



void
syscall(void)
{
    80002178:	1101                	addi	sp,sp,-32
    8000217a:	ec06                	sd	ra,24(sp)
    8000217c:	e822                	sd	s0,16(sp)
    8000217e:	e426                	sd	s1,8(sp)
    80002180:	e04a                	sd	s2,0(sp)
    80002182:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002184:	fffff097          	auipc	ra,0xfffff
    80002188:	db0080e7          	jalr	-592(ra) # 80000f34 <myproc>
    8000218c:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    8000218e:	05853903          	ld	s2,88(a0)
    80002192:	0a893783          	ld	a5,168(s2)
    80002196:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000219a:	37fd                	addiw	a5,a5,-1
    8000219c:	4775                	li	a4,29
    8000219e:	00f76f63          	bltu	a4,a5,800021bc <syscall+0x44>
    800021a2:	00369713          	slli	a4,a3,0x3
    800021a6:	00006797          	auipc	a5,0x6
    800021aa:	24a78793          	addi	a5,a5,586 # 800083f0 <syscalls>
    800021ae:	97ba                	add	a5,a5,a4
    800021b0:	639c                	ld	a5,0(a5)
    800021b2:	c789                	beqz	a5,800021bc <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    800021b4:	9782                	jalr	a5
    800021b6:	06a93823          	sd	a0,112(s2)
    800021ba:	a839                	j	800021d8 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800021bc:	15848613          	addi	a2,s1,344
    800021c0:	588c                	lw	a1,48(s1)
    800021c2:	00006517          	auipc	a0,0x6
    800021c6:	1f650513          	addi	a0,a0,502 # 800083b8 <states.1728+0x150>
    800021ca:	00004097          	auipc	ra,0x4
    800021ce:	d02080e7          	jalr	-766(ra) # 80005ecc <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800021d2:	6cbc                	ld	a5,88(s1)
    800021d4:	577d                	li	a4,-1
    800021d6:	fbb8                	sd	a4,112(a5)
  }
}
    800021d8:	60e2                	ld	ra,24(sp)
    800021da:	6442                	ld	s0,16(sp)
    800021dc:	64a2                	ld	s1,8(sp)
    800021de:	6902                	ld	s2,0(sp)
    800021e0:	6105                	addi	sp,sp,32
    800021e2:	8082                	ret

00000000800021e4 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    800021e4:	1101                	addi	sp,sp,-32
    800021e6:	ec06                	sd	ra,24(sp)
    800021e8:	e822                	sd	s0,16(sp)
    800021ea:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    800021ec:	fec40593          	addi	a1,s0,-20
    800021f0:	4501                	li	a0,0
    800021f2:	00000097          	auipc	ra,0x0
    800021f6:	f0e080e7          	jalr	-242(ra) # 80002100 <argint>
  exit(n);
    800021fa:	fec42503          	lw	a0,-20(s0)
    800021fe:	fffff097          	auipc	ra,0xfffff
    80002202:	5ca080e7          	jalr	1482(ra) # 800017c8 <exit>
  return 0;  // not reached
}
    80002206:	4501                	li	a0,0
    80002208:	60e2                	ld	ra,24(sp)
    8000220a:	6442                	ld	s0,16(sp)
    8000220c:	6105                	addi	sp,sp,32
    8000220e:	8082                	ret

0000000080002210 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002210:	1141                	addi	sp,sp,-16
    80002212:	e406                	sd	ra,8(sp)
    80002214:	e022                	sd	s0,0(sp)
    80002216:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002218:	fffff097          	auipc	ra,0xfffff
    8000221c:	d1c080e7          	jalr	-740(ra) # 80000f34 <myproc>
}
    80002220:	5908                	lw	a0,48(a0)
    80002222:	60a2                	ld	ra,8(sp)
    80002224:	6402                	ld	s0,0(sp)
    80002226:	0141                	addi	sp,sp,16
    80002228:	8082                	ret

000000008000222a <sys_fork>:

uint64
sys_fork(void)
{
    8000222a:	1141                	addi	sp,sp,-16
    8000222c:	e406                	sd	ra,8(sp)
    8000222e:	e022                	sd	s0,0(sp)
    80002230:	0800                	addi	s0,sp,16
  return fork();
    80002232:	fffff097          	auipc	ra,0xfffff
    80002236:	174080e7          	jalr	372(ra) # 800013a6 <fork>
}
    8000223a:	60a2                	ld	ra,8(sp)
    8000223c:	6402                	ld	s0,0(sp)
    8000223e:	0141                	addi	sp,sp,16
    80002240:	8082                	ret

0000000080002242 <sys_wait>:

uint64
sys_wait(void)
{
    80002242:	1101                	addi	sp,sp,-32
    80002244:	ec06                	sd	ra,24(sp)
    80002246:	e822                	sd	s0,16(sp)
    80002248:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    8000224a:	fe840593          	addi	a1,s0,-24
    8000224e:	4501                	li	a0,0
    80002250:	00000097          	auipc	ra,0x0
    80002254:	ed0080e7          	jalr	-304(ra) # 80002120 <argaddr>
  return wait(p);
    80002258:	fe843503          	ld	a0,-24(s0)
    8000225c:	fffff097          	auipc	ra,0xfffff
    80002260:	712080e7          	jalr	1810(ra) # 8000196e <wait>
}
    80002264:	60e2                	ld	ra,24(sp)
    80002266:	6442                	ld	s0,16(sp)
    80002268:	6105                	addi	sp,sp,32
    8000226a:	8082                	ret

000000008000226c <sys_sbrk>:

uint64
sys_sbrk(void)
{
    8000226c:	7179                	addi	sp,sp,-48
    8000226e:	f406                	sd	ra,40(sp)
    80002270:	f022                	sd	s0,32(sp)
    80002272:	ec26                	sd	s1,24(sp)
    80002274:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80002276:	fdc40593          	addi	a1,s0,-36
    8000227a:	4501                	li	a0,0
    8000227c:	00000097          	auipc	ra,0x0
    80002280:	e84080e7          	jalr	-380(ra) # 80002100 <argint>
  addr = myproc()->sz;
    80002284:	fffff097          	auipc	ra,0xfffff
    80002288:	cb0080e7          	jalr	-848(ra) # 80000f34 <myproc>
    8000228c:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    8000228e:	fdc42503          	lw	a0,-36(s0)
    80002292:	fffff097          	auipc	ra,0xfffff
    80002296:	0b8080e7          	jalr	184(ra) # 8000134a <growproc>
    8000229a:	00054863          	bltz	a0,800022aa <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    8000229e:	8526                	mv	a0,s1
    800022a0:	70a2                	ld	ra,40(sp)
    800022a2:	7402                	ld	s0,32(sp)
    800022a4:	64e2                	ld	s1,24(sp)
    800022a6:	6145                	addi	sp,sp,48
    800022a8:	8082                	ret
    return -1;
    800022aa:	54fd                	li	s1,-1
    800022ac:	bfcd                	j	8000229e <sys_sbrk+0x32>

00000000800022ae <sys_sleep>:

uint64
sys_sleep(void)
{
    800022ae:	7139                	addi	sp,sp,-64
    800022b0:	fc06                	sd	ra,56(sp)
    800022b2:	f822                	sd	s0,48(sp)
    800022b4:	f426                	sd	s1,40(sp)
    800022b6:	f04a                	sd	s2,32(sp)
    800022b8:	ec4e                	sd	s3,24(sp)
    800022ba:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;


  argint(0, &n);
    800022bc:	fcc40593          	addi	a1,s0,-52
    800022c0:	4501                	li	a0,0
    800022c2:	00000097          	auipc	ra,0x0
    800022c6:	e3e080e7          	jalr	-450(ra) # 80002100 <argint>
  acquire(&tickslock);
    800022ca:	0000c517          	auipc	a0,0xc
    800022ce:	6d650513          	addi	a0,a0,1750 # 8000e9a0 <tickslock>
    800022d2:	00004097          	auipc	ra,0x4
    800022d6:	0fa080e7          	jalr	250(ra) # 800063cc <acquire>
  ticks0 = ticks;
    800022da:	00006917          	auipc	s2,0x6
    800022de:	65e92903          	lw	s2,1630(s2) # 80008938 <ticks>
  while(ticks - ticks0 < n){
    800022e2:	fcc42783          	lw	a5,-52(s0)
    800022e6:	cf9d                	beqz	a5,80002324 <sys_sleep+0x76>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800022e8:	0000c997          	auipc	s3,0xc
    800022ec:	6b898993          	addi	s3,s3,1720 # 8000e9a0 <tickslock>
    800022f0:	00006497          	auipc	s1,0x6
    800022f4:	64848493          	addi	s1,s1,1608 # 80008938 <ticks>
    if(killed(myproc())){
    800022f8:	fffff097          	auipc	ra,0xfffff
    800022fc:	c3c080e7          	jalr	-964(ra) # 80000f34 <myproc>
    80002300:	fffff097          	auipc	ra,0xfffff
    80002304:	63c080e7          	jalr	1596(ra) # 8000193c <killed>
    80002308:	ed15                	bnez	a0,80002344 <sys_sleep+0x96>
    sleep(&ticks, &tickslock);
    8000230a:	85ce                	mv	a1,s3
    8000230c:	8526                	mv	a0,s1
    8000230e:	fffff097          	auipc	ra,0xfffff
    80002312:	386080e7          	jalr	902(ra) # 80001694 <sleep>
  while(ticks - ticks0 < n){
    80002316:	409c                	lw	a5,0(s1)
    80002318:	412787bb          	subw	a5,a5,s2
    8000231c:	fcc42703          	lw	a4,-52(s0)
    80002320:	fce7ece3          	bltu	a5,a4,800022f8 <sys_sleep+0x4a>
  }
  release(&tickslock);
    80002324:	0000c517          	auipc	a0,0xc
    80002328:	67c50513          	addi	a0,a0,1660 # 8000e9a0 <tickslock>
    8000232c:	00004097          	auipc	ra,0x4
    80002330:	154080e7          	jalr	340(ra) # 80006480 <release>
  return 0;
    80002334:	4501                	li	a0,0
}
    80002336:	70e2                	ld	ra,56(sp)
    80002338:	7442                	ld	s0,48(sp)
    8000233a:	74a2                	ld	s1,40(sp)
    8000233c:	7902                	ld	s2,32(sp)
    8000233e:	69e2                	ld	s3,24(sp)
    80002340:	6121                	addi	sp,sp,64
    80002342:	8082                	ret
      release(&tickslock);
    80002344:	0000c517          	auipc	a0,0xc
    80002348:	65c50513          	addi	a0,a0,1628 # 8000e9a0 <tickslock>
    8000234c:	00004097          	auipc	ra,0x4
    80002350:	134080e7          	jalr	308(ra) # 80006480 <release>
      return -1;
    80002354:	557d                	li	a0,-1
    80002356:	b7c5                	j	80002336 <sys_sleep+0x88>

0000000080002358 <sys_pgaccess>:


#ifdef LAB_PGTBL
#define PGACCESS_MAX_PAGE 32
int sys_pgaccess(void)
{
    80002358:	711d                	addi	sp,sp,-96
    8000235a:	ec86                	sd	ra,88(sp)
    8000235c:	e8a2                	sd	s0,80(sp)
    8000235e:	e4a6                	sd	s1,72(sp)
    80002360:	e0ca                	sd	s2,64(sp)
    80002362:	fc4e                	sd	s3,56(sp)
    80002364:	f852                	sd	s4,48(sp)
    80002366:	f456                	sd	s5,40(sp)
    80002368:	1080                	addi	s0,sp,96
    // lab pgtbl: your code here.
    uint64 va, buf;
    int pgnum;
    
    // 解析参数
    argaddr(0, &va);
    8000236a:	fb840593          	addi	a1,s0,-72
    8000236e:	4501                	li	a0,0
    80002370:	00000097          	auipc	ra,0x0
    80002374:	db0080e7          	jalr	-592(ra) # 80002120 <argaddr>
    argint(1, &pgnum);
    80002378:	fac40593          	addi	a1,s0,-84
    8000237c:	4505                	li	a0,1
    8000237e:	00000097          	auipc	ra,0x0
    80002382:	d82080e7          	jalr	-638(ra) # 80002100 <argint>
    argaddr(2, &buf);
    80002386:	fb040593          	addi	a1,s0,-80
    8000238a:	4509                	li	a0,2
    8000238c:	00000097          	auipc	ra,0x0
    80002390:	d94080e7          	jalr	-620(ra) # 80002120 <argaddr>

    if (pgnum > PGACCESS_MAX_PAGE)
    80002394:	fac42703          	lw	a4,-84(s0)
    80002398:	02000793          	li	a5,32
    8000239c:	00e7d463          	bge	a5,a4,800023a4 <sys_pgaccess+0x4c>
        pgnum = PGACCESS_MAX_PAGE;
    800023a0:	faf42623          	sw	a5,-84(s0)

    struct proc *p = myproc();
    800023a4:	fffff097          	auipc	ra,0xfffff
    800023a8:	b90080e7          	jalr	-1136(ra) # 80000f34 <myproc>
    800023ac:	8a2a                	mv	s4,a0
    if (!p) {
    800023ae:	c559                	beqz	a0,8000243c <sys_pgaccess+0xe4>
        return -1;
    }

    pagetable_t pgtbl = p->pagetable;
    800023b0:	05053983          	ld	s3,80(a0)
    if (!pgtbl) {
    800023b4:	08098663          	beqz	s3,80002440 <sys_pgaccess+0xe8>
        return -1;
    }
	
    uint64 mask = 0; // 位掩码
    800023b8:	fa043023          	sd	zero,-96(s0)
    for (int i = 0; i < pgnum; i++) {
    800023bc:	fac42783          	lw	a5,-84(s0)
    800023c0:	04f05963          	blez	a5,80002412 <sys_pgaccess+0xba>
    800023c4:	4481                	li	s1,0
        pte_t *pte = walk(pgtbl, va + i * PGSIZE, 0); // 访问PTE，检查
        if (*pte & PTE_A) {
            *pte &= (~PTE_A); // 复位
            mask |= (1 << i); // 标注第i个页是否被访问过
    800023c6:	4a85                	li	s5,1
    800023c8:	a801                	j	800023d8 <sys_pgaccess+0x80>
    for (int i = 0; i < pgnum; i++) {
    800023ca:	0485                	addi	s1,s1,1
    800023cc:	fac42703          	lw	a4,-84(s0)
    800023d0:	0004879b          	sext.w	a5,s1
    800023d4:	02e7df63          	bge	a5,a4,80002412 <sys_pgaccess+0xba>
    800023d8:	0004891b          	sext.w	s2,s1
        pte_t *pte = walk(pgtbl, va + i * PGSIZE, 0); // 访问PTE，检查
    800023dc:	00c49593          	slli	a1,s1,0xc
    800023e0:	4601                	li	a2,0
    800023e2:	fb843783          	ld	a5,-72(s0)
    800023e6:	95be                	add	a1,a1,a5
    800023e8:	854e                	mv	a0,s3
    800023ea:	ffffe097          	auipc	ra,0xffffe
    800023ee:	07a080e7          	jalr	122(ra) # 80000464 <walk>
        if (*pte & PTE_A) {
    800023f2:	611c                	ld	a5,0(a0)
    800023f4:	0407f713          	andi	a4,a5,64
    800023f8:	db69                	beqz	a4,800023ca <sys_pgaccess+0x72>
            *pte &= (~PTE_A); // 复位
    800023fa:	fbf7f793          	andi	a5,a5,-65
    800023fe:	e11c                	sd	a5,0(a0)
            mask |= (1 << i); // 标注第i个页是否被访问过
    80002400:	012a993b          	sllw	s2,s5,s2
    80002404:	fa043783          	ld	a5,-96(s0)
    80002408:	0127e933          	or	s2,a5,s2
    8000240c:	fb243023          	sd	s2,-96(s0)
    80002410:	bf6d                	j	800023ca <sys_pgaccess+0x72>
        }
    }
	
    // 复制到用户栈区
    copyout(p->pagetable, buf, (char *)&mask, sizeof(mask));
    80002412:	46a1                	li	a3,8
    80002414:	fa040613          	addi	a2,s0,-96
    80002418:	fb043583          	ld	a1,-80(s0)
    8000241c:	050a3503          	ld	a0,80(s4)
    80002420:	ffffe097          	auipc	ra,0xffffe
    80002424:	6f6080e7          	jalr	1782(ra) # 80000b16 <copyout>

    return 0;
    80002428:	4501                	li	a0,0
}
    8000242a:	60e6                	ld	ra,88(sp)
    8000242c:	6446                	ld	s0,80(sp)
    8000242e:	64a6                	ld	s1,72(sp)
    80002430:	6906                	ld	s2,64(sp)
    80002432:	79e2                	ld	s3,56(sp)
    80002434:	7a42                	ld	s4,48(sp)
    80002436:	7aa2                	ld	s5,40(sp)
    80002438:	6125                	addi	sp,sp,96
    8000243a:	8082                	ret
        return -1;
    8000243c:	557d                	li	a0,-1
    8000243e:	b7f5                	j	8000242a <sys_pgaccess+0xd2>
        return -1;
    80002440:	557d                	li	a0,-1
    80002442:	b7e5                	j	8000242a <sys_pgaccess+0xd2>

0000000080002444 <sys_kill>:
#endif

uint64
sys_kill(void)
{
    80002444:	1101                	addi	sp,sp,-32
    80002446:	ec06                	sd	ra,24(sp)
    80002448:	e822                	sd	s0,16(sp)
    8000244a:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    8000244c:	fec40593          	addi	a1,s0,-20
    80002450:	4501                	li	a0,0
    80002452:	00000097          	auipc	ra,0x0
    80002456:	cae080e7          	jalr	-850(ra) # 80002100 <argint>
  return kill(pid);
    8000245a:	fec42503          	lw	a0,-20(s0)
    8000245e:	fffff097          	auipc	ra,0xfffff
    80002462:	440080e7          	jalr	1088(ra) # 8000189e <kill>
}
    80002466:	60e2                	ld	ra,24(sp)
    80002468:	6442                	ld	s0,16(sp)
    8000246a:	6105                	addi	sp,sp,32
    8000246c:	8082                	ret

000000008000246e <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    8000246e:	1101                	addi	sp,sp,-32
    80002470:	ec06                	sd	ra,24(sp)
    80002472:	e822                	sd	s0,16(sp)
    80002474:	e426                	sd	s1,8(sp)
    80002476:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002478:	0000c517          	auipc	a0,0xc
    8000247c:	52850513          	addi	a0,a0,1320 # 8000e9a0 <tickslock>
    80002480:	00004097          	auipc	ra,0x4
    80002484:	f4c080e7          	jalr	-180(ra) # 800063cc <acquire>
  xticks = ticks;
    80002488:	00006497          	auipc	s1,0x6
    8000248c:	4b04a483          	lw	s1,1200(s1) # 80008938 <ticks>
  release(&tickslock);
    80002490:	0000c517          	auipc	a0,0xc
    80002494:	51050513          	addi	a0,a0,1296 # 8000e9a0 <tickslock>
    80002498:	00004097          	auipc	ra,0x4
    8000249c:	fe8080e7          	jalr	-24(ra) # 80006480 <release>
  return xticks;
}
    800024a0:	02049513          	slli	a0,s1,0x20
    800024a4:	9101                	srli	a0,a0,0x20
    800024a6:	60e2                	ld	ra,24(sp)
    800024a8:	6442                	ld	s0,16(sp)
    800024aa:	64a2                	ld	s1,8(sp)
    800024ac:	6105                	addi	sp,sp,32
    800024ae:	8082                	ret

00000000800024b0 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800024b0:	7179                	addi	sp,sp,-48
    800024b2:	f406                	sd	ra,40(sp)
    800024b4:	f022                	sd	s0,32(sp)
    800024b6:	ec26                	sd	s1,24(sp)
    800024b8:	e84a                	sd	s2,16(sp)
    800024ba:	e44e                	sd	s3,8(sp)
    800024bc:	e052                	sd	s4,0(sp)
    800024be:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800024c0:	00006597          	auipc	a1,0x6
    800024c4:	02858593          	addi	a1,a1,40 # 800084e8 <syscalls+0xf8>
    800024c8:	0000c517          	auipc	a0,0xc
    800024cc:	4f050513          	addi	a0,a0,1264 # 8000e9b8 <bcache>
    800024d0:	00004097          	auipc	ra,0x4
    800024d4:	e6c080e7          	jalr	-404(ra) # 8000633c <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800024d8:	00014797          	auipc	a5,0x14
    800024dc:	4e078793          	addi	a5,a5,1248 # 800169b8 <bcache+0x8000>
    800024e0:	00014717          	auipc	a4,0x14
    800024e4:	74070713          	addi	a4,a4,1856 # 80016c20 <bcache+0x8268>
    800024e8:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800024ec:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800024f0:	0000c497          	auipc	s1,0xc
    800024f4:	4e048493          	addi	s1,s1,1248 # 8000e9d0 <bcache+0x18>
    b->next = bcache.head.next;
    800024f8:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800024fa:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800024fc:	00006a17          	auipc	s4,0x6
    80002500:	ff4a0a13          	addi	s4,s4,-12 # 800084f0 <syscalls+0x100>
    b->next = bcache.head.next;
    80002504:	2b893783          	ld	a5,696(s2)
    80002508:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000250a:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000250e:	85d2                	mv	a1,s4
    80002510:	01048513          	addi	a0,s1,16
    80002514:	00001097          	auipc	ra,0x1
    80002518:	4c4080e7          	jalr	1220(ra) # 800039d8 <initsleeplock>
    bcache.head.next->prev = b;
    8000251c:	2b893783          	ld	a5,696(s2)
    80002520:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002522:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002526:	45848493          	addi	s1,s1,1112
    8000252a:	fd349de3          	bne	s1,s3,80002504 <binit+0x54>
  }
}
    8000252e:	70a2                	ld	ra,40(sp)
    80002530:	7402                	ld	s0,32(sp)
    80002532:	64e2                	ld	s1,24(sp)
    80002534:	6942                	ld	s2,16(sp)
    80002536:	69a2                	ld	s3,8(sp)
    80002538:	6a02                	ld	s4,0(sp)
    8000253a:	6145                	addi	sp,sp,48
    8000253c:	8082                	ret

000000008000253e <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000253e:	7179                	addi	sp,sp,-48
    80002540:	f406                	sd	ra,40(sp)
    80002542:	f022                	sd	s0,32(sp)
    80002544:	ec26                	sd	s1,24(sp)
    80002546:	e84a                	sd	s2,16(sp)
    80002548:	e44e                	sd	s3,8(sp)
    8000254a:	1800                	addi	s0,sp,48
    8000254c:	89aa                	mv	s3,a0
    8000254e:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    80002550:	0000c517          	auipc	a0,0xc
    80002554:	46850513          	addi	a0,a0,1128 # 8000e9b8 <bcache>
    80002558:	00004097          	auipc	ra,0x4
    8000255c:	e74080e7          	jalr	-396(ra) # 800063cc <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002560:	00014497          	auipc	s1,0x14
    80002564:	7104b483          	ld	s1,1808(s1) # 80016c70 <bcache+0x82b8>
    80002568:	00014797          	auipc	a5,0x14
    8000256c:	6b878793          	addi	a5,a5,1720 # 80016c20 <bcache+0x8268>
    80002570:	02f48f63          	beq	s1,a5,800025ae <bread+0x70>
    80002574:	873e                	mv	a4,a5
    80002576:	a021                	j	8000257e <bread+0x40>
    80002578:	68a4                	ld	s1,80(s1)
    8000257a:	02e48a63          	beq	s1,a4,800025ae <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    8000257e:	449c                	lw	a5,8(s1)
    80002580:	ff379ce3          	bne	a5,s3,80002578 <bread+0x3a>
    80002584:	44dc                	lw	a5,12(s1)
    80002586:	ff2799e3          	bne	a5,s2,80002578 <bread+0x3a>
      b->refcnt++;
    8000258a:	40bc                	lw	a5,64(s1)
    8000258c:	2785                	addiw	a5,a5,1
    8000258e:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002590:	0000c517          	auipc	a0,0xc
    80002594:	42850513          	addi	a0,a0,1064 # 8000e9b8 <bcache>
    80002598:	00004097          	auipc	ra,0x4
    8000259c:	ee8080e7          	jalr	-280(ra) # 80006480 <release>
      acquiresleep(&b->lock);
    800025a0:	01048513          	addi	a0,s1,16
    800025a4:	00001097          	auipc	ra,0x1
    800025a8:	46e080e7          	jalr	1134(ra) # 80003a12 <acquiresleep>
      return b;
    800025ac:	a8b9                	j	8000260a <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800025ae:	00014497          	auipc	s1,0x14
    800025b2:	6ba4b483          	ld	s1,1722(s1) # 80016c68 <bcache+0x82b0>
    800025b6:	00014797          	auipc	a5,0x14
    800025ba:	66a78793          	addi	a5,a5,1642 # 80016c20 <bcache+0x8268>
    800025be:	00f48863          	beq	s1,a5,800025ce <bread+0x90>
    800025c2:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800025c4:	40bc                	lw	a5,64(s1)
    800025c6:	cf81                	beqz	a5,800025de <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800025c8:	64a4                	ld	s1,72(s1)
    800025ca:	fee49de3          	bne	s1,a4,800025c4 <bread+0x86>
  panic("bget: no buffers");
    800025ce:	00006517          	auipc	a0,0x6
    800025d2:	f2a50513          	addi	a0,a0,-214 # 800084f8 <syscalls+0x108>
    800025d6:	00004097          	auipc	ra,0x4
    800025da:	8ac080e7          	jalr	-1876(ra) # 80005e82 <panic>
      b->dev = dev;
    800025de:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    800025e2:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    800025e6:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800025ea:	4785                	li	a5,1
    800025ec:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800025ee:	0000c517          	auipc	a0,0xc
    800025f2:	3ca50513          	addi	a0,a0,970 # 8000e9b8 <bcache>
    800025f6:	00004097          	auipc	ra,0x4
    800025fa:	e8a080e7          	jalr	-374(ra) # 80006480 <release>
      acquiresleep(&b->lock);
    800025fe:	01048513          	addi	a0,s1,16
    80002602:	00001097          	auipc	ra,0x1
    80002606:	410080e7          	jalr	1040(ra) # 80003a12 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000260a:	409c                	lw	a5,0(s1)
    8000260c:	cb89                	beqz	a5,8000261e <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000260e:	8526                	mv	a0,s1
    80002610:	70a2                	ld	ra,40(sp)
    80002612:	7402                	ld	s0,32(sp)
    80002614:	64e2                	ld	s1,24(sp)
    80002616:	6942                	ld	s2,16(sp)
    80002618:	69a2                	ld	s3,8(sp)
    8000261a:	6145                	addi	sp,sp,48
    8000261c:	8082                	ret
    virtio_disk_rw(b, 0);
    8000261e:	4581                	li	a1,0
    80002620:	8526                	mv	a0,s1
    80002622:	00003097          	auipc	ra,0x3
    80002626:	ff6080e7          	jalr	-10(ra) # 80005618 <virtio_disk_rw>
    b->valid = 1;
    8000262a:	4785                	li	a5,1
    8000262c:	c09c                	sw	a5,0(s1)
  return b;
    8000262e:	b7c5                	j	8000260e <bread+0xd0>

0000000080002630 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002630:	1101                	addi	sp,sp,-32
    80002632:	ec06                	sd	ra,24(sp)
    80002634:	e822                	sd	s0,16(sp)
    80002636:	e426                	sd	s1,8(sp)
    80002638:	1000                	addi	s0,sp,32
    8000263a:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000263c:	0541                	addi	a0,a0,16
    8000263e:	00001097          	auipc	ra,0x1
    80002642:	46e080e7          	jalr	1134(ra) # 80003aac <holdingsleep>
    80002646:	cd01                	beqz	a0,8000265e <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002648:	4585                	li	a1,1
    8000264a:	8526                	mv	a0,s1
    8000264c:	00003097          	auipc	ra,0x3
    80002650:	fcc080e7          	jalr	-52(ra) # 80005618 <virtio_disk_rw>
}
    80002654:	60e2                	ld	ra,24(sp)
    80002656:	6442                	ld	s0,16(sp)
    80002658:	64a2                	ld	s1,8(sp)
    8000265a:	6105                	addi	sp,sp,32
    8000265c:	8082                	ret
    panic("bwrite");
    8000265e:	00006517          	auipc	a0,0x6
    80002662:	eb250513          	addi	a0,a0,-334 # 80008510 <syscalls+0x120>
    80002666:	00004097          	auipc	ra,0x4
    8000266a:	81c080e7          	jalr	-2020(ra) # 80005e82 <panic>

000000008000266e <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000266e:	1101                	addi	sp,sp,-32
    80002670:	ec06                	sd	ra,24(sp)
    80002672:	e822                	sd	s0,16(sp)
    80002674:	e426                	sd	s1,8(sp)
    80002676:	e04a                	sd	s2,0(sp)
    80002678:	1000                	addi	s0,sp,32
    8000267a:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000267c:	01050913          	addi	s2,a0,16
    80002680:	854a                	mv	a0,s2
    80002682:	00001097          	auipc	ra,0x1
    80002686:	42a080e7          	jalr	1066(ra) # 80003aac <holdingsleep>
    8000268a:	c92d                	beqz	a0,800026fc <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    8000268c:	854a                	mv	a0,s2
    8000268e:	00001097          	auipc	ra,0x1
    80002692:	3da080e7          	jalr	986(ra) # 80003a68 <releasesleep>

  acquire(&bcache.lock);
    80002696:	0000c517          	auipc	a0,0xc
    8000269a:	32250513          	addi	a0,a0,802 # 8000e9b8 <bcache>
    8000269e:	00004097          	auipc	ra,0x4
    800026a2:	d2e080e7          	jalr	-722(ra) # 800063cc <acquire>
  b->refcnt--;
    800026a6:	40bc                	lw	a5,64(s1)
    800026a8:	37fd                	addiw	a5,a5,-1
    800026aa:	0007871b          	sext.w	a4,a5
    800026ae:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800026b0:	eb05                	bnez	a4,800026e0 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800026b2:	68bc                	ld	a5,80(s1)
    800026b4:	64b8                	ld	a4,72(s1)
    800026b6:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    800026b8:	64bc                	ld	a5,72(s1)
    800026ba:	68b8                	ld	a4,80(s1)
    800026bc:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800026be:	00014797          	auipc	a5,0x14
    800026c2:	2fa78793          	addi	a5,a5,762 # 800169b8 <bcache+0x8000>
    800026c6:	2b87b703          	ld	a4,696(a5)
    800026ca:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800026cc:	00014717          	auipc	a4,0x14
    800026d0:	55470713          	addi	a4,a4,1364 # 80016c20 <bcache+0x8268>
    800026d4:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800026d6:	2b87b703          	ld	a4,696(a5)
    800026da:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800026dc:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800026e0:	0000c517          	auipc	a0,0xc
    800026e4:	2d850513          	addi	a0,a0,728 # 8000e9b8 <bcache>
    800026e8:	00004097          	auipc	ra,0x4
    800026ec:	d98080e7          	jalr	-616(ra) # 80006480 <release>
}
    800026f0:	60e2                	ld	ra,24(sp)
    800026f2:	6442                	ld	s0,16(sp)
    800026f4:	64a2                	ld	s1,8(sp)
    800026f6:	6902                	ld	s2,0(sp)
    800026f8:	6105                	addi	sp,sp,32
    800026fa:	8082                	ret
    panic("brelse");
    800026fc:	00006517          	auipc	a0,0x6
    80002700:	e1c50513          	addi	a0,a0,-484 # 80008518 <syscalls+0x128>
    80002704:	00003097          	auipc	ra,0x3
    80002708:	77e080e7          	jalr	1918(ra) # 80005e82 <panic>

000000008000270c <bpin>:

void
bpin(struct buf *b) {
    8000270c:	1101                	addi	sp,sp,-32
    8000270e:	ec06                	sd	ra,24(sp)
    80002710:	e822                	sd	s0,16(sp)
    80002712:	e426                	sd	s1,8(sp)
    80002714:	1000                	addi	s0,sp,32
    80002716:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002718:	0000c517          	auipc	a0,0xc
    8000271c:	2a050513          	addi	a0,a0,672 # 8000e9b8 <bcache>
    80002720:	00004097          	auipc	ra,0x4
    80002724:	cac080e7          	jalr	-852(ra) # 800063cc <acquire>
  b->refcnt++;
    80002728:	40bc                	lw	a5,64(s1)
    8000272a:	2785                	addiw	a5,a5,1
    8000272c:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000272e:	0000c517          	auipc	a0,0xc
    80002732:	28a50513          	addi	a0,a0,650 # 8000e9b8 <bcache>
    80002736:	00004097          	auipc	ra,0x4
    8000273a:	d4a080e7          	jalr	-694(ra) # 80006480 <release>
}
    8000273e:	60e2                	ld	ra,24(sp)
    80002740:	6442                	ld	s0,16(sp)
    80002742:	64a2                	ld	s1,8(sp)
    80002744:	6105                	addi	sp,sp,32
    80002746:	8082                	ret

0000000080002748 <bunpin>:

void
bunpin(struct buf *b) {
    80002748:	1101                	addi	sp,sp,-32
    8000274a:	ec06                	sd	ra,24(sp)
    8000274c:	e822                	sd	s0,16(sp)
    8000274e:	e426                	sd	s1,8(sp)
    80002750:	1000                	addi	s0,sp,32
    80002752:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002754:	0000c517          	auipc	a0,0xc
    80002758:	26450513          	addi	a0,a0,612 # 8000e9b8 <bcache>
    8000275c:	00004097          	auipc	ra,0x4
    80002760:	c70080e7          	jalr	-912(ra) # 800063cc <acquire>
  b->refcnt--;
    80002764:	40bc                	lw	a5,64(s1)
    80002766:	37fd                	addiw	a5,a5,-1
    80002768:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000276a:	0000c517          	auipc	a0,0xc
    8000276e:	24e50513          	addi	a0,a0,590 # 8000e9b8 <bcache>
    80002772:	00004097          	auipc	ra,0x4
    80002776:	d0e080e7          	jalr	-754(ra) # 80006480 <release>
}
    8000277a:	60e2                	ld	ra,24(sp)
    8000277c:	6442                	ld	s0,16(sp)
    8000277e:	64a2                	ld	s1,8(sp)
    80002780:	6105                	addi	sp,sp,32
    80002782:	8082                	ret

0000000080002784 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002784:	1101                	addi	sp,sp,-32
    80002786:	ec06                	sd	ra,24(sp)
    80002788:	e822                	sd	s0,16(sp)
    8000278a:	e426                	sd	s1,8(sp)
    8000278c:	e04a                	sd	s2,0(sp)
    8000278e:	1000                	addi	s0,sp,32
    80002790:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002792:	00d5d59b          	srliw	a1,a1,0xd
    80002796:	00015797          	auipc	a5,0x15
    8000279a:	8fe7a783          	lw	a5,-1794(a5) # 80017094 <sb+0x1c>
    8000279e:	9dbd                	addw	a1,a1,a5
    800027a0:	00000097          	auipc	ra,0x0
    800027a4:	d9e080e7          	jalr	-610(ra) # 8000253e <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800027a8:	0074f713          	andi	a4,s1,7
    800027ac:	4785                	li	a5,1
    800027ae:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800027b2:	14ce                	slli	s1,s1,0x33
    800027b4:	90d9                	srli	s1,s1,0x36
    800027b6:	00950733          	add	a4,a0,s1
    800027ba:	05874703          	lbu	a4,88(a4)
    800027be:	00e7f6b3          	and	a3,a5,a4
    800027c2:	c69d                	beqz	a3,800027f0 <bfree+0x6c>
    800027c4:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800027c6:	94aa                	add	s1,s1,a0
    800027c8:	fff7c793          	not	a5,a5
    800027cc:	8ff9                	and	a5,a5,a4
    800027ce:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    800027d2:	00001097          	auipc	ra,0x1
    800027d6:	120080e7          	jalr	288(ra) # 800038f2 <log_write>
  brelse(bp);
    800027da:	854a                	mv	a0,s2
    800027dc:	00000097          	auipc	ra,0x0
    800027e0:	e92080e7          	jalr	-366(ra) # 8000266e <brelse>
}
    800027e4:	60e2                	ld	ra,24(sp)
    800027e6:	6442                	ld	s0,16(sp)
    800027e8:	64a2                	ld	s1,8(sp)
    800027ea:	6902                	ld	s2,0(sp)
    800027ec:	6105                	addi	sp,sp,32
    800027ee:	8082                	ret
    panic("freeing free block");
    800027f0:	00006517          	auipc	a0,0x6
    800027f4:	d3050513          	addi	a0,a0,-720 # 80008520 <syscalls+0x130>
    800027f8:	00003097          	auipc	ra,0x3
    800027fc:	68a080e7          	jalr	1674(ra) # 80005e82 <panic>

0000000080002800 <balloc>:
{
    80002800:	711d                	addi	sp,sp,-96
    80002802:	ec86                	sd	ra,88(sp)
    80002804:	e8a2                	sd	s0,80(sp)
    80002806:	e4a6                	sd	s1,72(sp)
    80002808:	e0ca                	sd	s2,64(sp)
    8000280a:	fc4e                	sd	s3,56(sp)
    8000280c:	f852                	sd	s4,48(sp)
    8000280e:	f456                	sd	s5,40(sp)
    80002810:	f05a                	sd	s6,32(sp)
    80002812:	ec5e                	sd	s7,24(sp)
    80002814:	e862                	sd	s8,16(sp)
    80002816:	e466                	sd	s9,8(sp)
    80002818:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000281a:	00015797          	auipc	a5,0x15
    8000281e:	8627a783          	lw	a5,-1950(a5) # 8001707c <sb+0x4>
    80002822:	10078163          	beqz	a5,80002924 <balloc+0x124>
    80002826:	8baa                	mv	s7,a0
    80002828:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000282a:	00015b17          	auipc	s6,0x15
    8000282e:	84eb0b13          	addi	s6,s6,-1970 # 80017078 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002832:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002834:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002836:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002838:	6c89                	lui	s9,0x2
    8000283a:	a061                	j	800028c2 <balloc+0xc2>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000283c:	974a                	add	a4,a4,s2
    8000283e:	8fd5                	or	a5,a5,a3
    80002840:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    80002844:	854a                	mv	a0,s2
    80002846:	00001097          	auipc	ra,0x1
    8000284a:	0ac080e7          	jalr	172(ra) # 800038f2 <log_write>
        brelse(bp);
    8000284e:	854a                	mv	a0,s2
    80002850:	00000097          	auipc	ra,0x0
    80002854:	e1e080e7          	jalr	-482(ra) # 8000266e <brelse>
  bp = bread(dev, bno);
    80002858:	85a6                	mv	a1,s1
    8000285a:	855e                	mv	a0,s7
    8000285c:	00000097          	auipc	ra,0x0
    80002860:	ce2080e7          	jalr	-798(ra) # 8000253e <bread>
    80002864:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002866:	40000613          	li	a2,1024
    8000286a:	4581                	li	a1,0
    8000286c:	05850513          	addi	a0,a0,88
    80002870:	ffffe097          	auipc	ra,0xffffe
    80002874:	908080e7          	jalr	-1784(ra) # 80000178 <memset>
  log_write(bp);
    80002878:	854a                	mv	a0,s2
    8000287a:	00001097          	auipc	ra,0x1
    8000287e:	078080e7          	jalr	120(ra) # 800038f2 <log_write>
  brelse(bp);
    80002882:	854a                	mv	a0,s2
    80002884:	00000097          	auipc	ra,0x0
    80002888:	dea080e7          	jalr	-534(ra) # 8000266e <brelse>
}
    8000288c:	8526                	mv	a0,s1
    8000288e:	60e6                	ld	ra,88(sp)
    80002890:	6446                	ld	s0,80(sp)
    80002892:	64a6                	ld	s1,72(sp)
    80002894:	6906                	ld	s2,64(sp)
    80002896:	79e2                	ld	s3,56(sp)
    80002898:	7a42                	ld	s4,48(sp)
    8000289a:	7aa2                	ld	s5,40(sp)
    8000289c:	7b02                	ld	s6,32(sp)
    8000289e:	6be2                	ld	s7,24(sp)
    800028a0:	6c42                	ld	s8,16(sp)
    800028a2:	6ca2                	ld	s9,8(sp)
    800028a4:	6125                	addi	sp,sp,96
    800028a6:	8082                	ret
    brelse(bp);
    800028a8:	854a                	mv	a0,s2
    800028aa:	00000097          	auipc	ra,0x0
    800028ae:	dc4080e7          	jalr	-572(ra) # 8000266e <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800028b2:	015c87bb          	addw	a5,s9,s5
    800028b6:	00078a9b          	sext.w	s5,a5
    800028ba:	004b2703          	lw	a4,4(s6)
    800028be:	06eaf363          	bgeu	s5,a4,80002924 <balloc+0x124>
    bp = bread(dev, BBLOCK(b, sb));
    800028c2:	41fad79b          	sraiw	a5,s5,0x1f
    800028c6:	0137d79b          	srliw	a5,a5,0x13
    800028ca:	015787bb          	addw	a5,a5,s5
    800028ce:	40d7d79b          	sraiw	a5,a5,0xd
    800028d2:	01cb2583          	lw	a1,28(s6)
    800028d6:	9dbd                	addw	a1,a1,a5
    800028d8:	855e                	mv	a0,s7
    800028da:	00000097          	auipc	ra,0x0
    800028de:	c64080e7          	jalr	-924(ra) # 8000253e <bread>
    800028e2:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800028e4:	004b2503          	lw	a0,4(s6)
    800028e8:	000a849b          	sext.w	s1,s5
    800028ec:	8662                	mv	a2,s8
    800028ee:	faa4fde3          	bgeu	s1,a0,800028a8 <balloc+0xa8>
      m = 1 << (bi % 8);
    800028f2:	41f6579b          	sraiw	a5,a2,0x1f
    800028f6:	01d7d69b          	srliw	a3,a5,0x1d
    800028fa:	00c6873b          	addw	a4,a3,a2
    800028fe:	00777793          	andi	a5,a4,7
    80002902:	9f95                	subw	a5,a5,a3
    80002904:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002908:	4037571b          	sraiw	a4,a4,0x3
    8000290c:	00e906b3          	add	a3,s2,a4
    80002910:	0586c683          	lbu	a3,88(a3)
    80002914:	00d7f5b3          	and	a1,a5,a3
    80002918:	d195                	beqz	a1,8000283c <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000291a:	2605                	addiw	a2,a2,1
    8000291c:	2485                	addiw	s1,s1,1
    8000291e:	fd4618e3          	bne	a2,s4,800028ee <balloc+0xee>
    80002922:	b759                	j	800028a8 <balloc+0xa8>
  printf("balloc: out of blocks\n");
    80002924:	00006517          	auipc	a0,0x6
    80002928:	c1450513          	addi	a0,a0,-1004 # 80008538 <syscalls+0x148>
    8000292c:	00003097          	auipc	ra,0x3
    80002930:	5a0080e7          	jalr	1440(ra) # 80005ecc <printf>
  return 0;
    80002934:	4481                	li	s1,0
    80002936:	bf99                	j	8000288c <balloc+0x8c>

0000000080002938 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002938:	7179                	addi	sp,sp,-48
    8000293a:	f406                	sd	ra,40(sp)
    8000293c:	f022                	sd	s0,32(sp)
    8000293e:	ec26                	sd	s1,24(sp)
    80002940:	e84a                	sd	s2,16(sp)
    80002942:	e44e                	sd	s3,8(sp)
    80002944:	e052                	sd	s4,0(sp)
    80002946:	1800                	addi	s0,sp,48
    80002948:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000294a:	47ad                	li	a5,11
    8000294c:	02b7e763          	bltu	a5,a1,8000297a <bmap+0x42>
    if((addr = ip->addrs[bn]) == 0){
    80002950:	02059493          	slli	s1,a1,0x20
    80002954:	9081                	srli	s1,s1,0x20
    80002956:	048a                	slli	s1,s1,0x2
    80002958:	94aa                	add	s1,s1,a0
    8000295a:	0504a903          	lw	s2,80(s1)
    8000295e:	06091e63          	bnez	s2,800029da <bmap+0xa2>
      addr = balloc(ip->dev);
    80002962:	4108                	lw	a0,0(a0)
    80002964:	00000097          	auipc	ra,0x0
    80002968:	e9c080e7          	jalr	-356(ra) # 80002800 <balloc>
    8000296c:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002970:	06090563          	beqz	s2,800029da <bmap+0xa2>
        return 0;
      ip->addrs[bn] = addr;
    80002974:	0524a823          	sw	s2,80(s1)
    80002978:	a08d                	j	800029da <bmap+0xa2>
    }
    return addr;
  }
  bn -= NDIRECT;
    8000297a:	ff45849b          	addiw	s1,a1,-12
    8000297e:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002982:	0ff00793          	li	a5,255
    80002986:	08e7e563          	bltu	a5,a4,80002a10 <bmap+0xd8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    8000298a:	08052903          	lw	s2,128(a0)
    8000298e:	00091d63          	bnez	s2,800029a8 <bmap+0x70>
      addr = balloc(ip->dev);
    80002992:	4108                	lw	a0,0(a0)
    80002994:	00000097          	auipc	ra,0x0
    80002998:	e6c080e7          	jalr	-404(ra) # 80002800 <balloc>
    8000299c:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800029a0:	02090d63          	beqz	s2,800029da <bmap+0xa2>
        return 0;
      ip->addrs[NDIRECT] = addr;
    800029a4:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    800029a8:	85ca                	mv	a1,s2
    800029aa:	0009a503          	lw	a0,0(s3)
    800029ae:	00000097          	auipc	ra,0x0
    800029b2:	b90080e7          	jalr	-1136(ra) # 8000253e <bread>
    800029b6:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800029b8:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800029bc:	02049593          	slli	a1,s1,0x20
    800029c0:	9181                	srli	a1,a1,0x20
    800029c2:	058a                	slli	a1,a1,0x2
    800029c4:	00b784b3          	add	s1,a5,a1
    800029c8:	0004a903          	lw	s2,0(s1)
    800029cc:	02090063          	beqz	s2,800029ec <bmap+0xb4>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800029d0:	8552                	mv	a0,s4
    800029d2:	00000097          	auipc	ra,0x0
    800029d6:	c9c080e7          	jalr	-868(ra) # 8000266e <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800029da:	854a                	mv	a0,s2
    800029dc:	70a2                	ld	ra,40(sp)
    800029de:	7402                	ld	s0,32(sp)
    800029e0:	64e2                	ld	s1,24(sp)
    800029e2:	6942                	ld	s2,16(sp)
    800029e4:	69a2                	ld	s3,8(sp)
    800029e6:	6a02                	ld	s4,0(sp)
    800029e8:	6145                	addi	sp,sp,48
    800029ea:	8082                	ret
      addr = balloc(ip->dev);
    800029ec:	0009a503          	lw	a0,0(s3)
    800029f0:	00000097          	auipc	ra,0x0
    800029f4:	e10080e7          	jalr	-496(ra) # 80002800 <balloc>
    800029f8:	0005091b          	sext.w	s2,a0
      if(addr){
    800029fc:	fc090ae3          	beqz	s2,800029d0 <bmap+0x98>
        a[bn] = addr;
    80002a00:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80002a04:	8552                	mv	a0,s4
    80002a06:	00001097          	auipc	ra,0x1
    80002a0a:	eec080e7          	jalr	-276(ra) # 800038f2 <log_write>
    80002a0e:	b7c9                	j	800029d0 <bmap+0x98>
  panic("bmap: out of range");
    80002a10:	00006517          	auipc	a0,0x6
    80002a14:	b4050513          	addi	a0,a0,-1216 # 80008550 <syscalls+0x160>
    80002a18:	00003097          	auipc	ra,0x3
    80002a1c:	46a080e7          	jalr	1130(ra) # 80005e82 <panic>

0000000080002a20 <iget>:
{
    80002a20:	7179                	addi	sp,sp,-48
    80002a22:	f406                	sd	ra,40(sp)
    80002a24:	f022                	sd	s0,32(sp)
    80002a26:	ec26                	sd	s1,24(sp)
    80002a28:	e84a                	sd	s2,16(sp)
    80002a2a:	e44e                	sd	s3,8(sp)
    80002a2c:	e052                	sd	s4,0(sp)
    80002a2e:	1800                	addi	s0,sp,48
    80002a30:	89aa                	mv	s3,a0
    80002a32:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002a34:	00014517          	auipc	a0,0x14
    80002a38:	66450513          	addi	a0,a0,1636 # 80017098 <itable>
    80002a3c:	00004097          	auipc	ra,0x4
    80002a40:	990080e7          	jalr	-1648(ra) # 800063cc <acquire>
  empty = 0;
    80002a44:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a46:	00014497          	auipc	s1,0x14
    80002a4a:	66a48493          	addi	s1,s1,1642 # 800170b0 <itable+0x18>
    80002a4e:	00016697          	auipc	a3,0x16
    80002a52:	0f268693          	addi	a3,a3,242 # 80018b40 <log>
    80002a56:	a039                	j	80002a64 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002a58:	02090b63          	beqz	s2,80002a8e <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a5c:	08848493          	addi	s1,s1,136
    80002a60:	02d48a63          	beq	s1,a3,80002a94 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002a64:	449c                	lw	a5,8(s1)
    80002a66:	fef059e3          	blez	a5,80002a58 <iget+0x38>
    80002a6a:	4098                	lw	a4,0(s1)
    80002a6c:	ff3716e3          	bne	a4,s3,80002a58 <iget+0x38>
    80002a70:	40d8                	lw	a4,4(s1)
    80002a72:	ff4713e3          	bne	a4,s4,80002a58 <iget+0x38>
      ip->ref++;
    80002a76:	2785                	addiw	a5,a5,1
    80002a78:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002a7a:	00014517          	auipc	a0,0x14
    80002a7e:	61e50513          	addi	a0,a0,1566 # 80017098 <itable>
    80002a82:	00004097          	auipc	ra,0x4
    80002a86:	9fe080e7          	jalr	-1538(ra) # 80006480 <release>
      return ip;
    80002a8a:	8926                	mv	s2,s1
    80002a8c:	a03d                	j	80002aba <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002a8e:	f7f9                	bnez	a5,80002a5c <iget+0x3c>
    80002a90:	8926                	mv	s2,s1
    80002a92:	b7e9                	j	80002a5c <iget+0x3c>
  if(empty == 0)
    80002a94:	02090c63          	beqz	s2,80002acc <iget+0xac>
  ip->dev = dev;
    80002a98:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002a9c:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002aa0:	4785                	li	a5,1
    80002aa2:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002aa6:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002aaa:	00014517          	auipc	a0,0x14
    80002aae:	5ee50513          	addi	a0,a0,1518 # 80017098 <itable>
    80002ab2:	00004097          	auipc	ra,0x4
    80002ab6:	9ce080e7          	jalr	-1586(ra) # 80006480 <release>
}
    80002aba:	854a                	mv	a0,s2
    80002abc:	70a2                	ld	ra,40(sp)
    80002abe:	7402                	ld	s0,32(sp)
    80002ac0:	64e2                	ld	s1,24(sp)
    80002ac2:	6942                	ld	s2,16(sp)
    80002ac4:	69a2                	ld	s3,8(sp)
    80002ac6:	6a02                	ld	s4,0(sp)
    80002ac8:	6145                	addi	sp,sp,48
    80002aca:	8082                	ret
    panic("iget: no inodes");
    80002acc:	00006517          	auipc	a0,0x6
    80002ad0:	a9c50513          	addi	a0,a0,-1380 # 80008568 <syscalls+0x178>
    80002ad4:	00003097          	auipc	ra,0x3
    80002ad8:	3ae080e7          	jalr	942(ra) # 80005e82 <panic>

0000000080002adc <fsinit>:
fsinit(int dev) {
    80002adc:	7179                	addi	sp,sp,-48
    80002ade:	f406                	sd	ra,40(sp)
    80002ae0:	f022                	sd	s0,32(sp)
    80002ae2:	ec26                	sd	s1,24(sp)
    80002ae4:	e84a                	sd	s2,16(sp)
    80002ae6:	e44e                	sd	s3,8(sp)
    80002ae8:	1800                	addi	s0,sp,48
    80002aea:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002aec:	4585                	li	a1,1
    80002aee:	00000097          	auipc	ra,0x0
    80002af2:	a50080e7          	jalr	-1456(ra) # 8000253e <bread>
    80002af6:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002af8:	00014997          	auipc	s3,0x14
    80002afc:	58098993          	addi	s3,s3,1408 # 80017078 <sb>
    80002b00:	02000613          	li	a2,32
    80002b04:	05850593          	addi	a1,a0,88
    80002b08:	854e                	mv	a0,s3
    80002b0a:	ffffd097          	auipc	ra,0xffffd
    80002b0e:	6ce080e7          	jalr	1742(ra) # 800001d8 <memmove>
  brelse(bp);
    80002b12:	8526                	mv	a0,s1
    80002b14:	00000097          	auipc	ra,0x0
    80002b18:	b5a080e7          	jalr	-1190(ra) # 8000266e <brelse>
  if(sb.magic != FSMAGIC)
    80002b1c:	0009a703          	lw	a4,0(s3)
    80002b20:	102037b7          	lui	a5,0x10203
    80002b24:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002b28:	02f71263          	bne	a4,a5,80002b4c <fsinit+0x70>
  initlog(dev, &sb);
    80002b2c:	00014597          	auipc	a1,0x14
    80002b30:	54c58593          	addi	a1,a1,1356 # 80017078 <sb>
    80002b34:	854a                	mv	a0,s2
    80002b36:	00001097          	auipc	ra,0x1
    80002b3a:	b40080e7          	jalr	-1216(ra) # 80003676 <initlog>
}
    80002b3e:	70a2                	ld	ra,40(sp)
    80002b40:	7402                	ld	s0,32(sp)
    80002b42:	64e2                	ld	s1,24(sp)
    80002b44:	6942                	ld	s2,16(sp)
    80002b46:	69a2                	ld	s3,8(sp)
    80002b48:	6145                	addi	sp,sp,48
    80002b4a:	8082                	ret
    panic("invalid file system");
    80002b4c:	00006517          	auipc	a0,0x6
    80002b50:	a2c50513          	addi	a0,a0,-1492 # 80008578 <syscalls+0x188>
    80002b54:	00003097          	auipc	ra,0x3
    80002b58:	32e080e7          	jalr	814(ra) # 80005e82 <panic>

0000000080002b5c <iinit>:
{
    80002b5c:	7179                	addi	sp,sp,-48
    80002b5e:	f406                	sd	ra,40(sp)
    80002b60:	f022                	sd	s0,32(sp)
    80002b62:	ec26                	sd	s1,24(sp)
    80002b64:	e84a                	sd	s2,16(sp)
    80002b66:	e44e                	sd	s3,8(sp)
    80002b68:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002b6a:	00006597          	auipc	a1,0x6
    80002b6e:	a2658593          	addi	a1,a1,-1498 # 80008590 <syscalls+0x1a0>
    80002b72:	00014517          	auipc	a0,0x14
    80002b76:	52650513          	addi	a0,a0,1318 # 80017098 <itable>
    80002b7a:	00003097          	auipc	ra,0x3
    80002b7e:	7c2080e7          	jalr	1986(ra) # 8000633c <initlock>
  for(i = 0; i < NINODE; i++) {
    80002b82:	00014497          	auipc	s1,0x14
    80002b86:	53e48493          	addi	s1,s1,1342 # 800170c0 <itable+0x28>
    80002b8a:	00016997          	auipc	s3,0x16
    80002b8e:	fc698993          	addi	s3,s3,-58 # 80018b50 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002b92:	00006917          	auipc	s2,0x6
    80002b96:	a0690913          	addi	s2,s2,-1530 # 80008598 <syscalls+0x1a8>
    80002b9a:	85ca                	mv	a1,s2
    80002b9c:	8526                	mv	a0,s1
    80002b9e:	00001097          	auipc	ra,0x1
    80002ba2:	e3a080e7          	jalr	-454(ra) # 800039d8 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002ba6:	08848493          	addi	s1,s1,136
    80002baa:	ff3498e3          	bne	s1,s3,80002b9a <iinit+0x3e>
}
    80002bae:	70a2                	ld	ra,40(sp)
    80002bb0:	7402                	ld	s0,32(sp)
    80002bb2:	64e2                	ld	s1,24(sp)
    80002bb4:	6942                	ld	s2,16(sp)
    80002bb6:	69a2                	ld	s3,8(sp)
    80002bb8:	6145                	addi	sp,sp,48
    80002bba:	8082                	ret

0000000080002bbc <ialloc>:
{
    80002bbc:	715d                	addi	sp,sp,-80
    80002bbe:	e486                	sd	ra,72(sp)
    80002bc0:	e0a2                	sd	s0,64(sp)
    80002bc2:	fc26                	sd	s1,56(sp)
    80002bc4:	f84a                	sd	s2,48(sp)
    80002bc6:	f44e                	sd	s3,40(sp)
    80002bc8:	f052                	sd	s4,32(sp)
    80002bca:	ec56                	sd	s5,24(sp)
    80002bcc:	e85a                	sd	s6,16(sp)
    80002bce:	e45e                	sd	s7,8(sp)
    80002bd0:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002bd2:	00014717          	auipc	a4,0x14
    80002bd6:	4b272703          	lw	a4,1202(a4) # 80017084 <sb+0xc>
    80002bda:	4785                	li	a5,1
    80002bdc:	04e7fa63          	bgeu	a5,a4,80002c30 <ialloc+0x74>
    80002be0:	8aaa                	mv	s5,a0
    80002be2:	8bae                	mv	s7,a1
    80002be4:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002be6:	00014a17          	auipc	s4,0x14
    80002bea:	492a0a13          	addi	s4,s4,1170 # 80017078 <sb>
    80002bee:	00048b1b          	sext.w	s6,s1
    80002bf2:	0044d593          	srli	a1,s1,0x4
    80002bf6:	018a2783          	lw	a5,24(s4)
    80002bfa:	9dbd                	addw	a1,a1,a5
    80002bfc:	8556                	mv	a0,s5
    80002bfe:	00000097          	auipc	ra,0x0
    80002c02:	940080e7          	jalr	-1728(ra) # 8000253e <bread>
    80002c06:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002c08:	05850993          	addi	s3,a0,88
    80002c0c:	00f4f793          	andi	a5,s1,15
    80002c10:	079a                	slli	a5,a5,0x6
    80002c12:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002c14:	00099783          	lh	a5,0(s3)
    80002c18:	c3a1                	beqz	a5,80002c58 <ialloc+0x9c>
    brelse(bp);
    80002c1a:	00000097          	auipc	ra,0x0
    80002c1e:	a54080e7          	jalr	-1452(ra) # 8000266e <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002c22:	0485                	addi	s1,s1,1
    80002c24:	00ca2703          	lw	a4,12(s4)
    80002c28:	0004879b          	sext.w	a5,s1
    80002c2c:	fce7e1e3          	bltu	a5,a4,80002bee <ialloc+0x32>
  printf("ialloc: no inodes\n");
    80002c30:	00006517          	auipc	a0,0x6
    80002c34:	97050513          	addi	a0,a0,-1680 # 800085a0 <syscalls+0x1b0>
    80002c38:	00003097          	auipc	ra,0x3
    80002c3c:	294080e7          	jalr	660(ra) # 80005ecc <printf>
  return 0;
    80002c40:	4501                	li	a0,0
}
    80002c42:	60a6                	ld	ra,72(sp)
    80002c44:	6406                	ld	s0,64(sp)
    80002c46:	74e2                	ld	s1,56(sp)
    80002c48:	7942                	ld	s2,48(sp)
    80002c4a:	79a2                	ld	s3,40(sp)
    80002c4c:	7a02                	ld	s4,32(sp)
    80002c4e:	6ae2                	ld	s5,24(sp)
    80002c50:	6b42                	ld	s6,16(sp)
    80002c52:	6ba2                	ld	s7,8(sp)
    80002c54:	6161                	addi	sp,sp,80
    80002c56:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002c58:	04000613          	li	a2,64
    80002c5c:	4581                	li	a1,0
    80002c5e:	854e                	mv	a0,s3
    80002c60:	ffffd097          	auipc	ra,0xffffd
    80002c64:	518080e7          	jalr	1304(ra) # 80000178 <memset>
      dip->type = type;
    80002c68:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002c6c:	854a                	mv	a0,s2
    80002c6e:	00001097          	auipc	ra,0x1
    80002c72:	c84080e7          	jalr	-892(ra) # 800038f2 <log_write>
      brelse(bp);
    80002c76:	854a                	mv	a0,s2
    80002c78:	00000097          	auipc	ra,0x0
    80002c7c:	9f6080e7          	jalr	-1546(ra) # 8000266e <brelse>
      return iget(dev, inum);
    80002c80:	85da                	mv	a1,s6
    80002c82:	8556                	mv	a0,s5
    80002c84:	00000097          	auipc	ra,0x0
    80002c88:	d9c080e7          	jalr	-612(ra) # 80002a20 <iget>
    80002c8c:	bf5d                	j	80002c42 <ialloc+0x86>

0000000080002c8e <iupdate>:
{
    80002c8e:	1101                	addi	sp,sp,-32
    80002c90:	ec06                	sd	ra,24(sp)
    80002c92:	e822                	sd	s0,16(sp)
    80002c94:	e426                	sd	s1,8(sp)
    80002c96:	e04a                	sd	s2,0(sp)
    80002c98:	1000                	addi	s0,sp,32
    80002c9a:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c9c:	415c                	lw	a5,4(a0)
    80002c9e:	0047d79b          	srliw	a5,a5,0x4
    80002ca2:	00014597          	auipc	a1,0x14
    80002ca6:	3ee5a583          	lw	a1,1006(a1) # 80017090 <sb+0x18>
    80002caa:	9dbd                	addw	a1,a1,a5
    80002cac:	4108                	lw	a0,0(a0)
    80002cae:	00000097          	auipc	ra,0x0
    80002cb2:	890080e7          	jalr	-1904(ra) # 8000253e <bread>
    80002cb6:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002cb8:	05850793          	addi	a5,a0,88
    80002cbc:	40c8                	lw	a0,4(s1)
    80002cbe:	893d                	andi	a0,a0,15
    80002cc0:	051a                	slli	a0,a0,0x6
    80002cc2:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002cc4:	04449703          	lh	a4,68(s1)
    80002cc8:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002ccc:	04649703          	lh	a4,70(s1)
    80002cd0:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002cd4:	04849703          	lh	a4,72(s1)
    80002cd8:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002cdc:	04a49703          	lh	a4,74(s1)
    80002ce0:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002ce4:	44f8                	lw	a4,76(s1)
    80002ce6:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002ce8:	03400613          	li	a2,52
    80002cec:	05048593          	addi	a1,s1,80
    80002cf0:	0531                	addi	a0,a0,12
    80002cf2:	ffffd097          	auipc	ra,0xffffd
    80002cf6:	4e6080e7          	jalr	1254(ra) # 800001d8 <memmove>
  log_write(bp);
    80002cfa:	854a                	mv	a0,s2
    80002cfc:	00001097          	auipc	ra,0x1
    80002d00:	bf6080e7          	jalr	-1034(ra) # 800038f2 <log_write>
  brelse(bp);
    80002d04:	854a                	mv	a0,s2
    80002d06:	00000097          	auipc	ra,0x0
    80002d0a:	968080e7          	jalr	-1688(ra) # 8000266e <brelse>
}
    80002d0e:	60e2                	ld	ra,24(sp)
    80002d10:	6442                	ld	s0,16(sp)
    80002d12:	64a2                	ld	s1,8(sp)
    80002d14:	6902                	ld	s2,0(sp)
    80002d16:	6105                	addi	sp,sp,32
    80002d18:	8082                	ret

0000000080002d1a <idup>:
{
    80002d1a:	1101                	addi	sp,sp,-32
    80002d1c:	ec06                	sd	ra,24(sp)
    80002d1e:	e822                	sd	s0,16(sp)
    80002d20:	e426                	sd	s1,8(sp)
    80002d22:	1000                	addi	s0,sp,32
    80002d24:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002d26:	00014517          	auipc	a0,0x14
    80002d2a:	37250513          	addi	a0,a0,882 # 80017098 <itable>
    80002d2e:	00003097          	auipc	ra,0x3
    80002d32:	69e080e7          	jalr	1694(ra) # 800063cc <acquire>
  ip->ref++;
    80002d36:	449c                	lw	a5,8(s1)
    80002d38:	2785                	addiw	a5,a5,1
    80002d3a:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002d3c:	00014517          	auipc	a0,0x14
    80002d40:	35c50513          	addi	a0,a0,860 # 80017098 <itable>
    80002d44:	00003097          	auipc	ra,0x3
    80002d48:	73c080e7          	jalr	1852(ra) # 80006480 <release>
}
    80002d4c:	8526                	mv	a0,s1
    80002d4e:	60e2                	ld	ra,24(sp)
    80002d50:	6442                	ld	s0,16(sp)
    80002d52:	64a2                	ld	s1,8(sp)
    80002d54:	6105                	addi	sp,sp,32
    80002d56:	8082                	ret

0000000080002d58 <ilock>:
{
    80002d58:	1101                	addi	sp,sp,-32
    80002d5a:	ec06                	sd	ra,24(sp)
    80002d5c:	e822                	sd	s0,16(sp)
    80002d5e:	e426                	sd	s1,8(sp)
    80002d60:	e04a                	sd	s2,0(sp)
    80002d62:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002d64:	c115                	beqz	a0,80002d88 <ilock+0x30>
    80002d66:	84aa                	mv	s1,a0
    80002d68:	451c                	lw	a5,8(a0)
    80002d6a:	00f05f63          	blez	a5,80002d88 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002d6e:	0541                	addi	a0,a0,16
    80002d70:	00001097          	auipc	ra,0x1
    80002d74:	ca2080e7          	jalr	-862(ra) # 80003a12 <acquiresleep>
  if(ip->valid == 0){
    80002d78:	40bc                	lw	a5,64(s1)
    80002d7a:	cf99                	beqz	a5,80002d98 <ilock+0x40>
}
    80002d7c:	60e2                	ld	ra,24(sp)
    80002d7e:	6442                	ld	s0,16(sp)
    80002d80:	64a2                	ld	s1,8(sp)
    80002d82:	6902                	ld	s2,0(sp)
    80002d84:	6105                	addi	sp,sp,32
    80002d86:	8082                	ret
    panic("ilock");
    80002d88:	00006517          	auipc	a0,0x6
    80002d8c:	83050513          	addi	a0,a0,-2000 # 800085b8 <syscalls+0x1c8>
    80002d90:	00003097          	auipc	ra,0x3
    80002d94:	0f2080e7          	jalr	242(ra) # 80005e82 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002d98:	40dc                	lw	a5,4(s1)
    80002d9a:	0047d79b          	srliw	a5,a5,0x4
    80002d9e:	00014597          	auipc	a1,0x14
    80002da2:	2f25a583          	lw	a1,754(a1) # 80017090 <sb+0x18>
    80002da6:	9dbd                	addw	a1,a1,a5
    80002da8:	4088                	lw	a0,0(s1)
    80002daa:	fffff097          	auipc	ra,0xfffff
    80002dae:	794080e7          	jalr	1940(ra) # 8000253e <bread>
    80002db2:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002db4:	05850593          	addi	a1,a0,88
    80002db8:	40dc                	lw	a5,4(s1)
    80002dba:	8bbd                	andi	a5,a5,15
    80002dbc:	079a                	slli	a5,a5,0x6
    80002dbe:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002dc0:	00059783          	lh	a5,0(a1)
    80002dc4:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002dc8:	00259783          	lh	a5,2(a1)
    80002dcc:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002dd0:	00459783          	lh	a5,4(a1)
    80002dd4:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002dd8:	00659783          	lh	a5,6(a1)
    80002ddc:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002de0:	459c                	lw	a5,8(a1)
    80002de2:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002de4:	03400613          	li	a2,52
    80002de8:	05b1                	addi	a1,a1,12
    80002dea:	05048513          	addi	a0,s1,80
    80002dee:	ffffd097          	auipc	ra,0xffffd
    80002df2:	3ea080e7          	jalr	1002(ra) # 800001d8 <memmove>
    brelse(bp);
    80002df6:	854a                	mv	a0,s2
    80002df8:	00000097          	auipc	ra,0x0
    80002dfc:	876080e7          	jalr	-1930(ra) # 8000266e <brelse>
    ip->valid = 1;
    80002e00:	4785                	li	a5,1
    80002e02:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002e04:	04449783          	lh	a5,68(s1)
    80002e08:	fbb5                	bnez	a5,80002d7c <ilock+0x24>
      panic("ilock: no type");
    80002e0a:	00005517          	auipc	a0,0x5
    80002e0e:	7b650513          	addi	a0,a0,1974 # 800085c0 <syscalls+0x1d0>
    80002e12:	00003097          	auipc	ra,0x3
    80002e16:	070080e7          	jalr	112(ra) # 80005e82 <panic>

0000000080002e1a <iunlock>:
{
    80002e1a:	1101                	addi	sp,sp,-32
    80002e1c:	ec06                	sd	ra,24(sp)
    80002e1e:	e822                	sd	s0,16(sp)
    80002e20:	e426                	sd	s1,8(sp)
    80002e22:	e04a                	sd	s2,0(sp)
    80002e24:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002e26:	c905                	beqz	a0,80002e56 <iunlock+0x3c>
    80002e28:	84aa                	mv	s1,a0
    80002e2a:	01050913          	addi	s2,a0,16
    80002e2e:	854a                	mv	a0,s2
    80002e30:	00001097          	auipc	ra,0x1
    80002e34:	c7c080e7          	jalr	-900(ra) # 80003aac <holdingsleep>
    80002e38:	cd19                	beqz	a0,80002e56 <iunlock+0x3c>
    80002e3a:	449c                	lw	a5,8(s1)
    80002e3c:	00f05d63          	blez	a5,80002e56 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002e40:	854a                	mv	a0,s2
    80002e42:	00001097          	auipc	ra,0x1
    80002e46:	c26080e7          	jalr	-986(ra) # 80003a68 <releasesleep>
}
    80002e4a:	60e2                	ld	ra,24(sp)
    80002e4c:	6442                	ld	s0,16(sp)
    80002e4e:	64a2                	ld	s1,8(sp)
    80002e50:	6902                	ld	s2,0(sp)
    80002e52:	6105                	addi	sp,sp,32
    80002e54:	8082                	ret
    panic("iunlock");
    80002e56:	00005517          	auipc	a0,0x5
    80002e5a:	77a50513          	addi	a0,a0,1914 # 800085d0 <syscalls+0x1e0>
    80002e5e:	00003097          	auipc	ra,0x3
    80002e62:	024080e7          	jalr	36(ra) # 80005e82 <panic>

0000000080002e66 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002e66:	7179                	addi	sp,sp,-48
    80002e68:	f406                	sd	ra,40(sp)
    80002e6a:	f022                	sd	s0,32(sp)
    80002e6c:	ec26                	sd	s1,24(sp)
    80002e6e:	e84a                	sd	s2,16(sp)
    80002e70:	e44e                	sd	s3,8(sp)
    80002e72:	e052                	sd	s4,0(sp)
    80002e74:	1800                	addi	s0,sp,48
    80002e76:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002e78:	05050493          	addi	s1,a0,80
    80002e7c:	08050913          	addi	s2,a0,128
    80002e80:	a021                	j	80002e88 <itrunc+0x22>
    80002e82:	0491                	addi	s1,s1,4
    80002e84:	01248d63          	beq	s1,s2,80002e9e <itrunc+0x38>
    if(ip->addrs[i]){
    80002e88:	408c                	lw	a1,0(s1)
    80002e8a:	dde5                	beqz	a1,80002e82 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002e8c:	0009a503          	lw	a0,0(s3)
    80002e90:	00000097          	auipc	ra,0x0
    80002e94:	8f4080e7          	jalr	-1804(ra) # 80002784 <bfree>
      ip->addrs[i] = 0;
    80002e98:	0004a023          	sw	zero,0(s1)
    80002e9c:	b7dd                	j	80002e82 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002e9e:	0809a583          	lw	a1,128(s3)
    80002ea2:	e185                	bnez	a1,80002ec2 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002ea4:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002ea8:	854e                	mv	a0,s3
    80002eaa:	00000097          	auipc	ra,0x0
    80002eae:	de4080e7          	jalr	-540(ra) # 80002c8e <iupdate>
}
    80002eb2:	70a2                	ld	ra,40(sp)
    80002eb4:	7402                	ld	s0,32(sp)
    80002eb6:	64e2                	ld	s1,24(sp)
    80002eb8:	6942                	ld	s2,16(sp)
    80002eba:	69a2                	ld	s3,8(sp)
    80002ebc:	6a02                	ld	s4,0(sp)
    80002ebe:	6145                	addi	sp,sp,48
    80002ec0:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002ec2:	0009a503          	lw	a0,0(s3)
    80002ec6:	fffff097          	auipc	ra,0xfffff
    80002eca:	678080e7          	jalr	1656(ra) # 8000253e <bread>
    80002ece:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002ed0:	05850493          	addi	s1,a0,88
    80002ed4:	45850913          	addi	s2,a0,1112
    80002ed8:	a811                	j	80002eec <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002eda:	0009a503          	lw	a0,0(s3)
    80002ede:	00000097          	auipc	ra,0x0
    80002ee2:	8a6080e7          	jalr	-1882(ra) # 80002784 <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002ee6:	0491                	addi	s1,s1,4
    80002ee8:	01248563          	beq	s1,s2,80002ef2 <itrunc+0x8c>
      if(a[j])
    80002eec:	408c                	lw	a1,0(s1)
    80002eee:	dde5                	beqz	a1,80002ee6 <itrunc+0x80>
    80002ef0:	b7ed                	j	80002eda <itrunc+0x74>
    brelse(bp);
    80002ef2:	8552                	mv	a0,s4
    80002ef4:	fffff097          	auipc	ra,0xfffff
    80002ef8:	77a080e7          	jalr	1914(ra) # 8000266e <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002efc:	0809a583          	lw	a1,128(s3)
    80002f00:	0009a503          	lw	a0,0(s3)
    80002f04:	00000097          	auipc	ra,0x0
    80002f08:	880080e7          	jalr	-1920(ra) # 80002784 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002f0c:	0809a023          	sw	zero,128(s3)
    80002f10:	bf51                	j	80002ea4 <itrunc+0x3e>

0000000080002f12 <iput>:
{
    80002f12:	1101                	addi	sp,sp,-32
    80002f14:	ec06                	sd	ra,24(sp)
    80002f16:	e822                	sd	s0,16(sp)
    80002f18:	e426                	sd	s1,8(sp)
    80002f1a:	e04a                	sd	s2,0(sp)
    80002f1c:	1000                	addi	s0,sp,32
    80002f1e:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002f20:	00014517          	auipc	a0,0x14
    80002f24:	17850513          	addi	a0,a0,376 # 80017098 <itable>
    80002f28:	00003097          	auipc	ra,0x3
    80002f2c:	4a4080e7          	jalr	1188(ra) # 800063cc <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002f30:	4498                	lw	a4,8(s1)
    80002f32:	4785                	li	a5,1
    80002f34:	02f70363          	beq	a4,a5,80002f5a <iput+0x48>
  ip->ref--;
    80002f38:	449c                	lw	a5,8(s1)
    80002f3a:	37fd                	addiw	a5,a5,-1
    80002f3c:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002f3e:	00014517          	auipc	a0,0x14
    80002f42:	15a50513          	addi	a0,a0,346 # 80017098 <itable>
    80002f46:	00003097          	auipc	ra,0x3
    80002f4a:	53a080e7          	jalr	1338(ra) # 80006480 <release>
}
    80002f4e:	60e2                	ld	ra,24(sp)
    80002f50:	6442                	ld	s0,16(sp)
    80002f52:	64a2                	ld	s1,8(sp)
    80002f54:	6902                	ld	s2,0(sp)
    80002f56:	6105                	addi	sp,sp,32
    80002f58:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002f5a:	40bc                	lw	a5,64(s1)
    80002f5c:	dff1                	beqz	a5,80002f38 <iput+0x26>
    80002f5e:	04a49783          	lh	a5,74(s1)
    80002f62:	fbf9                	bnez	a5,80002f38 <iput+0x26>
    acquiresleep(&ip->lock);
    80002f64:	01048913          	addi	s2,s1,16
    80002f68:	854a                	mv	a0,s2
    80002f6a:	00001097          	auipc	ra,0x1
    80002f6e:	aa8080e7          	jalr	-1368(ra) # 80003a12 <acquiresleep>
    release(&itable.lock);
    80002f72:	00014517          	auipc	a0,0x14
    80002f76:	12650513          	addi	a0,a0,294 # 80017098 <itable>
    80002f7a:	00003097          	auipc	ra,0x3
    80002f7e:	506080e7          	jalr	1286(ra) # 80006480 <release>
    itrunc(ip);
    80002f82:	8526                	mv	a0,s1
    80002f84:	00000097          	auipc	ra,0x0
    80002f88:	ee2080e7          	jalr	-286(ra) # 80002e66 <itrunc>
    ip->type = 0;
    80002f8c:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002f90:	8526                	mv	a0,s1
    80002f92:	00000097          	auipc	ra,0x0
    80002f96:	cfc080e7          	jalr	-772(ra) # 80002c8e <iupdate>
    ip->valid = 0;
    80002f9a:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002f9e:	854a                	mv	a0,s2
    80002fa0:	00001097          	auipc	ra,0x1
    80002fa4:	ac8080e7          	jalr	-1336(ra) # 80003a68 <releasesleep>
    acquire(&itable.lock);
    80002fa8:	00014517          	auipc	a0,0x14
    80002fac:	0f050513          	addi	a0,a0,240 # 80017098 <itable>
    80002fb0:	00003097          	auipc	ra,0x3
    80002fb4:	41c080e7          	jalr	1052(ra) # 800063cc <acquire>
    80002fb8:	b741                	j	80002f38 <iput+0x26>

0000000080002fba <iunlockput>:
{
    80002fba:	1101                	addi	sp,sp,-32
    80002fbc:	ec06                	sd	ra,24(sp)
    80002fbe:	e822                	sd	s0,16(sp)
    80002fc0:	e426                	sd	s1,8(sp)
    80002fc2:	1000                	addi	s0,sp,32
    80002fc4:	84aa                	mv	s1,a0
  iunlock(ip);
    80002fc6:	00000097          	auipc	ra,0x0
    80002fca:	e54080e7          	jalr	-428(ra) # 80002e1a <iunlock>
  iput(ip);
    80002fce:	8526                	mv	a0,s1
    80002fd0:	00000097          	auipc	ra,0x0
    80002fd4:	f42080e7          	jalr	-190(ra) # 80002f12 <iput>
}
    80002fd8:	60e2                	ld	ra,24(sp)
    80002fda:	6442                	ld	s0,16(sp)
    80002fdc:	64a2                	ld	s1,8(sp)
    80002fde:	6105                	addi	sp,sp,32
    80002fe0:	8082                	ret

0000000080002fe2 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002fe2:	1141                	addi	sp,sp,-16
    80002fe4:	e422                	sd	s0,8(sp)
    80002fe6:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002fe8:	411c                	lw	a5,0(a0)
    80002fea:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002fec:	415c                	lw	a5,4(a0)
    80002fee:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002ff0:	04451783          	lh	a5,68(a0)
    80002ff4:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002ff8:	04a51783          	lh	a5,74(a0)
    80002ffc:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003000:	04c56783          	lwu	a5,76(a0)
    80003004:	e99c                	sd	a5,16(a1)
}
    80003006:	6422                	ld	s0,8(sp)
    80003008:	0141                	addi	sp,sp,16
    8000300a:	8082                	ret

000000008000300c <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000300c:	457c                	lw	a5,76(a0)
    8000300e:	0ed7e963          	bltu	a5,a3,80003100 <readi+0xf4>
{
    80003012:	7159                	addi	sp,sp,-112
    80003014:	f486                	sd	ra,104(sp)
    80003016:	f0a2                	sd	s0,96(sp)
    80003018:	eca6                	sd	s1,88(sp)
    8000301a:	e8ca                	sd	s2,80(sp)
    8000301c:	e4ce                	sd	s3,72(sp)
    8000301e:	e0d2                	sd	s4,64(sp)
    80003020:	fc56                	sd	s5,56(sp)
    80003022:	f85a                	sd	s6,48(sp)
    80003024:	f45e                	sd	s7,40(sp)
    80003026:	f062                	sd	s8,32(sp)
    80003028:	ec66                	sd	s9,24(sp)
    8000302a:	e86a                	sd	s10,16(sp)
    8000302c:	e46e                	sd	s11,8(sp)
    8000302e:	1880                	addi	s0,sp,112
    80003030:	8b2a                	mv	s6,a0
    80003032:	8bae                	mv	s7,a1
    80003034:	8a32                	mv	s4,a2
    80003036:	84b6                	mv	s1,a3
    80003038:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    8000303a:	9f35                	addw	a4,a4,a3
    return 0;
    8000303c:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    8000303e:	0ad76063          	bltu	a4,a3,800030de <readi+0xd2>
  if(off + n > ip->size)
    80003042:	00e7f463          	bgeu	a5,a4,8000304a <readi+0x3e>
    n = ip->size - off;
    80003046:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000304a:	0a0a8963          	beqz	s5,800030fc <readi+0xf0>
    8000304e:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003050:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003054:	5c7d                	li	s8,-1
    80003056:	a82d                	j	80003090 <readi+0x84>
    80003058:	020d1d93          	slli	s11,s10,0x20
    8000305c:	020ddd93          	srli	s11,s11,0x20
    80003060:	05890613          	addi	a2,s2,88
    80003064:	86ee                	mv	a3,s11
    80003066:	963a                	add	a2,a2,a4
    80003068:	85d2                	mv	a1,s4
    8000306a:	855e                	mv	a0,s7
    8000306c:	fffff097          	auipc	ra,0xfffff
    80003070:	a30080e7          	jalr	-1488(ra) # 80001a9c <either_copyout>
    80003074:	05850d63          	beq	a0,s8,800030ce <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003078:	854a                	mv	a0,s2
    8000307a:	fffff097          	auipc	ra,0xfffff
    8000307e:	5f4080e7          	jalr	1524(ra) # 8000266e <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003082:	013d09bb          	addw	s3,s10,s3
    80003086:	009d04bb          	addw	s1,s10,s1
    8000308a:	9a6e                	add	s4,s4,s11
    8000308c:	0559f763          	bgeu	s3,s5,800030da <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80003090:	00a4d59b          	srliw	a1,s1,0xa
    80003094:	855a                	mv	a0,s6
    80003096:	00000097          	auipc	ra,0x0
    8000309a:	8a2080e7          	jalr	-1886(ra) # 80002938 <bmap>
    8000309e:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800030a2:	cd85                	beqz	a1,800030da <readi+0xce>
    bp = bread(ip->dev, addr);
    800030a4:	000b2503          	lw	a0,0(s6)
    800030a8:	fffff097          	auipc	ra,0xfffff
    800030ac:	496080e7          	jalr	1174(ra) # 8000253e <bread>
    800030b0:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800030b2:	3ff4f713          	andi	a4,s1,1023
    800030b6:	40ec87bb          	subw	a5,s9,a4
    800030ba:	413a86bb          	subw	a3,s5,s3
    800030be:	8d3e                	mv	s10,a5
    800030c0:	2781                	sext.w	a5,a5
    800030c2:	0006861b          	sext.w	a2,a3
    800030c6:	f8f679e3          	bgeu	a2,a5,80003058 <readi+0x4c>
    800030ca:	8d36                	mv	s10,a3
    800030cc:	b771                	j	80003058 <readi+0x4c>
      brelse(bp);
    800030ce:	854a                	mv	a0,s2
    800030d0:	fffff097          	auipc	ra,0xfffff
    800030d4:	59e080e7          	jalr	1438(ra) # 8000266e <brelse>
      tot = -1;
    800030d8:	59fd                	li	s3,-1
  }
  return tot;
    800030da:	0009851b          	sext.w	a0,s3
}
    800030de:	70a6                	ld	ra,104(sp)
    800030e0:	7406                	ld	s0,96(sp)
    800030e2:	64e6                	ld	s1,88(sp)
    800030e4:	6946                	ld	s2,80(sp)
    800030e6:	69a6                	ld	s3,72(sp)
    800030e8:	6a06                	ld	s4,64(sp)
    800030ea:	7ae2                	ld	s5,56(sp)
    800030ec:	7b42                	ld	s6,48(sp)
    800030ee:	7ba2                	ld	s7,40(sp)
    800030f0:	7c02                	ld	s8,32(sp)
    800030f2:	6ce2                	ld	s9,24(sp)
    800030f4:	6d42                	ld	s10,16(sp)
    800030f6:	6da2                	ld	s11,8(sp)
    800030f8:	6165                	addi	sp,sp,112
    800030fa:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800030fc:	89d6                	mv	s3,s5
    800030fe:	bff1                	j	800030da <readi+0xce>
    return 0;
    80003100:	4501                	li	a0,0
}
    80003102:	8082                	ret

0000000080003104 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003104:	457c                	lw	a5,76(a0)
    80003106:	10d7e863          	bltu	a5,a3,80003216 <writei+0x112>
{
    8000310a:	7159                	addi	sp,sp,-112
    8000310c:	f486                	sd	ra,104(sp)
    8000310e:	f0a2                	sd	s0,96(sp)
    80003110:	eca6                	sd	s1,88(sp)
    80003112:	e8ca                	sd	s2,80(sp)
    80003114:	e4ce                	sd	s3,72(sp)
    80003116:	e0d2                	sd	s4,64(sp)
    80003118:	fc56                	sd	s5,56(sp)
    8000311a:	f85a                	sd	s6,48(sp)
    8000311c:	f45e                	sd	s7,40(sp)
    8000311e:	f062                	sd	s8,32(sp)
    80003120:	ec66                	sd	s9,24(sp)
    80003122:	e86a                	sd	s10,16(sp)
    80003124:	e46e                	sd	s11,8(sp)
    80003126:	1880                	addi	s0,sp,112
    80003128:	8aaa                	mv	s5,a0
    8000312a:	8bae                	mv	s7,a1
    8000312c:	8a32                	mv	s4,a2
    8000312e:	8936                	mv	s2,a3
    80003130:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003132:	00e687bb          	addw	a5,a3,a4
    80003136:	0ed7e263          	bltu	a5,a3,8000321a <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    8000313a:	00043737          	lui	a4,0x43
    8000313e:	0ef76063          	bltu	a4,a5,8000321e <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003142:	0c0b0863          	beqz	s6,80003212 <writei+0x10e>
    80003146:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003148:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    8000314c:	5c7d                	li	s8,-1
    8000314e:	a091                	j	80003192 <writei+0x8e>
    80003150:	020d1d93          	slli	s11,s10,0x20
    80003154:	020ddd93          	srli	s11,s11,0x20
    80003158:	05848513          	addi	a0,s1,88
    8000315c:	86ee                	mv	a3,s11
    8000315e:	8652                	mv	a2,s4
    80003160:	85de                	mv	a1,s7
    80003162:	953a                	add	a0,a0,a4
    80003164:	fffff097          	auipc	ra,0xfffff
    80003168:	98e080e7          	jalr	-1650(ra) # 80001af2 <either_copyin>
    8000316c:	07850263          	beq	a0,s8,800031d0 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003170:	8526                	mv	a0,s1
    80003172:	00000097          	auipc	ra,0x0
    80003176:	780080e7          	jalr	1920(ra) # 800038f2 <log_write>
    brelse(bp);
    8000317a:	8526                	mv	a0,s1
    8000317c:	fffff097          	auipc	ra,0xfffff
    80003180:	4f2080e7          	jalr	1266(ra) # 8000266e <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003184:	013d09bb          	addw	s3,s10,s3
    80003188:	012d093b          	addw	s2,s10,s2
    8000318c:	9a6e                	add	s4,s4,s11
    8000318e:	0569f663          	bgeu	s3,s6,800031da <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    80003192:	00a9559b          	srliw	a1,s2,0xa
    80003196:	8556                	mv	a0,s5
    80003198:	fffff097          	auipc	ra,0xfffff
    8000319c:	7a0080e7          	jalr	1952(ra) # 80002938 <bmap>
    800031a0:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800031a4:	c99d                	beqz	a1,800031da <writei+0xd6>
    bp = bread(ip->dev, addr);
    800031a6:	000aa503          	lw	a0,0(s5)
    800031aa:	fffff097          	auipc	ra,0xfffff
    800031ae:	394080e7          	jalr	916(ra) # 8000253e <bread>
    800031b2:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800031b4:	3ff97713          	andi	a4,s2,1023
    800031b8:	40ec87bb          	subw	a5,s9,a4
    800031bc:	413b06bb          	subw	a3,s6,s3
    800031c0:	8d3e                	mv	s10,a5
    800031c2:	2781                	sext.w	a5,a5
    800031c4:	0006861b          	sext.w	a2,a3
    800031c8:	f8f674e3          	bgeu	a2,a5,80003150 <writei+0x4c>
    800031cc:	8d36                	mv	s10,a3
    800031ce:	b749                	j	80003150 <writei+0x4c>
      brelse(bp);
    800031d0:	8526                	mv	a0,s1
    800031d2:	fffff097          	auipc	ra,0xfffff
    800031d6:	49c080e7          	jalr	1180(ra) # 8000266e <brelse>
  }

  if(off > ip->size)
    800031da:	04caa783          	lw	a5,76(s5)
    800031de:	0127f463          	bgeu	a5,s2,800031e6 <writei+0xe2>
    ip->size = off;
    800031e2:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800031e6:	8556                	mv	a0,s5
    800031e8:	00000097          	auipc	ra,0x0
    800031ec:	aa6080e7          	jalr	-1370(ra) # 80002c8e <iupdate>

  return tot;
    800031f0:	0009851b          	sext.w	a0,s3
}
    800031f4:	70a6                	ld	ra,104(sp)
    800031f6:	7406                	ld	s0,96(sp)
    800031f8:	64e6                	ld	s1,88(sp)
    800031fa:	6946                	ld	s2,80(sp)
    800031fc:	69a6                	ld	s3,72(sp)
    800031fe:	6a06                	ld	s4,64(sp)
    80003200:	7ae2                	ld	s5,56(sp)
    80003202:	7b42                	ld	s6,48(sp)
    80003204:	7ba2                	ld	s7,40(sp)
    80003206:	7c02                	ld	s8,32(sp)
    80003208:	6ce2                	ld	s9,24(sp)
    8000320a:	6d42                	ld	s10,16(sp)
    8000320c:	6da2                	ld	s11,8(sp)
    8000320e:	6165                	addi	sp,sp,112
    80003210:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003212:	89da                	mv	s3,s6
    80003214:	bfc9                	j	800031e6 <writei+0xe2>
    return -1;
    80003216:	557d                	li	a0,-1
}
    80003218:	8082                	ret
    return -1;
    8000321a:	557d                	li	a0,-1
    8000321c:	bfe1                	j	800031f4 <writei+0xf0>
    return -1;
    8000321e:	557d                	li	a0,-1
    80003220:	bfd1                	j	800031f4 <writei+0xf0>

0000000080003222 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003222:	1141                	addi	sp,sp,-16
    80003224:	e406                	sd	ra,8(sp)
    80003226:	e022                	sd	s0,0(sp)
    80003228:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    8000322a:	4639                	li	a2,14
    8000322c:	ffffd097          	auipc	ra,0xffffd
    80003230:	024080e7          	jalr	36(ra) # 80000250 <strncmp>
}
    80003234:	60a2                	ld	ra,8(sp)
    80003236:	6402                	ld	s0,0(sp)
    80003238:	0141                	addi	sp,sp,16
    8000323a:	8082                	ret

000000008000323c <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    8000323c:	7139                	addi	sp,sp,-64
    8000323e:	fc06                	sd	ra,56(sp)
    80003240:	f822                	sd	s0,48(sp)
    80003242:	f426                	sd	s1,40(sp)
    80003244:	f04a                	sd	s2,32(sp)
    80003246:	ec4e                	sd	s3,24(sp)
    80003248:	e852                	sd	s4,16(sp)
    8000324a:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    8000324c:	04451703          	lh	a4,68(a0)
    80003250:	4785                	li	a5,1
    80003252:	00f71a63          	bne	a4,a5,80003266 <dirlookup+0x2a>
    80003256:	892a                	mv	s2,a0
    80003258:	89ae                	mv	s3,a1
    8000325a:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    8000325c:	457c                	lw	a5,76(a0)
    8000325e:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003260:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003262:	e79d                	bnez	a5,80003290 <dirlookup+0x54>
    80003264:	a8a5                	j	800032dc <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003266:	00005517          	auipc	a0,0x5
    8000326a:	37250513          	addi	a0,a0,882 # 800085d8 <syscalls+0x1e8>
    8000326e:	00003097          	auipc	ra,0x3
    80003272:	c14080e7          	jalr	-1004(ra) # 80005e82 <panic>
      panic("dirlookup read");
    80003276:	00005517          	auipc	a0,0x5
    8000327a:	37a50513          	addi	a0,a0,890 # 800085f0 <syscalls+0x200>
    8000327e:	00003097          	auipc	ra,0x3
    80003282:	c04080e7          	jalr	-1020(ra) # 80005e82 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003286:	24c1                	addiw	s1,s1,16
    80003288:	04c92783          	lw	a5,76(s2)
    8000328c:	04f4f763          	bgeu	s1,a5,800032da <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003290:	4741                	li	a4,16
    80003292:	86a6                	mv	a3,s1
    80003294:	fc040613          	addi	a2,s0,-64
    80003298:	4581                	li	a1,0
    8000329a:	854a                	mv	a0,s2
    8000329c:	00000097          	auipc	ra,0x0
    800032a0:	d70080e7          	jalr	-656(ra) # 8000300c <readi>
    800032a4:	47c1                	li	a5,16
    800032a6:	fcf518e3          	bne	a0,a5,80003276 <dirlookup+0x3a>
    if(de.inum == 0)
    800032aa:	fc045783          	lhu	a5,-64(s0)
    800032ae:	dfe1                	beqz	a5,80003286 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800032b0:	fc240593          	addi	a1,s0,-62
    800032b4:	854e                	mv	a0,s3
    800032b6:	00000097          	auipc	ra,0x0
    800032ba:	f6c080e7          	jalr	-148(ra) # 80003222 <namecmp>
    800032be:	f561                	bnez	a0,80003286 <dirlookup+0x4a>
      if(poff)
    800032c0:	000a0463          	beqz	s4,800032c8 <dirlookup+0x8c>
        *poff = off;
    800032c4:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800032c8:	fc045583          	lhu	a1,-64(s0)
    800032cc:	00092503          	lw	a0,0(s2)
    800032d0:	fffff097          	auipc	ra,0xfffff
    800032d4:	750080e7          	jalr	1872(ra) # 80002a20 <iget>
    800032d8:	a011                	j	800032dc <dirlookup+0xa0>
  return 0;
    800032da:	4501                	li	a0,0
}
    800032dc:	70e2                	ld	ra,56(sp)
    800032de:	7442                	ld	s0,48(sp)
    800032e0:	74a2                	ld	s1,40(sp)
    800032e2:	7902                	ld	s2,32(sp)
    800032e4:	69e2                	ld	s3,24(sp)
    800032e6:	6a42                	ld	s4,16(sp)
    800032e8:	6121                	addi	sp,sp,64
    800032ea:	8082                	ret

00000000800032ec <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800032ec:	711d                	addi	sp,sp,-96
    800032ee:	ec86                	sd	ra,88(sp)
    800032f0:	e8a2                	sd	s0,80(sp)
    800032f2:	e4a6                	sd	s1,72(sp)
    800032f4:	e0ca                	sd	s2,64(sp)
    800032f6:	fc4e                	sd	s3,56(sp)
    800032f8:	f852                	sd	s4,48(sp)
    800032fa:	f456                	sd	s5,40(sp)
    800032fc:	f05a                	sd	s6,32(sp)
    800032fe:	ec5e                	sd	s7,24(sp)
    80003300:	e862                	sd	s8,16(sp)
    80003302:	e466                	sd	s9,8(sp)
    80003304:	1080                	addi	s0,sp,96
    80003306:	84aa                	mv	s1,a0
    80003308:	8b2e                	mv	s6,a1
    8000330a:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    8000330c:	00054703          	lbu	a4,0(a0)
    80003310:	02f00793          	li	a5,47
    80003314:	02f70363          	beq	a4,a5,8000333a <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003318:	ffffe097          	auipc	ra,0xffffe
    8000331c:	c1c080e7          	jalr	-996(ra) # 80000f34 <myproc>
    80003320:	15053503          	ld	a0,336(a0)
    80003324:	00000097          	auipc	ra,0x0
    80003328:	9f6080e7          	jalr	-1546(ra) # 80002d1a <idup>
    8000332c:	89aa                	mv	s3,a0
  while(*path == '/')
    8000332e:	02f00913          	li	s2,47
  len = path - s;
    80003332:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    80003334:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003336:	4c05                	li	s8,1
    80003338:	a865                	j	800033f0 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    8000333a:	4585                	li	a1,1
    8000333c:	4505                	li	a0,1
    8000333e:	fffff097          	auipc	ra,0xfffff
    80003342:	6e2080e7          	jalr	1762(ra) # 80002a20 <iget>
    80003346:	89aa                	mv	s3,a0
    80003348:	b7dd                	j	8000332e <namex+0x42>
      iunlockput(ip);
    8000334a:	854e                	mv	a0,s3
    8000334c:	00000097          	auipc	ra,0x0
    80003350:	c6e080e7          	jalr	-914(ra) # 80002fba <iunlockput>
      return 0;
    80003354:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003356:	854e                	mv	a0,s3
    80003358:	60e6                	ld	ra,88(sp)
    8000335a:	6446                	ld	s0,80(sp)
    8000335c:	64a6                	ld	s1,72(sp)
    8000335e:	6906                	ld	s2,64(sp)
    80003360:	79e2                	ld	s3,56(sp)
    80003362:	7a42                	ld	s4,48(sp)
    80003364:	7aa2                	ld	s5,40(sp)
    80003366:	7b02                	ld	s6,32(sp)
    80003368:	6be2                	ld	s7,24(sp)
    8000336a:	6c42                	ld	s8,16(sp)
    8000336c:	6ca2                	ld	s9,8(sp)
    8000336e:	6125                	addi	sp,sp,96
    80003370:	8082                	ret
      iunlock(ip);
    80003372:	854e                	mv	a0,s3
    80003374:	00000097          	auipc	ra,0x0
    80003378:	aa6080e7          	jalr	-1370(ra) # 80002e1a <iunlock>
      return ip;
    8000337c:	bfe9                	j	80003356 <namex+0x6a>
      iunlockput(ip);
    8000337e:	854e                	mv	a0,s3
    80003380:	00000097          	auipc	ra,0x0
    80003384:	c3a080e7          	jalr	-966(ra) # 80002fba <iunlockput>
      return 0;
    80003388:	89d2                	mv	s3,s4
    8000338a:	b7f1                	j	80003356 <namex+0x6a>
  len = path - s;
    8000338c:	40b48633          	sub	a2,s1,a1
    80003390:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    80003394:	094cd463          	bge	s9,s4,8000341c <namex+0x130>
    memmove(name, s, DIRSIZ);
    80003398:	4639                	li	a2,14
    8000339a:	8556                	mv	a0,s5
    8000339c:	ffffd097          	auipc	ra,0xffffd
    800033a0:	e3c080e7          	jalr	-452(ra) # 800001d8 <memmove>
  while(*path == '/')
    800033a4:	0004c783          	lbu	a5,0(s1)
    800033a8:	01279763          	bne	a5,s2,800033b6 <namex+0xca>
    path++;
    800033ac:	0485                	addi	s1,s1,1
  while(*path == '/')
    800033ae:	0004c783          	lbu	a5,0(s1)
    800033b2:	ff278de3          	beq	a5,s2,800033ac <namex+0xc0>
    ilock(ip);
    800033b6:	854e                	mv	a0,s3
    800033b8:	00000097          	auipc	ra,0x0
    800033bc:	9a0080e7          	jalr	-1632(ra) # 80002d58 <ilock>
    if(ip->type != T_DIR){
    800033c0:	04499783          	lh	a5,68(s3)
    800033c4:	f98793e3          	bne	a5,s8,8000334a <namex+0x5e>
    if(nameiparent && *path == '\0'){
    800033c8:	000b0563          	beqz	s6,800033d2 <namex+0xe6>
    800033cc:	0004c783          	lbu	a5,0(s1)
    800033d0:	d3cd                	beqz	a5,80003372 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    800033d2:	865e                	mv	a2,s7
    800033d4:	85d6                	mv	a1,s5
    800033d6:	854e                	mv	a0,s3
    800033d8:	00000097          	auipc	ra,0x0
    800033dc:	e64080e7          	jalr	-412(ra) # 8000323c <dirlookup>
    800033e0:	8a2a                	mv	s4,a0
    800033e2:	dd51                	beqz	a0,8000337e <namex+0x92>
    iunlockput(ip);
    800033e4:	854e                	mv	a0,s3
    800033e6:	00000097          	auipc	ra,0x0
    800033ea:	bd4080e7          	jalr	-1068(ra) # 80002fba <iunlockput>
    ip = next;
    800033ee:	89d2                	mv	s3,s4
  while(*path == '/')
    800033f0:	0004c783          	lbu	a5,0(s1)
    800033f4:	05279763          	bne	a5,s2,80003442 <namex+0x156>
    path++;
    800033f8:	0485                	addi	s1,s1,1
  while(*path == '/')
    800033fa:	0004c783          	lbu	a5,0(s1)
    800033fe:	ff278de3          	beq	a5,s2,800033f8 <namex+0x10c>
  if(*path == 0)
    80003402:	c79d                	beqz	a5,80003430 <namex+0x144>
    path++;
    80003404:	85a6                	mv	a1,s1
  len = path - s;
    80003406:	8a5e                	mv	s4,s7
    80003408:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    8000340a:	01278963          	beq	a5,s2,8000341c <namex+0x130>
    8000340e:	dfbd                	beqz	a5,8000338c <namex+0xa0>
    path++;
    80003410:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80003412:	0004c783          	lbu	a5,0(s1)
    80003416:	ff279ce3          	bne	a5,s2,8000340e <namex+0x122>
    8000341a:	bf8d                	j	8000338c <namex+0xa0>
    memmove(name, s, len);
    8000341c:	2601                	sext.w	a2,a2
    8000341e:	8556                	mv	a0,s5
    80003420:	ffffd097          	auipc	ra,0xffffd
    80003424:	db8080e7          	jalr	-584(ra) # 800001d8 <memmove>
    name[len] = 0;
    80003428:	9a56                	add	s4,s4,s5
    8000342a:	000a0023          	sb	zero,0(s4)
    8000342e:	bf9d                	j	800033a4 <namex+0xb8>
  if(nameiparent){
    80003430:	f20b03e3          	beqz	s6,80003356 <namex+0x6a>
    iput(ip);
    80003434:	854e                	mv	a0,s3
    80003436:	00000097          	auipc	ra,0x0
    8000343a:	adc080e7          	jalr	-1316(ra) # 80002f12 <iput>
    return 0;
    8000343e:	4981                	li	s3,0
    80003440:	bf19                	j	80003356 <namex+0x6a>
  if(*path == 0)
    80003442:	d7fd                	beqz	a5,80003430 <namex+0x144>
  while(*path != '/' && *path != 0)
    80003444:	0004c783          	lbu	a5,0(s1)
    80003448:	85a6                	mv	a1,s1
    8000344a:	b7d1                	j	8000340e <namex+0x122>

000000008000344c <dirlink>:
{
    8000344c:	7139                	addi	sp,sp,-64
    8000344e:	fc06                	sd	ra,56(sp)
    80003450:	f822                	sd	s0,48(sp)
    80003452:	f426                	sd	s1,40(sp)
    80003454:	f04a                	sd	s2,32(sp)
    80003456:	ec4e                	sd	s3,24(sp)
    80003458:	e852                	sd	s4,16(sp)
    8000345a:	0080                	addi	s0,sp,64
    8000345c:	892a                	mv	s2,a0
    8000345e:	8a2e                	mv	s4,a1
    80003460:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003462:	4601                	li	a2,0
    80003464:	00000097          	auipc	ra,0x0
    80003468:	dd8080e7          	jalr	-552(ra) # 8000323c <dirlookup>
    8000346c:	e93d                	bnez	a0,800034e2 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000346e:	04c92483          	lw	s1,76(s2)
    80003472:	c49d                	beqz	s1,800034a0 <dirlink+0x54>
    80003474:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003476:	4741                	li	a4,16
    80003478:	86a6                	mv	a3,s1
    8000347a:	fc040613          	addi	a2,s0,-64
    8000347e:	4581                	li	a1,0
    80003480:	854a                	mv	a0,s2
    80003482:	00000097          	auipc	ra,0x0
    80003486:	b8a080e7          	jalr	-1142(ra) # 8000300c <readi>
    8000348a:	47c1                	li	a5,16
    8000348c:	06f51163          	bne	a0,a5,800034ee <dirlink+0xa2>
    if(de.inum == 0)
    80003490:	fc045783          	lhu	a5,-64(s0)
    80003494:	c791                	beqz	a5,800034a0 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003496:	24c1                	addiw	s1,s1,16
    80003498:	04c92783          	lw	a5,76(s2)
    8000349c:	fcf4ede3          	bltu	s1,a5,80003476 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800034a0:	4639                	li	a2,14
    800034a2:	85d2                	mv	a1,s4
    800034a4:	fc240513          	addi	a0,s0,-62
    800034a8:	ffffd097          	auipc	ra,0xffffd
    800034ac:	de4080e7          	jalr	-540(ra) # 8000028c <strncpy>
  de.inum = inum;
    800034b0:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800034b4:	4741                	li	a4,16
    800034b6:	86a6                	mv	a3,s1
    800034b8:	fc040613          	addi	a2,s0,-64
    800034bc:	4581                	li	a1,0
    800034be:	854a                	mv	a0,s2
    800034c0:	00000097          	auipc	ra,0x0
    800034c4:	c44080e7          	jalr	-956(ra) # 80003104 <writei>
    800034c8:	1541                	addi	a0,a0,-16
    800034ca:	00a03533          	snez	a0,a0
    800034ce:	40a00533          	neg	a0,a0
}
    800034d2:	70e2                	ld	ra,56(sp)
    800034d4:	7442                	ld	s0,48(sp)
    800034d6:	74a2                	ld	s1,40(sp)
    800034d8:	7902                	ld	s2,32(sp)
    800034da:	69e2                	ld	s3,24(sp)
    800034dc:	6a42                	ld	s4,16(sp)
    800034de:	6121                	addi	sp,sp,64
    800034e0:	8082                	ret
    iput(ip);
    800034e2:	00000097          	auipc	ra,0x0
    800034e6:	a30080e7          	jalr	-1488(ra) # 80002f12 <iput>
    return -1;
    800034ea:	557d                	li	a0,-1
    800034ec:	b7dd                	j	800034d2 <dirlink+0x86>
      panic("dirlink read");
    800034ee:	00005517          	auipc	a0,0x5
    800034f2:	11250513          	addi	a0,a0,274 # 80008600 <syscalls+0x210>
    800034f6:	00003097          	auipc	ra,0x3
    800034fa:	98c080e7          	jalr	-1652(ra) # 80005e82 <panic>

00000000800034fe <namei>:

struct inode*
namei(char *path)
{
    800034fe:	1101                	addi	sp,sp,-32
    80003500:	ec06                	sd	ra,24(sp)
    80003502:	e822                	sd	s0,16(sp)
    80003504:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003506:	fe040613          	addi	a2,s0,-32
    8000350a:	4581                	li	a1,0
    8000350c:	00000097          	auipc	ra,0x0
    80003510:	de0080e7          	jalr	-544(ra) # 800032ec <namex>
}
    80003514:	60e2                	ld	ra,24(sp)
    80003516:	6442                	ld	s0,16(sp)
    80003518:	6105                	addi	sp,sp,32
    8000351a:	8082                	ret

000000008000351c <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    8000351c:	1141                	addi	sp,sp,-16
    8000351e:	e406                	sd	ra,8(sp)
    80003520:	e022                	sd	s0,0(sp)
    80003522:	0800                	addi	s0,sp,16
    80003524:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003526:	4585                	li	a1,1
    80003528:	00000097          	auipc	ra,0x0
    8000352c:	dc4080e7          	jalr	-572(ra) # 800032ec <namex>
}
    80003530:	60a2                	ld	ra,8(sp)
    80003532:	6402                	ld	s0,0(sp)
    80003534:	0141                	addi	sp,sp,16
    80003536:	8082                	ret

0000000080003538 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003538:	1101                	addi	sp,sp,-32
    8000353a:	ec06                	sd	ra,24(sp)
    8000353c:	e822                	sd	s0,16(sp)
    8000353e:	e426                	sd	s1,8(sp)
    80003540:	e04a                	sd	s2,0(sp)
    80003542:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003544:	00015917          	auipc	s2,0x15
    80003548:	5fc90913          	addi	s2,s2,1532 # 80018b40 <log>
    8000354c:	01892583          	lw	a1,24(s2)
    80003550:	02892503          	lw	a0,40(s2)
    80003554:	fffff097          	auipc	ra,0xfffff
    80003558:	fea080e7          	jalr	-22(ra) # 8000253e <bread>
    8000355c:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    8000355e:	02c92683          	lw	a3,44(s2)
    80003562:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003564:	02d05763          	blez	a3,80003592 <write_head+0x5a>
    80003568:	00015797          	auipc	a5,0x15
    8000356c:	60878793          	addi	a5,a5,1544 # 80018b70 <log+0x30>
    80003570:	05c50713          	addi	a4,a0,92
    80003574:	36fd                	addiw	a3,a3,-1
    80003576:	1682                	slli	a3,a3,0x20
    80003578:	9281                	srli	a3,a3,0x20
    8000357a:	068a                	slli	a3,a3,0x2
    8000357c:	00015617          	auipc	a2,0x15
    80003580:	5f860613          	addi	a2,a2,1528 # 80018b74 <log+0x34>
    80003584:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003586:	4390                	lw	a2,0(a5)
    80003588:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000358a:	0791                	addi	a5,a5,4
    8000358c:	0711                	addi	a4,a4,4
    8000358e:	fed79ce3          	bne	a5,a3,80003586 <write_head+0x4e>
  }
  bwrite(buf);
    80003592:	8526                	mv	a0,s1
    80003594:	fffff097          	auipc	ra,0xfffff
    80003598:	09c080e7          	jalr	156(ra) # 80002630 <bwrite>
  brelse(buf);
    8000359c:	8526                	mv	a0,s1
    8000359e:	fffff097          	auipc	ra,0xfffff
    800035a2:	0d0080e7          	jalr	208(ra) # 8000266e <brelse>
}
    800035a6:	60e2                	ld	ra,24(sp)
    800035a8:	6442                	ld	s0,16(sp)
    800035aa:	64a2                	ld	s1,8(sp)
    800035ac:	6902                	ld	s2,0(sp)
    800035ae:	6105                	addi	sp,sp,32
    800035b0:	8082                	ret

00000000800035b2 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800035b2:	00015797          	auipc	a5,0x15
    800035b6:	5ba7a783          	lw	a5,1466(a5) # 80018b6c <log+0x2c>
    800035ba:	0af05d63          	blez	a5,80003674 <install_trans+0xc2>
{
    800035be:	7139                	addi	sp,sp,-64
    800035c0:	fc06                	sd	ra,56(sp)
    800035c2:	f822                	sd	s0,48(sp)
    800035c4:	f426                	sd	s1,40(sp)
    800035c6:	f04a                	sd	s2,32(sp)
    800035c8:	ec4e                	sd	s3,24(sp)
    800035ca:	e852                	sd	s4,16(sp)
    800035cc:	e456                	sd	s5,8(sp)
    800035ce:	e05a                	sd	s6,0(sp)
    800035d0:	0080                	addi	s0,sp,64
    800035d2:	8b2a                	mv	s6,a0
    800035d4:	00015a97          	auipc	s5,0x15
    800035d8:	59ca8a93          	addi	s5,s5,1436 # 80018b70 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800035dc:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800035de:	00015997          	auipc	s3,0x15
    800035e2:	56298993          	addi	s3,s3,1378 # 80018b40 <log>
    800035e6:	a035                	j	80003612 <install_trans+0x60>
      bunpin(dbuf);
    800035e8:	8526                	mv	a0,s1
    800035ea:	fffff097          	auipc	ra,0xfffff
    800035ee:	15e080e7          	jalr	350(ra) # 80002748 <bunpin>
    brelse(lbuf);
    800035f2:	854a                	mv	a0,s2
    800035f4:	fffff097          	auipc	ra,0xfffff
    800035f8:	07a080e7          	jalr	122(ra) # 8000266e <brelse>
    brelse(dbuf);
    800035fc:	8526                	mv	a0,s1
    800035fe:	fffff097          	auipc	ra,0xfffff
    80003602:	070080e7          	jalr	112(ra) # 8000266e <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003606:	2a05                	addiw	s4,s4,1
    80003608:	0a91                	addi	s5,s5,4
    8000360a:	02c9a783          	lw	a5,44(s3)
    8000360e:	04fa5963          	bge	s4,a5,80003660 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003612:	0189a583          	lw	a1,24(s3)
    80003616:	014585bb          	addw	a1,a1,s4
    8000361a:	2585                	addiw	a1,a1,1
    8000361c:	0289a503          	lw	a0,40(s3)
    80003620:	fffff097          	auipc	ra,0xfffff
    80003624:	f1e080e7          	jalr	-226(ra) # 8000253e <bread>
    80003628:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000362a:	000aa583          	lw	a1,0(s5)
    8000362e:	0289a503          	lw	a0,40(s3)
    80003632:	fffff097          	auipc	ra,0xfffff
    80003636:	f0c080e7          	jalr	-244(ra) # 8000253e <bread>
    8000363a:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000363c:	40000613          	li	a2,1024
    80003640:	05890593          	addi	a1,s2,88
    80003644:	05850513          	addi	a0,a0,88
    80003648:	ffffd097          	auipc	ra,0xffffd
    8000364c:	b90080e7          	jalr	-1136(ra) # 800001d8 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003650:	8526                	mv	a0,s1
    80003652:	fffff097          	auipc	ra,0xfffff
    80003656:	fde080e7          	jalr	-34(ra) # 80002630 <bwrite>
    if(recovering == 0)
    8000365a:	f80b1ce3          	bnez	s6,800035f2 <install_trans+0x40>
    8000365e:	b769                	j	800035e8 <install_trans+0x36>
}
    80003660:	70e2                	ld	ra,56(sp)
    80003662:	7442                	ld	s0,48(sp)
    80003664:	74a2                	ld	s1,40(sp)
    80003666:	7902                	ld	s2,32(sp)
    80003668:	69e2                	ld	s3,24(sp)
    8000366a:	6a42                	ld	s4,16(sp)
    8000366c:	6aa2                	ld	s5,8(sp)
    8000366e:	6b02                	ld	s6,0(sp)
    80003670:	6121                	addi	sp,sp,64
    80003672:	8082                	ret
    80003674:	8082                	ret

0000000080003676 <initlog>:
{
    80003676:	7179                	addi	sp,sp,-48
    80003678:	f406                	sd	ra,40(sp)
    8000367a:	f022                	sd	s0,32(sp)
    8000367c:	ec26                	sd	s1,24(sp)
    8000367e:	e84a                	sd	s2,16(sp)
    80003680:	e44e                	sd	s3,8(sp)
    80003682:	1800                	addi	s0,sp,48
    80003684:	892a                	mv	s2,a0
    80003686:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003688:	00015497          	auipc	s1,0x15
    8000368c:	4b848493          	addi	s1,s1,1208 # 80018b40 <log>
    80003690:	00005597          	auipc	a1,0x5
    80003694:	f8058593          	addi	a1,a1,-128 # 80008610 <syscalls+0x220>
    80003698:	8526                	mv	a0,s1
    8000369a:	00003097          	auipc	ra,0x3
    8000369e:	ca2080e7          	jalr	-862(ra) # 8000633c <initlock>
  log.start = sb->logstart;
    800036a2:	0149a583          	lw	a1,20(s3)
    800036a6:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800036a8:	0109a783          	lw	a5,16(s3)
    800036ac:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800036ae:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800036b2:	854a                	mv	a0,s2
    800036b4:	fffff097          	auipc	ra,0xfffff
    800036b8:	e8a080e7          	jalr	-374(ra) # 8000253e <bread>
  log.lh.n = lh->n;
    800036bc:	4d3c                	lw	a5,88(a0)
    800036be:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800036c0:	02f05563          	blez	a5,800036ea <initlog+0x74>
    800036c4:	05c50713          	addi	a4,a0,92
    800036c8:	00015697          	auipc	a3,0x15
    800036cc:	4a868693          	addi	a3,a3,1192 # 80018b70 <log+0x30>
    800036d0:	37fd                	addiw	a5,a5,-1
    800036d2:	1782                	slli	a5,a5,0x20
    800036d4:	9381                	srli	a5,a5,0x20
    800036d6:	078a                	slli	a5,a5,0x2
    800036d8:	06050613          	addi	a2,a0,96
    800036dc:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    800036de:	4310                	lw	a2,0(a4)
    800036e0:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    800036e2:	0711                	addi	a4,a4,4
    800036e4:	0691                	addi	a3,a3,4
    800036e6:	fef71ce3          	bne	a4,a5,800036de <initlog+0x68>
  brelse(buf);
    800036ea:	fffff097          	auipc	ra,0xfffff
    800036ee:	f84080e7          	jalr	-124(ra) # 8000266e <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800036f2:	4505                	li	a0,1
    800036f4:	00000097          	auipc	ra,0x0
    800036f8:	ebe080e7          	jalr	-322(ra) # 800035b2 <install_trans>
  log.lh.n = 0;
    800036fc:	00015797          	auipc	a5,0x15
    80003700:	4607a823          	sw	zero,1136(a5) # 80018b6c <log+0x2c>
  write_head(); // clear the log
    80003704:	00000097          	auipc	ra,0x0
    80003708:	e34080e7          	jalr	-460(ra) # 80003538 <write_head>
}
    8000370c:	70a2                	ld	ra,40(sp)
    8000370e:	7402                	ld	s0,32(sp)
    80003710:	64e2                	ld	s1,24(sp)
    80003712:	6942                	ld	s2,16(sp)
    80003714:	69a2                	ld	s3,8(sp)
    80003716:	6145                	addi	sp,sp,48
    80003718:	8082                	ret

000000008000371a <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    8000371a:	1101                	addi	sp,sp,-32
    8000371c:	ec06                	sd	ra,24(sp)
    8000371e:	e822                	sd	s0,16(sp)
    80003720:	e426                	sd	s1,8(sp)
    80003722:	e04a                	sd	s2,0(sp)
    80003724:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003726:	00015517          	auipc	a0,0x15
    8000372a:	41a50513          	addi	a0,a0,1050 # 80018b40 <log>
    8000372e:	00003097          	auipc	ra,0x3
    80003732:	c9e080e7          	jalr	-866(ra) # 800063cc <acquire>
  while(1){
    if(log.committing){
    80003736:	00015497          	auipc	s1,0x15
    8000373a:	40a48493          	addi	s1,s1,1034 # 80018b40 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000373e:	4979                	li	s2,30
    80003740:	a039                	j	8000374e <begin_op+0x34>
      sleep(&log, &log.lock);
    80003742:	85a6                	mv	a1,s1
    80003744:	8526                	mv	a0,s1
    80003746:	ffffe097          	auipc	ra,0xffffe
    8000374a:	f4e080e7          	jalr	-178(ra) # 80001694 <sleep>
    if(log.committing){
    8000374e:	50dc                	lw	a5,36(s1)
    80003750:	fbed                	bnez	a5,80003742 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003752:	509c                	lw	a5,32(s1)
    80003754:	0017871b          	addiw	a4,a5,1
    80003758:	0007069b          	sext.w	a3,a4
    8000375c:	0027179b          	slliw	a5,a4,0x2
    80003760:	9fb9                	addw	a5,a5,a4
    80003762:	0017979b          	slliw	a5,a5,0x1
    80003766:	54d8                	lw	a4,44(s1)
    80003768:	9fb9                	addw	a5,a5,a4
    8000376a:	00f95963          	bge	s2,a5,8000377c <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000376e:	85a6                	mv	a1,s1
    80003770:	8526                	mv	a0,s1
    80003772:	ffffe097          	auipc	ra,0xffffe
    80003776:	f22080e7          	jalr	-222(ra) # 80001694 <sleep>
    8000377a:	bfd1                	j	8000374e <begin_op+0x34>
    } else {
      log.outstanding += 1;
    8000377c:	00015517          	auipc	a0,0x15
    80003780:	3c450513          	addi	a0,a0,964 # 80018b40 <log>
    80003784:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80003786:	00003097          	auipc	ra,0x3
    8000378a:	cfa080e7          	jalr	-774(ra) # 80006480 <release>
      break;
    }
  }
}
    8000378e:	60e2                	ld	ra,24(sp)
    80003790:	6442                	ld	s0,16(sp)
    80003792:	64a2                	ld	s1,8(sp)
    80003794:	6902                	ld	s2,0(sp)
    80003796:	6105                	addi	sp,sp,32
    80003798:	8082                	ret

000000008000379a <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000379a:	7139                	addi	sp,sp,-64
    8000379c:	fc06                	sd	ra,56(sp)
    8000379e:	f822                	sd	s0,48(sp)
    800037a0:	f426                	sd	s1,40(sp)
    800037a2:	f04a                	sd	s2,32(sp)
    800037a4:	ec4e                	sd	s3,24(sp)
    800037a6:	e852                	sd	s4,16(sp)
    800037a8:	e456                	sd	s5,8(sp)
    800037aa:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800037ac:	00015497          	auipc	s1,0x15
    800037b0:	39448493          	addi	s1,s1,916 # 80018b40 <log>
    800037b4:	8526                	mv	a0,s1
    800037b6:	00003097          	auipc	ra,0x3
    800037ba:	c16080e7          	jalr	-1002(ra) # 800063cc <acquire>
  log.outstanding -= 1;
    800037be:	509c                	lw	a5,32(s1)
    800037c0:	37fd                	addiw	a5,a5,-1
    800037c2:	0007891b          	sext.w	s2,a5
    800037c6:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800037c8:	50dc                	lw	a5,36(s1)
    800037ca:	efb9                	bnez	a5,80003828 <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    800037cc:	06091663          	bnez	s2,80003838 <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    800037d0:	00015497          	auipc	s1,0x15
    800037d4:	37048493          	addi	s1,s1,880 # 80018b40 <log>
    800037d8:	4785                	li	a5,1
    800037da:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800037dc:	8526                	mv	a0,s1
    800037de:	00003097          	auipc	ra,0x3
    800037e2:	ca2080e7          	jalr	-862(ra) # 80006480 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800037e6:	54dc                	lw	a5,44(s1)
    800037e8:	06f04763          	bgtz	a5,80003856 <end_op+0xbc>
    acquire(&log.lock);
    800037ec:	00015497          	auipc	s1,0x15
    800037f0:	35448493          	addi	s1,s1,852 # 80018b40 <log>
    800037f4:	8526                	mv	a0,s1
    800037f6:	00003097          	auipc	ra,0x3
    800037fa:	bd6080e7          	jalr	-1066(ra) # 800063cc <acquire>
    log.committing = 0;
    800037fe:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003802:	8526                	mv	a0,s1
    80003804:	ffffe097          	auipc	ra,0xffffe
    80003808:	ef4080e7          	jalr	-268(ra) # 800016f8 <wakeup>
    release(&log.lock);
    8000380c:	8526                	mv	a0,s1
    8000380e:	00003097          	auipc	ra,0x3
    80003812:	c72080e7          	jalr	-910(ra) # 80006480 <release>
}
    80003816:	70e2                	ld	ra,56(sp)
    80003818:	7442                	ld	s0,48(sp)
    8000381a:	74a2                	ld	s1,40(sp)
    8000381c:	7902                	ld	s2,32(sp)
    8000381e:	69e2                	ld	s3,24(sp)
    80003820:	6a42                	ld	s4,16(sp)
    80003822:	6aa2                	ld	s5,8(sp)
    80003824:	6121                	addi	sp,sp,64
    80003826:	8082                	ret
    panic("log.committing");
    80003828:	00005517          	auipc	a0,0x5
    8000382c:	df050513          	addi	a0,a0,-528 # 80008618 <syscalls+0x228>
    80003830:	00002097          	auipc	ra,0x2
    80003834:	652080e7          	jalr	1618(ra) # 80005e82 <panic>
    wakeup(&log);
    80003838:	00015497          	auipc	s1,0x15
    8000383c:	30848493          	addi	s1,s1,776 # 80018b40 <log>
    80003840:	8526                	mv	a0,s1
    80003842:	ffffe097          	auipc	ra,0xffffe
    80003846:	eb6080e7          	jalr	-330(ra) # 800016f8 <wakeup>
  release(&log.lock);
    8000384a:	8526                	mv	a0,s1
    8000384c:	00003097          	auipc	ra,0x3
    80003850:	c34080e7          	jalr	-972(ra) # 80006480 <release>
  if(do_commit){
    80003854:	b7c9                	j	80003816 <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003856:	00015a97          	auipc	s5,0x15
    8000385a:	31aa8a93          	addi	s5,s5,794 # 80018b70 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    8000385e:	00015a17          	auipc	s4,0x15
    80003862:	2e2a0a13          	addi	s4,s4,738 # 80018b40 <log>
    80003866:	018a2583          	lw	a1,24(s4)
    8000386a:	012585bb          	addw	a1,a1,s2
    8000386e:	2585                	addiw	a1,a1,1
    80003870:	028a2503          	lw	a0,40(s4)
    80003874:	fffff097          	auipc	ra,0xfffff
    80003878:	cca080e7          	jalr	-822(ra) # 8000253e <bread>
    8000387c:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000387e:	000aa583          	lw	a1,0(s5)
    80003882:	028a2503          	lw	a0,40(s4)
    80003886:	fffff097          	auipc	ra,0xfffff
    8000388a:	cb8080e7          	jalr	-840(ra) # 8000253e <bread>
    8000388e:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003890:	40000613          	li	a2,1024
    80003894:	05850593          	addi	a1,a0,88
    80003898:	05848513          	addi	a0,s1,88
    8000389c:	ffffd097          	auipc	ra,0xffffd
    800038a0:	93c080e7          	jalr	-1732(ra) # 800001d8 <memmove>
    bwrite(to);  // write the log
    800038a4:	8526                	mv	a0,s1
    800038a6:	fffff097          	auipc	ra,0xfffff
    800038aa:	d8a080e7          	jalr	-630(ra) # 80002630 <bwrite>
    brelse(from);
    800038ae:	854e                	mv	a0,s3
    800038b0:	fffff097          	auipc	ra,0xfffff
    800038b4:	dbe080e7          	jalr	-578(ra) # 8000266e <brelse>
    brelse(to);
    800038b8:	8526                	mv	a0,s1
    800038ba:	fffff097          	auipc	ra,0xfffff
    800038be:	db4080e7          	jalr	-588(ra) # 8000266e <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800038c2:	2905                	addiw	s2,s2,1
    800038c4:	0a91                	addi	s5,s5,4
    800038c6:	02ca2783          	lw	a5,44(s4)
    800038ca:	f8f94ee3          	blt	s2,a5,80003866 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800038ce:	00000097          	auipc	ra,0x0
    800038d2:	c6a080e7          	jalr	-918(ra) # 80003538 <write_head>
    install_trans(0); // Now install writes to home locations
    800038d6:	4501                	li	a0,0
    800038d8:	00000097          	auipc	ra,0x0
    800038dc:	cda080e7          	jalr	-806(ra) # 800035b2 <install_trans>
    log.lh.n = 0;
    800038e0:	00015797          	auipc	a5,0x15
    800038e4:	2807a623          	sw	zero,652(a5) # 80018b6c <log+0x2c>
    write_head();    // Erase the transaction from the log
    800038e8:	00000097          	auipc	ra,0x0
    800038ec:	c50080e7          	jalr	-944(ra) # 80003538 <write_head>
    800038f0:	bdf5                	j	800037ec <end_op+0x52>

00000000800038f2 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800038f2:	1101                	addi	sp,sp,-32
    800038f4:	ec06                	sd	ra,24(sp)
    800038f6:	e822                	sd	s0,16(sp)
    800038f8:	e426                	sd	s1,8(sp)
    800038fa:	e04a                	sd	s2,0(sp)
    800038fc:	1000                	addi	s0,sp,32
    800038fe:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003900:	00015917          	auipc	s2,0x15
    80003904:	24090913          	addi	s2,s2,576 # 80018b40 <log>
    80003908:	854a                	mv	a0,s2
    8000390a:	00003097          	auipc	ra,0x3
    8000390e:	ac2080e7          	jalr	-1342(ra) # 800063cc <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003912:	02c92603          	lw	a2,44(s2)
    80003916:	47f5                	li	a5,29
    80003918:	06c7c563          	blt	a5,a2,80003982 <log_write+0x90>
    8000391c:	00015797          	auipc	a5,0x15
    80003920:	2407a783          	lw	a5,576(a5) # 80018b5c <log+0x1c>
    80003924:	37fd                	addiw	a5,a5,-1
    80003926:	04f65e63          	bge	a2,a5,80003982 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000392a:	00015797          	auipc	a5,0x15
    8000392e:	2367a783          	lw	a5,566(a5) # 80018b60 <log+0x20>
    80003932:	06f05063          	blez	a5,80003992 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003936:	4781                	li	a5,0
    80003938:	06c05563          	blez	a2,800039a2 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000393c:	44cc                	lw	a1,12(s1)
    8000393e:	00015717          	auipc	a4,0x15
    80003942:	23270713          	addi	a4,a4,562 # 80018b70 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003946:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003948:	4314                	lw	a3,0(a4)
    8000394a:	04b68c63          	beq	a3,a1,800039a2 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    8000394e:	2785                	addiw	a5,a5,1
    80003950:	0711                	addi	a4,a4,4
    80003952:	fef61be3          	bne	a2,a5,80003948 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003956:	0621                	addi	a2,a2,8
    80003958:	060a                	slli	a2,a2,0x2
    8000395a:	00015797          	auipc	a5,0x15
    8000395e:	1e678793          	addi	a5,a5,486 # 80018b40 <log>
    80003962:	963e                	add	a2,a2,a5
    80003964:	44dc                	lw	a5,12(s1)
    80003966:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003968:	8526                	mv	a0,s1
    8000396a:	fffff097          	auipc	ra,0xfffff
    8000396e:	da2080e7          	jalr	-606(ra) # 8000270c <bpin>
    log.lh.n++;
    80003972:	00015717          	auipc	a4,0x15
    80003976:	1ce70713          	addi	a4,a4,462 # 80018b40 <log>
    8000397a:	575c                	lw	a5,44(a4)
    8000397c:	2785                	addiw	a5,a5,1
    8000397e:	d75c                	sw	a5,44(a4)
    80003980:	a835                	j	800039bc <log_write+0xca>
    panic("too big a transaction");
    80003982:	00005517          	auipc	a0,0x5
    80003986:	ca650513          	addi	a0,a0,-858 # 80008628 <syscalls+0x238>
    8000398a:	00002097          	auipc	ra,0x2
    8000398e:	4f8080e7          	jalr	1272(ra) # 80005e82 <panic>
    panic("log_write outside of trans");
    80003992:	00005517          	auipc	a0,0x5
    80003996:	cae50513          	addi	a0,a0,-850 # 80008640 <syscalls+0x250>
    8000399a:	00002097          	auipc	ra,0x2
    8000399e:	4e8080e7          	jalr	1256(ra) # 80005e82 <panic>
  log.lh.block[i] = b->blockno;
    800039a2:	00878713          	addi	a4,a5,8
    800039a6:	00271693          	slli	a3,a4,0x2
    800039aa:	00015717          	auipc	a4,0x15
    800039ae:	19670713          	addi	a4,a4,406 # 80018b40 <log>
    800039b2:	9736                	add	a4,a4,a3
    800039b4:	44d4                	lw	a3,12(s1)
    800039b6:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800039b8:	faf608e3          	beq	a2,a5,80003968 <log_write+0x76>
  }
  release(&log.lock);
    800039bc:	00015517          	auipc	a0,0x15
    800039c0:	18450513          	addi	a0,a0,388 # 80018b40 <log>
    800039c4:	00003097          	auipc	ra,0x3
    800039c8:	abc080e7          	jalr	-1348(ra) # 80006480 <release>
}
    800039cc:	60e2                	ld	ra,24(sp)
    800039ce:	6442                	ld	s0,16(sp)
    800039d0:	64a2                	ld	s1,8(sp)
    800039d2:	6902                	ld	s2,0(sp)
    800039d4:	6105                	addi	sp,sp,32
    800039d6:	8082                	ret

00000000800039d8 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800039d8:	1101                	addi	sp,sp,-32
    800039da:	ec06                	sd	ra,24(sp)
    800039dc:	e822                	sd	s0,16(sp)
    800039de:	e426                	sd	s1,8(sp)
    800039e0:	e04a                	sd	s2,0(sp)
    800039e2:	1000                	addi	s0,sp,32
    800039e4:	84aa                	mv	s1,a0
    800039e6:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800039e8:	00005597          	auipc	a1,0x5
    800039ec:	c7858593          	addi	a1,a1,-904 # 80008660 <syscalls+0x270>
    800039f0:	0521                	addi	a0,a0,8
    800039f2:	00003097          	auipc	ra,0x3
    800039f6:	94a080e7          	jalr	-1718(ra) # 8000633c <initlock>
  lk->name = name;
    800039fa:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800039fe:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003a02:	0204a423          	sw	zero,40(s1)
}
    80003a06:	60e2                	ld	ra,24(sp)
    80003a08:	6442                	ld	s0,16(sp)
    80003a0a:	64a2                	ld	s1,8(sp)
    80003a0c:	6902                	ld	s2,0(sp)
    80003a0e:	6105                	addi	sp,sp,32
    80003a10:	8082                	ret

0000000080003a12 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003a12:	1101                	addi	sp,sp,-32
    80003a14:	ec06                	sd	ra,24(sp)
    80003a16:	e822                	sd	s0,16(sp)
    80003a18:	e426                	sd	s1,8(sp)
    80003a1a:	e04a                	sd	s2,0(sp)
    80003a1c:	1000                	addi	s0,sp,32
    80003a1e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003a20:	00850913          	addi	s2,a0,8
    80003a24:	854a                	mv	a0,s2
    80003a26:	00003097          	auipc	ra,0x3
    80003a2a:	9a6080e7          	jalr	-1626(ra) # 800063cc <acquire>
  while (lk->locked) {
    80003a2e:	409c                	lw	a5,0(s1)
    80003a30:	cb89                	beqz	a5,80003a42 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003a32:	85ca                	mv	a1,s2
    80003a34:	8526                	mv	a0,s1
    80003a36:	ffffe097          	auipc	ra,0xffffe
    80003a3a:	c5e080e7          	jalr	-930(ra) # 80001694 <sleep>
  while (lk->locked) {
    80003a3e:	409c                	lw	a5,0(s1)
    80003a40:	fbed                	bnez	a5,80003a32 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003a42:	4785                	li	a5,1
    80003a44:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003a46:	ffffd097          	auipc	ra,0xffffd
    80003a4a:	4ee080e7          	jalr	1262(ra) # 80000f34 <myproc>
    80003a4e:	591c                	lw	a5,48(a0)
    80003a50:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003a52:	854a                	mv	a0,s2
    80003a54:	00003097          	auipc	ra,0x3
    80003a58:	a2c080e7          	jalr	-1492(ra) # 80006480 <release>
}
    80003a5c:	60e2                	ld	ra,24(sp)
    80003a5e:	6442                	ld	s0,16(sp)
    80003a60:	64a2                	ld	s1,8(sp)
    80003a62:	6902                	ld	s2,0(sp)
    80003a64:	6105                	addi	sp,sp,32
    80003a66:	8082                	ret

0000000080003a68 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003a68:	1101                	addi	sp,sp,-32
    80003a6a:	ec06                	sd	ra,24(sp)
    80003a6c:	e822                	sd	s0,16(sp)
    80003a6e:	e426                	sd	s1,8(sp)
    80003a70:	e04a                	sd	s2,0(sp)
    80003a72:	1000                	addi	s0,sp,32
    80003a74:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003a76:	00850913          	addi	s2,a0,8
    80003a7a:	854a                	mv	a0,s2
    80003a7c:	00003097          	auipc	ra,0x3
    80003a80:	950080e7          	jalr	-1712(ra) # 800063cc <acquire>
  lk->locked = 0;
    80003a84:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003a88:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003a8c:	8526                	mv	a0,s1
    80003a8e:	ffffe097          	auipc	ra,0xffffe
    80003a92:	c6a080e7          	jalr	-918(ra) # 800016f8 <wakeup>
  release(&lk->lk);
    80003a96:	854a                	mv	a0,s2
    80003a98:	00003097          	auipc	ra,0x3
    80003a9c:	9e8080e7          	jalr	-1560(ra) # 80006480 <release>
}
    80003aa0:	60e2                	ld	ra,24(sp)
    80003aa2:	6442                	ld	s0,16(sp)
    80003aa4:	64a2                	ld	s1,8(sp)
    80003aa6:	6902                	ld	s2,0(sp)
    80003aa8:	6105                	addi	sp,sp,32
    80003aaa:	8082                	ret

0000000080003aac <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003aac:	7179                	addi	sp,sp,-48
    80003aae:	f406                	sd	ra,40(sp)
    80003ab0:	f022                	sd	s0,32(sp)
    80003ab2:	ec26                	sd	s1,24(sp)
    80003ab4:	e84a                	sd	s2,16(sp)
    80003ab6:	e44e                	sd	s3,8(sp)
    80003ab8:	1800                	addi	s0,sp,48
    80003aba:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003abc:	00850913          	addi	s2,a0,8
    80003ac0:	854a                	mv	a0,s2
    80003ac2:	00003097          	auipc	ra,0x3
    80003ac6:	90a080e7          	jalr	-1782(ra) # 800063cc <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003aca:	409c                	lw	a5,0(s1)
    80003acc:	ef99                	bnez	a5,80003aea <holdingsleep+0x3e>
    80003ace:	4481                	li	s1,0
  release(&lk->lk);
    80003ad0:	854a                	mv	a0,s2
    80003ad2:	00003097          	auipc	ra,0x3
    80003ad6:	9ae080e7          	jalr	-1618(ra) # 80006480 <release>
  return r;
}
    80003ada:	8526                	mv	a0,s1
    80003adc:	70a2                	ld	ra,40(sp)
    80003ade:	7402                	ld	s0,32(sp)
    80003ae0:	64e2                	ld	s1,24(sp)
    80003ae2:	6942                	ld	s2,16(sp)
    80003ae4:	69a2                	ld	s3,8(sp)
    80003ae6:	6145                	addi	sp,sp,48
    80003ae8:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003aea:	0284a983          	lw	s3,40(s1)
    80003aee:	ffffd097          	auipc	ra,0xffffd
    80003af2:	446080e7          	jalr	1094(ra) # 80000f34 <myproc>
    80003af6:	5904                	lw	s1,48(a0)
    80003af8:	413484b3          	sub	s1,s1,s3
    80003afc:	0014b493          	seqz	s1,s1
    80003b00:	bfc1                	j	80003ad0 <holdingsleep+0x24>

0000000080003b02 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003b02:	1141                	addi	sp,sp,-16
    80003b04:	e406                	sd	ra,8(sp)
    80003b06:	e022                	sd	s0,0(sp)
    80003b08:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003b0a:	00005597          	auipc	a1,0x5
    80003b0e:	b6658593          	addi	a1,a1,-1178 # 80008670 <syscalls+0x280>
    80003b12:	00015517          	auipc	a0,0x15
    80003b16:	17650513          	addi	a0,a0,374 # 80018c88 <ftable>
    80003b1a:	00003097          	auipc	ra,0x3
    80003b1e:	822080e7          	jalr	-2014(ra) # 8000633c <initlock>
}
    80003b22:	60a2                	ld	ra,8(sp)
    80003b24:	6402                	ld	s0,0(sp)
    80003b26:	0141                	addi	sp,sp,16
    80003b28:	8082                	ret

0000000080003b2a <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003b2a:	1101                	addi	sp,sp,-32
    80003b2c:	ec06                	sd	ra,24(sp)
    80003b2e:	e822                	sd	s0,16(sp)
    80003b30:	e426                	sd	s1,8(sp)
    80003b32:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003b34:	00015517          	auipc	a0,0x15
    80003b38:	15450513          	addi	a0,a0,340 # 80018c88 <ftable>
    80003b3c:	00003097          	auipc	ra,0x3
    80003b40:	890080e7          	jalr	-1904(ra) # 800063cc <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b44:	00015497          	auipc	s1,0x15
    80003b48:	15c48493          	addi	s1,s1,348 # 80018ca0 <ftable+0x18>
    80003b4c:	00016717          	auipc	a4,0x16
    80003b50:	0f470713          	addi	a4,a4,244 # 80019c40 <disk>
    if(f->ref == 0){
    80003b54:	40dc                	lw	a5,4(s1)
    80003b56:	cf99                	beqz	a5,80003b74 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b58:	02848493          	addi	s1,s1,40
    80003b5c:	fee49ce3          	bne	s1,a4,80003b54 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003b60:	00015517          	auipc	a0,0x15
    80003b64:	12850513          	addi	a0,a0,296 # 80018c88 <ftable>
    80003b68:	00003097          	auipc	ra,0x3
    80003b6c:	918080e7          	jalr	-1768(ra) # 80006480 <release>
  return 0;
    80003b70:	4481                	li	s1,0
    80003b72:	a819                	j	80003b88 <filealloc+0x5e>
      f->ref = 1;
    80003b74:	4785                	li	a5,1
    80003b76:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003b78:	00015517          	auipc	a0,0x15
    80003b7c:	11050513          	addi	a0,a0,272 # 80018c88 <ftable>
    80003b80:	00003097          	auipc	ra,0x3
    80003b84:	900080e7          	jalr	-1792(ra) # 80006480 <release>
}
    80003b88:	8526                	mv	a0,s1
    80003b8a:	60e2                	ld	ra,24(sp)
    80003b8c:	6442                	ld	s0,16(sp)
    80003b8e:	64a2                	ld	s1,8(sp)
    80003b90:	6105                	addi	sp,sp,32
    80003b92:	8082                	ret

0000000080003b94 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003b94:	1101                	addi	sp,sp,-32
    80003b96:	ec06                	sd	ra,24(sp)
    80003b98:	e822                	sd	s0,16(sp)
    80003b9a:	e426                	sd	s1,8(sp)
    80003b9c:	1000                	addi	s0,sp,32
    80003b9e:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003ba0:	00015517          	auipc	a0,0x15
    80003ba4:	0e850513          	addi	a0,a0,232 # 80018c88 <ftable>
    80003ba8:	00003097          	auipc	ra,0x3
    80003bac:	824080e7          	jalr	-2012(ra) # 800063cc <acquire>
  if(f->ref < 1)
    80003bb0:	40dc                	lw	a5,4(s1)
    80003bb2:	02f05263          	blez	a5,80003bd6 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003bb6:	2785                	addiw	a5,a5,1
    80003bb8:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003bba:	00015517          	auipc	a0,0x15
    80003bbe:	0ce50513          	addi	a0,a0,206 # 80018c88 <ftable>
    80003bc2:	00003097          	auipc	ra,0x3
    80003bc6:	8be080e7          	jalr	-1858(ra) # 80006480 <release>
  return f;
}
    80003bca:	8526                	mv	a0,s1
    80003bcc:	60e2                	ld	ra,24(sp)
    80003bce:	6442                	ld	s0,16(sp)
    80003bd0:	64a2                	ld	s1,8(sp)
    80003bd2:	6105                	addi	sp,sp,32
    80003bd4:	8082                	ret
    panic("filedup");
    80003bd6:	00005517          	auipc	a0,0x5
    80003bda:	aa250513          	addi	a0,a0,-1374 # 80008678 <syscalls+0x288>
    80003bde:	00002097          	auipc	ra,0x2
    80003be2:	2a4080e7          	jalr	676(ra) # 80005e82 <panic>

0000000080003be6 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003be6:	7139                	addi	sp,sp,-64
    80003be8:	fc06                	sd	ra,56(sp)
    80003bea:	f822                	sd	s0,48(sp)
    80003bec:	f426                	sd	s1,40(sp)
    80003bee:	f04a                	sd	s2,32(sp)
    80003bf0:	ec4e                	sd	s3,24(sp)
    80003bf2:	e852                	sd	s4,16(sp)
    80003bf4:	e456                	sd	s5,8(sp)
    80003bf6:	0080                	addi	s0,sp,64
    80003bf8:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003bfa:	00015517          	auipc	a0,0x15
    80003bfe:	08e50513          	addi	a0,a0,142 # 80018c88 <ftable>
    80003c02:	00002097          	auipc	ra,0x2
    80003c06:	7ca080e7          	jalr	1994(ra) # 800063cc <acquire>
  if(f->ref < 1)
    80003c0a:	40dc                	lw	a5,4(s1)
    80003c0c:	06f05163          	blez	a5,80003c6e <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003c10:	37fd                	addiw	a5,a5,-1
    80003c12:	0007871b          	sext.w	a4,a5
    80003c16:	c0dc                	sw	a5,4(s1)
    80003c18:	06e04363          	bgtz	a4,80003c7e <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003c1c:	0004a903          	lw	s2,0(s1)
    80003c20:	0094ca83          	lbu	s5,9(s1)
    80003c24:	0104ba03          	ld	s4,16(s1)
    80003c28:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003c2c:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003c30:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003c34:	00015517          	auipc	a0,0x15
    80003c38:	05450513          	addi	a0,a0,84 # 80018c88 <ftable>
    80003c3c:	00003097          	auipc	ra,0x3
    80003c40:	844080e7          	jalr	-1980(ra) # 80006480 <release>

  if(ff.type == FD_PIPE){
    80003c44:	4785                	li	a5,1
    80003c46:	04f90d63          	beq	s2,a5,80003ca0 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003c4a:	3979                	addiw	s2,s2,-2
    80003c4c:	4785                	li	a5,1
    80003c4e:	0527e063          	bltu	a5,s2,80003c8e <fileclose+0xa8>
    begin_op();
    80003c52:	00000097          	auipc	ra,0x0
    80003c56:	ac8080e7          	jalr	-1336(ra) # 8000371a <begin_op>
    iput(ff.ip);
    80003c5a:	854e                	mv	a0,s3
    80003c5c:	fffff097          	auipc	ra,0xfffff
    80003c60:	2b6080e7          	jalr	694(ra) # 80002f12 <iput>
    end_op();
    80003c64:	00000097          	auipc	ra,0x0
    80003c68:	b36080e7          	jalr	-1226(ra) # 8000379a <end_op>
    80003c6c:	a00d                	j	80003c8e <fileclose+0xa8>
    panic("fileclose");
    80003c6e:	00005517          	auipc	a0,0x5
    80003c72:	a1250513          	addi	a0,a0,-1518 # 80008680 <syscalls+0x290>
    80003c76:	00002097          	auipc	ra,0x2
    80003c7a:	20c080e7          	jalr	524(ra) # 80005e82 <panic>
    release(&ftable.lock);
    80003c7e:	00015517          	auipc	a0,0x15
    80003c82:	00a50513          	addi	a0,a0,10 # 80018c88 <ftable>
    80003c86:	00002097          	auipc	ra,0x2
    80003c8a:	7fa080e7          	jalr	2042(ra) # 80006480 <release>
  }
}
    80003c8e:	70e2                	ld	ra,56(sp)
    80003c90:	7442                	ld	s0,48(sp)
    80003c92:	74a2                	ld	s1,40(sp)
    80003c94:	7902                	ld	s2,32(sp)
    80003c96:	69e2                	ld	s3,24(sp)
    80003c98:	6a42                	ld	s4,16(sp)
    80003c9a:	6aa2                	ld	s5,8(sp)
    80003c9c:	6121                	addi	sp,sp,64
    80003c9e:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003ca0:	85d6                	mv	a1,s5
    80003ca2:	8552                	mv	a0,s4
    80003ca4:	00000097          	auipc	ra,0x0
    80003ca8:	34c080e7          	jalr	844(ra) # 80003ff0 <pipeclose>
    80003cac:	b7cd                	j	80003c8e <fileclose+0xa8>

0000000080003cae <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003cae:	715d                	addi	sp,sp,-80
    80003cb0:	e486                	sd	ra,72(sp)
    80003cb2:	e0a2                	sd	s0,64(sp)
    80003cb4:	fc26                	sd	s1,56(sp)
    80003cb6:	f84a                	sd	s2,48(sp)
    80003cb8:	f44e                	sd	s3,40(sp)
    80003cba:	0880                	addi	s0,sp,80
    80003cbc:	84aa                	mv	s1,a0
    80003cbe:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003cc0:	ffffd097          	auipc	ra,0xffffd
    80003cc4:	274080e7          	jalr	628(ra) # 80000f34 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003cc8:	409c                	lw	a5,0(s1)
    80003cca:	37f9                	addiw	a5,a5,-2
    80003ccc:	4705                	li	a4,1
    80003cce:	04f76763          	bltu	a4,a5,80003d1c <filestat+0x6e>
    80003cd2:	892a                	mv	s2,a0
    ilock(f->ip);
    80003cd4:	6c88                	ld	a0,24(s1)
    80003cd6:	fffff097          	auipc	ra,0xfffff
    80003cda:	082080e7          	jalr	130(ra) # 80002d58 <ilock>
    stati(f->ip, &st);
    80003cde:	fb840593          	addi	a1,s0,-72
    80003ce2:	6c88                	ld	a0,24(s1)
    80003ce4:	fffff097          	auipc	ra,0xfffff
    80003ce8:	2fe080e7          	jalr	766(ra) # 80002fe2 <stati>
    iunlock(f->ip);
    80003cec:	6c88                	ld	a0,24(s1)
    80003cee:	fffff097          	auipc	ra,0xfffff
    80003cf2:	12c080e7          	jalr	300(ra) # 80002e1a <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003cf6:	46e1                	li	a3,24
    80003cf8:	fb840613          	addi	a2,s0,-72
    80003cfc:	85ce                	mv	a1,s3
    80003cfe:	05093503          	ld	a0,80(s2)
    80003d02:	ffffd097          	auipc	ra,0xffffd
    80003d06:	e14080e7          	jalr	-492(ra) # 80000b16 <copyout>
    80003d0a:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003d0e:	60a6                	ld	ra,72(sp)
    80003d10:	6406                	ld	s0,64(sp)
    80003d12:	74e2                	ld	s1,56(sp)
    80003d14:	7942                	ld	s2,48(sp)
    80003d16:	79a2                	ld	s3,40(sp)
    80003d18:	6161                	addi	sp,sp,80
    80003d1a:	8082                	ret
  return -1;
    80003d1c:	557d                	li	a0,-1
    80003d1e:	bfc5                	j	80003d0e <filestat+0x60>

0000000080003d20 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003d20:	7179                	addi	sp,sp,-48
    80003d22:	f406                	sd	ra,40(sp)
    80003d24:	f022                	sd	s0,32(sp)
    80003d26:	ec26                	sd	s1,24(sp)
    80003d28:	e84a                	sd	s2,16(sp)
    80003d2a:	e44e                	sd	s3,8(sp)
    80003d2c:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003d2e:	00854783          	lbu	a5,8(a0)
    80003d32:	c3d5                	beqz	a5,80003dd6 <fileread+0xb6>
    80003d34:	84aa                	mv	s1,a0
    80003d36:	89ae                	mv	s3,a1
    80003d38:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003d3a:	411c                	lw	a5,0(a0)
    80003d3c:	4705                	li	a4,1
    80003d3e:	04e78963          	beq	a5,a4,80003d90 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003d42:	470d                	li	a4,3
    80003d44:	04e78d63          	beq	a5,a4,80003d9e <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d48:	4709                	li	a4,2
    80003d4a:	06e79e63          	bne	a5,a4,80003dc6 <fileread+0xa6>
    ilock(f->ip);
    80003d4e:	6d08                	ld	a0,24(a0)
    80003d50:	fffff097          	auipc	ra,0xfffff
    80003d54:	008080e7          	jalr	8(ra) # 80002d58 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003d58:	874a                	mv	a4,s2
    80003d5a:	5094                	lw	a3,32(s1)
    80003d5c:	864e                	mv	a2,s3
    80003d5e:	4585                	li	a1,1
    80003d60:	6c88                	ld	a0,24(s1)
    80003d62:	fffff097          	auipc	ra,0xfffff
    80003d66:	2aa080e7          	jalr	682(ra) # 8000300c <readi>
    80003d6a:	892a                	mv	s2,a0
    80003d6c:	00a05563          	blez	a0,80003d76 <fileread+0x56>
      f->off += r;
    80003d70:	509c                	lw	a5,32(s1)
    80003d72:	9fa9                	addw	a5,a5,a0
    80003d74:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003d76:	6c88                	ld	a0,24(s1)
    80003d78:	fffff097          	auipc	ra,0xfffff
    80003d7c:	0a2080e7          	jalr	162(ra) # 80002e1a <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003d80:	854a                	mv	a0,s2
    80003d82:	70a2                	ld	ra,40(sp)
    80003d84:	7402                	ld	s0,32(sp)
    80003d86:	64e2                	ld	s1,24(sp)
    80003d88:	6942                	ld	s2,16(sp)
    80003d8a:	69a2                	ld	s3,8(sp)
    80003d8c:	6145                	addi	sp,sp,48
    80003d8e:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003d90:	6908                	ld	a0,16(a0)
    80003d92:	00000097          	auipc	ra,0x0
    80003d96:	3ce080e7          	jalr	974(ra) # 80004160 <piperead>
    80003d9a:	892a                	mv	s2,a0
    80003d9c:	b7d5                	j	80003d80 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003d9e:	02451783          	lh	a5,36(a0)
    80003da2:	03079693          	slli	a3,a5,0x30
    80003da6:	92c1                	srli	a3,a3,0x30
    80003da8:	4725                	li	a4,9
    80003daa:	02d76863          	bltu	a4,a3,80003dda <fileread+0xba>
    80003dae:	0792                	slli	a5,a5,0x4
    80003db0:	00015717          	auipc	a4,0x15
    80003db4:	e3870713          	addi	a4,a4,-456 # 80018be8 <devsw>
    80003db8:	97ba                	add	a5,a5,a4
    80003dba:	639c                	ld	a5,0(a5)
    80003dbc:	c38d                	beqz	a5,80003dde <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003dbe:	4505                	li	a0,1
    80003dc0:	9782                	jalr	a5
    80003dc2:	892a                	mv	s2,a0
    80003dc4:	bf75                	j	80003d80 <fileread+0x60>
    panic("fileread");
    80003dc6:	00005517          	auipc	a0,0x5
    80003dca:	8ca50513          	addi	a0,a0,-1846 # 80008690 <syscalls+0x2a0>
    80003dce:	00002097          	auipc	ra,0x2
    80003dd2:	0b4080e7          	jalr	180(ra) # 80005e82 <panic>
    return -1;
    80003dd6:	597d                	li	s2,-1
    80003dd8:	b765                	j	80003d80 <fileread+0x60>
      return -1;
    80003dda:	597d                	li	s2,-1
    80003ddc:	b755                	j	80003d80 <fileread+0x60>
    80003dde:	597d                	li	s2,-1
    80003de0:	b745                	j	80003d80 <fileread+0x60>

0000000080003de2 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003de2:	715d                	addi	sp,sp,-80
    80003de4:	e486                	sd	ra,72(sp)
    80003de6:	e0a2                	sd	s0,64(sp)
    80003de8:	fc26                	sd	s1,56(sp)
    80003dea:	f84a                	sd	s2,48(sp)
    80003dec:	f44e                	sd	s3,40(sp)
    80003dee:	f052                	sd	s4,32(sp)
    80003df0:	ec56                	sd	s5,24(sp)
    80003df2:	e85a                	sd	s6,16(sp)
    80003df4:	e45e                	sd	s7,8(sp)
    80003df6:	e062                	sd	s8,0(sp)
    80003df8:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003dfa:	00954783          	lbu	a5,9(a0)
    80003dfe:	10078663          	beqz	a5,80003f0a <filewrite+0x128>
    80003e02:	892a                	mv	s2,a0
    80003e04:	8aae                	mv	s5,a1
    80003e06:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003e08:	411c                	lw	a5,0(a0)
    80003e0a:	4705                	li	a4,1
    80003e0c:	02e78263          	beq	a5,a4,80003e30 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003e10:	470d                	li	a4,3
    80003e12:	02e78663          	beq	a5,a4,80003e3e <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003e16:	4709                	li	a4,2
    80003e18:	0ee79163          	bne	a5,a4,80003efa <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003e1c:	0ac05d63          	blez	a2,80003ed6 <filewrite+0xf4>
    int i = 0;
    80003e20:	4981                	li	s3,0
    80003e22:	6b05                	lui	s6,0x1
    80003e24:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003e28:	6b85                	lui	s7,0x1
    80003e2a:	c00b8b9b          	addiw	s7,s7,-1024
    80003e2e:	a861                	j	80003ec6 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003e30:	6908                	ld	a0,16(a0)
    80003e32:	00000097          	auipc	ra,0x0
    80003e36:	22e080e7          	jalr	558(ra) # 80004060 <pipewrite>
    80003e3a:	8a2a                	mv	s4,a0
    80003e3c:	a045                	j	80003edc <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003e3e:	02451783          	lh	a5,36(a0)
    80003e42:	03079693          	slli	a3,a5,0x30
    80003e46:	92c1                	srli	a3,a3,0x30
    80003e48:	4725                	li	a4,9
    80003e4a:	0cd76263          	bltu	a4,a3,80003f0e <filewrite+0x12c>
    80003e4e:	0792                	slli	a5,a5,0x4
    80003e50:	00015717          	auipc	a4,0x15
    80003e54:	d9870713          	addi	a4,a4,-616 # 80018be8 <devsw>
    80003e58:	97ba                	add	a5,a5,a4
    80003e5a:	679c                	ld	a5,8(a5)
    80003e5c:	cbdd                	beqz	a5,80003f12 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003e5e:	4505                	li	a0,1
    80003e60:	9782                	jalr	a5
    80003e62:	8a2a                	mv	s4,a0
    80003e64:	a8a5                	j	80003edc <filewrite+0xfa>
    80003e66:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003e6a:	00000097          	auipc	ra,0x0
    80003e6e:	8b0080e7          	jalr	-1872(ra) # 8000371a <begin_op>
      ilock(f->ip);
    80003e72:	01893503          	ld	a0,24(s2)
    80003e76:	fffff097          	auipc	ra,0xfffff
    80003e7a:	ee2080e7          	jalr	-286(ra) # 80002d58 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003e7e:	8762                	mv	a4,s8
    80003e80:	02092683          	lw	a3,32(s2)
    80003e84:	01598633          	add	a2,s3,s5
    80003e88:	4585                	li	a1,1
    80003e8a:	01893503          	ld	a0,24(s2)
    80003e8e:	fffff097          	auipc	ra,0xfffff
    80003e92:	276080e7          	jalr	630(ra) # 80003104 <writei>
    80003e96:	84aa                	mv	s1,a0
    80003e98:	00a05763          	blez	a0,80003ea6 <filewrite+0xc4>
        f->off += r;
    80003e9c:	02092783          	lw	a5,32(s2)
    80003ea0:	9fa9                	addw	a5,a5,a0
    80003ea2:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003ea6:	01893503          	ld	a0,24(s2)
    80003eaa:	fffff097          	auipc	ra,0xfffff
    80003eae:	f70080e7          	jalr	-144(ra) # 80002e1a <iunlock>
      end_op();
    80003eb2:	00000097          	auipc	ra,0x0
    80003eb6:	8e8080e7          	jalr	-1816(ra) # 8000379a <end_op>

      if(r != n1){
    80003eba:	009c1f63          	bne	s8,s1,80003ed8 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003ebe:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003ec2:	0149db63          	bge	s3,s4,80003ed8 <filewrite+0xf6>
      int n1 = n - i;
    80003ec6:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003eca:	84be                	mv	s1,a5
    80003ecc:	2781                	sext.w	a5,a5
    80003ece:	f8fb5ce3          	bge	s6,a5,80003e66 <filewrite+0x84>
    80003ed2:	84de                	mv	s1,s7
    80003ed4:	bf49                	j	80003e66 <filewrite+0x84>
    int i = 0;
    80003ed6:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003ed8:	013a1f63          	bne	s4,s3,80003ef6 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003edc:	8552                	mv	a0,s4
    80003ede:	60a6                	ld	ra,72(sp)
    80003ee0:	6406                	ld	s0,64(sp)
    80003ee2:	74e2                	ld	s1,56(sp)
    80003ee4:	7942                	ld	s2,48(sp)
    80003ee6:	79a2                	ld	s3,40(sp)
    80003ee8:	7a02                	ld	s4,32(sp)
    80003eea:	6ae2                	ld	s5,24(sp)
    80003eec:	6b42                	ld	s6,16(sp)
    80003eee:	6ba2                	ld	s7,8(sp)
    80003ef0:	6c02                	ld	s8,0(sp)
    80003ef2:	6161                	addi	sp,sp,80
    80003ef4:	8082                	ret
    ret = (i == n ? n : -1);
    80003ef6:	5a7d                	li	s4,-1
    80003ef8:	b7d5                	j	80003edc <filewrite+0xfa>
    panic("filewrite");
    80003efa:	00004517          	auipc	a0,0x4
    80003efe:	7a650513          	addi	a0,a0,1958 # 800086a0 <syscalls+0x2b0>
    80003f02:	00002097          	auipc	ra,0x2
    80003f06:	f80080e7          	jalr	-128(ra) # 80005e82 <panic>
    return -1;
    80003f0a:	5a7d                	li	s4,-1
    80003f0c:	bfc1                	j	80003edc <filewrite+0xfa>
      return -1;
    80003f0e:	5a7d                	li	s4,-1
    80003f10:	b7f1                	j	80003edc <filewrite+0xfa>
    80003f12:	5a7d                	li	s4,-1
    80003f14:	b7e1                	j	80003edc <filewrite+0xfa>

0000000080003f16 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003f16:	7179                	addi	sp,sp,-48
    80003f18:	f406                	sd	ra,40(sp)
    80003f1a:	f022                	sd	s0,32(sp)
    80003f1c:	ec26                	sd	s1,24(sp)
    80003f1e:	e84a                	sd	s2,16(sp)
    80003f20:	e44e                	sd	s3,8(sp)
    80003f22:	e052                	sd	s4,0(sp)
    80003f24:	1800                	addi	s0,sp,48
    80003f26:	84aa                	mv	s1,a0
    80003f28:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003f2a:	0005b023          	sd	zero,0(a1)
    80003f2e:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003f32:	00000097          	auipc	ra,0x0
    80003f36:	bf8080e7          	jalr	-1032(ra) # 80003b2a <filealloc>
    80003f3a:	e088                	sd	a0,0(s1)
    80003f3c:	c551                	beqz	a0,80003fc8 <pipealloc+0xb2>
    80003f3e:	00000097          	auipc	ra,0x0
    80003f42:	bec080e7          	jalr	-1044(ra) # 80003b2a <filealloc>
    80003f46:	00aa3023          	sd	a0,0(s4)
    80003f4a:	c92d                	beqz	a0,80003fbc <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003f4c:	ffffc097          	auipc	ra,0xffffc
    80003f50:	1cc080e7          	jalr	460(ra) # 80000118 <kalloc>
    80003f54:	892a                	mv	s2,a0
    80003f56:	c125                	beqz	a0,80003fb6 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003f58:	4985                	li	s3,1
    80003f5a:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003f5e:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003f62:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003f66:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003f6a:	00004597          	auipc	a1,0x4
    80003f6e:	74658593          	addi	a1,a1,1862 # 800086b0 <syscalls+0x2c0>
    80003f72:	00002097          	auipc	ra,0x2
    80003f76:	3ca080e7          	jalr	970(ra) # 8000633c <initlock>
  (*f0)->type = FD_PIPE;
    80003f7a:	609c                	ld	a5,0(s1)
    80003f7c:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003f80:	609c                	ld	a5,0(s1)
    80003f82:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003f86:	609c                	ld	a5,0(s1)
    80003f88:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003f8c:	609c                	ld	a5,0(s1)
    80003f8e:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003f92:	000a3783          	ld	a5,0(s4)
    80003f96:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003f9a:	000a3783          	ld	a5,0(s4)
    80003f9e:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003fa2:	000a3783          	ld	a5,0(s4)
    80003fa6:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003faa:	000a3783          	ld	a5,0(s4)
    80003fae:	0127b823          	sd	s2,16(a5)
  return 0;
    80003fb2:	4501                	li	a0,0
    80003fb4:	a025                	j	80003fdc <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003fb6:	6088                	ld	a0,0(s1)
    80003fb8:	e501                	bnez	a0,80003fc0 <pipealloc+0xaa>
    80003fba:	a039                	j	80003fc8 <pipealloc+0xb2>
    80003fbc:	6088                	ld	a0,0(s1)
    80003fbe:	c51d                	beqz	a0,80003fec <pipealloc+0xd6>
    fileclose(*f0);
    80003fc0:	00000097          	auipc	ra,0x0
    80003fc4:	c26080e7          	jalr	-986(ra) # 80003be6 <fileclose>
  if(*f1)
    80003fc8:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003fcc:	557d                	li	a0,-1
  if(*f1)
    80003fce:	c799                	beqz	a5,80003fdc <pipealloc+0xc6>
    fileclose(*f1);
    80003fd0:	853e                	mv	a0,a5
    80003fd2:	00000097          	auipc	ra,0x0
    80003fd6:	c14080e7          	jalr	-1004(ra) # 80003be6 <fileclose>
  return -1;
    80003fda:	557d                	li	a0,-1
}
    80003fdc:	70a2                	ld	ra,40(sp)
    80003fde:	7402                	ld	s0,32(sp)
    80003fe0:	64e2                	ld	s1,24(sp)
    80003fe2:	6942                	ld	s2,16(sp)
    80003fe4:	69a2                	ld	s3,8(sp)
    80003fe6:	6a02                	ld	s4,0(sp)
    80003fe8:	6145                	addi	sp,sp,48
    80003fea:	8082                	ret
  return -1;
    80003fec:	557d                	li	a0,-1
    80003fee:	b7fd                	j	80003fdc <pipealloc+0xc6>

0000000080003ff0 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003ff0:	1101                	addi	sp,sp,-32
    80003ff2:	ec06                	sd	ra,24(sp)
    80003ff4:	e822                	sd	s0,16(sp)
    80003ff6:	e426                	sd	s1,8(sp)
    80003ff8:	e04a                	sd	s2,0(sp)
    80003ffa:	1000                	addi	s0,sp,32
    80003ffc:	84aa                	mv	s1,a0
    80003ffe:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004000:	00002097          	auipc	ra,0x2
    80004004:	3cc080e7          	jalr	972(ra) # 800063cc <acquire>
  if(writable){
    80004008:	02090d63          	beqz	s2,80004042 <pipeclose+0x52>
    pi->writeopen = 0;
    8000400c:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004010:	21848513          	addi	a0,s1,536
    80004014:	ffffd097          	auipc	ra,0xffffd
    80004018:	6e4080e7          	jalr	1764(ra) # 800016f8 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    8000401c:	2204b783          	ld	a5,544(s1)
    80004020:	eb95                	bnez	a5,80004054 <pipeclose+0x64>
    release(&pi->lock);
    80004022:	8526                	mv	a0,s1
    80004024:	00002097          	auipc	ra,0x2
    80004028:	45c080e7          	jalr	1116(ra) # 80006480 <release>
    kfree((char*)pi);
    8000402c:	8526                	mv	a0,s1
    8000402e:	ffffc097          	auipc	ra,0xffffc
    80004032:	fee080e7          	jalr	-18(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80004036:	60e2                	ld	ra,24(sp)
    80004038:	6442                	ld	s0,16(sp)
    8000403a:	64a2                	ld	s1,8(sp)
    8000403c:	6902                	ld	s2,0(sp)
    8000403e:	6105                	addi	sp,sp,32
    80004040:	8082                	ret
    pi->readopen = 0;
    80004042:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004046:	21c48513          	addi	a0,s1,540
    8000404a:	ffffd097          	auipc	ra,0xffffd
    8000404e:	6ae080e7          	jalr	1710(ra) # 800016f8 <wakeup>
    80004052:	b7e9                	j	8000401c <pipeclose+0x2c>
    release(&pi->lock);
    80004054:	8526                	mv	a0,s1
    80004056:	00002097          	auipc	ra,0x2
    8000405a:	42a080e7          	jalr	1066(ra) # 80006480 <release>
}
    8000405e:	bfe1                	j	80004036 <pipeclose+0x46>

0000000080004060 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004060:	7159                	addi	sp,sp,-112
    80004062:	f486                	sd	ra,104(sp)
    80004064:	f0a2                	sd	s0,96(sp)
    80004066:	eca6                	sd	s1,88(sp)
    80004068:	e8ca                	sd	s2,80(sp)
    8000406a:	e4ce                	sd	s3,72(sp)
    8000406c:	e0d2                	sd	s4,64(sp)
    8000406e:	fc56                	sd	s5,56(sp)
    80004070:	f85a                	sd	s6,48(sp)
    80004072:	f45e                	sd	s7,40(sp)
    80004074:	f062                	sd	s8,32(sp)
    80004076:	ec66                	sd	s9,24(sp)
    80004078:	1880                	addi	s0,sp,112
    8000407a:	84aa                	mv	s1,a0
    8000407c:	8aae                	mv	s5,a1
    8000407e:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004080:	ffffd097          	auipc	ra,0xffffd
    80004084:	eb4080e7          	jalr	-332(ra) # 80000f34 <myproc>
    80004088:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    8000408a:	8526                	mv	a0,s1
    8000408c:	00002097          	auipc	ra,0x2
    80004090:	340080e7          	jalr	832(ra) # 800063cc <acquire>
  while(i < n){
    80004094:	0d405463          	blez	s4,8000415c <pipewrite+0xfc>
    80004098:	8ba6                	mv	s7,s1
  int i = 0;
    8000409a:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000409c:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    8000409e:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800040a2:	21c48c13          	addi	s8,s1,540
    800040a6:	a08d                	j	80004108 <pipewrite+0xa8>
      release(&pi->lock);
    800040a8:	8526                	mv	a0,s1
    800040aa:	00002097          	auipc	ra,0x2
    800040ae:	3d6080e7          	jalr	982(ra) # 80006480 <release>
      return -1;
    800040b2:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800040b4:	854a                	mv	a0,s2
    800040b6:	70a6                	ld	ra,104(sp)
    800040b8:	7406                	ld	s0,96(sp)
    800040ba:	64e6                	ld	s1,88(sp)
    800040bc:	6946                	ld	s2,80(sp)
    800040be:	69a6                	ld	s3,72(sp)
    800040c0:	6a06                	ld	s4,64(sp)
    800040c2:	7ae2                	ld	s5,56(sp)
    800040c4:	7b42                	ld	s6,48(sp)
    800040c6:	7ba2                	ld	s7,40(sp)
    800040c8:	7c02                	ld	s8,32(sp)
    800040ca:	6ce2                	ld	s9,24(sp)
    800040cc:	6165                	addi	sp,sp,112
    800040ce:	8082                	ret
      wakeup(&pi->nread);
    800040d0:	8566                	mv	a0,s9
    800040d2:	ffffd097          	auipc	ra,0xffffd
    800040d6:	626080e7          	jalr	1574(ra) # 800016f8 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800040da:	85de                	mv	a1,s7
    800040dc:	8562                	mv	a0,s8
    800040de:	ffffd097          	auipc	ra,0xffffd
    800040e2:	5b6080e7          	jalr	1462(ra) # 80001694 <sleep>
    800040e6:	a839                	j	80004104 <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800040e8:	21c4a783          	lw	a5,540(s1)
    800040ec:	0017871b          	addiw	a4,a5,1
    800040f0:	20e4ae23          	sw	a4,540(s1)
    800040f4:	1ff7f793          	andi	a5,a5,511
    800040f8:	97a6                	add	a5,a5,s1
    800040fa:	f9f44703          	lbu	a4,-97(s0)
    800040fe:	00e78c23          	sb	a4,24(a5)
      i++;
    80004102:	2905                	addiw	s2,s2,1
  while(i < n){
    80004104:	05495063          	bge	s2,s4,80004144 <pipewrite+0xe4>
    if(pi->readopen == 0 || killed(pr)){
    80004108:	2204a783          	lw	a5,544(s1)
    8000410c:	dfd1                	beqz	a5,800040a8 <pipewrite+0x48>
    8000410e:	854e                	mv	a0,s3
    80004110:	ffffe097          	auipc	ra,0xffffe
    80004114:	82c080e7          	jalr	-2004(ra) # 8000193c <killed>
    80004118:	f941                	bnez	a0,800040a8 <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000411a:	2184a783          	lw	a5,536(s1)
    8000411e:	21c4a703          	lw	a4,540(s1)
    80004122:	2007879b          	addiw	a5,a5,512
    80004126:	faf705e3          	beq	a4,a5,800040d0 <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000412a:	4685                	li	a3,1
    8000412c:	01590633          	add	a2,s2,s5
    80004130:	f9f40593          	addi	a1,s0,-97
    80004134:	0509b503          	ld	a0,80(s3)
    80004138:	ffffd097          	auipc	ra,0xffffd
    8000413c:	a6a080e7          	jalr	-1430(ra) # 80000ba2 <copyin>
    80004140:	fb6514e3          	bne	a0,s6,800040e8 <pipewrite+0x88>
  wakeup(&pi->nread);
    80004144:	21848513          	addi	a0,s1,536
    80004148:	ffffd097          	auipc	ra,0xffffd
    8000414c:	5b0080e7          	jalr	1456(ra) # 800016f8 <wakeup>
  release(&pi->lock);
    80004150:	8526                	mv	a0,s1
    80004152:	00002097          	auipc	ra,0x2
    80004156:	32e080e7          	jalr	814(ra) # 80006480 <release>
  return i;
    8000415a:	bfa9                	j	800040b4 <pipewrite+0x54>
  int i = 0;
    8000415c:	4901                	li	s2,0
    8000415e:	b7dd                	j	80004144 <pipewrite+0xe4>

0000000080004160 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004160:	715d                	addi	sp,sp,-80
    80004162:	e486                	sd	ra,72(sp)
    80004164:	e0a2                	sd	s0,64(sp)
    80004166:	fc26                	sd	s1,56(sp)
    80004168:	f84a                	sd	s2,48(sp)
    8000416a:	f44e                	sd	s3,40(sp)
    8000416c:	f052                	sd	s4,32(sp)
    8000416e:	ec56                	sd	s5,24(sp)
    80004170:	e85a                	sd	s6,16(sp)
    80004172:	0880                	addi	s0,sp,80
    80004174:	84aa                	mv	s1,a0
    80004176:	892e                	mv	s2,a1
    80004178:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    8000417a:	ffffd097          	auipc	ra,0xffffd
    8000417e:	dba080e7          	jalr	-582(ra) # 80000f34 <myproc>
    80004182:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004184:	8b26                	mv	s6,s1
    80004186:	8526                	mv	a0,s1
    80004188:	00002097          	auipc	ra,0x2
    8000418c:	244080e7          	jalr	580(ra) # 800063cc <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004190:	2184a703          	lw	a4,536(s1)
    80004194:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004198:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000419c:	02f71763          	bne	a4,a5,800041ca <piperead+0x6a>
    800041a0:	2244a783          	lw	a5,548(s1)
    800041a4:	c39d                	beqz	a5,800041ca <piperead+0x6a>
    if(killed(pr)){
    800041a6:	8552                	mv	a0,s4
    800041a8:	ffffd097          	auipc	ra,0xffffd
    800041ac:	794080e7          	jalr	1940(ra) # 8000193c <killed>
    800041b0:	e941                	bnez	a0,80004240 <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800041b2:	85da                	mv	a1,s6
    800041b4:	854e                	mv	a0,s3
    800041b6:	ffffd097          	auipc	ra,0xffffd
    800041ba:	4de080e7          	jalr	1246(ra) # 80001694 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800041be:	2184a703          	lw	a4,536(s1)
    800041c2:	21c4a783          	lw	a5,540(s1)
    800041c6:	fcf70de3          	beq	a4,a5,800041a0 <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800041ca:	09505263          	blez	s5,8000424e <piperead+0xee>
    800041ce:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800041d0:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    800041d2:	2184a783          	lw	a5,536(s1)
    800041d6:	21c4a703          	lw	a4,540(s1)
    800041da:	02f70d63          	beq	a4,a5,80004214 <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800041de:	0017871b          	addiw	a4,a5,1
    800041e2:	20e4ac23          	sw	a4,536(s1)
    800041e6:	1ff7f793          	andi	a5,a5,511
    800041ea:	97a6                	add	a5,a5,s1
    800041ec:	0187c783          	lbu	a5,24(a5)
    800041f0:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800041f4:	4685                	li	a3,1
    800041f6:	fbf40613          	addi	a2,s0,-65
    800041fa:	85ca                	mv	a1,s2
    800041fc:	050a3503          	ld	a0,80(s4)
    80004200:	ffffd097          	auipc	ra,0xffffd
    80004204:	916080e7          	jalr	-1770(ra) # 80000b16 <copyout>
    80004208:	01650663          	beq	a0,s6,80004214 <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000420c:	2985                	addiw	s3,s3,1
    8000420e:	0905                	addi	s2,s2,1
    80004210:	fd3a91e3          	bne	s5,s3,800041d2 <piperead+0x72>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004214:	21c48513          	addi	a0,s1,540
    80004218:	ffffd097          	auipc	ra,0xffffd
    8000421c:	4e0080e7          	jalr	1248(ra) # 800016f8 <wakeup>
  release(&pi->lock);
    80004220:	8526                	mv	a0,s1
    80004222:	00002097          	auipc	ra,0x2
    80004226:	25e080e7          	jalr	606(ra) # 80006480 <release>
  return i;
}
    8000422a:	854e                	mv	a0,s3
    8000422c:	60a6                	ld	ra,72(sp)
    8000422e:	6406                	ld	s0,64(sp)
    80004230:	74e2                	ld	s1,56(sp)
    80004232:	7942                	ld	s2,48(sp)
    80004234:	79a2                	ld	s3,40(sp)
    80004236:	7a02                	ld	s4,32(sp)
    80004238:	6ae2                	ld	s5,24(sp)
    8000423a:	6b42                	ld	s6,16(sp)
    8000423c:	6161                	addi	sp,sp,80
    8000423e:	8082                	ret
      release(&pi->lock);
    80004240:	8526                	mv	a0,s1
    80004242:	00002097          	auipc	ra,0x2
    80004246:	23e080e7          	jalr	574(ra) # 80006480 <release>
      return -1;
    8000424a:	59fd                	li	s3,-1
    8000424c:	bff9                	j	8000422a <piperead+0xca>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000424e:	4981                	li	s3,0
    80004250:	b7d1                	j	80004214 <piperead+0xb4>

0000000080004252 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80004252:	1141                	addi	sp,sp,-16
    80004254:	e422                	sd	s0,8(sp)
    80004256:	0800                	addi	s0,sp,16
    80004258:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    8000425a:	8905                	andi	a0,a0,1
    8000425c:	c111                	beqz	a0,80004260 <flags2perm+0xe>
      perm = PTE_X;
    8000425e:	4521                	li	a0,8
    if(flags & 0x2)
    80004260:	8b89                	andi	a5,a5,2
    80004262:	c399                	beqz	a5,80004268 <flags2perm+0x16>
      perm |= PTE_W;
    80004264:	00456513          	ori	a0,a0,4
    return perm;
}
    80004268:	6422                	ld	s0,8(sp)
    8000426a:	0141                	addi	sp,sp,16
    8000426c:	8082                	ret

000000008000426e <exec>:

int
exec(char *path, char **argv)
{
    8000426e:	df010113          	addi	sp,sp,-528
    80004272:	20113423          	sd	ra,520(sp)
    80004276:	20813023          	sd	s0,512(sp)
    8000427a:	ffa6                	sd	s1,504(sp)
    8000427c:	fbca                	sd	s2,496(sp)
    8000427e:	f7ce                	sd	s3,488(sp)
    80004280:	f3d2                	sd	s4,480(sp)
    80004282:	efd6                	sd	s5,472(sp)
    80004284:	ebda                	sd	s6,464(sp)
    80004286:	e7de                	sd	s7,456(sp)
    80004288:	e3e2                	sd	s8,448(sp)
    8000428a:	ff66                	sd	s9,440(sp)
    8000428c:	fb6a                	sd	s10,432(sp)
    8000428e:	f76e                	sd	s11,424(sp)
    80004290:	0c00                	addi	s0,sp,528
    80004292:	84aa                	mv	s1,a0
    80004294:	dea43c23          	sd	a0,-520(s0)
    80004298:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000429c:	ffffd097          	auipc	ra,0xffffd
    800042a0:	c98080e7          	jalr	-872(ra) # 80000f34 <myproc>
    800042a4:	892a                	mv	s2,a0

  begin_op();
    800042a6:	fffff097          	auipc	ra,0xfffff
    800042aa:	474080e7          	jalr	1140(ra) # 8000371a <begin_op>

  if((ip = namei(path)) == 0){
    800042ae:	8526                	mv	a0,s1
    800042b0:	fffff097          	auipc	ra,0xfffff
    800042b4:	24e080e7          	jalr	590(ra) # 800034fe <namei>
    800042b8:	c92d                	beqz	a0,8000432a <exec+0xbc>
    800042ba:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800042bc:	fffff097          	auipc	ra,0xfffff
    800042c0:	a9c080e7          	jalr	-1380(ra) # 80002d58 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800042c4:	04000713          	li	a4,64
    800042c8:	4681                	li	a3,0
    800042ca:	e5040613          	addi	a2,s0,-432
    800042ce:	4581                	li	a1,0
    800042d0:	8526                	mv	a0,s1
    800042d2:	fffff097          	auipc	ra,0xfffff
    800042d6:	d3a080e7          	jalr	-710(ra) # 8000300c <readi>
    800042da:	04000793          	li	a5,64
    800042de:	00f51a63          	bne	a0,a5,800042f2 <exec+0x84>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    800042e2:	e5042703          	lw	a4,-432(s0)
    800042e6:	464c47b7          	lui	a5,0x464c4
    800042ea:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800042ee:	04f70463          	beq	a4,a5,80004336 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800042f2:	8526                	mv	a0,s1
    800042f4:	fffff097          	auipc	ra,0xfffff
    800042f8:	cc6080e7          	jalr	-826(ra) # 80002fba <iunlockput>
    end_op();
    800042fc:	fffff097          	auipc	ra,0xfffff
    80004300:	49e080e7          	jalr	1182(ra) # 8000379a <end_op>
  }
  return -1;
    80004304:	557d                	li	a0,-1
}
    80004306:	20813083          	ld	ra,520(sp)
    8000430a:	20013403          	ld	s0,512(sp)
    8000430e:	74fe                	ld	s1,504(sp)
    80004310:	795e                	ld	s2,496(sp)
    80004312:	79be                	ld	s3,488(sp)
    80004314:	7a1e                	ld	s4,480(sp)
    80004316:	6afe                	ld	s5,472(sp)
    80004318:	6b5e                	ld	s6,464(sp)
    8000431a:	6bbe                	ld	s7,456(sp)
    8000431c:	6c1e                	ld	s8,448(sp)
    8000431e:	7cfa                	ld	s9,440(sp)
    80004320:	7d5a                	ld	s10,432(sp)
    80004322:	7dba                	ld	s11,424(sp)
    80004324:	21010113          	addi	sp,sp,528
    80004328:	8082                	ret
    end_op();
    8000432a:	fffff097          	auipc	ra,0xfffff
    8000432e:	470080e7          	jalr	1136(ra) # 8000379a <end_op>
    return -1;
    80004332:	557d                	li	a0,-1
    80004334:	bfc9                	j	80004306 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    80004336:	854a                	mv	a0,s2
    80004338:	ffffd097          	auipc	ra,0xffffd
    8000433c:	cc0080e7          	jalr	-832(ra) # 80000ff8 <proc_pagetable>
    80004340:	8baa                	mv	s7,a0
    80004342:	d945                	beqz	a0,800042f2 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004344:	e7042983          	lw	s3,-400(s0)
    80004348:	e8845783          	lhu	a5,-376(s0)
    8000434c:	c7ad                	beqz	a5,800043b6 <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000434e:	4a01                	li	s4,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004350:	4b01                	li	s6,0
    if(ph.vaddr % PGSIZE != 0)
    80004352:	6c85                	lui	s9,0x1
    80004354:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004358:	def43823          	sd	a5,-528(s0)
    8000435c:	a485                	j	800045bc <exec+0x34e>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    8000435e:	00004517          	auipc	a0,0x4
    80004362:	35a50513          	addi	a0,a0,858 # 800086b8 <syscalls+0x2c8>
    80004366:	00002097          	auipc	ra,0x2
    8000436a:	b1c080e7          	jalr	-1252(ra) # 80005e82 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    8000436e:	8756                	mv	a4,s5
    80004370:	012d86bb          	addw	a3,s11,s2
    80004374:	4581                	li	a1,0
    80004376:	8526                	mv	a0,s1
    80004378:	fffff097          	auipc	ra,0xfffff
    8000437c:	c94080e7          	jalr	-876(ra) # 8000300c <readi>
    80004380:	2501                	sext.w	a0,a0
    80004382:	1eaa9163          	bne	s5,a0,80004564 <exec+0x2f6>
  for(i = 0; i < sz; i += PGSIZE){
    80004386:	6785                	lui	a5,0x1
    80004388:	0127893b          	addw	s2,a5,s2
    8000438c:	77fd                	lui	a5,0xfffff
    8000438e:	01478a3b          	addw	s4,a5,s4
    80004392:	21897c63          	bgeu	s2,s8,800045aa <exec+0x33c>
    pa = walkaddr(pagetable, va + i);
    80004396:	02091593          	slli	a1,s2,0x20
    8000439a:	9181                	srli	a1,a1,0x20
    8000439c:	95ea                	add	a1,a1,s10
    8000439e:	855e                	mv	a0,s7
    800043a0:	ffffc097          	auipc	ra,0xffffc
    800043a4:	16a080e7          	jalr	362(ra) # 8000050a <walkaddr>
    800043a8:	862a                	mv	a2,a0
    if(pa == 0)
    800043aa:	d955                	beqz	a0,8000435e <exec+0xf0>
      n = PGSIZE;
    800043ac:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    800043ae:	fd9a70e3          	bgeu	s4,s9,8000436e <exec+0x100>
      n = sz - i;
    800043b2:	8ad2                	mv	s5,s4
    800043b4:	bf6d                	j	8000436e <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800043b6:	4a01                	li	s4,0
  iunlockput(ip);
    800043b8:	8526                	mv	a0,s1
    800043ba:	fffff097          	auipc	ra,0xfffff
    800043be:	c00080e7          	jalr	-1024(ra) # 80002fba <iunlockput>
  end_op();
    800043c2:	fffff097          	auipc	ra,0xfffff
    800043c6:	3d8080e7          	jalr	984(ra) # 8000379a <end_op>
  p = myproc();
    800043ca:	ffffd097          	auipc	ra,0xffffd
    800043ce:	b6a080e7          	jalr	-1174(ra) # 80000f34 <myproc>
    800043d2:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800043d4:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    800043d8:	6785                	lui	a5,0x1
    800043da:	17fd                	addi	a5,a5,-1
    800043dc:	9a3e                	add	s4,s4,a5
    800043de:	757d                	lui	a0,0xfffff
    800043e0:	00aa77b3          	and	a5,s4,a0
    800043e4:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    800043e8:	4691                	li	a3,4
    800043ea:	6609                	lui	a2,0x2
    800043ec:	963e                	add	a2,a2,a5
    800043ee:	85be                	mv	a1,a5
    800043f0:	855e                	mv	a0,s7
    800043f2:	ffffc097          	auipc	ra,0xffffc
    800043f6:	4cc080e7          	jalr	1228(ra) # 800008be <uvmalloc>
    800043fa:	8b2a                	mv	s6,a0
  ip = 0;
    800043fc:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    800043fe:	16050363          	beqz	a0,80004564 <exec+0x2f6>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004402:	75f9                	lui	a1,0xffffe
    80004404:	95aa                	add	a1,a1,a0
    80004406:	855e                	mv	a0,s7
    80004408:	ffffc097          	auipc	ra,0xffffc
    8000440c:	6dc080e7          	jalr	1756(ra) # 80000ae4 <uvmclear>
  stackbase = sp - PGSIZE;
    80004410:	7c7d                	lui	s8,0xfffff
    80004412:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    80004414:	e0043783          	ld	a5,-512(s0)
    80004418:	6388                	ld	a0,0(a5)
    8000441a:	c535                	beqz	a0,80004486 <exec+0x218>
    8000441c:	e9040993          	addi	s3,s0,-368
    80004420:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004424:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    80004426:	ffffc097          	auipc	ra,0xffffc
    8000442a:	ed6080e7          	jalr	-298(ra) # 800002fc <strlen>
    8000442e:	2505                	addiw	a0,a0,1
    80004430:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004434:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80004438:	15896d63          	bltu	s2,s8,80004592 <exec+0x324>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000443c:	e0043d83          	ld	s11,-512(s0)
    80004440:	000dba03          	ld	s4,0(s11)
    80004444:	8552                	mv	a0,s4
    80004446:	ffffc097          	auipc	ra,0xffffc
    8000444a:	eb6080e7          	jalr	-330(ra) # 800002fc <strlen>
    8000444e:	0015069b          	addiw	a3,a0,1
    80004452:	8652                	mv	a2,s4
    80004454:	85ca                	mv	a1,s2
    80004456:	855e                	mv	a0,s7
    80004458:	ffffc097          	auipc	ra,0xffffc
    8000445c:	6be080e7          	jalr	1726(ra) # 80000b16 <copyout>
    80004460:	12054d63          	bltz	a0,8000459a <exec+0x32c>
    ustack[argc] = sp;
    80004464:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004468:	0485                	addi	s1,s1,1
    8000446a:	008d8793          	addi	a5,s11,8
    8000446e:	e0f43023          	sd	a5,-512(s0)
    80004472:	008db503          	ld	a0,8(s11)
    80004476:	c911                	beqz	a0,8000448a <exec+0x21c>
    if(argc >= MAXARG)
    80004478:	09a1                	addi	s3,s3,8
    8000447a:	fb3c96e3          	bne	s9,s3,80004426 <exec+0x1b8>
  sz = sz1;
    8000447e:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004482:	4481                	li	s1,0
    80004484:	a0c5                	j	80004564 <exec+0x2f6>
  sp = sz;
    80004486:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    80004488:	4481                	li	s1,0
  ustack[argc] = 0;
    8000448a:	00349793          	slli	a5,s1,0x3
    8000448e:	f9040713          	addi	a4,s0,-112
    80004492:	97ba                	add	a5,a5,a4
    80004494:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    80004498:	00148693          	addi	a3,s1,1
    8000449c:	068e                	slli	a3,a3,0x3
    8000449e:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800044a2:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    800044a6:	01897663          	bgeu	s2,s8,800044b2 <exec+0x244>
  sz = sz1;
    800044aa:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800044ae:	4481                	li	s1,0
    800044b0:	a855                	j	80004564 <exec+0x2f6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800044b2:	e9040613          	addi	a2,s0,-368
    800044b6:	85ca                	mv	a1,s2
    800044b8:	855e                	mv	a0,s7
    800044ba:	ffffc097          	auipc	ra,0xffffc
    800044be:	65c080e7          	jalr	1628(ra) # 80000b16 <copyout>
    800044c2:	0e054063          	bltz	a0,800045a2 <exec+0x334>
  p->trapframe->a1 = sp;
    800044c6:	058ab783          	ld	a5,88(s5)
    800044ca:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800044ce:	df843783          	ld	a5,-520(s0)
    800044d2:	0007c703          	lbu	a4,0(a5)
    800044d6:	cf11                	beqz	a4,800044f2 <exec+0x284>
    800044d8:	0785                	addi	a5,a5,1
    if(*s == '/')
    800044da:	02f00693          	li	a3,47
    800044de:	a039                	j	800044ec <exec+0x27e>
      last = s+1;
    800044e0:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    800044e4:	0785                	addi	a5,a5,1
    800044e6:	fff7c703          	lbu	a4,-1(a5)
    800044ea:	c701                	beqz	a4,800044f2 <exec+0x284>
    if(*s == '/')
    800044ec:	fed71ce3          	bne	a4,a3,800044e4 <exec+0x276>
    800044f0:	bfc5                	j	800044e0 <exec+0x272>
  safestrcpy(p->name, last, sizeof(p->name));
    800044f2:	4641                	li	a2,16
    800044f4:	df843583          	ld	a1,-520(s0)
    800044f8:	158a8513          	addi	a0,s5,344
    800044fc:	ffffc097          	auipc	ra,0xffffc
    80004500:	dce080e7          	jalr	-562(ra) # 800002ca <safestrcpy>
  oldpagetable = p->pagetable;
    80004504:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004508:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    8000450c:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004510:	058ab783          	ld	a5,88(s5)
    80004514:	e6843703          	ld	a4,-408(s0)
    80004518:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000451a:	058ab783          	ld	a5,88(s5)
    8000451e:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004522:	85ea                	mv	a1,s10
    80004524:	ffffd097          	auipc	ra,0xffffd
    80004528:	bca080e7          	jalr	-1078(ra) # 800010ee <proc_freepagetable>
  if (p->pid == 1) {
    8000452c:	030aa703          	lw	a4,48(s5)
    80004530:	4785                	li	a5,1
    80004532:	00f70563          	beq	a4,a5,8000453c <exec+0x2ce>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004536:	0004851b          	sext.w	a0,s1
    8000453a:	b3f1                	j	80004306 <exec+0x98>
    printf("page table %p\n", p->pagetable);
    8000453c:	050ab583          	ld	a1,80(s5)
    80004540:	00004517          	auipc	a0,0x4
    80004544:	19850513          	addi	a0,a0,408 # 800086d8 <syscalls+0x2e8>
    80004548:	00002097          	auipc	ra,0x2
    8000454c:	984080e7          	jalr	-1660(ra) # 80005ecc <printf>
    vmprint(p->pagetable, 1);
    80004550:	4585                	li	a1,1
    80004552:	050ab503          	ld	a0,80(s5)
    80004556:	ffffc097          	auipc	ra,0xffffc
    8000455a:	78c080e7          	jalr	1932(ra) # 80000ce2 <vmprint>
    8000455e:	bfe1                	j	80004536 <exec+0x2c8>
    80004560:	e1443423          	sd	s4,-504(s0)
    proc_freepagetable(pagetable, sz);
    80004564:	e0843583          	ld	a1,-504(s0)
    80004568:	855e                	mv	a0,s7
    8000456a:	ffffd097          	auipc	ra,0xffffd
    8000456e:	b84080e7          	jalr	-1148(ra) # 800010ee <proc_freepagetable>
  if(ip){
    80004572:	d80490e3          	bnez	s1,800042f2 <exec+0x84>
  return -1;
    80004576:	557d                	li	a0,-1
    80004578:	b379                	j	80004306 <exec+0x98>
    8000457a:	e1443423          	sd	s4,-504(s0)
    8000457e:	b7dd                	j	80004564 <exec+0x2f6>
    80004580:	e1443423          	sd	s4,-504(s0)
    80004584:	b7c5                	j	80004564 <exec+0x2f6>
    80004586:	e1443423          	sd	s4,-504(s0)
    8000458a:	bfe9                	j	80004564 <exec+0x2f6>
    8000458c:	e1443423          	sd	s4,-504(s0)
    80004590:	bfd1                	j	80004564 <exec+0x2f6>
  sz = sz1;
    80004592:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004596:	4481                	li	s1,0
    80004598:	b7f1                	j	80004564 <exec+0x2f6>
  sz = sz1;
    8000459a:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000459e:	4481                	li	s1,0
    800045a0:	b7d1                	j	80004564 <exec+0x2f6>
  sz = sz1;
    800045a2:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800045a6:	4481                	li	s1,0
    800045a8:	bf75                	j	80004564 <exec+0x2f6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800045aa:	e0843a03          	ld	s4,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800045ae:	2b05                	addiw	s6,s6,1
    800045b0:	0389899b          	addiw	s3,s3,56
    800045b4:	e8845783          	lhu	a5,-376(s0)
    800045b8:	e0fb50e3          	bge	s6,a5,800043b8 <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800045bc:	2981                	sext.w	s3,s3
    800045be:	03800713          	li	a4,56
    800045c2:	86ce                	mv	a3,s3
    800045c4:	e1840613          	addi	a2,s0,-488
    800045c8:	4581                	li	a1,0
    800045ca:	8526                	mv	a0,s1
    800045cc:	fffff097          	auipc	ra,0xfffff
    800045d0:	a40080e7          	jalr	-1472(ra) # 8000300c <readi>
    800045d4:	03800793          	li	a5,56
    800045d8:	f8f514e3          	bne	a0,a5,80004560 <exec+0x2f2>
    if(ph.type != ELF_PROG_LOAD)
    800045dc:	e1842783          	lw	a5,-488(s0)
    800045e0:	4705                	li	a4,1
    800045e2:	fce796e3          	bne	a5,a4,800045ae <exec+0x340>
    if(ph.memsz < ph.filesz)
    800045e6:	e4043903          	ld	s2,-448(s0)
    800045ea:	e3843783          	ld	a5,-456(s0)
    800045ee:	f8f966e3          	bltu	s2,a5,8000457a <exec+0x30c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800045f2:	e2843783          	ld	a5,-472(s0)
    800045f6:	993e                	add	s2,s2,a5
    800045f8:	f8f964e3          	bltu	s2,a5,80004580 <exec+0x312>
    if(ph.vaddr % PGSIZE != 0)
    800045fc:	df043703          	ld	a4,-528(s0)
    80004600:	8ff9                	and	a5,a5,a4
    80004602:	f3d1                	bnez	a5,80004586 <exec+0x318>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004604:	e1c42503          	lw	a0,-484(s0)
    80004608:	00000097          	auipc	ra,0x0
    8000460c:	c4a080e7          	jalr	-950(ra) # 80004252 <flags2perm>
    80004610:	86aa                	mv	a3,a0
    80004612:	864a                	mv	a2,s2
    80004614:	85d2                	mv	a1,s4
    80004616:	855e                	mv	a0,s7
    80004618:	ffffc097          	auipc	ra,0xffffc
    8000461c:	2a6080e7          	jalr	678(ra) # 800008be <uvmalloc>
    80004620:	e0a43423          	sd	a0,-504(s0)
    80004624:	d525                	beqz	a0,8000458c <exec+0x31e>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004626:	e2843d03          	ld	s10,-472(s0)
    8000462a:	e2042d83          	lw	s11,-480(s0)
    8000462e:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004632:	f60c0ce3          	beqz	s8,800045aa <exec+0x33c>
    80004636:	8a62                	mv	s4,s8
    80004638:	4901                	li	s2,0
    8000463a:	bbb1                	j	80004396 <exec+0x128>

000000008000463c <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000463c:	7179                	addi	sp,sp,-48
    8000463e:	f406                	sd	ra,40(sp)
    80004640:	f022                	sd	s0,32(sp)
    80004642:	ec26                	sd	s1,24(sp)
    80004644:	e84a                	sd	s2,16(sp)
    80004646:	1800                	addi	s0,sp,48
    80004648:	892e                	mv	s2,a1
    8000464a:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    8000464c:	fdc40593          	addi	a1,s0,-36
    80004650:	ffffe097          	auipc	ra,0xffffe
    80004654:	ab0080e7          	jalr	-1360(ra) # 80002100 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004658:	fdc42703          	lw	a4,-36(s0)
    8000465c:	47bd                	li	a5,15
    8000465e:	02e7eb63          	bltu	a5,a4,80004694 <argfd+0x58>
    80004662:	ffffd097          	auipc	ra,0xffffd
    80004666:	8d2080e7          	jalr	-1838(ra) # 80000f34 <myproc>
    8000466a:	fdc42703          	lw	a4,-36(s0)
    8000466e:	01a70793          	addi	a5,a4,26
    80004672:	078e                	slli	a5,a5,0x3
    80004674:	953e                	add	a0,a0,a5
    80004676:	611c                	ld	a5,0(a0)
    80004678:	c385                	beqz	a5,80004698 <argfd+0x5c>
    return -1;
  if(pfd)
    8000467a:	00090463          	beqz	s2,80004682 <argfd+0x46>
    *pfd = fd;
    8000467e:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004682:	4501                	li	a0,0
  if(pf)
    80004684:	c091                	beqz	s1,80004688 <argfd+0x4c>
    *pf = f;
    80004686:	e09c                	sd	a5,0(s1)
}
    80004688:	70a2                	ld	ra,40(sp)
    8000468a:	7402                	ld	s0,32(sp)
    8000468c:	64e2                	ld	s1,24(sp)
    8000468e:	6942                	ld	s2,16(sp)
    80004690:	6145                	addi	sp,sp,48
    80004692:	8082                	ret
    return -1;
    80004694:	557d                	li	a0,-1
    80004696:	bfcd                	j	80004688 <argfd+0x4c>
    80004698:	557d                	li	a0,-1
    8000469a:	b7fd                	j	80004688 <argfd+0x4c>

000000008000469c <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000469c:	1101                	addi	sp,sp,-32
    8000469e:	ec06                	sd	ra,24(sp)
    800046a0:	e822                	sd	s0,16(sp)
    800046a2:	e426                	sd	s1,8(sp)
    800046a4:	1000                	addi	s0,sp,32
    800046a6:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800046a8:	ffffd097          	auipc	ra,0xffffd
    800046ac:	88c080e7          	jalr	-1908(ra) # 80000f34 <myproc>
    800046b0:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800046b2:	0d050793          	addi	a5,a0,208
    800046b6:	4501                	li	a0,0
    800046b8:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800046ba:	6398                	ld	a4,0(a5)
    800046bc:	cb19                	beqz	a4,800046d2 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800046be:	2505                	addiw	a0,a0,1
    800046c0:	07a1                	addi	a5,a5,8
    800046c2:	fed51ce3          	bne	a0,a3,800046ba <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800046c6:	557d                	li	a0,-1
}
    800046c8:	60e2                	ld	ra,24(sp)
    800046ca:	6442                	ld	s0,16(sp)
    800046cc:	64a2                	ld	s1,8(sp)
    800046ce:	6105                	addi	sp,sp,32
    800046d0:	8082                	ret
      p->ofile[fd] = f;
    800046d2:	01a50793          	addi	a5,a0,26
    800046d6:	078e                	slli	a5,a5,0x3
    800046d8:	963e                	add	a2,a2,a5
    800046da:	e204                	sd	s1,0(a2)
      return fd;
    800046dc:	b7f5                	j	800046c8 <fdalloc+0x2c>

00000000800046de <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800046de:	715d                	addi	sp,sp,-80
    800046e0:	e486                	sd	ra,72(sp)
    800046e2:	e0a2                	sd	s0,64(sp)
    800046e4:	fc26                	sd	s1,56(sp)
    800046e6:	f84a                	sd	s2,48(sp)
    800046e8:	f44e                	sd	s3,40(sp)
    800046ea:	f052                	sd	s4,32(sp)
    800046ec:	ec56                	sd	s5,24(sp)
    800046ee:	e85a                	sd	s6,16(sp)
    800046f0:	0880                	addi	s0,sp,80
    800046f2:	8b2e                	mv	s6,a1
    800046f4:	89b2                	mv	s3,a2
    800046f6:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800046f8:	fb040593          	addi	a1,s0,-80
    800046fc:	fffff097          	auipc	ra,0xfffff
    80004700:	e20080e7          	jalr	-480(ra) # 8000351c <nameiparent>
    80004704:	84aa                	mv	s1,a0
    80004706:	16050063          	beqz	a0,80004866 <create+0x188>
    return 0;

  ilock(dp);
    8000470a:	ffffe097          	auipc	ra,0xffffe
    8000470e:	64e080e7          	jalr	1614(ra) # 80002d58 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004712:	4601                	li	a2,0
    80004714:	fb040593          	addi	a1,s0,-80
    80004718:	8526                	mv	a0,s1
    8000471a:	fffff097          	auipc	ra,0xfffff
    8000471e:	b22080e7          	jalr	-1246(ra) # 8000323c <dirlookup>
    80004722:	8aaa                	mv	s5,a0
    80004724:	c931                	beqz	a0,80004778 <create+0x9a>
    iunlockput(dp);
    80004726:	8526                	mv	a0,s1
    80004728:	fffff097          	auipc	ra,0xfffff
    8000472c:	892080e7          	jalr	-1902(ra) # 80002fba <iunlockput>
    ilock(ip);
    80004730:	8556                	mv	a0,s5
    80004732:	ffffe097          	auipc	ra,0xffffe
    80004736:	626080e7          	jalr	1574(ra) # 80002d58 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000473a:	000b059b          	sext.w	a1,s6
    8000473e:	4789                	li	a5,2
    80004740:	02f59563          	bne	a1,a5,8000476a <create+0x8c>
    80004744:	044ad783          	lhu	a5,68(s5)
    80004748:	37f9                	addiw	a5,a5,-2
    8000474a:	17c2                	slli	a5,a5,0x30
    8000474c:	93c1                	srli	a5,a5,0x30
    8000474e:	4705                	li	a4,1
    80004750:	00f76d63          	bltu	a4,a5,8000476a <create+0x8c>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004754:	8556                	mv	a0,s5
    80004756:	60a6                	ld	ra,72(sp)
    80004758:	6406                	ld	s0,64(sp)
    8000475a:	74e2                	ld	s1,56(sp)
    8000475c:	7942                	ld	s2,48(sp)
    8000475e:	79a2                	ld	s3,40(sp)
    80004760:	7a02                	ld	s4,32(sp)
    80004762:	6ae2                	ld	s5,24(sp)
    80004764:	6b42                	ld	s6,16(sp)
    80004766:	6161                	addi	sp,sp,80
    80004768:	8082                	ret
    iunlockput(ip);
    8000476a:	8556                	mv	a0,s5
    8000476c:	fffff097          	auipc	ra,0xfffff
    80004770:	84e080e7          	jalr	-1970(ra) # 80002fba <iunlockput>
    return 0;
    80004774:	4a81                	li	s5,0
    80004776:	bff9                	j	80004754 <create+0x76>
  if((ip = ialloc(dp->dev, type)) == 0){
    80004778:	85da                	mv	a1,s6
    8000477a:	4088                	lw	a0,0(s1)
    8000477c:	ffffe097          	auipc	ra,0xffffe
    80004780:	440080e7          	jalr	1088(ra) # 80002bbc <ialloc>
    80004784:	8a2a                	mv	s4,a0
    80004786:	c921                	beqz	a0,800047d6 <create+0xf8>
  ilock(ip);
    80004788:	ffffe097          	auipc	ra,0xffffe
    8000478c:	5d0080e7          	jalr	1488(ra) # 80002d58 <ilock>
  ip->major = major;
    80004790:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80004794:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80004798:	4785                	li	a5,1
    8000479a:	04fa1523          	sh	a5,74(s4)
  iupdate(ip);
    8000479e:	8552                	mv	a0,s4
    800047a0:	ffffe097          	auipc	ra,0xffffe
    800047a4:	4ee080e7          	jalr	1262(ra) # 80002c8e <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800047a8:	000b059b          	sext.w	a1,s6
    800047ac:	4785                	li	a5,1
    800047ae:	02f58b63          	beq	a1,a5,800047e4 <create+0x106>
  if(dirlink(dp, name, ip->inum) < 0)
    800047b2:	004a2603          	lw	a2,4(s4)
    800047b6:	fb040593          	addi	a1,s0,-80
    800047ba:	8526                	mv	a0,s1
    800047bc:	fffff097          	auipc	ra,0xfffff
    800047c0:	c90080e7          	jalr	-880(ra) # 8000344c <dirlink>
    800047c4:	06054f63          	bltz	a0,80004842 <create+0x164>
  iunlockput(dp);
    800047c8:	8526                	mv	a0,s1
    800047ca:	ffffe097          	auipc	ra,0xffffe
    800047ce:	7f0080e7          	jalr	2032(ra) # 80002fba <iunlockput>
  return ip;
    800047d2:	8ad2                	mv	s5,s4
    800047d4:	b741                	j	80004754 <create+0x76>
    iunlockput(dp);
    800047d6:	8526                	mv	a0,s1
    800047d8:	ffffe097          	auipc	ra,0xffffe
    800047dc:	7e2080e7          	jalr	2018(ra) # 80002fba <iunlockput>
    return 0;
    800047e0:	8ad2                	mv	s5,s4
    800047e2:	bf8d                	j	80004754 <create+0x76>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800047e4:	004a2603          	lw	a2,4(s4)
    800047e8:	00004597          	auipc	a1,0x4
    800047ec:	f0058593          	addi	a1,a1,-256 # 800086e8 <syscalls+0x2f8>
    800047f0:	8552                	mv	a0,s4
    800047f2:	fffff097          	auipc	ra,0xfffff
    800047f6:	c5a080e7          	jalr	-934(ra) # 8000344c <dirlink>
    800047fa:	04054463          	bltz	a0,80004842 <create+0x164>
    800047fe:	40d0                	lw	a2,4(s1)
    80004800:	00004597          	auipc	a1,0x4
    80004804:	95858593          	addi	a1,a1,-1704 # 80008158 <etext+0x158>
    80004808:	8552                	mv	a0,s4
    8000480a:	fffff097          	auipc	ra,0xfffff
    8000480e:	c42080e7          	jalr	-958(ra) # 8000344c <dirlink>
    80004812:	02054863          	bltz	a0,80004842 <create+0x164>
  if(dirlink(dp, name, ip->inum) < 0)
    80004816:	004a2603          	lw	a2,4(s4)
    8000481a:	fb040593          	addi	a1,s0,-80
    8000481e:	8526                	mv	a0,s1
    80004820:	fffff097          	auipc	ra,0xfffff
    80004824:	c2c080e7          	jalr	-980(ra) # 8000344c <dirlink>
    80004828:	00054d63          	bltz	a0,80004842 <create+0x164>
    dp->nlink++;  // for ".."
    8000482c:	04a4d783          	lhu	a5,74(s1)
    80004830:	2785                	addiw	a5,a5,1
    80004832:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004836:	8526                	mv	a0,s1
    80004838:	ffffe097          	auipc	ra,0xffffe
    8000483c:	456080e7          	jalr	1110(ra) # 80002c8e <iupdate>
    80004840:	b761                	j	800047c8 <create+0xea>
  ip->nlink = 0;
    80004842:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004846:	8552                	mv	a0,s4
    80004848:	ffffe097          	auipc	ra,0xffffe
    8000484c:	446080e7          	jalr	1094(ra) # 80002c8e <iupdate>
  iunlockput(ip);
    80004850:	8552                	mv	a0,s4
    80004852:	ffffe097          	auipc	ra,0xffffe
    80004856:	768080e7          	jalr	1896(ra) # 80002fba <iunlockput>
  iunlockput(dp);
    8000485a:	8526                	mv	a0,s1
    8000485c:	ffffe097          	auipc	ra,0xffffe
    80004860:	75e080e7          	jalr	1886(ra) # 80002fba <iunlockput>
  return 0;
    80004864:	bdc5                	j	80004754 <create+0x76>
    return 0;
    80004866:	8aaa                	mv	s5,a0
    80004868:	b5f5                	j	80004754 <create+0x76>

000000008000486a <sys_dup>:
{
    8000486a:	7179                	addi	sp,sp,-48
    8000486c:	f406                	sd	ra,40(sp)
    8000486e:	f022                	sd	s0,32(sp)
    80004870:	ec26                	sd	s1,24(sp)
    80004872:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004874:	fd840613          	addi	a2,s0,-40
    80004878:	4581                	li	a1,0
    8000487a:	4501                	li	a0,0
    8000487c:	00000097          	auipc	ra,0x0
    80004880:	dc0080e7          	jalr	-576(ra) # 8000463c <argfd>
    return -1;
    80004884:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004886:	02054363          	bltz	a0,800048ac <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    8000488a:	fd843503          	ld	a0,-40(s0)
    8000488e:	00000097          	auipc	ra,0x0
    80004892:	e0e080e7          	jalr	-498(ra) # 8000469c <fdalloc>
    80004896:	84aa                	mv	s1,a0
    return -1;
    80004898:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000489a:	00054963          	bltz	a0,800048ac <sys_dup+0x42>
  filedup(f);
    8000489e:	fd843503          	ld	a0,-40(s0)
    800048a2:	fffff097          	auipc	ra,0xfffff
    800048a6:	2f2080e7          	jalr	754(ra) # 80003b94 <filedup>
  return fd;
    800048aa:	87a6                	mv	a5,s1
}
    800048ac:	853e                	mv	a0,a5
    800048ae:	70a2                	ld	ra,40(sp)
    800048b0:	7402                	ld	s0,32(sp)
    800048b2:	64e2                	ld	s1,24(sp)
    800048b4:	6145                	addi	sp,sp,48
    800048b6:	8082                	ret

00000000800048b8 <sys_read>:
{
    800048b8:	7179                	addi	sp,sp,-48
    800048ba:	f406                	sd	ra,40(sp)
    800048bc:	f022                	sd	s0,32(sp)
    800048be:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800048c0:	fd840593          	addi	a1,s0,-40
    800048c4:	4505                	li	a0,1
    800048c6:	ffffe097          	auipc	ra,0xffffe
    800048ca:	85a080e7          	jalr	-1958(ra) # 80002120 <argaddr>
  argint(2, &n);
    800048ce:	fe440593          	addi	a1,s0,-28
    800048d2:	4509                	li	a0,2
    800048d4:	ffffe097          	auipc	ra,0xffffe
    800048d8:	82c080e7          	jalr	-2004(ra) # 80002100 <argint>
  if(argfd(0, 0, &f) < 0)
    800048dc:	fe840613          	addi	a2,s0,-24
    800048e0:	4581                	li	a1,0
    800048e2:	4501                	li	a0,0
    800048e4:	00000097          	auipc	ra,0x0
    800048e8:	d58080e7          	jalr	-680(ra) # 8000463c <argfd>
    800048ec:	87aa                	mv	a5,a0
    return -1;
    800048ee:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800048f0:	0007cc63          	bltz	a5,80004908 <sys_read+0x50>
  return fileread(f, p, n);
    800048f4:	fe442603          	lw	a2,-28(s0)
    800048f8:	fd843583          	ld	a1,-40(s0)
    800048fc:	fe843503          	ld	a0,-24(s0)
    80004900:	fffff097          	auipc	ra,0xfffff
    80004904:	420080e7          	jalr	1056(ra) # 80003d20 <fileread>
}
    80004908:	70a2                	ld	ra,40(sp)
    8000490a:	7402                	ld	s0,32(sp)
    8000490c:	6145                	addi	sp,sp,48
    8000490e:	8082                	ret

0000000080004910 <sys_write>:
{
    80004910:	7179                	addi	sp,sp,-48
    80004912:	f406                	sd	ra,40(sp)
    80004914:	f022                	sd	s0,32(sp)
    80004916:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004918:	fd840593          	addi	a1,s0,-40
    8000491c:	4505                	li	a0,1
    8000491e:	ffffe097          	auipc	ra,0xffffe
    80004922:	802080e7          	jalr	-2046(ra) # 80002120 <argaddr>
  argint(2, &n);
    80004926:	fe440593          	addi	a1,s0,-28
    8000492a:	4509                	li	a0,2
    8000492c:	ffffd097          	auipc	ra,0xffffd
    80004930:	7d4080e7          	jalr	2004(ra) # 80002100 <argint>
  if(argfd(0, 0, &f) < 0)
    80004934:	fe840613          	addi	a2,s0,-24
    80004938:	4581                	li	a1,0
    8000493a:	4501                	li	a0,0
    8000493c:	00000097          	auipc	ra,0x0
    80004940:	d00080e7          	jalr	-768(ra) # 8000463c <argfd>
    80004944:	87aa                	mv	a5,a0
    return -1;
    80004946:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004948:	0007cc63          	bltz	a5,80004960 <sys_write+0x50>
  return filewrite(f, p, n);
    8000494c:	fe442603          	lw	a2,-28(s0)
    80004950:	fd843583          	ld	a1,-40(s0)
    80004954:	fe843503          	ld	a0,-24(s0)
    80004958:	fffff097          	auipc	ra,0xfffff
    8000495c:	48a080e7          	jalr	1162(ra) # 80003de2 <filewrite>
}
    80004960:	70a2                	ld	ra,40(sp)
    80004962:	7402                	ld	s0,32(sp)
    80004964:	6145                	addi	sp,sp,48
    80004966:	8082                	ret

0000000080004968 <sys_close>:
{
    80004968:	1101                	addi	sp,sp,-32
    8000496a:	ec06                	sd	ra,24(sp)
    8000496c:	e822                	sd	s0,16(sp)
    8000496e:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004970:	fe040613          	addi	a2,s0,-32
    80004974:	fec40593          	addi	a1,s0,-20
    80004978:	4501                	li	a0,0
    8000497a:	00000097          	auipc	ra,0x0
    8000497e:	cc2080e7          	jalr	-830(ra) # 8000463c <argfd>
    return -1;
    80004982:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004984:	02054463          	bltz	a0,800049ac <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80004988:	ffffc097          	auipc	ra,0xffffc
    8000498c:	5ac080e7          	jalr	1452(ra) # 80000f34 <myproc>
    80004990:	fec42783          	lw	a5,-20(s0)
    80004994:	07e9                	addi	a5,a5,26
    80004996:	078e                	slli	a5,a5,0x3
    80004998:	97aa                	add	a5,a5,a0
    8000499a:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    8000499e:	fe043503          	ld	a0,-32(s0)
    800049a2:	fffff097          	auipc	ra,0xfffff
    800049a6:	244080e7          	jalr	580(ra) # 80003be6 <fileclose>
  return 0;
    800049aa:	4781                	li	a5,0
}
    800049ac:	853e                	mv	a0,a5
    800049ae:	60e2                	ld	ra,24(sp)
    800049b0:	6442                	ld	s0,16(sp)
    800049b2:	6105                	addi	sp,sp,32
    800049b4:	8082                	ret

00000000800049b6 <sys_fstat>:
{
    800049b6:	1101                	addi	sp,sp,-32
    800049b8:	ec06                	sd	ra,24(sp)
    800049ba:	e822                	sd	s0,16(sp)
    800049bc:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    800049be:	fe040593          	addi	a1,s0,-32
    800049c2:	4505                	li	a0,1
    800049c4:	ffffd097          	auipc	ra,0xffffd
    800049c8:	75c080e7          	jalr	1884(ra) # 80002120 <argaddr>
  if(argfd(0, 0, &f) < 0)
    800049cc:	fe840613          	addi	a2,s0,-24
    800049d0:	4581                	li	a1,0
    800049d2:	4501                	li	a0,0
    800049d4:	00000097          	auipc	ra,0x0
    800049d8:	c68080e7          	jalr	-920(ra) # 8000463c <argfd>
    800049dc:	87aa                	mv	a5,a0
    return -1;
    800049de:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800049e0:	0007ca63          	bltz	a5,800049f4 <sys_fstat+0x3e>
  return filestat(f, st);
    800049e4:	fe043583          	ld	a1,-32(s0)
    800049e8:	fe843503          	ld	a0,-24(s0)
    800049ec:	fffff097          	auipc	ra,0xfffff
    800049f0:	2c2080e7          	jalr	706(ra) # 80003cae <filestat>
}
    800049f4:	60e2                	ld	ra,24(sp)
    800049f6:	6442                	ld	s0,16(sp)
    800049f8:	6105                	addi	sp,sp,32
    800049fa:	8082                	ret

00000000800049fc <sys_link>:
{
    800049fc:	7169                	addi	sp,sp,-304
    800049fe:	f606                	sd	ra,296(sp)
    80004a00:	f222                	sd	s0,288(sp)
    80004a02:	ee26                	sd	s1,280(sp)
    80004a04:	ea4a                	sd	s2,272(sp)
    80004a06:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a08:	08000613          	li	a2,128
    80004a0c:	ed040593          	addi	a1,s0,-304
    80004a10:	4501                	li	a0,0
    80004a12:	ffffd097          	auipc	ra,0xffffd
    80004a16:	72e080e7          	jalr	1838(ra) # 80002140 <argstr>
    return -1;
    80004a1a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a1c:	10054e63          	bltz	a0,80004b38 <sys_link+0x13c>
    80004a20:	08000613          	li	a2,128
    80004a24:	f5040593          	addi	a1,s0,-176
    80004a28:	4505                	li	a0,1
    80004a2a:	ffffd097          	auipc	ra,0xffffd
    80004a2e:	716080e7          	jalr	1814(ra) # 80002140 <argstr>
    return -1;
    80004a32:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a34:	10054263          	bltz	a0,80004b38 <sys_link+0x13c>
  begin_op();
    80004a38:	fffff097          	auipc	ra,0xfffff
    80004a3c:	ce2080e7          	jalr	-798(ra) # 8000371a <begin_op>
  if((ip = namei(old)) == 0){
    80004a40:	ed040513          	addi	a0,s0,-304
    80004a44:	fffff097          	auipc	ra,0xfffff
    80004a48:	aba080e7          	jalr	-1350(ra) # 800034fe <namei>
    80004a4c:	84aa                	mv	s1,a0
    80004a4e:	c551                	beqz	a0,80004ada <sys_link+0xde>
  ilock(ip);
    80004a50:	ffffe097          	auipc	ra,0xffffe
    80004a54:	308080e7          	jalr	776(ra) # 80002d58 <ilock>
  if(ip->type == T_DIR){
    80004a58:	04449703          	lh	a4,68(s1)
    80004a5c:	4785                	li	a5,1
    80004a5e:	08f70463          	beq	a4,a5,80004ae6 <sys_link+0xea>
  ip->nlink++;
    80004a62:	04a4d783          	lhu	a5,74(s1)
    80004a66:	2785                	addiw	a5,a5,1
    80004a68:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004a6c:	8526                	mv	a0,s1
    80004a6e:	ffffe097          	auipc	ra,0xffffe
    80004a72:	220080e7          	jalr	544(ra) # 80002c8e <iupdate>
  iunlock(ip);
    80004a76:	8526                	mv	a0,s1
    80004a78:	ffffe097          	auipc	ra,0xffffe
    80004a7c:	3a2080e7          	jalr	930(ra) # 80002e1a <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004a80:	fd040593          	addi	a1,s0,-48
    80004a84:	f5040513          	addi	a0,s0,-176
    80004a88:	fffff097          	auipc	ra,0xfffff
    80004a8c:	a94080e7          	jalr	-1388(ra) # 8000351c <nameiparent>
    80004a90:	892a                	mv	s2,a0
    80004a92:	c935                	beqz	a0,80004b06 <sys_link+0x10a>
  ilock(dp);
    80004a94:	ffffe097          	auipc	ra,0xffffe
    80004a98:	2c4080e7          	jalr	708(ra) # 80002d58 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004a9c:	00092703          	lw	a4,0(s2)
    80004aa0:	409c                	lw	a5,0(s1)
    80004aa2:	04f71d63          	bne	a4,a5,80004afc <sys_link+0x100>
    80004aa6:	40d0                	lw	a2,4(s1)
    80004aa8:	fd040593          	addi	a1,s0,-48
    80004aac:	854a                	mv	a0,s2
    80004aae:	fffff097          	auipc	ra,0xfffff
    80004ab2:	99e080e7          	jalr	-1634(ra) # 8000344c <dirlink>
    80004ab6:	04054363          	bltz	a0,80004afc <sys_link+0x100>
  iunlockput(dp);
    80004aba:	854a                	mv	a0,s2
    80004abc:	ffffe097          	auipc	ra,0xffffe
    80004ac0:	4fe080e7          	jalr	1278(ra) # 80002fba <iunlockput>
  iput(ip);
    80004ac4:	8526                	mv	a0,s1
    80004ac6:	ffffe097          	auipc	ra,0xffffe
    80004aca:	44c080e7          	jalr	1100(ra) # 80002f12 <iput>
  end_op();
    80004ace:	fffff097          	auipc	ra,0xfffff
    80004ad2:	ccc080e7          	jalr	-820(ra) # 8000379a <end_op>
  return 0;
    80004ad6:	4781                	li	a5,0
    80004ad8:	a085                	j	80004b38 <sys_link+0x13c>
    end_op();
    80004ada:	fffff097          	auipc	ra,0xfffff
    80004ade:	cc0080e7          	jalr	-832(ra) # 8000379a <end_op>
    return -1;
    80004ae2:	57fd                	li	a5,-1
    80004ae4:	a891                	j	80004b38 <sys_link+0x13c>
    iunlockput(ip);
    80004ae6:	8526                	mv	a0,s1
    80004ae8:	ffffe097          	auipc	ra,0xffffe
    80004aec:	4d2080e7          	jalr	1234(ra) # 80002fba <iunlockput>
    end_op();
    80004af0:	fffff097          	auipc	ra,0xfffff
    80004af4:	caa080e7          	jalr	-854(ra) # 8000379a <end_op>
    return -1;
    80004af8:	57fd                	li	a5,-1
    80004afa:	a83d                	j	80004b38 <sys_link+0x13c>
    iunlockput(dp);
    80004afc:	854a                	mv	a0,s2
    80004afe:	ffffe097          	auipc	ra,0xffffe
    80004b02:	4bc080e7          	jalr	1212(ra) # 80002fba <iunlockput>
  ilock(ip);
    80004b06:	8526                	mv	a0,s1
    80004b08:	ffffe097          	auipc	ra,0xffffe
    80004b0c:	250080e7          	jalr	592(ra) # 80002d58 <ilock>
  ip->nlink--;
    80004b10:	04a4d783          	lhu	a5,74(s1)
    80004b14:	37fd                	addiw	a5,a5,-1
    80004b16:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004b1a:	8526                	mv	a0,s1
    80004b1c:	ffffe097          	auipc	ra,0xffffe
    80004b20:	172080e7          	jalr	370(ra) # 80002c8e <iupdate>
  iunlockput(ip);
    80004b24:	8526                	mv	a0,s1
    80004b26:	ffffe097          	auipc	ra,0xffffe
    80004b2a:	494080e7          	jalr	1172(ra) # 80002fba <iunlockput>
  end_op();
    80004b2e:	fffff097          	auipc	ra,0xfffff
    80004b32:	c6c080e7          	jalr	-916(ra) # 8000379a <end_op>
  return -1;
    80004b36:	57fd                	li	a5,-1
}
    80004b38:	853e                	mv	a0,a5
    80004b3a:	70b2                	ld	ra,296(sp)
    80004b3c:	7412                	ld	s0,288(sp)
    80004b3e:	64f2                	ld	s1,280(sp)
    80004b40:	6952                	ld	s2,272(sp)
    80004b42:	6155                	addi	sp,sp,304
    80004b44:	8082                	ret

0000000080004b46 <sys_unlink>:
{
    80004b46:	7151                	addi	sp,sp,-240
    80004b48:	f586                	sd	ra,232(sp)
    80004b4a:	f1a2                	sd	s0,224(sp)
    80004b4c:	eda6                	sd	s1,216(sp)
    80004b4e:	e9ca                	sd	s2,208(sp)
    80004b50:	e5ce                	sd	s3,200(sp)
    80004b52:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004b54:	08000613          	li	a2,128
    80004b58:	f3040593          	addi	a1,s0,-208
    80004b5c:	4501                	li	a0,0
    80004b5e:	ffffd097          	auipc	ra,0xffffd
    80004b62:	5e2080e7          	jalr	1506(ra) # 80002140 <argstr>
    80004b66:	18054163          	bltz	a0,80004ce8 <sys_unlink+0x1a2>
  begin_op();
    80004b6a:	fffff097          	auipc	ra,0xfffff
    80004b6e:	bb0080e7          	jalr	-1104(ra) # 8000371a <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004b72:	fb040593          	addi	a1,s0,-80
    80004b76:	f3040513          	addi	a0,s0,-208
    80004b7a:	fffff097          	auipc	ra,0xfffff
    80004b7e:	9a2080e7          	jalr	-1630(ra) # 8000351c <nameiparent>
    80004b82:	84aa                	mv	s1,a0
    80004b84:	c979                	beqz	a0,80004c5a <sys_unlink+0x114>
  ilock(dp);
    80004b86:	ffffe097          	auipc	ra,0xffffe
    80004b8a:	1d2080e7          	jalr	466(ra) # 80002d58 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004b8e:	00004597          	auipc	a1,0x4
    80004b92:	b5a58593          	addi	a1,a1,-1190 # 800086e8 <syscalls+0x2f8>
    80004b96:	fb040513          	addi	a0,s0,-80
    80004b9a:	ffffe097          	auipc	ra,0xffffe
    80004b9e:	688080e7          	jalr	1672(ra) # 80003222 <namecmp>
    80004ba2:	14050a63          	beqz	a0,80004cf6 <sys_unlink+0x1b0>
    80004ba6:	00003597          	auipc	a1,0x3
    80004baa:	5b258593          	addi	a1,a1,1458 # 80008158 <etext+0x158>
    80004bae:	fb040513          	addi	a0,s0,-80
    80004bb2:	ffffe097          	auipc	ra,0xffffe
    80004bb6:	670080e7          	jalr	1648(ra) # 80003222 <namecmp>
    80004bba:	12050e63          	beqz	a0,80004cf6 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004bbe:	f2c40613          	addi	a2,s0,-212
    80004bc2:	fb040593          	addi	a1,s0,-80
    80004bc6:	8526                	mv	a0,s1
    80004bc8:	ffffe097          	auipc	ra,0xffffe
    80004bcc:	674080e7          	jalr	1652(ra) # 8000323c <dirlookup>
    80004bd0:	892a                	mv	s2,a0
    80004bd2:	12050263          	beqz	a0,80004cf6 <sys_unlink+0x1b0>
  ilock(ip);
    80004bd6:	ffffe097          	auipc	ra,0xffffe
    80004bda:	182080e7          	jalr	386(ra) # 80002d58 <ilock>
  if(ip->nlink < 1)
    80004bde:	04a91783          	lh	a5,74(s2)
    80004be2:	08f05263          	blez	a5,80004c66 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004be6:	04491703          	lh	a4,68(s2)
    80004bea:	4785                	li	a5,1
    80004bec:	08f70563          	beq	a4,a5,80004c76 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004bf0:	4641                	li	a2,16
    80004bf2:	4581                	li	a1,0
    80004bf4:	fc040513          	addi	a0,s0,-64
    80004bf8:	ffffb097          	auipc	ra,0xffffb
    80004bfc:	580080e7          	jalr	1408(ra) # 80000178 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004c00:	4741                	li	a4,16
    80004c02:	f2c42683          	lw	a3,-212(s0)
    80004c06:	fc040613          	addi	a2,s0,-64
    80004c0a:	4581                	li	a1,0
    80004c0c:	8526                	mv	a0,s1
    80004c0e:	ffffe097          	auipc	ra,0xffffe
    80004c12:	4f6080e7          	jalr	1270(ra) # 80003104 <writei>
    80004c16:	47c1                	li	a5,16
    80004c18:	0af51563          	bne	a0,a5,80004cc2 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004c1c:	04491703          	lh	a4,68(s2)
    80004c20:	4785                	li	a5,1
    80004c22:	0af70863          	beq	a4,a5,80004cd2 <sys_unlink+0x18c>
  iunlockput(dp);
    80004c26:	8526                	mv	a0,s1
    80004c28:	ffffe097          	auipc	ra,0xffffe
    80004c2c:	392080e7          	jalr	914(ra) # 80002fba <iunlockput>
  ip->nlink--;
    80004c30:	04a95783          	lhu	a5,74(s2)
    80004c34:	37fd                	addiw	a5,a5,-1
    80004c36:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004c3a:	854a                	mv	a0,s2
    80004c3c:	ffffe097          	auipc	ra,0xffffe
    80004c40:	052080e7          	jalr	82(ra) # 80002c8e <iupdate>
  iunlockput(ip);
    80004c44:	854a                	mv	a0,s2
    80004c46:	ffffe097          	auipc	ra,0xffffe
    80004c4a:	374080e7          	jalr	884(ra) # 80002fba <iunlockput>
  end_op();
    80004c4e:	fffff097          	auipc	ra,0xfffff
    80004c52:	b4c080e7          	jalr	-1204(ra) # 8000379a <end_op>
  return 0;
    80004c56:	4501                	li	a0,0
    80004c58:	a84d                	j	80004d0a <sys_unlink+0x1c4>
    end_op();
    80004c5a:	fffff097          	auipc	ra,0xfffff
    80004c5e:	b40080e7          	jalr	-1216(ra) # 8000379a <end_op>
    return -1;
    80004c62:	557d                	li	a0,-1
    80004c64:	a05d                	j	80004d0a <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004c66:	00004517          	auipc	a0,0x4
    80004c6a:	a8a50513          	addi	a0,a0,-1398 # 800086f0 <syscalls+0x300>
    80004c6e:	00001097          	auipc	ra,0x1
    80004c72:	214080e7          	jalr	532(ra) # 80005e82 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004c76:	04c92703          	lw	a4,76(s2)
    80004c7a:	02000793          	li	a5,32
    80004c7e:	f6e7f9e3          	bgeu	a5,a4,80004bf0 <sys_unlink+0xaa>
    80004c82:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004c86:	4741                	li	a4,16
    80004c88:	86ce                	mv	a3,s3
    80004c8a:	f1840613          	addi	a2,s0,-232
    80004c8e:	4581                	li	a1,0
    80004c90:	854a                	mv	a0,s2
    80004c92:	ffffe097          	auipc	ra,0xffffe
    80004c96:	37a080e7          	jalr	890(ra) # 8000300c <readi>
    80004c9a:	47c1                	li	a5,16
    80004c9c:	00f51b63          	bne	a0,a5,80004cb2 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004ca0:	f1845783          	lhu	a5,-232(s0)
    80004ca4:	e7a1                	bnez	a5,80004cec <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004ca6:	29c1                	addiw	s3,s3,16
    80004ca8:	04c92783          	lw	a5,76(s2)
    80004cac:	fcf9ede3          	bltu	s3,a5,80004c86 <sys_unlink+0x140>
    80004cb0:	b781                	j	80004bf0 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004cb2:	00004517          	auipc	a0,0x4
    80004cb6:	a5650513          	addi	a0,a0,-1450 # 80008708 <syscalls+0x318>
    80004cba:	00001097          	auipc	ra,0x1
    80004cbe:	1c8080e7          	jalr	456(ra) # 80005e82 <panic>
    panic("unlink: writei");
    80004cc2:	00004517          	auipc	a0,0x4
    80004cc6:	a5e50513          	addi	a0,a0,-1442 # 80008720 <syscalls+0x330>
    80004cca:	00001097          	auipc	ra,0x1
    80004cce:	1b8080e7          	jalr	440(ra) # 80005e82 <panic>
    dp->nlink--;
    80004cd2:	04a4d783          	lhu	a5,74(s1)
    80004cd6:	37fd                	addiw	a5,a5,-1
    80004cd8:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004cdc:	8526                	mv	a0,s1
    80004cde:	ffffe097          	auipc	ra,0xffffe
    80004ce2:	fb0080e7          	jalr	-80(ra) # 80002c8e <iupdate>
    80004ce6:	b781                	j	80004c26 <sys_unlink+0xe0>
    return -1;
    80004ce8:	557d                	li	a0,-1
    80004cea:	a005                	j	80004d0a <sys_unlink+0x1c4>
    iunlockput(ip);
    80004cec:	854a                	mv	a0,s2
    80004cee:	ffffe097          	auipc	ra,0xffffe
    80004cf2:	2cc080e7          	jalr	716(ra) # 80002fba <iunlockput>
  iunlockput(dp);
    80004cf6:	8526                	mv	a0,s1
    80004cf8:	ffffe097          	auipc	ra,0xffffe
    80004cfc:	2c2080e7          	jalr	706(ra) # 80002fba <iunlockput>
  end_op();
    80004d00:	fffff097          	auipc	ra,0xfffff
    80004d04:	a9a080e7          	jalr	-1382(ra) # 8000379a <end_op>
  return -1;
    80004d08:	557d                	li	a0,-1
}
    80004d0a:	70ae                	ld	ra,232(sp)
    80004d0c:	740e                	ld	s0,224(sp)
    80004d0e:	64ee                	ld	s1,216(sp)
    80004d10:	694e                	ld	s2,208(sp)
    80004d12:	69ae                	ld	s3,200(sp)
    80004d14:	616d                	addi	sp,sp,240
    80004d16:	8082                	ret

0000000080004d18 <sys_open>:

uint64
sys_open(void)
{
    80004d18:	7131                	addi	sp,sp,-192
    80004d1a:	fd06                	sd	ra,184(sp)
    80004d1c:	f922                	sd	s0,176(sp)
    80004d1e:	f526                	sd	s1,168(sp)
    80004d20:	f14a                	sd	s2,160(sp)
    80004d22:	ed4e                	sd	s3,152(sp)
    80004d24:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004d26:	f4c40593          	addi	a1,s0,-180
    80004d2a:	4505                	li	a0,1
    80004d2c:	ffffd097          	auipc	ra,0xffffd
    80004d30:	3d4080e7          	jalr	980(ra) # 80002100 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004d34:	08000613          	li	a2,128
    80004d38:	f5040593          	addi	a1,s0,-176
    80004d3c:	4501                	li	a0,0
    80004d3e:	ffffd097          	auipc	ra,0xffffd
    80004d42:	402080e7          	jalr	1026(ra) # 80002140 <argstr>
    80004d46:	87aa                	mv	a5,a0
    return -1;
    80004d48:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004d4a:	0a07c963          	bltz	a5,80004dfc <sys_open+0xe4>

  begin_op();
    80004d4e:	fffff097          	auipc	ra,0xfffff
    80004d52:	9cc080e7          	jalr	-1588(ra) # 8000371a <begin_op>

  if(omode & O_CREATE){
    80004d56:	f4c42783          	lw	a5,-180(s0)
    80004d5a:	2007f793          	andi	a5,a5,512
    80004d5e:	cfc5                	beqz	a5,80004e16 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004d60:	4681                	li	a3,0
    80004d62:	4601                	li	a2,0
    80004d64:	4589                	li	a1,2
    80004d66:	f5040513          	addi	a0,s0,-176
    80004d6a:	00000097          	auipc	ra,0x0
    80004d6e:	974080e7          	jalr	-1676(ra) # 800046de <create>
    80004d72:	84aa                	mv	s1,a0
    if(ip == 0){
    80004d74:	c959                	beqz	a0,80004e0a <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004d76:	04449703          	lh	a4,68(s1)
    80004d7a:	478d                	li	a5,3
    80004d7c:	00f71763          	bne	a4,a5,80004d8a <sys_open+0x72>
    80004d80:	0464d703          	lhu	a4,70(s1)
    80004d84:	47a5                	li	a5,9
    80004d86:	0ce7ed63          	bltu	a5,a4,80004e60 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004d8a:	fffff097          	auipc	ra,0xfffff
    80004d8e:	da0080e7          	jalr	-608(ra) # 80003b2a <filealloc>
    80004d92:	89aa                	mv	s3,a0
    80004d94:	10050363          	beqz	a0,80004e9a <sys_open+0x182>
    80004d98:	00000097          	auipc	ra,0x0
    80004d9c:	904080e7          	jalr	-1788(ra) # 8000469c <fdalloc>
    80004da0:	892a                	mv	s2,a0
    80004da2:	0e054763          	bltz	a0,80004e90 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004da6:	04449703          	lh	a4,68(s1)
    80004daa:	478d                	li	a5,3
    80004dac:	0cf70563          	beq	a4,a5,80004e76 <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004db0:	4789                	li	a5,2
    80004db2:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004db6:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004dba:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004dbe:	f4c42783          	lw	a5,-180(s0)
    80004dc2:	0017c713          	xori	a4,a5,1
    80004dc6:	8b05                	andi	a4,a4,1
    80004dc8:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004dcc:	0037f713          	andi	a4,a5,3
    80004dd0:	00e03733          	snez	a4,a4
    80004dd4:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004dd8:	4007f793          	andi	a5,a5,1024
    80004ddc:	c791                	beqz	a5,80004de8 <sys_open+0xd0>
    80004dde:	04449703          	lh	a4,68(s1)
    80004de2:	4789                	li	a5,2
    80004de4:	0af70063          	beq	a4,a5,80004e84 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004de8:	8526                	mv	a0,s1
    80004dea:	ffffe097          	auipc	ra,0xffffe
    80004dee:	030080e7          	jalr	48(ra) # 80002e1a <iunlock>
  end_op();
    80004df2:	fffff097          	auipc	ra,0xfffff
    80004df6:	9a8080e7          	jalr	-1624(ra) # 8000379a <end_op>

  return fd;
    80004dfa:	854a                	mv	a0,s2
}
    80004dfc:	70ea                	ld	ra,184(sp)
    80004dfe:	744a                	ld	s0,176(sp)
    80004e00:	74aa                	ld	s1,168(sp)
    80004e02:	790a                	ld	s2,160(sp)
    80004e04:	69ea                	ld	s3,152(sp)
    80004e06:	6129                	addi	sp,sp,192
    80004e08:	8082                	ret
      end_op();
    80004e0a:	fffff097          	auipc	ra,0xfffff
    80004e0e:	990080e7          	jalr	-1648(ra) # 8000379a <end_op>
      return -1;
    80004e12:	557d                	li	a0,-1
    80004e14:	b7e5                	j	80004dfc <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004e16:	f5040513          	addi	a0,s0,-176
    80004e1a:	ffffe097          	auipc	ra,0xffffe
    80004e1e:	6e4080e7          	jalr	1764(ra) # 800034fe <namei>
    80004e22:	84aa                	mv	s1,a0
    80004e24:	c905                	beqz	a0,80004e54 <sys_open+0x13c>
    ilock(ip);
    80004e26:	ffffe097          	auipc	ra,0xffffe
    80004e2a:	f32080e7          	jalr	-206(ra) # 80002d58 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004e2e:	04449703          	lh	a4,68(s1)
    80004e32:	4785                	li	a5,1
    80004e34:	f4f711e3          	bne	a4,a5,80004d76 <sys_open+0x5e>
    80004e38:	f4c42783          	lw	a5,-180(s0)
    80004e3c:	d7b9                	beqz	a5,80004d8a <sys_open+0x72>
      iunlockput(ip);
    80004e3e:	8526                	mv	a0,s1
    80004e40:	ffffe097          	auipc	ra,0xffffe
    80004e44:	17a080e7          	jalr	378(ra) # 80002fba <iunlockput>
      end_op();
    80004e48:	fffff097          	auipc	ra,0xfffff
    80004e4c:	952080e7          	jalr	-1710(ra) # 8000379a <end_op>
      return -1;
    80004e50:	557d                	li	a0,-1
    80004e52:	b76d                	j	80004dfc <sys_open+0xe4>
      end_op();
    80004e54:	fffff097          	auipc	ra,0xfffff
    80004e58:	946080e7          	jalr	-1722(ra) # 8000379a <end_op>
      return -1;
    80004e5c:	557d                	li	a0,-1
    80004e5e:	bf79                	j	80004dfc <sys_open+0xe4>
    iunlockput(ip);
    80004e60:	8526                	mv	a0,s1
    80004e62:	ffffe097          	auipc	ra,0xffffe
    80004e66:	158080e7          	jalr	344(ra) # 80002fba <iunlockput>
    end_op();
    80004e6a:	fffff097          	auipc	ra,0xfffff
    80004e6e:	930080e7          	jalr	-1744(ra) # 8000379a <end_op>
    return -1;
    80004e72:	557d                	li	a0,-1
    80004e74:	b761                	j	80004dfc <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004e76:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004e7a:	04649783          	lh	a5,70(s1)
    80004e7e:	02f99223          	sh	a5,36(s3)
    80004e82:	bf25                	j	80004dba <sys_open+0xa2>
    itrunc(ip);
    80004e84:	8526                	mv	a0,s1
    80004e86:	ffffe097          	auipc	ra,0xffffe
    80004e8a:	fe0080e7          	jalr	-32(ra) # 80002e66 <itrunc>
    80004e8e:	bfa9                	j	80004de8 <sys_open+0xd0>
      fileclose(f);
    80004e90:	854e                	mv	a0,s3
    80004e92:	fffff097          	auipc	ra,0xfffff
    80004e96:	d54080e7          	jalr	-684(ra) # 80003be6 <fileclose>
    iunlockput(ip);
    80004e9a:	8526                	mv	a0,s1
    80004e9c:	ffffe097          	auipc	ra,0xffffe
    80004ea0:	11e080e7          	jalr	286(ra) # 80002fba <iunlockput>
    end_op();
    80004ea4:	fffff097          	auipc	ra,0xfffff
    80004ea8:	8f6080e7          	jalr	-1802(ra) # 8000379a <end_op>
    return -1;
    80004eac:	557d                	li	a0,-1
    80004eae:	b7b9                	j	80004dfc <sys_open+0xe4>

0000000080004eb0 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004eb0:	7175                	addi	sp,sp,-144
    80004eb2:	e506                	sd	ra,136(sp)
    80004eb4:	e122                	sd	s0,128(sp)
    80004eb6:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004eb8:	fffff097          	auipc	ra,0xfffff
    80004ebc:	862080e7          	jalr	-1950(ra) # 8000371a <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004ec0:	08000613          	li	a2,128
    80004ec4:	f7040593          	addi	a1,s0,-144
    80004ec8:	4501                	li	a0,0
    80004eca:	ffffd097          	auipc	ra,0xffffd
    80004ece:	276080e7          	jalr	630(ra) # 80002140 <argstr>
    80004ed2:	02054963          	bltz	a0,80004f04 <sys_mkdir+0x54>
    80004ed6:	4681                	li	a3,0
    80004ed8:	4601                	li	a2,0
    80004eda:	4585                	li	a1,1
    80004edc:	f7040513          	addi	a0,s0,-144
    80004ee0:	fffff097          	auipc	ra,0xfffff
    80004ee4:	7fe080e7          	jalr	2046(ra) # 800046de <create>
    80004ee8:	cd11                	beqz	a0,80004f04 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004eea:	ffffe097          	auipc	ra,0xffffe
    80004eee:	0d0080e7          	jalr	208(ra) # 80002fba <iunlockput>
  end_op();
    80004ef2:	fffff097          	auipc	ra,0xfffff
    80004ef6:	8a8080e7          	jalr	-1880(ra) # 8000379a <end_op>
  return 0;
    80004efa:	4501                	li	a0,0
}
    80004efc:	60aa                	ld	ra,136(sp)
    80004efe:	640a                	ld	s0,128(sp)
    80004f00:	6149                	addi	sp,sp,144
    80004f02:	8082                	ret
    end_op();
    80004f04:	fffff097          	auipc	ra,0xfffff
    80004f08:	896080e7          	jalr	-1898(ra) # 8000379a <end_op>
    return -1;
    80004f0c:	557d                	li	a0,-1
    80004f0e:	b7fd                	j	80004efc <sys_mkdir+0x4c>

0000000080004f10 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004f10:	7135                	addi	sp,sp,-160
    80004f12:	ed06                	sd	ra,152(sp)
    80004f14:	e922                	sd	s0,144(sp)
    80004f16:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004f18:	fffff097          	auipc	ra,0xfffff
    80004f1c:	802080e7          	jalr	-2046(ra) # 8000371a <begin_op>
  argint(1, &major);
    80004f20:	f6c40593          	addi	a1,s0,-148
    80004f24:	4505                	li	a0,1
    80004f26:	ffffd097          	auipc	ra,0xffffd
    80004f2a:	1da080e7          	jalr	474(ra) # 80002100 <argint>
  argint(2, &minor);
    80004f2e:	f6840593          	addi	a1,s0,-152
    80004f32:	4509                	li	a0,2
    80004f34:	ffffd097          	auipc	ra,0xffffd
    80004f38:	1cc080e7          	jalr	460(ra) # 80002100 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004f3c:	08000613          	li	a2,128
    80004f40:	f7040593          	addi	a1,s0,-144
    80004f44:	4501                	li	a0,0
    80004f46:	ffffd097          	auipc	ra,0xffffd
    80004f4a:	1fa080e7          	jalr	506(ra) # 80002140 <argstr>
    80004f4e:	02054b63          	bltz	a0,80004f84 <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004f52:	f6841683          	lh	a3,-152(s0)
    80004f56:	f6c41603          	lh	a2,-148(s0)
    80004f5a:	458d                	li	a1,3
    80004f5c:	f7040513          	addi	a0,s0,-144
    80004f60:	fffff097          	auipc	ra,0xfffff
    80004f64:	77e080e7          	jalr	1918(ra) # 800046de <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004f68:	cd11                	beqz	a0,80004f84 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004f6a:	ffffe097          	auipc	ra,0xffffe
    80004f6e:	050080e7          	jalr	80(ra) # 80002fba <iunlockput>
  end_op();
    80004f72:	fffff097          	auipc	ra,0xfffff
    80004f76:	828080e7          	jalr	-2008(ra) # 8000379a <end_op>
  return 0;
    80004f7a:	4501                	li	a0,0
}
    80004f7c:	60ea                	ld	ra,152(sp)
    80004f7e:	644a                	ld	s0,144(sp)
    80004f80:	610d                	addi	sp,sp,160
    80004f82:	8082                	ret
    end_op();
    80004f84:	fffff097          	auipc	ra,0xfffff
    80004f88:	816080e7          	jalr	-2026(ra) # 8000379a <end_op>
    return -1;
    80004f8c:	557d                	li	a0,-1
    80004f8e:	b7fd                	j	80004f7c <sys_mknod+0x6c>

0000000080004f90 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004f90:	7135                	addi	sp,sp,-160
    80004f92:	ed06                	sd	ra,152(sp)
    80004f94:	e922                	sd	s0,144(sp)
    80004f96:	e526                	sd	s1,136(sp)
    80004f98:	e14a                	sd	s2,128(sp)
    80004f9a:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004f9c:	ffffc097          	auipc	ra,0xffffc
    80004fa0:	f98080e7          	jalr	-104(ra) # 80000f34 <myproc>
    80004fa4:	892a                	mv	s2,a0
  
  begin_op();
    80004fa6:	ffffe097          	auipc	ra,0xffffe
    80004faa:	774080e7          	jalr	1908(ra) # 8000371a <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004fae:	08000613          	li	a2,128
    80004fb2:	f6040593          	addi	a1,s0,-160
    80004fb6:	4501                	li	a0,0
    80004fb8:	ffffd097          	auipc	ra,0xffffd
    80004fbc:	188080e7          	jalr	392(ra) # 80002140 <argstr>
    80004fc0:	04054b63          	bltz	a0,80005016 <sys_chdir+0x86>
    80004fc4:	f6040513          	addi	a0,s0,-160
    80004fc8:	ffffe097          	auipc	ra,0xffffe
    80004fcc:	536080e7          	jalr	1334(ra) # 800034fe <namei>
    80004fd0:	84aa                	mv	s1,a0
    80004fd2:	c131                	beqz	a0,80005016 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004fd4:	ffffe097          	auipc	ra,0xffffe
    80004fd8:	d84080e7          	jalr	-636(ra) # 80002d58 <ilock>
  if(ip->type != T_DIR){
    80004fdc:	04449703          	lh	a4,68(s1)
    80004fe0:	4785                	li	a5,1
    80004fe2:	04f71063          	bne	a4,a5,80005022 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004fe6:	8526                	mv	a0,s1
    80004fe8:	ffffe097          	auipc	ra,0xffffe
    80004fec:	e32080e7          	jalr	-462(ra) # 80002e1a <iunlock>
  iput(p->cwd);
    80004ff0:	15093503          	ld	a0,336(s2)
    80004ff4:	ffffe097          	auipc	ra,0xffffe
    80004ff8:	f1e080e7          	jalr	-226(ra) # 80002f12 <iput>
  end_op();
    80004ffc:	ffffe097          	auipc	ra,0xffffe
    80005000:	79e080e7          	jalr	1950(ra) # 8000379a <end_op>
  p->cwd = ip;
    80005004:	14993823          	sd	s1,336(s2)
  return 0;
    80005008:	4501                	li	a0,0
}
    8000500a:	60ea                	ld	ra,152(sp)
    8000500c:	644a                	ld	s0,144(sp)
    8000500e:	64aa                	ld	s1,136(sp)
    80005010:	690a                	ld	s2,128(sp)
    80005012:	610d                	addi	sp,sp,160
    80005014:	8082                	ret
    end_op();
    80005016:	ffffe097          	auipc	ra,0xffffe
    8000501a:	784080e7          	jalr	1924(ra) # 8000379a <end_op>
    return -1;
    8000501e:	557d                	li	a0,-1
    80005020:	b7ed                	j	8000500a <sys_chdir+0x7a>
    iunlockput(ip);
    80005022:	8526                	mv	a0,s1
    80005024:	ffffe097          	auipc	ra,0xffffe
    80005028:	f96080e7          	jalr	-106(ra) # 80002fba <iunlockput>
    end_op();
    8000502c:	ffffe097          	auipc	ra,0xffffe
    80005030:	76e080e7          	jalr	1902(ra) # 8000379a <end_op>
    return -1;
    80005034:	557d                	li	a0,-1
    80005036:	bfd1                	j	8000500a <sys_chdir+0x7a>

0000000080005038 <sys_exec>:

uint64
sys_exec(void)
{
    80005038:	7145                	addi	sp,sp,-464
    8000503a:	e786                	sd	ra,456(sp)
    8000503c:	e3a2                	sd	s0,448(sp)
    8000503e:	ff26                	sd	s1,440(sp)
    80005040:	fb4a                	sd	s2,432(sp)
    80005042:	f74e                	sd	s3,424(sp)
    80005044:	f352                	sd	s4,416(sp)
    80005046:	ef56                	sd	s5,408(sp)
    80005048:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    8000504a:	e3840593          	addi	a1,s0,-456
    8000504e:	4505                	li	a0,1
    80005050:	ffffd097          	auipc	ra,0xffffd
    80005054:	0d0080e7          	jalr	208(ra) # 80002120 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80005058:	08000613          	li	a2,128
    8000505c:	f4040593          	addi	a1,s0,-192
    80005060:	4501                	li	a0,0
    80005062:	ffffd097          	auipc	ra,0xffffd
    80005066:	0de080e7          	jalr	222(ra) # 80002140 <argstr>
    8000506a:	87aa                	mv	a5,a0
    return -1;
    8000506c:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    8000506e:	0c07c263          	bltz	a5,80005132 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80005072:	10000613          	li	a2,256
    80005076:	4581                	li	a1,0
    80005078:	e4040513          	addi	a0,s0,-448
    8000507c:	ffffb097          	auipc	ra,0xffffb
    80005080:	0fc080e7          	jalr	252(ra) # 80000178 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005084:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80005088:	89a6                	mv	s3,s1
    8000508a:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    8000508c:	02000a13          	li	s4,32
    80005090:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005094:	00391513          	slli	a0,s2,0x3
    80005098:	e3040593          	addi	a1,s0,-464
    8000509c:	e3843783          	ld	a5,-456(s0)
    800050a0:	953e                	add	a0,a0,a5
    800050a2:	ffffd097          	auipc	ra,0xffffd
    800050a6:	fc0080e7          	jalr	-64(ra) # 80002062 <fetchaddr>
    800050aa:	02054a63          	bltz	a0,800050de <sys_exec+0xa6>
      goto bad;
    }
    if(uarg == 0){
    800050ae:	e3043783          	ld	a5,-464(s0)
    800050b2:	c3b9                	beqz	a5,800050f8 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    800050b4:	ffffb097          	auipc	ra,0xffffb
    800050b8:	064080e7          	jalr	100(ra) # 80000118 <kalloc>
    800050bc:	85aa                	mv	a1,a0
    800050be:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800050c2:	cd11                	beqz	a0,800050de <sys_exec+0xa6>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800050c4:	6605                	lui	a2,0x1
    800050c6:	e3043503          	ld	a0,-464(s0)
    800050ca:	ffffd097          	auipc	ra,0xffffd
    800050ce:	fea080e7          	jalr	-22(ra) # 800020b4 <fetchstr>
    800050d2:	00054663          	bltz	a0,800050de <sys_exec+0xa6>
    if(i >= NELEM(argv)){
    800050d6:	0905                	addi	s2,s2,1
    800050d8:	09a1                	addi	s3,s3,8
    800050da:	fb491be3          	bne	s2,s4,80005090 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050de:	10048913          	addi	s2,s1,256
    800050e2:	6088                	ld	a0,0(s1)
    800050e4:	c531                	beqz	a0,80005130 <sys_exec+0xf8>
    kfree(argv[i]);
    800050e6:	ffffb097          	auipc	ra,0xffffb
    800050ea:	f36080e7          	jalr	-202(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050ee:	04a1                	addi	s1,s1,8
    800050f0:	ff2499e3          	bne	s1,s2,800050e2 <sys_exec+0xaa>
  return -1;
    800050f4:	557d                	li	a0,-1
    800050f6:	a835                	j	80005132 <sys_exec+0xfa>
      argv[i] = 0;
    800050f8:	0a8e                	slli	s5,s5,0x3
    800050fa:	fc040793          	addi	a5,s0,-64
    800050fe:	9abe                	add	s5,s5,a5
    80005100:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80005104:	e4040593          	addi	a1,s0,-448
    80005108:	f4040513          	addi	a0,s0,-192
    8000510c:	fffff097          	auipc	ra,0xfffff
    80005110:	162080e7          	jalr	354(ra) # 8000426e <exec>
    80005114:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005116:	10048993          	addi	s3,s1,256
    8000511a:	6088                	ld	a0,0(s1)
    8000511c:	c901                	beqz	a0,8000512c <sys_exec+0xf4>
    kfree(argv[i]);
    8000511e:	ffffb097          	auipc	ra,0xffffb
    80005122:	efe080e7          	jalr	-258(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005126:	04a1                	addi	s1,s1,8
    80005128:	ff3499e3          	bne	s1,s3,8000511a <sys_exec+0xe2>
  return ret;
    8000512c:	854a                	mv	a0,s2
    8000512e:	a011                	j	80005132 <sys_exec+0xfa>
  return -1;
    80005130:	557d                	li	a0,-1
}
    80005132:	60be                	ld	ra,456(sp)
    80005134:	641e                	ld	s0,448(sp)
    80005136:	74fa                	ld	s1,440(sp)
    80005138:	795a                	ld	s2,432(sp)
    8000513a:	79ba                	ld	s3,424(sp)
    8000513c:	7a1a                	ld	s4,416(sp)
    8000513e:	6afa                	ld	s5,408(sp)
    80005140:	6179                	addi	sp,sp,464
    80005142:	8082                	ret

0000000080005144 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005144:	7139                	addi	sp,sp,-64
    80005146:	fc06                	sd	ra,56(sp)
    80005148:	f822                	sd	s0,48(sp)
    8000514a:	f426                	sd	s1,40(sp)
    8000514c:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    8000514e:	ffffc097          	auipc	ra,0xffffc
    80005152:	de6080e7          	jalr	-538(ra) # 80000f34 <myproc>
    80005156:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80005158:	fd840593          	addi	a1,s0,-40
    8000515c:	4501                	li	a0,0
    8000515e:	ffffd097          	auipc	ra,0xffffd
    80005162:	fc2080e7          	jalr	-62(ra) # 80002120 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80005166:	fc840593          	addi	a1,s0,-56
    8000516a:	fd040513          	addi	a0,s0,-48
    8000516e:	fffff097          	auipc	ra,0xfffff
    80005172:	da8080e7          	jalr	-600(ra) # 80003f16 <pipealloc>
    return -1;
    80005176:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005178:	0c054463          	bltz	a0,80005240 <sys_pipe+0xfc>
  fd0 = -1;
    8000517c:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005180:	fd043503          	ld	a0,-48(s0)
    80005184:	fffff097          	auipc	ra,0xfffff
    80005188:	518080e7          	jalr	1304(ra) # 8000469c <fdalloc>
    8000518c:	fca42223          	sw	a0,-60(s0)
    80005190:	08054b63          	bltz	a0,80005226 <sys_pipe+0xe2>
    80005194:	fc843503          	ld	a0,-56(s0)
    80005198:	fffff097          	auipc	ra,0xfffff
    8000519c:	504080e7          	jalr	1284(ra) # 8000469c <fdalloc>
    800051a0:	fca42023          	sw	a0,-64(s0)
    800051a4:	06054863          	bltz	a0,80005214 <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800051a8:	4691                	li	a3,4
    800051aa:	fc440613          	addi	a2,s0,-60
    800051ae:	fd843583          	ld	a1,-40(s0)
    800051b2:	68a8                	ld	a0,80(s1)
    800051b4:	ffffc097          	auipc	ra,0xffffc
    800051b8:	962080e7          	jalr	-1694(ra) # 80000b16 <copyout>
    800051bc:	02054063          	bltz	a0,800051dc <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800051c0:	4691                	li	a3,4
    800051c2:	fc040613          	addi	a2,s0,-64
    800051c6:	fd843583          	ld	a1,-40(s0)
    800051ca:	0591                	addi	a1,a1,4
    800051cc:	68a8                	ld	a0,80(s1)
    800051ce:	ffffc097          	auipc	ra,0xffffc
    800051d2:	948080e7          	jalr	-1720(ra) # 80000b16 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800051d6:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800051d8:	06055463          	bgez	a0,80005240 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    800051dc:	fc442783          	lw	a5,-60(s0)
    800051e0:	07e9                	addi	a5,a5,26
    800051e2:	078e                	slli	a5,a5,0x3
    800051e4:	97a6                	add	a5,a5,s1
    800051e6:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800051ea:	fc042503          	lw	a0,-64(s0)
    800051ee:	0569                	addi	a0,a0,26
    800051f0:	050e                	slli	a0,a0,0x3
    800051f2:	94aa                	add	s1,s1,a0
    800051f4:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    800051f8:	fd043503          	ld	a0,-48(s0)
    800051fc:	fffff097          	auipc	ra,0xfffff
    80005200:	9ea080e7          	jalr	-1558(ra) # 80003be6 <fileclose>
    fileclose(wf);
    80005204:	fc843503          	ld	a0,-56(s0)
    80005208:	fffff097          	auipc	ra,0xfffff
    8000520c:	9de080e7          	jalr	-1570(ra) # 80003be6 <fileclose>
    return -1;
    80005210:	57fd                	li	a5,-1
    80005212:	a03d                	j	80005240 <sys_pipe+0xfc>
    if(fd0 >= 0)
    80005214:	fc442783          	lw	a5,-60(s0)
    80005218:	0007c763          	bltz	a5,80005226 <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    8000521c:	07e9                	addi	a5,a5,26
    8000521e:	078e                	slli	a5,a5,0x3
    80005220:	94be                	add	s1,s1,a5
    80005222:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005226:	fd043503          	ld	a0,-48(s0)
    8000522a:	fffff097          	auipc	ra,0xfffff
    8000522e:	9bc080e7          	jalr	-1604(ra) # 80003be6 <fileclose>
    fileclose(wf);
    80005232:	fc843503          	ld	a0,-56(s0)
    80005236:	fffff097          	auipc	ra,0xfffff
    8000523a:	9b0080e7          	jalr	-1616(ra) # 80003be6 <fileclose>
    return -1;
    8000523e:	57fd                	li	a5,-1
}
    80005240:	853e                	mv	a0,a5
    80005242:	70e2                	ld	ra,56(sp)
    80005244:	7442                	ld	s0,48(sp)
    80005246:	74a2                	ld	s1,40(sp)
    80005248:	6121                	addi	sp,sp,64
    8000524a:	8082                	ret
    8000524c:	0000                	unimp
	...

0000000080005250 <kernelvec>:
    80005250:	7111                	addi	sp,sp,-256
    80005252:	e006                	sd	ra,0(sp)
    80005254:	e40a                	sd	sp,8(sp)
    80005256:	e80e                	sd	gp,16(sp)
    80005258:	ec12                	sd	tp,24(sp)
    8000525a:	f016                	sd	t0,32(sp)
    8000525c:	f41a                	sd	t1,40(sp)
    8000525e:	f81e                	sd	t2,48(sp)
    80005260:	fc22                	sd	s0,56(sp)
    80005262:	e0a6                	sd	s1,64(sp)
    80005264:	e4aa                	sd	a0,72(sp)
    80005266:	e8ae                	sd	a1,80(sp)
    80005268:	ecb2                	sd	a2,88(sp)
    8000526a:	f0b6                	sd	a3,96(sp)
    8000526c:	f4ba                	sd	a4,104(sp)
    8000526e:	f8be                	sd	a5,112(sp)
    80005270:	fcc2                	sd	a6,120(sp)
    80005272:	e146                	sd	a7,128(sp)
    80005274:	e54a                	sd	s2,136(sp)
    80005276:	e94e                	sd	s3,144(sp)
    80005278:	ed52                	sd	s4,152(sp)
    8000527a:	f156                	sd	s5,160(sp)
    8000527c:	f55a                	sd	s6,168(sp)
    8000527e:	f95e                	sd	s7,176(sp)
    80005280:	fd62                	sd	s8,184(sp)
    80005282:	e1e6                	sd	s9,192(sp)
    80005284:	e5ea                	sd	s10,200(sp)
    80005286:	e9ee                	sd	s11,208(sp)
    80005288:	edf2                	sd	t3,216(sp)
    8000528a:	f1f6                	sd	t4,224(sp)
    8000528c:	f5fa                	sd	t5,232(sp)
    8000528e:	f9fe                	sd	t6,240(sp)
    80005290:	c9ffc0ef          	jal	ra,80001f2e <kerneltrap>
    80005294:	6082                	ld	ra,0(sp)
    80005296:	6122                	ld	sp,8(sp)
    80005298:	61c2                	ld	gp,16(sp)
    8000529a:	7282                	ld	t0,32(sp)
    8000529c:	7322                	ld	t1,40(sp)
    8000529e:	73c2                	ld	t2,48(sp)
    800052a0:	7462                	ld	s0,56(sp)
    800052a2:	6486                	ld	s1,64(sp)
    800052a4:	6526                	ld	a0,72(sp)
    800052a6:	65c6                	ld	a1,80(sp)
    800052a8:	6666                	ld	a2,88(sp)
    800052aa:	7686                	ld	a3,96(sp)
    800052ac:	7726                	ld	a4,104(sp)
    800052ae:	77c6                	ld	a5,112(sp)
    800052b0:	7866                	ld	a6,120(sp)
    800052b2:	688a                	ld	a7,128(sp)
    800052b4:	692a                	ld	s2,136(sp)
    800052b6:	69ca                	ld	s3,144(sp)
    800052b8:	6a6a                	ld	s4,152(sp)
    800052ba:	7a8a                	ld	s5,160(sp)
    800052bc:	7b2a                	ld	s6,168(sp)
    800052be:	7bca                	ld	s7,176(sp)
    800052c0:	7c6a                	ld	s8,184(sp)
    800052c2:	6c8e                	ld	s9,192(sp)
    800052c4:	6d2e                	ld	s10,200(sp)
    800052c6:	6dce                	ld	s11,208(sp)
    800052c8:	6e6e                	ld	t3,216(sp)
    800052ca:	7e8e                	ld	t4,224(sp)
    800052cc:	7f2e                	ld	t5,232(sp)
    800052ce:	7fce                	ld	t6,240(sp)
    800052d0:	6111                	addi	sp,sp,256
    800052d2:	10200073          	sret
    800052d6:	00000013          	nop
    800052da:	00000013          	nop
    800052de:	0001                	nop

00000000800052e0 <timervec>:
    800052e0:	34051573          	csrrw	a0,mscratch,a0
    800052e4:	e10c                	sd	a1,0(a0)
    800052e6:	e510                	sd	a2,8(a0)
    800052e8:	e914                	sd	a3,16(a0)
    800052ea:	6d0c                	ld	a1,24(a0)
    800052ec:	7110                	ld	a2,32(a0)
    800052ee:	6194                	ld	a3,0(a1)
    800052f0:	96b2                	add	a3,a3,a2
    800052f2:	e194                	sd	a3,0(a1)
    800052f4:	4589                	li	a1,2
    800052f6:	14459073          	csrw	sip,a1
    800052fa:	6914                	ld	a3,16(a0)
    800052fc:	6510                	ld	a2,8(a0)
    800052fe:	610c                	ld	a1,0(a0)
    80005300:	34051573          	csrrw	a0,mscratch,a0
    80005304:	30200073          	mret
	...

000000008000530a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000530a:	1141                	addi	sp,sp,-16
    8000530c:	e422                	sd	s0,8(sp)
    8000530e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005310:	0c0007b7          	lui	a5,0xc000
    80005314:	4705                	li	a4,1
    80005316:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005318:	c3d8                	sw	a4,4(a5)
}
    8000531a:	6422                	ld	s0,8(sp)
    8000531c:	0141                	addi	sp,sp,16
    8000531e:	8082                	ret

0000000080005320 <plicinithart>:

void
plicinithart(void)
{
    80005320:	1141                	addi	sp,sp,-16
    80005322:	e406                	sd	ra,8(sp)
    80005324:	e022                	sd	s0,0(sp)
    80005326:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005328:	ffffc097          	auipc	ra,0xffffc
    8000532c:	be0080e7          	jalr	-1056(ra) # 80000f08 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005330:	0085171b          	slliw	a4,a0,0x8
    80005334:	0c0027b7          	lui	a5,0xc002
    80005338:	97ba                	add	a5,a5,a4
    8000533a:	40200713          	li	a4,1026
    8000533e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005342:	00d5151b          	slliw	a0,a0,0xd
    80005346:	0c2017b7          	lui	a5,0xc201
    8000534a:	953e                	add	a0,a0,a5
    8000534c:	00052023          	sw	zero,0(a0)
}
    80005350:	60a2                	ld	ra,8(sp)
    80005352:	6402                	ld	s0,0(sp)
    80005354:	0141                	addi	sp,sp,16
    80005356:	8082                	ret

0000000080005358 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005358:	1141                	addi	sp,sp,-16
    8000535a:	e406                	sd	ra,8(sp)
    8000535c:	e022                	sd	s0,0(sp)
    8000535e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005360:	ffffc097          	auipc	ra,0xffffc
    80005364:	ba8080e7          	jalr	-1112(ra) # 80000f08 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005368:	00d5179b          	slliw	a5,a0,0xd
    8000536c:	0c201537          	lui	a0,0xc201
    80005370:	953e                	add	a0,a0,a5
  return irq;
}
    80005372:	4148                	lw	a0,4(a0)
    80005374:	60a2                	ld	ra,8(sp)
    80005376:	6402                	ld	s0,0(sp)
    80005378:	0141                	addi	sp,sp,16
    8000537a:	8082                	ret

000000008000537c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000537c:	1101                	addi	sp,sp,-32
    8000537e:	ec06                	sd	ra,24(sp)
    80005380:	e822                	sd	s0,16(sp)
    80005382:	e426                	sd	s1,8(sp)
    80005384:	1000                	addi	s0,sp,32
    80005386:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005388:	ffffc097          	auipc	ra,0xffffc
    8000538c:	b80080e7          	jalr	-1152(ra) # 80000f08 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005390:	00d5151b          	slliw	a0,a0,0xd
    80005394:	0c2017b7          	lui	a5,0xc201
    80005398:	97aa                	add	a5,a5,a0
    8000539a:	c3c4                	sw	s1,4(a5)
}
    8000539c:	60e2                	ld	ra,24(sp)
    8000539e:	6442                	ld	s0,16(sp)
    800053a0:	64a2                	ld	s1,8(sp)
    800053a2:	6105                	addi	sp,sp,32
    800053a4:	8082                	ret

00000000800053a6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800053a6:	1141                	addi	sp,sp,-16
    800053a8:	e406                	sd	ra,8(sp)
    800053aa:	e022                	sd	s0,0(sp)
    800053ac:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800053ae:	479d                	li	a5,7
    800053b0:	04a7cc63          	blt	a5,a0,80005408 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    800053b4:	00015797          	auipc	a5,0x15
    800053b8:	88c78793          	addi	a5,a5,-1908 # 80019c40 <disk>
    800053bc:	97aa                	add	a5,a5,a0
    800053be:	0187c783          	lbu	a5,24(a5)
    800053c2:	ebb9                	bnez	a5,80005418 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800053c4:	00451613          	slli	a2,a0,0x4
    800053c8:	00015797          	auipc	a5,0x15
    800053cc:	87878793          	addi	a5,a5,-1928 # 80019c40 <disk>
    800053d0:	6394                	ld	a3,0(a5)
    800053d2:	96b2                	add	a3,a3,a2
    800053d4:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800053d8:	6398                	ld	a4,0(a5)
    800053da:	9732                	add	a4,a4,a2
    800053dc:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800053e0:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800053e4:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800053e8:	953e                	add	a0,a0,a5
    800053ea:	4785                	li	a5,1
    800053ec:	00f50c23          	sb	a5,24(a0) # c201018 <_entry-0x73dfefe8>
  wakeup(&disk.free[0]);
    800053f0:	00015517          	auipc	a0,0x15
    800053f4:	86850513          	addi	a0,a0,-1944 # 80019c58 <disk+0x18>
    800053f8:	ffffc097          	auipc	ra,0xffffc
    800053fc:	300080e7          	jalr	768(ra) # 800016f8 <wakeup>
}
    80005400:	60a2                	ld	ra,8(sp)
    80005402:	6402                	ld	s0,0(sp)
    80005404:	0141                	addi	sp,sp,16
    80005406:	8082                	ret
    panic("free_desc 1");
    80005408:	00003517          	auipc	a0,0x3
    8000540c:	32850513          	addi	a0,a0,808 # 80008730 <syscalls+0x340>
    80005410:	00001097          	auipc	ra,0x1
    80005414:	a72080e7          	jalr	-1422(ra) # 80005e82 <panic>
    panic("free_desc 2");
    80005418:	00003517          	auipc	a0,0x3
    8000541c:	32850513          	addi	a0,a0,808 # 80008740 <syscalls+0x350>
    80005420:	00001097          	auipc	ra,0x1
    80005424:	a62080e7          	jalr	-1438(ra) # 80005e82 <panic>

0000000080005428 <virtio_disk_init>:
{
    80005428:	1101                	addi	sp,sp,-32
    8000542a:	ec06                	sd	ra,24(sp)
    8000542c:	e822                	sd	s0,16(sp)
    8000542e:	e426                	sd	s1,8(sp)
    80005430:	e04a                	sd	s2,0(sp)
    80005432:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005434:	00003597          	auipc	a1,0x3
    80005438:	31c58593          	addi	a1,a1,796 # 80008750 <syscalls+0x360>
    8000543c:	00015517          	auipc	a0,0x15
    80005440:	92c50513          	addi	a0,a0,-1748 # 80019d68 <disk+0x128>
    80005444:	00001097          	auipc	ra,0x1
    80005448:	ef8080e7          	jalr	-264(ra) # 8000633c <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000544c:	100017b7          	lui	a5,0x10001
    80005450:	4398                	lw	a4,0(a5)
    80005452:	2701                	sext.w	a4,a4
    80005454:	747277b7          	lui	a5,0x74727
    80005458:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    8000545c:	14f71e63          	bne	a4,a5,800055b8 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005460:	100017b7          	lui	a5,0x10001
    80005464:	43dc                	lw	a5,4(a5)
    80005466:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005468:	4709                	li	a4,2
    8000546a:	14e79763          	bne	a5,a4,800055b8 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000546e:	100017b7          	lui	a5,0x10001
    80005472:	479c                	lw	a5,8(a5)
    80005474:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005476:	14e79163          	bne	a5,a4,800055b8 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000547a:	100017b7          	lui	a5,0x10001
    8000547e:	47d8                	lw	a4,12(a5)
    80005480:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005482:	554d47b7          	lui	a5,0x554d4
    80005486:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000548a:	12f71763          	bne	a4,a5,800055b8 <virtio_disk_init+0x190>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000548e:	100017b7          	lui	a5,0x10001
    80005492:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005496:	4705                	li	a4,1
    80005498:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000549a:	470d                	li	a4,3
    8000549c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000549e:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800054a0:	c7ffe737          	lui	a4,0xc7ffe
    800054a4:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdc79f>
    800054a8:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800054aa:	2701                	sext.w	a4,a4
    800054ac:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800054ae:	472d                	li	a4,11
    800054b0:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    800054b2:	0707a903          	lw	s2,112(a5)
    800054b6:	2901                	sext.w	s2,s2
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800054b8:	00897793          	andi	a5,s2,8
    800054bc:	10078663          	beqz	a5,800055c8 <virtio_disk_init+0x1a0>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800054c0:	100017b7          	lui	a5,0x10001
    800054c4:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    800054c8:	43fc                	lw	a5,68(a5)
    800054ca:	2781                	sext.w	a5,a5
    800054cc:	10079663          	bnez	a5,800055d8 <virtio_disk_init+0x1b0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800054d0:	100017b7          	lui	a5,0x10001
    800054d4:	5bdc                	lw	a5,52(a5)
    800054d6:	2781                	sext.w	a5,a5
  if(max == 0)
    800054d8:	10078863          	beqz	a5,800055e8 <virtio_disk_init+0x1c0>
  if(max < NUM)
    800054dc:	471d                	li	a4,7
    800054de:	10f77d63          	bgeu	a4,a5,800055f8 <virtio_disk_init+0x1d0>
  disk.desc = kalloc();
    800054e2:	ffffb097          	auipc	ra,0xffffb
    800054e6:	c36080e7          	jalr	-970(ra) # 80000118 <kalloc>
    800054ea:	00014497          	auipc	s1,0x14
    800054ee:	75648493          	addi	s1,s1,1878 # 80019c40 <disk>
    800054f2:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    800054f4:	ffffb097          	auipc	ra,0xffffb
    800054f8:	c24080e7          	jalr	-988(ra) # 80000118 <kalloc>
    800054fc:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800054fe:	ffffb097          	auipc	ra,0xffffb
    80005502:	c1a080e7          	jalr	-998(ra) # 80000118 <kalloc>
    80005506:	87aa                	mv	a5,a0
    80005508:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    8000550a:	6088                	ld	a0,0(s1)
    8000550c:	cd75                	beqz	a0,80005608 <virtio_disk_init+0x1e0>
    8000550e:	00014717          	auipc	a4,0x14
    80005512:	73a73703          	ld	a4,1850(a4) # 80019c48 <disk+0x8>
    80005516:	cb6d                	beqz	a4,80005608 <virtio_disk_init+0x1e0>
    80005518:	cbe5                	beqz	a5,80005608 <virtio_disk_init+0x1e0>
  memset(disk.desc, 0, PGSIZE);
    8000551a:	6605                	lui	a2,0x1
    8000551c:	4581                	li	a1,0
    8000551e:	ffffb097          	auipc	ra,0xffffb
    80005522:	c5a080e7          	jalr	-934(ra) # 80000178 <memset>
  memset(disk.avail, 0, PGSIZE);
    80005526:	00014497          	auipc	s1,0x14
    8000552a:	71a48493          	addi	s1,s1,1818 # 80019c40 <disk>
    8000552e:	6605                	lui	a2,0x1
    80005530:	4581                	li	a1,0
    80005532:	6488                	ld	a0,8(s1)
    80005534:	ffffb097          	auipc	ra,0xffffb
    80005538:	c44080e7          	jalr	-956(ra) # 80000178 <memset>
  memset(disk.used, 0, PGSIZE);
    8000553c:	6605                	lui	a2,0x1
    8000553e:	4581                	li	a1,0
    80005540:	6888                	ld	a0,16(s1)
    80005542:	ffffb097          	auipc	ra,0xffffb
    80005546:	c36080e7          	jalr	-970(ra) # 80000178 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000554a:	100017b7          	lui	a5,0x10001
    8000554e:	4721                	li	a4,8
    80005550:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005552:	4098                	lw	a4,0(s1)
    80005554:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005558:	40d8                	lw	a4,4(s1)
    8000555a:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000555e:	6498                	ld	a4,8(s1)
    80005560:	0007069b          	sext.w	a3,a4
    80005564:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005568:	9701                	srai	a4,a4,0x20
    8000556a:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    8000556e:	6898                	ld	a4,16(s1)
    80005570:	0007069b          	sext.w	a3,a4
    80005574:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80005578:	9701                	srai	a4,a4,0x20
    8000557a:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    8000557e:	4685                	li	a3,1
    80005580:	c3f4                	sw	a3,68(a5)
    disk.free[i] = 1;
    80005582:	4705                	li	a4,1
    80005584:	00d48c23          	sb	a3,24(s1)
    80005588:	00e48ca3          	sb	a4,25(s1)
    8000558c:	00e48d23          	sb	a4,26(s1)
    80005590:	00e48da3          	sb	a4,27(s1)
    80005594:	00e48e23          	sb	a4,28(s1)
    80005598:	00e48ea3          	sb	a4,29(s1)
    8000559c:	00e48f23          	sb	a4,30(s1)
    800055a0:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800055a4:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800055a8:	0727a823          	sw	s2,112(a5)
}
    800055ac:	60e2                	ld	ra,24(sp)
    800055ae:	6442                	ld	s0,16(sp)
    800055b0:	64a2                	ld	s1,8(sp)
    800055b2:	6902                	ld	s2,0(sp)
    800055b4:	6105                	addi	sp,sp,32
    800055b6:	8082                	ret
    panic("could not find virtio disk");
    800055b8:	00003517          	auipc	a0,0x3
    800055bc:	1a850513          	addi	a0,a0,424 # 80008760 <syscalls+0x370>
    800055c0:	00001097          	auipc	ra,0x1
    800055c4:	8c2080e7          	jalr	-1854(ra) # 80005e82 <panic>
    panic("virtio disk FEATURES_OK unset");
    800055c8:	00003517          	auipc	a0,0x3
    800055cc:	1b850513          	addi	a0,a0,440 # 80008780 <syscalls+0x390>
    800055d0:	00001097          	auipc	ra,0x1
    800055d4:	8b2080e7          	jalr	-1870(ra) # 80005e82 <panic>
    panic("virtio disk should not be ready");
    800055d8:	00003517          	auipc	a0,0x3
    800055dc:	1c850513          	addi	a0,a0,456 # 800087a0 <syscalls+0x3b0>
    800055e0:	00001097          	auipc	ra,0x1
    800055e4:	8a2080e7          	jalr	-1886(ra) # 80005e82 <panic>
    panic("virtio disk has no queue 0");
    800055e8:	00003517          	auipc	a0,0x3
    800055ec:	1d850513          	addi	a0,a0,472 # 800087c0 <syscalls+0x3d0>
    800055f0:	00001097          	auipc	ra,0x1
    800055f4:	892080e7          	jalr	-1902(ra) # 80005e82 <panic>
    panic("virtio disk max queue too short");
    800055f8:	00003517          	auipc	a0,0x3
    800055fc:	1e850513          	addi	a0,a0,488 # 800087e0 <syscalls+0x3f0>
    80005600:	00001097          	auipc	ra,0x1
    80005604:	882080e7          	jalr	-1918(ra) # 80005e82 <panic>
    panic("virtio disk kalloc");
    80005608:	00003517          	auipc	a0,0x3
    8000560c:	1f850513          	addi	a0,a0,504 # 80008800 <syscalls+0x410>
    80005610:	00001097          	auipc	ra,0x1
    80005614:	872080e7          	jalr	-1934(ra) # 80005e82 <panic>

0000000080005618 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005618:	7159                	addi	sp,sp,-112
    8000561a:	f486                	sd	ra,104(sp)
    8000561c:	f0a2                	sd	s0,96(sp)
    8000561e:	eca6                	sd	s1,88(sp)
    80005620:	e8ca                	sd	s2,80(sp)
    80005622:	e4ce                	sd	s3,72(sp)
    80005624:	e0d2                	sd	s4,64(sp)
    80005626:	fc56                	sd	s5,56(sp)
    80005628:	f85a                	sd	s6,48(sp)
    8000562a:	f45e                	sd	s7,40(sp)
    8000562c:	f062                	sd	s8,32(sp)
    8000562e:	ec66                	sd	s9,24(sp)
    80005630:	e86a                	sd	s10,16(sp)
    80005632:	1880                	addi	s0,sp,112
    80005634:	892a                	mv	s2,a0
    80005636:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005638:	00c52c83          	lw	s9,12(a0)
    8000563c:	001c9c9b          	slliw	s9,s9,0x1
    80005640:	1c82                	slli	s9,s9,0x20
    80005642:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005646:	00014517          	auipc	a0,0x14
    8000564a:	72250513          	addi	a0,a0,1826 # 80019d68 <disk+0x128>
    8000564e:	00001097          	auipc	ra,0x1
    80005652:	d7e080e7          	jalr	-642(ra) # 800063cc <acquire>
  for(int i = 0; i < 3; i++){
    80005656:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005658:	4ba1                	li	s7,8
      disk.free[i] = 0;
    8000565a:	00014b17          	auipc	s6,0x14
    8000565e:	5e6b0b13          	addi	s6,s6,1510 # 80019c40 <disk>
  for(int i = 0; i < 3; i++){
    80005662:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    80005664:	8a4e                	mv	s4,s3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005666:	00014c17          	auipc	s8,0x14
    8000566a:	702c0c13          	addi	s8,s8,1794 # 80019d68 <disk+0x128>
    8000566e:	a8b5                	j	800056ea <virtio_disk_rw+0xd2>
      disk.free[i] = 0;
    80005670:	00fb06b3          	add	a3,s6,a5
    80005674:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    80005678:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    8000567a:	0207c563          	bltz	a5,800056a4 <virtio_disk_rw+0x8c>
  for(int i = 0; i < 3; i++){
    8000567e:	2485                	addiw	s1,s1,1
    80005680:	0711                	addi	a4,a4,4
    80005682:	1f548a63          	beq	s1,s5,80005876 <virtio_disk_rw+0x25e>
    idx[i] = alloc_desc();
    80005686:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    80005688:	00014697          	auipc	a3,0x14
    8000568c:	5b868693          	addi	a3,a3,1464 # 80019c40 <disk>
    80005690:	87d2                	mv	a5,s4
    if(disk.free[i]){
    80005692:	0186c583          	lbu	a1,24(a3)
    80005696:	fde9                	bnez	a1,80005670 <virtio_disk_rw+0x58>
  for(int i = 0; i < NUM; i++){
    80005698:	2785                	addiw	a5,a5,1
    8000569a:	0685                	addi	a3,a3,1
    8000569c:	ff779be3          	bne	a5,s7,80005692 <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    800056a0:	57fd                	li	a5,-1
    800056a2:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    800056a4:	02905a63          	blez	s1,800056d8 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    800056a8:	f9042503          	lw	a0,-112(s0)
    800056ac:	00000097          	auipc	ra,0x0
    800056b0:	cfa080e7          	jalr	-774(ra) # 800053a6 <free_desc>
      for(int j = 0; j < i; j++)
    800056b4:	4785                	li	a5,1
    800056b6:	0297d163          	bge	a5,s1,800056d8 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    800056ba:	f9442503          	lw	a0,-108(s0)
    800056be:	00000097          	auipc	ra,0x0
    800056c2:	ce8080e7          	jalr	-792(ra) # 800053a6 <free_desc>
      for(int j = 0; j < i; j++)
    800056c6:	4789                	li	a5,2
    800056c8:	0097d863          	bge	a5,s1,800056d8 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    800056cc:	f9842503          	lw	a0,-104(s0)
    800056d0:	00000097          	auipc	ra,0x0
    800056d4:	cd6080e7          	jalr	-810(ra) # 800053a6 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    800056d8:	85e2                	mv	a1,s8
    800056da:	00014517          	auipc	a0,0x14
    800056de:	57e50513          	addi	a0,a0,1406 # 80019c58 <disk+0x18>
    800056e2:	ffffc097          	auipc	ra,0xffffc
    800056e6:	fb2080e7          	jalr	-78(ra) # 80001694 <sleep>
  for(int i = 0; i < 3; i++){
    800056ea:	f9040713          	addi	a4,s0,-112
    800056ee:	84ce                	mv	s1,s3
    800056f0:	bf59                	j	80005686 <virtio_disk_rw+0x6e>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    800056f2:	00a60793          	addi	a5,a2,10 # 100a <_entry-0x7fffeff6>
    800056f6:	00479693          	slli	a3,a5,0x4
    800056fa:	00014797          	auipc	a5,0x14
    800056fe:	54678793          	addi	a5,a5,1350 # 80019c40 <disk>
    80005702:	97b6                	add	a5,a5,a3
    80005704:	4685                	li	a3,1
    80005706:	c794                	sw	a3,8(a5)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005708:	00014597          	auipc	a1,0x14
    8000570c:	53858593          	addi	a1,a1,1336 # 80019c40 <disk>
    80005710:	00a60793          	addi	a5,a2,10
    80005714:	0792                	slli	a5,a5,0x4
    80005716:	97ae                	add	a5,a5,a1
    80005718:	0007a623          	sw	zero,12(a5)
  buf0->sector = sector;
    8000571c:	0197b823          	sd	s9,16(a5)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005720:	f6070693          	addi	a3,a4,-160
    80005724:	619c                	ld	a5,0(a1)
    80005726:	97b6                	add	a5,a5,a3
    80005728:	e388                	sd	a0,0(a5)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000572a:	6188                	ld	a0,0(a1)
    8000572c:	96aa                	add	a3,a3,a0
    8000572e:	47c1                	li	a5,16
    80005730:	c69c                	sw	a5,8(a3)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005732:	4785                	li	a5,1
    80005734:	00f69623          	sh	a5,12(a3)
  disk.desc[idx[0]].next = idx[1];
    80005738:	f9442783          	lw	a5,-108(s0)
    8000573c:	00f69723          	sh	a5,14(a3)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005740:	0792                	slli	a5,a5,0x4
    80005742:	953e                	add	a0,a0,a5
    80005744:	05890693          	addi	a3,s2,88
    80005748:	e114                	sd	a3,0(a0)
  disk.desc[idx[1]].len = BSIZE;
    8000574a:	6188                	ld	a0,0(a1)
    8000574c:	97aa                	add	a5,a5,a0
    8000574e:	40000693          	li	a3,1024
    80005752:	c794                	sw	a3,8(a5)
  if(write)
    80005754:	100d0d63          	beqz	s10,8000586e <virtio_disk_rw+0x256>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80005758:	00079623          	sh	zero,12(a5)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000575c:	00c7d683          	lhu	a3,12(a5)
    80005760:	0016e693          	ori	a3,a3,1
    80005764:	00d79623          	sh	a3,12(a5)
  disk.desc[idx[1]].next = idx[2];
    80005768:	f9842583          	lw	a1,-104(s0)
    8000576c:	00b79723          	sh	a1,14(a5)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005770:	00014697          	auipc	a3,0x14
    80005774:	4d068693          	addi	a3,a3,1232 # 80019c40 <disk>
    80005778:	00260793          	addi	a5,a2,2
    8000577c:	0792                	slli	a5,a5,0x4
    8000577e:	97b6                	add	a5,a5,a3
    80005780:	587d                	li	a6,-1
    80005782:	01078823          	sb	a6,16(a5)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005786:	0592                	slli	a1,a1,0x4
    80005788:	952e                	add	a0,a0,a1
    8000578a:	f9070713          	addi	a4,a4,-112
    8000578e:	9736                	add	a4,a4,a3
    80005790:	e118                	sd	a4,0(a0)
  disk.desc[idx[2]].len = 1;
    80005792:	6298                	ld	a4,0(a3)
    80005794:	972e                	add	a4,a4,a1
    80005796:	4585                	li	a1,1
    80005798:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000579a:	4509                	li	a0,2
    8000579c:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[2]].next = 0;
    800057a0:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800057a4:	00b92223          	sw	a1,4(s2)
  disk.info[idx[0]].b = b;
    800057a8:	0127b423          	sd	s2,8(a5)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800057ac:	6698                	ld	a4,8(a3)
    800057ae:	00275783          	lhu	a5,2(a4)
    800057b2:	8b9d                	andi	a5,a5,7
    800057b4:	0786                	slli	a5,a5,0x1
    800057b6:	97ba                	add	a5,a5,a4
    800057b8:	00c79223          	sh	a2,4(a5)

  __sync_synchronize();
    800057bc:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800057c0:	6698                	ld	a4,8(a3)
    800057c2:	00275783          	lhu	a5,2(a4)
    800057c6:	2785                	addiw	a5,a5,1
    800057c8:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800057cc:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800057d0:	100017b7          	lui	a5,0x10001
    800057d4:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800057d8:	00492703          	lw	a4,4(s2)
    800057dc:	4785                	li	a5,1
    800057de:	02f71163          	bne	a4,a5,80005800 <virtio_disk_rw+0x1e8>
    sleep(b, &disk.vdisk_lock);
    800057e2:	00014997          	auipc	s3,0x14
    800057e6:	58698993          	addi	s3,s3,1414 # 80019d68 <disk+0x128>
  while(b->disk == 1) {
    800057ea:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800057ec:	85ce                	mv	a1,s3
    800057ee:	854a                	mv	a0,s2
    800057f0:	ffffc097          	auipc	ra,0xffffc
    800057f4:	ea4080e7          	jalr	-348(ra) # 80001694 <sleep>
  while(b->disk == 1) {
    800057f8:	00492783          	lw	a5,4(s2)
    800057fc:	fe9788e3          	beq	a5,s1,800057ec <virtio_disk_rw+0x1d4>
  }

  disk.info[idx[0]].b = 0;
    80005800:	f9042903          	lw	s2,-112(s0)
    80005804:	00290793          	addi	a5,s2,2
    80005808:	00479713          	slli	a4,a5,0x4
    8000580c:	00014797          	auipc	a5,0x14
    80005810:	43478793          	addi	a5,a5,1076 # 80019c40 <disk>
    80005814:	97ba                	add	a5,a5,a4
    80005816:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    8000581a:	00014997          	auipc	s3,0x14
    8000581e:	42698993          	addi	s3,s3,1062 # 80019c40 <disk>
    80005822:	00491713          	slli	a4,s2,0x4
    80005826:	0009b783          	ld	a5,0(s3)
    8000582a:	97ba                	add	a5,a5,a4
    8000582c:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005830:	854a                	mv	a0,s2
    80005832:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005836:	00000097          	auipc	ra,0x0
    8000583a:	b70080e7          	jalr	-1168(ra) # 800053a6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000583e:	8885                	andi	s1,s1,1
    80005840:	f0ed                	bnez	s1,80005822 <virtio_disk_rw+0x20a>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005842:	00014517          	auipc	a0,0x14
    80005846:	52650513          	addi	a0,a0,1318 # 80019d68 <disk+0x128>
    8000584a:	00001097          	auipc	ra,0x1
    8000584e:	c36080e7          	jalr	-970(ra) # 80006480 <release>
}
    80005852:	70a6                	ld	ra,104(sp)
    80005854:	7406                	ld	s0,96(sp)
    80005856:	64e6                	ld	s1,88(sp)
    80005858:	6946                	ld	s2,80(sp)
    8000585a:	69a6                	ld	s3,72(sp)
    8000585c:	6a06                	ld	s4,64(sp)
    8000585e:	7ae2                	ld	s5,56(sp)
    80005860:	7b42                	ld	s6,48(sp)
    80005862:	7ba2                	ld	s7,40(sp)
    80005864:	7c02                	ld	s8,32(sp)
    80005866:	6ce2                	ld	s9,24(sp)
    80005868:	6d42                	ld	s10,16(sp)
    8000586a:	6165                	addi	sp,sp,112
    8000586c:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000586e:	4689                	li	a3,2
    80005870:	00d79623          	sh	a3,12(a5)
    80005874:	b5e5                	j	8000575c <virtio_disk_rw+0x144>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005876:	f9042603          	lw	a2,-112(s0)
    8000587a:	00a60713          	addi	a4,a2,10
    8000587e:	0712                	slli	a4,a4,0x4
    80005880:	00014517          	auipc	a0,0x14
    80005884:	3c850513          	addi	a0,a0,968 # 80019c48 <disk+0x8>
    80005888:	953a                	add	a0,a0,a4
  if(write)
    8000588a:	e60d14e3          	bnez	s10,800056f2 <virtio_disk_rw+0xda>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    8000588e:	00a60793          	addi	a5,a2,10
    80005892:	00479693          	slli	a3,a5,0x4
    80005896:	00014797          	auipc	a5,0x14
    8000589a:	3aa78793          	addi	a5,a5,938 # 80019c40 <disk>
    8000589e:	97b6                	add	a5,a5,a3
    800058a0:	0007a423          	sw	zero,8(a5)
    800058a4:	b595                	j	80005708 <virtio_disk_rw+0xf0>

00000000800058a6 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800058a6:	1101                	addi	sp,sp,-32
    800058a8:	ec06                	sd	ra,24(sp)
    800058aa:	e822                	sd	s0,16(sp)
    800058ac:	e426                	sd	s1,8(sp)
    800058ae:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800058b0:	00014497          	auipc	s1,0x14
    800058b4:	39048493          	addi	s1,s1,912 # 80019c40 <disk>
    800058b8:	00014517          	auipc	a0,0x14
    800058bc:	4b050513          	addi	a0,a0,1200 # 80019d68 <disk+0x128>
    800058c0:	00001097          	auipc	ra,0x1
    800058c4:	b0c080e7          	jalr	-1268(ra) # 800063cc <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800058c8:	10001737          	lui	a4,0x10001
    800058cc:	533c                	lw	a5,96(a4)
    800058ce:	8b8d                	andi	a5,a5,3
    800058d0:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800058d2:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800058d6:	689c                	ld	a5,16(s1)
    800058d8:	0204d703          	lhu	a4,32(s1)
    800058dc:	0027d783          	lhu	a5,2(a5)
    800058e0:	04f70863          	beq	a4,a5,80005930 <virtio_disk_intr+0x8a>
    __sync_synchronize();
    800058e4:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800058e8:	6898                	ld	a4,16(s1)
    800058ea:	0204d783          	lhu	a5,32(s1)
    800058ee:	8b9d                	andi	a5,a5,7
    800058f0:	078e                	slli	a5,a5,0x3
    800058f2:	97ba                	add	a5,a5,a4
    800058f4:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800058f6:	00278713          	addi	a4,a5,2
    800058fa:	0712                	slli	a4,a4,0x4
    800058fc:	9726                	add	a4,a4,s1
    800058fe:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80005902:	e721                	bnez	a4,8000594a <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005904:	0789                	addi	a5,a5,2
    80005906:	0792                	slli	a5,a5,0x4
    80005908:	97a6                	add	a5,a5,s1
    8000590a:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    8000590c:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005910:	ffffc097          	auipc	ra,0xffffc
    80005914:	de8080e7          	jalr	-536(ra) # 800016f8 <wakeup>

    disk.used_idx += 1;
    80005918:	0204d783          	lhu	a5,32(s1)
    8000591c:	2785                	addiw	a5,a5,1
    8000591e:	17c2                	slli	a5,a5,0x30
    80005920:	93c1                	srli	a5,a5,0x30
    80005922:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005926:	6898                	ld	a4,16(s1)
    80005928:	00275703          	lhu	a4,2(a4)
    8000592c:	faf71ce3          	bne	a4,a5,800058e4 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005930:	00014517          	auipc	a0,0x14
    80005934:	43850513          	addi	a0,a0,1080 # 80019d68 <disk+0x128>
    80005938:	00001097          	auipc	ra,0x1
    8000593c:	b48080e7          	jalr	-1208(ra) # 80006480 <release>
}
    80005940:	60e2                	ld	ra,24(sp)
    80005942:	6442                	ld	s0,16(sp)
    80005944:	64a2                	ld	s1,8(sp)
    80005946:	6105                	addi	sp,sp,32
    80005948:	8082                	ret
      panic("virtio_disk_intr status");
    8000594a:	00003517          	auipc	a0,0x3
    8000594e:	ece50513          	addi	a0,a0,-306 # 80008818 <syscalls+0x428>
    80005952:	00000097          	auipc	ra,0x0
    80005956:	530080e7          	jalr	1328(ra) # 80005e82 <panic>

000000008000595a <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000595a:	1141                	addi	sp,sp,-16
    8000595c:	e422                	sd	s0,8(sp)
    8000595e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005960:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005964:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005968:	0037979b          	slliw	a5,a5,0x3
    8000596c:	02004737          	lui	a4,0x2004
    80005970:	97ba                	add	a5,a5,a4
    80005972:	0200c737          	lui	a4,0x200c
    80005976:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    8000597a:	000f4637          	lui	a2,0xf4
    8000597e:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005982:	95b2                	add	a1,a1,a2
    80005984:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005986:	00269713          	slli	a4,a3,0x2
    8000598a:	9736                	add	a4,a4,a3
    8000598c:	00371693          	slli	a3,a4,0x3
    80005990:	00014717          	auipc	a4,0x14
    80005994:	3f070713          	addi	a4,a4,1008 # 80019d80 <timer_scratch>
    80005998:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    8000599a:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000599c:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000599e:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    800059a2:	00000797          	auipc	a5,0x0
    800059a6:	93e78793          	addi	a5,a5,-1730 # 800052e0 <timervec>
    800059aa:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800059ae:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    800059b2:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800059b6:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    800059ba:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    800059be:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    800059c2:	30479073          	csrw	mie,a5
}
    800059c6:	6422                	ld	s0,8(sp)
    800059c8:	0141                	addi	sp,sp,16
    800059ca:	8082                	ret

00000000800059cc <start>:
{
    800059cc:	1141                	addi	sp,sp,-16
    800059ce:	e406                	sd	ra,8(sp)
    800059d0:	e022                	sd	s0,0(sp)
    800059d2:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800059d4:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800059d8:	7779                	lui	a4,0xffffe
    800059da:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdc83f>
    800059de:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800059e0:	6705                	lui	a4,0x1
    800059e2:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800059e6:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800059e8:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800059ec:	ffffb797          	auipc	a5,0xffffb
    800059f0:	93a78793          	addi	a5,a5,-1734 # 80000326 <main>
    800059f4:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800059f8:	4781                	li	a5,0
    800059fa:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800059fe:	67c1                	lui	a5,0x10
    80005a00:	17fd                	addi	a5,a5,-1
    80005a02:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005a06:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005a0a:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005a0e:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005a12:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005a16:	57fd                	li	a5,-1
    80005a18:	83a9                	srli	a5,a5,0xa
    80005a1a:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005a1e:	47bd                	li	a5,15
    80005a20:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005a24:	00000097          	auipc	ra,0x0
    80005a28:	f36080e7          	jalr	-202(ra) # 8000595a <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005a2c:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005a30:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005a32:	823e                	mv	tp,a5
  asm volatile("mret");
    80005a34:	30200073          	mret
}
    80005a38:	60a2                	ld	ra,8(sp)
    80005a3a:	6402                	ld	s0,0(sp)
    80005a3c:	0141                	addi	sp,sp,16
    80005a3e:	8082                	ret

0000000080005a40 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005a40:	715d                	addi	sp,sp,-80
    80005a42:	e486                	sd	ra,72(sp)
    80005a44:	e0a2                	sd	s0,64(sp)
    80005a46:	fc26                	sd	s1,56(sp)
    80005a48:	f84a                	sd	s2,48(sp)
    80005a4a:	f44e                	sd	s3,40(sp)
    80005a4c:	f052                	sd	s4,32(sp)
    80005a4e:	ec56                	sd	s5,24(sp)
    80005a50:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005a52:	04c05663          	blez	a2,80005a9e <consolewrite+0x5e>
    80005a56:	8a2a                	mv	s4,a0
    80005a58:	84ae                	mv	s1,a1
    80005a5a:	89b2                	mv	s3,a2
    80005a5c:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005a5e:	5afd                	li	s5,-1
    80005a60:	4685                	li	a3,1
    80005a62:	8626                	mv	a2,s1
    80005a64:	85d2                	mv	a1,s4
    80005a66:	fbf40513          	addi	a0,s0,-65
    80005a6a:	ffffc097          	auipc	ra,0xffffc
    80005a6e:	088080e7          	jalr	136(ra) # 80001af2 <either_copyin>
    80005a72:	01550c63          	beq	a0,s5,80005a8a <consolewrite+0x4a>
      break;
    uartputc(c);
    80005a76:	fbf44503          	lbu	a0,-65(s0)
    80005a7a:	00000097          	auipc	ra,0x0
    80005a7e:	794080e7          	jalr	1940(ra) # 8000620e <uartputc>
  for(i = 0; i < n; i++){
    80005a82:	2905                	addiw	s2,s2,1
    80005a84:	0485                	addi	s1,s1,1
    80005a86:	fd299de3          	bne	s3,s2,80005a60 <consolewrite+0x20>
  }

  return i;
}
    80005a8a:	854a                	mv	a0,s2
    80005a8c:	60a6                	ld	ra,72(sp)
    80005a8e:	6406                	ld	s0,64(sp)
    80005a90:	74e2                	ld	s1,56(sp)
    80005a92:	7942                	ld	s2,48(sp)
    80005a94:	79a2                	ld	s3,40(sp)
    80005a96:	7a02                	ld	s4,32(sp)
    80005a98:	6ae2                	ld	s5,24(sp)
    80005a9a:	6161                	addi	sp,sp,80
    80005a9c:	8082                	ret
  for(i = 0; i < n; i++){
    80005a9e:	4901                	li	s2,0
    80005aa0:	b7ed                	j	80005a8a <consolewrite+0x4a>

0000000080005aa2 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005aa2:	7119                	addi	sp,sp,-128
    80005aa4:	fc86                	sd	ra,120(sp)
    80005aa6:	f8a2                	sd	s0,112(sp)
    80005aa8:	f4a6                	sd	s1,104(sp)
    80005aaa:	f0ca                	sd	s2,96(sp)
    80005aac:	ecce                	sd	s3,88(sp)
    80005aae:	e8d2                	sd	s4,80(sp)
    80005ab0:	e4d6                	sd	s5,72(sp)
    80005ab2:	e0da                	sd	s6,64(sp)
    80005ab4:	fc5e                	sd	s7,56(sp)
    80005ab6:	f862                	sd	s8,48(sp)
    80005ab8:	f466                	sd	s9,40(sp)
    80005aba:	f06a                	sd	s10,32(sp)
    80005abc:	ec6e                	sd	s11,24(sp)
    80005abe:	0100                	addi	s0,sp,128
    80005ac0:	8b2a                	mv	s6,a0
    80005ac2:	8aae                	mv	s5,a1
    80005ac4:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005ac6:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    80005aca:	0001c517          	auipc	a0,0x1c
    80005ace:	3f650513          	addi	a0,a0,1014 # 80021ec0 <cons>
    80005ad2:	00001097          	auipc	ra,0x1
    80005ad6:	8fa080e7          	jalr	-1798(ra) # 800063cc <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005ada:	0001c497          	auipc	s1,0x1c
    80005ade:	3e648493          	addi	s1,s1,998 # 80021ec0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005ae2:	89a6                	mv	s3,s1
    80005ae4:	0001c917          	auipc	s2,0x1c
    80005ae8:	47490913          	addi	s2,s2,1140 # 80021f58 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    80005aec:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005aee:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005af0:	4da9                	li	s11,10
  while(n > 0){
    80005af2:	07405b63          	blez	s4,80005b68 <consoleread+0xc6>
    while(cons.r == cons.w){
    80005af6:	0984a783          	lw	a5,152(s1)
    80005afa:	09c4a703          	lw	a4,156(s1)
    80005afe:	02f71763          	bne	a4,a5,80005b2c <consoleread+0x8a>
      if(killed(myproc())){
    80005b02:	ffffb097          	auipc	ra,0xffffb
    80005b06:	432080e7          	jalr	1074(ra) # 80000f34 <myproc>
    80005b0a:	ffffc097          	auipc	ra,0xffffc
    80005b0e:	e32080e7          	jalr	-462(ra) # 8000193c <killed>
    80005b12:	e535                	bnez	a0,80005b7e <consoleread+0xdc>
      sleep(&cons.r, &cons.lock);
    80005b14:	85ce                	mv	a1,s3
    80005b16:	854a                	mv	a0,s2
    80005b18:	ffffc097          	auipc	ra,0xffffc
    80005b1c:	b7c080e7          	jalr	-1156(ra) # 80001694 <sleep>
    while(cons.r == cons.w){
    80005b20:	0984a783          	lw	a5,152(s1)
    80005b24:	09c4a703          	lw	a4,156(s1)
    80005b28:	fcf70de3          	beq	a4,a5,80005b02 <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005b2c:	0017871b          	addiw	a4,a5,1
    80005b30:	08e4ac23          	sw	a4,152(s1)
    80005b34:	07f7f713          	andi	a4,a5,127
    80005b38:	9726                	add	a4,a4,s1
    80005b3a:	01874703          	lbu	a4,24(a4)
    80005b3e:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80005b42:	079c0663          	beq	s8,s9,80005bae <consoleread+0x10c>
    cbuf = c;
    80005b46:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005b4a:	4685                	li	a3,1
    80005b4c:	f8f40613          	addi	a2,s0,-113
    80005b50:	85d6                	mv	a1,s5
    80005b52:	855a                	mv	a0,s6
    80005b54:	ffffc097          	auipc	ra,0xffffc
    80005b58:	f48080e7          	jalr	-184(ra) # 80001a9c <either_copyout>
    80005b5c:	01a50663          	beq	a0,s10,80005b68 <consoleread+0xc6>
    dst++;
    80005b60:	0a85                	addi	s5,s5,1
    --n;
    80005b62:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    80005b64:	f9bc17e3          	bne	s8,s11,80005af2 <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005b68:	0001c517          	auipc	a0,0x1c
    80005b6c:	35850513          	addi	a0,a0,856 # 80021ec0 <cons>
    80005b70:	00001097          	auipc	ra,0x1
    80005b74:	910080e7          	jalr	-1776(ra) # 80006480 <release>

  return target - n;
    80005b78:	414b853b          	subw	a0,s7,s4
    80005b7c:	a811                	j	80005b90 <consoleread+0xee>
        release(&cons.lock);
    80005b7e:	0001c517          	auipc	a0,0x1c
    80005b82:	34250513          	addi	a0,a0,834 # 80021ec0 <cons>
    80005b86:	00001097          	auipc	ra,0x1
    80005b8a:	8fa080e7          	jalr	-1798(ra) # 80006480 <release>
        return -1;
    80005b8e:	557d                	li	a0,-1
}
    80005b90:	70e6                	ld	ra,120(sp)
    80005b92:	7446                	ld	s0,112(sp)
    80005b94:	74a6                	ld	s1,104(sp)
    80005b96:	7906                	ld	s2,96(sp)
    80005b98:	69e6                	ld	s3,88(sp)
    80005b9a:	6a46                	ld	s4,80(sp)
    80005b9c:	6aa6                	ld	s5,72(sp)
    80005b9e:	6b06                	ld	s6,64(sp)
    80005ba0:	7be2                	ld	s7,56(sp)
    80005ba2:	7c42                	ld	s8,48(sp)
    80005ba4:	7ca2                	ld	s9,40(sp)
    80005ba6:	7d02                	ld	s10,32(sp)
    80005ba8:	6de2                	ld	s11,24(sp)
    80005baa:	6109                	addi	sp,sp,128
    80005bac:	8082                	ret
      if(n < target){
    80005bae:	000a071b          	sext.w	a4,s4
    80005bb2:	fb777be3          	bgeu	a4,s7,80005b68 <consoleread+0xc6>
        cons.r--;
    80005bb6:	0001c717          	auipc	a4,0x1c
    80005bba:	3af72123          	sw	a5,930(a4) # 80021f58 <cons+0x98>
    80005bbe:	b76d                	j	80005b68 <consoleread+0xc6>

0000000080005bc0 <consputc>:
{
    80005bc0:	1141                	addi	sp,sp,-16
    80005bc2:	e406                	sd	ra,8(sp)
    80005bc4:	e022                	sd	s0,0(sp)
    80005bc6:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005bc8:	10000793          	li	a5,256
    80005bcc:	00f50a63          	beq	a0,a5,80005be0 <consputc+0x20>
    uartputc_sync(c);
    80005bd0:	00000097          	auipc	ra,0x0
    80005bd4:	564080e7          	jalr	1380(ra) # 80006134 <uartputc_sync>
}
    80005bd8:	60a2                	ld	ra,8(sp)
    80005bda:	6402                	ld	s0,0(sp)
    80005bdc:	0141                	addi	sp,sp,16
    80005bde:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005be0:	4521                	li	a0,8
    80005be2:	00000097          	auipc	ra,0x0
    80005be6:	552080e7          	jalr	1362(ra) # 80006134 <uartputc_sync>
    80005bea:	02000513          	li	a0,32
    80005bee:	00000097          	auipc	ra,0x0
    80005bf2:	546080e7          	jalr	1350(ra) # 80006134 <uartputc_sync>
    80005bf6:	4521                	li	a0,8
    80005bf8:	00000097          	auipc	ra,0x0
    80005bfc:	53c080e7          	jalr	1340(ra) # 80006134 <uartputc_sync>
    80005c00:	bfe1                	j	80005bd8 <consputc+0x18>

0000000080005c02 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005c02:	1101                	addi	sp,sp,-32
    80005c04:	ec06                	sd	ra,24(sp)
    80005c06:	e822                	sd	s0,16(sp)
    80005c08:	e426                	sd	s1,8(sp)
    80005c0a:	e04a                	sd	s2,0(sp)
    80005c0c:	1000                	addi	s0,sp,32
    80005c0e:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005c10:	0001c517          	auipc	a0,0x1c
    80005c14:	2b050513          	addi	a0,a0,688 # 80021ec0 <cons>
    80005c18:	00000097          	auipc	ra,0x0
    80005c1c:	7b4080e7          	jalr	1972(ra) # 800063cc <acquire>

  switch(c){
    80005c20:	47d5                	li	a5,21
    80005c22:	0af48663          	beq	s1,a5,80005cce <consoleintr+0xcc>
    80005c26:	0297ca63          	blt	a5,s1,80005c5a <consoleintr+0x58>
    80005c2a:	47a1                	li	a5,8
    80005c2c:	0ef48763          	beq	s1,a5,80005d1a <consoleintr+0x118>
    80005c30:	47c1                	li	a5,16
    80005c32:	10f49a63          	bne	s1,a5,80005d46 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005c36:	ffffc097          	auipc	ra,0xffffc
    80005c3a:	f12080e7          	jalr	-238(ra) # 80001b48 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005c3e:	0001c517          	auipc	a0,0x1c
    80005c42:	28250513          	addi	a0,a0,642 # 80021ec0 <cons>
    80005c46:	00001097          	auipc	ra,0x1
    80005c4a:	83a080e7          	jalr	-1990(ra) # 80006480 <release>
}
    80005c4e:	60e2                	ld	ra,24(sp)
    80005c50:	6442                	ld	s0,16(sp)
    80005c52:	64a2                	ld	s1,8(sp)
    80005c54:	6902                	ld	s2,0(sp)
    80005c56:	6105                	addi	sp,sp,32
    80005c58:	8082                	ret
  switch(c){
    80005c5a:	07f00793          	li	a5,127
    80005c5e:	0af48e63          	beq	s1,a5,80005d1a <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005c62:	0001c717          	auipc	a4,0x1c
    80005c66:	25e70713          	addi	a4,a4,606 # 80021ec0 <cons>
    80005c6a:	0a072783          	lw	a5,160(a4)
    80005c6e:	09872703          	lw	a4,152(a4)
    80005c72:	9f99                	subw	a5,a5,a4
    80005c74:	07f00713          	li	a4,127
    80005c78:	fcf763e3          	bltu	a4,a5,80005c3e <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005c7c:	47b5                	li	a5,13
    80005c7e:	0cf48763          	beq	s1,a5,80005d4c <consoleintr+0x14a>
      consputc(c);
    80005c82:	8526                	mv	a0,s1
    80005c84:	00000097          	auipc	ra,0x0
    80005c88:	f3c080e7          	jalr	-196(ra) # 80005bc0 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005c8c:	0001c797          	auipc	a5,0x1c
    80005c90:	23478793          	addi	a5,a5,564 # 80021ec0 <cons>
    80005c94:	0a07a683          	lw	a3,160(a5)
    80005c98:	0016871b          	addiw	a4,a3,1
    80005c9c:	0007061b          	sext.w	a2,a4
    80005ca0:	0ae7a023          	sw	a4,160(a5)
    80005ca4:	07f6f693          	andi	a3,a3,127
    80005ca8:	97b6                	add	a5,a5,a3
    80005caa:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005cae:	47a9                	li	a5,10
    80005cb0:	0cf48563          	beq	s1,a5,80005d7a <consoleintr+0x178>
    80005cb4:	4791                	li	a5,4
    80005cb6:	0cf48263          	beq	s1,a5,80005d7a <consoleintr+0x178>
    80005cba:	0001c797          	auipc	a5,0x1c
    80005cbe:	29e7a783          	lw	a5,670(a5) # 80021f58 <cons+0x98>
    80005cc2:	9f1d                	subw	a4,a4,a5
    80005cc4:	08000793          	li	a5,128
    80005cc8:	f6f71be3          	bne	a4,a5,80005c3e <consoleintr+0x3c>
    80005ccc:	a07d                	j	80005d7a <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005cce:	0001c717          	auipc	a4,0x1c
    80005cd2:	1f270713          	addi	a4,a4,498 # 80021ec0 <cons>
    80005cd6:	0a072783          	lw	a5,160(a4)
    80005cda:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005cde:	0001c497          	auipc	s1,0x1c
    80005ce2:	1e248493          	addi	s1,s1,482 # 80021ec0 <cons>
    while(cons.e != cons.w &&
    80005ce6:	4929                	li	s2,10
    80005ce8:	f4f70be3          	beq	a4,a5,80005c3e <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005cec:	37fd                	addiw	a5,a5,-1
    80005cee:	07f7f713          	andi	a4,a5,127
    80005cf2:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005cf4:	01874703          	lbu	a4,24(a4)
    80005cf8:	f52703e3          	beq	a4,s2,80005c3e <consoleintr+0x3c>
      cons.e--;
    80005cfc:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005d00:	10000513          	li	a0,256
    80005d04:	00000097          	auipc	ra,0x0
    80005d08:	ebc080e7          	jalr	-324(ra) # 80005bc0 <consputc>
    while(cons.e != cons.w &&
    80005d0c:	0a04a783          	lw	a5,160(s1)
    80005d10:	09c4a703          	lw	a4,156(s1)
    80005d14:	fcf71ce3          	bne	a4,a5,80005cec <consoleintr+0xea>
    80005d18:	b71d                	j	80005c3e <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005d1a:	0001c717          	auipc	a4,0x1c
    80005d1e:	1a670713          	addi	a4,a4,422 # 80021ec0 <cons>
    80005d22:	0a072783          	lw	a5,160(a4)
    80005d26:	09c72703          	lw	a4,156(a4)
    80005d2a:	f0f70ae3          	beq	a4,a5,80005c3e <consoleintr+0x3c>
      cons.e--;
    80005d2e:	37fd                	addiw	a5,a5,-1
    80005d30:	0001c717          	auipc	a4,0x1c
    80005d34:	22f72823          	sw	a5,560(a4) # 80021f60 <cons+0xa0>
      consputc(BACKSPACE);
    80005d38:	10000513          	li	a0,256
    80005d3c:	00000097          	auipc	ra,0x0
    80005d40:	e84080e7          	jalr	-380(ra) # 80005bc0 <consputc>
    80005d44:	bded                	j	80005c3e <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005d46:	ee048ce3          	beqz	s1,80005c3e <consoleintr+0x3c>
    80005d4a:	bf21                	j	80005c62 <consoleintr+0x60>
      consputc(c);
    80005d4c:	4529                	li	a0,10
    80005d4e:	00000097          	auipc	ra,0x0
    80005d52:	e72080e7          	jalr	-398(ra) # 80005bc0 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005d56:	0001c797          	auipc	a5,0x1c
    80005d5a:	16a78793          	addi	a5,a5,362 # 80021ec0 <cons>
    80005d5e:	0a07a703          	lw	a4,160(a5)
    80005d62:	0017069b          	addiw	a3,a4,1
    80005d66:	0006861b          	sext.w	a2,a3
    80005d6a:	0ad7a023          	sw	a3,160(a5)
    80005d6e:	07f77713          	andi	a4,a4,127
    80005d72:	97ba                	add	a5,a5,a4
    80005d74:	4729                	li	a4,10
    80005d76:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005d7a:	0001c797          	auipc	a5,0x1c
    80005d7e:	1ec7a123          	sw	a2,482(a5) # 80021f5c <cons+0x9c>
        wakeup(&cons.r);
    80005d82:	0001c517          	auipc	a0,0x1c
    80005d86:	1d650513          	addi	a0,a0,470 # 80021f58 <cons+0x98>
    80005d8a:	ffffc097          	auipc	ra,0xffffc
    80005d8e:	96e080e7          	jalr	-1682(ra) # 800016f8 <wakeup>
    80005d92:	b575                	j	80005c3e <consoleintr+0x3c>

0000000080005d94 <consoleinit>:

void
consoleinit(void)
{
    80005d94:	1141                	addi	sp,sp,-16
    80005d96:	e406                	sd	ra,8(sp)
    80005d98:	e022                	sd	s0,0(sp)
    80005d9a:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005d9c:	00003597          	auipc	a1,0x3
    80005da0:	a9458593          	addi	a1,a1,-1388 # 80008830 <syscalls+0x440>
    80005da4:	0001c517          	auipc	a0,0x1c
    80005da8:	11c50513          	addi	a0,a0,284 # 80021ec0 <cons>
    80005dac:	00000097          	auipc	ra,0x0
    80005db0:	590080e7          	jalr	1424(ra) # 8000633c <initlock>

  uartinit();
    80005db4:	00000097          	auipc	ra,0x0
    80005db8:	330080e7          	jalr	816(ra) # 800060e4 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005dbc:	00013797          	auipc	a5,0x13
    80005dc0:	e2c78793          	addi	a5,a5,-468 # 80018be8 <devsw>
    80005dc4:	00000717          	auipc	a4,0x0
    80005dc8:	cde70713          	addi	a4,a4,-802 # 80005aa2 <consoleread>
    80005dcc:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005dce:	00000717          	auipc	a4,0x0
    80005dd2:	c7270713          	addi	a4,a4,-910 # 80005a40 <consolewrite>
    80005dd6:	ef98                	sd	a4,24(a5)
}
    80005dd8:	60a2                	ld	ra,8(sp)
    80005dda:	6402                	ld	s0,0(sp)
    80005ddc:	0141                	addi	sp,sp,16
    80005dde:	8082                	ret

0000000080005de0 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005de0:	7179                	addi	sp,sp,-48
    80005de2:	f406                	sd	ra,40(sp)
    80005de4:	f022                	sd	s0,32(sp)
    80005de6:	ec26                	sd	s1,24(sp)
    80005de8:	e84a                	sd	s2,16(sp)
    80005dea:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005dec:	c219                	beqz	a2,80005df2 <printint+0x12>
    80005dee:	08054663          	bltz	a0,80005e7a <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005df2:	2501                	sext.w	a0,a0
    80005df4:	4881                	li	a7,0
    80005df6:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005dfa:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005dfc:	2581                	sext.w	a1,a1
    80005dfe:	00003617          	auipc	a2,0x3
    80005e02:	a6260613          	addi	a2,a2,-1438 # 80008860 <digits>
    80005e06:	883a                	mv	a6,a4
    80005e08:	2705                	addiw	a4,a4,1
    80005e0a:	02b577bb          	remuw	a5,a0,a1
    80005e0e:	1782                	slli	a5,a5,0x20
    80005e10:	9381                	srli	a5,a5,0x20
    80005e12:	97b2                	add	a5,a5,a2
    80005e14:	0007c783          	lbu	a5,0(a5)
    80005e18:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005e1c:	0005079b          	sext.w	a5,a0
    80005e20:	02b5553b          	divuw	a0,a0,a1
    80005e24:	0685                	addi	a3,a3,1
    80005e26:	feb7f0e3          	bgeu	a5,a1,80005e06 <printint+0x26>

  if(sign)
    80005e2a:	00088b63          	beqz	a7,80005e40 <printint+0x60>
    buf[i++] = '-';
    80005e2e:	fe040793          	addi	a5,s0,-32
    80005e32:	973e                	add	a4,a4,a5
    80005e34:	02d00793          	li	a5,45
    80005e38:	fef70823          	sb	a5,-16(a4)
    80005e3c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005e40:	02e05763          	blez	a4,80005e6e <printint+0x8e>
    80005e44:	fd040793          	addi	a5,s0,-48
    80005e48:	00e784b3          	add	s1,a5,a4
    80005e4c:	fff78913          	addi	s2,a5,-1
    80005e50:	993a                	add	s2,s2,a4
    80005e52:	377d                	addiw	a4,a4,-1
    80005e54:	1702                	slli	a4,a4,0x20
    80005e56:	9301                	srli	a4,a4,0x20
    80005e58:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005e5c:	fff4c503          	lbu	a0,-1(s1)
    80005e60:	00000097          	auipc	ra,0x0
    80005e64:	d60080e7          	jalr	-672(ra) # 80005bc0 <consputc>
  while(--i >= 0)
    80005e68:	14fd                	addi	s1,s1,-1
    80005e6a:	ff2499e3          	bne	s1,s2,80005e5c <printint+0x7c>
}
    80005e6e:	70a2                	ld	ra,40(sp)
    80005e70:	7402                	ld	s0,32(sp)
    80005e72:	64e2                	ld	s1,24(sp)
    80005e74:	6942                	ld	s2,16(sp)
    80005e76:	6145                	addi	sp,sp,48
    80005e78:	8082                	ret
    x = -xx;
    80005e7a:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005e7e:	4885                	li	a7,1
    x = -xx;
    80005e80:	bf9d                	j	80005df6 <printint+0x16>

0000000080005e82 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005e82:	1101                	addi	sp,sp,-32
    80005e84:	ec06                	sd	ra,24(sp)
    80005e86:	e822                	sd	s0,16(sp)
    80005e88:	e426                	sd	s1,8(sp)
    80005e8a:	1000                	addi	s0,sp,32
    80005e8c:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005e8e:	0001c797          	auipc	a5,0x1c
    80005e92:	0e07a923          	sw	zero,242(a5) # 80021f80 <pr+0x18>
  printf("panic: ");
    80005e96:	00003517          	auipc	a0,0x3
    80005e9a:	9a250513          	addi	a0,a0,-1630 # 80008838 <syscalls+0x448>
    80005e9e:	00000097          	auipc	ra,0x0
    80005ea2:	02e080e7          	jalr	46(ra) # 80005ecc <printf>
  printf(s);
    80005ea6:	8526                	mv	a0,s1
    80005ea8:	00000097          	auipc	ra,0x0
    80005eac:	024080e7          	jalr	36(ra) # 80005ecc <printf>
  printf("\n");
    80005eb0:	00002517          	auipc	a0,0x2
    80005eb4:	19850513          	addi	a0,a0,408 # 80008048 <etext+0x48>
    80005eb8:	00000097          	auipc	ra,0x0
    80005ebc:	014080e7          	jalr	20(ra) # 80005ecc <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005ec0:	4785                	li	a5,1
    80005ec2:	00003717          	auipc	a4,0x3
    80005ec6:	a6f72d23          	sw	a5,-1414(a4) # 8000893c <panicked>
  for(;;)
    80005eca:	a001                	j	80005eca <panic+0x48>

0000000080005ecc <printf>:
{
    80005ecc:	7131                	addi	sp,sp,-192
    80005ece:	fc86                	sd	ra,120(sp)
    80005ed0:	f8a2                	sd	s0,112(sp)
    80005ed2:	f4a6                	sd	s1,104(sp)
    80005ed4:	f0ca                	sd	s2,96(sp)
    80005ed6:	ecce                	sd	s3,88(sp)
    80005ed8:	e8d2                	sd	s4,80(sp)
    80005eda:	e4d6                	sd	s5,72(sp)
    80005edc:	e0da                	sd	s6,64(sp)
    80005ede:	fc5e                	sd	s7,56(sp)
    80005ee0:	f862                	sd	s8,48(sp)
    80005ee2:	f466                	sd	s9,40(sp)
    80005ee4:	f06a                	sd	s10,32(sp)
    80005ee6:	ec6e                	sd	s11,24(sp)
    80005ee8:	0100                	addi	s0,sp,128
    80005eea:	8a2a                	mv	s4,a0
    80005eec:	e40c                	sd	a1,8(s0)
    80005eee:	e810                	sd	a2,16(s0)
    80005ef0:	ec14                	sd	a3,24(s0)
    80005ef2:	f018                	sd	a4,32(s0)
    80005ef4:	f41c                	sd	a5,40(s0)
    80005ef6:	03043823          	sd	a6,48(s0)
    80005efa:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005efe:	0001cd97          	auipc	s11,0x1c
    80005f02:	082dad83          	lw	s11,130(s11) # 80021f80 <pr+0x18>
  if(locking)
    80005f06:	020d9b63          	bnez	s11,80005f3c <printf+0x70>
  if (fmt == 0)
    80005f0a:	040a0263          	beqz	s4,80005f4e <printf+0x82>
  va_start(ap, fmt);
    80005f0e:	00840793          	addi	a5,s0,8
    80005f12:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005f16:	000a4503          	lbu	a0,0(s4)
    80005f1a:	16050263          	beqz	a0,8000607e <printf+0x1b2>
    80005f1e:	4481                	li	s1,0
    if(c != '%'){
    80005f20:	02500a93          	li	s5,37
    switch(c){
    80005f24:	07000b13          	li	s6,112
  consputc('x');
    80005f28:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005f2a:	00003b97          	auipc	s7,0x3
    80005f2e:	936b8b93          	addi	s7,s7,-1738 # 80008860 <digits>
    switch(c){
    80005f32:	07300c93          	li	s9,115
    80005f36:	06400c13          	li	s8,100
    80005f3a:	a82d                	j	80005f74 <printf+0xa8>
    acquire(&pr.lock);
    80005f3c:	0001c517          	auipc	a0,0x1c
    80005f40:	02c50513          	addi	a0,a0,44 # 80021f68 <pr>
    80005f44:	00000097          	auipc	ra,0x0
    80005f48:	488080e7          	jalr	1160(ra) # 800063cc <acquire>
    80005f4c:	bf7d                	j	80005f0a <printf+0x3e>
    panic("null fmt");
    80005f4e:	00003517          	auipc	a0,0x3
    80005f52:	8fa50513          	addi	a0,a0,-1798 # 80008848 <syscalls+0x458>
    80005f56:	00000097          	auipc	ra,0x0
    80005f5a:	f2c080e7          	jalr	-212(ra) # 80005e82 <panic>
      consputc(c);
    80005f5e:	00000097          	auipc	ra,0x0
    80005f62:	c62080e7          	jalr	-926(ra) # 80005bc0 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005f66:	2485                	addiw	s1,s1,1
    80005f68:	009a07b3          	add	a5,s4,s1
    80005f6c:	0007c503          	lbu	a0,0(a5)
    80005f70:	10050763          	beqz	a0,8000607e <printf+0x1b2>
    if(c != '%'){
    80005f74:	ff5515e3          	bne	a0,s5,80005f5e <printf+0x92>
    c = fmt[++i] & 0xff;
    80005f78:	2485                	addiw	s1,s1,1
    80005f7a:	009a07b3          	add	a5,s4,s1
    80005f7e:	0007c783          	lbu	a5,0(a5)
    80005f82:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80005f86:	cfe5                	beqz	a5,8000607e <printf+0x1b2>
    switch(c){
    80005f88:	05678a63          	beq	a5,s6,80005fdc <printf+0x110>
    80005f8c:	02fb7663          	bgeu	s6,a5,80005fb8 <printf+0xec>
    80005f90:	09978963          	beq	a5,s9,80006022 <printf+0x156>
    80005f94:	07800713          	li	a4,120
    80005f98:	0ce79863          	bne	a5,a4,80006068 <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80005f9c:	f8843783          	ld	a5,-120(s0)
    80005fa0:	00878713          	addi	a4,a5,8
    80005fa4:	f8e43423          	sd	a4,-120(s0)
    80005fa8:	4605                	li	a2,1
    80005faa:	85ea                	mv	a1,s10
    80005fac:	4388                	lw	a0,0(a5)
    80005fae:	00000097          	auipc	ra,0x0
    80005fb2:	e32080e7          	jalr	-462(ra) # 80005de0 <printint>
      break;
    80005fb6:	bf45                	j	80005f66 <printf+0x9a>
    switch(c){
    80005fb8:	0b578263          	beq	a5,s5,8000605c <printf+0x190>
    80005fbc:	0b879663          	bne	a5,s8,80006068 <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80005fc0:	f8843783          	ld	a5,-120(s0)
    80005fc4:	00878713          	addi	a4,a5,8
    80005fc8:	f8e43423          	sd	a4,-120(s0)
    80005fcc:	4605                	li	a2,1
    80005fce:	45a9                	li	a1,10
    80005fd0:	4388                	lw	a0,0(a5)
    80005fd2:	00000097          	auipc	ra,0x0
    80005fd6:	e0e080e7          	jalr	-498(ra) # 80005de0 <printint>
      break;
    80005fda:	b771                	j	80005f66 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005fdc:	f8843783          	ld	a5,-120(s0)
    80005fe0:	00878713          	addi	a4,a5,8
    80005fe4:	f8e43423          	sd	a4,-120(s0)
    80005fe8:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005fec:	03000513          	li	a0,48
    80005ff0:	00000097          	auipc	ra,0x0
    80005ff4:	bd0080e7          	jalr	-1072(ra) # 80005bc0 <consputc>
  consputc('x');
    80005ff8:	07800513          	li	a0,120
    80005ffc:	00000097          	auipc	ra,0x0
    80006000:	bc4080e7          	jalr	-1084(ra) # 80005bc0 <consputc>
    80006004:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80006006:	03c9d793          	srli	a5,s3,0x3c
    8000600a:	97de                	add	a5,a5,s7
    8000600c:	0007c503          	lbu	a0,0(a5)
    80006010:	00000097          	auipc	ra,0x0
    80006014:	bb0080e7          	jalr	-1104(ra) # 80005bc0 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80006018:	0992                	slli	s3,s3,0x4
    8000601a:	397d                	addiw	s2,s2,-1
    8000601c:	fe0915e3          	bnez	s2,80006006 <printf+0x13a>
    80006020:	b799                	j	80005f66 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80006022:	f8843783          	ld	a5,-120(s0)
    80006026:	00878713          	addi	a4,a5,8
    8000602a:	f8e43423          	sd	a4,-120(s0)
    8000602e:	0007b903          	ld	s2,0(a5)
    80006032:	00090e63          	beqz	s2,8000604e <printf+0x182>
      for(; *s; s++)
    80006036:	00094503          	lbu	a0,0(s2)
    8000603a:	d515                	beqz	a0,80005f66 <printf+0x9a>
        consputc(*s);
    8000603c:	00000097          	auipc	ra,0x0
    80006040:	b84080e7          	jalr	-1148(ra) # 80005bc0 <consputc>
      for(; *s; s++)
    80006044:	0905                	addi	s2,s2,1
    80006046:	00094503          	lbu	a0,0(s2)
    8000604a:	f96d                	bnez	a0,8000603c <printf+0x170>
    8000604c:	bf29                	j	80005f66 <printf+0x9a>
        s = "(null)";
    8000604e:	00002917          	auipc	s2,0x2
    80006052:	7f290913          	addi	s2,s2,2034 # 80008840 <syscalls+0x450>
      for(; *s; s++)
    80006056:	02800513          	li	a0,40
    8000605a:	b7cd                	j	8000603c <printf+0x170>
      consputc('%');
    8000605c:	8556                	mv	a0,s5
    8000605e:	00000097          	auipc	ra,0x0
    80006062:	b62080e7          	jalr	-1182(ra) # 80005bc0 <consputc>
      break;
    80006066:	b701                	j	80005f66 <printf+0x9a>
      consputc('%');
    80006068:	8556                	mv	a0,s5
    8000606a:	00000097          	auipc	ra,0x0
    8000606e:	b56080e7          	jalr	-1194(ra) # 80005bc0 <consputc>
      consputc(c);
    80006072:	854a                	mv	a0,s2
    80006074:	00000097          	auipc	ra,0x0
    80006078:	b4c080e7          	jalr	-1204(ra) # 80005bc0 <consputc>
      break;
    8000607c:	b5ed                	j	80005f66 <printf+0x9a>
  if(locking)
    8000607e:	020d9163          	bnez	s11,800060a0 <printf+0x1d4>
}
    80006082:	70e6                	ld	ra,120(sp)
    80006084:	7446                	ld	s0,112(sp)
    80006086:	74a6                	ld	s1,104(sp)
    80006088:	7906                	ld	s2,96(sp)
    8000608a:	69e6                	ld	s3,88(sp)
    8000608c:	6a46                	ld	s4,80(sp)
    8000608e:	6aa6                	ld	s5,72(sp)
    80006090:	6b06                	ld	s6,64(sp)
    80006092:	7be2                	ld	s7,56(sp)
    80006094:	7c42                	ld	s8,48(sp)
    80006096:	7ca2                	ld	s9,40(sp)
    80006098:	7d02                	ld	s10,32(sp)
    8000609a:	6de2                	ld	s11,24(sp)
    8000609c:	6129                	addi	sp,sp,192
    8000609e:	8082                	ret
    release(&pr.lock);
    800060a0:	0001c517          	auipc	a0,0x1c
    800060a4:	ec850513          	addi	a0,a0,-312 # 80021f68 <pr>
    800060a8:	00000097          	auipc	ra,0x0
    800060ac:	3d8080e7          	jalr	984(ra) # 80006480 <release>
}
    800060b0:	bfc9                	j	80006082 <printf+0x1b6>

00000000800060b2 <printfinit>:
    ;
}

void
printfinit(void)
{
    800060b2:	1101                	addi	sp,sp,-32
    800060b4:	ec06                	sd	ra,24(sp)
    800060b6:	e822                	sd	s0,16(sp)
    800060b8:	e426                	sd	s1,8(sp)
    800060ba:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    800060bc:	0001c497          	auipc	s1,0x1c
    800060c0:	eac48493          	addi	s1,s1,-340 # 80021f68 <pr>
    800060c4:	00002597          	auipc	a1,0x2
    800060c8:	79458593          	addi	a1,a1,1940 # 80008858 <syscalls+0x468>
    800060cc:	8526                	mv	a0,s1
    800060ce:	00000097          	auipc	ra,0x0
    800060d2:	26e080e7          	jalr	622(ra) # 8000633c <initlock>
  pr.locking = 1;
    800060d6:	4785                	li	a5,1
    800060d8:	cc9c                	sw	a5,24(s1)
}
    800060da:	60e2                	ld	ra,24(sp)
    800060dc:	6442                	ld	s0,16(sp)
    800060de:	64a2                	ld	s1,8(sp)
    800060e0:	6105                	addi	sp,sp,32
    800060e2:	8082                	ret

00000000800060e4 <uartinit>:

void uartstart();

void
uartinit(void)
{
    800060e4:	1141                	addi	sp,sp,-16
    800060e6:	e406                	sd	ra,8(sp)
    800060e8:	e022                	sd	s0,0(sp)
    800060ea:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800060ec:	100007b7          	lui	a5,0x10000
    800060f0:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800060f4:	f8000713          	li	a4,-128
    800060f8:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800060fc:	470d                	li	a4,3
    800060fe:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80006102:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80006106:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    8000610a:	469d                	li	a3,7
    8000610c:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80006110:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80006114:	00002597          	auipc	a1,0x2
    80006118:	76458593          	addi	a1,a1,1892 # 80008878 <digits+0x18>
    8000611c:	0001c517          	auipc	a0,0x1c
    80006120:	e6c50513          	addi	a0,a0,-404 # 80021f88 <uart_tx_lock>
    80006124:	00000097          	auipc	ra,0x0
    80006128:	218080e7          	jalr	536(ra) # 8000633c <initlock>
}
    8000612c:	60a2                	ld	ra,8(sp)
    8000612e:	6402                	ld	s0,0(sp)
    80006130:	0141                	addi	sp,sp,16
    80006132:	8082                	ret

0000000080006134 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80006134:	1101                	addi	sp,sp,-32
    80006136:	ec06                	sd	ra,24(sp)
    80006138:	e822                	sd	s0,16(sp)
    8000613a:	e426                	sd	s1,8(sp)
    8000613c:	1000                	addi	s0,sp,32
    8000613e:	84aa                	mv	s1,a0
  push_off();
    80006140:	00000097          	auipc	ra,0x0
    80006144:	240080e7          	jalr	576(ra) # 80006380 <push_off>

  if(panicked){
    80006148:	00002797          	auipc	a5,0x2
    8000614c:	7f47a783          	lw	a5,2036(a5) # 8000893c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006150:	10000737          	lui	a4,0x10000
  if(panicked){
    80006154:	c391                	beqz	a5,80006158 <uartputc_sync+0x24>
    for(;;)
    80006156:	a001                	j	80006156 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006158:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    8000615c:	0ff7f793          	andi	a5,a5,255
    80006160:	0207f793          	andi	a5,a5,32
    80006164:	dbf5                	beqz	a5,80006158 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80006166:	0ff4f793          	andi	a5,s1,255
    8000616a:	10000737          	lui	a4,0x10000
    8000616e:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    80006172:	00000097          	auipc	ra,0x0
    80006176:	2ae080e7          	jalr	686(ra) # 80006420 <pop_off>
}
    8000617a:	60e2                	ld	ra,24(sp)
    8000617c:	6442                	ld	s0,16(sp)
    8000617e:	64a2                	ld	s1,8(sp)
    80006180:	6105                	addi	sp,sp,32
    80006182:	8082                	ret

0000000080006184 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80006184:	00002717          	auipc	a4,0x2
    80006188:	7bc73703          	ld	a4,1980(a4) # 80008940 <uart_tx_r>
    8000618c:	00002797          	auipc	a5,0x2
    80006190:	7bc7b783          	ld	a5,1980(a5) # 80008948 <uart_tx_w>
    80006194:	06e78c63          	beq	a5,a4,8000620c <uartstart+0x88>
{
    80006198:	7139                	addi	sp,sp,-64
    8000619a:	fc06                	sd	ra,56(sp)
    8000619c:	f822                	sd	s0,48(sp)
    8000619e:	f426                	sd	s1,40(sp)
    800061a0:	f04a                	sd	s2,32(sp)
    800061a2:	ec4e                	sd	s3,24(sp)
    800061a4:	e852                	sd	s4,16(sp)
    800061a6:	e456                	sd	s5,8(sp)
    800061a8:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800061aa:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800061ae:	0001ca17          	auipc	s4,0x1c
    800061b2:	ddaa0a13          	addi	s4,s4,-550 # 80021f88 <uart_tx_lock>
    uart_tx_r += 1;
    800061b6:	00002497          	auipc	s1,0x2
    800061ba:	78a48493          	addi	s1,s1,1930 # 80008940 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    800061be:	00002997          	auipc	s3,0x2
    800061c2:	78a98993          	addi	s3,s3,1930 # 80008948 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800061c6:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    800061ca:	0ff7f793          	andi	a5,a5,255
    800061ce:	0207f793          	andi	a5,a5,32
    800061d2:	c785                	beqz	a5,800061fa <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800061d4:	01f77793          	andi	a5,a4,31
    800061d8:	97d2                	add	a5,a5,s4
    800061da:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    800061de:	0705                	addi	a4,a4,1
    800061e0:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    800061e2:	8526                	mv	a0,s1
    800061e4:	ffffb097          	auipc	ra,0xffffb
    800061e8:	514080e7          	jalr	1300(ra) # 800016f8 <wakeup>
    
    WriteReg(THR, c);
    800061ec:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    800061f0:	6098                	ld	a4,0(s1)
    800061f2:	0009b783          	ld	a5,0(s3)
    800061f6:	fce798e3          	bne	a5,a4,800061c6 <uartstart+0x42>
  }
}
    800061fa:	70e2                	ld	ra,56(sp)
    800061fc:	7442                	ld	s0,48(sp)
    800061fe:	74a2                	ld	s1,40(sp)
    80006200:	7902                	ld	s2,32(sp)
    80006202:	69e2                	ld	s3,24(sp)
    80006204:	6a42                	ld	s4,16(sp)
    80006206:	6aa2                	ld	s5,8(sp)
    80006208:	6121                	addi	sp,sp,64
    8000620a:	8082                	ret
    8000620c:	8082                	ret

000000008000620e <uartputc>:
{
    8000620e:	7179                	addi	sp,sp,-48
    80006210:	f406                	sd	ra,40(sp)
    80006212:	f022                	sd	s0,32(sp)
    80006214:	ec26                	sd	s1,24(sp)
    80006216:	e84a                	sd	s2,16(sp)
    80006218:	e44e                	sd	s3,8(sp)
    8000621a:	e052                	sd	s4,0(sp)
    8000621c:	1800                	addi	s0,sp,48
    8000621e:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    80006220:	0001c517          	auipc	a0,0x1c
    80006224:	d6850513          	addi	a0,a0,-664 # 80021f88 <uart_tx_lock>
    80006228:	00000097          	auipc	ra,0x0
    8000622c:	1a4080e7          	jalr	420(ra) # 800063cc <acquire>
  if(panicked){
    80006230:	00002797          	auipc	a5,0x2
    80006234:	70c7a783          	lw	a5,1804(a5) # 8000893c <panicked>
    80006238:	e7c9                	bnez	a5,800062c2 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000623a:	00002797          	auipc	a5,0x2
    8000623e:	70e7b783          	ld	a5,1806(a5) # 80008948 <uart_tx_w>
    80006242:	00002717          	auipc	a4,0x2
    80006246:	6fe73703          	ld	a4,1790(a4) # 80008940 <uart_tx_r>
    8000624a:	02070713          	addi	a4,a4,32
    sleep(&uart_tx_r, &uart_tx_lock);
    8000624e:	0001ca17          	auipc	s4,0x1c
    80006252:	d3aa0a13          	addi	s4,s4,-710 # 80021f88 <uart_tx_lock>
    80006256:	00002497          	auipc	s1,0x2
    8000625a:	6ea48493          	addi	s1,s1,1770 # 80008940 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000625e:	00002917          	auipc	s2,0x2
    80006262:	6ea90913          	addi	s2,s2,1770 # 80008948 <uart_tx_w>
    80006266:	00f71f63          	bne	a4,a5,80006284 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    8000626a:	85d2                	mv	a1,s4
    8000626c:	8526                	mv	a0,s1
    8000626e:	ffffb097          	auipc	ra,0xffffb
    80006272:	426080e7          	jalr	1062(ra) # 80001694 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006276:	00093783          	ld	a5,0(s2)
    8000627a:	6098                	ld	a4,0(s1)
    8000627c:	02070713          	addi	a4,a4,32
    80006280:	fef705e3          	beq	a4,a5,8000626a <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006284:	0001c497          	auipc	s1,0x1c
    80006288:	d0448493          	addi	s1,s1,-764 # 80021f88 <uart_tx_lock>
    8000628c:	01f7f713          	andi	a4,a5,31
    80006290:	9726                	add	a4,a4,s1
    80006292:	01370c23          	sb	s3,24(a4)
  uart_tx_w += 1;
    80006296:	0785                	addi	a5,a5,1
    80006298:	00002717          	auipc	a4,0x2
    8000629c:	6af73823          	sd	a5,1712(a4) # 80008948 <uart_tx_w>
  uartstart();
    800062a0:	00000097          	auipc	ra,0x0
    800062a4:	ee4080e7          	jalr	-284(ra) # 80006184 <uartstart>
  release(&uart_tx_lock);
    800062a8:	8526                	mv	a0,s1
    800062aa:	00000097          	auipc	ra,0x0
    800062ae:	1d6080e7          	jalr	470(ra) # 80006480 <release>
}
    800062b2:	70a2                	ld	ra,40(sp)
    800062b4:	7402                	ld	s0,32(sp)
    800062b6:	64e2                	ld	s1,24(sp)
    800062b8:	6942                	ld	s2,16(sp)
    800062ba:	69a2                	ld	s3,8(sp)
    800062bc:	6a02                	ld	s4,0(sp)
    800062be:	6145                	addi	sp,sp,48
    800062c0:	8082                	ret
    for(;;)
    800062c2:	a001                	j	800062c2 <uartputc+0xb4>

00000000800062c4 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800062c4:	1141                	addi	sp,sp,-16
    800062c6:	e422                	sd	s0,8(sp)
    800062c8:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800062ca:	100007b7          	lui	a5,0x10000
    800062ce:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800062d2:	8b85                	andi	a5,a5,1
    800062d4:	cb91                	beqz	a5,800062e8 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800062d6:	100007b7          	lui	a5,0x10000
    800062da:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    800062de:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    800062e2:	6422                	ld	s0,8(sp)
    800062e4:	0141                	addi	sp,sp,16
    800062e6:	8082                	ret
    return -1;
    800062e8:	557d                	li	a0,-1
    800062ea:	bfe5                	j	800062e2 <uartgetc+0x1e>

00000000800062ec <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800062ec:	1101                	addi	sp,sp,-32
    800062ee:	ec06                	sd	ra,24(sp)
    800062f0:	e822                	sd	s0,16(sp)
    800062f2:	e426                	sd	s1,8(sp)
    800062f4:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800062f6:	54fd                	li	s1,-1
    int c = uartgetc();
    800062f8:	00000097          	auipc	ra,0x0
    800062fc:	fcc080e7          	jalr	-52(ra) # 800062c4 <uartgetc>
    if(c == -1)
    80006300:	00950763          	beq	a0,s1,8000630e <uartintr+0x22>
      break;
    consoleintr(c);
    80006304:	00000097          	auipc	ra,0x0
    80006308:	8fe080e7          	jalr	-1794(ra) # 80005c02 <consoleintr>
  while(1){
    8000630c:	b7f5                	j	800062f8 <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    8000630e:	0001c497          	auipc	s1,0x1c
    80006312:	c7a48493          	addi	s1,s1,-902 # 80021f88 <uart_tx_lock>
    80006316:	8526                	mv	a0,s1
    80006318:	00000097          	auipc	ra,0x0
    8000631c:	0b4080e7          	jalr	180(ra) # 800063cc <acquire>
  uartstart();
    80006320:	00000097          	auipc	ra,0x0
    80006324:	e64080e7          	jalr	-412(ra) # 80006184 <uartstart>
  release(&uart_tx_lock);
    80006328:	8526                	mv	a0,s1
    8000632a:	00000097          	auipc	ra,0x0
    8000632e:	156080e7          	jalr	342(ra) # 80006480 <release>
}
    80006332:	60e2                	ld	ra,24(sp)
    80006334:	6442                	ld	s0,16(sp)
    80006336:	64a2                	ld	s1,8(sp)
    80006338:	6105                	addi	sp,sp,32
    8000633a:	8082                	ret

000000008000633c <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    8000633c:	1141                	addi	sp,sp,-16
    8000633e:	e422                	sd	s0,8(sp)
    80006340:	0800                	addi	s0,sp,16
  lk->name = name;
    80006342:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006344:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006348:	00053823          	sd	zero,16(a0)
}
    8000634c:	6422                	ld	s0,8(sp)
    8000634e:	0141                	addi	sp,sp,16
    80006350:	8082                	ret

0000000080006352 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006352:	411c                	lw	a5,0(a0)
    80006354:	e399                	bnez	a5,8000635a <holding+0x8>
    80006356:	4501                	li	a0,0
  return r;
}
    80006358:	8082                	ret
{
    8000635a:	1101                	addi	sp,sp,-32
    8000635c:	ec06                	sd	ra,24(sp)
    8000635e:	e822                	sd	s0,16(sp)
    80006360:	e426                	sd	s1,8(sp)
    80006362:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006364:	6904                	ld	s1,16(a0)
    80006366:	ffffb097          	auipc	ra,0xffffb
    8000636a:	bb2080e7          	jalr	-1102(ra) # 80000f18 <mycpu>
    8000636e:	40a48533          	sub	a0,s1,a0
    80006372:	00153513          	seqz	a0,a0
}
    80006376:	60e2                	ld	ra,24(sp)
    80006378:	6442                	ld	s0,16(sp)
    8000637a:	64a2                	ld	s1,8(sp)
    8000637c:	6105                	addi	sp,sp,32
    8000637e:	8082                	ret

0000000080006380 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006380:	1101                	addi	sp,sp,-32
    80006382:	ec06                	sd	ra,24(sp)
    80006384:	e822                	sd	s0,16(sp)
    80006386:	e426                	sd	s1,8(sp)
    80006388:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000638a:	100024f3          	csrr	s1,sstatus
    8000638e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006392:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006394:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80006398:	ffffb097          	auipc	ra,0xffffb
    8000639c:	b80080e7          	jalr	-1152(ra) # 80000f18 <mycpu>
    800063a0:	5d3c                	lw	a5,120(a0)
    800063a2:	cf89                	beqz	a5,800063bc <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800063a4:	ffffb097          	auipc	ra,0xffffb
    800063a8:	b74080e7          	jalr	-1164(ra) # 80000f18 <mycpu>
    800063ac:	5d3c                	lw	a5,120(a0)
    800063ae:	2785                	addiw	a5,a5,1
    800063b0:	dd3c                	sw	a5,120(a0)
}
    800063b2:	60e2                	ld	ra,24(sp)
    800063b4:	6442                	ld	s0,16(sp)
    800063b6:	64a2                	ld	s1,8(sp)
    800063b8:	6105                	addi	sp,sp,32
    800063ba:	8082                	ret
    mycpu()->intena = old;
    800063bc:	ffffb097          	auipc	ra,0xffffb
    800063c0:	b5c080e7          	jalr	-1188(ra) # 80000f18 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800063c4:	8085                	srli	s1,s1,0x1
    800063c6:	8885                	andi	s1,s1,1
    800063c8:	dd64                	sw	s1,124(a0)
    800063ca:	bfe9                	j	800063a4 <push_off+0x24>

00000000800063cc <acquire>:
{
    800063cc:	1101                	addi	sp,sp,-32
    800063ce:	ec06                	sd	ra,24(sp)
    800063d0:	e822                	sd	s0,16(sp)
    800063d2:	e426                	sd	s1,8(sp)
    800063d4:	1000                	addi	s0,sp,32
    800063d6:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800063d8:	00000097          	auipc	ra,0x0
    800063dc:	fa8080e7          	jalr	-88(ra) # 80006380 <push_off>
  if(holding(lk))
    800063e0:	8526                	mv	a0,s1
    800063e2:	00000097          	auipc	ra,0x0
    800063e6:	f70080e7          	jalr	-144(ra) # 80006352 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800063ea:	4705                	li	a4,1
  if(holding(lk))
    800063ec:	e115                	bnez	a0,80006410 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800063ee:	87ba                	mv	a5,a4
    800063f0:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800063f4:	2781                	sext.w	a5,a5
    800063f6:	ffe5                	bnez	a5,800063ee <acquire+0x22>
  __sync_synchronize();
    800063f8:	0ff0000f          	fence
  lk->cpu = mycpu();
    800063fc:	ffffb097          	auipc	ra,0xffffb
    80006400:	b1c080e7          	jalr	-1252(ra) # 80000f18 <mycpu>
    80006404:	e888                	sd	a0,16(s1)
}
    80006406:	60e2                	ld	ra,24(sp)
    80006408:	6442                	ld	s0,16(sp)
    8000640a:	64a2                	ld	s1,8(sp)
    8000640c:	6105                	addi	sp,sp,32
    8000640e:	8082                	ret
    panic("acquire");
    80006410:	00002517          	auipc	a0,0x2
    80006414:	47050513          	addi	a0,a0,1136 # 80008880 <digits+0x20>
    80006418:	00000097          	auipc	ra,0x0
    8000641c:	a6a080e7          	jalr	-1430(ra) # 80005e82 <panic>

0000000080006420 <pop_off>:

void
pop_off(void)
{
    80006420:	1141                	addi	sp,sp,-16
    80006422:	e406                	sd	ra,8(sp)
    80006424:	e022                	sd	s0,0(sp)
    80006426:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006428:	ffffb097          	auipc	ra,0xffffb
    8000642c:	af0080e7          	jalr	-1296(ra) # 80000f18 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006430:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006434:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006436:	e78d                	bnez	a5,80006460 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006438:	5d3c                	lw	a5,120(a0)
    8000643a:	02f05b63          	blez	a5,80006470 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    8000643e:	37fd                	addiw	a5,a5,-1
    80006440:	0007871b          	sext.w	a4,a5
    80006444:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006446:	eb09                	bnez	a4,80006458 <pop_off+0x38>
    80006448:	5d7c                	lw	a5,124(a0)
    8000644a:	c799                	beqz	a5,80006458 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000644c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006450:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006454:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006458:	60a2                	ld	ra,8(sp)
    8000645a:	6402                	ld	s0,0(sp)
    8000645c:	0141                	addi	sp,sp,16
    8000645e:	8082                	ret
    panic("pop_off - interruptible");
    80006460:	00002517          	auipc	a0,0x2
    80006464:	42850513          	addi	a0,a0,1064 # 80008888 <digits+0x28>
    80006468:	00000097          	auipc	ra,0x0
    8000646c:	a1a080e7          	jalr	-1510(ra) # 80005e82 <panic>
    panic("pop_off");
    80006470:	00002517          	auipc	a0,0x2
    80006474:	43050513          	addi	a0,a0,1072 # 800088a0 <digits+0x40>
    80006478:	00000097          	auipc	ra,0x0
    8000647c:	a0a080e7          	jalr	-1526(ra) # 80005e82 <panic>

0000000080006480 <release>:
{
    80006480:	1101                	addi	sp,sp,-32
    80006482:	ec06                	sd	ra,24(sp)
    80006484:	e822                	sd	s0,16(sp)
    80006486:	e426                	sd	s1,8(sp)
    80006488:	1000                	addi	s0,sp,32
    8000648a:	84aa                	mv	s1,a0
  if(!holding(lk))
    8000648c:	00000097          	auipc	ra,0x0
    80006490:	ec6080e7          	jalr	-314(ra) # 80006352 <holding>
    80006494:	c115                	beqz	a0,800064b8 <release+0x38>
  lk->cpu = 0;
    80006496:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    8000649a:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    8000649e:	0f50000f          	fence	iorw,ow
    800064a2:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800064a6:	00000097          	auipc	ra,0x0
    800064aa:	f7a080e7          	jalr	-134(ra) # 80006420 <pop_off>
}
    800064ae:	60e2                	ld	ra,24(sp)
    800064b0:	6442                	ld	s0,16(sp)
    800064b2:	64a2                	ld	s1,8(sp)
    800064b4:	6105                	addi	sp,sp,32
    800064b6:	8082                	ret
    panic("release");
    800064b8:	00002517          	auipc	a0,0x2
    800064bc:	3f050513          	addi	a0,a0,1008 # 800088a8 <digits+0x48>
    800064c0:	00000097          	auipc	ra,0x0
    800064c4:	9c2080e7          	jalr	-1598(ra) # 80005e82 <panic>
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
