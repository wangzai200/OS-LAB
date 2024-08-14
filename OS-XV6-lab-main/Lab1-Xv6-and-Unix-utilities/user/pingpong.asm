
user/_pingpong:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(int argc, char *argv[])
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	1800                	addi	s0,sp,48
    // 确保没有提供不必要的命令行参数
    if (argc > 1) {
   8:	4785                	li	a5,1
   a:	02a7d063          	bge	a5,a0,2a <main+0x2a>
        fprintf(2, "No argument is needed!\n");
   e:	00001597          	auipc	a1,0x1
  12:	9b258593          	addi	a1,a1,-1614 # 9c0 <malloc+0xe4>
  16:	4509                	li	a0,2
  18:	00000097          	auipc	ra,0x0
  1c:	7d8080e7          	jalr	2008(ra) # 7f0 <fprintf>
        exit(1);
  20:	4505                	li	a0,1
  22:	00000097          	auipc	ra,0x0
  26:	484080e7          	jalr	1156(ra) # 4a6 <exit>

    int parent2child[2], child2parent[2]; // 分别代表父到子和子到父的管道  0是读端 1是写端
    char buf[5]; // 只需要足够的空间存储 "ping" 或 "pong"

    // 创建两个管道
    if (pipe(parent2child) < 0 || pipe(child2parent) < 0) {
  2a:	fe840513          	addi	a0,s0,-24
  2e:	00000097          	auipc	ra,0x0
  32:	488080e7          	jalr	1160(ra) # 4b6 <pipe>
  36:	00054a63          	bltz	a0,4a <main+0x4a>
  3a:	fe040513          	addi	a0,s0,-32
  3e:	00000097          	auipc	ra,0x0
  42:	478080e7          	jalr	1144(ra) # 4b6 <pipe>
  46:	00055f63          	bgez	a0,64 <main+0x64>
        printf("pipe creation failed\n");
  4a:	00001517          	auipc	a0,0x1
  4e:	98e50513          	addi	a0,a0,-1650 # 9d8 <malloc+0xfc>
  52:	00000097          	auipc	ra,0x0
  56:	7cc080e7          	jalr	1996(ra) # 81e <printf>
        exit(1);
  5a:	4505                	li	a0,1
  5c:	00000097          	auipc	ra,0x0
  60:	44a080e7          	jalr	1098(ra) # 4a6 <exit>
    }
    // 在父进程中，fork() 返回新创建的子进程的进程ID（PID），这个值大于0。
    // 在子进程中，fork() 返回0。
    int pid = fork();
  64:	00000097          	auipc	ra,0x0
  68:	43a080e7          	jalr	1082(ra) # 49e <fork>

    if (pid < 0) {
  6c:	04054863          	bltz	a0,bc <main+0xbc>
        printf("fork failed\n");
        exit(1);
    }

    if (pid == 0) { // 子进程代码
  70:	ed71                	bnez	a0,14c <main+0x14c>
        close(parent2child[1]); // 关闭不需要的写端
  72:	fec42503          	lw	a0,-20(s0)
  76:	00000097          	auipc	ra,0x0
  7a:	458080e7          	jalr	1112(ra) # 4ce <close>
        close(child2parent[0]); // 关闭不需要的读端
  7e:	fe042503          	lw	a0,-32(s0)
  82:	00000097          	auipc	ra,0x0
  86:	44c080e7          	jalr	1100(ra) # 4ce <close>

        // 从父进程读取字节
        if (read(parent2child[0], buf, sizeof(buf)) != 4) {
  8a:	4615                	li	a2,5
  8c:	fd840593          	addi	a1,s0,-40
  90:	fe842503          	lw	a0,-24(s0)
  94:	00000097          	auipc	ra,0x0
  98:	42a080e7          	jalr	1066(ra) # 4be <read>
  9c:	4791                	li	a5,4
  9e:	02f50c63          	beq	a0,a5,d6 <main+0xd6>
            printf("child process read failed\n");
  a2:	00001517          	auipc	a0,0x1
  a6:	95e50513          	addi	a0,a0,-1698 # a00 <malloc+0x124>
  aa:	00000097          	auipc	ra,0x0
  ae:	774080e7          	jalr	1908(ra) # 81e <printf>
            exit(1);
  b2:	4505                	li	a0,1
  b4:	00000097          	auipc	ra,0x0
  b8:	3f2080e7          	jalr	1010(ra) # 4a6 <exit>
        printf("fork failed\n");
  bc:	00001517          	auipc	a0,0x1
  c0:	93450513          	addi	a0,a0,-1740 # 9f0 <malloc+0x114>
  c4:	00000097          	auipc	ra,0x0
  c8:	75a080e7          	jalr	1882(ra) # 81e <printf>
        exit(1);
  cc:	4505                	li	a0,1
  ce:	00000097          	auipc	ra,0x0
  d2:	3d8080e7          	jalr	984(ra) # 4a6 <exit>
        }
        printf("%d: received %s\n", getpid(), buf);
  d6:	00000097          	auipc	ra,0x0
  da:	450080e7          	jalr	1104(ra) # 526 <getpid>
  de:	85aa                	mv	a1,a0
  e0:	fd840613          	addi	a2,s0,-40
  e4:	00001517          	auipc	a0,0x1
  e8:	93c50513          	addi	a0,a0,-1732 # a20 <malloc+0x144>
  ec:	00000097          	auipc	ra,0x0
  f0:	732080e7          	jalr	1842(ra) # 81e <printf>
        close(parent2child[0]); // 关闭读端
  f4:	fe842503          	lw	a0,-24(s0)
  f8:	00000097          	auipc	ra,0x0
  fc:	3d6080e7          	jalr	982(ra) # 4ce <close>

        // 回应父进程
        if (write(child2parent[1], "pong", 4) != 4) {
 100:	4611                	li	a2,4
 102:	00001597          	auipc	a1,0x1
 106:	93658593          	addi	a1,a1,-1738 # a38 <malloc+0x15c>
 10a:	fe442503          	lw	a0,-28(s0)
 10e:	00000097          	auipc	ra,0x0
 112:	3b8080e7          	jalr	952(ra) # 4c6 <write>
 116:	4791                	li	a5,4
 118:	00f50f63          	beq	a0,a5,136 <main+0x136>
            printf("child process write failed\n");
 11c:	00001517          	auipc	a0,0x1
 120:	92450513          	addi	a0,a0,-1756 # a40 <malloc+0x164>
 124:	00000097          	auipc	ra,0x0
 128:	6fa080e7          	jalr	1786(ra) # 81e <printf>
            exit(1);
 12c:	4505                	li	a0,1
 12e:	00000097          	auipc	ra,0x0
 132:	378080e7          	jalr	888(ra) # 4a6 <exit>
        }
        close(child2parent[1]); // 关闭写端
 136:	fe442503          	lw	a0,-28(s0)
 13a:	00000097          	auipc	ra,0x0
 13e:	394080e7          	jalr	916(ra) # 4ce <close>
        exit(0);
 142:	4501                	li	a0,0
 144:	00000097          	auipc	ra,0x0
 148:	362080e7          	jalr	866(ra) # 4a6 <exit>
    } else { // 父进程代码
        close(parent2child[0]); // 关闭不需要的读端
 14c:	fe842503          	lw	a0,-24(s0)
 150:	00000097          	auipc	ra,0x0
 154:	37e080e7          	jalr	894(ra) # 4ce <close>
        close(child2parent[1]); // 关闭不需要的写端
 158:	fe442503          	lw	a0,-28(s0)
 15c:	00000097          	auipc	ra,0x0
 160:	372080e7          	jalr	882(ra) # 4ce <close>

        // 向子进程发送字节
        if (write(parent2child[1], "ping", 4) != 4) {
 164:	4611                	li	a2,4
 166:	00001597          	auipc	a1,0x1
 16a:	8fa58593          	addi	a1,a1,-1798 # a60 <malloc+0x184>
 16e:	fec42503          	lw	a0,-20(s0)
 172:	00000097          	auipc	ra,0x0
 176:	354080e7          	jalr	852(ra) # 4c6 <write>
 17a:	4791                	li	a5,4
 17c:	00f50f63          	beq	a0,a5,19a <main+0x19a>
            printf("parent process write failed\n");
 180:	00001517          	auipc	a0,0x1
 184:	8e850513          	addi	a0,a0,-1816 # a68 <malloc+0x18c>
 188:	00000097          	auipc	ra,0x0
 18c:	696080e7          	jalr	1686(ra) # 81e <printf>
            exit(1);
 190:	4505                	li	a0,1
 192:	00000097          	auipc	ra,0x0
 196:	314080e7          	jalr	788(ra) # 4a6 <exit>
        }
        close(parent2child[1]); // 关闭写端
 19a:	fec42503          	lw	a0,-20(s0)
 19e:	00000097          	auipc	ra,0x0
 1a2:	330080e7          	jalr	816(ra) # 4ce <close>

        // 等待子进程结束
        wait(0);
 1a6:	4501                	li	a0,0
 1a8:	00000097          	auipc	ra,0x0
 1ac:	306080e7          	jalr	774(ra) # 4ae <wait>

        // 从子进程读取字节
        if (read(child2parent[0], buf, sizeof(buf)) != 4) {
 1b0:	4615                	li	a2,5
 1b2:	fd840593          	addi	a1,s0,-40
 1b6:	fe042503          	lw	a0,-32(s0)
 1ba:	00000097          	auipc	ra,0x0
 1be:	304080e7          	jalr	772(ra) # 4be <read>
 1c2:	4791                	li	a5,4
 1c4:	00f50f63          	beq	a0,a5,1e2 <main+0x1e2>
            printf("parent process read failed\n");
 1c8:	00001517          	auipc	a0,0x1
 1cc:	8c050513          	addi	a0,a0,-1856 # a88 <malloc+0x1ac>
 1d0:	00000097          	auipc	ra,0x0
 1d4:	64e080e7          	jalr	1614(ra) # 81e <printf>
            exit(1);
 1d8:	4505                	li	a0,1
 1da:	00000097          	auipc	ra,0x0
 1de:	2cc080e7          	jalr	716(ra) # 4a6 <exit>
        }
        printf("%d: received %s\n", getpid(), buf);
 1e2:	00000097          	auipc	ra,0x0
 1e6:	344080e7          	jalr	836(ra) # 526 <getpid>
 1ea:	85aa                	mv	a1,a0
 1ec:	fd840613          	addi	a2,s0,-40
 1f0:	00001517          	auipc	a0,0x1
 1f4:	83050513          	addi	a0,a0,-2000 # a20 <malloc+0x144>
 1f8:	00000097          	auipc	ra,0x0
 1fc:	626080e7          	jalr	1574(ra) # 81e <printf>
        close(child2parent[0]); // 关闭读端
 200:	fe042503          	lw	a0,-32(s0)
 204:	00000097          	auipc	ra,0x0
 208:	2ca080e7          	jalr	714(ra) # 4ce <close>

        exit(0);
 20c:	4501                	li	a0,0
 20e:	00000097          	auipc	ra,0x0
 212:	298080e7          	jalr	664(ra) # 4a6 <exit>

0000000000000216 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 216:	1141                	addi	sp,sp,-16
 218:	e406                	sd	ra,8(sp)
 21a:	e022                	sd	s0,0(sp)
 21c:	0800                	addi	s0,sp,16
  extern int main();
  main();
 21e:	00000097          	auipc	ra,0x0
 222:	de2080e7          	jalr	-542(ra) # 0 <main>
  exit(0);
 226:	4501                	li	a0,0
 228:	00000097          	auipc	ra,0x0
 22c:	27e080e7          	jalr	638(ra) # 4a6 <exit>

0000000000000230 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 230:	1141                	addi	sp,sp,-16
 232:	e422                	sd	s0,8(sp)
 234:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 236:	87aa                	mv	a5,a0
 238:	0585                	addi	a1,a1,1
 23a:	0785                	addi	a5,a5,1
 23c:	fff5c703          	lbu	a4,-1(a1)
 240:	fee78fa3          	sb	a4,-1(a5)
 244:	fb75                	bnez	a4,238 <strcpy+0x8>
    ;
  return os;
}
 246:	6422                	ld	s0,8(sp)
 248:	0141                	addi	sp,sp,16
 24a:	8082                	ret

000000000000024c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 24c:	1141                	addi	sp,sp,-16
 24e:	e422                	sd	s0,8(sp)
 250:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 252:	00054783          	lbu	a5,0(a0)
 256:	cb91                	beqz	a5,26a <strcmp+0x1e>
 258:	0005c703          	lbu	a4,0(a1)
 25c:	00f71763          	bne	a4,a5,26a <strcmp+0x1e>
    p++, q++;
 260:	0505                	addi	a0,a0,1
 262:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 264:	00054783          	lbu	a5,0(a0)
 268:	fbe5                	bnez	a5,258 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 26a:	0005c503          	lbu	a0,0(a1)
}
 26e:	40a7853b          	subw	a0,a5,a0
 272:	6422                	ld	s0,8(sp)
 274:	0141                	addi	sp,sp,16
 276:	8082                	ret

