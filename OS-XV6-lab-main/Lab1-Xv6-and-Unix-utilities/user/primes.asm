
user/_primes:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <findPrimes>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"


void findPrimes(int leftPipe[]) {
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	f04a                	sd	s2,32(sp)
   a:	0080                	addi	s0,sp,64
   c:	84aa                	mv	s1,a0
    int prime;
    // 从左侧管道读取素数
    int isRead = read(leftPipe[0], &prime, sizeof(prime));
   e:	4611                	li	a2,4
  10:	fdc40593          	addi	a1,s0,-36
  14:	4108                	lw	a0,0(a0)
  16:	00000097          	auipc	ra,0x0
  1a:	520080e7          	jalr	1312(ra) # 536 <read>
    if (isRead == 0) {
  1e:	c929                	beqz	a0,70 <findPrimes+0x70>
        close(leftPipe[0]); // 关闭读端
        exit(0); // 无数据读取时退出
    } else if (isRead == -1) {
  20:	57fd                	li	a5,-1
  22:	06f50163          	beq	a0,a5,84 <findPrimes+0x84>
        printf("read failed"); // 读取失败
        exit(1);
    } else {
        printf("prime %d\n", prime); // 打印找到的素数
  26:	fdc42583          	lw	a1,-36(s0)
  2a:	00001517          	auipc	a0,0x1
  2e:	a2650513          	addi	a0,a0,-1498 # a50 <malloc+0xfc>
  32:	00001097          	auipc	ra,0x1
  36:	864080e7          	jalr	-1948(ra) # 896 <printf>
    }

    int parent2child[2];
    if (pipe(parent2child) < 0) {
  3a:	fd040513          	addi	a0,s0,-48
  3e:	00000097          	auipc	ra,0x0
  42:	4f0080e7          	jalr	1264(ra) # 52e <pipe>
  46:	04054c63          	bltz	a0,9e <findPrimes+0x9e>
        printf("pipe creation failed"); // 创建管道失败
        exit(1);
    }

    int pid = fork();
  4a:	00000097          	auipc	ra,0x0
  4e:	4cc080e7          	jalr	1228(ra) # 516 <fork>
    if (pid < 0) {
  52:	06054363          	bltz	a0,b8 <findPrimes+0xb8>
        printf("fork failed"); // 创建进程失败
        exit(1);
    }

    if (pid == 0) {
  56:	ed35                	bnez	a0,d2 <findPrimes+0xd2>
        // 子进程逻辑
        close(parent2child[1]); // 关闭写端
  58:	fd442503          	lw	a0,-44(s0)
  5c:	00000097          	auipc	ra,0x0
  60:	4ea080e7          	jalr	1258(ra) # 546 <close>
        findPrimes(parent2child); // 递归调用以创建新的筛选进程
  64:	fd040513          	addi	a0,s0,-48
  68:	00000097          	auipc	ra,0x0
  6c:	f98080e7          	jalr	-104(ra) # 0 <findPrimes>
        close(leftPipe[0]); // 关闭读端
  70:	4088                	lw	a0,0(s1)
  72:	00000097          	auipc	ra,0x0
  76:	4d4080e7          	jalr	1236(ra) # 546 <close>
        exit(0); // 无数据读取时退出
  7a:	4501                	li	a0,0
  7c:	00000097          	auipc	ra,0x0
  80:	4a2080e7          	jalr	1186(ra) # 51e <exit>
        printf("read failed"); // 读取失败
  84:	00001517          	auipc	a0,0x1
  88:	9bc50513          	addi	a0,a0,-1604 # a40 <malloc+0xec>
  8c:	00001097          	auipc	ra,0x1
  90:	80a080e7          	jalr	-2038(ra) # 896 <printf>
        exit(1);
  94:	4505                	li	a0,1
  96:	00000097          	auipc	ra,0x0
  9a:	488080e7          	jalr	1160(ra) # 51e <exit>
        printf("pipe creation failed"); // 创建管道失败
  9e:	00001517          	auipc	a0,0x1
  a2:	9c250513          	addi	a0,a0,-1598 # a60 <malloc+0x10c>
  a6:	00000097          	auipc	ra,0x0
  aa:	7f0080e7          	jalr	2032(ra) # 896 <printf>
        exit(1);
  ae:	4505                	li	a0,1
  b0:	00000097          	auipc	ra,0x0
  b4:	46e080e7          	jalr	1134(ra) # 51e <exit>
        printf("fork failed"); // 创建进程失败
  b8:	00001517          	auipc	a0,0x1
  bc:	9c050513          	addi	a0,a0,-1600 # a78 <malloc+0x124>
  c0:	00000097          	auipc	ra,0x0
  c4:	7d6080e7          	jalr	2006(ra) # 896 <printf>
        exit(1);
  c8:	4505                	li	a0,1
  ca:	00000097          	auipc	ra,0x0
  ce:	454080e7          	jalr	1108(ra) # 51e <exit>
    } else {
        // 父进程逻辑
        close(parent2child[0]); // 关闭子进程的读端
  d2:	fd042503          	lw	a0,-48(s0)
  d6:	00000097          	auipc	ra,0x0
  da:	470080e7          	jalr	1136(ra) # 546 <close>
        int tmp;
        while (read(leftPipe[0], &tmp, sizeof(tmp)) > 0) {
            if (tmp % prime != 0) {
                if (write(parent2child[1], &tmp, sizeof(tmp)) == -1) {
  de:	597d                	li	s2,-1
        while (read(leftPipe[0], &tmp, sizeof(tmp)) > 0) {
  e0:	4611                	li	a2,4
  e2:	fcc40593          	addi	a1,s0,-52
  e6:	4088                	lw	a0,0(s1)
  e8:	00000097          	auipc	ra,0x0
  ec:	44e080e7          	jalr	1102(ra) # 536 <read>
  f0:	04a05163          	blez	a0,132 <findPrimes+0x132>
            if (tmp % prime != 0) {
  f4:	fcc42783          	lw	a5,-52(s0)
  f8:	fdc42703          	lw	a4,-36(s0)
  fc:	02e7e7bb          	remw	a5,a5,a4
 100:	d3e5                	beqz	a5,e0 <findPrimes+0xe0>
                if (write(parent2child[1], &tmp, sizeof(tmp)) == -1) {
 102:	4611                	li	a2,4
 104:	fcc40593          	addi	a1,s0,-52
 108:	fd442503          	lw	a0,-44(s0)
 10c:	00000097          	auipc	ra,0x0
 110:	432080e7          	jalr	1074(ra) # 53e <write>
 114:	fd2516e3          	bne	a0,s2,e0 <findPrimes+0xe0>
                    printf("write failed"); // 写入失败
 118:	00001517          	auipc	a0,0x1
 11c:	97050513          	addi	a0,a0,-1680 # a88 <malloc+0x134>
 120:	00000097          	auipc	ra,0x0
 124:	776080e7          	jalr	1910(ra) # 896 <printf>
                    exit(1);
 128:	4505                	li	a0,1
 12a:	00000097          	auipc	ra,0x0
 12e:	3f4080e7          	jalr	1012(ra) # 51e <exit>
                }
            }
        }
        close(leftPipe[0]); // 关闭读端
 132:	4088                	lw	a0,0(s1)
 134:	00000097          	auipc	ra,0x0
 138:	412080e7          	jalr	1042(ra) # 546 <close>
        close(parent2child[1]); // 关闭写端
 13c:	fd442503          	lw	a0,-44(s0)
 140:	00000097          	auipc	ra,0x0
 144:	406080e7          	jalr	1030(ra) # 546 <close>
        wait(0); // 等待子进程完成
 148:	4501                	li	a0,0
 14a:	00000097          	auipc	ra,0x0
 14e:	3dc080e7          	jalr	988(ra) # 526 <wait>
    }

    exit(0);
 152:	4501                	li	a0,0
 154:	00000097          	auipc	ra,0x0
 158:	3ca080e7          	jalr	970(ra) # 51e <exit>

000000000000015c <main>:
}

int main(int argc, char *argv[]) {
 15c:	7155                	addi	sp,sp,-208
 15e:	e586                	sd	ra,200(sp)
 160:	e1a2                	sd	s0,192(sp)
 162:	fd26                	sd	s1,184(sp)
 164:	f94a                	sd	s2,176(sp)
 166:	f54e                	sd	s3,168(sp)
 168:	0980                	addi	s0,sp,208
    // 检查参数数量，确保不接受任何命令行参数
    if (argc > 1) {
 16a:	4785                	li	a5,1
 16c:	08a7c563          	blt	a5,a0,1f6 <main+0x9a>
 170:	f4840493          	addi	s1,s0,-184
 174:	8726                	mv	a4,s1
    }

    int nums[36];  // 创建数组以存储整数

    // 初始化整数数组
    for (int i = 2; i <= 35; i++) {
 176:	4789                	li	a5,2
 178:	02400693          	li	a3,36
        nums[i] = i;
 17c:	c31c                	sw	a5,0(a4)
    for (int i = 2; i <= 35; i++) {
 17e:	2785                	addiw	a5,a5,1
 180:	0711                	addi	a4,a4,4
 182:	fed79de3          	bne	a5,a3,17c <main+0x20>
    }

    int parent2child[2];  // 管道数组
    // 创建管道
    if (pipe(parent2child) < 0) {
 186:	f3840513          	addi	a0,s0,-200
 18a:	00000097          	auipc	ra,0x0
 18e:	3a4080e7          	jalr	932(ra) # 52e <pipe>
 192:	08054063          	bltz	a0,212 <main+0xb6>
        printf("pipe creation failed");
        exit(1);
    }

    int pid = fork();  // 创建子进程
 196:	00000097          	auipc	ra,0x0
 19a:	380080e7          	jalr	896(ra) # 516 <fork>
    if (pid < 0) {
 19e:	08054763          	bltz	a0,22c <main+0xd0>
        printf("fork failed");
        exit(1);
    }

    if (pid == 0) {
 1a2:	c155                	beqz	a0,246 <main+0xea>
        // 子进程
        close(parent2child[1]);  // 子进程关闭写端
        findPrimes(parent2child);  // 调用递归处理函数
    } else {
        // 父进程
        close(parent2child[0]);  // 父进程关闭读端
 1a4:	f3842503          	lw	a0,-200(s0)
 1a8:	00000097          	auipc	ra,0x0
 1ac:	39e080e7          	jalr	926(ra) # 546 <close>
        // 向管道写入整数
        for (int i = 2; i <= 35; i++) {
 1b0:	fd040993          	addi	s3,s0,-48
            if (write(parent2child[1], &nums[i], sizeof(nums[i])) == -1) {
 1b4:	597d                	li	s2,-1
 1b6:	4611                	li	a2,4
 1b8:	85a6                	mv	a1,s1
 1ba:	f3c42503          	lw	a0,-196(s0)
 1be:	00000097          	auipc	ra,0x0
 1c2:	380080e7          	jalr	896(ra) # 53e <write>
 1c6:	09250c63          	beq	a0,s2,25e <main+0x102>
        for (int i = 2; i <= 35; i++) {
 1ca:	0491                	addi	s1,s1,4
 1cc:	ff3495e3          	bne	s1,s3,1b6 <main+0x5a>
                close(parent2child[1]);
                wait(0);  // 等待子进程结束
                exit(1);
            }
        }
        close(parent2child[1]);  // 写入完成后关闭写端
 1d0:	f3c42503          	lw	a0,-196(s0)
 1d4:	00000097          	auipc	ra,0x0
 1d8:	372080e7          	jalr	882(ra) # 546 <close>
        wait(0);  // 等待子进程结束
 1dc:	4501                	li	a0,0
 1de:	00000097          	auipc	ra,0x0
 1e2:	348080e7          	jalr	840(ra) # 526 <wait>
    }
    return 0;  // 正常退出
}
 1e6:	4501                	li	a0,0
 1e8:	60ae                	ld	ra,200(sp)
 1ea:	640e                	ld	s0,192(sp)
 1ec:	74ea                	ld	s1,184(sp)
 1ee:	794a                	ld	s2,176(sp)
 1f0:	79aa                	ld	s3,168(sp)
 1f2:	6169                	addi	sp,sp,208
 1f4:	8082                	ret
        fprintf(2, "No argument is needed!\n");
 1f6:	00001597          	auipc	a1,0x1
 1fa:	8a258593          	addi	a1,a1,-1886 # a98 <malloc+0x144>
 1fe:	4509                	li	a0,2
 200:	00000097          	auipc	ra,0x0
 204:	668080e7          	jalr	1640(ra) # 868 <fprintf>
        exit(1);
 208:	4505                	li	a0,1
 20a:	00000097          	auipc	ra,0x0
 20e:	314080e7          	jalr	788(ra) # 51e <exit>
        printf("pipe creation failed");
 212:	00001517          	auipc	a0,0x1
 216:	84e50513          	addi	a0,a0,-1970 # a60 <malloc+0x10c>
 21a:	00000097          	auipc	ra,0x0
 21e:	67c080e7          	jalr	1660(ra) # 896 <printf>
        exit(1);
 222:	4505                	li	a0,1
 224:	00000097          	auipc	ra,0x0
 228:	2fa080e7          	jalr	762(ra) # 51e <exit>
        printf("fork failed");
 22c:	00001517          	auipc	a0,0x1
 230:	84c50513          	addi	a0,a0,-1972 # a78 <malloc+0x124>
 234:	00000097          	auipc	ra,0x0
 238:	662080e7          	jalr	1634(ra) # 896 <printf>
        exit(1);
 23c:	4505                	li	a0,1
 23e:	00000097          	auipc	ra,0x0
 242:	2e0080e7          	jalr	736(ra) # 51e <exit>
        close(parent2child[1]);  // 子进程关闭写端
 246:	f3c42503          	lw	a0,-196(s0)
 24a:	00000097          	auipc	ra,0x0
 24e:	2fc080e7          	jalr	764(ra) # 546 <close>
        findPrimes(parent2child);  // 调用递归处理函数
 252:	f3840513          	addi	a0,s0,-200
 256:	00000097          	auipc	ra,0x0
 25a:	daa080e7          	jalr	-598(ra) # 0 <findPrimes>
                printf("write failed");  // 输出写入错误信息
 25e:	00001517          	auipc	a0,0x1
 262:	82a50513          	addi	a0,a0,-2006 # a88 <malloc+0x134>
 266:	00000097          	auipc	ra,0x0
 26a:	630080e7          	jalr	1584(ra) # 896 <printf>
                close(parent2child[1]);
 26e:	f3c42503          	lw	a0,-196(s0)
 272:	00000097          	auipc	ra,0x0
 276:	2d4080e7          	jalr	724(ra) # 546 <close>
                wait(0);  // 等待子进程结束
 27a:	4501                	li	a0,0
 27c:	00000097          	auipc	ra,0x0
 280:	2aa080e7          	jalr	682(ra) # 526 <wait>
                exit(1);
 284:	4505                	li	a0,1
 286:	00000097          	auipc	ra,0x0
 28a:	298080e7          	jalr	664(ra) # 51e <exit>

000000000000028e <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 28e:	1141                	addi	sp,sp,-16
 290:	e406                	sd	ra,8(sp)
 292:	e022                	sd	s0,0(sp)
 294:	0800                	addi	s0,sp,16
  extern int main();
  main();
 296:	00000097          	auipc	ra,0x0
 29a:	ec6080e7          	jalr	-314(ra) # 15c <main>
  exit(0);
 29e:	4501                	li	a0,0
 2a0:	00000097          	auipc	ra,0x0
 2a4:	27e080e7          	jalr	638(ra) # 51e <exit>

00000000000002a8 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 2a8:	1141                	addi	sp,sp,-16
 2aa:	e422                	sd	s0,8(sp)
 2ac:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2ae:	87aa                	mv	a5,a0
 2b0:	0585                	addi	a1,a1,1
 2b2:	0785                	addi	a5,a5,1
 2b4:	fff5c703          	lbu	a4,-1(a1)
 2b8:	fee78fa3          	sb	a4,-1(a5)
 2bc:	fb75                	bnez	a4,2b0 <strcpy+0x8>
    ;
  return os;
}
 2be:	6422                	ld	s0,8(sp)
 2c0:	0141                	addi	sp,sp,16
 2c2:	8082                	ret

00000000000002c4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2c4:	1141                	addi	sp,sp,-16
 2c6:	e422                	sd	s0,8(sp)
 2c8:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 2ca:	00054783          	lbu	a5,0(a0)
 2ce:	cb91                	beqz	a5,2e2 <strcmp+0x1e>
 2d0:	0005c703          	lbu	a4,0(a1)
 2d4:	00f71763          	bne	a4,a5,2e2 <strcmp+0x1e>
    p++, q++;
 2d8:	0505                	addi	a0,a0,1
 2da:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2dc:	00054783          	lbu	a5,0(a0)
 2e0:	fbe5                	bnez	a5,2d0 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 2e2:	0005c503          	lbu	a0,0(a1)
}
 2e6:	40a7853b          	subw	a0,a5,a0
 2ea:	6422                	ld	s0,8(sp)
 2ec:	0141                	addi	sp,sp,16
 2ee:	8082                	ret

00000000000002f0 <strlen>:

uint
strlen(const char *s)
{
 2f0:	1141                	addi	sp,sp,-16
 2f2:	e422                	sd	s0,8(sp)
 2f4:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2f6:	00054783          	lbu	a5,0(a0)
 2fa:	cf91                	beqz	a5,316 <strlen+0x26>
 2fc:	0505                	addi	a0,a0,1
 2fe:	87aa                	mv	a5,a0
 300:	4685                	li	a3,1
 302:	9e89                	subw	a3,a3,a0
 304:	00f6853b          	addw	a0,a3,a5
 308:	0785                	addi	a5,a5,1
 30a:	fff7c703          	lbu	a4,-1(a5)
 30e:	fb7d                	bnez	a4,304 <strlen+0x14>
    ;
  return n;
}
 310:	6422                	ld	s0,8(sp)
 312:	0141                	addi	sp,sp,16
 314:	8082                	ret
  for(n = 0; s[n]; n++)
 316:	4501                	li	a0,0
 318:	bfe5                	j	310 <strlen+0x20>

000000000000031a <memset>:

void*
memset(void *dst, int c, uint n)
{
 31a:	1141                	addi	sp,sp,-16
 31c:	e422                	sd	s0,8(sp)
 31e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 320:	ce09                	beqz	a2,33a <memset+0x20>
 322:	87aa                	mv	a5,a0
 324:	fff6071b          	addiw	a4,a2,-1
 328:	1702                	slli	a4,a4,0x20
 32a:	9301                	srli	a4,a4,0x20
 32c:	0705                	addi	a4,a4,1
 32e:	972a                	add	a4,a4,a0
    cdst[i] = c;
 330:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 334:	0785                	addi	a5,a5,1
 336:	fee79de3          	bne	a5,a4,330 <memset+0x16>
  }
  return dst;
}
 33a:	6422                	ld	s0,8(sp)
 33c:	0141                	addi	sp,sp,16
 33e:	8082                	ret

0000000000000340 <strchr>:

char*
strchr(const char *s, char c)
{
 340:	1141                	addi	sp,sp,-16
 342:	e422                	sd	s0,8(sp)
 344:	0800                	addi	s0,sp,16
  for(; *s; s++)
 346:	00054783          	lbu	a5,0(a0)
 34a:	cb99                	beqz	a5,360 <strchr+0x20>
    if(*s == c)
 34c:	00f58763          	beq	a1,a5,35a <strchr+0x1a>
  for(; *s; s++)
 350:	0505                	addi	a0,a0,1
 352:	00054783          	lbu	a5,0(a0)
 356:	fbfd                	bnez	a5,34c <strchr+0xc>
      return (char*)s;
  return 0;
 358:	4501                	li	a0,0
}
 35a:	6422                	ld	s0,8(sp)
 35c:	0141                	addi	sp,sp,16
 35e:	8082                	ret
  return 0;
 360:	4501                	li	a0,0
 362:	bfe5                	j	35a <strchr+0x1a>

0000000000000364 <gets>:

char*
gets(char *buf, int max)
{
 364:	711d                	addi	sp,sp,-96
 366:	ec86                	sd	ra,88(sp)
 368:	e8a2                	sd	s0,80(sp)
 36a:	e4a6                	sd	s1,72(sp)
 36c:	e0ca                	sd	s2,64(sp)
 36e:	fc4e                	sd	s3,56(sp)
 370:	f852                	sd	s4,48(sp)
 372:	f456                	sd	s5,40(sp)
 374:	f05a                	sd	s6,32(sp)
 376:	ec5e                	sd	s7,24(sp)
 378:	1080                	addi	s0,sp,96
 37a:	8baa                	mv	s7,a0
 37c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 37e:	892a                	mv	s2,a0
 380:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 382:	4aa9                	li	s5,10
 384:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 386:	89a6                	mv	s3,s1
 388:	2485                	addiw	s1,s1,1
 38a:	0344d863          	bge	s1,s4,3ba <gets+0x56>
    cc = read(0, &c, 1);
 38e:	4605                	li	a2,1
 390:	faf40593          	addi	a1,s0,-81
 394:	4501                	li	a0,0
 396:	00000097          	auipc	ra,0x0
 39a:	1a0080e7          	jalr	416(ra) # 536 <read>
    if(cc < 1)
 39e:	00a05e63          	blez	a0,3ba <gets+0x56>
    buf[i++] = c;
 3a2:	faf44783          	lbu	a5,-81(s0)
 3a6:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 3aa:	01578763          	beq	a5,s5,3b8 <gets+0x54>
 3ae:	0905                	addi	s2,s2,1
 3b0:	fd679be3          	bne	a5,s6,386 <gets+0x22>
  for(i=0; i+1 < max; ){
 3b4:	89a6                	mv	s3,s1
 3b6:	a011                	j	3ba <gets+0x56>
 3b8:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 3ba:	99de                	add	s3,s3,s7
 3bc:	00098023          	sb	zero,0(s3)
  return buf;
}
 3c0:	855e                	mv	a0,s7
 3c2:	60e6                	ld	ra,88(sp)
 3c4:	6446                	ld	s0,80(sp)
 3c6:	64a6                	ld	s1,72(sp)
 3c8:	6906                	ld	s2,64(sp)
 3ca:	79e2                	ld	s3,56(sp)
 3cc:	7a42                	ld	s4,48(sp)
 3ce:	7aa2                	ld	s5,40(sp)
 3d0:	7b02                	ld	s6,32(sp)
 3d2:	6be2                	ld	s7,24(sp)
 3d4:	6125                	addi	sp,sp,96
 3d6:	8082                	ret

00000000000003d8 <stat>:

int
stat(const char *n, struct stat *st)
{
 3d8:	1101                	addi	sp,sp,-32
 3da:	ec06                	sd	ra,24(sp)
 3dc:	e822                	sd	s0,16(sp)
 3de:	e426                	sd	s1,8(sp)
 3e0:	e04a                	sd	s2,0(sp)
 3e2:	1000                	addi	s0,sp,32
 3e4:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3e6:	4581                	li	a1,0
 3e8:	00000097          	auipc	ra,0x0
 3ec:	176080e7          	jalr	374(ra) # 55e <open>
  if(fd < 0)
 3f0:	02054563          	bltz	a0,41a <stat+0x42>
 3f4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3f6:	85ca                	mv	a1,s2
 3f8:	00000097          	auipc	ra,0x0
 3fc:	17e080e7          	jalr	382(ra) # 576 <fstat>
 400:	892a                	mv	s2,a0
  close(fd);
 402:	8526                	mv	a0,s1
 404:	00000097          	auipc	ra,0x0
 408:	142080e7          	jalr	322(ra) # 546 <close>
  return r;
}
 40c:	854a                	mv	a0,s2
 40e:	60e2                	ld	ra,24(sp)
 410:	6442                	ld	s0,16(sp)
 412:	64a2                	ld	s1,8(sp)
 414:	6902                	ld	s2,0(sp)
 416:	6105                	addi	sp,sp,32
 418:	8082                	ret
    return -1;
 41a:	597d                	li	s2,-1
 41c:	bfc5                	j	40c <stat+0x34>

000000000000041e <atoi>:

int
atoi(const char *s)
{
 41e:	1141                	addi	sp,sp,-16
 420:	e422                	sd	s0,8(sp)
 422:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 424:	00054603          	lbu	a2,0(a0)
 428:	fd06079b          	addiw	a5,a2,-48
 42c:	0ff7f793          	andi	a5,a5,255
 430:	4725                	li	a4,9
 432:	02f76963          	bltu	a4,a5,464 <atoi+0x46>
 436:	86aa                	mv	a3,a0
  n = 0;
 438:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 43a:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 43c:	0685                	addi	a3,a3,1
 43e:	0025179b          	slliw	a5,a0,0x2
 442:	9fa9                	addw	a5,a5,a0
 444:	0017979b          	slliw	a5,a5,0x1
 448:	9fb1                	addw	a5,a5,a2
 44a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 44e:	0006c603          	lbu	a2,0(a3)
 452:	fd06071b          	addiw	a4,a2,-48
 456:	0ff77713          	andi	a4,a4,255
 45a:	fee5f1e3          	bgeu	a1,a4,43c <atoi+0x1e>
  return n;
}
 45e:	6422                	ld	s0,8(sp)
 460:	0141                	addi	sp,sp,16
 462:	8082                	ret
  n = 0;
 464:	4501                	li	a0,0
 466:	bfe5                	j	45e <atoi+0x40>

0000000000000468 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 468:	1141                	addi	sp,sp,-16
 46a:	e422                	sd	s0,8(sp)
 46c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 46e:	02b57663          	bgeu	a0,a1,49a <memmove+0x32>
    while(n-- > 0)
 472:	02c05163          	blez	a2,494 <memmove+0x2c>
 476:	fff6079b          	addiw	a5,a2,-1
 47a:	1782                	slli	a5,a5,0x20
 47c:	9381                	srli	a5,a5,0x20
 47e:	0785                	addi	a5,a5,1
 480:	97aa                	add	a5,a5,a0
  dst = vdst;
 482:	872a                	mv	a4,a0
      *dst++ = *src++;
 484:	0585                	addi	a1,a1,1
 486:	0705                	addi	a4,a4,1
 488:	fff5c683          	lbu	a3,-1(a1)
 48c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 490:	fee79ae3          	bne	a5,a4,484 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 494:	6422                	ld	s0,8(sp)
 496:	0141                	addi	sp,sp,16
 498:	8082                	ret
    dst += n;
 49a:	00c50733          	add	a4,a0,a2
    src += n;
 49e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 4a0:	fec05ae3          	blez	a2,494 <memmove+0x2c>
 4a4:	fff6079b          	addiw	a5,a2,-1
 4a8:	1782                	slli	a5,a5,0x20
 4aa:	9381                	srli	a5,a5,0x20
 4ac:	fff7c793          	not	a5,a5
 4b0:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 4b2:	15fd                	addi	a1,a1,-1
 4b4:	177d                	addi	a4,a4,-1
 4b6:	0005c683          	lbu	a3,0(a1)
 4ba:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 4be:	fee79ae3          	bne	a5,a4,4b2 <memmove+0x4a>
 4c2:	bfc9                	j	494 <memmove+0x2c>

00000000000004c4 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 4c4:	1141                	addi	sp,sp,-16
 4c6:	e422                	sd	s0,8(sp)
 4c8:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 4ca:	ca05                	beqz	a2,4fa <memcmp+0x36>
 4cc:	fff6069b          	addiw	a3,a2,-1
 4d0:	1682                	slli	a3,a3,0x20
 4d2:	9281                	srli	a3,a3,0x20
 4d4:	0685                	addi	a3,a3,1
 4d6:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 4d8:	00054783          	lbu	a5,0(a0)
 4dc:	0005c703          	lbu	a4,0(a1)
 4e0:	00e79863          	bne	a5,a4,4f0 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 4e4:	0505                	addi	a0,a0,1
    p2++;
 4e6:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 4e8:	fed518e3          	bne	a0,a3,4d8 <memcmp+0x14>
  }
  return 0;
 4ec:	4501                	li	a0,0
 4ee:	a019                	j	4f4 <memcmp+0x30>
      return *p1 - *p2;
 4f0:	40e7853b          	subw	a0,a5,a4
}
 4f4:	6422                	ld	s0,8(sp)
 4f6:	0141                	addi	sp,sp,16
 4f8:	8082                	ret
  return 0;
 4fa:	4501                	li	a0,0
 4fc:	bfe5                	j	4f4 <memcmp+0x30>

00000000000004fe <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4fe:	1141                	addi	sp,sp,-16
 500:	e406                	sd	ra,8(sp)
 502:	e022                	sd	s0,0(sp)
 504:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 506:	00000097          	auipc	ra,0x0
 50a:	f62080e7          	jalr	-158(ra) # 468 <memmove>
}
 50e:	60a2                	ld	ra,8(sp)
 510:	6402                	ld	s0,0(sp)
 512:	0141                	addi	sp,sp,16
 514:	8082                	ret

