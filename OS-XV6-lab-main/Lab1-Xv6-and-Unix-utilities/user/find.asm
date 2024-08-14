
user/_find:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:

#define MAX_PATH_LENGTH 512

// 改造ls.c中的fmtname,使得返回的字符串后不自动补齐空格
char *fmtname(char *path)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
   e:	84aa                	mv	s1,a0
    static char buf[DIRSIZ + 1];  // 静态缓冲区，用于存储和返回处理后的文件名
    char *p;

    // 寻找路径中最后一个斜杠后的第一个字符，即文件名的开始
    for (p = path + strlen(path); p >= path && *p != '/'; p--)
  10:	00000097          	auipc	ra,0x0
  14:	372080e7          	jalr	882(ra) # 382 <strlen>
  18:	02051793          	slli	a5,a0,0x20
  1c:	9381                	srli	a5,a5,0x20
  1e:	97a6                	add	a5,a5,s1
  20:	02f00693          	li	a3,47
  24:	0097e963          	bltu	a5,s1,36 <fmtname+0x36>
  28:	0007c703          	lbu	a4,0(a5)
  2c:	00d70563          	beq	a4,a3,36 <fmtname+0x36>
  30:	17fd                	addi	a5,a5,-1
  32:	fe97fbe3          	bgeu	a5,s1,28 <fmtname+0x28>
        ;
    p++;
  36:	00178913          	addi	s2,a5,1

    // 如果文件名的长度已经超过或等于 DIRSIZ，直接返回这个文件名
    if (strlen(p) >= DIRSIZ)
  3a:	854a                	mv	a0,s2
  3c:	00000097          	auipc	ra,0x0
  40:	346080e7          	jalr	838(ra) # 382 <strlen>
  44:	2501                	sext.w	a0,a0
  46:	47b5                	li	a5,13
  48:	08a7ec63          	bltu	a5,a0,e0 <fmtname+0xe0>
        return p;

    // 将文件名从 p 复制到 buf 中
    memmove(buf, p, strlen(p));
  4c:	854a                	mv	a0,s2
  4e:	00000097          	auipc	ra,0x0
  52:	334080e7          	jalr	820(ra) # 382 <strlen>
  56:	00001497          	auipc	s1,0x1
  5a:	fba48493          	addi	s1,s1,-70 # 1010 <buf.1106>
  5e:	0005061b          	sext.w	a2,a0
  62:	85ca                	mv	a1,s2
  64:	8526                	mv	a0,s1
  66:	00000097          	auipc	ra,0x0
  6a:	494080e7          	jalr	1172(ra) # 4fa <memmove>

    // 在文件名后填充空格，直到达到 DIRSIZ 的长度
    memset(buf + strlen(p), ' ', DIRSIZ - strlen(p));
  6e:	854a                	mv	a0,s2
  70:	00000097          	auipc	ra,0x0
  74:	312080e7          	jalr	786(ra) # 382 <strlen>
  78:	0005099b          	sext.w	s3,a0
  7c:	854a                	mv	a0,s2
  7e:	00000097          	auipc	ra,0x0
  82:	304080e7          	jalr	772(ra) # 382 <strlen>
  86:	1982                	slli	s3,s3,0x20
  88:	0209d993          	srli	s3,s3,0x20
  8c:	4639                	li	a2,14
  8e:	9e09                	subw	a2,a2,a0
  90:	02000593          	li	a1,32
  94:	01348533          	add	a0,s1,s3
  98:	00000097          	auipc	ra,0x0
  9c:	314080e7          	jalr	788(ra) # 3ac <memset>

    // 在填充后的字符串中从后向前搜索，找到第一个非空格字符
    for (char *i = buf + strlen(buf);; i--) {
  a0:	8526                	mv	a0,s1
  a2:	00000097          	auipc	ra,0x0
  a6:	2e0080e7          	jalr	736(ra) # 382 <strlen>
  aa:	02051793          	slli	a5,a0,0x20
  ae:	9381                	srli	a5,a5,0x20
  b0:	97a6                	add	a5,a5,s1
        if (*i != '\0' && *i != ' ' && *i != '\n' && *i != '\r' && *i != '\t') {
  b2:	02000613          	li	a2,32
  b6:	00001597          	auipc	a1,0x1
  ba:	a1a58593          	addi	a1,a1,-1510 # ad0 <malloc+0xea>
  be:	a011                	j	c2 <fmtname+0xc2>
    for (char *i = buf + strlen(buf);; i--) {
  c0:	17fd                	addi	a5,a5,-1
        if (*i != '\0' && *i != ' ' && *i != '\n' && *i != '\r' && *i != '\t') {
  c2:	0007c683          	lbu	a3,0(a5)
  c6:	00d66763          	bltu	a2,a3,d4 <fmtname+0xd4>
  ca:	6198                	ld	a4,0(a1)
  cc:	00d75733          	srl	a4,a4,a3
  d0:	8b05                	andi	a4,a4,1
  d2:	f77d                	bnez	a4,c0 <fmtname+0xc0>
            *(i + 1) = '\0';  // 在这个字符后面放置字符串结束符 '\0'
  d4:	000780a3          	sb	zero,1(a5)
            break;
        }
    }

    return buf;  // 返回处理后的字符串
  d8:	00001917          	auipc	s2,0x1
  dc:	f3890913          	addi	s2,s2,-200 # 1010 <buf.1106>
}
  e0:	854a                	mv	a0,s2
  e2:	70a2                	ld	ra,40(sp)
  e4:	7402                	ld	s0,32(sp)
  e6:	64e2                	ld	s1,24(sp)
  e8:	6942                	ld	s2,16(sp)
  ea:	69a2                	ld	s3,8(sp)
  ec:	6145                	addi	sp,sp,48
  ee:	8082                	ret

00000000000000f0 <find>:



// 定义find函数，用于在指定目录及其子目录中搜索具有特定名称的文件，从ls函数改造而来
void find(char *path, char *filename)
{
  f0:	d8010113          	addi	sp,sp,-640
  f4:	26113c23          	sd	ra,632(sp)
  f8:	26813823          	sd	s0,624(sp)
  fc:	26913423          	sd	s1,616(sp)
 100:	27213023          	sd	s2,608(sp)
 104:	25313c23          	sd	s3,600(sp)
 108:	25413823          	sd	s4,592(sp)
 10c:	25513423          	sd	s5,584(sp)
 110:	25613023          	sd	s6,576(sp)
 114:	23713c23          	sd	s7,568(sp)
 118:	0500                	addi	s0,sp,640
 11a:	892a                	mv	s2,a0
 11c:	89ae                	mv	s3,a1
    int fd;  // 文件描述符，用于打开目录
    struct dirent de;  // 目录项结构
    struct stat st;  // 文件状态结构

    // 尝试打开目录或文件
    if ((fd = open(path, 0)) < 0) {
 11e:	4581                	li	a1,0
 120:	00000097          	auipc	ra,0x0
 124:	4d0080e7          	jalr	1232(ra) # 5f0 <open>
 128:	06054a63          	bltz	a0,19c <find+0xac>
 12c:	84aa                	mv	s1,a0
        fprintf(2, "find: cannot open %s\n", path);  // 打开失败时输出错误信息
        return;
    }

    // 获取文件或目录的状态信息
    if (fstat(fd, &st) < 0) {
 12e:	d8840593          	addi	a1,s0,-632
 132:	00000097          	auipc	ra,0x0
 136:	4d6080e7          	jalr	1238(ra) # 608 <fstat>
 13a:	06054c63          	bltz	a0,1b2 <find+0xc2>
        close(fd);  // 关闭文件描述符
        return;
    }

    // 根据文件类型处理
    switch (st.type) {
 13e:	d9041783          	lh	a5,-624(s0)
 142:	0007869b          	sext.w	a3,a5
 146:	4705                	li	a4,1
 148:	08e68f63          	beq	a3,a4,1e6 <find+0xf6>
 14c:	4709                	li	a4,2
 14e:	00e69d63          	bne	a3,a4,168 <find+0x78>
    case T_FILE:  // 处理文件类型
        if (strcmp(fmtname(path), filename) == 0) {  // 比较处理后的文件名是否与目标文件名匹配
 152:	854a                	mv	a0,s2
 154:	00000097          	auipc	ra,0x0
 158:	eac080e7          	jalr	-340(ra) # 0 <fmtname>
 15c:	85ce                	mv	a1,s3
 15e:	00000097          	auipc	ra,0x0
 162:	1f8080e7          	jalr	504(ra) # 356 <strcmp>
 166:	c535                	beqz	a0,1d2 <find+0xe2>
            find(buf, filename);  // 递归调用find函数，以检查子目录
        }
        break;
    }

    close(fd);  // 完成后关闭文件描述符
 168:	8526                	mv	a0,s1
 16a:	00000097          	auipc	ra,0x0
 16e:	46e080e7          	jalr	1134(ra) # 5d8 <close>
}
 172:	27813083          	ld	ra,632(sp)
 176:	27013403          	ld	s0,624(sp)
 17a:	26813483          	ld	s1,616(sp)
 17e:	26013903          	ld	s2,608(sp)
 182:	25813983          	ld	s3,600(sp)
 186:	25013a03          	ld	s4,592(sp)
 18a:	24813a83          	ld	s5,584(sp)
 18e:	24013b03          	ld	s6,576(sp)
 192:	23813b83          	ld	s7,568(sp)
 196:	28010113          	addi	sp,sp,640
 19a:	8082                	ret
        fprintf(2, "find: cannot open %s\n", path);  // 打开失败时输出错误信息
 19c:	864a                	mv	a2,s2
 19e:	00001597          	auipc	a1,0x1
 1a2:	94258593          	addi	a1,a1,-1726 # ae0 <malloc+0xfa>
 1a6:	4509                	li	a0,2
 1a8:	00000097          	auipc	ra,0x0
 1ac:	752080e7          	jalr	1874(ra) # 8fa <fprintf>
        return;
 1b0:	b7c9                	j	172 <find+0x82>
        fprintf(2, "find: cannot stat %s\n", path);  // 获取状态失败时输出错误信息
 1b2:	864a                	mv	a2,s2
 1b4:	00001597          	auipc	a1,0x1
 1b8:	94458593          	addi	a1,a1,-1724 # af8 <malloc+0x112>
 1bc:	4509                	li	a0,2
 1be:	00000097          	auipc	ra,0x0
 1c2:	73c080e7          	jalr	1852(ra) # 8fa <fprintf>
        close(fd);  // 关闭文件描述符
 1c6:	8526                	mv	a0,s1
 1c8:	00000097          	auipc	ra,0x0
 1cc:	410080e7          	jalr	1040(ra) # 5d8 <close>
        return;
 1d0:	b74d                	j	172 <find+0x82>
            printf("%s\n", path);  // 如果匹配，打印文件路径
 1d2:	85ca                	mv	a1,s2
 1d4:	00001517          	auipc	a0,0x1
 1d8:	93c50513          	addi	a0,a0,-1732 # b10 <malloc+0x12a>
 1dc:	00000097          	auipc	ra,0x0
 1e0:	74c080e7          	jalr	1868(ra) # 928 <printf>
 1e4:	b751                	j	168 <find+0x78>
        if (strlen(path) + 1 + DIRSIZ + 1 > sizeof(buf)) {
 1e6:	854a                	mv	a0,s2
 1e8:	00000097          	auipc	ra,0x0
 1ec:	19a080e7          	jalr	410(ra) # 382 <strlen>
 1f0:	2541                	addiw	a0,a0,16
 1f2:	20000793          	li	a5,512
 1f6:	00a7fc63          	bgeu	a5,a0,20e <find+0x11e>
            fprintf(2, "find: path too long\n");  // 如果路径太长，输出错误信息
 1fa:	00001597          	auipc	a1,0x1
 1fe:	91e58593          	addi	a1,a1,-1762 # b18 <malloc+0x132>
 202:	4509                	li	a0,2
 204:	00000097          	auipc	ra,0x0
 208:	6f6080e7          	jalr	1782(ra) # 8fa <fprintf>
            break;
 20c:	bfb1                	j	168 <find+0x78>
        strcpy(buf, path);  // 将当前路径复制到缓冲区
 20e:	85ca                	mv	a1,s2
 210:	db040513          	addi	a0,s0,-592
 214:	00000097          	auipc	ra,0x0
 218:	126080e7          	jalr	294(ra) # 33a <strcpy>
        p = buf + strlen(buf);  // 设置指针到缓冲区末尾
 21c:	db040513          	addi	a0,s0,-592
 220:	00000097          	auipc	ra,0x0
 224:	162080e7          	jalr	354(ra) # 382 <strlen>
 228:	02051913          	slli	s2,a0,0x20
 22c:	02095913          	srli	s2,s2,0x20
 230:	db040793          	addi	a5,s0,-592
 234:	993e                	add	s2,s2,a5
        *p++ = '/';  // 在路径末尾添加斜杠，为拼接子目录或文件名做准备
 236:	00190b13          	addi	s6,s2,1
 23a:	02f00793          	li	a5,47
 23e:	00f90023          	sb	a5,0(s2)
            if (de.inum == 0 || strcmp(de.name, ".") == 0 || strcmp(de.name, "..") == 0) {
 242:	00001a97          	auipc	s5,0x1
 246:	8eea8a93          	addi	s5,s5,-1810 # b30 <malloc+0x14a>
 24a:	00001b97          	auipc	s7,0x1
 24e:	8eeb8b93          	addi	s7,s7,-1810 # b38 <malloc+0x152>
 252:	da240a13          	addi	s4,s0,-606
        while (read(fd, &de, sizeof(de)) == sizeof(de)) {
 256:	4641                	li	a2,16
 258:	da040593          	addi	a1,s0,-608
 25c:	8526                	mv	a0,s1
 25e:	00000097          	auipc	ra,0x0
 262:	36a080e7          	jalr	874(ra) # 5c8 <read>
 266:	47c1                	li	a5,16
 268:	f0f510e3          	bne	a0,a5,168 <find+0x78>
            if (de.inum == 0 || strcmp(de.name, ".") == 0 || strcmp(de.name, "..") == 0) {
 26c:	da045783          	lhu	a5,-608(s0)
 270:	d3fd                	beqz	a5,256 <find+0x166>
 272:	85d6                	mv	a1,s5
 274:	8552                	mv	a0,s4
 276:	00000097          	auipc	ra,0x0
 27a:	0e0080e7          	jalr	224(ra) # 356 <strcmp>
 27e:	dd61                	beqz	a0,256 <find+0x166>
 280:	85de                	mv	a1,s7
 282:	8552                	mv	a0,s4
 284:	00000097          	auipc	ra,0x0
 288:	0d2080e7          	jalr	210(ra) # 356 <strcmp>
 28c:	d569                	beqz	a0,256 <find+0x166>
            memmove(p, de.name, DIRSIZ);  // 将读取的目录项名称拼接到路径后
 28e:	4639                	li	a2,14
 290:	da240593          	addi	a1,s0,-606
 294:	855a                	mv	a0,s6
 296:	00000097          	auipc	ra,0x0
 29a:	264080e7          	jalr	612(ra) # 4fa <memmove>
            p[DIRSIZ] = 0;  // 确保路径字符串正确结束
 29e:	000907a3          	sb	zero,15(s2)
            if (stat(buf, &st) < 0) {
 2a2:	d8840593          	addi	a1,s0,-632
 2a6:	db040513          	addi	a0,s0,-592
 2aa:	00000097          	auipc	ra,0x0
 2ae:	1c0080e7          	jalr	448(ra) # 46a <stat>
 2b2:	00054a63          	bltz	a0,2c6 <find+0x1d6>
            find(buf, filename);  // 递归调用find函数，以检查子目录
 2b6:	85ce                	mv	a1,s3
 2b8:	db040513          	addi	a0,s0,-592
 2bc:	00000097          	auipc	ra,0x0
 2c0:	e34080e7          	jalr	-460(ra) # f0 <find>
 2c4:	bf49                	j	256 <find+0x166>
                fprintf(2, "find: cannot stat %s\n", buf);  // 如果无法获取子目录项的状态，输出错误信息并继续
 2c6:	db040613          	addi	a2,s0,-592
 2ca:	00001597          	auipc	a1,0x1
 2ce:	82e58593          	addi	a1,a1,-2002 # af8 <malloc+0x112>
 2d2:	4509                	li	a0,2
 2d4:	00000097          	auipc	ra,0x0
 2d8:	626080e7          	jalr	1574(ra) # 8fa <fprintf>
                continue;
 2dc:	bfad                	j	256 <find+0x166>

00000000000002de <main>:


int main(int argc, char *argv[])
{
 2de:	1141                	addi	sp,sp,-16
 2e0:	e406                	sd	ra,8(sp)
 2e2:	e022                	sd	s0,0(sp)
 2e4:	0800                	addi	s0,sp,16
    if (argc != 3) {
 2e6:	470d                	li	a4,3
 2e8:	02e50063          	beq	a0,a4,308 <main+0x2a>
        fprintf(2, "Usage: find <directory> <filename>\n");
 2ec:	00001597          	auipc	a1,0x1
 2f0:	85458593          	addi	a1,a1,-1964 # b40 <malloc+0x15a>
 2f4:	4509                	li	a0,2
 2f6:	00000097          	auipc	ra,0x0
 2fa:	604080e7          	jalr	1540(ra) # 8fa <fprintf>
        exit(0);
 2fe:	4501                	li	a0,0
 300:	00000097          	auipc	ra,0x0
 304:	2b0080e7          	jalr	688(ra) # 5b0 <exit>
 308:	87ae                	mv	a5,a1
    }

    find(argv[1], argv[2]);
 30a:	698c                	ld	a1,16(a1)
 30c:	6788                	ld	a0,8(a5)
 30e:	00000097          	auipc	ra,0x0
 312:	de2080e7          	jalr	-542(ra) # f0 <find>
    exit(0);
 316:	4501                	li	a0,0
 318:	00000097          	auipc	ra,0x0
 31c:	298080e7          	jalr	664(ra) # 5b0 <exit>

0000000000000320 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 320:	1141                	addi	sp,sp,-16
 322:	e406                	sd	ra,8(sp)
 324:	e022                	sd	s0,0(sp)
 326:	0800                	addi	s0,sp,16
  extern int main();
  main();
 328:	00000097          	auipc	ra,0x0
 32c:	fb6080e7          	jalr	-74(ra) # 2de <main>
  exit(0);
 330:	4501                	li	a0,0
 332:	00000097          	auipc	ra,0x0
 336:	27e080e7          	jalr	638(ra) # 5b0 <exit>

000000000000033a <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 33a:	1141                	addi	sp,sp,-16
 33c:	e422                	sd	s0,8(sp)
 33e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 340:	87aa                	mv	a5,a0
 342:	0585                	addi	a1,a1,1
 344:	0785                	addi	a5,a5,1
 346:	fff5c703          	lbu	a4,-1(a1)
 34a:	fee78fa3          	sb	a4,-1(a5)
 34e:	fb75                	bnez	a4,342 <strcpy+0x8>
    ;
  return os;
}
 350:	6422                	ld	s0,8(sp)
 352:	0141                	addi	sp,sp,16
 354:	8082                	ret

0000000000000356 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 356:	1141                	addi	sp,sp,-16
 358:	e422                	sd	s0,8(sp)
 35a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 35c:	00054783          	lbu	a5,0(a0)
 360:	cb91                	beqz	a5,374 <strcmp+0x1e>
 362:	0005c703          	lbu	a4,0(a1)
 366:	00f71763          	bne	a4,a5,374 <strcmp+0x1e>
    p++, q++;
 36a:	0505                	addi	a0,a0,1
 36c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 36e:	00054783          	lbu	a5,0(a0)
 372:	fbe5                	bnez	a5,362 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 374:	0005c503          	lbu	a0,0(a1)
}
 378:	40a7853b          	subw	a0,a5,a0
 37c:	6422                	ld	s0,8(sp)
 37e:	0141                	addi	sp,sp,16
 380:	8082                	ret

0000000000000382 <strlen>:

uint
strlen(const char *s)
{
 382:	1141                	addi	sp,sp,-16
 384:	e422                	sd	s0,8(sp)
 386:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 388:	00054783          	lbu	a5,0(a0)
 38c:	cf91                	beqz	a5,3a8 <strlen+0x26>
 38e:	0505                	addi	a0,a0,1
 390:	87aa                	mv	a5,a0
 392:	4685                	li	a3,1
 394:	9e89                	subw	a3,a3,a0
 396:	00f6853b          	addw	a0,a3,a5
 39a:	0785                	addi	a5,a5,1
 39c:	fff7c703          	lbu	a4,-1(a5)
 3a0:	fb7d                	bnez	a4,396 <strlen+0x14>
    ;
  return n;
}
 3a2:	6422                	ld	s0,8(sp)
 3a4:	0141                	addi	sp,sp,16
 3a6:	8082                	ret
  for(n = 0; s[n]; n++)
 3a8:	4501                	li	a0,0
 3aa:	bfe5                	j	3a2 <strlen+0x20>

00000000000003ac <memset>:

void*
memset(void *dst, int c, uint n)
{
 3ac:	1141                	addi	sp,sp,-16
 3ae:	e422                	sd	s0,8(sp)
 3b0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 3b2:	ce09                	beqz	a2,3cc <memset+0x20>
 3b4:	87aa                	mv	a5,a0
 3b6:	fff6071b          	addiw	a4,a2,-1
 3ba:	1702                	slli	a4,a4,0x20
 3bc:	9301                	srli	a4,a4,0x20
 3be:	0705                	addi	a4,a4,1
 3c0:	972a                	add	a4,a4,a0
    cdst[i] = c;
 3c2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 3c6:	0785                	addi	a5,a5,1
 3c8:	fee79de3          	bne	a5,a4,3c2 <memset+0x16>
  }
  return dst;
}
 3cc:	6422                	ld	s0,8(sp)
 3ce:	0141                	addi	sp,sp,16
 3d0:	8082                	ret

00000000000003d2 <strchr>:

char*
strchr(const char *s, char c)
{
 3d2:	1141                	addi	sp,sp,-16
 3d4:	e422                	sd	s0,8(sp)
 3d6:	0800                	addi	s0,sp,16
  for(; *s; s++)
 3d8:	00054783          	lbu	a5,0(a0)
 3dc:	cb99                	beqz	a5,3f2 <strchr+0x20>
    if(*s == c)
 3de:	00f58763          	beq	a1,a5,3ec <strchr+0x1a>
  for(; *s; s++)
 3e2:	0505                	addi	a0,a0,1
 3e4:	00054783          	lbu	a5,0(a0)
 3e8:	fbfd                	bnez	a5,3de <strchr+0xc>
      return (char*)s;
  return 0;
 3ea:	4501                	li	a0,0
}
 3ec:	6422                	ld	s0,8(sp)
 3ee:	0141                	addi	sp,sp,16
 3f0:	8082                	ret
  return 0;
 3f2:	4501                	li	a0,0
 3f4:	bfe5                	j	3ec <strchr+0x1a>

00000000000003f6 <gets>:

char*
gets(char *buf, int max)
{
 3f6:	711d                	addi	sp,sp,-96
 3f8:	ec86                	sd	ra,88(sp)
 3fa:	e8a2                	sd	s0,80(sp)
 3fc:	e4a6                	sd	s1,72(sp)
 3fe:	e0ca                	sd	s2,64(sp)
 400:	fc4e                	sd	s3,56(sp)
 402:	f852                	sd	s4,48(sp)
 404:	f456                	sd	s5,40(sp)
 406:	f05a                	sd	s6,32(sp)
 408:	ec5e                	sd	s7,24(sp)
 40a:	1080                	addi	s0,sp,96
 40c:	8baa                	mv	s7,a0
 40e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 410:	892a                	mv	s2,a0
 412:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 414:	4aa9                	li	s5,10
 416:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 418:	89a6                	mv	s3,s1
 41a:	2485                	addiw	s1,s1,1
 41c:	0344d863          	bge	s1,s4,44c <gets+0x56>
    cc = read(0, &c, 1);
 420:	4605                	li	a2,1
 422:	faf40593          	addi	a1,s0,-81
 426:	4501                	li	a0,0
 428:	00000097          	auipc	ra,0x0
 42c:	1a0080e7          	jalr	416(ra) # 5c8 <read>
    if(cc < 1)
 430:	00a05e63          	blez	a0,44c <gets+0x56>
    buf[i++] = c;
 434:	faf44783          	lbu	a5,-81(s0)
 438:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 43c:	01578763          	beq	a5,s5,44a <gets+0x54>
 440:	0905                	addi	s2,s2,1
 442:	fd679be3          	bne	a5,s6,418 <gets+0x22>
  for(i=0; i+1 < max; ){
 446:	89a6                	mv	s3,s1
 448:	a011                	j	44c <gets+0x56>
 44a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 44c:	99de                	add	s3,s3,s7
 44e:	00098023          	sb	zero,0(s3)
  return buf;
}
 452:	855e                	mv	a0,s7
 454:	60e6                	ld	ra,88(sp)
 456:	6446                	ld	s0,80(sp)
 458:	64a6                	ld	s1,72(sp)
 45a:	6906                	ld	s2,64(sp)
 45c:	79e2                	ld	s3,56(sp)
 45e:	7a42                	ld	s4,48(sp)
 460:	7aa2                	ld	s5,40(sp)
 462:	7b02                	ld	s6,32(sp)
 464:	6be2                	ld	s7,24(sp)
 466:	6125                	addi	sp,sp,96
 468:	8082                	ret

000000000000046a <stat>:

int
stat(const char *n, struct stat *st)
{
 46a:	1101                	addi	sp,sp,-32
 46c:	ec06                	sd	ra,24(sp)
 46e:	e822                	sd	s0,16(sp)
 470:	e426                	sd	s1,8(sp)
 472:	e04a                	sd	s2,0(sp)
 474:	1000                	addi	s0,sp,32
 476:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 478:	4581                	li	a1,0
 47a:	00000097          	auipc	ra,0x0
 47e:	176080e7          	jalr	374(ra) # 5f0 <open>
  if(fd < 0)
 482:	02054563          	bltz	a0,4ac <stat+0x42>
 486:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 488:	85ca                	mv	a1,s2
 48a:	00000097          	auipc	ra,0x0
 48e:	17e080e7          	jalr	382(ra) # 608 <fstat>
 492:	892a                	mv	s2,a0
  close(fd);
 494:	8526                	mv	a0,s1
 496:	00000097          	auipc	ra,0x0
 49a:	142080e7          	jalr	322(ra) # 5d8 <close>
  return r;
}
 49e:	854a                	mv	a0,s2
 4a0:	60e2                	ld	ra,24(sp)
 4a2:	6442                	ld	s0,16(sp)
 4a4:	64a2                	ld	s1,8(sp)
 4a6:	6902                	ld	s2,0(sp)
 4a8:	6105                	addi	sp,sp,32
 4aa:	8082                	ret
    return -1;
 4ac:	597d                	li	s2,-1
 4ae:	bfc5                	j	49e <stat+0x34>

00000000000004b0 <atoi>:

int
atoi(const char *s)
{
 4b0:	1141                	addi	sp,sp,-16
 4b2:	e422                	sd	s0,8(sp)
 4b4:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 4b6:	00054603          	lbu	a2,0(a0)
 4ba:	fd06079b          	addiw	a5,a2,-48
 4be:	0ff7f793          	andi	a5,a5,255
 4c2:	4725                	li	a4,9
 4c4:	02f76963          	bltu	a4,a5,4f6 <atoi+0x46>
 4c8:	86aa                	mv	a3,a0
  n = 0;
 4ca:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 4cc:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 4ce:	0685                	addi	a3,a3,1
 4d0:	0025179b          	slliw	a5,a0,0x2
 4d4:	9fa9                	addw	a5,a5,a0
 4d6:	0017979b          	slliw	a5,a5,0x1
 4da:	9fb1                	addw	a5,a5,a2
 4dc:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 4e0:	0006c603          	lbu	a2,0(a3)
 4e4:	fd06071b          	addiw	a4,a2,-48
 4e8:	0ff77713          	andi	a4,a4,255
 4ec:	fee5f1e3          	bgeu	a1,a4,4ce <atoi+0x1e>
  return n;
}
 4f0:	6422                	ld	s0,8(sp)
 4f2:	0141                	addi	sp,sp,16
 4f4:	8082                	ret
  n = 0;
 4f6:	4501                	li	a0,0
 4f8:	bfe5                	j	4f0 <atoi+0x40>

00000000000004fa <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4fa:	1141                	addi	sp,sp,-16
 4fc:	e422                	sd	s0,8(sp)
 4fe:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 500:	02b57663          	bgeu	a0,a1,52c <memmove+0x32>
    while(n-- > 0)
 504:	02c05163          	blez	a2,526 <memmove+0x2c>
 508:	fff6079b          	addiw	a5,a2,-1
 50c:	1782                	slli	a5,a5,0x20
 50e:	9381                	srli	a5,a5,0x20
 510:	0785                	addi	a5,a5,1
 512:	97aa                	add	a5,a5,a0
  dst = vdst;
 514:	872a                	mv	a4,a0
      *dst++ = *src++;
 516:	0585                	addi	a1,a1,1
 518:	0705                	addi	a4,a4,1
 51a:	fff5c683          	lbu	a3,-1(a1)
 51e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 522:	fee79ae3          	bne	a5,a4,516 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 526:	6422                	ld	s0,8(sp)
 528:	0141                	addi	sp,sp,16
 52a:	8082                	ret
    dst += n;
 52c:	00c50733          	add	a4,a0,a2
    src += n;
 530:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 532:	fec05ae3          	blez	a2,526 <memmove+0x2c>
 536:	fff6079b          	addiw	a5,a2,-1
 53a:	1782                	slli	a5,a5,0x20
 53c:	9381                	srli	a5,a5,0x20
 53e:	fff7c793          	not	a5,a5
 542:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 544:	15fd                	addi	a1,a1,-1
 546:	177d                	addi	a4,a4,-1
 548:	0005c683          	lbu	a3,0(a1)
 54c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 550:	fee79ae3          	bne	a5,a4,544 <memmove+0x4a>
 554:	bfc9                	j	526 <memmove+0x2c>

0000000000000556 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 556:	1141                	addi	sp,sp,-16
 558:	e422                	sd	s0,8(sp)
 55a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 55c:	ca05                	beqz	a2,58c <memcmp+0x36>
 55e:	fff6069b          	addiw	a3,a2,-1
 562:	1682                	slli	a3,a3,0x20
 564:	9281                	srli	a3,a3,0x20
 566:	0685                	addi	a3,a3,1
 568:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 56a:	00054783          	lbu	a5,0(a0)
 56e:	0005c703          	lbu	a4,0(a1)
 572:	00e79863          	bne	a5,a4,582 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 576:	0505                	addi	a0,a0,1
    p2++;
 578:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 57a:	fed518e3          	bne	a0,a3,56a <memcmp+0x14>
  }
  return 0;
 57e:	4501                	li	a0,0
 580:	a019                	j	586 <memcmp+0x30>
      return *p1 - *p2;
 582:	40e7853b          	subw	a0,a5,a4
}
 586:	6422                	ld	s0,8(sp)
 588:	0141                	addi	sp,sp,16
 58a:	8082                	ret
  return 0;
 58c:	4501                	li	a0,0
 58e:	bfe5                	j	586 <memcmp+0x30>

0000000000000590 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 590:	1141                	addi	sp,sp,-16
 592:	e406                	sd	ra,8(sp)
 594:	e022                	sd	s0,0(sp)
 596:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 598:	00000097          	auipc	ra,0x0
 59c:	f62080e7          	jalr	-158(ra) # 4fa <memmove>
}
 5a0:	60a2                	ld	ra,8(sp)
 5a2:	6402                	ld	s0,0(sp)
 5a4:	0141                	addi	sp,sp,16
 5a6:	8082                	ret

00000000000005a8 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 5a8:	4885                	li	a7,1
 ecall
 5aa:	00000073          	ecall
 ret
 5ae:	8082                	ret

00000000000005b0 <exit>:
.global exit
exit:
 li a7, SYS_exit
 5b0:	4889                	li	a7,2
 ecall
 5b2:	00000073          	ecall
 ret
 5b6:	8082                	ret

00000000000005b8 <wait>:
.global wait
wait:
 li a7, SYS_wait
 5b8:	488d                	li	a7,3
 ecall
 5ba:	00000073          	ecall
 ret
 5be:	8082                	ret

00000000000005c0 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 5c0:	4891                	li	a7,4
 ecall
 5c2:	00000073          	ecall
 ret
 5c6:	8082                	ret

00000000000005c8 <read>:
.global read
read:
 li a7, SYS_read
 5c8:	4895                	li	a7,5
 ecall
 5ca:	00000073          	ecall
 ret
 5ce:	8082                	ret

00000000000005d0 <write>:
.global write
write:
 li a7, SYS_write
 5d0:	48c1                	li	a7,16
 ecall
 5d2:	00000073          	ecall
 ret
 5d6:	8082                	ret

00000000000005d8 <close>:
.global close
close:
 li a7, SYS_close
 5d8:	48d5                	li	a7,21
 ecall
 5da:	00000073          	ecall
 ret
 5de:	8082                	ret

00000000000005e0 <kill>:
.global kill
kill:
 li a7, SYS_kill
 5e0:	4899                	li	a7,6
 ecall
 5e2:	00000073          	ecall
 ret
 5e6:	8082                	ret

00000000000005e8 <exec>:
.global exec
exec:
 li a7, SYS_exec
 5e8:	489d                	li	a7,7
 ecall
 5ea:	00000073          	ecall
 ret
 5ee:	8082                	ret

00000000000005f0 <open>:
.global open
open:
 li a7, SYS_open
 5f0:	48bd                	li	a7,15
 ecall
 5f2:	00000073          	ecall
 ret
 5f6:	8082                	ret

00000000000005f8 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5f8:	48c5                	li	a7,17
 ecall
 5fa:	00000073          	ecall
 ret
 5fe:	8082                	ret

0000000000000600 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 600:	48c9                	li	a7,18
 ecall
 602:	00000073          	ecall
 ret
 606:	8082                	ret

0000000000000608 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 608:	48a1                	li	a7,8
 ecall
 60a:	00000073          	ecall
 ret
 60e:	8082                	ret

0000000000000610 <link>:
.global link
link:
 li a7, SYS_link
 610:	48cd                	li	a7,19
 ecall
 612:	00000073          	ecall
 ret
 616:	8082                	ret

0000000000000618 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 618:	48d1                	li	a7,20
 ecall
 61a:	00000073          	ecall
 ret
 61e:	8082                	ret

0000000000000620 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 620:	48a5                	li	a7,9
 ecall
 622:	00000073          	ecall
 ret
 626:	8082                	ret

0000000000000628 <dup>:
.global dup
dup:
 li a7, SYS_dup
 628:	48a9                	li	a7,10
 ecall
 62a:	00000073          	ecall
 ret
 62e:	8082                	ret

0000000000000630 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 630:	48ad                	li	a7,11
 ecall
 632:	00000073          	ecall
 ret
 636:	8082                	ret

0000000000000638 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 638:	48b1                	li	a7,12
 ecall
 63a:	00000073          	ecall
 ret
 63e:	8082                	ret

0000000000000640 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 640:	48b5                	li	a7,13
 ecall
 642:	00000073          	ecall
 ret
 646:	8082                	ret

0000000000000648 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 648:	48b9                	li	a7,14
 ecall
 64a:	00000073          	ecall
 ret
 64e:	8082                	ret

0000000000000650 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 650:	1101                	addi	sp,sp,-32
 652:	ec06                	sd	ra,24(sp)
 654:	e822                	sd	s0,16(sp)
 656:	1000                	addi	s0,sp,32
 658:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 65c:	4605                	li	a2,1
 65e:	fef40593          	addi	a1,s0,-17
 662:	00000097          	auipc	ra,0x0
 666:	f6e080e7          	jalr	-146(ra) # 5d0 <write>
}
 66a:	60e2                	ld	ra,24(sp)
 66c:	6442                	ld	s0,16(sp)
 66e:	6105                	addi	sp,sp,32
 670:	8082                	ret

0000000000000672 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 672:	7139                	addi	sp,sp,-64
 674:	fc06                	sd	ra,56(sp)
 676:	f822                	sd	s0,48(sp)
 678:	f426                	sd	s1,40(sp)
 67a:	f04a                	sd	s2,32(sp)
 67c:	ec4e                	sd	s3,24(sp)
 67e:	0080                	addi	s0,sp,64
 680:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 682:	c299                	beqz	a3,688 <printint+0x16>
 684:	0805c863          	bltz	a1,714 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 688:	2581                	sext.w	a1,a1
  neg = 0;
 68a:	4881                	li	a7,0
 68c:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 690:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 692:	2601                	sext.w	a2,a2
 694:	00000517          	auipc	a0,0x0
 698:	4dc50513          	addi	a0,a0,1244 # b70 <digits>
 69c:	883a                	mv	a6,a4
 69e:	2705                	addiw	a4,a4,1
 6a0:	02c5f7bb          	remuw	a5,a1,a2
 6a4:	1782                	slli	a5,a5,0x20
 6a6:	9381                	srli	a5,a5,0x20
 6a8:	97aa                	add	a5,a5,a0
 6aa:	0007c783          	lbu	a5,0(a5)
 6ae:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 6b2:	0005879b          	sext.w	a5,a1
 6b6:	02c5d5bb          	divuw	a1,a1,a2
 6ba:	0685                	addi	a3,a3,1
 6bc:	fec7f0e3          	bgeu	a5,a2,69c <printint+0x2a>
  if(neg)
 6c0:	00088b63          	beqz	a7,6d6 <printint+0x64>
    buf[i++] = '-';
 6c4:	fd040793          	addi	a5,s0,-48
 6c8:	973e                	add	a4,a4,a5
 6ca:	02d00793          	li	a5,45
 6ce:	fef70823          	sb	a5,-16(a4)
 6d2:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 6d6:	02e05863          	blez	a4,706 <printint+0x94>
 6da:	fc040793          	addi	a5,s0,-64
 6de:	00e78933          	add	s2,a5,a4
 6e2:	fff78993          	addi	s3,a5,-1
 6e6:	99ba                	add	s3,s3,a4
 6e8:	377d                	addiw	a4,a4,-1
 6ea:	1702                	slli	a4,a4,0x20
 6ec:	9301                	srli	a4,a4,0x20
 6ee:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 6f2:	fff94583          	lbu	a1,-1(s2)
 6f6:	8526                	mv	a0,s1
 6f8:	00000097          	auipc	ra,0x0
 6fc:	f58080e7          	jalr	-168(ra) # 650 <putc>
  while(--i >= 0)
 700:	197d                	addi	s2,s2,-1
 702:	ff3918e3          	bne	s2,s3,6f2 <printint+0x80>
}
 706:	70e2                	ld	ra,56(sp)
 708:	7442                	ld	s0,48(sp)
 70a:	74a2                	ld	s1,40(sp)
 70c:	7902                	ld	s2,32(sp)
 70e:	69e2                	ld	s3,24(sp)
 710:	6121                	addi	sp,sp,64
 712:	8082                	ret
    x = -xx;
 714:	40b005bb          	negw	a1,a1
    neg = 1;
 718:	4885                	li	a7,1
    x = -xx;
 71a:	bf8d                	j	68c <printint+0x1a>