0000000000000278 <strlen>:

uint
strlen(const char *s)
{
 278:	1141                	addi	sp,sp,-16
 27a:	e422                	sd	s0,8(sp)
 27c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 27e:	00054783          	lbu	a5,0(a0)
 282:	cf91                	beqz	a5,29e <strlen+0x26>
 284:	0505                	addi	a0,a0,1
 286:	87aa                	mv	a5,a0
 288:	4685                	li	a3,1
 28a:	9e89                	subw	a3,a3,a0
 28c:	00f6853b          	addw	a0,a3,a5
 290:	0785                	addi	a5,a5,1
 292:	fff7c703          	lbu	a4,-1(a5)
 296:	fb7d                	bnez	a4,28c <strlen+0x14>
    ;
  return n;
}
 298:	6422                	ld	s0,8(sp)
 29a:	0141                	addi	sp,sp,16
 29c:	8082                	ret
  for(n = 0; s[n]; n++)
 29e:	4501                	li	a0,0
 2a0:	bfe5                	j	298 <strlen+0x20>

00000000000002a2 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2a2:	1141                	addi	sp,sp,-16
 2a4:	e422                	sd	s0,8(sp)
 2a6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 2a8:	ce09                	beqz	a2,2c2 <memset+0x20>
 2aa:	87aa                	mv	a5,a0
 2ac:	fff6071b          	addiw	a4,a2,-1
 2b0:	1702                	slli	a4,a4,0x20
 2b2:	9301                	srli	a4,a4,0x20
 2b4:	0705                	addi	a4,a4,1
 2b6:	972a                	add	a4,a4,a0
    cdst[i] = c;
 2b8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 2bc:	0785                	addi	a5,a5,1
 2be:	fee79de3          	bne	a5,a4,2b8 <memset+0x16>
  }
  return dst;
}
 2c2:	6422                	ld	s0,8(sp)
 2c4:	0141                	addi	sp,sp,16
 2c6:	8082                	ret