0000000000000516 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 516:	4885                	li	a7,1
 ecall
 518:	00000073          	ecall
 ret
 51c:	8082                	ret

000000000000051e <exit>:
.global exit
exit:
 li a7, SYS_exit
 51e:	4889                	li	a7,2
 ecall
 520:	00000073          	ecall
 ret
 524:	8082                	ret

0000000000000526 <wait>:
.global wait
wait:
 li a7, SYS_wait
 526:	488d                	li	a7,3
 ecall
 528:	00000073          	ecall
 ret
 52c:	8082                	ret

000000000000052e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 52e:	4891                	li	a7,4
 ecall
 530:	00000073          	ecall
 ret
 534:	8082                	ret

0000000000000536 <read>:
.global read
read:
 li a7, SYS_read
 536:	4895                	li	a7,5
 ecall
 538:	00000073          	ecall
 ret
 53c:	8082                	ret

000000000000053e <write>:
.global write
write:
 li a7, SYS_write
 53e:	48c1                	li	a7,16
 ecall
 540:	00000073          	ecall
 ret
 544:	8082                	ret

0000000000000546 <close>:
.global close
close:
 li a7, SYS_close
 546:	48d5                	li	a7,21
 ecall
 548:	00000073          	ecall
 ret
 54c:	8082                	ret

