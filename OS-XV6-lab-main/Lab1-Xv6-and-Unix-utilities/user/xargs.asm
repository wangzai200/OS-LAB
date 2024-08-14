
user/_xargs:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <myStrdup>:
#include <stddef.h>
#define STDIN 0
#define STDOUT 1
#define MAXARGLEN 32

char* myStrdup(const char* s) {
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
   c:	84aa                	mv	s1,a0
    if (s == NULL) return NULL;
   e:	c905                	beqz	a0,3e <myStrdup+0x3e>
    char* new_str = malloc(strlen(s) + 1);  // 加 1 为 null 终结符分配空间
  10:	00000097          	auipc	ra,0x0
  14:	2d0080e7          	jalr	720(ra) # 2e0 <strlen>
  18:	2505                	addiw	a0,a0,1
  1a:	00001097          	auipc	ra,0x1
  1e:	92a080e7          	jalr	-1750(ra) # 944 <malloc>
  22:	892a                	mv	s2,a0
    if (new_str == NULL) return NULL;
  24:	c511                	beqz	a0,30 <myStrdup+0x30>
    strcpy(new_str, s);  // 复制字符串包括 null 终结符
  26:	85a6                	mv	a1,s1
  28:	00000097          	auipc	ra,0x0
  2c:	270080e7          	jalr	624(ra) # 298 <strcpy>
    return new_str;
}
  30:	854a                	mv	a0,s2
  32:	60e2                	ld	ra,24(sp)
  34:	6442                	ld	s0,16(sp)
  36:	64a2                	ld	s1,8(sp)
  38:	6902                	ld	s2,0(sp)
  3a:	6105                	addi	sp,sp,32
  3c:	8082                	ret
    if (s == NULL) return NULL;
  3e:	892a                	mv	s2,a0
  40:	bfc5                	j	30 <myStrdup+0x30>

0000000000000042 <allocForArgs>:


void allocForArgs(char *args[], int argNum, int argLen)
{
    for (int i = 0; i < argNum; i++) {
  42:	08b05c63          	blez	a1,da <allocForArgs+0x98>
{
  46:	7139                	addi	sp,sp,-64
  48:	fc06                	sd	ra,56(sp)
  4a:	f822                	sd	s0,48(sp)
  4c:	f426                	sd	s1,40(sp)
  4e:	f04a                	sd	s2,32(sp)
  50:	ec4e                	sd	s3,24(sp)
  52:	e852                	sd	s4,16(sp)
  54:	e456                	sd	s5,8(sp)
  56:	0080                	addi	s0,sp,64
  58:	8aaa                	mv	s5,a0
  5a:	8a2e                	mv	s4,a1
    for (int i = 0; i < argNum; i++) {
  5c:	892a                	mv	s2,a0
  5e:	4481                	li	s1,0
        args[i] = malloc(argLen * sizeof(char));
  60:	0006099b          	sext.w	s3,a2
  64:	854e                	mv	a0,s3
  66:	00001097          	auipc	ra,0x1
  6a:	8de080e7          	jalr	-1826(ra) # 944 <malloc>
  6e:	00a93023          	sd	a0,0(s2)
        if (args[i] == 0) {
  72:	cd11                	beqz	a0,8e <allocForArgs+0x4c>
    for (int i = 0; i < argNum; i++) {
  74:	2485                	addiw	s1,s1,1
  76:	0921                	addi	s2,s2,8
  78:	fe9a16e3          	bne	s4,s1,64 <allocForArgs+0x22>
                free(args[i]);
            }
            exit(1);
        }
    }
}
  7c:	70e2                	ld	ra,56(sp)
  7e:	7442                	ld	s0,48(sp)
  80:	74a2                	ld	s1,40(sp)
  82:	7902                	ld	s2,32(sp)
  84:	69e2                	ld	s3,24(sp)
  86:	6a42                	ld	s4,16(sp)
  88:	6aa2                	ld	s5,8(sp)
  8a:	6121                	addi	sp,sp,64
  8c:	8082                	ret
            printf("Memory allocation failed for argument %d\n");
  8e:	00001517          	auipc	a0,0x1
  92:	9a250513          	addi	a0,a0,-1630 # a30 <malloc+0xec>
  96:	00000097          	auipc	ra,0x0
  9a:	7f0080e7          	jalr	2032(ra) # 886 <printf>
            while (i-- > 0) {
  9e:	fff4871b          	addiw	a4,s1,-1
  a2:	02905763          	blez	s1,d0 <allocForArgs+0x8e>
  a6:	070e                	slli	a4,a4,0x3
  a8:	00ea8933          	add	s2,s5,a4
  ac:	ff890713          	addi	a4,s2,-8
  b0:	fff4879b          	addiw	a5,s1,-1
  b4:	1782                	slli	a5,a5,0x20
  b6:	9381                	srli	a5,a5,0x20
  b8:	078e                	slli	a5,a5,0x3
  ba:	40f704b3          	sub	s1,a4,a5
                free(args[i]);
  be:	00093503          	ld	a0,0(s2)
  c2:	00000097          	auipc	ra,0x0
  c6:	7fa080e7          	jalr	2042(ra) # 8bc <free>
            while (i-- > 0) {
  ca:	1961                	addi	s2,s2,-8
  cc:	fe9919e3          	bne	s2,s1,be <allocForArgs+0x7c>
            exit(1);
  d0:	4505                	li	a0,1
  d2:	00000097          	auipc	ra,0x0
  d6:	43c080e7          	jalr	1084(ra) # 50e <exit>
  da:	8082                	ret

00000000000000dc <freeArgs>:

void freeArgs(char *args[], int argNum)
{
    for (int i = 0; i < argNum; i++) {
  dc:	04b05163          	blez	a1,11e <freeArgs+0x42>
{
  e0:	1101                	addi	sp,sp,-32
  e2:	ec06                	sd	ra,24(sp)
  e4:	e822                	sd	s0,16(sp)
  e6:	e426                	sd	s1,8(sp)
  e8:	e04a                	sd	s2,0(sp)
  ea:	1000                	addi	s0,sp,32
  ec:	84aa                	mv	s1,a0
  ee:	fff5891b          	addiw	s2,a1,-1
  f2:	1902                	slli	s2,s2,0x20
  f4:	02095913          	srli	s2,s2,0x20
  f8:	090e                	slli	s2,s2,0x3
  fa:	0521                	addi	a0,a0,8
  fc:	992a                	add	s2,s2,a0
        free(args[i]);
  fe:	6088                	ld	a0,0(s1)
 100:	00000097          	auipc	ra,0x0
 104:	7bc080e7          	jalr	1980(ra) # 8bc <free>
        args[i] = NULL;  // 避免悬空指针
 108:	0004b023          	sd	zero,0(s1)
    for (int i = 0; i < argNum; i++) {
 10c:	04a1                	addi	s1,s1,8
 10e:	ff2498e3          	bne	s1,s2,fe <freeArgs+0x22>
    }
}
 112:	60e2                	ld	ra,24(sp)
 114:	6442                	ld	s0,16(sp)
 116:	64a2                	ld	s1,8(sp)
 118:	6902                	ld	s2,0(sp)
 11a:	6105                	addi	sp,sp,32
 11c:	8082                	ret
 11e:	8082                	ret

0000000000000120 <main>:


int main(int argc, char *argv[])
{
 120:	7149                	addi	sp,sp,-368
 122:	f686                	sd	ra,360(sp)
 124:	f2a2                	sd	s0,352(sp)
 126:	eea6                	sd	s1,344(sp)
 128:	eaca                	sd	s2,336(sp)
 12a:	e6ce                	sd	s3,328(sp)
 12c:	e2d2                	sd	s4,320(sp)
 12e:	fe56                	sd	s5,312(sp)
 130:	fa5a                	sd	s6,304(sp)
 132:	1a80                	addi	s0,sp,368
    
    // 确保至少提供了一个命令
    if (argc < 2) {
 134:	4785                	li	a5,1
 136:	04a7de63          	bge	a5,a0,192 <main+0x72>
 13a:	89aa                	mv	s3,a0
 13c:	8a2e                	mv	s4,a1
        fprintf(STDOUT, "Usage: %s <command> [args]\n");
        exit(1);
    }

    char *args[MAXARG];  // 存储命令和参数的数组
    allocForArgs(args, MAXARG, MAXARGLEN);  // 为参数数组分配内存
 13e:	02000613          	li	a2,32
 142:	02000593          	li	a1,32
 146:	ec040513          	addi	a0,s0,-320
 14a:	00000097          	auipc	ra,0x0
 14e:	ef8080e7          	jalr	-264(ra) # 42 <allocForArgs>
    int argNum = 0;  // 参数索引
    char buffer[MAXARGLEN];  // 用于临时存储标准输入的数据
    int bufferLen = 0;  // 缓冲区当前长度

    // 处理argv中的命令和参数
    for (int i = 1; i < argc && argNum < MAXARG; i++, argNum++) {
 152:	ec040493          	addi	s1,s0,-320
 156:	0a21                	addi	s4,s4,8
 158:	39fd                	addiw	s3,s3,-1
    int argNum = 0;  // 参数索引
 15a:	4901                	li	s2,0
    for (int i = 1; i < argc && argNum < MAXARG; i++, argNum++) {
 15c:	02000a93          	li	s5,32
        strcpy(args[argNum], argv[i]);
 160:	000a3583          	ld	a1,0(s4)
 164:	6088                	ld	a0,0(s1)
 166:	00000097          	auipc	ra,0x0
 16a:	132080e7          	jalr	306(ra) # 298 <strcpy>
        args[argNum][MAXARGLEN - 1] = '\0';  // 确保字符串结束
 16e:	609c                	ld	a5,0(s1)
 170:	00078fa3          	sb	zero,31(a5)
    for (int i = 1; i < argc && argNum < MAXARG; i++, argNum++) {
 174:	2905                	addiw	s2,s2,1
 176:	01390763          	beq	s2,s3,184 <main+0x64>
 17a:	04a1                	addi	s1,s1,8
 17c:	0a21                	addi	s4,s4,8
 17e:	ff5911e3          	bne	s2,s5,160 <main+0x40>
 182:	89ca                	mv	s3,s2
                bufferLen = 0;  // 重置缓冲区长度
                if (++argNum >= MAXARG) break;  // 检查参数数量限制
            }
        } else {
            if (bufferLen < MAXARGLEN - 1) {
                buffer[bufferLen++] = ch;
 184:	4481                	li	s1,0
    while (read(STDIN, &ch, 1) > 0 && argNum < MAXARG) {
 186:	497d                	li	s2,31
        if (ch == '\n' || ch == ' ') {
 188:	4a29                	li	s4,10
 18a:	02000a93          	li	s5,32
            if (bufferLen < MAXARGLEN - 1) {
 18e:	4b79                	li	s6,30
 190:	a00d                	j	1b2 <main+0x92>
        fprintf(STDOUT, "Usage: %s <command> [args]\n");
 192:	00001597          	auipc	a1,0x1
 196:	8ce58593          	addi	a1,a1,-1842 # a60 <malloc+0x11c>
 19a:	4505                	li	a0,1
 19c:	00000097          	auipc	ra,0x0
 1a0:	6bc080e7          	jalr	1724(ra) # 858 <fprintf>
        exit(1);
 1a4:	4505                	li	a0,1
 1a6:	00000097          	auipc	ra,0x0
 1aa:	368080e7          	jalr	872(ra) # 50e <exit>
            if (bufferLen > 0) {
 1ae:	04904363          	bgtz	s1,1f4 <main+0xd4>
    while (read(STDIN, &ch, 1) > 0 && argNum < MAXARG) {
 1b2:	4605                	li	a2,1
 1b4:	e9f40593          	addi	a1,s0,-353
 1b8:	4501                	li	a0,0
 1ba:	00000097          	auipc	ra,0x0
 1be:	36c080e7          	jalr	876(ra) # 526 <read>
 1c2:	04a05b63          	blez	a0,218 <main+0xf8>
 1c6:	05394963          	blt	s2,s3,218 <main+0xf8>
        if (ch == '\n' || ch == ' ') {
 1ca:	e9f44783          	lbu	a5,-353(s0)
 1ce:	ff4780e3          	beq	a5,s4,1ae <main+0x8e>
 1d2:	fd578ee3          	beq	a5,s5,1ae <main+0x8e>
            if (bufferLen < MAXARGLEN - 1) {
 1d6:	fc9b4ee3          	blt	s6,s1,1b2 <main+0x92>
                buffer[bufferLen++] = ch;
 1da:	0014871b          	addiw	a4,s1,1
 1de:	fc040693          	addi	a3,s0,-64
 1e2:	94b6                	add	s1,s1,a3
 1e4:	eef48023          	sb	a5,-288(s1)
                buffer[bufferLen] = '\0';  // 保持buffer为有效的C字符串
 1e8:	00e687b3          	add	a5,a3,a4
 1ec:	ee078023          	sb	zero,-288(a5)
                buffer[bufferLen++] = ch;
 1f0:	84ba                	mv	s1,a4
 1f2:	b7c1                	j	1b2 <main+0x92>
                args[argNum] = myStrdup(buffer);  // 复制缓冲区到args
 1f4:	ea040513          	addi	a0,s0,-352
 1f8:	00000097          	auipc	ra,0x0
 1fc:	e08080e7          	jalr	-504(ra) # 0 <myStrdup>
 200:	00399793          	slli	a5,s3,0x3
 204:	fc040713          	addi	a4,s0,-64
 208:	97ba                	add	a5,a5,a4
 20a:	f0a7b023          	sd	a0,-256(a5)
                if (++argNum >= MAXARG) break;  // 检查参数数量限制
 20e:	2985                	addiw	s3,s3,1
 210:	01394463          	blt	s2,s3,218 <main+0xf8>
                bufferLen = 0;  // 重置缓冲区长度
 214:	4481                	li	s1,0
 216:	bf71                	j	1b2 <main+0x92>
            }
        }
    }

    // 设置参数数组的结束标志
    args[argNum] = 0;
 218:	00399793          	slli	a5,s3,0x3
 21c:	fc040713          	addi	a4,s0,-64
 220:	97ba                	add	a5,a5,a4
 222:	f007b023          	sd	zero,-256(a5)

    // 创建子进程执行命令
    if (fork() == 0) {
 226:	00000097          	auipc	ra,0x0
 22a:	2e0080e7          	jalr	736(ra) # 506 <fork>
 22e:	e91d                	bnez	a0,264 <main+0x144>
        exec(args[0], args); 
 230:	ec040593          	addi	a1,s0,-320
 234:	ec043503          	ld	a0,-320(s0)
 238:	00000097          	auipc	ra,0x0
 23c:	30e080e7          	jalr	782(ra) # 546 <exec>
        freeArgs(args, argNum);
 240:	85ce                	mv	a1,s3
 242:	ec040513          	addi	a0,s0,-320
 246:	00000097          	auipc	ra,0x0
 24a:	e96080e7          	jalr	-362(ra) # dc <freeArgs>
        wait(0);  // 父进程等待子进程结束
        freeArgs(args, argNum);  // 释放分配的内存
    }

    return 0;
 24e:	4501                	li	a0,0
 250:	70b6                	ld	ra,360(sp)
 252:	7416                	ld	s0,352(sp)
 254:	64f6                	ld	s1,344(sp)
 256:	6956                	ld	s2,336(sp)
 258:	69b6                	ld	s3,328(sp)
 25a:	6a16                	ld	s4,320(sp)
 25c:	7af2                	ld	s5,312(sp)
 25e:	7b52                	ld	s6,304(sp)
 260:	6175                	addi	sp,sp,368
 262:	8082                	ret
        wait(0);  // 父进程等待子进程结束
 264:	4501                	li	a0,0
 266:	00000097          	auipc	ra,0x0
 26a:	2b0080e7          	jalr	688(ra) # 516 <wait>
        freeArgs(args, argNum);  // 释放分配的内存
 26e:	85ce                	mv	a1,s3
 270:	ec040513          	addi	a0,s0,-320
 274:	00000097          	auipc	ra,0x0
 278:	e68080e7          	jalr	-408(ra) # dc <freeArgs>
 27c:	bfc9                	j	24e <main+0x12e>

000000000000027e <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 27e:	1141                	addi	sp,sp,-16
 280:	e406                	sd	ra,8(sp)
 282:	e022                	sd	s0,0(sp)
 284:	0800                	addi	s0,sp,16
  extern int main();
  main();
 286:	00000097          	auipc	ra,0x0
 28a:	e9a080e7          	jalr	-358(ra) # 120 <main>
  exit(0);
 28e:	4501                	li	a0,0
 290:	00000097          	auipc	ra,0x0
 294:	27e080e7          	jalr	638(ra) # 50e <exit>

0000000000000298 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 298:	1141                	addi	sp,sp,-16
 29a:	e422                	sd	s0,8(sp)
 29c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 29e:	87aa                	mv	a5,a0
 2a0:	0585                	addi	a1,a1,1
 2a2:	0785                	addi	a5,a5,1
 2a4:	fff5c703          	lbu	a4,-1(a1)
 2a8:	fee78fa3          	sb	a4,-1(a5)
 2ac:	fb75                	bnez	a4,2a0 <strcpy+0x8>
    ;
  return os;
}
 2ae:	6422                	ld	s0,8(sp)
 2b0:	0141                	addi	sp,sp,16
 2b2:	8082                	ret

00000000000002b4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2b4:	1141                	addi	sp,sp,-16
 2b6:	e422                	sd	s0,8(sp)
 2b8:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 2ba:	00054783          	lbu	a5,0(a0)
 2be:	cb91                	beqz	a5,2d2 <strcmp+0x1e>
 2c0:	0005c703          	lbu	a4,0(a1)
 2c4:	00f71763          	bne	a4,a5,2d2 <strcmp+0x1e>
    p++, q++;
 2c8:	0505                	addi	a0,a0,1
 2ca:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2cc:	00054783          	lbu	a5,0(a0)
 2d0:	fbe5                	bnez	a5,2c0 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 2d2:	0005c503          	lbu	a0,0(a1)
}
 2d6:	40a7853b          	subw	a0,a5,a0
 2da:	6422                	ld	s0,8(sp)
 2dc:	0141                	addi	sp,sp,16
 2de:	8082                	ret

00000000000002e0 <strlen>:

uint
strlen(const char *s)
{
 2e0:	1141                	addi	sp,sp,-16
 2e2:	e422                	sd	s0,8(sp)
 2e4:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2e6:	00054783          	lbu	a5,0(a0)
 2ea:	cf91                	beqz	a5,306 <strlen+0x26>
 2ec:	0505                	addi	a0,a0,1
 2ee:	87aa                	mv	a5,a0
 2f0:	4685                	li	a3,1
 2f2:	9e89                	subw	a3,a3,a0
 2f4:	00f6853b          	addw	a0,a3,a5
 2f8:	0785                	addi	a5,a5,1
 2fa:	fff7c703          	lbu	a4,-1(a5)
 2fe:	fb7d                	bnez	a4,2f4 <strlen+0x14>
    ;
  return n;
}
 300:	6422                	ld	s0,8(sp)
 302:	0141                	addi	sp,sp,16
 304:	8082                	ret
  for(n = 0; s[n]; n++)
 306:	4501                	li	a0,0
 308:	bfe5                	j	300 <strlen+0x20>

000000000000030a <memset>:

void*
memset(void *dst, int c, uint n)
{
 30a:	1141                	addi	sp,sp,-16
 30c:	e422                	sd	s0,8(sp)
 30e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 310:	ce09                	beqz	a2,32a <memset+0x20>
 312:	87aa                	mv	a5,a0
 314:	fff6071b          	addiw	a4,a2,-1
 318:	1702                	slli	a4,a4,0x20
 31a:	9301                	srli	a4,a4,0x20
 31c:	0705                	addi	a4,a4,1
 31e:	972a                	add	a4,a4,a0
    cdst[i] = c;
 320:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 324:	0785                	addi	a5,a5,1
 326:	fee79de3          	bne	a5,a4,320 <memset+0x16>
  }
  return dst;
}
 32a:	6422                	ld	s0,8(sp)
 32c:	0141                	addi	sp,sp,16
 32e:	8082                	ret

0000000000000330 <strchr>:

char*
strchr(const char *s, char c)
{
 330:	1141                	addi	sp,sp,-16
 332:	e422                	sd	s0,8(sp)
 334:	0800                	addi	s0,sp,16
  for(; *s; s++)
 336:	00054783          	lbu	a5,0(a0)
 33a:	cb99                	beqz	a5,350 <strchr+0x20>
    if(*s == c)
 33c:	00f58763          	beq	a1,a5,34a <strchr+0x1a>
  for(; *s; s++)
 340:	0505                	addi	a0,a0,1
 342:	00054783          	lbu	a5,0(a0)
 346:	fbfd                	bnez	a5,33c <strchr+0xc>
      return (char*)s;
  return 0;
 348:	4501                	li	a0,0
}
 34a:	6422                	ld	s0,8(sp)
 34c:	0141                	addi	sp,sp,16
 34e:	8082                	ret
  return 0;
 350:	4501                	li	a0,0
 352:	bfe5                	j	34a <strchr+0x1a>

0000000000000354 <gets>:

char*
gets(char *buf, int max)
{
 354:	711d                	addi	sp,sp,-96
 356:	ec86                	sd	ra,88(sp)
 358:	e8a2                	sd	s0,80(sp)
 35a:	e4a6                	sd	s1,72(sp)
 35c:	e0ca                	sd	s2,64(sp)
 35e:	fc4e                	sd	s3,56(sp)
 360:	f852                	sd	s4,48(sp)
 362:	f456                	sd	s5,40(sp)
 364:	f05a                	sd	s6,32(sp)
 366:	ec5e                	sd	s7,24(sp)
 368:	1080                	addi	s0,sp,96
 36a:	8baa                	mv	s7,a0
 36c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 36e:	892a                	mv	s2,a0
 370:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 372:	4aa9                	li	s5,10
 374:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 376:	89a6                	mv	s3,s1
 378:	2485                	addiw	s1,s1,1
 37a:	0344d863          	bge	s1,s4,3aa <gets+0x56>
    cc = read(0, &c, 1);
 37e:	4605                	li	a2,1
 380:	faf40593          	addi	a1,s0,-81
 384:	4501                	li	a0,0
 386:	00000097          	auipc	ra,0x0
 38a:	1a0080e7          	jalr	416(ra) # 526 <read>
    if(cc < 1)
 38e:	00a05e63          	blez	a0,3aa <gets+0x56>
    buf[i++] = c;
 392:	faf44783          	lbu	a5,-81(s0)
 396:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 39a:	01578763          	beq	a5,s5,3a8 <gets+0x54>
 39e:	0905                	addi	s2,s2,1
 3a0:	fd679be3          	bne	a5,s6,376 <gets+0x22>
  for(i=0; i+1 < max; ){
 3a4:	89a6                	mv	s3,s1
 3a6:	a011                	j	3aa <gets+0x56>
 3a8:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 3aa:	99de                	add	s3,s3,s7
 3ac:	00098023          	sb	zero,0(s3)
  return buf;
}
 3b0:	855e                	mv	a0,s7
 3b2:	60e6                	ld	ra,88(sp)
 3b4:	6446                	ld	s0,80(sp)
 3b6:	64a6                	ld	s1,72(sp)
 3b8:	6906                	ld	s2,64(sp)
 3ba:	79e2                	ld	s3,56(sp)
 3bc:	7a42                	ld	s4,48(sp)
 3be:	7aa2                	ld	s5,40(sp)
 3c0:	7b02                	ld	s6,32(sp)
 3c2:	6be2                	ld	s7,24(sp)
 3c4:	6125                	addi	sp,sp,96
 3c6:	8082                	ret

00000000000003c8 <stat>:

int
stat(const char *n, struct stat *st)
{
 3c8:	1101                	addi	sp,sp,-32
 3ca:	ec06                	sd	ra,24(sp)
 3cc:	e822                	sd	s0,16(sp)
 3ce:	e426                	sd	s1,8(sp)
 3d0:	e04a                	sd	s2,0(sp)
 3d2:	1000                	addi	s0,sp,32
 3d4:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3d6:	4581                	li	a1,0
 3d8:	00000097          	auipc	ra,0x0
 3dc:	176080e7          	jalr	374(ra) # 54e <open>
  if(fd < 0)
 3e0:	02054563          	bltz	a0,40a <stat+0x42>
 3e4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3e6:	85ca                	mv	a1,s2
 3e8:	00000097          	auipc	ra,0x0
 3ec:	17e080e7          	jalr	382(ra) # 566 <fstat>
 3f0:	892a                	mv	s2,a0
  close(fd);
 3f2:	8526                	mv	a0,s1
 3f4:	00000097          	auipc	ra,0x0
 3f8:	142080e7          	jalr	322(ra) # 536 <close>
  return r;
}
 3fc:	854a                	mv	a0,s2
 3fe:	60e2                	ld	ra,24(sp)
 400:	6442                	ld	s0,16(sp)
 402:	64a2                	ld	s1,8(sp)
 404:	6902                	ld	s2,0(sp)
 406:	6105                	addi	sp,sp,32
 408:	8082                	ret
    return -1;
 40a:	597d                	li	s2,-1
 40c:	bfc5                	j	3fc <stat+0x34>

000000000000040e <atoi>:

int
atoi(const char *s)
{
 40e:	1141                	addi	sp,sp,-16
 410:	e422                	sd	s0,8(sp)
 412:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 414:	00054603          	lbu	a2,0(a0)
 418:	fd06079b          	addiw	a5,a2,-48
 41c:	0ff7f793          	andi	a5,a5,255
 420:	4725                	li	a4,9
 422:	02f76963          	bltu	a4,a5,454 <atoi+0x46>
 426:	86aa                	mv	a3,a0
  n = 0;
 428:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 42a:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 42c:	0685                	addi	a3,a3,1
 42e:	0025179b          	slliw	a5,a0,0x2
 432:	9fa9                	addw	a5,a5,a0
 434:	0017979b          	slliw	a5,a5,0x1
 438:	9fb1                	addw	a5,a5,a2
 43a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 43e:	0006c603          	lbu	a2,0(a3)
 442:	fd06071b          	addiw	a4,a2,-48
 446:	0ff77713          	andi	a4,a4,255
 44a:	fee5f1e3          	bgeu	a1,a4,42c <atoi+0x1e>
  return n;
}
 44e:	6422                	ld	s0,8(sp)
 450:	0141                	addi	sp,sp,16
 452:	8082                	ret
  n = 0;
 454:	4501                	li	a0,0
 456:	bfe5                	j	44e <atoi+0x40>

0000000000000458 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 458:	1141                	addi	sp,sp,-16
 45a:	e422                	sd	s0,8(sp)
 45c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 45e:	02b57663          	bgeu	a0,a1,48a <memmove+0x32>
    while(n-- > 0)
 462:	02c05163          	blez	a2,484 <memmove+0x2c>
 466:	fff6079b          	addiw	a5,a2,-1
 46a:	1782                	slli	a5,a5,0x20
 46c:	9381                	srli	a5,a5,0x20
 46e:	0785                	addi	a5,a5,1
 470:	97aa                	add	a5,a5,a0
  dst = vdst;
 472:	872a                	mv	a4,a0
      *dst++ = *src++;
 474:	0585                	addi	a1,a1,1
 476:	0705                	addi	a4,a4,1
 478:	fff5c683          	lbu	a3,-1(a1)
 47c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 480:	fee79ae3          	bne	a5,a4,474 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 484:	6422                	ld	s0,8(sp)
 486:	0141                	addi	sp,sp,16
 488:	8082                	ret
    dst += n;
 48a:	00c50733          	add	a4,a0,a2
    src += n;
 48e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 490:	fec05ae3          	blez	a2,484 <memmove+0x2c>
 494:	fff6079b          	addiw	a5,a2,-1
 498:	1782                	slli	a5,a5,0x20
 49a:	9381                	srli	a5,a5,0x20
 49c:	fff7c793          	not	a5,a5
 4a0:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 4a2:	15fd                	addi	a1,a1,-1
 4a4:	177d                	addi	a4,a4,-1
 4a6:	0005c683          	lbu	a3,0(a1)
 4aa:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 4ae:	fee79ae3          	bne	a5,a4,4a2 <memmove+0x4a>
 4b2:	bfc9                	j	484 <memmove+0x2c>

00000000000004b4 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 4b4:	1141                	addi	sp,sp,-16
 4b6:	e422                	sd	s0,8(sp)
 4b8:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 4ba:	ca05                	beqz	a2,4ea <memcmp+0x36>
 4bc:	fff6069b          	addiw	a3,a2,-1
 4c0:	1682                	slli	a3,a3,0x20
 4c2:	9281                	srli	a3,a3,0x20
 4c4:	0685                	addi	a3,a3,1
 4c6:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 4c8:	00054783          	lbu	a5,0(a0)
 4cc:	0005c703          	lbu	a4,0(a1)
 4d0:	00e79863          	bne	a5,a4,4e0 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 4d4:	0505                	addi	a0,a0,1
    p2++;
 4d6:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 4d8:	fed518e3          	bne	a0,a3,4c8 <memcmp+0x14>
  }
  return 0;
 4dc:	4501                	li	a0,0
 4de:	a019                	j	4e4 <memcmp+0x30>
      return *p1 - *p2;
 4e0:	40e7853b          	subw	a0,a5,a4
}
 4e4:	6422                	ld	s0,8(sp)
 4e6:	0141                	addi	sp,sp,16
 4e8:	8082                	ret
  return 0;
 4ea:	4501                	li	a0,0
 4ec:	bfe5                	j	4e4 <memcmp+0x30>

00000000000004ee <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4ee:	1141                	addi	sp,sp,-16
 4f0:	e406                	sd	ra,8(sp)
 4f2:	e022                	sd	s0,0(sp)
 4f4:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4f6:	00000097          	auipc	ra,0x0
 4fa:	f62080e7          	jalr	-158(ra) # 458 <memmove>
}
 4fe:	60a2                	ld	ra,8(sp)
 500:	6402                	ld	s0,0(sp)
 502:	0141                	addi	sp,sp,16
 504:	8082                	ret

0000000000000506 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 506:	4885                	li	a7,1
 ecall
 508:	00000073          	ecall
 ret
 50c:	8082                	ret

000000000000050e <exit>:
.global exit
exit:
 li a7, SYS_exit
 50e:	4889                	li	a7,2
 ecall
 510:	00000073          	ecall
 ret
 514:	8082                	ret

0000000000000516 <wait>:
.global wait
wait:
 li a7, SYS_wait
 516:	488d                	li	a7,3
 ecall
 518:	00000073          	ecall
 ret
 51c:	8082                	ret

000000000000051e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 51e:	4891                	li	a7,4
 ecall
 520:	00000073          	ecall
 ret
 524:	8082                	ret

0000000000000526 <read>:
.global read
read:
 li a7, SYS_read
 526:	4895                	li	a7,5
 ecall
 528:	00000073          	ecall
 ret
 52c:	8082                	ret

000000000000052e <write>:
.global write
write:
 li a7, SYS_write
 52e:	48c1                	li	a7,16
 ecall
 530:	00000073          	ecall
 ret
 534:	8082                	ret

0000000000000536 <close>:
.global close
close:
 li a7, SYS_close
 536:	48d5                	li	a7,21
 ecall
 538:	00000073          	ecall
 ret
 53c:	8082                	ret

000000000000053e <kill>:
.global kill
kill:
 li a7, SYS_kill
 53e:	4899                	li	a7,6
 ecall
 540:	00000073          	ecall
 ret
 544:	8082                	ret

0000000000000546 <exec>:
.global exec
exec:
 li a7, SYS_exec
 546:	489d                	li	a7,7
 ecall
 548:	00000073          	ecall
 ret
 54c:	8082                	ret

000000000000054e <open>:
.global open
open:
 li a7, SYS_open
 54e:	48bd                	li	a7,15
 ecall
 550:	00000073          	ecall
 ret
 554:	8082                	ret

0000000000000556 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 556:	48c5                	li	a7,17
 ecall
 558:	00000073          	ecall
 ret
 55c:	8082                	ret

000000000000055e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 55e:	48c9                	li	a7,18
 ecall
 560:	00000073          	ecall
 ret
 564:	8082                	ret

0000000000000566 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 566:	48a1                	li	a7,8
 ecall
 568:	00000073          	ecall
 ret
 56c:	8082                	ret

000000000000056e <link>:
.global link
link:
 li a7, SYS_link
 56e:	48cd                	li	a7,19
 ecall
 570:	00000073          	ecall
 ret
 574:	8082                	ret

0000000000000576 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 576:	48d1                	li	a7,20
 ecall
 578:	00000073          	ecall
 ret
 57c:	8082                	ret

000000000000057e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 57e:	48a5                	li	a7,9
 ecall
 580:	00000073          	ecall
 ret
 584:	8082                	ret

0000000000000586 <dup>:
.global dup
dup:
 li a7, SYS_dup
 586:	48a9                	li	a7,10
 ecall
 588:	00000073          	ecall
 ret
 58c:	8082                	ret

000000000000058e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 58e:	48ad                	li	a7,11
 ecall
 590:	00000073          	ecall
 ret
 594:	8082                	ret

0000000000000596 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 596:	48b1                	li	a7,12
 ecall
 598:	00000073          	ecall
 ret
 59c:	8082                	ret

000000000000059e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 59e:	48b5                	li	a7,13
 ecall
 5a0:	00000073          	ecall
 ret
 5a4:	8082                	ret

00000000000005a6 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5a6:	48b9                	li	a7,14
 ecall
 5a8:	00000073          	ecall
 ret
 5ac:	8082                	ret

00000000000005ae <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5ae:	1101                	addi	sp,sp,-32
 5b0:	ec06                	sd	ra,24(sp)
 5b2:	e822                	sd	s0,16(sp)
 5b4:	1000                	addi	s0,sp,32
 5b6:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5ba:	4605                	li	a2,1
 5bc:	fef40593          	addi	a1,s0,-17
 5c0:	00000097          	auipc	ra,0x0
 5c4:	f6e080e7          	jalr	-146(ra) # 52e <write>
}
 5c8:	60e2                	ld	ra,24(sp)
 5ca:	6442                	ld	s0,16(sp)
 5cc:	6105                	addi	sp,sp,32
 5ce:	8082                	ret

00000000000005d0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5d0:	7139                	addi	sp,sp,-64
 5d2:	fc06                	sd	ra,56(sp)
 5d4:	f822                	sd	s0,48(sp)
 5d6:	f426                	sd	s1,40(sp)
 5d8:	f04a                	sd	s2,32(sp)
 5da:	ec4e                	sd	s3,24(sp)
 5dc:	0080                	addi	s0,sp,64
 5de:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5e0:	c299                	beqz	a3,5e6 <printint+0x16>
 5e2:	0805c863          	bltz	a1,672 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5e6:	2581                	sext.w	a1,a1
  neg = 0;
 5e8:	4881                	li	a7,0
 5ea:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 5ee:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5f0:	2601                	sext.w	a2,a2
 5f2:	00000517          	auipc	a0,0x0
 5f6:	49650513          	addi	a0,a0,1174 # a88 <digits>
 5fa:	883a                	mv	a6,a4
 5fc:	2705                	addiw	a4,a4,1
 5fe:	02c5f7bb          	remuw	a5,a1,a2
 602:	1782                	slli	a5,a5,0x20
 604:	9381                	srli	a5,a5,0x20
 606:	97aa                	add	a5,a5,a0
 608:	0007c783          	lbu	a5,0(a5)
 60c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 610:	0005879b          	sext.w	a5,a1
 614:	02c5d5bb          	divuw	a1,a1,a2
 618:	0685                	addi	a3,a3,1
 61a:	fec7f0e3          	bgeu	a5,a2,5fa <printint+0x2a>
  if(neg)
 61e:	00088b63          	beqz	a7,634 <printint+0x64>
    buf[i++] = '-';
 622:	fd040793          	addi	a5,s0,-48
 626:	973e                	add	a4,a4,a5
 628:	02d00793          	li	a5,45
 62c:	fef70823          	sb	a5,-16(a4)
 630:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 634:	02e05863          	blez	a4,664 <printint+0x94>
 638:	fc040793          	addi	a5,s0,-64
 63c:	00e78933          	add	s2,a5,a4
 640:	fff78993          	addi	s3,a5,-1
 644:	99ba                	add	s3,s3,a4
 646:	377d                	addiw	a4,a4,-1
 648:	1702                	slli	a4,a4,0x20
 64a:	9301                	srli	a4,a4,0x20
 64c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 650:	fff94583          	lbu	a1,-1(s2)
 654:	8526                	mv	a0,s1
 656:	00000097          	auipc	ra,0x0
 65a:	f58080e7          	jalr	-168(ra) # 5ae <putc>
  while(--i >= 0)
 65e:	197d                	addi	s2,s2,-1
 660:	ff3918e3          	bne	s2,s3,650 <printint+0x80>
}
 664:	70e2                	ld	ra,56(sp)
 666:	7442                	ld	s0,48(sp)
 668:	74a2                	ld	s1,40(sp)
 66a:	7902                	ld	s2,32(sp)
 66c:	69e2                	ld	s3,24(sp)
 66e:	6121                	addi	sp,sp,64
 670:	8082                	ret
    x = -xx;
 672:	40b005bb          	negw	a1,a1
    neg = 1;
 676:	4885                	li	a7,1
    x = -xx;
 678:	bf8d                	j	5ea <printint+0x1a>

000000000000067a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 67a:	7119                	addi	sp,sp,-128
 67c:	fc86                	sd	ra,120(sp)
 67e:	f8a2                	sd	s0,112(sp)
 680:	f4a6                	sd	s1,104(sp)
 682:	f0ca                	sd	s2,96(sp)
 684:	ecce                	sd	s3,88(sp)
 686:	e8d2                	sd	s4,80(sp)
 688:	e4d6                	sd	s5,72(sp)
 68a:	e0da                	sd	s6,64(sp)
 68c:	fc5e                	sd	s7,56(sp)
 68e:	f862                	sd	s8,48(sp)
 690:	f466                	sd	s9,40(sp)
 692:	f06a                	sd	s10,32(sp)
 694:	ec6e                	sd	s11,24(sp)
 696:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 698:	0005c903          	lbu	s2,0(a1)
 69c:	18090f63          	beqz	s2,83a <vprintf+0x1c0>
 6a0:	8aaa                	mv	s5,a0
 6a2:	8b32                	mv	s6,a2
 6a4:	00158493          	addi	s1,a1,1
  state = 0;
 6a8:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 6aa:	02500a13          	li	s4,37
      if(c == 'd'){
 6ae:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 6b2:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 6b6:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 6ba:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6be:	00000b97          	auipc	s7,0x0
 6c2:	3cab8b93          	addi	s7,s7,970 # a88 <digits>
 6c6:	a839                	j	6e4 <vprintf+0x6a>
        putc(fd, c);
 6c8:	85ca                	mv	a1,s2
 6ca:	8556                	mv	a0,s5
 6cc:	00000097          	auipc	ra,0x0
 6d0:	ee2080e7          	jalr	-286(ra) # 5ae <putc>
 6d4:	a019                	j	6da <vprintf+0x60>
    } else if(state == '%'){
 6d6:	01498f63          	beq	s3,s4,6f4 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 6da:	0485                	addi	s1,s1,1
 6dc:	fff4c903          	lbu	s2,-1(s1)
 6e0:	14090d63          	beqz	s2,83a <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 6e4:	0009079b          	sext.w	a5,s2
    if(state == 0){
 6e8:	fe0997e3          	bnez	s3,6d6 <vprintf+0x5c>
      if(c == '%'){
 6ec:	fd479ee3          	bne	a5,s4,6c8 <vprintf+0x4e>
        state = '%';
 6f0:	89be                	mv	s3,a5
 6f2:	b7e5                	j	6da <vprintf+0x60>
      if(c == 'd'){
 6f4:	05878063          	beq	a5,s8,734 <vprintf+0xba>
      } else if(c == 'l') {
 6f8:	05978c63          	beq	a5,s9,750 <vprintf+0xd6>
      } else if(c == 'x') {
 6fc:	07a78863          	beq	a5,s10,76c <vprintf+0xf2>
      } else if(c == 'p') {
 700:	09b78463          	beq	a5,s11,788 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 704:	07300713          	li	a4,115
 708:	0ce78663          	beq	a5,a4,7d4 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 70c:	06300713          	li	a4,99
 710:	0ee78e63          	beq	a5,a4,80c <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 714:	11478863          	beq	a5,s4,824 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 718:	85d2                	mv	a1,s4
 71a:	8556                	mv	a0,s5
 71c:	00000097          	auipc	ra,0x0
 720:	e92080e7          	jalr	-366(ra) # 5ae <putc>
        putc(fd, c);
 724:	85ca                	mv	a1,s2
 726:	8556                	mv	a0,s5
 728:	00000097          	auipc	ra,0x0
 72c:	e86080e7          	jalr	-378(ra) # 5ae <putc>
      }
      state = 0;
 730:	4981                	li	s3,0
 732:	b765                	j	6da <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 734:	008b0913          	addi	s2,s6,8
 738:	4685                	li	a3,1
 73a:	4629                	li	a2,10
 73c:	000b2583          	lw	a1,0(s6)
 740:	8556                	mv	a0,s5
 742:	00000097          	auipc	ra,0x0
 746:	e8e080e7          	jalr	-370(ra) # 5d0 <printint>
 74a:	8b4a                	mv	s6,s2
      state = 0;
 74c:	4981                	li	s3,0
 74e:	b771                	j	6da <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 750:	008b0913          	addi	s2,s6,8
 754:	4681                	li	a3,0
 756:	4629                	li	a2,10
 758:	000b2583          	lw	a1,0(s6)
 75c:	8556                	mv	a0,s5
 75e:	00000097          	auipc	ra,0x0
 762:	e72080e7          	jalr	-398(ra) # 5d0 <printint>
 766:	8b4a                	mv	s6,s2
      state = 0;
 768:	4981                	li	s3,0
 76a:	bf85                	j	6da <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 76c:	008b0913          	addi	s2,s6,8
 770:	4681                	li	a3,0
 772:	4641                	li	a2,16
 774:	000b2583          	lw	a1,0(s6)
 778:	8556                	mv	a0,s5
 77a:	00000097          	auipc	ra,0x0
 77e:	e56080e7          	jalr	-426(ra) # 5d0 <printint>
 782:	8b4a                	mv	s6,s2
      state = 0;
 784:	4981                	li	s3,0
 786:	bf91                	j	6da <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 788:	008b0793          	addi	a5,s6,8
 78c:	f8f43423          	sd	a5,-120(s0)
 790:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 794:	03000593          	li	a1,48
 798:	8556                	mv	a0,s5
 79a:	00000097          	auipc	ra,0x0
 79e:	e14080e7          	jalr	-492(ra) # 5ae <putc>
  putc(fd, 'x');
 7a2:	85ea                	mv	a1,s10
 7a4:	8556                	mv	a0,s5
 7a6:	00000097          	auipc	ra,0x0
 7aa:	e08080e7          	jalr	-504(ra) # 5ae <putc>
 7ae:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7b0:	03c9d793          	srli	a5,s3,0x3c
 7b4:	97de                	add	a5,a5,s7
 7b6:	0007c583          	lbu	a1,0(a5)
 7ba:	8556                	mv	a0,s5
 7bc:	00000097          	auipc	ra,0x0
 7c0:	df2080e7          	jalr	-526(ra) # 5ae <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7c4:	0992                	slli	s3,s3,0x4
 7c6:	397d                	addiw	s2,s2,-1
 7c8:	fe0914e3          	bnez	s2,7b0 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 7cc:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 7d0:	4981                	li	s3,0
 7d2:	b721                	j	6da <vprintf+0x60>
        s = va_arg(ap, char*);
 7d4:	008b0993          	addi	s3,s6,8
 7d8:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 7dc:	02090163          	beqz	s2,7fe <vprintf+0x184>
        while(*s != 0){
 7e0:	00094583          	lbu	a1,0(s2)
 7e4:	c9a1                	beqz	a1,834 <vprintf+0x1ba>
          putc(fd, *s);
 7e6:	8556                	mv	a0,s5
 7e8:	00000097          	auipc	ra,0x0
 7ec:	dc6080e7          	jalr	-570(ra) # 5ae <putc>
          s++;
 7f0:	0905                	addi	s2,s2,1
        while(*s != 0){
 7f2:	00094583          	lbu	a1,0(s2)
 7f6:	f9e5                	bnez	a1,7e6 <vprintf+0x16c>
        s = va_arg(ap, char*);
 7f8:	8b4e                	mv	s6,s3
      state = 0;
 7fa:	4981                	li	s3,0
 7fc:	bdf9                	j	6da <vprintf+0x60>
          s = "(null)";
 7fe:	00000917          	auipc	s2,0x0
 802:	28290913          	addi	s2,s2,642 # a80 <malloc+0x13c>
        while(*s != 0){
 806:	02800593          	li	a1,40
 80a:	bff1                	j	7e6 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 80c:	008b0913          	addi	s2,s6,8
 810:	000b4583          	lbu	a1,0(s6)
 814:	8556                	mv	a0,s5
 816:	00000097          	auipc	ra,0x0
 81a:	d98080e7          	jalr	-616(ra) # 5ae <putc>
 81e:	8b4a                	mv	s6,s2
      state = 0;
 820:	4981                	li	s3,0
 822:	bd65                	j	6da <vprintf+0x60>
        putc(fd, c);
 824:	85d2                	mv	a1,s4
 826:	8556                	mv	a0,s5
 828:	00000097          	auipc	ra,0x0
 82c:	d86080e7          	jalr	-634(ra) # 5ae <putc>
      state = 0;
 830:	4981                	li	s3,0
 832:	b565                	j	6da <vprintf+0x60>
        s = va_arg(ap, char*);
 834:	8b4e                	mv	s6,s3
      state = 0;
 836:	4981                	li	s3,0
 838:	b54d                	j	6da <vprintf+0x60>
    }
  }
}
 83a:	70e6                	ld	ra,120(sp)
 83c:	7446                	ld	s0,112(sp)
 83e:	74a6                	ld	s1,104(sp)
 840:	7906                	ld	s2,96(sp)
 842:	69e6                	ld	s3,88(sp)
 844:	6a46                	ld	s4,80(sp)
 846:	6aa6                	ld	s5,72(sp)
 848:	6b06                	ld	s6,64(sp)
 84a:	7be2                	ld	s7,56(sp)
 84c:	7c42                	ld	s8,48(sp)
 84e:	7ca2                	ld	s9,40(sp)
 850:	7d02                	ld	s10,32(sp)
 852:	6de2                	ld	s11,24(sp)
 854:	6109                	addi	sp,sp,128
 856:	8082                	ret

0000000000000858 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 858:	715d                	addi	sp,sp,-80
 85a:	ec06                	sd	ra,24(sp)
 85c:	e822                	sd	s0,16(sp)
 85e:	1000                	addi	s0,sp,32
 860:	e010                	sd	a2,0(s0)
 862:	e414                	sd	a3,8(s0)
 864:	e818                	sd	a4,16(s0)
 866:	ec1c                	sd	a5,24(s0)
 868:	03043023          	sd	a6,32(s0)
 86c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 870:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 874:	8622                	mv	a2,s0
 876:	00000097          	auipc	ra,0x0
 87a:	e04080e7          	jalr	-508(ra) # 67a <vprintf>
}
 87e:	60e2                	ld	ra,24(sp)
 880:	6442                	ld	s0,16(sp)
 882:	6161                	addi	sp,sp,80
 884:	8082                	ret

0000000000000886 <printf>:

void
printf(const char *fmt, ...)
{
 886:	711d                	addi	sp,sp,-96
 888:	ec06                	sd	ra,24(sp)
 88a:	e822                	sd	s0,16(sp)
 88c:	1000                	addi	s0,sp,32
 88e:	e40c                	sd	a1,8(s0)
 890:	e810                	sd	a2,16(s0)
 892:	ec14                	sd	a3,24(s0)
 894:	f018                	sd	a4,32(s0)
 896:	f41c                	sd	a5,40(s0)
 898:	03043823          	sd	a6,48(s0)
 89c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8a0:	00840613          	addi	a2,s0,8
 8a4:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8a8:	85aa                	mv	a1,a0
 8aa:	4505                	li	a0,1
 8ac:	00000097          	auipc	ra,0x0
 8b0:	dce080e7          	jalr	-562(ra) # 67a <vprintf>
}
 8b4:	60e2                	ld	ra,24(sp)
 8b6:	6442                	ld	s0,16(sp)
 8b8:	6125                	addi	sp,sp,96
 8ba:	8082                	ret

00000000000008bc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8bc:	1141                	addi	sp,sp,-16
 8be:	e422                	sd	s0,8(sp)
 8c0:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8c2:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8c6:	00000797          	auipc	a5,0x0
 8ca:	73a7b783          	ld	a5,1850(a5) # 1000 <freep>
 8ce:	a805                	j	8fe <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8d0:	4618                	lw	a4,8(a2)
 8d2:	9db9                	addw	a1,a1,a4
 8d4:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8d8:	6398                	ld	a4,0(a5)
 8da:	6318                	ld	a4,0(a4)
 8dc:	fee53823          	sd	a4,-16(a0)
 8e0:	a091                	j	924 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8e2:	ff852703          	lw	a4,-8(a0)
 8e6:	9e39                	addw	a2,a2,a4
 8e8:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 8ea:	ff053703          	ld	a4,-16(a0)
 8ee:	e398                	sd	a4,0(a5)
 8f0:	a099                	j	936 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8f2:	6398                	ld	a4,0(a5)
 8f4:	00e7e463          	bltu	a5,a4,8fc <free+0x40>
 8f8:	00e6ea63          	bltu	a3,a4,90c <free+0x50>
{
 8fc:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8fe:	fed7fae3          	bgeu	a5,a3,8f2 <free+0x36>
 902:	6398                	ld	a4,0(a5)
 904:	00e6e463          	bltu	a3,a4,90c <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 908:	fee7eae3          	bltu	a5,a4,8fc <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 90c:	ff852583          	lw	a1,-8(a0)
 910:	6390                	ld	a2,0(a5)
 912:	02059713          	slli	a4,a1,0x20
 916:	9301                	srli	a4,a4,0x20
 918:	0712                	slli	a4,a4,0x4
 91a:	9736                	add	a4,a4,a3
 91c:	fae60ae3          	beq	a2,a4,8d0 <free+0x14>
    bp->s.ptr = p->s.ptr;
 920:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 924:	4790                	lw	a2,8(a5)
 926:	02061713          	slli	a4,a2,0x20
 92a:	9301                	srli	a4,a4,0x20
 92c:	0712                	slli	a4,a4,0x4
 92e:	973e                	add	a4,a4,a5
 930:	fae689e3          	beq	a3,a4,8e2 <free+0x26>
  } else
    p->s.ptr = bp;
 934:	e394                	sd	a3,0(a5)
  freep = p;
 936:	00000717          	auipc	a4,0x0
 93a:	6cf73523          	sd	a5,1738(a4) # 1000 <freep>
}
 93e:	6422                	ld	s0,8(sp)
 940:	0141                	addi	sp,sp,16
 942:	8082                	ret

0000000000000944 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 944:	7139                	addi	sp,sp,-64
 946:	fc06                	sd	ra,56(sp)
 948:	f822                	sd	s0,48(sp)
 94a:	f426                	sd	s1,40(sp)
 94c:	f04a                	sd	s2,32(sp)
 94e:	ec4e                	sd	s3,24(sp)
 950:	e852                	sd	s4,16(sp)
 952:	e456                	sd	s5,8(sp)
 954:	e05a                	sd	s6,0(sp)
 956:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 958:	02051493          	slli	s1,a0,0x20
 95c:	9081                	srli	s1,s1,0x20
 95e:	04bd                	addi	s1,s1,15
 960:	8091                	srli	s1,s1,0x4
 962:	0014899b          	addiw	s3,s1,1
 966:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 968:	00000517          	auipc	a0,0x0
 96c:	69853503          	ld	a0,1688(a0) # 1000 <freep>
 970:	c515                	beqz	a0,99c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 972:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 974:	4798                	lw	a4,8(a5)
 976:	02977f63          	bgeu	a4,s1,9b4 <malloc+0x70>
 97a:	8a4e                	mv	s4,s3
 97c:	0009871b          	sext.w	a4,s3
 980:	6685                	lui	a3,0x1
 982:	00d77363          	bgeu	a4,a3,988 <malloc+0x44>
 986:	6a05                	lui	s4,0x1
 988:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 98c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 990:	00000917          	auipc	s2,0x0
 994:	67090913          	addi	s2,s2,1648 # 1000 <freep>
  if(p == (char*)-1)
 998:	5afd                	li	s5,-1
 99a:	a88d                	j	a0c <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 99c:	00000797          	auipc	a5,0x0
 9a0:	67478793          	addi	a5,a5,1652 # 1010 <base>
 9a4:	00000717          	auipc	a4,0x0
 9a8:	64f73e23          	sd	a5,1628(a4) # 1000 <freep>
 9ac:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9ae:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9b2:	b7e1                	j	97a <malloc+0x36>
      if(p->s.size == nunits)
 9b4:	02e48b63          	beq	s1,a4,9ea <malloc+0xa6>
        p->s.size -= nunits;
 9b8:	4137073b          	subw	a4,a4,s3
 9bc:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9be:	1702                	slli	a4,a4,0x20
 9c0:	9301                	srli	a4,a4,0x20
 9c2:	0712                	slli	a4,a4,0x4
 9c4:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9c6:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9ca:	00000717          	auipc	a4,0x0
 9ce:	62a73b23          	sd	a0,1590(a4) # 1000 <freep>
      return (void*)(p + 1);
 9d2:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 9d6:	70e2                	ld	ra,56(sp)
 9d8:	7442                	ld	s0,48(sp)
 9da:	74a2                	ld	s1,40(sp)
 9dc:	7902                	ld	s2,32(sp)
 9de:	69e2                	ld	s3,24(sp)
 9e0:	6a42                	ld	s4,16(sp)
 9e2:	6aa2                	ld	s5,8(sp)
 9e4:	6b02                	ld	s6,0(sp)
 9e6:	6121                	addi	sp,sp,64
 9e8:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 9ea:	6398                	ld	a4,0(a5)
 9ec:	e118                	sd	a4,0(a0)
 9ee:	bff1                	j	9ca <malloc+0x86>
  hp->s.size = nu;
 9f0:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9f4:	0541                	addi	a0,a0,16
 9f6:	00000097          	auipc	ra,0x0
 9fa:	ec6080e7          	jalr	-314(ra) # 8bc <free>
  return freep;
 9fe:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a02:	d971                	beqz	a0,9d6 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a04:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a06:	4798                	lw	a4,8(a5)
 a08:	fa9776e3          	bgeu	a4,s1,9b4 <malloc+0x70>
    if(p == freep)
 a0c:	00093703          	ld	a4,0(s2)
 a10:	853e                	mv	a0,a5
 a12:	fef719e3          	bne	a4,a5,a04 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 a16:	8552                	mv	a0,s4
 a18:	00000097          	auipc	ra,0x0
 a1c:	b7e080e7          	jalr	-1154(ra) # 596 <sbrk>
  if(p == (char*)-1)
 a20:	fd5518e3          	bne	a0,s5,9f0 <malloc+0xac>
        return 0;
 a24:	4501                	li	a0,0
 a26:	bf45                	j	9d6 <malloc+0x92>