00000000000002c8 <strchr>:

char*
strchr(const char *s, char c)
{
 2c8:	1141                	addi	sp,sp,-16
 2ca:	e422                	sd	s0,8(sp)
 2cc:	0800                	addi	s0,sp,16
  for(; *s; s++)
 2ce:	00054783          	lbu	a5,0(a0)
 2d2:	cb99                	beqz	a5,2e8 <strchr+0x20>
    if(*s == c)
 2d4:	00f58763          	beq	a1,a5,2e2 <strchr+0x1a>
  for(; *s; s++)
 2d8:	0505                	addi	a0,a0,1
 2da:	00054783          	lbu	a5,0(a0)
 2de:	fbfd                	bnez	a5,2d4 <strchr+0xc>
      return (char*)s;
  return 0;
 2e0:	4501                	li	a0,0
}
 2e2:	6422                	ld	s0,8(sp)
 2e4:	0141                	addi	sp,sp,16
 2e6:	8082                	ret
  return 0;
 2e8:	4501                	li	a0,0
 2ea:	bfe5                	j	2e2 <strchr+0x1a>

00000000000002ec <gets>:

char*
gets(char *buf, int max)
{
 2ec:	711d                	addi	sp,sp,-96
 2ee:	ec86                	sd	ra,88(sp)
 2f0:	e8a2                	sd	s0,80(sp)
 2f2:	e4a6                	sd	s1,72(sp)
 2f4:	e0ca                	sd	s2,64(sp)
 2f6:	fc4e                	sd	s3,56(sp)
 2f8:	f852                	sd	s4,48(sp)
 2fa:	f456                	sd	s5,40(sp)
 2fc:	f05a                	sd	s6,32(sp)
 2fe:	ec5e                	sd	s7,24(sp)
 300:	1080                	addi	s0,sp,96
 302:	8baa                	mv	s7,a0
 304:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 306:	892a                	mv	s2,a0
 308:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 30a:	4aa9                	li	s5,10
 30c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 30e:	89a6                	mv	s3,s1
 310:	2485                	addiw	s1,s1,1
 312:	0344d863          	bge	s1,s4,342 <gets+0x56>
    cc = read(0, &c, 1);
 316:	4605                	li	a2,1
 318:	faf40593          	addi	a1,s0,-81
 31c:	4501                	li	a0,0
 31e:	00000097          	auipc	ra,0x0
 322:	1a0080e7          	jalr	416(ra) # 4be <read>
    if(cc < 1)
 326:	00a05e63          	blez	a0,342 <gets+0x56>
    buf[i++] = c;
 32a:	faf44783          	lbu	a5,-81(s0)
 32e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 332:	01578763          	beq	a5,s5,340 <gets+0x54>
 336:	0905                	addi	s2,s2,1
 338:	fd679be3          	bne	a5,s6,30e <gets+0x22>
  for(i=0; i+1 < max; ){
 33c:	89a6                	mv	s3,s1
 33e:	a011                	j	342 <gets+0x56>
 340:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 342:	99de                	add	s3,s3,s7
 344:	00098023          	sb	zero,0(s3)
  return buf;
}
 348:	855e                	mv	a0,s7
 34a:	60e6                	ld	ra,88(sp)
 34c:	6446                	ld	s0,80(sp)
 34e:	64a6                	ld	s1,72(sp)
 350:	6906                	ld	s2,64(sp)
 352:	79e2                	ld	s3,56(sp)
 354:	7a42                	ld	s4,48(sp)
 356:	7aa2                	ld	s5,40(sp)
 358:	7b02                	ld	s6,32(sp)
 35a:	6be2                	ld	s7,24(sp)
 35c:	6125                	addi	sp,sp,96
 35e:	8082                	ret

0000000000000360 <stat>:

int
stat(const char *n, struct stat *st)
{
 360:	1101                	addi	sp,sp,-32
 362:	ec06                	sd	ra,24(sp)
 364:	e822                	sd	s0,16(sp)
 366:	e426                	sd	s1,8(sp)
 368:	e04a                	sd	s2,0(sp)
 36a:	1000                	addi	s0,sp,32
 36c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 36e:	4581                	li	a1,0
 370:	00000097          	auipc	ra,0x0
 374:	176080e7          	jalr	374(ra) # 4e6 <open>
  if(fd < 0)
 378:	02054563          	bltz	a0,3a2 <stat+0x42>
 37c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 37e:	85ca                	mv	a1,s2
 380:	00000097          	auipc	ra,0x0
 384:	17e080e7          	jalr	382(ra) # 4fe <fstat>
 388:	892a                	mv	s2,a0
  close(fd);
 38a:	8526                	mv	a0,s1
 38c:	00000097          	auipc	ra,0x0
 390:	142080e7          	jalr	322(ra) # 4ce <close>
  return r;
}
 394:	854a                	mv	a0,s2
 396:	60e2                	ld	ra,24(sp)
 398:	6442                	ld	s0,16(sp)
 39a:	64a2                	ld	s1,8(sp)
 39c:	6902                	ld	s2,0(sp)
 39e:	6105                	addi	sp,sp,32
 3a0:	8082                	ret
    return -1;
 3a2:	597d                	li	s2,-1
 3a4:	bfc5                	j	394 <stat+0x34>

00000000000003a6 <atoi>:

int
atoi(const char *s)
{
 3a6:	1141                	addi	sp,sp,-16
 3a8:	e422                	sd	s0,8(sp)
 3aa:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3ac:	00054603          	lbu	a2,0(a0)
 3b0:	fd06079b          	addiw	a5,a2,-48
 3b4:	0ff7f793          	andi	a5,a5,255
 3b8:	4725                	li	a4,9
 3ba:	02f76963          	bltu	a4,a5,3ec <atoi+0x46>
 3be:	86aa                	mv	a3,a0
  n = 0;
 3c0:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 3c2:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 3c4:	0685                	addi	a3,a3,1
 3c6:	0025179b          	slliw	a5,a0,0x2
 3ca:	9fa9                	addw	a5,a5,a0
 3cc:	0017979b          	slliw	a5,a5,0x1
 3d0:	9fb1                	addw	a5,a5,a2
 3d2:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 3d6:	0006c603          	lbu	a2,0(a3)
 3da:	fd06071b          	addiw	a4,a2,-48
 3de:	0ff77713          	andi	a4,a4,255
 3e2:	fee5f1e3          	bgeu	a1,a4,3c4 <atoi+0x1e>
  return n;
}
 3e6:	6422                	ld	s0,8(sp)
 3e8:	0141                	addi	sp,sp,16
 3ea:	8082                	ret
  n = 0;
 3ec:	4501                	li	a0,0
 3ee:	bfe5                	j	3e6 <atoi+0x40>

00000000000003f0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3f0:	1141                	addi	sp,sp,-16
 3f2:	e422                	sd	s0,8(sp)
 3f4:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 3f6:	02b57663          	bgeu	a0,a1,422 <memmove+0x32>
    while(n-- > 0)
 3fa:	02c05163          	blez	a2,41c <memmove+0x2c>
 3fe:	fff6079b          	addiw	a5,a2,-1
 402:	1782                	slli	a5,a5,0x20
 404:	9381                	srli	a5,a5,0x20
 406:	0785                	addi	a5,a5,1
 408:	97aa                	add	a5,a5,a0
  dst = vdst;
 40a:	872a                	mv	a4,a0
      *dst++ = *src++;
 40c:	0585                	addi	a1,a1,1
 40e:	0705                	addi	a4,a4,1
 410:	fff5c683          	lbu	a3,-1(a1)
 414:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 418:	fee79ae3          	bne	a5,a4,40c <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 41c:	6422                	ld	s0,8(sp)
 41e:	0141                	addi	sp,sp,16
 420:	8082                	ret
    dst += n;
 422:	00c50733          	add	a4,a0,a2
    src += n;
 426:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 428:	fec05ae3          	blez	a2,41c <memmove+0x2c>
 42c:	fff6079b          	addiw	a5,a2,-1
 430:	1782                	slli	a5,a5,0x20
 432:	9381                	srli	a5,a5,0x20
 434:	fff7c793          	not	a5,a5
 438:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 43a:	15fd                	addi	a1,a1,-1
 43c:	177d                	addi	a4,a4,-1
 43e:	0005c683          	lbu	a3,0(a1)
 442:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 446:	fee79ae3          	bne	a5,a4,43a <memmove+0x4a>
 44a:	bfc9                	j	41c <memmove+0x2c>

000000000000044c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 44c:	1141                	addi	sp,sp,-16
 44e:	e422                	sd	s0,8(sp)
 450:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 452:	ca05                	beqz	a2,482 <memcmp+0x36>
 454:	fff6069b          	addiw	a3,a2,-1
 458:	1682                	slli	a3,a3,0x20
 45a:	9281                	srli	a3,a3,0x20
 45c:	0685                	addi	a3,a3,1
 45e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 460:	00054783          	lbu	a5,0(a0)
 464:	0005c703          	lbu	a4,0(a1)
 468:	00e79863          	bne	a5,a4,478 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 46c:	0505                	addi	a0,a0,1
    p2++;
 46e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 470:	fed518e3          	bne	a0,a3,460 <memcmp+0x14>
  }
  return 0;
 474:	4501                	li	a0,0
 476:	a019                	j	47c <memcmp+0x30>
      return *p1 - *p2;
 478:	40e7853b          	subw	a0,a5,a4
}
 47c:	6422                	ld	s0,8(sp)
 47e:	0141                	addi	sp,sp,16
 480:	8082                	ret
  return 0;
 482:	4501                	li	a0,0
 484:	bfe5                	j	47c <memcmp+0x30>