000000000000054e <kill>:
.global kill
kill:
 li a7, SYS_kill
 54e:	4899                	li	a7,6
 ecall
 550:	00000073          	ecall
 ret
 554:	8082                	ret

0000000000000556 <exec>:
.global exec
exec:
 li a7, SYS_exec
 556:	489d                	li	a7,7
 ecall
 558:	00000073          	ecall
 ret
 55c:	8082                	ret

000000000000055e <open>:
.global open
open:
 li a7, SYS_open
 55e:	48bd                	li	a7,15
 ecall
 560:	00000073          	ecall
 ret
 564:	8082                	ret

0000000000000566 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 566:	48c5                	li	a7,17
 ecall
 568:	00000073          	ecall
 ret
 56c:	8082                	ret

000000000000056e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 56e:	48c9                	li	a7,18
 ecall
 570:	00000073          	ecall
 ret
 574:	8082                	ret

0000000000000576 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 576:	48a1                	li	a7,8
 ecall
 578:	00000073          	ecall
 ret
 57c:	8082                	ret

000000000000057e <link>:
.global link
link:
 li a7, SYS_link
 57e:	48cd                	li	a7,19
 ecall
 580:	00000073          	ecall
 ret
 584:	8082                	ret

0000000000000586 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 586:	48d1                	li	a7,20
 ecall
 588:	00000073          	ecall
 ret
 58c:	8082                	ret

