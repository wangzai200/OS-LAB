
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	8c013103          	ld	sp,-1856(sp) # 800088c0 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	007050ef          	jal	ra,8000581c <start>

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
    80000034:	35078793          	addi	a5,a5,848 # 80022380 <end>
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
    80000054:	8c090913          	addi	s2,s2,-1856 # 80008910 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	21e080e7          	jalr	542(ra) # 80006278 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	2be080e7          	jalr	702(ra) # 8000632c <release>
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
    8000008e:	c48080e7          	jalr	-952(ra) # 80005cd2 <panic>

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
    800000f0:	82450513          	addi	a0,a0,-2012 # 80008910 <kmem>
    800000f4:	00006097          	auipc	ra,0x6
    800000f8:	0f4080e7          	jalr	244(ra) # 800061e8 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fc:	45c5                	li	a1,17
    800000fe:	05ee                	slli	a1,a1,0x1b
    80000100:	00022517          	auipc	a0,0x22
    80000104:	28050513          	addi	a0,a0,640 # 80022380 <end>
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
    80000122:	00008497          	auipc	s1,0x8
    80000126:	7ee48493          	addi	s1,s1,2030 # 80008910 <kmem>
    8000012a:	8526                	mv	a0,s1
    8000012c:	00006097          	auipc	ra,0x6
    80000130:	14c080e7          	jalr	332(ra) # 80006278 <acquire>
  r = kmem.freelist;
    80000134:	6c84                	ld	s1,24(s1)
  if(r)
    80000136:	c885                	beqz	s1,80000166 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000138:	609c                	ld	a5,0(s1)
    8000013a:	00008517          	auipc	a0,0x8
    8000013e:	7d650513          	addi	a0,a0,2006 # 80008910 <kmem>
    80000142:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000144:	00006097          	auipc	ra,0x6
    80000148:	1e8080e7          	jalr	488(ra) # 8000632c <release>

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
    8000016a:	7aa50513          	addi	a0,a0,1962 # 80008910 <kmem>
    8000016e:	00006097          	auipc	ra,0x6
    80000172:	1be080e7          	jalr	446(ra) # 8000632c <release>
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
    80000332:	afe080e7          	jalr	-1282(ra) # 80000e2c <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000336:	00008717          	auipc	a4,0x8
    8000033a:	5aa70713          	addi	a4,a4,1450 # 800088e0 <started>
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
    8000034e:	ae2080e7          	jalr	-1310(ra) # 80000e2c <cpuid>
    80000352:	85aa                	mv	a1,a0
    80000354:	00008517          	auipc	a0,0x8
    80000358:	ce450513          	addi	a0,a0,-796 # 80008038 <etext+0x38>
    8000035c:	00006097          	auipc	ra,0x6
    80000360:	9c0080e7          	jalr	-1600(ra) # 80005d1c <printf>
    kvminithart();    // turn on paging
    80000364:	00000097          	auipc	ra,0x0
    80000368:	0d8080e7          	jalr	216(ra) # 8000043c <kvminithart>
    trapinithart();   // install kernel trap vector
    8000036c:	00001097          	auipc	ra,0x1
    80000370:	790080e7          	jalr	1936(ra) # 80001afc <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000374:	00005097          	auipc	ra,0x5
    80000378:	dfc080e7          	jalr	-516(ra) # 80005170 <plicinithart>
  }

  scheduler();        
    8000037c:	00001097          	auipc	ra,0x1
    80000380:	fda080e7          	jalr	-38(ra) # 80001356 <scheduler>
    consoleinit();
    80000384:	00006097          	auipc	ra,0x6
    80000388:	860080e7          	jalr	-1952(ra) # 80005be4 <consoleinit>
    printfinit();
    8000038c:	00006097          	auipc	ra,0x6
    80000390:	b76080e7          	jalr	-1162(ra) # 80005f02 <printfinit>
    printf("\n");
    80000394:	00008517          	auipc	a0,0x8
    80000398:	cb450513          	addi	a0,a0,-844 # 80008048 <etext+0x48>
    8000039c:	00006097          	auipc	ra,0x6
    800003a0:	980080e7          	jalr	-1664(ra) # 80005d1c <printf>
    printf("xv6 kernel is booting\n");
    800003a4:	00008517          	auipc	a0,0x8
    800003a8:	c7c50513          	addi	a0,a0,-900 # 80008020 <etext+0x20>
    800003ac:	00006097          	auipc	ra,0x6
    800003b0:	970080e7          	jalr	-1680(ra) # 80005d1c <printf>
    printf("\n");
    800003b4:	00008517          	auipc	a0,0x8
    800003b8:	c9450513          	addi	a0,a0,-876 # 80008048 <etext+0x48>
    800003bc:	00006097          	auipc	ra,0x6
    800003c0:	960080e7          	jalr	-1696(ra) # 80005d1c <printf>
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
    800003e0:	99c080e7          	jalr	-1636(ra) # 80000d78 <procinit>
    trapinit();      // trap vectors
    800003e4:	00001097          	auipc	ra,0x1
    800003e8:	6f0080e7          	jalr	1776(ra) # 80001ad4 <trapinit>
    trapinithart();  // install kernel trap vector
    800003ec:	00001097          	auipc	ra,0x1
    800003f0:	710080e7          	jalr	1808(ra) # 80001afc <trapinithart>
    plicinit();      // set up interrupt controller
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	d66080e7          	jalr	-666(ra) # 8000515a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003fc:	00005097          	auipc	ra,0x5
    80000400:	d74080e7          	jalr	-652(ra) # 80005170 <plicinithart>
    binit();         // buffer cache
    80000404:	00002097          	auipc	ra,0x2
    80000408:	f2e080e7          	jalr	-210(ra) # 80002332 <binit>
    iinit();         // inode table
    8000040c:	00002097          	auipc	ra,0x2
    80000410:	5d2080e7          	jalr	1490(ra) # 800029de <iinit>
    fileinit();      // file table
    80000414:	00003097          	auipc	ra,0x3
    80000418:	570080e7          	jalr	1392(ra) # 80003984 <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000041c:	00005097          	auipc	ra,0x5
    80000420:	e5c080e7          	jalr	-420(ra) # 80005278 <virtio_disk_init>
    userinit();      // first user process
    80000424:	00001097          	auipc	ra,0x1
    80000428:	d18080e7          	jalr	-744(ra) # 8000113c <userinit>
    __sync_synchronize();
    8000042c:	0ff0000f          	fence
    started = 1;
    80000430:	4785                	li	a5,1
    80000432:	00008717          	auipc	a4,0x8
    80000436:	4af72723          	sw	a5,1198(a4) # 800088e0 <started>
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
    8000044a:	4a27b783          	ld	a5,1186(a5) # 800088e8 <kernel_pagetable>
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
    80000496:	840080e7          	jalr	-1984(ra) # 80005cd2 <panic>
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
    8000058a:	00005097          	auipc	ra,0x5
    8000058e:	748080e7          	jalr	1864(ra) # 80005cd2 <panic>
      panic("mappages: remap");
    80000592:	00008517          	auipc	a0,0x8
    80000596:	ad650513          	addi	a0,a0,-1322 # 80008068 <etext+0x68>
    8000059a:	00005097          	auipc	ra,0x5
    8000059e:	738080e7          	jalr	1848(ra) # 80005cd2 <panic>
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
    80000614:	00005097          	auipc	ra,0x5
    80000618:	6be080e7          	jalr	1726(ra) # 80005cd2 <panic>

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
    800006e0:	606080e7          	jalr	1542(ra) # 80000ce2 <proc_mapstacks>
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
    80000706:	1ea7b323          	sd	a0,486(a5) # 800088e8 <kernel_pagetable>
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
    80000764:	572080e7          	jalr	1394(ra) # 80005cd2 <panic>
      panic("uvmunmap: walk");
    80000768:	00008517          	auipc	a0,0x8
    8000076c:	93050513          	addi	a0,a0,-1744 # 80008098 <etext+0x98>
    80000770:	00005097          	auipc	ra,0x5
    80000774:	562080e7          	jalr	1378(ra) # 80005cd2 <panic>
      panic("uvmunmap: not mapped");
    80000778:	00008517          	auipc	a0,0x8
    8000077c:	93050513          	addi	a0,a0,-1744 # 800080a8 <etext+0xa8>
    80000780:	00005097          	auipc	ra,0x5
    80000784:	552080e7          	jalr	1362(ra) # 80005cd2 <panic>
      panic("uvmunmap: not a leaf");
    80000788:	00008517          	auipc	a0,0x8
    8000078c:	93850513          	addi	a0,a0,-1736 # 800080c0 <etext+0xc0>
    80000790:	00005097          	auipc	ra,0x5
    80000794:	542080e7          	jalr	1346(ra) # 80005cd2 <panic>
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
    80000872:	464080e7          	jalr	1124(ra) # 80005cd2 <panic>

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
    800009bc:	31a080e7          	jalr	794(ra) # 80005cd2 <panic>
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
    80000a98:	23e080e7          	jalr	574(ra) # 80005cd2 <panic>
      panic("uvmcopy: page not present");
    80000a9c:	00007517          	auipc	a0,0x7
    80000aa0:	68c50513          	addi	a0,a0,1676 # 80008128 <etext+0x128>
    80000aa4:	00005097          	auipc	ra,0x5
    80000aa8:	22e080e7          	jalr	558(ra) # 80005cd2 <panic>
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
    80000b12:	1c4080e7          	jalr	452(ra) # 80005cd2 <panic>

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

0000000080000ce2 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000ce2:	7139                	addi	sp,sp,-64
    80000ce4:	fc06                	sd	ra,56(sp)
    80000ce6:	f822                	sd	s0,48(sp)
    80000ce8:	f426                	sd	s1,40(sp)
    80000cea:	f04a                	sd	s2,32(sp)
    80000cec:	ec4e                	sd	s3,24(sp)
    80000cee:	e852                	sd	s4,16(sp)
    80000cf0:	e456                	sd	s5,8(sp)
    80000cf2:	e05a                	sd	s6,0(sp)
    80000cf4:	0080                	addi	s0,sp,64
    80000cf6:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cf8:	00008497          	auipc	s1,0x8
    80000cfc:	06848493          	addi	s1,s1,104 # 80008d60 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000d00:	8b26                	mv	s6,s1
    80000d02:	00007a97          	auipc	s5,0x7
    80000d06:	2fea8a93          	addi	s5,s5,766 # 80008000 <etext>
    80000d0a:	04000937          	lui	s2,0x4000
    80000d0e:	197d                	addi	s2,s2,-1
    80000d10:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d12:	0000ea17          	auipc	s4,0xe
    80000d16:	04ea0a13          	addi	s4,s4,78 # 8000ed60 <tickslock>
    char *pa = kalloc();
    80000d1a:	fffff097          	auipc	ra,0xfffff
    80000d1e:	3fe080e7          	jalr	1022(ra) # 80000118 <kalloc>
    80000d22:	862a                	mv	a2,a0
    if(pa == 0)
    80000d24:	c131                	beqz	a0,80000d68 <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000d26:	416485b3          	sub	a1,s1,s6
    80000d2a:	859d                	srai	a1,a1,0x7
    80000d2c:	000ab783          	ld	a5,0(s5)
    80000d30:	02f585b3          	mul	a1,a1,a5
    80000d34:	2585                	addiw	a1,a1,1
    80000d36:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d3a:	4719                	li	a4,6
    80000d3c:	6685                	lui	a3,0x1
    80000d3e:	40b905b3          	sub	a1,s2,a1
    80000d42:	854e                	mv	a0,s3
    80000d44:	00000097          	auipc	ra,0x0
    80000d48:	8a8080e7          	jalr	-1880(ra) # 800005ec <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d4c:	18048493          	addi	s1,s1,384
    80000d50:	fd4495e3          	bne	s1,s4,80000d1a <proc_mapstacks+0x38>
  }
}
    80000d54:	70e2                	ld	ra,56(sp)
    80000d56:	7442                	ld	s0,48(sp)
    80000d58:	74a2                	ld	s1,40(sp)
    80000d5a:	7902                	ld	s2,32(sp)
    80000d5c:	69e2                	ld	s3,24(sp)
    80000d5e:	6a42                	ld	s4,16(sp)
    80000d60:	6aa2                	ld	s5,8(sp)
    80000d62:	6b02                	ld	s6,0(sp)
    80000d64:	6121                	addi	sp,sp,64
    80000d66:	8082                	ret
      panic("kalloc");
    80000d68:	00007517          	auipc	a0,0x7
    80000d6c:	3f050513          	addi	a0,a0,1008 # 80008158 <etext+0x158>
    80000d70:	00005097          	auipc	ra,0x5
    80000d74:	f62080e7          	jalr	-158(ra) # 80005cd2 <panic>

0000000080000d78 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000d78:	7139                	addi	sp,sp,-64
    80000d7a:	fc06                	sd	ra,56(sp)
    80000d7c:	f822                	sd	s0,48(sp)
    80000d7e:	f426                	sd	s1,40(sp)
    80000d80:	f04a                	sd	s2,32(sp)
    80000d82:	ec4e                	sd	s3,24(sp)
    80000d84:	e852                	sd	s4,16(sp)
    80000d86:	e456                	sd	s5,8(sp)
    80000d88:	e05a                	sd	s6,0(sp)
    80000d8a:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000d8c:	00007597          	auipc	a1,0x7
    80000d90:	3d458593          	addi	a1,a1,980 # 80008160 <etext+0x160>
    80000d94:	00008517          	auipc	a0,0x8
    80000d98:	b9c50513          	addi	a0,a0,-1124 # 80008930 <pid_lock>
    80000d9c:	00005097          	auipc	ra,0x5
    80000da0:	44c080e7          	jalr	1100(ra) # 800061e8 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000da4:	00007597          	auipc	a1,0x7
    80000da8:	3c458593          	addi	a1,a1,964 # 80008168 <etext+0x168>
    80000dac:	00008517          	auipc	a0,0x8
    80000db0:	b9c50513          	addi	a0,a0,-1124 # 80008948 <wait_lock>
    80000db4:	00005097          	auipc	ra,0x5
    80000db8:	434080e7          	jalr	1076(ra) # 800061e8 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dbc:	00008497          	auipc	s1,0x8
    80000dc0:	fa448493          	addi	s1,s1,-92 # 80008d60 <proc>
      initlock(&p->lock, "proc");
    80000dc4:	00007b17          	auipc	s6,0x7
    80000dc8:	3b4b0b13          	addi	s6,s6,948 # 80008178 <etext+0x178>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000dcc:	8aa6                	mv	s5,s1
    80000dce:	00007a17          	auipc	s4,0x7
    80000dd2:	232a0a13          	addi	s4,s4,562 # 80008000 <etext>
    80000dd6:	04000937          	lui	s2,0x4000
    80000dda:	197d                	addi	s2,s2,-1
    80000ddc:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dde:	0000e997          	auipc	s3,0xe
    80000de2:	f8298993          	addi	s3,s3,-126 # 8000ed60 <tickslock>
      initlock(&p->lock, "proc");
    80000de6:	85da                	mv	a1,s6
    80000de8:	8526                	mv	a0,s1
    80000dea:	00005097          	auipc	ra,0x5
    80000dee:	3fe080e7          	jalr	1022(ra) # 800061e8 <initlock>
      p->state = UNUSED;
    80000df2:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000df6:	415487b3          	sub	a5,s1,s5
    80000dfa:	879d                	srai	a5,a5,0x7
    80000dfc:	000a3703          	ld	a4,0(s4)
    80000e00:	02e787b3          	mul	a5,a5,a4
    80000e04:	2785                	addiw	a5,a5,1
    80000e06:	00d7979b          	slliw	a5,a5,0xd
    80000e0a:	40f907b3          	sub	a5,s2,a5
    80000e0e:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e10:	18048493          	addi	s1,s1,384
    80000e14:	fd3499e3          	bne	s1,s3,80000de6 <procinit+0x6e>
  }
}
    80000e18:	70e2                	ld	ra,56(sp)
    80000e1a:	7442                	ld	s0,48(sp)
    80000e1c:	74a2                	ld	s1,40(sp)
    80000e1e:	7902                	ld	s2,32(sp)
    80000e20:	69e2                	ld	s3,24(sp)
    80000e22:	6a42                	ld	s4,16(sp)
    80000e24:	6aa2                	ld	s5,8(sp)
    80000e26:	6b02                	ld	s6,0(sp)
    80000e28:	6121                	addi	sp,sp,64
    80000e2a:	8082                	ret

0000000080000e2c <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e2c:	1141                	addi	sp,sp,-16
    80000e2e:	e422                	sd	s0,8(sp)
    80000e30:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e32:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e34:	2501                	sext.w	a0,a0
    80000e36:	6422                	ld	s0,8(sp)
    80000e38:	0141                	addi	sp,sp,16
    80000e3a:	8082                	ret

0000000080000e3c <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000e3c:	1141                	addi	sp,sp,-16
    80000e3e:	e422                	sd	s0,8(sp)
    80000e40:	0800                	addi	s0,sp,16
    80000e42:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e44:	2781                	sext.w	a5,a5
    80000e46:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e48:	00008517          	auipc	a0,0x8
    80000e4c:	b1850513          	addi	a0,a0,-1256 # 80008960 <cpus>
    80000e50:	953e                	add	a0,a0,a5
    80000e52:	6422                	ld	s0,8(sp)
    80000e54:	0141                	addi	sp,sp,16
    80000e56:	8082                	ret

0000000080000e58 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000e58:	1101                	addi	sp,sp,-32
    80000e5a:	ec06                	sd	ra,24(sp)
    80000e5c:	e822                	sd	s0,16(sp)
    80000e5e:	e426                	sd	s1,8(sp)
    80000e60:	1000                	addi	s0,sp,32
  push_off();
    80000e62:	00005097          	auipc	ra,0x5
    80000e66:	3ca080e7          	jalr	970(ra) # 8000622c <push_off>
    80000e6a:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e6c:	2781                	sext.w	a5,a5
    80000e6e:	079e                	slli	a5,a5,0x7
    80000e70:	00008717          	auipc	a4,0x8
    80000e74:	ac070713          	addi	a4,a4,-1344 # 80008930 <pid_lock>
    80000e78:	97ba                	add	a5,a5,a4
    80000e7a:	7b84                	ld	s1,48(a5)
  pop_off();
    80000e7c:	00005097          	auipc	ra,0x5
    80000e80:	450080e7          	jalr	1104(ra) # 800062cc <pop_off>
  return p;
}
    80000e84:	8526                	mv	a0,s1
    80000e86:	60e2                	ld	ra,24(sp)
    80000e88:	6442                	ld	s0,16(sp)
    80000e8a:	64a2                	ld	s1,8(sp)
    80000e8c:	6105                	addi	sp,sp,32
    80000e8e:	8082                	ret

0000000080000e90 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000e90:	1141                	addi	sp,sp,-16
    80000e92:	e406                	sd	ra,8(sp)
    80000e94:	e022                	sd	s0,0(sp)
    80000e96:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000e98:	00000097          	auipc	ra,0x0
    80000e9c:	fc0080e7          	jalr	-64(ra) # 80000e58 <myproc>
    80000ea0:	00005097          	auipc	ra,0x5
    80000ea4:	48c080e7          	jalr	1164(ra) # 8000632c <release>

  if (first) {
    80000ea8:	00008797          	auipc	a5,0x8
    80000eac:	9c87a783          	lw	a5,-1592(a5) # 80008870 <first.1687>
    80000eb0:	eb89                	bnez	a5,80000ec2 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000eb2:	00001097          	auipc	ra,0x1
    80000eb6:	c62080e7          	jalr	-926(ra) # 80001b14 <usertrapret>
}
    80000eba:	60a2                	ld	ra,8(sp)
    80000ebc:	6402                	ld	s0,0(sp)
    80000ebe:	0141                	addi	sp,sp,16
    80000ec0:	8082                	ret
    first = 0;
    80000ec2:	00008797          	auipc	a5,0x8
    80000ec6:	9a07a723          	sw	zero,-1618(a5) # 80008870 <first.1687>
    fsinit(ROOTDEV);
    80000eca:	4505                	li	a0,1
    80000ecc:	00002097          	auipc	ra,0x2
    80000ed0:	a92080e7          	jalr	-1390(ra) # 8000295e <fsinit>
    80000ed4:	bff9                	j	80000eb2 <forkret+0x22>

0000000080000ed6 <allocpid>:
{
    80000ed6:	1101                	addi	sp,sp,-32
    80000ed8:	ec06                	sd	ra,24(sp)
    80000eda:	e822                	sd	s0,16(sp)
    80000edc:	e426                	sd	s1,8(sp)
    80000ede:	e04a                	sd	s2,0(sp)
    80000ee0:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000ee2:	00008917          	auipc	s2,0x8
    80000ee6:	a4e90913          	addi	s2,s2,-1458 # 80008930 <pid_lock>
    80000eea:	854a                	mv	a0,s2
    80000eec:	00005097          	auipc	ra,0x5
    80000ef0:	38c080e7          	jalr	908(ra) # 80006278 <acquire>
  pid = nextpid;
    80000ef4:	00008797          	auipc	a5,0x8
    80000ef8:	98078793          	addi	a5,a5,-1664 # 80008874 <nextpid>
    80000efc:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000efe:	0014871b          	addiw	a4,s1,1
    80000f02:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000f04:	854a                	mv	a0,s2
    80000f06:	00005097          	auipc	ra,0x5
    80000f0a:	426080e7          	jalr	1062(ra) # 8000632c <release>
}
    80000f0e:	8526                	mv	a0,s1
    80000f10:	60e2                	ld	ra,24(sp)
    80000f12:	6442                	ld	s0,16(sp)
    80000f14:	64a2                	ld	s1,8(sp)
    80000f16:	6902                	ld	s2,0(sp)
    80000f18:	6105                	addi	sp,sp,32
    80000f1a:	8082                	ret

0000000080000f1c <proc_pagetable>:
{
    80000f1c:	1101                	addi	sp,sp,-32
    80000f1e:	ec06                	sd	ra,24(sp)
    80000f20:	e822                	sd	s0,16(sp)
    80000f22:	e426                	sd	s1,8(sp)
    80000f24:	e04a                	sd	s2,0(sp)
    80000f26:	1000                	addi	s0,sp,32
    80000f28:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f2a:	00000097          	auipc	ra,0x0
    80000f2e:	8ac080e7          	jalr	-1876(ra) # 800007d6 <uvmcreate>
    80000f32:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f34:	c121                	beqz	a0,80000f74 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f36:	4729                	li	a4,10
    80000f38:	00006697          	auipc	a3,0x6
    80000f3c:	0c868693          	addi	a3,a3,200 # 80007000 <_trampoline>
    80000f40:	6605                	lui	a2,0x1
    80000f42:	040005b7          	lui	a1,0x4000
    80000f46:	15fd                	addi	a1,a1,-1
    80000f48:	05b2                	slli	a1,a1,0xc
    80000f4a:	fffff097          	auipc	ra,0xfffff
    80000f4e:	602080e7          	jalr	1538(ra) # 8000054c <mappages>
    80000f52:	02054863          	bltz	a0,80000f82 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f56:	4719                	li	a4,6
    80000f58:	05893683          	ld	a3,88(s2)
    80000f5c:	6605                	lui	a2,0x1
    80000f5e:	020005b7          	lui	a1,0x2000
    80000f62:	15fd                	addi	a1,a1,-1
    80000f64:	05b6                	slli	a1,a1,0xd
    80000f66:	8526                	mv	a0,s1
    80000f68:	fffff097          	auipc	ra,0xfffff
    80000f6c:	5e4080e7          	jalr	1508(ra) # 8000054c <mappages>
    80000f70:	02054163          	bltz	a0,80000f92 <proc_pagetable+0x76>
}
    80000f74:	8526                	mv	a0,s1
    80000f76:	60e2                	ld	ra,24(sp)
    80000f78:	6442                	ld	s0,16(sp)
    80000f7a:	64a2                	ld	s1,8(sp)
    80000f7c:	6902                	ld	s2,0(sp)
    80000f7e:	6105                	addi	sp,sp,32
    80000f80:	8082                	ret
    uvmfree(pagetable, 0);
    80000f82:	4581                	li	a1,0
    80000f84:	8526                	mv	a0,s1
    80000f86:	00000097          	auipc	ra,0x0
    80000f8a:	a54080e7          	jalr	-1452(ra) # 800009da <uvmfree>
    return 0;
    80000f8e:	4481                	li	s1,0
    80000f90:	b7d5                	j	80000f74 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f92:	4681                	li	a3,0
    80000f94:	4605                	li	a2,1
    80000f96:	040005b7          	lui	a1,0x4000
    80000f9a:	15fd                	addi	a1,a1,-1
    80000f9c:	05b2                	slli	a1,a1,0xc
    80000f9e:	8526                	mv	a0,s1
    80000fa0:	fffff097          	auipc	ra,0xfffff
    80000fa4:	772080e7          	jalr	1906(ra) # 80000712 <uvmunmap>
    uvmfree(pagetable, 0);
    80000fa8:	4581                	li	a1,0
    80000faa:	8526                	mv	a0,s1
    80000fac:	00000097          	auipc	ra,0x0
    80000fb0:	a2e080e7          	jalr	-1490(ra) # 800009da <uvmfree>
    return 0;
    80000fb4:	4481                	li	s1,0
    80000fb6:	bf7d                	j	80000f74 <proc_pagetable+0x58>

0000000080000fb8 <proc_freepagetable>:
{
    80000fb8:	1101                	addi	sp,sp,-32
    80000fba:	ec06                	sd	ra,24(sp)
    80000fbc:	e822                	sd	s0,16(sp)
    80000fbe:	e426                	sd	s1,8(sp)
    80000fc0:	e04a                	sd	s2,0(sp)
    80000fc2:	1000                	addi	s0,sp,32
    80000fc4:	84aa                	mv	s1,a0
    80000fc6:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fc8:	4681                	li	a3,0
    80000fca:	4605                	li	a2,1
    80000fcc:	040005b7          	lui	a1,0x4000
    80000fd0:	15fd                	addi	a1,a1,-1
    80000fd2:	05b2                	slli	a1,a1,0xc
    80000fd4:	fffff097          	auipc	ra,0xfffff
    80000fd8:	73e080e7          	jalr	1854(ra) # 80000712 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000fdc:	4681                	li	a3,0
    80000fde:	4605                	li	a2,1
    80000fe0:	020005b7          	lui	a1,0x2000
    80000fe4:	15fd                	addi	a1,a1,-1
    80000fe6:	05b6                	slli	a1,a1,0xd
    80000fe8:	8526                	mv	a0,s1
    80000fea:	fffff097          	auipc	ra,0xfffff
    80000fee:	728080e7          	jalr	1832(ra) # 80000712 <uvmunmap>
  uvmfree(pagetable, sz);
    80000ff2:	85ca                	mv	a1,s2
    80000ff4:	8526                	mv	a0,s1
    80000ff6:	00000097          	auipc	ra,0x0
    80000ffa:	9e4080e7          	jalr	-1564(ra) # 800009da <uvmfree>
}
    80000ffe:	60e2                	ld	ra,24(sp)
    80001000:	6442                	ld	s0,16(sp)
    80001002:	64a2                	ld	s1,8(sp)
    80001004:	6902                	ld	s2,0(sp)
    80001006:	6105                	addi	sp,sp,32
    80001008:	8082                	ret

000000008000100a <freeproc>:
{
    8000100a:	1101                	addi	sp,sp,-32
    8000100c:	ec06                	sd	ra,24(sp)
    8000100e:	e822                	sd	s0,16(sp)
    80001010:	e426                	sd	s1,8(sp)
    80001012:	1000                	addi	s0,sp,32
    80001014:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001016:	6d28                	ld	a0,88(a0)
    80001018:	c509                	beqz	a0,80001022 <freeproc+0x18>
    kfree((void*)p->trapframe);
    8000101a:	fffff097          	auipc	ra,0xfffff
    8000101e:	002080e7          	jalr	2(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001022:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001026:	68a8                	ld	a0,80(s1)
    80001028:	c511                	beqz	a0,80001034 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    8000102a:	64ac                	ld	a1,72(s1)
    8000102c:	00000097          	auipc	ra,0x0
    80001030:	f8c080e7          	jalr	-116(ra) # 80000fb8 <proc_freepagetable>
  p->pagetable = 0;
    80001034:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001038:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    8000103c:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001040:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001044:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001048:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    8000104c:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001050:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001054:	0004ac23          	sw	zero,24(s1)
}
    80001058:	60e2                	ld	ra,24(sp)
    8000105a:	6442                	ld	s0,16(sp)
    8000105c:	64a2                	ld	s1,8(sp)
    8000105e:	6105                	addi	sp,sp,32
    80001060:	8082                	ret

0000000080001062 <allocproc>:
{
    80001062:	1101                	addi	sp,sp,-32
    80001064:	ec06                	sd	ra,24(sp)
    80001066:	e822                	sd	s0,16(sp)
    80001068:	e426                	sd	s1,8(sp)
    8000106a:	e04a                	sd	s2,0(sp)
    8000106c:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    8000106e:	00008497          	auipc	s1,0x8
    80001072:	cf248493          	addi	s1,s1,-782 # 80008d60 <proc>
    80001076:	0000e917          	auipc	s2,0xe
    8000107a:	cea90913          	addi	s2,s2,-790 # 8000ed60 <tickslock>
    acquire(&p->lock);
    8000107e:	8526                	mv	a0,s1
    80001080:	00005097          	auipc	ra,0x5
    80001084:	1f8080e7          	jalr	504(ra) # 80006278 <acquire>
    if(p->state == UNUSED) {
    80001088:	4c9c                	lw	a5,24(s1)
    8000108a:	cf81                	beqz	a5,800010a2 <allocproc+0x40>
      release(&p->lock);
    8000108c:	8526                	mv	a0,s1
    8000108e:	00005097          	auipc	ra,0x5
    80001092:	29e080e7          	jalr	670(ra) # 8000632c <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001096:	18048493          	addi	s1,s1,384
    8000109a:	ff2492e3          	bne	s1,s2,8000107e <allocproc+0x1c>
  return 0;
    8000109e:	4481                	li	s1,0
    800010a0:	a8b9                	j	800010fe <allocproc+0x9c>
  p->pid = allocpid();
    800010a2:	00000097          	auipc	ra,0x0
    800010a6:	e34080e7          	jalr	-460(ra) # 80000ed6 <allocpid>
    800010aa:	d888                	sw	a0,48(s1)
  p->state = USED;
    800010ac:	4785                	li	a5,1
    800010ae:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800010b0:	fffff097          	auipc	ra,0xfffff
    800010b4:	068080e7          	jalr	104(ra) # 80000118 <kalloc>
    800010b8:	892a                	mv	s2,a0
    800010ba:	eca8                	sd	a0,88(s1)
    800010bc:	c921                	beqz	a0,8000110c <allocproc+0xaa>
  p->pagetable = proc_pagetable(p);
    800010be:	8526                	mv	a0,s1
    800010c0:	00000097          	auipc	ra,0x0
    800010c4:	e5c080e7          	jalr	-420(ra) # 80000f1c <proc_pagetable>
    800010c8:	892a                	mv	s2,a0
    800010ca:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800010cc:	cd21                	beqz	a0,80001124 <allocproc+0xc2>
  memset(&p->context, 0, sizeof(p->context));
    800010ce:	07000613          	li	a2,112
    800010d2:	4581                	li	a1,0
    800010d4:	06048513          	addi	a0,s1,96
    800010d8:	fffff097          	auipc	ra,0xfffff
    800010dc:	0a0080e7          	jalr	160(ra) # 80000178 <memset>
  p->context.ra = (uint64)forkret;
    800010e0:	00000797          	auipc	a5,0x0
    800010e4:	db078793          	addi	a5,a5,-592 # 80000e90 <forkret>
    800010e8:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800010ea:	60bc                	ld	a5,64(s1)
    800010ec:	6705                	lui	a4,0x1
    800010ee:	97ba                	add	a5,a5,a4
    800010f0:	f4bc                	sd	a5,104(s1)
  p->interval = 0;
    800010f2:	1604a423          	sw	zero,360(s1)
  p->ticks = 0;
    800010f6:	1604a623          	sw	zero,364(s1)
  p->handler = 0;
    800010fa:	1604b823          	sd	zero,368(s1)
}
    800010fe:	8526                	mv	a0,s1
    80001100:	60e2                	ld	ra,24(sp)
    80001102:	6442                	ld	s0,16(sp)
    80001104:	64a2                	ld	s1,8(sp)
    80001106:	6902                	ld	s2,0(sp)
    80001108:	6105                	addi	sp,sp,32
    8000110a:	8082                	ret
    freeproc(p);
    8000110c:	8526                	mv	a0,s1
    8000110e:	00000097          	auipc	ra,0x0
    80001112:	efc080e7          	jalr	-260(ra) # 8000100a <freeproc>
    release(&p->lock);
    80001116:	8526                	mv	a0,s1
    80001118:	00005097          	auipc	ra,0x5
    8000111c:	214080e7          	jalr	532(ra) # 8000632c <release>
    return 0;
    80001120:	84ca                	mv	s1,s2
    80001122:	bff1                	j	800010fe <allocproc+0x9c>
    freeproc(p);
    80001124:	8526                	mv	a0,s1
    80001126:	00000097          	auipc	ra,0x0
    8000112a:	ee4080e7          	jalr	-284(ra) # 8000100a <freeproc>
    release(&p->lock);
    8000112e:	8526                	mv	a0,s1
    80001130:	00005097          	auipc	ra,0x5
    80001134:	1fc080e7          	jalr	508(ra) # 8000632c <release>
    return 0;
    80001138:	84ca                	mv	s1,s2
    8000113a:	b7d1                	j	800010fe <allocproc+0x9c>

000000008000113c <userinit>:
{
    8000113c:	1101                	addi	sp,sp,-32
    8000113e:	ec06                	sd	ra,24(sp)
    80001140:	e822                	sd	s0,16(sp)
    80001142:	e426                	sd	s1,8(sp)
    80001144:	1000                	addi	s0,sp,32
  p = allocproc();
    80001146:	00000097          	auipc	ra,0x0
    8000114a:	f1c080e7          	jalr	-228(ra) # 80001062 <allocproc>
    8000114e:	84aa                	mv	s1,a0
  initproc = p;
    80001150:	00007797          	auipc	a5,0x7
    80001154:	7aa7b023          	sd	a0,1952(a5) # 800088f0 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001158:	03400613          	li	a2,52
    8000115c:	00007597          	auipc	a1,0x7
    80001160:	72458593          	addi	a1,a1,1828 # 80008880 <initcode>
    80001164:	6928                	ld	a0,80(a0)
    80001166:	fffff097          	auipc	ra,0xfffff
    8000116a:	69e080e7          	jalr	1694(ra) # 80000804 <uvmfirst>
  p->sz = PGSIZE;
    8000116e:	6785                	lui	a5,0x1
    80001170:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001172:	6cb8                	ld	a4,88(s1)
    80001174:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001178:	6cb8                	ld	a4,88(s1)
    8000117a:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    8000117c:	4641                	li	a2,16
    8000117e:	00007597          	auipc	a1,0x7
    80001182:	00258593          	addi	a1,a1,2 # 80008180 <etext+0x180>
    80001186:	15848513          	addi	a0,s1,344
    8000118a:	fffff097          	auipc	ra,0xfffff
    8000118e:	140080e7          	jalr	320(ra) # 800002ca <safestrcpy>
  p->cwd = namei("/");
    80001192:	00007517          	auipc	a0,0x7
    80001196:	ffe50513          	addi	a0,a0,-2 # 80008190 <etext+0x190>
    8000119a:	00002097          	auipc	ra,0x2
    8000119e:	1e6080e7          	jalr	486(ra) # 80003380 <namei>
    800011a2:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800011a6:	478d                	li	a5,3
    800011a8:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800011aa:	8526                	mv	a0,s1
    800011ac:	00005097          	auipc	ra,0x5
    800011b0:	180080e7          	jalr	384(ra) # 8000632c <release>
}
    800011b4:	60e2                	ld	ra,24(sp)
    800011b6:	6442                	ld	s0,16(sp)
    800011b8:	64a2                	ld	s1,8(sp)
    800011ba:	6105                	addi	sp,sp,32
    800011bc:	8082                	ret

00000000800011be <growproc>:
{
    800011be:	1101                	addi	sp,sp,-32
    800011c0:	ec06                	sd	ra,24(sp)
    800011c2:	e822                	sd	s0,16(sp)
    800011c4:	e426                	sd	s1,8(sp)
    800011c6:	e04a                	sd	s2,0(sp)
    800011c8:	1000                	addi	s0,sp,32
    800011ca:	892a                	mv	s2,a0
  struct proc *p = myproc();
    800011cc:	00000097          	auipc	ra,0x0
    800011d0:	c8c080e7          	jalr	-884(ra) # 80000e58 <myproc>
    800011d4:	84aa                	mv	s1,a0
  sz = p->sz;
    800011d6:	652c                	ld	a1,72(a0)
  if(n > 0){
    800011d8:	01204c63          	bgtz	s2,800011f0 <growproc+0x32>
  } else if(n < 0){
    800011dc:	02094663          	bltz	s2,80001208 <growproc+0x4a>
  p->sz = sz;
    800011e0:	e4ac                	sd	a1,72(s1)
  return 0;
    800011e2:	4501                	li	a0,0
}
    800011e4:	60e2                	ld	ra,24(sp)
    800011e6:	6442                	ld	s0,16(sp)
    800011e8:	64a2                	ld	s1,8(sp)
    800011ea:	6902                	ld	s2,0(sp)
    800011ec:	6105                	addi	sp,sp,32
    800011ee:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    800011f0:	4691                	li	a3,4
    800011f2:	00b90633          	add	a2,s2,a1
    800011f6:	6928                	ld	a0,80(a0)
    800011f8:	fffff097          	auipc	ra,0xfffff
    800011fc:	6c6080e7          	jalr	1734(ra) # 800008be <uvmalloc>
    80001200:	85aa                	mv	a1,a0
    80001202:	fd79                	bnez	a0,800011e0 <growproc+0x22>
      return -1;
    80001204:	557d                	li	a0,-1
    80001206:	bff9                	j	800011e4 <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001208:	00b90633          	add	a2,s2,a1
    8000120c:	6928                	ld	a0,80(a0)
    8000120e:	fffff097          	auipc	ra,0xfffff
    80001212:	668080e7          	jalr	1640(ra) # 80000876 <uvmdealloc>
    80001216:	85aa                	mv	a1,a0
    80001218:	b7e1                	j	800011e0 <growproc+0x22>

000000008000121a <fork>:
{
    8000121a:	7179                	addi	sp,sp,-48
    8000121c:	f406                	sd	ra,40(sp)
    8000121e:	f022                	sd	s0,32(sp)
    80001220:	ec26                	sd	s1,24(sp)
    80001222:	e84a                	sd	s2,16(sp)
    80001224:	e44e                	sd	s3,8(sp)
    80001226:	e052                	sd	s4,0(sp)
    80001228:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000122a:	00000097          	auipc	ra,0x0
    8000122e:	c2e080e7          	jalr	-978(ra) # 80000e58 <myproc>
    80001232:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    80001234:	00000097          	auipc	ra,0x0
    80001238:	e2e080e7          	jalr	-466(ra) # 80001062 <allocproc>
    8000123c:	10050b63          	beqz	a0,80001352 <fork+0x138>
    80001240:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001242:	04893603          	ld	a2,72(s2)
    80001246:	692c                	ld	a1,80(a0)
    80001248:	05093503          	ld	a0,80(s2)
    8000124c:	fffff097          	auipc	ra,0xfffff
    80001250:	7c6080e7          	jalr	1990(ra) # 80000a12 <uvmcopy>
    80001254:	04054663          	bltz	a0,800012a0 <fork+0x86>
  np->sz = p->sz;
    80001258:	04893783          	ld	a5,72(s2)
    8000125c:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    80001260:	05893683          	ld	a3,88(s2)
    80001264:	87b6                	mv	a5,a3
    80001266:	0589b703          	ld	a4,88(s3)
    8000126a:	12068693          	addi	a3,a3,288
    8000126e:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001272:	6788                	ld	a0,8(a5)
    80001274:	6b8c                	ld	a1,16(a5)
    80001276:	6f90                	ld	a2,24(a5)
    80001278:	01073023          	sd	a6,0(a4)
    8000127c:	e708                	sd	a0,8(a4)
    8000127e:	eb0c                	sd	a1,16(a4)
    80001280:	ef10                	sd	a2,24(a4)
    80001282:	02078793          	addi	a5,a5,32
    80001286:	02070713          	addi	a4,a4,32
    8000128a:	fed792e3          	bne	a5,a3,8000126e <fork+0x54>
  np->trapframe->a0 = 0;
    8000128e:	0589b783          	ld	a5,88(s3)
    80001292:	0607b823          	sd	zero,112(a5)
    80001296:	0d000493          	li	s1,208
  for(i = 0; i < NOFILE; i++)
    8000129a:	15000a13          	li	s4,336
    8000129e:	a03d                	j	800012cc <fork+0xb2>
    freeproc(np);
    800012a0:	854e                	mv	a0,s3
    800012a2:	00000097          	auipc	ra,0x0
    800012a6:	d68080e7          	jalr	-664(ra) # 8000100a <freeproc>
    release(&np->lock);
    800012aa:	854e                	mv	a0,s3
    800012ac:	00005097          	auipc	ra,0x5
    800012b0:	080080e7          	jalr	128(ra) # 8000632c <release>
    return -1;
    800012b4:	5a7d                	li	s4,-1
    800012b6:	a069                	j	80001340 <fork+0x126>
      np->ofile[i] = filedup(p->ofile[i]);
    800012b8:	00002097          	auipc	ra,0x2
    800012bc:	75e080e7          	jalr	1886(ra) # 80003a16 <filedup>
    800012c0:	009987b3          	add	a5,s3,s1
    800012c4:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    800012c6:	04a1                	addi	s1,s1,8
    800012c8:	01448763          	beq	s1,s4,800012d6 <fork+0xbc>
    if(p->ofile[i])
    800012cc:	009907b3          	add	a5,s2,s1
    800012d0:	6388                	ld	a0,0(a5)
    800012d2:	f17d                	bnez	a0,800012b8 <fork+0x9e>
    800012d4:	bfcd                	j	800012c6 <fork+0xac>
  np->cwd = idup(p->cwd);
    800012d6:	15093503          	ld	a0,336(s2)
    800012da:	00002097          	auipc	ra,0x2
    800012de:	8c2080e7          	jalr	-1854(ra) # 80002b9c <idup>
    800012e2:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800012e6:	4641                	li	a2,16
    800012e8:	15890593          	addi	a1,s2,344
    800012ec:	15898513          	addi	a0,s3,344
    800012f0:	fffff097          	auipc	ra,0xfffff
    800012f4:	fda080e7          	jalr	-38(ra) # 800002ca <safestrcpy>
  pid = np->pid;
    800012f8:	0309aa03          	lw	s4,48(s3)
  release(&np->lock);
    800012fc:	854e                	mv	a0,s3
    800012fe:	00005097          	auipc	ra,0x5
    80001302:	02e080e7          	jalr	46(ra) # 8000632c <release>
  acquire(&wait_lock);
    80001306:	00007497          	auipc	s1,0x7
    8000130a:	64248493          	addi	s1,s1,1602 # 80008948 <wait_lock>
    8000130e:	8526                	mv	a0,s1
    80001310:	00005097          	auipc	ra,0x5
    80001314:	f68080e7          	jalr	-152(ra) # 80006278 <acquire>
  np->parent = p;
    80001318:	0329bc23          	sd	s2,56(s3)
  release(&wait_lock);
    8000131c:	8526                	mv	a0,s1
    8000131e:	00005097          	auipc	ra,0x5
    80001322:	00e080e7          	jalr	14(ra) # 8000632c <release>
  acquire(&np->lock);
    80001326:	854e                	mv	a0,s3
    80001328:	00005097          	auipc	ra,0x5
    8000132c:	f50080e7          	jalr	-176(ra) # 80006278 <acquire>
  np->state = RUNNABLE;
    80001330:	478d                	li	a5,3
    80001332:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001336:	854e                	mv	a0,s3
    80001338:	00005097          	auipc	ra,0x5
    8000133c:	ff4080e7          	jalr	-12(ra) # 8000632c <release>
}
    80001340:	8552                	mv	a0,s4
    80001342:	70a2                	ld	ra,40(sp)
    80001344:	7402                	ld	s0,32(sp)
    80001346:	64e2                	ld	s1,24(sp)
    80001348:	6942                	ld	s2,16(sp)
    8000134a:	69a2                	ld	s3,8(sp)
    8000134c:	6a02                	ld	s4,0(sp)
    8000134e:	6145                	addi	sp,sp,48
    80001350:	8082                	ret
    return -1;
    80001352:	5a7d                	li	s4,-1
    80001354:	b7f5                	j	80001340 <fork+0x126>

0000000080001356 <scheduler>:
{
    80001356:	7139                	addi	sp,sp,-64
    80001358:	fc06                	sd	ra,56(sp)
    8000135a:	f822                	sd	s0,48(sp)
    8000135c:	f426                	sd	s1,40(sp)
    8000135e:	f04a                	sd	s2,32(sp)
    80001360:	ec4e                	sd	s3,24(sp)
    80001362:	e852                	sd	s4,16(sp)
    80001364:	e456                	sd	s5,8(sp)
    80001366:	e05a                	sd	s6,0(sp)
    80001368:	0080                	addi	s0,sp,64
    8000136a:	8792                	mv	a5,tp
  int id = r_tp();
    8000136c:	2781                	sext.w	a5,a5
  c->proc = 0;
    8000136e:	00779a93          	slli	s5,a5,0x7
    80001372:	00007717          	auipc	a4,0x7
    80001376:	5be70713          	addi	a4,a4,1470 # 80008930 <pid_lock>
    8000137a:	9756                	add	a4,a4,s5
    8000137c:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001380:	00007717          	auipc	a4,0x7
    80001384:	5e870713          	addi	a4,a4,1512 # 80008968 <cpus+0x8>
    80001388:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    8000138a:	498d                	li	s3,3
        p->state = RUNNING;
    8000138c:	4b11                	li	s6,4
        c->proc = p;
    8000138e:	079e                	slli	a5,a5,0x7
    80001390:	00007a17          	auipc	s4,0x7
    80001394:	5a0a0a13          	addi	s4,s4,1440 # 80008930 <pid_lock>
    80001398:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    8000139a:	0000e917          	auipc	s2,0xe
    8000139e:	9c690913          	addi	s2,s2,-1594 # 8000ed60 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013a2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013a6:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800013aa:	10079073          	csrw	sstatus,a5
    800013ae:	00008497          	auipc	s1,0x8
    800013b2:	9b248493          	addi	s1,s1,-1614 # 80008d60 <proc>
    800013b6:	a03d                	j	800013e4 <scheduler+0x8e>
        p->state = RUNNING;
    800013b8:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    800013bc:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800013c0:	06048593          	addi	a1,s1,96
    800013c4:	8556                	mv	a0,s5
    800013c6:	00000097          	auipc	ra,0x0
    800013ca:	6a4080e7          	jalr	1700(ra) # 80001a6a <swtch>
        c->proc = 0;
    800013ce:	020a3823          	sd	zero,48(s4)
      release(&p->lock);
    800013d2:	8526                	mv	a0,s1
    800013d4:	00005097          	auipc	ra,0x5
    800013d8:	f58080e7          	jalr	-168(ra) # 8000632c <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800013dc:	18048493          	addi	s1,s1,384
    800013e0:	fd2481e3          	beq	s1,s2,800013a2 <scheduler+0x4c>
      acquire(&p->lock);
    800013e4:	8526                	mv	a0,s1
    800013e6:	00005097          	auipc	ra,0x5
    800013ea:	e92080e7          	jalr	-366(ra) # 80006278 <acquire>
      if(p->state == RUNNABLE) {
    800013ee:	4c9c                	lw	a5,24(s1)
    800013f0:	ff3791e3          	bne	a5,s3,800013d2 <scheduler+0x7c>
    800013f4:	b7d1                	j	800013b8 <scheduler+0x62>

00000000800013f6 <sched>:
{
    800013f6:	7179                	addi	sp,sp,-48
    800013f8:	f406                	sd	ra,40(sp)
    800013fa:	f022                	sd	s0,32(sp)
    800013fc:	ec26                	sd	s1,24(sp)
    800013fe:	e84a                	sd	s2,16(sp)
    80001400:	e44e                	sd	s3,8(sp)
    80001402:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001404:	00000097          	auipc	ra,0x0
    80001408:	a54080e7          	jalr	-1452(ra) # 80000e58 <myproc>
    8000140c:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    8000140e:	00005097          	auipc	ra,0x5
    80001412:	df0080e7          	jalr	-528(ra) # 800061fe <holding>
    80001416:	c93d                	beqz	a0,8000148c <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001418:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000141a:	2781                	sext.w	a5,a5
    8000141c:	079e                	slli	a5,a5,0x7
    8000141e:	00007717          	auipc	a4,0x7
    80001422:	51270713          	addi	a4,a4,1298 # 80008930 <pid_lock>
    80001426:	97ba                	add	a5,a5,a4
    80001428:	0a87a703          	lw	a4,168(a5)
    8000142c:	4785                	li	a5,1
    8000142e:	06f71763          	bne	a4,a5,8000149c <sched+0xa6>
  if(p->state == RUNNING)
    80001432:	4c98                	lw	a4,24(s1)
    80001434:	4791                	li	a5,4
    80001436:	06f70b63          	beq	a4,a5,800014ac <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000143a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000143e:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001440:	efb5                	bnez	a5,800014bc <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001442:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001444:	00007917          	auipc	s2,0x7
    80001448:	4ec90913          	addi	s2,s2,1260 # 80008930 <pid_lock>
    8000144c:	2781                	sext.w	a5,a5
    8000144e:	079e                	slli	a5,a5,0x7
    80001450:	97ca                	add	a5,a5,s2
    80001452:	0ac7a983          	lw	s3,172(a5)
    80001456:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001458:	2781                	sext.w	a5,a5
    8000145a:	079e                	slli	a5,a5,0x7
    8000145c:	00007597          	auipc	a1,0x7
    80001460:	50c58593          	addi	a1,a1,1292 # 80008968 <cpus+0x8>
    80001464:	95be                	add	a1,a1,a5
    80001466:	06048513          	addi	a0,s1,96
    8000146a:	00000097          	auipc	ra,0x0
    8000146e:	600080e7          	jalr	1536(ra) # 80001a6a <swtch>
    80001472:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001474:	2781                	sext.w	a5,a5
    80001476:	079e                	slli	a5,a5,0x7
    80001478:	97ca                	add	a5,a5,s2
    8000147a:	0b37a623          	sw	s3,172(a5)
}
    8000147e:	70a2                	ld	ra,40(sp)
    80001480:	7402                	ld	s0,32(sp)
    80001482:	64e2                	ld	s1,24(sp)
    80001484:	6942                	ld	s2,16(sp)
    80001486:	69a2                	ld	s3,8(sp)
    80001488:	6145                	addi	sp,sp,48
    8000148a:	8082                	ret
    panic("sched p->lock");
    8000148c:	00007517          	auipc	a0,0x7
    80001490:	d0c50513          	addi	a0,a0,-756 # 80008198 <etext+0x198>
    80001494:	00005097          	auipc	ra,0x5
    80001498:	83e080e7          	jalr	-1986(ra) # 80005cd2 <panic>
    panic("sched locks");
    8000149c:	00007517          	auipc	a0,0x7
    800014a0:	d0c50513          	addi	a0,a0,-756 # 800081a8 <etext+0x1a8>
    800014a4:	00005097          	auipc	ra,0x5
    800014a8:	82e080e7          	jalr	-2002(ra) # 80005cd2 <panic>
    panic("sched running");
    800014ac:	00007517          	auipc	a0,0x7
    800014b0:	d0c50513          	addi	a0,a0,-756 # 800081b8 <etext+0x1b8>
    800014b4:	00005097          	auipc	ra,0x5
    800014b8:	81e080e7          	jalr	-2018(ra) # 80005cd2 <panic>
    panic("sched interruptible");
    800014bc:	00007517          	auipc	a0,0x7
    800014c0:	d0c50513          	addi	a0,a0,-756 # 800081c8 <etext+0x1c8>
    800014c4:	00005097          	auipc	ra,0x5
    800014c8:	80e080e7          	jalr	-2034(ra) # 80005cd2 <panic>

00000000800014cc <yield>:
{
    800014cc:	1101                	addi	sp,sp,-32
    800014ce:	ec06                	sd	ra,24(sp)
    800014d0:	e822                	sd	s0,16(sp)
    800014d2:	e426                	sd	s1,8(sp)
    800014d4:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800014d6:	00000097          	auipc	ra,0x0
    800014da:	982080e7          	jalr	-1662(ra) # 80000e58 <myproc>
    800014de:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800014e0:	00005097          	auipc	ra,0x5
    800014e4:	d98080e7          	jalr	-616(ra) # 80006278 <acquire>
  p->state = RUNNABLE;
    800014e8:	478d                	li	a5,3
    800014ea:	cc9c                	sw	a5,24(s1)
  sched();
    800014ec:	00000097          	auipc	ra,0x0
    800014f0:	f0a080e7          	jalr	-246(ra) # 800013f6 <sched>
  release(&p->lock);
    800014f4:	8526                	mv	a0,s1
    800014f6:	00005097          	auipc	ra,0x5
    800014fa:	e36080e7          	jalr	-458(ra) # 8000632c <release>
}
    800014fe:	60e2                	ld	ra,24(sp)
    80001500:	6442                	ld	s0,16(sp)
    80001502:	64a2                	ld	s1,8(sp)
    80001504:	6105                	addi	sp,sp,32
    80001506:	8082                	ret

0000000080001508 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001508:	7179                	addi	sp,sp,-48
    8000150a:	f406                	sd	ra,40(sp)
    8000150c:	f022                	sd	s0,32(sp)
    8000150e:	ec26                	sd	s1,24(sp)
    80001510:	e84a                	sd	s2,16(sp)
    80001512:	e44e                	sd	s3,8(sp)
    80001514:	1800                	addi	s0,sp,48
    80001516:	89aa                	mv	s3,a0
    80001518:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000151a:	00000097          	auipc	ra,0x0
    8000151e:	93e080e7          	jalr	-1730(ra) # 80000e58 <myproc>
    80001522:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001524:	00005097          	auipc	ra,0x5
    80001528:	d54080e7          	jalr	-684(ra) # 80006278 <acquire>
  release(lk);
    8000152c:	854a                	mv	a0,s2
    8000152e:	00005097          	auipc	ra,0x5
    80001532:	dfe080e7          	jalr	-514(ra) # 8000632c <release>

  // Go to sleep.
  p->chan = chan;
    80001536:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000153a:	4789                	li	a5,2
    8000153c:	cc9c                	sw	a5,24(s1)

  sched();
    8000153e:	00000097          	auipc	ra,0x0
    80001542:	eb8080e7          	jalr	-328(ra) # 800013f6 <sched>

  // Tidy up.
  p->chan = 0;
    80001546:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000154a:	8526                	mv	a0,s1
    8000154c:	00005097          	auipc	ra,0x5
    80001550:	de0080e7          	jalr	-544(ra) # 8000632c <release>
  acquire(lk);
    80001554:	854a                	mv	a0,s2
    80001556:	00005097          	auipc	ra,0x5
    8000155a:	d22080e7          	jalr	-734(ra) # 80006278 <acquire>
}
    8000155e:	70a2                	ld	ra,40(sp)
    80001560:	7402                	ld	s0,32(sp)
    80001562:	64e2                	ld	s1,24(sp)
    80001564:	6942                	ld	s2,16(sp)
    80001566:	69a2                	ld	s3,8(sp)
    80001568:	6145                	addi	sp,sp,48
    8000156a:	8082                	ret

000000008000156c <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    8000156c:	7139                	addi	sp,sp,-64
    8000156e:	fc06                	sd	ra,56(sp)
    80001570:	f822                	sd	s0,48(sp)
    80001572:	f426                	sd	s1,40(sp)
    80001574:	f04a                	sd	s2,32(sp)
    80001576:	ec4e                	sd	s3,24(sp)
    80001578:	e852                	sd	s4,16(sp)
    8000157a:	e456                	sd	s5,8(sp)
    8000157c:	0080                	addi	s0,sp,64
    8000157e:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001580:	00007497          	auipc	s1,0x7
    80001584:	7e048493          	addi	s1,s1,2016 # 80008d60 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001588:	4989                	li	s3,2
        p->state = RUNNABLE;
    8000158a:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    8000158c:	0000d917          	auipc	s2,0xd
    80001590:	7d490913          	addi	s2,s2,2004 # 8000ed60 <tickslock>
    80001594:	a821                	j	800015ac <wakeup+0x40>
        p->state = RUNNABLE;
    80001596:	0154ac23          	sw	s5,24(s1)
      }
      release(&p->lock);
    8000159a:	8526                	mv	a0,s1
    8000159c:	00005097          	auipc	ra,0x5
    800015a0:	d90080e7          	jalr	-624(ra) # 8000632c <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800015a4:	18048493          	addi	s1,s1,384
    800015a8:	03248463          	beq	s1,s2,800015d0 <wakeup+0x64>
    if(p != myproc()){
    800015ac:	00000097          	auipc	ra,0x0
    800015b0:	8ac080e7          	jalr	-1876(ra) # 80000e58 <myproc>
    800015b4:	fea488e3          	beq	s1,a0,800015a4 <wakeup+0x38>
      acquire(&p->lock);
    800015b8:	8526                	mv	a0,s1
    800015ba:	00005097          	auipc	ra,0x5
    800015be:	cbe080e7          	jalr	-834(ra) # 80006278 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800015c2:	4c9c                	lw	a5,24(s1)
    800015c4:	fd379be3          	bne	a5,s3,8000159a <wakeup+0x2e>
    800015c8:	709c                	ld	a5,32(s1)
    800015ca:	fd4798e3          	bne	a5,s4,8000159a <wakeup+0x2e>
    800015ce:	b7e1                	j	80001596 <wakeup+0x2a>
    }
  }
}
    800015d0:	70e2                	ld	ra,56(sp)
    800015d2:	7442                	ld	s0,48(sp)
    800015d4:	74a2                	ld	s1,40(sp)
    800015d6:	7902                	ld	s2,32(sp)
    800015d8:	69e2                	ld	s3,24(sp)
    800015da:	6a42                	ld	s4,16(sp)
    800015dc:	6aa2                	ld	s5,8(sp)
    800015de:	6121                	addi	sp,sp,64
    800015e0:	8082                	ret

00000000800015e2 <reparent>:
{
    800015e2:	7179                	addi	sp,sp,-48
    800015e4:	f406                	sd	ra,40(sp)
    800015e6:	f022                	sd	s0,32(sp)
    800015e8:	ec26                	sd	s1,24(sp)
    800015ea:	e84a                	sd	s2,16(sp)
    800015ec:	e44e                	sd	s3,8(sp)
    800015ee:	e052                	sd	s4,0(sp)
    800015f0:	1800                	addi	s0,sp,48
    800015f2:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800015f4:	00007497          	auipc	s1,0x7
    800015f8:	76c48493          	addi	s1,s1,1900 # 80008d60 <proc>
      pp->parent = initproc;
    800015fc:	00007a17          	auipc	s4,0x7
    80001600:	2f4a0a13          	addi	s4,s4,756 # 800088f0 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001604:	0000d997          	auipc	s3,0xd
    80001608:	75c98993          	addi	s3,s3,1884 # 8000ed60 <tickslock>
    8000160c:	a029                	j	80001616 <reparent+0x34>
    8000160e:	18048493          	addi	s1,s1,384
    80001612:	01348d63          	beq	s1,s3,8000162c <reparent+0x4a>
    if(pp->parent == p){
    80001616:	7c9c                	ld	a5,56(s1)
    80001618:	ff279be3          	bne	a5,s2,8000160e <reparent+0x2c>
      pp->parent = initproc;
    8000161c:	000a3503          	ld	a0,0(s4)
    80001620:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001622:	00000097          	auipc	ra,0x0
    80001626:	f4a080e7          	jalr	-182(ra) # 8000156c <wakeup>
    8000162a:	b7d5                	j	8000160e <reparent+0x2c>
}
    8000162c:	70a2                	ld	ra,40(sp)
    8000162e:	7402                	ld	s0,32(sp)
    80001630:	64e2                	ld	s1,24(sp)
    80001632:	6942                	ld	s2,16(sp)
    80001634:	69a2                	ld	s3,8(sp)
    80001636:	6a02                	ld	s4,0(sp)
    80001638:	6145                	addi	sp,sp,48
    8000163a:	8082                	ret

000000008000163c <exit>:
{
    8000163c:	7179                	addi	sp,sp,-48
    8000163e:	f406                	sd	ra,40(sp)
    80001640:	f022                	sd	s0,32(sp)
    80001642:	ec26                	sd	s1,24(sp)
    80001644:	e84a                	sd	s2,16(sp)
    80001646:	e44e                	sd	s3,8(sp)
    80001648:	e052                	sd	s4,0(sp)
    8000164a:	1800                	addi	s0,sp,48
    8000164c:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000164e:	00000097          	auipc	ra,0x0
    80001652:	80a080e7          	jalr	-2038(ra) # 80000e58 <myproc>
    80001656:	89aa                	mv	s3,a0
  if(p == initproc)
    80001658:	00007797          	auipc	a5,0x7
    8000165c:	2987b783          	ld	a5,664(a5) # 800088f0 <initproc>
    80001660:	0d050493          	addi	s1,a0,208
    80001664:	15050913          	addi	s2,a0,336
    80001668:	02a79363          	bne	a5,a0,8000168e <exit+0x52>
    panic("init exiting");
    8000166c:	00007517          	auipc	a0,0x7
    80001670:	b7450513          	addi	a0,a0,-1164 # 800081e0 <etext+0x1e0>
    80001674:	00004097          	auipc	ra,0x4
    80001678:	65e080e7          	jalr	1630(ra) # 80005cd2 <panic>
      fileclose(f);
    8000167c:	00002097          	auipc	ra,0x2
    80001680:	3ec080e7          	jalr	1004(ra) # 80003a68 <fileclose>
      p->ofile[fd] = 0;
    80001684:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80001688:	04a1                	addi	s1,s1,8
    8000168a:	01248563          	beq	s1,s2,80001694 <exit+0x58>
    if(p->ofile[fd]){
    8000168e:	6088                	ld	a0,0(s1)
    80001690:	f575                	bnez	a0,8000167c <exit+0x40>
    80001692:	bfdd                	j	80001688 <exit+0x4c>
  begin_op();
    80001694:	00002097          	auipc	ra,0x2
    80001698:	f08080e7          	jalr	-248(ra) # 8000359c <begin_op>
  iput(p->cwd);
    8000169c:	1509b503          	ld	a0,336(s3)
    800016a0:	00001097          	auipc	ra,0x1
    800016a4:	6f4080e7          	jalr	1780(ra) # 80002d94 <iput>
  end_op();
    800016a8:	00002097          	auipc	ra,0x2
    800016ac:	f74080e7          	jalr	-140(ra) # 8000361c <end_op>
  p->cwd = 0;
    800016b0:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800016b4:	00007497          	auipc	s1,0x7
    800016b8:	29448493          	addi	s1,s1,660 # 80008948 <wait_lock>
    800016bc:	8526                	mv	a0,s1
    800016be:	00005097          	auipc	ra,0x5
    800016c2:	bba080e7          	jalr	-1094(ra) # 80006278 <acquire>
  reparent(p);
    800016c6:	854e                	mv	a0,s3
    800016c8:	00000097          	auipc	ra,0x0
    800016cc:	f1a080e7          	jalr	-230(ra) # 800015e2 <reparent>
  wakeup(p->parent);
    800016d0:	0389b503          	ld	a0,56(s3)
    800016d4:	00000097          	auipc	ra,0x0
    800016d8:	e98080e7          	jalr	-360(ra) # 8000156c <wakeup>
  acquire(&p->lock);
    800016dc:	854e                	mv	a0,s3
    800016de:	00005097          	auipc	ra,0x5
    800016e2:	b9a080e7          	jalr	-1126(ra) # 80006278 <acquire>
  p->xstate = status;
    800016e6:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800016ea:	4795                	li	a5,5
    800016ec:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800016f0:	8526                	mv	a0,s1
    800016f2:	00005097          	auipc	ra,0x5
    800016f6:	c3a080e7          	jalr	-966(ra) # 8000632c <release>
  sched();
    800016fa:	00000097          	auipc	ra,0x0
    800016fe:	cfc080e7          	jalr	-772(ra) # 800013f6 <sched>
  panic("zombie exit");
    80001702:	00007517          	auipc	a0,0x7
    80001706:	aee50513          	addi	a0,a0,-1298 # 800081f0 <etext+0x1f0>
    8000170a:	00004097          	auipc	ra,0x4
    8000170e:	5c8080e7          	jalr	1480(ra) # 80005cd2 <panic>

0000000080001712 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001712:	7179                	addi	sp,sp,-48
    80001714:	f406                	sd	ra,40(sp)
    80001716:	f022                	sd	s0,32(sp)
    80001718:	ec26                	sd	s1,24(sp)
    8000171a:	e84a                	sd	s2,16(sp)
    8000171c:	e44e                	sd	s3,8(sp)
    8000171e:	1800                	addi	s0,sp,48
    80001720:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001722:	00007497          	auipc	s1,0x7
    80001726:	63e48493          	addi	s1,s1,1598 # 80008d60 <proc>
    8000172a:	0000d997          	auipc	s3,0xd
    8000172e:	63698993          	addi	s3,s3,1590 # 8000ed60 <tickslock>
    acquire(&p->lock);
    80001732:	8526                	mv	a0,s1
    80001734:	00005097          	auipc	ra,0x5
    80001738:	b44080e7          	jalr	-1212(ra) # 80006278 <acquire>
    if(p->pid == pid){
    8000173c:	589c                	lw	a5,48(s1)
    8000173e:	01278d63          	beq	a5,s2,80001758 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001742:	8526                	mv	a0,s1
    80001744:	00005097          	auipc	ra,0x5
    80001748:	be8080e7          	jalr	-1048(ra) # 8000632c <release>
  for(p = proc; p < &proc[NPROC]; p++){
    8000174c:	18048493          	addi	s1,s1,384
    80001750:	ff3491e3          	bne	s1,s3,80001732 <kill+0x20>
  }
  return -1;
    80001754:	557d                	li	a0,-1
    80001756:	a829                	j	80001770 <kill+0x5e>
      p->killed = 1;
    80001758:	4785                	li	a5,1
    8000175a:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    8000175c:	4c98                	lw	a4,24(s1)
    8000175e:	4789                	li	a5,2
    80001760:	00f70f63          	beq	a4,a5,8000177e <kill+0x6c>
      release(&p->lock);
    80001764:	8526                	mv	a0,s1
    80001766:	00005097          	auipc	ra,0x5
    8000176a:	bc6080e7          	jalr	-1082(ra) # 8000632c <release>
      return 0;
    8000176e:	4501                	li	a0,0
}
    80001770:	70a2                	ld	ra,40(sp)
    80001772:	7402                	ld	s0,32(sp)
    80001774:	64e2                	ld	s1,24(sp)
    80001776:	6942                	ld	s2,16(sp)
    80001778:	69a2                	ld	s3,8(sp)
    8000177a:	6145                	addi	sp,sp,48
    8000177c:	8082                	ret
        p->state = RUNNABLE;
    8000177e:	478d                	li	a5,3
    80001780:	cc9c                	sw	a5,24(s1)
    80001782:	b7cd                	j	80001764 <kill+0x52>

0000000080001784 <setkilled>:

void
setkilled(struct proc *p)
{
    80001784:	1101                	addi	sp,sp,-32
    80001786:	ec06                	sd	ra,24(sp)
    80001788:	e822                	sd	s0,16(sp)
    8000178a:	e426                	sd	s1,8(sp)
    8000178c:	1000                	addi	s0,sp,32
    8000178e:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001790:	00005097          	auipc	ra,0x5
    80001794:	ae8080e7          	jalr	-1304(ra) # 80006278 <acquire>
  p->killed = 1;
    80001798:	4785                	li	a5,1
    8000179a:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    8000179c:	8526                	mv	a0,s1
    8000179e:	00005097          	auipc	ra,0x5
    800017a2:	b8e080e7          	jalr	-1138(ra) # 8000632c <release>
}
    800017a6:	60e2                	ld	ra,24(sp)
    800017a8:	6442                	ld	s0,16(sp)
    800017aa:	64a2                	ld	s1,8(sp)
    800017ac:	6105                	addi	sp,sp,32
    800017ae:	8082                	ret

00000000800017b0 <killed>:

int
killed(struct proc *p)
{
    800017b0:	1101                	addi	sp,sp,-32
    800017b2:	ec06                	sd	ra,24(sp)
    800017b4:	e822                	sd	s0,16(sp)
    800017b6:	e426                	sd	s1,8(sp)
    800017b8:	e04a                	sd	s2,0(sp)
    800017ba:	1000                	addi	s0,sp,32
    800017bc:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    800017be:	00005097          	auipc	ra,0x5
    800017c2:	aba080e7          	jalr	-1350(ra) # 80006278 <acquire>
  k = p->killed;
    800017c6:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    800017ca:	8526                	mv	a0,s1
    800017cc:	00005097          	auipc	ra,0x5
    800017d0:	b60080e7          	jalr	-1184(ra) # 8000632c <release>
  return k;
}
    800017d4:	854a                	mv	a0,s2
    800017d6:	60e2                	ld	ra,24(sp)
    800017d8:	6442                	ld	s0,16(sp)
    800017da:	64a2                	ld	s1,8(sp)
    800017dc:	6902                	ld	s2,0(sp)
    800017de:	6105                	addi	sp,sp,32
    800017e0:	8082                	ret

00000000800017e2 <wait>:
{
    800017e2:	715d                	addi	sp,sp,-80
    800017e4:	e486                	sd	ra,72(sp)
    800017e6:	e0a2                	sd	s0,64(sp)
    800017e8:	fc26                	sd	s1,56(sp)
    800017ea:	f84a                	sd	s2,48(sp)
    800017ec:	f44e                	sd	s3,40(sp)
    800017ee:	f052                	sd	s4,32(sp)
    800017f0:	ec56                	sd	s5,24(sp)
    800017f2:	e85a                	sd	s6,16(sp)
    800017f4:	e45e                	sd	s7,8(sp)
    800017f6:	e062                	sd	s8,0(sp)
    800017f8:	0880                	addi	s0,sp,80
    800017fa:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800017fc:	fffff097          	auipc	ra,0xfffff
    80001800:	65c080e7          	jalr	1628(ra) # 80000e58 <myproc>
    80001804:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001806:	00007517          	auipc	a0,0x7
    8000180a:	14250513          	addi	a0,a0,322 # 80008948 <wait_lock>
    8000180e:	00005097          	auipc	ra,0x5
    80001812:	a6a080e7          	jalr	-1430(ra) # 80006278 <acquire>
    havekids = 0;
    80001816:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    80001818:	4a15                	li	s4,5
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000181a:	0000d997          	auipc	s3,0xd
    8000181e:	54698993          	addi	s3,s3,1350 # 8000ed60 <tickslock>
        havekids = 1;
    80001822:	4a85                	li	s5,1
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001824:	00007c17          	auipc	s8,0x7
    80001828:	124c0c13          	addi	s8,s8,292 # 80008948 <wait_lock>
    havekids = 0;
    8000182c:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000182e:	00007497          	auipc	s1,0x7
    80001832:	53248493          	addi	s1,s1,1330 # 80008d60 <proc>
    80001836:	a0bd                	j	800018a4 <wait+0xc2>
          pid = pp->pid;
    80001838:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    8000183c:	000b0e63          	beqz	s6,80001858 <wait+0x76>
    80001840:	4691                	li	a3,4
    80001842:	02c48613          	addi	a2,s1,44
    80001846:	85da                	mv	a1,s6
    80001848:	05093503          	ld	a0,80(s2)
    8000184c:	fffff097          	auipc	ra,0xfffff
    80001850:	2ca080e7          	jalr	714(ra) # 80000b16 <copyout>
    80001854:	02054563          	bltz	a0,8000187e <wait+0x9c>
          freeproc(pp);
    80001858:	8526                	mv	a0,s1
    8000185a:	fffff097          	auipc	ra,0xfffff
    8000185e:	7b0080e7          	jalr	1968(ra) # 8000100a <freeproc>
          release(&pp->lock);
    80001862:	8526                	mv	a0,s1
    80001864:	00005097          	auipc	ra,0x5
    80001868:	ac8080e7          	jalr	-1336(ra) # 8000632c <release>
          release(&wait_lock);
    8000186c:	00007517          	auipc	a0,0x7
    80001870:	0dc50513          	addi	a0,a0,220 # 80008948 <wait_lock>
    80001874:	00005097          	auipc	ra,0x5
    80001878:	ab8080e7          	jalr	-1352(ra) # 8000632c <release>
          return pid;
    8000187c:	a0b5                	j	800018e8 <wait+0x106>
            release(&pp->lock);
    8000187e:	8526                	mv	a0,s1
    80001880:	00005097          	auipc	ra,0x5
    80001884:	aac080e7          	jalr	-1364(ra) # 8000632c <release>
            release(&wait_lock);
    80001888:	00007517          	auipc	a0,0x7
    8000188c:	0c050513          	addi	a0,a0,192 # 80008948 <wait_lock>
    80001890:	00005097          	auipc	ra,0x5
    80001894:	a9c080e7          	jalr	-1380(ra) # 8000632c <release>
            return -1;
    80001898:	59fd                	li	s3,-1
    8000189a:	a0b9                	j	800018e8 <wait+0x106>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000189c:	18048493          	addi	s1,s1,384
    800018a0:	03348463          	beq	s1,s3,800018c8 <wait+0xe6>
      if(pp->parent == p){
    800018a4:	7c9c                	ld	a5,56(s1)
    800018a6:	ff279be3          	bne	a5,s2,8000189c <wait+0xba>
        acquire(&pp->lock);
    800018aa:	8526                	mv	a0,s1
    800018ac:	00005097          	auipc	ra,0x5
    800018b0:	9cc080e7          	jalr	-1588(ra) # 80006278 <acquire>
        if(pp->state == ZOMBIE){
    800018b4:	4c9c                	lw	a5,24(s1)
    800018b6:	f94781e3          	beq	a5,s4,80001838 <wait+0x56>
        release(&pp->lock);
    800018ba:	8526                	mv	a0,s1
    800018bc:	00005097          	auipc	ra,0x5
    800018c0:	a70080e7          	jalr	-1424(ra) # 8000632c <release>
        havekids = 1;
    800018c4:	8756                	mv	a4,s5
    800018c6:	bfd9                	j	8000189c <wait+0xba>
    if(!havekids || killed(p)){
    800018c8:	c719                	beqz	a4,800018d6 <wait+0xf4>
    800018ca:	854a                	mv	a0,s2
    800018cc:	00000097          	auipc	ra,0x0
    800018d0:	ee4080e7          	jalr	-284(ra) # 800017b0 <killed>
    800018d4:	c51d                	beqz	a0,80001902 <wait+0x120>
      release(&wait_lock);
    800018d6:	00007517          	auipc	a0,0x7
    800018da:	07250513          	addi	a0,a0,114 # 80008948 <wait_lock>
    800018de:	00005097          	auipc	ra,0x5
    800018e2:	a4e080e7          	jalr	-1458(ra) # 8000632c <release>
      return -1;
    800018e6:	59fd                	li	s3,-1
}
    800018e8:	854e                	mv	a0,s3
    800018ea:	60a6                	ld	ra,72(sp)
    800018ec:	6406                	ld	s0,64(sp)
    800018ee:	74e2                	ld	s1,56(sp)
    800018f0:	7942                	ld	s2,48(sp)
    800018f2:	79a2                	ld	s3,40(sp)
    800018f4:	7a02                	ld	s4,32(sp)
    800018f6:	6ae2                	ld	s5,24(sp)
    800018f8:	6b42                	ld	s6,16(sp)
    800018fa:	6ba2                	ld	s7,8(sp)
    800018fc:	6c02                	ld	s8,0(sp)
    800018fe:	6161                	addi	sp,sp,80
    80001900:	8082                	ret
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001902:	85e2                	mv	a1,s8
    80001904:	854a                	mv	a0,s2
    80001906:	00000097          	auipc	ra,0x0
    8000190a:	c02080e7          	jalr	-1022(ra) # 80001508 <sleep>
    havekids = 0;
    8000190e:	bf39                	j	8000182c <wait+0x4a>

0000000080001910 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001910:	7179                	addi	sp,sp,-48
    80001912:	f406                	sd	ra,40(sp)
    80001914:	f022                	sd	s0,32(sp)
    80001916:	ec26                	sd	s1,24(sp)
    80001918:	e84a                	sd	s2,16(sp)
    8000191a:	e44e                	sd	s3,8(sp)
    8000191c:	e052                	sd	s4,0(sp)
    8000191e:	1800                	addi	s0,sp,48
    80001920:	84aa                	mv	s1,a0
    80001922:	892e                	mv	s2,a1
    80001924:	89b2                	mv	s3,a2
    80001926:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001928:	fffff097          	auipc	ra,0xfffff
    8000192c:	530080e7          	jalr	1328(ra) # 80000e58 <myproc>
  if(user_dst){
    80001930:	c08d                	beqz	s1,80001952 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001932:	86d2                	mv	a3,s4
    80001934:	864e                	mv	a2,s3
    80001936:	85ca                	mv	a1,s2
    80001938:	6928                	ld	a0,80(a0)
    8000193a:	fffff097          	auipc	ra,0xfffff
    8000193e:	1dc080e7          	jalr	476(ra) # 80000b16 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001942:	70a2                	ld	ra,40(sp)
    80001944:	7402                	ld	s0,32(sp)
    80001946:	64e2                	ld	s1,24(sp)
    80001948:	6942                	ld	s2,16(sp)
    8000194a:	69a2                	ld	s3,8(sp)
    8000194c:	6a02                	ld	s4,0(sp)
    8000194e:	6145                	addi	sp,sp,48
    80001950:	8082                	ret
    memmove((char *)dst, src, len);
    80001952:	000a061b          	sext.w	a2,s4
    80001956:	85ce                	mv	a1,s3
    80001958:	854a                	mv	a0,s2
    8000195a:	fffff097          	auipc	ra,0xfffff
    8000195e:	87e080e7          	jalr	-1922(ra) # 800001d8 <memmove>
    return 0;
    80001962:	8526                	mv	a0,s1
    80001964:	bff9                	j	80001942 <either_copyout+0x32>

0000000080001966 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001966:	7179                	addi	sp,sp,-48
    80001968:	f406                	sd	ra,40(sp)
    8000196a:	f022                	sd	s0,32(sp)
    8000196c:	ec26                	sd	s1,24(sp)
    8000196e:	e84a                	sd	s2,16(sp)
    80001970:	e44e                	sd	s3,8(sp)
    80001972:	e052                	sd	s4,0(sp)
    80001974:	1800                	addi	s0,sp,48
    80001976:	892a                	mv	s2,a0
    80001978:	84ae                	mv	s1,a1
    8000197a:	89b2                	mv	s3,a2
    8000197c:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000197e:	fffff097          	auipc	ra,0xfffff
    80001982:	4da080e7          	jalr	1242(ra) # 80000e58 <myproc>
  if(user_src){
    80001986:	c08d                	beqz	s1,800019a8 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001988:	86d2                	mv	a3,s4
    8000198a:	864e                	mv	a2,s3
    8000198c:	85ca                	mv	a1,s2
    8000198e:	6928                	ld	a0,80(a0)
    80001990:	fffff097          	auipc	ra,0xfffff
    80001994:	212080e7          	jalr	530(ra) # 80000ba2 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001998:	70a2                	ld	ra,40(sp)
    8000199a:	7402                	ld	s0,32(sp)
    8000199c:	64e2                	ld	s1,24(sp)
    8000199e:	6942                	ld	s2,16(sp)
    800019a0:	69a2                	ld	s3,8(sp)
    800019a2:	6a02                	ld	s4,0(sp)
    800019a4:	6145                	addi	sp,sp,48
    800019a6:	8082                	ret
    memmove(dst, (char*)src, len);
    800019a8:	000a061b          	sext.w	a2,s4
    800019ac:	85ce                	mv	a1,s3
    800019ae:	854a                	mv	a0,s2
    800019b0:	fffff097          	auipc	ra,0xfffff
    800019b4:	828080e7          	jalr	-2008(ra) # 800001d8 <memmove>
    return 0;
    800019b8:	8526                	mv	a0,s1
    800019ba:	bff9                	j	80001998 <either_copyin+0x32>

00000000800019bc <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800019bc:	715d                	addi	sp,sp,-80
    800019be:	e486                	sd	ra,72(sp)
    800019c0:	e0a2                	sd	s0,64(sp)
    800019c2:	fc26                	sd	s1,56(sp)
    800019c4:	f84a                	sd	s2,48(sp)
    800019c6:	f44e                	sd	s3,40(sp)
    800019c8:	f052                	sd	s4,32(sp)
    800019ca:	ec56                	sd	s5,24(sp)
    800019cc:	e85a                	sd	s6,16(sp)
    800019ce:	e45e                	sd	s7,8(sp)
    800019d0:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800019d2:	00006517          	auipc	a0,0x6
    800019d6:	67650513          	addi	a0,a0,1654 # 80008048 <etext+0x48>
    800019da:	00004097          	auipc	ra,0x4
    800019de:	342080e7          	jalr	834(ra) # 80005d1c <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800019e2:	00007497          	auipc	s1,0x7
    800019e6:	4d648493          	addi	s1,s1,1238 # 80008eb8 <proc+0x158>
    800019ea:	0000d917          	auipc	s2,0xd
    800019ee:	4ce90913          	addi	s2,s2,1230 # 8000eeb8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019f2:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800019f4:	00007997          	auipc	s3,0x7
    800019f8:	80c98993          	addi	s3,s3,-2036 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    800019fc:	00007a97          	auipc	s5,0x7
    80001a00:	80ca8a93          	addi	s5,s5,-2036 # 80008208 <etext+0x208>
    printf("\n");
    80001a04:	00006a17          	auipc	s4,0x6
    80001a08:	644a0a13          	addi	s4,s4,1604 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a0c:	00007b97          	auipc	s7,0x7
    80001a10:	83cb8b93          	addi	s7,s7,-1988 # 80008248 <states.1731>
    80001a14:	a00d                	j	80001a36 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001a16:	ed86a583          	lw	a1,-296(a3)
    80001a1a:	8556                	mv	a0,s5
    80001a1c:	00004097          	auipc	ra,0x4
    80001a20:	300080e7          	jalr	768(ra) # 80005d1c <printf>
    printf("\n");
    80001a24:	8552                	mv	a0,s4
    80001a26:	00004097          	auipc	ra,0x4
    80001a2a:	2f6080e7          	jalr	758(ra) # 80005d1c <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a2e:	18048493          	addi	s1,s1,384
    80001a32:	03248163          	beq	s1,s2,80001a54 <procdump+0x98>
    if(p->state == UNUSED)
    80001a36:	86a6                	mv	a3,s1
    80001a38:	ec04a783          	lw	a5,-320(s1)
    80001a3c:	dbed                	beqz	a5,80001a2e <procdump+0x72>
      state = "???";
    80001a3e:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a40:	fcfb6be3          	bltu	s6,a5,80001a16 <procdump+0x5a>
    80001a44:	1782                	slli	a5,a5,0x20
    80001a46:	9381                	srli	a5,a5,0x20
    80001a48:	078e                	slli	a5,a5,0x3
    80001a4a:	97de                	add	a5,a5,s7
    80001a4c:	6390                	ld	a2,0(a5)
    80001a4e:	f661                	bnez	a2,80001a16 <procdump+0x5a>
      state = "???";
    80001a50:	864e                	mv	a2,s3
    80001a52:	b7d1                	j	80001a16 <procdump+0x5a>
  }
}
    80001a54:	60a6                	ld	ra,72(sp)
    80001a56:	6406                	ld	s0,64(sp)
    80001a58:	74e2                	ld	s1,56(sp)
    80001a5a:	7942                	ld	s2,48(sp)
    80001a5c:	79a2                	ld	s3,40(sp)
    80001a5e:	7a02                	ld	s4,32(sp)
    80001a60:	6ae2                	ld	s5,24(sp)
    80001a62:	6b42                	ld	s6,16(sp)
    80001a64:	6ba2                	ld	s7,8(sp)
    80001a66:	6161                	addi	sp,sp,80
    80001a68:	8082                	ret

0000000080001a6a <swtch>:
    80001a6a:	00153023          	sd	ra,0(a0)
    80001a6e:	00253423          	sd	sp,8(a0)
    80001a72:	e900                	sd	s0,16(a0)
    80001a74:	ed04                	sd	s1,24(a0)
    80001a76:	03253023          	sd	s2,32(a0)
    80001a7a:	03353423          	sd	s3,40(a0)
    80001a7e:	03453823          	sd	s4,48(a0)
    80001a82:	03553c23          	sd	s5,56(a0)
    80001a86:	05653023          	sd	s6,64(a0)
    80001a8a:	05753423          	sd	s7,72(a0)
    80001a8e:	05853823          	sd	s8,80(a0)
    80001a92:	05953c23          	sd	s9,88(a0)
    80001a96:	07a53023          	sd	s10,96(a0)
    80001a9a:	07b53423          	sd	s11,104(a0)
    80001a9e:	0005b083          	ld	ra,0(a1)
    80001aa2:	0085b103          	ld	sp,8(a1)
    80001aa6:	6980                	ld	s0,16(a1)
    80001aa8:	6d84                	ld	s1,24(a1)
    80001aaa:	0205b903          	ld	s2,32(a1)
    80001aae:	0285b983          	ld	s3,40(a1)
    80001ab2:	0305ba03          	ld	s4,48(a1)
    80001ab6:	0385ba83          	ld	s5,56(a1)
    80001aba:	0405bb03          	ld	s6,64(a1)
    80001abe:	0485bb83          	ld	s7,72(a1)
    80001ac2:	0505bc03          	ld	s8,80(a1)
    80001ac6:	0585bc83          	ld	s9,88(a1)
    80001aca:	0605bd03          	ld	s10,96(a1)
    80001ace:	0685bd83          	ld	s11,104(a1)
    80001ad2:	8082                	ret

0000000080001ad4 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001ad4:	1141                	addi	sp,sp,-16
    80001ad6:	e406                	sd	ra,8(sp)
    80001ad8:	e022                	sd	s0,0(sp)
    80001ada:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001adc:	00006597          	auipc	a1,0x6
    80001ae0:	79c58593          	addi	a1,a1,1948 # 80008278 <states.1731+0x30>
    80001ae4:	0000d517          	auipc	a0,0xd
    80001ae8:	27c50513          	addi	a0,a0,636 # 8000ed60 <tickslock>
    80001aec:	00004097          	auipc	ra,0x4
    80001af0:	6fc080e7          	jalr	1788(ra) # 800061e8 <initlock>
}
    80001af4:	60a2                	ld	ra,8(sp)
    80001af6:	6402                	ld	s0,0(sp)
    80001af8:	0141                	addi	sp,sp,16
    80001afa:	8082                	ret

0000000080001afc <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001afc:	1141                	addi	sp,sp,-16
    80001afe:	e422                	sd	s0,8(sp)
    80001b00:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b02:	00003797          	auipc	a5,0x3
    80001b06:	59e78793          	addi	a5,a5,1438 # 800050a0 <kernelvec>
    80001b0a:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001b0e:	6422                	ld	s0,8(sp)
    80001b10:	0141                	addi	sp,sp,16
    80001b12:	8082                	ret

0000000080001b14 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001b14:	1141                	addi	sp,sp,-16
    80001b16:	e406                	sd	ra,8(sp)
    80001b18:	e022                	sd	s0,0(sp)
    80001b1a:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001b1c:	fffff097          	auipc	ra,0xfffff
    80001b20:	33c080e7          	jalr	828(ra) # 80000e58 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b24:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001b28:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b2a:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001b2e:	00005617          	auipc	a2,0x5
    80001b32:	4d260613          	addi	a2,a2,1234 # 80007000 <_trampoline>
    80001b36:	00005697          	auipc	a3,0x5
    80001b3a:	4ca68693          	addi	a3,a3,1226 # 80007000 <_trampoline>
    80001b3e:	8e91                	sub	a3,a3,a2
    80001b40:	040007b7          	lui	a5,0x4000
    80001b44:	17fd                	addi	a5,a5,-1
    80001b46:	07b2                	slli	a5,a5,0xc
    80001b48:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b4a:	10569073          	csrw	stvec,a3
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001b4e:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001b50:	180026f3          	csrr	a3,satp
    80001b54:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001b56:	6d38                	ld	a4,88(a0)
    80001b58:	6134                	ld	a3,64(a0)
    80001b5a:	6585                	lui	a1,0x1
    80001b5c:	96ae                	add	a3,a3,a1
    80001b5e:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001b60:	6d38                	ld	a4,88(a0)
    80001b62:	00000697          	auipc	a3,0x0
    80001b66:	13068693          	addi	a3,a3,304 # 80001c92 <usertrap>
    80001b6a:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001b6c:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001b6e:	8692                	mv	a3,tp
    80001b70:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b72:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001b76:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001b7a:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b7e:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001b82:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b84:	6f18                	ld	a4,24(a4)
    80001b86:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001b8a:	6928                	ld	a0,80(a0)
    80001b8c:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001b8e:	00005717          	auipc	a4,0x5
    80001b92:	50e70713          	addi	a4,a4,1294 # 8000709c <userret>
    80001b96:	8f11                	sub	a4,a4,a2
    80001b98:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001b9a:	577d                	li	a4,-1
    80001b9c:	177e                	slli	a4,a4,0x3f
    80001b9e:	8d59                	or	a0,a0,a4
    80001ba0:	9782                	jalr	a5
}
    80001ba2:	60a2                	ld	ra,8(sp)
    80001ba4:	6402                	ld	s0,0(sp)
    80001ba6:	0141                	addi	sp,sp,16
    80001ba8:	8082                	ret

0000000080001baa <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001baa:	1101                	addi	sp,sp,-32
    80001bac:	ec06                	sd	ra,24(sp)
    80001bae:	e822                	sd	s0,16(sp)
    80001bb0:	e426                	sd	s1,8(sp)
    80001bb2:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001bb4:	0000d497          	auipc	s1,0xd
    80001bb8:	1ac48493          	addi	s1,s1,428 # 8000ed60 <tickslock>
    80001bbc:	8526                	mv	a0,s1
    80001bbe:	00004097          	auipc	ra,0x4
    80001bc2:	6ba080e7          	jalr	1722(ra) # 80006278 <acquire>
  ticks++;
    80001bc6:	00007517          	auipc	a0,0x7
    80001bca:	d3250513          	addi	a0,a0,-718 # 800088f8 <ticks>
    80001bce:	411c                	lw	a5,0(a0)
    80001bd0:	2785                	addiw	a5,a5,1
    80001bd2:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001bd4:	00000097          	auipc	ra,0x0
    80001bd8:	998080e7          	jalr	-1640(ra) # 8000156c <wakeup>
  release(&tickslock);
    80001bdc:	8526                	mv	a0,s1
    80001bde:	00004097          	auipc	ra,0x4
    80001be2:	74e080e7          	jalr	1870(ra) # 8000632c <release>
}
    80001be6:	60e2                	ld	ra,24(sp)
    80001be8:	6442                	ld	s0,16(sp)
    80001bea:	64a2                	ld	s1,8(sp)
    80001bec:	6105                	addi	sp,sp,32
    80001bee:	8082                	ret

0000000080001bf0 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001bf0:	1101                	addi	sp,sp,-32
    80001bf2:	ec06                	sd	ra,24(sp)
    80001bf4:	e822                	sd	s0,16(sp)
    80001bf6:	e426                	sd	s1,8(sp)
    80001bf8:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001bfa:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80001bfe:	00074d63          	bltz	a4,80001c18 <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80001c02:	57fd                	li	a5,-1
    80001c04:	17fe                	slli	a5,a5,0x3f
    80001c06:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001c08:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001c0a:	06f70363          	beq	a4,a5,80001c70 <devintr+0x80>
  }
}
    80001c0e:	60e2                	ld	ra,24(sp)
    80001c10:	6442                	ld	s0,16(sp)
    80001c12:	64a2                	ld	s1,8(sp)
    80001c14:	6105                	addi	sp,sp,32
    80001c16:	8082                	ret
     (scause & 0xff) == 9){
    80001c18:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    80001c1c:	46a5                	li	a3,9
    80001c1e:	fed792e3          	bne	a5,a3,80001c02 <devintr+0x12>
    int irq = plic_claim();
    80001c22:	00003097          	auipc	ra,0x3
    80001c26:	586080e7          	jalr	1414(ra) # 800051a8 <plic_claim>
    80001c2a:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001c2c:	47a9                	li	a5,10
    80001c2e:	02f50763          	beq	a0,a5,80001c5c <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80001c32:	4785                	li	a5,1
    80001c34:	02f50963          	beq	a0,a5,80001c66 <devintr+0x76>
    return 1;
    80001c38:	4505                	li	a0,1
    } else if(irq){
    80001c3a:	d8f1                	beqz	s1,80001c0e <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    80001c3c:	85a6                	mv	a1,s1
    80001c3e:	00006517          	auipc	a0,0x6
    80001c42:	64250513          	addi	a0,a0,1602 # 80008280 <states.1731+0x38>
    80001c46:	00004097          	auipc	ra,0x4
    80001c4a:	0d6080e7          	jalr	214(ra) # 80005d1c <printf>
      plic_complete(irq);
    80001c4e:	8526                	mv	a0,s1
    80001c50:	00003097          	auipc	ra,0x3
    80001c54:	57c080e7          	jalr	1404(ra) # 800051cc <plic_complete>
    return 1;
    80001c58:	4505                	li	a0,1
    80001c5a:	bf55                	j	80001c0e <devintr+0x1e>
      uartintr();
    80001c5c:	00004097          	auipc	ra,0x4
    80001c60:	53c080e7          	jalr	1340(ra) # 80006198 <uartintr>
    80001c64:	b7ed                	j	80001c4e <devintr+0x5e>
      virtio_disk_intr();
    80001c66:	00004097          	auipc	ra,0x4
    80001c6a:	a90080e7          	jalr	-1392(ra) # 800056f6 <virtio_disk_intr>
    80001c6e:	b7c5                	j	80001c4e <devintr+0x5e>
    if(cpuid() == 0){
    80001c70:	fffff097          	auipc	ra,0xfffff
    80001c74:	1bc080e7          	jalr	444(ra) # 80000e2c <cpuid>
    80001c78:	c901                	beqz	a0,80001c88 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001c7a:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001c7e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001c80:	14479073          	csrw	sip,a5
    return 2;
    80001c84:	4509                	li	a0,2
    80001c86:	b761                	j	80001c0e <devintr+0x1e>
      clockintr();
    80001c88:	00000097          	auipc	ra,0x0
    80001c8c:	f22080e7          	jalr	-222(ra) # 80001baa <clockintr>
    80001c90:	b7ed                	j	80001c7a <devintr+0x8a>

0000000080001c92 <usertrap>:
{
    80001c92:	1101                	addi	sp,sp,-32
    80001c94:	ec06                	sd	ra,24(sp)
    80001c96:	e822                	sd	s0,16(sp)
    80001c98:	e426                	sd	s1,8(sp)
    80001c9a:	e04a                	sd	s2,0(sp)
    80001c9c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c9e:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001ca2:	1007f793          	andi	a5,a5,256
    80001ca6:	e3b1                	bnez	a5,80001cea <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001ca8:	00003797          	auipc	a5,0x3
    80001cac:	3f878793          	addi	a5,a5,1016 # 800050a0 <kernelvec>
    80001cb0:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001cb4:	fffff097          	auipc	ra,0xfffff
    80001cb8:	1a4080e7          	jalr	420(ra) # 80000e58 <myproc>
    80001cbc:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001cbe:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001cc0:	14102773          	csrr	a4,sepc
    80001cc4:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001cc6:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001cca:	47a1                	li	a5,8
    80001ccc:	02f70763          	beq	a4,a5,80001cfa <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    80001cd0:	00000097          	auipc	ra,0x0
    80001cd4:	f20080e7          	jalr	-224(ra) # 80001bf0 <devintr>
    80001cd8:	892a                	mv	s2,a0
    80001cda:	c151                	beqz	a0,80001d5e <usertrap+0xcc>
  if(killed(p))
    80001cdc:	8526                	mv	a0,s1
    80001cde:	00000097          	auipc	ra,0x0
    80001ce2:	ad2080e7          	jalr	-1326(ra) # 800017b0 <killed>
    80001ce6:	c929                	beqz	a0,80001d38 <usertrap+0xa6>
    80001ce8:	a099                	j	80001d2e <usertrap+0x9c>
    panic("usertrap: not from user mode");
    80001cea:	00006517          	auipc	a0,0x6
    80001cee:	5b650513          	addi	a0,a0,1462 # 800082a0 <states.1731+0x58>
    80001cf2:	00004097          	auipc	ra,0x4
    80001cf6:	fe0080e7          	jalr	-32(ra) # 80005cd2 <panic>
    if(killed(p))
    80001cfa:	00000097          	auipc	ra,0x0
    80001cfe:	ab6080e7          	jalr	-1354(ra) # 800017b0 <killed>
    80001d02:	e921                	bnez	a0,80001d52 <usertrap+0xc0>
    p->trapframe->epc += 4;
    80001d04:	6cb8                	ld	a4,88(s1)
    80001d06:	6f1c                	ld	a5,24(a4)
    80001d08:	0791                	addi	a5,a5,4
    80001d0a:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d0c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d10:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d14:	10079073          	csrw	sstatus,a5
    syscall();
    80001d18:	00000097          	auipc	ra,0x0
    80001d1c:	322080e7          	jalr	802(ra) # 8000203a <syscall>
  if(killed(p))
    80001d20:	8526                	mv	a0,s1
    80001d22:	00000097          	auipc	ra,0x0
    80001d26:	a8e080e7          	jalr	-1394(ra) # 800017b0 <killed>
    80001d2a:	c911                	beqz	a0,80001d3e <usertrap+0xac>
    80001d2c:	4901                	li	s2,0
    exit(-1);
    80001d2e:	557d                	li	a0,-1
    80001d30:	00000097          	auipc	ra,0x0
    80001d34:	90c080e7          	jalr	-1780(ra) # 8000163c <exit>
  if(which_dev == 2)
    80001d38:	4789                	li	a5,2
    80001d3a:	04f90f63          	beq	s2,a5,80001d98 <usertrap+0x106>
  usertrapret();
    80001d3e:	00000097          	auipc	ra,0x0
    80001d42:	dd6080e7          	jalr	-554(ra) # 80001b14 <usertrapret>
}
    80001d46:	60e2                	ld	ra,24(sp)
    80001d48:	6442                	ld	s0,16(sp)
    80001d4a:	64a2                	ld	s1,8(sp)
    80001d4c:	6902                	ld	s2,0(sp)
    80001d4e:	6105                	addi	sp,sp,32
    80001d50:	8082                	ret
      exit(-1);
    80001d52:	557d                	li	a0,-1
    80001d54:	00000097          	auipc	ra,0x0
    80001d58:	8e8080e7          	jalr	-1816(ra) # 8000163c <exit>
    80001d5c:	b765                	j	80001d04 <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d5e:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001d62:	5890                	lw	a2,48(s1)
    80001d64:	00006517          	auipc	a0,0x6
    80001d68:	55c50513          	addi	a0,a0,1372 # 800082c0 <states.1731+0x78>
    80001d6c:	00004097          	auipc	ra,0x4
    80001d70:	fb0080e7          	jalr	-80(ra) # 80005d1c <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d74:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001d78:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001d7c:	00006517          	auipc	a0,0x6
    80001d80:	57450513          	addi	a0,a0,1396 # 800082f0 <states.1731+0xa8>
    80001d84:	00004097          	auipc	ra,0x4
    80001d88:	f98080e7          	jalr	-104(ra) # 80005d1c <printf>
    setkilled(p);
    80001d8c:	8526                	mv	a0,s1
    80001d8e:	00000097          	auipc	ra,0x0
    80001d92:	9f6080e7          	jalr	-1546(ra) # 80001784 <setkilled>
    80001d96:	b769                	j	80001d20 <usertrap+0x8e>
    yield();
    80001d98:	fffff097          	auipc	ra,0xfffff
    80001d9c:	734080e7          	jalr	1844(ra) # 800014cc <yield>
        if (p->interval != 0) {
    80001da0:	1684a783          	lw	a5,360(s1)
    80001da4:	cb91                	beqz	a5,80001db8 <usertrap+0x126>
            p->ticks += 1;
    80001da6:	16c4a703          	lw	a4,364(s1)
    80001daa:	2705                	addiw	a4,a4,1
    80001dac:	0007069b          	sext.w	a3,a4
            if (p->ticks == p->interval) {
    80001db0:	00d78963          	beq	a5,a3,80001dc2 <usertrap+0x130>
            p->ticks += 1;
    80001db4:	16e4a623          	sw	a4,364(s1)
        yield();
    80001db8:	fffff097          	auipc	ra,0xfffff
    80001dbc:	714080e7          	jalr	1812(ra) # 800014cc <yield>
    80001dc0:	bfbd                	j	80001d3e <usertrap+0xac>
                p->ticks = 0;
    80001dc2:	1604a623          	sw	zero,364(s1)
                if (p->trapframe_saved == 0) {
    80001dc6:	1784b783          	ld	a5,376(s1)
    80001dca:	f7fd                	bnez	a5,80001db8 <usertrap+0x126>
                    p->trapframe_saved = (struct trapframe *)kalloc();
    80001dcc:	ffffe097          	auipc	ra,0xffffe
    80001dd0:	34c080e7          	jalr	844(ra) # 80000118 <kalloc>
    80001dd4:	16a4bc23          	sd	a0,376(s1)
                    memmove(p->trapframe_saved, p->trapframe, sizeof(*p->trapframe_saved));
    80001dd8:	12000613          	li	a2,288
    80001ddc:	6cac                	ld	a1,88(s1)
    80001dde:	ffffe097          	auipc	ra,0xffffe
    80001de2:	3fa080e7          	jalr	1018(ra) # 800001d8 <memmove>
                    p->trapframe->epc = p->handler;
    80001de6:	6cbc                	ld	a5,88(s1)
    80001de8:	1704b703          	ld	a4,368(s1)
    80001dec:	ef98                	sd	a4,24(a5)
    80001dee:	b7e9                	j	80001db8 <usertrap+0x126>

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
    80001e1c:	dd8080e7          	jalr	-552(ra) # 80001bf0 <devintr>
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
    80001e42:	4d250513          	addi	a0,a0,1234 # 80008310 <states.1731+0xc8>
    80001e46:	00004097          	auipc	ra,0x4
    80001e4a:	e8c080e7          	jalr	-372(ra) # 80005cd2 <panic>
    panic("kerneltrap: interrupts enabled");
    80001e4e:	00006517          	auipc	a0,0x6
    80001e52:	4ea50513          	addi	a0,a0,1258 # 80008338 <states.1731+0xf0>
    80001e56:	00004097          	auipc	ra,0x4
    80001e5a:	e7c080e7          	jalr	-388(ra) # 80005cd2 <panic>
    printf("scause %p\n", scause);
    80001e5e:	85ce                	mv	a1,s3
    80001e60:	00006517          	auipc	a0,0x6
    80001e64:	4f850513          	addi	a0,a0,1272 # 80008358 <states.1731+0x110>
    80001e68:	00004097          	auipc	ra,0x4
    80001e6c:	eb4080e7          	jalr	-332(ra) # 80005d1c <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e70:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e74:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e78:	00006517          	auipc	a0,0x6
    80001e7c:	4f050513          	addi	a0,a0,1264 # 80008368 <states.1731+0x120>
    80001e80:	00004097          	auipc	ra,0x4
    80001e84:	e9c080e7          	jalr	-356(ra) # 80005d1c <printf>
    panic("kerneltrap");
    80001e88:	00006517          	auipc	a0,0x6
    80001e8c:	4f850513          	addi	a0,a0,1272 # 80008380 <states.1731+0x138>
    80001e90:	00004097          	auipc	ra,0x4
    80001e94:	e42080e7          	jalr	-446(ra) # 80005cd2 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e98:	fffff097          	auipc	ra,0xfffff
    80001e9c:	fc0080e7          	jalr	-64(ra) # 80000e58 <myproc>
    80001ea0:	d541                	beqz	a0,80001e28 <kerneltrap+0x38>
    80001ea2:	fffff097          	auipc	ra,0xfffff
    80001ea6:	fb6080e7          	jalr	-74(ra) # 80000e58 <myproc>
    80001eaa:	4d18                	lw	a4,24(a0)
    80001eac:	4791                	li	a5,4
    80001eae:	f6f71de3          	bne	a4,a5,80001e28 <kerneltrap+0x38>
    yield();
    80001eb2:	fffff097          	auipc	ra,0xfffff
    80001eb6:	61a080e7          	jalr	1562(ra) # 800014cc <yield>
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
    80001ecc:	f90080e7          	jalr	-112(ra) # 80000e58 <myproc>
  switch (n) {
    80001ed0:	4795                	li	a5,5
    80001ed2:	0497e163          	bltu	a5,s1,80001f14 <argraw+0x58>
    80001ed6:	048a                	slli	s1,s1,0x2
    80001ed8:	00006717          	auipc	a4,0x6
    80001edc:	4e070713          	addi	a4,a4,1248 # 800083b8 <states.1731+0x170>
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
    80001f18:	47c50513          	addi	a0,a0,1148 # 80008390 <states.1731+0x148>
    80001f1c:	00004097          	auipc	ra,0x4
    80001f20:	db6080e7          	jalr	-586(ra) # 80005cd2 <panic>

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
    80001f38:	f24080e7          	jalr	-220(ra) # 80000e58 <myproc>
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
    80001f56:	c50080e7          	jalr	-944(ra) # 80000ba2 <copyin>
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
    80001f8e:	ece080e7          	jalr	-306(ra) # 80000e58 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001f92:	86ce                	mv	a3,s3
    80001f94:	864a                	mv	a2,s2
    80001f96:	85a6                	mv	a1,s1
    80001f98:	6928                	ld	a0,80(a0)
    80001f9a:	fffff097          	auipc	ra,0xfffff
    80001f9e:	c94080e7          	jalr	-876(ra) # 80000c2e <copyinstr>
    80001fa2:	00054e63          	bltz	a0,80001fbe <fetchstr+0x48>
  return strlen(buf);
    80001fa6:	8526                	mv	a0,s1
    80001fa8:	ffffe097          	auipc	ra,0xffffe
    80001fac:	354080e7          	jalr	852(ra) # 800002fc <strlen>
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
[SYS_sigreturn] sys_sigreturn,
};

void
syscall(void)
{
    8000203a:	1101                	addi	sp,sp,-32
    8000203c:	ec06                	sd	ra,24(sp)
    8000203e:	e822                	sd	s0,16(sp)
    80002040:	e426                	sd	s1,8(sp)
    80002042:	e04a                	sd	s2,0(sp)
    80002044:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002046:	fffff097          	auipc	ra,0xfffff
    8000204a:	e12080e7          	jalr	-494(ra) # 80000e58 <myproc>
    8000204e:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002050:	05853903          	ld	s2,88(a0)
    80002054:	0a893783          	ld	a5,168(s2)
    80002058:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000205c:	37fd                	addiw	a5,a5,-1
    8000205e:	4759                	li	a4,22
    80002060:	00f76f63          	bltu	a4,a5,8000207e <syscall+0x44>
    80002064:	00369713          	slli	a4,a3,0x3
    80002068:	00006797          	auipc	a5,0x6
    8000206c:	36878793          	addi	a5,a5,872 # 800083d0 <syscalls>
    80002070:	97ba                	add	a5,a5,a4
    80002072:	639c                	ld	a5,0(a5)
    80002074:	c789                	beqz	a5,8000207e <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002076:	9782                	jalr	a5
    80002078:	06a93823          	sd	a0,112(s2)
    8000207c:	a839                	j	8000209a <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    8000207e:	15848613          	addi	a2,s1,344
    80002082:	588c                	lw	a1,48(s1)
    80002084:	00006517          	auipc	a0,0x6
    80002088:	31450513          	addi	a0,a0,788 # 80008398 <states.1731+0x150>
    8000208c:	00004097          	auipc	ra,0x4
    80002090:	c90080e7          	jalr	-880(ra) # 80005d1c <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002094:	6cbc                	ld	a5,88(s1)
    80002096:	577d                	li	a4,-1
    80002098:	fbb8                	sd	a4,112(a5)
  }
}
    8000209a:	60e2                	ld	ra,24(sp)
    8000209c:	6442                	ld	s0,16(sp)
    8000209e:	64a2                	ld	s1,8(sp)
    800020a0:	6902                	ld	s2,0(sp)
    800020a2:	6105                	addi	sp,sp,32
    800020a4:	8082                	ret

00000000800020a6 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    800020a6:	1101                	addi	sp,sp,-32
    800020a8:	ec06                	sd	ra,24(sp)
    800020aa:	e822                	sd	s0,16(sp)
    800020ac:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    800020ae:	fec40593          	addi	a1,s0,-20
    800020b2:	4501                	li	a0,0
    800020b4:	00000097          	auipc	ra,0x0
    800020b8:	f0e080e7          	jalr	-242(ra) # 80001fc2 <argint>
  exit(n);
    800020bc:	fec42503          	lw	a0,-20(s0)
    800020c0:	fffff097          	auipc	ra,0xfffff
    800020c4:	57c080e7          	jalr	1404(ra) # 8000163c <exit>
  return 0;  // not reached
}
    800020c8:	4501                	li	a0,0
    800020ca:	60e2                	ld	ra,24(sp)
    800020cc:	6442                	ld	s0,16(sp)
    800020ce:	6105                	addi	sp,sp,32
    800020d0:	8082                	ret

00000000800020d2 <sys_getpid>:

uint64
sys_getpid(void)
{
    800020d2:	1141                	addi	sp,sp,-16
    800020d4:	e406                	sd	ra,8(sp)
    800020d6:	e022                	sd	s0,0(sp)
    800020d8:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800020da:	fffff097          	auipc	ra,0xfffff
    800020de:	d7e080e7          	jalr	-642(ra) # 80000e58 <myproc>
}
    800020e2:	5908                	lw	a0,48(a0)
    800020e4:	60a2                	ld	ra,8(sp)
    800020e6:	6402                	ld	s0,0(sp)
    800020e8:	0141                	addi	sp,sp,16
    800020ea:	8082                	ret

00000000800020ec <sys_fork>:

uint64
sys_fork(void)
{
    800020ec:	1141                	addi	sp,sp,-16
    800020ee:	e406                	sd	ra,8(sp)
    800020f0:	e022                	sd	s0,0(sp)
    800020f2:	0800                	addi	s0,sp,16
  return fork();
    800020f4:	fffff097          	auipc	ra,0xfffff
    800020f8:	126080e7          	jalr	294(ra) # 8000121a <fork>
}
    800020fc:	60a2                	ld	ra,8(sp)
    800020fe:	6402                	ld	s0,0(sp)
    80002100:	0141                	addi	sp,sp,16
    80002102:	8082                	ret

0000000080002104 <sys_wait>:

uint64
sys_wait(void)
{
    80002104:	1101                	addi	sp,sp,-32
    80002106:	ec06                	sd	ra,24(sp)
    80002108:	e822                	sd	s0,16(sp)
    8000210a:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    8000210c:	fe840593          	addi	a1,s0,-24
    80002110:	4501                	li	a0,0
    80002112:	00000097          	auipc	ra,0x0
    80002116:	ed0080e7          	jalr	-304(ra) # 80001fe2 <argaddr>
  return wait(p);
    8000211a:	fe843503          	ld	a0,-24(s0)
    8000211e:	fffff097          	auipc	ra,0xfffff
    80002122:	6c4080e7          	jalr	1732(ra) # 800017e2 <wait>
}
    80002126:	60e2                	ld	ra,24(sp)
    80002128:	6442                	ld	s0,16(sp)
    8000212a:	6105                	addi	sp,sp,32
    8000212c:	8082                	ret

000000008000212e <sys_sbrk>:

uint64
sys_sbrk(void)
{
    8000212e:	7179                	addi	sp,sp,-48
    80002130:	f406                	sd	ra,40(sp)
    80002132:	f022                	sd	s0,32(sp)
    80002134:	ec26                	sd	s1,24(sp)
    80002136:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80002138:	fdc40593          	addi	a1,s0,-36
    8000213c:	4501                	li	a0,0
    8000213e:	00000097          	auipc	ra,0x0
    80002142:	e84080e7          	jalr	-380(ra) # 80001fc2 <argint>
  addr = myproc()->sz;
    80002146:	fffff097          	auipc	ra,0xfffff
    8000214a:	d12080e7          	jalr	-750(ra) # 80000e58 <myproc>
    8000214e:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80002150:	fdc42503          	lw	a0,-36(s0)
    80002154:	fffff097          	auipc	ra,0xfffff
    80002158:	06a080e7          	jalr	106(ra) # 800011be <growproc>
    8000215c:	00054863          	bltz	a0,8000216c <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    80002160:	8526                	mv	a0,s1
    80002162:	70a2                	ld	ra,40(sp)
    80002164:	7402                	ld	s0,32(sp)
    80002166:	64e2                	ld	s1,24(sp)
    80002168:	6145                	addi	sp,sp,48
    8000216a:	8082                	ret
    return -1;
    8000216c:	54fd                	li	s1,-1
    8000216e:	bfcd                	j	80002160 <sys_sbrk+0x32>

0000000080002170 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002170:	7139                	addi	sp,sp,-64
    80002172:	fc06                	sd	ra,56(sp)
    80002174:	f822                	sd	s0,48(sp)
    80002176:	f426                	sd	s1,40(sp)
    80002178:	f04a                	sd	s2,32(sp)
    8000217a:	ec4e                	sd	s3,24(sp)
    8000217c:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;
  backtrace();
    8000217e:	00004097          	auipc	ra,0x4
    80002182:	db6080e7          	jalr	-586(ra) # 80005f34 <backtrace>

  argint(0, &n);
    80002186:	fcc40593          	addi	a1,s0,-52
    8000218a:	4501                	li	a0,0
    8000218c:	00000097          	auipc	ra,0x0
    80002190:	e36080e7          	jalr	-458(ra) # 80001fc2 <argint>
  if(n < 0)
    80002194:	fcc42783          	lw	a5,-52(s0)
    80002198:	0607cf63          	bltz	a5,80002216 <sys_sleep+0xa6>
    n = 0;
  acquire(&tickslock);
    8000219c:	0000d517          	auipc	a0,0xd
    800021a0:	bc450513          	addi	a0,a0,-1084 # 8000ed60 <tickslock>
    800021a4:	00004097          	auipc	ra,0x4
    800021a8:	0d4080e7          	jalr	212(ra) # 80006278 <acquire>
  ticks0 = ticks;
    800021ac:	00006917          	auipc	s2,0x6
    800021b0:	74c92903          	lw	s2,1868(s2) # 800088f8 <ticks>
  while(ticks - ticks0 < n){
    800021b4:	fcc42783          	lw	a5,-52(s0)
    800021b8:	cf9d                	beqz	a5,800021f6 <sys_sleep+0x86>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800021ba:	0000d997          	auipc	s3,0xd
    800021be:	ba698993          	addi	s3,s3,-1114 # 8000ed60 <tickslock>
    800021c2:	00006497          	auipc	s1,0x6
    800021c6:	73648493          	addi	s1,s1,1846 # 800088f8 <ticks>
    if(killed(myproc())){
    800021ca:	fffff097          	auipc	ra,0xfffff
    800021ce:	c8e080e7          	jalr	-882(ra) # 80000e58 <myproc>
    800021d2:	fffff097          	auipc	ra,0xfffff
    800021d6:	5de080e7          	jalr	1502(ra) # 800017b0 <killed>
    800021da:	e129                	bnez	a0,8000221c <sys_sleep+0xac>
    sleep(&ticks, &tickslock);
    800021dc:	85ce                	mv	a1,s3
    800021de:	8526                	mv	a0,s1
    800021e0:	fffff097          	auipc	ra,0xfffff
    800021e4:	328080e7          	jalr	808(ra) # 80001508 <sleep>
  while(ticks - ticks0 < n){
    800021e8:	409c                	lw	a5,0(s1)
    800021ea:	412787bb          	subw	a5,a5,s2
    800021ee:	fcc42703          	lw	a4,-52(s0)
    800021f2:	fce7ece3          	bltu	a5,a4,800021ca <sys_sleep+0x5a>
  }
  release(&tickslock);
    800021f6:	0000d517          	auipc	a0,0xd
    800021fa:	b6a50513          	addi	a0,a0,-1174 # 8000ed60 <tickslock>
    800021fe:	00004097          	auipc	ra,0x4
    80002202:	12e080e7          	jalr	302(ra) # 8000632c <release>
  return 0;
    80002206:	4501                	li	a0,0
}
    80002208:	70e2                	ld	ra,56(sp)
    8000220a:	7442                	ld	s0,48(sp)
    8000220c:	74a2                	ld	s1,40(sp)
    8000220e:	7902                	ld	s2,32(sp)
    80002210:	69e2                	ld	s3,24(sp)
    80002212:	6121                	addi	sp,sp,64
    80002214:	8082                	ret
    n = 0;
    80002216:	fc042623          	sw	zero,-52(s0)
    8000221a:	b749                	j	8000219c <sys_sleep+0x2c>
      release(&tickslock);
    8000221c:	0000d517          	auipc	a0,0xd
    80002220:	b4450513          	addi	a0,a0,-1212 # 8000ed60 <tickslock>
    80002224:	00004097          	auipc	ra,0x4
    80002228:	108080e7          	jalr	264(ra) # 8000632c <release>
      return -1;
    8000222c:	557d                	li	a0,-1
    8000222e:	bfe9                	j	80002208 <sys_sleep+0x98>

0000000080002230 <sys_kill>:

uint64
sys_kill(void)
{
    80002230:	1101                	addi	sp,sp,-32
    80002232:	ec06                	sd	ra,24(sp)
    80002234:	e822                	sd	s0,16(sp)
    80002236:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002238:	fec40593          	addi	a1,s0,-20
    8000223c:	4501                	li	a0,0
    8000223e:	00000097          	auipc	ra,0x0
    80002242:	d84080e7          	jalr	-636(ra) # 80001fc2 <argint>
  return kill(pid);
    80002246:	fec42503          	lw	a0,-20(s0)
    8000224a:	fffff097          	auipc	ra,0xfffff
    8000224e:	4c8080e7          	jalr	1224(ra) # 80001712 <kill>
}
    80002252:	60e2                	ld	ra,24(sp)
    80002254:	6442                	ld	s0,16(sp)
    80002256:	6105                	addi	sp,sp,32
    80002258:	8082                	ret

000000008000225a <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    8000225a:	1101                	addi	sp,sp,-32
    8000225c:	ec06                	sd	ra,24(sp)
    8000225e:	e822                	sd	s0,16(sp)
    80002260:	e426                	sd	s1,8(sp)
    80002262:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002264:	0000d517          	auipc	a0,0xd
    80002268:	afc50513          	addi	a0,a0,-1284 # 8000ed60 <tickslock>
    8000226c:	00004097          	auipc	ra,0x4
    80002270:	00c080e7          	jalr	12(ra) # 80006278 <acquire>
  xticks = ticks;
    80002274:	00006497          	auipc	s1,0x6
    80002278:	6844a483          	lw	s1,1668(s1) # 800088f8 <ticks>
  release(&tickslock);
    8000227c:	0000d517          	auipc	a0,0xd
    80002280:	ae450513          	addi	a0,a0,-1308 # 8000ed60 <tickslock>
    80002284:	00004097          	auipc	ra,0x4
    80002288:	0a8080e7          	jalr	168(ra) # 8000632c <release>
  return xticks;
}
    8000228c:	02049513          	slli	a0,s1,0x20
    80002290:	9101                	srli	a0,a0,0x20
    80002292:	60e2                	ld	ra,24(sp)
    80002294:	6442                	ld	s0,16(sp)
    80002296:	64a2                	ld	s1,8(sp)
    80002298:	6105                	addi	sp,sp,32
    8000229a:	8082                	ret

000000008000229c <sys_sigalarm>:
uint64 sys_sigalarm(void)
{
    8000229c:	7179                	addi	sp,sp,-48
    8000229e:	f406                	sd	ra,40(sp)
    800022a0:	f022                	sd	s0,32(sp)
    800022a2:	ec26                	sd	s1,24(sp)
    800022a4:	1800                	addi	s0,sp,48
    int interval;
    uint64 handler;
    struct proc *p = myproc();
    800022a6:	fffff097          	auipc	ra,0xfffff
    800022aa:	bb2080e7          	jalr	-1102(ra) # 80000e58 <myproc>
    800022ae:	84aa                	mv	s1,a0
    argint(0, &interval);
    800022b0:	fdc40593          	addi	a1,s0,-36
    800022b4:	4501                	li	a0,0
    800022b6:	00000097          	auipc	ra,0x0
    800022ba:	d0c080e7          	jalr	-756(ra) # 80001fc2 <argint>
    argaddr(1, &handler);
    800022be:	fd040593          	addi	a1,s0,-48
    800022c2:	4505                	li	a0,1
    800022c4:	00000097          	auipc	ra,0x0
    800022c8:	d1e080e7          	jalr	-738(ra) # 80001fe2 <argaddr>

    p->interval = interval;
    800022cc:	fdc42783          	lw	a5,-36(s0)
    800022d0:	16f4a423          	sw	a5,360(s1)
    p->handler = handler;
    800022d4:	fd043783          	ld	a5,-48(s0)
    800022d8:	16f4b823          	sd	a5,368(s1)
    return 0;
}
    800022dc:	4501                	li	a0,0
    800022de:	70a2                	ld	ra,40(sp)
    800022e0:	7402                	ld	s0,32(sp)
    800022e2:	64e2                	ld	s1,24(sp)
    800022e4:	6145                	addi	sp,sp,48
    800022e6:	8082                	ret

00000000800022e8 <sys_sigreturn>:

uint64 sys_sigreturn(void)
{
    800022e8:	1101                	addi	sp,sp,-32
    800022ea:	ec06                	sd	ra,24(sp)
    800022ec:	e822                	sd	s0,16(sp)
    800022ee:	e426                	sd	s1,8(sp)
    800022f0:	1000                	addi	s0,sp,32
    struct proc *p = myproc();
    800022f2:	fffff097          	auipc	ra,0xfffff
    800022f6:	b66080e7          	jalr	-1178(ra) # 80000e58 <myproc>
    800022fa:	84aa                	mv	s1,a0
    if (p->trapframe_saved) {
    800022fc:	17853583          	ld	a1,376(a0)
    80002300:	c185                	beqz	a1,80002320 <sys_sigreturn+0x38>
        memmove(p->trapframe, p->trapframe_saved, sizeof(*p->trapframe_saved));
    80002302:	12000613          	li	a2,288
    80002306:	6d28                	ld	a0,88(a0)
    80002308:	ffffe097          	auipc	ra,0xffffe
    8000230c:	ed0080e7          	jalr	-304(ra) # 800001d8 <memmove>
        kfree((void *)p->trapframe_saved);
    80002310:	1784b503          	ld	a0,376(s1)
    80002314:	ffffe097          	auipc	ra,0xffffe
    80002318:	d08080e7          	jalr	-760(ra) # 8000001c <kfree>
        p->trapframe_saved = 0;
    8000231c:	1604bc23          	sd	zero,376(s1)
    }
    p->ticks = 0;
    80002320:	1604a623          	sw	zero,364(s1)
    return p->trapframe->a0;
    80002324:	6cbc                	ld	a5,88(s1)
    80002326:	7ba8                	ld	a0,112(a5)
    80002328:	60e2                	ld	ra,24(sp)
    8000232a:	6442                	ld	s0,16(sp)
    8000232c:	64a2                	ld	s1,8(sp)
    8000232e:	6105                	addi	sp,sp,32
    80002330:	8082                	ret

0000000080002332 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002332:	7179                	addi	sp,sp,-48
    80002334:	f406                	sd	ra,40(sp)
    80002336:	f022                	sd	s0,32(sp)
    80002338:	ec26                	sd	s1,24(sp)
    8000233a:	e84a                	sd	s2,16(sp)
    8000233c:	e44e                	sd	s3,8(sp)
    8000233e:	e052                	sd	s4,0(sp)
    80002340:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002342:	00006597          	auipc	a1,0x6
    80002346:	14e58593          	addi	a1,a1,334 # 80008490 <syscalls+0xc0>
    8000234a:	0000d517          	auipc	a0,0xd
    8000234e:	a2e50513          	addi	a0,a0,-1490 # 8000ed78 <bcache>
    80002352:	00004097          	auipc	ra,0x4
    80002356:	e96080e7          	jalr	-362(ra) # 800061e8 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000235a:	00015797          	auipc	a5,0x15
    8000235e:	a1e78793          	addi	a5,a5,-1506 # 80016d78 <bcache+0x8000>
    80002362:	00015717          	auipc	a4,0x15
    80002366:	c7e70713          	addi	a4,a4,-898 # 80016fe0 <bcache+0x8268>
    8000236a:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000236e:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002372:	0000d497          	auipc	s1,0xd
    80002376:	a1e48493          	addi	s1,s1,-1506 # 8000ed90 <bcache+0x18>
    b->next = bcache.head.next;
    8000237a:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000237c:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000237e:	00006a17          	auipc	s4,0x6
    80002382:	11aa0a13          	addi	s4,s4,282 # 80008498 <syscalls+0xc8>
    b->next = bcache.head.next;
    80002386:	2b893783          	ld	a5,696(s2)
    8000238a:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000238c:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002390:	85d2                	mv	a1,s4
    80002392:	01048513          	addi	a0,s1,16
    80002396:	00001097          	auipc	ra,0x1
    8000239a:	4c4080e7          	jalr	1220(ra) # 8000385a <initsleeplock>
    bcache.head.next->prev = b;
    8000239e:	2b893783          	ld	a5,696(s2)
    800023a2:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800023a4:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800023a8:	45848493          	addi	s1,s1,1112
    800023ac:	fd349de3          	bne	s1,s3,80002386 <binit+0x54>
  }
}
    800023b0:	70a2                	ld	ra,40(sp)
    800023b2:	7402                	ld	s0,32(sp)
    800023b4:	64e2                	ld	s1,24(sp)
    800023b6:	6942                	ld	s2,16(sp)
    800023b8:	69a2                	ld	s3,8(sp)
    800023ba:	6a02                	ld	s4,0(sp)
    800023bc:	6145                	addi	sp,sp,48
    800023be:	8082                	ret

00000000800023c0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800023c0:	7179                	addi	sp,sp,-48
    800023c2:	f406                	sd	ra,40(sp)
    800023c4:	f022                	sd	s0,32(sp)
    800023c6:	ec26                	sd	s1,24(sp)
    800023c8:	e84a                	sd	s2,16(sp)
    800023ca:	e44e                	sd	s3,8(sp)
    800023cc:	1800                	addi	s0,sp,48
    800023ce:	89aa                	mv	s3,a0
    800023d0:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    800023d2:	0000d517          	auipc	a0,0xd
    800023d6:	9a650513          	addi	a0,a0,-1626 # 8000ed78 <bcache>
    800023da:	00004097          	auipc	ra,0x4
    800023de:	e9e080e7          	jalr	-354(ra) # 80006278 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800023e2:	00015497          	auipc	s1,0x15
    800023e6:	c4e4b483          	ld	s1,-946(s1) # 80017030 <bcache+0x82b8>
    800023ea:	00015797          	auipc	a5,0x15
    800023ee:	bf678793          	addi	a5,a5,-1034 # 80016fe0 <bcache+0x8268>
    800023f2:	02f48f63          	beq	s1,a5,80002430 <bread+0x70>
    800023f6:	873e                	mv	a4,a5
    800023f8:	a021                	j	80002400 <bread+0x40>
    800023fa:	68a4                	ld	s1,80(s1)
    800023fc:	02e48a63          	beq	s1,a4,80002430 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002400:	449c                	lw	a5,8(s1)
    80002402:	ff379ce3          	bne	a5,s3,800023fa <bread+0x3a>
    80002406:	44dc                	lw	a5,12(s1)
    80002408:	ff2799e3          	bne	a5,s2,800023fa <bread+0x3a>
      b->refcnt++;
    8000240c:	40bc                	lw	a5,64(s1)
    8000240e:	2785                	addiw	a5,a5,1
    80002410:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002412:	0000d517          	auipc	a0,0xd
    80002416:	96650513          	addi	a0,a0,-1690 # 8000ed78 <bcache>
    8000241a:	00004097          	auipc	ra,0x4
    8000241e:	f12080e7          	jalr	-238(ra) # 8000632c <release>
      acquiresleep(&b->lock);
    80002422:	01048513          	addi	a0,s1,16
    80002426:	00001097          	auipc	ra,0x1
    8000242a:	46e080e7          	jalr	1134(ra) # 80003894 <acquiresleep>
      return b;
    8000242e:	a8b9                	j	8000248c <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002430:	00015497          	auipc	s1,0x15
    80002434:	bf84b483          	ld	s1,-1032(s1) # 80017028 <bcache+0x82b0>
    80002438:	00015797          	auipc	a5,0x15
    8000243c:	ba878793          	addi	a5,a5,-1112 # 80016fe0 <bcache+0x8268>
    80002440:	00f48863          	beq	s1,a5,80002450 <bread+0x90>
    80002444:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002446:	40bc                	lw	a5,64(s1)
    80002448:	cf81                	beqz	a5,80002460 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000244a:	64a4                	ld	s1,72(s1)
    8000244c:	fee49de3          	bne	s1,a4,80002446 <bread+0x86>
  panic("bget: no buffers");
    80002450:	00006517          	auipc	a0,0x6
    80002454:	05050513          	addi	a0,a0,80 # 800084a0 <syscalls+0xd0>
    80002458:	00004097          	auipc	ra,0x4
    8000245c:	87a080e7          	jalr	-1926(ra) # 80005cd2 <panic>
      b->dev = dev;
    80002460:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    80002464:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    80002468:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000246c:	4785                	li	a5,1
    8000246e:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002470:	0000d517          	auipc	a0,0xd
    80002474:	90850513          	addi	a0,a0,-1784 # 8000ed78 <bcache>
    80002478:	00004097          	auipc	ra,0x4
    8000247c:	eb4080e7          	jalr	-332(ra) # 8000632c <release>
      acquiresleep(&b->lock);
    80002480:	01048513          	addi	a0,s1,16
    80002484:	00001097          	auipc	ra,0x1
    80002488:	410080e7          	jalr	1040(ra) # 80003894 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000248c:	409c                	lw	a5,0(s1)
    8000248e:	cb89                	beqz	a5,800024a0 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002490:	8526                	mv	a0,s1
    80002492:	70a2                	ld	ra,40(sp)
    80002494:	7402                	ld	s0,32(sp)
    80002496:	64e2                	ld	s1,24(sp)
    80002498:	6942                	ld	s2,16(sp)
    8000249a:	69a2                	ld	s3,8(sp)
    8000249c:	6145                	addi	sp,sp,48
    8000249e:	8082                	ret
    virtio_disk_rw(b, 0);
    800024a0:	4581                	li	a1,0
    800024a2:	8526                	mv	a0,s1
    800024a4:	00003097          	auipc	ra,0x3
    800024a8:	fc4080e7          	jalr	-60(ra) # 80005468 <virtio_disk_rw>
    b->valid = 1;
    800024ac:	4785                	li	a5,1
    800024ae:	c09c                	sw	a5,0(s1)
  return b;
    800024b0:	b7c5                	j	80002490 <bread+0xd0>

00000000800024b2 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800024b2:	1101                	addi	sp,sp,-32
    800024b4:	ec06                	sd	ra,24(sp)
    800024b6:	e822                	sd	s0,16(sp)
    800024b8:	e426                	sd	s1,8(sp)
    800024ba:	1000                	addi	s0,sp,32
    800024bc:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800024be:	0541                	addi	a0,a0,16
    800024c0:	00001097          	auipc	ra,0x1
    800024c4:	46e080e7          	jalr	1134(ra) # 8000392e <holdingsleep>
    800024c8:	cd01                	beqz	a0,800024e0 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800024ca:	4585                	li	a1,1
    800024cc:	8526                	mv	a0,s1
    800024ce:	00003097          	auipc	ra,0x3
    800024d2:	f9a080e7          	jalr	-102(ra) # 80005468 <virtio_disk_rw>
}
    800024d6:	60e2                	ld	ra,24(sp)
    800024d8:	6442                	ld	s0,16(sp)
    800024da:	64a2                	ld	s1,8(sp)
    800024dc:	6105                	addi	sp,sp,32
    800024de:	8082                	ret
    panic("bwrite");
    800024e0:	00006517          	auipc	a0,0x6
    800024e4:	fd850513          	addi	a0,a0,-40 # 800084b8 <syscalls+0xe8>
    800024e8:	00003097          	auipc	ra,0x3
    800024ec:	7ea080e7          	jalr	2026(ra) # 80005cd2 <panic>

00000000800024f0 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800024f0:	1101                	addi	sp,sp,-32
    800024f2:	ec06                	sd	ra,24(sp)
    800024f4:	e822                	sd	s0,16(sp)
    800024f6:	e426                	sd	s1,8(sp)
    800024f8:	e04a                	sd	s2,0(sp)
    800024fa:	1000                	addi	s0,sp,32
    800024fc:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800024fe:	01050913          	addi	s2,a0,16
    80002502:	854a                	mv	a0,s2
    80002504:	00001097          	auipc	ra,0x1
    80002508:	42a080e7          	jalr	1066(ra) # 8000392e <holdingsleep>
    8000250c:	c92d                	beqz	a0,8000257e <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    8000250e:	854a                	mv	a0,s2
    80002510:	00001097          	auipc	ra,0x1
    80002514:	3da080e7          	jalr	986(ra) # 800038ea <releasesleep>

  acquire(&bcache.lock);
    80002518:	0000d517          	auipc	a0,0xd
    8000251c:	86050513          	addi	a0,a0,-1952 # 8000ed78 <bcache>
    80002520:	00004097          	auipc	ra,0x4
    80002524:	d58080e7          	jalr	-680(ra) # 80006278 <acquire>
  b->refcnt--;
    80002528:	40bc                	lw	a5,64(s1)
    8000252a:	37fd                	addiw	a5,a5,-1
    8000252c:	0007871b          	sext.w	a4,a5
    80002530:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002532:	eb05                	bnez	a4,80002562 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002534:	68bc                	ld	a5,80(s1)
    80002536:	64b8                	ld	a4,72(s1)
    80002538:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    8000253a:	64bc                	ld	a5,72(s1)
    8000253c:	68b8                	ld	a4,80(s1)
    8000253e:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002540:	00015797          	auipc	a5,0x15
    80002544:	83878793          	addi	a5,a5,-1992 # 80016d78 <bcache+0x8000>
    80002548:	2b87b703          	ld	a4,696(a5)
    8000254c:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000254e:	00015717          	auipc	a4,0x15
    80002552:	a9270713          	addi	a4,a4,-1390 # 80016fe0 <bcache+0x8268>
    80002556:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002558:	2b87b703          	ld	a4,696(a5)
    8000255c:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000255e:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002562:	0000d517          	auipc	a0,0xd
    80002566:	81650513          	addi	a0,a0,-2026 # 8000ed78 <bcache>
    8000256a:	00004097          	auipc	ra,0x4
    8000256e:	dc2080e7          	jalr	-574(ra) # 8000632c <release>
}
    80002572:	60e2                	ld	ra,24(sp)
    80002574:	6442                	ld	s0,16(sp)
    80002576:	64a2                	ld	s1,8(sp)
    80002578:	6902                	ld	s2,0(sp)
    8000257a:	6105                	addi	sp,sp,32
    8000257c:	8082                	ret
    panic("brelse");
    8000257e:	00006517          	auipc	a0,0x6
    80002582:	f4250513          	addi	a0,a0,-190 # 800084c0 <syscalls+0xf0>
    80002586:	00003097          	auipc	ra,0x3
    8000258a:	74c080e7          	jalr	1868(ra) # 80005cd2 <panic>

000000008000258e <bpin>:

void
bpin(struct buf *b) {
    8000258e:	1101                	addi	sp,sp,-32
    80002590:	ec06                	sd	ra,24(sp)
    80002592:	e822                	sd	s0,16(sp)
    80002594:	e426                	sd	s1,8(sp)
    80002596:	1000                	addi	s0,sp,32
    80002598:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000259a:	0000c517          	auipc	a0,0xc
    8000259e:	7de50513          	addi	a0,a0,2014 # 8000ed78 <bcache>
    800025a2:	00004097          	auipc	ra,0x4
    800025a6:	cd6080e7          	jalr	-810(ra) # 80006278 <acquire>
  b->refcnt++;
    800025aa:	40bc                	lw	a5,64(s1)
    800025ac:	2785                	addiw	a5,a5,1
    800025ae:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800025b0:	0000c517          	auipc	a0,0xc
    800025b4:	7c850513          	addi	a0,a0,1992 # 8000ed78 <bcache>
    800025b8:	00004097          	auipc	ra,0x4
    800025bc:	d74080e7          	jalr	-652(ra) # 8000632c <release>
}
    800025c0:	60e2                	ld	ra,24(sp)
    800025c2:	6442                	ld	s0,16(sp)
    800025c4:	64a2                	ld	s1,8(sp)
    800025c6:	6105                	addi	sp,sp,32
    800025c8:	8082                	ret

00000000800025ca <bunpin>:

void
bunpin(struct buf *b) {
    800025ca:	1101                	addi	sp,sp,-32
    800025cc:	ec06                	sd	ra,24(sp)
    800025ce:	e822                	sd	s0,16(sp)
    800025d0:	e426                	sd	s1,8(sp)
    800025d2:	1000                	addi	s0,sp,32
    800025d4:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800025d6:	0000c517          	auipc	a0,0xc
    800025da:	7a250513          	addi	a0,a0,1954 # 8000ed78 <bcache>
    800025de:	00004097          	auipc	ra,0x4
    800025e2:	c9a080e7          	jalr	-870(ra) # 80006278 <acquire>
  b->refcnt--;
    800025e6:	40bc                	lw	a5,64(s1)
    800025e8:	37fd                	addiw	a5,a5,-1
    800025ea:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800025ec:	0000c517          	auipc	a0,0xc
    800025f0:	78c50513          	addi	a0,a0,1932 # 8000ed78 <bcache>
    800025f4:	00004097          	auipc	ra,0x4
    800025f8:	d38080e7          	jalr	-712(ra) # 8000632c <release>
}
    800025fc:	60e2                	ld	ra,24(sp)
    800025fe:	6442                	ld	s0,16(sp)
    80002600:	64a2                	ld	s1,8(sp)
    80002602:	6105                	addi	sp,sp,32
    80002604:	8082                	ret

0000000080002606 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002606:	1101                	addi	sp,sp,-32
    80002608:	ec06                	sd	ra,24(sp)
    8000260a:	e822                	sd	s0,16(sp)
    8000260c:	e426                	sd	s1,8(sp)
    8000260e:	e04a                	sd	s2,0(sp)
    80002610:	1000                	addi	s0,sp,32
    80002612:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002614:	00d5d59b          	srliw	a1,a1,0xd
    80002618:	00015797          	auipc	a5,0x15
    8000261c:	e3c7a783          	lw	a5,-452(a5) # 80017454 <sb+0x1c>
    80002620:	9dbd                	addw	a1,a1,a5
    80002622:	00000097          	auipc	ra,0x0
    80002626:	d9e080e7          	jalr	-610(ra) # 800023c0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000262a:	0074f713          	andi	a4,s1,7
    8000262e:	4785                	li	a5,1
    80002630:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002634:	14ce                	slli	s1,s1,0x33
    80002636:	90d9                	srli	s1,s1,0x36
    80002638:	00950733          	add	a4,a0,s1
    8000263c:	05874703          	lbu	a4,88(a4)
    80002640:	00e7f6b3          	and	a3,a5,a4
    80002644:	c69d                	beqz	a3,80002672 <bfree+0x6c>
    80002646:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002648:	94aa                	add	s1,s1,a0
    8000264a:	fff7c793          	not	a5,a5
    8000264e:	8ff9                	and	a5,a5,a4
    80002650:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    80002654:	00001097          	auipc	ra,0x1
    80002658:	120080e7          	jalr	288(ra) # 80003774 <log_write>
  brelse(bp);
    8000265c:	854a                	mv	a0,s2
    8000265e:	00000097          	auipc	ra,0x0
    80002662:	e92080e7          	jalr	-366(ra) # 800024f0 <brelse>
}
    80002666:	60e2                	ld	ra,24(sp)
    80002668:	6442                	ld	s0,16(sp)
    8000266a:	64a2                	ld	s1,8(sp)
    8000266c:	6902                	ld	s2,0(sp)
    8000266e:	6105                	addi	sp,sp,32
    80002670:	8082                	ret
    panic("freeing free block");
    80002672:	00006517          	auipc	a0,0x6
    80002676:	e5650513          	addi	a0,a0,-426 # 800084c8 <syscalls+0xf8>
    8000267a:	00003097          	auipc	ra,0x3
    8000267e:	658080e7          	jalr	1624(ra) # 80005cd2 <panic>

0000000080002682 <balloc>:
{
    80002682:	711d                	addi	sp,sp,-96
    80002684:	ec86                	sd	ra,88(sp)
    80002686:	e8a2                	sd	s0,80(sp)
    80002688:	e4a6                	sd	s1,72(sp)
    8000268a:	e0ca                	sd	s2,64(sp)
    8000268c:	fc4e                	sd	s3,56(sp)
    8000268e:	f852                	sd	s4,48(sp)
    80002690:	f456                	sd	s5,40(sp)
    80002692:	f05a                	sd	s6,32(sp)
    80002694:	ec5e                	sd	s7,24(sp)
    80002696:	e862                	sd	s8,16(sp)
    80002698:	e466                	sd	s9,8(sp)
    8000269a:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000269c:	00015797          	auipc	a5,0x15
    800026a0:	da07a783          	lw	a5,-608(a5) # 8001743c <sb+0x4>
    800026a4:	10078163          	beqz	a5,800027a6 <balloc+0x124>
    800026a8:	8baa                	mv	s7,a0
    800026aa:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800026ac:	00015b17          	auipc	s6,0x15
    800026b0:	d8cb0b13          	addi	s6,s6,-628 # 80017438 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026b4:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800026b6:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026b8:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800026ba:	6c89                	lui	s9,0x2
    800026bc:	a061                	j	80002744 <balloc+0xc2>
        bp->data[bi/8] |= m;  // Mark block in use.
    800026be:	974a                	add	a4,a4,s2
    800026c0:	8fd5                	or	a5,a5,a3
    800026c2:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    800026c6:	854a                	mv	a0,s2
    800026c8:	00001097          	auipc	ra,0x1
    800026cc:	0ac080e7          	jalr	172(ra) # 80003774 <log_write>
        brelse(bp);
    800026d0:	854a                	mv	a0,s2
    800026d2:	00000097          	auipc	ra,0x0
    800026d6:	e1e080e7          	jalr	-482(ra) # 800024f0 <brelse>
  bp = bread(dev, bno);
    800026da:	85a6                	mv	a1,s1
    800026dc:	855e                	mv	a0,s7
    800026de:	00000097          	auipc	ra,0x0
    800026e2:	ce2080e7          	jalr	-798(ra) # 800023c0 <bread>
    800026e6:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800026e8:	40000613          	li	a2,1024
    800026ec:	4581                	li	a1,0
    800026ee:	05850513          	addi	a0,a0,88
    800026f2:	ffffe097          	auipc	ra,0xffffe
    800026f6:	a86080e7          	jalr	-1402(ra) # 80000178 <memset>
  log_write(bp);
    800026fa:	854a                	mv	a0,s2
    800026fc:	00001097          	auipc	ra,0x1
    80002700:	078080e7          	jalr	120(ra) # 80003774 <log_write>
  brelse(bp);
    80002704:	854a                	mv	a0,s2
    80002706:	00000097          	auipc	ra,0x0
    8000270a:	dea080e7          	jalr	-534(ra) # 800024f0 <brelse>
}
    8000270e:	8526                	mv	a0,s1
    80002710:	60e6                	ld	ra,88(sp)
    80002712:	6446                	ld	s0,80(sp)
    80002714:	64a6                	ld	s1,72(sp)
    80002716:	6906                	ld	s2,64(sp)
    80002718:	79e2                	ld	s3,56(sp)
    8000271a:	7a42                	ld	s4,48(sp)
    8000271c:	7aa2                	ld	s5,40(sp)
    8000271e:	7b02                	ld	s6,32(sp)
    80002720:	6be2                	ld	s7,24(sp)
    80002722:	6c42                	ld	s8,16(sp)
    80002724:	6ca2                	ld	s9,8(sp)
    80002726:	6125                	addi	sp,sp,96
    80002728:	8082                	ret
    brelse(bp);
    8000272a:	854a                	mv	a0,s2
    8000272c:	00000097          	auipc	ra,0x0
    80002730:	dc4080e7          	jalr	-572(ra) # 800024f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002734:	015c87bb          	addw	a5,s9,s5
    80002738:	00078a9b          	sext.w	s5,a5
    8000273c:	004b2703          	lw	a4,4(s6)
    80002740:	06eaf363          	bgeu	s5,a4,800027a6 <balloc+0x124>
    bp = bread(dev, BBLOCK(b, sb));
    80002744:	41fad79b          	sraiw	a5,s5,0x1f
    80002748:	0137d79b          	srliw	a5,a5,0x13
    8000274c:	015787bb          	addw	a5,a5,s5
    80002750:	40d7d79b          	sraiw	a5,a5,0xd
    80002754:	01cb2583          	lw	a1,28(s6)
    80002758:	9dbd                	addw	a1,a1,a5
    8000275a:	855e                	mv	a0,s7
    8000275c:	00000097          	auipc	ra,0x0
    80002760:	c64080e7          	jalr	-924(ra) # 800023c0 <bread>
    80002764:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002766:	004b2503          	lw	a0,4(s6)
    8000276a:	000a849b          	sext.w	s1,s5
    8000276e:	8662                	mv	a2,s8
    80002770:	faa4fde3          	bgeu	s1,a0,8000272a <balloc+0xa8>
      m = 1 << (bi % 8);
    80002774:	41f6579b          	sraiw	a5,a2,0x1f
    80002778:	01d7d69b          	srliw	a3,a5,0x1d
    8000277c:	00c6873b          	addw	a4,a3,a2
    80002780:	00777793          	andi	a5,a4,7
    80002784:	9f95                	subw	a5,a5,a3
    80002786:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000278a:	4037571b          	sraiw	a4,a4,0x3
    8000278e:	00e906b3          	add	a3,s2,a4
    80002792:	0586c683          	lbu	a3,88(a3)
    80002796:	00d7f5b3          	and	a1,a5,a3
    8000279a:	d195                	beqz	a1,800026be <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000279c:	2605                	addiw	a2,a2,1
    8000279e:	2485                	addiw	s1,s1,1
    800027a0:	fd4618e3          	bne	a2,s4,80002770 <balloc+0xee>
    800027a4:	b759                	j	8000272a <balloc+0xa8>
  printf("balloc: out of blocks\n");
    800027a6:	00006517          	auipc	a0,0x6
    800027aa:	d3a50513          	addi	a0,a0,-710 # 800084e0 <syscalls+0x110>
    800027ae:	00003097          	auipc	ra,0x3
    800027b2:	56e080e7          	jalr	1390(ra) # 80005d1c <printf>
  return 0;
    800027b6:	4481                	li	s1,0
    800027b8:	bf99                	j	8000270e <balloc+0x8c>

00000000800027ba <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800027ba:	7179                	addi	sp,sp,-48
    800027bc:	f406                	sd	ra,40(sp)
    800027be:	f022                	sd	s0,32(sp)
    800027c0:	ec26                	sd	s1,24(sp)
    800027c2:	e84a                	sd	s2,16(sp)
    800027c4:	e44e                	sd	s3,8(sp)
    800027c6:	e052                	sd	s4,0(sp)
    800027c8:	1800                	addi	s0,sp,48
    800027ca:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800027cc:	47ad                	li	a5,11
    800027ce:	02b7e763          	bltu	a5,a1,800027fc <bmap+0x42>
    if((addr = ip->addrs[bn]) == 0){
    800027d2:	02059493          	slli	s1,a1,0x20
    800027d6:	9081                	srli	s1,s1,0x20
    800027d8:	048a                	slli	s1,s1,0x2
    800027da:	94aa                	add	s1,s1,a0
    800027dc:	0504a903          	lw	s2,80(s1)
    800027e0:	06091e63          	bnez	s2,8000285c <bmap+0xa2>
      addr = balloc(ip->dev);
    800027e4:	4108                	lw	a0,0(a0)
    800027e6:	00000097          	auipc	ra,0x0
    800027ea:	e9c080e7          	jalr	-356(ra) # 80002682 <balloc>
    800027ee:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800027f2:	06090563          	beqz	s2,8000285c <bmap+0xa2>
        return 0;
      ip->addrs[bn] = addr;
    800027f6:	0524a823          	sw	s2,80(s1)
    800027fa:	a08d                	j	8000285c <bmap+0xa2>
    }
    return addr;
  }
  bn -= NDIRECT;
    800027fc:	ff45849b          	addiw	s1,a1,-12
    80002800:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002804:	0ff00793          	li	a5,255
    80002808:	08e7e563          	bltu	a5,a4,80002892 <bmap+0xd8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    8000280c:	08052903          	lw	s2,128(a0)
    80002810:	00091d63          	bnez	s2,8000282a <bmap+0x70>
      addr = balloc(ip->dev);
    80002814:	4108                	lw	a0,0(a0)
    80002816:	00000097          	auipc	ra,0x0
    8000281a:	e6c080e7          	jalr	-404(ra) # 80002682 <balloc>
    8000281e:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002822:	02090d63          	beqz	s2,8000285c <bmap+0xa2>
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002826:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    8000282a:	85ca                	mv	a1,s2
    8000282c:	0009a503          	lw	a0,0(s3)
    80002830:	00000097          	auipc	ra,0x0
    80002834:	b90080e7          	jalr	-1136(ra) # 800023c0 <bread>
    80002838:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000283a:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000283e:	02049593          	slli	a1,s1,0x20
    80002842:	9181                	srli	a1,a1,0x20
    80002844:	058a                	slli	a1,a1,0x2
    80002846:	00b784b3          	add	s1,a5,a1
    8000284a:	0004a903          	lw	s2,0(s1)
    8000284e:	02090063          	beqz	s2,8000286e <bmap+0xb4>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002852:	8552                	mv	a0,s4
    80002854:	00000097          	auipc	ra,0x0
    80002858:	c9c080e7          	jalr	-868(ra) # 800024f0 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    8000285c:	854a                	mv	a0,s2
    8000285e:	70a2                	ld	ra,40(sp)
    80002860:	7402                	ld	s0,32(sp)
    80002862:	64e2                	ld	s1,24(sp)
    80002864:	6942                	ld	s2,16(sp)
    80002866:	69a2                	ld	s3,8(sp)
    80002868:	6a02                	ld	s4,0(sp)
    8000286a:	6145                	addi	sp,sp,48
    8000286c:	8082                	ret
      addr = balloc(ip->dev);
    8000286e:	0009a503          	lw	a0,0(s3)
    80002872:	00000097          	auipc	ra,0x0
    80002876:	e10080e7          	jalr	-496(ra) # 80002682 <balloc>
    8000287a:	0005091b          	sext.w	s2,a0
      if(addr){
    8000287e:	fc090ae3          	beqz	s2,80002852 <bmap+0x98>
        a[bn] = addr;
    80002882:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80002886:	8552                	mv	a0,s4
    80002888:	00001097          	auipc	ra,0x1
    8000288c:	eec080e7          	jalr	-276(ra) # 80003774 <log_write>
    80002890:	b7c9                	j	80002852 <bmap+0x98>
  panic("bmap: out of range");
    80002892:	00006517          	auipc	a0,0x6
    80002896:	c6650513          	addi	a0,a0,-922 # 800084f8 <syscalls+0x128>
    8000289a:	00003097          	auipc	ra,0x3
    8000289e:	438080e7          	jalr	1080(ra) # 80005cd2 <panic>

00000000800028a2 <iget>:
{
    800028a2:	7179                	addi	sp,sp,-48
    800028a4:	f406                	sd	ra,40(sp)
    800028a6:	f022                	sd	s0,32(sp)
    800028a8:	ec26                	sd	s1,24(sp)
    800028aa:	e84a                	sd	s2,16(sp)
    800028ac:	e44e                	sd	s3,8(sp)
    800028ae:	e052                	sd	s4,0(sp)
    800028b0:	1800                	addi	s0,sp,48
    800028b2:	89aa                	mv	s3,a0
    800028b4:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800028b6:	00015517          	auipc	a0,0x15
    800028ba:	ba250513          	addi	a0,a0,-1118 # 80017458 <itable>
    800028be:	00004097          	auipc	ra,0x4
    800028c2:	9ba080e7          	jalr	-1606(ra) # 80006278 <acquire>
  empty = 0;
    800028c6:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800028c8:	00015497          	auipc	s1,0x15
    800028cc:	ba848493          	addi	s1,s1,-1112 # 80017470 <itable+0x18>
    800028d0:	00016697          	auipc	a3,0x16
    800028d4:	63068693          	addi	a3,a3,1584 # 80018f00 <log>
    800028d8:	a039                	j	800028e6 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800028da:	02090b63          	beqz	s2,80002910 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800028de:	08848493          	addi	s1,s1,136
    800028e2:	02d48a63          	beq	s1,a3,80002916 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800028e6:	449c                	lw	a5,8(s1)
    800028e8:	fef059e3          	blez	a5,800028da <iget+0x38>
    800028ec:	4098                	lw	a4,0(s1)
    800028ee:	ff3716e3          	bne	a4,s3,800028da <iget+0x38>
    800028f2:	40d8                	lw	a4,4(s1)
    800028f4:	ff4713e3          	bne	a4,s4,800028da <iget+0x38>
      ip->ref++;
    800028f8:	2785                	addiw	a5,a5,1
    800028fa:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800028fc:	00015517          	auipc	a0,0x15
    80002900:	b5c50513          	addi	a0,a0,-1188 # 80017458 <itable>
    80002904:	00004097          	auipc	ra,0x4
    80002908:	a28080e7          	jalr	-1496(ra) # 8000632c <release>
      return ip;
    8000290c:	8926                	mv	s2,s1
    8000290e:	a03d                	j	8000293c <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002910:	f7f9                	bnez	a5,800028de <iget+0x3c>
    80002912:	8926                	mv	s2,s1
    80002914:	b7e9                	j	800028de <iget+0x3c>
  if(empty == 0)
    80002916:	02090c63          	beqz	s2,8000294e <iget+0xac>
  ip->dev = dev;
    8000291a:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    8000291e:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002922:	4785                	li	a5,1
    80002924:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002928:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    8000292c:	00015517          	auipc	a0,0x15
    80002930:	b2c50513          	addi	a0,a0,-1236 # 80017458 <itable>
    80002934:	00004097          	auipc	ra,0x4
    80002938:	9f8080e7          	jalr	-1544(ra) # 8000632c <release>
}
    8000293c:	854a                	mv	a0,s2
    8000293e:	70a2                	ld	ra,40(sp)
    80002940:	7402                	ld	s0,32(sp)
    80002942:	64e2                	ld	s1,24(sp)
    80002944:	6942                	ld	s2,16(sp)
    80002946:	69a2                	ld	s3,8(sp)
    80002948:	6a02                	ld	s4,0(sp)
    8000294a:	6145                	addi	sp,sp,48
    8000294c:	8082                	ret
    panic("iget: no inodes");
    8000294e:	00006517          	auipc	a0,0x6
    80002952:	bc250513          	addi	a0,a0,-1086 # 80008510 <syscalls+0x140>
    80002956:	00003097          	auipc	ra,0x3
    8000295a:	37c080e7          	jalr	892(ra) # 80005cd2 <panic>

000000008000295e <fsinit>:
fsinit(int dev) {
    8000295e:	7179                	addi	sp,sp,-48
    80002960:	f406                	sd	ra,40(sp)
    80002962:	f022                	sd	s0,32(sp)
    80002964:	ec26                	sd	s1,24(sp)
    80002966:	e84a                	sd	s2,16(sp)
    80002968:	e44e                	sd	s3,8(sp)
    8000296a:	1800                	addi	s0,sp,48
    8000296c:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    8000296e:	4585                	li	a1,1
    80002970:	00000097          	auipc	ra,0x0
    80002974:	a50080e7          	jalr	-1456(ra) # 800023c0 <bread>
    80002978:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    8000297a:	00015997          	auipc	s3,0x15
    8000297e:	abe98993          	addi	s3,s3,-1346 # 80017438 <sb>
    80002982:	02000613          	li	a2,32
    80002986:	05850593          	addi	a1,a0,88
    8000298a:	854e                	mv	a0,s3
    8000298c:	ffffe097          	auipc	ra,0xffffe
    80002990:	84c080e7          	jalr	-1972(ra) # 800001d8 <memmove>
  brelse(bp);
    80002994:	8526                	mv	a0,s1
    80002996:	00000097          	auipc	ra,0x0
    8000299a:	b5a080e7          	jalr	-1190(ra) # 800024f0 <brelse>
  if(sb.magic != FSMAGIC)
    8000299e:	0009a703          	lw	a4,0(s3)
    800029a2:	102037b7          	lui	a5,0x10203
    800029a6:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800029aa:	02f71263          	bne	a4,a5,800029ce <fsinit+0x70>
  initlog(dev, &sb);
    800029ae:	00015597          	auipc	a1,0x15
    800029b2:	a8a58593          	addi	a1,a1,-1398 # 80017438 <sb>
    800029b6:	854a                	mv	a0,s2
    800029b8:	00001097          	auipc	ra,0x1
    800029bc:	b40080e7          	jalr	-1216(ra) # 800034f8 <initlog>
}
    800029c0:	70a2                	ld	ra,40(sp)
    800029c2:	7402                	ld	s0,32(sp)
    800029c4:	64e2                	ld	s1,24(sp)
    800029c6:	6942                	ld	s2,16(sp)
    800029c8:	69a2                	ld	s3,8(sp)
    800029ca:	6145                	addi	sp,sp,48
    800029cc:	8082                	ret
    panic("invalid file system");
    800029ce:	00006517          	auipc	a0,0x6
    800029d2:	b5250513          	addi	a0,a0,-1198 # 80008520 <syscalls+0x150>
    800029d6:	00003097          	auipc	ra,0x3
    800029da:	2fc080e7          	jalr	764(ra) # 80005cd2 <panic>

00000000800029de <iinit>:
{
    800029de:	7179                	addi	sp,sp,-48
    800029e0:	f406                	sd	ra,40(sp)
    800029e2:	f022                	sd	s0,32(sp)
    800029e4:	ec26                	sd	s1,24(sp)
    800029e6:	e84a                	sd	s2,16(sp)
    800029e8:	e44e                	sd	s3,8(sp)
    800029ea:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800029ec:	00006597          	auipc	a1,0x6
    800029f0:	b4c58593          	addi	a1,a1,-1204 # 80008538 <syscalls+0x168>
    800029f4:	00015517          	auipc	a0,0x15
    800029f8:	a6450513          	addi	a0,a0,-1436 # 80017458 <itable>
    800029fc:	00003097          	auipc	ra,0x3
    80002a00:	7ec080e7          	jalr	2028(ra) # 800061e8 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002a04:	00015497          	auipc	s1,0x15
    80002a08:	a7c48493          	addi	s1,s1,-1412 # 80017480 <itable+0x28>
    80002a0c:	00016997          	auipc	s3,0x16
    80002a10:	50498993          	addi	s3,s3,1284 # 80018f10 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002a14:	00006917          	auipc	s2,0x6
    80002a18:	b2c90913          	addi	s2,s2,-1236 # 80008540 <syscalls+0x170>
    80002a1c:	85ca                	mv	a1,s2
    80002a1e:	8526                	mv	a0,s1
    80002a20:	00001097          	auipc	ra,0x1
    80002a24:	e3a080e7          	jalr	-454(ra) # 8000385a <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002a28:	08848493          	addi	s1,s1,136
    80002a2c:	ff3498e3          	bne	s1,s3,80002a1c <iinit+0x3e>
}
    80002a30:	70a2                	ld	ra,40(sp)
    80002a32:	7402                	ld	s0,32(sp)
    80002a34:	64e2                	ld	s1,24(sp)
    80002a36:	6942                	ld	s2,16(sp)
    80002a38:	69a2                	ld	s3,8(sp)
    80002a3a:	6145                	addi	sp,sp,48
    80002a3c:	8082                	ret

0000000080002a3e <ialloc>:
{
    80002a3e:	715d                	addi	sp,sp,-80
    80002a40:	e486                	sd	ra,72(sp)
    80002a42:	e0a2                	sd	s0,64(sp)
    80002a44:	fc26                	sd	s1,56(sp)
    80002a46:	f84a                	sd	s2,48(sp)
    80002a48:	f44e                	sd	s3,40(sp)
    80002a4a:	f052                	sd	s4,32(sp)
    80002a4c:	ec56                	sd	s5,24(sp)
    80002a4e:	e85a                	sd	s6,16(sp)
    80002a50:	e45e                	sd	s7,8(sp)
    80002a52:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a54:	00015717          	auipc	a4,0x15
    80002a58:	9f072703          	lw	a4,-1552(a4) # 80017444 <sb+0xc>
    80002a5c:	4785                	li	a5,1
    80002a5e:	04e7fa63          	bgeu	a5,a4,80002ab2 <ialloc+0x74>
    80002a62:	8aaa                	mv	s5,a0
    80002a64:	8bae                	mv	s7,a1
    80002a66:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002a68:	00015a17          	auipc	s4,0x15
    80002a6c:	9d0a0a13          	addi	s4,s4,-1584 # 80017438 <sb>
    80002a70:	00048b1b          	sext.w	s6,s1
    80002a74:	0044d593          	srli	a1,s1,0x4
    80002a78:	018a2783          	lw	a5,24(s4)
    80002a7c:	9dbd                	addw	a1,a1,a5
    80002a7e:	8556                	mv	a0,s5
    80002a80:	00000097          	auipc	ra,0x0
    80002a84:	940080e7          	jalr	-1728(ra) # 800023c0 <bread>
    80002a88:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002a8a:	05850993          	addi	s3,a0,88
    80002a8e:	00f4f793          	andi	a5,s1,15
    80002a92:	079a                	slli	a5,a5,0x6
    80002a94:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002a96:	00099783          	lh	a5,0(s3)
    80002a9a:	c3a1                	beqz	a5,80002ada <ialloc+0x9c>
    brelse(bp);
    80002a9c:	00000097          	auipc	ra,0x0
    80002aa0:	a54080e7          	jalr	-1452(ra) # 800024f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002aa4:	0485                	addi	s1,s1,1
    80002aa6:	00ca2703          	lw	a4,12(s4)
    80002aaa:	0004879b          	sext.w	a5,s1
    80002aae:	fce7e1e3          	bltu	a5,a4,80002a70 <ialloc+0x32>
  printf("ialloc: no inodes\n");
    80002ab2:	00006517          	auipc	a0,0x6
    80002ab6:	a9650513          	addi	a0,a0,-1386 # 80008548 <syscalls+0x178>
    80002aba:	00003097          	auipc	ra,0x3
    80002abe:	262080e7          	jalr	610(ra) # 80005d1c <printf>
  return 0;
    80002ac2:	4501                	li	a0,0
}
    80002ac4:	60a6                	ld	ra,72(sp)
    80002ac6:	6406                	ld	s0,64(sp)
    80002ac8:	74e2                	ld	s1,56(sp)
    80002aca:	7942                	ld	s2,48(sp)
    80002acc:	79a2                	ld	s3,40(sp)
    80002ace:	7a02                	ld	s4,32(sp)
    80002ad0:	6ae2                	ld	s5,24(sp)
    80002ad2:	6b42                	ld	s6,16(sp)
    80002ad4:	6ba2                	ld	s7,8(sp)
    80002ad6:	6161                	addi	sp,sp,80
    80002ad8:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002ada:	04000613          	li	a2,64
    80002ade:	4581                	li	a1,0
    80002ae0:	854e                	mv	a0,s3
    80002ae2:	ffffd097          	auipc	ra,0xffffd
    80002ae6:	696080e7          	jalr	1686(ra) # 80000178 <memset>
      dip->type = type;
    80002aea:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002aee:	854a                	mv	a0,s2
    80002af0:	00001097          	auipc	ra,0x1
    80002af4:	c84080e7          	jalr	-892(ra) # 80003774 <log_write>
      brelse(bp);
    80002af8:	854a                	mv	a0,s2
    80002afa:	00000097          	auipc	ra,0x0
    80002afe:	9f6080e7          	jalr	-1546(ra) # 800024f0 <brelse>
      return iget(dev, inum);
    80002b02:	85da                	mv	a1,s6
    80002b04:	8556                	mv	a0,s5
    80002b06:	00000097          	auipc	ra,0x0
    80002b0a:	d9c080e7          	jalr	-612(ra) # 800028a2 <iget>
    80002b0e:	bf5d                	j	80002ac4 <ialloc+0x86>

0000000080002b10 <iupdate>:
{
    80002b10:	1101                	addi	sp,sp,-32
    80002b12:	ec06                	sd	ra,24(sp)
    80002b14:	e822                	sd	s0,16(sp)
    80002b16:	e426                	sd	s1,8(sp)
    80002b18:	e04a                	sd	s2,0(sp)
    80002b1a:	1000                	addi	s0,sp,32
    80002b1c:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b1e:	415c                	lw	a5,4(a0)
    80002b20:	0047d79b          	srliw	a5,a5,0x4
    80002b24:	00015597          	auipc	a1,0x15
    80002b28:	92c5a583          	lw	a1,-1748(a1) # 80017450 <sb+0x18>
    80002b2c:	9dbd                	addw	a1,a1,a5
    80002b2e:	4108                	lw	a0,0(a0)
    80002b30:	00000097          	auipc	ra,0x0
    80002b34:	890080e7          	jalr	-1904(ra) # 800023c0 <bread>
    80002b38:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b3a:	05850793          	addi	a5,a0,88
    80002b3e:	40c8                	lw	a0,4(s1)
    80002b40:	893d                	andi	a0,a0,15
    80002b42:	051a                	slli	a0,a0,0x6
    80002b44:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002b46:	04449703          	lh	a4,68(s1)
    80002b4a:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002b4e:	04649703          	lh	a4,70(s1)
    80002b52:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002b56:	04849703          	lh	a4,72(s1)
    80002b5a:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002b5e:	04a49703          	lh	a4,74(s1)
    80002b62:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002b66:	44f8                	lw	a4,76(s1)
    80002b68:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002b6a:	03400613          	li	a2,52
    80002b6e:	05048593          	addi	a1,s1,80
    80002b72:	0531                	addi	a0,a0,12
    80002b74:	ffffd097          	auipc	ra,0xffffd
    80002b78:	664080e7          	jalr	1636(ra) # 800001d8 <memmove>
  log_write(bp);
    80002b7c:	854a                	mv	a0,s2
    80002b7e:	00001097          	auipc	ra,0x1
    80002b82:	bf6080e7          	jalr	-1034(ra) # 80003774 <log_write>
  brelse(bp);
    80002b86:	854a                	mv	a0,s2
    80002b88:	00000097          	auipc	ra,0x0
    80002b8c:	968080e7          	jalr	-1688(ra) # 800024f0 <brelse>
}
    80002b90:	60e2                	ld	ra,24(sp)
    80002b92:	6442                	ld	s0,16(sp)
    80002b94:	64a2                	ld	s1,8(sp)
    80002b96:	6902                	ld	s2,0(sp)
    80002b98:	6105                	addi	sp,sp,32
    80002b9a:	8082                	ret

0000000080002b9c <idup>:
{
    80002b9c:	1101                	addi	sp,sp,-32
    80002b9e:	ec06                	sd	ra,24(sp)
    80002ba0:	e822                	sd	s0,16(sp)
    80002ba2:	e426                	sd	s1,8(sp)
    80002ba4:	1000                	addi	s0,sp,32
    80002ba6:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002ba8:	00015517          	auipc	a0,0x15
    80002bac:	8b050513          	addi	a0,a0,-1872 # 80017458 <itable>
    80002bb0:	00003097          	auipc	ra,0x3
    80002bb4:	6c8080e7          	jalr	1736(ra) # 80006278 <acquire>
  ip->ref++;
    80002bb8:	449c                	lw	a5,8(s1)
    80002bba:	2785                	addiw	a5,a5,1
    80002bbc:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002bbe:	00015517          	auipc	a0,0x15
    80002bc2:	89a50513          	addi	a0,a0,-1894 # 80017458 <itable>
    80002bc6:	00003097          	auipc	ra,0x3
    80002bca:	766080e7          	jalr	1894(ra) # 8000632c <release>
}
    80002bce:	8526                	mv	a0,s1
    80002bd0:	60e2                	ld	ra,24(sp)
    80002bd2:	6442                	ld	s0,16(sp)
    80002bd4:	64a2                	ld	s1,8(sp)
    80002bd6:	6105                	addi	sp,sp,32
    80002bd8:	8082                	ret

0000000080002bda <ilock>:
{
    80002bda:	1101                	addi	sp,sp,-32
    80002bdc:	ec06                	sd	ra,24(sp)
    80002bde:	e822                	sd	s0,16(sp)
    80002be0:	e426                	sd	s1,8(sp)
    80002be2:	e04a                	sd	s2,0(sp)
    80002be4:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002be6:	c115                	beqz	a0,80002c0a <ilock+0x30>
    80002be8:	84aa                	mv	s1,a0
    80002bea:	451c                	lw	a5,8(a0)
    80002bec:	00f05f63          	blez	a5,80002c0a <ilock+0x30>
  acquiresleep(&ip->lock);
    80002bf0:	0541                	addi	a0,a0,16
    80002bf2:	00001097          	auipc	ra,0x1
    80002bf6:	ca2080e7          	jalr	-862(ra) # 80003894 <acquiresleep>
  if(ip->valid == 0){
    80002bfa:	40bc                	lw	a5,64(s1)
    80002bfc:	cf99                	beqz	a5,80002c1a <ilock+0x40>
}
    80002bfe:	60e2                	ld	ra,24(sp)
    80002c00:	6442                	ld	s0,16(sp)
    80002c02:	64a2                	ld	s1,8(sp)
    80002c04:	6902                	ld	s2,0(sp)
    80002c06:	6105                	addi	sp,sp,32
    80002c08:	8082                	ret
    panic("ilock");
    80002c0a:	00006517          	auipc	a0,0x6
    80002c0e:	95650513          	addi	a0,a0,-1706 # 80008560 <syscalls+0x190>
    80002c12:	00003097          	auipc	ra,0x3
    80002c16:	0c0080e7          	jalr	192(ra) # 80005cd2 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c1a:	40dc                	lw	a5,4(s1)
    80002c1c:	0047d79b          	srliw	a5,a5,0x4
    80002c20:	00015597          	auipc	a1,0x15
    80002c24:	8305a583          	lw	a1,-2000(a1) # 80017450 <sb+0x18>
    80002c28:	9dbd                	addw	a1,a1,a5
    80002c2a:	4088                	lw	a0,0(s1)
    80002c2c:	fffff097          	auipc	ra,0xfffff
    80002c30:	794080e7          	jalr	1940(ra) # 800023c0 <bread>
    80002c34:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c36:	05850593          	addi	a1,a0,88
    80002c3a:	40dc                	lw	a5,4(s1)
    80002c3c:	8bbd                	andi	a5,a5,15
    80002c3e:	079a                	slli	a5,a5,0x6
    80002c40:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002c42:	00059783          	lh	a5,0(a1)
    80002c46:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002c4a:	00259783          	lh	a5,2(a1)
    80002c4e:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002c52:	00459783          	lh	a5,4(a1)
    80002c56:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002c5a:	00659783          	lh	a5,6(a1)
    80002c5e:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002c62:	459c                	lw	a5,8(a1)
    80002c64:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002c66:	03400613          	li	a2,52
    80002c6a:	05b1                	addi	a1,a1,12
    80002c6c:	05048513          	addi	a0,s1,80
    80002c70:	ffffd097          	auipc	ra,0xffffd
    80002c74:	568080e7          	jalr	1384(ra) # 800001d8 <memmove>
    brelse(bp);
    80002c78:	854a                	mv	a0,s2
    80002c7a:	00000097          	auipc	ra,0x0
    80002c7e:	876080e7          	jalr	-1930(ra) # 800024f0 <brelse>
    ip->valid = 1;
    80002c82:	4785                	li	a5,1
    80002c84:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002c86:	04449783          	lh	a5,68(s1)
    80002c8a:	fbb5                	bnez	a5,80002bfe <ilock+0x24>
      panic("ilock: no type");
    80002c8c:	00006517          	auipc	a0,0x6
    80002c90:	8dc50513          	addi	a0,a0,-1828 # 80008568 <syscalls+0x198>
    80002c94:	00003097          	auipc	ra,0x3
    80002c98:	03e080e7          	jalr	62(ra) # 80005cd2 <panic>

0000000080002c9c <iunlock>:
{
    80002c9c:	1101                	addi	sp,sp,-32
    80002c9e:	ec06                	sd	ra,24(sp)
    80002ca0:	e822                	sd	s0,16(sp)
    80002ca2:	e426                	sd	s1,8(sp)
    80002ca4:	e04a                	sd	s2,0(sp)
    80002ca6:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002ca8:	c905                	beqz	a0,80002cd8 <iunlock+0x3c>
    80002caa:	84aa                	mv	s1,a0
    80002cac:	01050913          	addi	s2,a0,16
    80002cb0:	854a                	mv	a0,s2
    80002cb2:	00001097          	auipc	ra,0x1
    80002cb6:	c7c080e7          	jalr	-900(ra) # 8000392e <holdingsleep>
    80002cba:	cd19                	beqz	a0,80002cd8 <iunlock+0x3c>
    80002cbc:	449c                	lw	a5,8(s1)
    80002cbe:	00f05d63          	blez	a5,80002cd8 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002cc2:	854a                	mv	a0,s2
    80002cc4:	00001097          	auipc	ra,0x1
    80002cc8:	c26080e7          	jalr	-986(ra) # 800038ea <releasesleep>
}
    80002ccc:	60e2                	ld	ra,24(sp)
    80002cce:	6442                	ld	s0,16(sp)
    80002cd0:	64a2                	ld	s1,8(sp)
    80002cd2:	6902                	ld	s2,0(sp)
    80002cd4:	6105                	addi	sp,sp,32
    80002cd6:	8082                	ret
    panic("iunlock");
    80002cd8:	00006517          	auipc	a0,0x6
    80002cdc:	8a050513          	addi	a0,a0,-1888 # 80008578 <syscalls+0x1a8>
    80002ce0:	00003097          	auipc	ra,0x3
    80002ce4:	ff2080e7          	jalr	-14(ra) # 80005cd2 <panic>

0000000080002ce8 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002ce8:	7179                	addi	sp,sp,-48
    80002cea:	f406                	sd	ra,40(sp)
    80002cec:	f022                	sd	s0,32(sp)
    80002cee:	ec26                	sd	s1,24(sp)
    80002cf0:	e84a                	sd	s2,16(sp)
    80002cf2:	e44e                	sd	s3,8(sp)
    80002cf4:	e052                	sd	s4,0(sp)
    80002cf6:	1800                	addi	s0,sp,48
    80002cf8:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002cfa:	05050493          	addi	s1,a0,80
    80002cfe:	08050913          	addi	s2,a0,128
    80002d02:	a021                	j	80002d0a <itrunc+0x22>
    80002d04:	0491                	addi	s1,s1,4
    80002d06:	01248d63          	beq	s1,s2,80002d20 <itrunc+0x38>
    if(ip->addrs[i]){
    80002d0a:	408c                	lw	a1,0(s1)
    80002d0c:	dde5                	beqz	a1,80002d04 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002d0e:	0009a503          	lw	a0,0(s3)
    80002d12:	00000097          	auipc	ra,0x0
    80002d16:	8f4080e7          	jalr	-1804(ra) # 80002606 <bfree>
      ip->addrs[i] = 0;
    80002d1a:	0004a023          	sw	zero,0(s1)
    80002d1e:	b7dd                	j	80002d04 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002d20:	0809a583          	lw	a1,128(s3)
    80002d24:	e185                	bnez	a1,80002d44 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002d26:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002d2a:	854e                	mv	a0,s3
    80002d2c:	00000097          	auipc	ra,0x0
    80002d30:	de4080e7          	jalr	-540(ra) # 80002b10 <iupdate>
}
    80002d34:	70a2                	ld	ra,40(sp)
    80002d36:	7402                	ld	s0,32(sp)
    80002d38:	64e2                	ld	s1,24(sp)
    80002d3a:	6942                	ld	s2,16(sp)
    80002d3c:	69a2                	ld	s3,8(sp)
    80002d3e:	6a02                	ld	s4,0(sp)
    80002d40:	6145                	addi	sp,sp,48
    80002d42:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002d44:	0009a503          	lw	a0,0(s3)
    80002d48:	fffff097          	auipc	ra,0xfffff
    80002d4c:	678080e7          	jalr	1656(ra) # 800023c0 <bread>
    80002d50:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002d52:	05850493          	addi	s1,a0,88
    80002d56:	45850913          	addi	s2,a0,1112
    80002d5a:	a811                	j	80002d6e <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002d5c:	0009a503          	lw	a0,0(s3)
    80002d60:	00000097          	auipc	ra,0x0
    80002d64:	8a6080e7          	jalr	-1882(ra) # 80002606 <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002d68:	0491                	addi	s1,s1,4
    80002d6a:	01248563          	beq	s1,s2,80002d74 <itrunc+0x8c>
      if(a[j])
    80002d6e:	408c                	lw	a1,0(s1)
    80002d70:	dde5                	beqz	a1,80002d68 <itrunc+0x80>
    80002d72:	b7ed                	j	80002d5c <itrunc+0x74>
    brelse(bp);
    80002d74:	8552                	mv	a0,s4
    80002d76:	fffff097          	auipc	ra,0xfffff
    80002d7a:	77a080e7          	jalr	1914(ra) # 800024f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002d7e:	0809a583          	lw	a1,128(s3)
    80002d82:	0009a503          	lw	a0,0(s3)
    80002d86:	00000097          	auipc	ra,0x0
    80002d8a:	880080e7          	jalr	-1920(ra) # 80002606 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002d8e:	0809a023          	sw	zero,128(s3)
    80002d92:	bf51                	j	80002d26 <itrunc+0x3e>

0000000080002d94 <iput>:
{
    80002d94:	1101                	addi	sp,sp,-32
    80002d96:	ec06                	sd	ra,24(sp)
    80002d98:	e822                	sd	s0,16(sp)
    80002d9a:	e426                	sd	s1,8(sp)
    80002d9c:	e04a                	sd	s2,0(sp)
    80002d9e:	1000                	addi	s0,sp,32
    80002da0:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002da2:	00014517          	auipc	a0,0x14
    80002da6:	6b650513          	addi	a0,a0,1718 # 80017458 <itable>
    80002daa:	00003097          	auipc	ra,0x3
    80002dae:	4ce080e7          	jalr	1230(ra) # 80006278 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002db2:	4498                	lw	a4,8(s1)
    80002db4:	4785                	li	a5,1
    80002db6:	02f70363          	beq	a4,a5,80002ddc <iput+0x48>
  ip->ref--;
    80002dba:	449c                	lw	a5,8(s1)
    80002dbc:	37fd                	addiw	a5,a5,-1
    80002dbe:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002dc0:	00014517          	auipc	a0,0x14
    80002dc4:	69850513          	addi	a0,a0,1688 # 80017458 <itable>
    80002dc8:	00003097          	auipc	ra,0x3
    80002dcc:	564080e7          	jalr	1380(ra) # 8000632c <release>
}
    80002dd0:	60e2                	ld	ra,24(sp)
    80002dd2:	6442                	ld	s0,16(sp)
    80002dd4:	64a2                	ld	s1,8(sp)
    80002dd6:	6902                	ld	s2,0(sp)
    80002dd8:	6105                	addi	sp,sp,32
    80002dda:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002ddc:	40bc                	lw	a5,64(s1)
    80002dde:	dff1                	beqz	a5,80002dba <iput+0x26>
    80002de0:	04a49783          	lh	a5,74(s1)
    80002de4:	fbf9                	bnez	a5,80002dba <iput+0x26>
    acquiresleep(&ip->lock);
    80002de6:	01048913          	addi	s2,s1,16
    80002dea:	854a                	mv	a0,s2
    80002dec:	00001097          	auipc	ra,0x1
    80002df0:	aa8080e7          	jalr	-1368(ra) # 80003894 <acquiresleep>
    release(&itable.lock);
    80002df4:	00014517          	auipc	a0,0x14
    80002df8:	66450513          	addi	a0,a0,1636 # 80017458 <itable>
    80002dfc:	00003097          	auipc	ra,0x3
    80002e00:	530080e7          	jalr	1328(ra) # 8000632c <release>
    itrunc(ip);
    80002e04:	8526                	mv	a0,s1
    80002e06:	00000097          	auipc	ra,0x0
    80002e0a:	ee2080e7          	jalr	-286(ra) # 80002ce8 <itrunc>
    ip->type = 0;
    80002e0e:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002e12:	8526                	mv	a0,s1
    80002e14:	00000097          	auipc	ra,0x0
    80002e18:	cfc080e7          	jalr	-772(ra) # 80002b10 <iupdate>
    ip->valid = 0;
    80002e1c:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002e20:	854a                	mv	a0,s2
    80002e22:	00001097          	auipc	ra,0x1
    80002e26:	ac8080e7          	jalr	-1336(ra) # 800038ea <releasesleep>
    acquire(&itable.lock);
    80002e2a:	00014517          	auipc	a0,0x14
    80002e2e:	62e50513          	addi	a0,a0,1582 # 80017458 <itable>
    80002e32:	00003097          	auipc	ra,0x3
    80002e36:	446080e7          	jalr	1094(ra) # 80006278 <acquire>
    80002e3a:	b741                	j	80002dba <iput+0x26>

0000000080002e3c <iunlockput>:
{
    80002e3c:	1101                	addi	sp,sp,-32
    80002e3e:	ec06                	sd	ra,24(sp)
    80002e40:	e822                	sd	s0,16(sp)
    80002e42:	e426                	sd	s1,8(sp)
    80002e44:	1000                	addi	s0,sp,32
    80002e46:	84aa                	mv	s1,a0
  iunlock(ip);
    80002e48:	00000097          	auipc	ra,0x0
    80002e4c:	e54080e7          	jalr	-428(ra) # 80002c9c <iunlock>
  iput(ip);
    80002e50:	8526                	mv	a0,s1
    80002e52:	00000097          	auipc	ra,0x0
    80002e56:	f42080e7          	jalr	-190(ra) # 80002d94 <iput>
}
    80002e5a:	60e2                	ld	ra,24(sp)
    80002e5c:	6442                	ld	s0,16(sp)
    80002e5e:	64a2                	ld	s1,8(sp)
    80002e60:	6105                	addi	sp,sp,32
    80002e62:	8082                	ret

0000000080002e64 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002e64:	1141                	addi	sp,sp,-16
    80002e66:	e422                	sd	s0,8(sp)
    80002e68:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002e6a:	411c                	lw	a5,0(a0)
    80002e6c:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002e6e:	415c                	lw	a5,4(a0)
    80002e70:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002e72:	04451783          	lh	a5,68(a0)
    80002e76:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002e7a:	04a51783          	lh	a5,74(a0)
    80002e7e:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002e82:	04c56783          	lwu	a5,76(a0)
    80002e86:	e99c                	sd	a5,16(a1)
}
    80002e88:	6422                	ld	s0,8(sp)
    80002e8a:	0141                	addi	sp,sp,16
    80002e8c:	8082                	ret

0000000080002e8e <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002e8e:	457c                	lw	a5,76(a0)
    80002e90:	0ed7e963          	bltu	a5,a3,80002f82 <readi+0xf4>
{
    80002e94:	7159                	addi	sp,sp,-112
    80002e96:	f486                	sd	ra,104(sp)
    80002e98:	f0a2                	sd	s0,96(sp)
    80002e9a:	eca6                	sd	s1,88(sp)
    80002e9c:	e8ca                	sd	s2,80(sp)
    80002e9e:	e4ce                	sd	s3,72(sp)
    80002ea0:	e0d2                	sd	s4,64(sp)
    80002ea2:	fc56                	sd	s5,56(sp)
    80002ea4:	f85a                	sd	s6,48(sp)
    80002ea6:	f45e                	sd	s7,40(sp)
    80002ea8:	f062                	sd	s8,32(sp)
    80002eaa:	ec66                	sd	s9,24(sp)
    80002eac:	e86a                	sd	s10,16(sp)
    80002eae:	e46e                	sd	s11,8(sp)
    80002eb0:	1880                	addi	s0,sp,112
    80002eb2:	8b2a                	mv	s6,a0
    80002eb4:	8bae                	mv	s7,a1
    80002eb6:	8a32                	mv	s4,a2
    80002eb8:	84b6                	mv	s1,a3
    80002eba:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002ebc:	9f35                	addw	a4,a4,a3
    return 0;
    80002ebe:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002ec0:	0ad76063          	bltu	a4,a3,80002f60 <readi+0xd2>
  if(off + n > ip->size)
    80002ec4:	00e7f463          	bgeu	a5,a4,80002ecc <readi+0x3e>
    n = ip->size - off;
    80002ec8:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ecc:	0a0a8963          	beqz	s5,80002f7e <readi+0xf0>
    80002ed0:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ed2:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002ed6:	5c7d                	li	s8,-1
    80002ed8:	a82d                	j	80002f12 <readi+0x84>
    80002eda:	020d1d93          	slli	s11,s10,0x20
    80002ede:	020ddd93          	srli	s11,s11,0x20
    80002ee2:	05890613          	addi	a2,s2,88
    80002ee6:	86ee                	mv	a3,s11
    80002ee8:	963a                	add	a2,a2,a4
    80002eea:	85d2                	mv	a1,s4
    80002eec:	855e                	mv	a0,s7
    80002eee:	fffff097          	auipc	ra,0xfffff
    80002ef2:	a22080e7          	jalr	-1502(ra) # 80001910 <either_copyout>
    80002ef6:	05850d63          	beq	a0,s8,80002f50 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002efa:	854a                	mv	a0,s2
    80002efc:	fffff097          	auipc	ra,0xfffff
    80002f00:	5f4080e7          	jalr	1524(ra) # 800024f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f04:	013d09bb          	addw	s3,s10,s3
    80002f08:	009d04bb          	addw	s1,s10,s1
    80002f0c:	9a6e                	add	s4,s4,s11
    80002f0e:	0559f763          	bgeu	s3,s5,80002f5c <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80002f12:	00a4d59b          	srliw	a1,s1,0xa
    80002f16:	855a                	mv	a0,s6
    80002f18:	00000097          	auipc	ra,0x0
    80002f1c:	8a2080e7          	jalr	-1886(ra) # 800027ba <bmap>
    80002f20:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002f24:	cd85                	beqz	a1,80002f5c <readi+0xce>
    bp = bread(ip->dev, addr);
    80002f26:	000b2503          	lw	a0,0(s6)
    80002f2a:	fffff097          	auipc	ra,0xfffff
    80002f2e:	496080e7          	jalr	1174(ra) # 800023c0 <bread>
    80002f32:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f34:	3ff4f713          	andi	a4,s1,1023
    80002f38:	40ec87bb          	subw	a5,s9,a4
    80002f3c:	413a86bb          	subw	a3,s5,s3
    80002f40:	8d3e                	mv	s10,a5
    80002f42:	2781                	sext.w	a5,a5
    80002f44:	0006861b          	sext.w	a2,a3
    80002f48:	f8f679e3          	bgeu	a2,a5,80002eda <readi+0x4c>
    80002f4c:	8d36                	mv	s10,a3
    80002f4e:	b771                	j	80002eda <readi+0x4c>
      brelse(bp);
    80002f50:	854a                	mv	a0,s2
    80002f52:	fffff097          	auipc	ra,0xfffff
    80002f56:	59e080e7          	jalr	1438(ra) # 800024f0 <brelse>
      tot = -1;
    80002f5a:	59fd                	li	s3,-1
  }
  return tot;
    80002f5c:	0009851b          	sext.w	a0,s3
}
    80002f60:	70a6                	ld	ra,104(sp)
    80002f62:	7406                	ld	s0,96(sp)
    80002f64:	64e6                	ld	s1,88(sp)
    80002f66:	6946                	ld	s2,80(sp)
    80002f68:	69a6                	ld	s3,72(sp)
    80002f6a:	6a06                	ld	s4,64(sp)
    80002f6c:	7ae2                	ld	s5,56(sp)
    80002f6e:	7b42                	ld	s6,48(sp)
    80002f70:	7ba2                	ld	s7,40(sp)
    80002f72:	7c02                	ld	s8,32(sp)
    80002f74:	6ce2                	ld	s9,24(sp)
    80002f76:	6d42                	ld	s10,16(sp)
    80002f78:	6da2                	ld	s11,8(sp)
    80002f7a:	6165                	addi	sp,sp,112
    80002f7c:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f7e:	89d6                	mv	s3,s5
    80002f80:	bff1                	j	80002f5c <readi+0xce>
    return 0;
    80002f82:	4501                	li	a0,0
}
    80002f84:	8082                	ret

0000000080002f86 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002f86:	457c                	lw	a5,76(a0)
    80002f88:	10d7e863          	bltu	a5,a3,80003098 <writei+0x112>
{
    80002f8c:	7159                	addi	sp,sp,-112
    80002f8e:	f486                	sd	ra,104(sp)
    80002f90:	f0a2                	sd	s0,96(sp)
    80002f92:	eca6                	sd	s1,88(sp)
    80002f94:	e8ca                	sd	s2,80(sp)
    80002f96:	e4ce                	sd	s3,72(sp)
    80002f98:	e0d2                	sd	s4,64(sp)
    80002f9a:	fc56                	sd	s5,56(sp)
    80002f9c:	f85a                	sd	s6,48(sp)
    80002f9e:	f45e                	sd	s7,40(sp)
    80002fa0:	f062                	sd	s8,32(sp)
    80002fa2:	ec66                	sd	s9,24(sp)
    80002fa4:	e86a                	sd	s10,16(sp)
    80002fa6:	e46e                	sd	s11,8(sp)
    80002fa8:	1880                	addi	s0,sp,112
    80002faa:	8aaa                	mv	s5,a0
    80002fac:	8bae                	mv	s7,a1
    80002fae:	8a32                	mv	s4,a2
    80002fb0:	8936                	mv	s2,a3
    80002fb2:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002fb4:	00e687bb          	addw	a5,a3,a4
    80002fb8:	0ed7e263          	bltu	a5,a3,8000309c <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002fbc:	00043737          	lui	a4,0x43
    80002fc0:	0ef76063          	bltu	a4,a5,800030a0 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002fc4:	0c0b0863          	beqz	s6,80003094 <writei+0x10e>
    80002fc8:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002fca:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002fce:	5c7d                	li	s8,-1
    80002fd0:	a091                	j	80003014 <writei+0x8e>
    80002fd2:	020d1d93          	slli	s11,s10,0x20
    80002fd6:	020ddd93          	srli	s11,s11,0x20
    80002fda:	05848513          	addi	a0,s1,88
    80002fde:	86ee                	mv	a3,s11
    80002fe0:	8652                	mv	a2,s4
    80002fe2:	85de                	mv	a1,s7
    80002fe4:	953a                	add	a0,a0,a4
    80002fe6:	fffff097          	auipc	ra,0xfffff
    80002fea:	980080e7          	jalr	-1664(ra) # 80001966 <either_copyin>
    80002fee:	07850263          	beq	a0,s8,80003052 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002ff2:	8526                	mv	a0,s1
    80002ff4:	00000097          	auipc	ra,0x0
    80002ff8:	780080e7          	jalr	1920(ra) # 80003774 <log_write>
    brelse(bp);
    80002ffc:	8526                	mv	a0,s1
    80002ffe:	fffff097          	auipc	ra,0xfffff
    80003002:	4f2080e7          	jalr	1266(ra) # 800024f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003006:	013d09bb          	addw	s3,s10,s3
    8000300a:	012d093b          	addw	s2,s10,s2
    8000300e:	9a6e                	add	s4,s4,s11
    80003010:	0569f663          	bgeu	s3,s6,8000305c <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    80003014:	00a9559b          	srliw	a1,s2,0xa
    80003018:	8556                	mv	a0,s5
    8000301a:	fffff097          	auipc	ra,0xfffff
    8000301e:	7a0080e7          	jalr	1952(ra) # 800027ba <bmap>
    80003022:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003026:	c99d                	beqz	a1,8000305c <writei+0xd6>
    bp = bread(ip->dev, addr);
    80003028:	000aa503          	lw	a0,0(s5)
    8000302c:	fffff097          	auipc	ra,0xfffff
    80003030:	394080e7          	jalr	916(ra) # 800023c0 <bread>
    80003034:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003036:	3ff97713          	andi	a4,s2,1023
    8000303a:	40ec87bb          	subw	a5,s9,a4
    8000303e:	413b06bb          	subw	a3,s6,s3
    80003042:	8d3e                	mv	s10,a5
    80003044:	2781                	sext.w	a5,a5
    80003046:	0006861b          	sext.w	a2,a3
    8000304a:	f8f674e3          	bgeu	a2,a5,80002fd2 <writei+0x4c>
    8000304e:	8d36                	mv	s10,a3
    80003050:	b749                	j	80002fd2 <writei+0x4c>
      brelse(bp);
    80003052:	8526                	mv	a0,s1
    80003054:	fffff097          	auipc	ra,0xfffff
    80003058:	49c080e7          	jalr	1180(ra) # 800024f0 <brelse>
  }

  if(off > ip->size)
    8000305c:	04caa783          	lw	a5,76(s5)
    80003060:	0127f463          	bgeu	a5,s2,80003068 <writei+0xe2>
    ip->size = off;
    80003064:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003068:	8556                	mv	a0,s5
    8000306a:	00000097          	auipc	ra,0x0
    8000306e:	aa6080e7          	jalr	-1370(ra) # 80002b10 <iupdate>

  return tot;
    80003072:	0009851b          	sext.w	a0,s3
}
    80003076:	70a6                	ld	ra,104(sp)
    80003078:	7406                	ld	s0,96(sp)
    8000307a:	64e6                	ld	s1,88(sp)
    8000307c:	6946                	ld	s2,80(sp)
    8000307e:	69a6                	ld	s3,72(sp)
    80003080:	6a06                	ld	s4,64(sp)
    80003082:	7ae2                	ld	s5,56(sp)
    80003084:	7b42                	ld	s6,48(sp)
    80003086:	7ba2                	ld	s7,40(sp)
    80003088:	7c02                	ld	s8,32(sp)
    8000308a:	6ce2                	ld	s9,24(sp)
    8000308c:	6d42                	ld	s10,16(sp)
    8000308e:	6da2                	ld	s11,8(sp)
    80003090:	6165                	addi	sp,sp,112
    80003092:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003094:	89da                	mv	s3,s6
    80003096:	bfc9                	j	80003068 <writei+0xe2>
    return -1;
    80003098:	557d                	li	a0,-1
}
    8000309a:	8082                	ret
    return -1;
    8000309c:	557d                	li	a0,-1
    8000309e:	bfe1                	j	80003076 <writei+0xf0>
    return -1;
    800030a0:	557d                	li	a0,-1
    800030a2:	bfd1                	j	80003076 <writei+0xf0>

00000000800030a4 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800030a4:	1141                	addi	sp,sp,-16
    800030a6:	e406                	sd	ra,8(sp)
    800030a8:	e022                	sd	s0,0(sp)
    800030aa:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800030ac:	4639                	li	a2,14
    800030ae:	ffffd097          	auipc	ra,0xffffd
    800030b2:	1a2080e7          	jalr	418(ra) # 80000250 <strncmp>
}
    800030b6:	60a2                	ld	ra,8(sp)
    800030b8:	6402                	ld	s0,0(sp)
    800030ba:	0141                	addi	sp,sp,16
    800030bc:	8082                	ret

00000000800030be <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800030be:	7139                	addi	sp,sp,-64
    800030c0:	fc06                	sd	ra,56(sp)
    800030c2:	f822                	sd	s0,48(sp)
    800030c4:	f426                	sd	s1,40(sp)
    800030c6:	f04a                	sd	s2,32(sp)
    800030c8:	ec4e                	sd	s3,24(sp)
    800030ca:	e852                	sd	s4,16(sp)
    800030cc:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800030ce:	04451703          	lh	a4,68(a0)
    800030d2:	4785                	li	a5,1
    800030d4:	00f71a63          	bne	a4,a5,800030e8 <dirlookup+0x2a>
    800030d8:	892a                	mv	s2,a0
    800030da:	89ae                	mv	s3,a1
    800030dc:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800030de:	457c                	lw	a5,76(a0)
    800030e0:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800030e2:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800030e4:	e79d                	bnez	a5,80003112 <dirlookup+0x54>
    800030e6:	a8a5                	j	8000315e <dirlookup+0xa0>
    panic("dirlookup not DIR");
    800030e8:	00005517          	auipc	a0,0x5
    800030ec:	49850513          	addi	a0,a0,1176 # 80008580 <syscalls+0x1b0>
    800030f0:	00003097          	auipc	ra,0x3
    800030f4:	be2080e7          	jalr	-1054(ra) # 80005cd2 <panic>
      panic("dirlookup read");
    800030f8:	00005517          	auipc	a0,0x5
    800030fc:	4a050513          	addi	a0,a0,1184 # 80008598 <syscalls+0x1c8>
    80003100:	00003097          	auipc	ra,0x3
    80003104:	bd2080e7          	jalr	-1070(ra) # 80005cd2 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003108:	24c1                	addiw	s1,s1,16
    8000310a:	04c92783          	lw	a5,76(s2)
    8000310e:	04f4f763          	bgeu	s1,a5,8000315c <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003112:	4741                	li	a4,16
    80003114:	86a6                	mv	a3,s1
    80003116:	fc040613          	addi	a2,s0,-64
    8000311a:	4581                	li	a1,0
    8000311c:	854a                	mv	a0,s2
    8000311e:	00000097          	auipc	ra,0x0
    80003122:	d70080e7          	jalr	-656(ra) # 80002e8e <readi>
    80003126:	47c1                	li	a5,16
    80003128:	fcf518e3          	bne	a0,a5,800030f8 <dirlookup+0x3a>
    if(de.inum == 0)
    8000312c:	fc045783          	lhu	a5,-64(s0)
    80003130:	dfe1                	beqz	a5,80003108 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003132:	fc240593          	addi	a1,s0,-62
    80003136:	854e                	mv	a0,s3
    80003138:	00000097          	auipc	ra,0x0
    8000313c:	f6c080e7          	jalr	-148(ra) # 800030a4 <namecmp>
    80003140:	f561                	bnez	a0,80003108 <dirlookup+0x4a>
      if(poff)
    80003142:	000a0463          	beqz	s4,8000314a <dirlookup+0x8c>
        *poff = off;
    80003146:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000314a:	fc045583          	lhu	a1,-64(s0)
    8000314e:	00092503          	lw	a0,0(s2)
    80003152:	fffff097          	auipc	ra,0xfffff
    80003156:	750080e7          	jalr	1872(ra) # 800028a2 <iget>
    8000315a:	a011                	j	8000315e <dirlookup+0xa0>
  return 0;
    8000315c:	4501                	li	a0,0
}
    8000315e:	70e2                	ld	ra,56(sp)
    80003160:	7442                	ld	s0,48(sp)
    80003162:	74a2                	ld	s1,40(sp)
    80003164:	7902                	ld	s2,32(sp)
    80003166:	69e2                	ld	s3,24(sp)
    80003168:	6a42                	ld	s4,16(sp)
    8000316a:	6121                	addi	sp,sp,64
    8000316c:	8082                	ret

000000008000316e <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    8000316e:	711d                	addi	sp,sp,-96
    80003170:	ec86                	sd	ra,88(sp)
    80003172:	e8a2                	sd	s0,80(sp)
    80003174:	e4a6                	sd	s1,72(sp)
    80003176:	e0ca                	sd	s2,64(sp)
    80003178:	fc4e                	sd	s3,56(sp)
    8000317a:	f852                	sd	s4,48(sp)
    8000317c:	f456                	sd	s5,40(sp)
    8000317e:	f05a                	sd	s6,32(sp)
    80003180:	ec5e                	sd	s7,24(sp)
    80003182:	e862                	sd	s8,16(sp)
    80003184:	e466                	sd	s9,8(sp)
    80003186:	1080                	addi	s0,sp,96
    80003188:	84aa                	mv	s1,a0
    8000318a:	8b2e                	mv	s6,a1
    8000318c:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    8000318e:	00054703          	lbu	a4,0(a0)
    80003192:	02f00793          	li	a5,47
    80003196:	02f70363          	beq	a4,a5,800031bc <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    8000319a:	ffffe097          	auipc	ra,0xffffe
    8000319e:	cbe080e7          	jalr	-834(ra) # 80000e58 <myproc>
    800031a2:	15053503          	ld	a0,336(a0)
    800031a6:	00000097          	auipc	ra,0x0
    800031aa:	9f6080e7          	jalr	-1546(ra) # 80002b9c <idup>
    800031ae:	89aa                	mv	s3,a0
  while(*path == '/')
    800031b0:	02f00913          	li	s2,47
  len = path - s;
    800031b4:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    800031b6:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800031b8:	4c05                	li	s8,1
    800031ba:	a865                	j	80003272 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    800031bc:	4585                	li	a1,1
    800031be:	4505                	li	a0,1
    800031c0:	fffff097          	auipc	ra,0xfffff
    800031c4:	6e2080e7          	jalr	1762(ra) # 800028a2 <iget>
    800031c8:	89aa                	mv	s3,a0
    800031ca:	b7dd                	j	800031b0 <namex+0x42>
      iunlockput(ip);
    800031cc:	854e                	mv	a0,s3
    800031ce:	00000097          	auipc	ra,0x0
    800031d2:	c6e080e7          	jalr	-914(ra) # 80002e3c <iunlockput>
      return 0;
    800031d6:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800031d8:	854e                	mv	a0,s3
    800031da:	60e6                	ld	ra,88(sp)
    800031dc:	6446                	ld	s0,80(sp)
    800031de:	64a6                	ld	s1,72(sp)
    800031e0:	6906                	ld	s2,64(sp)
    800031e2:	79e2                	ld	s3,56(sp)
    800031e4:	7a42                	ld	s4,48(sp)
    800031e6:	7aa2                	ld	s5,40(sp)
    800031e8:	7b02                	ld	s6,32(sp)
    800031ea:	6be2                	ld	s7,24(sp)
    800031ec:	6c42                	ld	s8,16(sp)
    800031ee:	6ca2                	ld	s9,8(sp)
    800031f0:	6125                	addi	sp,sp,96
    800031f2:	8082                	ret
      iunlock(ip);
    800031f4:	854e                	mv	a0,s3
    800031f6:	00000097          	auipc	ra,0x0
    800031fa:	aa6080e7          	jalr	-1370(ra) # 80002c9c <iunlock>
      return ip;
    800031fe:	bfe9                	j	800031d8 <namex+0x6a>
      iunlockput(ip);
    80003200:	854e                	mv	a0,s3
    80003202:	00000097          	auipc	ra,0x0
    80003206:	c3a080e7          	jalr	-966(ra) # 80002e3c <iunlockput>
      return 0;
    8000320a:	89d2                	mv	s3,s4
    8000320c:	b7f1                	j	800031d8 <namex+0x6a>
  len = path - s;
    8000320e:	40b48633          	sub	a2,s1,a1
    80003212:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    80003216:	094cd463          	bge	s9,s4,8000329e <namex+0x130>
    memmove(name, s, DIRSIZ);
    8000321a:	4639                	li	a2,14
    8000321c:	8556                	mv	a0,s5
    8000321e:	ffffd097          	auipc	ra,0xffffd
    80003222:	fba080e7          	jalr	-70(ra) # 800001d8 <memmove>
  while(*path == '/')
    80003226:	0004c783          	lbu	a5,0(s1)
    8000322a:	01279763          	bne	a5,s2,80003238 <namex+0xca>
    path++;
    8000322e:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003230:	0004c783          	lbu	a5,0(s1)
    80003234:	ff278de3          	beq	a5,s2,8000322e <namex+0xc0>
    ilock(ip);
    80003238:	854e                	mv	a0,s3
    8000323a:	00000097          	auipc	ra,0x0
    8000323e:	9a0080e7          	jalr	-1632(ra) # 80002bda <ilock>
    if(ip->type != T_DIR){
    80003242:	04499783          	lh	a5,68(s3)
    80003246:	f98793e3          	bne	a5,s8,800031cc <namex+0x5e>
    if(nameiparent && *path == '\0'){
    8000324a:	000b0563          	beqz	s6,80003254 <namex+0xe6>
    8000324e:	0004c783          	lbu	a5,0(s1)
    80003252:	d3cd                	beqz	a5,800031f4 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003254:	865e                	mv	a2,s7
    80003256:	85d6                	mv	a1,s5
    80003258:	854e                	mv	a0,s3
    8000325a:	00000097          	auipc	ra,0x0
    8000325e:	e64080e7          	jalr	-412(ra) # 800030be <dirlookup>
    80003262:	8a2a                	mv	s4,a0
    80003264:	dd51                	beqz	a0,80003200 <namex+0x92>
    iunlockput(ip);
    80003266:	854e                	mv	a0,s3
    80003268:	00000097          	auipc	ra,0x0
    8000326c:	bd4080e7          	jalr	-1068(ra) # 80002e3c <iunlockput>
    ip = next;
    80003270:	89d2                	mv	s3,s4
  while(*path == '/')
    80003272:	0004c783          	lbu	a5,0(s1)
    80003276:	05279763          	bne	a5,s2,800032c4 <namex+0x156>
    path++;
    8000327a:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000327c:	0004c783          	lbu	a5,0(s1)
    80003280:	ff278de3          	beq	a5,s2,8000327a <namex+0x10c>
  if(*path == 0)
    80003284:	c79d                	beqz	a5,800032b2 <namex+0x144>
    path++;
    80003286:	85a6                	mv	a1,s1
  len = path - s;
    80003288:	8a5e                	mv	s4,s7
    8000328a:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    8000328c:	01278963          	beq	a5,s2,8000329e <namex+0x130>
    80003290:	dfbd                	beqz	a5,8000320e <namex+0xa0>
    path++;
    80003292:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80003294:	0004c783          	lbu	a5,0(s1)
    80003298:	ff279ce3          	bne	a5,s2,80003290 <namex+0x122>
    8000329c:	bf8d                	j	8000320e <namex+0xa0>
    memmove(name, s, len);
    8000329e:	2601                	sext.w	a2,a2
    800032a0:	8556                	mv	a0,s5
    800032a2:	ffffd097          	auipc	ra,0xffffd
    800032a6:	f36080e7          	jalr	-202(ra) # 800001d8 <memmove>
    name[len] = 0;
    800032aa:	9a56                	add	s4,s4,s5
    800032ac:	000a0023          	sb	zero,0(s4)
    800032b0:	bf9d                	j	80003226 <namex+0xb8>
  if(nameiparent){
    800032b2:	f20b03e3          	beqz	s6,800031d8 <namex+0x6a>
    iput(ip);
    800032b6:	854e                	mv	a0,s3
    800032b8:	00000097          	auipc	ra,0x0
    800032bc:	adc080e7          	jalr	-1316(ra) # 80002d94 <iput>
    return 0;
    800032c0:	4981                	li	s3,0
    800032c2:	bf19                	j	800031d8 <namex+0x6a>
  if(*path == 0)
    800032c4:	d7fd                	beqz	a5,800032b2 <namex+0x144>
  while(*path != '/' && *path != 0)
    800032c6:	0004c783          	lbu	a5,0(s1)
    800032ca:	85a6                	mv	a1,s1
    800032cc:	b7d1                	j	80003290 <namex+0x122>

00000000800032ce <dirlink>:
{
    800032ce:	7139                	addi	sp,sp,-64
    800032d0:	fc06                	sd	ra,56(sp)
    800032d2:	f822                	sd	s0,48(sp)
    800032d4:	f426                	sd	s1,40(sp)
    800032d6:	f04a                	sd	s2,32(sp)
    800032d8:	ec4e                	sd	s3,24(sp)
    800032da:	e852                	sd	s4,16(sp)
    800032dc:	0080                	addi	s0,sp,64
    800032de:	892a                	mv	s2,a0
    800032e0:	8a2e                	mv	s4,a1
    800032e2:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800032e4:	4601                	li	a2,0
    800032e6:	00000097          	auipc	ra,0x0
    800032ea:	dd8080e7          	jalr	-552(ra) # 800030be <dirlookup>
    800032ee:	e93d                	bnez	a0,80003364 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032f0:	04c92483          	lw	s1,76(s2)
    800032f4:	c49d                	beqz	s1,80003322 <dirlink+0x54>
    800032f6:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800032f8:	4741                	li	a4,16
    800032fa:	86a6                	mv	a3,s1
    800032fc:	fc040613          	addi	a2,s0,-64
    80003300:	4581                	li	a1,0
    80003302:	854a                	mv	a0,s2
    80003304:	00000097          	auipc	ra,0x0
    80003308:	b8a080e7          	jalr	-1142(ra) # 80002e8e <readi>
    8000330c:	47c1                	li	a5,16
    8000330e:	06f51163          	bne	a0,a5,80003370 <dirlink+0xa2>
    if(de.inum == 0)
    80003312:	fc045783          	lhu	a5,-64(s0)
    80003316:	c791                	beqz	a5,80003322 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003318:	24c1                	addiw	s1,s1,16
    8000331a:	04c92783          	lw	a5,76(s2)
    8000331e:	fcf4ede3          	bltu	s1,a5,800032f8 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003322:	4639                	li	a2,14
    80003324:	85d2                	mv	a1,s4
    80003326:	fc240513          	addi	a0,s0,-62
    8000332a:	ffffd097          	auipc	ra,0xffffd
    8000332e:	f62080e7          	jalr	-158(ra) # 8000028c <strncpy>
  de.inum = inum;
    80003332:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003336:	4741                	li	a4,16
    80003338:	86a6                	mv	a3,s1
    8000333a:	fc040613          	addi	a2,s0,-64
    8000333e:	4581                	li	a1,0
    80003340:	854a                	mv	a0,s2
    80003342:	00000097          	auipc	ra,0x0
    80003346:	c44080e7          	jalr	-956(ra) # 80002f86 <writei>
    8000334a:	1541                	addi	a0,a0,-16
    8000334c:	00a03533          	snez	a0,a0
    80003350:	40a00533          	neg	a0,a0
}
    80003354:	70e2                	ld	ra,56(sp)
    80003356:	7442                	ld	s0,48(sp)
    80003358:	74a2                	ld	s1,40(sp)
    8000335a:	7902                	ld	s2,32(sp)
    8000335c:	69e2                	ld	s3,24(sp)
    8000335e:	6a42                	ld	s4,16(sp)
    80003360:	6121                	addi	sp,sp,64
    80003362:	8082                	ret
    iput(ip);
    80003364:	00000097          	auipc	ra,0x0
    80003368:	a30080e7          	jalr	-1488(ra) # 80002d94 <iput>
    return -1;
    8000336c:	557d                	li	a0,-1
    8000336e:	b7dd                	j	80003354 <dirlink+0x86>
      panic("dirlink read");
    80003370:	00005517          	auipc	a0,0x5
    80003374:	23850513          	addi	a0,a0,568 # 800085a8 <syscalls+0x1d8>
    80003378:	00003097          	auipc	ra,0x3
    8000337c:	95a080e7          	jalr	-1702(ra) # 80005cd2 <panic>

0000000080003380 <namei>:

struct inode*
namei(char *path)
{
    80003380:	1101                	addi	sp,sp,-32
    80003382:	ec06                	sd	ra,24(sp)
    80003384:	e822                	sd	s0,16(sp)
    80003386:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003388:	fe040613          	addi	a2,s0,-32
    8000338c:	4581                	li	a1,0
    8000338e:	00000097          	auipc	ra,0x0
    80003392:	de0080e7          	jalr	-544(ra) # 8000316e <namex>
}
    80003396:	60e2                	ld	ra,24(sp)
    80003398:	6442                	ld	s0,16(sp)
    8000339a:	6105                	addi	sp,sp,32
    8000339c:	8082                	ret

000000008000339e <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    8000339e:	1141                	addi	sp,sp,-16
    800033a0:	e406                	sd	ra,8(sp)
    800033a2:	e022                	sd	s0,0(sp)
    800033a4:	0800                	addi	s0,sp,16
    800033a6:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800033a8:	4585                	li	a1,1
    800033aa:	00000097          	auipc	ra,0x0
    800033ae:	dc4080e7          	jalr	-572(ra) # 8000316e <namex>
}
    800033b2:	60a2                	ld	ra,8(sp)
    800033b4:	6402                	ld	s0,0(sp)
    800033b6:	0141                	addi	sp,sp,16
    800033b8:	8082                	ret

00000000800033ba <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800033ba:	1101                	addi	sp,sp,-32
    800033bc:	ec06                	sd	ra,24(sp)
    800033be:	e822                	sd	s0,16(sp)
    800033c0:	e426                	sd	s1,8(sp)
    800033c2:	e04a                	sd	s2,0(sp)
    800033c4:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800033c6:	00016917          	auipc	s2,0x16
    800033ca:	b3a90913          	addi	s2,s2,-1222 # 80018f00 <log>
    800033ce:	01892583          	lw	a1,24(s2)
    800033d2:	02892503          	lw	a0,40(s2)
    800033d6:	fffff097          	auipc	ra,0xfffff
    800033da:	fea080e7          	jalr	-22(ra) # 800023c0 <bread>
    800033de:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800033e0:	02c92683          	lw	a3,44(s2)
    800033e4:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800033e6:	02d05763          	blez	a3,80003414 <write_head+0x5a>
    800033ea:	00016797          	auipc	a5,0x16
    800033ee:	b4678793          	addi	a5,a5,-1210 # 80018f30 <log+0x30>
    800033f2:	05c50713          	addi	a4,a0,92
    800033f6:	36fd                	addiw	a3,a3,-1
    800033f8:	1682                	slli	a3,a3,0x20
    800033fa:	9281                	srli	a3,a3,0x20
    800033fc:	068a                	slli	a3,a3,0x2
    800033fe:	00016617          	auipc	a2,0x16
    80003402:	b3660613          	addi	a2,a2,-1226 # 80018f34 <log+0x34>
    80003406:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003408:	4390                	lw	a2,0(a5)
    8000340a:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000340c:	0791                	addi	a5,a5,4
    8000340e:	0711                	addi	a4,a4,4
    80003410:	fed79ce3          	bne	a5,a3,80003408 <write_head+0x4e>
  }
  bwrite(buf);
    80003414:	8526                	mv	a0,s1
    80003416:	fffff097          	auipc	ra,0xfffff
    8000341a:	09c080e7          	jalr	156(ra) # 800024b2 <bwrite>
  brelse(buf);
    8000341e:	8526                	mv	a0,s1
    80003420:	fffff097          	auipc	ra,0xfffff
    80003424:	0d0080e7          	jalr	208(ra) # 800024f0 <brelse>
}
    80003428:	60e2                	ld	ra,24(sp)
    8000342a:	6442                	ld	s0,16(sp)
    8000342c:	64a2                	ld	s1,8(sp)
    8000342e:	6902                	ld	s2,0(sp)
    80003430:	6105                	addi	sp,sp,32
    80003432:	8082                	ret

0000000080003434 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003434:	00016797          	auipc	a5,0x16
    80003438:	af87a783          	lw	a5,-1288(a5) # 80018f2c <log+0x2c>
    8000343c:	0af05d63          	blez	a5,800034f6 <install_trans+0xc2>
{
    80003440:	7139                	addi	sp,sp,-64
    80003442:	fc06                	sd	ra,56(sp)
    80003444:	f822                	sd	s0,48(sp)
    80003446:	f426                	sd	s1,40(sp)
    80003448:	f04a                	sd	s2,32(sp)
    8000344a:	ec4e                	sd	s3,24(sp)
    8000344c:	e852                	sd	s4,16(sp)
    8000344e:	e456                	sd	s5,8(sp)
    80003450:	e05a                	sd	s6,0(sp)
    80003452:	0080                	addi	s0,sp,64
    80003454:	8b2a                	mv	s6,a0
    80003456:	00016a97          	auipc	s5,0x16
    8000345a:	adaa8a93          	addi	s5,s5,-1318 # 80018f30 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000345e:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003460:	00016997          	auipc	s3,0x16
    80003464:	aa098993          	addi	s3,s3,-1376 # 80018f00 <log>
    80003468:	a035                	j	80003494 <install_trans+0x60>
      bunpin(dbuf);
    8000346a:	8526                	mv	a0,s1
    8000346c:	fffff097          	auipc	ra,0xfffff
    80003470:	15e080e7          	jalr	350(ra) # 800025ca <bunpin>
    brelse(lbuf);
    80003474:	854a                	mv	a0,s2
    80003476:	fffff097          	auipc	ra,0xfffff
    8000347a:	07a080e7          	jalr	122(ra) # 800024f0 <brelse>
    brelse(dbuf);
    8000347e:	8526                	mv	a0,s1
    80003480:	fffff097          	auipc	ra,0xfffff
    80003484:	070080e7          	jalr	112(ra) # 800024f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003488:	2a05                	addiw	s4,s4,1
    8000348a:	0a91                	addi	s5,s5,4
    8000348c:	02c9a783          	lw	a5,44(s3)
    80003490:	04fa5963          	bge	s4,a5,800034e2 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003494:	0189a583          	lw	a1,24(s3)
    80003498:	014585bb          	addw	a1,a1,s4
    8000349c:	2585                	addiw	a1,a1,1
    8000349e:	0289a503          	lw	a0,40(s3)
    800034a2:	fffff097          	auipc	ra,0xfffff
    800034a6:	f1e080e7          	jalr	-226(ra) # 800023c0 <bread>
    800034aa:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800034ac:	000aa583          	lw	a1,0(s5)
    800034b0:	0289a503          	lw	a0,40(s3)
    800034b4:	fffff097          	auipc	ra,0xfffff
    800034b8:	f0c080e7          	jalr	-244(ra) # 800023c0 <bread>
    800034bc:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800034be:	40000613          	li	a2,1024
    800034c2:	05890593          	addi	a1,s2,88
    800034c6:	05850513          	addi	a0,a0,88
    800034ca:	ffffd097          	auipc	ra,0xffffd
    800034ce:	d0e080e7          	jalr	-754(ra) # 800001d8 <memmove>
    bwrite(dbuf);  // write dst to disk
    800034d2:	8526                	mv	a0,s1
    800034d4:	fffff097          	auipc	ra,0xfffff
    800034d8:	fde080e7          	jalr	-34(ra) # 800024b2 <bwrite>
    if(recovering == 0)
    800034dc:	f80b1ce3          	bnez	s6,80003474 <install_trans+0x40>
    800034e0:	b769                	j	8000346a <install_trans+0x36>
}
    800034e2:	70e2                	ld	ra,56(sp)
    800034e4:	7442                	ld	s0,48(sp)
    800034e6:	74a2                	ld	s1,40(sp)
    800034e8:	7902                	ld	s2,32(sp)
    800034ea:	69e2                	ld	s3,24(sp)
    800034ec:	6a42                	ld	s4,16(sp)
    800034ee:	6aa2                	ld	s5,8(sp)
    800034f0:	6b02                	ld	s6,0(sp)
    800034f2:	6121                	addi	sp,sp,64
    800034f4:	8082                	ret
    800034f6:	8082                	ret

00000000800034f8 <initlog>:
{
    800034f8:	7179                	addi	sp,sp,-48
    800034fa:	f406                	sd	ra,40(sp)
    800034fc:	f022                	sd	s0,32(sp)
    800034fe:	ec26                	sd	s1,24(sp)
    80003500:	e84a                	sd	s2,16(sp)
    80003502:	e44e                	sd	s3,8(sp)
    80003504:	1800                	addi	s0,sp,48
    80003506:	892a                	mv	s2,a0
    80003508:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000350a:	00016497          	auipc	s1,0x16
    8000350e:	9f648493          	addi	s1,s1,-1546 # 80018f00 <log>
    80003512:	00005597          	auipc	a1,0x5
    80003516:	0a658593          	addi	a1,a1,166 # 800085b8 <syscalls+0x1e8>
    8000351a:	8526                	mv	a0,s1
    8000351c:	00003097          	auipc	ra,0x3
    80003520:	ccc080e7          	jalr	-820(ra) # 800061e8 <initlock>
  log.start = sb->logstart;
    80003524:	0149a583          	lw	a1,20(s3)
    80003528:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000352a:	0109a783          	lw	a5,16(s3)
    8000352e:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003530:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003534:	854a                	mv	a0,s2
    80003536:	fffff097          	auipc	ra,0xfffff
    8000353a:	e8a080e7          	jalr	-374(ra) # 800023c0 <bread>
  log.lh.n = lh->n;
    8000353e:	4d3c                	lw	a5,88(a0)
    80003540:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003542:	02f05563          	blez	a5,8000356c <initlog+0x74>
    80003546:	05c50713          	addi	a4,a0,92
    8000354a:	00016697          	auipc	a3,0x16
    8000354e:	9e668693          	addi	a3,a3,-1562 # 80018f30 <log+0x30>
    80003552:	37fd                	addiw	a5,a5,-1
    80003554:	1782                	slli	a5,a5,0x20
    80003556:	9381                	srli	a5,a5,0x20
    80003558:	078a                	slli	a5,a5,0x2
    8000355a:	06050613          	addi	a2,a0,96
    8000355e:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    80003560:	4310                	lw	a2,0(a4)
    80003562:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    80003564:	0711                	addi	a4,a4,4
    80003566:	0691                	addi	a3,a3,4
    80003568:	fef71ce3          	bne	a4,a5,80003560 <initlog+0x68>
  brelse(buf);
    8000356c:	fffff097          	auipc	ra,0xfffff
    80003570:	f84080e7          	jalr	-124(ra) # 800024f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003574:	4505                	li	a0,1
    80003576:	00000097          	auipc	ra,0x0
    8000357a:	ebe080e7          	jalr	-322(ra) # 80003434 <install_trans>
  log.lh.n = 0;
    8000357e:	00016797          	auipc	a5,0x16
    80003582:	9a07a723          	sw	zero,-1618(a5) # 80018f2c <log+0x2c>
  write_head(); // clear the log
    80003586:	00000097          	auipc	ra,0x0
    8000358a:	e34080e7          	jalr	-460(ra) # 800033ba <write_head>
}
    8000358e:	70a2                	ld	ra,40(sp)
    80003590:	7402                	ld	s0,32(sp)
    80003592:	64e2                	ld	s1,24(sp)
    80003594:	6942                	ld	s2,16(sp)
    80003596:	69a2                	ld	s3,8(sp)
    80003598:	6145                	addi	sp,sp,48
    8000359a:	8082                	ret

000000008000359c <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    8000359c:	1101                	addi	sp,sp,-32
    8000359e:	ec06                	sd	ra,24(sp)
    800035a0:	e822                	sd	s0,16(sp)
    800035a2:	e426                	sd	s1,8(sp)
    800035a4:	e04a                	sd	s2,0(sp)
    800035a6:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800035a8:	00016517          	auipc	a0,0x16
    800035ac:	95850513          	addi	a0,a0,-1704 # 80018f00 <log>
    800035b0:	00003097          	auipc	ra,0x3
    800035b4:	cc8080e7          	jalr	-824(ra) # 80006278 <acquire>
  while(1){
    if(log.committing){
    800035b8:	00016497          	auipc	s1,0x16
    800035bc:	94848493          	addi	s1,s1,-1720 # 80018f00 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035c0:	4979                	li	s2,30
    800035c2:	a039                	j	800035d0 <begin_op+0x34>
      sleep(&log, &log.lock);
    800035c4:	85a6                	mv	a1,s1
    800035c6:	8526                	mv	a0,s1
    800035c8:	ffffe097          	auipc	ra,0xffffe
    800035cc:	f40080e7          	jalr	-192(ra) # 80001508 <sleep>
    if(log.committing){
    800035d0:	50dc                	lw	a5,36(s1)
    800035d2:	fbed                	bnez	a5,800035c4 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035d4:	509c                	lw	a5,32(s1)
    800035d6:	0017871b          	addiw	a4,a5,1
    800035da:	0007069b          	sext.w	a3,a4
    800035de:	0027179b          	slliw	a5,a4,0x2
    800035e2:	9fb9                	addw	a5,a5,a4
    800035e4:	0017979b          	slliw	a5,a5,0x1
    800035e8:	54d8                	lw	a4,44(s1)
    800035ea:	9fb9                	addw	a5,a5,a4
    800035ec:	00f95963          	bge	s2,a5,800035fe <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800035f0:	85a6                	mv	a1,s1
    800035f2:	8526                	mv	a0,s1
    800035f4:	ffffe097          	auipc	ra,0xffffe
    800035f8:	f14080e7          	jalr	-236(ra) # 80001508 <sleep>
    800035fc:	bfd1                	j	800035d0 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800035fe:	00016517          	auipc	a0,0x16
    80003602:	90250513          	addi	a0,a0,-1790 # 80018f00 <log>
    80003606:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80003608:	00003097          	auipc	ra,0x3
    8000360c:	d24080e7          	jalr	-732(ra) # 8000632c <release>
      break;
    }
  }
}
    80003610:	60e2                	ld	ra,24(sp)
    80003612:	6442                	ld	s0,16(sp)
    80003614:	64a2                	ld	s1,8(sp)
    80003616:	6902                	ld	s2,0(sp)
    80003618:	6105                	addi	sp,sp,32
    8000361a:	8082                	ret

000000008000361c <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000361c:	7139                	addi	sp,sp,-64
    8000361e:	fc06                	sd	ra,56(sp)
    80003620:	f822                	sd	s0,48(sp)
    80003622:	f426                	sd	s1,40(sp)
    80003624:	f04a                	sd	s2,32(sp)
    80003626:	ec4e                	sd	s3,24(sp)
    80003628:	e852                	sd	s4,16(sp)
    8000362a:	e456                	sd	s5,8(sp)
    8000362c:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000362e:	00016497          	auipc	s1,0x16
    80003632:	8d248493          	addi	s1,s1,-1838 # 80018f00 <log>
    80003636:	8526                	mv	a0,s1
    80003638:	00003097          	auipc	ra,0x3
    8000363c:	c40080e7          	jalr	-960(ra) # 80006278 <acquire>
  log.outstanding -= 1;
    80003640:	509c                	lw	a5,32(s1)
    80003642:	37fd                	addiw	a5,a5,-1
    80003644:	0007891b          	sext.w	s2,a5
    80003648:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000364a:	50dc                	lw	a5,36(s1)
    8000364c:	efb9                	bnez	a5,800036aa <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    8000364e:	06091663          	bnez	s2,800036ba <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    80003652:	00016497          	auipc	s1,0x16
    80003656:	8ae48493          	addi	s1,s1,-1874 # 80018f00 <log>
    8000365a:	4785                	li	a5,1
    8000365c:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000365e:	8526                	mv	a0,s1
    80003660:	00003097          	auipc	ra,0x3
    80003664:	ccc080e7          	jalr	-820(ra) # 8000632c <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003668:	54dc                	lw	a5,44(s1)
    8000366a:	06f04763          	bgtz	a5,800036d8 <end_op+0xbc>
    acquire(&log.lock);
    8000366e:	00016497          	auipc	s1,0x16
    80003672:	89248493          	addi	s1,s1,-1902 # 80018f00 <log>
    80003676:	8526                	mv	a0,s1
    80003678:	00003097          	auipc	ra,0x3
    8000367c:	c00080e7          	jalr	-1024(ra) # 80006278 <acquire>
    log.committing = 0;
    80003680:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003684:	8526                	mv	a0,s1
    80003686:	ffffe097          	auipc	ra,0xffffe
    8000368a:	ee6080e7          	jalr	-282(ra) # 8000156c <wakeup>
    release(&log.lock);
    8000368e:	8526                	mv	a0,s1
    80003690:	00003097          	auipc	ra,0x3
    80003694:	c9c080e7          	jalr	-868(ra) # 8000632c <release>
}
    80003698:	70e2                	ld	ra,56(sp)
    8000369a:	7442                	ld	s0,48(sp)
    8000369c:	74a2                	ld	s1,40(sp)
    8000369e:	7902                	ld	s2,32(sp)
    800036a0:	69e2                	ld	s3,24(sp)
    800036a2:	6a42                	ld	s4,16(sp)
    800036a4:	6aa2                	ld	s5,8(sp)
    800036a6:	6121                	addi	sp,sp,64
    800036a8:	8082                	ret
    panic("log.committing");
    800036aa:	00005517          	auipc	a0,0x5
    800036ae:	f1650513          	addi	a0,a0,-234 # 800085c0 <syscalls+0x1f0>
    800036b2:	00002097          	auipc	ra,0x2
    800036b6:	620080e7          	jalr	1568(ra) # 80005cd2 <panic>
    wakeup(&log);
    800036ba:	00016497          	auipc	s1,0x16
    800036be:	84648493          	addi	s1,s1,-1978 # 80018f00 <log>
    800036c2:	8526                	mv	a0,s1
    800036c4:	ffffe097          	auipc	ra,0xffffe
    800036c8:	ea8080e7          	jalr	-344(ra) # 8000156c <wakeup>
  release(&log.lock);
    800036cc:	8526                	mv	a0,s1
    800036ce:	00003097          	auipc	ra,0x3
    800036d2:	c5e080e7          	jalr	-930(ra) # 8000632c <release>
  if(do_commit){
    800036d6:	b7c9                	j	80003698 <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    800036d8:	00016a97          	auipc	s5,0x16
    800036dc:	858a8a93          	addi	s5,s5,-1960 # 80018f30 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800036e0:	00016a17          	auipc	s4,0x16
    800036e4:	820a0a13          	addi	s4,s4,-2016 # 80018f00 <log>
    800036e8:	018a2583          	lw	a1,24(s4)
    800036ec:	012585bb          	addw	a1,a1,s2
    800036f0:	2585                	addiw	a1,a1,1
    800036f2:	028a2503          	lw	a0,40(s4)
    800036f6:	fffff097          	auipc	ra,0xfffff
    800036fa:	cca080e7          	jalr	-822(ra) # 800023c0 <bread>
    800036fe:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003700:	000aa583          	lw	a1,0(s5)
    80003704:	028a2503          	lw	a0,40(s4)
    80003708:	fffff097          	auipc	ra,0xfffff
    8000370c:	cb8080e7          	jalr	-840(ra) # 800023c0 <bread>
    80003710:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003712:	40000613          	li	a2,1024
    80003716:	05850593          	addi	a1,a0,88
    8000371a:	05848513          	addi	a0,s1,88
    8000371e:	ffffd097          	auipc	ra,0xffffd
    80003722:	aba080e7          	jalr	-1350(ra) # 800001d8 <memmove>
    bwrite(to);  // write the log
    80003726:	8526                	mv	a0,s1
    80003728:	fffff097          	auipc	ra,0xfffff
    8000372c:	d8a080e7          	jalr	-630(ra) # 800024b2 <bwrite>
    brelse(from);
    80003730:	854e                	mv	a0,s3
    80003732:	fffff097          	auipc	ra,0xfffff
    80003736:	dbe080e7          	jalr	-578(ra) # 800024f0 <brelse>
    brelse(to);
    8000373a:	8526                	mv	a0,s1
    8000373c:	fffff097          	auipc	ra,0xfffff
    80003740:	db4080e7          	jalr	-588(ra) # 800024f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003744:	2905                	addiw	s2,s2,1
    80003746:	0a91                	addi	s5,s5,4
    80003748:	02ca2783          	lw	a5,44(s4)
    8000374c:	f8f94ee3          	blt	s2,a5,800036e8 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003750:	00000097          	auipc	ra,0x0
    80003754:	c6a080e7          	jalr	-918(ra) # 800033ba <write_head>
    install_trans(0); // Now install writes to home locations
    80003758:	4501                	li	a0,0
    8000375a:	00000097          	auipc	ra,0x0
    8000375e:	cda080e7          	jalr	-806(ra) # 80003434 <install_trans>
    log.lh.n = 0;
    80003762:	00015797          	auipc	a5,0x15
    80003766:	7c07a523          	sw	zero,1994(a5) # 80018f2c <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000376a:	00000097          	auipc	ra,0x0
    8000376e:	c50080e7          	jalr	-944(ra) # 800033ba <write_head>
    80003772:	bdf5                	j	8000366e <end_op+0x52>

0000000080003774 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003774:	1101                	addi	sp,sp,-32
    80003776:	ec06                	sd	ra,24(sp)
    80003778:	e822                	sd	s0,16(sp)
    8000377a:	e426                	sd	s1,8(sp)
    8000377c:	e04a                	sd	s2,0(sp)
    8000377e:	1000                	addi	s0,sp,32
    80003780:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003782:	00015917          	auipc	s2,0x15
    80003786:	77e90913          	addi	s2,s2,1918 # 80018f00 <log>
    8000378a:	854a                	mv	a0,s2
    8000378c:	00003097          	auipc	ra,0x3
    80003790:	aec080e7          	jalr	-1300(ra) # 80006278 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003794:	02c92603          	lw	a2,44(s2)
    80003798:	47f5                	li	a5,29
    8000379a:	06c7c563          	blt	a5,a2,80003804 <log_write+0x90>
    8000379e:	00015797          	auipc	a5,0x15
    800037a2:	77e7a783          	lw	a5,1918(a5) # 80018f1c <log+0x1c>
    800037a6:	37fd                	addiw	a5,a5,-1
    800037a8:	04f65e63          	bge	a2,a5,80003804 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800037ac:	00015797          	auipc	a5,0x15
    800037b0:	7747a783          	lw	a5,1908(a5) # 80018f20 <log+0x20>
    800037b4:	06f05063          	blez	a5,80003814 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800037b8:	4781                	li	a5,0
    800037ba:	06c05563          	blez	a2,80003824 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037be:	44cc                	lw	a1,12(s1)
    800037c0:	00015717          	auipc	a4,0x15
    800037c4:	77070713          	addi	a4,a4,1904 # 80018f30 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800037c8:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037ca:	4314                	lw	a3,0(a4)
    800037cc:	04b68c63          	beq	a3,a1,80003824 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800037d0:	2785                	addiw	a5,a5,1
    800037d2:	0711                	addi	a4,a4,4
    800037d4:	fef61be3          	bne	a2,a5,800037ca <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800037d8:	0621                	addi	a2,a2,8
    800037da:	060a                	slli	a2,a2,0x2
    800037dc:	00015797          	auipc	a5,0x15
    800037e0:	72478793          	addi	a5,a5,1828 # 80018f00 <log>
    800037e4:	963e                	add	a2,a2,a5
    800037e6:	44dc                	lw	a5,12(s1)
    800037e8:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800037ea:	8526                	mv	a0,s1
    800037ec:	fffff097          	auipc	ra,0xfffff
    800037f0:	da2080e7          	jalr	-606(ra) # 8000258e <bpin>
    log.lh.n++;
    800037f4:	00015717          	auipc	a4,0x15
    800037f8:	70c70713          	addi	a4,a4,1804 # 80018f00 <log>
    800037fc:	575c                	lw	a5,44(a4)
    800037fe:	2785                	addiw	a5,a5,1
    80003800:	d75c                	sw	a5,44(a4)
    80003802:	a835                	j	8000383e <log_write+0xca>
    panic("too big a transaction");
    80003804:	00005517          	auipc	a0,0x5
    80003808:	dcc50513          	addi	a0,a0,-564 # 800085d0 <syscalls+0x200>
    8000380c:	00002097          	auipc	ra,0x2
    80003810:	4c6080e7          	jalr	1222(ra) # 80005cd2 <panic>
    panic("log_write outside of trans");
    80003814:	00005517          	auipc	a0,0x5
    80003818:	dd450513          	addi	a0,a0,-556 # 800085e8 <syscalls+0x218>
    8000381c:	00002097          	auipc	ra,0x2
    80003820:	4b6080e7          	jalr	1206(ra) # 80005cd2 <panic>
  log.lh.block[i] = b->blockno;
    80003824:	00878713          	addi	a4,a5,8
    80003828:	00271693          	slli	a3,a4,0x2
    8000382c:	00015717          	auipc	a4,0x15
    80003830:	6d470713          	addi	a4,a4,1748 # 80018f00 <log>
    80003834:	9736                	add	a4,a4,a3
    80003836:	44d4                	lw	a3,12(s1)
    80003838:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000383a:	faf608e3          	beq	a2,a5,800037ea <log_write+0x76>
  }
  release(&log.lock);
    8000383e:	00015517          	auipc	a0,0x15
    80003842:	6c250513          	addi	a0,a0,1730 # 80018f00 <log>
    80003846:	00003097          	auipc	ra,0x3
    8000384a:	ae6080e7          	jalr	-1306(ra) # 8000632c <release>
}
    8000384e:	60e2                	ld	ra,24(sp)
    80003850:	6442                	ld	s0,16(sp)
    80003852:	64a2                	ld	s1,8(sp)
    80003854:	6902                	ld	s2,0(sp)
    80003856:	6105                	addi	sp,sp,32
    80003858:	8082                	ret

000000008000385a <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000385a:	1101                	addi	sp,sp,-32
    8000385c:	ec06                	sd	ra,24(sp)
    8000385e:	e822                	sd	s0,16(sp)
    80003860:	e426                	sd	s1,8(sp)
    80003862:	e04a                	sd	s2,0(sp)
    80003864:	1000                	addi	s0,sp,32
    80003866:	84aa                	mv	s1,a0
    80003868:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000386a:	00005597          	auipc	a1,0x5
    8000386e:	d9e58593          	addi	a1,a1,-610 # 80008608 <syscalls+0x238>
    80003872:	0521                	addi	a0,a0,8
    80003874:	00003097          	auipc	ra,0x3
    80003878:	974080e7          	jalr	-1676(ra) # 800061e8 <initlock>
  lk->name = name;
    8000387c:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003880:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003884:	0204a423          	sw	zero,40(s1)
}
    80003888:	60e2                	ld	ra,24(sp)
    8000388a:	6442                	ld	s0,16(sp)
    8000388c:	64a2                	ld	s1,8(sp)
    8000388e:	6902                	ld	s2,0(sp)
    80003890:	6105                	addi	sp,sp,32
    80003892:	8082                	ret

0000000080003894 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003894:	1101                	addi	sp,sp,-32
    80003896:	ec06                	sd	ra,24(sp)
    80003898:	e822                	sd	s0,16(sp)
    8000389a:	e426                	sd	s1,8(sp)
    8000389c:	e04a                	sd	s2,0(sp)
    8000389e:	1000                	addi	s0,sp,32
    800038a0:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800038a2:	00850913          	addi	s2,a0,8
    800038a6:	854a                	mv	a0,s2
    800038a8:	00003097          	auipc	ra,0x3
    800038ac:	9d0080e7          	jalr	-1584(ra) # 80006278 <acquire>
  while (lk->locked) {
    800038b0:	409c                	lw	a5,0(s1)
    800038b2:	cb89                	beqz	a5,800038c4 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800038b4:	85ca                	mv	a1,s2
    800038b6:	8526                	mv	a0,s1
    800038b8:	ffffe097          	auipc	ra,0xffffe
    800038bc:	c50080e7          	jalr	-944(ra) # 80001508 <sleep>
  while (lk->locked) {
    800038c0:	409c                	lw	a5,0(s1)
    800038c2:	fbed                	bnez	a5,800038b4 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800038c4:	4785                	li	a5,1
    800038c6:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800038c8:	ffffd097          	auipc	ra,0xffffd
    800038cc:	590080e7          	jalr	1424(ra) # 80000e58 <myproc>
    800038d0:	591c                	lw	a5,48(a0)
    800038d2:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800038d4:	854a                	mv	a0,s2
    800038d6:	00003097          	auipc	ra,0x3
    800038da:	a56080e7          	jalr	-1450(ra) # 8000632c <release>
}
    800038de:	60e2                	ld	ra,24(sp)
    800038e0:	6442                	ld	s0,16(sp)
    800038e2:	64a2                	ld	s1,8(sp)
    800038e4:	6902                	ld	s2,0(sp)
    800038e6:	6105                	addi	sp,sp,32
    800038e8:	8082                	ret

00000000800038ea <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800038ea:	1101                	addi	sp,sp,-32
    800038ec:	ec06                	sd	ra,24(sp)
    800038ee:	e822                	sd	s0,16(sp)
    800038f0:	e426                	sd	s1,8(sp)
    800038f2:	e04a                	sd	s2,0(sp)
    800038f4:	1000                	addi	s0,sp,32
    800038f6:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800038f8:	00850913          	addi	s2,a0,8
    800038fc:	854a                	mv	a0,s2
    800038fe:	00003097          	auipc	ra,0x3
    80003902:	97a080e7          	jalr	-1670(ra) # 80006278 <acquire>
  lk->locked = 0;
    80003906:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000390a:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    8000390e:	8526                	mv	a0,s1
    80003910:	ffffe097          	auipc	ra,0xffffe
    80003914:	c5c080e7          	jalr	-932(ra) # 8000156c <wakeup>
  release(&lk->lk);
    80003918:	854a                	mv	a0,s2
    8000391a:	00003097          	auipc	ra,0x3
    8000391e:	a12080e7          	jalr	-1518(ra) # 8000632c <release>
}
    80003922:	60e2                	ld	ra,24(sp)
    80003924:	6442                	ld	s0,16(sp)
    80003926:	64a2                	ld	s1,8(sp)
    80003928:	6902                	ld	s2,0(sp)
    8000392a:	6105                	addi	sp,sp,32
    8000392c:	8082                	ret

000000008000392e <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000392e:	7179                	addi	sp,sp,-48
    80003930:	f406                	sd	ra,40(sp)
    80003932:	f022                	sd	s0,32(sp)
    80003934:	ec26                	sd	s1,24(sp)
    80003936:	e84a                	sd	s2,16(sp)
    80003938:	e44e                	sd	s3,8(sp)
    8000393a:	1800                	addi	s0,sp,48
    8000393c:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    8000393e:	00850913          	addi	s2,a0,8
    80003942:	854a                	mv	a0,s2
    80003944:	00003097          	auipc	ra,0x3
    80003948:	934080e7          	jalr	-1740(ra) # 80006278 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000394c:	409c                	lw	a5,0(s1)
    8000394e:	ef99                	bnez	a5,8000396c <holdingsleep+0x3e>
    80003950:	4481                	li	s1,0
  release(&lk->lk);
    80003952:	854a                	mv	a0,s2
    80003954:	00003097          	auipc	ra,0x3
    80003958:	9d8080e7          	jalr	-1576(ra) # 8000632c <release>
  return r;
}
    8000395c:	8526                	mv	a0,s1
    8000395e:	70a2                	ld	ra,40(sp)
    80003960:	7402                	ld	s0,32(sp)
    80003962:	64e2                	ld	s1,24(sp)
    80003964:	6942                	ld	s2,16(sp)
    80003966:	69a2                	ld	s3,8(sp)
    80003968:	6145                	addi	sp,sp,48
    8000396a:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    8000396c:	0284a983          	lw	s3,40(s1)
    80003970:	ffffd097          	auipc	ra,0xffffd
    80003974:	4e8080e7          	jalr	1256(ra) # 80000e58 <myproc>
    80003978:	5904                	lw	s1,48(a0)
    8000397a:	413484b3          	sub	s1,s1,s3
    8000397e:	0014b493          	seqz	s1,s1
    80003982:	bfc1                	j	80003952 <holdingsleep+0x24>

0000000080003984 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003984:	1141                	addi	sp,sp,-16
    80003986:	e406                	sd	ra,8(sp)
    80003988:	e022                	sd	s0,0(sp)
    8000398a:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    8000398c:	00005597          	auipc	a1,0x5
    80003990:	c8c58593          	addi	a1,a1,-884 # 80008618 <syscalls+0x248>
    80003994:	00015517          	auipc	a0,0x15
    80003998:	6b450513          	addi	a0,a0,1716 # 80019048 <ftable>
    8000399c:	00003097          	auipc	ra,0x3
    800039a0:	84c080e7          	jalr	-1972(ra) # 800061e8 <initlock>
}
    800039a4:	60a2                	ld	ra,8(sp)
    800039a6:	6402                	ld	s0,0(sp)
    800039a8:	0141                	addi	sp,sp,16
    800039aa:	8082                	ret

00000000800039ac <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800039ac:	1101                	addi	sp,sp,-32
    800039ae:	ec06                	sd	ra,24(sp)
    800039b0:	e822                	sd	s0,16(sp)
    800039b2:	e426                	sd	s1,8(sp)
    800039b4:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800039b6:	00015517          	auipc	a0,0x15
    800039ba:	69250513          	addi	a0,a0,1682 # 80019048 <ftable>
    800039be:	00003097          	auipc	ra,0x3
    800039c2:	8ba080e7          	jalr	-1862(ra) # 80006278 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039c6:	00015497          	auipc	s1,0x15
    800039ca:	69a48493          	addi	s1,s1,1690 # 80019060 <ftable+0x18>
    800039ce:	00016717          	auipc	a4,0x16
    800039d2:	63270713          	addi	a4,a4,1586 # 8001a000 <disk>
    if(f->ref == 0){
    800039d6:	40dc                	lw	a5,4(s1)
    800039d8:	cf99                	beqz	a5,800039f6 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039da:	02848493          	addi	s1,s1,40
    800039de:	fee49ce3          	bne	s1,a4,800039d6 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800039e2:	00015517          	auipc	a0,0x15
    800039e6:	66650513          	addi	a0,a0,1638 # 80019048 <ftable>
    800039ea:	00003097          	auipc	ra,0x3
    800039ee:	942080e7          	jalr	-1726(ra) # 8000632c <release>
  return 0;
    800039f2:	4481                	li	s1,0
    800039f4:	a819                	j	80003a0a <filealloc+0x5e>
      f->ref = 1;
    800039f6:	4785                	li	a5,1
    800039f8:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800039fa:	00015517          	auipc	a0,0x15
    800039fe:	64e50513          	addi	a0,a0,1614 # 80019048 <ftable>
    80003a02:	00003097          	auipc	ra,0x3
    80003a06:	92a080e7          	jalr	-1750(ra) # 8000632c <release>
}
    80003a0a:	8526                	mv	a0,s1
    80003a0c:	60e2                	ld	ra,24(sp)
    80003a0e:	6442                	ld	s0,16(sp)
    80003a10:	64a2                	ld	s1,8(sp)
    80003a12:	6105                	addi	sp,sp,32
    80003a14:	8082                	ret

0000000080003a16 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003a16:	1101                	addi	sp,sp,-32
    80003a18:	ec06                	sd	ra,24(sp)
    80003a1a:	e822                	sd	s0,16(sp)
    80003a1c:	e426                	sd	s1,8(sp)
    80003a1e:	1000                	addi	s0,sp,32
    80003a20:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003a22:	00015517          	auipc	a0,0x15
    80003a26:	62650513          	addi	a0,a0,1574 # 80019048 <ftable>
    80003a2a:	00003097          	auipc	ra,0x3
    80003a2e:	84e080e7          	jalr	-1970(ra) # 80006278 <acquire>
  if(f->ref < 1)
    80003a32:	40dc                	lw	a5,4(s1)
    80003a34:	02f05263          	blez	a5,80003a58 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003a38:	2785                	addiw	a5,a5,1
    80003a3a:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003a3c:	00015517          	auipc	a0,0x15
    80003a40:	60c50513          	addi	a0,a0,1548 # 80019048 <ftable>
    80003a44:	00003097          	auipc	ra,0x3
    80003a48:	8e8080e7          	jalr	-1816(ra) # 8000632c <release>
  return f;
}
    80003a4c:	8526                	mv	a0,s1
    80003a4e:	60e2                	ld	ra,24(sp)
    80003a50:	6442                	ld	s0,16(sp)
    80003a52:	64a2                	ld	s1,8(sp)
    80003a54:	6105                	addi	sp,sp,32
    80003a56:	8082                	ret
    panic("filedup");
    80003a58:	00005517          	auipc	a0,0x5
    80003a5c:	bc850513          	addi	a0,a0,-1080 # 80008620 <syscalls+0x250>
    80003a60:	00002097          	auipc	ra,0x2
    80003a64:	272080e7          	jalr	626(ra) # 80005cd2 <panic>

0000000080003a68 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003a68:	7139                	addi	sp,sp,-64
    80003a6a:	fc06                	sd	ra,56(sp)
    80003a6c:	f822                	sd	s0,48(sp)
    80003a6e:	f426                	sd	s1,40(sp)
    80003a70:	f04a                	sd	s2,32(sp)
    80003a72:	ec4e                	sd	s3,24(sp)
    80003a74:	e852                	sd	s4,16(sp)
    80003a76:	e456                	sd	s5,8(sp)
    80003a78:	0080                	addi	s0,sp,64
    80003a7a:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003a7c:	00015517          	auipc	a0,0x15
    80003a80:	5cc50513          	addi	a0,a0,1484 # 80019048 <ftable>
    80003a84:	00002097          	auipc	ra,0x2
    80003a88:	7f4080e7          	jalr	2036(ra) # 80006278 <acquire>
  if(f->ref < 1)
    80003a8c:	40dc                	lw	a5,4(s1)
    80003a8e:	06f05163          	blez	a5,80003af0 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003a92:	37fd                	addiw	a5,a5,-1
    80003a94:	0007871b          	sext.w	a4,a5
    80003a98:	c0dc                	sw	a5,4(s1)
    80003a9a:	06e04363          	bgtz	a4,80003b00 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003a9e:	0004a903          	lw	s2,0(s1)
    80003aa2:	0094ca83          	lbu	s5,9(s1)
    80003aa6:	0104ba03          	ld	s4,16(s1)
    80003aaa:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003aae:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003ab2:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003ab6:	00015517          	auipc	a0,0x15
    80003aba:	59250513          	addi	a0,a0,1426 # 80019048 <ftable>
    80003abe:	00003097          	auipc	ra,0x3
    80003ac2:	86e080e7          	jalr	-1938(ra) # 8000632c <release>

  if(ff.type == FD_PIPE){
    80003ac6:	4785                	li	a5,1
    80003ac8:	04f90d63          	beq	s2,a5,80003b22 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003acc:	3979                	addiw	s2,s2,-2
    80003ace:	4785                	li	a5,1
    80003ad0:	0527e063          	bltu	a5,s2,80003b10 <fileclose+0xa8>
    begin_op();
    80003ad4:	00000097          	auipc	ra,0x0
    80003ad8:	ac8080e7          	jalr	-1336(ra) # 8000359c <begin_op>
    iput(ff.ip);
    80003adc:	854e                	mv	a0,s3
    80003ade:	fffff097          	auipc	ra,0xfffff
    80003ae2:	2b6080e7          	jalr	694(ra) # 80002d94 <iput>
    end_op();
    80003ae6:	00000097          	auipc	ra,0x0
    80003aea:	b36080e7          	jalr	-1226(ra) # 8000361c <end_op>
    80003aee:	a00d                	j	80003b10 <fileclose+0xa8>
    panic("fileclose");
    80003af0:	00005517          	auipc	a0,0x5
    80003af4:	b3850513          	addi	a0,a0,-1224 # 80008628 <syscalls+0x258>
    80003af8:	00002097          	auipc	ra,0x2
    80003afc:	1da080e7          	jalr	474(ra) # 80005cd2 <panic>
    release(&ftable.lock);
    80003b00:	00015517          	auipc	a0,0x15
    80003b04:	54850513          	addi	a0,a0,1352 # 80019048 <ftable>
    80003b08:	00003097          	auipc	ra,0x3
    80003b0c:	824080e7          	jalr	-2012(ra) # 8000632c <release>
  }
}
    80003b10:	70e2                	ld	ra,56(sp)
    80003b12:	7442                	ld	s0,48(sp)
    80003b14:	74a2                	ld	s1,40(sp)
    80003b16:	7902                	ld	s2,32(sp)
    80003b18:	69e2                	ld	s3,24(sp)
    80003b1a:	6a42                	ld	s4,16(sp)
    80003b1c:	6aa2                	ld	s5,8(sp)
    80003b1e:	6121                	addi	sp,sp,64
    80003b20:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003b22:	85d6                	mv	a1,s5
    80003b24:	8552                	mv	a0,s4
    80003b26:	00000097          	auipc	ra,0x0
    80003b2a:	34c080e7          	jalr	844(ra) # 80003e72 <pipeclose>
    80003b2e:	b7cd                	j	80003b10 <fileclose+0xa8>

0000000080003b30 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003b30:	715d                	addi	sp,sp,-80
    80003b32:	e486                	sd	ra,72(sp)
    80003b34:	e0a2                	sd	s0,64(sp)
    80003b36:	fc26                	sd	s1,56(sp)
    80003b38:	f84a                	sd	s2,48(sp)
    80003b3a:	f44e                	sd	s3,40(sp)
    80003b3c:	0880                	addi	s0,sp,80
    80003b3e:	84aa                	mv	s1,a0
    80003b40:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003b42:	ffffd097          	auipc	ra,0xffffd
    80003b46:	316080e7          	jalr	790(ra) # 80000e58 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003b4a:	409c                	lw	a5,0(s1)
    80003b4c:	37f9                	addiw	a5,a5,-2
    80003b4e:	4705                	li	a4,1
    80003b50:	04f76763          	bltu	a4,a5,80003b9e <filestat+0x6e>
    80003b54:	892a                	mv	s2,a0
    ilock(f->ip);
    80003b56:	6c88                	ld	a0,24(s1)
    80003b58:	fffff097          	auipc	ra,0xfffff
    80003b5c:	082080e7          	jalr	130(ra) # 80002bda <ilock>
    stati(f->ip, &st);
    80003b60:	fb840593          	addi	a1,s0,-72
    80003b64:	6c88                	ld	a0,24(s1)
    80003b66:	fffff097          	auipc	ra,0xfffff
    80003b6a:	2fe080e7          	jalr	766(ra) # 80002e64 <stati>
    iunlock(f->ip);
    80003b6e:	6c88                	ld	a0,24(s1)
    80003b70:	fffff097          	auipc	ra,0xfffff
    80003b74:	12c080e7          	jalr	300(ra) # 80002c9c <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003b78:	46e1                	li	a3,24
    80003b7a:	fb840613          	addi	a2,s0,-72
    80003b7e:	85ce                	mv	a1,s3
    80003b80:	05093503          	ld	a0,80(s2)
    80003b84:	ffffd097          	auipc	ra,0xffffd
    80003b88:	f92080e7          	jalr	-110(ra) # 80000b16 <copyout>
    80003b8c:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003b90:	60a6                	ld	ra,72(sp)
    80003b92:	6406                	ld	s0,64(sp)
    80003b94:	74e2                	ld	s1,56(sp)
    80003b96:	7942                	ld	s2,48(sp)
    80003b98:	79a2                	ld	s3,40(sp)
    80003b9a:	6161                	addi	sp,sp,80
    80003b9c:	8082                	ret
  return -1;
    80003b9e:	557d                	li	a0,-1
    80003ba0:	bfc5                	j	80003b90 <filestat+0x60>

0000000080003ba2 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003ba2:	7179                	addi	sp,sp,-48
    80003ba4:	f406                	sd	ra,40(sp)
    80003ba6:	f022                	sd	s0,32(sp)
    80003ba8:	ec26                	sd	s1,24(sp)
    80003baa:	e84a                	sd	s2,16(sp)
    80003bac:	e44e                	sd	s3,8(sp)
    80003bae:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003bb0:	00854783          	lbu	a5,8(a0)
    80003bb4:	c3d5                	beqz	a5,80003c58 <fileread+0xb6>
    80003bb6:	84aa                	mv	s1,a0
    80003bb8:	89ae                	mv	s3,a1
    80003bba:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003bbc:	411c                	lw	a5,0(a0)
    80003bbe:	4705                	li	a4,1
    80003bc0:	04e78963          	beq	a5,a4,80003c12 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003bc4:	470d                	li	a4,3
    80003bc6:	04e78d63          	beq	a5,a4,80003c20 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003bca:	4709                	li	a4,2
    80003bcc:	06e79e63          	bne	a5,a4,80003c48 <fileread+0xa6>
    ilock(f->ip);
    80003bd0:	6d08                	ld	a0,24(a0)
    80003bd2:	fffff097          	auipc	ra,0xfffff
    80003bd6:	008080e7          	jalr	8(ra) # 80002bda <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003bda:	874a                	mv	a4,s2
    80003bdc:	5094                	lw	a3,32(s1)
    80003bde:	864e                	mv	a2,s3
    80003be0:	4585                	li	a1,1
    80003be2:	6c88                	ld	a0,24(s1)
    80003be4:	fffff097          	auipc	ra,0xfffff
    80003be8:	2aa080e7          	jalr	682(ra) # 80002e8e <readi>
    80003bec:	892a                	mv	s2,a0
    80003bee:	00a05563          	blez	a0,80003bf8 <fileread+0x56>
      f->off += r;
    80003bf2:	509c                	lw	a5,32(s1)
    80003bf4:	9fa9                	addw	a5,a5,a0
    80003bf6:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003bf8:	6c88                	ld	a0,24(s1)
    80003bfa:	fffff097          	auipc	ra,0xfffff
    80003bfe:	0a2080e7          	jalr	162(ra) # 80002c9c <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003c02:	854a                	mv	a0,s2
    80003c04:	70a2                	ld	ra,40(sp)
    80003c06:	7402                	ld	s0,32(sp)
    80003c08:	64e2                	ld	s1,24(sp)
    80003c0a:	6942                	ld	s2,16(sp)
    80003c0c:	69a2                	ld	s3,8(sp)
    80003c0e:	6145                	addi	sp,sp,48
    80003c10:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003c12:	6908                	ld	a0,16(a0)
    80003c14:	00000097          	auipc	ra,0x0
    80003c18:	3ce080e7          	jalr	974(ra) # 80003fe2 <piperead>
    80003c1c:	892a                	mv	s2,a0
    80003c1e:	b7d5                	j	80003c02 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003c20:	02451783          	lh	a5,36(a0)
    80003c24:	03079693          	slli	a3,a5,0x30
    80003c28:	92c1                	srli	a3,a3,0x30
    80003c2a:	4725                	li	a4,9
    80003c2c:	02d76863          	bltu	a4,a3,80003c5c <fileread+0xba>
    80003c30:	0792                	slli	a5,a5,0x4
    80003c32:	00015717          	auipc	a4,0x15
    80003c36:	37670713          	addi	a4,a4,886 # 80018fa8 <devsw>
    80003c3a:	97ba                	add	a5,a5,a4
    80003c3c:	639c                	ld	a5,0(a5)
    80003c3e:	c38d                	beqz	a5,80003c60 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003c40:	4505                	li	a0,1
    80003c42:	9782                	jalr	a5
    80003c44:	892a                	mv	s2,a0
    80003c46:	bf75                	j	80003c02 <fileread+0x60>
    panic("fileread");
    80003c48:	00005517          	auipc	a0,0x5
    80003c4c:	9f050513          	addi	a0,a0,-1552 # 80008638 <syscalls+0x268>
    80003c50:	00002097          	auipc	ra,0x2
    80003c54:	082080e7          	jalr	130(ra) # 80005cd2 <panic>
    return -1;
    80003c58:	597d                	li	s2,-1
    80003c5a:	b765                	j	80003c02 <fileread+0x60>
      return -1;
    80003c5c:	597d                	li	s2,-1
    80003c5e:	b755                	j	80003c02 <fileread+0x60>
    80003c60:	597d                	li	s2,-1
    80003c62:	b745                	j	80003c02 <fileread+0x60>

0000000080003c64 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003c64:	715d                	addi	sp,sp,-80
    80003c66:	e486                	sd	ra,72(sp)
    80003c68:	e0a2                	sd	s0,64(sp)
    80003c6a:	fc26                	sd	s1,56(sp)
    80003c6c:	f84a                	sd	s2,48(sp)
    80003c6e:	f44e                	sd	s3,40(sp)
    80003c70:	f052                	sd	s4,32(sp)
    80003c72:	ec56                	sd	s5,24(sp)
    80003c74:	e85a                	sd	s6,16(sp)
    80003c76:	e45e                	sd	s7,8(sp)
    80003c78:	e062                	sd	s8,0(sp)
    80003c7a:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003c7c:	00954783          	lbu	a5,9(a0)
    80003c80:	10078663          	beqz	a5,80003d8c <filewrite+0x128>
    80003c84:	892a                	mv	s2,a0
    80003c86:	8aae                	mv	s5,a1
    80003c88:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c8a:	411c                	lw	a5,0(a0)
    80003c8c:	4705                	li	a4,1
    80003c8e:	02e78263          	beq	a5,a4,80003cb2 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c92:	470d                	li	a4,3
    80003c94:	02e78663          	beq	a5,a4,80003cc0 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c98:	4709                	li	a4,2
    80003c9a:	0ee79163          	bne	a5,a4,80003d7c <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003c9e:	0ac05d63          	blez	a2,80003d58 <filewrite+0xf4>
    int i = 0;
    80003ca2:	4981                	li	s3,0
    80003ca4:	6b05                	lui	s6,0x1
    80003ca6:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003caa:	6b85                	lui	s7,0x1
    80003cac:	c00b8b9b          	addiw	s7,s7,-1024
    80003cb0:	a861                	j	80003d48 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003cb2:	6908                	ld	a0,16(a0)
    80003cb4:	00000097          	auipc	ra,0x0
    80003cb8:	22e080e7          	jalr	558(ra) # 80003ee2 <pipewrite>
    80003cbc:	8a2a                	mv	s4,a0
    80003cbe:	a045                	j	80003d5e <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003cc0:	02451783          	lh	a5,36(a0)
    80003cc4:	03079693          	slli	a3,a5,0x30
    80003cc8:	92c1                	srli	a3,a3,0x30
    80003cca:	4725                	li	a4,9
    80003ccc:	0cd76263          	bltu	a4,a3,80003d90 <filewrite+0x12c>
    80003cd0:	0792                	slli	a5,a5,0x4
    80003cd2:	00015717          	auipc	a4,0x15
    80003cd6:	2d670713          	addi	a4,a4,726 # 80018fa8 <devsw>
    80003cda:	97ba                	add	a5,a5,a4
    80003cdc:	679c                	ld	a5,8(a5)
    80003cde:	cbdd                	beqz	a5,80003d94 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003ce0:	4505                	li	a0,1
    80003ce2:	9782                	jalr	a5
    80003ce4:	8a2a                	mv	s4,a0
    80003ce6:	a8a5                	j	80003d5e <filewrite+0xfa>
    80003ce8:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003cec:	00000097          	auipc	ra,0x0
    80003cf0:	8b0080e7          	jalr	-1872(ra) # 8000359c <begin_op>
      ilock(f->ip);
    80003cf4:	01893503          	ld	a0,24(s2)
    80003cf8:	fffff097          	auipc	ra,0xfffff
    80003cfc:	ee2080e7          	jalr	-286(ra) # 80002bda <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003d00:	8762                	mv	a4,s8
    80003d02:	02092683          	lw	a3,32(s2)
    80003d06:	01598633          	add	a2,s3,s5
    80003d0a:	4585                	li	a1,1
    80003d0c:	01893503          	ld	a0,24(s2)
    80003d10:	fffff097          	auipc	ra,0xfffff
    80003d14:	276080e7          	jalr	630(ra) # 80002f86 <writei>
    80003d18:	84aa                	mv	s1,a0
    80003d1a:	00a05763          	blez	a0,80003d28 <filewrite+0xc4>
        f->off += r;
    80003d1e:	02092783          	lw	a5,32(s2)
    80003d22:	9fa9                	addw	a5,a5,a0
    80003d24:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003d28:	01893503          	ld	a0,24(s2)
    80003d2c:	fffff097          	auipc	ra,0xfffff
    80003d30:	f70080e7          	jalr	-144(ra) # 80002c9c <iunlock>
      end_op();
    80003d34:	00000097          	auipc	ra,0x0
    80003d38:	8e8080e7          	jalr	-1816(ra) # 8000361c <end_op>

      if(r != n1){
    80003d3c:	009c1f63          	bne	s8,s1,80003d5a <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003d40:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003d44:	0149db63          	bge	s3,s4,80003d5a <filewrite+0xf6>
      int n1 = n - i;
    80003d48:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003d4c:	84be                	mv	s1,a5
    80003d4e:	2781                	sext.w	a5,a5
    80003d50:	f8fb5ce3          	bge	s6,a5,80003ce8 <filewrite+0x84>
    80003d54:	84de                	mv	s1,s7
    80003d56:	bf49                	j	80003ce8 <filewrite+0x84>
    int i = 0;
    80003d58:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003d5a:	013a1f63          	bne	s4,s3,80003d78 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003d5e:	8552                	mv	a0,s4
    80003d60:	60a6                	ld	ra,72(sp)
    80003d62:	6406                	ld	s0,64(sp)
    80003d64:	74e2                	ld	s1,56(sp)
    80003d66:	7942                	ld	s2,48(sp)
    80003d68:	79a2                	ld	s3,40(sp)
    80003d6a:	7a02                	ld	s4,32(sp)
    80003d6c:	6ae2                	ld	s5,24(sp)
    80003d6e:	6b42                	ld	s6,16(sp)
    80003d70:	6ba2                	ld	s7,8(sp)
    80003d72:	6c02                	ld	s8,0(sp)
    80003d74:	6161                	addi	sp,sp,80
    80003d76:	8082                	ret
    ret = (i == n ? n : -1);
    80003d78:	5a7d                	li	s4,-1
    80003d7a:	b7d5                	j	80003d5e <filewrite+0xfa>
    panic("filewrite");
    80003d7c:	00005517          	auipc	a0,0x5
    80003d80:	8cc50513          	addi	a0,a0,-1844 # 80008648 <syscalls+0x278>
    80003d84:	00002097          	auipc	ra,0x2
    80003d88:	f4e080e7          	jalr	-178(ra) # 80005cd2 <panic>
    return -1;
    80003d8c:	5a7d                	li	s4,-1
    80003d8e:	bfc1                	j	80003d5e <filewrite+0xfa>
      return -1;
    80003d90:	5a7d                	li	s4,-1
    80003d92:	b7f1                	j	80003d5e <filewrite+0xfa>
    80003d94:	5a7d                	li	s4,-1
    80003d96:	b7e1                	j	80003d5e <filewrite+0xfa>

0000000080003d98 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003d98:	7179                	addi	sp,sp,-48
    80003d9a:	f406                	sd	ra,40(sp)
    80003d9c:	f022                	sd	s0,32(sp)
    80003d9e:	ec26                	sd	s1,24(sp)
    80003da0:	e84a                	sd	s2,16(sp)
    80003da2:	e44e                	sd	s3,8(sp)
    80003da4:	e052                	sd	s4,0(sp)
    80003da6:	1800                	addi	s0,sp,48
    80003da8:	84aa                	mv	s1,a0
    80003daa:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003dac:	0005b023          	sd	zero,0(a1)
    80003db0:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003db4:	00000097          	auipc	ra,0x0
    80003db8:	bf8080e7          	jalr	-1032(ra) # 800039ac <filealloc>
    80003dbc:	e088                	sd	a0,0(s1)
    80003dbe:	c551                	beqz	a0,80003e4a <pipealloc+0xb2>
    80003dc0:	00000097          	auipc	ra,0x0
    80003dc4:	bec080e7          	jalr	-1044(ra) # 800039ac <filealloc>
    80003dc8:	00aa3023          	sd	a0,0(s4)
    80003dcc:	c92d                	beqz	a0,80003e3e <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003dce:	ffffc097          	auipc	ra,0xffffc
    80003dd2:	34a080e7          	jalr	842(ra) # 80000118 <kalloc>
    80003dd6:	892a                	mv	s2,a0
    80003dd8:	c125                	beqz	a0,80003e38 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003dda:	4985                	li	s3,1
    80003ddc:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003de0:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003de4:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003de8:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003dec:	00005597          	auipc	a1,0x5
    80003df0:	86c58593          	addi	a1,a1,-1940 # 80008658 <syscalls+0x288>
    80003df4:	00002097          	auipc	ra,0x2
    80003df8:	3f4080e7          	jalr	1012(ra) # 800061e8 <initlock>
  (*f0)->type = FD_PIPE;
    80003dfc:	609c                	ld	a5,0(s1)
    80003dfe:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003e02:	609c                	ld	a5,0(s1)
    80003e04:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003e08:	609c                	ld	a5,0(s1)
    80003e0a:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003e0e:	609c                	ld	a5,0(s1)
    80003e10:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003e14:	000a3783          	ld	a5,0(s4)
    80003e18:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003e1c:	000a3783          	ld	a5,0(s4)
    80003e20:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003e24:	000a3783          	ld	a5,0(s4)
    80003e28:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003e2c:	000a3783          	ld	a5,0(s4)
    80003e30:	0127b823          	sd	s2,16(a5)
  return 0;
    80003e34:	4501                	li	a0,0
    80003e36:	a025                	j	80003e5e <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003e38:	6088                	ld	a0,0(s1)
    80003e3a:	e501                	bnez	a0,80003e42 <pipealloc+0xaa>
    80003e3c:	a039                	j	80003e4a <pipealloc+0xb2>
    80003e3e:	6088                	ld	a0,0(s1)
    80003e40:	c51d                	beqz	a0,80003e6e <pipealloc+0xd6>
    fileclose(*f0);
    80003e42:	00000097          	auipc	ra,0x0
    80003e46:	c26080e7          	jalr	-986(ra) # 80003a68 <fileclose>
  if(*f1)
    80003e4a:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003e4e:	557d                	li	a0,-1
  if(*f1)
    80003e50:	c799                	beqz	a5,80003e5e <pipealloc+0xc6>
    fileclose(*f1);
    80003e52:	853e                	mv	a0,a5
    80003e54:	00000097          	auipc	ra,0x0
    80003e58:	c14080e7          	jalr	-1004(ra) # 80003a68 <fileclose>
  return -1;
    80003e5c:	557d                	li	a0,-1
}
    80003e5e:	70a2                	ld	ra,40(sp)
    80003e60:	7402                	ld	s0,32(sp)
    80003e62:	64e2                	ld	s1,24(sp)
    80003e64:	6942                	ld	s2,16(sp)
    80003e66:	69a2                	ld	s3,8(sp)
    80003e68:	6a02                	ld	s4,0(sp)
    80003e6a:	6145                	addi	sp,sp,48
    80003e6c:	8082                	ret
  return -1;
    80003e6e:	557d                	li	a0,-1
    80003e70:	b7fd                	j	80003e5e <pipealloc+0xc6>

0000000080003e72 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003e72:	1101                	addi	sp,sp,-32
    80003e74:	ec06                	sd	ra,24(sp)
    80003e76:	e822                	sd	s0,16(sp)
    80003e78:	e426                	sd	s1,8(sp)
    80003e7a:	e04a                	sd	s2,0(sp)
    80003e7c:	1000                	addi	s0,sp,32
    80003e7e:	84aa                	mv	s1,a0
    80003e80:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003e82:	00002097          	auipc	ra,0x2
    80003e86:	3f6080e7          	jalr	1014(ra) # 80006278 <acquire>
  if(writable){
    80003e8a:	02090d63          	beqz	s2,80003ec4 <pipeclose+0x52>
    pi->writeopen = 0;
    80003e8e:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003e92:	21848513          	addi	a0,s1,536
    80003e96:	ffffd097          	auipc	ra,0xffffd
    80003e9a:	6d6080e7          	jalr	1750(ra) # 8000156c <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003e9e:	2204b783          	ld	a5,544(s1)
    80003ea2:	eb95                	bnez	a5,80003ed6 <pipeclose+0x64>
    release(&pi->lock);
    80003ea4:	8526                	mv	a0,s1
    80003ea6:	00002097          	auipc	ra,0x2
    80003eaa:	486080e7          	jalr	1158(ra) # 8000632c <release>
    kfree((char*)pi);
    80003eae:	8526                	mv	a0,s1
    80003eb0:	ffffc097          	auipc	ra,0xffffc
    80003eb4:	16c080e7          	jalr	364(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003eb8:	60e2                	ld	ra,24(sp)
    80003eba:	6442                	ld	s0,16(sp)
    80003ebc:	64a2                	ld	s1,8(sp)
    80003ebe:	6902                	ld	s2,0(sp)
    80003ec0:	6105                	addi	sp,sp,32
    80003ec2:	8082                	ret
    pi->readopen = 0;
    80003ec4:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003ec8:	21c48513          	addi	a0,s1,540
    80003ecc:	ffffd097          	auipc	ra,0xffffd
    80003ed0:	6a0080e7          	jalr	1696(ra) # 8000156c <wakeup>
    80003ed4:	b7e9                	j	80003e9e <pipeclose+0x2c>
    release(&pi->lock);
    80003ed6:	8526                	mv	a0,s1
    80003ed8:	00002097          	auipc	ra,0x2
    80003edc:	454080e7          	jalr	1108(ra) # 8000632c <release>
}
    80003ee0:	bfe1                	j	80003eb8 <pipeclose+0x46>

0000000080003ee2 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003ee2:	7159                	addi	sp,sp,-112
    80003ee4:	f486                	sd	ra,104(sp)
    80003ee6:	f0a2                	sd	s0,96(sp)
    80003ee8:	eca6                	sd	s1,88(sp)
    80003eea:	e8ca                	sd	s2,80(sp)
    80003eec:	e4ce                	sd	s3,72(sp)
    80003eee:	e0d2                	sd	s4,64(sp)
    80003ef0:	fc56                	sd	s5,56(sp)
    80003ef2:	f85a                	sd	s6,48(sp)
    80003ef4:	f45e                	sd	s7,40(sp)
    80003ef6:	f062                	sd	s8,32(sp)
    80003ef8:	ec66                	sd	s9,24(sp)
    80003efa:	1880                	addi	s0,sp,112
    80003efc:	84aa                	mv	s1,a0
    80003efe:	8aae                	mv	s5,a1
    80003f00:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003f02:	ffffd097          	auipc	ra,0xffffd
    80003f06:	f56080e7          	jalr	-170(ra) # 80000e58 <myproc>
    80003f0a:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003f0c:	8526                	mv	a0,s1
    80003f0e:	00002097          	auipc	ra,0x2
    80003f12:	36a080e7          	jalr	874(ra) # 80006278 <acquire>
  while(i < n){
    80003f16:	0d405463          	blez	s4,80003fde <pipewrite+0xfc>
    80003f1a:	8ba6                	mv	s7,s1
  int i = 0;
    80003f1c:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f1e:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003f20:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003f24:	21c48c13          	addi	s8,s1,540
    80003f28:	a08d                	j	80003f8a <pipewrite+0xa8>
      release(&pi->lock);
    80003f2a:	8526                	mv	a0,s1
    80003f2c:	00002097          	auipc	ra,0x2
    80003f30:	400080e7          	jalr	1024(ra) # 8000632c <release>
      return -1;
    80003f34:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003f36:	854a                	mv	a0,s2
    80003f38:	70a6                	ld	ra,104(sp)
    80003f3a:	7406                	ld	s0,96(sp)
    80003f3c:	64e6                	ld	s1,88(sp)
    80003f3e:	6946                	ld	s2,80(sp)
    80003f40:	69a6                	ld	s3,72(sp)
    80003f42:	6a06                	ld	s4,64(sp)
    80003f44:	7ae2                	ld	s5,56(sp)
    80003f46:	7b42                	ld	s6,48(sp)
    80003f48:	7ba2                	ld	s7,40(sp)
    80003f4a:	7c02                	ld	s8,32(sp)
    80003f4c:	6ce2                	ld	s9,24(sp)
    80003f4e:	6165                	addi	sp,sp,112
    80003f50:	8082                	ret
      wakeup(&pi->nread);
    80003f52:	8566                	mv	a0,s9
    80003f54:	ffffd097          	auipc	ra,0xffffd
    80003f58:	618080e7          	jalr	1560(ra) # 8000156c <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003f5c:	85de                	mv	a1,s7
    80003f5e:	8562                	mv	a0,s8
    80003f60:	ffffd097          	auipc	ra,0xffffd
    80003f64:	5a8080e7          	jalr	1448(ra) # 80001508 <sleep>
    80003f68:	a839                	j	80003f86 <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003f6a:	21c4a783          	lw	a5,540(s1)
    80003f6e:	0017871b          	addiw	a4,a5,1
    80003f72:	20e4ae23          	sw	a4,540(s1)
    80003f76:	1ff7f793          	andi	a5,a5,511
    80003f7a:	97a6                	add	a5,a5,s1
    80003f7c:	f9f44703          	lbu	a4,-97(s0)
    80003f80:	00e78c23          	sb	a4,24(a5)
      i++;
    80003f84:	2905                	addiw	s2,s2,1
  while(i < n){
    80003f86:	05495063          	bge	s2,s4,80003fc6 <pipewrite+0xe4>
    if(pi->readopen == 0 || killed(pr)){
    80003f8a:	2204a783          	lw	a5,544(s1)
    80003f8e:	dfd1                	beqz	a5,80003f2a <pipewrite+0x48>
    80003f90:	854e                	mv	a0,s3
    80003f92:	ffffe097          	auipc	ra,0xffffe
    80003f96:	81e080e7          	jalr	-2018(ra) # 800017b0 <killed>
    80003f9a:	f941                	bnez	a0,80003f2a <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003f9c:	2184a783          	lw	a5,536(s1)
    80003fa0:	21c4a703          	lw	a4,540(s1)
    80003fa4:	2007879b          	addiw	a5,a5,512
    80003fa8:	faf705e3          	beq	a4,a5,80003f52 <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003fac:	4685                	li	a3,1
    80003fae:	01590633          	add	a2,s2,s5
    80003fb2:	f9f40593          	addi	a1,s0,-97
    80003fb6:	0509b503          	ld	a0,80(s3)
    80003fba:	ffffd097          	auipc	ra,0xffffd
    80003fbe:	be8080e7          	jalr	-1048(ra) # 80000ba2 <copyin>
    80003fc2:	fb6514e3          	bne	a0,s6,80003f6a <pipewrite+0x88>
  wakeup(&pi->nread);
    80003fc6:	21848513          	addi	a0,s1,536
    80003fca:	ffffd097          	auipc	ra,0xffffd
    80003fce:	5a2080e7          	jalr	1442(ra) # 8000156c <wakeup>
  release(&pi->lock);
    80003fd2:	8526                	mv	a0,s1
    80003fd4:	00002097          	auipc	ra,0x2
    80003fd8:	358080e7          	jalr	856(ra) # 8000632c <release>
  return i;
    80003fdc:	bfa9                	j	80003f36 <pipewrite+0x54>
  int i = 0;
    80003fde:	4901                	li	s2,0
    80003fe0:	b7dd                	j	80003fc6 <pipewrite+0xe4>

0000000080003fe2 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003fe2:	715d                	addi	sp,sp,-80
    80003fe4:	e486                	sd	ra,72(sp)
    80003fe6:	e0a2                	sd	s0,64(sp)
    80003fe8:	fc26                	sd	s1,56(sp)
    80003fea:	f84a                	sd	s2,48(sp)
    80003fec:	f44e                	sd	s3,40(sp)
    80003fee:	f052                	sd	s4,32(sp)
    80003ff0:	ec56                	sd	s5,24(sp)
    80003ff2:	e85a                	sd	s6,16(sp)
    80003ff4:	0880                	addi	s0,sp,80
    80003ff6:	84aa                	mv	s1,a0
    80003ff8:	892e                	mv	s2,a1
    80003ffa:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003ffc:	ffffd097          	auipc	ra,0xffffd
    80004000:	e5c080e7          	jalr	-420(ra) # 80000e58 <myproc>
    80004004:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004006:	8b26                	mv	s6,s1
    80004008:	8526                	mv	a0,s1
    8000400a:	00002097          	auipc	ra,0x2
    8000400e:	26e080e7          	jalr	622(ra) # 80006278 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004012:	2184a703          	lw	a4,536(s1)
    80004016:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000401a:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000401e:	02f71763          	bne	a4,a5,8000404c <piperead+0x6a>
    80004022:	2244a783          	lw	a5,548(s1)
    80004026:	c39d                	beqz	a5,8000404c <piperead+0x6a>
    if(killed(pr)){
    80004028:	8552                	mv	a0,s4
    8000402a:	ffffd097          	auipc	ra,0xffffd
    8000402e:	786080e7          	jalr	1926(ra) # 800017b0 <killed>
    80004032:	e941                	bnez	a0,800040c2 <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004034:	85da                	mv	a1,s6
    80004036:	854e                	mv	a0,s3
    80004038:	ffffd097          	auipc	ra,0xffffd
    8000403c:	4d0080e7          	jalr	1232(ra) # 80001508 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004040:	2184a703          	lw	a4,536(s1)
    80004044:	21c4a783          	lw	a5,540(s1)
    80004048:	fcf70de3          	beq	a4,a5,80004022 <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000404c:	09505263          	blez	s5,800040d0 <piperead+0xee>
    80004050:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004052:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    80004054:	2184a783          	lw	a5,536(s1)
    80004058:	21c4a703          	lw	a4,540(s1)
    8000405c:	02f70d63          	beq	a4,a5,80004096 <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004060:	0017871b          	addiw	a4,a5,1
    80004064:	20e4ac23          	sw	a4,536(s1)
    80004068:	1ff7f793          	andi	a5,a5,511
    8000406c:	97a6                	add	a5,a5,s1
    8000406e:	0187c783          	lbu	a5,24(a5)
    80004072:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004076:	4685                	li	a3,1
    80004078:	fbf40613          	addi	a2,s0,-65
    8000407c:	85ca                	mv	a1,s2
    8000407e:	050a3503          	ld	a0,80(s4)
    80004082:	ffffd097          	auipc	ra,0xffffd
    80004086:	a94080e7          	jalr	-1388(ra) # 80000b16 <copyout>
    8000408a:	01650663          	beq	a0,s6,80004096 <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000408e:	2985                	addiw	s3,s3,1
    80004090:	0905                	addi	s2,s2,1
    80004092:	fd3a91e3          	bne	s5,s3,80004054 <piperead+0x72>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004096:	21c48513          	addi	a0,s1,540
    8000409a:	ffffd097          	auipc	ra,0xffffd
    8000409e:	4d2080e7          	jalr	1234(ra) # 8000156c <wakeup>
  release(&pi->lock);
    800040a2:	8526                	mv	a0,s1
    800040a4:	00002097          	auipc	ra,0x2
    800040a8:	288080e7          	jalr	648(ra) # 8000632c <release>
  return i;
}
    800040ac:	854e                	mv	a0,s3
    800040ae:	60a6                	ld	ra,72(sp)
    800040b0:	6406                	ld	s0,64(sp)
    800040b2:	74e2                	ld	s1,56(sp)
    800040b4:	7942                	ld	s2,48(sp)
    800040b6:	79a2                	ld	s3,40(sp)
    800040b8:	7a02                	ld	s4,32(sp)
    800040ba:	6ae2                	ld	s5,24(sp)
    800040bc:	6b42                	ld	s6,16(sp)
    800040be:	6161                	addi	sp,sp,80
    800040c0:	8082                	ret
      release(&pi->lock);
    800040c2:	8526                	mv	a0,s1
    800040c4:	00002097          	auipc	ra,0x2
    800040c8:	268080e7          	jalr	616(ra) # 8000632c <release>
      return -1;
    800040cc:	59fd                	li	s3,-1
    800040ce:	bff9                	j	800040ac <piperead+0xca>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040d0:	4981                	li	s3,0
    800040d2:	b7d1                	j	80004096 <piperead+0xb4>

00000000800040d4 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    800040d4:	1141                	addi	sp,sp,-16
    800040d6:	e422                	sd	s0,8(sp)
    800040d8:	0800                	addi	s0,sp,16
    800040da:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    800040dc:	8905                	andi	a0,a0,1
    800040de:	c111                	beqz	a0,800040e2 <flags2perm+0xe>
      perm = PTE_X;
    800040e0:	4521                	li	a0,8
    if(flags & 0x2)
    800040e2:	8b89                	andi	a5,a5,2
    800040e4:	c399                	beqz	a5,800040ea <flags2perm+0x16>
      perm |= PTE_W;
    800040e6:	00456513          	ori	a0,a0,4
    return perm;
}
    800040ea:	6422                	ld	s0,8(sp)
    800040ec:	0141                	addi	sp,sp,16
    800040ee:	8082                	ret

00000000800040f0 <exec>:

int
exec(char *path, char **argv)
{
    800040f0:	df010113          	addi	sp,sp,-528
    800040f4:	20113423          	sd	ra,520(sp)
    800040f8:	20813023          	sd	s0,512(sp)
    800040fc:	ffa6                	sd	s1,504(sp)
    800040fe:	fbca                	sd	s2,496(sp)
    80004100:	f7ce                	sd	s3,488(sp)
    80004102:	f3d2                	sd	s4,480(sp)
    80004104:	efd6                	sd	s5,472(sp)
    80004106:	ebda                	sd	s6,464(sp)
    80004108:	e7de                	sd	s7,456(sp)
    8000410a:	e3e2                	sd	s8,448(sp)
    8000410c:	ff66                	sd	s9,440(sp)
    8000410e:	fb6a                	sd	s10,432(sp)
    80004110:	f76e                	sd	s11,424(sp)
    80004112:	0c00                	addi	s0,sp,528
    80004114:	84aa                	mv	s1,a0
    80004116:	dea43c23          	sd	a0,-520(s0)
    8000411a:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000411e:	ffffd097          	auipc	ra,0xffffd
    80004122:	d3a080e7          	jalr	-710(ra) # 80000e58 <myproc>
    80004126:	892a                	mv	s2,a0

  begin_op();
    80004128:	fffff097          	auipc	ra,0xfffff
    8000412c:	474080e7          	jalr	1140(ra) # 8000359c <begin_op>

  if((ip = namei(path)) == 0){
    80004130:	8526                	mv	a0,s1
    80004132:	fffff097          	auipc	ra,0xfffff
    80004136:	24e080e7          	jalr	590(ra) # 80003380 <namei>
    8000413a:	c92d                	beqz	a0,800041ac <exec+0xbc>
    8000413c:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000413e:	fffff097          	auipc	ra,0xfffff
    80004142:	a9c080e7          	jalr	-1380(ra) # 80002bda <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004146:	04000713          	li	a4,64
    8000414a:	4681                	li	a3,0
    8000414c:	e5040613          	addi	a2,s0,-432
    80004150:	4581                	li	a1,0
    80004152:	8526                	mv	a0,s1
    80004154:	fffff097          	auipc	ra,0xfffff
    80004158:	d3a080e7          	jalr	-710(ra) # 80002e8e <readi>
    8000415c:	04000793          	li	a5,64
    80004160:	00f51a63          	bne	a0,a5,80004174 <exec+0x84>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80004164:	e5042703          	lw	a4,-432(s0)
    80004168:	464c47b7          	lui	a5,0x464c4
    8000416c:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004170:	04f70463          	beq	a4,a5,800041b8 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004174:	8526                	mv	a0,s1
    80004176:	fffff097          	auipc	ra,0xfffff
    8000417a:	cc6080e7          	jalr	-826(ra) # 80002e3c <iunlockput>
    end_op();
    8000417e:	fffff097          	auipc	ra,0xfffff
    80004182:	49e080e7          	jalr	1182(ra) # 8000361c <end_op>
  }
  return -1;
    80004186:	557d                	li	a0,-1
}
    80004188:	20813083          	ld	ra,520(sp)
    8000418c:	20013403          	ld	s0,512(sp)
    80004190:	74fe                	ld	s1,504(sp)
    80004192:	795e                	ld	s2,496(sp)
    80004194:	79be                	ld	s3,488(sp)
    80004196:	7a1e                	ld	s4,480(sp)
    80004198:	6afe                	ld	s5,472(sp)
    8000419a:	6b5e                	ld	s6,464(sp)
    8000419c:	6bbe                	ld	s7,456(sp)
    8000419e:	6c1e                	ld	s8,448(sp)
    800041a0:	7cfa                	ld	s9,440(sp)
    800041a2:	7d5a                	ld	s10,432(sp)
    800041a4:	7dba                	ld	s11,424(sp)
    800041a6:	21010113          	addi	sp,sp,528
    800041aa:	8082                	ret
    end_op();
    800041ac:	fffff097          	auipc	ra,0xfffff
    800041b0:	470080e7          	jalr	1136(ra) # 8000361c <end_op>
    return -1;
    800041b4:	557d                	li	a0,-1
    800041b6:	bfc9                	j	80004188 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    800041b8:	854a                	mv	a0,s2
    800041ba:	ffffd097          	auipc	ra,0xffffd
    800041be:	d62080e7          	jalr	-670(ra) # 80000f1c <proc_pagetable>
    800041c2:	8baa                	mv	s7,a0
    800041c4:	d945                	beqz	a0,80004174 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800041c6:	e7042983          	lw	s3,-400(s0)
    800041ca:	e8845783          	lhu	a5,-376(s0)
    800041ce:	c7ad                	beqz	a5,80004238 <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800041d0:	4a01                	li	s4,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800041d2:	4b01                	li	s6,0
    if(ph.vaddr % PGSIZE != 0)
    800041d4:	6c85                	lui	s9,0x1
    800041d6:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800041da:	def43823          	sd	a5,-528(s0)
    800041de:	ac0d                	j	80004410 <exec+0x320>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    800041e0:	00004517          	auipc	a0,0x4
    800041e4:	48050513          	addi	a0,a0,1152 # 80008660 <syscalls+0x290>
    800041e8:	00002097          	auipc	ra,0x2
    800041ec:	aea080e7          	jalr	-1302(ra) # 80005cd2 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800041f0:	8756                	mv	a4,s5
    800041f2:	012d86bb          	addw	a3,s11,s2
    800041f6:	4581                	li	a1,0
    800041f8:	8526                	mv	a0,s1
    800041fa:	fffff097          	auipc	ra,0xfffff
    800041fe:	c94080e7          	jalr	-876(ra) # 80002e8e <readi>
    80004202:	2501                	sext.w	a0,a0
    80004204:	1aaa9a63          	bne	s5,a0,800043b8 <exec+0x2c8>
  for(i = 0; i < sz; i += PGSIZE){
    80004208:	6785                	lui	a5,0x1
    8000420a:	0127893b          	addw	s2,a5,s2
    8000420e:	77fd                	lui	a5,0xfffff
    80004210:	01478a3b          	addw	s4,a5,s4
    80004214:	1f897563          	bgeu	s2,s8,800043fe <exec+0x30e>
    pa = walkaddr(pagetable, va + i);
    80004218:	02091593          	slli	a1,s2,0x20
    8000421c:	9181                	srli	a1,a1,0x20
    8000421e:	95ea                	add	a1,a1,s10
    80004220:	855e                	mv	a0,s7
    80004222:	ffffc097          	auipc	ra,0xffffc
    80004226:	2e8080e7          	jalr	744(ra) # 8000050a <walkaddr>
    8000422a:	862a                	mv	a2,a0
    if(pa == 0)
    8000422c:	d955                	beqz	a0,800041e0 <exec+0xf0>
      n = PGSIZE;
    8000422e:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    80004230:	fd9a70e3          	bgeu	s4,s9,800041f0 <exec+0x100>
      n = sz - i;
    80004234:	8ad2                	mv	s5,s4
    80004236:	bf6d                	j	800041f0 <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004238:	4a01                	li	s4,0
  iunlockput(ip);
    8000423a:	8526                	mv	a0,s1
    8000423c:	fffff097          	auipc	ra,0xfffff
    80004240:	c00080e7          	jalr	-1024(ra) # 80002e3c <iunlockput>
  end_op();
    80004244:	fffff097          	auipc	ra,0xfffff
    80004248:	3d8080e7          	jalr	984(ra) # 8000361c <end_op>
  p = myproc();
    8000424c:	ffffd097          	auipc	ra,0xffffd
    80004250:	c0c080e7          	jalr	-1012(ra) # 80000e58 <myproc>
    80004254:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004256:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    8000425a:	6785                	lui	a5,0x1
    8000425c:	17fd                	addi	a5,a5,-1
    8000425e:	9a3e                	add	s4,s4,a5
    80004260:	757d                	lui	a0,0xfffff
    80004262:	00aa77b3          	and	a5,s4,a0
    80004266:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    8000426a:	4691                	li	a3,4
    8000426c:	6609                	lui	a2,0x2
    8000426e:	963e                	add	a2,a2,a5
    80004270:	85be                	mv	a1,a5
    80004272:	855e                	mv	a0,s7
    80004274:	ffffc097          	auipc	ra,0xffffc
    80004278:	64a080e7          	jalr	1610(ra) # 800008be <uvmalloc>
    8000427c:	8b2a                	mv	s6,a0
  ip = 0;
    8000427e:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004280:	12050c63          	beqz	a0,800043b8 <exec+0x2c8>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004284:	75f9                	lui	a1,0xffffe
    80004286:	95aa                	add	a1,a1,a0
    80004288:	855e                	mv	a0,s7
    8000428a:	ffffd097          	auipc	ra,0xffffd
    8000428e:	85a080e7          	jalr	-1958(ra) # 80000ae4 <uvmclear>
  stackbase = sp - PGSIZE;
    80004292:	7c7d                	lui	s8,0xfffff
    80004294:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    80004296:	e0043783          	ld	a5,-512(s0)
    8000429a:	6388                	ld	a0,0(a5)
    8000429c:	c535                	beqz	a0,80004308 <exec+0x218>
    8000429e:	e9040993          	addi	s3,s0,-368
    800042a2:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    800042a6:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    800042a8:	ffffc097          	auipc	ra,0xffffc
    800042ac:	054080e7          	jalr	84(ra) # 800002fc <strlen>
    800042b0:	2505                	addiw	a0,a0,1
    800042b2:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800042b6:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    800042ba:	13896663          	bltu	s2,s8,800043e6 <exec+0x2f6>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800042be:	e0043d83          	ld	s11,-512(s0)
    800042c2:	000dba03          	ld	s4,0(s11)
    800042c6:	8552                	mv	a0,s4
    800042c8:	ffffc097          	auipc	ra,0xffffc
    800042cc:	034080e7          	jalr	52(ra) # 800002fc <strlen>
    800042d0:	0015069b          	addiw	a3,a0,1
    800042d4:	8652                	mv	a2,s4
    800042d6:	85ca                	mv	a1,s2
    800042d8:	855e                	mv	a0,s7
    800042da:	ffffd097          	auipc	ra,0xffffd
    800042de:	83c080e7          	jalr	-1988(ra) # 80000b16 <copyout>
    800042e2:	10054663          	bltz	a0,800043ee <exec+0x2fe>
    ustack[argc] = sp;
    800042e6:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800042ea:	0485                	addi	s1,s1,1
    800042ec:	008d8793          	addi	a5,s11,8
    800042f0:	e0f43023          	sd	a5,-512(s0)
    800042f4:	008db503          	ld	a0,8(s11)
    800042f8:	c911                	beqz	a0,8000430c <exec+0x21c>
    if(argc >= MAXARG)
    800042fa:	09a1                	addi	s3,s3,8
    800042fc:	fb3c96e3          	bne	s9,s3,800042a8 <exec+0x1b8>
  sz = sz1;
    80004300:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004304:	4481                	li	s1,0
    80004306:	a84d                	j	800043b8 <exec+0x2c8>
  sp = sz;
    80004308:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    8000430a:	4481                	li	s1,0
  ustack[argc] = 0;
    8000430c:	00349793          	slli	a5,s1,0x3
    80004310:	f9040713          	addi	a4,s0,-112
    80004314:	97ba                	add	a5,a5,a4
    80004316:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    8000431a:	00148693          	addi	a3,s1,1
    8000431e:	068e                	slli	a3,a3,0x3
    80004320:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004324:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004328:	01897663          	bgeu	s2,s8,80004334 <exec+0x244>
  sz = sz1;
    8000432c:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004330:	4481                	li	s1,0
    80004332:	a059                	j	800043b8 <exec+0x2c8>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004334:	e9040613          	addi	a2,s0,-368
    80004338:	85ca                	mv	a1,s2
    8000433a:	855e                	mv	a0,s7
    8000433c:	ffffc097          	auipc	ra,0xffffc
    80004340:	7da080e7          	jalr	2010(ra) # 80000b16 <copyout>
    80004344:	0a054963          	bltz	a0,800043f6 <exec+0x306>
  p->trapframe->a1 = sp;
    80004348:	058ab783          	ld	a5,88(s5)
    8000434c:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004350:	df843783          	ld	a5,-520(s0)
    80004354:	0007c703          	lbu	a4,0(a5)
    80004358:	cf11                	beqz	a4,80004374 <exec+0x284>
    8000435a:	0785                	addi	a5,a5,1
    if(*s == '/')
    8000435c:	02f00693          	li	a3,47
    80004360:	a039                	j	8000436e <exec+0x27e>
      last = s+1;
    80004362:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004366:	0785                	addi	a5,a5,1
    80004368:	fff7c703          	lbu	a4,-1(a5)
    8000436c:	c701                	beqz	a4,80004374 <exec+0x284>
    if(*s == '/')
    8000436e:	fed71ce3          	bne	a4,a3,80004366 <exec+0x276>
    80004372:	bfc5                	j	80004362 <exec+0x272>
  safestrcpy(p->name, last, sizeof(p->name));
    80004374:	4641                	li	a2,16
    80004376:	df843583          	ld	a1,-520(s0)
    8000437a:	158a8513          	addi	a0,s5,344
    8000437e:	ffffc097          	auipc	ra,0xffffc
    80004382:	f4c080e7          	jalr	-180(ra) # 800002ca <safestrcpy>
  oldpagetable = p->pagetable;
    80004386:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    8000438a:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    8000438e:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004392:	058ab783          	ld	a5,88(s5)
    80004396:	e6843703          	ld	a4,-408(s0)
    8000439a:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000439c:	058ab783          	ld	a5,88(s5)
    800043a0:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800043a4:	85ea                	mv	a1,s10
    800043a6:	ffffd097          	auipc	ra,0xffffd
    800043aa:	c12080e7          	jalr	-1006(ra) # 80000fb8 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800043ae:	0004851b          	sext.w	a0,s1
    800043b2:	bbd9                	j	80004188 <exec+0x98>
    800043b4:	e1443423          	sd	s4,-504(s0)
    proc_freepagetable(pagetable, sz);
    800043b8:	e0843583          	ld	a1,-504(s0)
    800043bc:	855e                	mv	a0,s7
    800043be:	ffffd097          	auipc	ra,0xffffd
    800043c2:	bfa080e7          	jalr	-1030(ra) # 80000fb8 <proc_freepagetable>
  if(ip){
    800043c6:	da0497e3          	bnez	s1,80004174 <exec+0x84>
  return -1;
    800043ca:	557d                	li	a0,-1
    800043cc:	bb75                	j	80004188 <exec+0x98>
    800043ce:	e1443423          	sd	s4,-504(s0)
    800043d2:	b7dd                	j	800043b8 <exec+0x2c8>
    800043d4:	e1443423          	sd	s4,-504(s0)
    800043d8:	b7c5                	j	800043b8 <exec+0x2c8>
    800043da:	e1443423          	sd	s4,-504(s0)
    800043de:	bfe9                	j	800043b8 <exec+0x2c8>
    800043e0:	e1443423          	sd	s4,-504(s0)
    800043e4:	bfd1                	j	800043b8 <exec+0x2c8>
  sz = sz1;
    800043e6:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800043ea:	4481                	li	s1,0
    800043ec:	b7f1                	j	800043b8 <exec+0x2c8>
  sz = sz1;
    800043ee:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800043f2:	4481                	li	s1,0
    800043f4:	b7d1                	j	800043b8 <exec+0x2c8>
  sz = sz1;
    800043f6:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800043fa:	4481                	li	s1,0
    800043fc:	bf75                	j	800043b8 <exec+0x2c8>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800043fe:	e0843a03          	ld	s4,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004402:	2b05                	addiw	s6,s6,1
    80004404:	0389899b          	addiw	s3,s3,56
    80004408:	e8845783          	lhu	a5,-376(s0)
    8000440c:	e2fb57e3          	bge	s6,a5,8000423a <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004410:	2981                	sext.w	s3,s3
    80004412:	03800713          	li	a4,56
    80004416:	86ce                	mv	a3,s3
    80004418:	e1840613          	addi	a2,s0,-488
    8000441c:	4581                	li	a1,0
    8000441e:	8526                	mv	a0,s1
    80004420:	fffff097          	auipc	ra,0xfffff
    80004424:	a6e080e7          	jalr	-1426(ra) # 80002e8e <readi>
    80004428:	03800793          	li	a5,56
    8000442c:	f8f514e3          	bne	a0,a5,800043b4 <exec+0x2c4>
    if(ph.type != ELF_PROG_LOAD)
    80004430:	e1842783          	lw	a5,-488(s0)
    80004434:	4705                	li	a4,1
    80004436:	fce796e3          	bne	a5,a4,80004402 <exec+0x312>
    if(ph.memsz < ph.filesz)
    8000443a:	e4043903          	ld	s2,-448(s0)
    8000443e:	e3843783          	ld	a5,-456(s0)
    80004442:	f8f966e3          	bltu	s2,a5,800043ce <exec+0x2de>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004446:	e2843783          	ld	a5,-472(s0)
    8000444a:	993e                	add	s2,s2,a5
    8000444c:	f8f964e3          	bltu	s2,a5,800043d4 <exec+0x2e4>
    if(ph.vaddr % PGSIZE != 0)
    80004450:	df043703          	ld	a4,-528(s0)
    80004454:	8ff9                	and	a5,a5,a4
    80004456:	f3d1                	bnez	a5,800043da <exec+0x2ea>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004458:	e1c42503          	lw	a0,-484(s0)
    8000445c:	00000097          	auipc	ra,0x0
    80004460:	c78080e7          	jalr	-904(ra) # 800040d4 <flags2perm>
    80004464:	86aa                	mv	a3,a0
    80004466:	864a                	mv	a2,s2
    80004468:	85d2                	mv	a1,s4
    8000446a:	855e                	mv	a0,s7
    8000446c:	ffffc097          	auipc	ra,0xffffc
    80004470:	452080e7          	jalr	1106(ra) # 800008be <uvmalloc>
    80004474:	e0a43423          	sd	a0,-504(s0)
    80004478:	d525                	beqz	a0,800043e0 <exec+0x2f0>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000447a:	e2843d03          	ld	s10,-472(s0)
    8000447e:	e2042d83          	lw	s11,-480(s0)
    80004482:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004486:	f60c0ce3          	beqz	s8,800043fe <exec+0x30e>
    8000448a:	8a62                	mv	s4,s8
    8000448c:	4901                	li	s2,0
    8000448e:	b369                	j	80004218 <exec+0x128>

0000000080004490 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004490:	7179                	addi	sp,sp,-48
    80004492:	f406                	sd	ra,40(sp)
    80004494:	f022                	sd	s0,32(sp)
    80004496:	ec26                	sd	s1,24(sp)
    80004498:	e84a                	sd	s2,16(sp)
    8000449a:	1800                	addi	s0,sp,48
    8000449c:	892e                	mv	s2,a1
    8000449e:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    800044a0:	fdc40593          	addi	a1,s0,-36
    800044a4:	ffffe097          	auipc	ra,0xffffe
    800044a8:	b1e080e7          	jalr	-1250(ra) # 80001fc2 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800044ac:	fdc42703          	lw	a4,-36(s0)
    800044b0:	47bd                	li	a5,15
    800044b2:	02e7eb63          	bltu	a5,a4,800044e8 <argfd+0x58>
    800044b6:	ffffd097          	auipc	ra,0xffffd
    800044ba:	9a2080e7          	jalr	-1630(ra) # 80000e58 <myproc>
    800044be:	fdc42703          	lw	a4,-36(s0)
    800044c2:	01a70793          	addi	a5,a4,26
    800044c6:	078e                	slli	a5,a5,0x3
    800044c8:	953e                	add	a0,a0,a5
    800044ca:	611c                	ld	a5,0(a0)
    800044cc:	c385                	beqz	a5,800044ec <argfd+0x5c>
    return -1;
  if(pfd)
    800044ce:	00090463          	beqz	s2,800044d6 <argfd+0x46>
    *pfd = fd;
    800044d2:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800044d6:	4501                	li	a0,0
  if(pf)
    800044d8:	c091                	beqz	s1,800044dc <argfd+0x4c>
    *pf = f;
    800044da:	e09c                	sd	a5,0(s1)
}
    800044dc:	70a2                	ld	ra,40(sp)
    800044de:	7402                	ld	s0,32(sp)
    800044e0:	64e2                	ld	s1,24(sp)
    800044e2:	6942                	ld	s2,16(sp)
    800044e4:	6145                	addi	sp,sp,48
    800044e6:	8082                	ret
    return -1;
    800044e8:	557d                	li	a0,-1
    800044ea:	bfcd                	j	800044dc <argfd+0x4c>
    800044ec:	557d                	li	a0,-1
    800044ee:	b7fd                	j	800044dc <argfd+0x4c>

00000000800044f0 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800044f0:	1101                	addi	sp,sp,-32
    800044f2:	ec06                	sd	ra,24(sp)
    800044f4:	e822                	sd	s0,16(sp)
    800044f6:	e426                	sd	s1,8(sp)
    800044f8:	1000                	addi	s0,sp,32
    800044fa:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800044fc:	ffffd097          	auipc	ra,0xffffd
    80004500:	95c080e7          	jalr	-1700(ra) # 80000e58 <myproc>
    80004504:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004506:	0d050793          	addi	a5,a0,208 # fffffffffffff0d0 <end+0xffffffff7ffdcd50>
    8000450a:	4501                	li	a0,0
    8000450c:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    8000450e:	6398                	ld	a4,0(a5)
    80004510:	cb19                	beqz	a4,80004526 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004512:	2505                	addiw	a0,a0,1
    80004514:	07a1                	addi	a5,a5,8
    80004516:	fed51ce3          	bne	a0,a3,8000450e <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000451a:	557d                	li	a0,-1
}
    8000451c:	60e2                	ld	ra,24(sp)
    8000451e:	6442                	ld	s0,16(sp)
    80004520:	64a2                	ld	s1,8(sp)
    80004522:	6105                	addi	sp,sp,32
    80004524:	8082                	ret
      p->ofile[fd] = f;
    80004526:	01a50793          	addi	a5,a0,26
    8000452a:	078e                	slli	a5,a5,0x3
    8000452c:	963e                	add	a2,a2,a5
    8000452e:	e204                	sd	s1,0(a2)
      return fd;
    80004530:	b7f5                	j	8000451c <fdalloc+0x2c>

0000000080004532 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004532:	715d                	addi	sp,sp,-80
    80004534:	e486                	sd	ra,72(sp)
    80004536:	e0a2                	sd	s0,64(sp)
    80004538:	fc26                	sd	s1,56(sp)
    8000453a:	f84a                	sd	s2,48(sp)
    8000453c:	f44e                	sd	s3,40(sp)
    8000453e:	f052                	sd	s4,32(sp)
    80004540:	ec56                	sd	s5,24(sp)
    80004542:	e85a                	sd	s6,16(sp)
    80004544:	0880                	addi	s0,sp,80
    80004546:	8b2e                	mv	s6,a1
    80004548:	89b2                	mv	s3,a2
    8000454a:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000454c:	fb040593          	addi	a1,s0,-80
    80004550:	fffff097          	auipc	ra,0xfffff
    80004554:	e4e080e7          	jalr	-434(ra) # 8000339e <nameiparent>
    80004558:	84aa                	mv	s1,a0
    8000455a:	16050063          	beqz	a0,800046ba <create+0x188>
    return 0;

  ilock(dp);
    8000455e:	ffffe097          	auipc	ra,0xffffe
    80004562:	67c080e7          	jalr	1660(ra) # 80002bda <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004566:	4601                	li	a2,0
    80004568:	fb040593          	addi	a1,s0,-80
    8000456c:	8526                	mv	a0,s1
    8000456e:	fffff097          	auipc	ra,0xfffff
    80004572:	b50080e7          	jalr	-1200(ra) # 800030be <dirlookup>
    80004576:	8aaa                	mv	s5,a0
    80004578:	c931                	beqz	a0,800045cc <create+0x9a>
    iunlockput(dp);
    8000457a:	8526                	mv	a0,s1
    8000457c:	fffff097          	auipc	ra,0xfffff
    80004580:	8c0080e7          	jalr	-1856(ra) # 80002e3c <iunlockput>
    ilock(ip);
    80004584:	8556                	mv	a0,s5
    80004586:	ffffe097          	auipc	ra,0xffffe
    8000458a:	654080e7          	jalr	1620(ra) # 80002bda <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000458e:	000b059b          	sext.w	a1,s6
    80004592:	4789                	li	a5,2
    80004594:	02f59563          	bne	a1,a5,800045be <create+0x8c>
    80004598:	044ad783          	lhu	a5,68(s5)
    8000459c:	37f9                	addiw	a5,a5,-2
    8000459e:	17c2                	slli	a5,a5,0x30
    800045a0:	93c1                	srli	a5,a5,0x30
    800045a2:	4705                	li	a4,1
    800045a4:	00f76d63          	bltu	a4,a5,800045be <create+0x8c>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    800045a8:	8556                	mv	a0,s5
    800045aa:	60a6                	ld	ra,72(sp)
    800045ac:	6406                	ld	s0,64(sp)
    800045ae:	74e2                	ld	s1,56(sp)
    800045b0:	7942                	ld	s2,48(sp)
    800045b2:	79a2                	ld	s3,40(sp)
    800045b4:	7a02                	ld	s4,32(sp)
    800045b6:	6ae2                	ld	s5,24(sp)
    800045b8:	6b42                	ld	s6,16(sp)
    800045ba:	6161                	addi	sp,sp,80
    800045bc:	8082                	ret
    iunlockput(ip);
    800045be:	8556                	mv	a0,s5
    800045c0:	fffff097          	auipc	ra,0xfffff
    800045c4:	87c080e7          	jalr	-1924(ra) # 80002e3c <iunlockput>
    return 0;
    800045c8:	4a81                	li	s5,0
    800045ca:	bff9                	j	800045a8 <create+0x76>
  if((ip = ialloc(dp->dev, type)) == 0){
    800045cc:	85da                	mv	a1,s6
    800045ce:	4088                	lw	a0,0(s1)
    800045d0:	ffffe097          	auipc	ra,0xffffe
    800045d4:	46e080e7          	jalr	1134(ra) # 80002a3e <ialloc>
    800045d8:	8a2a                	mv	s4,a0
    800045da:	c921                	beqz	a0,8000462a <create+0xf8>
  ilock(ip);
    800045dc:	ffffe097          	auipc	ra,0xffffe
    800045e0:	5fe080e7          	jalr	1534(ra) # 80002bda <ilock>
  ip->major = major;
    800045e4:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    800045e8:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    800045ec:	4785                	li	a5,1
    800045ee:	04fa1523          	sh	a5,74(s4)
  iupdate(ip);
    800045f2:	8552                	mv	a0,s4
    800045f4:	ffffe097          	auipc	ra,0xffffe
    800045f8:	51c080e7          	jalr	1308(ra) # 80002b10 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800045fc:	000b059b          	sext.w	a1,s6
    80004600:	4785                	li	a5,1
    80004602:	02f58b63          	beq	a1,a5,80004638 <create+0x106>
  if(dirlink(dp, name, ip->inum) < 0)
    80004606:	004a2603          	lw	a2,4(s4)
    8000460a:	fb040593          	addi	a1,s0,-80
    8000460e:	8526                	mv	a0,s1
    80004610:	fffff097          	auipc	ra,0xfffff
    80004614:	cbe080e7          	jalr	-834(ra) # 800032ce <dirlink>
    80004618:	06054f63          	bltz	a0,80004696 <create+0x164>
  iunlockput(dp);
    8000461c:	8526                	mv	a0,s1
    8000461e:	fffff097          	auipc	ra,0xfffff
    80004622:	81e080e7          	jalr	-2018(ra) # 80002e3c <iunlockput>
  return ip;
    80004626:	8ad2                	mv	s5,s4
    80004628:	b741                	j	800045a8 <create+0x76>
    iunlockput(dp);
    8000462a:	8526                	mv	a0,s1
    8000462c:	fffff097          	auipc	ra,0xfffff
    80004630:	810080e7          	jalr	-2032(ra) # 80002e3c <iunlockput>
    return 0;
    80004634:	8ad2                	mv	s5,s4
    80004636:	bf8d                	j	800045a8 <create+0x76>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004638:	004a2603          	lw	a2,4(s4)
    8000463c:	00004597          	auipc	a1,0x4
    80004640:	04458593          	addi	a1,a1,68 # 80008680 <syscalls+0x2b0>
    80004644:	8552                	mv	a0,s4
    80004646:	fffff097          	auipc	ra,0xfffff
    8000464a:	c88080e7          	jalr	-888(ra) # 800032ce <dirlink>
    8000464e:	04054463          	bltz	a0,80004696 <create+0x164>
    80004652:	40d0                	lw	a2,4(s1)
    80004654:	00004597          	auipc	a1,0x4
    80004658:	03458593          	addi	a1,a1,52 # 80008688 <syscalls+0x2b8>
    8000465c:	8552                	mv	a0,s4
    8000465e:	fffff097          	auipc	ra,0xfffff
    80004662:	c70080e7          	jalr	-912(ra) # 800032ce <dirlink>
    80004666:	02054863          	bltz	a0,80004696 <create+0x164>
  if(dirlink(dp, name, ip->inum) < 0)
    8000466a:	004a2603          	lw	a2,4(s4)
    8000466e:	fb040593          	addi	a1,s0,-80
    80004672:	8526                	mv	a0,s1
    80004674:	fffff097          	auipc	ra,0xfffff
    80004678:	c5a080e7          	jalr	-934(ra) # 800032ce <dirlink>
    8000467c:	00054d63          	bltz	a0,80004696 <create+0x164>
    dp->nlink++;  // for ".."
    80004680:	04a4d783          	lhu	a5,74(s1)
    80004684:	2785                	addiw	a5,a5,1
    80004686:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000468a:	8526                	mv	a0,s1
    8000468c:	ffffe097          	auipc	ra,0xffffe
    80004690:	484080e7          	jalr	1156(ra) # 80002b10 <iupdate>
    80004694:	b761                	j	8000461c <create+0xea>
  ip->nlink = 0;
    80004696:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    8000469a:	8552                	mv	a0,s4
    8000469c:	ffffe097          	auipc	ra,0xffffe
    800046a0:	474080e7          	jalr	1140(ra) # 80002b10 <iupdate>
  iunlockput(ip);
    800046a4:	8552                	mv	a0,s4
    800046a6:	ffffe097          	auipc	ra,0xffffe
    800046aa:	796080e7          	jalr	1942(ra) # 80002e3c <iunlockput>
  iunlockput(dp);
    800046ae:	8526                	mv	a0,s1
    800046b0:	ffffe097          	auipc	ra,0xffffe
    800046b4:	78c080e7          	jalr	1932(ra) # 80002e3c <iunlockput>
  return 0;
    800046b8:	bdc5                	j	800045a8 <create+0x76>
    return 0;
    800046ba:	8aaa                	mv	s5,a0
    800046bc:	b5f5                	j	800045a8 <create+0x76>

00000000800046be <sys_dup>:
{
    800046be:	7179                	addi	sp,sp,-48
    800046c0:	f406                	sd	ra,40(sp)
    800046c2:	f022                	sd	s0,32(sp)
    800046c4:	ec26                	sd	s1,24(sp)
    800046c6:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800046c8:	fd840613          	addi	a2,s0,-40
    800046cc:	4581                	li	a1,0
    800046ce:	4501                	li	a0,0
    800046d0:	00000097          	auipc	ra,0x0
    800046d4:	dc0080e7          	jalr	-576(ra) # 80004490 <argfd>
    return -1;
    800046d8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800046da:	02054363          	bltz	a0,80004700 <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    800046de:	fd843503          	ld	a0,-40(s0)
    800046e2:	00000097          	auipc	ra,0x0
    800046e6:	e0e080e7          	jalr	-498(ra) # 800044f0 <fdalloc>
    800046ea:	84aa                	mv	s1,a0
    return -1;
    800046ec:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800046ee:	00054963          	bltz	a0,80004700 <sys_dup+0x42>
  filedup(f);
    800046f2:	fd843503          	ld	a0,-40(s0)
    800046f6:	fffff097          	auipc	ra,0xfffff
    800046fa:	320080e7          	jalr	800(ra) # 80003a16 <filedup>
  return fd;
    800046fe:	87a6                	mv	a5,s1
}
    80004700:	853e                	mv	a0,a5
    80004702:	70a2                	ld	ra,40(sp)
    80004704:	7402                	ld	s0,32(sp)
    80004706:	64e2                	ld	s1,24(sp)
    80004708:	6145                	addi	sp,sp,48
    8000470a:	8082                	ret

000000008000470c <sys_read>:
{
    8000470c:	7179                	addi	sp,sp,-48
    8000470e:	f406                	sd	ra,40(sp)
    80004710:	f022                	sd	s0,32(sp)
    80004712:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004714:	fd840593          	addi	a1,s0,-40
    80004718:	4505                	li	a0,1
    8000471a:	ffffe097          	auipc	ra,0xffffe
    8000471e:	8c8080e7          	jalr	-1848(ra) # 80001fe2 <argaddr>
  argint(2, &n);
    80004722:	fe440593          	addi	a1,s0,-28
    80004726:	4509                	li	a0,2
    80004728:	ffffe097          	auipc	ra,0xffffe
    8000472c:	89a080e7          	jalr	-1894(ra) # 80001fc2 <argint>
  if(argfd(0, 0, &f) < 0)
    80004730:	fe840613          	addi	a2,s0,-24
    80004734:	4581                	li	a1,0
    80004736:	4501                	li	a0,0
    80004738:	00000097          	auipc	ra,0x0
    8000473c:	d58080e7          	jalr	-680(ra) # 80004490 <argfd>
    80004740:	87aa                	mv	a5,a0
    return -1;
    80004742:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004744:	0007cc63          	bltz	a5,8000475c <sys_read+0x50>
  return fileread(f, p, n);
    80004748:	fe442603          	lw	a2,-28(s0)
    8000474c:	fd843583          	ld	a1,-40(s0)
    80004750:	fe843503          	ld	a0,-24(s0)
    80004754:	fffff097          	auipc	ra,0xfffff
    80004758:	44e080e7          	jalr	1102(ra) # 80003ba2 <fileread>
}
    8000475c:	70a2                	ld	ra,40(sp)
    8000475e:	7402                	ld	s0,32(sp)
    80004760:	6145                	addi	sp,sp,48
    80004762:	8082                	ret

0000000080004764 <sys_write>:
{
    80004764:	7179                	addi	sp,sp,-48
    80004766:	f406                	sd	ra,40(sp)
    80004768:	f022                	sd	s0,32(sp)
    8000476a:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000476c:	fd840593          	addi	a1,s0,-40
    80004770:	4505                	li	a0,1
    80004772:	ffffe097          	auipc	ra,0xffffe
    80004776:	870080e7          	jalr	-1936(ra) # 80001fe2 <argaddr>
  argint(2, &n);
    8000477a:	fe440593          	addi	a1,s0,-28
    8000477e:	4509                	li	a0,2
    80004780:	ffffe097          	auipc	ra,0xffffe
    80004784:	842080e7          	jalr	-1982(ra) # 80001fc2 <argint>
  if(argfd(0, 0, &f) < 0)
    80004788:	fe840613          	addi	a2,s0,-24
    8000478c:	4581                	li	a1,0
    8000478e:	4501                	li	a0,0
    80004790:	00000097          	auipc	ra,0x0
    80004794:	d00080e7          	jalr	-768(ra) # 80004490 <argfd>
    80004798:	87aa                	mv	a5,a0
    return -1;
    8000479a:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000479c:	0007cc63          	bltz	a5,800047b4 <sys_write+0x50>
  return filewrite(f, p, n);
    800047a0:	fe442603          	lw	a2,-28(s0)
    800047a4:	fd843583          	ld	a1,-40(s0)
    800047a8:	fe843503          	ld	a0,-24(s0)
    800047ac:	fffff097          	auipc	ra,0xfffff
    800047b0:	4b8080e7          	jalr	1208(ra) # 80003c64 <filewrite>
}
    800047b4:	70a2                	ld	ra,40(sp)
    800047b6:	7402                	ld	s0,32(sp)
    800047b8:	6145                	addi	sp,sp,48
    800047ba:	8082                	ret

00000000800047bc <sys_close>:
{
    800047bc:	1101                	addi	sp,sp,-32
    800047be:	ec06                	sd	ra,24(sp)
    800047c0:	e822                	sd	s0,16(sp)
    800047c2:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800047c4:	fe040613          	addi	a2,s0,-32
    800047c8:	fec40593          	addi	a1,s0,-20
    800047cc:	4501                	li	a0,0
    800047ce:	00000097          	auipc	ra,0x0
    800047d2:	cc2080e7          	jalr	-830(ra) # 80004490 <argfd>
    return -1;
    800047d6:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800047d8:	02054463          	bltz	a0,80004800 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800047dc:	ffffc097          	auipc	ra,0xffffc
    800047e0:	67c080e7          	jalr	1660(ra) # 80000e58 <myproc>
    800047e4:	fec42783          	lw	a5,-20(s0)
    800047e8:	07e9                	addi	a5,a5,26
    800047ea:	078e                	slli	a5,a5,0x3
    800047ec:	97aa                	add	a5,a5,a0
    800047ee:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    800047f2:	fe043503          	ld	a0,-32(s0)
    800047f6:	fffff097          	auipc	ra,0xfffff
    800047fa:	272080e7          	jalr	626(ra) # 80003a68 <fileclose>
  return 0;
    800047fe:	4781                	li	a5,0
}
    80004800:	853e                	mv	a0,a5
    80004802:	60e2                	ld	ra,24(sp)
    80004804:	6442                	ld	s0,16(sp)
    80004806:	6105                	addi	sp,sp,32
    80004808:	8082                	ret

000000008000480a <sys_fstat>:
{
    8000480a:	1101                	addi	sp,sp,-32
    8000480c:	ec06                	sd	ra,24(sp)
    8000480e:	e822                	sd	s0,16(sp)
    80004810:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004812:	fe040593          	addi	a1,s0,-32
    80004816:	4505                	li	a0,1
    80004818:	ffffd097          	auipc	ra,0xffffd
    8000481c:	7ca080e7          	jalr	1994(ra) # 80001fe2 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004820:	fe840613          	addi	a2,s0,-24
    80004824:	4581                	li	a1,0
    80004826:	4501                	li	a0,0
    80004828:	00000097          	auipc	ra,0x0
    8000482c:	c68080e7          	jalr	-920(ra) # 80004490 <argfd>
    80004830:	87aa                	mv	a5,a0
    return -1;
    80004832:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004834:	0007ca63          	bltz	a5,80004848 <sys_fstat+0x3e>
  return filestat(f, st);
    80004838:	fe043583          	ld	a1,-32(s0)
    8000483c:	fe843503          	ld	a0,-24(s0)
    80004840:	fffff097          	auipc	ra,0xfffff
    80004844:	2f0080e7          	jalr	752(ra) # 80003b30 <filestat>
}
    80004848:	60e2                	ld	ra,24(sp)
    8000484a:	6442                	ld	s0,16(sp)
    8000484c:	6105                	addi	sp,sp,32
    8000484e:	8082                	ret

0000000080004850 <sys_link>:
{
    80004850:	7169                	addi	sp,sp,-304
    80004852:	f606                	sd	ra,296(sp)
    80004854:	f222                	sd	s0,288(sp)
    80004856:	ee26                	sd	s1,280(sp)
    80004858:	ea4a                	sd	s2,272(sp)
    8000485a:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000485c:	08000613          	li	a2,128
    80004860:	ed040593          	addi	a1,s0,-304
    80004864:	4501                	li	a0,0
    80004866:	ffffd097          	auipc	ra,0xffffd
    8000486a:	79c080e7          	jalr	1948(ra) # 80002002 <argstr>
    return -1;
    8000486e:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004870:	10054e63          	bltz	a0,8000498c <sys_link+0x13c>
    80004874:	08000613          	li	a2,128
    80004878:	f5040593          	addi	a1,s0,-176
    8000487c:	4505                	li	a0,1
    8000487e:	ffffd097          	auipc	ra,0xffffd
    80004882:	784080e7          	jalr	1924(ra) # 80002002 <argstr>
    return -1;
    80004886:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004888:	10054263          	bltz	a0,8000498c <sys_link+0x13c>
  begin_op();
    8000488c:	fffff097          	auipc	ra,0xfffff
    80004890:	d10080e7          	jalr	-752(ra) # 8000359c <begin_op>
  if((ip = namei(old)) == 0){
    80004894:	ed040513          	addi	a0,s0,-304
    80004898:	fffff097          	auipc	ra,0xfffff
    8000489c:	ae8080e7          	jalr	-1304(ra) # 80003380 <namei>
    800048a0:	84aa                	mv	s1,a0
    800048a2:	c551                	beqz	a0,8000492e <sys_link+0xde>
  ilock(ip);
    800048a4:	ffffe097          	auipc	ra,0xffffe
    800048a8:	336080e7          	jalr	822(ra) # 80002bda <ilock>
  if(ip->type == T_DIR){
    800048ac:	04449703          	lh	a4,68(s1)
    800048b0:	4785                	li	a5,1
    800048b2:	08f70463          	beq	a4,a5,8000493a <sys_link+0xea>
  ip->nlink++;
    800048b6:	04a4d783          	lhu	a5,74(s1)
    800048ba:	2785                	addiw	a5,a5,1
    800048bc:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800048c0:	8526                	mv	a0,s1
    800048c2:	ffffe097          	auipc	ra,0xffffe
    800048c6:	24e080e7          	jalr	590(ra) # 80002b10 <iupdate>
  iunlock(ip);
    800048ca:	8526                	mv	a0,s1
    800048cc:	ffffe097          	auipc	ra,0xffffe
    800048d0:	3d0080e7          	jalr	976(ra) # 80002c9c <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800048d4:	fd040593          	addi	a1,s0,-48
    800048d8:	f5040513          	addi	a0,s0,-176
    800048dc:	fffff097          	auipc	ra,0xfffff
    800048e0:	ac2080e7          	jalr	-1342(ra) # 8000339e <nameiparent>
    800048e4:	892a                	mv	s2,a0
    800048e6:	c935                	beqz	a0,8000495a <sys_link+0x10a>
  ilock(dp);
    800048e8:	ffffe097          	auipc	ra,0xffffe
    800048ec:	2f2080e7          	jalr	754(ra) # 80002bda <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800048f0:	00092703          	lw	a4,0(s2)
    800048f4:	409c                	lw	a5,0(s1)
    800048f6:	04f71d63          	bne	a4,a5,80004950 <sys_link+0x100>
    800048fa:	40d0                	lw	a2,4(s1)
    800048fc:	fd040593          	addi	a1,s0,-48
    80004900:	854a                	mv	a0,s2
    80004902:	fffff097          	auipc	ra,0xfffff
    80004906:	9cc080e7          	jalr	-1588(ra) # 800032ce <dirlink>
    8000490a:	04054363          	bltz	a0,80004950 <sys_link+0x100>
  iunlockput(dp);
    8000490e:	854a                	mv	a0,s2
    80004910:	ffffe097          	auipc	ra,0xffffe
    80004914:	52c080e7          	jalr	1324(ra) # 80002e3c <iunlockput>
  iput(ip);
    80004918:	8526                	mv	a0,s1
    8000491a:	ffffe097          	auipc	ra,0xffffe
    8000491e:	47a080e7          	jalr	1146(ra) # 80002d94 <iput>
  end_op();
    80004922:	fffff097          	auipc	ra,0xfffff
    80004926:	cfa080e7          	jalr	-774(ra) # 8000361c <end_op>
  return 0;
    8000492a:	4781                	li	a5,0
    8000492c:	a085                	j	8000498c <sys_link+0x13c>
    end_op();
    8000492e:	fffff097          	auipc	ra,0xfffff
    80004932:	cee080e7          	jalr	-786(ra) # 8000361c <end_op>
    return -1;
    80004936:	57fd                	li	a5,-1
    80004938:	a891                	j	8000498c <sys_link+0x13c>
    iunlockput(ip);
    8000493a:	8526                	mv	a0,s1
    8000493c:	ffffe097          	auipc	ra,0xffffe
    80004940:	500080e7          	jalr	1280(ra) # 80002e3c <iunlockput>
    end_op();
    80004944:	fffff097          	auipc	ra,0xfffff
    80004948:	cd8080e7          	jalr	-808(ra) # 8000361c <end_op>
    return -1;
    8000494c:	57fd                	li	a5,-1
    8000494e:	a83d                	j	8000498c <sys_link+0x13c>
    iunlockput(dp);
    80004950:	854a                	mv	a0,s2
    80004952:	ffffe097          	auipc	ra,0xffffe
    80004956:	4ea080e7          	jalr	1258(ra) # 80002e3c <iunlockput>
  ilock(ip);
    8000495a:	8526                	mv	a0,s1
    8000495c:	ffffe097          	auipc	ra,0xffffe
    80004960:	27e080e7          	jalr	638(ra) # 80002bda <ilock>
  ip->nlink--;
    80004964:	04a4d783          	lhu	a5,74(s1)
    80004968:	37fd                	addiw	a5,a5,-1
    8000496a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000496e:	8526                	mv	a0,s1
    80004970:	ffffe097          	auipc	ra,0xffffe
    80004974:	1a0080e7          	jalr	416(ra) # 80002b10 <iupdate>
  iunlockput(ip);
    80004978:	8526                	mv	a0,s1
    8000497a:	ffffe097          	auipc	ra,0xffffe
    8000497e:	4c2080e7          	jalr	1218(ra) # 80002e3c <iunlockput>
  end_op();
    80004982:	fffff097          	auipc	ra,0xfffff
    80004986:	c9a080e7          	jalr	-870(ra) # 8000361c <end_op>
  return -1;
    8000498a:	57fd                	li	a5,-1
}
    8000498c:	853e                	mv	a0,a5
    8000498e:	70b2                	ld	ra,296(sp)
    80004990:	7412                	ld	s0,288(sp)
    80004992:	64f2                	ld	s1,280(sp)
    80004994:	6952                	ld	s2,272(sp)
    80004996:	6155                	addi	sp,sp,304
    80004998:	8082                	ret

000000008000499a <sys_unlink>:
{
    8000499a:	7151                	addi	sp,sp,-240
    8000499c:	f586                	sd	ra,232(sp)
    8000499e:	f1a2                	sd	s0,224(sp)
    800049a0:	eda6                	sd	s1,216(sp)
    800049a2:	e9ca                	sd	s2,208(sp)
    800049a4:	e5ce                	sd	s3,200(sp)
    800049a6:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800049a8:	08000613          	li	a2,128
    800049ac:	f3040593          	addi	a1,s0,-208
    800049b0:	4501                	li	a0,0
    800049b2:	ffffd097          	auipc	ra,0xffffd
    800049b6:	650080e7          	jalr	1616(ra) # 80002002 <argstr>
    800049ba:	18054163          	bltz	a0,80004b3c <sys_unlink+0x1a2>
  begin_op();
    800049be:	fffff097          	auipc	ra,0xfffff
    800049c2:	bde080e7          	jalr	-1058(ra) # 8000359c <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800049c6:	fb040593          	addi	a1,s0,-80
    800049ca:	f3040513          	addi	a0,s0,-208
    800049ce:	fffff097          	auipc	ra,0xfffff
    800049d2:	9d0080e7          	jalr	-1584(ra) # 8000339e <nameiparent>
    800049d6:	84aa                	mv	s1,a0
    800049d8:	c979                	beqz	a0,80004aae <sys_unlink+0x114>
  ilock(dp);
    800049da:	ffffe097          	auipc	ra,0xffffe
    800049de:	200080e7          	jalr	512(ra) # 80002bda <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800049e2:	00004597          	auipc	a1,0x4
    800049e6:	c9e58593          	addi	a1,a1,-866 # 80008680 <syscalls+0x2b0>
    800049ea:	fb040513          	addi	a0,s0,-80
    800049ee:	ffffe097          	auipc	ra,0xffffe
    800049f2:	6b6080e7          	jalr	1718(ra) # 800030a4 <namecmp>
    800049f6:	14050a63          	beqz	a0,80004b4a <sys_unlink+0x1b0>
    800049fa:	00004597          	auipc	a1,0x4
    800049fe:	c8e58593          	addi	a1,a1,-882 # 80008688 <syscalls+0x2b8>
    80004a02:	fb040513          	addi	a0,s0,-80
    80004a06:	ffffe097          	auipc	ra,0xffffe
    80004a0a:	69e080e7          	jalr	1694(ra) # 800030a4 <namecmp>
    80004a0e:	12050e63          	beqz	a0,80004b4a <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004a12:	f2c40613          	addi	a2,s0,-212
    80004a16:	fb040593          	addi	a1,s0,-80
    80004a1a:	8526                	mv	a0,s1
    80004a1c:	ffffe097          	auipc	ra,0xffffe
    80004a20:	6a2080e7          	jalr	1698(ra) # 800030be <dirlookup>
    80004a24:	892a                	mv	s2,a0
    80004a26:	12050263          	beqz	a0,80004b4a <sys_unlink+0x1b0>
  ilock(ip);
    80004a2a:	ffffe097          	auipc	ra,0xffffe
    80004a2e:	1b0080e7          	jalr	432(ra) # 80002bda <ilock>
  if(ip->nlink < 1)
    80004a32:	04a91783          	lh	a5,74(s2)
    80004a36:	08f05263          	blez	a5,80004aba <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004a3a:	04491703          	lh	a4,68(s2)
    80004a3e:	4785                	li	a5,1
    80004a40:	08f70563          	beq	a4,a5,80004aca <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004a44:	4641                	li	a2,16
    80004a46:	4581                	li	a1,0
    80004a48:	fc040513          	addi	a0,s0,-64
    80004a4c:	ffffb097          	auipc	ra,0xffffb
    80004a50:	72c080e7          	jalr	1836(ra) # 80000178 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a54:	4741                	li	a4,16
    80004a56:	f2c42683          	lw	a3,-212(s0)
    80004a5a:	fc040613          	addi	a2,s0,-64
    80004a5e:	4581                	li	a1,0
    80004a60:	8526                	mv	a0,s1
    80004a62:	ffffe097          	auipc	ra,0xffffe
    80004a66:	524080e7          	jalr	1316(ra) # 80002f86 <writei>
    80004a6a:	47c1                	li	a5,16
    80004a6c:	0af51563          	bne	a0,a5,80004b16 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004a70:	04491703          	lh	a4,68(s2)
    80004a74:	4785                	li	a5,1
    80004a76:	0af70863          	beq	a4,a5,80004b26 <sys_unlink+0x18c>
  iunlockput(dp);
    80004a7a:	8526                	mv	a0,s1
    80004a7c:	ffffe097          	auipc	ra,0xffffe
    80004a80:	3c0080e7          	jalr	960(ra) # 80002e3c <iunlockput>
  ip->nlink--;
    80004a84:	04a95783          	lhu	a5,74(s2)
    80004a88:	37fd                	addiw	a5,a5,-1
    80004a8a:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004a8e:	854a                	mv	a0,s2
    80004a90:	ffffe097          	auipc	ra,0xffffe
    80004a94:	080080e7          	jalr	128(ra) # 80002b10 <iupdate>
  iunlockput(ip);
    80004a98:	854a                	mv	a0,s2
    80004a9a:	ffffe097          	auipc	ra,0xffffe
    80004a9e:	3a2080e7          	jalr	930(ra) # 80002e3c <iunlockput>
  end_op();
    80004aa2:	fffff097          	auipc	ra,0xfffff
    80004aa6:	b7a080e7          	jalr	-1158(ra) # 8000361c <end_op>
  return 0;
    80004aaa:	4501                	li	a0,0
    80004aac:	a84d                	j	80004b5e <sys_unlink+0x1c4>
    end_op();
    80004aae:	fffff097          	auipc	ra,0xfffff
    80004ab2:	b6e080e7          	jalr	-1170(ra) # 8000361c <end_op>
    return -1;
    80004ab6:	557d                	li	a0,-1
    80004ab8:	a05d                	j	80004b5e <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004aba:	00004517          	auipc	a0,0x4
    80004abe:	bd650513          	addi	a0,a0,-1066 # 80008690 <syscalls+0x2c0>
    80004ac2:	00001097          	auipc	ra,0x1
    80004ac6:	210080e7          	jalr	528(ra) # 80005cd2 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004aca:	04c92703          	lw	a4,76(s2)
    80004ace:	02000793          	li	a5,32
    80004ad2:	f6e7f9e3          	bgeu	a5,a4,80004a44 <sys_unlink+0xaa>
    80004ad6:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004ada:	4741                	li	a4,16
    80004adc:	86ce                	mv	a3,s3
    80004ade:	f1840613          	addi	a2,s0,-232
    80004ae2:	4581                	li	a1,0
    80004ae4:	854a                	mv	a0,s2
    80004ae6:	ffffe097          	auipc	ra,0xffffe
    80004aea:	3a8080e7          	jalr	936(ra) # 80002e8e <readi>
    80004aee:	47c1                	li	a5,16
    80004af0:	00f51b63          	bne	a0,a5,80004b06 <sys_unlink+0x16c>
    if(de.inum != 0)
    80004af4:	f1845783          	lhu	a5,-232(s0)
    80004af8:	e7a1                	bnez	a5,80004b40 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004afa:	29c1                	addiw	s3,s3,16
    80004afc:	04c92783          	lw	a5,76(s2)
    80004b00:	fcf9ede3          	bltu	s3,a5,80004ada <sys_unlink+0x140>
    80004b04:	b781                	j	80004a44 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004b06:	00004517          	auipc	a0,0x4
    80004b0a:	ba250513          	addi	a0,a0,-1118 # 800086a8 <syscalls+0x2d8>
    80004b0e:	00001097          	auipc	ra,0x1
    80004b12:	1c4080e7          	jalr	452(ra) # 80005cd2 <panic>
    panic("unlink: writei");
    80004b16:	00004517          	auipc	a0,0x4
    80004b1a:	baa50513          	addi	a0,a0,-1110 # 800086c0 <syscalls+0x2f0>
    80004b1e:	00001097          	auipc	ra,0x1
    80004b22:	1b4080e7          	jalr	436(ra) # 80005cd2 <panic>
    dp->nlink--;
    80004b26:	04a4d783          	lhu	a5,74(s1)
    80004b2a:	37fd                	addiw	a5,a5,-1
    80004b2c:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004b30:	8526                	mv	a0,s1
    80004b32:	ffffe097          	auipc	ra,0xffffe
    80004b36:	fde080e7          	jalr	-34(ra) # 80002b10 <iupdate>
    80004b3a:	b781                	j	80004a7a <sys_unlink+0xe0>
    return -1;
    80004b3c:	557d                	li	a0,-1
    80004b3e:	a005                	j	80004b5e <sys_unlink+0x1c4>
    iunlockput(ip);
    80004b40:	854a                	mv	a0,s2
    80004b42:	ffffe097          	auipc	ra,0xffffe
    80004b46:	2fa080e7          	jalr	762(ra) # 80002e3c <iunlockput>
  iunlockput(dp);
    80004b4a:	8526                	mv	a0,s1
    80004b4c:	ffffe097          	auipc	ra,0xffffe
    80004b50:	2f0080e7          	jalr	752(ra) # 80002e3c <iunlockput>
  end_op();
    80004b54:	fffff097          	auipc	ra,0xfffff
    80004b58:	ac8080e7          	jalr	-1336(ra) # 8000361c <end_op>
  return -1;
    80004b5c:	557d                	li	a0,-1
}
    80004b5e:	70ae                	ld	ra,232(sp)
    80004b60:	740e                	ld	s0,224(sp)
    80004b62:	64ee                	ld	s1,216(sp)
    80004b64:	694e                	ld	s2,208(sp)
    80004b66:	69ae                	ld	s3,200(sp)
    80004b68:	616d                	addi	sp,sp,240
    80004b6a:	8082                	ret

0000000080004b6c <sys_open>:

uint64
sys_open(void)
{
    80004b6c:	7131                	addi	sp,sp,-192
    80004b6e:	fd06                	sd	ra,184(sp)
    80004b70:	f922                	sd	s0,176(sp)
    80004b72:	f526                	sd	s1,168(sp)
    80004b74:	f14a                	sd	s2,160(sp)
    80004b76:	ed4e                	sd	s3,152(sp)
    80004b78:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004b7a:	f4c40593          	addi	a1,s0,-180
    80004b7e:	4505                	li	a0,1
    80004b80:	ffffd097          	auipc	ra,0xffffd
    80004b84:	442080e7          	jalr	1090(ra) # 80001fc2 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004b88:	08000613          	li	a2,128
    80004b8c:	f5040593          	addi	a1,s0,-176
    80004b90:	4501                	li	a0,0
    80004b92:	ffffd097          	auipc	ra,0xffffd
    80004b96:	470080e7          	jalr	1136(ra) # 80002002 <argstr>
    80004b9a:	87aa                	mv	a5,a0
    return -1;
    80004b9c:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004b9e:	0a07c963          	bltz	a5,80004c50 <sys_open+0xe4>

  begin_op();
    80004ba2:	fffff097          	auipc	ra,0xfffff
    80004ba6:	9fa080e7          	jalr	-1542(ra) # 8000359c <begin_op>

  if(omode & O_CREATE){
    80004baa:	f4c42783          	lw	a5,-180(s0)
    80004bae:	2007f793          	andi	a5,a5,512
    80004bb2:	cfc5                	beqz	a5,80004c6a <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004bb4:	4681                	li	a3,0
    80004bb6:	4601                	li	a2,0
    80004bb8:	4589                	li	a1,2
    80004bba:	f5040513          	addi	a0,s0,-176
    80004bbe:	00000097          	auipc	ra,0x0
    80004bc2:	974080e7          	jalr	-1676(ra) # 80004532 <create>
    80004bc6:	84aa                	mv	s1,a0
    if(ip == 0){
    80004bc8:	c959                	beqz	a0,80004c5e <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004bca:	04449703          	lh	a4,68(s1)
    80004bce:	478d                	li	a5,3
    80004bd0:	00f71763          	bne	a4,a5,80004bde <sys_open+0x72>
    80004bd4:	0464d703          	lhu	a4,70(s1)
    80004bd8:	47a5                	li	a5,9
    80004bda:	0ce7ed63          	bltu	a5,a4,80004cb4 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004bde:	fffff097          	auipc	ra,0xfffff
    80004be2:	dce080e7          	jalr	-562(ra) # 800039ac <filealloc>
    80004be6:	89aa                	mv	s3,a0
    80004be8:	10050363          	beqz	a0,80004cee <sys_open+0x182>
    80004bec:	00000097          	auipc	ra,0x0
    80004bf0:	904080e7          	jalr	-1788(ra) # 800044f0 <fdalloc>
    80004bf4:	892a                	mv	s2,a0
    80004bf6:	0e054763          	bltz	a0,80004ce4 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004bfa:	04449703          	lh	a4,68(s1)
    80004bfe:	478d                	li	a5,3
    80004c00:	0cf70563          	beq	a4,a5,80004cca <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004c04:	4789                	li	a5,2
    80004c06:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004c0a:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004c0e:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004c12:	f4c42783          	lw	a5,-180(s0)
    80004c16:	0017c713          	xori	a4,a5,1
    80004c1a:	8b05                	andi	a4,a4,1
    80004c1c:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004c20:	0037f713          	andi	a4,a5,3
    80004c24:	00e03733          	snez	a4,a4
    80004c28:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004c2c:	4007f793          	andi	a5,a5,1024
    80004c30:	c791                	beqz	a5,80004c3c <sys_open+0xd0>
    80004c32:	04449703          	lh	a4,68(s1)
    80004c36:	4789                	li	a5,2
    80004c38:	0af70063          	beq	a4,a5,80004cd8 <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80004c3c:	8526                	mv	a0,s1
    80004c3e:	ffffe097          	auipc	ra,0xffffe
    80004c42:	05e080e7          	jalr	94(ra) # 80002c9c <iunlock>
  end_op();
    80004c46:	fffff097          	auipc	ra,0xfffff
    80004c4a:	9d6080e7          	jalr	-1578(ra) # 8000361c <end_op>

  return fd;
    80004c4e:	854a                	mv	a0,s2
}
    80004c50:	70ea                	ld	ra,184(sp)
    80004c52:	744a                	ld	s0,176(sp)
    80004c54:	74aa                	ld	s1,168(sp)
    80004c56:	790a                	ld	s2,160(sp)
    80004c58:	69ea                	ld	s3,152(sp)
    80004c5a:	6129                	addi	sp,sp,192
    80004c5c:	8082                	ret
      end_op();
    80004c5e:	fffff097          	auipc	ra,0xfffff
    80004c62:	9be080e7          	jalr	-1602(ra) # 8000361c <end_op>
      return -1;
    80004c66:	557d                	li	a0,-1
    80004c68:	b7e5                	j	80004c50 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    80004c6a:	f5040513          	addi	a0,s0,-176
    80004c6e:	ffffe097          	auipc	ra,0xffffe
    80004c72:	712080e7          	jalr	1810(ra) # 80003380 <namei>
    80004c76:	84aa                	mv	s1,a0
    80004c78:	c905                	beqz	a0,80004ca8 <sys_open+0x13c>
    ilock(ip);
    80004c7a:	ffffe097          	auipc	ra,0xffffe
    80004c7e:	f60080e7          	jalr	-160(ra) # 80002bda <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004c82:	04449703          	lh	a4,68(s1)
    80004c86:	4785                	li	a5,1
    80004c88:	f4f711e3          	bne	a4,a5,80004bca <sys_open+0x5e>
    80004c8c:	f4c42783          	lw	a5,-180(s0)
    80004c90:	d7b9                	beqz	a5,80004bde <sys_open+0x72>
      iunlockput(ip);
    80004c92:	8526                	mv	a0,s1
    80004c94:	ffffe097          	auipc	ra,0xffffe
    80004c98:	1a8080e7          	jalr	424(ra) # 80002e3c <iunlockput>
      end_op();
    80004c9c:	fffff097          	auipc	ra,0xfffff
    80004ca0:	980080e7          	jalr	-1664(ra) # 8000361c <end_op>
      return -1;
    80004ca4:	557d                	li	a0,-1
    80004ca6:	b76d                	j	80004c50 <sys_open+0xe4>
      end_op();
    80004ca8:	fffff097          	auipc	ra,0xfffff
    80004cac:	974080e7          	jalr	-1676(ra) # 8000361c <end_op>
      return -1;
    80004cb0:	557d                	li	a0,-1
    80004cb2:	bf79                	j	80004c50 <sys_open+0xe4>
    iunlockput(ip);
    80004cb4:	8526                	mv	a0,s1
    80004cb6:	ffffe097          	auipc	ra,0xffffe
    80004cba:	186080e7          	jalr	390(ra) # 80002e3c <iunlockput>
    end_op();
    80004cbe:	fffff097          	auipc	ra,0xfffff
    80004cc2:	95e080e7          	jalr	-1698(ra) # 8000361c <end_op>
    return -1;
    80004cc6:	557d                	li	a0,-1
    80004cc8:	b761                	j	80004c50 <sys_open+0xe4>
    f->type = FD_DEVICE;
    80004cca:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004cce:	04649783          	lh	a5,70(s1)
    80004cd2:	02f99223          	sh	a5,36(s3)
    80004cd6:	bf25                	j	80004c0e <sys_open+0xa2>
    itrunc(ip);
    80004cd8:	8526                	mv	a0,s1
    80004cda:	ffffe097          	auipc	ra,0xffffe
    80004cde:	00e080e7          	jalr	14(ra) # 80002ce8 <itrunc>
    80004ce2:	bfa9                	j	80004c3c <sys_open+0xd0>
      fileclose(f);
    80004ce4:	854e                	mv	a0,s3
    80004ce6:	fffff097          	auipc	ra,0xfffff
    80004cea:	d82080e7          	jalr	-638(ra) # 80003a68 <fileclose>
    iunlockput(ip);
    80004cee:	8526                	mv	a0,s1
    80004cf0:	ffffe097          	auipc	ra,0xffffe
    80004cf4:	14c080e7          	jalr	332(ra) # 80002e3c <iunlockput>
    end_op();
    80004cf8:	fffff097          	auipc	ra,0xfffff
    80004cfc:	924080e7          	jalr	-1756(ra) # 8000361c <end_op>
    return -1;
    80004d00:	557d                	li	a0,-1
    80004d02:	b7b9                	j	80004c50 <sys_open+0xe4>

0000000080004d04 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004d04:	7175                	addi	sp,sp,-144
    80004d06:	e506                	sd	ra,136(sp)
    80004d08:	e122                	sd	s0,128(sp)
    80004d0a:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004d0c:	fffff097          	auipc	ra,0xfffff
    80004d10:	890080e7          	jalr	-1904(ra) # 8000359c <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004d14:	08000613          	li	a2,128
    80004d18:	f7040593          	addi	a1,s0,-144
    80004d1c:	4501                	li	a0,0
    80004d1e:	ffffd097          	auipc	ra,0xffffd
    80004d22:	2e4080e7          	jalr	740(ra) # 80002002 <argstr>
    80004d26:	02054963          	bltz	a0,80004d58 <sys_mkdir+0x54>
    80004d2a:	4681                	li	a3,0
    80004d2c:	4601                	li	a2,0
    80004d2e:	4585                	li	a1,1
    80004d30:	f7040513          	addi	a0,s0,-144
    80004d34:	fffff097          	auipc	ra,0xfffff
    80004d38:	7fe080e7          	jalr	2046(ra) # 80004532 <create>
    80004d3c:	cd11                	beqz	a0,80004d58 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d3e:	ffffe097          	auipc	ra,0xffffe
    80004d42:	0fe080e7          	jalr	254(ra) # 80002e3c <iunlockput>
  end_op();
    80004d46:	fffff097          	auipc	ra,0xfffff
    80004d4a:	8d6080e7          	jalr	-1834(ra) # 8000361c <end_op>
  return 0;
    80004d4e:	4501                	li	a0,0
}
    80004d50:	60aa                	ld	ra,136(sp)
    80004d52:	640a                	ld	s0,128(sp)
    80004d54:	6149                	addi	sp,sp,144
    80004d56:	8082                	ret
    end_op();
    80004d58:	fffff097          	auipc	ra,0xfffff
    80004d5c:	8c4080e7          	jalr	-1852(ra) # 8000361c <end_op>
    return -1;
    80004d60:	557d                	li	a0,-1
    80004d62:	b7fd                	j	80004d50 <sys_mkdir+0x4c>

0000000080004d64 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004d64:	7135                	addi	sp,sp,-160
    80004d66:	ed06                	sd	ra,152(sp)
    80004d68:	e922                	sd	s0,144(sp)
    80004d6a:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004d6c:	fffff097          	auipc	ra,0xfffff
    80004d70:	830080e7          	jalr	-2000(ra) # 8000359c <begin_op>
  argint(1, &major);
    80004d74:	f6c40593          	addi	a1,s0,-148
    80004d78:	4505                	li	a0,1
    80004d7a:	ffffd097          	auipc	ra,0xffffd
    80004d7e:	248080e7          	jalr	584(ra) # 80001fc2 <argint>
  argint(2, &minor);
    80004d82:	f6840593          	addi	a1,s0,-152
    80004d86:	4509                	li	a0,2
    80004d88:	ffffd097          	auipc	ra,0xffffd
    80004d8c:	23a080e7          	jalr	570(ra) # 80001fc2 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d90:	08000613          	li	a2,128
    80004d94:	f7040593          	addi	a1,s0,-144
    80004d98:	4501                	li	a0,0
    80004d9a:	ffffd097          	auipc	ra,0xffffd
    80004d9e:	268080e7          	jalr	616(ra) # 80002002 <argstr>
    80004da2:	02054b63          	bltz	a0,80004dd8 <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004da6:	f6841683          	lh	a3,-152(s0)
    80004daa:	f6c41603          	lh	a2,-148(s0)
    80004dae:	458d                	li	a1,3
    80004db0:	f7040513          	addi	a0,s0,-144
    80004db4:	fffff097          	auipc	ra,0xfffff
    80004db8:	77e080e7          	jalr	1918(ra) # 80004532 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004dbc:	cd11                	beqz	a0,80004dd8 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004dbe:	ffffe097          	auipc	ra,0xffffe
    80004dc2:	07e080e7          	jalr	126(ra) # 80002e3c <iunlockput>
  end_op();
    80004dc6:	fffff097          	auipc	ra,0xfffff
    80004dca:	856080e7          	jalr	-1962(ra) # 8000361c <end_op>
  return 0;
    80004dce:	4501                	li	a0,0
}
    80004dd0:	60ea                	ld	ra,152(sp)
    80004dd2:	644a                	ld	s0,144(sp)
    80004dd4:	610d                	addi	sp,sp,160
    80004dd6:	8082                	ret
    end_op();
    80004dd8:	fffff097          	auipc	ra,0xfffff
    80004ddc:	844080e7          	jalr	-1980(ra) # 8000361c <end_op>
    return -1;
    80004de0:	557d                	li	a0,-1
    80004de2:	b7fd                	j	80004dd0 <sys_mknod+0x6c>

0000000080004de4 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004de4:	7135                	addi	sp,sp,-160
    80004de6:	ed06                	sd	ra,152(sp)
    80004de8:	e922                	sd	s0,144(sp)
    80004dea:	e526                	sd	s1,136(sp)
    80004dec:	e14a                	sd	s2,128(sp)
    80004dee:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004df0:	ffffc097          	auipc	ra,0xffffc
    80004df4:	068080e7          	jalr	104(ra) # 80000e58 <myproc>
    80004df8:	892a                	mv	s2,a0
  
  begin_op();
    80004dfa:	ffffe097          	auipc	ra,0xffffe
    80004dfe:	7a2080e7          	jalr	1954(ra) # 8000359c <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004e02:	08000613          	li	a2,128
    80004e06:	f6040593          	addi	a1,s0,-160
    80004e0a:	4501                	li	a0,0
    80004e0c:	ffffd097          	auipc	ra,0xffffd
    80004e10:	1f6080e7          	jalr	502(ra) # 80002002 <argstr>
    80004e14:	04054b63          	bltz	a0,80004e6a <sys_chdir+0x86>
    80004e18:	f6040513          	addi	a0,s0,-160
    80004e1c:	ffffe097          	auipc	ra,0xffffe
    80004e20:	564080e7          	jalr	1380(ra) # 80003380 <namei>
    80004e24:	84aa                	mv	s1,a0
    80004e26:	c131                	beqz	a0,80004e6a <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004e28:	ffffe097          	auipc	ra,0xffffe
    80004e2c:	db2080e7          	jalr	-590(ra) # 80002bda <ilock>
  if(ip->type != T_DIR){
    80004e30:	04449703          	lh	a4,68(s1)
    80004e34:	4785                	li	a5,1
    80004e36:	04f71063          	bne	a4,a5,80004e76 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004e3a:	8526                	mv	a0,s1
    80004e3c:	ffffe097          	auipc	ra,0xffffe
    80004e40:	e60080e7          	jalr	-416(ra) # 80002c9c <iunlock>
  iput(p->cwd);
    80004e44:	15093503          	ld	a0,336(s2)
    80004e48:	ffffe097          	auipc	ra,0xffffe
    80004e4c:	f4c080e7          	jalr	-180(ra) # 80002d94 <iput>
  end_op();
    80004e50:	ffffe097          	auipc	ra,0xffffe
    80004e54:	7cc080e7          	jalr	1996(ra) # 8000361c <end_op>
  p->cwd = ip;
    80004e58:	14993823          	sd	s1,336(s2)
  return 0;
    80004e5c:	4501                	li	a0,0
}
    80004e5e:	60ea                	ld	ra,152(sp)
    80004e60:	644a                	ld	s0,144(sp)
    80004e62:	64aa                	ld	s1,136(sp)
    80004e64:	690a                	ld	s2,128(sp)
    80004e66:	610d                	addi	sp,sp,160
    80004e68:	8082                	ret
    end_op();
    80004e6a:	ffffe097          	auipc	ra,0xffffe
    80004e6e:	7b2080e7          	jalr	1970(ra) # 8000361c <end_op>
    return -1;
    80004e72:	557d                	li	a0,-1
    80004e74:	b7ed                	j	80004e5e <sys_chdir+0x7a>
    iunlockput(ip);
    80004e76:	8526                	mv	a0,s1
    80004e78:	ffffe097          	auipc	ra,0xffffe
    80004e7c:	fc4080e7          	jalr	-60(ra) # 80002e3c <iunlockput>
    end_op();
    80004e80:	ffffe097          	auipc	ra,0xffffe
    80004e84:	79c080e7          	jalr	1948(ra) # 8000361c <end_op>
    return -1;
    80004e88:	557d                	li	a0,-1
    80004e8a:	bfd1                	j	80004e5e <sys_chdir+0x7a>

0000000080004e8c <sys_exec>:

uint64
sys_exec(void)
{
    80004e8c:	7145                	addi	sp,sp,-464
    80004e8e:	e786                	sd	ra,456(sp)
    80004e90:	e3a2                	sd	s0,448(sp)
    80004e92:	ff26                	sd	s1,440(sp)
    80004e94:	fb4a                	sd	s2,432(sp)
    80004e96:	f74e                	sd	s3,424(sp)
    80004e98:	f352                	sd	s4,416(sp)
    80004e9a:	ef56                	sd	s5,408(sp)
    80004e9c:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004e9e:	e3840593          	addi	a1,s0,-456
    80004ea2:	4505                	li	a0,1
    80004ea4:	ffffd097          	auipc	ra,0xffffd
    80004ea8:	13e080e7          	jalr	318(ra) # 80001fe2 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004eac:	08000613          	li	a2,128
    80004eb0:	f4040593          	addi	a1,s0,-192
    80004eb4:	4501                	li	a0,0
    80004eb6:	ffffd097          	auipc	ra,0xffffd
    80004eba:	14c080e7          	jalr	332(ra) # 80002002 <argstr>
    80004ebe:	87aa                	mv	a5,a0
    return -1;
    80004ec0:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004ec2:	0c07c263          	bltz	a5,80004f86 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80004ec6:	10000613          	li	a2,256
    80004eca:	4581                	li	a1,0
    80004ecc:	e4040513          	addi	a0,s0,-448
    80004ed0:	ffffb097          	auipc	ra,0xffffb
    80004ed4:	2a8080e7          	jalr	680(ra) # 80000178 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004ed8:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80004edc:	89a6                	mv	s3,s1
    80004ede:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004ee0:	02000a13          	li	s4,32
    80004ee4:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004ee8:	00391513          	slli	a0,s2,0x3
    80004eec:	e3040593          	addi	a1,s0,-464
    80004ef0:	e3843783          	ld	a5,-456(s0)
    80004ef4:	953e                	add	a0,a0,a5
    80004ef6:	ffffd097          	auipc	ra,0xffffd
    80004efa:	02e080e7          	jalr	46(ra) # 80001f24 <fetchaddr>
    80004efe:	02054a63          	bltz	a0,80004f32 <sys_exec+0xa6>
      goto bad;
    }
    if(uarg == 0){
    80004f02:	e3043783          	ld	a5,-464(s0)
    80004f06:	c3b9                	beqz	a5,80004f4c <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004f08:	ffffb097          	auipc	ra,0xffffb
    80004f0c:	210080e7          	jalr	528(ra) # 80000118 <kalloc>
    80004f10:	85aa                	mv	a1,a0
    80004f12:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004f16:	cd11                	beqz	a0,80004f32 <sys_exec+0xa6>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004f18:	6605                	lui	a2,0x1
    80004f1a:	e3043503          	ld	a0,-464(s0)
    80004f1e:	ffffd097          	auipc	ra,0xffffd
    80004f22:	058080e7          	jalr	88(ra) # 80001f76 <fetchstr>
    80004f26:	00054663          	bltz	a0,80004f32 <sys_exec+0xa6>
    if(i >= NELEM(argv)){
    80004f2a:	0905                	addi	s2,s2,1
    80004f2c:	09a1                	addi	s3,s3,8
    80004f2e:	fb491be3          	bne	s2,s4,80004ee4 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f32:	10048913          	addi	s2,s1,256
    80004f36:	6088                	ld	a0,0(s1)
    80004f38:	c531                	beqz	a0,80004f84 <sys_exec+0xf8>
    kfree(argv[i]);
    80004f3a:	ffffb097          	auipc	ra,0xffffb
    80004f3e:	0e2080e7          	jalr	226(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f42:	04a1                	addi	s1,s1,8
    80004f44:	ff2499e3          	bne	s1,s2,80004f36 <sys_exec+0xaa>
  return -1;
    80004f48:	557d                	li	a0,-1
    80004f4a:	a835                	j	80004f86 <sys_exec+0xfa>
      argv[i] = 0;
    80004f4c:	0a8e                	slli	s5,s5,0x3
    80004f4e:	fc040793          	addi	a5,s0,-64
    80004f52:	9abe                	add	s5,s5,a5
    80004f54:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    80004f58:	e4040593          	addi	a1,s0,-448
    80004f5c:	f4040513          	addi	a0,s0,-192
    80004f60:	fffff097          	auipc	ra,0xfffff
    80004f64:	190080e7          	jalr	400(ra) # 800040f0 <exec>
    80004f68:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f6a:	10048993          	addi	s3,s1,256
    80004f6e:	6088                	ld	a0,0(s1)
    80004f70:	c901                	beqz	a0,80004f80 <sys_exec+0xf4>
    kfree(argv[i]);
    80004f72:	ffffb097          	auipc	ra,0xffffb
    80004f76:	0aa080e7          	jalr	170(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f7a:	04a1                	addi	s1,s1,8
    80004f7c:	ff3499e3          	bne	s1,s3,80004f6e <sys_exec+0xe2>
  return ret;
    80004f80:	854a                	mv	a0,s2
    80004f82:	a011                	j	80004f86 <sys_exec+0xfa>
  return -1;
    80004f84:	557d                	li	a0,-1
}
    80004f86:	60be                	ld	ra,456(sp)
    80004f88:	641e                	ld	s0,448(sp)
    80004f8a:	74fa                	ld	s1,440(sp)
    80004f8c:	795a                	ld	s2,432(sp)
    80004f8e:	79ba                	ld	s3,424(sp)
    80004f90:	7a1a                	ld	s4,416(sp)
    80004f92:	6afa                	ld	s5,408(sp)
    80004f94:	6179                	addi	sp,sp,464
    80004f96:	8082                	ret

0000000080004f98 <sys_pipe>:

uint64
sys_pipe(void)
{
    80004f98:	7139                	addi	sp,sp,-64
    80004f9a:	fc06                	sd	ra,56(sp)
    80004f9c:	f822                	sd	s0,48(sp)
    80004f9e:	f426                	sd	s1,40(sp)
    80004fa0:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004fa2:	ffffc097          	auipc	ra,0xffffc
    80004fa6:	eb6080e7          	jalr	-330(ra) # 80000e58 <myproc>
    80004faa:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80004fac:	fd840593          	addi	a1,s0,-40
    80004fb0:	4501                	li	a0,0
    80004fb2:	ffffd097          	auipc	ra,0xffffd
    80004fb6:	030080e7          	jalr	48(ra) # 80001fe2 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80004fba:	fc840593          	addi	a1,s0,-56
    80004fbe:	fd040513          	addi	a0,s0,-48
    80004fc2:	fffff097          	auipc	ra,0xfffff
    80004fc6:	dd6080e7          	jalr	-554(ra) # 80003d98 <pipealloc>
    return -1;
    80004fca:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004fcc:	0c054463          	bltz	a0,80005094 <sys_pipe+0xfc>
  fd0 = -1;
    80004fd0:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004fd4:	fd043503          	ld	a0,-48(s0)
    80004fd8:	fffff097          	auipc	ra,0xfffff
    80004fdc:	518080e7          	jalr	1304(ra) # 800044f0 <fdalloc>
    80004fe0:	fca42223          	sw	a0,-60(s0)
    80004fe4:	08054b63          	bltz	a0,8000507a <sys_pipe+0xe2>
    80004fe8:	fc843503          	ld	a0,-56(s0)
    80004fec:	fffff097          	auipc	ra,0xfffff
    80004ff0:	504080e7          	jalr	1284(ra) # 800044f0 <fdalloc>
    80004ff4:	fca42023          	sw	a0,-64(s0)
    80004ff8:	06054863          	bltz	a0,80005068 <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004ffc:	4691                	li	a3,4
    80004ffe:	fc440613          	addi	a2,s0,-60
    80005002:	fd843583          	ld	a1,-40(s0)
    80005006:	68a8                	ld	a0,80(s1)
    80005008:	ffffc097          	auipc	ra,0xffffc
    8000500c:	b0e080e7          	jalr	-1266(ra) # 80000b16 <copyout>
    80005010:	02054063          	bltz	a0,80005030 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005014:	4691                	li	a3,4
    80005016:	fc040613          	addi	a2,s0,-64
    8000501a:	fd843583          	ld	a1,-40(s0)
    8000501e:	0591                	addi	a1,a1,4
    80005020:	68a8                	ld	a0,80(s1)
    80005022:	ffffc097          	auipc	ra,0xffffc
    80005026:	af4080e7          	jalr	-1292(ra) # 80000b16 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000502a:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000502c:	06055463          	bgez	a0,80005094 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80005030:	fc442783          	lw	a5,-60(s0)
    80005034:	07e9                	addi	a5,a5,26
    80005036:	078e                	slli	a5,a5,0x3
    80005038:	97a6                	add	a5,a5,s1
    8000503a:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    8000503e:	fc042503          	lw	a0,-64(s0)
    80005042:	0569                	addi	a0,a0,26
    80005044:	050e                	slli	a0,a0,0x3
    80005046:	94aa                	add	s1,s1,a0
    80005048:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    8000504c:	fd043503          	ld	a0,-48(s0)
    80005050:	fffff097          	auipc	ra,0xfffff
    80005054:	a18080e7          	jalr	-1512(ra) # 80003a68 <fileclose>
    fileclose(wf);
    80005058:	fc843503          	ld	a0,-56(s0)
    8000505c:	fffff097          	auipc	ra,0xfffff
    80005060:	a0c080e7          	jalr	-1524(ra) # 80003a68 <fileclose>
    return -1;
    80005064:	57fd                	li	a5,-1
    80005066:	a03d                	j	80005094 <sys_pipe+0xfc>
    if(fd0 >= 0)
    80005068:	fc442783          	lw	a5,-60(s0)
    8000506c:	0007c763          	bltz	a5,8000507a <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80005070:	07e9                	addi	a5,a5,26
    80005072:	078e                	slli	a5,a5,0x3
    80005074:	94be                	add	s1,s1,a5
    80005076:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    8000507a:	fd043503          	ld	a0,-48(s0)
    8000507e:	fffff097          	auipc	ra,0xfffff
    80005082:	9ea080e7          	jalr	-1558(ra) # 80003a68 <fileclose>
    fileclose(wf);
    80005086:	fc843503          	ld	a0,-56(s0)
    8000508a:	fffff097          	auipc	ra,0xfffff
    8000508e:	9de080e7          	jalr	-1570(ra) # 80003a68 <fileclose>
    return -1;
    80005092:	57fd                	li	a5,-1
}
    80005094:	853e                	mv	a0,a5
    80005096:	70e2                	ld	ra,56(sp)
    80005098:	7442                	ld	s0,48(sp)
    8000509a:	74a2                	ld	s1,40(sp)
    8000509c:	6121                	addi	sp,sp,64
    8000509e:	8082                	ret

00000000800050a0 <kernelvec>:
    800050a0:	7111                	addi	sp,sp,-256
    800050a2:	e006                	sd	ra,0(sp)
    800050a4:	e40a                	sd	sp,8(sp)
    800050a6:	e80e                	sd	gp,16(sp)
    800050a8:	ec12                	sd	tp,24(sp)
    800050aa:	f016                	sd	t0,32(sp)
    800050ac:	f41a                	sd	t1,40(sp)
    800050ae:	f81e                	sd	t2,48(sp)
    800050b0:	fc22                	sd	s0,56(sp)
    800050b2:	e0a6                	sd	s1,64(sp)
    800050b4:	e4aa                	sd	a0,72(sp)
    800050b6:	e8ae                	sd	a1,80(sp)
    800050b8:	ecb2                	sd	a2,88(sp)
    800050ba:	f0b6                	sd	a3,96(sp)
    800050bc:	f4ba                	sd	a4,104(sp)
    800050be:	f8be                	sd	a5,112(sp)
    800050c0:	fcc2                	sd	a6,120(sp)
    800050c2:	e146                	sd	a7,128(sp)
    800050c4:	e54a                	sd	s2,136(sp)
    800050c6:	e94e                	sd	s3,144(sp)
    800050c8:	ed52                	sd	s4,152(sp)
    800050ca:	f156                	sd	s5,160(sp)
    800050cc:	f55a                	sd	s6,168(sp)
    800050ce:	f95e                	sd	s7,176(sp)
    800050d0:	fd62                	sd	s8,184(sp)
    800050d2:	e1e6                	sd	s9,192(sp)
    800050d4:	e5ea                	sd	s10,200(sp)
    800050d6:	e9ee                	sd	s11,208(sp)
    800050d8:	edf2                	sd	t3,216(sp)
    800050da:	f1f6                	sd	t4,224(sp)
    800050dc:	f5fa                	sd	t5,232(sp)
    800050de:	f9fe                	sd	t6,240(sp)
    800050e0:	d11fc0ef          	jal	ra,80001df0 <kerneltrap>
    800050e4:	6082                	ld	ra,0(sp)
    800050e6:	6122                	ld	sp,8(sp)
    800050e8:	61c2                	ld	gp,16(sp)
    800050ea:	7282                	ld	t0,32(sp)
    800050ec:	7322                	ld	t1,40(sp)
    800050ee:	73c2                	ld	t2,48(sp)
    800050f0:	7462                	ld	s0,56(sp)
    800050f2:	6486                	ld	s1,64(sp)
    800050f4:	6526                	ld	a0,72(sp)
    800050f6:	65c6                	ld	a1,80(sp)
    800050f8:	6666                	ld	a2,88(sp)
    800050fa:	7686                	ld	a3,96(sp)
    800050fc:	7726                	ld	a4,104(sp)
    800050fe:	77c6                	ld	a5,112(sp)
    80005100:	7866                	ld	a6,120(sp)
    80005102:	688a                	ld	a7,128(sp)
    80005104:	692a                	ld	s2,136(sp)
    80005106:	69ca                	ld	s3,144(sp)
    80005108:	6a6a                	ld	s4,152(sp)
    8000510a:	7a8a                	ld	s5,160(sp)
    8000510c:	7b2a                	ld	s6,168(sp)
    8000510e:	7bca                	ld	s7,176(sp)
    80005110:	7c6a                	ld	s8,184(sp)
    80005112:	6c8e                	ld	s9,192(sp)
    80005114:	6d2e                	ld	s10,200(sp)
    80005116:	6dce                	ld	s11,208(sp)
    80005118:	6e6e                	ld	t3,216(sp)
    8000511a:	7e8e                	ld	t4,224(sp)
    8000511c:	7f2e                	ld	t5,232(sp)
    8000511e:	7fce                	ld	t6,240(sp)
    80005120:	6111                	addi	sp,sp,256
    80005122:	10200073          	sret
    80005126:	00000013          	nop
    8000512a:	00000013          	nop
    8000512e:	0001                	nop

0000000080005130 <timervec>:
    80005130:	34051573          	csrrw	a0,mscratch,a0
    80005134:	e10c                	sd	a1,0(a0)
    80005136:	e510                	sd	a2,8(a0)
    80005138:	e914                	sd	a3,16(a0)
    8000513a:	6d0c                	ld	a1,24(a0)
    8000513c:	7110                	ld	a2,32(a0)
    8000513e:	6194                	ld	a3,0(a1)
    80005140:	96b2                	add	a3,a3,a2
    80005142:	e194                	sd	a3,0(a1)
    80005144:	4589                	li	a1,2
    80005146:	14459073          	csrw	sip,a1
    8000514a:	6914                	ld	a3,16(a0)
    8000514c:	6510                	ld	a2,8(a0)
    8000514e:	610c                	ld	a1,0(a0)
    80005150:	34051573          	csrrw	a0,mscratch,a0
    80005154:	30200073          	mret
	...

000000008000515a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000515a:	1141                	addi	sp,sp,-16
    8000515c:	e422                	sd	s0,8(sp)
    8000515e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005160:	0c0007b7          	lui	a5,0xc000
    80005164:	4705                	li	a4,1
    80005166:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005168:	c3d8                	sw	a4,4(a5)
}
    8000516a:	6422                	ld	s0,8(sp)
    8000516c:	0141                	addi	sp,sp,16
    8000516e:	8082                	ret

0000000080005170 <plicinithart>:

void
plicinithart(void)
{
    80005170:	1141                	addi	sp,sp,-16
    80005172:	e406                	sd	ra,8(sp)
    80005174:	e022                	sd	s0,0(sp)
    80005176:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005178:	ffffc097          	auipc	ra,0xffffc
    8000517c:	cb4080e7          	jalr	-844(ra) # 80000e2c <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005180:	0085171b          	slliw	a4,a0,0x8
    80005184:	0c0027b7          	lui	a5,0xc002
    80005188:	97ba                	add	a5,a5,a4
    8000518a:	40200713          	li	a4,1026
    8000518e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005192:	00d5151b          	slliw	a0,a0,0xd
    80005196:	0c2017b7          	lui	a5,0xc201
    8000519a:	953e                	add	a0,a0,a5
    8000519c:	00052023          	sw	zero,0(a0)
}
    800051a0:	60a2                	ld	ra,8(sp)
    800051a2:	6402                	ld	s0,0(sp)
    800051a4:	0141                	addi	sp,sp,16
    800051a6:	8082                	ret

00000000800051a8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800051a8:	1141                	addi	sp,sp,-16
    800051aa:	e406                	sd	ra,8(sp)
    800051ac:	e022                	sd	s0,0(sp)
    800051ae:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800051b0:	ffffc097          	auipc	ra,0xffffc
    800051b4:	c7c080e7          	jalr	-900(ra) # 80000e2c <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800051b8:	00d5179b          	slliw	a5,a0,0xd
    800051bc:	0c201537          	lui	a0,0xc201
    800051c0:	953e                	add	a0,a0,a5
  return irq;
}
    800051c2:	4148                	lw	a0,4(a0)
    800051c4:	60a2                	ld	ra,8(sp)
    800051c6:	6402                	ld	s0,0(sp)
    800051c8:	0141                	addi	sp,sp,16
    800051ca:	8082                	ret

00000000800051cc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800051cc:	1101                	addi	sp,sp,-32
    800051ce:	ec06                	sd	ra,24(sp)
    800051d0:	e822                	sd	s0,16(sp)
    800051d2:	e426                	sd	s1,8(sp)
    800051d4:	1000                	addi	s0,sp,32
    800051d6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800051d8:	ffffc097          	auipc	ra,0xffffc
    800051dc:	c54080e7          	jalr	-940(ra) # 80000e2c <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800051e0:	00d5151b          	slliw	a0,a0,0xd
    800051e4:	0c2017b7          	lui	a5,0xc201
    800051e8:	97aa                	add	a5,a5,a0
    800051ea:	c3c4                	sw	s1,4(a5)
}
    800051ec:	60e2                	ld	ra,24(sp)
    800051ee:	6442                	ld	s0,16(sp)
    800051f0:	64a2                	ld	s1,8(sp)
    800051f2:	6105                	addi	sp,sp,32
    800051f4:	8082                	ret

00000000800051f6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800051f6:	1141                	addi	sp,sp,-16
    800051f8:	e406                	sd	ra,8(sp)
    800051fa:	e022                	sd	s0,0(sp)
    800051fc:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800051fe:	479d                	li	a5,7
    80005200:	04a7cc63          	blt	a5,a0,80005258 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80005204:	00015797          	auipc	a5,0x15
    80005208:	dfc78793          	addi	a5,a5,-516 # 8001a000 <disk>
    8000520c:	97aa                	add	a5,a5,a0
    8000520e:	0187c783          	lbu	a5,24(a5)
    80005212:	ebb9                	bnez	a5,80005268 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005214:	00451613          	slli	a2,a0,0x4
    80005218:	00015797          	auipc	a5,0x15
    8000521c:	de878793          	addi	a5,a5,-536 # 8001a000 <disk>
    80005220:	6394                	ld	a3,0(a5)
    80005222:	96b2                	add	a3,a3,a2
    80005224:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    80005228:	6398                	ld	a4,0(a5)
    8000522a:	9732                	add	a4,a4,a2
    8000522c:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005230:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005234:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005238:	953e                	add	a0,a0,a5
    8000523a:	4785                	li	a5,1
    8000523c:	00f50c23          	sb	a5,24(a0) # c201018 <_entry-0x73dfefe8>
  wakeup(&disk.free[0]);
    80005240:	00015517          	auipc	a0,0x15
    80005244:	dd850513          	addi	a0,a0,-552 # 8001a018 <disk+0x18>
    80005248:	ffffc097          	auipc	ra,0xffffc
    8000524c:	324080e7          	jalr	804(ra) # 8000156c <wakeup>
}
    80005250:	60a2                	ld	ra,8(sp)
    80005252:	6402                	ld	s0,0(sp)
    80005254:	0141                	addi	sp,sp,16
    80005256:	8082                	ret
    panic("free_desc 1");
    80005258:	00003517          	auipc	a0,0x3
    8000525c:	47850513          	addi	a0,a0,1144 # 800086d0 <syscalls+0x300>
    80005260:	00001097          	auipc	ra,0x1
    80005264:	a72080e7          	jalr	-1422(ra) # 80005cd2 <panic>
    panic("free_desc 2");
    80005268:	00003517          	auipc	a0,0x3
    8000526c:	47850513          	addi	a0,a0,1144 # 800086e0 <syscalls+0x310>
    80005270:	00001097          	auipc	ra,0x1
    80005274:	a62080e7          	jalr	-1438(ra) # 80005cd2 <panic>

0000000080005278 <virtio_disk_init>:
{
    80005278:	1101                	addi	sp,sp,-32
    8000527a:	ec06                	sd	ra,24(sp)
    8000527c:	e822                	sd	s0,16(sp)
    8000527e:	e426                	sd	s1,8(sp)
    80005280:	e04a                	sd	s2,0(sp)
    80005282:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005284:	00003597          	auipc	a1,0x3
    80005288:	46c58593          	addi	a1,a1,1132 # 800086f0 <syscalls+0x320>
    8000528c:	00015517          	auipc	a0,0x15
    80005290:	e9c50513          	addi	a0,a0,-356 # 8001a128 <disk+0x128>
    80005294:	00001097          	auipc	ra,0x1
    80005298:	f54080e7          	jalr	-172(ra) # 800061e8 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000529c:	100017b7          	lui	a5,0x10001
    800052a0:	4398                	lw	a4,0(a5)
    800052a2:	2701                	sext.w	a4,a4
    800052a4:	747277b7          	lui	a5,0x74727
    800052a8:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800052ac:	14f71e63          	bne	a4,a5,80005408 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800052b0:	100017b7          	lui	a5,0x10001
    800052b4:	43dc                	lw	a5,4(a5)
    800052b6:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800052b8:	4709                	li	a4,2
    800052ba:	14e79763          	bne	a5,a4,80005408 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800052be:	100017b7          	lui	a5,0x10001
    800052c2:	479c                	lw	a5,8(a5)
    800052c4:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800052c6:	14e79163          	bne	a5,a4,80005408 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800052ca:	100017b7          	lui	a5,0x10001
    800052ce:	47d8                	lw	a4,12(a5)
    800052d0:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800052d2:	554d47b7          	lui	a5,0x554d4
    800052d6:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800052da:	12f71763          	bne	a4,a5,80005408 <virtio_disk_init+0x190>
  *R(VIRTIO_MMIO_STATUS) = status;
    800052de:	100017b7          	lui	a5,0x10001
    800052e2:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800052e6:	4705                	li	a4,1
    800052e8:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800052ea:	470d                	li	a4,3
    800052ec:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800052ee:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800052f0:	c7ffe737          	lui	a4,0xc7ffe
    800052f4:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fdc3df>
    800052f8:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800052fa:	2701                	sext.w	a4,a4
    800052fc:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800052fe:	472d                	li	a4,11
    80005300:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80005302:	0707a903          	lw	s2,112(a5)
    80005306:	2901                	sext.w	s2,s2
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005308:	00897793          	andi	a5,s2,8
    8000530c:	10078663          	beqz	a5,80005418 <virtio_disk_init+0x1a0>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005310:	100017b7          	lui	a5,0x10001
    80005314:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005318:	43fc                	lw	a5,68(a5)
    8000531a:	2781                	sext.w	a5,a5
    8000531c:	10079663          	bnez	a5,80005428 <virtio_disk_init+0x1b0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005320:	100017b7          	lui	a5,0x10001
    80005324:	5bdc                	lw	a5,52(a5)
    80005326:	2781                	sext.w	a5,a5
  if(max == 0)
    80005328:	10078863          	beqz	a5,80005438 <virtio_disk_init+0x1c0>
  if(max < NUM)
    8000532c:	471d                	li	a4,7
    8000532e:	10f77d63          	bgeu	a4,a5,80005448 <virtio_disk_init+0x1d0>
  disk.desc = kalloc();
    80005332:	ffffb097          	auipc	ra,0xffffb
    80005336:	de6080e7          	jalr	-538(ra) # 80000118 <kalloc>
    8000533a:	00015497          	auipc	s1,0x15
    8000533e:	cc648493          	addi	s1,s1,-826 # 8001a000 <disk>
    80005342:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005344:	ffffb097          	auipc	ra,0xffffb
    80005348:	dd4080e7          	jalr	-556(ra) # 80000118 <kalloc>
    8000534c:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000534e:	ffffb097          	auipc	ra,0xffffb
    80005352:	dca080e7          	jalr	-566(ra) # 80000118 <kalloc>
    80005356:	87aa                	mv	a5,a0
    80005358:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    8000535a:	6088                	ld	a0,0(s1)
    8000535c:	cd75                	beqz	a0,80005458 <virtio_disk_init+0x1e0>
    8000535e:	00015717          	auipc	a4,0x15
    80005362:	caa73703          	ld	a4,-854(a4) # 8001a008 <disk+0x8>
    80005366:	cb6d                	beqz	a4,80005458 <virtio_disk_init+0x1e0>
    80005368:	cbe5                	beqz	a5,80005458 <virtio_disk_init+0x1e0>
  memset(disk.desc, 0, PGSIZE);
    8000536a:	6605                	lui	a2,0x1
    8000536c:	4581                	li	a1,0
    8000536e:	ffffb097          	auipc	ra,0xffffb
    80005372:	e0a080e7          	jalr	-502(ra) # 80000178 <memset>
  memset(disk.avail, 0, PGSIZE);
    80005376:	00015497          	auipc	s1,0x15
    8000537a:	c8a48493          	addi	s1,s1,-886 # 8001a000 <disk>
    8000537e:	6605                	lui	a2,0x1
    80005380:	4581                	li	a1,0
    80005382:	6488                	ld	a0,8(s1)
    80005384:	ffffb097          	auipc	ra,0xffffb
    80005388:	df4080e7          	jalr	-524(ra) # 80000178 <memset>
  memset(disk.used, 0, PGSIZE);
    8000538c:	6605                	lui	a2,0x1
    8000538e:	4581                	li	a1,0
    80005390:	6888                	ld	a0,16(s1)
    80005392:	ffffb097          	auipc	ra,0xffffb
    80005396:	de6080e7          	jalr	-538(ra) # 80000178 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000539a:	100017b7          	lui	a5,0x10001
    8000539e:	4721                	li	a4,8
    800053a0:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800053a2:	4098                	lw	a4,0(s1)
    800053a4:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800053a8:	40d8                	lw	a4,4(s1)
    800053aa:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800053ae:	6498                	ld	a4,8(s1)
    800053b0:	0007069b          	sext.w	a3,a4
    800053b4:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800053b8:	9701                	srai	a4,a4,0x20
    800053ba:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800053be:	6898                	ld	a4,16(s1)
    800053c0:	0007069b          	sext.w	a3,a4
    800053c4:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800053c8:	9701                	srai	a4,a4,0x20
    800053ca:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800053ce:	4685                	li	a3,1
    800053d0:	c3f4                	sw	a3,68(a5)
    disk.free[i] = 1;
    800053d2:	4705                	li	a4,1
    800053d4:	00d48c23          	sb	a3,24(s1)
    800053d8:	00e48ca3          	sb	a4,25(s1)
    800053dc:	00e48d23          	sb	a4,26(s1)
    800053e0:	00e48da3          	sb	a4,27(s1)
    800053e4:	00e48e23          	sb	a4,28(s1)
    800053e8:	00e48ea3          	sb	a4,29(s1)
    800053ec:	00e48f23          	sb	a4,30(s1)
    800053f0:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800053f4:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800053f8:	0727a823          	sw	s2,112(a5)
}
    800053fc:	60e2                	ld	ra,24(sp)
    800053fe:	6442                	ld	s0,16(sp)
    80005400:	64a2                	ld	s1,8(sp)
    80005402:	6902                	ld	s2,0(sp)
    80005404:	6105                	addi	sp,sp,32
    80005406:	8082                	ret
    panic("could not find virtio disk");
    80005408:	00003517          	auipc	a0,0x3
    8000540c:	2f850513          	addi	a0,a0,760 # 80008700 <syscalls+0x330>
    80005410:	00001097          	auipc	ra,0x1
    80005414:	8c2080e7          	jalr	-1854(ra) # 80005cd2 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005418:	00003517          	auipc	a0,0x3
    8000541c:	30850513          	addi	a0,a0,776 # 80008720 <syscalls+0x350>
    80005420:	00001097          	auipc	ra,0x1
    80005424:	8b2080e7          	jalr	-1870(ra) # 80005cd2 <panic>
    panic("virtio disk should not be ready");
    80005428:	00003517          	auipc	a0,0x3
    8000542c:	31850513          	addi	a0,a0,792 # 80008740 <syscalls+0x370>
    80005430:	00001097          	auipc	ra,0x1
    80005434:	8a2080e7          	jalr	-1886(ra) # 80005cd2 <panic>
    panic("virtio disk has no queue 0");
    80005438:	00003517          	auipc	a0,0x3
    8000543c:	32850513          	addi	a0,a0,808 # 80008760 <syscalls+0x390>
    80005440:	00001097          	auipc	ra,0x1
    80005444:	892080e7          	jalr	-1902(ra) # 80005cd2 <panic>
    panic("virtio disk max queue too short");
    80005448:	00003517          	auipc	a0,0x3
    8000544c:	33850513          	addi	a0,a0,824 # 80008780 <syscalls+0x3b0>
    80005450:	00001097          	auipc	ra,0x1
    80005454:	882080e7          	jalr	-1918(ra) # 80005cd2 <panic>
    panic("virtio disk kalloc");
    80005458:	00003517          	auipc	a0,0x3
    8000545c:	34850513          	addi	a0,a0,840 # 800087a0 <syscalls+0x3d0>
    80005460:	00001097          	auipc	ra,0x1
    80005464:	872080e7          	jalr	-1934(ra) # 80005cd2 <panic>

0000000080005468 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005468:	7159                	addi	sp,sp,-112
    8000546a:	f486                	sd	ra,104(sp)
    8000546c:	f0a2                	sd	s0,96(sp)
    8000546e:	eca6                	sd	s1,88(sp)
    80005470:	e8ca                	sd	s2,80(sp)
    80005472:	e4ce                	sd	s3,72(sp)
    80005474:	e0d2                	sd	s4,64(sp)
    80005476:	fc56                	sd	s5,56(sp)
    80005478:	f85a                	sd	s6,48(sp)
    8000547a:	f45e                	sd	s7,40(sp)
    8000547c:	f062                	sd	s8,32(sp)
    8000547e:	ec66                	sd	s9,24(sp)
    80005480:	e86a                	sd	s10,16(sp)
    80005482:	1880                	addi	s0,sp,112
    80005484:	892a                	mv	s2,a0
    80005486:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005488:	00c52c83          	lw	s9,12(a0)
    8000548c:	001c9c9b          	slliw	s9,s9,0x1
    80005490:	1c82                	slli	s9,s9,0x20
    80005492:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005496:	00015517          	auipc	a0,0x15
    8000549a:	c9250513          	addi	a0,a0,-878 # 8001a128 <disk+0x128>
    8000549e:	00001097          	auipc	ra,0x1
    800054a2:	dda080e7          	jalr	-550(ra) # 80006278 <acquire>
  for(int i = 0; i < 3; i++){
    800054a6:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800054a8:	4ba1                	li	s7,8
      disk.free[i] = 0;
    800054aa:	00015b17          	auipc	s6,0x15
    800054ae:	b56b0b13          	addi	s6,s6,-1194 # 8001a000 <disk>
  for(int i = 0; i < 3; i++){
    800054b2:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    800054b4:	8a4e                	mv	s4,s3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800054b6:	00015c17          	auipc	s8,0x15
    800054ba:	c72c0c13          	addi	s8,s8,-910 # 8001a128 <disk+0x128>
    800054be:	a8b5                	j	8000553a <virtio_disk_rw+0xd2>
      disk.free[i] = 0;
    800054c0:	00fb06b3          	add	a3,s6,a5
    800054c4:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    800054c8:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    800054ca:	0207c563          	bltz	a5,800054f4 <virtio_disk_rw+0x8c>
  for(int i = 0; i < 3; i++){
    800054ce:	2485                	addiw	s1,s1,1
    800054d0:	0711                	addi	a4,a4,4
    800054d2:	1f548a63          	beq	s1,s5,800056c6 <virtio_disk_rw+0x25e>
    idx[i] = alloc_desc();
    800054d6:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    800054d8:	00015697          	auipc	a3,0x15
    800054dc:	b2868693          	addi	a3,a3,-1240 # 8001a000 <disk>
    800054e0:	87d2                	mv	a5,s4
    if(disk.free[i]){
    800054e2:	0186c583          	lbu	a1,24(a3)
    800054e6:	fde9                	bnez	a1,800054c0 <virtio_disk_rw+0x58>
  for(int i = 0; i < NUM; i++){
    800054e8:	2785                	addiw	a5,a5,1
    800054ea:	0685                	addi	a3,a3,1
    800054ec:	ff779be3          	bne	a5,s7,800054e2 <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    800054f0:	57fd                	li	a5,-1
    800054f2:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    800054f4:	02905a63          	blez	s1,80005528 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    800054f8:	f9042503          	lw	a0,-112(s0)
    800054fc:	00000097          	auipc	ra,0x0
    80005500:	cfa080e7          	jalr	-774(ra) # 800051f6 <free_desc>
      for(int j = 0; j < i; j++)
    80005504:	4785                	li	a5,1
    80005506:	0297d163          	bge	a5,s1,80005528 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    8000550a:	f9442503          	lw	a0,-108(s0)
    8000550e:	00000097          	auipc	ra,0x0
    80005512:	ce8080e7          	jalr	-792(ra) # 800051f6 <free_desc>
      for(int j = 0; j < i; j++)
    80005516:	4789                	li	a5,2
    80005518:	0097d863          	bge	a5,s1,80005528 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    8000551c:	f9842503          	lw	a0,-104(s0)
    80005520:	00000097          	auipc	ra,0x0
    80005524:	cd6080e7          	jalr	-810(ra) # 800051f6 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005528:	85e2                	mv	a1,s8
    8000552a:	00015517          	auipc	a0,0x15
    8000552e:	aee50513          	addi	a0,a0,-1298 # 8001a018 <disk+0x18>
    80005532:	ffffc097          	auipc	ra,0xffffc
    80005536:	fd6080e7          	jalr	-42(ra) # 80001508 <sleep>
  for(int i = 0; i < 3; i++){
    8000553a:	f9040713          	addi	a4,s0,-112
    8000553e:	84ce                	mv	s1,s3
    80005540:	bf59                	j	800054d6 <virtio_disk_rw+0x6e>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    80005542:	00a60793          	addi	a5,a2,10 # 100a <_entry-0x7fffeff6>
    80005546:	00479693          	slli	a3,a5,0x4
    8000554a:	00015797          	auipc	a5,0x15
    8000554e:	ab678793          	addi	a5,a5,-1354 # 8001a000 <disk>
    80005552:	97b6                	add	a5,a5,a3
    80005554:	4685                	li	a3,1
    80005556:	c794                	sw	a3,8(a5)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005558:	00015597          	auipc	a1,0x15
    8000555c:	aa858593          	addi	a1,a1,-1368 # 8001a000 <disk>
    80005560:	00a60793          	addi	a5,a2,10
    80005564:	0792                	slli	a5,a5,0x4
    80005566:	97ae                	add	a5,a5,a1
    80005568:	0007a623          	sw	zero,12(a5)
  buf0->sector = sector;
    8000556c:	0197b823          	sd	s9,16(a5)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005570:	f6070693          	addi	a3,a4,-160
    80005574:	619c                	ld	a5,0(a1)
    80005576:	97b6                	add	a5,a5,a3
    80005578:	e388                	sd	a0,0(a5)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000557a:	6188                	ld	a0,0(a1)
    8000557c:	96aa                	add	a3,a3,a0
    8000557e:	47c1                	li	a5,16
    80005580:	c69c                	sw	a5,8(a3)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005582:	4785                	li	a5,1
    80005584:	00f69623          	sh	a5,12(a3)
  disk.desc[idx[0]].next = idx[1];
    80005588:	f9442783          	lw	a5,-108(s0)
    8000558c:	00f69723          	sh	a5,14(a3)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005590:	0792                	slli	a5,a5,0x4
    80005592:	953e                	add	a0,a0,a5
    80005594:	05890693          	addi	a3,s2,88
    80005598:	e114                	sd	a3,0(a0)
  disk.desc[idx[1]].len = BSIZE;
    8000559a:	6188                	ld	a0,0(a1)
    8000559c:	97aa                	add	a5,a5,a0
    8000559e:	40000693          	li	a3,1024
    800055a2:	c794                	sw	a3,8(a5)
  if(write)
    800055a4:	100d0d63          	beqz	s10,800056be <virtio_disk_rw+0x256>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800055a8:	00079623          	sh	zero,12(a5)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800055ac:	00c7d683          	lhu	a3,12(a5)
    800055b0:	0016e693          	ori	a3,a3,1
    800055b4:	00d79623          	sh	a3,12(a5)
  disk.desc[idx[1]].next = idx[2];
    800055b8:	f9842583          	lw	a1,-104(s0)
    800055bc:	00b79723          	sh	a1,14(a5)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800055c0:	00015697          	auipc	a3,0x15
    800055c4:	a4068693          	addi	a3,a3,-1472 # 8001a000 <disk>
    800055c8:	00260793          	addi	a5,a2,2
    800055cc:	0792                	slli	a5,a5,0x4
    800055ce:	97b6                	add	a5,a5,a3
    800055d0:	587d                	li	a6,-1
    800055d2:	01078823          	sb	a6,16(a5)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800055d6:	0592                	slli	a1,a1,0x4
    800055d8:	952e                	add	a0,a0,a1
    800055da:	f9070713          	addi	a4,a4,-112
    800055de:	9736                	add	a4,a4,a3
    800055e0:	e118                	sd	a4,0(a0)
  disk.desc[idx[2]].len = 1;
    800055e2:	6298                	ld	a4,0(a3)
    800055e4:	972e                	add	a4,a4,a1
    800055e6:	4585                	li	a1,1
    800055e8:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800055ea:	4509                	li	a0,2
    800055ec:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[2]].next = 0;
    800055f0:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800055f4:	00b92223          	sw	a1,4(s2)
  disk.info[idx[0]].b = b;
    800055f8:	0127b423          	sd	s2,8(a5)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800055fc:	6698                	ld	a4,8(a3)
    800055fe:	00275783          	lhu	a5,2(a4)
    80005602:	8b9d                	andi	a5,a5,7
    80005604:	0786                	slli	a5,a5,0x1
    80005606:	97ba                	add	a5,a5,a4
    80005608:	00c79223          	sh	a2,4(a5)

  __sync_synchronize();
    8000560c:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005610:	6698                	ld	a4,8(a3)
    80005612:	00275783          	lhu	a5,2(a4)
    80005616:	2785                	addiw	a5,a5,1
    80005618:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    8000561c:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005620:	100017b7          	lui	a5,0x10001
    80005624:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005628:	00492703          	lw	a4,4(s2)
    8000562c:	4785                	li	a5,1
    8000562e:	02f71163          	bne	a4,a5,80005650 <virtio_disk_rw+0x1e8>
    sleep(b, &disk.vdisk_lock);
    80005632:	00015997          	auipc	s3,0x15
    80005636:	af698993          	addi	s3,s3,-1290 # 8001a128 <disk+0x128>
  while(b->disk == 1) {
    8000563a:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    8000563c:	85ce                	mv	a1,s3
    8000563e:	854a                	mv	a0,s2
    80005640:	ffffc097          	auipc	ra,0xffffc
    80005644:	ec8080e7          	jalr	-312(ra) # 80001508 <sleep>
  while(b->disk == 1) {
    80005648:	00492783          	lw	a5,4(s2)
    8000564c:	fe9788e3          	beq	a5,s1,8000563c <virtio_disk_rw+0x1d4>
  }

  disk.info[idx[0]].b = 0;
    80005650:	f9042903          	lw	s2,-112(s0)
    80005654:	00290793          	addi	a5,s2,2
    80005658:	00479713          	slli	a4,a5,0x4
    8000565c:	00015797          	auipc	a5,0x15
    80005660:	9a478793          	addi	a5,a5,-1628 # 8001a000 <disk>
    80005664:	97ba                	add	a5,a5,a4
    80005666:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    8000566a:	00015997          	auipc	s3,0x15
    8000566e:	99698993          	addi	s3,s3,-1642 # 8001a000 <disk>
    80005672:	00491713          	slli	a4,s2,0x4
    80005676:	0009b783          	ld	a5,0(s3)
    8000567a:	97ba                	add	a5,a5,a4
    8000567c:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005680:	854a                	mv	a0,s2
    80005682:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005686:	00000097          	auipc	ra,0x0
    8000568a:	b70080e7          	jalr	-1168(ra) # 800051f6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000568e:	8885                	andi	s1,s1,1
    80005690:	f0ed                	bnez	s1,80005672 <virtio_disk_rw+0x20a>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005692:	00015517          	auipc	a0,0x15
    80005696:	a9650513          	addi	a0,a0,-1386 # 8001a128 <disk+0x128>
    8000569a:	00001097          	auipc	ra,0x1
    8000569e:	c92080e7          	jalr	-878(ra) # 8000632c <release>
}
    800056a2:	70a6                	ld	ra,104(sp)
    800056a4:	7406                	ld	s0,96(sp)
    800056a6:	64e6                	ld	s1,88(sp)
    800056a8:	6946                	ld	s2,80(sp)
    800056aa:	69a6                	ld	s3,72(sp)
    800056ac:	6a06                	ld	s4,64(sp)
    800056ae:	7ae2                	ld	s5,56(sp)
    800056b0:	7b42                	ld	s6,48(sp)
    800056b2:	7ba2                	ld	s7,40(sp)
    800056b4:	7c02                	ld	s8,32(sp)
    800056b6:	6ce2                	ld	s9,24(sp)
    800056b8:	6d42                	ld	s10,16(sp)
    800056ba:	6165                	addi	sp,sp,112
    800056bc:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    800056be:	4689                	li	a3,2
    800056c0:	00d79623          	sh	a3,12(a5)
    800056c4:	b5e5                	j	800055ac <virtio_disk_rw+0x144>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800056c6:	f9042603          	lw	a2,-112(s0)
    800056ca:	00a60713          	addi	a4,a2,10
    800056ce:	0712                	slli	a4,a4,0x4
    800056d0:	00015517          	auipc	a0,0x15
    800056d4:	93850513          	addi	a0,a0,-1736 # 8001a008 <disk+0x8>
    800056d8:	953a                	add	a0,a0,a4
  if(write)
    800056da:	e60d14e3          	bnez	s10,80005542 <virtio_disk_rw+0xda>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    800056de:	00a60793          	addi	a5,a2,10
    800056e2:	00479693          	slli	a3,a5,0x4
    800056e6:	00015797          	auipc	a5,0x15
    800056ea:	91a78793          	addi	a5,a5,-1766 # 8001a000 <disk>
    800056ee:	97b6                	add	a5,a5,a3
    800056f0:	0007a423          	sw	zero,8(a5)
    800056f4:	b595                	j	80005558 <virtio_disk_rw+0xf0>

00000000800056f6 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800056f6:	1101                	addi	sp,sp,-32
    800056f8:	ec06                	sd	ra,24(sp)
    800056fa:	e822                	sd	s0,16(sp)
    800056fc:	e426                	sd	s1,8(sp)
    800056fe:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005700:	00015497          	auipc	s1,0x15
    80005704:	90048493          	addi	s1,s1,-1792 # 8001a000 <disk>
    80005708:	00015517          	auipc	a0,0x15
    8000570c:	a2050513          	addi	a0,a0,-1504 # 8001a128 <disk+0x128>
    80005710:	00001097          	auipc	ra,0x1
    80005714:	b68080e7          	jalr	-1176(ra) # 80006278 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005718:	10001737          	lui	a4,0x10001
    8000571c:	533c                	lw	a5,96(a4)
    8000571e:	8b8d                	andi	a5,a5,3
    80005720:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005722:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005726:	689c                	ld	a5,16(s1)
    80005728:	0204d703          	lhu	a4,32(s1)
    8000572c:	0027d783          	lhu	a5,2(a5)
    80005730:	04f70863          	beq	a4,a5,80005780 <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80005734:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005738:	6898                	ld	a4,16(s1)
    8000573a:	0204d783          	lhu	a5,32(s1)
    8000573e:	8b9d                	andi	a5,a5,7
    80005740:	078e                	slli	a5,a5,0x3
    80005742:	97ba                	add	a5,a5,a4
    80005744:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005746:	00278713          	addi	a4,a5,2
    8000574a:	0712                	slli	a4,a4,0x4
    8000574c:	9726                	add	a4,a4,s1
    8000574e:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80005752:	e721                	bnez	a4,8000579a <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005754:	0789                	addi	a5,a5,2
    80005756:	0792                	slli	a5,a5,0x4
    80005758:	97a6                	add	a5,a5,s1
    8000575a:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    8000575c:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005760:	ffffc097          	auipc	ra,0xffffc
    80005764:	e0c080e7          	jalr	-500(ra) # 8000156c <wakeup>

    disk.used_idx += 1;
    80005768:	0204d783          	lhu	a5,32(s1)
    8000576c:	2785                	addiw	a5,a5,1
    8000576e:	17c2                	slli	a5,a5,0x30
    80005770:	93c1                	srli	a5,a5,0x30
    80005772:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005776:	6898                	ld	a4,16(s1)
    80005778:	00275703          	lhu	a4,2(a4)
    8000577c:	faf71ce3          	bne	a4,a5,80005734 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005780:	00015517          	auipc	a0,0x15
    80005784:	9a850513          	addi	a0,a0,-1624 # 8001a128 <disk+0x128>
    80005788:	00001097          	auipc	ra,0x1
    8000578c:	ba4080e7          	jalr	-1116(ra) # 8000632c <release>
}
    80005790:	60e2                	ld	ra,24(sp)
    80005792:	6442                	ld	s0,16(sp)
    80005794:	64a2                	ld	s1,8(sp)
    80005796:	6105                	addi	sp,sp,32
    80005798:	8082                	ret
      panic("virtio_disk_intr status");
    8000579a:	00003517          	auipc	a0,0x3
    8000579e:	01e50513          	addi	a0,a0,30 # 800087b8 <syscalls+0x3e8>
    800057a2:	00000097          	auipc	ra,0x0
    800057a6:	530080e7          	jalr	1328(ra) # 80005cd2 <panic>

00000000800057aa <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    800057aa:	1141                	addi	sp,sp,-16
    800057ac:	e422                	sd	s0,8(sp)
    800057ae:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800057b0:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    800057b4:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    800057b8:	0037979b          	slliw	a5,a5,0x3
    800057bc:	02004737          	lui	a4,0x2004
    800057c0:	97ba                	add	a5,a5,a4
    800057c2:	0200c737          	lui	a4,0x200c
    800057c6:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    800057ca:	000f4637          	lui	a2,0xf4
    800057ce:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    800057d2:	95b2                	add	a1,a1,a2
    800057d4:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    800057d6:	00269713          	slli	a4,a3,0x2
    800057da:	9736                	add	a4,a4,a3
    800057dc:	00371693          	slli	a3,a4,0x3
    800057e0:	00015717          	auipc	a4,0x15
    800057e4:	96070713          	addi	a4,a4,-1696 # 8001a140 <timer_scratch>
    800057e8:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    800057ea:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    800057ec:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    800057ee:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    800057f2:	00000797          	auipc	a5,0x0
    800057f6:	93e78793          	addi	a5,a5,-1730 # 80005130 <timervec>
    800057fa:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800057fe:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005802:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005806:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    8000580a:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000580e:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005812:	30479073          	csrw	mie,a5
}
    80005816:	6422                	ld	s0,8(sp)
    80005818:	0141                	addi	sp,sp,16
    8000581a:	8082                	ret

000000008000581c <start>:
{
    8000581c:	1141                	addi	sp,sp,-16
    8000581e:	e406                	sd	ra,8(sp)
    80005820:	e022                	sd	s0,0(sp)
    80005822:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005824:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005828:	7779                	lui	a4,0xffffe
    8000582a:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdc47f>
    8000582e:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005830:	6705                	lui	a4,0x1
    80005832:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005836:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005838:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    8000583c:	ffffb797          	auipc	a5,0xffffb
    80005840:	aea78793          	addi	a5,a5,-1302 # 80000326 <main>
    80005844:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005848:	4781                	li	a5,0
    8000584a:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    8000584e:	67c1                	lui	a5,0x10
    80005850:	17fd                	addi	a5,a5,-1
    80005852:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005856:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    8000585a:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    8000585e:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005862:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005866:	57fd                	li	a5,-1
    80005868:	83a9                	srli	a5,a5,0xa
    8000586a:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    8000586e:	47bd                	li	a5,15
    80005870:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005874:	00000097          	auipc	ra,0x0
    80005878:	f36080e7          	jalr	-202(ra) # 800057aa <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000587c:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005880:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005882:	823e                	mv	tp,a5
  asm volatile("mret");
    80005884:	30200073          	mret
}
    80005888:	60a2                	ld	ra,8(sp)
    8000588a:	6402                	ld	s0,0(sp)
    8000588c:	0141                	addi	sp,sp,16
    8000588e:	8082                	ret

0000000080005890 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005890:	715d                	addi	sp,sp,-80
    80005892:	e486                	sd	ra,72(sp)
    80005894:	e0a2                	sd	s0,64(sp)
    80005896:	fc26                	sd	s1,56(sp)
    80005898:	f84a                	sd	s2,48(sp)
    8000589a:	f44e                	sd	s3,40(sp)
    8000589c:	f052                	sd	s4,32(sp)
    8000589e:	ec56                	sd	s5,24(sp)
    800058a0:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    800058a2:	04c05663          	blez	a2,800058ee <consolewrite+0x5e>
    800058a6:	8a2a                	mv	s4,a0
    800058a8:	84ae                	mv	s1,a1
    800058aa:	89b2                	mv	s3,a2
    800058ac:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    800058ae:	5afd                	li	s5,-1
    800058b0:	4685                	li	a3,1
    800058b2:	8626                	mv	a2,s1
    800058b4:	85d2                	mv	a1,s4
    800058b6:	fbf40513          	addi	a0,s0,-65
    800058ba:	ffffc097          	auipc	ra,0xffffc
    800058be:	0ac080e7          	jalr	172(ra) # 80001966 <either_copyin>
    800058c2:	01550c63          	beq	a0,s5,800058da <consolewrite+0x4a>
      break;
    uartputc(c);
    800058c6:	fbf44503          	lbu	a0,-65(s0)
    800058ca:	00000097          	auipc	ra,0x0
    800058ce:	7f0080e7          	jalr	2032(ra) # 800060ba <uartputc>
  for(i = 0; i < n; i++){
    800058d2:	2905                	addiw	s2,s2,1
    800058d4:	0485                	addi	s1,s1,1
    800058d6:	fd299de3          	bne	s3,s2,800058b0 <consolewrite+0x20>
  }

  return i;
}
    800058da:	854a                	mv	a0,s2
    800058dc:	60a6                	ld	ra,72(sp)
    800058de:	6406                	ld	s0,64(sp)
    800058e0:	74e2                	ld	s1,56(sp)
    800058e2:	7942                	ld	s2,48(sp)
    800058e4:	79a2                	ld	s3,40(sp)
    800058e6:	7a02                	ld	s4,32(sp)
    800058e8:	6ae2                	ld	s5,24(sp)
    800058ea:	6161                	addi	sp,sp,80
    800058ec:	8082                	ret
  for(i = 0; i < n; i++){
    800058ee:	4901                	li	s2,0
    800058f0:	b7ed                	j	800058da <consolewrite+0x4a>

00000000800058f2 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    800058f2:	7119                	addi	sp,sp,-128
    800058f4:	fc86                	sd	ra,120(sp)
    800058f6:	f8a2                	sd	s0,112(sp)
    800058f8:	f4a6                	sd	s1,104(sp)
    800058fa:	f0ca                	sd	s2,96(sp)
    800058fc:	ecce                	sd	s3,88(sp)
    800058fe:	e8d2                	sd	s4,80(sp)
    80005900:	e4d6                	sd	s5,72(sp)
    80005902:	e0da                	sd	s6,64(sp)
    80005904:	fc5e                	sd	s7,56(sp)
    80005906:	f862                	sd	s8,48(sp)
    80005908:	f466                	sd	s9,40(sp)
    8000590a:	f06a                	sd	s10,32(sp)
    8000590c:	ec6e                	sd	s11,24(sp)
    8000590e:	0100                	addi	s0,sp,128
    80005910:	8b2a                	mv	s6,a0
    80005912:	8aae                	mv	s5,a1
    80005914:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005916:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    8000591a:	0001d517          	auipc	a0,0x1d
    8000591e:	96650513          	addi	a0,a0,-1690 # 80022280 <cons>
    80005922:	00001097          	auipc	ra,0x1
    80005926:	956080e7          	jalr	-1706(ra) # 80006278 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000592a:	0001d497          	auipc	s1,0x1d
    8000592e:	95648493          	addi	s1,s1,-1706 # 80022280 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005932:	89a6                	mv	s3,s1
    80005934:	0001d917          	auipc	s2,0x1d
    80005938:	9e490913          	addi	s2,s2,-1564 # 80022318 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    8000593c:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    8000593e:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005940:	4da9                	li	s11,10
  while(n > 0){
    80005942:	07405b63          	blez	s4,800059b8 <consoleread+0xc6>
    while(cons.r == cons.w){
    80005946:	0984a783          	lw	a5,152(s1)
    8000594a:	09c4a703          	lw	a4,156(s1)
    8000594e:	02f71763          	bne	a4,a5,8000597c <consoleread+0x8a>
      if(killed(myproc())){
    80005952:	ffffb097          	auipc	ra,0xffffb
    80005956:	506080e7          	jalr	1286(ra) # 80000e58 <myproc>
    8000595a:	ffffc097          	auipc	ra,0xffffc
    8000595e:	e56080e7          	jalr	-426(ra) # 800017b0 <killed>
    80005962:	e535                	bnez	a0,800059ce <consoleread+0xdc>
      sleep(&cons.r, &cons.lock);
    80005964:	85ce                	mv	a1,s3
    80005966:	854a                	mv	a0,s2
    80005968:	ffffc097          	auipc	ra,0xffffc
    8000596c:	ba0080e7          	jalr	-1120(ra) # 80001508 <sleep>
    while(cons.r == cons.w){
    80005970:	0984a783          	lw	a5,152(s1)
    80005974:	09c4a703          	lw	a4,156(s1)
    80005978:	fcf70de3          	beq	a4,a5,80005952 <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    8000597c:	0017871b          	addiw	a4,a5,1
    80005980:	08e4ac23          	sw	a4,152(s1)
    80005984:	07f7f713          	andi	a4,a5,127
    80005988:	9726                	add	a4,a4,s1
    8000598a:	01874703          	lbu	a4,24(a4)
    8000598e:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80005992:	079c0663          	beq	s8,s9,800059fe <consoleread+0x10c>
    cbuf = c;
    80005996:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    8000599a:	4685                	li	a3,1
    8000599c:	f8f40613          	addi	a2,s0,-113
    800059a0:	85d6                	mv	a1,s5
    800059a2:	855a                	mv	a0,s6
    800059a4:	ffffc097          	auipc	ra,0xffffc
    800059a8:	f6c080e7          	jalr	-148(ra) # 80001910 <either_copyout>
    800059ac:	01a50663          	beq	a0,s10,800059b8 <consoleread+0xc6>
    dst++;
    800059b0:	0a85                	addi	s5,s5,1
    --n;
    800059b2:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    800059b4:	f9bc17e3          	bne	s8,s11,80005942 <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    800059b8:	0001d517          	auipc	a0,0x1d
    800059bc:	8c850513          	addi	a0,a0,-1848 # 80022280 <cons>
    800059c0:	00001097          	auipc	ra,0x1
    800059c4:	96c080e7          	jalr	-1684(ra) # 8000632c <release>

  return target - n;
    800059c8:	414b853b          	subw	a0,s7,s4
    800059cc:	a811                	j	800059e0 <consoleread+0xee>
        release(&cons.lock);
    800059ce:	0001d517          	auipc	a0,0x1d
    800059d2:	8b250513          	addi	a0,a0,-1870 # 80022280 <cons>
    800059d6:	00001097          	auipc	ra,0x1
    800059da:	956080e7          	jalr	-1706(ra) # 8000632c <release>
        return -1;
    800059de:	557d                	li	a0,-1
}
    800059e0:	70e6                	ld	ra,120(sp)
    800059e2:	7446                	ld	s0,112(sp)
    800059e4:	74a6                	ld	s1,104(sp)
    800059e6:	7906                	ld	s2,96(sp)
    800059e8:	69e6                	ld	s3,88(sp)
    800059ea:	6a46                	ld	s4,80(sp)
    800059ec:	6aa6                	ld	s5,72(sp)
    800059ee:	6b06                	ld	s6,64(sp)
    800059f0:	7be2                	ld	s7,56(sp)
    800059f2:	7c42                	ld	s8,48(sp)
    800059f4:	7ca2                	ld	s9,40(sp)
    800059f6:	7d02                	ld	s10,32(sp)
    800059f8:	6de2                	ld	s11,24(sp)
    800059fa:	6109                	addi	sp,sp,128
    800059fc:	8082                	ret
      if(n < target){
    800059fe:	000a071b          	sext.w	a4,s4
    80005a02:	fb777be3          	bgeu	a4,s7,800059b8 <consoleread+0xc6>
        cons.r--;
    80005a06:	0001d717          	auipc	a4,0x1d
    80005a0a:	90f72923          	sw	a5,-1774(a4) # 80022318 <cons+0x98>
    80005a0e:	b76d                	j	800059b8 <consoleread+0xc6>

0000000080005a10 <consputc>:
{
    80005a10:	1141                	addi	sp,sp,-16
    80005a12:	e406                	sd	ra,8(sp)
    80005a14:	e022                	sd	s0,0(sp)
    80005a16:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005a18:	10000793          	li	a5,256
    80005a1c:	00f50a63          	beq	a0,a5,80005a30 <consputc+0x20>
    uartputc_sync(c);
    80005a20:	00000097          	auipc	ra,0x0
    80005a24:	5c0080e7          	jalr	1472(ra) # 80005fe0 <uartputc_sync>
}
    80005a28:	60a2                	ld	ra,8(sp)
    80005a2a:	6402                	ld	s0,0(sp)
    80005a2c:	0141                	addi	sp,sp,16
    80005a2e:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005a30:	4521                	li	a0,8
    80005a32:	00000097          	auipc	ra,0x0
    80005a36:	5ae080e7          	jalr	1454(ra) # 80005fe0 <uartputc_sync>
    80005a3a:	02000513          	li	a0,32
    80005a3e:	00000097          	auipc	ra,0x0
    80005a42:	5a2080e7          	jalr	1442(ra) # 80005fe0 <uartputc_sync>
    80005a46:	4521                	li	a0,8
    80005a48:	00000097          	auipc	ra,0x0
    80005a4c:	598080e7          	jalr	1432(ra) # 80005fe0 <uartputc_sync>
    80005a50:	bfe1                	j	80005a28 <consputc+0x18>

0000000080005a52 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005a52:	1101                	addi	sp,sp,-32
    80005a54:	ec06                	sd	ra,24(sp)
    80005a56:	e822                	sd	s0,16(sp)
    80005a58:	e426                	sd	s1,8(sp)
    80005a5a:	e04a                	sd	s2,0(sp)
    80005a5c:	1000                	addi	s0,sp,32
    80005a5e:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005a60:	0001d517          	auipc	a0,0x1d
    80005a64:	82050513          	addi	a0,a0,-2016 # 80022280 <cons>
    80005a68:	00001097          	auipc	ra,0x1
    80005a6c:	810080e7          	jalr	-2032(ra) # 80006278 <acquire>

  switch(c){
    80005a70:	47d5                	li	a5,21
    80005a72:	0af48663          	beq	s1,a5,80005b1e <consoleintr+0xcc>
    80005a76:	0297ca63          	blt	a5,s1,80005aaa <consoleintr+0x58>
    80005a7a:	47a1                	li	a5,8
    80005a7c:	0ef48763          	beq	s1,a5,80005b6a <consoleintr+0x118>
    80005a80:	47c1                	li	a5,16
    80005a82:	10f49a63          	bne	s1,a5,80005b96 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005a86:	ffffc097          	auipc	ra,0xffffc
    80005a8a:	f36080e7          	jalr	-202(ra) # 800019bc <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005a8e:	0001c517          	auipc	a0,0x1c
    80005a92:	7f250513          	addi	a0,a0,2034 # 80022280 <cons>
    80005a96:	00001097          	auipc	ra,0x1
    80005a9a:	896080e7          	jalr	-1898(ra) # 8000632c <release>
}
    80005a9e:	60e2                	ld	ra,24(sp)
    80005aa0:	6442                	ld	s0,16(sp)
    80005aa2:	64a2                	ld	s1,8(sp)
    80005aa4:	6902                	ld	s2,0(sp)
    80005aa6:	6105                	addi	sp,sp,32
    80005aa8:	8082                	ret
  switch(c){
    80005aaa:	07f00793          	li	a5,127
    80005aae:	0af48e63          	beq	s1,a5,80005b6a <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005ab2:	0001c717          	auipc	a4,0x1c
    80005ab6:	7ce70713          	addi	a4,a4,1998 # 80022280 <cons>
    80005aba:	0a072783          	lw	a5,160(a4)
    80005abe:	09872703          	lw	a4,152(a4)
    80005ac2:	9f99                	subw	a5,a5,a4
    80005ac4:	07f00713          	li	a4,127
    80005ac8:	fcf763e3          	bltu	a4,a5,80005a8e <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005acc:	47b5                	li	a5,13
    80005ace:	0cf48763          	beq	s1,a5,80005b9c <consoleintr+0x14a>
      consputc(c);
    80005ad2:	8526                	mv	a0,s1
    80005ad4:	00000097          	auipc	ra,0x0
    80005ad8:	f3c080e7          	jalr	-196(ra) # 80005a10 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005adc:	0001c797          	auipc	a5,0x1c
    80005ae0:	7a478793          	addi	a5,a5,1956 # 80022280 <cons>
    80005ae4:	0a07a683          	lw	a3,160(a5)
    80005ae8:	0016871b          	addiw	a4,a3,1
    80005aec:	0007061b          	sext.w	a2,a4
    80005af0:	0ae7a023          	sw	a4,160(a5)
    80005af4:	07f6f693          	andi	a3,a3,127
    80005af8:	97b6                	add	a5,a5,a3
    80005afa:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005afe:	47a9                	li	a5,10
    80005b00:	0cf48563          	beq	s1,a5,80005bca <consoleintr+0x178>
    80005b04:	4791                	li	a5,4
    80005b06:	0cf48263          	beq	s1,a5,80005bca <consoleintr+0x178>
    80005b0a:	0001d797          	auipc	a5,0x1d
    80005b0e:	80e7a783          	lw	a5,-2034(a5) # 80022318 <cons+0x98>
    80005b12:	9f1d                	subw	a4,a4,a5
    80005b14:	08000793          	li	a5,128
    80005b18:	f6f71be3          	bne	a4,a5,80005a8e <consoleintr+0x3c>
    80005b1c:	a07d                	j	80005bca <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005b1e:	0001c717          	auipc	a4,0x1c
    80005b22:	76270713          	addi	a4,a4,1890 # 80022280 <cons>
    80005b26:	0a072783          	lw	a5,160(a4)
    80005b2a:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005b2e:	0001c497          	auipc	s1,0x1c
    80005b32:	75248493          	addi	s1,s1,1874 # 80022280 <cons>
    while(cons.e != cons.w &&
    80005b36:	4929                	li	s2,10
    80005b38:	f4f70be3          	beq	a4,a5,80005a8e <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005b3c:	37fd                	addiw	a5,a5,-1
    80005b3e:	07f7f713          	andi	a4,a5,127
    80005b42:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005b44:	01874703          	lbu	a4,24(a4)
    80005b48:	f52703e3          	beq	a4,s2,80005a8e <consoleintr+0x3c>
      cons.e--;
    80005b4c:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005b50:	10000513          	li	a0,256
    80005b54:	00000097          	auipc	ra,0x0
    80005b58:	ebc080e7          	jalr	-324(ra) # 80005a10 <consputc>
    while(cons.e != cons.w &&
    80005b5c:	0a04a783          	lw	a5,160(s1)
    80005b60:	09c4a703          	lw	a4,156(s1)
    80005b64:	fcf71ce3          	bne	a4,a5,80005b3c <consoleintr+0xea>
    80005b68:	b71d                	j	80005a8e <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005b6a:	0001c717          	auipc	a4,0x1c
    80005b6e:	71670713          	addi	a4,a4,1814 # 80022280 <cons>
    80005b72:	0a072783          	lw	a5,160(a4)
    80005b76:	09c72703          	lw	a4,156(a4)
    80005b7a:	f0f70ae3          	beq	a4,a5,80005a8e <consoleintr+0x3c>
      cons.e--;
    80005b7e:	37fd                	addiw	a5,a5,-1
    80005b80:	0001c717          	auipc	a4,0x1c
    80005b84:	7af72023          	sw	a5,1952(a4) # 80022320 <cons+0xa0>
      consputc(BACKSPACE);
    80005b88:	10000513          	li	a0,256
    80005b8c:	00000097          	auipc	ra,0x0
    80005b90:	e84080e7          	jalr	-380(ra) # 80005a10 <consputc>
    80005b94:	bded                	j	80005a8e <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005b96:	ee048ce3          	beqz	s1,80005a8e <consoleintr+0x3c>
    80005b9a:	bf21                	j	80005ab2 <consoleintr+0x60>
      consputc(c);
    80005b9c:	4529                	li	a0,10
    80005b9e:	00000097          	auipc	ra,0x0
    80005ba2:	e72080e7          	jalr	-398(ra) # 80005a10 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005ba6:	0001c797          	auipc	a5,0x1c
    80005baa:	6da78793          	addi	a5,a5,1754 # 80022280 <cons>
    80005bae:	0a07a703          	lw	a4,160(a5)
    80005bb2:	0017069b          	addiw	a3,a4,1
    80005bb6:	0006861b          	sext.w	a2,a3
    80005bba:	0ad7a023          	sw	a3,160(a5)
    80005bbe:	07f77713          	andi	a4,a4,127
    80005bc2:	97ba                	add	a5,a5,a4
    80005bc4:	4729                	li	a4,10
    80005bc6:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005bca:	0001c797          	auipc	a5,0x1c
    80005bce:	74c7a923          	sw	a2,1874(a5) # 8002231c <cons+0x9c>
        wakeup(&cons.r);
    80005bd2:	0001c517          	auipc	a0,0x1c
    80005bd6:	74650513          	addi	a0,a0,1862 # 80022318 <cons+0x98>
    80005bda:	ffffc097          	auipc	ra,0xffffc
    80005bde:	992080e7          	jalr	-1646(ra) # 8000156c <wakeup>
    80005be2:	b575                	j	80005a8e <consoleintr+0x3c>

0000000080005be4 <consoleinit>:

void
consoleinit(void)
{
    80005be4:	1141                	addi	sp,sp,-16
    80005be6:	e406                	sd	ra,8(sp)
    80005be8:	e022                	sd	s0,0(sp)
    80005bea:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005bec:	00003597          	auipc	a1,0x3
    80005bf0:	be458593          	addi	a1,a1,-1052 # 800087d0 <syscalls+0x400>
    80005bf4:	0001c517          	auipc	a0,0x1c
    80005bf8:	68c50513          	addi	a0,a0,1676 # 80022280 <cons>
    80005bfc:	00000097          	auipc	ra,0x0
    80005c00:	5ec080e7          	jalr	1516(ra) # 800061e8 <initlock>

  uartinit();
    80005c04:	00000097          	auipc	ra,0x0
    80005c08:	38c080e7          	jalr	908(ra) # 80005f90 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005c0c:	00013797          	auipc	a5,0x13
    80005c10:	39c78793          	addi	a5,a5,924 # 80018fa8 <devsw>
    80005c14:	00000717          	auipc	a4,0x0
    80005c18:	cde70713          	addi	a4,a4,-802 # 800058f2 <consoleread>
    80005c1c:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005c1e:	00000717          	auipc	a4,0x0
    80005c22:	c7270713          	addi	a4,a4,-910 # 80005890 <consolewrite>
    80005c26:	ef98                	sd	a4,24(a5)
}
    80005c28:	60a2                	ld	ra,8(sp)
    80005c2a:	6402                	ld	s0,0(sp)
    80005c2c:	0141                	addi	sp,sp,16
    80005c2e:	8082                	ret

0000000080005c30 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005c30:	7179                	addi	sp,sp,-48
    80005c32:	f406                	sd	ra,40(sp)
    80005c34:	f022                	sd	s0,32(sp)
    80005c36:	ec26                	sd	s1,24(sp)
    80005c38:	e84a                	sd	s2,16(sp)
    80005c3a:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005c3c:	c219                	beqz	a2,80005c42 <printint+0x12>
    80005c3e:	08054663          	bltz	a0,80005cca <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005c42:	2501                	sext.w	a0,a0
    80005c44:	4881                	li	a7,0
    80005c46:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005c4a:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005c4c:	2581                	sext.w	a1,a1
    80005c4e:	00003617          	auipc	a2,0x3
    80005c52:	bca60613          	addi	a2,a2,-1078 # 80008818 <digits>
    80005c56:	883a                	mv	a6,a4
    80005c58:	2705                	addiw	a4,a4,1
    80005c5a:	02b577bb          	remuw	a5,a0,a1
    80005c5e:	1782                	slli	a5,a5,0x20
    80005c60:	9381                	srli	a5,a5,0x20
    80005c62:	97b2                	add	a5,a5,a2
    80005c64:	0007c783          	lbu	a5,0(a5)
    80005c68:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005c6c:	0005079b          	sext.w	a5,a0
    80005c70:	02b5553b          	divuw	a0,a0,a1
    80005c74:	0685                	addi	a3,a3,1
    80005c76:	feb7f0e3          	bgeu	a5,a1,80005c56 <printint+0x26>

  if(sign)
    80005c7a:	00088b63          	beqz	a7,80005c90 <printint+0x60>
    buf[i++] = '-';
    80005c7e:	fe040793          	addi	a5,s0,-32
    80005c82:	973e                	add	a4,a4,a5
    80005c84:	02d00793          	li	a5,45
    80005c88:	fef70823          	sb	a5,-16(a4)
    80005c8c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005c90:	02e05763          	blez	a4,80005cbe <printint+0x8e>
    80005c94:	fd040793          	addi	a5,s0,-48
    80005c98:	00e784b3          	add	s1,a5,a4
    80005c9c:	fff78913          	addi	s2,a5,-1
    80005ca0:	993a                	add	s2,s2,a4
    80005ca2:	377d                	addiw	a4,a4,-1
    80005ca4:	1702                	slli	a4,a4,0x20
    80005ca6:	9301                	srli	a4,a4,0x20
    80005ca8:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005cac:	fff4c503          	lbu	a0,-1(s1)
    80005cb0:	00000097          	auipc	ra,0x0
    80005cb4:	d60080e7          	jalr	-672(ra) # 80005a10 <consputc>
  while(--i >= 0)
    80005cb8:	14fd                	addi	s1,s1,-1
    80005cba:	ff2499e3          	bne	s1,s2,80005cac <printint+0x7c>
}
    80005cbe:	70a2                	ld	ra,40(sp)
    80005cc0:	7402                	ld	s0,32(sp)
    80005cc2:	64e2                	ld	s1,24(sp)
    80005cc4:	6942                	ld	s2,16(sp)
    80005cc6:	6145                	addi	sp,sp,48
    80005cc8:	8082                	ret
    x = -xx;
    80005cca:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005cce:	4885                	li	a7,1
    x = -xx;
    80005cd0:	bf9d                	j	80005c46 <printint+0x16>

0000000080005cd2 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005cd2:	1101                	addi	sp,sp,-32
    80005cd4:	ec06                	sd	ra,24(sp)
    80005cd6:	e822                	sd	s0,16(sp)
    80005cd8:	e426                	sd	s1,8(sp)
    80005cda:	1000                	addi	s0,sp,32
    80005cdc:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005cde:	0001c797          	auipc	a5,0x1c
    80005ce2:	6607a123          	sw	zero,1634(a5) # 80022340 <pr+0x18>
  printf("panic: ");
    80005ce6:	00003517          	auipc	a0,0x3
    80005cea:	af250513          	addi	a0,a0,-1294 # 800087d8 <syscalls+0x408>
    80005cee:	00000097          	auipc	ra,0x0
    80005cf2:	02e080e7          	jalr	46(ra) # 80005d1c <printf>
  printf(s);
    80005cf6:	8526                	mv	a0,s1
    80005cf8:	00000097          	auipc	ra,0x0
    80005cfc:	024080e7          	jalr	36(ra) # 80005d1c <printf>
  printf("\n");
    80005d00:	00002517          	auipc	a0,0x2
    80005d04:	34850513          	addi	a0,a0,840 # 80008048 <etext+0x48>
    80005d08:	00000097          	auipc	ra,0x0
    80005d0c:	014080e7          	jalr	20(ra) # 80005d1c <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005d10:	4785                	li	a5,1
    80005d12:	00003717          	auipc	a4,0x3
    80005d16:	bef72523          	sw	a5,-1046(a4) # 800088fc <panicked>
  for(;;)
    80005d1a:	a001                	j	80005d1a <panic+0x48>

0000000080005d1c <printf>:
{
    80005d1c:	7131                	addi	sp,sp,-192
    80005d1e:	fc86                	sd	ra,120(sp)
    80005d20:	f8a2                	sd	s0,112(sp)
    80005d22:	f4a6                	sd	s1,104(sp)
    80005d24:	f0ca                	sd	s2,96(sp)
    80005d26:	ecce                	sd	s3,88(sp)
    80005d28:	e8d2                	sd	s4,80(sp)
    80005d2a:	e4d6                	sd	s5,72(sp)
    80005d2c:	e0da                	sd	s6,64(sp)
    80005d2e:	fc5e                	sd	s7,56(sp)
    80005d30:	f862                	sd	s8,48(sp)
    80005d32:	f466                	sd	s9,40(sp)
    80005d34:	f06a                	sd	s10,32(sp)
    80005d36:	ec6e                	sd	s11,24(sp)
    80005d38:	0100                	addi	s0,sp,128
    80005d3a:	8a2a                	mv	s4,a0
    80005d3c:	e40c                	sd	a1,8(s0)
    80005d3e:	e810                	sd	a2,16(s0)
    80005d40:	ec14                	sd	a3,24(s0)
    80005d42:	f018                	sd	a4,32(s0)
    80005d44:	f41c                	sd	a5,40(s0)
    80005d46:	03043823          	sd	a6,48(s0)
    80005d4a:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005d4e:	0001cd97          	auipc	s11,0x1c
    80005d52:	5f2dad83          	lw	s11,1522(s11) # 80022340 <pr+0x18>
  if(locking)
    80005d56:	020d9b63          	bnez	s11,80005d8c <printf+0x70>
  if (fmt == 0)
    80005d5a:	040a0263          	beqz	s4,80005d9e <printf+0x82>
  va_start(ap, fmt);
    80005d5e:	00840793          	addi	a5,s0,8
    80005d62:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005d66:	000a4503          	lbu	a0,0(s4)
    80005d6a:	16050263          	beqz	a0,80005ece <printf+0x1b2>
    80005d6e:	4481                	li	s1,0
    if(c != '%'){
    80005d70:	02500a93          	li	s5,37
    switch(c){
    80005d74:	07000b13          	li	s6,112
  consputc('x');
    80005d78:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005d7a:	00003b97          	auipc	s7,0x3
    80005d7e:	a9eb8b93          	addi	s7,s7,-1378 # 80008818 <digits>
    switch(c){
    80005d82:	07300c93          	li	s9,115
    80005d86:	06400c13          	li	s8,100
    80005d8a:	a82d                	j	80005dc4 <printf+0xa8>
    acquire(&pr.lock);
    80005d8c:	0001c517          	auipc	a0,0x1c
    80005d90:	59c50513          	addi	a0,a0,1436 # 80022328 <pr>
    80005d94:	00000097          	auipc	ra,0x0
    80005d98:	4e4080e7          	jalr	1252(ra) # 80006278 <acquire>
    80005d9c:	bf7d                	j	80005d5a <printf+0x3e>
    panic("null fmt");
    80005d9e:	00003517          	auipc	a0,0x3
    80005da2:	a4a50513          	addi	a0,a0,-1462 # 800087e8 <syscalls+0x418>
    80005da6:	00000097          	auipc	ra,0x0
    80005daa:	f2c080e7          	jalr	-212(ra) # 80005cd2 <panic>
      consputc(c);
    80005dae:	00000097          	auipc	ra,0x0
    80005db2:	c62080e7          	jalr	-926(ra) # 80005a10 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005db6:	2485                	addiw	s1,s1,1
    80005db8:	009a07b3          	add	a5,s4,s1
    80005dbc:	0007c503          	lbu	a0,0(a5)
    80005dc0:	10050763          	beqz	a0,80005ece <printf+0x1b2>
    if(c != '%'){
    80005dc4:	ff5515e3          	bne	a0,s5,80005dae <printf+0x92>
    c = fmt[++i] & 0xff;
    80005dc8:	2485                	addiw	s1,s1,1
    80005dca:	009a07b3          	add	a5,s4,s1
    80005dce:	0007c783          	lbu	a5,0(a5)
    80005dd2:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80005dd6:	cfe5                	beqz	a5,80005ece <printf+0x1b2>
    switch(c){
    80005dd8:	05678a63          	beq	a5,s6,80005e2c <printf+0x110>
    80005ddc:	02fb7663          	bgeu	s6,a5,80005e08 <printf+0xec>
    80005de0:	09978963          	beq	a5,s9,80005e72 <printf+0x156>
    80005de4:	07800713          	li	a4,120
    80005de8:	0ce79863          	bne	a5,a4,80005eb8 <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80005dec:	f8843783          	ld	a5,-120(s0)
    80005df0:	00878713          	addi	a4,a5,8
    80005df4:	f8e43423          	sd	a4,-120(s0)
    80005df8:	4605                	li	a2,1
    80005dfa:	85ea                	mv	a1,s10
    80005dfc:	4388                	lw	a0,0(a5)
    80005dfe:	00000097          	auipc	ra,0x0
    80005e02:	e32080e7          	jalr	-462(ra) # 80005c30 <printint>
      break;
    80005e06:	bf45                	j	80005db6 <printf+0x9a>
    switch(c){
    80005e08:	0b578263          	beq	a5,s5,80005eac <printf+0x190>
    80005e0c:	0b879663          	bne	a5,s8,80005eb8 <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80005e10:	f8843783          	ld	a5,-120(s0)
    80005e14:	00878713          	addi	a4,a5,8
    80005e18:	f8e43423          	sd	a4,-120(s0)
    80005e1c:	4605                	li	a2,1
    80005e1e:	45a9                	li	a1,10
    80005e20:	4388                	lw	a0,0(a5)
    80005e22:	00000097          	auipc	ra,0x0
    80005e26:	e0e080e7          	jalr	-498(ra) # 80005c30 <printint>
      break;
    80005e2a:	b771                	j	80005db6 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005e2c:	f8843783          	ld	a5,-120(s0)
    80005e30:	00878713          	addi	a4,a5,8
    80005e34:	f8e43423          	sd	a4,-120(s0)
    80005e38:	0007b983          	ld	s3,0(a5)
  consputc('0');
    80005e3c:	03000513          	li	a0,48
    80005e40:	00000097          	auipc	ra,0x0
    80005e44:	bd0080e7          	jalr	-1072(ra) # 80005a10 <consputc>
  consputc('x');
    80005e48:	07800513          	li	a0,120
    80005e4c:	00000097          	auipc	ra,0x0
    80005e50:	bc4080e7          	jalr	-1084(ra) # 80005a10 <consputc>
    80005e54:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005e56:	03c9d793          	srli	a5,s3,0x3c
    80005e5a:	97de                	add	a5,a5,s7
    80005e5c:	0007c503          	lbu	a0,0(a5)
    80005e60:	00000097          	auipc	ra,0x0
    80005e64:	bb0080e7          	jalr	-1104(ra) # 80005a10 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005e68:	0992                	slli	s3,s3,0x4
    80005e6a:	397d                	addiw	s2,s2,-1
    80005e6c:	fe0915e3          	bnez	s2,80005e56 <printf+0x13a>
    80005e70:	b799                	j	80005db6 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005e72:	f8843783          	ld	a5,-120(s0)
    80005e76:	00878713          	addi	a4,a5,8
    80005e7a:	f8e43423          	sd	a4,-120(s0)
    80005e7e:	0007b903          	ld	s2,0(a5)
    80005e82:	00090e63          	beqz	s2,80005e9e <printf+0x182>
      for(; *s; s++)
    80005e86:	00094503          	lbu	a0,0(s2)
    80005e8a:	d515                	beqz	a0,80005db6 <printf+0x9a>
        consputc(*s);
    80005e8c:	00000097          	auipc	ra,0x0
    80005e90:	b84080e7          	jalr	-1148(ra) # 80005a10 <consputc>
      for(; *s; s++)
    80005e94:	0905                	addi	s2,s2,1
    80005e96:	00094503          	lbu	a0,0(s2)
    80005e9a:	f96d                	bnez	a0,80005e8c <printf+0x170>
    80005e9c:	bf29                	j	80005db6 <printf+0x9a>
        s = "(null)";
    80005e9e:	00003917          	auipc	s2,0x3
    80005ea2:	94290913          	addi	s2,s2,-1726 # 800087e0 <syscalls+0x410>
      for(; *s; s++)
    80005ea6:	02800513          	li	a0,40
    80005eaa:	b7cd                	j	80005e8c <printf+0x170>
      consputc('%');
    80005eac:	8556                	mv	a0,s5
    80005eae:	00000097          	auipc	ra,0x0
    80005eb2:	b62080e7          	jalr	-1182(ra) # 80005a10 <consputc>
      break;
    80005eb6:	b701                	j	80005db6 <printf+0x9a>
      consputc('%');
    80005eb8:	8556                	mv	a0,s5
    80005eba:	00000097          	auipc	ra,0x0
    80005ebe:	b56080e7          	jalr	-1194(ra) # 80005a10 <consputc>
      consputc(c);
    80005ec2:	854a                	mv	a0,s2
    80005ec4:	00000097          	auipc	ra,0x0
    80005ec8:	b4c080e7          	jalr	-1204(ra) # 80005a10 <consputc>
      break;
    80005ecc:	b5ed                	j	80005db6 <printf+0x9a>
  if(locking)
    80005ece:	020d9163          	bnez	s11,80005ef0 <printf+0x1d4>
}
    80005ed2:	70e6                	ld	ra,120(sp)
    80005ed4:	7446                	ld	s0,112(sp)
    80005ed6:	74a6                	ld	s1,104(sp)
    80005ed8:	7906                	ld	s2,96(sp)
    80005eda:	69e6                	ld	s3,88(sp)
    80005edc:	6a46                	ld	s4,80(sp)
    80005ede:	6aa6                	ld	s5,72(sp)
    80005ee0:	6b06                	ld	s6,64(sp)
    80005ee2:	7be2                	ld	s7,56(sp)
    80005ee4:	7c42                	ld	s8,48(sp)
    80005ee6:	7ca2                	ld	s9,40(sp)
    80005ee8:	7d02                	ld	s10,32(sp)
    80005eea:	6de2                	ld	s11,24(sp)
    80005eec:	6129                	addi	sp,sp,192
    80005eee:	8082                	ret
    release(&pr.lock);
    80005ef0:	0001c517          	auipc	a0,0x1c
    80005ef4:	43850513          	addi	a0,a0,1080 # 80022328 <pr>
    80005ef8:	00000097          	auipc	ra,0x0
    80005efc:	434080e7          	jalr	1076(ra) # 8000632c <release>
}
    80005f00:	bfc9                	j	80005ed2 <printf+0x1b6>

0000000080005f02 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005f02:	1101                	addi	sp,sp,-32
    80005f04:	ec06                	sd	ra,24(sp)
    80005f06:	e822                	sd	s0,16(sp)
    80005f08:	e426                	sd	s1,8(sp)
    80005f0a:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005f0c:	0001c497          	auipc	s1,0x1c
    80005f10:	41c48493          	addi	s1,s1,1052 # 80022328 <pr>
    80005f14:	00003597          	auipc	a1,0x3
    80005f18:	8e458593          	addi	a1,a1,-1820 # 800087f8 <syscalls+0x428>
    80005f1c:	8526                	mv	a0,s1
    80005f1e:	00000097          	auipc	ra,0x0
    80005f22:	2ca080e7          	jalr	714(ra) # 800061e8 <initlock>
  pr.locking = 1;
    80005f26:	4785                	li	a5,1
    80005f28:	cc9c                	sw	a5,24(s1)
}
    80005f2a:	60e2                	ld	ra,24(sp)
    80005f2c:	6442                	ld	s0,16(sp)
    80005f2e:	64a2                	ld	s1,8(sp)
    80005f30:	6105                	addi	sp,sp,32
    80005f32:	8082                	ret

0000000080005f34 <backtrace>:
void backtrace(void)
{
    80005f34:	7179                	addi	sp,sp,-48
    80005f36:	f406                	sd	ra,40(sp)
    80005f38:	f022                	sd	s0,32(sp)
    80005f3a:	ec26                	sd	s1,24(sp)
    80005f3c:	e84a                	sd	s2,16(sp)
    80005f3e:	e44e                	sd	s3,8(sp)
    80005f40:	1800                	addi	s0,sp,48

static inline uint64
r_fp()
{
  uint64 x;
  asm volatile("mv %0, s0" : "=r" (x) );
    80005f42:	84a2                	mv	s1,s0
    uint64 fp = r_fp();
    uint64 boundary = PGROUNDUP(fp);
    80005f44:	6905                	lui	s2,0x1
    80005f46:	197d                	addi	s2,s2,-1
    80005f48:	9926                	add	s2,s2,s1
    80005f4a:	77fd                	lui	a5,0xfffff
    80005f4c:	00f97933          	and	s2,s2,a5
    printf("backtrace:\n");
    80005f50:	00003517          	auipc	a0,0x3
    80005f54:	8b050513          	addi	a0,a0,-1872 # 80008800 <syscalls+0x430>
    80005f58:	00000097          	auipc	ra,0x0
    80005f5c:	dc4080e7          	jalr	-572(ra) # 80005d1c <printf>
    while (fp < boundary) {
    80005f60:	0324f163          	bgeu	s1,s2,80005f82 <backtrace+0x4e>
        printf("%p\n", *((uint64 *)(fp - 8)));
    80005f64:	00003997          	auipc	s3,0x3
    80005f68:	8ac98993          	addi	s3,s3,-1876 # 80008810 <syscalls+0x440>
    80005f6c:	ff84b583          	ld	a1,-8(s1)
    80005f70:	854e                	mv	a0,s3
    80005f72:	00000097          	auipc	ra,0x0
    80005f76:	daa080e7          	jalr	-598(ra) # 80005d1c <printf>
        fp = *((uint64 *)(fp - 16));
    80005f7a:	ff04b483          	ld	s1,-16(s1)
    while (fp < boundary) {
    80005f7e:	ff24e7e3          	bltu	s1,s2,80005f6c <backtrace+0x38>
    }
    80005f82:	70a2                	ld	ra,40(sp)
    80005f84:	7402                	ld	s0,32(sp)
    80005f86:	64e2                	ld	s1,24(sp)
    80005f88:	6942                	ld	s2,16(sp)
    80005f8a:	69a2                	ld	s3,8(sp)
    80005f8c:	6145                	addi	sp,sp,48
    80005f8e:	8082                	ret

0000000080005f90 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005f90:	1141                	addi	sp,sp,-16
    80005f92:	e406                	sd	ra,8(sp)
    80005f94:	e022                	sd	s0,0(sp)
    80005f96:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005f98:	100007b7          	lui	a5,0x10000
    80005f9c:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005fa0:	f8000713          	li	a4,-128
    80005fa4:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005fa8:	470d                	li	a4,3
    80005faa:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005fae:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005fb2:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005fb6:	469d                	li	a3,7
    80005fb8:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005fbc:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005fc0:	00003597          	auipc	a1,0x3
    80005fc4:	87058593          	addi	a1,a1,-1936 # 80008830 <digits+0x18>
    80005fc8:	0001c517          	auipc	a0,0x1c
    80005fcc:	38050513          	addi	a0,a0,896 # 80022348 <uart_tx_lock>
    80005fd0:	00000097          	auipc	ra,0x0
    80005fd4:	218080e7          	jalr	536(ra) # 800061e8 <initlock>
}
    80005fd8:	60a2                	ld	ra,8(sp)
    80005fda:	6402                	ld	s0,0(sp)
    80005fdc:	0141                	addi	sp,sp,16
    80005fde:	8082                	ret

0000000080005fe0 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005fe0:	1101                	addi	sp,sp,-32
    80005fe2:	ec06                	sd	ra,24(sp)
    80005fe4:	e822                	sd	s0,16(sp)
    80005fe6:	e426                	sd	s1,8(sp)
    80005fe8:	1000                	addi	s0,sp,32
    80005fea:	84aa                	mv	s1,a0
  push_off();
    80005fec:	00000097          	auipc	ra,0x0
    80005ff0:	240080e7          	jalr	576(ra) # 8000622c <push_off>

  if(panicked){
    80005ff4:	00003797          	auipc	a5,0x3
    80005ff8:	9087a783          	lw	a5,-1784(a5) # 800088fc <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005ffc:	10000737          	lui	a4,0x10000
  if(panicked){
    80006000:	c391                	beqz	a5,80006004 <uartputc_sync+0x24>
    for(;;)
    80006002:	a001                	j	80006002 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006004:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80006008:	0ff7f793          	andi	a5,a5,255
    8000600c:	0207f793          	andi	a5,a5,32
    80006010:	dbf5                	beqz	a5,80006004 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80006012:	0ff4f793          	andi	a5,s1,255
    80006016:	10000737          	lui	a4,0x10000
    8000601a:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    8000601e:	00000097          	auipc	ra,0x0
    80006022:	2ae080e7          	jalr	686(ra) # 800062cc <pop_off>
}
    80006026:	60e2                	ld	ra,24(sp)
    80006028:	6442                	ld	s0,16(sp)
    8000602a:	64a2                	ld	s1,8(sp)
    8000602c:	6105                	addi	sp,sp,32
    8000602e:	8082                	ret

0000000080006030 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80006030:	00003717          	auipc	a4,0x3
    80006034:	8d073703          	ld	a4,-1840(a4) # 80008900 <uart_tx_r>
    80006038:	00003797          	auipc	a5,0x3
    8000603c:	8d07b783          	ld	a5,-1840(a5) # 80008908 <uart_tx_w>
    80006040:	06e78c63          	beq	a5,a4,800060b8 <uartstart+0x88>
{
    80006044:	7139                	addi	sp,sp,-64
    80006046:	fc06                	sd	ra,56(sp)
    80006048:	f822                	sd	s0,48(sp)
    8000604a:	f426                	sd	s1,40(sp)
    8000604c:	f04a                	sd	s2,32(sp)
    8000604e:	ec4e                	sd	s3,24(sp)
    80006050:	e852                	sd	s4,16(sp)
    80006052:	e456                	sd	s5,8(sp)
    80006054:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006056:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000605a:	0001ca17          	auipc	s4,0x1c
    8000605e:	2eea0a13          	addi	s4,s4,750 # 80022348 <uart_tx_lock>
    uart_tx_r += 1;
    80006062:	00003497          	auipc	s1,0x3
    80006066:	89e48493          	addi	s1,s1,-1890 # 80008900 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    8000606a:	00003997          	auipc	s3,0x3
    8000606e:	89e98993          	addi	s3,s3,-1890 # 80008908 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006072:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    80006076:	0ff7f793          	andi	a5,a5,255
    8000607a:	0207f793          	andi	a5,a5,32
    8000607e:	c785                	beqz	a5,800060a6 <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006080:	01f77793          	andi	a5,a4,31
    80006084:	97d2                	add	a5,a5,s4
    80006086:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    8000608a:	0705                	addi	a4,a4,1
    8000608c:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    8000608e:	8526                	mv	a0,s1
    80006090:	ffffb097          	auipc	ra,0xffffb
    80006094:	4dc080e7          	jalr	1244(ra) # 8000156c <wakeup>
    
    WriteReg(THR, c);
    80006098:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    8000609c:	6098                	ld	a4,0(s1)
    8000609e:	0009b783          	ld	a5,0(s3)
    800060a2:	fce798e3          	bne	a5,a4,80006072 <uartstart+0x42>
  }
}
    800060a6:	70e2                	ld	ra,56(sp)
    800060a8:	7442                	ld	s0,48(sp)
    800060aa:	74a2                	ld	s1,40(sp)
    800060ac:	7902                	ld	s2,32(sp)
    800060ae:	69e2                	ld	s3,24(sp)
    800060b0:	6a42                	ld	s4,16(sp)
    800060b2:	6aa2                	ld	s5,8(sp)
    800060b4:	6121                	addi	sp,sp,64
    800060b6:	8082                	ret
    800060b8:	8082                	ret

00000000800060ba <uartputc>:
{
    800060ba:	7179                	addi	sp,sp,-48
    800060bc:	f406                	sd	ra,40(sp)
    800060be:	f022                	sd	s0,32(sp)
    800060c0:	ec26                	sd	s1,24(sp)
    800060c2:	e84a                	sd	s2,16(sp)
    800060c4:	e44e                	sd	s3,8(sp)
    800060c6:	e052                	sd	s4,0(sp)
    800060c8:	1800                	addi	s0,sp,48
    800060ca:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    800060cc:	0001c517          	auipc	a0,0x1c
    800060d0:	27c50513          	addi	a0,a0,636 # 80022348 <uart_tx_lock>
    800060d4:	00000097          	auipc	ra,0x0
    800060d8:	1a4080e7          	jalr	420(ra) # 80006278 <acquire>
  if(panicked){
    800060dc:	00003797          	auipc	a5,0x3
    800060e0:	8207a783          	lw	a5,-2016(a5) # 800088fc <panicked>
    800060e4:	e7c9                	bnez	a5,8000616e <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800060e6:	00003797          	auipc	a5,0x3
    800060ea:	8227b783          	ld	a5,-2014(a5) # 80008908 <uart_tx_w>
    800060ee:	00003717          	auipc	a4,0x3
    800060f2:	81273703          	ld	a4,-2030(a4) # 80008900 <uart_tx_r>
    800060f6:	02070713          	addi	a4,a4,32
    sleep(&uart_tx_r, &uart_tx_lock);
    800060fa:	0001ca17          	auipc	s4,0x1c
    800060fe:	24ea0a13          	addi	s4,s4,590 # 80022348 <uart_tx_lock>
    80006102:	00002497          	auipc	s1,0x2
    80006106:	7fe48493          	addi	s1,s1,2046 # 80008900 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000610a:	00002917          	auipc	s2,0x2
    8000610e:	7fe90913          	addi	s2,s2,2046 # 80008908 <uart_tx_w>
    80006112:	00f71f63          	bne	a4,a5,80006130 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    80006116:	85d2                	mv	a1,s4
    80006118:	8526                	mv	a0,s1
    8000611a:	ffffb097          	auipc	ra,0xffffb
    8000611e:	3ee080e7          	jalr	1006(ra) # 80001508 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006122:	00093783          	ld	a5,0(s2)
    80006126:	6098                	ld	a4,0(s1)
    80006128:	02070713          	addi	a4,a4,32
    8000612c:	fef705e3          	beq	a4,a5,80006116 <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006130:	0001c497          	auipc	s1,0x1c
    80006134:	21848493          	addi	s1,s1,536 # 80022348 <uart_tx_lock>
    80006138:	01f7f713          	andi	a4,a5,31
    8000613c:	9726                	add	a4,a4,s1
    8000613e:	01370c23          	sb	s3,24(a4)
  uart_tx_w += 1;
    80006142:	0785                	addi	a5,a5,1
    80006144:	00002717          	auipc	a4,0x2
    80006148:	7cf73223          	sd	a5,1988(a4) # 80008908 <uart_tx_w>
  uartstart();
    8000614c:	00000097          	auipc	ra,0x0
    80006150:	ee4080e7          	jalr	-284(ra) # 80006030 <uartstart>
  release(&uart_tx_lock);
    80006154:	8526                	mv	a0,s1
    80006156:	00000097          	auipc	ra,0x0
    8000615a:	1d6080e7          	jalr	470(ra) # 8000632c <release>
}
    8000615e:	70a2                	ld	ra,40(sp)
    80006160:	7402                	ld	s0,32(sp)
    80006162:	64e2                	ld	s1,24(sp)
    80006164:	6942                	ld	s2,16(sp)
    80006166:	69a2                	ld	s3,8(sp)
    80006168:	6a02                	ld	s4,0(sp)
    8000616a:	6145                	addi	sp,sp,48
    8000616c:	8082                	ret
    for(;;)
    8000616e:	a001                	j	8000616e <uartputc+0xb4>

0000000080006170 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006170:	1141                	addi	sp,sp,-16
    80006172:	e422                	sd	s0,8(sp)
    80006174:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80006176:	100007b7          	lui	a5,0x10000
    8000617a:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    8000617e:	8b85                	andi	a5,a5,1
    80006180:	cb91                	beqz	a5,80006194 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80006182:	100007b7          	lui	a5,0x10000
    80006186:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    8000618a:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    8000618e:	6422                	ld	s0,8(sp)
    80006190:	0141                	addi	sp,sp,16
    80006192:	8082                	ret
    return -1;
    80006194:	557d                	li	a0,-1
    80006196:	bfe5                	j	8000618e <uartgetc+0x1e>

0000000080006198 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80006198:	1101                	addi	sp,sp,-32
    8000619a:	ec06                	sd	ra,24(sp)
    8000619c:	e822                	sd	s0,16(sp)
    8000619e:	e426                	sd	s1,8(sp)
    800061a0:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800061a2:	54fd                	li	s1,-1
    int c = uartgetc();
    800061a4:	00000097          	auipc	ra,0x0
    800061a8:	fcc080e7          	jalr	-52(ra) # 80006170 <uartgetc>
    if(c == -1)
    800061ac:	00950763          	beq	a0,s1,800061ba <uartintr+0x22>
      break;
    consoleintr(c);
    800061b0:	00000097          	auipc	ra,0x0
    800061b4:	8a2080e7          	jalr	-1886(ra) # 80005a52 <consoleintr>
  while(1){
    800061b8:	b7f5                	j	800061a4 <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800061ba:	0001c497          	auipc	s1,0x1c
    800061be:	18e48493          	addi	s1,s1,398 # 80022348 <uart_tx_lock>
    800061c2:	8526                	mv	a0,s1
    800061c4:	00000097          	auipc	ra,0x0
    800061c8:	0b4080e7          	jalr	180(ra) # 80006278 <acquire>
  uartstart();
    800061cc:	00000097          	auipc	ra,0x0
    800061d0:	e64080e7          	jalr	-412(ra) # 80006030 <uartstart>
  release(&uart_tx_lock);
    800061d4:	8526                	mv	a0,s1
    800061d6:	00000097          	auipc	ra,0x0
    800061da:	156080e7          	jalr	342(ra) # 8000632c <release>
}
    800061de:	60e2                	ld	ra,24(sp)
    800061e0:	6442                	ld	s0,16(sp)
    800061e2:	64a2                	ld	s1,8(sp)
    800061e4:	6105                	addi	sp,sp,32
    800061e6:	8082                	ret

00000000800061e8 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800061e8:	1141                	addi	sp,sp,-16
    800061ea:	e422                	sd	s0,8(sp)
    800061ec:	0800                	addi	s0,sp,16
  lk->name = name;
    800061ee:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800061f0:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800061f4:	00053823          	sd	zero,16(a0)
}
    800061f8:	6422                	ld	s0,8(sp)
    800061fa:	0141                	addi	sp,sp,16
    800061fc:	8082                	ret

00000000800061fe <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800061fe:	411c                	lw	a5,0(a0)
    80006200:	e399                	bnez	a5,80006206 <holding+0x8>
    80006202:	4501                	li	a0,0
  return r;
}
    80006204:	8082                	ret
{
    80006206:	1101                	addi	sp,sp,-32
    80006208:	ec06                	sd	ra,24(sp)
    8000620a:	e822                	sd	s0,16(sp)
    8000620c:	e426                	sd	s1,8(sp)
    8000620e:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006210:	6904                	ld	s1,16(a0)
    80006212:	ffffb097          	auipc	ra,0xffffb
    80006216:	c2a080e7          	jalr	-982(ra) # 80000e3c <mycpu>
    8000621a:	40a48533          	sub	a0,s1,a0
    8000621e:	00153513          	seqz	a0,a0
}
    80006222:	60e2                	ld	ra,24(sp)
    80006224:	6442                	ld	s0,16(sp)
    80006226:	64a2                	ld	s1,8(sp)
    80006228:	6105                	addi	sp,sp,32
    8000622a:	8082                	ret

000000008000622c <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    8000622c:	1101                	addi	sp,sp,-32
    8000622e:	ec06                	sd	ra,24(sp)
    80006230:	e822                	sd	s0,16(sp)
    80006232:	e426                	sd	s1,8(sp)
    80006234:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006236:	100024f3          	csrr	s1,sstatus
    8000623a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000623e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006240:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80006244:	ffffb097          	auipc	ra,0xffffb
    80006248:	bf8080e7          	jalr	-1032(ra) # 80000e3c <mycpu>
    8000624c:	5d3c                	lw	a5,120(a0)
    8000624e:	cf89                	beqz	a5,80006268 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80006250:	ffffb097          	auipc	ra,0xffffb
    80006254:	bec080e7          	jalr	-1044(ra) # 80000e3c <mycpu>
    80006258:	5d3c                	lw	a5,120(a0)
    8000625a:	2785                	addiw	a5,a5,1
    8000625c:	dd3c                	sw	a5,120(a0)
}
    8000625e:	60e2                	ld	ra,24(sp)
    80006260:	6442                	ld	s0,16(sp)
    80006262:	64a2                	ld	s1,8(sp)
    80006264:	6105                	addi	sp,sp,32
    80006266:	8082                	ret
    mycpu()->intena = old;
    80006268:	ffffb097          	auipc	ra,0xffffb
    8000626c:	bd4080e7          	jalr	-1068(ra) # 80000e3c <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80006270:	8085                	srli	s1,s1,0x1
    80006272:	8885                	andi	s1,s1,1
    80006274:	dd64                	sw	s1,124(a0)
    80006276:	bfe9                	j	80006250 <push_off+0x24>

0000000080006278 <acquire>:
{
    80006278:	1101                	addi	sp,sp,-32
    8000627a:	ec06                	sd	ra,24(sp)
    8000627c:	e822                	sd	s0,16(sp)
    8000627e:	e426                	sd	s1,8(sp)
    80006280:	1000                	addi	s0,sp,32
    80006282:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80006284:	00000097          	auipc	ra,0x0
    80006288:	fa8080e7          	jalr	-88(ra) # 8000622c <push_off>
  if(holding(lk))
    8000628c:	8526                	mv	a0,s1
    8000628e:	00000097          	auipc	ra,0x0
    80006292:	f70080e7          	jalr	-144(ra) # 800061fe <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006296:	4705                	li	a4,1
  if(holding(lk))
    80006298:	e115                	bnez	a0,800062bc <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000629a:	87ba                	mv	a5,a4
    8000629c:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800062a0:	2781                	sext.w	a5,a5
    800062a2:	ffe5                	bnez	a5,8000629a <acquire+0x22>
  __sync_synchronize();
    800062a4:	0ff0000f          	fence
  lk->cpu = mycpu();
    800062a8:	ffffb097          	auipc	ra,0xffffb
    800062ac:	b94080e7          	jalr	-1132(ra) # 80000e3c <mycpu>
    800062b0:	e888                	sd	a0,16(s1)
}
    800062b2:	60e2                	ld	ra,24(sp)
    800062b4:	6442                	ld	s0,16(sp)
    800062b6:	64a2                	ld	s1,8(sp)
    800062b8:	6105                	addi	sp,sp,32
    800062ba:	8082                	ret
    panic("acquire");
    800062bc:	00002517          	auipc	a0,0x2
    800062c0:	57c50513          	addi	a0,a0,1404 # 80008838 <digits+0x20>
    800062c4:	00000097          	auipc	ra,0x0
    800062c8:	a0e080e7          	jalr	-1522(ra) # 80005cd2 <panic>

00000000800062cc <pop_off>:

void
pop_off(void)
{
    800062cc:	1141                	addi	sp,sp,-16
    800062ce:	e406                	sd	ra,8(sp)
    800062d0:	e022                	sd	s0,0(sp)
    800062d2:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800062d4:	ffffb097          	auipc	ra,0xffffb
    800062d8:	b68080e7          	jalr	-1176(ra) # 80000e3c <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800062dc:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800062e0:	8b89                	andi	a5,a5,2
  if(intr_get())
    800062e2:	e78d                	bnez	a5,8000630c <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800062e4:	5d3c                	lw	a5,120(a0)
    800062e6:	02f05b63          	blez	a5,8000631c <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    800062ea:	37fd                	addiw	a5,a5,-1
    800062ec:	0007871b          	sext.w	a4,a5
    800062f0:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800062f2:	eb09                	bnez	a4,80006304 <pop_off+0x38>
    800062f4:	5d7c                	lw	a5,124(a0)
    800062f6:	c799                	beqz	a5,80006304 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800062f8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800062fc:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006300:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006304:	60a2                	ld	ra,8(sp)
    80006306:	6402                	ld	s0,0(sp)
    80006308:	0141                	addi	sp,sp,16
    8000630a:	8082                	ret
    panic("pop_off - interruptible");
    8000630c:	00002517          	auipc	a0,0x2
    80006310:	53450513          	addi	a0,a0,1332 # 80008840 <digits+0x28>
    80006314:	00000097          	auipc	ra,0x0
    80006318:	9be080e7          	jalr	-1602(ra) # 80005cd2 <panic>
    panic("pop_off");
    8000631c:	00002517          	auipc	a0,0x2
    80006320:	53c50513          	addi	a0,a0,1340 # 80008858 <digits+0x40>
    80006324:	00000097          	auipc	ra,0x0
    80006328:	9ae080e7          	jalr	-1618(ra) # 80005cd2 <panic>

000000008000632c <release>:
{
    8000632c:	1101                	addi	sp,sp,-32
    8000632e:	ec06                	sd	ra,24(sp)
    80006330:	e822                	sd	s0,16(sp)
    80006332:	e426                	sd	s1,8(sp)
    80006334:	1000                	addi	s0,sp,32
    80006336:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006338:	00000097          	auipc	ra,0x0
    8000633c:	ec6080e7          	jalr	-314(ra) # 800061fe <holding>
    80006340:	c115                	beqz	a0,80006364 <release+0x38>
  lk->cpu = 0;
    80006342:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006346:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    8000634a:	0f50000f          	fence	iorw,ow
    8000634e:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80006352:	00000097          	auipc	ra,0x0
    80006356:	f7a080e7          	jalr	-134(ra) # 800062cc <pop_off>
}
    8000635a:	60e2                	ld	ra,24(sp)
    8000635c:	6442                	ld	s0,16(sp)
    8000635e:	64a2                	ld	s1,8(sp)
    80006360:	6105                	addi	sp,sp,32
    80006362:	8082                	ret
    panic("release");
    80006364:	00002517          	auipc	a0,0x2
    80006368:	4fc50513          	addi	a0,a0,1276 # 80008860 <digits+0x48>
    8000636c:	00000097          	auipc	ra,0x0
    80006370:	966080e7          	jalr	-1690(ra) # 80005cd2 <panic>
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