0000000000000486 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 486:	1141                	addi	sp,sp,-16
 488:	e406                	sd	ra,8(sp)
 48a:	e022                	sd	s0,0(sp)
 48c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 48e:	00000097          	auipc	ra,0x0
 492:	f62080e7          	jalr	-158(ra) # 3f0 <memmove>
}
 496:	60a2                	ld	ra,8(sp)
 498:	6402                	ld	s0,0(sp)
 49a:	0141                	addi	sp,sp,16
 49c:	8082                	ret

000000000000049e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 49e:	4885                	li	a7,1
 ecall
 4a0:	00000073          	ecall
 ret
 4a4:	8082                	ret

00000000000004a6 <exit>:
.global exit
exit:
 li a7, SYS_exit
 4a6:	4889                	li	a7,2
 ecall
 4a8:	00000073          	ecall
 ret
 4ac:	8082                	ret

00000000000004ae <wait>:
.global wait
wait:
 li a7, SYS_wait
 4ae:	488d                	li	a7,3
 ecall
 4b0:	00000073          	ecall
 ret
 4b4:	8082                	ret

00000000000004b6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4b6:	4891                	li	a7,4
 ecall
 4b8:	00000073          	ecall
 ret
 4bc:	8082                	ret

00000000000004be <read>:
.global read
read:
 li a7, SYS_read
 4be:	4895                	li	a7,5
 ecall
 4c0:	00000073          	ecall
 ret
 4c4:	8082                	ret