000000000000058e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 58e:	48a5                	li	a7,9
 ecall
 590:	00000073          	ecall
 ret
 594:	8082                	ret

0000000000000596 <dup>:
.global dup
dup:
 li a7, SYS_dup
 596:	48a9                	li	a7,10
 ecall
 598:	00000073          	ecall
 ret
 59c:	8082                	ret

000000000000059e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 59e:	48ad                	li	a7,11
 ecall
 5a0:	00000073          	ecall
 ret
 5a4:	8082                	ret

00000000000005a6 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5a6:	48b1                	li	a7,12
 ecall
 5a8:	00000073          	ecall
 ret
 5ac:	8082                	ret

00000000000005ae <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 5ae:	48b5                	li	a7,13
 ecall
 5b0:	00000073          	ecall
 ret
 5b4:	8082                	ret

00000000000005b6 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5b6:	48b9                	li	a7,14
 ecall
 5b8:	00000073          	ecall
 ret
 5bc:	8082                	ret

00000000000005be <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5be:	1101                	addi	sp,sp,-32
 5c0:	ec06                	sd	ra,24(sp)
 5c2:	e822                	sd	s0,16(sp)
 5c4:	1000                	addi	s0,sp,32
 5c6:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5ca:	4605                	li	a2,1
 5cc:	fef40593          	addi	a1,s0,-17
 5d0:	00000097          	auipc	ra,0x0
 5d4:	f6e080e7          	jalr	-146(ra) # 53e <write>
}
 5d8:	60e2                	ld	ra,24(sp)
 5da:	6442                	ld	s0,16(sp)
 5dc:	6105                	addi	sp,sp,32
 5de:	8082                	ret