000000000000071c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 71c:	7119                	addi	sp,sp,-128
 71e:	fc86                	sd	ra,120(sp)
 720:	f8a2                	sd	s0,112(sp)
 722:	f4a6                	sd	s1,104(sp)
 724:	f0ca                	sd	s2,96(sp)
 726:	ecce                	sd	s3,88(sp)
 728:	e8d2                	sd	s4,80(sp)
 72a:	e4d6                	sd	s5,72(sp)
 72c:	e0da                	sd	s6,64(sp)
 72e:	fc5e                	sd	s7,56(sp)
 730:	f862                	sd	s8,48(sp)
 732:	f466                	sd	s9,40(sp)
 734:	f06a                	sd	s10,32(sp)
 736:	ec6e                	sd	s11,24(sp)
 738:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 73a:	0005c903          	lbu	s2,0(a1)
 73e:	18090f63          	beqz	s2,8dc <vprintf+0x1c0>
 742:	8aaa                	mv	s5,a0
 744:	8b32                	mv	s6,a2
 746:	00158493          	addi	s1,a1,1
  state = 0;
 74a:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 74c:	02500a13          	li	s4,37
      if(c == 'd'){
 750:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 754:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 758:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 75c:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 760:	00000b97          	auipc	s7,0x0
 764:	410b8b93          	addi	s7,s7,1040 # b70 <digits>
 768:	a839                	j	786 <vprintf+0x6a>
        putc(fd, c);
 76a:	85ca                	mv	a1,s2
 76c:	8556                	mv	a0,s5
 76e:	00000097          	auipc	ra,0x0
 772:	ee2080e7          	jalr	-286(ra) # 650 <putc>
 776:	a019                	j	77c <vprintf+0x60>
    } else if(state == '%'){
 778:	01498f63          	beq	s3,s4,796 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 77c:	0485                	addi	s1,s1,1
 77e:	fff4c903          	lbu	s2,-1(s1)
 782:	14090d63          	beqz	s2,8dc <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 786:	0009079b          	sext.w	a5,s2
    if(state == 0){
 78a:	fe0997e3          	bnez	s3,778 <vprintf+0x5c>
      if(c == '%'){
 78e:	fd479ee3          	bne	a5,s4,76a <vprintf+0x4e>
        state = '%';
 792:	89be                	mv	s3,a5
 794:	b7e5                	j	77c <vprintf+0x60>
      if(c == 'd'){
 796:	05878063          	beq	a5,s8,7d6 <vprintf+0xba>
      } else if(c == 'l') {
 79a:	05978c63          	beq	a5,s9,7f2 <vprintf+0xd6>
      } else if(c == 'x') {
 79e:	07a78863          	beq	a5,s10,80e <vprintf+0xf2>
      } else if(c == 'p') {
 7a2:	09b78463          	beq	a5,s11,82a <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 7a6:	07300713          	li	a4,115
 7aa:	0ce78663          	beq	a5,a4,876 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 7ae:	06300713          	li	a4,99
 7b2:	0ee78e63          	beq	a5,a4,8ae <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 7b6:	11478863          	beq	a5,s4,8c6 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 7ba:	85d2                	mv	a1,s4
 7bc:	8556                	mv	a0,s5
 7be:	00000097          	auipc	ra,0x0
 7c2:	e92080e7          	jalr	-366(ra) # 650 <putc>
        putc(fd, c);
 7c6:	85ca                	mv	a1,s2
 7c8:	8556                	mv	a0,s5
 7ca:	00000097          	auipc	ra,0x0
 7ce:	e86080e7          	jalr	-378(ra) # 650 <putc>
      }
      state = 0;
 7d2:	4981                	li	s3,0
 7d4:	b765                	j	77c <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 7d6:	008b0913          	addi	s2,s6,8
 7da:	4685                	li	a3,1
 7dc:	4629                	li	a2,10
 7de:	000b2583          	lw	a1,0(s6)
 7e2:	8556                	mv	a0,s5
 7e4:	00000097          	auipc	ra,0x0
 7e8:	e8e080e7          	jalr	-370(ra) # 672 <printint>
 7ec:	8b4a                	mv	s6,s2
      state = 0;
 7ee:	4981                	li	s3,0
 7f0:	b771                	j	77c <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7f2:	008b0913          	addi	s2,s6,8
 7f6:	4681                	li	a3,0
 7f8:	4629                	li	a2,10
 7fa:	000b2583          	lw	a1,0(s6)
 7fe:	8556                	mv	a0,s5
 800:	00000097          	auipc	ra,0x0
 804:	e72080e7          	jalr	-398(ra) # 672 <printint>
 808:	8b4a                	mv	s6,s2
      state = 0;
 80a:	4981                	li	s3,0
 80c:	bf85                	j	77c <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 80e:	008b0913          	addi	s2,s6,8
 812:	4681                	li	a3,0
 814:	4641                	li	a2,16
 816:	000b2583          	lw	a1,0(s6)
 81a:	8556                	mv	a0,s5
 81c:	00000097          	auipc	ra,0x0
 820:	e56080e7          	jalr	-426(ra) # 672 <printint>
 824:	8b4a                	mv	s6,s2
      state = 0;
 826:	4981                	li	s3,0
 828:	bf91                	j	77c <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 82a:	008b0793          	addi	a5,s6,8
 82e:	f8f43423          	sd	a5,-120(s0)
 832:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 836:	03000593          	li	a1,48
 83a:	8556                	mv	a0,s5
 83c:	00000097          	auipc	ra,0x0
 840:	e14080e7          	jalr	-492(ra) # 650 <putc>
  putc(fd, 'x');
 844:	85ea                	mv	a1,s10
 846:	8556                	mv	a0,s5
 848:	00000097          	auipc	ra,0x0
 84c:	e08080e7          	jalr	-504(ra) # 650 <putc>
 850:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 852:	03c9d793          	srli	a5,s3,0x3c
 856:	97de                	add	a5,a5,s7
 858:	0007c583          	lbu	a1,0(a5)
 85c:	8556                	mv	a0,s5
 85e:	00000097          	auipc	ra,0x0
 862:	df2080e7          	jalr	-526(ra) # 650 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 866:	0992                	slli	s3,s3,0x4
 868:	397d                	addiw	s2,s2,-1
 86a:	fe0914e3          	bnez	s2,852 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 86e:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 872:	4981                	li	s3,0
 874:	b721                	j	77c <vprintf+0x60>
        s = va_arg(ap, char*);
 876:	008b0993          	addi	s3,s6,8
 87a:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 87e:	02090163          	beqz	s2,8a0 <vprintf+0x184>
        while(*s != 0){
 882:	00094583          	lbu	a1,0(s2)
 886:	c9a1                	beqz	a1,8d6 <vprintf+0x1ba>
          putc(fd, *s);
 888:	8556                	mv	a0,s5
 88a:	00000097          	auipc	ra,0x0
 88e:	dc6080e7          	jalr	-570(ra) # 650 <putc>
          s++;
 892:	0905                	addi	s2,s2,1
        while(*s != 0){
 894:	00094583          	lbu	a1,0(s2)
 898:	f9e5                	bnez	a1,888 <vprintf+0x16c>
        s = va_arg(ap, char*);
 89a:	8b4e                	mv	s6,s3
      state = 0;
 89c:	4981                	li	s3,0
 89e:	bdf9                	j	77c <vprintf+0x60>
          s = "(null)";
 8a0:	00000917          	auipc	s2,0x0
 8a4:	2c890913          	addi	s2,s2,712 # b68 <malloc+0x182>
        while(*s != 0){
 8a8:	02800593          	li	a1,40
 8ac:	bff1                	j	888 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 8ae:	008b0913          	addi	s2,s6,8
 8b2:	000b4583          	lbu	a1,0(s6)
 8b6:	8556                	mv	a0,s5
 8b8:	00000097          	auipc	ra,0x0
 8bc:	d98080e7          	jalr	-616(ra) # 650 <putc>
 8c0:	8b4a                	mv	s6,s2
      state = 0;
 8c2:	4981                	li	s3,0
 8c4:	bd65                	j	77c <vprintf+0x60>
        putc(fd, c);
 8c6:	85d2                	mv	a1,s4
 8c8:	8556                	mv	a0,s5
 8ca:	00000097          	auipc	ra,0x0
 8ce:	d86080e7          	jalr	-634(ra) # 650 <putc>
      state = 0;
 8d2:	4981                	li	s3,0
 8d4:	b565                	j	77c <vprintf+0x60>
        s = va_arg(ap, char*);
 8d6:	8b4e                	mv	s6,s3
      state = 0;
 8d8:	4981                	li	s3,0
 8da:	b54d                	j	77c <vprintf+0x60>
    }
  }
}
 8dc:	70e6                	ld	ra,120(sp)
 8de:	7446                	ld	s0,112(sp)
 8e0:	74a6                	ld	s1,104(sp)
 8e2:	7906                	ld	s2,96(sp)
 8e4:	69e6                	ld	s3,88(sp)
 8e6:	6a46                	ld	s4,80(sp)
 8e8:	6aa6                	ld	s5,72(sp)
 8ea:	6b06                	ld	s6,64(sp)
 8ec:	7be2                	ld	s7,56(sp)
 8ee:	7c42                	ld	s8,48(sp)
 8f0:	7ca2                	ld	s9,40(sp)
 8f2:	7d02                	ld	s10,32(sp)
 8f4:	6de2                	ld	s11,24(sp)
 8f6:	6109                	addi	sp,sp,128
 8f8:	8082                	ret

00000000000008fa <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8fa:	715d                	addi	sp,sp,-80
 8fc:	ec06                	sd	ra,24(sp)
 8fe:	e822                	sd	s0,16(sp)
 900:	1000                	addi	s0,sp,32
 902:	e010                	sd	a2,0(s0)
 904:	e414                	sd	a3,8(s0)
 906:	e818                	sd	a4,16(s0)
 908:	ec1c                	sd	a5,24(s0)
 90a:	03043023          	sd	a6,32(s0)
 90e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 912:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 916:	8622                	mv	a2,s0
 918:	00000097          	auipc	ra,0x0
 91c:	e04080e7          	jalr	-508(ra) # 71c <vprintf>
}
 920:	60e2                	ld	ra,24(sp)
 922:	6442                	ld	s0,16(sp)
 924:	6161                	addi	sp,sp,80
 926:	8082                	ret

0000000000000928 <printf>:

void
printf(const char *fmt, ...)
{
 928:	711d                	addi	sp,sp,-96
 92a:	ec06                	sd	ra,24(sp)
 92c:	e822                	sd	s0,16(sp)
 92e:	1000                	addi	s0,sp,32
 930:	e40c                	sd	a1,8(s0)
 932:	e810                	sd	a2,16(s0)
 934:	ec14                	sd	a3,24(s0)
 936:	f018                	sd	a4,32(s0)
 938:	f41c                	sd	a5,40(s0)
 93a:	03043823          	sd	a6,48(s0)
 93e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 942:	00840613          	addi	a2,s0,8
 946:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 94a:	85aa                	mv	a1,a0
 94c:	4505                	li	a0,1
 94e:	00000097          	auipc	ra,0x0
 952:	dce080e7          	jalr	-562(ra) # 71c <vprintf>
}
 956:	60e2                	ld	ra,24(sp)
 958:	6442                	ld	s0,16(sp)
 95a:	6125                	addi	sp,sp,96
 95c:	8082                	ret

000000000000095e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 95e:	1141                	addi	sp,sp,-16
 960:	e422                	sd	s0,8(sp)
 962:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 964:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 968:	00000797          	auipc	a5,0x0
 96c:	6987b783          	ld	a5,1688(a5) # 1000 <freep>
 970:	a805                	j	9a0 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 972:	4618                	lw	a4,8(a2)
 974:	9db9                	addw	a1,a1,a4
 976:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 97a:	6398                	ld	a4,0(a5)
 97c:	6318                	ld	a4,0(a4)
 97e:	fee53823          	sd	a4,-16(a0)
 982:	a091                	j	9c6 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 984:	ff852703          	lw	a4,-8(a0)
 988:	9e39                	addw	a2,a2,a4
 98a:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 98c:	ff053703          	ld	a4,-16(a0)
 990:	e398                	sd	a4,0(a5)
 992:	a099                	j	9d8 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 994:	6398                	ld	a4,0(a5)
 996:	00e7e463          	bltu	a5,a4,99e <free+0x40>
 99a:	00e6ea63          	bltu	a3,a4,9ae <free+0x50>
{
 99e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9a0:	fed7fae3          	bgeu	a5,a3,994 <free+0x36>
 9a4:	6398                	ld	a4,0(a5)
 9a6:	00e6e463          	bltu	a3,a4,9ae <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9aa:	fee7eae3          	bltu	a5,a4,99e <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 9ae:	ff852583          	lw	a1,-8(a0)
 9b2:	6390                	ld	a2,0(a5)
 9b4:	02059713          	slli	a4,a1,0x20
 9b8:	9301                	srli	a4,a4,0x20
 9ba:	0712                	slli	a4,a4,0x4
 9bc:	9736                	add	a4,a4,a3
 9be:	fae60ae3          	beq	a2,a4,972 <free+0x14>
    bp->s.ptr = p->s.ptr;
 9c2:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 9c6:	4790                	lw	a2,8(a5)
 9c8:	02061713          	slli	a4,a2,0x20
 9cc:	9301                	srli	a4,a4,0x20
 9ce:	0712                	slli	a4,a4,0x4
 9d0:	973e                	add	a4,a4,a5
 9d2:	fae689e3          	beq	a3,a4,984 <free+0x26>
  } else
    p->s.ptr = bp;
 9d6:	e394                	sd	a3,0(a5)
  freep = p;
 9d8:	00000717          	auipc	a4,0x0
 9dc:	62f73423          	sd	a5,1576(a4) # 1000 <freep>
}
 9e0:	6422                	ld	s0,8(sp)
 9e2:	0141                	addi	sp,sp,16
 9e4:	8082                	ret

00000000000009e6 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9e6:	7139                	addi	sp,sp,-64
 9e8:	fc06                	sd	ra,56(sp)
 9ea:	f822                	sd	s0,48(sp)
 9ec:	f426                	sd	s1,40(sp)
 9ee:	f04a                	sd	s2,32(sp)
 9f0:	ec4e                	sd	s3,24(sp)
 9f2:	e852                	sd	s4,16(sp)
 9f4:	e456                	sd	s5,8(sp)
 9f6:	e05a                	sd	s6,0(sp)
 9f8:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9fa:	02051493          	slli	s1,a0,0x20
 9fe:	9081                	srli	s1,s1,0x20
 a00:	04bd                	addi	s1,s1,15
 a02:	8091                	srli	s1,s1,0x4
 a04:	0014899b          	addiw	s3,s1,1
 a08:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 a0a:	00000517          	auipc	a0,0x0
 a0e:	5f653503          	ld	a0,1526(a0) # 1000 <freep>
 a12:	c515                	beqz	a0,a3e <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a14:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a16:	4798                	lw	a4,8(a5)
 a18:	02977f63          	bgeu	a4,s1,a56 <malloc+0x70>
 a1c:	8a4e                	mv	s4,s3
 a1e:	0009871b          	sext.w	a4,s3
 a22:	6685                	lui	a3,0x1
 a24:	00d77363          	bgeu	a4,a3,a2a <malloc+0x44>
 a28:	6a05                	lui	s4,0x1
 a2a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a2e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a32:	00000917          	auipc	s2,0x0
 a36:	5ce90913          	addi	s2,s2,1486 # 1000 <freep>
  if(p == (char*)-1)
 a3a:	5afd                	li	s5,-1
 a3c:	a88d                	j	aae <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 a3e:	00000797          	auipc	a5,0x0
 a42:	5e278793          	addi	a5,a5,1506 # 1020 <base>
 a46:	00000717          	auipc	a4,0x0
 a4a:	5af73d23          	sd	a5,1466(a4) # 1000 <freep>
 a4e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a50:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a54:	b7e1                	j	a1c <malloc+0x36>
      if(p->s.size == nunits)
 a56:	02e48b63          	beq	s1,a4,a8c <malloc+0xa6>
        p->s.size -= nunits;
 a5a:	4137073b          	subw	a4,a4,s3
 a5e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a60:	1702                	slli	a4,a4,0x20
 a62:	9301                	srli	a4,a4,0x20
 a64:	0712                	slli	a4,a4,0x4
 a66:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a68:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a6c:	00000717          	auipc	a4,0x0
 a70:	58a73a23          	sd	a0,1428(a4) # 1000 <freep>
      return (void*)(p + 1);
 a74:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 a78:	70e2                	ld	ra,56(sp)
 a7a:	7442                	ld	s0,48(sp)
 a7c:	74a2                	ld	s1,40(sp)
 a7e:	7902                	ld	s2,32(sp)
 a80:	69e2                	ld	s3,24(sp)
 a82:	6a42                	ld	s4,16(sp)
 a84:	6aa2                	ld	s5,8(sp)
 a86:	6b02                	ld	s6,0(sp)
 a88:	6121                	addi	sp,sp,64
 a8a:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 a8c:	6398                	ld	a4,0(a5)
 a8e:	e118                	sd	a4,0(a0)
 a90:	bff1                	j	a6c <malloc+0x86>
  hp->s.size = nu;
 a92:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a96:	0541                	addi	a0,a0,16
 a98:	00000097          	auipc	ra,0x0
 a9c:	ec6080e7          	jalr	-314(ra) # 95e <free>
  return freep;
 aa0:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 aa4:	d971                	beqz	a0,a78 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 aa6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 aa8:	4798                	lw	a4,8(a5)
 aaa:	fa9776e3          	bgeu	a4,s1,a56 <malloc+0x70>
    if(p == freep)
 aae:	00093703          	ld	a4,0(s2)
 ab2:	853e                	mv	a0,a5
 ab4:	fef719e3          	bne	a4,a5,aa6 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 ab8:	8552                	mv	a0,s4
 aba:	00000097          	auipc	ra,0x0
 abe:	b7e080e7          	jalr	-1154(ra) # 638 <sbrk>
  if(p == (char*)-1)
 ac2:	fd5518e3          	bne	a0,s5,a92 <malloc+0xac>
        return 0;
 ac6:	4501                	li	a0,0
 ac8:	bf45                	j	a78 <malloc+0x92>