00000000000004c6 <write>:
.global write
write:
 li a7, SYS_write
 4c6:	48c1                	li	a7,16
 ecall
 4c8:	00000073          	ecall
 ret
 4cc:	8082                	ret

00000000000004ce <close>:
.global close
close:
 li a7, SYS_close
 4ce:	48d5                	li	a7,21
 ecall
 4d0:	00000073          	ecall
 ret
 4d4:	8082                	ret

00000000000004d6 <kill>:
.global kill
kill:
 li a7, SYS_kill
 4d6:	4899                	li	a7,6
 ecall
 4d8:	00000073          	ecall
 ret
 4dc:	8082                	ret

00000000000004de <exec>:
.global exec
exec:
 li a7, SYS_exec
 4de:	489d                	li	a7,7
 ecall
 4e0:	00000073          	ecall
 ret
 4e4:	8082                	ret

00000000000004e6 <open>:
.global open
open:
 li a7, SYS_open
 4e6:	48bd                	li	a7,15
 ecall
 4e8:	00000073          	ecall
 ret
 4ec:	8082                	ret

00000000000004ee <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4ee:	48c5                	li	a7,17
 ecall
 4f0:	00000073          	ecall
 ret
 4f4:	8082                	ret

00000000000004f6 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4f6:	48c9                	li	a7,18
 ecall
 4f8:	00000073          	ecall
 ret
 4fc:	8082                	ret

00000000000004fe <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4fe:	48a1                	li	a7,8
 ecall
 500:	00000073          	ecall
 ret
 504:	8082                	ret

0000000000000506 <link>:
.global link
link:
 li a7, SYS_link
 506:	48cd                	li	a7,19
 ecall
 508:	00000073          	ecall
 ret
 50c:	8082                	ret

000000000000050e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 50e:	48d1                	li	a7,20
 ecall
 510:	00000073          	ecall
 ret
 514:	8082                	ret

0000000000000516 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 516:	48a5                	li	a7,9
 ecall
 518:	00000073          	ecall
 ret
 51c:	8082                	ret

000000000000051e <dup>:
.global dup
dup:
 li a7, SYS_dup
 51e:	48a9                	li	a7,10
 ecall
 520:	00000073          	ecall
 ret
 524:	8082                	ret

0000000000000526 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 526:	48ad                	li	a7,11
 ecall
 528:	00000073          	ecall
 ret
 52c:	8082                	ret

000000000000052e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 52e:	48b1                	li	a7,12
 ecall
 530:	00000073          	ecall
 ret
 534:	8082                	ret

0000000000000536 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 536:	48b5                	li	a7,13
 ecall
 538:	00000073          	ecall
 ret
 53c:	8082                	ret

000000000000053e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 53e:	48b9                	li	a7,14
 ecall
 540:	00000073          	ecall
 ret
 544:	8082                	ret

0000000000000546 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 546:	1101                	addi	sp,sp,-32
 548:	ec06                	sd	ra,24(sp)
 54a:	e822                	sd	s0,16(sp)
 54c:	1000                	addi	s0,sp,32
 54e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 552:	4605                	li	a2,1
 554:	fef40593          	addi	a1,s0,-17
 558:	00000097          	auipc	ra,0x0
 55c:	f6e080e7          	jalr	-146(ra) # 4c6 <write>
}
 560:	60e2                	ld	ra,24(sp)
 562:	6442                	ld	s0,16(sp)
 564:	6105                	addi	sp,sp,32
 566:	8082                	ret

0000000000000568 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 568:	7139                	addi	sp,sp,-64
 56a:	fc06                	sd	ra,56(sp)
 56c:	f822                	sd	s0,48(sp)
 56e:	f426                	sd	s1,40(sp)
 570:	f04a                	sd	s2,32(sp)
 572:	ec4e                	sd	s3,24(sp)
 574:	0080                	addi	s0,sp,64
 576:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 578:	c299                	beqz	a3,57e <printint+0x16>
 57a:	0805c863          	bltz	a1,60a <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 57e:	2581                	sext.w	a1,a1
  neg = 0;
 580:	4881                	li	a7,0
 582:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 586:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 588:	2601                	sext.w	a2,a2
 58a:	00000517          	auipc	a0,0x0
 58e:	52650513          	addi	a0,a0,1318 # ab0 <digits>
 592:	883a                	mv	a6,a4
 594:	2705                	addiw	a4,a4,1
 596:	02c5f7bb          	remuw	a5,a1,a2
 59a:	1782                	slli	a5,a5,0x20
 59c:	9381                	srli	a5,a5,0x20
 59e:	97aa                	add	a5,a5,a0
 5a0:	0007c783          	lbu	a5,0(a5)
 5a4:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5a8:	0005879b          	sext.w	a5,a1
 5ac:	02c5d5bb          	divuw	a1,a1,a2
 5b0:	0685                	addi	a3,a3,1
 5b2:	fec7f0e3          	bgeu	a5,a2,592 <printint+0x2a>
  if(neg)
 5b6:	00088b63          	beqz	a7,5cc <printint+0x64>
    buf[i++] = '-';
 5ba:	fd040793          	addi	a5,s0,-48
 5be:	973e                	add	a4,a4,a5
 5c0:	02d00793          	li	a5,45
 5c4:	fef70823          	sb	a5,-16(a4)
 5c8:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 5cc:	02e05863          	blez	a4,5fc <printint+0x94>
 5d0:	fc040793          	addi	a5,s0,-64
 5d4:	00e78933          	add	s2,a5,a4
 5d8:	fff78993          	addi	s3,a5,-1
 5dc:	99ba                	add	s3,s3,a4
 5de:	377d                	addiw	a4,a4,-1
 5e0:	1702                	slli	a4,a4,0x20
 5e2:	9301                	srli	a4,a4,0x20
 5e4:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5e8:	fff94583          	lbu	a1,-1(s2)
 5ec:	8526                	mv	a0,s1
 5ee:	00000097          	auipc	ra,0x0
 5f2:	f58080e7          	jalr	-168(ra) # 546 <putc>
  while(--i >= 0)
 5f6:	197d                	addi	s2,s2,-1
 5f8:	ff3918e3          	bne	s2,s3,5e8 <printint+0x80>
}
 5fc:	70e2                	ld	ra,56(sp)
 5fe:	7442                	ld	s0,48(sp)
 600:	74a2                	ld	s1,40(sp)
 602:	7902                	ld	s2,32(sp)
 604:	69e2                	ld	s3,24(sp)
 606:	6121                	addi	sp,sp,64
 608:	8082                	ret
    x = -xx;
 60a:	40b005bb          	negw	a1,a1
    neg = 1;
 60e:	4885                	li	a7,1
    x = -xx;
 610:	bf8d                	j	582 <printint+0x1a>