00000000000005e0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5e0:	7139                	addi	sp,sp,-64
 5e2:	fc06                	sd	ra,56(sp)
 5e4:	f822                	sd	s0,48(sp)
 5e6:	f426                	sd	s1,40(sp)
 5e8:	f04a                	sd	s2,32(sp)
 5ea:	ec4e                	sd	s3,24(sp)
 5ec:	0080                	addi	s0,sp,64
 5ee:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5f0:	c299                	beqz	a3,5f6 <printint+0x16>
 5f2:	0805c863          	bltz	a1,682 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5f6:	2581                	sext.w	a1,a1
  neg = 0;
 5f8:	4881                	li	a7,0
 5fa:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 5fe:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 600:	2601                	sext.w	a2,a2
 602:	00000517          	auipc	a0,0x0
 606:	4b650513          	addi	a0,a0,1206 # ab8 <digits>
 60a:	883a                	mv	a6,a4
 60c:	2705                	addiw	a4,a4,1
 60e:	02c5f7bb          	remuw	a5,a1,a2
 612:	1782                	slli	a5,a5,0x20
 614:	9381                	srli	a5,a5,0x20
 616:	97aa                	add	a5,a5,a0
 618:	0007c783          	lbu	a5,0(a5)
 61c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 620:	0005879b          	sext.w	a5,a1
 624:	02c5d5bb          	divuw	a1,a1,a2
 628:	0685                	addi	a3,a3,1
 62a:	fec7f0e3          	bgeu	a5,a2,60a <printint+0x2a>
  if(neg)
 62e:	00088b63          	beqz	a7,644 <printint+0x64>
    buf[i++] = '-';
 632:	fd040793          	addi	a5,s0,-48
 636:	973e                	add	a4,a4,a5
 638:	02d00793          	li	a5,45
 63c:	fef70823          	sb	a5,-16(a4)
 640:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 644:	02e05863          	blez	a4,674 <printint+0x94>
 648:	fc040793          	addi	a5,s0,-64
 64c:	00e78933          	add	s2,a5,a4
 650:	fff78993          	addi	s3,a5,-1
 654:	99ba                	add	s3,s3,a4
 656:	377d                	addiw	a4,a4,-1
 658:	1702                	slli	a4,a4,0x20
 65a:	9301                	srli	a4,a4,0x20
 65c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 660:	fff94583          	lbu	a1,-1(s2)
 664:	8526                	mv	a0,s1
 666:	00000097          	auipc	ra,0x0
 66a:	f58080e7          	jalr	-168(ra) # 5be <putc>
  while(--i >= 0)
 66e:	197d                	addi	s2,s2,-1
 670:	ff3918e3          	bne	s2,s3,660 <printint+0x80>
}
 674:	70e2                	ld	ra,56(sp)
 676:	7442                	ld	s0,48(sp)
 678:	74a2                	ld	s1,40(sp)
 67a:	7902                	ld	s2,32(sp)
 67c:	69e2                	ld	s3,24(sp)
 67e:	6121                	addi	sp,sp,64
 680:	8082                	ret
    x = -xx;
 682:	40b005bb          	negw	a1,a1
    neg = 1;
 686:	4885                	li	a7,1
    x = -xx;
 688:	bf8d                	j	5fa <printint+0x1a>