0000000000000612 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 612:	7119                	addi	sp,sp,-128
 614:	fc86                	sd	ra,120(sp)
 616:	f8a2                	sd	s0,112(sp)
 618:	f4a6                	sd	s1,104(sp)
 61a:	f0ca                	sd	s2,96(sp)
 61c:	ecce                	sd	s3,88(sp)
 61e:	e8d2                	sd	s4,80(sp)
 620:	e4d6                	sd	s5,72(sp)
 622:	e0da                	sd	s6,64(sp)
 624:	fc5e                	sd	s7,56(sp)
 626:	f862                	sd	s8,48(sp)
 628:	f466                	sd	s9,40(sp)
 62a:	f06a                	sd	s10,32(sp)
 62c:	ec6e                	sd	s11,24(sp)
 62e:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 630:	0005c903          	lbu	s2,0(a1)
 634:	18090f63          	beqz	s2,7d2 <vprintf+0x1c0>
 638:	8aaa                	mv	s5,a0
 63a:	8b32                	mv	s6,a2
 63c:	00158493          	addi	s1,a1,1
  state = 0;
 640:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 642:	02500a13          	li	s4,37
      if(c == 'd'){
 646:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 64a:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 64e:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 652:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 656:	00000b97          	auipc	s7,0x0
 65a:	45ab8b93          	addi	s7,s7,1114 # ab0 <digits>
 65e:	a839                	j	67c <vprintf+0x6a>
        putc(fd, c);
 660:	85ca                	mv	a1,s2
 662:	8556                	mv	a0,s5
 664:	00000097          	auipc	ra,0x0
 668:	ee2080e7          	jalr	-286(ra) # 546 <putc>
 66c:	a019                	j	672 <vprintf+0x60>
    } else if(state == '%'){
 66e:	01498f63          	beq	s3,s4,68c <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 672:	0485                	addi	s1,s1,1
 674:	fff4c903          	lbu	s2,-1(s1)
 678:	14090d63          	beqz	s2,7d2 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 67c:	0009079b          	sext.w	a5,s2
    if(state == 0){
 680:	fe0997e3          	bnez	s3,66e <vprintf+0x5c>
      if(c == '%'){
 684:	fd479ee3          	bne	a5,s4,660 <vprintf+0x4e>
        state = '%';
 688:	89be                	mv	s3,a5
 68a:	b7e5                	j	672 <vprintf+0x60>
      if(c == 'd'){
 68c:	05878063          	beq	a5,s8,6cc <vprintf+0xba>
      } else if(c == 'l') {
 690:	05978c63          	beq	a5,s9,6e8 <vprintf+0xd6>
      } else if(c == 'x') {
 694:	07a78863          	beq	a5,s10,704 <vprintf+0xf2>
      } else if(c == 'p') {
 698:	09b78463          	beq	a5,s11,720 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 69c:	07300713          	li	a4,115
 6a0:	0ce78663          	beq	a5,a4,76c <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6a4:	06300713          	li	a4,99
 6a8:	0ee78e63          	beq	a5,a4,7a4 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 6ac:	11478863          	beq	a5,s4,7bc <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6b0:	85d2                	mv	a1,s4
 6b2:	8556                	mv	a0,s5
 6b4:	00000097          	auipc	ra,0x0
 6b8:	e92080e7          	jalr	-366(ra) # 546 <putc>
        putc(fd, c);
 6bc:	85ca                	mv	a1,s2
 6be:	8556                	mv	a0,s5
 6c0:	00000097          	auipc	ra,0x0
 6c4:	e86080e7          	jalr	-378(ra) # 546 <putc>
      }
      state = 0;
 6c8:	4981                	li	s3,0
 6ca:	b765                	j	672 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 6cc:	008b0913          	addi	s2,s6,8
 6d0:	4685                	li	a3,1
 6d2:	4629                	li	a2,10
 6d4:	000b2583          	lw	a1,0(s6)
 6d8:	8556                	mv	a0,s5
 6da:	00000097          	auipc	ra,0x0
 6de:	e8e080e7          	jalr	-370(ra) # 568 <printint>
 6e2:	8b4a                	mv	s6,s2
      state = 0;
 6e4:	4981                	li	s3,0
 6e6:	b771                	j	672 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6e8:	008b0913          	addi	s2,s6,8
 6ec:	4681                	li	a3,0
 6ee:	4629                	li	a2,10
 6f0:	000b2583          	lw	a1,0(s6)
 6f4:	8556                	mv	a0,s5
 6f6:	00000097          	auipc	ra,0x0
 6fa:	e72080e7          	jalr	-398(ra) # 568 <printint>
 6fe:	8b4a                	mv	s6,s2
      state = 0;
 700:	4981                	li	s3,0
 702:	bf85                	j	672 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 704:	008b0913          	addi	s2,s6,8
 708:	4681                	li	a3,0
 70a:	4641                	li	a2,16
 70c:	000b2583          	lw	a1,0(s6)
 710:	8556                	mv	a0,s5
 712:	00000097          	auipc	ra,0x0
 716:	e56080e7          	jalr	-426(ra) # 568 <printint>
 71a:	8b4a                	mv	s6,s2
      state = 0;
 71c:	4981                	li	s3,0
 71e:	bf91                	j	672 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 720:	008b0793          	addi	a5,s6,8
 724:	f8f43423          	sd	a5,-120(s0)
 728:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 72c:	03000593          	li	a1,48
 730:	8556                	mv	a0,s5
 732:	00000097          	auipc	ra,0x0
 736:	e14080e7          	jalr	-492(ra) # 546 <putc>
  putc(fd, 'x');
 73a:	85ea                	mv	a1,s10
 73c:	8556                	mv	a0,s5
 73e:	00000097          	auipc	ra,0x0
 742:	e08080e7          	jalr	-504(ra) # 546 <putc>
 746:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 748:	03c9d793          	srli	a5,s3,0x3c
 74c:	97de                	add	a5,a5,s7
 74e:	0007c583          	lbu	a1,0(a5)
 752:	8556                	mv	a0,s5
 754:	00000097          	auipc	ra,0x0
 758:	df2080e7          	jalr	-526(ra) # 546 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 75c:	0992                	slli	s3,s3,0x4
 75e:	397d                	addiw	s2,s2,-1
 760:	fe0914e3          	bnez	s2,748 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 764:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 768:	4981                	li	s3,0
 76a:	b721                	j	672 <vprintf+0x60>
        s = va_arg(ap, char*);
 76c:	008b0993          	addi	s3,s6,8
 770:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 774:	02090163          	beqz	s2,796 <vprintf+0x184>
        while(*s != 0){
 778:	00094583          	lbu	a1,0(s2)
 77c:	c9a1                	beqz	a1,7cc <vprintf+0x1ba>
          putc(fd, *s);
 77e:	8556                	mv	a0,s5
 780:	00000097          	auipc	ra,0x0
 784:	dc6080e7          	jalr	-570(ra) # 546 <putc>
          s++;
 788:	0905                	addi	s2,s2,1
        while(*s != 0){
 78a:	00094583          	lbu	a1,0(s2)
 78e:	f9e5                	bnez	a1,77e <vprintf+0x16c>
        s = va_arg(ap, char*);
 790:	8b4e                	mv	s6,s3
      state = 0;
 792:	4981                	li	s3,0
 794:	bdf9                	j	672 <vprintf+0x60>
          s = "(null)";
 796:	00000917          	auipc	s2,0x0
 79a:	31290913          	addi	s2,s2,786 # aa8 <malloc+0x1cc>
        while(*s != 0){
 79e:	02800593          	li	a1,40
 7a2:	bff1                	j	77e <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 7a4:	008b0913          	addi	s2,s6,8
 7a8:	000b4583          	lbu	a1,0(s6)
 7ac:	8556                	mv	a0,s5
 7ae:	00000097          	auipc	ra,0x0
 7b2:	d98080e7          	jalr	-616(ra) # 546 <putc>
 7b6:	8b4a                	mv	s6,s2
      state = 0;
 7b8:	4981                	li	s3,0
 7ba:	bd65                	j	672 <vprintf+0x60>
        putc(fd, c);
 7bc:	85d2                	mv	a1,s4
 7be:	8556                	mv	a0,s5
 7c0:	00000097          	auipc	ra,0x0
 7c4:	d86080e7          	jalr	-634(ra) # 546 <putc>
      state = 0;
 7c8:	4981                	li	s3,0
 7ca:	b565                	j	672 <vprintf+0x60>
        s = va_arg(ap, char*);
 7cc:	8b4e                	mv	s6,s3
      state = 0;
 7ce:	4981                	li	s3,0
 7d0:	b54d                	j	672 <vprintf+0x60>
    }
  }
}
 7d2:	70e6                	ld	ra,120(sp)
 7d4:	7446                	ld	s0,112(sp)
 7d6:	74a6                	ld	s1,104(sp)
 7d8:	7906                	ld	s2,96(sp)
 7da:	69e6                	ld	s3,88(sp)
 7dc:	6a46                	ld	s4,80(sp)
 7de:	6aa6                	ld	s5,72(sp)
 7e0:	6b06                	ld	s6,64(sp)
 7e2:	7be2                	ld	s7,56(sp)
 7e4:	7c42                	ld	s8,48(sp)
 7e6:	7ca2                	ld	s9,40(sp)
 7e8:	7d02                	ld	s10,32(sp)
 7ea:	6de2                	ld	s11,24(sp)
 7ec:	6109                	addi	sp,sp,128
 7ee:	8082                	ret

00000000000007f0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7f0:	715d                	addi	sp,sp,-80
 7f2:	ec06                	sd	ra,24(sp)
 7f4:	e822                	sd	s0,16(sp)
 7f6:	1000                	addi	s0,sp,32
 7f8:	e010                	sd	a2,0(s0)
 7fa:	e414                	sd	a3,8(s0)
 7fc:	e818                	sd	a4,16(s0)
 7fe:	ec1c                	sd	a5,24(s0)
 800:	03043023          	sd	a6,32(s0)
 804:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 808:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 80c:	8622                	mv	a2,s0
 80e:	00000097          	auipc	ra,0x0
 812:	e04080e7          	jalr	-508(ra) # 612 <vprintf>
}
 816:	60e2                	ld	ra,24(sp)
 818:	6442                	ld	s0,16(sp)
 81a:	6161                	addi	sp,sp,80
 81c:	8082                	ret

000000000000081e <printf>:

void
printf(const char *fmt, ...)
{
 81e:	711d                	addi	sp,sp,-96
 820:	ec06                	sd	ra,24(sp)
 822:	e822                	sd	s0,16(sp)
 824:	1000                	addi	s0,sp,32
 826:	e40c                	sd	a1,8(s0)
 828:	e810                	sd	a2,16(s0)
 82a:	ec14                	sd	a3,24(s0)
 82c:	f018                	sd	a4,32(s0)
 82e:	f41c                	sd	a5,40(s0)
 830:	03043823          	sd	a6,48(s0)
 834:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 838:	00840613          	addi	a2,s0,8
 83c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 840:	85aa                	mv	a1,a0
 842:	4505                	li	a0,1
 844:	00000097          	auipc	ra,0x0
 848:	dce080e7          	jalr	-562(ra) # 612 <vprintf>
}
 84c:	60e2                	ld	ra,24(sp)
 84e:	6442                	ld	s0,16(sp)
 850:	6125                	addi	sp,sp,96
 852:	8082                	ret

0000000000000854 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 854:	1141                	addi	sp,sp,-16
 856:	e422                	sd	s0,8(sp)
 858:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 85a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 85e:	00000797          	auipc	a5,0x0
 862:	7a27b783          	ld	a5,1954(a5) # 1000 <freep>
 866:	a805                	j	896 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 868:	4618                	lw	a4,8(a2)
 86a:	9db9                	addw	a1,a1,a4
 86c:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 870:	6398                	ld	a4,0(a5)
 872:	6318                	ld	a4,0(a4)
 874:	fee53823          	sd	a4,-16(a0)
 878:	a091                	j	8bc <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 87a:	ff852703          	lw	a4,-8(a0)
 87e:	9e39                	addw	a2,a2,a4
 880:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 882:	ff053703          	ld	a4,-16(a0)
 886:	e398                	sd	a4,0(a5)
 888:	a099                	j	8ce <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 88a:	6398                	ld	a4,0(a5)
 88c:	00e7e463          	bltu	a5,a4,894 <free+0x40>
 890:	00e6ea63          	bltu	a3,a4,8a4 <free+0x50>
{
 894:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 896:	fed7fae3          	bgeu	a5,a3,88a <free+0x36>
 89a:	6398                	ld	a4,0(a5)
 89c:	00e6e463          	bltu	a3,a4,8a4 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8a0:	fee7eae3          	bltu	a5,a4,894 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 8a4:	ff852583          	lw	a1,-8(a0)
 8a8:	6390                	ld	a2,0(a5)
 8aa:	02059713          	slli	a4,a1,0x20
 8ae:	9301                	srli	a4,a4,0x20
 8b0:	0712                	slli	a4,a4,0x4
 8b2:	9736                	add	a4,a4,a3
 8b4:	fae60ae3          	beq	a2,a4,868 <free+0x14>
    bp->s.ptr = p->s.ptr;
 8b8:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8bc:	4790                	lw	a2,8(a5)
 8be:	02061713          	slli	a4,a2,0x20
 8c2:	9301                	srli	a4,a4,0x20
 8c4:	0712                	slli	a4,a4,0x4
 8c6:	973e                	add	a4,a4,a5
 8c8:	fae689e3          	beq	a3,a4,87a <free+0x26>
  } else
    p->s.ptr = bp;
 8cc:	e394                	sd	a3,0(a5)
  freep = p;
 8ce:	00000717          	auipc	a4,0x0
 8d2:	72f73923          	sd	a5,1842(a4) # 1000 <freep>
}
 8d6:	6422                	ld	s0,8(sp)
 8d8:	0141                	addi	sp,sp,16
 8da:	8082                	ret

00000000000008dc <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8dc:	7139                	addi	sp,sp,-64
 8de:	fc06                	sd	ra,56(sp)
 8e0:	f822                	sd	s0,48(sp)
 8e2:	f426                	sd	s1,40(sp)
 8e4:	f04a                	sd	s2,32(sp)
 8e6:	ec4e                	sd	s3,24(sp)
 8e8:	e852                	sd	s4,16(sp)
 8ea:	e456                	sd	s5,8(sp)
 8ec:	e05a                	sd	s6,0(sp)
 8ee:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8f0:	02051493          	slli	s1,a0,0x20
 8f4:	9081                	srli	s1,s1,0x20
 8f6:	04bd                	addi	s1,s1,15
 8f8:	8091                	srli	s1,s1,0x4
 8fa:	0014899b          	addiw	s3,s1,1
 8fe:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 900:	00000517          	auipc	a0,0x0
 904:	70053503          	ld	a0,1792(a0) # 1000 <freep>
 908:	c515                	beqz	a0,934 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 90a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 90c:	4798                	lw	a4,8(a5)
 90e:	02977f63          	bgeu	a4,s1,94c <malloc+0x70>
 912:	8a4e                	mv	s4,s3
 914:	0009871b          	sext.w	a4,s3
 918:	6685                	lui	a3,0x1
 91a:	00d77363          	bgeu	a4,a3,920 <malloc+0x44>
 91e:	6a05                	lui	s4,0x1
 920:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 924:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 928:	00000917          	auipc	s2,0x0
 92c:	6d890913          	addi	s2,s2,1752 # 1000 <freep>
  if(p == (char*)-1)
 930:	5afd                	li	s5,-1
 932:	a88d                	j	9a4 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 934:	00000797          	auipc	a5,0x0
 938:	6dc78793          	addi	a5,a5,1756 # 1010 <base>
 93c:	00000717          	auipc	a4,0x0
 940:	6cf73223          	sd	a5,1732(a4) # 1000 <freep>
 944:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 946:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 94a:	b7e1                	j	912 <malloc+0x36>
      if(p->s.size == nunits)
 94c:	02e48b63          	beq	s1,a4,982 <malloc+0xa6>
        p->s.size -= nunits;
 950:	4137073b          	subw	a4,a4,s3
 954:	c798                	sw	a4,8(a5)
        p += p->s.size;
 956:	1702                	slli	a4,a4,0x20
 958:	9301                	srli	a4,a4,0x20
 95a:	0712                	slli	a4,a4,0x4
 95c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 95e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 962:	00000717          	auipc	a4,0x0
 966:	68a73f23          	sd	a0,1694(a4) # 1000 <freep>
      return (void*)(p + 1);
 96a:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 96e:	70e2                	ld	ra,56(sp)
 970:	7442                	ld	s0,48(sp)
 972:	74a2                	ld	s1,40(sp)
 974:	7902                	ld	s2,32(sp)
 976:	69e2                	ld	s3,24(sp)
 978:	6a42                	ld	s4,16(sp)
 97a:	6aa2                	ld	s5,8(sp)
 97c:	6b02                	ld	s6,0(sp)
 97e:	6121                	addi	sp,sp,64
 980:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 982:	6398                	ld	a4,0(a5)
 984:	e118                	sd	a4,0(a0)
 986:	bff1                	j	962 <malloc+0x86>
  hp->s.size = nu;
 988:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 98c:	0541                	addi	a0,a0,16
 98e:	00000097          	auipc	ra,0x0
 992:	ec6080e7          	jalr	-314(ra) # 854 <free>
  return freep;
 996:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 99a:	d971                	beqz	a0,96e <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 99c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 99e:	4798                	lw	a4,8(a5)
 9a0:	fa9776e3          	bgeu	a4,s1,94c <malloc+0x70>
    if(p == freep)
 9a4:	00093703          	ld	a4,0(s2)
 9a8:	853e                	mv	a0,a5
 9aa:	fef719e3          	bne	a4,a5,99c <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 9ae:	8552                	mv	a0,s4
 9b0:	00000097          	auipc	ra,0x0
 9b4:	b7e080e7          	jalr	-1154(ra) # 52e <sbrk>
  if(p == (char*)-1)
 9b8:	fd5518e3          	bne	a0,s5,988 <malloc+0xac>
        return 0;
 9bc:	4501                	li	a0,0
 9be:	bf45                	j	96e <malloc+0x92>