000000000000068a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 68a:	7119                	addi	sp,sp,-128
 68c:	fc86                	sd	ra,120(sp)
 68e:	f8a2                	sd	s0,112(sp)
 690:	f4a6                	sd	s1,104(sp)
 692:	f0ca                	sd	s2,96(sp)
 694:	ecce                	sd	s3,88(sp)
 696:	e8d2                	sd	s4,80(sp)
 698:	e4d6                	sd	s5,72(sp)
 69a:	e0da                	sd	s6,64(sp)
 69c:	fc5e                	sd	s7,56(sp)
 69e:	f862                	sd	s8,48(sp)
 6a0:	f466                	sd	s9,40(sp)
 6a2:	f06a                	sd	s10,32(sp)
 6a4:	ec6e                	sd	s11,24(sp)
 6a6:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 6a8:	0005c903          	lbu	s2,0(a1)
 6ac:	18090f63          	beqz	s2,84a <vprintf+0x1c0>
 6b0:	8aaa                	mv	s5,a0
 6b2:	8b32                	mv	s6,a2
 6b4:	00158493          	addi	s1,a1,1
  state = 0;
 6b8:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 6ba:	02500a13          	li	s4,37
      if(c == 'd'){
 6be:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 6c2:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 6c6:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 6ca:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6ce:	00000b97          	auipc	s7,0x0
 6d2:	3eab8b93          	addi	s7,s7,1002 # ab8 <digits>
 6d6:	a839                	j	6f4 <vprintf+0x6a>
        putc(fd, c);
 6d8:	85ca                	mv	a1,s2
 6da:	8556                	mv	a0,s5
 6dc:	00000097          	auipc	ra,0x0
 6e0:	ee2080e7          	jalr	-286(ra) # 5be <putc>
 6e4:	a019                	j	6ea <vprintf+0x60>
    } else if(state == '%'){
 6e6:	01498f63          	beq	s3,s4,704 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 6ea:	0485                	addi	s1,s1,1
 6ec:	fff4c903          	lbu	s2,-1(s1)
 6f0:	14090d63          	beqz	s2,84a <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 6f4:	0009079b          	sext.w	a5,s2
    if(state == 0){
 6f8:	fe0997e3          	bnez	s3,6e6 <vprintf+0x5c>
      if(c == '%'){
 6fc:	fd479ee3          	bne	a5,s4,6d8 <vprintf+0x4e>
        state = '%';
 700:	89be                	mv	s3,a5
 702:	b7e5                	j	6ea <vprintf+0x60>
      if(c == 'd'){
 704:	05878063          	beq	a5,s8,744 <vprintf+0xba>
      } else if(c == 'l') {
 708:	05978c63          	beq	a5,s9,760 <vprintf+0xd6>
      } else if(c == 'x') {
 70c:	07a78863          	beq	a5,s10,77c <vprintf+0xf2>
      } else if(c == 'p') {
 710:	09b78463          	beq	a5,s11,798 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 714:	07300713          	li	a4,115
 718:	0ce78663          	beq	a5,a4,7e4 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 71c:	06300713          	li	a4,99
 720:	0ee78e63          	beq	a5,a4,81c <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 724:	11478863          	beq	a5,s4,834 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 728:	85d2                	mv	a1,s4
 72a:	8556                	mv	a0,s5
 72c:	00000097          	auipc	ra,0x0
 730:	e92080e7          	jalr	-366(ra) # 5be <putc>
        putc(fd, c);
 734:	85ca                	mv	a1,s2
 736:	8556                	mv	a0,s5
 738:	00000097          	auipc	ra,0x0
 73c:	e86080e7          	jalr	-378(ra) # 5be <putc>
      }
      state = 0;
 740:	4981                	li	s3,0
 742:	b765                	j	6ea <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 744:	008b0913          	addi	s2,s6,8
 748:	4685                	li	a3,1
 74a:	4629                	li	a2,10
 74c:	000b2583          	lw	a1,0(s6)
 750:	8556                	mv	a0,s5
 752:	00000097          	auipc	ra,0x0
 756:	e8e080e7          	jalr	-370(ra) # 5e0 <printint>
 75a:	8b4a                	mv	s6,s2
      state = 0;
 75c:	4981                	li	s3,0
 75e:	b771                	j	6ea <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 760:	008b0913          	addi	s2,s6,8
 764:	4681                	li	a3,0
 766:	4629                	li	a2,10
 768:	000b2583          	lw	a1,0(s6)
 76c:	8556                	mv	a0,s5
 76e:	00000097          	auipc	ra,0x0
 772:	e72080e7          	jalr	-398(ra) # 5e0 <printint>
 776:	8b4a                	mv	s6,s2
      state = 0;
 778:	4981                	li	s3,0
 77a:	bf85                	j	6ea <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 77c:	008b0913          	addi	s2,s6,8
 780:	4681                	li	a3,0
 782:	4641                	li	a2,16
 784:	000b2583          	lw	a1,0(s6)
 788:	8556                	mv	a0,s5
 78a:	00000097          	auipc	ra,0x0
 78e:	e56080e7          	jalr	-426(ra) # 5e0 <printint>
 792:	8b4a                	mv	s6,s2
      state = 0;
 794:	4981                	li	s3,0
 796:	bf91                	j	6ea <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 798:	008b0793          	addi	a5,s6,8
 79c:	f8f43423          	sd	a5,-120(s0)
 7a0:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 7a4:	03000593          	li	a1,48
 7a8:	8556                	mv	a0,s5
 7aa:	00000097          	auipc	ra,0x0
 7ae:	e14080e7          	jalr	-492(ra) # 5be <putc>
  putc(fd, 'x');
 7b2:	85ea                	mv	a1,s10
 7b4:	8556                	mv	a0,s5
 7b6:	00000097          	auipc	ra,0x0
 7ba:	e08080e7          	jalr	-504(ra) # 5be <putc>
 7be:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7c0:	03c9d793          	srli	a5,s3,0x3c
 7c4:	97de                	add	a5,a5,s7
 7c6:	0007c583          	lbu	a1,0(a5)
 7ca:	8556                	mv	a0,s5
 7cc:	00000097          	auipc	ra,0x0
 7d0:	df2080e7          	jalr	-526(ra) # 5be <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7d4:	0992                	slli	s3,s3,0x4
 7d6:	397d                	addiw	s2,s2,-1
 7d8:	fe0914e3          	bnez	s2,7c0 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 7dc:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 7e0:	4981                	li	s3,0
 7e2:	b721                	j	6ea <vprintf+0x60>
        s = va_arg(ap, char*);
 7e4:	008b0993          	addi	s3,s6,8
 7e8:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 7ec:	02090163          	beqz	s2,80e <vprintf+0x184>
        while(*s != 0){
 7f0:	00094583          	lbu	a1,0(s2)
 7f4:	c9a1                	beqz	a1,844 <vprintf+0x1ba>
          putc(fd, *s);
 7f6:	8556                	mv	a0,s5
 7f8:	00000097          	auipc	ra,0x0
 7fc:	dc6080e7          	jalr	-570(ra) # 5be <putc>
          s++;
 800:	0905                	addi	s2,s2,1
        while(*s != 0){
 802:	00094583          	lbu	a1,0(s2)
 806:	f9e5                	bnez	a1,7f6 <vprintf+0x16c>
        s = va_arg(ap, char*);
 808:	8b4e                	mv	s6,s3
      state = 0;
 80a:	4981                	li	s3,0
 80c:	bdf9                	j	6ea <vprintf+0x60>
          s = "(null)";
 80e:	00000917          	auipc	s2,0x0
 812:	2a290913          	addi	s2,s2,674 # ab0 <malloc+0x15c>
        while(*s != 0){
 816:	02800593          	li	a1,40
 81a:	bff1                	j	7f6 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 81c:	008b0913          	addi	s2,s6,8
 820:	000b4583          	lbu	a1,0(s6)
 824:	8556                	mv	a0,s5
 826:	00000097          	auipc	ra,0x0
 82a:	d98080e7          	jalr	-616(ra) # 5be <putc>
 82e:	8b4a                	mv	s6,s2
      state = 0;
 830:	4981                	li	s3,0
 832:	bd65                	j	6ea <vprintf+0x60>
        putc(fd, c);
 834:	85d2                	mv	a1,s4
 836:	8556                	mv	a0,s5
 838:	00000097          	auipc	ra,0x0
 83c:	d86080e7          	jalr	-634(ra) # 5be <putc>
      state = 0;
 840:	4981                	li	s3,0
 842:	b565                	j	6ea <vprintf+0x60>
        s = va_arg(ap, char*);
 844:	8b4e                	mv	s6,s3
      state = 0;
 846:	4981                	li	s3,0
 848:	b54d                	j	6ea <vprintf+0x60>
    }
  }
}
 84a:	70e6                	ld	ra,120(sp)
 84c:	7446                	ld	s0,112(sp)
 84e:	74a6                	ld	s1,104(sp)
 850:	7906                	ld	s2,96(sp)
 852:	69e6                	ld	s3,88(sp)
 854:	6a46                	ld	s4,80(sp)
 856:	6aa6                	ld	s5,72(sp)
 858:	6b06                	ld	s6,64(sp)
 85a:	7be2                	ld	s7,56(sp)
 85c:	7c42                	ld	s8,48(sp)
 85e:	7ca2                	ld	s9,40(sp)
 860:	7d02                	ld	s10,32(sp)
 862:	6de2                	ld	s11,24(sp)
 864:	6109                	addi	sp,sp,128
 866:	8082                	ret

0000000000000868 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 868:	715d                	addi	sp,sp,-80
 86a:	ec06                	sd	ra,24(sp)
 86c:	e822                	sd	s0,16(sp)
 86e:	1000                	addi	s0,sp,32
 870:	e010                	sd	a2,0(s0)
 872:	e414                	sd	a3,8(s0)
 874:	e818                	sd	a4,16(s0)
 876:	ec1c                	sd	a5,24(s0)
 878:	03043023          	sd	a6,32(s0)
 87c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 880:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 884:	8622                	mv	a2,s0
 886:	00000097          	auipc	ra,0x0
 88a:	e04080e7          	jalr	-508(ra) # 68a <vprintf>
}
 88e:	60e2                	ld	ra,24(sp)
 890:	6442                	ld	s0,16(sp)
 892:	6161                	addi	sp,sp,80
 894:	8082                	ret

0000000000000896 <printf>:

void
printf(const char *fmt, ...)
{
 896:	711d                	addi	sp,sp,-96
 898:	ec06                	sd	ra,24(sp)
 89a:	e822                	sd	s0,16(sp)
 89c:	1000                	addi	s0,sp,32
 89e:	e40c                	sd	a1,8(s0)
 8a0:	e810                	sd	a2,16(s0)
 8a2:	ec14                	sd	a3,24(s0)
 8a4:	f018                	sd	a4,32(s0)
 8a6:	f41c                	sd	a5,40(s0)
 8a8:	03043823          	sd	a6,48(s0)
 8ac:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8b0:	00840613          	addi	a2,s0,8
 8b4:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8b8:	85aa                	mv	a1,a0
 8ba:	4505                	li	a0,1
 8bc:	00000097          	auipc	ra,0x0
 8c0:	dce080e7          	jalr	-562(ra) # 68a <vprintf>
}
 8c4:	60e2                	ld	ra,24(sp)
 8c6:	6442                	ld	s0,16(sp)
 8c8:	6125                	addi	sp,sp,96
 8ca:	8082                	ret

00000000000008cc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8cc:	1141                	addi	sp,sp,-16
 8ce:	e422                	sd	s0,8(sp)
 8d0:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8d2:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8d6:	00000797          	auipc	a5,0x0
 8da:	72a7b783          	ld	a5,1834(a5) # 1000 <freep>
 8de:	a805                	j	90e <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8e0:	4618                	lw	a4,8(a2)
 8e2:	9db9                	addw	a1,a1,a4
 8e4:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8e8:	6398                	ld	a4,0(a5)
 8ea:	6318                	ld	a4,0(a4)
 8ec:	fee53823          	sd	a4,-16(a0)
 8f0:	a091                	j	934 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8f2:	ff852703          	lw	a4,-8(a0)
 8f6:	9e39                	addw	a2,a2,a4
 8f8:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 8fa:	ff053703          	ld	a4,-16(a0)
 8fe:	e398                	sd	a4,0(a5)
 900:	a099                	j	946 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 902:	6398                	ld	a4,0(a5)
 904:	00e7e463          	bltu	a5,a4,90c <free+0x40>
 908:	00e6ea63          	bltu	a3,a4,91c <free+0x50>
{
 90c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 90e:	fed7fae3          	bgeu	a5,a3,902 <free+0x36>
 912:	6398                	ld	a4,0(a5)
 914:	00e6e463          	bltu	a3,a4,91c <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 918:	fee7eae3          	bltu	a5,a4,90c <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 91c:	ff852583          	lw	a1,-8(a0)
 920:	6390                	ld	a2,0(a5)
 922:	02059713          	slli	a4,a1,0x20
 926:	9301                	srli	a4,a4,0x20
 928:	0712                	slli	a4,a4,0x4
 92a:	9736                	add	a4,a4,a3
 92c:	fae60ae3          	beq	a2,a4,8e0 <free+0x14>
    bp->s.ptr = p->s.ptr;
 930:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 934:	4790                	lw	a2,8(a5)
 936:	02061713          	slli	a4,a2,0x20
 93a:	9301                	srli	a4,a4,0x20
 93c:	0712                	slli	a4,a4,0x4
 93e:	973e                	add	a4,a4,a5
 940:	fae689e3          	beq	a3,a4,8f2 <free+0x26>
  } else
    p->s.ptr = bp;
 944:	e394                	sd	a3,0(a5)
  freep = p;
 946:	00000717          	auipc	a4,0x0
 94a:	6af73d23          	sd	a5,1722(a4) # 1000 <freep>
}
 94e:	6422                	ld	s0,8(sp)
 950:	0141                	addi	sp,sp,16
 952:	8082                	ret

0000000000000954 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 954:	7139                	addi	sp,sp,-64
 956:	fc06                	sd	ra,56(sp)
 958:	f822                	sd	s0,48(sp)
 95a:	f426                	sd	s1,40(sp)
 95c:	f04a                	sd	s2,32(sp)
 95e:	ec4e                	sd	s3,24(sp)
 960:	e852                	sd	s4,16(sp)
 962:	e456                	sd	s5,8(sp)
 964:	e05a                	sd	s6,0(sp)
 966:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 968:	02051493          	slli	s1,a0,0x20
 96c:	9081                	srli	s1,s1,0x20
 96e:	04bd                	addi	s1,s1,15
 970:	8091                	srli	s1,s1,0x4
 972:	0014899b          	addiw	s3,s1,1
 976:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 978:	00000517          	auipc	a0,0x0
 97c:	68853503          	ld	a0,1672(a0) # 1000 <freep>
 980:	c515                	beqz	a0,9ac <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 982:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 984:	4798                	lw	a4,8(a5)
 986:	02977f63          	bgeu	a4,s1,9c4 <malloc+0x70>
 98a:	8a4e                	mv	s4,s3
 98c:	0009871b          	sext.w	a4,s3
 990:	6685                	lui	a3,0x1
 992:	00d77363          	bgeu	a4,a3,998 <malloc+0x44>
 996:	6a05                	lui	s4,0x1
 998:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 99c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9a0:	00000917          	auipc	s2,0x0
 9a4:	66090913          	addi	s2,s2,1632 # 1000 <freep>
  if(p == (char*)-1)
 9a8:	5afd                	li	s5,-1
 9aa:	a88d                	j	a1c <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 9ac:	00000797          	auipc	a5,0x0
 9b0:	66478793          	addi	a5,a5,1636 # 1010 <base>
 9b4:	00000717          	auipc	a4,0x0
 9b8:	64f73623          	sd	a5,1612(a4) # 1000 <freep>
 9bc:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9be:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9c2:	b7e1                	j	98a <malloc+0x36>
      if(p->s.size == nunits)
 9c4:	02e48b63          	beq	s1,a4,9fa <malloc+0xa6>
        p->s.size -= nunits;
 9c8:	4137073b          	subw	a4,a4,s3
 9cc:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9ce:	1702                	slli	a4,a4,0x20
 9d0:	9301                	srli	a4,a4,0x20
 9d2:	0712                	slli	a4,a4,0x4
 9d4:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9d6:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9da:	00000717          	auipc	a4,0x0
 9de:	62a73323          	sd	a0,1574(a4) # 1000 <freep>
      return (void*)(p + 1);
 9e2:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 9e6:	70e2                	ld	ra,56(sp)
 9e8:	7442                	ld	s0,48(sp)
 9ea:	74a2                	ld	s1,40(sp)
 9ec:	7902                	ld	s2,32(sp)
 9ee:	69e2                	ld	s3,24(sp)
 9f0:	6a42                	ld	s4,16(sp)
 9f2:	6aa2                	ld	s5,8(sp)
 9f4:	6b02                	ld	s6,0(sp)
 9f6:	6121                	addi	sp,sp,64
 9f8:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 9fa:	6398                	ld	a4,0(a5)
 9fc:	e118                	sd	a4,0(a0)
 9fe:	bff1                	j	9da <malloc+0x86>
  hp->s.size = nu;
 a00:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a04:	0541                	addi	a0,a0,16
 a06:	00000097          	auipc	ra,0x0
 a0a:	ec6080e7          	jalr	-314(ra) # 8cc <free>
  return freep;
 a0e:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a12:	d971                	beqz	a0,9e6 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a14:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a16:	4798                	lw	a4,8(a5)
 a18:	fa9776e3          	bgeu	a4,s1,9c4 <malloc+0x70>
    if(p == freep)
 a1c:	00093703          	ld	a4,0(s2)
 a20:	853e                	mv	a0,a5
 a22:	fef719e3          	bne	a4,a5,a14 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 a26:	8552                	mv	a0,s4
 a28:	00000097          	auipc	ra,0x0
 a2c:	b7e080e7          	jalr	-1154(ra) # 5a6 <sbrk>
  if(p == (char*)-1)
 a30:	fd5518e3          	bne	a0,s5,a00 <malloc+0xac>
        return 0;
 a34:	4501                	li	a0,0
 a36:	bf45                	j	9e6 <malloc+0x92>
