
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <copyinstr1>:
}

// what if you pass ridiculous string pointers to system calls?
void
copyinstr1(char *s)
{
       0:	1141                	addi	sp,sp,-16
       2:	e406                	sd	ra,8(sp)
       4:	e022                	sd	s0,0(sp)
       6:	0800                	addi	s0,sp,16
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };

  for(int ai = 0; ai < 2; ai++){
    uint64 addr = addrs[ai];

    int fd = open((char *)addr, O_CREATE|O_WRONLY);
       8:	20100593          	li	a1,513
       c:	4505                	li	a0,1
       e:	057e                	slli	a0,a0,0x1f
      10:	00006097          	auipc	ra,0x6
      14:	c16080e7          	jalr	-1002(ra) # 5c26 <open>
    if(fd >= 0){
      18:	02055063          	bgez	a0,38 <copyinstr1+0x38>
    int fd = open((char *)addr, O_CREATE|O_WRONLY);
      1c:	20100593          	li	a1,513
      20:	557d                	li	a0,-1
      22:	00006097          	auipc	ra,0x6
      26:	c04080e7          	jalr	-1020(ra) # 5c26 <open>
    uint64 addr = addrs[ai];
      2a:	55fd                	li	a1,-1
    if(fd >= 0){
      2c:	00055863          	bgez	a0,3c <copyinstr1+0x3c>
      printf("open(%p) returned %d, not -1\n", addr, fd);
      exit(1);
    }
  }
}
      30:	60a2                	ld	ra,8(sp)
      32:	6402                	ld	s0,0(sp)
      34:	0141                	addi	sp,sp,16
      36:	8082                	ret
    uint64 addr = addrs[ai];
      38:	4585                	li	a1,1
      3a:	05fe                	slli	a1,a1,0x1f
      printf("open(%p) returned %d, not -1\n", addr, fd);
      3c:	862a                	mv	a2,a0
      3e:	00006517          	auipc	a0,0x6
      42:	0f250513          	addi	a0,a0,242 # 6130 <malloc+0x104>
      46:	00006097          	auipc	ra,0x6
      4a:	f28080e7          	jalr	-216(ra) # 5f6e <printf>
      exit(1);
      4e:	4505                	li	a0,1
      50:	00006097          	auipc	ra,0x6
      54:	b96080e7          	jalr	-1130(ra) # 5be6 <exit>

0000000000000058 <bsstest>:
void
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
      58:	0000a797          	auipc	a5,0xa
      5c:	51078793          	addi	a5,a5,1296 # a568 <uninit>
      60:	0000d697          	auipc	a3,0xd
      64:	c1868693          	addi	a3,a3,-1000 # cc78 <buf>
    if(uninit[i] != '\0'){
      68:	0007c703          	lbu	a4,0(a5)
      6c:	e709                	bnez	a4,76 <bsstest+0x1e>
  for(i = 0; i < sizeof(uninit); i++){
      6e:	0785                	addi	a5,a5,1
      70:	fed79ce3          	bne	a5,a3,68 <bsstest+0x10>
      74:	8082                	ret
{
      76:	1141                	addi	sp,sp,-16
      78:	e406                	sd	ra,8(sp)
      7a:	e022                	sd	s0,0(sp)
      7c:	0800                	addi	s0,sp,16
      printf("%s: bss test failed\n", s);
      7e:	85aa                	mv	a1,a0
      80:	00006517          	auipc	a0,0x6
      84:	0d050513          	addi	a0,a0,208 # 6150 <malloc+0x124>
      88:	00006097          	auipc	ra,0x6
      8c:	ee6080e7          	jalr	-282(ra) # 5f6e <printf>
      exit(1);
      90:	4505                	li	a0,1
      92:	00006097          	auipc	ra,0x6
      96:	b54080e7          	jalr	-1196(ra) # 5be6 <exit>

000000000000009a <opentest>:
{
      9a:	1101                	addi	sp,sp,-32
      9c:	ec06                	sd	ra,24(sp)
      9e:	e822                	sd	s0,16(sp)
      a0:	e426                	sd	s1,8(sp)
      a2:	1000                	addi	s0,sp,32
      a4:	84aa                	mv	s1,a0
  fd = open("echo", 0);
      a6:	4581                	li	a1,0
      a8:	00006517          	auipc	a0,0x6
      ac:	0c050513          	addi	a0,a0,192 # 6168 <malloc+0x13c>
      b0:	00006097          	auipc	ra,0x6
      b4:	b76080e7          	jalr	-1162(ra) # 5c26 <open>
  if(fd < 0){
      b8:	02054663          	bltz	a0,e4 <opentest+0x4a>
  close(fd);
      bc:	00006097          	auipc	ra,0x6
      c0:	b52080e7          	jalr	-1198(ra) # 5c0e <close>
  fd = open("doesnotexist", 0);
      c4:	4581                	li	a1,0
      c6:	00006517          	auipc	a0,0x6
      ca:	0c250513          	addi	a0,a0,194 # 6188 <malloc+0x15c>
      ce:	00006097          	auipc	ra,0x6
      d2:	b58080e7          	jalr	-1192(ra) # 5c26 <open>
  if(fd >= 0){
      d6:	02055563          	bgez	a0,100 <opentest+0x66>
}
      da:	60e2                	ld	ra,24(sp)
      dc:	6442                	ld	s0,16(sp)
      de:	64a2                	ld	s1,8(sp)
      e0:	6105                	addi	sp,sp,32
      e2:	8082                	ret
    printf("%s: open echo failed!\n", s);
      e4:	85a6                	mv	a1,s1
      e6:	00006517          	auipc	a0,0x6
      ea:	08a50513          	addi	a0,a0,138 # 6170 <malloc+0x144>
      ee:	00006097          	auipc	ra,0x6
      f2:	e80080e7          	jalr	-384(ra) # 5f6e <printf>
    exit(1);
      f6:	4505                	li	a0,1
      f8:	00006097          	auipc	ra,0x6
      fc:	aee080e7          	jalr	-1298(ra) # 5be6 <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     100:	85a6                	mv	a1,s1
     102:	00006517          	auipc	a0,0x6
     106:	09650513          	addi	a0,a0,150 # 6198 <malloc+0x16c>
     10a:	00006097          	auipc	ra,0x6
     10e:	e64080e7          	jalr	-412(ra) # 5f6e <printf>
    exit(1);
     112:	4505                	li	a0,1
     114:	00006097          	auipc	ra,0x6
     118:	ad2080e7          	jalr	-1326(ra) # 5be6 <exit>

000000000000011c <truncate2>:
{
     11c:	7179                	addi	sp,sp,-48
     11e:	f406                	sd	ra,40(sp)
     120:	f022                	sd	s0,32(sp)
     122:	ec26                	sd	s1,24(sp)
     124:	e84a                	sd	s2,16(sp)
     126:	e44e                	sd	s3,8(sp)
     128:	1800                	addi	s0,sp,48
     12a:	89aa                	mv	s3,a0
  unlink("truncfile");
     12c:	00006517          	auipc	a0,0x6
     130:	09450513          	addi	a0,a0,148 # 61c0 <malloc+0x194>
     134:	00006097          	auipc	ra,0x6
     138:	b02080e7          	jalr	-1278(ra) # 5c36 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     13c:	60100593          	li	a1,1537
     140:	00006517          	auipc	a0,0x6
     144:	08050513          	addi	a0,a0,128 # 61c0 <malloc+0x194>
     148:	00006097          	auipc	ra,0x6
     14c:	ade080e7          	jalr	-1314(ra) # 5c26 <open>
     150:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     152:	4611                	li	a2,4
     154:	00006597          	auipc	a1,0x6
     158:	07c58593          	addi	a1,a1,124 # 61d0 <malloc+0x1a4>
     15c:	00006097          	auipc	ra,0x6
     160:	aaa080e7          	jalr	-1366(ra) # 5c06 <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     164:	40100593          	li	a1,1025
     168:	00006517          	auipc	a0,0x6
     16c:	05850513          	addi	a0,a0,88 # 61c0 <malloc+0x194>
     170:	00006097          	auipc	ra,0x6
     174:	ab6080e7          	jalr	-1354(ra) # 5c26 <open>
     178:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     17a:	4605                	li	a2,1
     17c:	00006597          	auipc	a1,0x6
     180:	05c58593          	addi	a1,a1,92 # 61d8 <malloc+0x1ac>
     184:	8526                	mv	a0,s1
     186:	00006097          	auipc	ra,0x6
     18a:	a80080e7          	jalr	-1408(ra) # 5c06 <write>
  if(n != -1){
     18e:	57fd                	li	a5,-1
     190:	02f51b63          	bne	a0,a5,1c6 <truncate2+0xaa>
  unlink("truncfile");
     194:	00006517          	auipc	a0,0x6
     198:	02c50513          	addi	a0,a0,44 # 61c0 <malloc+0x194>
     19c:	00006097          	auipc	ra,0x6
     1a0:	a9a080e7          	jalr	-1382(ra) # 5c36 <unlink>
  close(fd1);
     1a4:	8526                	mv	a0,s1
     1a6:	00006097          	auipc	ra,0x6
     1aa:	a68080e7          	jalr	-1432(ra) # 5c0e <close>
  close(fd2);
     1ae:	854a                	mv	a0,s2
     1b0:	00006097          	auipc	ra,0x6
     1b4:	a5e080e7          	jalr	-1442(ra) # 5c0e <close>
}
     1b8:	70a2                	ld	ra,40(sp)
     1ba:	7402                	ld	s0,32(sp)
     1bc:	64e2                	ld	s1,24(sp)
     1be:	6942                	ld	s2,16(sp)
     1c0:	69a2                	ld	s3,8(sp)
     1c2:	6145                	addi	sp,sp,48
     1c4:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     1c6:	862a                	mv	a2,a0
     1c8:	85ce                	mv	a1,s3
     1ca:	00006517          	auipc	a0,0x6
     1ce:	01650513          	addi	a0,a0,22 # 61e0 <malloc+0x1b4>
     1d2:	00006097          	auipc	ra,0x6
     1d6:	d9c080e7          	jalr	-612(ra) # 5f6e <printf>
    exit(1);
     1da:	4505                	li	a0,1
     1dc:	00006097          	auipc	ra,0x6
     1e0:	a0a080e7          	jalr	-1526(ra) # 5be6 <exit>

00000000000001e4 <createtest>:
{
     1e4:	7179                	addi	sp,sp,-48
     1e6:	f406                	sd	ra,40(sp)
     1e8:	f022                	sd	s0,32(sp)
     1ea:	ec26                	sd	s1,24(sp)
     1ec:	e84a                	sd	s2,16(sp)
     1ee:	1800                	addi	s0,sp,48
  name[0] = 'a';
     1f0:	06100793          	li	a5,97
     1f4:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     1f8:	fc040d23          	sb	zero,-38(s0)
     1fc:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     200:	06400913          	li	s2,100
    name[1] = '0' + i;
     204:	fc940ca3          	sb	s1,-39(s0)
    fd = open(name, O_CREATE|O_RDWR);
     208:	20200593          	li	a1,514
     20c:	fd840513          	addi	a0,s0,-40
     210:	00006097          	auipc	ra,0x6
     214:	a16080e7          	jalr	-1514(ra) # 5c26 <open>
    close(fd);
     218:	00006097          	auipc	ra,0x6
     21c:	9f6080e7          	jalr	-1546(ra) # 5c0e <close>
  for(i = 0; i < N; i++){
     220:	2485                	addiw	s1,s1,1
     222:	0ff4f493          	andi	s1,s1,255
     226:	fd249fe3          	bne	s1,s2,204 <createtest+0x20>
  name[0] = 'a';
     22a:	06100793          	li	a5,97
     22e:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     232:	fc040d23          	sb	zero,-38(s0)
     236:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     23a:	06400913          	li	s2,100
    name[1] = '0' + i;
     23e:	fc940ca3          	sb	s1,-39(s0)
    unlink(name);
     242:	fd840513          	addi	a0,s0,-40
     246:	00006097          	auipc	ra,0x6
     24a:	9f0080e7          	jalr	-1552(ra) # 5c36 <unlink>
  for(i = 0; i < N; i++){
     24e:	2485                	addiw	s1,s1,1
     250:	0ff4f493          	andi	s1,s1,255
     254:	ff2495e3          	bne	s1,s2,23e <createtest+0x5a>
}
     258:	70a2                	ld	ra,40(sp)
     25a:	7402                	ld	s0,32(sp)
     25c:	64e2                	ld	s1,24(sp)
     25e:	6942                	ld	s2,16(sp)
     260:	6145                	addi	sp,sp,48
     262:	8082                	ret

0000000000000264 <bigwrite>:
{
     264:	715d                	addi	sp,sp,-80
     266:	e486                	sd	ra,72(sp)
     268:	e0a2                	sd	s0,64(sp)
     26a:	fc26                	sd	s1,56(sp)
     26c:	f84a                	sd	s2,48(sp)
     26e:	f44e                	sd	s3,40(sp)
     270:	f052                	sd	s4,32(sp)
     272:	ec56                	sd	s5,24(sp)
     274:	e85a                	sd	s6,16(sp)
     276:	e45e                	sd	s7,8(sp)
     278:	0880                	addi	s0,sp,80
     27a:	8baa                	mv	s7,a0
  unlink("bigwrite");
     27c:	00006517          	auipc	a0,0x6
     280:	f8c50513          	addi	a0,a0,-116 # 6208 <malloc+0x1dc>
     284:	00006097          	auipc	ra,0x6
     288:	9b2080e7          	jalr	-1614(ra) # 5c36 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     28c:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     290:	00006a97          	auipc	s5,0x6
     294:	f78a8a93          	addi	s5,s5,-136 # 6208 <malloc+0x1dc>
      int cc = write(fd, buf, sz);
     298:	0000da17          	auipc	s4,0xd
     29c:	9e0a0a13          	addi	s4,s4,-1568 # cc78 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2a0:	6b0d                	lui	s6,0x3
     2a2:	1c9b0b13          	addi	s6,s6,457 # 31c9 <fourteen+0x1a3>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2a6:	20200593          	li	a1,514
     2aa:	8556                	mv	a0,s5
     2ac:	00006097          	auipc	ra,0x6
     2b0:	97a080e7          	jalr	-1670(ra) # 5c26 <open>
     2b4:	892a                	mv	s2,a0
    if(fd < 0){
     2b6:	04054d63          	bltz	a0,310 <bigwrite+0xac>
      int cc = write(fd, buf, sz);
     2ba:	8626                	mv	a2,s1
     2bc:	85d2                	mv	a1,s4
     2be:	00006097          	auipc	ra,0x6
     2c2:	948080e7          	jalr	-1720(ra) # 5c06 <write>
     2c6:	89aa                	mv	s3,a0
      if(cc != sz){
     2c8:	06a49463          	bne	s1,a0,330 <bigwrite+0xcc>
      int cc = write(fd, buf, sz);
     2cc:	8626                	mv	a2,s1
     2ce:	85d2                	mv	a1,s4
     2d0:	854a                	mv	a0,s2
     2d2:	00006097          	auipc	ra,0x6
     2d6:	934080e7          	jalr	-1740(ra) # 5c06 <write>
      if(cc != sz){
     2da:	04951963          	bne	a0,s1,32c <bigwrite+0xc8>
    close(fd);
     2de:	854a                	mv	a0,s2
     2e0:	00006097          	auipc	ra,0x6
     2e4:	92e080e7          	jalr	-1746(ra) # 5c0e <close>
    unlink("bigwrite");
     2e8:	8556                	mv	a0,s5
     2ea:	00006097          	auipc	ra,0x6
     2ee:	94c080e7          	jalr	-1716(ra) # 5c36 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2f2:	1d74849b          	addiw	s1,s1,471
     2f6:	fb6498e3          	bne	s1,s6,2a6 <bigwrite+0x42>
}
     2fa:	60a6                	ld	ra,72(sp)
     2fc:	6406                	ld	s0,64(sp)
     2fe:	74e2                	ld	s1,56(sp)
     300:	7942                	ld	s2,48(sp)
     302:	79a2                	ld	s3,40(sp)
     304:	7a02                	ld	s4,32(sp)
     306:	6ae2                	ld	s5,24(sp)
     308:	6b42                	ld	s6,16(sp)
     30a:	6ba2                	ld	s7,8(sp)
     30c:	6161                	addi	sp,sp,80
     30e:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     310:	85de                	mv	a1,s7
     312:	00006517          	auipc	a0,0x6
     316:	f0650513          	addi	a0,a0,-250 # 6218 <malloc+0x1ec>
     31a:	00006097          	auipc	ra,0x6
     31e:	c54080e7          	jalr	-940(ra) # 5f6e <printf>
      exit(1);
     322:	4505                	li	a0,1
     324:	00006097          	auipc	ra,0x6
     328:	8c2080e7          	jalr	-1854(ra) # 5be6 <exit>
     32c:	84ce                	mv	s1,s3
      int cc = write(fd, buf, sz);
     32e:	89aa                	mv	s3,a0
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     330:	86ce                	mv	a3,s3
     332:	8626                	mv	a2,s1
     334:	85de                	mv	a1,s7
     336:	00006517          	auipc	a0,0x6
     33a:	f0250513          	addi	a0,a0,-254 # 6238 <malloc+0x20c>
     33e:	00006097          	auipc	ra,0x6
     342:	c30080e7          	jalr	-976(ra) # 5f6e <printf>
        exit(1);
     346:	4505                	li	a0,1
     348:	00006097          	auipc	ra,0x6
     34c:	89e080e7          	jalr	-1890(ra) # 5be6 <exit>

0000000000000350 <badwrite>:
// file is deleted? if the kernel has this bug, it will panic: balloc:
// out of blocks. assumed_free may need to be raised to be more than
// the number of free blocks. this test takes a long time.
void
badwrite(char *s)
{
     350:	7179                	addi	sp,sp,-48
     352:	f406                	sd	ra,40(sp)
     354:	f022                	sd	s0,32(sp)
     356:	ec26                	sd	s1,24(sp)
     358:	e84a                	sd	s2,16(sp)
     35a:	e44e                	sd	s3,8(sp)
     35c:	e052                	sd	s4,0(sp)
     35e:	1800                	addi	s0,sp,48
  int assumed_free = 600;
  
  unlink("junk");
     360:	00006517          	auipc	a0,0x6
     364:	ef050513          	addi	a0,a0,-272 # 6250 <malloc+0x224>
     368:	00006097          	auipc	ra,0x6
     36c:	8ce080e7          	jalr	-1842(ra) # 5c36 <unlink>
     370:	25800913          	li	s2,600
  for(int i = 0; i < assumed_free; i++){
    int fd = open("junk", O_CREATE|O_WRONLY);
     374:	00006997          	auipc	s3,0x6
     378:	edc98993          	addi	s3,s3,-292 # 6250 <malloc+0x224>
    if(fd < 0){
      printf("open junk failed\n");
      exit(1);
    }
    write(fd, (char*)0xffffffffffL, 1);
     37c:	5a7d                	li	s4,-1
     37e:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
     382:	20100593          	li	a1,513
     386:	854e                	mv	a0,s3
     388:	00006097          	auipc	ra,0x6
     38c:	89e080e7          	jalr	-1890(ra) # 5c26 <open>
     390:	84aa                	mv	s1,a0
    if(fd < 0){
     392:	06054b63          	bltz	a0,408 <badwrite+0xb8>
    write(fd, (char*)0xffffffffffL, 1);
     396:	4605                	li	a2,1
     398:	85d2                	mv	a1,s4
     39a:	00006097          	auipc	ra,0x6
     39e:	86c080e7          	jalr	-1940(ra) # 5c06 <write>
    close(fd);
     3a2:	8526                	mv	a0,s1
     3a4:	00006097          	auipc	ra,0x6
     3a8:	86a080e7          	jalr	-1942(ra) # 5c0e <close>
    unlink("junk");
     3ac:	854e                	mv	a0,s3
     3ae:	00006097          	auipc	ra,0x6
     3b2:	888080e7          	jalr	-1912(ra) # 5c36 <unlink>
  for(int i = 0; i < assumed_free; i++){
     3b6:	397d                	addiw	s2,s2,-1
     3b8:	fc0915e3          	bnez	s2,382 <badwrite+0x32>
  }

  int fd = open("junk", O_CREATE|O_WRONLY);
     3bc:	20100593          	li	a1,513
     3c0:	00006517          	auipc	a0,0x6
     3c4:	e9050513          	addi	a0,a0,-368 # 6250 <malloc+0x224>
     3c8:	00006097          	auipc	ra,0x6
     3cc:	85e080e7          	jalr	-1954(ra) # 5c26 <open>
     3d0:	84aa                	mv	s1,a0
  if(fd < 0){
     3d2:	04054863          	bltz	a0,422 <badwrite+0xd2>
    printf("open junk failed\n");
    exit(1);
  }
  if(write(fd, "x", 1) != 1){
     3d6:	4605                	li	a2,1
     3d8:	00006597          	auipc	a1,0x6
     3dc:	e0058593          	addi	a1,a1,-512 # 61d8 <malloc+0x1ac>
     3e0:	00006097          	auipc	ra,0x6
     3e4:	826080e7          	jalr	-2010(ra) # 5c06 <write>
     3e8:	4785                	li	a5,1
     3ea:	04f50963          	beq	a0,a5,43c <badwrite+0xec>
    printf("write failed\n");
     3ee:	00006517          	auipc	a0,0x6
     3f2:	e8250513          	addi	a0,a0,-382 # 6270 <malloc+0x244>
     3f6:	00006097          	auipc	ra,0x6
     3fa:	b78080e7          	jalr	-1160(ra) # 5f6e <printf>
    exit(1);
     3fe:	4505                	li	a0,1
     400:	00005097          	auipc	ra,0x5
     404:	7e6080e7          	jalr	2022(ra) # 5be6 <exit>
      printf("open junk failed\n");
     408:	00006517          	auipc	a0,0x6
     40c:	e5050513          	addi	a0,a0,-432 # 6258 <malloc+0x22c>
     410:	00006097          	auipc	ra,0x6
     414:	b5e080e7          	jalr	-1186(ra) # 5f6e <printf>
      exit(1);
     418:	4505                	li	a0,1
     41a:	00005097          	auipc	ra,0x5
     41e:	7cc080e7          	jalr	1996(ra) # 5be6 <exit>
    printf("open junk failed\n");
     422:	00006517          	auipc	a0,0x6
     426:	e3650513          	addi	a0,a0,-458 # 6258 <malloc+0x22c>
     42a:	00006097          	auipc	ra,0x6
     42e:	b44080e7          	jalr	-1212(ra) # 5f6e <printf>
    exit(1);
     432:	4505                	li	a0,1
     434:	00005097          	auipc	ra,0x5
     438:	7b2080e7          	jalr	1970(ra) # 5be6 <exit>
  }
  close(fd);
     43c:	8526                	mv	a0,s1
     43e:	00005097          	auipc	ra,0x5
     442:	7d0080e7          	jalr	2000(ra) # 5c0e <close>
  unlink("junk");
     446:	00006517          	auipc	a0,0x6
     44a:	e0a50513          	addi	a0,a0,-502 # 6250 <malloc+0x224>
     44e:	00005097          	auipc	ra,0x5
     452:	7e8080e7          	jalr	2024(ra) # 5c36 <unlink>

  exit(0);
     456:	4501                	li	a0,0
     458:	00005097          	auipc	ra,0x5
     45c:	78e080e7          	jalr	1934(ra) # 5be6 <exit>

0000000000000460 <outofinodes>:
  }
}

void
outofinodes(char *s)
{
     460:	715d                	addi	sp,sp,-80
     462:	e486                	sd	ra,72(sp)
     464:	e0a2                	sd	s0,64(sp)
     466:	fc26                	sd	s1,56(sp)
     468:	f84a                	sd	s2,48(sp)
     46a:	f44e                	sd	s3,40(sp)
     46c:	0880                	addi	s0,sp,80
  int nzz = 32*32;
  for(int i = 0; i < nzz; i++){
     46e:	4481                	li	s1,0
    char name[32];
    name[0] = 'z';
     470:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
     474:	40000993          	li	s3,1024
    name[0] = 'z';
     478:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
     47c:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
     480:	41f4d79b          	sraiw	a5,s1,0x1f
     484:	01b7d71b          	srliw	a4,a5,0x1b
     488:	009707bb          	addw	a5,a4,s1
     48c:	4057d69b          	sraiw	a3,a5,0x5
     490:	0306869b          	addiw	a3,a3,48
     494:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
     498:	8bfd                	andi	a5,a5,31
     49a:	9f99                	subw	a5,a5,a4
     49c:	0307879b          	addiw	a5,a5,48
     4a0:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
     4a4:	fa040a23          	sb	zero,-76(s0)
    unlink(name);
     4a8:	fb040513          	addi	a0,s0,-80
     4ac:	00005097          	auipc	ra,0x5
     4b0:	78a080e7          	jalr	1930(ra) # 5c36 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
     4b4:	60200593          	li	a1,1538
     4b8:	fb040513          	addi	a0,s0,-80
     4bc:	00005097          	auipc	ra,0x5
     4c0:	76a080e7          	jalr	1898(ra) # 5c26 <open>
    if(fd < 0){
     4c4:	00054963          	bltz	a0,4d6 <outofinodes+0x76>
      // failure is eventually expected.
      break;
    }
    close(fd);
     4c8:	00005097          	auipc	ra,0x5
     4cc:	746080e7          	jalr	1862(ra) # 5c0e <close>
  for(int i = 0; i < nzz; i++){
     4d0:	2485                	addiw	s1,s1,1
     4d2:	fb3493e3          	bne	s1,s3,478 <outofinodes+0x18>
     4d6:	4481                	li	s1,0
  }

  for(int i = 0; i < nzz; i++){
    char name[32];
    name[0] = 'z';
     4d8:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
     4dc:	40000993          	li	s3,1024
    name[0] = 'z';
     4e0:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
     4e4:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
     4e8:	41f4d79b          	sraiw	a5,s1,0x1f
     4ec:	01b7d71b          	srliw	a4,a5,0x1b
     4f0:	009707bb          	addw	a5,a4,s1
     4f4:	4057d69b          	sraiw	a3,a5,0x5
     4f8:	0306869b          	addiw	a3,a3,48
     4fc:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
     500:	8bfd                	andi	a5,a5,31
     502:	9f99                	subw	a5,a5,a4
     504:	0307879b          	addiw	a5,a5,48
     508:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
     50c:	fa040a23          	sb	zero,-76(s0)
    unlink(name);
     510:	fb040513          	addi	a0,s0,-80
     514:	00005097          	auipc	ra,0x5
     518:	722080e7          	jalr	1826(ra) # 5c36 <unlink>
  for(int i = 0; i < nzz; i++){
     51c:	2485                	addiw	s1,s1,1
     51e:	fd3491e3          	bne	s1,s3,4e0 <outofinodes+0x80>
  }
}
     522:	60a6                	ld	ra,72(sp)
     524:	6406                	ld	s0,64(sp)
     526:	74e2                	ld	s1,56(sp)
     528:	7942                	ld	s2,48(sp)
     52a:	79a2                	ld	s3,40(sp)
     52c:	6161                	addi	sp,sp,80
     52e:	8082                	ret

0000000000000530 <copyin>:
{
     530:	715d                	addi	sp,sp,-80
     532:	e486                	sd	ra,72(sp)
     534:	e0a2                	sd	s0,64(sp)
     536:	fc26                	sd	s1,56(sp)
     538:	f84a                	sd	s2,48(sp)
     53a:	f44e                	sd	s3,40(sp)
     53c:	f052                	sd	s4,32(sp)
     53e:	0880                	addi	s0,sp,80
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     540:	4785                	li	a5,1
     542:	07fe                	slli	a5,a5,0x1f
     544:	fcf43023          	sd	a5,-64(s0)
     548:	57fd                	li	a5,-1
     54a:	fcf43423          	sd	a5,-56(s0)
  for(int ai = 0; ai < 2; ai++){
     54e:	fc040913          	addi	s2,s0,-64
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     552:	00006a17          	auipc	s4,0x6
     556:	d2ea0a13          	addi	s4,s4,-722 # 6280 <malloc+0x254>
    uint64 addr = addrs[ai];
     55a:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     55e:	20100593          	li	a1,513
     562:	8552                	mv	a0,s4
     564:	00005097          	auipc	ra,0x5
     568:	6c2080e7          	jalr	1730(ra) # 5c26 <open>
     56c:	84aa                	mv	s1,a0
    if(fd < 0){
     56e:	08054863          	bltz	a0,5fe <copyin+0xce>
    int n = write(fd, (void*)addr, 8192);
     572:	6609                	lui	a2,0x2
     574:	85ce                	mv	a1,s3
     576:	00005097          	auipc	ra,0x5
     57a:	690080e7          	jalr	1680(ra) # 5c06 <write>
    if(n >= 0){
     57e:	08055d63          	bgez	a0,618 <copyin+0xe8>
    close(fd);
     582:	8526                	mv	a0,s1
     584:	00005097          	auipc	ra,0x5
     588:	68a080e7          	jalr	1674(ra) # 5c0e <close>
    unlink("copyin1");
     58c:	8552                	mv	a0,s4
     58e:	00005097          	auipc	ra,0x5
     592:	6a8080e7          	jalr	1704(ra) # 5c36 <unlink>
    n = write(1, (char*)addr, 8192);
     596:	6609                	lui	a2,0x2
     598:	85ce                	mv	a1,s3
     59a:	4505                	li	a0,1
     59c:	00005097          	auipc	ra,0x5
     5a0:	66a080e7          	jalr	1642(ra) # 5c06 <write>
    if(n > 0){
     5a4:	08a04963          	bgtz	a0,636 <copyin+0x106>
    if(pipe(fds) < 0){
     5a8:	fb840513          	addi	a0,s0,-72
     5ac:	00005097          	auipc	ra,0x5
     5b0:	64a080e7          	jalr	1610(ra) # 5bf6 <pipe>
     5b4:	0a054063          	bltz	a0,654 <copyin+0x124>
    n = write(fds[1], (char*)addr, 8192);
     5b8:	6609                	lui	a2,0x2
     5ba:	85ce                	mv	a1,s3
     5bc:	fbc42503          	lw	a0,-68(s0)
     5c0:	00005097          	auipc	ra,0x5
     5c4:	646080e7          	jalr	1606(ra) # 5c06 <write>
    if(n > 0){
     5c8:	0aa04363          	bgtz	a0,66e <copyin+0x13e>
    close(fds[0]);
     5cc:	fb842503          	lw	a0,-72(s0)
     5d0:	00005097          	auipc	ra,0x5
     5d4:	63e080e7          	jalr	1598(ra) # 5c0e <close>
    close(fds[1]);
     5d8:	fbc42503          	lw	a0,-68(s0)
     5dc:	00005097          	auipc	ra,0x5
     5e0:	632080e7          	jalr	1586(ra) # 5c0e <close>
  for(int ai = 0; ai < 2; ai++){
     5e4:	0921                	addi	s2,s2,8
     5e6:	fd040793          	addi	a5,s0,-48
     5ea:	f6f918e3          	bne	s2,a5,55a <copyin+0x2a>
}
     5ee:	60a6                	ld	ra,72(sp)
     5f0:	6406                	ld	s0,64(sp)
     5f2:	74e2                	ld	s1,56(sp)
     5f4:	7942                	ld	s2,48(sp)
     5f6:	79a2                	ld	s3,40(sp)
     5f8:	7a02                	ld	s4,32(sp)
     5fa:	6161                	addi	sp,sp,80
     5fc:	8082                	ret
      printf("open(copyin1) failed\n");
     5fe:	00006517          	auipc	a0,0x6
     602:	c8a50513          	addi	a0,a0,-886 # 6288 <malloc+0x25c>
     606:	00006097          	auipc	ra,0x6
     60a:	968080e7          	jalr	-1688(ra) # 5f6e <printf>
      exit(1);
     60e:	4505                	li	a0,1
     610:	00005097          	auipc	ra,0x5
     614:	5d6080e7          	jalr	1494(ra) # 5be6 <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", addr, n);
     618:	862a                	mv	a2,a0
     61a:	85ce                	mv	a1,s3
     61c:	00006517          	auipc	a0,0x6
     620:	c8450513          	addi	a0,a0,-892 # 62a0 <malloc+0x274>
     624:	00006097          	auipc	ra,0x6
     628:	94a080e7          	jalr	-1718(ra) # 5f6e <printf>
      exit(1);
     62c:	4505                	li	a0,1
     62e:	00005097          	auipc	ra,0x5
     632:	5b8080e7          	jalr	1464(ra) # 5be6 <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     636:	862a                	mv	a2,a0
     638:	85ce                	mv	a1,s3
     63a:	00006517          	auipc	a0,0x6
     63e:	c9650513          	addi	a0,a0,-874 # 62d0 <malloc+0x2a4>
     642:	00006097          	auipc	ra,0x6
     646:	92c080e7          	jalr	-1748(ra) # 5f6e <printf>
      exit(1);
     64a:	4505                	li	a0,1
     64c:	00005097          	auipc	ra,0x5
     650:	59a080e7          	jalr	1434(ra) # 5be6 <exit>
      printf("pipe() failed\n");
     654:	00006517          	auipc	a0,0x6
     658:	cac50513          	addi	a0,a0,-852 # 6300 <malloc+0x2d4>
     65c:	00006097          	auipc	ra,0x6
     660:	912080e7          	jalr	-1774(ra) # 5f6e <printf>
      exit(1);
     664:	4505                	li	a0,1
     666:	00005097          	auipc	ra,0x5
     66a:	580080e7          	jalr	1408(ra) # 5be6 <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     66e:	862a                	mv	a2,a0
     670:	85ce                	mv	a1,s3
     672:	00006517          	auipc	a0,0x6
     676:	c9e50513          	addi	a0,a0,-866 # 6310 <malloc+0x2e4>
     67a:	00006097          	auipc	ra,0x6
     67e:	8f4080e7          	jalr	-1804(ra) # 5f6e <printf>
      exit(1);
     682:	4505                	li	a0,1
     684:	00005097          	auipc	ra,0x5
     688:	562080e7          	jalr	1378(ra) # 5be6 <exit>

000000000000068c <copyout>:
{
     68c:	711d                	addi	sp,sp,-96
     68e:	ec86                	sd	ra,88(sp)
     690:	e8a2                	sd	s0,80(sp)
     692:	e4a6                	sd	s1,72(sp)
     694:	e0ca                	sd	s2,64(sp)
     696:	fc4e                	sd	s3,56(sp)
     698:	f852                	sd	s4,48(sp)
     69a:	f456                	sd	s5,40(sp)
     69c:	1080                	addi	s0,sp,96
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     69e:	4785                	li	a5,1
     6a0:	07fe                	slli	a5,a5,0x1f
     6a2:	faf43823          	sd	a5,-80(s0)
     6a6:	57fd                	li	a5,-1
     6a8:	faf43c23          	sd	a5,-72(s0)
  for(int ai = 0; ai < 2; ai++){
     6ac:	fb040913          	addi	s2,s0,-80
    int fd = open("README", 0);
     6b0:	00006a17          	auipc	s4,0x6
     6b4:	c90a0a13          	addi	s4,s4,-880 # 6340 <malloc+0x314>
    n = write(fds[1], "x", 1);
     6b8:	00006a97          	auipc	s5,0x6
     6bc:	b20a8a93          	addi	s5,s5,-1248 # 61d8 <malloc+0x1ac>
    uint64 addr = addrs[ai];
     6c0:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     6c4:	4581                	li	a1,0
     6c6:	8552                	mv	a0,s4
     6c8:	00005097          	auipc	ra,0x5
     6cc:	55e080e7          	jalr	1374(ra) # 5c26 <open>
     6d0:	84aa                	mv	s1,a0
    if(fd < 0){
     6d2:	08054663          	bltz	a0,75e <copyout+0xd2>
    int n = read(fd, (void*)addr, 8192);
     6d6:	6609                	lui	a2,0x2
     6d8:	85ce                	mv	a1,s3
     6da:	00005097          	auipc	ra,0x5
     6de:	524080e7          	jalr	1316(ra) # 5bfe <read>
    if(n > 0){
     6e2:	08a04b63          	bgtz	a0,778 <copyout+0xec>
    close(fd);
     6e6:	8526                	mv	a0,s1
     6e8:	00005097          	auipc	ra,0x5
     6ec:	526080e7          	jalr	1318(ra) # 5c0e <close>
    if(pipe(fds) < 0){
     6f0:	fa840513          	addi	a0,s0,-88
     6f4:	00005097          	auipc	ra,0x5
     6f8:	502080e7          	jalr	1282(ra) # 5bf6 <pipe>
     6fc:	08054d63          	bltz	a0,796 <copyout+0x10a>
    n = write(fds[1], "x", 1);
     700:	4605                	li	a2,1
     702:	85d6                	mv	a1,s5
     704:	fac42503          	lw	a0,-84(s0)
     708:	00005097          	auipc	ra,0x5
     70c:	4fe080e7          	jalr	1278(ra) # 5c06 <write>
    if(n != 1){
     710:	4785                	li	a5,1
     712:	08f51f63          	bne	a0,a5,7b0 <copyout+0x124>
    n = read(fds[0], (void*)addr, 8192);
     716:	6609                	lui	a2,0x2
     718:	85ce                	mv	a1,s3
     71a:	fa842503          	lw	a0,-88(s0)
     71e:	00005097          	auipc	ra,0x5
     722:	4e0080e7          	jalr	1248(ra) # 5bfe <read>
    if(n > 0){
     726:	0aa04263          	bgtz	a0,7ca <copyout+0x13e>
    close(fds[0]);
     72a:	fa842503          	lw	a0,-88(s0)
     72e:	00005097          	auipc	ra,0x5
     732:	4e0080e7          	jalr	1248(ra) # 5c0e <close>
    close(fds[1]);
     736:	fac42503          	lw	a0,-84(s0)
     73a:	00005097          	auipc	ra,0x5
     73e:	4d4080e7          	jalr	1236(ra) # 5c0e <close>
  for(int ai = 0; ai < 2; ai++){
     742:	0921                	addi	s2,s2,8
     744:	fc040793          	addi	a5,s0,-64
     748:	f6f91ce3          	bne	s2,a5,6c0 <copyout+0x34>
}
     74c:	60e6                	ld	ra,88(sp)
     74e:	6446                	ld	s0,80(sp)
     750:	64a6                	ld	s1,72(sp)
     752:	6906                	ld	s2,64(sp)
     754:	79e2                	ld	s3,56(sp)
     756:	7a42                	ld	s4,48(sp)
     758:	7aa2                	ld	s5,40(sp)
     75a:	6125                	addi	sp,sp,96
     75c:	8082                	ret
      printf("open(README) failed\n");
     75e:	00006517          	auipc	a0,0x6
     762:	bea50513          	addi	a0,a0,-1046 # 6348 <malloc+0x31c>
     766:	00006097          	auipc	ra,0x6
     76a:	808080e7          	jalr	-2040(ra) # 5f6e <printf>
      exit(1);
     76e:	4505                	li	a0,1
     770:	00005097          	auipc	ra,0x5
     774:	476080e7          	jalr	1142(ra) # 5be6 <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     778:	862a                	mv	a2,a0
     77a:	85ce                	mv	a1,s3
     77c:	00006517          	auipc	a0,0x6
     780:	be450513          	addi	a0,a0,-1052 # 6360 <malloc+0x334>
     784:	00005097          	auipc	ra,0x5
     788:	7ea080e7          	jalr	2026(ra) # 5f6e <printf>
      exit(1);
     78c:	4505                	li	a0,1
     78e:	00005097          	auipc	ra,0x5
     792:	458080e7          	jalr	1112(ra) # 5be6 <exit>
      printf("pipe() failed\n");
     796:	00006517          	auipc	a0,0x6
     79a:	b6a50513          	addi	a0,a0,-1174 # 6300 <malloc+0x2d4>
     79e:	00005097          	auipc	ra,0x5
     7a2:	7d0080e7          	jalr	2000(ra) # 5f6e <printf>
      exit(1);
     7a6:	4505                	li	a0,1
     7a8:	00005097          	auipc	ra,0x5
     7ac:	43e080e7          	jalr	1086(ra) # 5be6 <exit>
      printf("pipe write failed\n");
     7b0:	00006517          	auipc	a0,0x6
     7b4:	be050513          	addi	a0,a0,-1056 # 6390 <malloc+0x364>
     7b8:	00005097          	auipc	ra,0x5
     7bc:	7b6080e7          	jalr	1974(ra) # 5f6e <printf>
      exit(1);
     7c0:	4505                	li	a0,1
     7c2:	00005097          	auipc	ra,0x5
     7c6:	424080e7          	jalr	1060(ra) # 5be6 <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     7ca:	862a                	mv	a2,a0
     7cc:	85ce                	mv	a1,s3
     7ce:	00006517          	auipc	a0,0x6
     7d2:	bda50513          	addi	a0,a0,-1062 # 63a8 <malloc+0x37c>
     7d6:	00005097          	auipc	ra,0x5
     7da:	798080e7          	jalr	1944(ra) # 5f6e <printf>
      exit(1);
     7de:	4505                	li	a0,1
     7e0:	00005097          	auipc	ra,0x5
     7e4:	406080e7          	jalr	1030(ra) # 5be6 <exit>

00000000000007e8 <truncate1>:
{
     7e8:	711d                	addi	sp,sp,-96
     7ea:	ec86                	sd	ra,88(sp)
     7ec:	e8a2                	sd	s0,80(sp)
     7ee:	e4a6                	sd	s1,72(sp)
     7f0:	e0ca                	sd	s2,64(sp)
     7f2:	fc4e                	sd	s3,56(sp)
     7f4:	f852                	sd	s4,48(sp)
     7f6:	f456                	sd	s5,40(sp)
     7f8:	1080                	addi	s0,sp,96
     7fa:	8aaa                	mv	s5,a0
  unlink("truncfile");
     7fc:	00006517          	auipc	a0,0x6
     800:	9c450513          	addi	a0,a0,-1596 # 61c0 <malloc+0x194>
     804:	00005097          	auipc	ra,0x5
     808:	432080e7          	jalr	1074(ra) # 5c36 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     80c:	60100593          	li	a1,1537
     810:	00006517          	auipc	a0,0x6
     814:	9b050513          	addi	a0,a0,-1616 # 61c0 <malloc+0x194>
     818:	00005097          	auipc	ra,0x5
     81c:	40e080e7          	jalr	1038(ra) # 5c26 <open>
     820:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     822:	4611                	li	a2,4
     824:	00006597          	auipc	a1,0x6
     828:	9ac58593          	addi	a1,a1,-1620 # 61d0 <malloc+0x1a4>
     82c:	00005097          	auipc	ra,0x5
     830:	3da080e7          	jalr	986(ra) # 5c06 <write>
  close(fd1);
     834:	8526                	mv	a0,s1
     836:	00005097          	auipc	ra,0x5
     83a:	3d8080e7          	jalr	984(ra) # 5c0e <close>
  int fd2 = open("truncfile", O_RDONLY);
     83e:	4581                	li	a1,0
     840:	00006517          	auipc	a0,0x6
     844:	98050513          	addi	a0,a0,-1664 # 61c0 <malloc+0x194>
     848:	00005097          	auipc	ra,0x5
     84c:	3de080e7          	jalr	990(ra) # 5c26 <open>
     850:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     852:	02000613          	li	a2,32
     856:	fa040593          	addi	a1,s0,-96
     85a:	00005097          	auipc	ra,0x5
     85e:	3a4080e7          	jalr	932(ra) # 5bfe <read>
  if(n != 4){
     862:	4791                	li	a5,4
     864:	0cf51e63          	bne	a0,a5,940 <truncate1+0x158>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     868:	40100593          	li	a1,1025
     86c:	00006517          	auipc	a0,0x6
     870:	95450513          	addi	a0,a0,-1708 # 61c0 <malloc+0x194>
     874:	00005097          	auipc	ra,0x5
     878:	3b2080e7          	jalr	946(ra) # 5c26 <open>
     87c:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     87e:	4581                	li	a1,0
     880:	00006517          	auipc	a0,0x6
     884:	94050513          	addi	a0,a0,-1728 # 61c0 <malloc+0x194>
     888:	00005097          	auipc	ra,0x5
     88c:	39e080e7          	jalr	926(ra) # 5c26 <open>
     890:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     892:	02000613          	li	a2,32
     896:	fa040593          	addi	a1,s0,-96
     89a:	00005097          	auipc	ra,0x5
     89e:	364080e7          	jalr	868(ra) # 5bfe <read>
     8a2:	8a2a                	mv	s4,a0
  if(n != 0){
     8a4:	ed4d                	bnez	a0,95e <truncate1+0x176>
  n = read(fd2, buf, sizeof(buf));
     8a6:	02000613          	li	a2,32
     8aa:	fa040593          	addi	a1,s0,-96
     8ae:	8526                	mv	a0,s1
     8b0:	00005097          	auipc	ra,0x5
     8b4:	34e080e7          	jalr	846(ra) # 5bfe <read>
     8b8:	8a2a                	mv	s4,a0
  if(n != 0){
     8ba:	e971                	bnez	a0,98e <truncate1+0x1a6>
  write(fd1, "abcdef", 6);
     8bc:	4619                	li	a2,6
     8be:	00006597          	auipc	a1,0x6
     8c2:	b7a58593          	addi	a1,a1,-1158 # 6438 <malloc+0x40c>
     8c6:	854e                	mv	a0,s3
     8c8:	00005097          	auipc	ra,0x5
     8cc:	33e080e7          	jalr	830(ra) # 5c06 <write>
  n = read(fd3, buf, sizeof(buf));
     8d0:	02000613          	li	a2,32
     8d4:	fa040593          	addi	a1,s0,-96
     8d8:	854a                	mv	a0,s2
     8da:	00005097          	auipc	ra,0x5
     8de:	324080e7          	jalr	804(ra) # 5bfe <read>
  if(n != 6){
     8e2:	4799                	li	a5,6
     8e4:	0cf51d63          	bne	a0,a5,9be <truncate1+0x1d6>
  n = read(fd2, buf, sizeof(buf));
     8e8:	02000613          	li	a2,32
     8ec:	fa040593          	addi	a1,s0,-96
     8f0:	8526                	mv	a0,s1
     8f2:	00005097          	auipc	ra,0x5
     8f6:	30c080e7          	jalr	780(ra) # 5bfe <read>
  if(n != 2){
     8fa:	4789                	li	a5,2
     8fc:	0ef51063          	bne	a0,a5,9dc <truncate1+0x1f4>
  unlink("truncfile");
     900:	00006517          	auipc	a0,0x6
     904:	8c050513          	addi	a0,a0,-1856 # 61c0 <malloc+0x194>
     908:	00005097          	auipc	ra,0x5
     90c:	32e080e7          	jalr	814(ra) # 5c36 <unlink>
  close(fd1);
     910:	854e                	mv	a0,s3
     912:	00005097          	auipc	ra,0x5
     916:	2fc080e7          	jalr	764(ra) # 5c0e <close>
  close(fd2);
     91a:	8526                	mv	a0,s1
     91c:	00005097          	auipc	ra,0x5
     920:	2f2080e7          	jalr	754(ra) # 5c0e <close>
  close(fd3);
     924:	854a                	mv	a0,s2
     926:	00005097          	auipc	ra,0x5
     92a:	2e8080e7          	jalr	744(ra) # 5c0e <close>
}
     92e:	60e6                	ld	ra,88(sp)
     930:	6446                	ld	s0,80(sp)
     932:	64a6                	ld	s1,72(sp)
     934:	6906                	ld	s2,64(sp)
     936:	79e2                	ld	s3,56(sp)
     938:	7a42                	ld	s4,48(sp)
     93a:	7aa2                	ld	s5,40(sp)
     93c:	6125                	addi	sp,sp,96
     93e:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     940:	862a                	mv	a2,a0
     942:	85d6                	mv	a1,s5
     944:	00006517          	auipc	a0,0x6
     948:	a9450513          	addi	a0,a0,-1388 # 63d8 <malloc+0x3ac>
     94c:	00005097          	auipc	ra,0x5
     950:	622080e7          	jalr	1570(ra) # 5f6e <printf>
    exit(1);
     954:	4505                	li	a0,1
     956:	00005097          	auipc	ra,0x5
     95a:	290080e7          	jalr	656(ra) # 5be6 <exit>
    printf("aaa fd3=%d\n", fd3);
     95e:	85ca                	mv	a1,s2
     960:	00006517          	auipc	a0,0x6
     964:	a9850513          	addi	a0,a0,-1384 # 63f8 <malloc+0x3cc>
     968:	00005097          	auipc	ra,0x5
     96c:	606080e7          	jalr	1542(ra) # 5f6e <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     970:	8652                	mv	a2,s4
     972:	85d6                	mv	a1,s5
     974:	00006517          	auipc	a0,0x6
     978:	a9450513          	addi	a0,a0,-1388 # 6408 <malloc+0x3dc>
     97c:	00005097          	auipc	ra,0x5
     980:	5f2080e7          	jalr	1522(ra) # 5f6e <printf>
    exit(1);
     984:	4505                	li	a0,1
     986:	00005097          	auipc	ra,0x5
     98a:	260080e7          	jalr	608(ra) # 5be6 <exit>
    printf("bbb fd2=%d\n", fd2);
     98e:	85a6                	mv	a1,s1
     990:	00006517          	auipc	a0,0x6
     994:	a9850513          	addi	a0,a0,-1384 # 6428 <malloc+0x3fc>
     998:	00005097          	auipc	ra,0x5
     99c:	5d6080e7          	jalr	1494(ra) # 5f6e <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     9a0:	8652                	mv	a2,s4
     9a2:	85d6                	mv	a1,s5
     9a4:	00006517          	auipc	a0,0x6
     9a8:	a6450513          	addi	a0,a0,-1436 # 6408 <malloc+0x3dc>
     9ac:	00005097          	auipc	ra,0x5
     9b0:	5c2080e7          	jalr	1474(ra) # 5f6e <printf>
    exit(1);
     9b4:	4505                	li	a0,1
     9b6:	00005097          	auipc	ra,0x5
     9ba:	230080e7          	jalr	560(ra) # 5be6 <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     9be:	862a                	mv	a2,a0
     9c0:	85d6                	mv	a1,s5
     9c2:	00006517          	auipc	a0,0x6
     9c6:	a7e50513          	addi	a0,a0,-1410 # 6440 <malloc+0x414>
     9ca:	00005097          	auipc	ra,0x5
     9ce:	5a4080e7          	jalr	1444(ra) # 5f6e <printf>
    exit(1);
     9d2:	4505                	li	a0,1
     9d4:	00005097          	auipc	ra,0x5
     9d8:	212080e7          	jalr	530(ra) # 5be6 <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     9dc:	862a                	mv	a2,a0
     9de:	85d6                	mv	a1,s5
     9e0:	00006517          	auipc	a0,0x6
     9e4:	a8050513          	addi	a0,a0,-1408 # 6460 <malloc+0x434>
     9e8:	00005097          	auipc	ra,0x5
     9ec:	586080e7          	jalr	1414(ra) # 5f6e <printf>
    exit(1);
     9f0:	4505                	li	a0,1
     9f2:	00005097          	auipc	ra,0x5
     9f6:	1f4080e7          	jalr	500(ra) # 5be6 <exit>

00000000000009fa <writetest>:
{
     9fa:	7139                	addi	sp,sp,-64
     9fc:	fc06                	sd	ra,56(sp)
     9fe:	f822                	sd	s0,48(sp)
     a00:	f426                	sd	s1,40(sp)
     a02:	f04a                	sd	s2,32(sp)
     a04:	ec4e                	sd	s3,24(sp)
     a06:	e852                	sd	s4,16(sp)
     a08:	e456                	sd	s5,8(sp)
     a0a:	e05a                	sd	s6,0(sp)
     a0c:	0080                	addi	s0,sp,64
     a0e:	8b2a                	mv	s6,a0
  fd = open("small", O_CREATE|O_RDWR);
     a10:	20200593          	li	a1,514
     a14:	00006517          	auipc	a0,0x6
     a18:	a6c50513          	addi	a0,a0,-1428 # 6480 <malloc+0x454>
     a1c:	00005097          	auipc	ra,0x5
     a20:	20a080e7          	jalr	522(ra) # 5c26 <open>
  if(fd < 0){
     a24:	0a054d63          	bltz	a0,ade <writetest+0xe4>
     a28:	892a                	mv	s2,a0
     a2a:	4481                	li	s1,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     a2c:	00006997          	auipc	s3,0x6
     a30:	a7c98993          	addi	s3,s3,-1412 # 64a8 <malloc+0x47c>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     a34:	00006a97          	auipc	s5,0x6
     a38:	aaca8a93          	addi	s5,s5,-1364 # 64e0 <malloc+0x4b4>
  for(i = 0; i < N; i++){
     a3c:	06400a13          	li	s4,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     a40:	4629                	li	a2,10
     a42:	85ce                	mv	a1,s3
     a44:	854a                	mv	a0,s2
     a46:	00005097          	auipc	ra,0x5
     a4a:	1c0080e7          	jalr	448(ra) # 5c06 <write>
     a4e:	47a9                	li	a5,10
     a50:	0af51563          	bne	a0,a5,afa <writetest+0x100>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     a54:	4629                	li	a2,10
     a56:	85d6                	mv	a1,s5
     a58:	854a                	mv	a0,s2
     a5a:	00005097          	auipc	ra,0x5
     a5e:	1ac080e7          	jalr	428(ra) # 5c06 <write>
     a62:	47a9                	li	a5,10
     a64:	0af51a63          	bne	a0,a5,b18 <writetest+0x11e>
  for(i = 0; i < N; i++){
     a68:	2485                	addiw	s1,s1,1
     a6a:	fd449be3          	bne	s1,s4,a40 <writetest+0x46>
  close(fd);
     a6e:	854a                	mv	a0,s2
     a70:	00005097          	auipc	ra,0x5
     a74:	19e080e7          	jalr	414(ra) # 5c0e <close>
  fd = open("small", O_RDONLY);
     a78:	4581                	li	a1,0
     a7a:	00006517          	auipc	a0,0x6
     a7e:	a0650513          	addi	a0,a0,-1530 # 6480 <malloc+0x454>
     a82:	00005097          	auipc	ra,0x5
     a86:	1a4080e7          	jalr	420(ra) # 5c26 <open>
     a8a:	84aa                	mv	s1,a0
  if(fd < 0){
     a8c:	0a054563          	bltz	a0,b36 <writetest+0x13c>
  i = read(fd, buf, N*SZ*2);
     a90:	7d000613          	li	a2,2000
     a94:	0000c597          	auipc	a1,0xc
     a98:	1e458593          	addi	a1,a1,484 # cc78 <buf>
     a9c:	00005097          	auipc	ra,0x5
     aa0:	162080e7          	jalr	354(ra) # 5bfe <read>
  if(i != N*SZ*2){
     aa4:	7d000793          	li	a5,2000
     aa8:	0af51563          	bne	a0,a5,b52 <writetest+0x158>
  close(fd);
     aac:	8526                	mv	a0,s1
     aae:	00005097          	auipc	ra,0x5
     ab2:	160080e7          	jalr	352(ra) # 5c0e <close>
  if(unlink("small") < 0){
     ab6:	00006517          	auipc	a0,0x6
     aba:	9ca50513          	addi	a0,a0,-1590 # 6480 <malloc+0x454>
     abe:	00005097          	auipc	ra,0x5
     ac2:	178080e7          	jalr	376(ra) # 5c36 <unlink>
     ac6:	0a054463          	bltz	a0,b6e <writetest+0x174>
}
     aca:	70e2                	ld	ra,56(sp)
     acc:	7442                	ld	s0,48(sp)
     ace:	74a2                	ld	s1,40(sp)
     ad0:	7902                	ld	s2,32(sp)
     ad2:	69e2                	ld	s3,24(sp)
     ad4:	6a42                	ld	s4,16(sp)
     ad6:	6aa2                	ld	s5,8(sp)
     ad8:	6b02                	ld	s6,0(sp)
     ada:	6121                	addi	sp,sp,64
     adc:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
     ade:	85da                	mv	a1,s6
     ae0:	00006517          	auipc	a0,0x6
     ae4:	9a850513          	addi	a0,a0,-1624 # 6488 <malloc+0x45c>
     ae8:	00005097          	auipc	ra,0x5
     aec:	486080e7          	jalr	1158(ra) # 5f6e <printf>
    exit(1);
     af0:	4505                	li	a0,1
     af2:	00005097          	auipc	ra,0x5
     af6:	0f4080e7          	jalr	244(ra) # 5be6 <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     afa:	8626                	mv	a2,s1
     afc:	85da                	mv	a1,s6
     afe:	00006517          	auipc	a0,0x6
     b02:	9ba50513          	addi	a0,a0,-1606 # 64b8 <malloc+0x48c>
     b06:	00005097          	auipc	ra,0x5
     b0a:	468080e7          	jalr	1128(ra) # 5f6e <printf>
      exit(1);
     b0e:	4505                	li	a0,1
     b10:	00005097          	auipc	ra,0x5
     b14:	0d6080e7          	jalr	214(ra) # 5be6 <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     b18:	8626                	mv	a2,s1
     b1a:	85da                	mv	a1,s6
     b1c:	00006517          	auipc	a0,0x6
     b20:	9d450513          	addi	a0,a0,-1580 # 64f0 <malloc+0x4c4>
     b24:	00005097          	auipc	ra,0x5
     b28:	44a080e7          	jalr	1098(ra) # 5f6e <printf>
      exit(1);
     b2c:	4505                	li	a0,1
     b2e:	00005097          	auipc	ra,0x5
     b32:	0b8080e7          	jalr	184(ra) # 5be6 <exit>
    printf("%s: error: open small failed!\n", s);
     b36:	85da                	mv	a1,s6
     b38:	00006517          	auipc	a0,0x6
     b3c:	9e050513          	addi	a0,a0,-1568 # 6518 <malloc+0x4ec>
     b40:	00005097          	auipc	ra,0x5
     b44:	42e080e7          	jalr	1070(ra) # 5f6e <printf>
    exit(1);
     b48:	4505                	li	a0,1
     b4a:	00005097          	auipc	ra,0x5
     b4e:	09c080e7          	jalr	156(ra) # 5be6 <exit>
    printf("%s: read failed\n", s);
     b52:	85da                	mv	a1,s6
     b54:	00006517          	auipc	a0,0x6
     b58:	9e450513          	addi	a0,a0,-1564 # 6538 <malloc+0x50c>
     b5c:	00005097          	auipc	ra,0x5
     b60:	412080e7          	jalr	1042(ra) # 5f6e <printf>
    exit(1);
     b64:	4505                	li	a0,1
     b66:	00005097          	auipc	ra,0x5
     b6a:	080080e7          	jalr	128(ra) # 5be6 <exit>
    printf("%s: unlink small failed\n", s);
     b6e:	85da                	mv	a1,s6
     b70:	00006517          	auipc	a0,0x6
     b74:	9e050513          	addi	a0,a0,-1568 # 6550 <malloc+0x524>
     b78:	00005097          	auipc	ra,0x5
     b7c:	3f6080e7          	jalr	1014(ra) # 5f6e <printf>
    exit(1);
     b80:	4505                	li	a0,1
     b82:	00005097          	auipc	ra,0x5
     b86:	064080e7          	jalr	100(ra) # 5be6 <exit>

0000000000000b8a <writebig>:
{
     b8a:	7139                	addi	sp,sp,-64
     b8c:	fc06                	sd	ra,56(sp)
     b8e:	f822                	sd	s0,48(sp)
     b90:	f426                	sd	s1,40(sp)
     b92:	f04a                	sd	s2,32(sp)
     b94:	ec4e                	sd	s3,24(sp)
     b96:	e852                	sd	s4,16(sp)
     b98:	e456                	sd	s5,8(sp)
     b9a:	0080                	addi	s0,sp,64
     b9c:	8aaa                	mv	s5,a0
  fd = open("big", O_CREATE|O_RDWR);
     b9e:	20200593          	li	a1,514
     ba2:	00006517          	auipc	a0,0x6
     ba6:	9ce50513          	addi	a0,a0,-1586 # 6570 <malloc+0x544>
     baa:	00005097          	auipc	ra,0x5
     bae:	07c080e7          	jalr	124(ra) # 5c26 <open>
     bb2:	89aa                	mv	s3,a0
  for(i = 0; i < MAXFILE; i++){
     bb4:	4481                	li	s1,0
    ((int*)buf)[0] = i;
     bb6:	0000c917          	auipc	s2,0xc
     bba:	0c290913          	addi	s2,s2,194 # cc78 <buf>
  for(i = 0; i < MAXFILE; i++){
     bbe:	10c00a13          	li	s4,268
  if(fd < 0){
     bc2:	06054c63          	bltz	a0,c3a <writebig+0xb0>
    ((int*)buf)[0] = i;
     bc6:	00992023          	sw	s1,0(s2)
    if(write(fd, buf, BSIZE) != BSIZE){
     bca:	40000613          	li	a2,1024
     bce:	85ca                	mv	a1,s2
     bd0:	854e                	mv	a0,s3
     bd2:	00005097          	auipc	ra,0x5
     bd6:	034080e7          	jalr	52(ra) # 5c06 <write>
     bda:	40000793          	li	a5,1024
     bde:	06f51c63          	bne	a0,a5,c56 <writebig+0xcc>
  for(i = 0; i < MAXFILE; i++){
     be2:	2485                	addiw	s1,s1,1
     be4:	ff4491e3          	bne	s1,s4,bc6 <writebig+0x3c>
  close(fd);
     be8:	854e                	mv	a0,s3
     bea:	00005097          	auipc	ra,0x5
     bee:	024080e7          	jalr	36(ra) # 5c0e <close>
  fd = open("big", O_RDONLY);
     bf2:	4581                	li	a1,0
     bf4:	00006517          	auipc	a0,0x6
     bf8:	97c50513          	addi	a0,a0,-1668 # 6570 <malloc+0x544>
     bfc:	00005097          	auipc	ra,0x5
     c00:	02a080e7          	jalr	42(ra) # 5c26 <open>
     c04:	89aa                	mv	s3,a0
  n = 0;
     c06:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     c08:	0000c917          	auipc	s2,0xc
     c0c:	07090913          	addi	s2,s2,112 # cc78 <buf>
  if(fd < 0){
     c10:	06054263          	bltz	a0,c74 <writebig+0xea>
    i = read(fd, buf, BSIZE);
     c14:	40000613          	li	a2,1024
     c18:	85ca                	mv	a1,s2
     c1a:	854e                	mv	a0,s3
     c1c:	00005097          	auipc	ra,0x5
     c20:	fe2080e7          	jalr	-30(ra) # 5bfe <read>
    if(i == 0){
     c24:	c535                	beqz	a0,c90 <writebig+0x106>
    } else if(i != BSIZE){
     c26:	40000793          	li	a5,1024
     c2a:	0af51f63          	bne	a0,a5,ce8 <writebig+0x15e>
    if(((int*)buf)[0] != n){
     c2e:	00092683          	lw	a3,0(s2)
     c32:	0c969a63          	bne	a3,s1,d06 <writebig+0x17c>
    n++;
     c36:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
     c38:	bff1                	j	c14 <writebig+0x8a>
    printf("%s: error: creat big failed!\n", s);
     c3a:	85d6                	mv	a1,s5
     c3c:	00006517          	auipc	a0,0x6
     c40:	93c50513          	addi	a0,a0,-1732 # 6578 <malloc+0x54c>
     c44:	00005097          	auipc	ra,0x5
     c48:	32a080e7          	jalr	810(ra) # 5f6e <printf>
    exit(1);
     c4c:	4505                	li	a0,1
     c4e:	00005097          	auipc	ra,0x5
     c52:	f98080e7          	jalr	-104(ra) # 5be6 <exit>
      printf("%s: error: write big file failed\n", s, i);
     c56:	8626                	mv	a2,s1
     c58:	85d6                	mv	a1,s5
     c5a:	00006517          	auipc	a0,0x6
     c5e:	93e50513          	addi	a0,a0,-1730 # 6598 <malloc+0x56c>
     c62:	00005097          	auipc	ra,0x5
     c66:	30c080e7          	jalr	780(ra) # 5f6e <printf>
      exit(1);
     c6a:	4505                	li	a0,1
     c6c:	00005097          	auipc	ra,0x5
     c70:	f7a080e7          	jalr	-134(ra) # 5be6 <exit>
    printf("%s: error: open big failed!\n", s);
     c74:	85d6                	mv	a1,s5
     c76:	00006517          	auipc	a0,0x6
     c7a:	94a50513          	addi	a0,a0,-1718 # 65c0 <malloc+0x594>
     c7e:	00005097          	auipc	ra,0x5
     c82:	2f0080e7          	jalr	752(ra) # 5f6e <printf>
    exit(1);
     c86:	4505                	li	a0,1
     c88:	00005097          	auipc	ra,0x5
     c8c:	f5e080e7          	jalr	-162(ra) # 5be6 <exit>
      if(n == MAXFILE - 1){
     c90:	10b00793          	li	a5,267
     c94:	02f48a63          	beq	s1,a5,cc8 <writebig+0x13e>
  close(fd);
     c98:	854e                	mv	a0,s3
     c9a:	00005097          	auipc	ra,0x5
     c9e:	f74080e7          	jalr	-140(ra) # 5c0e <close>
  if(unlink("big") < 0){
     ca2:	00006517          	auipc	a0,0x6
     ca6:	8ce50513          	addi	a0,a0,-1842 # 6570 <malloc+0x544>
     caa:	00005097          	auipc	ra,0x5
     cae:	f8c080e7          	jalr	-116(ra) # 5c36 <unlink>
     cb2:	06054963          	bltz	a0,d24 <writebig+0x19a>
}
     cb6:	70e2                	ld	ra,56(sp)
     cb8:	7442                	ld	s0,48(sp)
     cba:	74a2                	ld	s1,40(sp)
     cbc:	7902                	ld	s2,32(sp)
     cbe:	69e2                	ld	s3,24(sp)
     cc0:	6a42                	ld	s4,16(sp)
     cc2:	6aa2                	ld	s5,8(sp)
     cc4:	6121                	addi	sp,sp,64
     cc6:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
     cc8:	10b00613          	li	a2,267
     ccc:	85d6                	mv	a1,s5
     cce:	00006517          	auipc	a0,0x6
     cd2:	91250513          	addi	a0,a0,-1774 # 65e0 <malloc+0x5b4>
     cd6:	00005097          	auipc	ra,0x5
     cda:	298080e7          	jalr	664(ra) # 5f6e <printf>
        exit(1);
     cde:	4505                	li	a0,1
     ce0:	00005097          	auipc	ra,0x5
     ce4:	f06080e7          	jalr	-250(ra) # 5be6 <exit>
      printf("%s: read failed %d\n", s, i);
     ce8:	862a                	mv	a2,a0
     cea:	85d6                	mv	a1,s5
     cec:	00006517          	auipc	a0,0x6
     cf0:	91c50513          	addi	a0,a0,-1764 # 6608 <malloc+0x5dc>
     cf4:	00005097          	auipc	ra,0x5
     cf8:	27a080e7          	jalr	634(ra) # 5f6e <printf>
      exit(1);
     cfc:	4505                	li	a0,1
     cfe:	00005097          	auipc	ra,0x5
     d02:	ee8080e7          	jalr	-280(ra) # 5be6 <exit>
      printf("%s: read content of block %d is %d\n", s,
     d06:	8626                	mv	a2,s1
     d08:	85d6                	mv	a1,s5
     d0a:	00006517          	auipc	a0,0x6
     d0e:	91650513          	addi	a0,a0,-1770 # 6620 <malloc+0x5f4>
     d12:	00005097          	auipc	ra,0x5
     d16:	25c080e7          	jalr	604(ra) # 5f6e <printf>
      exit(1);
     d1a:	4505                	li	a0,1
     d1c:	00005097          	auipc	ra,0x5
     d20:	eca080e7          	jalr	-310(ra) # 5be6 <exit>
    printf("%s: unlink big failed\n", s);
     d24:	85d6                	mv	a1,s5
     d26:	00006517          	auipc	a0,0x6
     d2a:	92250513          	addi	a0,a0,-1758 # 6648 <malloc+0x61c>
     d2e:	00005097          	auipc	ra,0x5
     d32:	240080e7          	jalr	576(ra) # 5f6e <printf>
    exit(1);
     d36:	4505                	li	a0,1
     d38:	00005097          	auipc	ra,0x5
     d3c:	eae080e7          	jalr	-338(ra) # 5be6 <exit>

0000000000000d40 <unlinkread>:
{
     d40:	7179                	addi	sp,sp,-48
     d42:	f406                	sd	ra,40(sp)
     d44:	f022                	sd	s0,32(sp)
     d46:	ec26                	sd	s1,24(sp)
     d48:	e84a                	sd	s2,16(sp)
     d4a:	e44e                	sd	s3,8(sp)
     d4c:	1800                	addi	s0,sp,48
     d4e:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     d50:	20200593          	li	a1,514
     d54:	00006517          	auipc	a0,0x6
     d58:	90c50513          	addi	a0,a0,-1780 # 6660 <malloc+0x634>
     d5c:	00005097          	auipc	ra,0x5
     d60:	eca080e7          	jalr	-310(ra) # 5c26 <open>
  if(fd < 0){
     d64:	0e054563          	bltz	a0,e4e <unlinkread+0x10e>
     d68:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     d6a:	4615                	li	a2,5
     d6c:	00006597          	auipc	a1,0x6
     d70:	92458593          	addi	a1,a1,-1756 # 6690 <malloc+0x664>
     d74:	00005097          	auipc	ra,0x5
     d78:	e92080e7          	jalr	-366(ra) # 5c06 <write>
  close(fd);
     d7c:	8526                	mv	a0,s1
     d7e:	00005097          	auipc	ra,0x5
     d82:	e90080e7          	jalr	-368(ra) # 5c0e <close>
  fd = open("unlinkread", O_RDWR);
     d86:	4589                	li	a1,2
     d88:	00006517          	auipc	a0,0x6
     d8c:	8d850513          	addi	a0,a0,-1832 # 6660 <malloc+0x634>
     d90:	00005097          	auipc	ra,0x5
     d94:	e96080e7          	jalr	-362(ra) # 5c26 <open>
     d98:	84aa                	mv	s1,a0
  if(fd < 0){
     d9a:	0c054863          	bltz	a0,e6a <unlinkread+0x12a>
  if(unlink("unlinkread") != 0){
     d9e:	00006517          	auipc	a0,0x6
     da2:	8c250513          	addi	a0,a0,-1854 # 6660 <malloc+0x634>
     da6:	00005097          	auipc	ra,0x5
     daa:	e90080e7          	jalr	-368(ra) # 5c36 <unlink>
     dae:	ed61                	bnez	a0,e86 <unlinkread+0x146>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     db0:	20200593          	li	a1,514
     db4:	00006517          	auipc	a0,0x6
     db8:	8ac50513          	addi	a0,a0,-1876 # 6660 <malloc+0x634>
     dbc:	00005097          	auipc	ra,0x5
     dc0:	e6a080e7          	jalr	-406(ra) # 5c26 <open>
     dc4:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     dc6:	460d                	li	a2,3
     dc8:	00006597          	auipc	a1,0x6
     dcc:	91058593          	addi	a1,a1,-1776 # 66d8 <malloc+0x6ac>
     dd0:	00005097          	auipc	ra,0x5
     dd4:	e36080e7          	jalr	-458(ra) # 5c06 <write>
  close(fd1);
     dd8:	854a                	mv	a0,s2
     dda:	00005097          	auipc	ra,0x5
     dde:	e34080e7          	jalr	-460(ra) # 5c0e <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
     de2:	660d                	lui	a2,0x3
     de4:	0000c597          	auipc	a1,0xc
     de8:	e9458593          	addi	a1,a1,-364 # cc78 <buf>
     dec:	8526                	mv	a0,s1
     dee:	00005097          	auipc	ra,0x5
     df2:	e10080e7          	jalr	-496(ra) # 5bfe <read>
     df6:	4795                	li	a5,5
     df8:	0af51563          	bne	a0,a5,ea2 <unlinkread+0x162>
  if(buf[0] != 'h'){
     dfc:	0000c717          	auipc	a4,0xc
     e00:	e7c74703          	lbu	a4,-388(a4) # cc78 <buf>
     e04:	06800793          	li	a5,104
     e08:	0af71b63          	bne	a4,a5,ebe <unlinkread+0x17e>
  if(write(fd, buf, 10) != 10){
     e0c:	4629                	li	a2,10
     e0e:	0000c597          	auipc	a1,0xc
     e12:	e6a58593          	addi	a1,a1,-406 # cc78 <buf>
     e16:	8526                	mv	a0,s1
     e18:	00005097          	auipc	ra,0x5
     e1c:	dee080e7          	jalr	-530(ra) # 5c06 <write>
     e20:	47a9                	li	a5,10
     e22:	0af51c63          	bne	a0,a5,eda <unlinkread+0x19a>
  close(fd);
     e26:	8526                	mv	a0,s1
     e28:	00005097          	auipc	ra,0x5
     e2c:	de6080e7          	jalr	-538(ra) # 5c0e <close>
  unlink("unlinkread");
     e30:	00006517          	auipc	a0,0x6
     e34:	83050513          	addi	a0,a0,-2000 # 6660 <malloc+0x634>
     e38:	00005097          	auipc	ra,0x5
     e3c:	dfe080e7          	jalr	-514(ra) # 5c36 <unlink>
}
     e40:	70a2                	ld	ra,40(sp)
     e42:	7402                	ld	s0,32(sp)
     e44:	64e2                	ld	s1,24(sp)
     e46:	6942                	ld	s2,16(sp)
     e48:	69a2                	ld	s3,8(sp)
     e4a:	6145                	addi	sp,sp,48
     e4c:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     e4e:	85ce                	mv	a1,s3
     e50:	00006517          	auipc	a0,0x6
     e54:	82050513          	addi	a0,a0,-2016 # 6670 <malloc+0x644>
     e58:	00005097          	auipc	ra,0x5
     e5c:	116080e7          	jalr	278(ra) # 5f6e <printf>
    exit(1);
     e60:	4505                	li	a0,1
     e62:	00005097          	auipc	ra,0x5
     e66:	d84080e7          	jalr	-636(ra) # 5be6 <exit>
    printf("%s: open unlinkread failed\n", s);
     e6a:	85ce                	mv	a1,s3
     e6c:	00006517          	auipc	a0,0x6
     e70:	82c50513          	addi	a0,a0,-2004 # 6698 <malloc+0x66c>
     e74:	00005097          	auipc	ra,0x5
     e78:	0fa080e7          	jalr	250(ra) # 5f6e <printf>
    exit(1);
     e7c:	4505                	li	a0,1
     e7e:	00005097          	auipc	ra,0x5
     e82:	d68080e7          	jalr	-664(ra) # 5be6 <exit>
    printf("%s: unlink unlinkread failed\n", s);
     e86:	85ce                	mv	a1,s3
     e88:	00006517          	auipc	a0,0x6
     e8c:	83050513          	addi	a0,a0,-2000 # 66b8 <malloc+0x68c>
     e90:	00005097          	auipc	ra,0x5
     e94:	0de080e7          	jalr	222(ra) # 5f6e <printf>
    exit(1);
     e98:	4505                	li	a0,1
     e9a:	00005097          	auipc	ra,0x5
     e9e:	d4c080e7          	jalr	-692(ra) # 5be6 <exit>
    printf("%s: unlinkread read failed", s);
     ea2:	85ce                	mv	a1,s3
     ea4:	00006517          	auipc	a0,0x6
     ea8:	83c50513          	addi	a0,a0,-1988 # 66e0 <malloc+0x6b4>
     eac:	00005097          	auipc	ra,0x5
     eb0:	0c2080e7          	jalr	194(ra) # 5f6e <printf>
    exit(1);
     eb4:	4505                	li	a0,1
     eb6:	00005097          	auipc	ra,0x5
     eba:	d30080e7          	jalr	-720(ra) # 5be6 <exit>
    printf("%s: unlinkread wrong data\n", s);
     ebe:	85ce                	mv	a1,s3
     ec0:	00006517          	auipc	a0,0x6
     ec4:	84050513          	addi	a0,a0,-1984 # 6700 <malloc+0x6d4>
     ec8:	00005097          	auipc	ra,0x5
     ecc:	0a6080e7          	jalr	166(ra) # 5f6e <printf>
    exit(1);
     ed0:	4505                	li	a0,1
     ed2:	00005097          	auipc	ra,0x5
     ed6:	d14080e7          	jalr	-748(ra) # 5be6 <exit>
    printf("%s: unlinkread write failed\n", s);
     eda:	85ce                	mv	a1,s3
     edc:	00006517          	auipc	a0,0x6
     ee0:	84450513          	addi	a0,a0,-1980 # 6720 <malloc+0x6f4>
     ee4:	00005097          	auipc	ra,0x5
     ee8:	08a080e7          	jalr	138(ra) # 5f6e <printf>
    exit(1);
     eec:	4505                	li	a0,1
     eee:	00005097          	auipc	ra,0x5
     ef2:	cf8080e7          	jalr	-776(ra) # 5be6 <exit>

0000000000000ef6 <linktest>:
{
     ef6:	1101                	addi	sp,sp,-32
     ef8:	ec06                	sd	ra,24(sp)
     efa:	e822                	sd	s0,16(sp)
     efc:	e426                	sd	s1,8(sp)
     efe:	e04a                	sd	s2,0(sp)
     f00:	1000                	addi	s0,sp,32
     f02:	892a                	mv	s2,a0
  unlink("lf1");
     f04:	00006517          	auipc	a0,0x6
     f08:	83c50513          	addi	a0,a0,-1988 # 6740 <malloc+0x714>
     f0c:	00005097          	auipc	ra,0x5
     f10:	d2a080e7          	jalr	-726(ra) # 5c36 <unlink>
  unlink("lf2");
     f14:	00006517          	auipc	a0,0x6
     f18:	83450513          	addi	a0,a0,-1996 # 6748 <malloc+0x71c>
     f1c:	00005097          	auipc	ra,0x5
     f20:	d1a080e7          	jalr	-742(ra) # 5c36 <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
     f24:	20200593          	li	a1,514
     f28:	00006517          	auipc	a0,0x6
     f2c:	81850513          	addi	a0,a0,-2024 # 6740 <malloc+0x714>
     f30:	00005097          	auipc	ra,0x5
     f34:	cf6080e7          	jalr	-778(ra) # 5c26 <open>
  if(fd < 0){
     f38:	10054763          	bltz	a0,1046 <linktest+0x150>
     f3c:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
     f3e:	4615                	li	a2,5
     f40:	00005597          	auipc	a1,0x5
     f44:	75058593          	addi	a1,a1,1872 # 6690 <malloc+0x664>
     f48:	00005097          	auipc	ra,0x5
     f4c:	cbe080e7          	jalr	-834(ra) # 5c06 <write>
     f50:	4795                	li	a5,5
     f52:	10f51863          	bne	a0,a5,1062 <linktest+0x16c>
  close(fd);
     f56:	8526                	mv	a0,s1
     f58:	00005097          	auipc	ra,0x5
     f5c:	cb6080e7          	jalr	-842(ra) # 5c0e <close>
  if(link("lf1", "lf2") < 0){
     f60:	00005597          	auipc	a1,0x5
     f64:	7e858593          	addi	a1,a1,2024 # 6748 <malloc+0x71c>
     f68:	00005517          	auipc	a0,0x5
     f6c:	7d850513          	addi	a0,a0,2008 # 6740 <malloc+0x714>
     f70:	00005097          	auipc	ra,0x5
     f74:	cd6080e7          	jalr	-810(ra) # 5c46 <link>
     f78:	10054363          	bltz	a0,107e <linktest+0x188>
  unlink("lf1");
     f7c:	00005517          	auipc	a0,0x5
     f80:	7c450513          	addi	a0,a0,1988 # 6740 <malloc+0x714>
     f84:	00005097          	auipc	ra,0x5
     f88:	cb2080e7          	jalr	-846(ra) # 5c36 <unlink>
  if(open("lf1", 0) >= 0){
     f8c:	4581                	li	a1,0
     f8e:	00005517          	auipc	a0,0x5
     f92:	7b250513          	addi	a0,a0,1970 # 6740 <malloc+0x714>
     f96:	00005097          	auipc	ra,0x5
     f9a:	c90080e7          	jalr	-880(ra) # 5c26 <open>
     f9e:	0e055e63          	bgez	a0,109a <linktest+0x1a4>
  fd = open("lf2", 0);
     fa2:	4581                	li	a1,0
     fa4:	00005517          	auipc	a0,0x5
     fa8:	7a450513          	addi	a0,a0,1956 # 6748 <malloc+0x71c>
     fac:	00005097          	auipc	ra,0x5
     fb0:	c7a080e7          	jalr	-902(ra) # 5c26 <open>
     fb4:	84aa                	mv	s1,a0
  if(fd < 0){
     fb6:	10054063          	bltz	a0,10b6 <linktest+0x1c0>
  if(read(fd, buf, sizeof(buf)) != SZ){
     fba:	660d                	lui	a2,0x3
     fbc:	0000c597          	auipc	a1,0xc
     fc0:	cbc58593          	addi	a1,a1,-836 # cc78 <buf>
     fc4:	00005097          	auipc	ra,0x5
     fc8:	c3a080e7          	jalr	-966(ra) # 5bfe <read>
     fcc:	4795                	li	a5,5
     fce:	10f51263          	bne	a0,a5,10d2 <linktest+0x1dc>
  close(fd);
     fd2:	8526                	mv	a0,s1
     fd4:	00005097          	auipc	ra,0x5
     fd8:	c3a080e7          	jalr	-966(ra) # 5c0e <close>
  if(link("lf2", "lf2") >= 0){
     fdc:	00005597          	auipc	a1,0x5
     fe0:	76c58593          	addi	a1,a1,1900 # 6748 <malloc+0x71c>
     fe4:	852e                	mv	a0,a1
     fe6:	00005097          	auipc	ra,0x5
     fea:	c60080e7          	jalr	-928(ra) # 5c46 <link>
     fee:	10055063          	bgez	a0,10ee <linktest+0x1f8>
  unlink("lf2");
     ff2:	00005517          	auipc	a0,0x5
     ff6:	75650513          	addi	a0,a0,1878 # 6748 <malloc+0x71c>
     ffa:	00005097          	auipc	ra,0x5
     ffe:	c3c080e7          	jalr	-964(ra) # 5c36 <unlink>
  if(link("lf2", "lf1") >= 0){
    1002:	00005597          	auipc	a1,0x5
    1006:	73e58593          	addi	a1,a1,1854 # 6740 <malloc+0x714>
    100a:	00005517          	auipc	a0,0x5
    100e:	73e50513          	addi	a0,a0,1854 # 6748 <malloc+0x71c>
    1012:	00005097          	auipc	ra,0x5
    1016:	c34080e7          	jalr	-972(ra) # 5c46 <link>
    101a:	0e055863          	bgez	a0,110a <linktest+0x214>
  if(link(".", "lf1") >= 0){
    101e:	00005597          	auipc	a1,0x5
    1022:	72258593          	addi	a1,a1,1826 # 6740 <malloc+0x714>
    1026:	00006517          	auipc	a0,0x6
    102a:	82a50513          	addi	a0,a0,-2006 # 6850 <malloc+0x824>
    102e:	00005097          	auipc	ra,0x5
    1032:	c18080e7          	jalr	-1000(ra) # 5c46 <link>
    1036:	0e055863          	bgez	a0,1126 <linktest+0x230>
}
    103a:	60e2                	ld	ra,24(sp)
    103c:	6442                	ld	s0,16(sp)
    103e:	64a2                	ld	s1,8(sp)
    1040:	6902                	ld	s2,0(sp)
    1042:	6105                	addi	sp,sp,32
    1044:	8082                	ret
    printf("%s: create lf1 failed\n", s);
    1046:	85ca                	mv	a1,s2
    1048:	00005517          	auipc	a0,0x5
    104c:	70850513          	addi	a0,a0,1800 # 6750 <malloc+0x724>
    1050:	00005097          	auipc	ra,0x5
    1054:	f1e080e7          	jalr	-226(ra) # 5f6e <printf>
    exit(1);
    1058:	4505                	li	a0,1
    105a:	00005097          	auipc	ra,0x5
    105e:	b8c080e7          	jalr	-1140(ra) # 5be6 <exit>
    printf("%s: write lf1 failed\n", s);
    1062:	85ca                	mv	a1,s2
    1064:	00005517          	auipc	a0,0x5
    1068:	70450513          	addi	a0,a0,1796 # 6768 <malloc+0x73c>
    106c:	00005097          	auipc	ra,0x5
    1070:	f02080e7          	jalr	-254(ra) # 5f6e <printf>
    exit(1);
    1074:	4505                	li	a0,1
    1076:	00005097          	auipc	ra,0x5
    107a:	b70080e7          	jalr	-1168(ra) # 5be6 <exit>
    printf("%s: link lf1 lf2 failed\n", s);
    107e:	85ca                	mv	a1,s2
    1080:	00005517          	auipc	a0,0x5
    1084:	70050513          	addi	a0,a0,1792 # 6780 <malloc+0x754>
    1088:	00005097          	auipc	ra,0x5
    108c:	ee6080e7          	jalr	-282(ra) # 5f6e <printf>
    exit(1);
    1090:	4505                	li	a0,1
    1092:	00005097          	auipc	ra,0x5
    1096:	b54080e7          	jalr	-1196(ra) # 5be6 <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
    109a:	85ca                	mv	a1,s2
    109c:	00005517          	auipc	a0,0x5
    10a0:	70450513          	addi	a0,a0,1796 # 67a0 <malloc+0x774>
    10a4:	00005097          	auipc	ra,0x5
    10a8:	eca080e7          	jalr	-310(ra) # 5f6e <printf>
    exit(1);
    10ac:	4505                	li	a0,1
    10ae:	00005097          	auipc	ra,0x5
    10b2:	b38080e7          	jalr	-1224(ra) # 5be6 <exit>
    printf("%s: open lf2 failed\n", s);
    10b6:	85ca                	mv	a1,s2
    10b8:	00005517          	auipc	a0,0x5
    10bc:	71850513          	addi	a0,a0,1816 # 67d0 <malloc+0x7a4>
    10c0:	00005097          	auipc	ra,0x5
    10c4:	eae080e7          	jalr	-338(ra) # 5f6e <printf>
    exit(1);
    10c8:	4505                	li	a0,1
    10ca:	00005097          	auipc	ra,0x5
    10ce:	b1c080e7          	jalr	-1252(ra) # 5be6 <exit>
    printf("%s: read lf2 failed\n", s);
    10d2:	85ca                	mv	a1,s2
    10d4:	00005517          	auipc	a0,0x5
    10d8:	71450513          	addi	a0,a0,1812 # 67e8 <malloc+0x7bc>
    10dc:	00005097          	auipc	ra,0x5
    10e0:	e92080e7          	jalr	-366(ra) # 5f6e <printf>
    exit(1);
    10e4:	4505                	li	a0,1
    10e6:	00005097          	auipc	ra,0x5
    10ea:	b00080e7          	jalr	-1280(ra) # 5be6 <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
    10ee:	85ca                	mv	a1,s2
    10f0:	00005517          	auipc	a0,0x5
    10f4:	71050513          	addi	a0,a0,1808 # 6800 <malloc+0x7d4>
    10f8:	00005097          	auipc	ra,0x5
    10fc:	e76080e7          	jalr	-394(ra) # 5f6e <printf>
    exit(1);
    1100:	4505                	li	a0,1
    1102:	00005097          	auipc	ra,0x5
    1106:	ae4080e7          	jalr	-1308(ra) # 5be6 <exit>
    printf("%s: link non-existent succeeded! oops\n", s);
    110a:	85ca                	mv	a1,s2
    110c:	00005517          	auipc	a0,0x5
    1110:	71c50513          	addi	a0,a0,1820 # 6828 <malloc+0x7fc>
    1114:	00005097          	auipc	ra,0x5
    1118:	e5a080e7          	jalr	-422(ra) # 5f6e <printf>
    exit(1);
    111c:	4505                	li	a0,1
    111e:	00005097          	auipc	ra,0x5
    1122:	ac8080e7          	jalr	-1336(ra) # 5be6 <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
    1126:	85ca                	mv	a1,s2
    1128:	00005517          	auipc	a0,0x5
    112c:	73050513          	addi	a0,a0,1840 # 6858 <malloc+0x82c>
    1130:	00005097          	auipc	ra,0x5
    1134:	e3e080e7          	jalr	-450(ra) # 5f6e <printf>
    exit(1);
    1138:	4505                	li	a0,1
    113a:	00005097          	auipc	ra,0x5
    113e:	aac080e7          	jalr	-1364(ra) # 5be6 <exit>

0000000000001142 <validatetest>:
{
    1142:	7139                	addi	sp,sp,-64
    1144:	fc06                	sd	ra,56(sp)
    1146:	f822                	sd	s0,48(sp)
    1148:	f426                	sd	s1,40(sp)
    114a:	f04a                	sd	s2,32(sp)
    114c:	ec4e                	sd	s3,24(sp)
    114e:	e852                	sd	s4,16(sp)
    1150:	e456                	sd	s5,8(sp)
    1152:	e05a                	sd	s6,0(sp)
    1154:	0080                	addi	s0,sp,64
    1156:	8b2a                	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    1158:	4481                	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
    115a:	00005997          	auipc	s3,0x5
    115e:	71e98993          	addi	s3,s3,1822 # 6878 <malloc+0x84c>
    1162:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    1164:	6a85                	lui	s5,0x1
    1166:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
    116a:	85a6                	mv	a1,s1
    116c:	854e                	mv	a0,s3
    116e:	00005097          	auipc	ra,0x5
    1172:	ad8080e7          	jalr	-1320(ra) # 5c46 <link>
    1176:	01251f63          	bne	a0,s2,1194 <validatetest+0x52>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    117a:	94d6                	add	s1,s1,s5
    117c:	ff4497e3          	bne	s1,s4,116a <validatetest+0x28>
}
    1180:	70e2                	ld	ra,56(sp)
    1182:	7442                	ld	s0,48(sp)
    1184:	74a2                	ld	s1,40(sp)
    1186:	7902                	ld	s2,32(sp)
    1188:	69e2                	ld	s3,24(sp)
    118a:	6a42                	ld	s4,16(sp)
    118c:	6aa2                	ld	s5,8(sp)
    118e:	6b02                	ld	s6,0(sp)
    1190:	6121                	addi	sp,sp,64
    1192:	8082                	ret
      printf("%s: link should not succeed\n", s);
    1194:	85da                	mv	a1,s6
    1196:	00005517          	auipc	a0,0x5
    119a:	6f250513          	addi	a0,a0,1778 # 6888 <malloc+0x85c>
    119e:	00005097          	auipc	ra,0x5
    11a2:	dd0080e7          	jalr	-560(ra) # 5f6e <printf>
      exit(1);
    11a6:	4505                	li	a0,1
    11a8:	00005097          	auipc	ra,0x5
    11ac:	a3e080e7          	jalr	-1474(ra) # 5be6 <exit>

00000000000011b0 <bigdir>:
{
    11b0:	715d                	addi	sp,sp,-80
    11b2:	e486                	sd	ra,72(sp)
    11b4:	e0a2                	sd	s0,64(sp)
    11b6:	fc26                	sd	s1,56(sp)
    11b8:	f84a                	sd	s2,48(sp)
    11ba:	f44e                	sd	s3,40(sp)
    11bc:	f052                	sd	s4,32(sp)
    11be:	ec56                	sd	s5,24(sp)
    11c0:	e85a                	sd	s6,16(sp)
    11c2:	0880                	addi	s0,sp,80
    11c4:	89aa                	mv	s3,a0
  unlink("bd");
    11c6:	00005517          	auipc	a0,0x5
    11ca:	6e250513          	addi	a0,a0,1762 # 68a8 <malloc+0x87c>
    11ce:	00005097          	auipc	ra,0x5
    11d2:	a68080e7          	jalr	-1432(ra) # 5c36 <unlink>
  fd = open("bd", O_CREATE);
    11d6:	20000593          	li	a1,512
    11da:	00005517          	auipc	a0,0x5
    11de:	6ce50513          	addi	a0,a0,1742 # 68a8 <malloc+0x87c>
    11e2:	00005097          	auipc	ra,0x5
    11e6:	a44080e7          	jalr	-1468(ra) # 5c26 <open>
  if(fd < 0){
    11ea:	0c054963          	bltz	a0,12bc <bigdir+0x10c>
  close(fd);
    11ee:	00005097          	auipc	ra,0x5
    11f2:	a20080e7          	jalr	-1504(ra) # 5c0e <close>
  for(i = 0; i < N; i++){
    11f6:	4901                	li	s2,0
    name[0] = 'x';
    11f8:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
    11fc:	00005a17          	auipc	s4,0x5
    1200:	6aca0a13          	addi	s4,s4,1708 # 68a8 <malloc+0x87c>
  for(i = 0; i < N; i++){
    1204:	1f400b13          	li	s6,500
    name[0] = 'x';
    1208:	fb540823          	sb	s5,-80(s0)
    name[1] = '0' + (i / 64);
    120c:	41f9579b          	sraiw	a5,s2,0x1f
    1210:	01a7d71b          	srliw	a4,a5,0x1a
    1214:	012707bb          	addw	a5,a4,s2
    1218:	4067d69b          	sraiw	a3,a5,0x6
    121c:	0306869b          	addiw	a3,a3,48
    1220:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    1224:	03f7f793          	andi	a5,a5,63
    1228:	9f99                	subw	a5,a5,a4
    122a:	0307879b          	addiw	a5,a5,48
    122e:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    1232:	fa0409a3          	sb	zero,-77(s0)
    if(link("bd", name) != 0){
    1236:	fb040593          	addi	a1,s0,-80
    123a:	8552                	mv	a0,s4
    123c:	00005097          	auipc	ra,0x5
    1240:	a0a080e7          	jalr	-1526(ra) # 5c46 <link>
    1244:	84aa                	mv	s1,a0
    1246:	e949                	bnez	a0,12d8 <bigdir+0x128>
  for(i = 0; i < N; i++){
    1248:	2905                	addiw	s2,s2,1
    124a:	fb691fe3          	bne	s2,s6,1208 <bigdir+0x58>
  unlink("bd");
    124e:	00005517          	auipc	a0,0x5
    1252:	65a50513          	addi	a0,a0,1626 # 68a8 <malloc+0x87c>
    1256:	00005097          	auipc	ra,0x5
    125a:	9e0080e7          	jalr	-1568(ra) # 5c36 <unlink>
    name[0] = 'x';
    125e:	07800913          	li	s2,120
  for(i = 0; i < N; i++){
    1262:	1f400a13          	li	s4,500
    name[0] = 'x';
    1266:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
    126a:	41f4d79b          	sraiw	a5,s1,0x1f
    126e:	01a7d71b          	srliw	a4,a5,0x1a
    1272:	009707bb          	addw	a5,a4,s1
    1276:	4067d69b          	sraiw	a3,a5,0x6
    127a:	0306869b          	addiw	a3,a3,48
    127e:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    1282:	03f7f793          	andi	a5,a5,63
    1286:	9f99                	subw	a5,a5,a4
    1288:	0307879b          	addiw	a5,a5,48
    128c:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    1290:	fa0409a3          	sb	zero,-77(s0)
    if(unlink(name) != 0){
    1294:	fb040513          	addi	a0,s0,-80
    1298:	00005097          	auipc	ra,0x5
    129c:	99e080e7          	jalr	-1634(ra) # 5c36 <unlink>
    12a0:	ed21                	bnez	a0,12f8 <bigdir+0x148>
  for(i = 0; i < N; i++){
    12a2:	2485                	addiw	s1,s1,1
    12a4:	fd4491e3          	bne	s1,s4,1266 <bigdir+0xb6>
}
    12a8:	60a6                	ld	ra,72(sp)
    12aa:	6406                	ld	s0,64(sp)
    12ac:	74e2                	ld	s1,56(sp)
    12ae:	7942                	ld	s2,48(sp)
    12b0:	79a2                	ld	s3,40(sp)
    12b2:	7a02                	ld	s4,32(sp)
    12b4:	6ae2                	ld	s5,24(sp)
    12b6:	6b42                	ld	s6,16(sp)
    12b8:	6161                	addi	sp,sp,80
    12ba:	8082                	ret
    printf("%s: bigdir create failed\n", s);
    12bc:	85ce                	mv	a1,s3
    12be:	00005517          	auipc	a0,0x5
    12c2:	5f250513          	addi	a0,a0,1522 # 68b0 <malloc+0x884>
    12c6:	00005097          	auipc	ra,0x5
    12ca:	ca8080e7          	jalr	-856(ra) # 5f6e <printf>
    exit(1);
    12ce:	4505                	li	a0,1
    12d0:	00005097          	auipc	ra,0x5
    12d4:	916080e7          	jalr	-1770(ra) # 5be6 <exit>
      printf("%s: bigdir link(bd, %s) failed\n", s, name);
    12d8:	fb040613          	addi	a2,s0,-80
    12dc:	85ce                	mv	a1,s3
    12de:	00005517          	auipc	a0,0x5
    12e2:	5f250513          	addi	a0,a0,1522 # 68d0 <malloc+0x8a4>
    12e6:	00005097          	auipc	ra,0x5
    12ea:	c88080e7          	jalr	-888(ra) # 5f6e <printf>
      exit(1);
    12ee:	4505                	li	a0,1
    12f0:	00005097          	auipc	ra,0x5
    12f4:	8f6080e7          	jalr	-1802(ra) # 5be6 <exit>
      printf("%s: bigdir unlink failed", s);
    12f8:	85ce                	mv	a1,s3
    12fa:	00005517          	auipc	a0,0x5
    12fe:	5f650513          	addi	a0,a0,1526 # 68f0 <malloc+0x8c4>
    1302:	00005097          	auipc	ra,0x5
    1306:	c6c080e7          	jalr	-916(ra) # 5f6e <printf>
      exit(1);
    130a:	4505                	li	a0,1
    130c:	00005097          	auipc	ra,0x5
    1310:	8da080e7          	jalr	-1830(ra) # 5be6 <exit>

0000000000001314 <pgbug>:
{
    1314:	7179                	addi	sp,sp,-48
    1316:	f406                	sd	ra,40(sp)
    1318:	f022                	sd	s0,32(sp)
    131a:	ec26                	sd	s1,24(sp)
    131c:	1800                	addi	s0,sp,48
  argv[0] = 0;
    131e:	fc043c23          	sd	zero,-40(s0)
  exec(big, argv);
    1322:	00008497          	auipc	s1,0x8
    1326:	cde48493          	addi	s1,s1,-802 # 9000 <big>
    132a:	fd840593          	addi	a1,s0,-40
    132e:	6088                	ld	a0,0(s1)
    1330:	00005097          	auipc	ra,0x5
    1334:	8ee080e7          	jalr	-1810(ra) # 5c1e <exec>
  pipe(big);
    1338:	6088                	ld	a0,0(s1)
    133a:	00005097          	auipc	ra,0x5
    133e:	8bc080e7          	jalr	-1860(ra) # 5bf6 <pipe>
  exit(0);
    1342:	4501                	li	a0,0
    1344:	00005097          	auipc	ra,0x5
    1348:	8a2080e7          	jalr	-1886(ra) # 5be6 <exit>

000000000000134c <badarg>:
{
    134c:	7139                	addi	sp,sp,-64
    134e:	fc06                	sd	ra,56(sp)
    1350:	f822                	sd	s0,48(sp)
    1352:	f426                	sd	s1,40(sp)
    1354:	f04a                	sd	s2,32(sp)
    1356:	ec4e                	sd	s3,24(sp)
    1358:	0080                	addi	s0,sp,64
    135a:	64b1                	lui	s1,0xc
    135c:	35048493          	addi	s1,s1,848 # c350 <uninit+0x1de8>
    argv[0] = (char*)0xffffffff;
    1360:	597d                	li	s2,-1
    1362:	02095913          	srli	s2,s2,0x20
    exec("echo", argv);
    1366:	00005997          	auipc	s3,0x5
    136a:	e0298993          	addi	s3,s3,-510 # 6168 <malloc+0x13c>
    argv[0] = (char*)0xffffffff;
    136e:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    1372:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    1376:	fc040593          	addi	a1,s0,-64
    137a:	854e                	mv	a0,s3
    137c:	00005097          	auipc	ra,0x5
    1380:	8a2080e7          	jalr	-1886(ra) # 5c1e <exec>
  for(int i = 0; i < 50000; i++){
    1384:	34fd                	addiw	s1,s1,-1
    1386:	f4e5                	bnez	s1,136e <badarg+0x22>
  exit(0);
    1388:	4501                	li	a0,0
    138a:	00005097          	auipc	ra,0x5
    138e:	85c080e7          	jalr	-1956(ra) # 5be6 <exit>

0000000000001392 <copyinstr2>:
{
    1392:	7155                	addi	sp,sp,-208
    1394:	e586                	sd	ra,200(sp)
    1396:	e1a2                	sd	s0,192(sp)
    1398:	0980                	addi	s0,sp,208
  for(int i = 0; i < MAXPATH; i++)
    139a:	f6840793          	addi	a5,s0,-152
    139e:	fe840693          	addi	a3,s0,-24
    b[i] = 'x';
    13a2:	07800713          	li	a4,120
    13a6:	00e78023          	sb	a4,0(a5)
  for(int i = 0; i < MAXPATH; i++)
    13aa:	0785                	addi	a5,a5,1
    13ac:	fed79de3          	bne	a5,a3,13a6 <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    13b0:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    13b4:	f6840513          	addi	a0,s0,-152
    13b8:	00005097          	auipc	ra,0x5
    13bc:	87e080e7          	jalr	-1922(ra) # 5c36 <unlink>
  if(ret != -1){
    13c0:	57fd                	li	a5,-1
    13c2:	0ef51063          	bne	a0,a5,14a2 <copyinstr2+0x110>
  int fd = open(b, O_CREATE | O_WRONLY);
    13c6:	20100593          	li	a1,513
    13ca:	f6840513          	addi	a0,s0,-152
    13ce:	00005097          	auipc	ra,0x5
    13d2:	858080e7          	jalr	-1960(ra) # 5c26 <open>
  if(fd != -1){
    13d6:	57fd                	li	a5,-1
    13d8:	0ef51563          	bne	a0,a5,14c2 <copyinstr2+0x130>
  ret = link(b, b);
    13dc:	f6840593          	addi	a1,s0,-152
    13e0:	852e                	mv	a0,a1
    13e2:	00005097          	auipc	ra,0x5
    13e6:	864080e7          	jalr	-1948(ra) # 5c46 <link>
  if(ret != -1){
    13ea:	57fd                	li	a5,-1
    13ec:	0ef51b63          	bne	a0,a5,14e2 <copyinstr2+0x150>
  char *args[] = { "xx", 0 };
    13f0:	00006797          	auipc	a5,0x6
    13f4:	75878793          	addi	a5,a5,1880 # 7b48 <malloc+0x1b1c>
    13f8:	f4f43c23          	sd	a5,-168(s0)
    13fc:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    1400:	f5840593          	addi	a1,s0,-168
    1404:	f6840513          	addi	a0,s0,-152
    1408:	00005097          	auipc	ra,0x5
    140c:	816080e7          	jalr	-2026(ra) # 5c1e <exec>
  if(ret != -1){
    1410:	57fd                	li	a5,-1
    1412:	0ef51963          	bne	a0,a5,1504 <copyinstr2+0x172>
  int pid = fork();
    1416:	00004097          	auipc	ra,0x4
    141a:	7c8080e7          	jalr	1992(ra) # 5bde <fork>
  if(pid < 0){
    141e:	10054363          	bltz	a0,1524 <copyinstr2+0x192>
  if(pid == 0){
    1422:	12051463          	bnez	a0,154a <copyinstr2+0x1b8>
    1426:	00008797          	auipc	a5,0x8
    142a:	13a78793          	addi	a5,a5,314 # 9560 <big.1277>
    142e:	00009697          	auipc	a3,0x9
    1432:	13268693          	addi	a3,a3,306 # a560 <big.1277+0x1000>
      big[i] = 'x';
    1436:	07800713          	li	a4,120
    143a:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
    143e:	0785                	addi	a5,a5,1
    1440:	fed79de3          	bne	a5,a3,143a <copyinstr2+0xa8>
    big[PGSIZE] = '\0';
    1444:	00009797          	auipc	a5,0x9
    1448:	10078e23          	sb	zero,284(a5) # a560 <big.1277+0x1000>
    char *args2[] = { big, big, big, 0 };
    144c:	00007797          	auipc	a5,0x7
    1450:	11c78793          	addi	a5,a5,284 # 8568 <malloc+0x253c>
    1454:	6390                	ld	a2,0(a5)
    1456:	6794                	ld	a3,8(a5)
    1458:	6b98                	ld	a4,16(a5)
    145a:	6f9c                	ld	a5,24(a5)
    145c:	f2c43823          	sd	a2,-208(s0)
    1460:	f2d43c23          	sd	a3,-200(s0)
    1464:	f4e43023          	sd	a4,-192(s0)
    1468:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    146c:	f3040593          	addi	a1,s0,-208
    1470:	00005517          	auipc	a0,0x5
    1474:	cf850513          	addi	a0,a0,-776 # 6168 <malloc+0x13c>
    1478:	00004097          	auipc	ra,0x4
    147c:	7a6080e7          	jalr	1958(ra) # 5c1e <exec>
    if(ret != -1){
    1480:	57fd                	li	a5,-1
    1482:	0af50e63          	beq	a0,a5,153e <copyinstr2+0x1ac>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    1486:	55fd                	li	a1,-1
    1488:	00005517          	auipc	a0,0x5
    148c:	51050513          	addi	a0,a0,1296 # 6998 <malloc+0x96c>
    1490:	00005097          	auipc	ra,0x5
    1494:	ade080e7          	jalr	-1314(ra) # 5f6e <printf>
      exit(1);
    1498:	4505                	li	a0,1
    149a:	00004097          	auipc	ra,0x4
    149e:	74c080e7          	jalr	1868(ra) # 5be6 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    14a2:	862a                	mv	a2,a0
    14a4:	f6840593          	addi	a1,s0,-152
    14a8:	00005517          	auipc	a0,0x5
    14ac:	46850513          	addi	a0,a0,1128 # 6910 <malloc+0x8e4>
    14b0:	00005097          	auipc	ra,0x5
    14b4:	abe080e7          	jalr	-1346(ra) # 5f6e <printf>
    exit(1);
    14b8:	4505                	li	a0,1
    14ba:	00004097          	auipc	ra,0x4
    14be:	72c080e7          	jalr	1836(ra) # 5be6 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    14c2:	862a                	mv	a2,a0
    14c4:	f6840593          	addi	a1,s0,-152
    14c8:	00005517          	auipc	a0,0x5
    14cc:	46850513          	addi	a0,a0,1128 # 6930 <malloc+0x904>
    14d0:	00005097          	auipc	ra,0x5
    14d4:	a9e080e7          	jalr	-1378(ra) # 5f6e <printf>
    exit(1);
    14d8:	4505                	li	a0,1
    14da:	00004097          	auipc	ra,0x4
    14de:	70c080e7          	jalr	1804(ra) # 5be6 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    14e2:	86aa                	mv	a3,a0
    14e4:	f6840613          	addi	a2,s0,-152
    14e8:	85b2                	mv	a1,a2
    14ea:	00005517          	auipc	a0,0x5
    14ee:	46650513          	addi	a0,a0,1126 # 6950 <malloc+0x924>
    14f2:	00005097          	auipc	ra,0x5
    14f6:	a7c080e7          	jalr	-1412(ra) # 5f6e <printf>
    exit(1);
    14fa:	4505                	li	a0,1
    14fc:	00004097          	auipc	ra,0x4
    1500:	6ea080e7          	jalr	1770(ra) # 5be6 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    1504:	567d                	li	a2,-1
    1506:	f6840593          	addi	a1,s0,-152
    150a:	00005517          	auipc	a0,0x5
    150e:	46e50513          	addi	a0,a0,1134 # 6978 <malloc+0x94c>
    1512:	00005097          	auipc	ra,0x5
    1516:	a5c080e7          	jalr	-1444(ra) # 5f6e <printf>
    exit(1);
    151a:	4505                	li	a0,1
    151c:	00004097          	auipc	ra,0x4
    1520:	6ca080e7          	jalr	1738(ra) # 5be6 <exit>
    printf("fork failed\n");
    1524:	00006517          	auipc	a0,0x6
    1528:	8d450513          	addi	a0,a0,-1836 # 6df8 <malloc+0xdcc>
    152c:	00005097          	auipc	ra,0x5
    1530:	a42080e7          	jalr	-1470(ra) # 5f6e <printf>
    exit(1);
    1534:	4505                	li	a0,1
    1536:	00004097          	auipc	ra,0x4
    153a:	6b0080e7          	jalr	1712(ra) # 5be6 <exit>
    exit(747); // OK
    153e:	2eb00513          	li	a0,747
    1542:	00004097          	auipc	ra,0x4
    1546:	6a4080e7          	jalr	1700(ra) # 5be6 <exit>
  int st = 0;
    154a:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    154e:	f5440513          	addi	a0,s0,-172
    1552:	00004097          	auipc	ra,0x4
    1556:	69c080e7          	jalr	1692(ra) # 5bee <wait>
  if(st != 747){
    155a:	f5442703          	lw	a4,-172(s0)
    155e:	2eb00793          	li	a5,747
    1562:	00f71663          	bne	a4,a5,156e <copyinstr2+0x1dc>
}
    1566:	60ae                	ld	ra,200(sp)
    1568:	640e                	ld	s0,192(sp)
    156a:	6169                	addi	sp,sp,208
    156c:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    156e:	00005517          	auipc	a0,0x5
    1572:	45250513          	addi	a0,a0,1106 # 69c0 <malloc+0x994>
    1576:	00005097          	auipc	ra,0x5
    157a:	9f8080e7          	jalr	-1544(ra) # 5f6e <printf>
    exit(1);
    157e:	4505                	li	a0,1
    1580:	00004097          	auipc	ra,0x4
    1584:	666080e7          	jalr	1638(ra) # 5be6 <exit>

0000000000001588 <truncate3>:
{
    1588:	7159                	addi	sp,sp,-112
    158a:	f486                	sd	ra,104(sp)
    158c:	f0a2                	sd	s0,96(sp)
    158e:	eca6                	sd	s1,88(sp)
    1590:	e8ca                	sd	s2,80(sp)
    1592:	e4ce                	sd	s3,72(sp)
    1594:	e0d2                	sd	s4,64(sp)
    1596:	fc56                	sd	s5,56(sp)
    1598:	1880                	addi	s0,sp,112
    159a:	892a                	mv	s2,a0
  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
    159c:	60100593          	li	a1,1537
    15a0:	00005517          	auipc	a0,0x5
    15a4:	c2050513          	addi	a0,a0,-992 # 61c0 <malloc+0x194>
    15a8:	00004097          	auipc	ra,0x4
    15ac:	67e080e7          	jalr	1662(ra) # 5c26 <open>
    15b0:	00004097          	auipc	ra,0x4
    15b4:	65e080e7          	jalr	1630(ra) # 5c0e <close>
  pid = fork();
    15b8:	00004097          	auipc	ra,0x4
    15bc:	626080e7          	jalr	1574(ra) # 5bde <fork>
  if(pid < 0){
    15c0:	08054063          	bltz	a0,1640 <truncate3+0xb8>
  if(pid == 0){
    15c4:	e969                	bnez	a0,1696 <truncate3+0x10e>
    15c6:	06400993          	li	s3,100
      int fd = open("truncfile", O_WRONLY);
    15ca:	00005a17          	auipc	s4,0x5
    15ce:	bf6a0a13          	addi	s4,s4,-1034 # 61c0 <malloc+0x194>
      int n = write(fd, "1234567890", 10);
    15d2:	00005a97          	auipc	s5,0x5
    15d6:	44ea8a93          	addi	s5,s5,1102 # 6a20 <malloc+0x9f4>
      int fd = open("truncfile", O_WRONLY);
    15da:	4585                	li	a1,1
    15dc:	8552                	mv	a0,s4
    15de:	00004097          	auipc	ra,0x4
    15e2:	648080e7          	jalr	1608(ra) # 5c26 <open>
    15e6:	84aa                	mv	s1,a0
      if(fd < 0){
    15e8:	06054a63          	bltz	a0,165c <truncate3+0xd4>
      int n = write(fd, "1234567890", 10);
    15ec:	4629                	li	a2,10
    15ee:	85d6                	mv	a1,s5
    15f0:	00004097          	auipc	ra,0x4
    15f4:	616080e7          	jalr	1558(ra) # 5c06 <write>
      if(n != 10){
    15f8:	47a9                	li	a5,10
    15fa:	06f51f63          	bne	a0,a5,1678 <truncate3+0xf0>
      close(fd);
    15fe:	8526                	mv	a0,s1
    1600:	00004097          	auipc	ra,0x4
    1604:	60e080e7          	jalr	1550(ra) # 5c0e <close>
      fd = open("truncfile", O_RDONLY);
    1608:	4581                	li	a1,0
    160a:	8552                	mv	a0,s4
    160c:	00004097          	auipc	ra,0x4
    1610:	61a080e7          	jalr	1562(ra) # 5c26 <open>
    1614:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    1616:	02000613          	li	a2,32
    161a:	f9840593          	addi	a1,s0,-104
    161e:	00004097          	auipc	ra,0x4
    1622:	5e0080e7          	jalr	1504(ra) # 5bfe <read>
      close(fd);
    1626:	8526                	mv	a0,s1
    1628:	00004097          	auipc	ra,0x4
    162c:	5e6080e7          	jalr	1510(ra) # 5c0e <close>
    for(int i = 0; i < 100; i++){
    1630:	39fd                	addiw	s3,s3,-1
    1632:	fa0994e3          	bnez	s3,15da <truncate3+0x52>
    exit(0);
    1636:	4501                	li	a0,0
    1638:	00004097          	auipc	ra,0x4
    163c:	5ae080e7          	jalr	1454(ra) # 5be6 <exit>
    printf("%s: fork failed\n", s);
    1640:	85ca                	mv	a1,s2
    1642:	00005517          	auipc	a0,0x5
    1646:	3ae50513          	addi	a0,a0,942 # 69f0 <malloc+0x9c4>
    164a:	00005097          	auipc	ra,0x5
    164e:	924080e7          	jalr	-1756(ra) # 5f6e <printf>
    exit(1);
    1652:	4505                	li	a0,1
    1654:	00004097          	auipc	ra,0x4
    1658:	592080e7          	jalr	1426(ra) # 5be6 <exit>
        printf("%s: open failed\n", s);
    165c:	85ca                	mv	a1,s2
    165e:	00005517          	auipc	a0,0x5
    1662:	3aa50513          	addi	a0,a0,938 # 6a08 <malloc+0x9dc>
    1666:	00005097          	auipc	ra,0x5
    166a:	908080e7          	jalr	-1784(ra) # 5f6e <printf>
        exit(1);
    166e:	4505                	li	a0,1
    1670:	00004097          	auipc	ra,0x4
    1674:	576080e7          	jalr	1398(ra) # 5be6 <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    1678:	862a                	mv	a2,a0
    167a:	85ca                	mv	a1,s2
    167c:	00005517          	auipc	a0,0x5
    1680:	3b450513          	addi	a0,a0,948 # 6a30 <malloc+0xa04>
    1684:	00005097          	auipc	ra,0x5
    1688:	8ea080e7          	jalr	-1814(ra) # 5f6e <printf>
        exit(1);
    168c:	4505                	li	a0,1
    168e:	00004097          	auipc	ra,0x4
    1692:	558080e7          	jalr	1368(ra) # 5be6 <exit>
    1696:	09600993          	li	s3,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    169a:	00005a17          	auipc	s4,0x5
    169e:	b26a0a13          	addi	s4,s4,-1242 # 61c0 <malloc+0x194>
    int n = write(fd, "xxx", 3);
    16a2:	00005a97          	auipc	s5,0x5
    16a6:	3aea8a93          	addi	s5,s5,942 # 6a50 <malloc+0xa24>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    16aa:	60100593          	li	a1,1537
    16ae:	8552                	mv	a0,s4
    16b0:	00004097          	auipc	ra,0x4
    16b4:	576080e7          	jalr	1398(ra) # 5c26 <open>
    16b8:	84aa                	mv	s1,a0
    if(fd < 0){
    16ba:	04054763          	bltz	a0,1708 <truncate3+0x180>
    int n = write(fd, "xxx", 3);
    16be:	460d                	li	a2,3
    16c0:	85d6                	mv	a1,s5
    16c2:	00004097          	auipc	ra,0x4
    16c6:	544080e7          	jalr	1348(ra) # 5c06 <write>
    if(n != 3){
    16ca:	478d                	li	a5,3
    16cc:	04f51c63          	bne	a0,a5,1724 <truncate3+0x19c>
    close(fd);
    16d0:	8526                	mv	a0,s1
    16d2:	00004097          	auipc	ra,0x4
    16d6:	53c080e7          	jalr	1340(ra) # 5c0e <close>
  for(int i = 0; i < 150; i++){
    16da:	39fd                	addiw	s3,s3,-1
    16dc:	fc0997e3          	bnez	s3,16aa <truncate3+0x122>
  wait(&xstatus);
    16e0:	fbc40513          	addi	a0,s0,-68
    16e4:	00004097          	auipc	ra,0x4
    16e8:	50a080e7          	jalr	1290(ra) # 5bee <wait>
  unlink("truncfile");
    16ec:	00005517          	auipc	a0,0x5
    16f0:	ad450513          	addi	a0,a0,-1324 # 61c0 <malloc+0x194>
    16f4:	00004097          	auipc	ra,0x4
    16f8:	542080e7          	jalr	1346(ra) # 5c36 <unlink>
  exit(xstatus);
    16fc:	fbc42503          	lw	a0,-68(s0)
    1700:	00004097          	auipc	ra,0x4
    1704:	4e6080e7          	jalr	1254(ra) # 5be6 <exit>
      printf("%s: open failed\n", s);
    1708:	85ca                	mv	a1,s2
    170a:	00005517          	auipc	a0,0x5
    170e:	2fe50513          	addi	a0,a0,766 # 6a08 <malloc+0x9dc>
    1712:	00005097          	auipc	ra,0x5
    1716:	85c080e7          	jalr	-1956(ra) # 5f6e <printf>
      exit(1);
    171a:	4505                	li	a0,1
    171c:	00004097          	auipc	ra,0x4
    1720:	4ca080e7          	jalr	1226(ra) # 5be6 <exit>
      printf("%s: write got %d, expected 3\n", s, n);
    1724:	862a                	mv	a2,a0
    1726:	85ca                	mv	a1,s2
    1728:	00005517          	auipc	a0,0x5
    172c:	33050513          	addi	a0,a0,816 # 6a58 <malloc+0xa2c>
    1730:	00005097          	auipc	ra,0x5
    1734:	83e080e7          	jalr	-1986(ra) # 5f6e <printf>
      exit(1);
    1738:	4505                	li	a0,1
    173a:	00004097          	auipc	ra,0x4
    173e:	4ac080e7          	jalr	1196(ra) # 5be6 <exit>

0000000000001742 <exectest>:
{
    1742:	715d                	addi	sp,sp,-80
    1744:	e486                	sd	ra,72(sp)
    1746:	e0a2                	sd	s0,64(sp)
    1748:	fc26                	sd	s1,56(sp)
    174a:	f84a                	sd	s2,48(sp)
    174c:	0880                	addi	s0,sp,80
    174e:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    1750:	00005797          	auipc	a5,0x5
    1754:	a1878793          	addi	a5,a5,-1512 # 6168 <malloc+0x13c>
    1758:	fcf43023          	sd	a5,-64(s0)
    175c:	00005797          	auipc	a5,0x5
    1760:	31c78793          	addi	a5,a5,796 # 6a78 <malloc+0xa4c>
    1764:	fcf43423          	sd	a5,-56(s0)
    1768:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    176c:	00005517          	auipc	a0,0x5
    1770:	31450513          	addi	a0,a0,788 # 6a80 <malloc+0xa54>
    1774:	00004097          	auipc	ra,0x4
    1778:	4c2080e7          	jalr	1218(ra) # 5c36 <unlink>
  pid = fork();
    177c:	00004097          	auipc	ra,0x4
    1780:	462080e7          	jalr	1122(ra) # 5bde <fork>
  if(pid < 0) {
    1784:	04054663          	bltz	a0,17d0 <exectest+0x8e>
    1788:	84aa                	mv	s1,a0
  if(pid == 0) {
    178a:	e959                	bnez	a0,1820 <exectest+0xde>
    close(1);
    178c:	4505                	li	a0,1
    178e:	00004097          	auipc	ra,0x4
    1792:	480080e7          	jalr	1152(ra) # 5c0e <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    1796:	20100593          	li	a1,513
    179a:	00005517          	auipc	a0,0x5
    179e:	2e650513          	addi	a0,a0,742 # 6a80 <malloc+0xa54>
    17a2:	00004097          	auipc	ra,0x4
    17a6:	484080e7          	jalr	1156(ra) # 5c26 <open>
    if(fd < 0) {
    17aa:	04054163          	bltz	a0,17ec <exectest+0xaa>
    if(fd != 1) {
    17ae:	4785                	li	a5,1
    17b0:	04f50c63          	beq	a0,a5,1808 <exectest+0xc6>
      printf("%s: wrong fd\n", s);
    17b4:	85ca                	mv	a1,s2
    17b6:	00005517          	auipc	a0,0x5
    17ba:	2ea50513          	addi	a0,a0,746 # 6aa0 <malloc+0xa74>
    17be:	00004097          	auipc	ra,0x4
    17c2:	7b0080e7          	jalr	1968(ra) # 5f6e <printf>
      exit(1);
    17c6:	4505                	li	a0,1
    17c8:	00004097          	auipc	ra,0x4
    17cc:	41e080e7          	jalr	1054(ra) # 5be6 <exit>
     printf("%s: fork failed\n", s);
    17d0:	85ca                	mv	a1,s2
    17d2:	00005517          	auipc	a0,0x5
    17d6:	21e50513          	addi	a0,a0,542 # 69f0 <malloc+0x9c4>
    17da:	00004097          	auipc	ra,0x4
    17de:	794080e7          	jalr	1940(ra) # 5f6e <printf>
     exit(1);
    17e2:	4505                	li	a0,1
    17e4:	00004097          	auipc	ra,0x4
    17e8:	402080e7          	jalr	1026(ra) # 5be6 <exit>
      printf("%s: create failed\n", s);
    17ec:	85ca                	mv	a1,s2
    17ee:	00005517          	auipc	a0,0x5
    17f2:	29a50513          	addi	a0,a0,666 # 6a88 <malloc+0xa5c>
    17f6:	00004097          	auipc	ra,0x4
    17fa:	778080e7          	jalr	1912(ra) # 5f6e <printf>
      exit(1);
    17fe:	4505                	li	a0,1
    1800:	00004097          	auipc	ra,0x4
    1804:	3e6080e7          	jalr	998(ra) # 5be6 <exit>
    if(exec("echo", echoargv) < 0){
    1808:	fc040593          	addi	a1,s0,-64
    180c:	00005517          	auipc	a0,0x5
    1810:	95c50513          	addi	a0,a0,-1700 # 6168 <malloc+0x13c>
    1814:	00004097          	auipc	ra,0x4
    1818:	40a080e7          	jalr	1034(ra) # 5c1e <exec>
    181c:	02054163          	bltz	a0,183e <exectest+0xfc>
  if (wait(&xstatus) != pid) {
    1820:	fdc40513          	addi	a0,s0,-36
    1824:	00004097          	auipc	ra,0x4
    1828:	3ca080e7          	jalr	970(ra) # 5bee <wait>
    182c:	02951763          	bne	a0,s1,185a <exectest+0x118>
  if(xstatus != 0)
    1830:	fdc42503          	lw	a0,-36(s0)
    1834:	cd0d                	beqz	a0,186e <exectest+0x12c>
    exit(xstatus);
    1836:	00004097          	auipc	ra,0x4
    183a:	3b0080e7          	jalr	944(ra) # 5be6 <exit>
      printf("%s: exec echo failed\n", s);
    183e:	85ca                	mv	a1,s2
    1840:	00005517          	auipc	a0,0x5
    1844:	27050513          	addi	a0,a0,624 # 6ab0 <malloc+0xa84>
    1848:	00004097          	auipc	ra,0x4
    184c:	726080e7          	jalr	1830(ra) # 5f6e <printf>
      exit(1);
    1850:	4505                	li	a0,1
    1852:	00004097          	auipc	ra,0x4
    1856:	394080e7          	jalr	916(ra) # 5be6 <exit>
    printf("%s: wait failed!\n", s);
    185a:	85ca                	mv	a1,s2
    185c:	00005517          	auipc	a0,0x5
    1860:	26c50513          	addi	a0,a0,620 # 6ac8 <malloc+0xa9c>
    1864:	00004097          	auipc	ra,0x4
    1868:	70a080e7          	jalr	1802(ra) # 5f6e <printf>
    186c:	b7d1                	j	1830 <exectest+0xee>
  fd = open("echo-ok", O_RDONLY);
    186e:	4581                	li	a1,0
    1870:	00005517          	auipc	a0,0x5
    1874:	21050513          	addi	a0,a0,528 # 6a80 <malloc+0xa54>
    1878:	00004097          	auipc	ra,0x4
    187c:	3ae080e7          	jalr	942(ra) # 5c26 <open>
  if(fd < 0) {
    1880:	02054a63          	bltz	a0,18b4 <exectest+0x172>
  if (read(fd, buf, 2) != 2) {
    1884:	4609                	li	a2,2
    1886:	fb840593          	addi	a1,s0,-72
    188a:	00004097          	auipc	ra,0x4
    188e:	374080e7          	jalr	884(ra) # 5bfe <read>
    1892:	4789                	li	a5,2
    1894:	02f50e63          	beq	a0,a5,18d0 <exectest+0x18e>
    printf("%s: read failed\n", s);
    1898:	85ca                	mv	a1,s2
    189a:	00005517          	auipc	a0,0x5
    189e:	c9e50513          	addi	a0,a0,-866 # 6538 <malloc+0x50c>
    18a2:	00004097          	auipc	ra,0x4
    18a6:	6cc080e7          	jalr	1740(ra) # 5f6e <printf>
    exit(1);
    18aa:	4505                	li	a0,1
    18ac:	00004097          	auipc	ra,0x4
    18b0:	33a080e7          	jalr	826(ra) # 5be6 <exit>
    printf("%s: open failed\n", s);
    18b4:	85ca                	mv	a1,s2
    18b6:	00005517          	auipc	a0,0x5
    18ba:	15250513          	addi	a0,a0,338 # 6a08 <malloc+0x9dc>
    18be:	00004097          	auipc	ra,0x4
    18c2:	6b0080e7          	jalr	1712(ra) # 5f6e <printf>
    exit(1);
    18c6:	4505                	li	a0,1
    18c8:	00004097          	auipc	ra,0x4
    18cc:	31e080e7          	jalr	798(ra) # 5be6 <exit>
  unlink("echo-ok");
    18d0:	00005517          	auipc	a0,0x5
    18d4:	1b050513          	addi	a0,a0,432 # 6a80 <malloc+0xa54>
    18d8:	00004097          	auipc	ra,0x4
    18dc:	35e080e7          	jalr	862(ra) # 5c36 <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    18e0:	fb844703          	lbu	a4,-72(s0)
    18e4:	04f00793          	li	a5,79
    18e8:	00f71863          	bne	a4,a5,18f8 <exectest+0x1b6>
    18ec:	fb944703          	lbu	a4,-71(s0)
    18f0:	04b00793          	li	a5,75
    18f4:	02f70063          	beq	a4,a5,1914 <exectest+0x1d2>
    printf("%s: wrong output\n", s);
    18f8:	85ca                	mv	a1,s2
    18fa:	00005517          	auipc	a0,0x5
    18fe:	1e650513          	addi	a0,a0,486 # 6ae0 <malloc+0xab4>
    1902:	00004097          	auipc	ra,0x4
    1906:	66c080e7          	jalr	1644(ra) # 5f6e <printf>
    exit(1);
    190a:	4505                	li	a0,1
    190c:	00004097          	auipc	ra,0x4
    1910:	2da080e7          	jalr	730(ra) # 5be6 <exit>
    exit(0);
    1914:	4501                	li	a0,0
    1916:	00004097          	auipc	ra,0x4
    191a:	2d0080e7          	jalr	720(ra) # 5be6 <exit>

000000000000191e <pipe1>:
{
    191e:	711d                	addi	sp,sp,-96
    1920:	ec86                	sd	ra,88(sp)
    1922:	e8a2                	sd	s0,80(sp)
    1924:	e4a6                	sd	s1,72(sp)
    1926:	e0ca                	sd	s2,64(sp)
    1928:	fc4e                	sd	s3,56(sp)
    192a:	f852                	sd	s4,48(sp)
    192c:	f456                	sd	s5,40(sp)
    192e:	f05a                	sd	s6,32(sp)
    1930:	ec5e                	sd	s7,24(sp)
    1932:	1080                	addi	s0,sp,96
    1934:	892a                	mv	s2,a0
  if(pipe(fds) != 0){
    1936:	fa840513          	addi	a0,s0,-88
    193a:	00004097          	auipc	ra,0x4
    193e:	2bc080e7          	jalr	700(ra) # 5bf6 <pipe>
    1942:	ed25                	bnez	a0,19ba <pipe1+0x9c>
    1944:	84aa                	mv	s1,a0
  pid = fork();
    1946:	00004097          	auipc	ra,0x4
    194a:	298080e7          	jalr	664(ra) # 5bde <fork>
    194e:	8a2a                	mv	s4,a0
  if(pid == 0){
    1950:	c159                	beqz	a0,19d6 <pipe1+0xb8>
  } else if(pid > 0){
    1952:	16a05e63          	blez	a0,1ace <pipe1+0x1b0>
    close(fds[1]);
    1956:	fac42503          	lw	a0,-84(s0)
    195a:	00004097          	auipc	ra,0x4
    195e:	2b4080e7          	jalr	692(ra) # 5c0e <close>
    total = 0;
    1962:	8a26                	mv	s4,s1
    cc = 1;
    1964:	4985                	li	s3,1
    while((n = read(fds[0], buf, cc)) > 0){
    1966:	0000ba97          	auipc	s5,0xb
    196a:	312a8a93          	addi	s5,s5,786 # cc78 <buf>
      if(cc > sizeof(buf))
    196e:	6b0d                	lui	s6,0x3
    while((n = read(fds[0], buf, cc)) > 0){
    1970:	864e                	mv	a2,s3
    1972:	85d6                	mv	a1,s5
    1974:	fa842503          	lw	a0,-88(s0)
    1978:	00004097          	auipc	ra,0x4
    197c:	286080e7          	jalr	646(ra) # 5bfe <read>
    1980:	10a05263          	blez	a0,1a84 <pipe1+0x166>
      for(i = 0; i < n; i++){
    1984:	0000b717          	auipc	a4,0xb
    1988:	2f470713          	addi	a4,a4,756 # cc78 <buf>
    198c:	00a4863b          	addw	a2,s1,a0
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    1990:	00074683          	lbu	a3,0(a4)
    1994:	0ff4f793          	andi	a5,s1,255
    1998:	2485                	addiw	s1,s1,1
    199a:	0cf69163          	bne	a3,a5,1a5c <pipe1+0x13e>
      for(i = 0; i < n; i++){
    199e:	0705                	addi	a4,a4,1
    19a0:	fec498e3          	bne	s1,a2,1990 <pipe1+0x72>
      total += n;
    19a4:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
    19a8:	0019979b          	slliw	a5,s3,0x1
    19ac:	0007899b          	sext.w	s3,a5
      if(cc > sizeof(buf))
    19b0:	013b7363          	bgeu	s6,s3,19b6 <pipe1+0x98>
        cc = sizeof(buf);
    19b4:	89da                	mv	s3,s6
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    19b6:	84b2                	mv	s1,a2
    19b8:	bf65                	j	1970 <pipe1+0x52>
    printf("%s: pipe() failed\n", s);
    19ba:	85ca                	mv	a1,s2
    19bc:	00005517          	auipc	a0,0x5
    19c0:	13c50513          	addi	a0,a0,316 # 6af8 <malloc+0xacc>
    19c4:	00004097          	auipc	ra,0x4
    19c8:	5aa080e7          	jalr	1450(ra) # 5f6e <printf>
    exit(1);
    19cc:	4505                	li	a0,1
    19ce:	00004097          	auipc	ra,0x4
    19d2:	218080e7          	jalr	536(ra) # 5be6 <exit>
    close(fds[0]);
    19d6:	fa842503          	lw	a0,-88(s0)
    19da:	00004097          	auipc	ra,0x4
    19de:	234080e7          	jalr	564(ra) # 5c0e <close>
    for(n = 0; n < N; n++){
    19e2:	0000bb17          	auipc	s6,0xb
    19e6:	296b0b13          	addi	s6,s6,662 # cc78 <buf>
    19ea:	416004bb          	negw	s1,s6
    19ee:	0ff4f493          	andi	s1,s1,255
    19f2:	409b0993          	addi	s3,s6,1033
      if(write(fds[1], buf, SZ) != SZ){
    19f6:	8bda                	mv	s7,s6
    for(n = 0; n < N; n++){
    19f8:	6a85                	lui	s5,0x1
    19fa:	42da8a93          	addi	s5,s5,1069 # 142d <copyinstr2+0x9b>
{
    19fe:	87da                	mv	a5,s6
        buf[i] = seq++;
    1a00:	0097873b          	addw	a4,a5,s1
    1a04:	00e78023          	sb	a4,0(a5)
      for(i = 0; i < SZ; i++)
    1a08:	0785                	addi	a5,a5,1
    1a0a:	fef99be3          	bne	s3,a5,1a00 <pipe1+0xe2>
    1a0e:	409a0a1b          	addiw	s4,s4,1033
      if(write(fds[1], buf, SZ) != SZ){
    1a12:	40900613          	li	a2,1033
    1a16:	85de                	mv	a1,s7
    1a18:	fac42503          	lw	a0,-84(s0)
    1a1c:	00004097          	auipc	ra,0x4
    1a20:	1ea080e7          	jalr	490(ra) # 5c06 <write>
    1a24:	40900793          	li	a5,1033
    1a28:	00f51c63          	bne	a0,a5,1a40 <pipe1+0x122>
    for(n = 0; n < N; n++){
    1a2c:	24a5                	addiw	s1,s1,9
    1a2e:	0ff4f493          	andi	s1,s1,255
    1a32:	fd5a16e3          	bne	s4,s5,19fe <pipe1+0xe0>
    exit(0);
    1a36:	4501                	li	a0,0
    1a38:	00004097          	auipc	ra,0x4
    1a3c:	1ae080e7          	jalr	430(ra) # 5be6 <exit>
        printf("%s: pipe1 oops 1\n", s);
    1a40:	85ca                	mv	a1,s2
    1a42:	00005517          	auipc	a0,0x5
    1a46:	0ce50513          	addi	a0,a0,206 # 6b10 <malloc+0xae4>
    1a4a:	00004097          	auipc	ra,0x4
    1a4e:	524080e7          	jalr	1316(ra) # 5f6e <printf>
        exit(1);
    1a52:	4505                	li	a0,1
    1a54:	00004097          	auipc	ra,0x4
    1a58:	192080e7          	jalr	402(ra) # 5be6 <exit>
          printf("%s: pipe1 oops 2\n", s);
    1a5c:	85ca                	mv	a1,s2
    1a5e:	00005517          	auipc	a0,0x5
    1a62:	0ca50513          	addi	a0,a0,202 # 6b28 <malloc+0xafc>
    1a66:	00004097          	auipc	ra,0x4
    1a6a:	508080e7          	jalr	1288(ra) # 5f6e <printf>
}
    1a6e:	60e6                	ld	ra,88(sp)
    1a70:	6446                	ld	s0,80(sp)
    1a72:	64a6                	ld	s1,72(sp)
    1a74:	6906                	ld	s2,64(sp)
    1a76:	79e2                	ld	s3,56(sp)
    1a78:	7a42                	ld	s4,48(sp)
    1a7a:	7aa2                	ld	s5,40(sp)
    1a7c:	7b02                	ld	s6,32(sp)
    1a7e:	6be2                	ld	s7,24(sp)
    1a80:	6125                	addi	sp,sp,96
    1a82:	8082                	ret
    if(total != N * SZ){
    1a84:	6785                	lui	a5,0x1
    1a86:	42d78793          	addi	a5,a5,1069 # 142d <copyinstr2+0x9b>
    1a8a:	02fa0063          	beq	s4,a5,1aaa <pipe1+0x18c>
      printf("%s: pipe1 oops 3 total %d\n", total);
    1a8e:	85d2                	mv	a1,s4
    1a90:	00005517          	auipc	a0,0x5
    1a94:	0b050513          	addi	a0,a0,176 # 6b40 <malloc+0xb14>
    1a98:	00004097          	auipc	ra,0x4
    1a9c:	4d6080e7          	jalr	1238(ra) # 5f6e <printf>
      exit(1);
    1aa0:	4505                	li	a0,1
    1aa2:	00004097          	auipc	ra,0x4
    1aa6:	144080e7          	jalr	324(ra) # 5be6 <exit>
    close(fds[0]);
    1aaa:	fa842503          	lw	a0,-88(s0)
    1aae:	00004097          	auipc	ra,0x4
    1ab2:	160080e7          	jalr	352(ra) # 5c0e <close>
    wait(&xstatus);
    1ab6:	fa440513          	addi	a0,s0,-92
    1aba:	00004097          	auipc	ra,0x4
    1abe:	134080e7          	jalr	308(ra) # 5bee <wait>
    exit(xstatus);
    1ac2:	fa442503          	lw	a0,-92(s0)
    1ac6:	00004097          	auipc	ra,0x4
    1aca:	120080e7          	jalr	288(ra) # 5be6 <exit>
    printf("%s: fork() failed\n", s);
    1ace:	85ca                	mv	a1,s2
    1ad0:	00005517          	auipc	a0,0x5
    1ad4:	09050513          	addi	a0,a0,144 # 6b60 <malloc+0xb34>
    1ad8:	00004097          	auipc	ra,0x4
    1adc:	496080e7          	jalr	1174(ra) # 5f6e <printf>
    exit(1);
    1ae0:	4505                	li	a0,1
    1ae2:	00004097          	auipc	ra,0x4
    1ae6:	104080e7          	jalr	260(ra) # 5be6 <exit>

0000000000001aea <exitwait>:
{
    1aea:	7139                	addi	sp,sp,-64
    1aec:	fc06                	sd	ra,56(sp)
    1aee:	f822                	sd	s0,48(sp)
    1af0:	f426                	sd	s1,40(sp)
    1af2:	f04a                	sd	s2,32(sp)
    1af4:	ec4e                	sd	s3,24(sp)
    1af6:	e852                	sd	s4,16(sp)
    1af8:	0080                	addi	s0,sp,64
    1afa:	8a2a                	mv	s4,a0
  for(i = 0; i < 100; i++){
    1afc:	4901                	li	s2,0
    1afe:	06400993          	li	s3,100
    pid = fork();
    1b02:	00004097          	auipc	ra,0x4
    1b06:	0dc080e7          	jalr	220(ra) # 5bde <fork>
    1b0a:	84aa                	mv	s1,a0
    if(pid < 0){
    1b0c:	02054a63          	bltz	a0,1b40 <exitwait+0x56>
    if(pid){
    1b10:	c151                	beqz	a0,1b94 <exitwait+0xaa>
      if(wait(&xstate) != pid){
    1b12:	fcc40513          	addi	a0,s0,-52
    1b16:	00004097          	auipc	ra,0x4
    1b1a:	0d8080e7          	jalr	216(ra) # 5bee <wait>
    1b1e:	02951f63          	bne	a0,s1,1b5c <exitwait+0x72>
      if(i != xstate) {
    1b22:	fcc42783          	lw	a5,-52(s0)
    1b26:	05279963          	bne	a5,s2,1b78 <exitwait+0x8e>
  for(i = 0; i < 100; i++){
    1b2a:	2905                	addiw	s2,s2,1
    1b2c:	fd391be3          	bne	s2,s3,1b02 <exitwait+0x18>
}
    1b30:	70e2                	ld	ra,56(sp)
    1b32:	7442                	ld	s0,48(sp)
    1b34:	74a2                	ld	s1,40(sp)
    1b36:	7902                	ld	s2,32(sp)
    1b38:	69e2                	ld	s3,24(sp)
    1b3a:	6a42                	ld	s4,16(sp)
    1b3c:	6121                	addi	sp,sp,64
    1b3e:	8082                	ret
      printf("%s: fork failed\n", s);
    1b40:	85d2                	mv	a1,s4
    1b42:	00005517          	auipc	a0,0x5
    1b46:	eae50513          	addi	a0,a0,-338 # 69f0 <malloc+0x9c4>
    1b4a:	00004097          	auipc	ra,0x4
    1b4e:	424080e7          	jalr	1060(ra) # 5f6e <printf>
      exit(1);
    1b52:	4505                	li	a0,1
    1b54:	00004097          	auipc	ra,0x4
    1b58:	092080e7          	jalr	146(ra) # 5be6 <exit>
        printf("%s: wait wrong pid\n", s);
    1b5c:	85d2                	mv	a1,s4
    1b5e:	00005517          	auipc	a0,0x5
    1b62:	01a50513          	addi	a0,a0,26 # 6b78 <malloc+0xb4c>
    1b66:	00004097          	auipc	ra,0x4
    1b6a:	408080e7          	jalr	1032(ra) # 5f6e <printf>
        exit(1);
    1b6e:	4505                	li	a0,1
    1b70:	00004097          	auipc	ra,0x4
    1b74:	076080e7          	jalr	118(ra) # 5be6 <exit>
        printf("%s: wait wrong exit status\n", s);
    1b78:	85d2                	mv	a1,s4
    1b7a:	00005517          	auipc	a0,0x5
    1b7e:	01650513          	addi	a0,a0,22 # 6b90 <malloc+0xb64>
    1b82:	00004097          	auipc	ra,0x4
    1b86:	3ec080e7          	jalr	1004(ra) # 5f6e <printf>
        exit(1);
    1b8a:	4505                	li	a0,1
    1b8c:	00004097          	auipc	ra,0x4
    1b90:	05a080e7          	jalr	90(ra) # 5be6 <exit>
      exit(i);
    1b94:	854a                	mv	a0,s2
    1b96:	00004097          	auipc	ra,0x4
    1b9a:	050080e7          	jalr	80(ra) # 5be6 <exit>

0000000000001b9e <twochildren>:
{
    1b9e:	1101                	addi	sp,sp,-32
    1ba0:	ec06                	sd	ra,24(sp)
    1ba2:	e822                	sd	s0,16(sp)
    1ba4:	e426                	sd	s1,8(sp)
    1ba6:	e04a                	sd	s2,0(sp)
    1ba8:	1000                	addi	s0,sp,32
    1baa:	892a                	mv	s2,a0
    1bac:	3e800493          	li	s1,1000
    int pid1 = fork();
    1bb0:	00004097          	auipc	ra,0x4
    1bb4:	02e080e7          	jalr	46(ra) # 5bde <fork>
    if(pid1 < 0){
    1bb8:	02054c63          	bltz	a0,1bf0 <twochildren+0x52>
    if(pid1 == 0){
    1bbc:	c921                	beqz	a0,1c0c <twochildren+0x6e>
      int pid2 = fork();
    1bbe:	00004097          	auipc	ra,0x4
    1bc2:	020080e7          	jalr	32(ra) # 5bde <fork>
      if(pid2 < 0){
    1bc6:	04054763          	bltz	a0,1c14 <twochildren+0x76>
      if(pid2 == 0){
    1bca:	c13d                	beqz	a0,1c30 <twochildren+0x92>
        wait(0);
    1bcc:	4501                	li	a0,0
    1bce:	00004097          	auipc	ra,0x4
    1bd2:	020080e7          	jalr	32(ra) # 5bee <wait>
        wait(0);
    1bd6:	4501                	li	a0,0
    1bd8:	00004097          	auipc	ra,0x4
    1bdc:	016080e7          	jalr	22(ra) # 5bee <wait>
  for(int i = 0; i < 1000; i++){
    1be0:	34fd                	addiw	s1,s1,-1
    1be2:	f4f9                	bnez	s1,1bb0 <twochildren+0x12>
}
    1be4:	60e2                	ld	ra,24(sp)
    1be6:	6442                	ld	s0,16(sp)
    1be8:	64a2                	ld	s1,8(sp)
    1bea:	6902                	ld	s2,0(sp)
    1bec:	6105                	addi	sp,sp,32
    1bee:	8082                	ret
      printf("%s: fork failed\n", s);
    1bf0:	85ca                	mv	a1,s2
    1bf2:	00005517          	auipc	a0,0x5
    1bf6:	dfe50513          	addi	a0,a0,-514 # 69f0 <malloc+0x9c4>
    1bfa:	00004097          	auipc	ra,0x4
    1bfe:	374080e7          	jalr	884(ra) # 5f6e <printf>
      exit(1);
    1c02:	4505                	li	a0,1
    1c04:	00004097          	auipc	ra,0x4
    1c08:	fe2080e7          	jalr	-30(ra) # 5be6 <exit>
      exit(0);
    1c0c:	00004097          	auipc	ra,0x4
    1c10:	fda080e7          	jalr	-38(ra) # 5be6 <exit>
        printf("%s: fork failed\n", s);
    1c14:	85ca                	mv	a1,s2
    1c16:	00005517          	auipc	a0,0x5
    1c1a:	dda50513          	addi	a0,a0,-550 # 69f0 <malloc+0x9c4>
    1c1e:	00004097          	auipc	ra,0x4
    1c22:	350080e7          	jalr	848(ra) # 5f6e <printf>
        exit(1);
    1c26:	4505                	li	a0,1
    1c28:	00004097          	auipc	ra,0x4
    1c2c:	fbe080e7          	jalr	-66(ra) # 5be6 <exit>
        exit(0);
    1c30:	00004097          	auipc	ra,0x4
    1c34:	fb6080e7          	jalr	-74(ra) # 5be6 <exit>

0000000000001c38 <forkfork>:
{
    1c38:	7179                	addi	sp,sp,-48
    1c3a:	f406                	sd	ra,40(sp)
    1c3c:	f022                	sd	s0,32(sp)
    1c3e:	ec26                	sd	s1,24(sp)
    1c40:	1800                	addi	s0,sp,48
    1c42:	84aa                	mv	s1,a0
    int pid = fork();
    1c44:	00004097          	auipc	ra,0x4
    1c48:	f9a080e7          	jalr	-102(ra) # 5bde <fork>
    if(pid < 0){
    1c4c:	04054163          	bltz	a0,1c8e <forkfork+0x56>
    if(pid == 0){
    1c50:	cd29                	beqz	a0,1caa <forkfork+0x72>
    int pid = fork();
    1c52:	00004097          	auipc	ra,0x4
    1c56:	f8c080e7          	jalr	-116(ra) # 5bde <fork>
    if(pid < 0){
    1c5a:	02054a63          	bltz	a0,1c8e <forkfork+0x56>
    if(pid == 0){
    1c5e:	c531                	beqz	a0,1caa <forkfork+0x72>
    wait(&xstatus);
    1c60:	fdc40513          	addi	a0,s0,-36
    1c64:	00004097          	auipc	ra,0x4
    1c68:	f8a080e7          	jalr	-118(ra) # 5bee <wait>
    if(xstatus != 0) {
    1c6c:	fdc42783          	lw	a5,-36(s0)
    1c70:	ebbd                	bnez	a5,1ce6 <forkfork+0xae>
    wait(&xstatus);
    1c72:	fdc40513          	addi	a0,s0,-36
    1c76:	00004097          	auipc	ra,0x4
    1c7a:	f78080e7          	jalr	-136(ra) # 5bee <wait>
    if(xstatus != 0) {
    1c7e:	fdc42783          	lw	a5,-36(s0)
    1c82:	e3b5                	bnez	a5,1ce6 <forkfork+0xae>
}
    1c84:	70a2                	ld	ra,40(sp)
    1c86:	7402                	ld	s0,32(sp)
    1c88:	64e2                	ld	s1,24(sp)
    1c8a:	6145                	addi	sp,sp,48
    1c8c:	8082                	ret
      printf("%s: fork failed", s);
    1c8e:	85a6                	mv	a1,s1
    1c90:	00005517          	auipc	a0,0x5
    1c94:	f2050513          	addi	a0,a0,-224 # 6bb0 <malloc+0xb84>
    1c98:	00004097          	auipc	ra,0x4
    1c9c:	2d6080e7          	jalr	726(ra) # 5f6e <printf>
      exit(1);
    1ca0:	4505                	li	a0,1
    1ca2:	00004097          	auipc	ra,0x4
    1ca6:	f44080e7          	jalr	-188(ra) # 5be6 <exit>
{
    1caa:	0c800493          	li	s1,200
        int pid1 = fork();
    1cae:	00004097          	auipc	ra,0x4
    1cb2:	f30080e7          	jalr	-208(ra) # 5bde <fork>
        if(pid1 < 0){
    1cb6:	00054f63          	bltz	a0,1cd4 <forkfork+0x9c>
        if(pid1 == 0){
    1cba:	c115                	beqz	a0,1cde <forkfork+0xa6>
        wait(0);
    1cbc:	4501                	li	a0,0
    1cbe:	00004097          	auipc	ra,0x4
    1cc2:	f30080e7          	jalr	-208(ra) # 5bee <wait>
      for(int j = 0; j < 200; j++){
    1cc6:	34fd                	addiw	s1,s1,-1
    1cc8:	f0fd                	bnez	s1,1cae <forkfork+0x76>
      exit(0);
    1cca:	4501                	li	a0,0
    1ccc:	00004097          	auipc	ra,0x4
    1cd0:	f1a080e7          	jalr	-230(ra) # 5be6 <exit>
          exit(1);
    1cd4:	4505                	li	a0,1
    1cd6:	00004097          	auipc	ra,0x4
    1cda:	f10080e7          	jalr	-240(ra) # 5be6 <exit>
          exit(0);
    1cde:	00004097          	auipc	ra,0x4
    1ce2:	f08080e7          	jalr	-248(ra) # 5be6 <exit>
      printf("%s: fork in child failed", s);
    1ce6:	85a6                	mv	a1,s1
    1ce8:	00005517          	auipc	a0,0x5
    1cec:	ed850513          	addi	a0,a0,-296 # 6bc0 <malloc+0xb94>
    1cf0:	00004097          	auipc	ra,0x4
    1cf4:	27e080e7          	jalr	638(ra) # 5f6e <printf>
      exit(1);
    1cf8:	4505                	li	a0,1
    1cfa:	00004097          	auipc	ra,0x4
    1cfe:	eec080e7          	jalr	-276(ra) # 5be6 <exit>

0000000000001d02 <reparent2>:
{
    1d02:	1101                	addi	sp,sp,-32
    1d04:	ec06                	sd	ra,24(sp)
    1d06:	e822                	sd	s0,16(sp)
    1d08:	e426                	sd	s1,8(sp)
    1d0a:	1000                	addi	s0,sp,32
    1d0c:	32000493          	li	s1,800
    int pid1 = fork();
    1d10:	00004097          	auipc	ra,0x4
    1d14:	ece080e7          	jalr	-306(ra) # 5bde <fork>
    if(pid1 < 0){
    1d18:	00054f63          	bltz	a0,1d36 <reparent2+0x34>
    if(pid1 == 0){
    1d1c:	c915                	beqz	a0,1d50 <reparent2+0x4e>
    wait(0);
    1d1e:	4501                	li	a0,0
    1d20:	00004097          	auipc	ra,0x4
    1d24:	ece080e7          	jalr	-306(ra) # 5bee <wait>
  for(int i = 0; i < 800; i++){
    1d28:	34fd                	addiw	s1,s1,-1
    1d2a:	f0fd                	bnez	s1,1d10 <reparent2+0xe>
  exit(0);
    1d2c:	4501                	li	a0,0
    1d2e:	00004097          	auipc	ra,0x4
    1d32:	eb8080e7          	jalr	-328(ra) # 5be6 <exit>
      printf("fork failed\n");
    1d36:	00005517          	auipc	a0,0x5
    1d3a:	0c250513          	addi	a0,a0,194 # 6df8 <malloc+0xdcc>
    1d3e:	00004097          	auipc	ra,0x4
    1d42:	230080e7          	jalr	560(ra) # 5f6e <printf>
      exit(1);
    1d46:	4505                	li	a0,1
    1d48:	00004097          	auipc	ra,0x4
    1d4c:	e9e080e7          	jalr	-354(ra) # 5be6 <exit>
      fork();
    1d50:	00004097          	auipc	ra,0x4
    1d54:	e8e080e7          	jalr	-370(ra) # 5bde <fork>
      fork();
    1d58:	00004097          	auipc	ra,0x4
    1d5c:	e86080e7          	jalr	-378(ra) # 5bde <fork>
      exit(0);
    1d60:	4501                	li	a0,0
    1d62:	00004097          	auipc	ra,0x4
    1d66:	e84080e7          	jalr	-380(ra) # 5be6 <exit>

0000000000001d6a <createdelete>:
{
    1d6a:	7175                	addi	sp,sp,-144
    1d6c:	e506                	sd	ra,136(sp)
    1d6e:	e122                	sd	s0,128(sp)
    1d70:	fca6                	sd	s1,120(sp)
    1d72:	f8ca                	sd	s2,112(sp)
    1d74:	f4ce                	sd	s3,104(sp)
    1d76:	f0d2                	sd	s4,96(sp)
    1d78:	ecd6                	sd	s5,88(sp)
    1d7a:	e8da                	sd	s6,80(sp)
    1d7c:	e4de                	sd	s7,72(sp)
    1d7e:	e0e2                	sd	s8,64(sp)
    1d80:	fc66                	sd	s9,56(sp)
    1d82:	0900                	addi	s0,sp,144
    1d84:	8caa                	mv	s9,a0
  for(pi = 0; pi < NCHILD; pi++){
    1d86:	4901                	li	s2,0
    1d88:	4991                	li	s3,4
    pid = fork();
    1d8a:	00004097          	auipc	ra,0x4
    1d8e:	e54080e7          	jalr	-428(ra) # 5bde <fork>
    1d92:	84aa                	mv	s1,a0
    if(pid < 0){
    1d94:	02054f63          	bltz	a0,1dd2 <createdelete+0x68>
    if(pid == 0){
    1d98:	c939                	beqz	a0,1dee <createdelete+0x84>
  for(pi = 0; pi < NCHILD; pi++){
    1d9a:	2905                	addiw	s2,s2,1
    1d9c:	ff3917e3          	bne	s2,s3,1d8a <createdelete+0x20>
    1da0:	4491                	li	s1,4
    wait(&xstatus);
    1da2:	f7c40513          	addi	a0,s0,-132
    1da6:	00004097          	auipc	ra,0x4
    1daa:	e48080e7          	jalr	-440(ra) # 5bee <wait>
    if(xstatus != 0)
    1dae:	f7c42903          	lw	s2,-132(s0)
    1db2:	0e091263          	bnez	s2,1e96 <createdelete+0x12c>
  for(pi = 0; pi < NCHILD; pi++){
    1db6:	34fd                	addiw	s1,s1,-1
    1db8:	f4ed                	bnez	s1,1da2 <createdelete+0x38>
  name[0] = name[1] = name[2] = 0;
    1dba:	f8040123          	sb	zero,-126(s0)
    1dbe:	03000993          	li	s3,48
    1dc2:	5a7d                	li	s4,-1
    1dc4:	07000c13          	li	s8,112
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1dc8:	4b21                	li	s6,8
      if((i == 0 || i >= N/2) && fd < 0){
    1dca:	4ba5                	li	s7,9
    for(pi = 0; pi < NCHILD; pi++){
    1dcc:	07400a93          	li	s5,116
    1dd0:	a29d                	j	1f36 <createdelete+0x1cc>
      printf("fork failed\n", s);
    1dd2:	85e6                	mv	a1,s9
    1dd4:	00005517          	auipc	a0,0x5
    1dd8:	02450513          	addi	a0,a0,36 # 6df8 <malloc+0xdcc>
    1ddc:	00004097          	auipc	ra,0x4
    1de0:	192080e7          	jalr	402(ra) # 5f6e <printf>
      exit(1);
    1de4:	4505                	li	a0,1
    1de6:	00004097          	auipc	ra,0x4
    1dea:	e00080e7          	jalr	-512(ra) # 5be6 <exit>
      name[0] = 'p' + pi;
    1dee:	0709091b          	addiw	s2,s2,112
    1df2:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
    1df6:	f8040123          	sb	zero,-126(s0)
      for(i = 0; i < N; i++){
    1dfa:	4951                	li	s2,20
    1dfc:	a015                	j	1e20 <createdelete+0xb6>
          printf("%s: create failed\n", s);
    1dfe:	85e6                	mv	a1,s9
    1e00:	00005517          	auipc	a0,0x5
    1e04:	c8850513          	addi	a0,a0,-888 # 6a88 <malloc+0xa5c>
    1e08:	00004097          	auipc	ra,0x4
    1e0c:	166080e7          	jalr	358(ra) # 5f6e <printf>
          exit(1);
    1e10:	4505                	li	a0,1
    1e12:	00004097          	auipc	ra,0x4
    1e16:	dd4080e7          	jalr	-556(ra) # 5be6 <exit>
      for(i = 0; i < N; i++){
    1e1a:	2485                	addiw	s1,s1,1
    1e1c:	07248863          	beq	s1,s2,1e8c <createdelete+0x122>
        name[1] = '0' + i;
    1e20:	0304879b          	addiw	a5,s1,48
    1e24:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1e28:	20200593          	li	a1,514
    1e2c:	f8040513          	addi	a0,s0,-128
    1e30:	00004097          	auipc	ra,0x4
    1e34:	df6080e7          	jalr	-522(ra) # 5c26 <open>
        if(fd < 0){
    1e38:	fc0543e3          	bltz	a0,1dfe <createdelete+0x94>
        close(fd);
    1e3c:	00004097          	auipc	ra,0x4
    1e40:	dd2080e7          	jalr	-558(ra) # 5c0e <close>
        if(i > 0 && (i % 2 ) == 0){
    1e44:	fc905be3          	blez	s1,1e1a <createdelete+0xb0>
    1e48:	0014f793          	andi	a5,s1,1
    1e4c:	f7f9                	bnez	a5,1e1a <createdelete+0xb0>
          name[1] = '0' + (i / 2);
    1e4e:	01f4d79b          	srliw	a5,s1,0x1f
    1e52:	9fa5                	addw	a5,a5,s1
    1e54:	4017d79b          	sraiw	a5,a5,0x1
    1e58:	0307879b          	addiw	a5,a5,48
    1e5c:	f8f400a3          	sb	a5,-127(s0)
          if(unlink(name) < 0){
    1e60:	f8040513          	addi	a0,s0,-128
    1e64:	00004097          	auipc	ra,0x4
    1e68:	dd2080e7          	jalr	-558(ra) # 5c36 <unlink>
    1e6c:	fa0557e3          	bgez	a0,1e1a <createdelete+0xb0>
            printf("%s: unlink failed\n", s);
    1e70:	85e6                	mv	a1,s9
    1e72:	00005517          	auipc	a0,0x5
    1e76:	d6e50513          	addi	a0,a0,-658 # 6be0 <malloc+0xbb4>
    1e7a:	00004097          	auipc	ra,0x4
    1e7e:	0f4080e7          	jalr	244(ra) # 5f6e <printf>
            exit(1);
    1e82:	4505                	li	a0,1
    1e84:	00004097          	auipc	ra,0x4
    1e88:	d62080e7          	jalr	-670(ra) # 5be6 <exit>
      exit(0);
    1e8c:	4501                	li	a0,0
    1e8e:	00004097          	auipc	ra,0x4
    1e92:	d58080e7          	jalr	-680(ra) # 5be6 <exit>
      exit(1);
    1e96:	4505                	li	a0,1
    1e98:	00004097          	auipc	ra,0x4
    1e9c:	d4e080e7          	jalr	-690(ra) # 5be6 <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1ea0:	f8040613          	addi	a2,s0,-128
    1ea4:	85e6                	mv	a1,s9
    1ea6:	00005517          	auipc	a0,0x5
    1eaa:	d5250513          	addi	a0,a0,-686 # 6bf8 <malloc+0xbcc>
    1eae:	00004097          	auipc	ra,0x4
    1eb2:	0c0080e7          	jalr	192(ra) # 5f6e <printf>
        exit(1);
    1eb6:	4505                	li	a0,1
    1eb8:	00004097          	auipc	ra,0x4
    1ebc:	d2e080e7          	jalr	-722(ra) # 5be6 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1ec0:	054b7163          	bgeu	s6,s4,1f02 <createdelete+0x198>
      if(fd >= 0)
    1ec4:	02055a63          	bgez	a0,1ef8 <createdelete+0x18e>
    for(pi = 0; pi < NCHILD; pi++){
    1ec8:	2485                	addiw	s1,s1,1
    1eca:	0ff4f493          	andi	s1,s1,255
    1ece:	05548c63          	beq	s1,s5,1f26 <createdelete+0x1bc>
      name[0] = 'p' + pi;
    1ed2:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    1ed6:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
    1eda:	4581                	li	a1,0
    1edc:	f8040513          	addi	a0,s0,-128
    1ee0:	00004097          	auipc	ra,0x4
    1ee4:	d46080e7          	jalr	-698(ra) # 5c26 <open>
      if((i == 0 || i >= N/2) && fd < 0){
    1ee8:	00090463          	beqz	s2,1ef0 <createdelete+0x186>
    1eec:	fd2bdae3          	bge	s7,s2,1ec0 <createdelete+0x156>
    1ef0:	fa0548e3          	bltz	a0,1ea0 <createdelete+0x136>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1ef4:	014b7963          	bgeu	s6,s4,1f06 <createdelete+0x19c>
        close(fd);
    1ef8:	00004097          	auipc	ra,0x4
    1efc:	d16080e7          	jalr	-746(ra) # 5c0e <close>
    1f00:	b7e1                	j	1ec8 <createdelete+0x15e>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1f02:	fc0543e3          	bltz	a0,1ec8 <createdelete+0x15e>
        printf("%s: oops createdelete %s did exist\n", s, name);
    1f06:	f8040613          	addi	a2,s0,-128
    1f0a:	85e6                	mv	a1,s9
    1f0c:	00005517          	auipc	a0,0x5
    1f10:	d1450513          	addi	a0,a0,-748 # 6c20 <malloc+0xbf4>
    1f14:	00004097          	auipc	ra,0x4
    1f18:	05a080e7          	jalr	90(ra) # 5f6e <printf>
        exit(1);
    1f1c:	4505                	li	a0,1
    1f1e:	00004097          	auipc	ra,0x4
    1f22:	cc8080e7          	jalr	-824(ra) # 5be6 <exit>
  for(i = 0; i < N; i++){
    1f26:	2905                	addiw	s2,s2,1
    1f28:	2a05                	addiw	s4,s4,1
    1f2a:	2985                	addiw	s3,s3,1
    1f2c:	0ff9f993          	andi	s3,s3,255
    1f30:	47d1                	li	a5,20
    1f32:	02f90a63          	beq	s2,a5,1f66 <createdelete+0x1fc>
    for(pi = 0; pi < NCHILD; pi++){
    1f36:	84e2                	mv	s1,s8
    1f38:	bf69                	j	1ed2 <createdelete+0x168>
  for(i = 0; i < N; i++){
    1f3a:	2905                	addiw	s2,s2,1
    1f3c:	0ff97913          	andi	s2,s2,255
    1f40:	2985                	addiw	s3,s3,1
    1f42:	0ff9f993          	andi	s3,s3,255
    1f46:	03490863          	beq	s2,s4,1f76 <createdelete+0x20c>
  name[0] = name[1] = name[2] = 0;
    1f4a:	84d6                	mv	s1,s5
      name[0] = 'p' + i;
    1f4c:	f9240023          	sb	s2,-128(s0)
      name[1] = '0' + i;
    1f50:	f93400a3          	sb	s3,-127(s0)
      unlink(name);
    1f54:	f8040513          	addi	a0,s0,-128
    1f58:	00004097          	auipc	ra,0x4
    1f5c:	cde080e7          	jalr	-802(ra) # 5c36 <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    1f60:	34fd                	addiw	s1,s1,-1
    1f62:	f4ed                	bnez	s1,1f4c <createdelete+0x1e2>
    1f64:	bfd9                	j	1f3a <createdelete+0x1d0>
    1f66:	03000993          	li	s3,48
    1f6a:	07000913          	li	s2,112
  name[0] = name[1] = name[2] = 0;
    1f6e:	4a91                	li	s5,4
  for(i = 0; i < N; i++){
    1f70:	08400a13          	li	s4,132
    1f74:	bfd9                	j	1f4a <createdelete+0x1e0>
}
    1f76:	60aa                	ld	ra,136(sp)
    1f78:	640a                	ld	s0,128(sp)
    1f7a:	74e6                	ld	s1,120(sp)
    1f7c:	7946                	ld	s2,112(sp)
    1f7e:	79a6                	ld	s3,104(sp)
    1f80:	7a06                	ld	s4,96(sp)
    1f82:	6ae6                	ld	s5,88(sp)
    1f84:	6b46                	ld	s6,80(sp)
    1f86:	6ba6                	ld	s7,72(sp)
    1f88:	6c06                	ld	s8,64(sp)
    1f8a:	7ce2                	ld	s9,56(sp)
    1f8c:	6149                	addi	sp,sp,144
    1f8e:	8082                	ret

0000000000001f90 <linkunlink>:
{
    1f90:	711d                	addi	sp,sp,-96
    1f92:	ec86                	sd	ra,88(sp)
    1f94:	e8a2                	sd	s0,80(sp)
    1f96:	e4a6                	sd	s1,72(sp)
    1f98:	e0ca                	sd	s2,64(sp)
    1f9a:	fc4e                	sd	s3,56(sp)
    1f9c:	f852                	sd	s4,48(sp)
    1f9e:	f456                	sd	s5,40(sp)
    1fa0:	f05a                	sd	s6,32(sp)
    1fa2:	ec5e                	sd	s7,24(sp)
    1fa4:	e862                	sd	s8,16(sp)
    1fa6:	e466                	sd	s9,8(sp)
    1fa8:	1080                	addi	s0,sp,96
    1faa:	84aa                	mv	s1,a0
  unlink("x");
    1fac:	00004517          	auipc	a0,0x4
    1fb0:	22c50513          	addi	a0,a0,556 # 61d8 <malloc+0x1ac>
    1fb4:	00004097          	auipc	ra,0x4
    1fb8:	c82080e7          	jalr	-894(ra) # 5c36 <unlink>
  pid = fork();
    1fbc:	00004097          	auipc	ra,0x4
    1fc0:	c22080e7          	jalr	-990(ra) # 5bde <fork>
  if(pid < 0){
    1fc4:	02054b63          	bltz	a0,1ffa <linkunlink+0x6a>
    1fc8:	8c2a                	mv	s8,a0
  unsigned int x = (pid ? 1 : 97);
    1fca:	4c85                	li	s9,1
    1fcc:	e119                	bnez	a0,1fd2 <linkunlink+0x42>
    1fce:	06100c93          	li	s9,97
    1fd2:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    1fd6:	41c659b7          	lui	s3,0x41c65
    1fda:	e6d9899b          	addiw	s3,s3,-403
    1fde:	690d                	lui	s2,0x3
    1fe0:	0399091b          	addiw	s2,s2,57
    if((x % 3) == 0){
    1fe4:	4a0d                	li	s4,3
    } else if((x % 3) == 1){
    1fe6:	4b05                	li	s6,1
      unlink("x");
    1fe8:	00004a97          	auipc	s5,0x4
    1fec:	1f0a8a93          	addi	s5,s5,496 # 61d8 <malloc+0x1ac>
      link("cat", "x");
    1ff0:	00005b97          	auipc	s7,0x5
    1ff4:	c58b8b93          	addi	s7,s7,-936 # 6c48 <malloc+0xc1c>
    1ff8:	a091                	j	203c <linkunlink+0xac>
    printf("%s: fork failed\n", s);
    1ffa:	85a6                	mv	a1,s1
    1ffc:	00005517          	auipc	a0,0x5
    2000:	9f450513          	addi	a0,a0,-1548 # 69f0 <malloc+0x9c4>
    2004:	00004097          	auipc	ra,0x4
    2008:	f6a080e7          	jalr	-150(ra) # 5f6e <printf>
    exit(1);
    200c:	4505                	li	a0,1
    200e:	00004097          	auipc	ra,0x4
    2012:	bd8080e7          	jalr	-1064(ra) # 5be6 <exit>
      close(open("x", O_RDWR | O_CREATE));
    2016:	20200593          	li	a1,514
    201a:	8556                	mv	a0,s5
    201c:	00004097          	auipc	ra,0x4
    2020:	c0a080e7          	jalr	-1014(ra) # 5c26 <open>
    2024:	00004097          	auipc	ra,0x4
    2028:	bea080e7          	jalr	-1046(ra) # 5c0e <close>
    202c:	a031                	j	2038 <linkunlink+0xa8>
      unlink("x");
    202e:	8556                	mv	a0,s5
    2030:	00004097          	auipc	ra,0x4
    2034:	c06080e7          	jalr	-1018(ra) # 5c36 <unlink>
  for(i = 0; i < 100; i++){
    2038:	34fd                	addiw	s1,s1,-1
    203a:	c09d                	beqz	s1,2060 <linkunlink+0xd0>
    x = x * 1103515245 + 12345;
    203c:	033c87bb          	mulw	a5,s9,s3
    2040:	012787bb          	addw	a5,a5,s2
    2044:	00078c9b          	sext.w	s9,a5
    if((x % 3) == 0){
    2048:	0347f7bb          	remuw	a5,a5,s4
    204c:	d7e9                	beqz	a5,2016 <linkunlink+0x86>
    } else if((x % 3) == 1){
    204e:	ff6790e3          	bne	a5,s6,202e <linkunlink+0x9e>
      link("cat", "x");
    2052:	85d6                	mv	a1,s5
    2054:	855e                	mv	a0,s7
    2056:	00004097          	auipc	ra,0x4
    205a:	bf0080e7          	jalr	-1040(ra) # 5c46 <link>
    205e:	bfe9                	j	2038 <linkunlink+0xa8>
  if(pid)
    2060:	020c0463          	beqz	s8,2088 <linkunlink+0xf8>
    wait(0);
    2064:	4501                	li	a0,0
    2066:	00004097          	auipc	ra,0x4
    206a:	b88080e7          	jalr	-1144(ra) # 5bee <wait>
}
    206e:	60e6                	ld	ra,88(sp)
    2070:	6446                	ld	s0,80(sp)
    2072:	64a6                	ld	s1,72(sp)
    2074:	6906                	ld	s2,64(sp)
    2076:	79e2                	ld	s3,56(sp)
    2078:	7a42                	ld	s4,48(sp)
    207a:	7aa2                	ld	s5,40(sp)
    207c:	7b02                	ld	s6,32(sp)
    207e:	6be2                	ld	s7,24(sp)
    2080:	6c42                	ld	s8,16(sp)
    2082:	6ca2                	ld	s9,8(sp)
    2084:	6125                	addi	sp,sp,96
    2086:	8082                	ret
    exit(0);
    2088:	4501                	li	a0,0
    208a:	00004097          	auipc	ra,0x4
    208e:	b5c080e7          	jalr	-1188(ra) # 5be6 <exit>

0000000000002092 <forktest>:
{
    2092:	7179                	addi	sp,sp,-48
    2094:	f406                	sd	ra,40(sp)
    2096:	f022                	sd	s0,32(sp)
    2098:	ec26                	sd	s1,24(sp)
    209a:	e84a                	sd	s2,16(sp)
    209c:	e44e                	sd	s3,8(sp)
    209e:	1800                	addi	s0,sp,48
    20a0:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
    20a2:	4481                	li	s1,0
    20a4:	3e800913          	li	s2,1000
    pid = fork();
    20a8:	00004097          	auipc	ra,0x4
    20ac:	b36080e7          	jalr	-1226(ra) # 5bde <fork>
    if(pid < 0)
    20b0:	02054863          	bltz	a0,20e0 <forktest+0x4e>
    if(pid == 0)
    20b4:	c115                	beqz	a0,20d8 <forktest+0x46>
  for(n=0; n<N; n++){
    20b6:	2485                	addiw	s1,s1,1
    20b8:	ff2498e3          	bne	s1,s2,20a8 <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    20bc:	85ce                	mv	a1,s3
    20be:	00005517          	auipc	a0,0x5
    20c2:	baa50513          	addi	a0,a0,-1110 # 6c68 <malloc+0xc3c>
    20c6:	00004097          	auipc	ra,0x4
    20ca:	ea8080e7          	jalr	-344(ra) # 5f6e <printf>
    exit(1);
    20ce:	4505                	li	a0,1
    20d0:	00004097          	auipc	ra,0x4
    20d4:	b16080e7          	jalr	-1258(ra) # 5be6 <exit>
      exit(0);
    20d8:	00004097          	auipc	ra,0x4
    20dc:	b0e080e7          	jalr	-1266(ra) # 5be6 <exit>
  if (n == 0) {
    20e0:	cc9d                	beqz	s1,211e <forktest+0x8c>
  if(n == N){
    20e2:	3e800793          	li	a5,1000
    20e6:	fcf48be3          	beq	s1,a5,20bc <forktest+0x2a>
  for(; n > 0; n--){
    20ea:	00905b63          	blez	s1,2100 <forktest+0x6e>
    if(wait(0) < 0){
    20ee:	4501                	li	a0,0
    20f0:	00004097          	auipc	ra,0x4
    20f4:	afe080e7          	jalr	-1282(ra) # 5bee <wait>
    20f8:	04054163          	bltz	a0,213a <forktest+0xa8>
  for(; n > 0; n--){
    20fc:	34fd                	addiw	s1,s1,-1
    20fe:	f8e5                	bnez	s1,20ee <forktest+0x5c>
  if(wait(0) != -1){
    2100:	4501                	li	a0,0
    2102:	00004097          	auipc	ra,0x4
    2106:	aec080e7          	jalr	-1300(ra) # 5bee <wait>
    210a:	57fd                	li	a5,-1
    210c:	04f51563          	bne	a0,a5,2156 <forktest+0xc4>
}
    2110:	70a2                	ld	ra,40(sp)
    2112:	7402                	ld	s0,32(sp)
    2114:	64e2                	ld	s1,24(sp)
    2116:	6942                	ld	s2,16(sp)
    2118:	69a2                	ld	s3,8(sp)
    211a:	6145                	addi	sp,sp,48
    211c:	8082                	ret
    printf("%s: no fork at all!\n", s);
    211e:	85ce                	mv	a1,s3
    2120:	00005517          	auipc	a0,0x5
    2124:	b3050513          	addi	a0,a0,-1232 # 6c50 <malloc+0xc24>
    2128:	00004097          	auipc	ra,0x4
    212c:	e46080e7          	jalr	-442(ra) # 5f6e <printf>
    exit(1);
    2130:	4505                	li	a0,1
    2132:	00004097          	auipc	ra,0x4
    2136:	ab4080e7          	jalr	-1356(ra) # 5be6 <exit>
      printf("%s: wait stopped early\n", s);
    213a:	85ce                	mv	a1,s3
    213c:	00005517          	auipc	a0,0x5
    2140:	b5450513          	addi	a0,a0,-1196 # 6c90 <malloc+0xc64>
    2144:	00004097          	auipc	ra,0x4
    2148:	e2a080e7          	jalr	-470(ra) # 5f6e <printf>
      exit(1);
    214c:	4505                	li	a0,1
    214e:	00004097          	auipc	ra,0x4
    2152:	a98080e7          	jalr	-1384(ra) # 5be6 <exit>
    printf("%s: wait got too many\n", s);
    2156:	85ce                	mv	a1,s3
    2158:	00005517          	auipc	a0,0x5
    215c:	b5050513          	addi	a0,a0,-1200 # 6ca8 <malloc+0xc7c>
    2160:	00004097          	auipc	ra,0x4
    2164:	e0e080e7          	jalr	-498(ra) # 5f6e <printf>
    exit(1);
    2168:	4505                	li	a0,1
    216a:	00004097          	auipc	ra,0x4
    216e:	a7c080e7          	jalr	-1412(ra) # 5be6 <exit>

0000000000002172 <kernmem>:
{
    2172:	715d                	addi	sp,sp,-80
    2174:	e486                	sd	ra,72(sp)
    2176:	e0a2                	sd	s0,64(sp)
    2178:	fc26                	sd	s1,56(sp)
    217a:	f84a                	sd	s2,48(sp)
    217c:	f44e                	sd	s3,40(sp)
    217e:	f052                	sd	s4,32(sp)
    2180:	ec56                	sd	s5,24(sp)
    2182:	0880                	addi	s0,sp,80
    2184:	8a2a                	mv	s4,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    2186:	4485                	li	s1,1
    2188:	04fe                	slli	s1,s1,0x1f
    if(xstatus != -1)  // did kernel kill child?
    218a:	5afd                	li	s5,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    218c:	69b1                	lui	s3,0xc
    218e:	35098993          	addi	s3,s3,848 # c350 <uninit+0x1de8>
    2192:	1003d937          	lui	s2,0x1003d
    2196:	090e                	slli	s2,s2,0x3
    2198:	48090913          	addi	s2,s2,1152 # 1003d480 <base+0x1002d808>
    pid = fork();
    219c:	00004097          	auipc	ra,0x4
    21a0:	a42080e7          	jalr	-1470(ra) # 5bde <fork>
    if(pid < 0){
    21a4:	02054963          	bltz	a0,21d6 <kernmem+0x64>
    if(pid == 0){
    21a8:	c529                	beqz	a0,21f2 <kernmem+0x80>
    wait(&xstatus);
    21aa:	fbc40513          	addi	a0,s0,-68
    21ae:	00004097          	auipc	ra,0x4
    21b2:	a40080e7          	jalr	-1472(ra) # 5bee <wait>
    if(xstatus != -1)  // did kernel kill child?
    21b6:	fbc42783          	lw	a5,-68(s0)
    21ba:	05579d63          	bne	a5,s5,2214 <kernmem+0xa2>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    21be:	94ce                	add	s1,s1,s3
    21c0:	fd249ee3          	bne	s1,s2,219c <kernmem+0x2a>
}
    21c4:	60a6                	ld	ra,72(sp)
    21c6:	6406                	ld	s0,64(sp)
    21c8:	74e2                	ld	s1,56(sp)
    21ca:	7942                	ld	s2,48(sp)
    21cc:	79a2                	ld	s3,40(sp)
    21ce:	7a02                	ld	s4,32(sp)
    21d0:	6ae2                	ld	s5,24(sp)
    21d2:	6161                	addi	sp,sp,80
    21d4:	8082                	ret
      printf("%s: fork failed\n", s);
    21d6:	85d2                	mv	a1,s4
    21d8:	00005517          	auipc	a0,0x5
    21dc:	81850513          	addi	a0,a0,-2024 # 69f0 <malloc+0x9c4>
    21e0:	00004097          	auipc	ra,0x4
    21e4:	d8e080e7          	jalr	-626(ra) # 5f6e <printf>
      exit(1);
    21e8:	4505                	li	a0,1
    21ea:	00004097          	auipc	ra,0x4
    21ee:	9fc080e7          	jalr	-1540(ra) # 5be6 <exit>
      printf("%s: oops could read %x = %x\n", s, a, *a);
    21f2:	0004c683          	lbu	a3,0(s1)
    21f6:	8626                	mv	a2,s1
    21f8:	85d2                	mv	a1,s4
    21fa:	00005517          	auipc	a0,0x5
    21fe:	ac650513          	addi	a0,a0,-1338 # 6cc0 <malloc+0xc94>
    2202:	00004097          	auipc	ra,0x4
    2206:	d6c080e7          	jalr	-660(ra) # 5f6e <printf>
      exit(1);
    220a:	4505                	li	a0,1
    220c:	00004097          	auipc	ra,0x4
    2210:	9da080e7          	jalr	-1574(ra) # 5be6 <exit>
      exit(1);
    2214:	4505                	li	a0,1
    2216:	00004097          	auipc	ra,0x4
    221a:	9d0080e7          	jalr	-1584(ra) # 5be6 <exit>

000000000000221e <MAXVAplus>:
{
    221e:	7179                	addi	sp,sp,-48
    2220:	f406                	sd	ra,40(sp)
    2222:	f022                	sd	s0,32(sp)
    2224:	ec26                	sd	s1,24(sp)
    2226:	e84a                	sd	s2,16(sp)
    2228:	1800                	addi	s0,sp,48
  volatile uint64 a = MAXVA;
    222a:	4785                	li	a5,1
    222c:	179a                	slli	a5,a5,0x26
    222e:	fcf43c23          	sd	a5,-40(s0)
  for( ; a != 0; a <<= 1){
    2232:	fd843783          	ld	a5,-40(s0)
    2236:	cf85                	beqz	a5,226e <MAXVAplus+0x50>
    2238:	892a                	mv	s2,a0
    if(xstatus != -1)  // did kernel kill child?
    223a:	54fd                	li	s1,-1
    pid = fork();
    223c:	00004097          	auipc	ra,0x4
    2240:	9a2080e7          	jalr	-1630(ra) # 5bde <fork>
    if(pid < 0){
    2244:	02054b63          	bltz	a0,227a <MAXVAplus+0x5c>
    if(pid == 0){
    2248:	c539                	beqz	a0,2296 <MAXVAplus+0x78>
    wait(&xstatus);
    224a:	fd440513          	addi	a0,s0,-44
    224e:	00004097          	auipc	ra,0x4
    2252:	9a0080e7          	jalr	-1632(ra) # 5bee <wait>
    if(xstatus != -1)  // did kernel kill child?
    2256:	fd442783          	lw	a5,-44(s0)
    225a:	06979463          	bne	a5,s1,22c2 <MAXVAplus+0xa4>
  for( ; a != 0; a <<= 1){
    225e:	fd843783          	ld	a5,-40(s0)
    2262:	0786                	slli	a5,a5,0x1
    2264:	fcf43c23          	sd	a5,-40(s0)
    2268:	fd843783          	ld	a5,-40(s0)
    226c:	fbe1                	bnez	a5,223c <MAXVAplus+0x1e>
}
    226e:	70a2                	ld	ra,40(sp)
    2270:	7402                	ld	s0,32(sp)
    2272:	64e2                	ld	s1,24(sp)
    2274:	6942                	ld	s2,16(sp)
    2276:	6145                	addi	sp,sp,48
    2278:	8082                	ret
      printf("%s: fork failed\n", s);
    227a:	85ca                	mv	a1,s2
    227c:	00004517          	auipc	a0,0x4
    2280:	77450513          	addi	a0,a0,1908 # 69f0 <malloc+0x9c4>
    2284:	00004097          	auipc	ra,0x4
    2288:	cea080e7          	jalr	-790(ra) # 5f6e <printf>
      exit(1);
    228c:	4505                	li	a0,1
    228e:	00004097          	auipc	ra,0x4
    2292:	958080e7          	jalr	-1704(ra) # 5be6 <exit>
      *(char*)a = 99;
    2296:	fd843783          	ld	a5,-40(s0)
    229a:	06300713          	li	a4,99
    229e:	00e78023          	sb	a4,0(a5)
      printf("%s: oops wrote %x\n", s, a);
    22a2:	fd843603          	ld	a2,-40(s0)
    22a6:	85ca                	mv	a1,s2
    22a8:	00005517          	auipc	a0,0x5
    22ac:	a3850513          	addi	a0,a0,-1480 # 6ce0 <malloc+0xcb4>
    22b0:	00004097          	auipc	ra,0x4
    22b4:	cbe080e7          	jalr	-834(ra) # 5f6e <printf>
      exit(1);
    22b8:	4505                	li	a0,1
    22ba:	00004097          	auipc	ra,0x4
    22be:	92c080e7          	jalr	-1748(ra) # 5be6 <exit>
      exit(1);
    22c2:	4505                	li	a0,1
    22c4:	00004097          	auipc	ra,0x4
    22c8:	922080e7          	jalr	-1758(ra) # 5be6 <exit>

00000000000022cc <bigargtest>:
{
    22cc:	7179                	addi	sp,sp,-48
    22ce:	f406                	sd	ra,40(sp)
    22d0:	f022                	sd	s0,32(sp)
    22d2:	ec26                	sd	s1,24(sp)
    22d4:	1800                	addi	s0,sp,48
    22d6:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    22d8:	00005517          	auipc	a0,0x5
    22dc:	a2050513          	addi	a0,a0,-1504 # 6cf8 <malloc+0xccc>
    22e0:	00004097          	auipc	ra,0x4
    22e4:	956080e7          	jalr	-1706(ra) # 5c36 <unlink>
  pid = fork();
    22e8:	00004097          	auipc	ra,0x4
    22ec:	8f6080e7          	jalr	-1802(ra) # 5bde <fork>
  if(pid == 0){
    22f0:	c121                	beqz	a0,2330 <bigargtest+0x64>
  } else if(pid < 0){
    22f2:	0a054063          	bltz	a0,2392 <bigargtest+0xc6>
  wait(&xstatus);
    22f6:	fdc40513          	addi	a0,s0,-36
    22fa:	00004097          	auipc	ra,0x4
    22fe:	8f4080e7          	jalr	-1804(ra) # 5bee <wait>
  if(xstatus != 0)
    2302:	fdc42503          	lw	a0,-36(s0)
    2306:	e545                	bnez	a0,23ae <bigargtest+0xe2>
  fd = open("bigarg-ok", 0);
    2308:	4581                	li	a1,0
    230a:	00005517          	auipc	a0,0x5
    230e:	9ee50513          	addi	a0,a0,-1554 # 6cf8 <malloc+0xccc>
    2312:	00004097          	auipc	ra,0x4
    2316:	914080e7          	jalr	-1772(ra) # 5c26 <open>
  if(fd < 0){
    231a:	08054e63          	bltz	a0,23b6 <bigargtest+0xea>
  close(fd);
    231e:	00004097          	auipc	ra,0x4
    2322:	8f0080e7          	jalr	-1808(ra) # 5c0e <close>
}
    2326:	70a2                	ld	ra,40(sp)
    2328:	7402                	ld	s0,32(sp)
    232a:	64e2                	ld	s1,24(sp)
    232c:	6145                	addi	sp,sp,48
    232e:	8082                	ret
    2330:	00007797          	auipc	a5,0x7
    2334:	13078793          	addi	a5,a5,304 # 9460 <args.1825>
    2338:	00007697          	auipc	a3,0x7
    233c:	22068693          	addi	a3,a3,544 # 9558 <args.1825+0xf8>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    2340:	00005717          	auipc	a4,0x5
    2344:	9c870713          	addi	a4,a4,-1592 # 6d08 <malloc+0xcdc>
    2348:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    234a:	07a1                	addi	a5,a5,8
    234c:	fed79ee3          	bne	a5,a3,2348 <bigargtest+0x7c>
    args[MAXARG-1] = 0;
    2350:	00007597          	auipc	a1,0x7
    2354:	11058593          	addi	a1,a1,272 # 9460 <args.1825>
    2358:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    235c:	00004517          	auipc	a0,0x4
    2360:	e0c50513          	addi	a0,a0,-500 # 6168 <malloc+0x13c>
    2364:	00004097          	auipc	ra,0x4
    2368:	8ba080e7          	jalr	-1862(ra) # 5c1e <exec>
    fd = open("bigarg-ok", O_CREATE);
    236c:	20000593          	li	a1,512
    2370:	00005517          	auipc	a0,0x5
    2374:	98850513          	addi	a0,a0,-1656 # 6cf8 <malloc+0xccc>
    2378:	00004097          	auipc	ra,0x4
    237c:	8ae080e7          	jalr	-1874(ra) # 5c26 <open>
    close(fd);
    2380:	00004097          	auipc	ra,0x4
    2384:	88e080e7          	jalr	-1906(ra) # 5c0e <close>
    exit(0);
    2388:	4501                	li	a0,0
    238a:	00004097          	auipc	ra,0x4
    238e:	85c080e7          	jalr	-1956(ra) # 5be6 <exit>
    printf("%s: bigargtest: fork failed\n", s);
    2392:	85a6                	mv	a1,s1
    2394:	00005517          	auipc	a0,0x5
    2398:	a5450513          	addi	a0,a0,-1452 # 6de8 <malloc+0xdbc>
    239c:	00004097          	auipc	ra,0x4
    23a0:	bd2080e7          	jalr	-1070(ra) # 5f6e <printf>
    exit(1);
    23a4:	4505                	li	a0,1
    23a6:	00004097          	auipc	ra,0x4
    23aa:	840080e7          	jalr	-1984(ra) # 5be6 <exit>
    exit(xstatus);
    23ae:	00004097          	auipc	ra,0x4
    23b2:	838080e7          	jalr	-1992(ra) # 5be6 <exit>
    printf("%s: bigarg test failed!\n", s);
    23b6:	85a6                	mv	a1,s1
    23b8:	00005517          	auipc	a0,0x5
    23bc:	a5050513          	addi	a0,a0,-1456 # 6e08 <malloc+0xddc>
    23c0:	00004097          	auipc	ra,0x4
    23c4:	bae080e7          	jalr	-1106(ra) # 5f6e <printf>
    exit(1);
    23c8:	4505                	li	a0,1
    23ca:	00004097          	auipc	ra,0x4
    23ce:	81c080e7          	jalr	-2020(ra) # 5be6 <exit>

00000000000023d2 <stacktest>:
{
    23d2:	7179                	addi	sp,sp,-48
    23d4:	f406                	sd	ra,40(sp)
    23d6:	f022                	sd	s0,32(sp)
    23d8:	ec26                	sd	s1,24(sp)
    23da:	1800                	addi	s0,sp,48
    23dc:	84aa                	mv	s1,a0
  pid = fork();
    23de:	00004097          	auipc	ra,0x4
    23e2:	800080e7          	jalr	-2048(ra) # 5bde <fork>
  if(pid == 0) {
    23e6:	c115                	beqz	a0,240a <stacktest+0x38>
  } else if(pid < 0){
    23e8:	04054463          	bltz	a0,2430 <stacktest+0x5e>
  wait(&xstatus);
    23ec:	fdc40513          	addi	a0,s0,-36
    23f0:	00003097          	auipc	ra,0x3
    23f4:	7fe080e7          	jalr	2046(ra) # 5bee <wait>
  if(xstatus == -1)  // kernel killed child?
    23f8:	fdc42503          	lw	a0,-36(s0)
    23fc:	57fd                	li	a5,-1
    23fe:	04f50763          	beq	a0,a5,244c <stacktest+0x7a>
    exit(xstatus);
    2402:	00003097          	auipc	ra,0x3
    2406:	7e4080e7          	jalr	2020(ra) # 5be6 <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    240a:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %p\n", s, *sp);
    240c:	77fd                	lui	a5,0xfffff
    240e:	97ba                	add	a5,a5,a4
    2410:	0007c603          	lbu	a2,0(a5) # fffffffffffff000 <base+0xfffffffffffef388>
    2414:	85a6                	mv	a1,s1
    2416:	00005517          	auipc	a0,0x5
    241a:	a1250513          	addi	a0,a0,-1518 # 6e28 <malloc+0xdfc>
    241e:	00004097          	auipc	ra,0x4
    2422:	b50080e7          	jalr	-1200(ra) # 5f6e <printf>
    exit(1);
    2426:	4505                	li	a0,1
    2428:	00003097          	auipc	ra,0x3
    242c:	7be080e7          	jalr	1982(ra) # 5be6 <exit>
    printf("%s: fork failed\n", s);
    2430:	85a6                	mv	a1,s1
    2432:	00004517          	auipc	a0,0x4
    2436:	5be50513          	addi	a0,a0,1470 # 69f0 <malloc+0x9c4>
    243a:	00004097          	auipc	ra,0x4
    243e:	b34080e7          	jalr	-1228(ra) # 5f6e <printf>
    exit(1);
    2442:	4505                	li	a0,1
    2444:	00003097          	auipc	ra,0x3
    2448:	7a2080e7          	jalr	1954(ra) # 5be6 <exit>
    exit(0);
    244c:	4501                	li	a0,0
    244e:	00003097          	auipc	ra,0x3
    2452:	798080e7          	jalr	1944(ra) # 5be6 <exit>

0000000000002456 <textwrite>:
{
    2456:	7179                	addi	sp,sp,-48
    2458:	f406                	sd	ra,40(sp)
    245a:	f022                	sd	s0,32(sp)
    245c:	ec26                	sd	s1,24(sp)
    245e:	1800                	addi	s0,sp,48
    2460:	84aa                	mv	s1,a0
  pid = fork();
    2462:	00003097          	auipc	ra,0x3
    2466:	77c080e7          	jalr	1916(ra) # 5bde <fork>
  if(pid == 0) {
    246a:	c115                	beqz	a0,248e <textwrite+0x38>
  } else if(pid < 0){
    246c:	02054963          	bltz	a0,249e <textwrite+0x48>
  wait(&xstatus);
    2470:	fdc40513          	addi	a0,s0,-36
    2474:	00003097          	auipc	ra,0x3
    2478:	77a080e7          	jalr	1914(ra) # 5bee <wait>
  if(xstatus == -1)  // kernel killed child?
    247c:	fdc42503          	lw	a0,-36(s0)
    2480:	57fd                	li	a5,-1
    2482:	02f50c63          	beq	a0,a5,24ba <textwrite+0x64>
    exit(xstatus);
    2486:	00003097          	auipc	ra,0x3
    248a:	760080e7          	jalr	1888(ra) # 5be6 <exit>
    *addr = 10;
    248e:	47a9                	li	a5,10
    2490:	00f02023          	sw	a5,0(zero) # 0 <copyinstr1>
    exit(1);
    2494:	4505                	li	a0,1
    2496:	00003097          	auipc	ra,0x3
    249a:	750080e7          	jalr	1872(ra) # 5be6 <exit>
    printf("%s: fork failed\n", s);
    249e:	85a6                	mv	a1,s1
    24a0:	00004517          	auipc	a0,0x4
    24a4:	55050513          	addi	a0,a0,1360 # 69f0 <malloc+0x9c4>
    24a8:	00004097          	auipc	ra,0x4
    24ac:	ac6080e7          	jalr	-1338(ra) # 5f6e <printf>
    exit(1);
    24b0:	4505                	li	a0,1
    24b2:	00003097          	auipc	ra,0x3
    24b6:	734080e7          	jalr	1844(ra) # 5be6 <exit>
    exit(0);
    24ba:	4501                	li	a0,0
    24bc:	00003097          	auipc	ra,0x3
    24c0:	72a080e7          	jalr	1834(ra) # 5be6 <exit>

00000000000024c4 <manywrites>:
{
    24c4:	711d                	addi	sp,sp,-96
    24c6:	ec86                	sd	ra,88(sp)
    24c8:	e8a2                	sd	s0,80(sp)
    24ca:	e4a6                	sd	s1,72(sp)
    24cc:	e0ca                	sd	s2,64(sp)
    24ce:	fc4e                	sd	s3,56(sp)
    24d0:	f852                	sd	s4,48(sp)
    24d2:	f456                	sd	s5,40(sp)
    24d4:	f05a                	sd	s6,32(sp)
    24d6:	ec5e                	sd	s7,24(sp)
    24d8:	1080                	addi	s0,sp,96
    24da:	8aaa                	mv	s5,a0
  for(int ci = 0; ci < nchildren; ci++){
    24dc:	4901                	li	s2,0
    24de:	4991                	li	s3,4
    int pid = fork();
    24e0:	00003097          	auipc	ra,0x3
    24e4:	6fe080e7          	jalr	1790(ra) # 5bde <fork>
    24e8:	84aa                	mv	s1,a0
    if(pid < 0){
    24ea:	02054963          	bltz	a0,251c <manywrites+0x58>
    if(pid == 0){
    24ee:	c521                	beqz	a0,2536 <manywrites+0x72>
  for(int ci = 0; ci < nchildren; ci++){
    24f0:	2905                	addiw	s2,s2,1
    24f2:	ff3917e3          	bne	s2,s3,24e0 <manywrites+0x1c>
    24f6:	4491                	li	s1,4
    int st = 0;
    24f8:	fa042423          	sw	zero,-88(s0)
    wait(&st);
    24fc:	fa840513          	addi	a0,s0,-88
    2500:	00003097          	auipc	ra,0x3
    2504:	6ee080e7          	jalr	1774(ra) # 5bee <wait>
    if(st != 0)
    2508:	fa842503          	lw	a0,-88(s0)
    250c:	ed6d                	bnez	a0,2606 <manywrites+0x142>
  for(int ci = 0; ci < nchildren; ci++){
    250e:	34fd                	addiw	s1,s1,-1
    2510:	f4e5                	bnez	s1,24f8 <manywrites+0x34>
  exit(0);
    2512:	4501                	li	a0,0
    2514:	00003097          	auipc	ra,0x3
    2518:	6d2080e7          	jalr	1746(ra) # 5be6 <exit>
      printf("fork failed\n");
    251c:	00005517          	auipc	a0,0x5
    2520:	8dc50513          	addi	a0,a0,-1828 # 6df8 <malloc+0xdcc>
    2524:	00004097          	auipc	ra,0x4
    2528:	a4a080e7          	jalr	-1462(ra) # 5f6e <printf>
      exit(1);
    252c:	4505                	li	a0,1
    252e:	00003097          	auipc	ra,0x3
    2532:	6b8080e7          	jalr	1720(ra) # 5be6 <exit>
      name[0] = 'b';
    2536:	06200793          	li	a5,98
    253a:	faf40423          	sb	a5,-88(s0)
      name[1] = 'a' + ci;
    253e:	0619079b          	addiw	a5,s2,97
    2542:	faf404a3          	sb	a5,-87(s0)
      name[2] = '\0';
    2546:	fa040523          	sb	zero,-86(s0)
      unlink(name);
    254a:	fa840513          	addi	a0,s0,-88
    254e:	00003097          	auipc	ra,0x3
    2552:	6e8080e7          	jalr	1768(ra) # 5c36 <unlink>
    2556:	4b79                	li	s6,30
          int cc = write(fd, buf, sz);
    2558:	0000ab97          	auipc	s7,0xa
    255c:	720b8b93          	addi	s7,s7,1824 # cc78 <buf>
        for(int i = 0; i < ci+1; i++){
    2560:	8a26                	mv	s4,s1
    2562:	02094e63          	bltz	s2,259e <manywrites+0xda>
          int fd = open(name, O_CREATE | O_RDWR);
    2566:	20200593          	li	a1,514
    256a:	fa840513          	addi	a0,s0,-88
    256e:	00003097          	auipc	ra,0x3
    2572:	6b8080e7          	jalr	1720(ra) # 5c26 <open>
    2576:	89aa                	mv	s3,a0
          if(fd < 0){
    2578:	04054763          	bltz	a0,25c6 <manywrites+0x102>
          int cc = write(fd, buf, sz);
    257c:	660d                	lui	a2,0x3
    257e:	85de                	mv	a1,s7
    2580:	00003097          	auipc	ra,0x3
    2584:	686080e7          	jalr	1670(ra) # 5c06 <write>
          if(cc != sz){
    2588:	678d                	lui	a5,0x3
    258a:	04f51e63          	bne	a0,a5,25e6 <manywrites+0x122>
          close(fd);
    258e:	854e                	mv	a0,s3
    2590:	00003097          	auipc	ra,0x3
    2594:	67e080e7          	jalr	1662(ra) # 5c0e <close>
        for(int i = 0; i < ci+1; i++){
    2598:	2a05                	addiw	s4,s4,1
    259a:	fd4956e3          	bge	s2,s4,2566 <manywrites+0xa2>
        unlink(name);
    259e:	fa840513          	addi	a0,s0,-88
    25a2:	00003097          	auipc	ra,0x3
    25a6:	694080e7          	jalr	1684(ra) # 5c36 <unlink>
      for(int iters = 0; iters < howmany; iters++){
    25aa:	3b7d                	addiw	s6,s6,-1
    25ac:	fa0b1ae3          	bnez	s6,2560 <manywrites+0x9c>
      unlink(name);
    25b0:	fa840513          	addi	a0,s0,-88
    25b4:	00003097          	auipc	ra,0x3
    25b8:	682080e7          	jalr	1666(ra) # 5c36 <unlink>
      exit(0);
    25bc:	4501                	li	a0,0
    25be:	00003097          	auipc	ra,0x3
    25c2:	628080e7          	jalr	1576(ra) # 5be6 <exit>
            printf("%s: cannot create %s\n", s, name);
    25c6:	fa840613          	addi	a2,s0,-88
    25ca:	85d6                	mv	a1,s5
    25cc:	00005517          	auipc	a0,0x5
    25d0:	88450513          	addi	a0,a0,-1916 # 6e50 <malloc+0xe24>
    25d4:	00004097          	auipc	ra,0x4
    25d8:	99a080e7          	jalr	-1638(ra) # 5f6e <printf>
            exit(1);
    25dc:	4505                	li	a0,1
    25de:	00003097          	auipc	ra,0x3
    25e2:	608080e7          	jalr	1544(ra) # 5be6 <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    25e6:	86aa                	mv	a3,a0
    25e8:	660d                	lui	a2,0x3
    25ea:	85d6                	mv	a1,s5
    25ec:	00004517          	auipc	a0,0x4
    25f0:	c4c50513          	addi	a0,a0,-948 # 6238 <malloc+0x20c>
    25f4:	00004097          	auipc	ra,0x4
    25f8:	97a080e7          	jalr	-1670(ra) # 5f6e <printf>
            exit(1);
    25fc:	4505                	li	a0,1
    25fe:	00003097          	auipc	ra,0x3
    2602:	5e8080e7          	jalr	1512(ra) # 5be6 <exit>
      exit(st);
    2606:	00003097          	auipc	ra,0x3
    260a:	5e0080e7          	jalr	1504(ra) # 5be6 <exit>

000000000000260e <copyinstr3>:
{
    260e:	7179                	addi	sp,sp,-48
    2610:	f406                	sd	ra,40(sp)
    2612:	f022                	sd	s0,32(sp)
    2614:	ec26                	sd	s1,24(sp)
    2616:	1800                	addi	s0,sp,48
  sbrk(8192);
    2618:	6509                	lui	a0,0x2
    261a:	00003097          	auipc	ra,0x3
    261e:	654080e7          	jalr	1620(ra) # 5c6e <sbrk>
  uint64 top = (uint64) sbrk(0);
    2622:	4501                	li	a0,0
    2624:	00003097          	auipc	ra,0x3
    2628:	64a080e7          	jalr	1610(ra) # 5c6e <sbrk>
  if((top % PGSIZE) != 0){
    262c:	03451793          	slli	a5,a0,0x34
    2630:	e3c9                	bnez	a5,26b2 <copyinstr3+0xa4>
  top = (uint64) sbrk(0);
    2632:	4501                	li	a0,0
    2634:	00003097          	auipc	ra,0x3
    2638:	63a080e7          	jalr	1594(ra) # 5c6e <sbrk>
  if(top % PGSIZE){
    263c:	03451793          	slli	a5,a0,0x34
    2640:	e3d9                	bnez	a5,26c6 <copyinstr3+0xb8>
  char *b = (char *) (top - 1);
    2642:	fff50493          	addi	s1,a0,-1 # 1fff <linkunlink+0x6f>
  *b = 'x';
    2646:	07800793          	li	a5,120
    264a:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    264e:	8526                	mv	a0,s1
    2650:	00003097          	auipc	ra,0x3
    2654:	5e6080e7          	jalr	1510(ra) # 5c36 <unlink>
  if(ret != -1){
    2658:	57fd                	li	a5,-1
    265a:	08f51363          	bne	a0,a5,26e0 <copyinstr3+0xd2>
  int fd = open(b, O_CREATE | O_WRONLY);
    265e:	20100593          	li	a1,513
    2662:	8526                	mv	a0,s1
    2664:	00003097          	auipc	ra,0x3
    2668:	5c2080e7          	jalr	1474(ra) # 5c26 <open>
  if(fd != -1){
    266c:	57fd                	li	a5,-1
    266e:	08f51863          	bne	a0,a5,26fe <copyinstr3+0xf0>
  ret = link(b, b);
    2672:	85a6                	mv	a1,s1
    2674:	8526                	mv	a0,s1
    2676:	00003097          	auipc	ra,0x3
    267a:	5d0080e7          	jalr	1488(ra) # 5c46 <link>
  if(ret != -1){
    267e:	57fd                	li	a5,-1
    2680:	08f51e63          	bne	a0,a5,271c <copyinstr3+0x10e>
  char *args[] = { "xx", 0 };
    2684:	00005797          	auipc	a5,0x5
    2688:	4c478793          	addi	a5,a5,1220 # 7b48 <malloc+0x1b1c>
    268c:	fcf43823          	sd	a5,-48(s0)
    2690:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    2694:	fd040593          	addi	a1,s0,-48
    2698:	8526                	mv	a0,s1
    269a:	00003097          	auipc	ra,0x3
    269e:	584080e7          	jalr	1412(ra) # 5c1e <exec>
  if(ret != -1){
    26a2:	57fd                	li	a5,-1
    26a4:	08f51c63          	bne	a0,a5,273c <copyinstr3+0x12e>
}
    26a8:	70a2                	ld	ra,40(sp)
    26aa:	7402                	ld	s0,32(sp)
    26ac:	64e2                	ld	s1,24(sp)
    26ae:	6145                	addi	sp,sp,48
    26b0:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    26b2:	0347d513          	srli	a0,a5,0x34
    26b6:	6785                	lui	a5,0x1
    26b8:	40a7853b          	subw	a0,a5,a0
    26bc:	00003097          	auipc	ra,0x3
    26c0:	5b2080e7          	jalr	1458(ra) # 5c6e <sbrk>
    26c4:	b7bd                	j	2632 <copyinstr3+0x24>
    printf("oops\n");
    26c6:	00004517          	auipc	a0,0x4
    26ca:	7a250513          	addi	a0,a0,1954 # 6e68 <malloc+0xe3c>
    26ce:	00004097          	auipc	ra,0x4
    26d2:	8a0080e7          	jalr	-1888(ra) # 5f6e <printf>
    exit(1);
    26d6:	4505                	li	a0,1
    26d8:	00003097          	auipc	ra,0x3
    26dc:	50e080e7          	jalr	1294(ra) # 5be6 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    26e0:	862a                	mv	a2,a0
    26e2:	85a6                	mv	a1,s1
    26e4:	00004517          	auipc	a0,0x4
    26e8:	22c50513          	addi	a0,a0,556 # 6910 <malloc+0x8e4>
    26ec:	00004097          	auipc	ra,0x4
    26f0:	882080e7          	jalr	-1918(ra) # 5f6e <printf>
    exit(1);
    26f4:	4505                	li	a0,1
    26f6:	00003097          	auipc	ra,0x3
    26fa:	4f0080e7          	jalr	1264(ra) # 5be6 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    26fe:	862a                	mv	a2,a0
    2700:	85a6                	mv	a1,s1
    2702:	00004517          	auipc	a0,0x4
    2706:	22e50513          	addi	a0,a0,558 # 6930 <malloc+0x904>
    270a:	00004097          	auipc	ra,0x4
    270e:	864080e7          	jalr	-1948(ra) # 5f6e <printf>
    exit(1);
    2712:	4505                	li	a0,1
    2714:	00003097          	auipc	ra,0x3
    2718:	4d2080e7          	jalr	1234(ra) # 5be6 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    271c:	86aa                	mv	a3,a0
    271e:	8626                	mv	a2,s1
    2720:	85a6                	mv	a1,s1
    2722:	00004517          	auipc	a0,0x4
    2726:	22e50513          	addi	a0,a0,558 # 6950 <malloc+0x924>
    272a:	00004097          	auipc	ra,0x4
    272e:	844080e7          	jalr	-1980(ra) # 5f6e <printf>
    exit(1);
    2732:	4505                	li	a0,1
    2734:	00003097          	auipc	ra,0x3
    2738:	4b2080e7          	jalr	1202(ra) # 5be6 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    273c:	567d                	li	a2,-1
    273e:	85a6                	mv	a1,s1
    2740:	00004517          	auipc	a0,0x4
    2744:	23850513          	addi	a0,a0,568 # 6978 <malloc+0x94c>
    2748:	00004097          	auipc	ra,0x4
    274c:	826080e7          	jalr	-2010(ra) # 5f6e <printf>
    exit(1);
    2750:	4505                	li	a0,1
    2752:	00003097          	auipc	ra,0x3
    2756:	494080e7          	jalr	1172(ra) # 5be6 <exit>

000000000000275a <rwsbrk>:
{
    275a:	1101                	addi	sp,sp,-32
    275c:	ec06                	sd	ra,24(sp)
    275e:	e822                	sd	s0,16(sp)
    2760:	e426                	sd	s1,8(sp)
    2762:	e04a                	sd	s2,0(sp)
    2764:	1000                	addi	s0,sp,32
  uint64 a = (uint64) sbrk(8192);
    2766:	6509                	lui	a0,0x2
    2768:	00003097          	auipc	ra,0x3
    276c:	506080e7          	jalr	1286(ra) # 5c6e <sbrk>
  if(a == 0xffffffffffffffffLL) {
    2770:	57fd                	li	a5,-1
    2772:	06f50363          	beq	a0,a5,27d8 <rwsbrk+0x7e>
    2776:	84aa                	mv	s1,a0
  if ((uint64) sbrk(-8192) ==  0xffffffffffffffffLL) {
    2778:	7579                	lui	a0,0xffffe
    277a:	00003097          	auipc	ra,0x3
    277e:	4f4080e7          	jalr	1268(ra) # 5c6e <sbrk>
    2782:	57fd                	li	a5,-1
    2784:	06f50763          	beq	a0,a5,27f2 <rwsbrk+0x98>
  fd = open("rwsbrk", O_CREATE|O_WRONLY);
    2788:	20100593          	li	a1,513
    278c:	00004517          	auipc	a0,0x4
    2790:	71c50513          	addi	a0,a0,1820 # 6ea8 <malloc+0xe7c>
    2794:	00003097          	auipc	ra,0x3
    2798:	492080e7          	jalr	1170(ra) # 5c26 <open>
    279c:	892a                	mv	s2,a0
  if(fd < 0){
    279e:	06054763          	bltz	a0,280c <rwsbrk+0xb2>
  n = write(fd, (void*)(a+4096), 1024);
    27a2:	6505                	lui	a0,0x1
    27a4:	94aa                	add	s1,s1,a0
    27a6:	40000613          	li	a2,1024
    27aa:	85a6                	mv	a1,s1
    27ac:	854a                	mv	a0,s2
    27ae:	00003097          	auipc	ra,0x3
    27b2:	458080e7          	jalr	1112(ra) # 5c06 <write>
    27b6:	862a                	mv	a2,a0
  if(n >= 0){
    27b8:	06054763          	bltz	a0,2826 <rwsbrk+0xcc>
    printf("write(fd, %p, 1024) returned %d, not -1\n", a+4096, n);
    27bc:	85a6                	mv	a1,s1
    27be:	00004517          	auipc	a0,0x4
    27c2:	70a50513          	addi	a0,a0,1802 # 6ec8 <malloc+0xe9c>
    27c6:	00003097          	auipc	ra,0x3
    27ca:	7a8080e7          	jalr	1960(ra) # 5f6e <printf>
    exit(1);
    27ce:	4505                	li	a0,1
    27d0:	00003097          	auipc	ra,0x3
    27d4:	416080e7          	jalr	1046(ra) # 5be6 <exit>
    printf("sbrk(rwsbrk) failed\n");
    27d8:	00004517          	auipc	a0,0x4
    27dc:	69850513          	addi	a0,a0,1688 # 6e70 <malloc+0xe44>
    27e0:	00003097          	auipc	ra,0x3
    27e4:	78e080e7          	jalr	1934(ra) # 5f6e <printf>
    exit(1);
    27e8:	4505                	li	a0,1
    27ea:	00003097          	auipc	ra,0x3
    27ee:	3fc080e7          	jalr	1020(ra) # 5be6 <exit>
    printf("sbrk(rwsbrk) shrink failed\n");
    27f2:	00004517          	auipc	a0,0x4
    27f6:	69650513          	addi	a0,a0,1686 # 6e88 <malloc+0xe5c>
    27fa:	00003097          	auipc	ra,0x3
    27fe:	774080e7          	jalr	1908(ra) # 5f6e <printf>
    exit(1);
    2802:	4505                	li	a0,1
    2804:	00003097          	auipc	ra,0x3
    2808:	3e2080e7          	jalr	994(ra) # 5be6 <exit>
    printf("open(rwsbrk) failed\n");
    280c:	00004517          	auipc	a0,0x4
    2810:	6a450513          	addi	a0,a0,1700 # 6eb0 <malloc+0xe84>
    2814:	00003097          	auipc	ra,0x3
    2818:	75a080e7          	jalr	1882(ra) # 5f6e <printf>
    exit(1);
    281c:	4505                	li	a0,1
    281e:	00003097          	auipc	ra,0x3
    2822:	3c8080e7          	jalr	968(ra) # 5be6 <exit>
  close(fd);
    2826:	854a                	mv	a0,s2
    2828:	00003097          	auipc	ra,0x3
    282c:	3e6080e7          	jalr	998(ra) # 5c0e <close>
  unlink("rwsbrk");
    2830:	00004517          	auipc	a0,0x4
    2834:	67850513          	addi	a0,a0,1656 # 6ea8 <malloc+0xe7c>
    2838:	00003097          	auipc	ra,0x3
    283c:	3fe080e7          	jalr	1022(ra) # 5c36 <unlink>
  fd = open("README", O_RDONLY);
    2840:	4581                	li	a1,0
    2842:	00004517          	auipc	a0,0x4
    2846:	afe50513          	addi	a0,a0,-1282 # 6340 <malloc+0x314>
    284a:	00003097          	auipc	ra,0x3
    284e:	3dc080e7          	jalr	988(ra) # 5c26 <open>
    2852:	892a                	mv	s2,a0
  if(fd < 0){
    2854:	02054963          	bltz	a0,2886 <rwsbrk+0x12c>
  n = read(fd, (void*)(a+4096), 10);
    2858:	4629                	li	a2,10
    285a:	85a6                	mv	a1,s1
    285c:	00003097          	auipc	ra,0x3
    2860:	3a2080e7          	jalr	930(ra) # 5bfe <read>
    2864:	862a                	mv	a2,a0
  if(n >= 0){
    2866:	02054d63          	bltz	a0,28a0 <rwsbrk+0x146>
    printf("read(fd, %p, 10) returned %d, not -1\n", a+4096, n);
    286a:	85a6                	mv	a1,s1
    286c:	00004517          	auipc	a0,0x4
    2870:	68c50513          	addi	a0,a0,1676 # 6ef8 <malloc+0xecc>
    2874:	00003097          	auipc	ra,0x3
    2878:	6fa080e7          	jalr	1786(ra) # 5f6e <printf>
    exit(1);
    287c:	4505                	li	a0,1
    287e:	00003097          	auipc	ra,0x3
    2882:	368080e7          	jalr	872(ra) # 5be6 <exit>
    printf("open(rwsbrk) failed\n");
    2886:	00004517          	auipc	a0,0x4
    288a:	62a50513          	addi	a0,a0,1578 # 6eb0 <malloc+0xe84>
    288e:	00003097          	auipc	ra,0x3
    2892:	6e0080e7          	jalr	1760(ra) # 5f6e <printf>
    exit(1);
    2896:	4505                	li	a0,1
    2898:	00003097          	auipc	ra,0x3
    289c:	34e080e7          	jalr	846(ra) # 5be6 <exit>
  close(fd);
    28a0:	854a                	mv	a0,s2
    28a2:	00003097          	auipc	ra,0x3
    28a6:	36c080e7          	jalr	876(ra) # 5c0e <close>
  exit(0);
    28aa:	4501                	li	a0,0
    28ac:	00003097          	auipc	ra,0x3
    28b0:	33a080e7          	jalr	826(ra) # 5be6 <exit>

00000000000028b4 <sbrkbasic>:
{
    28b4:	715d                	addi	sp,sp,-80
    28b6:	e486                	sd	ra,72(sp)
    28b8:	e0a2                	sd	s0,64(sp)
    28ba:	fc26                	sd	s1,56(sp)
    28bc:	f84a                	sd	s2,48(sp)
    28be:	f44e                	sd	s3,40(sp)
    28c0:	f052                	sd	s4,32(sp)
    28c2:	ec56                	sd	s5,24(sp)
    28c4:	0880                	addi	s0,sp,80
    28c6:	8a2a                	mv	s4,a0
  pid = fork();
    28c8:	00003097          	auipc	ra,0x3
    28cc:	316080e7          	jalr	790(ra) # 5bde <fork>
  if(pid < 0){
    28d0:	02054c63          	bltz	a0,2908 <sbrkbasic+0x54>
  if(pid == 0){
    28d4:	ed21                	bnez	a0,292c <sbrkbasic+0x78>
    a = sbrk(TOOMUCH);
    28d6:	40000537          	lui	a0,0x40000
    28da:	00003097          	auipc	ra,0x3
    28de:	394080e7          	jalr	916(ra) # 5c6e <sbrk>
    if(a == (char*)0xffffffffffffffffL){
    28e2:	57fd                	li	a5,-1
    28e4:	02f50f63          	beq	a0,a5,2922 <sbrkbasic+0x6e>
    for(b = a; b < a+TOOMUCH; b += 4096){
    28e8:	400007b7          	lui	a5,0x40000
    28ec:	97aa                	add	a5,a5,a0
      *b = 99;
    28ee:	06300693          	li	a3,99
    for(b = a; b < a+TOOMUCH; b += 4096){
    28f2:	6705                	lui	a4,0x1
      *b = 99;
    28f4:	00d50023          	sb	a3,0(a0) # 40000000 <base+0x3fff0388>
    for(b = a; b < a+TOOMUCH; b += 4096){
    28f8:	953a                	add	a0,a0,a4
    28fa:	fef51de3          	bne	a0,a5,28f4 <sbrkbasic+0x40>
    exit(1);
    28fe:	4505                	li	a0,1
    2900:	00003097          	auipc	ra,0x3
    2904:	2e6080e7          	jalr	742(ra) # 5be6 <exit>
    printf("fork failed in sbrkbasic\n");
    2908:	00004517          	auipc	a0,0x4
    290c:	61850513          	addi	a0,a0,1560 # 6f20 <malloc+0xef4>
    2910:	00003097          	auipc	ra,0x3
    2914:	65e080e7          	jalr	1630(ra) # 5f6e <printf>
    exit(1);
    2918:	4505                	li	a0,1
    291a:	00003097          	auipc	ra,0x3
    291e:	2cc080e7          	jalr	716(ra) # 5be6 <exit>
      exit(0);
    2922:	4501                	li	a0,0
    2924:	00003097          	auipc	ra,0x3
    2928:	2c2080e7          	jalr	706(ra) # 5be6 <exit>
  wait(&xstatus);
    292c:	fbc40513          	addi	a0,s0,-68
    2930:	00003097          	auipc	ra,0x3
    2934:	2be080e7          	jalr	702(ra) # 5bee <wait>
  if(xstatus == 1){
    2938:	fbc42703          	lw	a4,-68(s0)
    293c:	4785                	li	a5,1
    293e:	00f70e63          	beq	a4,a5,295a <sbrkbasic+0xa6>
  a = sbrk(0);
    2942:	4501                	li	a0,0
    2944:	00003097          	auipc	ra,0x3
    2948:	32a080e7          	jalr	810(ra) # 5c6e <sbrk>
    294c:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    294e:	4901                	li	s2,0
    *b = 1;
    2950:	4a85                	li	s5,1
  for(i = 0; i < 5000; i++){
    2952:	6985                	lui	s3,0x1
    2954:	38898993          	addi	s3,s3,904 # 1388 <badarg+0x3c>
    2958:	a005                	j	2978 <sbrkbasic+0xc4>
    printf("%s: too much memory allocated!\n", s);
    295a:	85d2                	mv	a1,s4
    295c:	00004517          	auipc	a0,0x4
    2960:	5e450513          	addi	a0,a0,1508 # 6f40 <malloc+0xf14>
    2964:	00003097          	auipc	ra,0x3
    2968:	60a080e7          	jalr	1546(ra) # 5f6e <printf>
    exit(1);
    296c:	4505                	li	a0,1
    296e:	00003097          	auipc	ra,0x3
    2972:	278080e7          	jalr	632(ra) # 5be6 <exit>
    a = b + 1;
    2976:	84be                	mv	s1,a5
    b = sbrk(1);
    2978:	4505                	li	a0,1
    297a:	00003097          	auipc	ra,0x3
    297e:	2f4080e7          	jalr	756(ra) # 5c6e <sbrk>
    if(b != a){
    2982:	04951b63          	bne	a0,s1,29d8 <sbrkbasic+0x124>
    *b = 1;
    2986:	01548023          	sb	s5,0(s1)
    a = b + 1;
    298a:	00148793          	addi	a5,s1,1
  for(i = 0; i < 5000; i++){
    298e:	2905                	addiw	s2,s2,1
    2990:	ff3913e3          	bne	s2,s3,2976 <sbrkbasic+0xc2>
  pid = fork();
    2994:	00003097          	auipc	ra,0x3
    2998:	24a080e7          	jalr	586(ra) # 5bde <fork>
    299c:	892a                	mv	s2,a0
  if(pid < 0){
    299e:	04054e63          	bltz	a0,29fa <sbrkbasic+0x146>
  c = sbrk(1);
    29a2:	4505                	li	a0,1
    29a4:	00003097          	auipc	ra,0x3
    29a8:	2ca080e7          	jalr	714(ra) # 5c6e <sbrk>
  c = sbrk(1);
    29ac:	4505                	li	a0,1
    29ae:	00003097          	auipc	ra,0x3
    29b2:	2c0080e7          	jalr	704(ra) # 5c6e <sbrk>
  if(c != a + 1){
    29b6:	0489                	addi	s1,s1,2
    29b8:	04a48f63          	beq	s1,a0,2a16 <sbrkbasic+0x162>
    printf("%s: sbrk test failed post-fork\n", s);
    29bc:	85d2                	mv	a1,s4
    29be:	00004517          	auipc	a0,0x4
    29c2:	5e250513          	addi	a0,a0,1506 # 6fa0 <malloc+0xf74>
    29c6:	00003097          	auipc	ra,0x3
    29ca:	5a8080e7          	jalr	1448(ra) # 5f6e <printf>
    exit(1);
    29ce:	4505                	li	a0,1
    29d0:	00003097          	auipc	ra,0x3
    29d4:	216080e7          	jalr	534(ra) # 5be6 <exit>
      printf("%s: sbrk test failed %d %x %x\n", s, i, a, b);
    29d8:	872a                	mv	a4,a0
    29da:	86a6                	mv	a3,s1
    29dc:	864a                	mv	a2,s2
    29de:	85d2                	mv	a1,s4
    29e0:	00004517          	auipc	a0,0x4
    29e4:	58050513          	addi	a0,a0,1408 # 6f60 <malloc+0xf34>
    29e8:	00003097          	auipc	ra,0x3
    29ec:	586080e7          	jalr	1414(ra) # 5f6e <printf>
      exit(1);
    29f0:	4505                	li	a0,1
    29f2:	00003097          	auipc	ra,0x3
    29f6:	1f4080e7          	jalr	500(ra) # 5be6 <exit>
    printf("%s: sbrk test fork failed\n", s);
    29fa:	85d2                	mv	a1,s4
    29fc:	00004517          	auipc	a0,0x4
    2a00:	58450513          	addi	a0,a0,1412 # 6f80 <malloc+0xf54>
    2a04:	00003097          	auipc	ra,0x3
    2a08:	56a080e7          	jalr	1386(ra) # 5f6e <printf>
    exit(1);
    2a0c:	4505                	li	a0,1
    2a0e:	00003097          	auipc	ra,0x3
    2a12:	1d8080e7          	jalr	472(ra) # 5be6 <exit>
  if(pid == 0)
    2a16:	00091763          	bnez	s2,2a24 <sbrkbasic+0x170>
    exit(0);
    2a1a:	4501                	li	a0,0
    2a1c:	00003097          	auipc	ra,0x3
    2a20:	1ca080e7          	jalr	458(ra) # 5be6 <exit>
  wait(&xstatus);
    2a24:	fbc40513          	addi	a0,s0,-68
    2a28:	00003097          	auipc	ra,0x3
    2a2c:	1c6080e7          	jalr	454(ra) # 5bee <wait>
  exit(xstatus);
    2a30:	fbc42503          	lw	a0,-68(s0)
    2a34:	00003097          	auipc	ra,0x3
    2a38:	1b2080e7          	jalr	434(ra) # 5be6 <exit>

0000000000002a3c <sbrkmuch>:
{
    2a3c:	7179                	addi	sp,sp,-48
    2a3e:	f406                	sd	ra,40(sp)
    2a40:	f022                	sd	s0,32(sp)
    2a42:	ec26                	sd	s1,24(sp)
    2a44:	e84a                	sd	s2,16(sp)
    2a46:	e44e                	sd	s3,8(sp)
    2a48:	e052                	sd	s4,0(sp)
    2a4a:	1800                	addi	s0,sp,48
    2a4c:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    2a4e:	4501                	li	a0,0
    2a50:	00003097          	auipc	ra,0x3
    2a54:	21e080e7          	jalr	542(ra) # 5c6e <sbrk>
    2a58:	892a                	mv	s2,a0
  a = sbrk(0);
    2a5a:	4501                	li	a0,0
    2a5c:	00003097          	auipc	ra,0x3
    2a60:	212080e7          	jalr	530(ra) # 5c6e <sbrk>
    2a64:	84aa                	mv	s1,a0
  p = sbrk(amt);
    2a66:	06400537          	lui	a0,0x6400
    2a6a:	9d05                	subw	a0,a0,s1
    2a6c:	00003097          	auipc	ra,0x3
    2a70:	202080e7          	jalr	514(ra) # 5c6e <sbrk>
  if (p != a) {
    2a74:	0ca49863          	bne	s1,a0,2b44 <sbrkmuch+0x108>
  char *eee = sbrk(0);
    2a78:	4501                	li	a0,0
    2a7a:	00003097          	auipc	ra,0x3
    2a7e:	1f4080e7          	jalr	500(ra) # 5c6e <sbrk>
    2a82:	87aa                	mv	a5,a0
  for(char *pp = a; pp < eee; pp += 4096)
    2a84:	00a4f963          	bgeu	s1,a0,2a96 <sbrkmuch+0x5a>
    *pp = 1;
    2a88:	4685                	li	a3,1
  for(char *pp = a; pp < eee; pp += 4096)
    2a8a:	6705                	lui	a4,0x1
    *pp = 1;
    2a8c:	00d48023          	sb	a3,0(s1)
  for(char *pp = a; pp < eee; pp += 4096)
    2a90:	94ba                	add	s1,s1,a4
    2a92:	fef4ede3          	bltu	s1,a5,2a8c <sbrkmuch+0x50>
  *lastaddr = 99;
    2a96:	064007b7          	lui	a5,0x6400
    2a9a:	06300713          	li	a4,99
    2a9e:	fee78fa3          	sb	a4,-1(a5) # 63fffff <base+0x63f0387>
  a = sbrk(0);
    2aa2:	4501                	li	a0,0
    2aa4:	00003097          	auipc	ra,0x3
    2aa8:	1ca080e7          	jalr	458(ra) # 5c6e <sbrk>
    2aac:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    2aae:	757d                	lui	a0,0xfffff
    2ab0:	00003097          	auipc	ra,0x3
    2ab4:	1be080e7          	jalr	446(ra) # 5c6e <sbrk>
  if(c == (char*)0xffffffffffffffffL){
    2ab8:	57fd                	li	a5,-1
    2aba:	0af50363          	beq	a0,a5,2b60 <sbrkmuch+0x124>
  c = sbrk(0);
    2abe:	4501                	li	a0,0
    2ac0:	00003097          	auipc	ra,0x3
    2ac4:	1ae080e7          	jalr	430(ra) # 5c6e <sbrk>
  if(c != a - PGSIZE){
    2ac8:	77fd                	lui	a5,0xfffff
    2aca:	97a6                	add	a5,a5,s1
    2acc:	0af51863          	bne	a0,a5,2b7c <sbrkmuch+0x140>
  a = sbrk(0);
    2ad0:	4501                	li	a0,0
    2ad2:	00003097          	auipc	ra,0x3
    2ad6:	19c080e7          	jalr	412(ra) # 5c6e <sbrk>
    2ada:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    2adc:	6505                	lui	a0,0x1
    2ade:	00003097          	auipc	ra,0x3
    2ae2:	190080e7          	jalr	400(ra) # 5c6e <sbrk>
    2ae6:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    2ae8:	0aa49a63          	bne	s1,a0,2b9c <sbrkmuch+0x160>
    2aec:	4501                	li	a0,0
    2aee:	00003097          	auipc	ra,0x3
    2af2:	180080e7          	jalr	384(ra) # 5c6e <sbrk>
    2af6:	6785                	lui	a5,0x1
    2af8:	97a6                	add	a5,a5,s1
    2afa:	0af51163          	bne	a0,a5,2b9c <sbrkmuch+0x160>
  if(*lastaddr == 99){
    2afe:	064007b7          	lui	a5,0x6400
    2b02:	fff7c703          	lbu	a4,-1(a5) # 63fffff <base+0x63f0387>
    2b06:	06300793          	li	a5,99
    2b0a:	0af70963          	beq	a4,a5,2bbc <sbrkmuch+0x180>
  a = sbrk(0);
    2b0e:	4501                	li	a0,0
    2b10:	00003097          	auipc	ra,0x3
    2b14:	15e080e7          	jalr	350(ra) # 5c6e <sbrk>
    2b18:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    2b1a:	4501                	li	a0,0
    2b1c:	00003097          	auipc	ra,0x3
    2b20:	152080e7          	jalr	338(ra) # 5c6e <sbrk>
    2b24:	40a9053b          	subw	a0,s2,a0
    2b28:	00003097          	auipc	ra,0x3
    2b2c:	146080e7          	jalr	326(ra) # 5c6e <sbrk>
  if(c != a){
    2b30:	0aa49463          	bne	s1,a0,2bd8 <sbrkmuch+0x19c>
}
    2b34:	70a2                	ld	ra,40(sp)
    2b36:	7402                	ld	s0,32(sp)
    2b38:	64e2                	ld	s1,24(sp)
    2b3a:	6942                	ld	s2,16(sp)
    2b3c:	69a2                	ld	s3,8(sp)
    2b3e:	6a02                	ld	s4,0(sp)
    2b40:	6145                	addi	sp,sp,48
    2b42:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    2b44:	85ce                	mv	a1,s3
    2b46:	00004517          	auipc	a0,0x4
    2b4a:	47a50513          	addi	a0,a0,1146 # 6fc0 <malloc+0xf94>
    2b4e:	00003097          	auipc	ra,0x3
    2b52:	420080e7          	jalr	1056(ra) # 5f6e <printf>
    exit(1);
    2b56:	4505                	li	a0,1
    2b58:	00003097          	auipc	ra,0x3
    2b5c:	08e080e7          	jalr	142(ra) # 5be6 <exit>
    printf("%s: sbrk could not deallocate\n", s);
    2b60:	85ce                	mv	a1,s3
    2b62:	00004517          	auipc	a0,0x4
    2b66:	4a650513          	addi	a0,a0,1190 # 7008 <malloc+0xfdc>
    2b6a:	00003097          	auipc	ra,0x3
    2b6e:	404080e7          	jalr	1028(ra) # 5f6e <printf>
    exit(1);
    2b72:	4505                	li	a0,1
    2b74:	00003097          	auipc	ra,0x3
    2b78:	072080e7          	jalr	114(ra) # 5be6 <exit>
    printf("%s: sbrk deallocation produced wrong address, a %x c %x\n", s, a, c);
    2b7c:	86aa                	mv	a3,a0
    2b7e:	8626                	mv	a2,s1
    2b80:	85ce                	mv	a1,s3
    2b82:	00004517          	auipc	a0,0x4
    2b86:	4a650513          	addi	a0,a0,1190 # 7028 <malloc+0xffc>
    2b8a:	00003097          	auipc	ra,0x3
    2b8e:	3e4080e7          	jalr	996(ra) # 5f6e <printf>
    exit(1);
    2b92:	4505                	li	a0,1
    2b94:	00003097          	auipc	ra,0x3
    2b98:	052080e7          	jalr	82(ra) # 5be6 <exit>
    printf("%s: sbrk re-allocation failed, a %x c %x\n", s, a, c);
    2b9c:	86d2                	mv	a3,s4
    2b9e:	8626                	mv	a2,s1
    2ba0:	85ce                	mv	a1,s3
    2ba2:	00004517          	auipc	a0,0x4
    2ba6:	4c650513          	addi	a0,a0,1222 # 7068 <malloc+0x103c>
    2baa:	00003097          	auipc	ra,0x3
    2bae:	3c4080e7          	jalr	964(ra) # 5f6e <printf>
    exit(1);
    2bb2:	4505                	li	a0,1
    2bb4:	00003097          	auipc	ra,0x3
    2bb8:	032080e7          	jalr	50(ra) # 5be6 <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    2bbc:	85ce                	mv	a1,s3
    2bbe:	00004517          	auipc	a0,0x4
    2bc2:	4da50513          	addi	a0,a0,1242 # 7098 <malloc+0x106c>
    2bc6:	00003097          	auipc	ra,0x3
    2bca:	3a8080e7          	jalr	936(ra) # 5f6e <printf>
    exit(1);
    2bce:	4505                	li	a0,1
    2bd0:	00003097          	auipc	ra,0x3
    2bd4:	016080e7          	jalr	22(ra) # 5be6 <exit>
    printf("%s: sbrk downsize failed, a %x c %x\n", s, a, c);
    2bd8:	86aa                	mv	a3,a0
    2bda:	8626                	mv	a2,s1
    2bdc:	85ce                	mv	a1,s3
    2bde:	00004517          	auipc	a0,0x4
    2be2:	4f250513          	addi	a0,a0,1266 # 70d0 <malloc+0x10a4>
    2be6:	00003097          	auipc	ra,0x3
    2bea:	388080e7          	jalr	904(ra) # 5f6e <printf>
    exit(1);
    2bee:	4505                	li	a0,1
    2bf0:	00003097          	auipc	ra,0x3
    2bf4:	ff6080e7          	jalr	-10(ra) # 5be6 <exit>

0000000000002bf8 <sbrkarg>:
{
    2bf8:	7179                	addi	sp,sp,-48
    2bfa:	f406                	sd	ra,40(sp)
    2bfc:	f022                	sd	s0,32(sp)
    2bfe:	ec26                	sd	s1,24(sp)
    2c00:	e84a                	sd	s2,16(sp)
    2c02:	e44e                	sd	s3,8(sp)
    2c04:	1800                	addi	s0,sp,48
    2c06:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    2c08:	6505                	lui	a0,0x1
    2c0a:	00003097          	auipc	ra,0x3
    2c0e:	064080e7          	jalr	100(ra) # 5c6e <sbrk>
    2c12:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    2c14:	20100593          	li	a1,513
    2c18:	00004517          	auipc	a0,0x4
    2c1c:	4e050513          	addi	a0,a0,1248 # 70f8 <malloc+0x10cc>
    2c20:	00003097          	auipc	ra,0x3
    2c24:	006080e7          	jalr	6(ra) # 5c26 <open>
    2c28:	84aa                	mv	s1,a0
  unlink("sbrk");
    2c2a:	00004517          	auipc	a0,0x4
    2c2e:	4ce50513          	addi	a0,a0,1230 # 70f8 <malloc+0x10cc>
    2c32:	00003097          	auipc	ra,0x3
    2c36:	004080e7          	jalr	4(ra) # 5c36 <unlink>
  if(fd < 0)  {
    2c3a:	0404c163          	bltz	s1,2c7c <sbrkarg+0x84>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    2c3e:	6605                	lui	a2,0x1
    2c40:	85ca                	mv	a1,s2
    2c42:	8526                	mv	a0,s1
    2c44:	00003097          	auipc	ra,0x3
    2c48:	fc2080e7          	jalr	-62(ra) # 5c06 <write>
    2c4c:	04054663          	bltz	a0,2c98 <sbrkarg+0xa0>
  close(fd);
    2c50:	8526                	mv	a0,s1
    2c52:	00003097          	auipc	ra,0x3
    2c56:	fbc080e7          	jalr	-68(ra) # 5c0e <close>
  a = sbrk(PGSIZE);
    2c5a:	6505                	lui	a0,0x1
    2c5c:	00003097          	auipc	ra,0x3
    2c60:	012080e7          	jalr	18(ra) # 5c6e <sbrk>
  if(pipe((int *) a) != 0){
    2c64:	00003097          	auipc	ra,0x3
    2c68:	f92080e7          	jalr	-110(ra) # 5bf6 <pipe>
    2c6c:	e521                	bnez	a0,2cb4 <sbrkarg+0xbc>
}
    2c6e:	70a2                	ld	ra,40(sp)
    2c70:	7402                	ld	s0,32(sp)
    2c72:	64e2                	ld	s1,24(sp)
    2c74:	6942                	ld	s2,16(sp)
    2c76:	69a2                	ld	s3,8(sp)
    2c78:	6145                	addi	sp,sp,48
    2c7a:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    2c7c:	85ce                	mv	a1,s3
    2c7e:	00004517          	auipc	a0,0x4
    2c82:	48250513          	addi	a0,a0,1154 # 7100 <malloc+0x10d4>
    2c86:	00003097          	auipc	ra,0x3
    2c8a:	2e8080e7          	jalr	744(ra) # 5f6e <printf>
    exit(1);
    2c8e:	4505                	li	a0,1
    2c90:	00003097          	auipc	ra,0x3
    2c94:	f56080e7          	jalr	-170(ra) # 5be6 <exit>
    printf("%s: write sbrk failed\n", s);
    2c98:	85ce                	mv	a1,s3
    2c9a:	00004517          	auipc	a0,0x4
    2c9e:	47e50513          	addi	a0,a0,1150 # 7118 <malloc+0x10ec>
    2ca2:	00003097          	auipc	ra,0x3
    2ca6:	2cc080e7          	jalr	716(ra) # 5f6e <printf>
    exit(1);
    2caa:	4505                	li	a0,1
    2cac:	00003097          	auipc	ra,0x3
    2cb0:	f3a080e7          	jalr	-198(ra) # 5be6 <exit>
    printf("%s: pipe() failed\n", s);
    2cb4:	85ce                	mv	a1,s3
    2cb6:	00004517          	auipc	a0,0x4
    2cba:	e4250513          	addi	a0,a0,-446 # 6af8 <malloc+0xacc>
    2cbe:	00003097          	auipc	ra,0x3
    2cc2:	2b0080e7          	jalr	688(ra) # 5f6e <printf>
    exit(1);
    2cc6:	4505                	li	a0,1
    2cc8:	00003097          	auipc	ra,0x3
    2ccc:	f1e080e7          	jalr	-226(ra) # 5be6 <exit>

0000000000002cd0 <argptest>:
{
    2cd0:	1101                	addi	sp,sp,-32
    2cd2:	ec06                	sd	ra,24(sp)
    2cd4:	e822                	sd	s0,16(sp)
    2cd6:	e426                	sd	s1,8(sp)
    2cd8:	e04a                	sd	s2,0(sp)
    2cda:	1000                	addi	s0,sp,32
    2cdc:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    2cde:	4581                	li	a1,0
    2ce0:	00004517          	auipc	a0,0x4
    2ce4:	45050513          	addi	a0,a0,1104 # 7130 <malloc+0x1104>
    2ce8:	00003097          	auipc	ra,0x3
    2cec:	f3e080e7          	jalr	-194(ra) # 5c26 <open>
  if (fd < 0) {
    2cf0:	02054b63          	bltz	a0,2d26 <argptest+0x56>
    2cf4:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    2cf6:	4501                	li	a0,0
    2cf8:	00003097          	auipc	ra,0x3
    2cfc:	f76080e7          	jalr	-138(ra) # 5c6e <sbrk>
    2d00:	567d                	li	a2,-1
    2d02:	fff50593          	addi	a1,a0,-1
    2d06:	8526                	mv	a0,s1
    2d08:	00003097          	auipc	ra,0x3
    2d0c:	ef6080e7          	jalr	-266(ra) # 5bfe <read>
  close(fd);
    2d10:	8526                	mv	a0,s1
    2d12:	00003097          	auipc	ra,0x3
    2d16:	efc080e7          	jalr	-260(ra) # 5c0e <close>
}
    2d1a:	60e2                	ld	ra,24(sp)
    2d1c:	6442                	ld	s0,16(sp)
    2d1e:	64a2                	ld	s1,8(sp)
    2d20:	6902                	ld	s2,0(sp)
    2d22:	6105                	addi	sp,sp,32
    2d24:	8082                	ret
    printf("%s: open failed\n", s);
    2d26:	85ca                	mv	a1,s2
    2d28:	00004517          	auipc	a0,0x4
    2d2c:	ce050513          	addi	a0,a0,-800 # 6a08 <malloc+0x9dc>
    2d30:	00003097          	auipc	ra,0x3
    2d34:	23e080e7          	jalr	574(ra) # 5f6e <printf>
    exit(1);
    2d38:	4505                	li	a0,1
    2d3a:	00003097          	auipc	ra,0x3
    2d3e:	eac080e7          	jalr	-340(ra) # 5be6 <exit>

0000000000002d42 <sbrkbugs>:
{
    2d42:	1141                	addi	sp,sp,-16
    2d44:	e406                	sd	ra,8(sp)
    2d46:	e022                	sd	s0,0(sp)
    2d48:	0800                	addi	s0,sp,16
  int pid = fork();
    2d4a:	00003097          	auipc	ra,0x3
    2d4e:	e94080e7          	jalr	-364(ra) # 5bde <fork>
  if(pid < 0){
    2d52:	02054263          	bltz	a0,2d76 <sbrkbugs+0x34>
  if(pid == 0){
    2d56:	ed0d                	bnez	a0,2d90 <sbrkbugs+0x4e>
    int sz = (uint64) sbrk(0);
    2d58:	00003097          	auipc	ra,0x3
    2d5c:	f16080e7          	jalr	-234(ra) # 5c6e <sbrk>
    sbrk(-sz);
    2d60:	40a0053b          	negw	a0,a0
    2d64:	00003097          	auipc	ra,0x3
    2d68:	f0a080e7          	jalr	-246(ra) # 5c6e <sbrk>
    exit(0);
    2d6c:	4501                	li	a0,0
    2d6e:	00003097          	auipc	ra,0x3
    2d72:	e78080e7          	jalr	-392(ra) # 5be6 <exit>
    printf("fork failed\n");
    2d76:	00004517          	auipc	a0,0x4
    2d7a:	08250513          	addi	a0,a0,130 # 6df8 <malloc+0xdcc>
    2d7e:	00003097          	auipc	ra,0x3
    2d82:	1f0080e7          	jalr	496(ra) # 5f6e <printf>
    exit(1);
    2d86:	4505                	li	a0,1
    2d88:	00003097          	auipc	ra,0x3
    2d8c:	e5e080e7          	jalr	-418(ra) # 5be6 <exit>
  wait(0);
    2d90:	4501                	li	a0,0
    2d92:	00003097          	auipc	ra,0x3
    2d96:	e5c080e7          	jalr	-420(ra) # 5bee <wait>
  pid = fork();
    2d9a:	00003097          	auipc	ra,0x3
    2d9e:	e44080e7          	jalr	-444(ra) # 5bde <fork>
  if(pid < 0){
    2da2:	02054563          	bltz	a0,2dcc <sbrkbugs+0x8a>
  if(pid == 0){
    2da6:	e121                	bnez	a0,2de6 <sbrkbugs+0xa4>
    int sz = (uint64) sbrk(0);
    2da8:	00003097          	auipc	ra,0x3
    2dac:	ec6080e7          	jalr	-314(ra) # 5c6e <sbrk>
    sbrk(-(sz - 3500));
    2db0:	6785                	lui	a5,0x1
    2db2:	dac7879b          	addiw	a5,a5,-596
    2db6:	40a7853b          	subw	a0,a5,a0
    2dba:	00003097          	auipc	ra,0x3
    2dbe:	eb4080e7          	jalr	-332(ra) # 5c6e <sbrk>
    exit(0);
    2dc2:	4501                	li	a0,0
    2dc4:	00003097          	auipc	ra,0x3
    2dc8:	e22080e7          	jalr	-478(ra) # 5be6 <exit>
    printf("fork failed\n");
    2dcc:	00004517          	auipc	a0,0x4
    2dd0:	02c50513          	addi	a0,a0,44 # 6df8 <malloc+0xdcc>
    2dd4:	00003097          	auipc	ra,0x3
    2dd8:	19a080e7          	jalr	410(ra) # 5f6e <printf>
    exit(1);
    2ddc:	4505                	li	a0,1
    2dde:	00003097          	auipc	ra,0x3
    2de2:	e08080e7          	jalr	-504(ra) # 5be6 <exit>
  wait(0);
    2de6:	4501                	li	a0,0
    2de8:	00003097          	auipc	ra,0x3
    2dec:	e06080e7          	jalr	-506(ra) # 5bee <wait>
  pid = fork();
    2df0:	00003097          	auipc	ra,0x3
    2df4:	dee080e7          	jalr	-530(ra) # 5bde <fork>
  if(pid < 0){
    2df8:	02054a63          	bltz	a0,2e2c <sbrkbugs+0xea>
  if(pid == 0){
    2dfc:	e529                	bnez	a0,2e46 <sbrkbugs+0x104>
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));
    2dfe:	00003097          	auipc	ra,0x3
    2e02:	e70080e7          	jalr	-400(ra) # 5c6e <sbrk>
    2e06:	67ad                	lui	a5,0xb
    2e08:	8007879b          	addiw	a5,a5,-2048
    2e0c:	40a7853b          	subw	a0,a5,a0
    2e10:	00003097          	auipc	ra,0x3
    2e14:	e5e080e7          	jalr	-418(ra) # 5c6e <sbrk>
    sbrk(-10);
    2e18:	5559                	li	a0,-10
    2e1a:	00003097          	auipc	ra,0x3
    2e1e:	e54080e7          	jalr	-428(ra) # 5c6e <sbrk>
    exit(0);
    2e22:	4501                	li	a0,0
    2e24:	00003097          	auipc	ra,0x3
    2e28:	dc2080e7          	jalr	-574(ra) # 5be6 <exit>
    printf("fork failed\n");
    2e2c:	00004517          	auipc	a0,0x4
    2e30:	fcc50513          	addi	a0,a0,-52 # 6df8 <malloc+0xdcc>
    2e34:	00003097          	auipc	ra,0x3
    2e38:	13a080e7          	jalr	314(ra) # 5f6e <printf>
    exit(1);
    2e3c:	4505                	li	a0,1
    2e3e:	00003097          	auipc	ra,0x3
    2e42:	da8080e7          	jalr	-600(ra) # 5be6 <exit>
  wait(0);
    2e46:	4501                	li	a0,0
    2e48:	00003097          	auipc	ra,0x3
    2e4c:	da6080e7          	jalr	-602(ra) # 5bee <wait>
  exit(0);
    2e50:	4501                	li	a0,0
    2e52:	00003097          	auipc	ra,0x3
    2e56:	d94080e7          	jalr	-620(ra) # 5be6 <exit>

0000000000002e5a <sbrklast>:
{
    2e5a:	7179                	addi	sp,sp,-48
    2e5c:	f406                	sd	ra,40(sp)
    2e5e:	f022                	sd	s0,32(sp)
    2e60:	ec26                	sd	s1,24(sp)
    2e62:	e84a                	sd	s2,16(sp)
    2e64:	e44e                	sd	s3,8(sp)
    2e66:	1800                	addi	s0,sp,48
  uint64 top = (uint64) sbrk(0);
    2e68:	4501                	li	a0,0
    2e6a:	00003097          	auipc	ra,0x3
    2e6e:	e04080e7          	jalr	-508(ra) # 5c6e <sbrk>
  if((top % 4096) != 0)
    2e72:	03451793          	slli	a5,a0,0x34
    2e76:	efc1                	bnez	a5,2f0e <sbrklast+0xb4>
  sbrk(4096);
    2e78:	6505                	lui	a0,0x1
    2e7a:	00003097          	auipc	ra,0x3
    2e7e:	df4080e7          	jalr	-524(ra) # 5c6e <sbrk>
  sbrk(10);
    2e82:	4529                	li	a0,10
    2e84:	00003097          	auipc	ra,0x3
    2e88:	dea080e7          	jalr	-534(ra) # 5c6e <sbrk>
  sbrk(-20);
    2e8c:	5531                	li	a0,-20
    2e8e:	00003097          	auipc	ra,0x3
    2e92:	de0080e7          	jalr	-544(ra) # 5c6e <sbrk>
  top = (uint64) sbrk(0);
    2e96:	4501                	li	a0,0
    2e98:	00003097          	auipc	ra,0x3
    2e9c:	dd6080e7          	jalr	-554(ra) # 5c6e <sbrk>
    2ea0:	84aa                	mv	s1,a0
  char *p = (char *) (top - 64);
    2ea2:	fc050913          	addi	s2,a0,-64 # fc0 <linktest+0xca>
  p[0] = 'x';
    2ea6:	07800793          	li	a5,120
    2eaa:	fcf50023          	sb	a5,-64(a0)
  p[1] = '\0';
    2eae:	fc0500a3          	sb	zero,-63(a0)
  int fd = open(p, O_RDWR|O_CREATE);
    2eb2:	20200593          	li	a1,514
    2eb6:	854a                	mv	a0,s2
    2eb8:	00003097          	auipc	ra,0x3
    2ebc:	d6e080e7          	jalr	-658(ra) # 5c26 <open>
    2ec0:	89aa                	mv	s3,a0
  write(fd, p, 1);
    2ec2:	4605                	li	a2,1
    2ec4:	85ca                	mv	a1,s2
    2ec6:	00003097          	auipc	ra,0x3
    2eca:	d40080e7          	jalr	-704(ra) # 5c06 <write>
  close(fd);
    2ece:	854e                	mv	a0,s3
    2ed0:	00003097          	auipc	ra,0x3
    2ed4:	d3e080e7          	jalr	-706(ra) # 5c0e <close>
  fd = open(p, O_RDWR);
    2ed8:	4589                	li	a1,2
    2eda:	854a                	mv	a0,s2
    2edc:	00003097          	auipc	ra,0x3
    2ee0:	d4a080e7          	jalr	-694(ra) # 5c26 <open>
  p[0] = '\0';
    2ee4:	fc048023          	sb	zero,-64(s1)
  read(fd, p, 1);
    2ee8:	4605                	li	a2,1
    2eea:	85ca                	mv	a1,s2
    2eec:	00003097          	auipc	ra,0x3
    2ef0:	d12080e7          	jalr	-750(ra) # 5bfe <read>
  if(p[0] != 'x')
    2ef4:	fc04c703          	lbu	a4,-64(s1)
    2ef8:	07800793          	li	a5,120
    2efc:	02f71363          	bne	a4,a5,2f22 <sbrklast+0xc8>
}
    2f00:	70a2                	ld	ra,40(sp)
    2f02:	7402                	ld	s0,32(sp)
    2f04:	64e2                	ld	s1,24(sp)
    2f06:	6942                	ld	s2,16(sp)
    2f08:	69a2                	ld	s3,8(sp)
    2f0a:	6145                	addi	sp,sp,48
    2f0c:	8082                	ret
    sbrk(4096 - (top % 4096));
    2f0e:	0347d513          	srli	a0,a5,0x34
    2f12:	6785                	lui	a5,0x1
    2f14:	40a7853b          	subw	a0,a5,a0
    2f18:	00003097          	auipc	ra,0x3
    2f1c:	d56080e7          	jalr	-682(ra) # 5c6e <sbrk>
    2f20:	bfa1                	j	2e78 <sbrklast+0x1e>
    exit(1);
    2f22:	4505                	li	a0,1
    2f24:	00003097          	auipc	ra,0x3
    2f28:	cc2080e7          	jalr	-830(ra) # 5be6 <exit>

0000000000002f2c <sbrk8000>:
{
    2f2c:	1141                	addi	sp,sp,-16
    2f2e:	e406                	sd	ra,8(sp)
    2f30:	e022                	sd	s0,0(sp)
    2f32:	0800                	addi	s0,sp,16
  sbrk(0x80000004);
    2f34:	80000537          	lui	a0,0x80000
    2f38:	0511                	addi	a0,a0,4
    2f3a:	00003097          	auipc	ra,0x3
    2f3e:	d34080e7          	jalr	-716(ra) # 5c6e <sbrk>
  volatile char *top = sbrk(0);
    2f42:	4501                	li	a0,0
    2f44:	00003097          	auipc	ra,0x3
    2f48:	d2a080e7          	jalr	-726(ra) # 5c6e <sbrk>
  *(top-1) = *(top-1) + 1;
    2f4c:	fff54783          	lbu	a5,-1(a0) # ffffffff7fffffff <base+0xffffffff7fff0387>
    2f50:	0785                	addi	a5,a5,1
    2f52:	0ff7f793          	andi	a5,a5,255
    2f56:	fef50fa3          	sb	a5,-1(a0)
}
    2f5a:	60a2                	ld	ra,8(sp)
    2f5c:	6402                	ld	s0,0(sp)
    2f5e:	0141                	addi	sp,sp,16
    2f60:	8082                	ret

0000000000002f62 <execout>:
{
    2f62:	715d                	addi	sp,sp,-80
    2f64:	e486                	sd	ra,72(sp)
    2f66:	e0a2                	sd	s0,64(sp)
    2f68:	fc26                	sd	s1,56(sp)
    2f6a:	f84a                	sd	s2,48(sp)
    2f6c:	f44e                	sd	s3,40(sp)
    2f6e:	f052                	sd	s4,32(sp)
    2f70:	0880                	addi	s0,sp,80
  for(int avail = 0; avail < 15; avail++){
    2f72:	4901                	li	s2,0
    2f74:	49bd                	li	s3,15
    int pid = fork();
    2f76:	00003097          	auipc	ra,0x3
    2f7a:	c68080e7          	jalr	-920(ra) # 5bde <fork>
    2f7e:	84aa                	mv	s1,a0
    if(pid < 0){
    2f80:	02054063          	bltz	a0,2fa0 <execout+0x3e>
    } else if(pid == 0){
    2f84:	c91d                	beqz	a0,2fba <execout+0x58>
      wait((int*)0);
    2f86:	4501                	li	a0,0
    2f88:	00003097          	auipc	ra,0x3
    2f8c:	c66080e7          	jalr	-922(ra) # 5bee <wait>
  for(int avail = 0; avail < 15; avail++){
    2f90:	2905                	addiw	s2,s2,1
    2f92:	ff3912e3          	bne	s2,s3,2f76 <execout+0x14>
  exit(0);
    2f96:	4501                	li	a0,0
    2f98:	00003097          	auipc	ra,0x3
    2f9c:	c4e080e7          	jalr	-946(ra) # 5be6 <exit>
      printf("fork failed\n");
    2fa0:	00004517          	auipc	a0,0x4
    2fa4:	e5850513          	addi	a0,a0,-424 # 6df8 <malloc+0xdcc>
    2fa8:	00003097          	auipc	ra,0x3
    2fac:	fc6080e7          	jalr	-58(ra) # 5f6e <printf>
      exit(1);
    2fb0:	4505                	li	a0,1
    2fb2:	00003097          	auipc	ra,0x3
    2fb6:	c34080e7          	jalr	-972(ra) # 5be6 <exit>
        if(a == 0xffffffffffffffffLL)
    2fba:	59fd                	li	s3,-1
        *(char*)(a + 4096 - 1) = 1;
    2fbc:	4a05                	li	s4,1
        uint64 a = (uint64) sbrk(4096);
    2fbe:	6505                	lui	a0,0x1
    2fc0:	00003097          	auipc	ra,0x3
    2fc4:	cae080e7          	jalr	-850(ra) # 5c6e <sbrk>
        if(a == 0xffffffffffffffffLL)
    2fc8:	01350763          	beq	a0,s3,2fd6 <execout+0x74>
        *(char*)(a + 4096 - 1) = 1;
    2fcc:	6785                	lui	a5,0x1
    2fce:	953e                	add	a0,a0,a5
    2fd0:	ff450fa3          	sb	s4,-1(a0) # fff <linktest+0x109>
      while(1){
    2fd4:	b7ed                	j	2fbe <execout+0x5c>
      for(int i = 0; i < avail; i++)
    2fd6:	01205a63          	blez	s2,2fea <execout+0x88>
        sbrk(-4096);
    2fda:	757d                	lui	a0,0xfffff
    2fdc:	00003097          	auipc	ra,0x3
    2fe0:	c92080e7          	jalr	-878(ra) # 5c6e <sbrk>
      for(int i = 0; i < avail; i++)
    2fe4:	2485                	addiw	s1,s1,1
    2fe6:	ff249ae3          	bne	s1,s2,2fda <execout+0x78>
      close(1);
    2fea:	4505                	li	a0,1
    2fec:	00003097          	auipc	ra,0x3
    2ff0:	c22080e7          	jalr	-990(ra) # 5c0e <close>
      char *args[] = { "echo", "x", 0 };
    2ff4:	00003517          	auipc	a0,0x3
    2ff8:	17450513          	addi	a0,a0,372 # 6168 <malloc+0x13c>
    2ffc:	faa43c23          	sd	a0,-72(s0)
    3000:	00003797          	auipc	a5,0x3
    3004:	1d878793          	addi	a5,a5,472 # 61d8 <malloc+0x1ac>
    3008:	fcf43023          	sd	a5,-64(s0)
    300c:	fc043423          	sd	zero,-56(s0)
      exec("echo", args);
    3010:	fb840593          	addi	a1,s0,-72
    3014:	00003097          	auipc	ra,0x3
    3018:	c0a080e7          	jalr	-1014(ra) # 5c1e <exec>
      exit(0);
    301c:	4501                	li	a0,0
    301e:	00003097          	auipc	ra,0x3
    3022:	bc8080e7          	jalr	-1080(ra) # 5be6 <exit>

0000000000003026 <fourteen>:
{
    3026:	1101                	addi	sp,sp,-32
    3028:	ec06                	sd	ra,24(sp)
    302a:	e822                	sd	s0,16(sp)
    302c:	e426                	sd	s1,8(sp)
    302e:	1000                	addi	s0,sp,32
    3030:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    3032:	00004517          	auipc	a0,0x4
    3036:	2d650513          	addi	a0,a0,726 # 7308 <malloc+0x12dc>
    303a:	00003097          	auipc	ra,0x3
    303e:	c14080e7          	jalr	-1004(ra) # 5c4e <mkdir>
    3042:	e165                	bnez	a0,3122 <fourteen+0xfc>
  if(mkdir("12345678901234/123456789012345") != 0){
    3044:	00004517          	auipc	a0,0x4
    3048:	11c50513          	addi	a0,a0,284 # 7160 <malloc+0x1134>
    304c:	00003097          	auipc	ra,0x3
    3050:	c02080e7          	jalr	-1022(ra) # 5c4e <mkdir>
    3054:	e56d                	bnez	a0,313e <fourteen+0x118>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    3056:	20000593          	li	a1,512
    305a:	00004517          	auipc	a0,0x4
    305e:	15e50513          	addi	a0,a0,350 # 71b8 <malloc+0x118c>
    3062:	00003097          	auipc	ra,0x3
    3066:	bc4080e7          	jalr	-1084(ra) # 5c26 <open>
  if(fd < 0){
    306a:	0e054863          	bltz	a0,315a <fourteen+0x134>
  close(fd);
    306e:	00003097          	auipc	ra,0x3
    3072:	ba0080e7          	jalr	-1120(ra) # 5c0e <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    3076:	4581                	li	a1,0
    3078:	00004517          	auipc	a0,0x4
    307c:	1b850513          	addi	a0,a0,440 # 7230 <malloc+0x1204>
    3080:	00003097          	auipc	ra,0x3
    3084:	ba6080e7          	jalr	-1114(ra) # 5c26 <open>
  if(fd < 0){
    3088:	0e054763          	bltz	a0,3176 <fourteen+0x150>
  close(fd);
    308c:	00003097          	auipc	ra,0x3
    3090:	b82080e7          	jalr	-1150(ra) # 5c0e <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    3094:	00004517          	auipc	a0,0x4
    3098:	20c50513          	addi	a0,a0,524 # 72a0 <malloc+0x1274>
    309c:	00003097          	auipc	ra,0x3
    30a0:	bb2080e7          	jalr	-1102(ra) # 5c4e <mkdir>
    30a4:	c57d                	beqz	a0,3192 <fourteen+0x16c>
  if(mkdir("123456789012345/12345678901234") == 0){
    30a6:	00004517          	auipc	a0,0x4
    30aa:	25250513          	addi	a0,a0,594 # 72f8 <malloc+0x12cc>
    30ae:	00003097          	auipc	ra,0x3
    30b2:	ba0080e7          	jalr	-1120(ra) # 5c4e <mkdir>
    30b6:	cd65                	beqz	a0,31ae <fourteen+0x188>
  unlink("123456789012345/12345678901234");
    30b8:	00004517          	auipc	a0,0x4
    30bc:	24050513          	addi	a0,a0,576 # 72f8 <malloc+0x12cc>
    30c0:	00003097          	auipc	ra,0x3
    30c4:	b76080e7          	jalr	-1162(ra) # 5c36 <unlink>
  unlink("12345678901234/12345678901234");
    30c8:	00004517          	auipc	a0,0x4
    30cc:	1d850513          	addi	a0,a0,472 # 72a0 <malloc+0x1274>
    30d0:	00003097          	auipc	ra,0x3
    30d4:	b66080e7          	jalr	-1178(ra) # 5c36 <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    30d8:	00004517          	auipc	a0,0x4
    30dc:	15850513          	addi	a0,a0,344 # 7230 <malloc+0x1204>
    30e0:	00003097          	auipc	ra,0x3
    30e4:	b56080e7          	jalr	-1194(ra) # 5c36 <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    30e8:	00004517          	auipc	a0,0x4
    30ec:	0d050513          	addi	a0,a0,208 # 71b8 <malloc+0x118c>
    30f0:	00003097          	auipc	ra,0x3
    30f4:	b46080e7          	jalr	-1210(ra) # 5c36 <unlink>
  unlink("12345678901234/123456789012345");
    30f8:	00004517          	auipc	a0,0x4
    30fc:	06850513          	addi	a0,a0,104 # 7160 <malloc+0x1134>
    3100:	00003097          	auipc	ra,0x3
    3104:	b36080e7          	jalr	-1226(ra) # 5c36 <unlink>
  unlink("12345678901234");
    3108:	00004517          	auipc	a0,0x4
    310c:	20050513          	addi	a0,a0,512 # 7308 <malloc+0x12dc>
    3110:	00003097          	auipc	ra,0x3
    3114:	b26080e7          	jalr	-1242(ra) # 5c36 <unlink>
}
    3118:	60e2                	ld	ra,24(sp)
    311a:	6442                	ld	s0,16(sp)
    311c:	64a2                	ld	s1,8(sp)
    311e:	6105                	addi	sp,sp,32
    3120:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    3122:	85a6                	mv	a1,s1
    3124:	00004517          	auipc	a0,0x4
    3128:	01450513          	addi	a0,a0,20 # 7138 <malloc+0x110c>
    312c:	00003097          	auipc	ra,0x3
    3130:	e42080e7          	jalr	-446(ra) # 5f6e <printf>
    exit(1);
    3134:	4505                	li	a0,1
    3136:	00003097          	auipc	ra,0x3
    313a:	ab0080e7          	jalr	-1360(ra) # 5be6 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    313e:	85a6                	mv	a1,s1
    3140:	00004517          	auipc	a0,0x4
    3144:	04050513          	addi	a0,a0,64 # 7180 <malloc+0x1154>
    3148:	00003097          	auipc	ra,0x3
    314c:	e26080e7          	jalr	-474(ra) # 5f6e <printf>
    exit(1);
    3150:	4505                	li	a0,1
    3152:	00003097          	auipc	ra,0x3
    3156:	a94080e7          	jalr	-1388(ra) # 5be6 <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    315a:	85a6                	mv	a1,s1
    315c:	00004517          	auipc	a0,0x4
    3160:	08c50513          	addi	a0,a0,140 # 71e8 <malloc+0x11bc>
    3164:	00003097          	auipc	ra,0x3
    3168:	e0a080e7          	jalr	-502(ra) # 5f6e <printf>
    exit(1);
    316c:	4505                	li	a0,1
    316e:	00003097          	auipc	ra,0x3
    3172:	a78080e7          	jalr	-1416(ra) # 5be6 <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    3176:	85a6                	mv	a1,s1
    3178:	00004517          	auipc	a0,0x4
    317c:	0e850513          	addi	a0,a0,232 # 7260 <malloc+0x1234>
    3180:	00003097          	auipc	ra,0x3
    3184:	dee080e7          	jalr	-530(ra) # 5f6e <printf>
    exit(1);
    3188:	4505                	li	a0,1
    318a:	00003097          	auipc	ra,0x3
    318e:	a5c080e7          	jalr	-1444(ra) # 5be6 <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    3192:	85a6                	mv	a1,s1
    3194:	00004517          	auipc	a0,0x4
    3198:	12c50513          	addi	a0,a0,300 # 72c0 <malloc+0x1294>
    319c:	00003097          	auipc	ra,0x3
    31a0:	dd2080e7          	jalr	-558(ra) # 5f6e <printf>
    exit(1);
    31a4:	4505                	li	a0,1
    31a6:	00003097          	auipc	ra,0x3
    31aa:	a40080e7          	jalr	-1472(ra) # 5be6 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    31ae:	85a6                	mv	a1,s1
    31b0:	00004517          	auipc	a0,0x4
    31b4:	16850513          	addi	a0,a0,360 # 7318 <malloc+0x12ec>
    31b8:	00003097          	auipc	ra,0x3
    31bc:	db6080e7          	jalr	-586(ra) # 5f6e <printf>
    exit(1);
    31c0:	4505                	li	a0,1
    31c2:	00003097          	auipc	ra,0x3
    31c6:	a24080e7          	jalr	-1500(ra) # 5be6 <exit>

00000000000031ca <diskfull>:
{
    31ca:	b9010113          	addi	sp,sp,-1136
    31ce:	46113423          	sd	ra,1128(sp)
    31d2:	46813023          	sd	s0,1120(sp)
    31d6:	44913c23          	sd	s1,1112(sp)
    31da:	45213823          	sd	s2,1104(sp)
    31de:	45313423          	sd	s3,1096(sp)
    31e2:	45413023          	sd	s4,1088(sp)
    31e6:	43513c23          	sd	s5,1080(sp)
    31ea:	43613823          	sd	s6,1072(sp)
    31ee:	43713423          	sd	s7,1064(sp)
    31f2:	43813023          	sd	s8,1056(sp)
    31f6:	47010413          	addi	s0,sp,1136
    31fa:	8c2a                	mv	s8,a0
  unlink("diskfulldir");
    31fc:	00004517          	auipc	a0,0x4
    3200:	15450513          	addi	a0,a0,340 # 7350 <malloc+0x1324>
    3204:	00003097          	auipc	ra,0x3
    3208:	a32080e7          	jalr	-1486(ra) # 5c36 <unlink>
  for(fi = 0; done == 0; fi++){
    320c:	4a01                	li	s4,0
    name[0] = 'b';
    320e:	06200b13          	li	s6,98
    name[1] = 'i';
    3212:	06900a93          	li	s5,105
    name[2] = 'g';
    3216:	06700993          	li	s3,103
    321a:	10c00b93          	li	s7,268
    321e:	aabd                	j	339c <diskfull+0x1d2>
      printf("%s: could not create file %s\n", s, name);
    3220:	b9040613          	addi	a2,s0,-1136
    3224:	85e2                	mv	a1,s8
    3226:	00004517          	auipc	a0,0x4
    322a:	13a50513          	addi	a0,a0,314 # 7360 <malloc+0x1334>
    322e:	00003097          	auipc	ra,0x3
    3232:	d40080e7          	jalr	-704(ra) # 5f6e <printf>
      break;
    3236:	a821                	j	324e <diskfull+0x84>
        close(fd);
    3238:	854a                	mv	a0,s2
    323a:	00003097          	auipc	ra,0x3
    323e:	9d4080e7          	jalr	-1580(ra) # 5c0e <close>
    close(fd);
    3242:	854a                	mv	a0,s2
    3244:	00003097          	auipc	ra,0x3
    3248:	9ca080e7          	jalr	-1590(ra) # 5c0e <close>
  for(fi = 0; done == 0; fi++){
    324c:	2a05                	addiw	s4,s4,1
  for(int i = 0; i < nzz; i++){
    324e:	4481                	li	s1,0
    name[0] = 'z';
    3250:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
    3254:	08000993          	li	s3,128
    name[0] = 'z';
    3258:	bb240823          	sb	s2,-1104(s0)
    name[1] = 'z';
    325c:	bb2408a3          	sb	s2,-1103(s0)
    name[2] = '0' + (i / 32);
    3260:	41f4d79b          	sraiw	a5,s1,0x1f
    3264:	01b7d71b          	srliw	a4,a5,0x1b
    3268:	009707bb          	addw	a5,a4,s1
    326c:	4057d69b          	sraiw	a3,a5,0x5
    3270:	0306869b          	addiw	a3,a3,48
    3274:	bad40923          	sb	a3,-1102(s0)
    name[3] = '0' + (i % 32);
    3278:	8bfd                	andi	a5,a5,31
    327a:	9f99                	subw	a5,a5,a4
    327c:	0307879b          	addiw	a5,a5,48
    3280:	baf409a3          	sb	a5,-1101(s0)
    name[4] = '\0';
    3284:	ba040a23          	sb	zero,-1100(s0)
    unlink(name);
    3288:	bb040513          	addi	a0,s0,-1104
    328c:	00003097          	auipc	ra,0x3
    3290:	9aa080e7          	jalr	-1622(ra) # 5c36 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    3294:	60200593          	li	a1,1538
    3298:	bb040513          	addi	a0,s0,-1104
    329c:	00003097          	auipc	ra,0x3
    32a0:	98a080e7          	jalr	-1654(ra) # 5c26 <open>
    if(fd < 0)
    32a4:	00054963          	bltz	a0,32b6 <diskfull+0xec>
    close(fd);
    32a8:	00003097          	auipc	ra,0x3
    32ac:	966080e7          	jalr	-1690(ra) # 5c0e <close>
  for(int i = 0; i < nzz; i++){
    32b0:	2485                	addiw	s1,s1,1
    32b2:	fb3493e3          	bne	s1,s3,3258 <diskfull+0x8e>
  if(mkdir("diskfulldir") == 0)
    32b6:	00004517          	auipc	a0,0x4
    32ba:	09a50513          	addi	a0,a0,154 # 7350 <malloc+0x1324>
    32be:	00003097          	auipc	ra,0x3
    32c2:	990080e7          	jalr	-1648(ra) # 5c4e <mkdir>
    32c6:	12050963          	beqz	a0,33f8 <diskfull+0x22e>
  unlink("diskfulldir");
    32ca:	00004517          	auipc	a0,0x4
    32ce:	08650513          	addi	a0,a0,134 # 7350 <malloc+0x1324>
    32d2:	00003097          	auipc	ra,0x3
    32d6:	964080e7          	jalr	-1692(ra) # 5c36 <unlink>
  for(int i = 0; i < nzz; i++){
    32da:	4481                	li	s1,0
    name[0] = 'z';
    32dc:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
    32e0:	08000993          	li	s3,128
    name[0] = 'z';
    32e4:	bb240823          	sb	s2,-1104(s0)
    name[1] = 'z';
    32e8:	bb2408a3          	sb	s2,-1103(s0)
    name[2] = '0' + (i / 32);
    32ec:	41f4d79b          	sraiw	a5,s1,0x1f
    32f0:	01b7d71b          	srliw	a4,a5,0x1b
    32f4:	009707bb          	addw	a5,a4,s1
    32f8:	4057d69b          	sraiw	a3,a5,0x5
    32fc:	0306869b          	addiw	a3,a3,48
    3300:	bad40923          	sb	a3,-1102(s0)
    name[3] = '0' + (i % 32);
    3304:	8bfd                	andi	a5,a5,31
    3306:	9f99                	subw	a5,a5,a4
    3308:	0307879b          	addiw	a5,a5,48
    330c:	baf409a3          	sb	a5,-1101(s0)
    name[4] = '\0';
    3310:	ba040a23          	sb	zero,-1100(s0)
    unlink(name);
    3314:	bb040513          	addi	a0,s0,-1104
    3318:	00003097          	auipc	ra,0x3
    331c:	91e080e7          	jalr	-1762(ra) # 5c36 <unlink>
  for(int i = 0; i < nzz; i++){
    3320:	2485                	addiw	s1,s1,1
    3322:	fd3491e3          	bne	s1,s3,32e4 <diskfull+0x11a>
  for(int i = 0; i < fi; i++){
    3326:	03405e63          	blez	s4,3362 <diskfull+0x198>
    332a:	4481                	li	s1,0
    name[0] = 'b';
    332c:	06200a93          	li	s5,98
    name[1] = 'i';
    3330:	06900993          	li	s3,105
    name[2] = 'g';
    3334:	06700913          	li	s2,103
    name[0] = 'b';
    3338:	bb540823          	sb	s5,-1104(s0)
    name[1] = 'i';
    333c:	bb3408a3          	sb	s3,-1103(s0)
    name[2] = 'g';
    3340:	bb240923          	sb	s2,-1102(s0)
    name[3] = '0' + i;
    3344:	0304879b          	addiw	a5,s1,48
    3348:	baf409a3          	sb	a5,-1101(s0)
    name[4] = '\0';
    334c:	ba040a23          	sb	zero,-1100(s0)
    unlink(name);
    3350:	bb040513          	addi	a0,s0,-1104
    3354:	00003097          	auipc	ra,0x3
    3358:	8e2080e7          	jalr	-1822(ra) # 5c36 <unlink>
  for(int i = 0; i < fi; i++){
    335c:	2485                	addiw	s1,s1,1
    335e:	fd449de3          	bne	s1,s4,3338 <diskfull+0x16e>
}
    3362:	46813083          	ld	ra,1128(sp)
    3366:	46013403          	ld	s0,1120(sp)
    336a:	45813483          	ld	s1,1112(sp)
    336e:	45013903          	ld	s2,1104(sp)
    3372:	44813983          	ld	s3,1096(sp)
    3376:	44013a03          	ld	s4,1088(sp)
    337a:	43813a83          	ld	s5,1080(sp)
    337e:	43013b03          	ld	s6,1072(sp)
    3382:	42813b83          	ld	s7,1064(sp)
    3386:	42013c03          	ld	s8,1056(sp)
    338a:	47010113          	addi	sp,sp,1136
    338e:	8082                	ret
    close(fd);
    3390:	854a                	mv	a0,s2
    3392:	00003097          	auipc	ra,0x3
    3396:	87c080e7          	jalr	-1924(ra) # 5c0e <close>
  for(fi = 0; done == 0; fi++){
    339a:	2a05                	addiw	s4,s4,1
    name[0] = 'b';
    339c:	b9640823          	sb	s6,-1136(s0)
    name[1] = 'i';
    33a0:	b95408a3          	sb	s5,-1135(s0)
    name[2] = 'g';
    33a4:	b9340923          	sb	s3,-1134(s0)
    name[3] = '0' + fi;
    33a8:	030a079b          	addiw	a5,s4,48
    33ac:	b8f409a3          	sb	a5,-1133(s0)
    name[4] = '\0';
    33b0:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
    33b4:	b9040513          	addi	a0,s0,-1136
    33b8:	00003097          	auipc	ra,0x3
    33bc:	87e080e7          	jalr	-1922(ra) # 5c36 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    33c0:	60200593          	li	a1,1538
    33c4:	b9040513          	addi	a0,s0,-1136
    33c8:	00003097          	auipc	ra,0x3
    33cc:	85e080e7          	jalr	-1954(ra) # 5c26 <open>
    33d0:	892a                	mv	s2,a0
    if(fd < 0){
    33d2:	e40547e3          	bltz	a0,3220 <diskfull+0x56>
    33d6:	84de                	mv	s1,s7
      if(write(fd, buf, BSIZE) != BSIZE){
    33d8:	40000613          	li	a2,1024
    33dc:	bb040593          	addi	a1,s0,-1104
    33e0:	854a                	mv	a0,s2
    33e2:	00003097          	auipc	ra,0x3
    33e6:	824080e7          	jalr	-2012(ra) # 5c06 <write>
    33ea:	40000793          	li	a5,1024
    33ee:	e4f515e3          	bne	a0,a5,3238 <diskfull+0x6e>
    for(int i = 0; i < MAXFILE; i++){
    33f2:	34fd                	addiw	s1,s1,-1
    33f4:	f0f5                	bnez	s1,33d8 <diskfull+0x20e>
    33f6:	bf69                	j	3390 <diskfull+0x1c6>
    printf("%s: mkdir(diskfulldir) unexpectedly succeeded!\n");
    33f8:	00004517          	auipc	a0,0x4
    33fc:	f8850513          	addi	a0,a0,-120 # 7380 <malloc+0x1354>
    3400:	00003097          	auipc	ra,0x3
    3404:	b6e080e7          	jalr	-1170(ra) # 5f6e <printf>
    3408:	b5c9                	j	32ca <diskfull+0x100>

000000000000340a <iputtest>:
{
    340a:	1101                	addi	sp,sp,-32
    340c:	ec06                	sd	ra,24(sp)
    340e:	e822                	sd	s0,16(sp)
    3410:	e426                	sd	s1,8(sp)
    3412:	1000                	addi	s0,sp,32
    3414:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
    3416:	00004517          	auipc	a0,0x4
    341a:	f9a50513          	addi	a0,a0,-102 # 73b0 <malloc+0x1384>
    341e:	00003097          	auipc	ra,0x3
    3422:	830080e7          	jalr	-2000(ra) # 5c4e <mkdir>
    3426:	04054563          	bltz	a0,3470 <iputtest+0x66>
  if(chdir("iputdir") < 0){
    342a:	00004517          	auipc	a0,0x4
    342e:	f8650513          	addi	a0,a0,-122 # 73b0 <malloc+0x1384>
    3432:	00003097          	auipc	ra,0x3
    3436:	824080e7          	jalr	-2012(ra) # 5c56 <chdir>
    343a:	04054963          	bltz	a0,348c <iputtest+0x82>
  if(unlink("../iputdir") < 0){
    343e:	00004517          	auipc	a0,0x4
    3442:	fb250513          	addi	a0,a0,-78 # 73f0 <malloc+0x13c4>
    3446:	00002097          	auipc	ra,0x2
    344a:	7f0080e7          	jalr	2032(ra) # 5c36 <unlink>
    344e:	04054d63          	bltz	a0,34a8 <iputtest+0x9e>
  if(chdir("/") < 0){
    3452:	00004517          	auipc	a0,0x4
    3456:	fce50513          	addi	a0,a0,-50 # 7420 <malloc+0x13f4>
    345a:	00002097          	auipc	ra,0x2
    345e:	7fc080e7          	jalr	2044(ra) # 5c56 <chdir>
    3462:	06054163          	bltz	a0,34c4 <iputtest+0xba>
}
    3466:	60e2                	ld	ra,24(sp)
    3468:	6442                	ld	s0,16(sp)
    346a:	64a2                	ld	s1,8(sp)
    346c:	6105                	addi	sp,sp,32
    346e:	8082                	ret
    printf("%s: mkdir failed\n", s);
    3470:	85a6                	mv	a1,s1
    3472:	00004517          	auipc	a0,0x4
    3476:	f4650513          	addi	a0,a0,-186 # 73b8 <malloc+0x138c>
    347a:	00003097          	auipc	ra,0x3
    347e:	af4080e7          	jalr	-1292(ra) # 5f6e <printf>
    exit(1);
    3482:	4505                	li	a0,1
    3484:	00002097          	auipc	ra,0x2
    3488:	762080e7          	jalr	1890(ra) # 5be6 <exit>
    printf("%s: chdir iputdir failed\n", s);
    348c:	85a6                	mv	a1,s1
    348e:	00004517          	auipc	a0,0x4
    3492:	f4250513          	addi	a0,a0,-190 # 73d0 <malloc+0x13a4>
    3496:	00003097          	auipc	ra,0x3
    349a:	ad8080e7          	jalr	-1320(ra) # 5f6e <printf>
    exit(1);
    349e:	4505                	li	a0,1
    34a0:	00002097          	auipc	ra,0x2
    34a4:	746080e7          	jalr	1862(ra) # 5be6 <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    34a8:	85a6                	mv	a1,s1
    34aa:	00004517          	auipc	a0,0x4
    34ae:	f5650513          	addi	a0,a0,-170 # 7400 <malloc+0x13d4>
    34b2:	00003097          	auipc	ra,0x3
    34b6:	abc080e7          	jalr	-1348(ra) # 5f6e <printf>
    exit(1);
    34ba:	4505                	li	a0,1
    34bc:	00002097          	auipc	ra,0x2
    34c0:	72a080e7          	jalr	1834(ra) # 5be6 <exit>
    printf("%s: chdir / failed\n", s);
    34c4:	85a6                	mv	a1,s1
    34c6:	00004517          	auipc	a0,0x4
    34ca:	f6250513          	addi	a0,a0,-158 # 7428 <malloc+0x13fc>
    34ce:	00003097          	auipc	ra,0x3
    34d2:	aa0080e7          	jalr	-1376(ra) # 5f6e <printf>
    exit(1);
    34d6:	4505                	li	a0,1
    34d8:	00002097          	auipc	ra,0x2
    34dc:	70e080e7          	jalr	1806(ra) # 5be6 <exit>

00000000000034e0 <exitiputtest>:
{
    34e0:	7179                	addi	sp,sp,-48
    34e2:	f406                	sd	ra,40(sp)
    34e4:	f022                	sd	s0,32(sp)
    34e6:	ec26                	sd	s1,24(sp)
    34e8:	1800                	addi	s0,sp,48
    34ea:	84aa                	mv	s1,a0
  pid = fork();
    34ec:	00002097          	auipc	ra,0x2
    34f0:	6f2080e7          	jalr	1778(ra) # 5bde <fork>
  if(pid < 0){
    34f4:	04054663          	bltz	a0,3540 <exitiputtest+0x60>
  if(pid == 0){
    34f8:	ed45                	bnez	a0,35b0 <exitiputtest+0xd0>
    if(mkdir("iputdir") < 0){
    34fa:	00004517          	auipc	a0,0x4
    34fe:	eb650513          	addi	a0,a0,-330 # 73b0 <malloc+0x1384>
    3502:	00002097          	auipc	ra,0x2
    3506:	74c080e7          	jalr	1868(ra) # 5c4e <mkdir>
    350a:	04054963          	bltz	a0,355c <exitiputtest+0x7c>
    if(chdir("iputdir") < 0){
    350e:	00004517          	auipc	a0,0x4
    3512:	ea250513          	addi	a0,a0,-350 # 73b0 <malloc+0x1384>
    3516:	00002097          	auipc	ra,0x2
    351a:	740080e7          	jalr	1856(ra) # 5c56 <chdir>
    351e:	04054d63          	bltz	a0,3578 <exitiputtest+0x98>
    if(unlink("../iputdir") < 0){
    3522:	00004517          	auipc	a0,0x4
    3526:	ece50513          	addi	a0,a0,-306 # 73f0 <malloc+0x13c4>
    352a:	00002097          	auipc	ra,0x2
    352e:	70c080e7          	jalr	1804(ra) # 5c36 <unlink>
    3532:	06054163          	bltz	a0,3594 <exitiputtest+0xb4>
    exit(0);
    3536:	4501                	li	a0,0
    3538:	00002097          	auipc	ra,0x2
    353c:	6ae080e7          	jalr	1710(ra) # 5be6 <exit>
    printf("%s: fork failed\n", s);
    3540:	85a6                	mv	a1,s1
    3542:	00003517          	auipc	a0,0x3
    3546:	4ae50513          	addi	a0,a0,1198 # 69f0 <malloc+0x9c4>
    354a:	00003097          	auipc	ra,0x3
    354e:	a24080e7          	jalr	-1500(ra) # 5f6e <printf>
    exit(1);
    3552:	4505                	li	a0,1
    3554:	00002097          	auipc	ra,0x2
    3558:	692080e7          	jalr	1682(ra) # 5be6 <exit>
      printf("%s: mkdir failed\n", s);
    355c:	85a6                	mv	a1,s1
    355e:	00004517          	auipc	a0,0x4
    3562:	e5a50513          	addi	a0,a0,-422 # 73b8 <malloc+0x138c>
    3566:	00003097          	auipc	ra,0x3
    356a:	a08080e7          	jalr	-1528(ra) # 5f6e <printf>
      exit(1);
    356e:	4505                	li	a0,1
    3570:	00002097          	auipc	ra,0x2
    3574:	676080e7          	jalr	1654(ra) # 5be6 <exit>
      printf("%s: child chdir failed\n", s);
    3578:	85a6                	mv	a1,s1
    357a:	00004517          	auipc	a0,0x4
    357e:	ec650513          	addi	a0,a0,-314 # 7440 <malloc+0x1414>
    3582:	00003097          	auipc	ra,0x3
    3586:	9ec080e7          	jalr	-1556(ra) # 5f6e <printf>
      exit(1);
    358a:	4505                	li	a0,1
    358c:	00002097          	auipc	ra,0x2
    3590:	65a080e7          	jalr	1626(ra) # 5be6 <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    3594:	85a6                	mv	a1,s1
    3596:	00004517          	auipc	a0,0x4
    359a:	e6a50513          	addi	a0,a0,-406 # 7400 <malloc+0x13d4>
    359e:	00003097          	auipc	ra,0x3
    35a2:	9d0080e7          	jalr	-1584(ra) # 5f6e <printf>
      exit(1);
    35a6:	4505                	li	a0,1
    35a8:	00002097          	auipc	ra,0x2
    35ac:	63e080e7          	jalr	1598(ra) # 5be6 <exit>
  wait(&xstatus);
    35b0:	fdc40513          	addi	a0,s0,-36
    35b4:	00002097          	auipc	ra,0x2
    35b8:	63a080e7          	jalr	1594(ra) # 5bee <wait>
  exit(xstatus);
    35bc:	fdc42503          	lw	a0,-36(s0)
    35c0:	00002097          	auipc	ra,0x2
    35c4:	626080e7          	jalr	1574(ra) # 5be6 <exit>

00000000000035c8 <dirtest>:
{
    35c8:	1101                	addi	sp,sp,-32
    35ca:	ec06                	sd	ra,24(sp)
    35cc:	e822                	sd	s0,16(sp)
    35ce:	e426                	sd	s1,8(sp)
    35d0:	1000                	addi	s0,sp,32
    35d2:	84aa                	mv	s1,a0
  if(mkdir("dir0") < 0){
    35d4:	00004517          	auipc	a0,0x4
    35d8:	e8450513          	addi	a0,a0,-380 # 7458 <malloc+0x142c>
    35dc:	00002097          	auipc	ra,0x2
    35e0:	672080e7          	jalr	1650(ra) # 5c4e <mkdir>
    35e4:	04054563          	bltz	a0,362e <dirtest+0x66>
  if(chdir("dir0") < 0){
    35e8:	00004517          	auipc	a0,0x4
    35ec:	e7050513          	addi	a0,a0,-400 # 7458 <malloc+0x142c>
    35f0:	00002097          	auipc	ra,0x2
    35f4:	666080e7          	jalr	1638(ra) # 5c56 <chdir>
    35f8:	04054963          	bltz	a0,364a <dirtest+0x82>
  if(chdir("..") < 0){
    35fc:	00004517          	auipc	a0,0x4
    3600:	e7c50513          	addi	a0,a0,-388 # 7478 <malloc+0x144c>
    3604:	00002097          	auipc	ra,0x2
    3608:	652080e7          	jalr	1618(ra) # 5c56 <chdir>
    360c:	04054d63          	bltz	a0,3666 <dirtest+0x9e>
  if(unlink("dir0") < 0){
    3610:	00004517          	auipc	a0,0x4
    3614:	e4850513          	addi	a0,a0,-440 # 7458 <malloc+0x142c>
    3618:	00002097          	auipc	ra,0x2
    361c:	61e080e7          	jalr	1566(ra) # 5c36 <unlink>
    3620:	06054163          	bltz	a0,3682 <dirtest+0xba>
}
    3624:	60e2                	ld	ra,24(sp)
    3626:	6442                	ld	s0,16(sp)
    3628:	64a2                	ld	s1,8(sp)
    362a:	6105                	addi	sp,sp,32
    362c:	8082                	ret
    printf("%s: mkdir failed\n", s);
    362e:	85a6                	mv	a1,s1
    3630:	00004517          	auipc	a0,0x4
    3634:	d8850513          	addi	a0,a0,-632 # 73b8 <malloc+0x138c>
    3638:	00003097          	auipc	ra,0x3
    363c:	936080e7          	jalr	-1738(ra) # 5f6e <printf>
    exit(1);
    3640:	4505                	li	a0,1
    3642:	00002097          	auipc	ra,0x2
    3646:	5a4080e7          	jalr	1444(ra) # 5be6 <exit>
    printf("%s: chdir dir0 failed\n", s);
    364a:	85a6                	mv	a1,s1
    364c:	00004517          	auipc	a0,0x4
    3650:	e1450513          	addi	a0,a0,-492 # 7460 <malloc+0x1434>
    3654:	00003097          	auipc	ra,0x3
    3658:	91a080e7          	jalr	-1766(ra) # 5f6e <printf>
    exit(1);
    365c:	4505                	li	a0,1
    365e:	00002097          	auipc	ra,0x2
    3662:	588080e7          	jalr	1416(ra) # 5be6 <exit>
    printf("%s: chdir .. failed\n", s);
    3666:	85a6                	mv	a1,s1
    3668:	00004517          	auipc	a0,0x4
    366c:	e1850513          	addi	a0,a0,-488 # 7480 <malloc+0x1454>
    3670:	00003097          	auipc	ra,0x3
    3674:	8fe080e7          	jalr	-1794(ra) # 5f6e <printf>
    exit(1);
    3678:	4505                	li	a0,1
    367a:	00002097          	auipc	ra,0x2
    367e:	56c080e7          	jalr	1388(ra) # 5be6 <exit>
    printf("%s: unlink dir0 failed\n", s);
    3682:	85a6                	mv	a1,s1
    3684:	00004517          	auipc	a0,0x4
    3688:	e1450513          	addi	a0,a0,-492 # 7498 <malloc+0x146c>
    368c:	00003097          	auipc	ra,0x3
    3690:	8e2080e7          	jalr	-1822(ra) # 5f6e <printf>
    exit(1);
    3694:	4505                	li	a0,1
    3696:	00002097          	auipc	ra,0x2
    369a:	550080e7          	jalr	1360(ra) # 5be6 <exit>

000000000000369e <subdir>:
{
    369e:	1101                	addi	sp,sp,-32
    36a0:	ec06                	sd	ra,24(sp)
    36a2:	e822                	sd	s0,16(sp)
    36a4:	e426                	sd	s1,8(sp)
    36a6:	e04a                	sd	s2,0(sp)
    36a8:	1000                	addi	s0,sp,32
    36aa:	892a                	mv	s2,a0
  unlink("ff");
    36ac:	00004517          	auipc	a0,0x4
    36b0:	f3450513          	addi	a0,a0,-204 # 75e0 <malloc+0x15b4>
    36b4:	00002097          	auipc	ra,0x2
    36b8:	582080e7          	jalr	1410(ra) # 5c36 <unlink>
  if(mkdir("dd") != 0){
    36bc:	00004517          	auipc	a0,0x4
    36c0:	df450513          	addi	a0,a0,-524 # 74b0 <malloc+0x1484>
    36c4:	00002097          	auipc	ra,0x2
    36c8:	58a080e7          	jalr	1418(ra) # 5c4e <mkdir>
    36cc:	38051663          	bnez	a0,3a58 <subdir+0x3ba>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    36d0:	20200593          	li	a1,514
    36d4:	00004517          	auipc	a0,0x4
    36d8:	dfc50513          	addi	a0,a0,-516 # 74d0 <malloc+0x14a4>
    36dc:	00002097          	auipc	ra,0x2
    36e0:	54a080e7          	jalr	1354(ra) # 5c26 <open>
    36e4:	84aa                	mv	s1,a0
  if(fd < 0){
    36e6:	38054763          	bltz	a0,3a74 <subdir+0x3d6>
  write(fd, "ff", 2);
    36ea:	4609                	li	a2,2
    36ec:	00004597          	auipc	a1,0x4
    36f0:	ef458593          	addi	a1,a1,-268 # 75e0 <malloc+0x15b4>
    36f4:	00002097          	auipc	ra,0x2
    36f8:	512080e7          	jalr	1298(ra) # 5c06 <write>
  close(fd);
    36fc:	8526                	mv	a0,s1
    36fe:	00002097          	auipc	ra,0x2
    3702:	510080e7          	jalr	1296(ra) # 5c0e <close>
  if(unlink("dd") >= 0){
    3706:	00004517          	auipc	a0,0x4
    370a:	daa50513          	addi	a0,a0,-598 # 74b0 <malloc+0x1484>
    370e:	00002097          	auipc	ra,0x2
    3712:	528080e7          	jalr	1320(ra) # 5c36 <unlink>
    3716:	36055d63          	bgez	a0,3a90 <subdir+0x3f2>
  if(mkdir("/dd/dd") != 0){
    371a:	00004517          	auipc	a0,0x4
    371e:	e0e50513          	addi	a0,a0,-498 # 7528 <malloc+0x14fc>
    3722:	00002097          	auipc	ra,0x2
    3726:	52c080e7          	jalr	1324(ra) # 5c4e <mkdir>
    372a:	38051163          	bnez	a0,3aac <subdir+0x40e>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    372e:	20200593          	li	a1,514
    3732:	00004517          	auipc	a0,0x4
    3736:	e1e50513          	addi	a0,a0,-482 # 7550 <malloc+0x1524>
    373a:	00002097          	auipc	ra,0x2
    373e:	4ec080e7          	jalr	1260(ra) # 5c26 <open>
    3742:	84aa                	mv	s1,a0
  if(fd < 0){
    3744:	38054263          	bltz	a0,3ac8 <subdir+0x42a>
  write(fd, "FF", 2);
    3748:	4609                	li	a2,2
    374a:	00004597          	auipc	a1,0x4
    374e:	e3658593          	addi	a1,a1,-458 # 7580 <malloc+0x1554>
    3752:	00002097          	auipc	ra,0x2
    3756:	4b4080e7          	jalr	1204(ra) # 5c06 <write>
  close(fd);
    375a:	8526                	mv	a0,s1
    375c:	00002097          	auipc	ra,0x2
    3760:	4b2080e7          	jalr	1202(ra) # 5c0e <close>
  fd = open("dd/dd/../ff", 0);
    3764:	4581                	li	a1,0
    3766:	00004517          	auipc	a0,0x4
    376a:	e2250513          	addi	a0,a0,-478 # 7588 <malloc+0x155c>
    376e:	00002097          	auipc	ra,0x2
    3772:	4b8080e7          	jalr	1208(ra) # 5c26 <open>
    3776:	84aa                	mv	s1,a0
  if(fd < 0){
    3778:	36054663          	bltz	a0,3ae4 <subdir+0x446>
  cc = read(fd, buf, sizeof(buf));
    377c:	660d                	lui	a2,0x3
    377e:	00009597          	auipc	a1,0x9
    3782:	4fa58593          	addi	a1,a1,1274 # cc78 <buf>
    3786:	00002097          	auipc	ra,0x2
    378a:	478080e7          	jalr	1144(ra) # 5bfe <read>
  if(cc != 2 || buf[0] != 'f'){
    378e:	4789                	li	a5,2
    3790:	36f51863          	bne	a0,a5,3b00 <subdir+0x462>
    3794:	00009717          	auipc	a4,0x9
    3798:	4e474703          	lbu	a4,1252(a4) # cc78 <buf>
    379c:	06600793          	li	a5,102
    37a0:	36f71063          	bne	a4,a5,3b00 <subdir+0x462>
  close(fd);
    37a4:	8526                	mv	a0,s1
    37a6:	00002097          	auipc	ra,0x2
    37aa:	468080e7          	jalr	1128(ra) # 5c0e <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    37ae:	00004597          	auipc	a1,0x4
    37b2:	e2a58593          	addi	a1,a1,-470 # 75d8 <malloc+0x15ac>
    37b6:	00004517          	auipc	a0,0x4
    37ba:	d9a50513          	addi	a0,a0,-614 # 7550 <malloc+0x1524>
    37be:	00002097          	auipc	ra,0x2
    37c2:	488080e7          	jalr	1160(ra) # 5c46 <link>
    37c6:	34051b63          	bnez	a0,3b1c <subdir+0x47e>
  if(unlink("dd/dd/ff") != 0){
    37ca:	00004517          	auipc	a0,0x4
    37ce:	d8650513          	addi	a0,a0,-634 # 7550 <malloc+0x1524>
    37d2:	00002097          	auipc	ra,0x2
    37d6:	464080e7          	jalr	1124(ra) # 5c36 <unlink>
    37da:	34051f63          	bnez	a0,3b38 <subdir+0x49a>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    37de:	4581                	li	a1,0
    37e0:	00004517          	auipc	a0,0x4
    37e4:	d7050513          	addi	a0,a0,-656 # 7550 <malloc+0x1524>
    37e8:	00002097          	auipc	ra,0x2
    37ec:	43e080e7          	jalr	1086(ra) # 5c26 <open>
    37f0:	36055263          	bgez	a0,3b54 <subdir+0x4b6>
  if(chdir("dd") != 0){
    37f4:	00004517          	auipc	a0,0x4
    37f8:	cbc50513          	addi	a0,a0,-836 # 74b0 <malloc+0x1484>
    37fc:	00002097          	auipc	ra,0x2
    3800:	45a080e7          	jalr	1114(ra) # 5c56 <chdir>
    3804:	36051663          	bnez	a0,3b70 <subdir+0x4d2>
  if(chdir("dd/../../dd") != 0){
    3808:	00004517          	auipc	a0,0x4
    380c:	e6850513          	addi	a0,a0,-408 # 7670 <malloc+0x1644>
    3810:	00002097          	auipc	ra,0x2
    3814:	446080e7          	jalr	1094(ra) # 5c56 <chdir>
    3818:	36051a63          	bnez	a0,3b8c <subdir+0x4ee>
  if(chdir("dd/../../../dd") != 0){
    381c:	00004517          	auipc	a0,0x4
    3820:	e8450513          	addi	a0,a0,-380 # 76a0 <malloc+0x1674>
    3824:	00002097          	auipc	ra,0x2
    3828:	432080e7          	jalr	1074(ra) # 5c56 <chdir>
    382c:	36051e63          	bnez	a0,3ba8 <subdir+0x50a>
  if(chdir("./..") != 0){
    3830:	00004517          	auipc	a0,0x4
    3834:	ea050513          	addi	a0,a0,-352 # 76d0 <malloc+0x16a4>
    3838:	00002097          	auipc	ra,0x2
    383c:	41e080e7          	jalr	1054(ra) # 5c56 <chdir>
    3840:	38051263          	bnez	a0,3bc4 <subdir+0x526>
  fd = open("dd/dd/ffff", 0);
    3844:	4581                	li	a1,0
    3846:	00004517          	auipc	a0,0x4
    384a:	d9250513          	addi	a0,a0,-622 # 75d8 <malloc+0x15ac>
    384e:	00002097          	auipc	ra,0x2
    3852:	3d8080e7          	jalr	984(ra) # 5c26 <open>
    3856:	84aa                	mv	s1,a0
  if(fd < 0){
    3858:	38054463          	bltz	a0,3be0 <subdir+0x542>
  if(read(fd, buf, sizeof(buf)) != 2){
    385c:	660d                	lui	a2,0x3
    385e:	00009597          	auipc	a1,0x9
    3862:	41a58593          	addi	a1,a1,1050 # cc78 <buf>
    3866:	00002097          	auipc	ra,0x2
    386a:	398080e7          	jalr	920(ra) # 5bfe <read>
    386e:	4789                	li	a5,2
    3870:	38f51663          	bne	a0,a5,3bfc <subdir+0x55e>
  close(fd);
    3874:	8526                	mv	a0,s1
    3876:	00002097          	auipc	ra,0x2
    387a:	398080e7          	jalr	920(ra) # 5c0e <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    387e:	4581                	li	a1,0
    3880:	00004517          	auipc	a0,0x4
    3884:	cd050513          	addi	a0,a0,-816 # 7550 <malloc+0x1524>
    3888:	00002097          	auipc	ra,0x2
    388c:	39e080e7          	jalr	926(ra) # 5c26 <open>
    3890:	38055463          	bgez	a0,3c18 <subdir+0x57a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    3894:	20200593          	li	a1,514
    3898:	00004517          	auipc	a0,0x4
    389c:	ec850513          	addi	a0,a0,-312 # 7760 <malloc+0x1734>
    38a0:	00002097          	auipc	ra,0x2
    38a4:	386080e7          	jalr	902(ra) # 5c26 <open>
    38a8:	38055663          	bgez	a0,3c34 <subdir+0x596>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    38ac:	20200593          	li	a1,514
    38b0:	00004517          	auipc	a0,0x4
    38b4:	ee050513          	addi	a0,a0,-288 # 7790 <malloc+0x1764>
    38b8:	00002097          	auipc	ra,0x2
    38bc:	36e080e7          	jalr	878(ra) # 5c26 <open>
    38c0:	38055863          	bgez	a0,3c50 <subdir+0x5b2>
  if(open("dd", O_CREATE) >= 0){
    38c4:	20000593          	li	a1,512
    38c8:	00004517          	auipc	a0,0x4
    38cc:	be850513          	addi	a0,a0,-1048 # 74b0 <malloc+0x1484>
    38d0:	00002097          	auipc	ra,0x2
    38d4:	356080e7          	jalr	854(ra) # 5c26 <open>
    38d8:	38055a63          	bgez	a0,3c6c <subdir+0x5ce>
  if(open("dd", O_RDWR) >= 0){
    38dc:	4589                	li	a1,2
    38de:	00004517          	auipc	a0,0x4
    38e2:	bd250513          	addi	a0,a0,-1070 # 74b0 <malloc+0x1484>
    38e6:	00002097          	auipc	ra,0x2
    38ea:	340080e7          	jalr	832(ra) # 5c26 <open>
    38ee:	38055d63          	bgez	a0,3c88 <subdir+0x5ea>
  if(open("dd", O_WRONLY) >= 0){
    38f2:	4585                	li	a1,1
    38f4:	00004517          	auipc	a0,0x4
    38f8:	bbc50513          	addi	a0,a0,-1092 # 74b0 <malloc+0x1484>
    38fc:	00002097          	auipc	ra,0x2
    3900:	32a080e7          	jalr	810(ra) # 5c26 <open>
    3904:	3a055063          	bgez	a0,3ca4 <subdir+0x606>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    3908:	00004597          	auipc	a1,0x4
    390c:	f1858593          	addi	a1,a1,-232 # 7820 <malloc+0x17f4>
    3910:	00004517          	auipc	a0,0x4
    3914:	e5050513          	addi	a0,a0,-432 # 7760 <malloc+0x1734>
    3918:	00002097          	auipc	ra,0x2
    391c:	32e080e7          	jalr	814(ra) # 5c46 <link>
    3920:	3a050063          	beqz	a0,3cc0 <subdir+0x622>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    3924:	00004597          	auipc	a1,0x4
    3928:	efc58593          	addi	a1,a1,-260 # 7820 <malloc+0x17f4>
    392c:	00004517          	auipc	a0,0x4
    3930:	e6450513          	addi	a0,a0,-412 # 7790 <malloc+0x1764>
    3934:	00002097          	auipc	ra,0x2
    3938:	312080e7          	jalr	786(ra) # 5c46 <link>
    393c:	3a050063          	beqz	a0,3cdc <subdir+0x63e>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    3940:	00004597          	auipc	a1,0x4
    3944:	c9858593          	addi	a1,a1,-872 # 75d8 <malloc+0x15ac>
    3948:	00004517          	auipc	a0,0x4
    394c:	b8850513          	addi	a0,a0,-1144 # 74d0 <malloc+0x14a4>
    3950:	00002097          	auipc	ra,0x2
    3954:	2f6080e7          	jalr	758(ra) # 5c46 <link>
    3958:	3a050063          	beqz	a0,3cf8 <subdir+0x65a>
  if(mkdir("dd/ff/ff") == 0){
    395c:	00004517          	auipc	a0,0x4
    3960:	e0450513          	addi	a0,a0,-508 # 7760 <malloc+0x1734>
    3964:	00002097          	auipc	ra,0x2
    3968:	2ea080e7          	jalr	746(ra) # 5c4e <mkdir>
    396c:	3a050463          	beqz	a0,3d14 <subdir+0x676>
  if(mkdir("dd/xx/ff") == 0){
    3970:	00004517          	auipc	a0,0x4
    3974:	e2050513          	addi	a0,a0,-480 # 7790 <malloc+0x1764>
    3978:	00002097          	auipc	ra,0x2
    397c:	2d6080e7          	jalr	726(ra) # 5c4e <mkdir>
    3980:	3a050863          	beqz	a0,3d30 <subdir+0x692>
  if(mkdir("dd/dd/ffff") == 0){
    3984:	00004517          	auipc	a0,0x4
    3988:	c5450513          	addi	a0,a0,-940 # 75d8 <malloc+0x15ac>
    398c:	00002097          	auipc	ra,0x2
    3990:	2c2080e7          	jalr	706(ra) # 5c4e <mkdir>
    3994:	3a050c63          	beqz	a0,3d4c <subdir+0x6ae>
  if(unlink("dd/xx/ff") == 0){
    3998:	00004517          	auipc	a0,0x4
    399c:	df850513          	addi	a0,a0,-520 # 7790 <malloc+0x1764>
    39a0:	00002097          	auipc	ra,0x2
    39a4:	296080e7          	jalr	662(ra) # 5c36 <unlink>
    39a8:	3c050063          	beqz	a0,3d68 <subdir+0x6ca>
  if(unlink("dd/ff/ff") == 0){
    39ac:	00004517          	auipc	a0,0x4
    39b0:	db450513          	addi	a0,a0,-588 # 7760 <malloc+0x1734>
    39b4:	00002097          	auipc	ra,0x2
    39b8:	282080e7          	jalr	642(ra) # 5c36 <unlink>
    39bc:	3c050463          	beqz	a0,3d84 <subdir+0x6e6>
  if(chdir("dd/ff") == 0){
    39c0:	00004517          	auipc	a0,0x4
    39c4:	b1050513          	addi	a0,a0,-1264 # 74d0 <malloc+0x14a4>
    39c8:	00002097          	auipc	ra,0x2
    39cc:	28e080e7          	jalr	654(ra) # 5c56 <chdir>
    39d0:	3c050863          	beqz	a0,3da0 <subdir+0x702>
  if(chdir("dd/xx") == 0){
    39d4:	00004517          	auipc	a0,0x4
    39d8:	f9c50513          	addi	a0,a0,-100 # 7970 <malloc+0x1944>
    39dc:	00002097          	auipc	ra,0x2
    39e0:	27a080e7          	jalr	634(ra) # 5c56 <chdir>
    39e4:	3c050c63          	beqz	a0,3dbc <subdir+0x71e>
  if(unlink("dd/dd/ffff") != 0){
    39e8:	00004517          	auipc	a0,0x4
    39ec:	bf050513          	addi	a0,a0,-1040 # 75d8 <malloc+0x15ac>
    39f0:	00002097          	auipc	ra,0x2
    39f4:	246080e7          	jalr	582(ra) # 5c36 <unlink>
    39f8:	3e051063          	bnez	a0,3dd8 <subdir+0x73a>
  if(unlink("dd/ff") != 0){
    39fc:	00004517          	auipc	a0,0x4
    3a00:	ad450513          	addi	a0,a0,-1324 # 74d0 <malloc+0x14a4>
    3a04:	00002097          	auipc	ra,0x2
    3a08:	232080e7          	jalr	562(ra) # 5c36 <unlink>
    3a0c:	3e051463          	bnez	a0,3df4 <subdir+0x756>
  if(unlink("dd") == 0){
    3a10:	00004517          	auipc	a0,0x4
    3a14:	aa050513          	addi	a0,a0,-1376 # 74b0 <malloc+0x1484>
    3a18:	00002097          	auipc	ra,0x2
    3a1c:	21e080e7          	jalr	542(ra) # 5c36 <unlink>
    3a20:	3e050863          	beqz	a0,3e10 <subdir+0x772>
  if(unlink("dd/dd") < 0){
    3a24:	00004517          	auipc	a0,0x4
    3a28:	fbc50513          	addi	a0,a0,-68 # 79e0 <malloc+0x19b4>
    3a2c:	00002097          	auipc	ra,0x2
    3a30:	20a080e7          	jalr	522(ra) # 5c36 <unlink>
    3a34:	3e054c63          	bltz	a0,3e2c <subdir+0x78e>
  if(unlink("dd") < 0){
    3a38:	00004517          	auipc	a0,0x4
    3a3c:	a7850513          	addi	a0,a0,-1416 # 74b0 <malloc+0x1484>
    3a40:	00002097          	auipc	ra,0x2
    3a44:	1f6080e7          	jalr	502(ra) # 5c36 <unlink>
    3a48:	40054063          	bltz	a0,3e48 <subdir+0x7aa>
}
    3a4c:	60e2                	ld	ra,24(sp)
    3a4e:	6442                	ld	s0,16(sp)
    3a50:	64a2                	ld	s1,8(sp)
    3a52:	6902                	ld	s2,0(sp)
    3a54:	6105                	addi	sp,sp,32
    3a56:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    3a58:	85ca                	mv	a1,s2
    3a5a:	00004517          	auipc	a0,0x4
    3a5e:	a5e50513          	addi	a0,a0,-1442 # 74b8 <malloc+0x148c>
    3a62:	00002097          	auipc	ra,0x2
    3a66:	50c080e7          	jalr	1292(ra) # 5f6e <printf>
    exit(1);
    3a6a:	4505                	li	a0,1
    3a6c:	00002097          	auipc	ra,0x2
    3a70:	17a080e7          	jalr	378(ra) # 5be6 <exit>
    printf("%s: create dd/ff failed\n", s);
    3a74:	85ca                	mv	a1,s2
    3a76:	00004517          	auipc	a0,0x4
    3a7a:	a6250513          	addi	a0,a0,-1438 # 74d8 <malloc+0x14ac>
    3a7e:	00002097          	auipc	ra,0x2
    3a82:	4f0080e7          	jalr	1264(ra) # 5f6e <printf>
    exit(1);
    3a86:	4505                	li	a0,1
    3a88:	00002097          	auipc	ra,0x2
    3a8c:	15e080e7          	jalr	350(ra) # 5be6 <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    3a90:	85ca                	mv	a1,s2
    3a92:	00004517          	auipc	a0,0x4
    3a96:	a6650513          	addi	a0,a0,-1434 # 74f8 <malloc+0x14cc>
    3a9a:	00002097          	auipc	ra,0x2
    3a9e:	4d4080e7          	jalr	1236(ra) # 5f6e <printf>
    exit(1);
    3aa2:	4505                	li	a0,1
    3aa4:	00002097          	auipc	ra,0x2
    3aa8:	142080e7          	jalr	322(ra) # 5be6 <exit>
    printf("subdir mkdir dd/dd failed\n", s);
    3aac:	85ca                	mv	a1,s2
    3aae:	00004517          	auipc	a0,0x4
    3ab2:	a8250513          	addi	a0,a0,-1406 # 7530 <malloc+0x1504>
    3ab6:	00002097          	auipc	ra,0x2
    3aba:	4b8080e7          	jalr	1208(ra) # 5f6e <printf>
    exit(1);
    3abe:	4505                	li	a0,1
    3ac0:	00002097          	auipc	ra,0x2
    3ac4:	126080e7          	jalr	294(ra) # 5be6 <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    3ac8:	85ca                	mv	a1,s2
    3aca:	00004517          	auipc	a0,0x4
    3ace:	a9650513          	addi	a0,a0,-1386 # 7560 <malloc+0x1534>
    3ad2:	00002097          	auipc	ra,0x2
    3ad6:	49c080e7          	jalr	1180(ra) # 5f6e <printf>
    exit(1);
    3ada:	4505                	li	a0,1
    3adc:	00002097          	auipc	ra,0x2
    3ae0:	10a080e7          	jalr	266(ra) # 5be6 <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    3ae4:	85ca                	mv	a1,s2
    3ae6:	00004517          	auipc	a0,0x4
    3aea:	ab250513          	addi	a0,a0,-1358 # 7598 <malloc+0x156c>
    3aee:	00002097          	auipc	ra,0x2
    3af2:	480080e7          	jalr	1152(ra) # 5f6e <printf>
    exit(1);
    3af6:	4505                	li	a0,1
    3af8:	00002097          	auipc	ra,0x2
    3afc:	0ee080e7          	jalr	238(ra) # 5be6 <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    3b00:	85ca                	mv	a1,s2
    3b02:	00004517          	auipc	a0,0x4
    3b06:	ab650513          	addi	a0,a0,-1354 # 75b8 <malloc+0x158c>
    3b0a:	00002097          	auipc	ra,0x2
    3b0e:	464080e7          	jalr	1124(ra) # 5f6e <printf>
    exit(1);
    3b12:	4505                	li	a0,1
    3b14:	00002097          	auipc	ra,0x2
    3b18:	0d2080e7          	jalr	210(ra) # 5be6 <exit>
    printf("link dd/dd/ff dd/dd/ffff failed\n", s);
    3b1c:	85ca                	mv	a1,s2
    3b1e:	00004517          	auipc	a0,0x4
    3b22:	aca50513          	addi	a0,a0,-1334 # 75e8 <malloc+0x15bc>
    3b26:	00002097          	auipc	ra,0x2
    3b2a:	448080e7          	jalr	1096(ra) # 5f6e <printf>
    exit(1);
    3b2e:	4505                	li	a0,1
    3b30:	00002097          	auipc	ra,0x2
    3b34:	0b6080e7          	jalr	182(ra) # 5be6 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3b38:	85ca                	mv	a1,s2
    3b3a:	00004517          	auipc	a0,0x4
    3b3e:	ad650513          	addi	a0,a0,-1322 # 7610 <malloc+0x15e4>
    3b42:	00002097          	auipc	ra,0x2
    3b46:	42c080e7          	jalr	1068(ra) # 5f6e <printf>
    exit(1);
    3b4a:	4505                	li	a0,1
    3b4c:	00002097          	auipc	ra,0x2
    3b50:	09a080e7          	jalr	154(ra) # 5be6 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    3b54:	85ca                	mv	a1,s2
    3b56:	00004517          	auipc	a0,0x4
    3b5a:	ada50513          	addi	a0,a0,-1318 # 7630 <malloc+0x1604>
    3b5e:	00002097          	auipc	ra,0x2
    3b62:	410080e7          	jalr	1040(ra) # 5f6e <printf>
    exit(1);
    3b66:	4505                	li	a0,1
    3b68:	00002097          	auipc	ra,0x2
    3b6c:	07e080e7          	jalr	126(ra) # 5be6 <exit>
    printf("%s: chdir dd failed\n", s);
    3b70:	85ca                	mv	a1,s2
    3b72:	00004517          	auipc	a0,0x4
    3b76:	ae650513          	addi	a0,a0,-1306 # 7658 <malloc+0x162c>
    3b7a:	00002097          	auipc	ra,0x2
    3b7e:	3f4080e7          	jalr	1012(ra) # 5f6e <printf>
    exit(1);
    3b82:	4505                	li	a0,1
    3b84:	00002097          	auipc	ra,0x2
    3b88:	062080e7          	jalr	98(ra) # 5be6 <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    3b8c:	85ca                	mv	a1,s2
    3b8e:	00004517          	auipc	a0,0x4
    3b92:	af250513          	addi	a0,a0,-1294 # 7680 <malloc+0x1654>
    3b96:	00002097          	auipc	ra,0x2
    3b9a:	3d8080e7          	jalr	984(ra) # 5f6e <printf>
    exit(1);
    3b9e:	4505                	li	a0,1
    3ba0:	00002097          	auipc	ra,0x2
    3ba4:	046080e7          	jalr	70(ra) # 5be6 <exit>
    printf("chdir dd/../../dd failed\n", s);
    3ba8:	85ca                	mv	a1,s2
    3baa:	00004517          	auipc	a0,0x4
    3bae:	b0650513          	addi	a0,a0,-1274 # 76b0 <malloc+0x1684>
    3bb2:	00002097          	auipc	ra,0x2
    3bb6:	3bc080e7          	jalr	956(ra) # 5f6e <printf>
    exit(1);
    3bba:	4505                	li	a0,1
    3bbc:	00002097          	auipc	ra,0x2
    3bc0:	02a080e7          	jalr	42(ra) # 5be6 <exit>
    printf("%s: chdir ./.. failed\n", s);
    3bc4:	85ca                	mv	a1,s2
    3bc6:	00004517          	auipc	a0,0x4
    3bca:	b1250513          	addi	a0,a0,-1262 # 76d8 <malloc+0x16ac>
    3bce:	00002097          	auipc	ra,0x2
    3bd2:	3a0080e7          	jalr	928(ra) # 5f6e <printf>
    exit(1);
    3bd6:	4505                	li	a0,1
    3bd8:	00002097          	auipc	ra,0x2
    3bdc:	00e080e7          	jalr	14(ra) # 5be6 <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    3be0:	85ca                	mv	a1,s2
    3be2:	00004517          	auipc	a0,0x4
    3be6:	b0e50513          	addi	a0,a0,-1266 # 76f0 <malloc+0x16c4>
    3bea:	00002097          	auipc	ra,0x2
    3bee:	384080e7          	jalr	900(ra) # 5f6e <printf>
    exit(1);
    3bf2:	4505                	li	a0,1
    3bf4:	00002097          	auipc	ra,0x2
    3bf8:	ff2080e7          	jalr	-14(ra) # 5be6 <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    3bfc:	85ca                	mv	a1,s2
    3bfe:	00004517          	auipc	a0,0x4
    3c02:	b1250513          	addi	a0,a0,-1262 # 7710 <malloc+0x16e4>
    3c06:	00002097          	auipc	ra,0x2
    3c0a:	368080e7          	jalr	872(ra) # 5f6e <printf>
    exit(1);
    3c0e:	4505                	li	a0,1
    3c10:	00002097          	auipc	ra,0x2
    3c14:	fd6080e7          	jalr	-42(ra) # 5be6 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    3c18:	85ca                	mv	a1,s2
    3c1a:	00004517          	auipc	a0,0x4
    3c1e:	b1650513          	addi	a0,a0,-1258 # 7730 <malloc+0x1704>
    3c22:	00002097          	auipc	ra,0x2
    3c26:	34c080e7          	jalr	844(ra) # 5f6e <printf>
    exit(1);
    3c2a:	4505                	li	a0,1
    3c2c:	00002097          	auipc	ra,0x2
    3c30:	fba080e7          	jalr	-70(ra) # 5be6 <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    3c34:	85ca                	mv	a1,s2
    3c36:	00004517          	auipc	a0,0x4
    3c3a:	b3a50513          	addi	a0,a0,-1222 # 7770 <malloc+0x1744>
    3c3e:	00002097          	auipc	ra,0x2
    3c42:	330080e7          	jalr	816(ra) # 5f6e <printf>
    exit(1);
    3c46:	4505                	li	a0,1
    3c48:	00002097          	auipc	ra,0x2
    3c4c:	f9e080e7          	jalr	-98(ra) # 5be6 <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    3c50:	85ca                	mv	a1,s2
    3c52:	00004517          	auipc	a0,0x4
    3c56:	b4e50513          	addi	a0,a0,-1202 # 77a0 <malloc+0x1774>
    3c5a:	00002097          	auipc	ra,0x2
    3c5e:	314080e7          	jalr	788(ra) # 5f6e <printf>
    exit(1);
    3c62:	4505                	li	a0,1
    3c64:	00002097          	auipc	ra,0x2
    3c68:	f82080e7          	jalr	-126(ra) # 5be6 <exit>
    printf("%s: create dd succeeded!\n", s);
    3c6c:	85ca                	mv	a1,s2
    3c6e:	00004517          	auipc	a0,0x4
    3c72:	b5250513          	addi	a0,a0,-1198 # 77c0 <malloc+0x1794>
    3c76:	00002097          	auipc	ra,0x2
    3c7a:	2f8080e7          	jalr	760(ra) # 5f6e <printf>
    exit(1);
    3c7e:	4505                	li	a0,1
    3c80:	00002097          	auipc	ra,0x2
    3c84:	f66080e7          	jalr	-154(ra) # 5be6 <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    3c88:	85ca                	mv	a1,s2
    3c8a:	00004517          	auipc	a0,0x4
    3c8e:	b5650513          	addi	a0,a0,-1194 # 77e0 <malloc+0x17b4>
    3c92:	00002097          	auipc	ra,0x2
    3c96:	2dc080e7          	jalr	732(ra) # 5f6e <printf>
    exit(1);
    3c9a:	4505                	li	a0,1
    3c9c:	00002097          	auipc	ra,0x2
    3ca0:	f4a080e7          	jalr	-182(ra) # 5be6 <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    3ca4:	85ca                	mv	a1,s2
    3ca6:	00004517          	auipc	a0,0x4
    3caa:	b5a50513          	addi	a0,a0,-1190 # 7800 <malloc+0x17d4>
    3cae:	00002097          	auipc	ra,0x2
    3cb2:	2c0080e7          	jalr	704(ra) # 5f6e <printf>
    exit(1);
    3cb6:	4505                	li	a0,1
    3cb8:	00002097          	auipc	ra,0x2
    3cbc:	f2e080e7          	jalr	-210(ra) # 5be6 <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    3cc0:	85ca                	mv	a1,s2
    3cc2:	00004517          	auipc	a0,0x4
    3cc6:	b6e50513          	addi	a0,a0,-1170 # 7830 <malloc+0x1804>
    3cca:	00002097          	auipc	ra,0x2
    3cce:	2a4080e7          	jalr	676(ra) # 5f6e <printf>
    exit(1);
    3cd2:	4505                	li	a0,1
    3cd4:	00002097          	auipc	ra,0x2
    3cd8:	f12080e7          	jalr	-238(ra) # 5be6 <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    3cdc:	85ca                	mv	a1,s2
    3cde:	00004517          	auipc	a0,0x4
    3ce2:	b7a50513          	addi	a0,a0,-1158 # 7858 <malloc+0x182c>
    3ce6:	00002097          	auipc	ra,0x2
    3cea:	288080e7          	jalr	648(ra) # 5f6e <printf>
    exit(1);
    3cee:	4505                	li	a0,1
    3cf0:	00002097          	auipc	ra,0x2
    3cf4:	ef6080e7          	jalr	-266(ra) # 5be6 <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    3cf8:	85ca                	mv	a1,s2
    3cfa:	00004517          	auipc	a0,0x4
    3cfe:	b8650513          	addi	a0,a0,-1146 # 7880 <malloc+0x1854>
    3d02:	00002097          	auipc	ra,0x2
    3d06:	26c080e7          	jalr	620(ra) # 5f6e <printf>
    exit(1);
    3d0a:	4505                	li	a0,1
    3d0c:	00002097          	auipc	ra,0x2
    3d10:	eda080e7          	jalr	-294(ra) # 5be6 <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    3d14:	85ca                	mv	a1,s2
    3d16:	00004517          	auipc	a0,0x4
    3d1a:	b9250513          	addi	a0,a0,-1134 # 78a8 <malloc+0x187c>
    3d1e:	00002097          	auipc	ra,0x2
    3d22:	250080e7          	jalr	592(ra) # 5f6e <printf>
    exit(1);
    3d26:	4505                	li	a0,1
    3d28:	00002097          	auipc	ra,0x2
    3d2c:	ebe080e7          	jalr	-322(ra) # 5be6 <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    3d30:	85ca                	mv	a1,s2
    3d32:	00004517          	auipc	a0,0x4
    3d36:	b9650513          	addi	a0,a0,-1130 # 78c8 <malloc+0x189c>
    3d3a:	00002097          	auipc	ra,0x2
    3d3e:	234080e7          	jalr	564(ra) # 5f6e <printf>
    exit(1);
    3d42:	4505                	li	a0,1
    3d44:	00002097          	auipc	ra,0x2
    3d48:	ea2080e7          	jalr	-350(ra) # 5be6 <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    3d4c:	85ca                	mv	a1,s2
    3d4e:	00004517          	auipc	a0,0x4
    3d52:	b9a50513          	addi	a0,a0,-1126 # 78e8 <malloc+0x18bc>
    3d56:	00002097          	auipc	ra,0x2
    3d5a:	218080e7          	jalr	536(ra) # 5f6e <printf>
    exit(1);
    3d5e:	4505                	li	a0,1
    3d60:	00002097          	auipc	ra,0x2
    3d64:	e86080e7          	jalr	-378(ra) # 5be6 <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    3d68:	85ca                	mv	a1,s2
    3d6a:	00004517          	auipc	a0,0x4
    3d6e:	ba650513          	addi	a0,a0,-1114 # 7910 <malloc+0x18e4>
    3d72:	00002097          	auipc	ra,0x2
    3d76:	1fc080e7          	jalr	508(ra) # 5f6e <printf>
    exit(1);
    3d7a:	4505                	li	a0,1
    3d7c:	00002097          	auipc	ra,0x2
    3d80:	e6a080e7          	jalr	-406(ra) # 5be6 <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    3d84:	85ca                	mv	a1,s2
    3d86:	00004517          	auipc	a0,0x4
    3d8a:	baa50513          	addi	a0,a0,-1110 # 7930 <malloc+0x1904>
    3d8e:	00002097          	auipc	ra,0x2
    3d92:	1e0080e7          	jalr	480(ra) # 5f6e <printf>
    exit(1);
    3d96:	4505                	li	a0,1
    3d98:	00002097          	auipc	ra,0x2
    3d9c:	e4e080e7          	jalr	-434(ra) # 5be6 <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    3da0:	85ca                	mv	a1,s2
    3da2:	00004517          	auipc	a0,0x4
    3da6:	bae50513          	addi	a0,a0,-1106 # 7950 <malloc+0x1924>
    3daa:	00002097          	auipc	ra,0x2
    3dae:	1c4080e7          	jalr	452(ra) # 5f6e <printf>
    exit(1);
    3db2:	4505                	li	a0,1
    3db4:	00002097          	auipc	ra,0x2
    3db8:	e32080e7          	jalr	-462(ra) # 5be6 <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    3dbc:	85ca                	mv	a1,s2
    3dbe:	00004517          	auipc	a0,0x4
    3dc2:	bba50513          	addi	a0,a0,-1094 # 7978 <malloc+0x194c>
    3dc6:	00002097          	auipc	ra,0x2
    3dca:	1a8080e7          	jalr	424(ra) # 5f6e <printf>
    exit(1);
    3dce:	4505                	li	a0,1
    3dd0:	00002097          	auipc	ra,0x2
    3dd4:	e16080e7          	jalr	-490(ra) # 5be6 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3dd8:	85ca                	mv	a1,s2
    3dda:	00004517          	auipc	a0,0x4
    3dde:	83650513          	addi	a0,a0,-1994 # 7610 <malloc+0x15e4>
    3de2:	00002097          	auipc	ra,0x2
    3de6:	18c080e7          	jalr	396(ra) # 5f6e <printf>
    exit(1);
    3dea:	4505                	li	a0,1
    3dec:	00002097          	auipc	ra,0x2
    3df0:	dfa080e7          	jalr	-518(ra) # 5be6 <exit>
    printf("%s: unlink dd/ff failed\n", s);
    3df4:	85ca                	mv	a1,s2
    3df6:	00004517          	auipc	a0,0x4
    3dfa:	ba250513          	addi	a0,a0,-1118 # 7998 <malloc+0x196c>
    3dfe:	00002097          	auipc	ra,0x2
    3e02:	170080e7          	jalr	368(ra) # 5f6e <printf>
    exit(1);
    3e06:	4505                	li	a0,1
    3e08:	00002097          	auipc	ra,0x2
    3e0c:	dde080e7          	jalr	-546(ra) # 5be6 <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    3e10:	85ca                	mv	a1,s2
    3e12:	00004517          	auipc	a0,0x4
    3e16:	ba650513          	addi	a0,a0,-1114 # 79b8 <malloc+0x198c>
    3e1a:	00002097          	auipc	ra,0x2
    3e1e:	154080e7          	jalr	340(ra) # 5f6e <printf>
    exit(1);
    3e22:	4505                	li	a0,1
    3e24:	00002097          	auipc	ra,0x2
    3e28:	dc2080e7          	jalr	-574(ra) # 5be6 <exit>
    printf("%s: unlink dd/dd failed\n", s);
    3e2c:	85ca                	mv	a1,s2
    3e2e:	00004517          	auipc	a0,0x4
    3e32:	bba50513          	addi	a0,a0,-1094 # 79e8 <malloc+0x19bc>
    3e36:	00002097          	auipc	ra,0x2
    3e3a:	138080e7          	jalr	312(ra) # 5f6e <printf>
    exit(1);
    3e3e:	4505                	li	a0,1
    3e40:	00002097          	auipc	ra,0x2
    3e44:	da6080e7          	jalr	-602(ra) # 5be6 <exit>
    printf("%s: unlink dd failed\n", s);
    3e48:	85ca                	mv	a1,s2
    3e4a:	00004517          	auipc	a0,0x4
    3e4e:	bbe50513          	addi	a0,a0,-1090 # 7a08 <malloc+0x19dc>
    3e52:	00002097          	auipc	ra,0x2
    3e56:	11c080e7          	jalr	284(ra) # 5f6e <printf>
    exit(1);
    3e5a:	4505                	li	a0,1
    3e5c:	00002097          	auipc	ra,0x2
    3e60:	d8a080e7          	jalr	-630(ra) # 5be6 <exit>

0000000000003e64 <rmdot>:
{
    3e64:	1101                	addi	sp,sp,-32
    3e66:	ec06                	sd	ra,24(sp)
    3e68:	e822                	sd	s0,16(sp)
    3e6a:	e426                	sd	s1,8(sp)
    3e6c:	1000                	addi	s0,sp,32
    3e6e:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
    3e70:	00004517          	auipc	a0,0x4
    3e74:	bb050513          	addi	a0,a0,-1104 # 7a20 <malloc+0x19f4>
    3e78:	00002097          	auipc	ra,0x2
    3e7c:	dd6080e7          	jalr	-554(ra) # 5c4e <mkdir>
    3e80:	e549                	bnez	a0,3f0a <rmdot+0xa6>
  if(chdir("dots") != 0){
    3e82:	00004517          	auipc	a0,0x4
    3e86:	b9e50513          	addi	a0,a0,-1122 # 7a20 <malloc+0x19f4>
    3e8a:	00002097          	auipc	ra,0x2
    3e8e:	dcc080e7          	jalr	-564(ra) # 5c56 <chdir>
    3e92:	e951                	bnez	a0,3f26 <rmdot+0xc2>
  if(unlink(".") == 0){
    3e94:	00003517          	auipc	a0,0x3
    3e98:	9bc50513          	addi	a0,a0,-1604 # 6850 <malloc+0x824>
    3e9c:	00002097          	auipc	ra,0x2
    3ea0:	d9a080e7          	jalr	-614(ra) # 5c36 <unlink>
    3ea4:	cd59                	beqz	a0,3f42 <rmdot+0xde>
  if(unlink("..") == 0){
    3ea6:	00003517          	auipc	a0,0x3
    3eaa:	5d250513          	addi	a0,a0,1490 # 7478 <malloc+0x144c>
    3eae:	00002097          	auipc	ra,0x2
    3eb2:	d88080e7          	jalr	-632(ra) # 5c36 <unlink>
    3eb6:	c545                	beqz	a0,3f5e <rmdot+0xfa>
  if(chdir("/") != 0){
    3eb8:	00003517          	auipc	a0,0x3
    3ebc:	56850513          	addi	a0,a0,1384 # 7420 <malloc+0x13f4>
    3ec0:	00002097          	auipc	ra,0x2
    3ec4:	d96080e7          	jalr	-618(ra) # 5c56 <chdir>
    3ec8:	e94d                	bnez	a0,3f7a <rmdot+0x116>
  if(unlink("dots/.") == 0){
    3eca:	00004517          	auipc	a0,0x4
    3ece:	bbe50513          	addi	a0,a0,-1090 # 7a88 <malloc+0x1a5c>
    3ed2:	00002097          	auipc	ra,0x2
    3ed6:	d64080e7          	jalr	-668(ra) # 5c36 <unlink>
    3eda:	cd55                	beqz	a0,3f96 <rmdot+0x132>
  if(unlink("dots/..") == 0){
    3edc:	00004517          	auipc	a0,0x4
    3ee0:	bd450513          	addi	a0,a0,-1068 # 7ab0 <malloc+0x1a84>
    3ee4:	00002097          	auipc	ra,0x2
    3ee8:	d52080e7          	jalr	-686(ra) # 5c36 <unlink>
    3eec:	c179                	beqz	a0,3fb2 <rmdot+0x14e>
  if(unlink("dots") != 0){
    3eee:	00004517          	auipc	a0,0x4
    3ef2:	b3250513          	addi	a0,a0,-1230 # 7a20 <malloc+0x19f4>
    3ef6:	00002097          	auipc	ra,0x2
    3efa:	d40080e7          	jalr	-704(ra) # 5c36 <unlink>
    3efe:	e961                	bnez	a0,3fce <rmdot+0x16a>
}
    3f00:	60e2                	ld	ra,24(sp)
    3f02:	6442                	ld	s0,16(sp)
    3f04:	64a2                	ld	s1,8(sp)
    3f06:	6105                	addi	sp,sp,32
    3f08:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    3f0a:	85a6                	mv	a1,s1
    3f0c:	00004517          	auipc	a0,0x4
    3f10:	b1c50513          	addi	a0,a0,-1252 # 7a28 <malloc+0x19fc>
    3f14:	00002097          	auipc	ra,0x2
    3f18:	05a080e7          	jalr	90(ra) # 5f6e <printf>
    exit(1);
    3f1c:	4505                	li	a0,1
    3f1e:	00002097          	auipc	ra,0x2
    3f22:	cc8080e7          	jalr	-824(ra) # 5be6 <exit>
    printf("%s: chdir dots failed\n", s);
    3f26:	85a6                	mv	a1,s1
    3f28:	00004517          	auipc	a0,0x4
    3f2c:	b1850513          	addi	a0,a0,-1256 # 7a40 <malloc+0x1a14>
    3f30:	00002097          	auipc	ra,0x2
    3f34:	03e080e7          	jalr	62(ra) # 5f6e <printf>
    exit(1);
    3f38:	4505                	li	a0,1
    3f3a:	00002097          	auipc	ra,0x2
    3f3e:	cac080e7          	jalr	-852(ra) # 5be6 <exit>
    printf("%s: rm . worked!\n", s);
    3f42:	85a6                	mv	a1,s1
    3f44:	00004517          	auipc	a0,0x4
    3f48:	b1450513          	addi	a0,a0,-1260 # 7a58 <malloc+0x1a2c>
    3f4c:	00002097          	auipc	ra,0x2
    3f50:	022080e7          	jalr	34(ra) # 5f6e <printf>
    exit(1);
    3f54:	4505                	li	a0,1
    3f56:	00002097          	auipc	ra,0x2
    3f5a:	c90080e7          	jalr	-880(ra) # 5be6 <exit>
    printf("%s: rm .. worked!\n", s);
    3f5e:	85a6                	mv	a1,s1
    3f60:	00004517          	auipc	a0,0x4
    3f64:	b1050513          	addi	a0,a0,-1264 # 7a70 <malloc+0x1a44>
    3f68:	00002097          	auipc	ra,0x2
    3f6c:	006080e7          	jalr	6(ra) # 5f6e <printf>
    exit(1);
    3f70:	4505                	li	a0,1
    3f72:	00002097          	auipc	ra,0x2
    3f76:	c74080e7          	jalr	-908(ra) # 5be6 <exit>
    printf("%s: chdir / failed\n", s);
    3f7a:	85a6                	mv	a1,s1
    3f7c:	00003517          	auipc	a0,0x3
    3f80:	4ac50513          	addi	a0,a0,1196 # 7428 <malloc+0x13fc>
    3f84:	00002097          	auipc	ra,0x2
    3f88:	fea080e7          	jalr	-22(ra) # 5f6e <printf>
    exit(1);
    3f8c:	4505                	li	a0,1
    3f8e:	00002097          	auipc	ra,0x2
    3f92:	c58080e7          	jalr	-936(ra) # 5be6 <exit>
    printf("%s: unlink dots/. worked!\n", s);
    3f96:	85a6                	mv	a1,s1
    3f98:	00004517          	auipc	a0,0x4
    3f9c:	af850513          	addi	a0,a0,-1288 # 7a90 <malloc+0x1a64>
    3fa0:	00002097          	auipc	ra,0x2
    3fa4:	fce080e7          	jalr	-50(ra) # 5f6e <printf>
    exit(1);
    3fa8:	4505                	li	a0,1
    3faa:	00002097          	auipc	ra,0x2
    3fae:	c3c080e7          	jalr	-964(ra) # 5be6 <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    3fb2:	85a6                	mv	a1,s1
    3fb4:	00004517          	auipc	a0,0x4
    3fb8:	b0450513          	addi	a0,a0,-1276 # 7ab8 <malloc+0x1a8c>
    3fbc:	00002097          	auipc	ra,0x2
    3fc0:	fb2080e7          	jalr	-78(ra) # 5f6e <printf>
    exit(1);
    3fc4:	4505                	li	a0,1
    3fc6:	00002097          	auipc	ra,0x2
    3fca:	c20080e7          	jalr	-992(ra) # 5be6 <exit>
    printf("%s: unlink dots failed!\n", s);
    3fce:	85a6                	mv	a1,s1
    3fd0:	00004517          	auipc	a0,0x4
    3fd4:	b0850513          	addi	a0,a0,-1272 # 7ad8 <malloc+0x1aac>
    3fd8:	00002097          	auipc	ra,0x2
    3fdc:	f96080e7          	jalr	-106(ra) # 5f6e <printf>
    exit(1);
    3fe0:	4505                	li	a0,1
    3fe2:	00002097          	auipc	ra,0x2
    3fe6:	c04080e7          	jalr	-1020(ra) # 5be6 <exit>

0000000000003fea <dirfile>:
{
    3fea:	1101                	addi	sp,sp,-32
    3fec:	ec06                	sd	ra,24(sp)
    3fee:	e822                	sd	s0,16(sp)
    3ff0:	e426                	sd	s1,8(sp)
    3ff2:	e04a                	sd	s2,0(sp)
    3ff4:	1000                	addi	s0,sp,32
    3ff6:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    3ff8:	20000593          	li	a1,512
    3ffc:	00004517          	auipc	a0,0x4
    4000:	afc50513          	addi	a0,a0,-1284 # 7af8 <malloc+0x1acc>
    4004:	00002097          	auipc	ra,0x2
    4008:	c22080e7          	jalr	-990(ra) # 5c26 <open>
  if(fd < 0){
    400c:	0e054d63          	bltz	a0,4106 <dirfile+0x11c>
  close(fd);
    4010:	00002097          	auipc	ra,0x2
    4014:	bfe080e7          	jalr	-1026(ra) # 5c0e <close>
  if(chdir("dirfile") == 0){
    4018:	00004517          	auipc	a0,0x4
    401c:	ae050513          	addi	a0,a0,-1312 # 7af8 <malloc+0x1acc>
    4020:	00002097          	auipc	ra,0x2
    4024:	c36080e7          	jalr	-970(ra) # 5c56 <chdir>
    4028:	cd6d                	beqz	a0,4122 <dirfile+0x138>
  fd = open("dirfile/xx", 0);
    402a:	4581                	li	a1,0
    402c:	00004517          	auipc	a0,0x4
    4030:	b1450513          	addi	a0,a0,-1260 # 7b40 <malloc+0x1b14>
    4034:	00002097          	auipc	ra,0x2
    4038:	bf2080e7          	jalr	-1038(ra) # 5c26 <open>
  if(fd >= 0){
    403c:	10055163          	bgez	a0,413e <dirfile+0x154>
  fd = open("dirfile/xx", O_CREATE);
    4040:	20000593          	li	a1,512
    4044:	00004517          	auipc	a0,0x4
    4048:	afc50513          	addi	a0,a0,-1284 # 7b40 <malloc+0x1b14>
    404c:	00002097          	auipc	ra,0x2
    4050:	bda080e7          	jalr	-1062(ra) # 5c26 <open>
  if(fd >= 0){
    4054:	10055363          	bgez	a0,415a <dirfile+0x170>
  if(mkdir("dirfile/xx") == 0){
    4058:	00004517          	auipc	a0,0x4
    405c:	ae850513          	addi	a0,a0,-1304 # 7b40 <malloc+0x1b14>
    4060:	00002097          	auipc	ra,0x2
    4064:	bee080e7          	jalr	-1042(ra) # 5c4e <mkdir>
    4068:	10050763          	beqz	a0,4176 <dirfile+0x18c>
  if(unlink("dirfile/xx") == 0){
    406c:	00004517          	auipc	a0,0x4
    4070:	ad450513          	addi	a0,a0,-1324 # 7b40 <malloc+0x1b14>
    4074:	00002097          	auipc	ra,0x2
    4078:	bc2080e7          	jalr	-1086(ra) # 5c36 <unlink>
    407c:	10050b63          	beqz	a0,4192 <dirfile+0x1a8>
  if(link("README", "dirfile/xx") == 0){
    4080:	00004597          	auipc	a1,0x4
    4084:	ac058593          	addi	a1,a1,-1344 # 7b40 <malloc+0x1b14>
    4088:	00002517          	auipc	a0,0x2
    408c:	2b850513          	addi	a0,a0,696 # 6340 <malloc+0x314>
    4090:	00002097          	auipc	ra,0x2
    4094:	bb6080e7          	jalr	-1098(ra) # 5c46 <link>
    4098:	10050b63          	beqz	a0,41ae <dirfile+0x1c4>
  if(unlink("dirfile") != 0){
    409c:	00004517          	auipc	a0,0x4
    40a0:	a5c50513          	addi	a0,a0,-1444 # 7af8 <malloc+0x1acc>
    40a4:	00002097          	auipc	ra,0x2
    40a8:	b92080e7          	jalr	-1134(ra) # 5c36 <unlink>
    40ac:	10051f63          	bnez	a0,41ca <dirfile+0x1e0>
  fd = open(".", O_RDWR);
    40b0:	4589                	li	a1,2
    40b2:	00002517          	auipc	a0,0x2
    40b6:	79e50513          	addi	a0,a0,1950 # 6850 <malloc+0x824>
    40ba:	00002097          	auipc	ra,0x2
    40be:	b6c080e7          	jalr	-1172(ra) # 5c26 <open>
  if(fd >= 0){
    40c2:	12055263          	bgez	a0,41e6 <dirfile+0x1fc>
  fd = open(".", 0);
    40c6:	4581                	li	a1,0
    40c8:	00002517          	auipc	a0,0x2
    40cc:	78850513          	addi	a0,a0,1928 # 6850 <malloc+0x824>
    40d0:	00002097          	auipc	ra,0x2
    40d4:	b56080e7          	jalr	-1194(ra) # 5c26 <open>
    40d8:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    40da:	4605                	li	a2,1
    40dc:	00002597          	auipc	a1,0x2
    40e0:	0fc58593          	addi	a1,a1,252 # 61d8 <malloc+0x1ac>
    40e4:	00002097          	auipc	ra,0x2
    40e8:	b22080e7          	jalr	-1246(ra) # 5c06 <write>
    40ec:	10a04b63          	bgtz	a0,4202 <dirfile+0x218>
  close(fd);
    40f0:	8526                	mv	a0,s1
    40f2:	00002097          	auipc	ra,0x2
    40f6:	b1c080e7          	jalr	-1252(ra) # 5c0e <close>
}
    40fa:	60e2                	ld	ra,24(sp)
    40fc:	6442                	ld	s0,16(sp)
    40fe:	64a2                	ld	s1,8(sp)
    4100:	6902                	ld	s2,0(sp)
    4102:	6105                	addi	sp,sp,32
    4104:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    4106:	85ca                	mv	a1,s2
    4108:	00004517          	auipc	a0,0x4
    410c:	9f850513          	addi	a0,a0,-1544 # 7b00 <malloc+0x1ad4>
    4110:	00002097          	auipc	ra,0x2
    4114:	e5e080e7          	jalr	-418(ra) # 5f6e <printf>
    exit(1);
    4118:	4505                	li	a0,1
    411a:	00002097          	auipc	ra,0x2
    411e:	acc080e7          	jalr	-1332(ra) # 5be6 <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    4122:	85ca                	mv	a1,s2
    4124:	00004517          	auipc	a0,0x4
    4128:	9fc50513          	addi	a0,a0,-1540 # 7b20 <malloc+0x1af4>
    412c:	00002097          	auipc	ra,0x2
    4130:	e42080e7          	jalr	-446(ra) # 5f6e <printf>
    exit(1);
    4134:	4505                	li	a0,1
    4136:	00002097          	auipc	ra,0x2
    413a:	ab0080e7          	jalr	-1360(ra) # 5be6 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    413e:	85ca                	mv	a1,s2
    4140:	00004517          	auipc	a0,0x4
    4144:	a1050513          	addi	a0,a0,-1520 # 7b50 <malloc+0x1b24>
    4148:	00002097          	auipc	ra,0x2
    414c:	e26080e7          	jalr	-474(ra) # 5f6e <printf>
    exit(1);
    4150:	4505                	li	a0,1
    4152:	00002097          	auipc	ra,0x2
    4156:	a94080e7          	jalr	-1388(ra) # 5be6 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    415a:	85ca                	mv	a1,s2
    415c:	00004517          	auipc	a0,0x4
    4160:	9f450513          	addi	a0,a0,-1548 # 7b50 <malloc+0x1b24>
    4164:	00002097          	auipc	ra,0x2
    4168:	e0a080e7          	jalr	-502(ra) # 5f6e <printf>
    exit(1);
    416c:	4505                	li	a0,1
    416e:	00002097          	auipc	ra,0x2
    4172:	a78080e7          	jalr	-1416(ra) # 5be6 <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    4176:	85ca                	mv	a1,s2
    4178:	00004517          	auipc	a0,0x4
    417c:	a0050513          	addi	a0,a0,-1536 # 7b78 <malloc+0x1b4c>
    4180:	00002097          	auipc	ra,0x2
    4184:	dee080e7          	jalr	-530(ra) # 5f6e <printf>
    exit(1);
    4188:	4505                	li	a0,1
    418a:	00002097          	auipc	ra,0x2
    418e:	a5c080e7          	jalr	-1444(ra) # 5be6 <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    4192:	85ca                	mv	a1,s2
    4194:	00004517          	auipc	a0,0x4
    4198:	a0c50513          	addi	a0,a0,-1524 # 7ba0 <malloc+0x1b74>
    419c:	00002097          	auipc	ra,0x2
    41a0:	dd2080e7          	jalr	-558(ra) # 5f6e <printf>
    exit(1);
    41a4:	4505                	li	a0,1
    41a6:	00002097          	auipc	ra,0x2
    41aa:	a40080e7          	jalr	-1472(ra) # 5be6 <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    41ae:	85ca                	mv	a1,s2
    41b0:	00004517          	auipc	a0,0x4
    41b4:	a1850513          	addi	a0,a0,-1512 # 7bc8 <malloc+0x1b9c>
    41b8:	00002097          	auipc	ra,0x2
    41bc:	db6080e7          	jalr	-586(ra) # 5f6e <printf>
    exit(1);
    41c0:	4505                	li	a0,1
    41c2:	00002097          	auipc	ra,0x2
    41c6:	a24080e7          	jalr	-1500(ra) # 5be6 <exit>
    printf("%s: unlink dirfile failed!\n", s);
    41ca:	85ca                	mv	a1,s2
    41cc:	00004517          	auipc	a0,0x4
    41d0:	a2450513          	addi	a0,a0,-1500 # 7bf0 <malloc+0x1bc4>
    41d4:	00002097          	auipc	ra,0x2
    41d8:	d9a080e7          	jalr	-614(ra) # 5f6e <printf>
    exit(1);
    41dc:	4505                	li	a0,1
    41de:	00002097          	auipc	ra,0x2
    41e2:	a08080e7          	jalr	-1528(ra) # 5be6 <exit>
    printf("%s: open . for writing succeeded!\n", s);
    41e6:	85ca                	mv	a1,s2
    41e8:	00004517          	auipc	a0,0x4
    41ec:	a2850513          	addi	a0,a0,-1496 # 7c10 <malloc+0x1be4>
    41f0:	00002097          	auipc	ra,0x2
    41f4:	d7e080e7          	jalr	-642(ra) # 5f6e <printf>
    exit(1);
    41f8:	4505                	li	a0,1
    41fa:	00002097          	auipc	ra,0x2
    41fe:	9ec080e7          	jalr	-1556(ra) # 5be6 <exit>
    printf("%s: write . succeeded!\n", s);
    4202:	85ca                	mv	a1,s2
    4204:	00004517          	auipc	a0,0x4
    4208:	a3450513          	addi	a0,a0,-1484 # 7c38 <malloc+0x1c0c>
    420c:	00002097          	auipc	ra,0x2
    4210:	d62080e7          	jalr	-670(ra) # 5f6e <printf>
    exit(1);
    4214:	4505                	li	a0,1
    4216:	00002097          	auipc	ra,0x2
    421a:	9d0080e7          	jalr	-1584(ra) # 5be6 <exit>

000000000000421e <iref>:
{
    421e:	7139                	addi	sp,sp,-64
    4220:	fc06                	sd	ra,56(sp)
    4222:	f822                	sd	s0,48(sp)
    4224:	f426                	sd	s1,40(sp)
    4226:	f04a                	sd	s2,32(sp)
    4228:	ec4e                	sd	s3,24(sp)
    422a:	e852                	sd	s4,16(sp)
    422c:	e456                	sd	s5,8(sp)
    422e:	e05a                	sd	s6,0(sp)
    4230:	0080                	addi	s0,sp,64
    4232:	8b2a                	mv	s6,a0
    4234:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    4238:	00004a17          	auipc	s4,0x4
    423c:	a18a0a13          	addi	s4,s4,-1512 # 7c50 <malloc+0x1c24>
    mkdir("");
    4240:	00003497          	auipc	s1,0x3
    4244:	51848493          	addi	s1,s1,1304 # 7758 <malloc+0x172c>
    link("README", "");
    4248:	00002a97          	auipc	s5,0x2
    424c:	0f8a8a93          	addi	s5,s5,248 # 6340 <malloc+0x314>
    fd = open("xx", O_CREATE);
    4250:	00004997          	auipc	s3,0x4
    4254:	8f898993          	addi	s3,s3,-1800 # 7b48 <malloc+0x1b1c>
    4258:	a891                	j	42ac <iref+0x8e>
      printf("%s: mkdir irefd failed\n", s);
    425a:	85da                	mv	a1,s6
    425c:	00004517          	auipc	a0,0x4
    4260:	9fc50513          	addi	a0,a0,-1540 # 7c58 <malloc+0x1c2c>
    4264:	00002097          	auipc	ra,0x2
    4268:	d0a080e7          	jalr	-758(ra) # 5f6e <printf>
      exit(1);
    426c:	4505                	li	a0,1
    426e:	00002097          	auipc	ra,0x2
    4272:	978080e7          	jalr	-1672(ra) # 5be6 <exit>
      printf("%s: chdir irefd failed\n", s);
    4276:	85da                	mv	a1,s6
    4278:	00004517          	auipc	a0,0x4
    427c:	9f850513          	addi	a0,a0,-1544 # 7c70 <malloc+0x1c44>
    4280:	00002097          	auipc	ra,0x2
    4284:	cee080e7          	jalr	-786(ra) # 5f6e <printf>
      exit(1);
    4288:	4505                	li	a0,1
    428a:	00002097          	auipc	ra,0x2
    428e:	95c080e7          	jalr	-1700(ra) # 5be6 <exit>
      close(fd);
    4292:	00002097          	auipc	ra,0x2
    4296:	97c080e7          	jalr	-1668(ra) # 5c0e <close>
    429a:	a889                	j	42ec <iref+0xce>
    unlink("xx");
    429c:	854e                	mv	a0,s3
    429e:	00002097          	auipc	ra,0x2
    42a2:	998080e7          	jalr	-1640(ra) # 5c36 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    42a6:	397d                	addiw	s2,s2,-1
    42a8:	06090063          	beqz	s2,4308 <iref+0xea>
    if(mkdir("irefd") != 0){
    42ac:	8552                	mv	a0,s4
    42ae:	00002097          	auipc	ra,0x2
    42b2:	9a0080e7          	jalr	-1632(ra) # 5c4e <mkdir>
    42b6:	f155                	bnez	a0,425a <iref+0x3c>
    if(chdir("irefd") != 0){
    42b8:	8552                	mv	a0,s4
    42ba:	00002097          	auipc	ra,0x2
    42be:	99c080e7          	jalr	-1636(ra) # 5c56 <chdir>
    42c2:	f955                	bnez	a0,4276 <iref+0x58>
    mkdir("");
    42c4:	8526                	mv	a0,s1
    42c6:	00002097          	auipc	ra,0x2
    42ca:	988080e7          	jalr	-1656(ra) # 5c4e <mkdir>
    link("README", "");
    42ce:	85a6                	mv	a1,s1
    42d0:	8556                	mv	a0,s5
    42d2:	00002097          	auipc	ra,0x2
    42d6:	974080e7          	jalr	-1676(ra) # 5c46 <link>
    fd = open("", O_CREATE);
    42da:	20000593          	li	a1,512
    42de:	8526                	mv	a0,s1
    42e0:	00002097          	auipc	ra,0x2
    42e4:	946080e7          	jalr	-1722(ra) # 5c26 <open>
    if(fd >= 0)
    42e8:	fa0555e3          	bgez	a0,4292 <iref+0x74>
    fd = open("xx", O_CREATE);
    42ec:	20000593          	li	a1,512
    42f0:	854e                	mv	a0,s3
    42f2:	00002097          	auipc	ra,0x2
    42f6:	934080e7          	jalr	-1740(ra) # 5c26 <open>
    if(fd >= 0)
    42fa:	fa0541e3          	bltz	a0,429c <iref+0x7e>
      close(fd);
    42fe:	00002097          	auipc	ra,0x2
    4302:	910080e7          	jalr	-1776(ra) # 5c0e <close>
    4306:	bf59                	j	429c <iref+0x7e>
    4308:	03300493          	li	s1,51
    chdir("..");
    430c:	00003997          	auipc	s3,0x3
    4310:	16c98993          	addi	s3,s3,364 # 7478 <malloc+0x144c>
    unlink("irefd");
    4314:	00004917          	auipc	s2,0x4
    4318:	93c90913          	addi	s2,s2,-1732 # 7c50 <malloc+0x1c24>
    chdir("..");
    431c:	854e                	mv	a0,s3
    431e:	00002097          	auipc	ra,0x2
    4322:	938080e7          	jalr	-1736(ra) # 5c56 <chdir>
    unlink("irefd");
    4326:	854a                	mv	a0,s2
    4328:	00002097          	auipc	ra,0x2
    432c:	90e080e7          	jalr	-1778(ra) # 5c36 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    4330:	34fd                	addiw	s1,s1,-1
    4332:	f4ed                	bnez	s1,431c <iref+0xfe>
  chdir("/");
    4334:	00003517          	auipc	a0,0x3
    4338:	0ec50513          	addi	a0,a0,236 # 7420 <malloc+0x13f4>
    433c:	00002097          	auipc	ra,0x2
    4340:	91a080e7          	jalr	-1766(ra) # 5c56 <chdir>
}
    4344:	70e2                	ld	ra,56(sp)
    4346:	7442                	ld	s0,48(sp)
    4348:	74a2                	ld	s1,40(sp)
    434a:	7902                	ld	s2,32(sp)
    434c:	69e2                	ld	s3,24(sp)
    434e:	6a42                	ld	s4,16(sp)
    4350:	6aa2                	ld	s5,8(sp)
    4352:	6b02                	ld	s6,0(sp)
    4354:	6121                	addi	sp,sp,64
    4356:	8082                	ret

0000000000004358 <openiputtest>:
{
    4358:	7179                	addi	sp,sp,-48
    435a:	f406                	sd	ra,40(sp)
    435c:	f022                	sd	s0,32(sp)
    435e:	ec26                	sd	s1,24(sp)
    4360:	1800                	addi	s0,sp,48
    4362:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    4364:	00004517          	auipc	a0,0x4
    4368:	92450513          	addi	a0,a0,-1756 # 7c88 <malloc+0x1c5c>
    436c:	00002097          	auipc	ra,0x2
    4370:	8e2080e7          	jalr	-1822(ra) # 5c4e <mkdir>
    4374:	04054263          	bltz	a0,43b8 <openiputtest+0x60>
  pid = fork();
    4378:	00002097          	auipc	ra,0x2
    437c:	866080e7          	jalr	-1946(ra) # 5bde <fork>
  if(pid < 0){
    4380:	04054a63          	bltz	a0,43d4 <openiputtest+0x7c>
  if(pid == 0){
    4384:	e93d                	bnez	a0,43fa <openiputtest+0xa2>
    int fd = open("oidir", O_RDWR);
    4386:	4589                	li	a1,2
    4388:	00004517          	auipc	a0,0x4
    438c:	90050513          	addi	a0,a0,-1792 # 7c88 <malloc+0x1c5c>
    4390:	00002097          	auipc	ra,0x2
    4394:	896080e7          	jalr	-1898(ra) # 5c26 <open>
    if(fd >= 0){
    4398:	04054c63          	bltz	a0,43f0 <openiputtest+0x98>
      printf("%s: open directory for write succeeded\n", s);
    439c:	85a6                	mv	a1,s1
    439e:	00004517          	auipc	a0,0x4
    43a2:	90a50513          	addi	a0,a0,-1782 # 7ca8 <malloc+0x1c7c>
    43a6:	00002097          	auipc	ra,0x2
    43aa:	bc8080e7          	jalr	-1080(ra) # 5f6e <printf>
      exit(1);
    43ae:	4505                	li	a0,1
    43b0:	00002097          	auipc	ra,0x2
    43b4:	836080e7          	jalr	-1994(ra) # 5be6 <exit>
    printf("%s: mkdir oidir failed\n", s);
    43b8:	85a6                	mv	a1,s1
    43ba:	00004517          	auipc	a0,0x4
    43be:	8d650513          	addi	a0,a0,-1834 # 7c90 <malloc+0x1c64>
    43c2:	00002097          	auipc	ra,0x2
    43c6:	bac080e7          	jalr	-1108(ra) # 5f6e <printf>
    exit(1);
    43ca:	4505                	li	a0,1
    43cc:	00002097          	auipc	ra,0x2
    43d0:	81a080e7          	jalr	-2022(ra) # 5be6 <exit>
    printf("%s: fork failed\n", s);
    43d4:	85a6                	mv	a1,s1
    43d6:	00002517          	auipc	a0,0x2
    43da:	61a50513          	addi	a0,a0,1562 # 69f0 <malloc+0x9c4>
    43de:	00002097          	auipc	ra,0x2
    43e2:	b90080e7          	jalr	-1136(ra) # 5f6e <printf>
    exit(1);
    43e6:	4505                	li	a0,1
    43e8:	00001097          	auipc	ra,0x1
    43ec:	7fe080e7          	jalr	2046(ra) # 5be6 <exit>
    exit(0);
    43f0:	4501                	li	a0,0
    43f2:	00001097          	auipc	ra,0x1
    43f6:	7f4080e7          	jalr	2036(ra) # 5be6 <exit>
  sleep(1);
    43fa:	4505                	li	a0,1
    43fc:	00002097          	auipc	ra,0x2
    4400:	87a080e7          	jalr	-1926(ra) # 5c76 <sleep>
  if(unlink("oidir") != 0){
    4404:	00004517          	auipc	a0,0x4
    4408:	88450513          	addi	a0,a0,-1916 # 7c88 <malloc+0x1c5c>
    440c:	00002097          	auipc	ra,0x2
    4410:	82a080e7          	jalr	-2006(ra) # 5c36 <unlink>
    4414:	cd19                	beqz	a0,4432 <openiputtest+0xda>
    printf("%s: unlink failed\n", s);
    4416:	85a6                	mv	a1,s1
    4418:	00002517          	auipc	a0,0x2
    441c:	7c850513          	addi	a0,a0,1992 # 6be0 <malloc+0xbb4>
    4420:	00002097          	auipc	ra,0x2
    4424:	b4e080e7          	jalr	-1202(ra) # 5f6e <printf>
    exit(1);
    4428:	4505                	li	a0,1
    442a:	00001097          	auipc	ra,0x1
    442e:	7bc080e7          	jalr	1980(ra) # 5be6 <exit>
  wait(&xstatus);
    4432:	fdc40513          	addi	a0,s0,-36
    4436:	00001097          	auipc	ra,0x1
    443a:	7b8080e7          	jalr	1976(ra) # 5bee <wait>
  exit(xstatus);
    443e:	fdc42503          	lw	a0,-36(s0)
    4442:	00001097          	auipc	ra,0x1
    4446:	7a4080e7          	jalr	1956(ra) # 5be6 <exit>

000000000000444a <forkforkfork>:
{
    444a:	1101                	addi	sp,sp,-32
    444c:	ec06                	sd	ra,24(sp)
    444e:	e822                	sd	s0,16(sp)
    4450:	e426                	sd	s1,8(sp)
    4452:	1000                	addi	s0,sp,32
    4454:	84aa                	mv	s1,a0
  unlink("stopforking");
    4456:	00004517          	auipc	a0,0x4
    445a:	87a50513          	addi	a0,a0,-1926 # 7cd0 <malloc+0x1ca4>
    445e:	00001097          	auipc	ra,0x1
    4462:	7d8080e7          	jalr	2008(ra) # 5c36 <unlink>
  int pid = fork();
    4466:	00001097          	auipc	ra,0x1
    446a:	778080e7          	jalr	1912(ra) # 5bde <fork>
  if(pid < 0){
    446e:	04054563          	bltz	a0,44b8 <forkforkfork+0x6e>
  if(pid == 0){
    4472:	c12d                	beqz	a0,44d4 <forkforkfork+0x8a>
  sleep(20); // two seconds
    4474:	4551                	li	a0,20
    4476:	00002097          	auipc	ra,0x2
    447a:	800080e7          	jalr	-2048(ra) # 5c76 <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
    447e:	20200593          	li	a1,514
    4482:	00004517          	auipc	a0,0x4
    4486:	84e50513          	addi	a0,a0,-1970 # 7cd0 <malloc+0x1ca4>
    448a:	00001097          	auipc	ra,0x1
    448e:	79c080e7          	jalr	1948(ra) # 5c26 <open>
    4492:	00001097          	auipc	ra,0x1
    4496:	77c080e7          	jalr	1916(ra) # 5c0e <close>
  wait(0);
    449a:	4501                	li	a0,0
    449c:	00001097          	auipc	ra,0x1
    44a0:	752080e7          	jalr	1874(ra) # 5bee <wait>
  sleep(10); // one second
    44a4:	4529                	li	a0,10
    44a6:	00001097          	auipc	ra,0x1
    44aa:	7d0080e7          	jalr	2000(ra) # 5c76 <sleep>
}
    44ae:	60e2                	ld	ra,24(sp)
    44b0:	6442                	ld	s0,16(sp)
    44b2:	64a2                	ld	s1,8(sp)
    44b4:	6105                	addi	sp,sp,32
    44b6:	8082                	ret
    printf("%s: fork failed", s);
    44b8:	85a6                	mv	a1,s1
    44ba:	00002517          	auipc	a0,0x2
    44be:	6f650513          	addi	a0,a0,1782 # 6bb0 <malloc+0xb84>
    44c2:	00002097          	auipc	ra,0x2
    44c6:	aac080e7          	jalr	-1364(ra) # 5f6e <printf>
    exit(1);
    44ca:	4505                	li	a0,1
    44cc:	00001097          	auipc	ra,0x1
    44d0:	71a080e7          	jalr	1818(ra) # 5be6 <exit>
      int fd = open("stopforking", 0);
    44d4:	00003497          	auipc	s1,0x3
    44d8:	7fc48493          	addi	s1,s1,2044 # 7cd0 <malloc+0x1ca4>
    44dc:	4581                	li	a1,0
    44de:	8526                	mv	a0,s1
    44e0:	00001097          	auipc	ra,0x1
    44e4:	746080e7          	jalr	1862(ra) # 5c26 <open>
      if(fd >= 0){
    44e8:	02055463          	bgez	a0,4510 <forkforkfork+0xc6>
      if(fork() < 0){
    44ec:	00001097          	auipc	ra,0x1
    44f0:	6f2080e7          	jalr	1778(ra) # 5bde <fork>
    44f4:	fe0554e3          	bgez	a0,44dc <forkforkfork+0x92>
        close(open("stopforking", O_CREATE|O_RDWR));
    44f8:	20200593          	li	a1,514
    44fc:	8526                	mv	a0,s1
    44fe:	00001097          	auipc	ra,0x1
    4502:	728080e7          	jalr	1832(ra) # 5c26 <open>
    4506:	00001097          	auipc	ra,0x1
    450a:	708080e7          	jalr	1800(ra) # 5c0e <close>
    450e:	b7f9                	j	44dc <forkforkfork+0x92>
        exit(0);
    4510:	4501                	li	a0,0
    4512:	00001097          	auipc	ra,0x1
    4516:	6d4080e7          	jalr	1748(ra) # 5be6 <exit>

000000000000451a <killstatus>:
{
    451a:	7139                	addi	sp,sp,-64
    451c:	fc06                	sd	ra,56(sp)
    451e:	f822                	sd	s0,48(sp)
    4520:	f426                	sd	s1,40(sp)
    4522:	f04a                	sd	s2,32(sp)
    4524:	ec4e                	sd	s3,24(sp)
    4526:	e852                	sd	s4,16(sp)
    4528:	0080                	addi	s0,sp,64
    452a:	8a2a                	mv	s4,a0
    452c:	06400913          	li	s2,100
    if(xst != -1) {
    4530:	59fd                	li	s3,-1
    int pid1 = fork();
    4532:	00001097          	auipc	ra,0x1
    4536:	6ac080e7          	jalr	1708(ra) # 5bde <fork>
    453a:	84aa                	mv	s1,a0
    if(pid1 < 0){
    453c:	02054f63          	bltz	a0,457a <killstatus+0x60>
    if(pid1 == 0){
    4540:	c939                	beqz	a0,4596 <killstatus+0x7c>
    sleep(1);
    4542:	4505                	li	a0,1
    4544:	00001097          	auipc	ra,0x1
    4548:	732080e7          	jalr	1842(ra) # 5c76 <sleep>
    kill(pid1);
    454c:	8526                	mv	a0,s1
    454e:	00001097          	auipc	ra,0x1
    4552:	6c8080e7          	jalr	1736(ra) # 5c16 <kill>
    wait(&xst);
    4556:	fcc40513          	addi	a0,s0,-52
    455a:	00001097          	auipc	ra,0x1
    455e:	694080e7          	jalr	1684(ra) # 5bee <wait>
    if(xst != -1) {
    4562:	fcc42783          	lw	a5,-52(s0)
    4566:	03379d63          	bne	a5,s3,45a0 <killstatus+0x86>
  for(int i = 0; i < 100; i++){
    456a:	397d                	addiw	s2,s2,-1
    456c:	fc0913e3          	bnez	s2,4532 <killstatus+0x18>
  exit(0);
    4570:	4501                	li	a0,0
    4572:	00001097          	auipc	ra,0x1
    4576:	674080e7          	jalr	1652(ra) # 5be6 <exit>
      printf("%s: fork failed\n", s);
    457a:	85d2                	mv	a1,s4
    457c:	00002517          	auipc	a0,0x2
    4580:	47450513          	addi	a0,a0,1140 # 69f0 <malloc+0x9c4>
    4584:	00002097          	auipc	ra,0x2
    4588:	9ea080e7          	jalr	-1558(ra) # 5f6e <printf>
      exit(1);
    458c:	4505                	li	a0,1
    458e:	00001097          	auipc	ra,0x1
    4592:	658080e7          	jalr	1624(ra) # 5be6 <exit>
        getpid();
    4596:	00001097          	auipc	ra,0x1
    459a:	6d0080e7          	jalr	1744(ra) # 5c66 <getpid>
      while(1) {
    459e:	bfe5                	j	4596 <killstatus+0x7c>
       printf("%s: status should be -1\n", s);
    45a0:	85d2                	mv	a1,s4
    45a2:	00003517          	auipc	a0,0x3
    45a6:	73e50513          	addi	a0,a0,1854 # 7ce0 <malloc+0x1cb4>
    45aa:	00002097          	auipc	ra,0x2
    45ae:	9c4080e7          	jalr	-1596(ra) # 5f6e <printf>
       exit(1);
    45b2:	4505                	li	a0,1
    45b4:	00001097          	auipc	ra,0x1
    45b8:	632080e7          	jalr	1586(ra) # 5be6 <exit>

00000000000045bc <preempt>:
{
    45bc:	7139                	addi	sp,sp,-64
    45be:	fc06                	sd	ra,56(sp)
    45c0:	f822                	sd	s0,48(sp)
    45c2:	f426                	sd	s1,40(sp)
    45c4:	f04a                	sd	s2,32(sp)
    45c6:	ec4e                	sd	s3,24(sp)
    45c8:	e852                	sd	s4,16(sp)
    45ca:	0080                	addi	s0,sp,64
    45cc:	84aa                	mv	s1,a0
  pid1 = fork();
    45ce:	00001097          	auipc	ra,0x1
    45d2:	610080e7          	jalr	1552(ra) # 5bde <fork>
  if(pid1 < 0) {
    45d6:	00054563          	bltz	a0,45e0 <preempt+0x24>
    45da:	8a2a                	mv	s4,a0
  if(pid1 == 0)
    45dc:	e105                	bnez	a0,45fc <preempt+0x40>
    for(;;)
    45de:	a001                	j	45de <preempt+0x22>
    printf("%s: fork failed", s);
    45e0:	85a6                	mv	a1,s1
    45e2:	00002517          	auipc	a0,0x2
    45e6:	5ce50513          	addi	a0,a0,1486 # 6bb0 <malloc+0xb84>
    45ea:	00002097          	auipc	ra,0x2
    45ee:	984080e7          	jalr	-1660(ra) # 5f6e <printf>
    exit(1);
    45f2:	4505                	li	a0,1
    45f4:	00001097          	auipc	ra,0x1
    45f8:	5f2080e7          	jalr	1522(ra) # 5be6 <exit>
  pid2 = fork();
    45fc:	00001097          	auipc	ra,0x1
    4600:	5e2080e7          	jalr	1506(ra) # 5bde <fork>
    4604:	89aa                	mv	s3,a0
  if(pid2 < 0) {
    4606:	00054463          	bltz	a0,460e <preempt+0x52>
  if(pid2 == 0)
    460a:	e105                	bnez	a0,462a <preempt+0x6e>
    for(;;)
    460c:	a001                	j	460c <preempt+0x50>
    printf("%s: fork failed\n", s);
    460e:	85a6                	mv	a1,s1
    4610:	00002517          	auipc	a0,0x2
    4614:	3e050513          	addi	a0,a0,992 # 69f0 <malloc+0x9c4>
    4618:	00002097          	auipc	ra,0x2
    461c:	956080e7          	jalr	-1706(ra) # 5f6e <printf>
    exit(1);
    4620:	4505                	li	a0,1
    4622:	00001097          	auipc	ra,0x1
    4626:	5c4080e7          	jalr	1476(ra) # 5be6 <exit>
  pipe(pfds);
    462a:	fc840513          	addi	a0,s0,-56
    462e:	00001097          	auipc	ra,0x1
    4632:	5c8080e7          	jalr	1480(ra) # 5bf6 <pipe>
  pid3 = fork();
    4636:	00001097          	auipc	ra,0x1
    463a:	5a8080e7          	jalr	1448(ra) # 5bde <fork>
    463e:	892a                	mv	s2,a0
  if(pid3 < 0) {
    4640:	02054e63          	bltz	a0,467c <preempt+0xc0>
  if(pid3 == 0){
    4644:	e525                	bnez	a0,46ac <preempt+0xf0>
    close(pfds[0]);
    4646:	fc842503          	lw	a0,-56(s0)
    464a:	00001097          	auipc	ra,0x1
    464e:	5c4080e7          	jalr	1476(ra) # 5c0e <close>
    if(write(pfds[1], "x", 1) != 1)
    4652:	4605                	li	a2,1
    4654:	00002597          	auipc	a1,0x2
    4658:	b8458593          	addi	a1,a1,-1148 # 61d8 <malloc+0x1ac>
    465c:	fcc42503          	lw	a0,-52(s0)
    4660:	00001097          	auipc	ra,0x1
    4664:	5a6080e7          	jalr	1446(ra) # 5c06 <write>
    4668:	4785                	li	a5,1
    466a:	02f51763          	bne	a0,a5,4698 <preempt+0xdc>
    close(pfds[1]);
    466e:	fcc42503          	lw	a0,-52(s0)
    4672:	00001097          	auipc	ra,0x1
    4676:	59c080e7          	jalr	1436(ra) # 5c0e <close>
    for(;;)
    467a:	a001                	j	467a <preempt+0xbe>
     printf("%s: fork failed\n", s);
    467c:	85a6                	mv	a1,s1
    467e:	00002517          	auipc	a0,0x2
    4682:	37250513          	addi	a0,a0,882 # 69f0 <malloc+0x9c4>
    4686:	00002097          	auipc	ra,0x2
    468a:	8e8080e7          	jalr	-1816(ra) # 5f6e <printf>
     exit(1);
    468e:	4505                	li	a0,1
    4690:	00001097          	auipc	ra,0x1
    4694:	556080e7          	jalr	1366(ra) # 5be6 <exit>
      printf("%s: preempt write error", s);
    4698:	85a6                	mv	a1,s1
    469a:	00003517          	auipc	a0,0x3
    469e:	66650513          	addi	a0,a0,1638 # 7d00 <malloc+0x1cd4>
    46a2:	00002097          	auipc	ra,0x2
    46a6:	8cc080e7          	jalr	-1844(ra) # 5f6e <printf>
    46aa:	b7d1                	j	466e <preempt+0xb2>
  close(pfds[1]);
    46ac:	fcc42503          	lw	a0,-52(s0)
    46b0:	00001097          	auipc	ra,0x1
    46b4:	55e080e7          	jalr	1374(ra) # 5c0e <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    46b8:	660d                	lui	a2,0x3
    46ba:	00008597          	auipc	a1,0x8
    46be:	5be58593          	addi	a1,a1,1470 # cc78 <buf>
    46c2:	fc842503          	lw	a0,-56(s0)
    46c6:	00001097          	auipc	ra,0x1
    46ca:	538080e7          	jalr	1336(ra) # 5bfe <read>
    46ce:	4785                	li	a5,1
    46d0:	02f50363          	beq	a0,a5,46f6 <preempt+0x13a>
    printf("%s: preempt read error", s);
    46d4:	85a6                	mv	a1,s1
    46d6:	00003517          	auipc	a0,0x3
    46da:	64250513          	addi	a0,a0,1602 # 7d18 <malloc+0x1cec>
    46de:	00002097          	auipc	ra,0x2
    46e2:	890080e7          	jalr	-1904(ra) # 5f6e <printf>
}
    46e6:	70e2                	ld	ra,56(sp)
    46e8:	7442                	ld	s0,48(sp)
    46ea:	74a2                	ld	s1,40(sp)
    46ec:	7902                	ld	s2,32(sp)
    46ee:	69e2                	ld	s3,24(sp)
    46f0:	6a42                	ld	s4,16(sp)
    46f2:	6121                	addi	sp,sp,64
    46f4:	8082                	ret
  close(pfds[0]);
    46f6:	fc842503          	lw	a0,-56(s0)
    46fa:	00001097          	auipc	ra,0x1
    46fe:	514080e7          	jalr	1300(ra) # 5c0e <close>
  printf("kill... ");
    4702:	00003517          	auipc	a0,0x3
    4706:	62e50513          	addi	a0,a0,1582 # 7d30 <malloc+0x1d04>
    470a:	00002097          	auipc	ra,0x2
    470e:	864080e7          	jalr	-1948(ra) # 5f6e <printf>
  kill(pid1);
    4712:	8552                	mv	a0,s4
    4714:	00001097          	auipc	ra,0x1
    4718:	502080e7          	jalr	1282(ra) # 5c16 <kill>
  kill(pid2);
    471c:	854e                	mv	a0,s3
    471e:	00001097          	auipc	ra,0x1
    4722:	4f8080e7          	jalr	1272(ra) # 5c16 <kill>
  kill(pid3);
    4726:	854a                	mv	a0,s2
    4728:	00001097          	auipc	ra,0x1
    472c:	4ee080e7          	jalr	1262(ra) # 5c16 <kill>
  printf("wait... ");
    4730:	00003517          	auipc	a0,0x3
    4734:	61050513          	addi	a0,a0,1552 # 7d40 <malloc+0x1d14>
    4738:	00002097          	auipc	ra,0x2
    473c:	836080e7          	jalr	-1994(ra) # 5f6e <printf>
  wait(0);
    4740:	4501                	li	a0,0
    4742:	00001097          	auipc	ra,0x1
    4746:	4ac080e7          	jalr	1196(ra) # 5bee <wait>
  wait(0);
    474a:	4501                	li	a0,0
    474c:	00001097          	auipc	ra,0x1
    4750:	4a2080e7          	jalr	1186(ra) # 5bee <wait>
  wait(0);
    4754:	4501                	li	a0,0
    4756:	00001097          	auipc	ra,0x1
    475a:	498080e7          	jalr	1176(ra) # 5bee <wait>
    475e:	b761                	j	46e6 <preempt+0x12a>

0000000000004760 <reparent>:
{
    4760:	7179                	addi	sp,sp,-48
    4762:	f406                	sd	ra,40(sp)
    4764:	f022                	sd	s0,32(sp)
    4766:	ec26                	sd	s1,24(sp)
    4768:	e84a                	sd	s2,16(sp)
    476a:	e44e                	sd	s3,8(sp)
    476c:	e052                	sd	s4,0(sp)
    476e:	1800                	addi	s0,sp,48
    4770:	89aa                	mv	s3,a0
  int master_pid = getpid();
    4772:	00001097          	auipc	ra,0x1
    4776:	4f4080e7          	jalr	1268(ra) # 5c66 <getpid>
    477a:	8a2a                	mv	s4,a0
    477c:	0c800913          	li	s2,200
    int pid = fork();
    4780:	00001097          	auipc	ra,0x1
    4784:	45e080e7          	jalr	1118(ra) # 5bde <fork>
    4788:	84aa                	mv	s1,a0
    if(pid < 0){
    478a:	02054263          	bltz	a0,47ae <reparent+0x4e>
    if(pid){
    478e:	cd21                	beqz	a0,47e6 <reparent+0x86>
      if(wait(0) != pid){
    4790:	4501                	li	a0,0
    4792:	00001097          	auipc	ra,0x1
    4796:	45c080e7          	jalr	1116(ra) # 5bee <wait>
    479a:	02951863          	bne	a0,s1,47ca <reparent+0x6a>
  for(int i = 0; i < 200; i++){
    479e:	397d                	addiw	s2,s2,-1
    47a0:	fe0910e3          	bnez	s2,4780 <reparent+0x20>
  exit(0);
    47a4:	4501                	li	a0,0
    47a6:	00001097          	auipc	ra,0x1
    47aa:	440080e7          	jalr	1088(ra) # 5be6 <exit>
      printf("%s: fork failed\n", s);
    47ae:	85ce                	mv	a1,s3
    47b0:	00002517          	auipc	a0,0x2
    47b4:	24050513          	addi	a0,a0,576 # 69f0 <malloc+0x9c4>
    47b8:	00001097          	auipc	ra,0x1
    47bc:	7b6080e7          	jalr	1974(ra) # 5f6e <printf>
      exit(1);
    47c0:	4505                	li	a0,1
    47c2:	00001097          	auipc	ra,0x1
    47c6:	424080e7          	jalr	1060(ra) # 5be6 <exit>
        printf("%s: wait wrong pid\n", s);
    47ca:	85ce                	mv	a1,s3
    47cc:	00002517          	auipc	a0,0x2
    47d0:	3ac50513          	addi	a0,a0,940 # 6b78 <malloc+0xb4c>
    47d4:	00001097          	auipc	ra,0x1
    47d8:	79a080e7          	jalr	1946(ra) # 5f6e <printf>
        exit(1);
    47dc:	4505                	li	a0,1
    47de:	00001097          	auipc	ra,0x1
    47e2:	408080e7          	jalr	1032(ra) # 5be6 <exit>
      int pid2 = fork();
    47e6:	00001097          	auipc	ra,0x1
    47ea:	3f8080e7          	jalr	1016(ra) # 5bde <fork>
      if(pid2 < 0){
    47ee:	00054763          	bltz	a0,47fc <reparent+0x9c>
      exit(0);
    47f2:	4501                	li	a0,0
    47f4:	00001097          	auipc	ra,0x1
    47f8:	3f2080e7          	jalr	1010(ra) # 5be6 <exit>
        kill(master_pid);
    47fc:	8552                	mv	a0,s4
    47fe:	00001097          	auipc	ra,0x1
    4802:	418080e7          	jalr	1048(ra) # 5c16 <kill>
        exit(1);
    4806:	4505                	li	a0,1
    4808:	00001097          	auipc	ra,0x1
    480c:	3de080e7          	jalr	990(ra) # 5be6 <exit>

0000000000004810 <sbrkfail>:
{
    4810:	7119                	addi	sp,sp,-128
    4812:	fc86                	sd	ra,120(sp)
    4814:	f8a2                	sd	s0,112(sp)
    4816:	f4a6                	sd	s1,104(sp)
    4818:	f0ca                	sd	s2,96(sp)
    481a:	ecce                	sd	s3,88(sp)
    481c:	e8d2                	sd	s4,80(sp)
    481e:	e4d6                	sd	s5,72(sp)
    4820:	0100                	addi	s0,sp,128
    4822:	892a                	mv	s2,a0
  if(pipe(fds) != 0){
    4824:	fb040513          	addi	a0,s0,-80
    4828:	00001097          	auipc	ra,0x1
    482c:	3ce080e7          	jalr	974(ra) # 5bf6 <pipe>
    4830:	e901                	bnez	a0,4840 <sbrkfail+0x30>
    4832:	f8040493          	addi	s1,s0,-128
    4836:	fa840a13          	addi	s4,s0,-88
    483a:	89a6                	mv	s3,s1
    if(pids[i] != -1)
    483c:	5afd                	li	s5,-1
    483e:	a08d                	j	48a0 <sbrkfail+0x90>
    printf("%s: pipe() failed\n", s);
    4840:	85ca                	mv	a1,s2
    4842:	00002517          	auipc	a0,0x2
    4846:	2b650513          	addi	a0,a0,694 # 6af8 <malloc+0xacc>
    484a:	00001097          	auipc	ra,0x1
    484e:	724080e7          	jalr	1828(ra) # 5f6e <printf>
    exit(1);
    4852:	4505                	li	a0,1
    4854:	00001097          	auipc	ra,0x1
    4858:	392080e7          	jalr	914(ra) # 5be6 <exit>
      sbrk(BIG - (uint64)sbrk(0));
    485c:	4501                	li	a0,0
    485e:	00001097          	auipc	ra,0x1
    4862:	410080e7          	jalr	1040(ra) # 5c6e <sbrk>
    4866:	064007b7          	lui	a5,0x6400
    486a:	40a7853b          	subw	a0,a5,a0
    486e:	00001097          	auipc	ra,0x1
    4872:	400080e7          	jalr	1024(ra) # 5c6e <sbrk>
      write(fds[1], "x", 1);
    4876:	4605                	li	a2,1
    4878:	00002597          	auipc	a1,0x2
    487c:	96058593          	addi	a1,a1,-1696 # 61d8 <malloc+0x1ac>
    4880:	fb442503          	lw	a0,-76(s0)
    4884:	00001097          	auipc	ra,0x1
    4888:	382080e7          	jalr	898(ra) # 5c06 <write>
      for(;;) sleep(1000);
    488c:	3e800513          	li	a0,1000
    4890:	00001097          	auipc	ra,0x1
    4894:	3e6080e7          	jalr	998(ra) # 5c76 <sleep>
    4898:	bfd5                	j	488c <sbrkfail+0x7c>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    489a:	0991                	addi	s3,s3,4
    489c:	03498563          	beq	s3,s4,48c6 <sbrkfail+0xb6>
    if((pids[i] = fork()) == 0){
    48a0:	00001097          	auipc	ra,0x1
    48a4:	33e080e7          	jalr	830(ra) # 5bde <fork>
    48a8:	00a9a023          	sw	a0,0(s3)
    48ac:	d945                	beqz	a0,485c <sbrkfail+0x4c>
    if(pids[i] != -1)
    48ae:	ff5506e3          	beq	a0,s5,489a <sbrkfail+0x8a>
      read(fds[0], &scratch, 1);
    48b2:	4605                	li	a2,1
    48b4:	faf40593          	addi	a1,s0,-81
    48b8:	fb042503          	lw	a0,-80(s0)
    48bc:	00001097          	auipc	ra,0x1
    48c0:	342080e7          	jalr	834(ra) # 5bfe <read>
    48c4:	bfd9                	j	489a <sbrkfail+0x8a>
  c = sbrk(PGSIZE);
    48c6:	6505                	lui	a0,0x1
    48c8:	00001097          	auipc	ra,0x1
    48cc:	3a6080e7          	jalr	934(ra) # 5c6e <sbrk>
    48d0:	89aa                	mv	s3,a0
    if(pids[i] == -1)
    48d2:	5afd                	li	s5,-1
    48d4:	a021                	j	48dc <sbrkfail+0xcc>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    48d6:	0491                	addi	s1,s1,4
    48d8:	01448f63          	beq	s1,s4,48f6 <sbrkfail+0xe6>
    if(pids[i] == -1)
    48dc:	4088                	lw	a0,0(s1)
    48de:	ff550ce3          	beq	a0,s5,48d6 <sbrkfail+0xc6>
    kill(pids[i]);
    48e2:	00001097          	auipc	ra,0x1
    48e6:	334080e7          	jalr	820(ra) # 5c16 <kill>
    wait(0);
    48ea:	4501                	li	a0,0
    48ec:	00001097          	auipc	ra,0x1
    48f0:	302080e7          	jalr	770(ra) # 5bee <wait>
    48f4:	b7cd                	j	48d6 <sbrkfail+0xc6>
  if(c == (char*)0xffffffffffffffffL){
    48f6:	57fd                	li	a5,-1
    48f8:	04f98163          	beq	s3,a5,493a <sbrkfail+0x12a>
  pid = fork();
    48fc:	00001097          	auipc	ra,0x1
    4900:	2e2080e7          	jalr	738(ra) # 5bde <fork>
    4904:	84aa                	mv	s1,a0
  if(pid < 0){
    4906:	04054863          	bltz	a0,4956 <sbrkfail+0x146>
  if(pid == 0){
    490a:	c525                	beqz	a0,4972 <sbrkfail+0x162>
  wait(&xstatus);
    490c:	fbc40513          	addi	a0,s0,-68
    4910:	00001097          	auipc	ra,0x1
    4914:	2de080e7          	jalr	734(ra) # 5bee <wait>
  if(xstatus != -1 && xstatus != 2)
    4918:	fbc42783          	lw	a5,-68(s0)
    491c:	577d                	li	a4,-1
    491e:	00e78563          	beq	a5,a4,4928 <sbrkfail+0x118>
    4922:	4709                	li	a4,2
    4924:	08e79d63          	bne	a5,a4,49be <sbrkfail+0x1ae>
}
    4928:	70e6                	ld	ra,120(sp)
    492a:	7446                	ld	s0,112(sp)
    492c:	74a6                	ld	s1,104(sp)
    492e:	7906                	ld	s2,96(sp)
    4930:	69e6                	ld	s3,88(sp)
    4932:	6a46                	ld	s4,80(sp)
    4934:	6aa6                	ld	s5,72(sp)
    4936:	6109                	addi	sp,sp,128
    4938:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    493a:	85ca                	mv	a1,s2
    493c:	00003517          	auipc	a0,0x3
    4940:	41450513          	addi	a0,a0,1044 # 7d50 <malloc+0x1d24>
    4944:	00001097          	auipc	ra,0x1
    4948:	62a080e7          	jalr	1578(ra) # 5f6e <printf>
    exit(1);
    494c:	4505                	li	a0,1
    494e:	00001097          	auipc	ra,0x1
    4952:	298080e7          	jalr	664(ra) # 5be6 <exit>
    printf("%s: fork failed\n", s);
    4956:	85ca                	mv	a1,s2
    4958:	00002517          	auipc	a0,0x2
    495c:	09850513          	addi	a0,a0,152 # 69f0 <malloc+0x9c4>
    4960:	00001097          	auipc	ra,0x1
    4964:	60e080e7          	jalr	1550(ra) # 5f6e <printf>
    exit(1);
    4968:	4505                	li	a0,1
    496a:	00001097          	auipc	ra,0x1
    496e:	27c080e7          	jalr	636(ra) # 5be6 <exit>
    a = sbrk(0);
    4972:	4501                	li	a0,0
    4974:	00001097          	auipc	ra,0x1
    4978:	2fa080e7          	jalr	762(ra) # 5c6e <sbrk>
    497c:	89aa                	mv	s3,a0
    sbrk(10*BIG);
    497e:	3e800537          	lui	a0,0x3e800
    4982:	00001097          	auipc	ra,0x1
    4986:	2ec080e7          	jalr	748(ra) # 5c6e <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    498a:	874e                	mv	a4,s3
    498c:	3e8007b7          	lui	a5,0x3e800
    4990:	97ce                	add	a5,a5,s3
    4992:	6685                	lui	a3,0x1
      n += *(a+i);
    4994:	00074603          	lbu	a2,0(a4)
    4998:	9cb1                	addw	s1,s1,a2
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    499a:	9736                	add	a4,a4,a3
    499c:	fef71ce3          	bne	a4,a5,4994 <sbrkfail+0x184>
    printf("%s: allocate a lot of memory succeeded %d\n", s, n);
    49a0:	8626                	mv	a2,s1
    49a2:	85ca                	mv	a1,s2
    49a4:	00003517          	auipc	a0,0x3
    49a8:	3cc50513          	addi	a0,a0,972 # 7d70 <malloc+0x1d44>
    49ac:	00001097          	auipc	ra,0x1
    49b0:	5c2080e7          	jalr	1474(ra) # 5f6e <printf>
    exit(1);
    49b4:	4505                	li	a0,1
    49b6:	00001097          	auipc	ra,0x1
    49ba:	230080e7          	jalr	560(ra) # 5be6 <exit>
    exit(1);
    49be:	4505                	li	a0,1
    49c0:	00001097          	auipc	ra,0x1
    49c4:	226080e7          	jalr	550(ra) # 5be6 <exit>

00000000000049c8 <mem>:
{
    49c8:	7139                	addi	sp,sp,-64
    49ca:	fc06                	sd	ra,56(sp)
    49cc:	f822                	sd	s0,48(sp)
    49ce:	f426                	sd	s1,40(sp)
    49d0:	f04a                	sd	s2,32(sp)
    49d2:	ec4e                	sd	s3,24(sp)
    49d4:	0080                	addi	s0,sp,64
    49d6:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    49d8:	00001097          	auipc	ra,0x1
    49dc:	206080e7          	jalr	518(ra) # 5bde <fork>
    m1 = 0;
    49e0:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    49e2:	6909                	lui	s2,0x2
    49e4:	71190913          	addi	s2,s2,1809 # 2711 <copyinstr3+0x103>
  if((pid = fork()) == 0){
    49e8:	ed39                	bnez	a0,4a46 <mem+0x7e>
    while((m2 = malloc(10001)) != 0){
    49ea:	854a                	mv	a0,s2
    49ec:	00001097          	auipc	ra,0x1
    49f0:	640080e7          	jalr	1600(ra) # 602c <malloc>
    49f4:	c501                	beqz	a0,49fc <mem+0x34>
      *(char**)m2 = m1;
    49f6:	e104                	sd	s1,0(a0)
      m1 = m2;
    49f8:	84aa                	mv	s1,a0
    49fa:	bfc5                	j	49ea <mem+0x22>
    while(m1){
    49fc:	c881                	beqz	s1,4a0c <mem+0x44>
      m2 = *(char**)m1;
    49fe:	8526                	mv	a0,s1
    4a00:	6084                	ld	s1,0(s1)
      free(m1);
    4a02:	00001097          	auipc	ra,0x1
    4a06:	5a2080e7          	jalr	1442(ra) # 5fa4 <free>
    while(m1){
    4a0a:	f8f5                	bnez	s1,49fe <mem+0x36>
    m1 = malloc(1024*20);
    4a0c:	6515                	lui	a0,0x5
    4a0e:	00001097          	auipc	ra,0x1
    4a12:	61e080e7          	jalr	1566(ra) # 602c <malloc>
    if(m1 == 0){
    4a16:	c911                	beqz	a0,4a2a <mem+0x62>
    free(m1);
    4a18:	00001097          	auipc	ra,0x1
    4a1c:	58c080e7          	jalr	1420(ra) # 5fa4 <free>
    exit(0);
    4a20:	4501                	li	a0,0
    4a22:	00001097          	auipc	ra,0x1
    4a26:	1c4080e7          	jalr	452(ra) # 5be6 <exit>
      printf("couldn't allocate mem?!!\n", s);
    4a2a:	85ce                	mv	a1,s3
    4a2c:	00003517          	auipc	a0,0x3
    4a30:	37450513          	addi	a0,a0,884 # 7da0 <malloc+0x1d74>
    4a34:	00001097          	auipc	ra,0x1
    4a38:	53a080e7          	jalr	1338(ra) # 5f6e <printf>
      exit(1);
    4a3c:	4505                	li	a0,1
    4a3e:	00001097          	auipc	ra,0x1
    4a42:	1a8080e7          	jalr	424(ra) # 5be6 <exit>
    wait(&xstatus);
    4a46:	fcc40513          	addi	a0,s0,-52
    4a4a:	00001097          	auipc	ra,0x1
    4a4e:	1a4080e7          	jalr	420(ra) # 5bee <wait>
    if(xstatus == -1){
    4a52:	fcc42503          	lw	a0,-52(s0)
    4a56:	57fd                	li	a5,-1
    4a58:	00f50663          	beq	a0,a5,4a64 <mem+0x9c>
    exit(xstatus);
    4a5c:	00001097          	auipc	ra,0x1
    4a60:	18a080e7          	jalr	394(ra) # 5be6 <exit>
      exit(0);
    4a64:	4501                	li	a0,0
    4a66:	00001097          	auipc	ra,0x1
    4a6a:	180080e7          	jalr	384(ra) # 5be6 <exit>

0000000000004a6e <sharedfd>:
{
    4a6e:	7159                	addi	sp,sp,-112
    4a70:	f486                	sd	ra,104(sp)
    4a72:	f0a2                	sd	s0,96(sp)
    4a74:	eca6                	sd	s1,88(sp)
    4a76:	e8ca                	sd	s2,80(sp)
    4a78:	e4ce                	sd	s3,72(sp)
    4a7a:	e0d2                	sd	s4,64(sp)
    4a7c:	fc56                	sd	s5,56(sp)
    4a7e:	f85a                	sd	s6,48(sp)
    4a80:	f45e                	sd	s7,40(sp)
    4a82:	1880                	addi	s0,sp,112
    4a84:	8a2a                	mv	s4,a0
  unlink("sharedfd");
    4a86:	00003517          	auipc	a0,0x3
    4a8a:	33a50513          	addi	a0,a0,826 # 7dc0 <malloc+0x1d94>
    4a8e:	00001097          	auipc	ra,0x1
    4a92:	1a8080e7          	jalr	424(ra) # 5c36 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    4a96:	20200593          	li	a1,514
    4a9a:	00003517          	auipc	a0,0x3
    4a9e:	32650513          	addi	a0,a0,806 # 7dc0 <malloc+0x1d94>
    4aa2:	00001097          	auipc	ra,0x1
    4aa6:	184080e7          	jalr	388(ra) # 5c26 <open>
  if(fd < 0){
    4aaa:	04054a63          	bltz	a0,4afe <sharedfd+0x90>
    4aae:	892a                	mv	s2,a0
  pid = fork();
    4ab0:	00001097          	auipc	ra,0x1
    4ab4:	12e080e7          	jalr	302(ra) # 5bde <fork>
    4ab8:	89aa                	mv	s3,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    4aba:	06300593          	li	a1,99
    4abe:	c119                	beqz	a0,4ac4 <sharedfd+0x56>
    4ac0:	07000593          	li	a1,112
    4ac4:	4629                	li	a2,10
    4ac6:	fa040513          	addi	a0,s0,-96
    4aca:	00001097          	auipc	ra,0x1
    4ace:	f02080e7          	jalr	-254(ra) # 59cc <memset>
    4ad2:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    4ad6:	4629                	li	a2,10
    4ad8:	fa040593          	addi	a1,s0,-96
    4adc:	854a                	mv	a0,s2
    4ade:	00001097          	auipc	ra,0x1
    4ae2:	128080e7          	jalr	296(ra) # 5c06 <write>
    4ae6:	47a9                	li	a5,10
    4ae8:	02f51963          	bne	a0,a5,4b1a <sharedfd+0xac>
  for(i = 0; i < N; i++){
    4aec:	34fd                	addiw	s1,s1,-1
    4aee:	f4e5                	bnez	s1,4ad6 <sharedfd+0x68>
  if(pid == 0) {
    4af0:	04099363          	bnez	s3,4b36 <sharedfd+0xc8>
    exit(0);
    4af4:	4501                	li	a0,0
    4af6:	00001097          	auipc	ra,0x1
    4afa:	0f0080e7          	jalr	240(ra) # 5be6 <exit>
    printf("%s: cannot open sharedfd for writing", s);
    4afe:	85d2                	mv	a1,s4
    4b00:	00003517          	auipc	a0,0x3
    4b04:	2d050513          	addi	a0,a0,720 # 7dd0 <malloc+0x1da4>
    4b08:	00001097          	auipc	ra,0x1
    4b0c:	466080e7          	jalr	1126(ra) # 5f6e <printf>
    exit(1);
    4b10:	4505                	li	a0,1
    4b12:	00001097          	auipc	ra,0x1
    4b16:	0d4080e7          	jalr	212(ra) # 5be6 <exit>
      printf("%s: write sharedfd failed\n", s);
    4b1a:	85d2                	mv	a1,s4
    4b1c:	00003517          	auipc	a0,0x3
    4b20:	2dc50513          	addi	a0,a0,732 # 7df8 <malloc+0x1dcc>
    4b24:	00001097          	auipc	ra,0x1
    4b28:	44a080e7          	jalr	1098(ra) # 5f6e <printf>
      exit(1);
    4b2c:	4505                	li	a0,1
    4b2e:	00001097          	auipc	ra,0x1
    4b32:	0b8080e7          	jalr	184(ra) # 5be6 <exit>
    wait(&xstatus);
    4b36:	f9c40513          	addi	a0,s0,-100
    4b3a:	00001097          	auipc	ra,0x1
    4b3e:	0b4080e7          	jalr	180(ra) # 5bee <wait>
    if(xstatus != 0)
    4b42:	f9c42983          	lw	s3,-100(s0)
    4b46:	00098763          	beqz	s3,4b54 <sharedfd+0xe6>
      exit(xstatus);
    4b4a:	854e                	mv	a0,s3
    4b4c:	00001097          	auipc	ra,0x1
    4b50:	09a080e7          	jalr	154(ra) # 5be6 <exit>
  close(fd);
    4b54:	854a                	mv	a0,s2
    4b56:	00001097          	auipc	ra,0x1
    4b5a:	0b8080e7          	jalr	184(ra) # 5c0e <close>
  fd = open("sharedfd", 0);
    4b5e:	4581                	li	a1,0
    4b60:	00003517          	auipc	a0,0x3
    4b64:	26050513          	addi	a0,a0,608 # 7dc0 <malloc+0x1d94>
    4b68:	00001097          	auipc	ra,0x1
    4b6c:	0be080e7          	jalr	190(ra) # 5c26 <open>
    4b70:	8baa                	mv	s7,a0
  nc = np = 0;
    4b72:	8ace                	mv	s5,s3
  if(fd < 0){
    4b74:	02054563          	bltz	a0,4b9e <sharedfd+0x130>
    4b78:	faa40913          	addi	s2,s0,-86
      if(buf[i] == 'c')
    4b7c:	06300493          	li	s1,99
      if(buf[i] == 'p')
    4b80:	07000b13          	li	s6,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    4b84:	4629                	li	a2,10
    4b86:	fa040593          	addi	a1,s0,-96
    4b8a:	855e                	mv	a0,s7
    4b8c:	00001097          	auipc	ra,0x1
    4b90:	072080e7          	jalr	114(ra) # 5bfe <read>
    4b94:	02a05f63          	blez	a0,4bd2 <sharedfd+0x164>
    4b98:	fa040793          	addi	a5,s0,-96
    4b9c:	a01d                	j	4bc2 <sharedfd+0x154>
    printf("%s: cannot open sharedfd for reading\n", s);
    4b9e:	85d2                	mv	a1,s4
    4ba0:	00003517          	auipc	a0,0x3
    4ba4:	27850513          	addi	a0,a0,632 # 7e18 <malloc+0x1dec>
    4ba8:	00001097          	auipc	ra,0x1
    4bac:	3c6080e7          	jalr	966(ra) # 5f6e <printf>
    exit(1);
    4bb0:	4505                	li	a0,1
    4bb2:	00001097          	auipc	ra,0x1
    4bb6:	034080e7          	jalr	52(ra) # 5be6 <exit>
        nc++;
    4bba:	2985                	addiw	s3,s3,1
    for(i = 0; i < sizeof(buf); i++){
    4bbc:	0785                	addi	a5,a5,1
    4bbe:	fd2783e3          	beq	a5,s2,4b84 <sharedfd+0x116>
      if(buf[i] == 'c')
    4bc2:	0007c703          	lbu	a4,0(a5) # 3e800000 <base+0x3e7f0388>
    4bc6:	fe970ae3          	beq	a4,s1,4bba <sharedfd+0x14c>
      if(buf[i] == 'p')
    4bca:	ff6719e3          	bne	a4,s6,4bbc <sharedfd+0x14e>
        np++;
    4bce:	2a85                	addiw	s5,s5,1
    4bd0:	b7f5                	j	4bbc <sharedfd+0x14e>
  close(fd);
    4bd2:	855e                	mv	a0,s7
    4bd4:	00001097          	auipc	ra,0x1
    4bd8:	03a080e7          	jalr	58(ra) # 5c0e <close>
  unlink("sharedfd");
    4bdc:	00003517          	auipc	a0,0x3
    4be0:	1e450513          	addi	a0,a0,484 # 7dc0 <malloc+0x1d94>
    4be4:	00001097          	auipc	ra,0x1
    4be8:	052080e7          	jalr	82(ra) # 5c36 <unlink>
  if(nc == N*SZ && np == N*SZ){
    4bec:	6789                	lui	a5,0x2
    4bee:	71078793          	addi	a5,a5,1808 # 2710 <copyinstr3+0x102>
    4bf2:	00f99763          	bne	s3,a5,4c00 <sharedfd+0x192>
    4bf6:	6789                	lui	a5,0x2
    4bf8:	71078793          	addi	a5,a5,1808 # 2710 <copyinstr3+0x102>
    4bfc:	02fa8063          	beq	s5,a5,4c1c <sharedfd+0x1ae>
    printf("%s: nc/np test fails\n", s);
    4c00:	85d2                	mv	a1,s4
    4c02:	00003517          	auipc	a0,0x3
    4c06:	23e50513          	addi	a0,a0,574 # 7e40 <malloc+0x1e14>
    4c0a:	00001097          	auipc	ra,0x1
    4c0e:	364080e7          	jalr	868(ra) # 5f6e <printf>
    exit(1);
    4c12:	4505                	li	a0,1
    4c14:	00001097          	auipc	ra,0x1
    4c18:	fd2080e7          	jalr	-46(ra) # 5be6 <exit>
    exit(0);
    4c1c:	4501                	li	a0,0
    4c1e:	00001097          	auipc	ra,0x1
    4c22:	fc8080e7          	jalr	-56(ra) # 5be6 <exit>

0000000000004c26 <fourfiles>:
{
    4c26:	7171                	addi	sp,sp,-176
    4c28:	f506                	sd	ra,168(sp)
    4c2a:	f122                	sd	s0,160(sp)
    4c2c:	ed26                	sd	s1,152(sp)
    4c2e:	e94a                	sd	s2,144(sp)
    4c30:	e54e                	sd	s3,136(sp)
    4c32:	e152                	sd	s4,128(sp)
    4c34:	fcd6                	sd	s5,120(sp)
    4c36:	f8da                	sd	s6,112(sp)
    4c38:	f4de                	sd	s7,104(sp)
    4c3a:	f0e2                	sd	s8,96(sp)
    4c3c:	ece6                	sd	s9,88(sp)
    4c3e:	e8ea                	sd	s10,80(sp)
    4c40:	e4ee                	sd	s11,72(sp)
    4c42:	1900                	addi	s0,sp,176
    4c44:	8caa                	mv	s9,a0
  char *names[] = { "f0", "f1", "f2", "f3" };
    4c46:	00001797          	auipc	a5,0x1
    4c4a:	4ca78793          	addi	a5,a5,1226 # 6110 <malloc+0xe4>
    4c4e:	f6f43823          	sd	a5,-144(s0)
    4c52:	00001797          	auipc	a5,0x1
    4c56:	4c678793          	addi	a5,a5,1222 # 6118 <malloc+0xec>
    4c5a:	f6f43c23          	sd	a5,-136(s0)
    4c5e:	00001797          	auipc	a5,0x1
    4c62:	4c278793          	addi	a5,a5,1218 # 6120 <malloc+0xf4>
    4c66:	f8f43023          	sd	a5,-128(s0)
    4c6a:	00001797          	auipc	a5,0x1
    4c6e:	4be78793          	addi	a5,a5,1214 # 6128 <malloc+0xfc>
    4c72:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    4c76:	f7040b93          	addi	s7,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    4c7a:	895e                	mv	s2,s7
  for(pi = 0; pi < NCHILD; pi++){
    4c7c:	4481                	li	s1,0
    4c7e:	4a11                	li	s4,4
    fname = names[pi];
    4c80:	00093983          	ld	s3,0(s2)
    unlink(fname);
    4c84:	854e                	mv	a0,s3
    4c86:	00001097          	auipc	ra,0x1
    4c8a:	fb0080e7          	jalr	-80(ra) # 5c36 <unlink>
    pid = fork();
    4c8e:	00001097          	auipc	ra,0x1
    4c92:	f50080e7          	jalr	-176(ra) # 5bde <fork>
    if(pid < 0){
    4c96:	04054563          	bltz	a0,4ce0 <fourfiles+0xba>
    if(pid == 0){
    4c9a:	c12d                	beqz	a0,4cfc <fourfiles+0xd6>
  for(pi = 0; pi < NCHILD; pi++){
    4c9c:	2485                	addiw	s1,s1,1
    4c9e:	0921                	addi	s2,s2,8
    4ca0:	ff4490e3          	bne	s1,s4,4c80 <fourfiles+0x5a>
    4ca4:	4491                	li	s1,4
    wait(&xstatus);
    4ca6:	f6c40513          	addi	a0,s0,-148
    4caa:	00001097          	auipc	ra,0x1
    4cae:	f44080e7          	jalr	-188(ra) # 5bee <wait>
    if(xstatus != 0)
    4cb2:	f6c42503          	lw	a0,-148(s0)
    4cb6:	ed69                	bnez	a0,4d90 <fourfiles+0x16a>
  for(pi = 0; pi < NCHILD; pi++){
    4cb8:	34fd                	addiw	s1,s1,-1
    4cba:	f4f5                	bnez	s1,4ca6 <fourfiles+0x80>
    4cbc:	03000b13          	li	s6,48
    total = 0;
    4cc0:	f4a43c23          	sd	a0,-168(s0)
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4cc4:	00008a17          	auipc	s4,0x8
    4cc8:	fb4a0a13          	addi	s4,s4,-76 # cc78 <buf>
    4ccc:	00008a97          	auipc	s5,0x8
    4cd0:	fada8a93          	addi	s5,s5,-83 # cc79 <buf+0x1>
    if(total != N*SZ){
    4cd4:	6d05                	lui	s10,0x1
    4cd6:	770d0d13          	addi	s10,s10,1904 # 1770 <exectest+0x2e>
  for(i = 0; i < NCHILD; i++){
    4cda:	03400d93          	li	s11,52
    4cde:	a23d                	j	4e0c <fourfiles+0x1e6>
      printf("fork failed\n", s);
    4ce0:	85e6                	mv	a1,s9
    4ce2:	00002517          	auipc	a0,0x2
    4ce6:	11650513          	addi	a0,a0,278 # 6df8 <malloc+0xdcc>
    4cea:	00001097          	auipc	ra,0x1
    4cee:	284080e7          	jalr	644(ra) # 5f6e <printf>
      exit(1);
    4cf2:	4505                	li	a0,1
    4cf4:	00001097          	auipc	ra,0x1
    4cf8:	ef2080e7          	jalr	-270(ra) # 5be6 <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    4cfc:	20200593          	li	a1,514
    4d00:	854e                	mv	a0,s3
    4d02:	00001097          	auipc	ra,0x1
    4d06:	f24080e7          	jalr	-220(ra) # 5c26 <open>
    4d0a:	892a                	mv	s2,a0
      if(fd < 0){
    4d0c:	04054763          	bltz	a0,4d5a <fourfiles+0x134>
      memset(buf, '0'+pi, SZ);
    4d10:	1f400613          	li	a2,500
    4d14:	0304859b          	addiw	a1,s1,48
    4d18:	00008517          	auipc	a0,0x8
    4d1c:	f6050513          	addi	a0,a0,-160 # cc78 <buf>
    4d20:	00001097          	auipc	ra,0x1
    4d24:	cac080e7          	jalr	-852(ra) # 59cc <memset>
    4d28:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    4d2a:	00008997          	auipc	s3,0x8
    4d2e:	f4e98993          	addi	s3,s3,-178 # cc78 <buf>
    4d32:	1f400613          	li	a2,500
    4d36:	85ce                	mv	a1,s3
    4d38:	854a                	mv	a0,s2
    4d3a:	00001097          	auipc	ra,0x1
    4d3e:	ecc080e7          	jalr	-308(ra) # 5c06 <write>
    4d42:	85aa                	mv	a1,a0
    4d44:	1f400793          	li	a5,500
    4d48:	02f51763          	bne	a0,a5,4d76 <fourfiles+0x150>
      for(i = 0; i < N; i++){
    4d4c:	34fd                	addiw	s1,s1,-1
    4d4e:	f0f5                	bnez	s1,4d32 <fourfiles+0x10c>
      exit(0);
    4d50:	4501                	li	a0,0
    4d52:	00001097          	auipc	ra,0x1
    4d56:	e94080e7          	jalr	-364(ra) # 5be6 <exit>
        printf("create failed\n", s);
    4d5a:	85e6                	mv	a1,s9
    4d5c:	00003517          	auipc	a0,0x3
    4d60:	0fc50513          	addi	a0,a0,252 # 7e58 <malloc+0x1e2c>
    4d64:	00001097          	auipc	ra,0x1
    4d68:	20a080e7          	jalr	522(ra) # 5f6e <printf>
        exit(1);
    4d6c:	4505                	li	a0,1
    4d6e:	00001097          	auipc	ra,0x1
    4d72:	e78080e7          	jalr	-392(ra) # 5be6 <exit>
          printf("write failed %d\n", n);
    4d76:	00003517          	auipc	a0,0x3
    4d7a:	0f250513          	addi	a0,a0,242 # 7e68 <malloc+0x1e3c>
    4d7e:	00001097          	auipc	ra,0x1
    4d82:	1f0080e7          	jalr	496(ra) # 5f6e <printf>
          exit(1);
    4d86:	4505                	li	a0,1
    4d88:	00001097          	auipc	ra,0x1
    4d8c:	e5e080e7          	jalr	-418(ra) # 5be6 <exit>
      exit(xstatus);
    4d90:	00001097          	auipc	ra,0x1
    4d94:	e56080e7          	jalr	-426(ra) # 5be6 <exit>
          printf("wrong char\n", s);
    4d98:	85e6                	mv	a1,s9
    4d9a:	00003517          	auipc	a0,0x3
    4d9e:	0e650513          	addi	a0,a0,230 # 7e80 <malloc+0x1e54>
    4da2:	00001097          	auipc	ra,0x1
    4da6:	1cc080e7          	jalr	460(ra) # 5f6e <printf>
          exit(1);
    4daa:	4505                	li	a0,1
    4dac:	00001097          	auipc	ra,0x1
    4db0:	e3a080e7          	jalr	-454(ra) # 5be6 <exit>
      total += n;
    4db4:	00a9093b          	addw	s2,s2,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4db8:	660d                	lui	a2,0x3
    4dba:	85d2                	mv	a1,s4
    4dbc:	854e                	mv	a0,s3
    4dbe:	00001097          	auipc	ra,0x1
    4dc2:	e40080e7          	jalr	-448(ra) # 5bfe <read>
    4dc6:	02a05363          	blez	a0,4dec <fourfiles+0x1c6>
    4dca:	00008797          	auipc	a5,0x8
    4dce:	eae78793          	addi	a5,a5,-338 # cc78 <buf>
    4dd2:	fff5069b          	addiw	a3,a0,-1
    4dd6:	1682                	slli	a3,a3,0x20
    4dd8:	9281                	srli	a3,a3,0x20
    4dda:	96d6                	add	a3,a3,s5
        if(buf[j] != '0'+i){
    4ddc:	0007c703          	lbu	a4,0(a5)
    4de0:	fa971ce3          	bne	a4,s1,4d98 <fourfiles+0x172>
      for(j = 0; j < n; j++){
    4de4:	0785                	addi	a5,a5,1
    4de6:	fed79be3          	bne	a5,a3,4ddc <fourfiles+0x1b6>
    4dea:	b7e9                	j	4db4 <fourfiles+0x18e>
    close(fd);
    4dec:	854e                	mv	a0,s3
    4dee:	00001097          	auipc	ra,0x1
    4df2:	e20080e7          	jalr	-480(ra) # 5c0e <close>
    if(total != N*SZ){
    4df6:	03a91963          	bne	s2,s10,4e28 <fourfiles+0x202>
    unlink(fname);
    4dfa:	8562                	mv	a0,s8
    4dfc:	00001097          	auipc	ra,0x1
    4e00:	e3a080e7          	jalr	-454(ra) # 5c36 <unlink>
  for(i = 0; i < NCHILD; i++){
    4e04:	0ba1                	addi	s7,s7,8
    4e06:	2b05                	addiw	s6,s6,1
    4e08:	03bb0e63          	beq	s6,s11,4e44 <fourfiles+0x21e>
    fname = names[i];
    4e0c:	000bbc03          	ld	s8,0(s7)
    fd = open(fname, 0);
    4e10:	4581                	li	a1,0
    4e12:	8562                	mv	a0,s8
    4e14:	00001097          	auipc	ra,0x1
    4e18:	e12080e7          	jalr	-494(ra) # 5c26 <open>
    4e1c:	89aa                	mv	s3,a0
    total = 0;
    4e1e:	f5843903          	ld	s2,-168(s0)
        if(buf[j] != '0'+i){
    4e22:	000b049b          	sext.w	s1,s6
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4e26:	bf49                	j	4db8 <fourfiles+0x192>
      printf("wrong length %d\n", total);
    4e28:	85ca                	mv	a1,s2
    4e2a:	00003517          	auipc	a0,0x3
    4e2e:	06650513          	addi	a0,a0,102 # 7e90 <malloc+0x1e64>
    4e32:	00001097          	auipc	ra,0x1
    4e36:	13c080e7          	jalr	316(ra) # 5f6e <printf>
      exit(1);
    4e3a:	4505                	li	a0,1
    4e3c:	00001097          	auipc	ra,0x1
    4e40:	daa080e7          	jalr	-598(ra) # 5be6 <exit>
}
    4e44:	70aa                	ld	ra,168(sp)
    4e46:	740a                	ld	s0,160(sp)
    4e48:	64ea                	ld	s1,152(sp)
    4e4a:	694a                	ld	s2,144(sp)
    4e4c:	69aa                	ld	s3,136(sp)
    4e4e:	6a0a                	ld	s4,128(sp)
    4e50:	7ae6                	ld	s5,120(sp)
    4e52:	7b46                	ld	s6,112(sp)
    4e54:	7ba6                	ld	s7,104(sp)
    4e56:	7c06                	ld	s8,96(sp)
    4e58:	6ce6                	ld	s9,88(sp)
    4e5a:	6d46                	ld	s10,80(sp)
    4e5c:	6da6                	ld	s11,72(sp)
    4e5e:	614d                	addi	sp,sp,176
    4e60:	8082                	ret

0000000000004e62 <concreate>:
{
    4e62:	7135                	addi	sp,sp,-160
    4e64:	ed06                	sd	ra,152(sp)
    4e66:	e922                	sd	s0,144(sp)
    4e68:	e526                	sd	s1,136(sp)
    4e6a:	e14a                	sd	s2,128(sp)
    4e6c:	fcce                	sd	s3,120(sp)
    4e6e:	f8d2                	sd	s4,112(sp)
    4e70:	f4d6                	sd	s5,104(sp)
    4e72:	f0da                	sd	s6,96(sp)
    4e74:	ecde                	sd	s7,88(sp)
    4e76:	1100                	addi	s0,sp,160
    4e78:	89aa                	mv	s3,a0
  file[0] = 'C';
    4e7a:	04300793          	li	a5,67
    4e7e:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    4e82:	fa040523          	sb	zero,-86(s0)
  for(i = 0; i < N; i++){
    4e86:	4901                	li	s2,0
    if(pid && (i % 3) == 1){
    4e88:	4b0d                	li	s6,3
    4e8a:	4a85                	li	s5,1
      link("C0", file);
    4e8c:	00003b97          	auipc	s7,0x3
    4e90:	01cb8b93          	addi	s7,s7,28 # 7ea8 <malloc+0x1e7c>
  for(i = 0; i < N; i++){
    4e94:	02800a13          	li	s4,40
    4e98:	acc1                	j	5168 <concreate+0x306>
      link("C0", file);
    4e9a:	fa840593          	addi	a1,s0,-88
    4e9e:	855e                	mv	a0,s7
    4ea0:	00001097          	auipc	ra,0x1
    4ea4:	da6080e7          	jalr	-602(ra) # 5c46 <link>
    if(pid == 0) {
    4ea8:	a45d                	j	514e <concreate+0x2ec>
    } else if(pid == 0 && (i % 5) == 1){
    4eaa:	4795                	li	a5,5
    4eac:	02f9693b          	remw	s2,s2,a5
    4eb0:	4785                	li	a5,1
    4eb2:	02f90b63          	beq	s2,a5,4ee8 <concreate+0x86>
      fd = open(file, O_CREATE | O_RDWR);
    4eb6:	20200593          	li	a1,514
    4eba:	fa840513          	addi	a0,s0,-88
    4ebe:	00001097          	auipc	ra,0x1
    4ec2:	d68080e7          	jalr	-664(ra) # 5c26 <open>
      if(fd < 0){
    4ec6:	26055b63          	bgez	a0,513c <concreate+0x2da>
        printf("concreate create %s failed\n", file);
    4eca:	fa840593          	addi	a1,s0,-88
    4ece:	00003517          	auipc	a0,0x3
    4ed2:	fe250513          	addi	a0,a0,-30 # 7eb0 <malloc+0x1e84>
    4ed6:	00001097          	auipc	ra,0x1
    4eda:	098080e7          	jalr	152(ra) # 5f6e <printf>
        exit(1);
    4ede:	4505                	li	a0,1
    4ee0:	00001097          	auipc	ra,0x1
    4ee4:	d06080e7          	jalr	-762(ra) # 5be6 <exit>
      link("C0", file);
    4ee8:	fa840593          	addi	a1,s0,-88
    4eec:	00003517          	auipc	a0,0x3
    4ef0:	fbc50513          	addi	a0,a0,-68 # 7ea8 <malloc+0x1e7c>
    4ef4:	00001097          	auipc	ra,0x1
    4ef8:	d52080e7          	jalr	-686(ra) # 5c46 <link>
      exit(0);
    4efc:	4501                	li	a0,0
    4efe:	00001097          	auipc	ra,0x1
    4f02:	ce8080e7          	jalr	-792(ra) # 5be6 <exit>
        exit(1);
    4f06:	4505                	li	a0,1
    4f08:	00001097          	auipc	ra,0x1
    4f0c:	cde080e7          	jalr	-802(ra) # 5be6 <exit>
  memset(fa, 0, sizeof(fa));
    4f10:	02800613          	li	a2,40
    4f14:	4581                	li	a1,0
    4f16:	f8040513          	addi	a0,s0,-128
    4f1a:	00001097          	auipc	ra,0x1
    4f1e:	ab2080e7          	jalr	-1358(ra) # 59cc <memset>
  fd = open(".", 0);
    4f22:	4581                	li	a1,0
    4f24:	00002517          	auipc	a0,0x2
    4f28:	92c50513          	addi	a0,a0,-1748 # 6850 <malloc+0x824>
    4f2c:	00001097          	auipc	ra,0x1
    4f30:	cfa080e7          	jalr	-774(ra) # 5c26 <open>
    4f34:	892a                	mv	s2,a0
  n = 0;
    4f36:	8aa6                	mv	s5,s1
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4f38:	04300a13          	li	s4,67
      if(i < 0 || i >= sizeof(fa)){
    4f3c:	02700b13          	li	s6,39
      fa[i] = 1;
    4f40:	4b85                	li	s7,1
  while(read(fd, &de, sizeof(de)) > 0){
    4f42:	a03d                	j	4f70 <concreate+0x10e>
        printf("%s: concreate weird file %s\n", s, de.name);
    4f44:	f7240613          	addi	a2,s0,-142
    4f48:	85ce                	mv	a1,s3
    4f4a:	00003517          	auipc	a0,0x3
    4f4e:	f8650513          	addi	a0,a0,-122 # 7ed0 <malloc+0x1ea4>
    4f52:	00001097          	auipc	ra,0x1
    4f56:	01c080e7          	jalr	28(ra) # 5f6e <printf>
        exit(1);
    4f5a:	4505                	li	a0,1
    4f5c:	00001097          	auipc	ra,0x1
    4f60:	c8a080e7          	jalr	-886(ra) # 5be6 <exit>
      fa[i] = 1;
    4f64:	fb040793          	addi	a5,s0,-80
    4f68:	973e                	add	a4,a4,a5
    4f6a:	fd770823          	sb	s7,-48(a4)
      n++;
    4f6e:	2a85                	addiw	s5,s5,1
  while(read(fd, &de, sizeof(de)) > 0){
    4f70:	4641                	li	a2,16
    4f72:	f7040593          	addi	a1,s0,-144
    4f76:	854a                	mv	a0,s2
    4f78:	00001097          	auipc	ra,0x1
    4f7c:	c86080e7          	jalr	-890(ra) # 5bfe <read>
    4f80:	04a05a63          	blez	a0,4fd4 <concreate+0x172>
    if(de.inum == 0)
    4f84:	f7045783          	lhu	a5,-144(s0)
    4f88:	d7e5                	beqz	a5,4f70 <concreate+0x10e>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4f8a:	f7244783          	lbu	a5,-142(s0)
    4f8e:	ff4791e3          	bne	a5,s4,4f70 <concreate+0x10e>
    4f92:	f7444783          	lbu	a5,-140(s0)
    4f96:	ffe9                	bnez	a5,4f70 <concreate+0x10e>
      i = de.name[1] - '0';
    4f98:	f7344783          	lbu	a5,-141(s0)
    4f9c:	fd07879b          	addiw	a5,a5,-48
    4fa0:	0007871b          	sext.w	a4,a5
      if(i < 0 || i >= sizeof(fa)){
    4fa4:	faeb60e3          	bltu	s6,a4,4f44 <concreate+0xe2>
      if(fa[i]){
    4fa8:	fb040793          	addi	a5,s0,-80
    4fac:	97ba                	add	a5,a5,a4
    4fae:	fd07c783          	lbu	a5,-48(a5)
    4fb2:	dbcd                	beqz	a5,4f64 <concreate+0x102>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    4fb4:	f7240613          	addi	a2,s0,-142
    4fb8:	85ce                	mv	a1,s3
    4fba:	00003517          	auipc	a0,0x3
    4fbe:	f3650513          	addi	a0,a0,-202 # 7ef0 <malloc+0x1ec4>
    4fc2:	00001097          	auipc	ra,0x1
    4fc6:	fac080e7          	jalr	-84(ra) # 5f6e <printf>
        exit(1);
    4fca:	4505                	li	a0,1
    4fcc:	00001097          	auipc	ra,0x1
    4fd0:	c1a080e7          	jalr	-998(ra) # 5be6 <exit>
  close(fd);
    4fd4:	854a                	mv	a0,s2
    4fd6:	00001097          	auipc	ra,0x1
    4fda:	c38080e7          	jalr	-968(ra) # 5c0e <close>
  if(n != N){
    4fde:	02800793          	li	a5,40
    4fe2:	00fa9763          	bne	s5,a5,4ff0 <concreate+0x18e>
    if(((i % 3) == 0 && pid == 0) ||
    4fe6:	4a8d                	li	s5,3
    4fe8:	4b05                	li	s6,1
  for(i = 0; i < N; i++){
    4fea:	02800a13          	li	s4,40
    4fee:	a8c9                	j	50c0 <concreate+0x25e>
    printf("%s: concreate not enough files in directory listing\n", s);
    4ff0:	85ce                	mv	a1,s3
    4ff2:	00003517          	auipc	a0,0x3
    4ff6:	f2650513          	addi	a0,a0,-218 # 7f18 <malloc+0x1eec>
    4ffa:	00001097          	auipc	ra,0x1
    4ffe:	f74080e7          	jalr	-140(ra) # 5f6e <printf>
    exit(1);
    5002:	4505                	li	a0,1
    5004:	00001097          	auipc	ra,0x1
    5008:	be2080e7          	jalr	-1054(ra) # 5be6 <exit>
      printf("%s: fork failed\n", s);
    500c:	85ce                	mv	a1,s3
    500e:	00002517          	auipc	a0,0x2
    5012:	9e250513          	addi	a0,a0,-1566 # 69f0 <malloc+0x9c4>
    5016:	00001097          	auipc	ra,0x1
    501a:	f58080e7          	jalr	-168(ra) # 5f6e <printf>
      exit(1);
    501e:	4505                	li	a0,1
    5020:	00001097          	auipc	ra,0x1
    5024:	bc6080e7          	jalr	-1082(ra) # 5be6 <exit>
      close(open(file, 0));
    5028:	4581                	li	a1,0
    502a:	fa840513          	addi	a0,s0,-88
    502e:	00001097          	auipc	ra,0x1
    5032:	bf8080e7          	jalr	-1032(ra) # 5c26 <open>
    5036:	00001097          	auipc	ra,0x1
    503a:	bd8080e7          	jalr	-1064(ra) # 5c0e <close>
      close(open(file, 0));
    503e:	4581                	li	a1,0
    5040:	fa840513          	addi	a0,s0,-88
    5044:	00001097          	auipc	ra,0x1
    5048:	be2080e7          	jalr	-1054(ra) # 5c26 <open>
    504c:	00001097          	auipc	ra,0x1
    5050:	bc2080e7          	jalr	-1086(ra) # 5c0e <close>
      close(open(file, 0));
    5054:	4581                	li	a1,0
    5056:	fa840513          	addi	a0,s0,-88
    505a:	00001097          	auipc	ra,0x1
    505e:	bcc080e7          	jalr	-1076(ra) # 5c26 <open>
    5062:	00001097          	auipc	ra,0x1
    5066:	bac080e7          	jalr	-1108(ra) # 5c0e <close>
      close(open(file, 0));
    506a:	4581                	li	a1,0
    506c:	fa840513          	addi	a0,s0,-88
    5070:	00001097          	auipc	ra,0x1
    5074:	bb6080e7          	jalr	-1098(ra) # 5c26 <open>
    5078:	00001097          	auipc	ra,0x1
    507c:	b96080e7          	jalr	-1130(ra) # 5c0e <close>
      close(open(file, 0));
    5080:	4581                	li	a1,0
    5082:	fa840513          	addi	a0,s0,-88
    5086:	00001097          	auipc	ra,0x1
    508a:	ba0080e7          	jalr	-1120(ra) # 5c26 <open>
    508e:	00001097          	auipc	ra,0x1
    5092:	b80080e7          	jalr	-1152(ra) # 5c0e <close>
      close(open(file, 0));
    5096:	4581                	li	a1,0
    5098:	fa840513          	addi	a0,s0,-88
    509c:	00001097          	auipc	ra,0x1
    50a0:	b8a080e7          	jalr	-1142(ra) # 5c26 <open>
    50a4:	00001097          	auipc	ra,0x1
    50a8:	b6a080e7          	jalr	-1174(ra) # 5c0e <close>
    if(pid == 0)
    50ac:	08090363          	beqz	s2,5132 <concreate+0x2d0>
      wait(0);
    50b0:	4501                	li	a0,0
    50b2:	00001097          	auipc	ra,0x1
    50b6:	b3c080e7          	jalr	-1220(ra) # 5bee <wait>
  for(i = 0; i < N; i++){
    50ba:	2485                	addiw	s1,s1,1
    50bc:	0f448563          	beq	s1,s4,51a6 <concreate+0x344>
    file[1] = '0' + i;
    50c0:	0304879b          	addiw	a5,s1,48
    50c4:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    50c8:	00001097          	auipc	ra,0x1
    50cc:	b16080e7          	jalr	-1258(ra) # 5bde <fork>
    50d0:	892a                	mv	s2,a0
    if(pid < 0){
    50d2:	f2054de3          	bltz	a0,500c <concreate+0x1aa>
    if(((i % 3) == 0 && pid == 0) ||
    50d6:	0354e73b          	remw	a4,s1,s5
    50da:	00a767b3          	or	a5,a4,a0
    50de:	2781                	sext.w	a5,a5
    50e0:	d7a1                	beqz	a5,5028 <concreate+0x1c6>
    50e2:	01671363          	bne	a4,s6,50e8 <concreate+0x286>
       ((i % 3) == 1 && pid != 0)){
    50e6:	f129                	bnez	a0,5028 <concreate+0x1c6>
      unlink(file);
    50e8:	fa840513          	addi	a0,s0,-88
    50ec:	00001097          	auipc	ra,0x1
    50f0:	b4a080e7          	jalr	-1206(ra) # 5c36 <unlink>
      unlink(file);
    50f4:	fa840513          	addi	a0,s0,-88
    50f8:	00001097          	auipc	ra,0x1
    50fc:	b3e080e7          	jalr	-1218(ra) # 5c36 <unlink>
      unlink(file);
    5100:	fa840513          	addi	a0,s0,-88
    5104:	00001097          	auipc	ra,0x1
    5108:	b32080e7          	jalr	-1230(ra) # 5c36 <unlink>
      unlink(file);
    510c:	fa840513          	addi	a0,s0,-88
    5110:	00001097          	auipc	ra,0x1
    5114:	b26080e7          	jalr	-1242(ra) # 5c36 <unlink>
      unlink(file);
    5118:	fa840513          	addi	a0,s0,-88
    511c:	00001097          	auipc	ra,0x1
    5120:	b1a080e7          	jalr	-1254(ra) # 5c36 <unlink>
      unlink(file);
    5124:	fa840513          	addi	a0,s0,-88
    5128:	00001097          	auipc	ra,0x1
    512c:	b0e080e7          	jalr	-1266(ra) # 5c36 <unlink>
    5130:	bfb5                	j	50ac <concreate+0x24a>
      exit(0);
    5132:	4501                	li	a0,0
    5134:	00001097          	auipc	ra,0x1
    5138:	ab2080e7          	jalr	-1358(ra) # 5be6 <exit>
      close(fd);
    513c:	00001097          	auipc	ra,0x1
    5140:	ad2080e7          	jalr	-1326(ra) # 5c0e <close>
    if(pid == 0) {
    5144:	bb65                	j	4efc <concreate+0x9a>
      close(fd);
    5146:	00001097          	auipc	ra,0x1
    514a:	ac8080e7          	jalr	-1336(ra) # 5c0e <close>
      wait(&xstatus);
    514e:	f6c40513          	addi	a0,s0,-148
    5152:	00001097          	auipc	ra,0x1
    5156:	a9c080e7          	jalr	-1380(ra) # 5bee <wait>
      if(xstatus != 0)
    515a:	f6c42483          	lw	s1,-148(s0)
    515e:	da0494e3          	bnez	s1,4f06 <concreate+0xa4>
  for(i = 0; i < N; i++){
    5162:	2905                	addiw	s2,s2,1
    5164:	db4906e3          	beq	s2,s4,4f10 <concreate+0xae>
    file[1] = '0' + i;
    5168:	0309079b          	addiw	a5,s2,48
    516c:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    5170:	fa840513          	addi	a0,s0,-88
    5174:	00001097          	auipc	ra,0x1
    5178:	ac2080e7          	jalr	-1342(ra) # 5c36 <unlink>
    pid = fork();
    517c:	00001097          	auipc	ra,0x1
    5180:	a62080e7          	jalr	-1438(ra) # 5bde <fork>
    if(pid && (i % 3) == 1){
    5184:	d20503e3          	beqz	a0,4eaa <concreate+0x48>
    5188:	036967bb          	remw	a5,s2,s6
    518c:	d15787e3          	beq	a5,s5,4e9a <concreate+0x38>
      fd = open(file, O_CREATE | O_RDWR);
    5190:	20200593          	li	a1,514
    5194:	fa840513          	addi	a0,s0,-88
    5198:	00001097          	auipc	ra,0x1
    519c:	a8e080e7          	jalr	-1394(ra) # 5c26 <open>
      if(fd < 0){
    51a0:	fa0553e3          	bgez	a0,5146 <concreate+0x2e4>
    51a4:	b31d                	j	4eca <concreate+0x68>
}
    51a6:	60ea                	ld	ra,152(sp)
    51a8:	644a                	ld	s0,144(sp)
    51aa:	64aa                	ld	s1,136(sp)
    51ac:	690a                	ld	s2,128(sp)
    51ae:	79e6                	ld	s3,120(sp)
    51b0:	7a46                	ld	s4,112(sp)
    51b2:	7aa6                	ld	s5,104(sp)
    51b4:	7b06                	ld	s6,96(sp)
    51b6:	6be6                	ld	s7,88(sp)
    51b8:	610d                	addi	sp,sp,160
    51ba:	8082                	ret

00000000000051bc <bigfile>:
{
    51bc:	7139                	addi	sp,sp,-64
    51be:	fc06                	sd	ra,56(sp)
    51c0:	f822                	sd	s0,48(sp)
    51c2:	f426                	sd	s1,40(sp)
    51c4:	f04a                	sd	s2,32(sp)
    51c6:	ec4e                	sd	s3,24(sp)
    51c8:	e852                	sd	s4,16(sp)
    51ca:	e456                	sd	s5,8(sp)
    51cc:	0080                	addi	s0,sp,64
    51ce:	8aaa                	mv	s5,a0
  unlink("bigfile.dat");
    51d0:	00003517          	auipc	a0,0x3
    51d4:	d8050513          	addi	a0,a0,-640 # 7f50 <malloc+0x1f24>
    51d8:	00001097          	auipc	ra,0x1
    51dc:	a5e080e7          	jalr	-1442(ra) # 5c36 <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    51e0:	20200593          	li	a1,514
    51e4:	00003517          	auipc	a0,0x3
    51e8:	d6c50513          	addi	a0,a0,-660 # 7f50 <malloc+0x1f24>
    51ec:	00001097          	auipc	ra,0x1
    51f0:	a3a080e7          	jalr	-1478(ra) # 5c26 <open>
    51f4:	89aa                	mv	s3,a0
  for(i = 0; i < N; i++){
    51f6:	4481                	li	s1,0
    memset(buf, i, SZ);
    51f8:	00008917          	auipc	s2,0x8
    51fc:	a8090913          	addi	s2,s2,-1408 # cc78 <buf>
  for(i = 0; i < N; i++){
    5200:	4a51                	li	s4,20
  if(fd < 0){
    5202:	0a054063          	bltz	a0,52a2 <bigfile+0xe6>
    memset(buf, i, SZ);
    5206:	25800613          	li	a2,600
    520a:	85a6                	mv	a1,s1
    520c:	854a                	mv	a0,s2
    520e:	00000097          	auipc	ra,0x0
    5212:	7be080e7          	jalr	1982(ra) # 59cc <memset>
    if(write(fd, buf, SZ) != SZ){
    5216:	25800613          	li	a2,600
    521a:	85ca                	mv	a1,s2
    521c:	854e                	mv	a0,s3
    521e:	00001097          	auipc	ra,0x1
    5222:	9e8080e7          	jalr	-1560(ra) # 5c06 <write>
    5226:	25800793          	li	a5,600
    522a:	08f51a63          	bne	a0,a5,52be <bigfile+0x102>
  for(i = 0; i < N; i++){
    522e:	2485                	addiw	s1,s1,1
    5230:	fd449be3          	bne	s1,s4,5206 <bigfile+0x4a>
  close(fd);
    5234:	854e                	mv	a0,s3
    5236:	00001097          	auipc	ra,0x1
    523a:	9d8080e7          	jalr	-1576(ra) # 5c0e <close>
  fd = open("bigfile.dat", 0);
    523e:	4581                	li	a1,0
    5240:	00003517          	auipc	a0,0x3
    5244:	d1050513          	addi	a0,a0,-752 # 7f50 <malloc+0x1f24>
    5248:	00001097          	auipc	ra,0x1
    524c:	9de080e7          	jalr	-1570(ra) # 5c26 <open>
    5250:	8a2a                	mv	s4,a0
  total = 0;
    5252:	4981                	li	s3,0
  for(i = 0; ; i++){
    5254:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    5256:	00008917          	auipc	s2,0x8
    525a:	a2290913          	addi	s2,s2,-1502 # cc78 <buf>
  if(fd < 0){
    525e:	06054e63          	bltz	a0,52da <bigfile+0x11e>
    cc = read(fd, buf, SZ/2);
    5262:	12c00613          	li	a2,300
    5266:	85ca                	mv	a1,s2
    5268:	8552                	mv	a0,s4
    526a:	00001097          	auipc	ra,0x1
    526e:	994080e7          	jalr	-1644(ra) # 5bfe <read>
    if(cc < 0){
    5272:	08054263          	bltz	a0,52f6 <bigfile+0x13a>
    if(cc == 0)
    5276:	c971                	beqz	a0,534a <bigfile+0x18e>
    if(cc != SZ/2){
    5278:	12c00793          	li	a5,300
    527c:	08f51b63          	bne	a0,a5,5312 <bigfile+0x156>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    5280:	01f4d79b          	srliw	a5,s1,0x1f
    5284:	9fa5                	addw	a5,a5,s1
    5286:	4017d79b          	sraiw	a5,a5,0x1
    528a:	00094703          	lbu	a4,0(s2)
    528e:	0af71063          	bne	a4,a5,532e <bigfile+0x172>
    5292:	12b94703          	lbu	a4,299(s2)
    5296:	08f71c63          	bne	a4,a5,532e <bigfile+0x172>
    total += cc;
    529a:	12c9899b          	addiw	s3,s3,300
  for(i = 0; ; i++){
    529e:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    52a0:	b7c9                	j	5262 <bigfile+0xa6>
    printf("%s: cannot create bigfile", s);
    52a2:	85d6                	mv	a1,s5
    52a4:	00003517          	auipc	a0,0x3
    52a8:	cbc50513          	addi	a0,a0,-836 # 7f60 <malloc+0x1f34>
    52ac:	00001097          	auipc	ra,0x1
    52b0:	cc2080e7          	jalr	-830(ra) # 5f6e <printf>
    exit(1);
    52b4:	4505                	li	a0,1
    52b6:	00001097          	auipc	ra,0x1
    52ba:	930080e7          	jalr	-1744(ra) # 5be6 <exit>
      printf("%s: write bigfile failed\n", s);
    52be:	85d6                	mv	a1,s5
    52c0:	00003517          	auipc	a0,0x3
    52c4:	cc050513          	addi	a0,a0,-832 # 7f80 <malloc+0x1f54>
    52c8:	00001097          	auipc	ra,0x1
    52cc:	ca6080e7          	jalr	-858(ra) # 5f6e <printf>
      exit(1);
    52d0:	4505                	li	a0,1
    52d2:	00001097          	auipc	ra,0x1
    52d6:	914080e7          	jalr	-1772(ra) # 5be6 <exit>
    printf("%s: cannot open bigfile\n", s);
    52da:	85d6                	mv	a1,s5
    52dc:	00003517          	auipc	a0,0x3
    52e0:	cc450513          	addi	a0,a0,-828 # 7fa0 <malloc+0x1f74>
    52e4:	00001097          	auipc	ra,0x1
    52e8:	c8a080e7          	jalr	-886(ra) # 5f6e <printf>
    exit(1);
    52ec:	4505                	li	a0,1
    52ee:	00001097          	auipc	ra,0x1
    52f2:	8f8080e7          	jalr	-1800(ra) # 5be6 <exit>
      printf("%s: read bigfile failed\n", s);
    52f6:	85d6                	mv	a1,s5
    52f8:	00003517          	auipc	a0,0x3
    52fc:	cc850513          	addi	a0,a0,-824 # 7fc0 <malloc+0x1f94>
    5300:	00001097          	auipc	ra,0x1
    5304:	c6e080e7          	jalr	-914(ra) # 5f6e <printf>
      exit(1);
    5308:	4505                	li	a0,1
    530a:	00001097          	auipc	ra,0x1
    530e:	8dc080e7          	jalr	-1828(ra) # 5be6 <exit>
      printf("%s: short read bigfile\n", s);
    5312:	85d6                	mv	a1,s5
    5314:	00003517          	auipc	a0,0x3
    5318:	ccc50513          	addi	a0,a0,-820 # 7fe0 <malloc+0x1fb4>
    531c:	00001097          	auipc	ra,0x1
    5320:	c52080e7          	jalr	-942(ra) # 5f6e <printf>
      exit(1);
    5324:	4505                	li	a0,1
    5326:	00001097          	auipc	ra,0x1
    532a:	8c0080e7          	jalr	-1856(ra) # 5be6 <exit>
      printf("%s: read bigfile wrong data\n", s);
    532e:	85d6                	mv	a1,s5
    5330:	00003517          	auipc	a0,0x3
    5334:	cc850513          	addi	a0,a0,-824 # 7ff8 <malloc+0x1fcc>
    5338:	00001097          	auipc	ra,0x1
    533c:	c36080e7          	jalr	-970(ra) # 5f6e <printf>
      exit(1);
    5340:	4505                	li	a0,1
    5342:	00001097          	auipc	ra,0x1
    5346:	8a4080e7          	jalr	-1884(ra) # 5be6 <exit>
  close(fd);
    534a:	8552                	mv	a0,s4
    534c:	00001097          	auipc	ra,0x1
    5350:	8c2080e7          	jalr	-1854(ra) # 5c0e <close>
  if(total != N*SZ){
    5354:	678d                	lui	a5,0x3
    5356:	ee078793          	addi	a5,a5,-288 # 2ee0 <sbrklast+0x86>
    535a:	02f99363          	bne	s3,a5,5380 <bigfile+0x1c4>
  unlink("bigfile.dat");
    535e:	00003517          	auipc	a0,0x3
    5362:	bf250513          	addi	a0,a0,-1038 # 7f50 <malloc+0x1f24>
    5366:	00001097          	auipc	ra,0x1
    536a:	8d0080e7          	jalr	-1840(ra) # 5c36 <unlink>
}
    536e:	70e2                	ld	ra,56(sp)
    5370:	7442                	ld	s0,48(sp)
    5372:	74a2                	ld	s1,40(sp)
    5374:	7902                	ld	s2,32(sp)
    5376:	69e2                	ld	s3,24(sp)
    5378:	6a42                	ld	s4,16(sp)
    537a:	6aa2                	ld	s5,8(sp)
    537c:	6121                	addi	sp,sp,64
    537e:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    5380:	85d6                	mv	a1,s5
    5382:	00003517          	auipc	a0,0x3
    5386:	c9650513          	addi	a0,a0,-874 # 8018 <malloc+0x1fec>
    538a:	00001097          	auipc	ra,0x1
    538e:	be4080e7          	jalr	-1052(ra) # 5f6e <printf>
    exit(1);
    5392:	4505                	li	a0,1
    5394:	00001097          	auipc	ra,0x1
    5398:	852080e7          	jalr	-1966(ra) # 5be6 <exit>

000000000000539c <fsfull>:
{
    539c:	7171                	addi	sp,sp,-176
    539e:	f506                	sd	ra,168(sp)
    53a0:	f122                	sd	s0,160(sp)
    53a2:	ed26                	sd	s1,152(sp)
    53a4:	e94a                	sd	s2,144(sp)
    53a6:	e54e                	sd	s3,136(sp)
    53a8:	e152                	sd	s4,128(sp)
    53aa:	fcd6                	sd	s5,120(sp)
    53ac:	f8da                	sd	s6,112(sp)
    53ae:	f4de                	sd	s7,104(sp)
    53b0:	f0e2                	sd	s8,96(sp)
    53b2:	ece6                	sd	s9,88(sp)
    53b4:	e8ea                	sd	s10,80(sp)
    53b6:	e4ee                	sd	s11,72(sp)
    53b8:	1900                	addi	s0,sp,176
  printf("fsfull test\n");
    53ba:	00003517          	auipc	a0,0x3
    53be:	c7e50513          	addi	a0,a0,-898 # 8038 <malloc+0x200c>
    53c2:	00001097          	auipc	ra,0x1
    53c6:	bac080e7          	jalr	-1108(ra) # 5f6e <printf>
  for(nfiles = 0; ; nfiles++){
    53ca:	4481                	li	s1,0
    name[0] = 'f';
    53cc:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    53d0:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    53d4:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    53d8:	4b29                	li	s6,10
    printf("writing %s\n", name);
    53da:	00003c97          	auipc	s9,0x3
    53de:	c6ec8c93          	addi	s9,s9,-914 # 8048 <malloc+0x201c>
    int total = 0;
    53e2:	4d81                	li	s11,0
      int cc = write(fd, buf, BSIZE);
    53e4:	00008a17          	auipc	s4,0x8
    53e8:	894a0a13          	addi	s4,s4,-1900 # cc78 <buf>
    name[0] = 'f';
    53ec:	f5a40823          	sb	s10,-176(s0)
    name[1] = '0' + nfiles / 1000;
    53f0:	0384c7bb          	divw	a5,s1,s8
    53f4:	0307879b          	addiw	a5,a5,48
    53f8:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    53fc:	0384e7bb          	remw	a5,s1,s8
    5400:	0377c7bb          	divw	a5,a5,s7
    5404:	0307879b          	addiw	a5,a5,48
    5408:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    540c:	0374e7bb          	remw	a5,s1,s7
    5410:	0367c7bb          	divw	a5,a5,s6
    5414:	0307879b          	addiw	a5,a5,48
    5418:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    541c:	0364e7bb          	remw	a5,s1,s6
    5420:	0307879b          	addiw	a5,a5,48
    5424:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    5428:	f4040aa3          	sb	zero,-171(s0)
    printf("writing %s\n", name);
    542c:	f5040593          	addi	a1,s0,-176
    5430:	8566                	mv	a0,s9
    5432:	00001097          	auipc	ra,0x1
    5436:	b3c080e7          	jalr	-1220(ra) # 5f6e <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    543a:	20200593          	li	a1,514
    543e:	f5040513          	addi	a0,s0,-176
    5442:	00000097          	auipc	ra,0x0
    5446:	7e4080e7          	jalr	2020(ra) # 5c26 <open>
    544a:	892a                	mv	s2,a0
    if(fd < 0){
    544c:	0a055663          	bgez	a0,54f8 <fsfull+0x15c>
      printf("open %s failed\n", name);
    5450:	f5040593          	addi	a1,s0,-176
    5454:	00003517          	auipc	a0,0x3
    5458:	c0450513          	addi	a0,a0,-1020 # 8058 <malloc+0x202c>
    545c:	00001097          	auipc	ra,0x1
    5460:	b12080e7          	jalr	-1262(ra) # 5f6e <printf>
  while(nfiles >= 0){
    5464:	0604c363          	bltz	s1,54ca <fsfull+0x12e>
    name[0] = 'f';
    5468:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    546c:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    5470:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    5474:	4929                	li	s2,10
  while(nfiles >= 0){
    5476:	5afd                	li	s5,-1
    name[0] = 'f';
    5478:	f5640823          	sb	s6,-176(s0)
    name[1] = '0' + nfiles / 1000;
    547c:	0344c7bb          	divw	a5,s1,s4
    5480:	0307879b          	addiw	a5,a5,48
    5484:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    5488:	0344e7bb          	remw	a5,s1,s4
    548c:	0337c7bb          	divw	a5,a5,s3
    5490:	0307879b          	addiw	a5,a5,48
    5494:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    5498:	0334e7bb          	remw	a5,s1,s3
    549c:	0327c7bb          	divw	a5,a5,s2
    54a0:	0307879b          	addiw	a5,a5,48
    54a4:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    54a8:	0324e7bb          	remw	a5,s1,s2
    54ac:	0307879b          	addiw	a5,a5,48
    54b0:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    54b4:	f4040aa3          	sb	zero,-171(s0)
    unlink(name);
    54b8:	f5040513          	addi	a0,s0,-176
    54bc:	00000097          	auipc	ra,0x0
    54c0:	77a080e7          	jalr	1914(ra) # 5c36 <unlink>
    nfiles--;
    54c4:	34fd                	addiw	s1,s1,-1
  while(nfiles >= 0){
    54c6:	fb5499e3          	bne	s1,s5,5478 <fsfull+0xdc>
  printf("fsfull test finished\n");
    54ca:	00003517          	auipc	a0,0x3
    54ce:	bae50513          	addi	a0,a0,-1106 # 8078 <malloc+0x204c>
    54d2:	00001097          	auipc	ra,0x1
    54d6:	a9c080e7          	jalr	-1380(ra) # 5f6e <printf>
}
    54da:	70aa                	ld	ra,168(sp)
    54dc:	740a                	ld	s0,160(sp)
    54de:	64ea                	ld	s1,152(sp)
    54e0:	694a                	ld	s2,144(sp)
    54e2:	69aa                	ld	s3,136(sp)
    54e4:	6a0a                	ld	s4,128(sp)
    54e6:	7ae6                	ld	s5,120(sp)
    54e8:	7b46                	ld	s6,112(sp)
    54ea:	7ba6                	ld	s7,104(sp)
    54ec:	7c06                	ld	s8,96(sp)
    54ee:	6ce6                	ld	s9,88(sp)
    54f0:	6d46                	ld	s10,80(sp)
    54f2:	6da6                	ld	s11,72(sp)
    54f4:	614d                	addi	sp,sp,176
    54f6:	8082                	ret
    int total = 0;
    54f8:	89ee                	mv	s3,s11
      if(cc < BSIZE)
    54fa:	3ff00a93          	li	s5,1023
      int cc = write(fd, buf, BSIZE);
    54fe:	40000613          	li	a2,1024
    5502:	85d2                	mv	a1,s4
    5504:	854a                	mv	a0,s2
    5506:	00000097          	auipc	ra,0x0
    550a:	700080e7          	jalr	1792(ra) # 5c06 <write>
      if(cc < BSIZE)
    550e:	00aad563          	bge	s5,a0,5518 <fsfull+0x17c>
      total += cc;
    5512:	00a989bb          	addw	s3,s3,a0
    while(1){
    5516:	b7e5                	j	54fe <fsfull+0x162>
    printf("wrote %d bytes\n", total);
    5518:	85ce                	mv	a1,s3
    551a:	00003517          	auipc	a0,0x3
    551e:	b4e50513          	addi	a0,a0,-1202 # 8068 <malloc+0x203c>
    5522:	00001097          	auipc	ra,0x1
    5526:	a4c080e7          	jalr	-1460(ra) # 5f6e <printf>
    close(fd);
    552a:	854a                	mv	a0,s2
    552c:	00000097          	auipc	ra,0x0
    5530:	6e2080e7          	jalr	1762(ra) # 5c0e <close>
    if(total == 0)
    5534:	f20988e3          	beqz	s3,5464 <fsfull+0xc8>
  for(nfiles = 0; ; nfiles++){
    5538:	2485                	addiw	s1,s1,1
    553a:	bd4d                	j	53ec <fsfull+0x50>

000000000000553c <run>:
//

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    553c:	7179                	addi	sp,sp,-48
    553e:	f406                	sd	ra,40(sp)
    5540:	f022                	sd	s0,32(sp)
    5542:	ec26                	sd	s1,24(sp)
    5544:	e84a                	sd	s2,16(sp)
    5546:	1800                	addi	s0,sp,48
    5548:	84aa                	mv	s1,a0
    554a:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    554c:	00003517          	auipc	a0,0x3
    5550:	b4450513          	addi	a0,a0,-1212 # 8090 <malloc+0x2064>
    5554:	00001097          	auipc	ra,0x1
    5558:	a1a080e7          	jalr	-1510(ra) # 5f6e <printf>
  if((pid = fork()) < 0) {
    555c:	00000097          	auipc	ra,0x0
    5560:	682080e7          	jalr	1666(ra) # 5bde <fork>
    5564:	02054e63          	bltz	a0,55a0 <run+0x64>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    5568:	c929                	beqz	a0,55ba <run+0x7e>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    556a:	fdc40513          	addi	a0,s0,-36
    556e:	00000097          	auipc	ra,0x0
    5572:	680080e7          	jalr	1664(ra) # 5bee <wait>
    if(xstatus != 0) 
    5576:	fdc42783          	lw	a5,-36(s0)
    557a:	c7b9                	beqz	a5,55c8 <run+0x8c>
      printf("FAILED\n");
    557c:	00003517          	auipc	a0,0x3
    5580:	b3c50513          	addi	a0,a0,-1220 # 80b8 <malloc+0x208c>
    5584:	00001097          	auipc	ra,0x1
    5588:	9ea080e7          	jalr	-1558(ra) # 5f6e <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    558c:	fdc42503          	lw	a0,-36(s0)
  }
}
    5590:	00153513          	seqz	a0,a0
    5594:	70a2                	ld	ra,40(sp)
    5596:	7402                	ld	s0,32(sp)
    5598:	64e2                	ld	s1,24(sp)
    559a:	6942                	ld	s2,16(sp)
    559c:	6145                	addi	sp,sp,48
    559e:	8082                	ret
    printf("runtest: fork error\n");
    55a0:	00003517          	auipc	a0,0x3
    55a4:	b0050513          	addi	a0,a0,-1280 # 80a0 <malloc+0x2074>
    55a8:	00001097          	auipc	ra,0x1
    55ac:	9c6080e7          	jalr	-1594(ra) # 5f6e <printf>
    exit(1);
    55b0:	4505                	li	a0,1
    55b2:	00000097          	auipc	ra,0x0
    55b6:	634080e7          	jalr	1588(ra) # 5be6 <exit>
    f(s);
    55ba:	854a                	mv	a0,s2
    55bc:	9482                	jalr	s1
    exit(0);
    55be:	4501                	li	a0,0
    55c0:	00000097          	auipc	ra,0x0
    55c4:	626080e7          	jalr	1574(ra) # 5be6 <exit>
      printf("OK\n");
    55c8:	00003517          	auipc	a0,0x3
    55cc:	af850513          	addi	a0,a0,-1288 # 80c0 <malloc+0x2094>
    55d0:	00001097          	auipc	ra,0x1
    55d4:	99e080e7          	jalr	-1634(ra) # 5f6e <printf>
    55d8:	bf55                	j	558c <run+0x50>

00000000000055da <runtests>:

int
runtests(struct test *tests, char *justone) {
    55da:	1101                	addi	sp,sp,-32
    55dc:	ec06                	sd	ra,24(sp)
    55de:	e822                	sd	s0,16(sp)
    55e0:	e426                	sd	s1,8(sp)
    55e2:	e04a                	sd	s2,0(sp)
    55e4:	1000                	addi	s0,sp,32
    55e6:	84aa                	mv	s1,a0
    55e8:	892e                	mv	s2,a1
  for (struct test *t = tests; t->s != 0; t++) {
    55ea:	6508                	ld	a0,8(a0)
    55ec:	ed09                	bnez	a0,5606 <runtests+0x2c>
        printf("SOME TESTS FAILED\n");
        return 1;
      }
    }
  }
  return 0;
    55ee:	4501                	li	a0,0
    55f0:	a82d                	j	562a <runtests+0x50>
      if(!run(t->f, t->s)){
    55f2:	648c                	ld	a1,8(s1)
    55f4:	6088                	ld	a0,0(s1)
    55f6:	00000097          	auipc	ra,0x0
    55fa:	f46080e7          	jalr	-186(ra) # 553c <run>
    55fe:	cd09                	beqz	a0,5618 <runtests+0x3e>
  for (struct test *t = tests; t->s != 0; t++) {
    5600:	04c1                	addi	s1,s1,16
    5602:	6488                	ld	a0,8(s1)
    5604:	c11d                	beqz	a0,562a <runtests+0x50>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    5606:	fe0906e3          	beqz	s2,55f2 <runtests+0x18>
    560a:	85ca                	mv	a1,s2
    560c:	00000097          	auipc	ra,0x0
    5610:	36a080e7          	jalr	874(ra) # 5976 <strcmp>
    5614:	f575                	bnez	a0,5600 <runtests+0x26>
    5616:	bff1                	j	55f2 <runtests+0x18>
        printf("SOME TESTS FAILED\n");
    5618:	00003517          	auipc	a0,0x3
    561c:	ab050513          	addi	a0,a0,-1360 # 80c8 <malloc+0x209c>
    5620:	00001097          	auipc	ra,0x1
    5624:	94e080e7          	jalr	-1714(ra) # 5f6e <printf>
        return 1;
    5628:	4505                	li	a0,1
}
    562a:	60e2                	ld	ra,24(sp)
    562c:	6442                	ld	s0,16(sp)
    562e:	64a2                	ld	s1,8(sp)
    5630:	6902                	ld	s2,0(sp)
    5632:	6105                	addi	sp,sp,32
    5634:	8082                	ret

0000000000005636 <countfree>:
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int
countfree()
{
    5636:	7139                	addi	sp,sp,-64
    5638:	fc06                	sd	ra,56(sp)
    563a:	f822                	sd	s0,48(sp)
    563c:	f426                	sd	s1,40(sp)
    563e:	f04a                	sd	s2,32(sp)
    5640:	ec4e                	sd	s3,24(sp)
    5642:	0080                	addi	s0,sp,64
  int fds[2];

  if(pipe(fds) < 0){
    5644:	fc840513          	addi	a0,s0,-56
    5648:	00000097          	auipc	ra,0x0
    564c:	5ae080e7          	jalr	1454(ra) # 5bf6 <pipe>
    5650:	06054863          	bltz	a0,56c0 <countfree+0x8a>
    printf("pipe() failed in countfree()\n");
    exit(1);
  }
  
  int pid = fork();
    5654:	00000097          	auipc	ra,0x0
    5658:	58a080e7          	jalr	1418(ra) # 5bde <fork>

  if(pid < 0){
    565c:	06054f63          	bltz	a0,56da <countfree+0xa4>
    printf("fork failed in countfree()\n");
    exit(1);
  }

  if(pid == 0){
    5660:	ed59                	bnez	a0,56fe <countfree+0xc8>
    close(fds[0]);
    5662:	fc842503          	lw	a0,-56(s0)
    5666:	00000097          	auipc	ra,0x0
    566a:	5a8080e7          	jalr	1448(ra) # 5c0e <close>
    
    while(1){
      uint64 a = (uint64) sbrk(4096);
      if(a == 0xffffffffffffffff){
    566e:	54fd                	li	s1,-1
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    5670:	4985                	li	s3,1

      // report back one more page.
      if(write(fds[1], "x", 1) != 1){
    5672:	00001917          	auipc	s2,0x1
    5676:	b6690913          	addi	s2,s2,-1178 # 61d8 <malloc+0x1ac>
      uint64 a = (uint64) sbrk(4096);
    567a:	6505                	lui	a0,0x1
    567c:	00000097          	auipc	ra,0x0
    5680:	5f2080e7          	jalr	1522(ra) # 5c6e <sbrk>
      if(a == 0xffffffffffffffff){
    5684:	06950863          	beq	a0,s1,56f4 <countfree+0xbe>
      *(char *)(a + 4096 - 1) = 1;
    5688:	6785                	lui	a5,0x1
    568a:	953e                	add	a0,a0,a5
    568c:	ff350fa3          	sb	s3,-1(a0) # fff <linktest+0x109>
      if(write(fds[1], "x", 1) != 1){
    5690:	4605                	li	a2,1
    5692:	85ca                	mv	a1,s2
    5694:	fcc42503          	lw	a0,-52(s0)
    5698:	00000097          	auipc	ra,0x0
    569c:	56e080e7          	jalr	1390(ra) # 5c06 <write>
    56a0:	4785                	li	a5,1
    56a2:	fcf50ce3          	beq	a0,a5,567a <countfree+0x44>
        printf("write() failed in countfree()\n");
    56a6:	00003517          	auipc	a0,0x3
    56aa:	a7a50513          	addi	a0,a0,-1414 # 8120 <malloc+0x20f4>
    56ae:	00001097          	auipc	ra,0x1
    56b2:	8c0080e7          	jalr	-1856(ra) # 5f6e <printf>
        exit(1);
    56b6:	4505                	li	a0,1
    56b8:	00000097          	auipc	ra,0x0
    56bc:	52e080e7          	jalr	1326(ra) # 5be6 <exit>
    printf("pipe() failed in countfree()\n");
    56c0:	00003517          	auipc	a0,0x3
    56c4:	a2050513          	addi	a0,a0,-1504 # 80e0 <malloc+0x20b4>
    56c8:	00001097          	auipc	ra,0x1
    56cc:	8a6080e7          	jalr	-1882(ra) # 5f6e <printf>
    exit(1);
    56d0:	4505                	li	a0,1
    56d2:	00000097          	auipc	ra,0x0
    56d6:	514080e7          	jalr	1300(ra) # 5be6 <exit>
    printf("fork failed in countfree()\n");
    56da:	00003517          	auipc	a0,0x3
    56de:	a2650513          	addi	a0,a0,-1498 # 8100 <malloc+0x20d4>
    56e2:	00001097          	auipc	ra,0x1
    56e6:	88c080e7          	jalr	-1908(ra) # 5f6e <printf>
    exit(1);
    56ea:	4505                	li	a0,1
    56ec:	00000097          	auipc	ra,0x0
    56f0:	4fa080e7          	jalr	1274(ra) # 5be6 <exit>
      }
    }

    exit(0);
    56f4:	4501                	li	a0,0
    56f6:	00000097          	auipc	ra,0x0
    56fa:	4f0080e7          	jalr	1264(ra) # 5be6 <exit>
  }

  close(fds[1]);
    56fe:	fcc42503          	lw	a0,-52(s0)
    5702:	00000097          	auipc	ra,0x0
    5706:	50c080e7          	jalr	1292(ra) # 5c0e <close>

  int n = 0;
    570a:	4481                	li	s1,0
  while(1){
    char c;
    int cc = read(fds[0], &c, 1);
    570c:	4605                	li	a2,1
    570e:	fc740593          	addi	a1,s0,-57
    5712:	fc842503          	lw	a0,-56(s0)
    5716:	00000097          	auipc	ra,0x0
    571a:	4e8080e7          	jalr	1256(ra) # 5bfe <read>
    if(cc < 0){
    571e:	00054563          	bltz	a0,5728 <countfree+0xf2>
      printf("read() failed in countfree()\n");
      exit(1);
    }
    if(cc == 0)
    5722:	c105                	beqz	a0,5742 <countfree+0x10c>
      break;
    n += 1;
    5724:	2485                	addiw	s1,s1,1
  while(1){
    5726:	b7dd                	j	570c <countfree+0xd6>
      printf("read() failed in countfree()\n");
    5728:	00003517          	auipc	a0,0x3
    572c:	a1850513          	addi	a0,a0,-1512 # 8140 <malloc+0x2114>
    5730:	00001097          	auipc	ra,0x1
    5734:	83e080e7          	jalr	-1986(ra) # 5f6e <printf>
      exit(1);
    5738:	4505                	li	a0,1
    573a:	00000097          	auipc	ra,0x0
    573e:	4ac080e7          	jalr	1196(ra) # 5be6 <exit>
  }

  close(fds[0]);
    5742:	fc842503          	lw	a0,-56(s0)
    5746:	00000097          	auipc	ra,0x0
    574a:	4c8080e7          	jalr	1224(ra) # 5c0e <close>
  wait((int*)0);
    574e:	4501                	li	a0,0
    5750:	00000097          	auipc	ra,0x0
    5754:	49e080e7          	jalr	1182(ra) # 5bee <wait>
  
  return n;
}
    5758:	8526                	mv	a0,s1
    575a:	70e2                	ld	ra,56(sp)
    575c:	7442                	ld	s0,48(sp)
    575e:	74a2                	ld	s1,40(sp)
    5760:	7902                	ld	s2,32(sp)
    5762:	69e2                	ld	s3,24(sp)
    5764:	6121                	addi	sp,sp,64
    5766:	8082                	ret

0000000000005768 <drivetests>:

int
drivetests(int quick, int continuous, char *justone) {
    5768:	711d                	addi	sp,sp,-96
    576a:	ec86                	sd	ra,88(sp)
    576c:	e8a2                	sd	s0,80(sp)
    576e:	e4a6                	sd	s1,72(sp)
    5770:	e0ca                	sd	s2,64(sp)
    5772:	fc4e                	sd	s3,56(sp)
    5774:	f852                	sd	s4,48(sp)
    5776:	f456                	sd	s5,40(sp)
    5778:	f05a                	sd	s6,32(sp)
    577a:	ec5e                	sd	s7,24(sp)
    577c:	e862                	sd	s8,16(sp)
    577e:	e466                	sd	s9,8(sp)
    5780:	e06a                	sd	s10,0(sp)
    5782:	1080                	addi	s0,sp,96
    5784:	8a2a                	mv	s4,a0
    5786:	89ae                	mv	s3,a1
    5788:	8932                	mv	s2,a2
  do {
    printf("usertests starting\n");
    578a:	00003b97          	auipc	s7,0x3
    578e:	9d6b8b93          	addi	s7,s7,-1578 # 8160 <malloc+0x2134>
    int free0 = countfree();
    int free1 = 0;
    if (runtests(quicktests, justone)) {
    5792:	00004b17          	auipc	s6,0x4
    5796:	87eb0b13          	addi	s6,s6,-1922 # 9010 <quicktests>
      if(continuous != 2) {
    579a:	4a89                	li	s5,2
          return 1;
        }
      }
    }
    if((free1 = countfree()) < free0) {
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    579c:	00003c97          	auipc	s9,0x3
    57a0:	9fcc8c93          	addi	s9,s9,-1540 # 8198 <malloc+0x216c>
      if (runtests(slowtests, justone)) {
    57a4:	00004c17          	auipc	s8,0x4
    57a8:	c3cc0c13          	addi	s8,s8,-964 # 93e0 <slowtests>
        printf("usertests slow tests starting\n");
    57ac:	00003d17          	auipc	s10,0x3
    57b0:	9ccd0d13          	addi	s10,s10,-1588 # 8178 <malloc+0x214c>
    57b4:	a839                	j	57d2 <drivetests+0x6a>
    57b6:	856a                	mv	a0,s10
    57b8:	00000097          	auipc	ra,0x0
    57bc:	7b6080e7          	jalr	1974(ra) # 5f6e <printf>
    57c0:	a081                	j	5800 <drivetests+0x98>
    if((free1 = countfree()) < free0) {
    57c2:	00000097          	auipc	ra,0x0
    57c6:	e74080e7          	jalr	-396(ra) # 5636 <countfree>
    57ca:	06954263          	blt	a0,s1,582e <drivetests+0xc6>
      if(continuous != 2) {
        return 1;
      }
    }
  } while(continuous);
    57ce:	06098f63          	beqz	s3,584c <drivetests+0xe4>
    printf("usertests starting\n");
    57d2:	855e                	mv	a0,s7
    57d4:	00000097          	auipc	ra,0x0
    57d8:	79a080e7          	jalr	1946(ra) # 5f6e <printf>
    int free0 = countfree();
    57dc:	00000097          	auipc	ra,0x0
    57e0:	e5a080e7          	jalr	-422(ra) # 5636 <countfree>
    57e4:	84aa                	mv	s1,a0
    if (runtests(quicktests, justone)) {
    57e6:	85ca                	mv	a1,s2
    57e8:	855a                	mv	a0,s6
    57ea:	00000097          	auipc	ra,0x0
    57ee:	df0080e7          	jalr	-528(ra) # 55da <runtests>
    57f2:	c119                	beqz	a0,57f8 <drivetests+0x90>
      if(continuous != 2) {
    57f4:	05599863          	bne	s3,s5,5844 <drivetests+0xdc>
    if(!quick) {
    57f8:	fc0a15e3          	bnez	s4,57c2 <drivetests+0x5a>
      if (justone == 0)
    57fc:	fa090de3          	beqz	s2,57b6 <drivetests+0x4e>
      if (runtests(slowtests, justone)) {
    5800:	85ca                	mv	a1,s2
    5802:	8562                	mv	a0,s8
    5804:	00000097          	auipc	ra,0x0
    5808:	dd6080e7          	jalr	-554(ra) # 55da <runtests>
    580c:	d95d                	beqz	a0,57c2 <drivetests+0x5a>
        if(continuous != 2) {
    580e:	03599d63          	bne	s3,s5,5848 <drivetests+0xe0>
    if((free1 = countfree()) < free0) {
    5812:	00000097          	auipc	ra,0x0
    5816:	e24080e7          	jalr	-476(ra) # 5636 <countfree>
    581a:	fa955ae3          	bge	a0,s1,57ce <drivetests+0x66>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    581e:	8626                	mv	a2,s1
    5820:	85aa                	mv	a1,a0
    5822:	8566                	mv	a0,s9
    5824:	00000097          	auipc	ra,0x0
    5828:	74a080e7          	jalr	1866(ra) # 5f6e <printf>
      if(continuous != 2) {
    582c:	b75d                	j	57d2 <drivetests+0x6a>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    582e:	8626                	mv	a2,s1
    5830:	85aa                	mv	a1,a0
    5832:	8566                	mv	a0,s9
    5834:	00000097          	auipc	ra,0x0
    5838:	73a080e7          	jalr	1850(ra) # 5f6e <printf>
      if(continuous != 2) {
    583c:	f9598be3          	beq	s3,s5,57d2 <drivetests+0x6a>
        return 1;
    5840:	4505                	li	a0,1
    5842:	a031                	j	584e <drivetests+0xe6>
        return 1;
    5844:	4505                	li	a0,1
    5846:	a021                	j	584e <drivetests+0xe6>
          return 1;
    5848:	4505                	li	a0,1
    584a:	a011                	j	584e <drivetests+0xe6>
  return 0;
    584c:	854e                	mv	a0,s3
}
    584e:	60e6                	ld	ra,88(sp)
    5850:	6446                	ld	s0,80(sp)
    5852:	64a6                	ld	s1,72(sp)
    5854:	6906                	ld	s2,64(sp)
    5856:	79e2                	ld	s3,56(sp)
    5858:	7a42                	ld	s4,48(sp)
    585a:	7aa2                	ld	s5,40(sp)
    585c:	7b02                	ld	s6,32(sp)
    585e:	6be2                	ld	s7,24(sp)
    5860:	6c42                	ld	s8,16(sp)
    5862:	6ca2                	ld	s9,8(sp)
    5864:	6d02                	ld	s10,0(sp)
    5866:	6125                	addi	sp,sp,96
    5868:	8082                	ret

000000000000586a <main>:

int
main(int argc, char *argv[])
{
    586a:	1101                	addi	sp,sp,-32
    586c:	ec06                	sd	ra,24(sp)
    586e:	e822                	sd	s0,16(sp)
    5870:	e426                	sd	s1,8(sp)
    5872:	e04a                	sd	s2,0(sp)
    5874:	1000                	addi	s0,sp,32
    5876:	84aa                	mv	s1,a0
  int continuous = 0;
  int quick = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    5878:	4789                	li	a5,2
    587a:	02f50363          	beq	a0,a5,58a0 <main+0x36>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    587e:	4785                	li	a5,1
    5880:	06a7cd63          	blt	a5,a0,58fa <main+0x90>
  char *justone = 0;
    5884:	4601                	li	a2,0
  int quick = 0;
    5886:	4501                	li	a0,0
  int continuous = 0;
    5888:	4481                	li	s1,0
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    exit(1);
  }
  if (drivetests(quick, continuous, justone)) {
    588a:	85a6                	mv	a1,s1
    588c:	00000097          	auipc	ra,0x0
    5890:	edc080e7          	jalr	-292(ra) # 5768 <drivetests>
    5894:	c949                	beqz	a0,5926 <main+0xbc>
    exit(1);
    5896:	4505                	li	a0,1
    5898:	00000097          	auipc	ra,0x0
    589c:	34e080e7          	jalr	846(ra) # 5be6 <exit>
    58a0:	892e                	mv	s2,a1
  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    58a2:	00003597          	auipc	a1,0x3
    58a6:	92658593          	addi	a1,a1,-1754 # 81c8 <malloc+0x219c>
    58aa:	00893503          	ld	a0,8(s2)
    58ae:	00000097          	auipc	ra,0x0
    58b2:	0c8080e7          	jalr	200(ra) # 5976 <strcmp>
    58b6:	cd39                	beqz	a0,5914 <main+0xaa>
  } else if(argc == 2 && strcmp(argv[1], "-c") == 0){
    58b8:	00003597          	auipc	a1,0x3
    58bc:	96858593          	addi	a1,a1,-1688 # 8220 <malloc+0x21f4>
    58c0:	00893503          	ld	a0,8(s2)
    58c4:	00000097          	auipc	ra,0x0
    58c8:	0b2080e7          	jalr	178(ra) # 5976 <strcmp>
    58cc:	c931                	beqz	a0,5920 <main+0xb6>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    58ce:	00003597          	auipc	a1,0x3
    58d2:	94a58593          	addi	a1,a1,-1718 # 8218 <malloc+0x21ec>
    58d6:	00893503          	ld	a0,8(s2)
    58da:	00000097          	auipc	ra,0x0
    58de:	09c080e7          	jalr	156(ra) # 5976 <strcmp>
    58e2:	cd0d                	beqz	a0,591c <main+0xb2>
  } else if(argc == 2 && argv[1][0] != '-'){
    58e4:	00893603          	ld	a2,8(s2)
    58e8:	00064703          	lbu	a4,0(a2) # 3000 <execout+0x9e>
    58ec:	02d00793          	li	a5,45
    58f0:	00f70563          	beq	a4,a5,58fa <main+0x90>
  int quick = 0;
    58f4:	4501                	li	a0,0
  int continuous = 0;
    58f6:	4481                	li	s1,0
    58f8:	bf49                	j	588a <main+0x20>
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    58fa:	00003517          	auipc	a0,0x3
    58fe:	8d650513          	addi	a0,a0,-1834 # 81d0 <malloc+0x21a4>
    5902:	00000097          	auipc	ra,0x0
    5906:	66c080e7          	jalr	1644(ra) # 5f6e <printf>
    exit(1);
    590a:	4505                	li	a0,1
    590c:	00000097          	auipc	ra,0x0
    5910:	2da080e7          	jalr	730(ra) # 5be6 <exit>
  int continuous = 0;
    5914:	84aa                	mv	s1,a0
  char *justone = 0;
    5916:	4601                	li	a2,0
    quick = 1;
    5918:	4505                	li	a0,1
    591a:	bf85                	j	588a <main+0x20>
  char *justone = 0;
    591c:	4601                	li	a2,0
    591e:	b7b5                	j	588a <main+0x20>
    5920:	4601                	li	a2,0
    continuous = 1;
    5922:	4485                	li	s1,1
    5924:	b79d                	j	588a <main+0x20>
  }
  printf("ALL TESTS PASSED\n");
    5926:	00003517          	auipc	a0,0x3
    592a:	8da50513          	addi	a0,a0,-1830 # 8200 <malloc+0x21d4>
    592e:	00000097          	auipc	ra,0x0
    5932:	640080e7          	jalr	1600(ra) # 5f6e <printf>
  exit(0);
    5936:	4501                	li	a0,0
    5938:	00000097          	auipc	ra,0x0
    593c:	2ae080e7          	jalr	686(ra) # 5be6 <exit>

0000000000005940 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
    5940:	1141                	addi	sp,sp,-16
    5942:	e406                	sd	ra,8(sp)
    5944:	e022                	sd	s0,0(sp)
    5946:	0800                	addi	s0,sp,16
  extern int main();
  main();
    5948:	00000097          	auipc	ra,0x0
    594c:	f22080e7          	jalr	-222(ra) # 586a <main>
  exit(0);
    5950:	4501                	li	a0,0
    5952:	00000097          	auipc	ra,0x0
    5956:	294080e7          	jalr	660(ra) # 5be6 <exit>

000000000000595a <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
    595a:	1141                	addi	sp,sp,-16
    595c:	e422                	sd	s0,8(sp)
    595e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    5960:	87aa                	mv	a5,a0
    5962:	0585                	addi	a1,a1,1
    5964:	0785                	addi	a5,a5,1
    5966:	fff5c703          	lbu	a4,-1(a1)
    596a:	fee78fa3          	sb	a4,-1(a5) # fff <linktest+0x109>
    596e:	fb75                	bnez	a4,5962 <strcpy+0x8>
    ;
  return os;
}
    5970:	6422                	ld	s0,8(sp)
    5972:	0141                	addi	sp,sp,16
    5974:	8082                	ret

0000000000005976 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    5976:	1141                	addi	sp,sp,-16
    5978:	e422                	sd	s0,8(sp)
    597a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    597c:	00054783          	lbu	a5,0(a0)
    5980:	cb91                	beqz	a5,5994 <strcmp+0x1e>
    5982:	0005c703          	lbu	a4,0(a1)
    5986:	00f71763          	bne	a4,a5,5994 <strcmp+0x1e>
    p++, q++;
    598a:	0505                	addi	a0,a0,1
    598c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    598e:	00054783          	lbu	a5,0(a0)
    5992:	fbe5                	bnez	a5,5982 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    5994:	0005c503          	lbu	a0,0(a1)
}
    5998:	40a7853b          	subw	a0,a5,a0
    599c:	6422                	ld	s0,8(sp)
    599e:	0141                	addi	sp,sp,16
    59a0:	8082                	ret

00000000000059a2 <strlen>:

uint
strlen(const char *s)
{
    59a2:	1141                	addi	sp,sp,-16
    59a4:	e422                	sd	s0,8(sp)
    59a6:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    59a8:	00054783          	lbu	a5,0(a0)
    59ac:	cf91                	beqz	a5,59c8 <strlen+0x26>
    59ae:	0505                	addi	a0,a0,1
    59b0:	87aa                	mv	a5,a0
    59b2:	4685                	li	a3,1
    59b4:	9e89                	subw	a3,a3,a0
    59b6:	00f6853b          	addw	a0,a3,a5
    59ba:	0785                	addi	a5,a5,1
    59bc:	fff7c703          	lbu	a4,-1(a5)
    59c0:	fb7d                	bnez	a4,59b6 <strlen+0x14>
    ;
  return n;
}
    59c2:	6422                	ld	s0,8(sp)
    59c4:	0141                	addi	sp,sp,16
    59c6:	8082                	ret
  for(n = 0; s[n]; n++)
    59c8:	4501                	li	a0,0
    59ca:	bfe5                	j	59c2 <strlen+0x20>

00000000000059cc <memset>:

void*
memset(void *dst, int c, uint n)
{
    59cc:	1141                	addi	sp,sp,-16
    59ce:	e422                	sd	s0,8(sp)
    59d0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    59d2:	ce09                	beqz	a2,59ec <memset+0x20>
    59d4:	87aa                	mv	a5,a0
    59d6:	fff6071b          	addiw	a4,a2,-1
    59da:	1702                	slli	a4,a4,0x20
    59dc:	9301                	srli	a4,a4,0x20
    59de:	0705                	addi	a4,a4,1
    59e0:	972a                	add	a4,a4,a0
    cdst[i] = c;
    59e2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    59e6:	0785                	addi	a5,a5,1
    59e8:	fee79de3          	bne	a5,a4,59e2 <memset+0x16>
  }
  return dst;
}
    59ec:	6422                	ld	s0,8(sp)
    59ee:	0141                	addi	sp,sp,16
    59f0:	8082                	ret

00000000000059f2 <strchr>:

char*
strchr(const char *s, char c)
{
    59f2:	1141                	addi	sp,sp,-16
    59f4:	e422                	sd	s0,8(sp)
    59f6:	0800                	addi	s0,sp,16
  for(; *s; s++)
    59f8:	00054783          	lbu	a5,0(a0)
    59fc:	cb99                	beqz	a5,5a12 <strchr+0x20>
    if(*s == c)
    59fe:	00f58763          	beq	a1,a5,5a0c <strchr+0x1a>
  for(; *s; s++)
    5a02:	0505                	addi	a0,a0,1
    5a04:	00054783          	lbu	a5,0(a0)
    5a08:	fbfd                	bnez	a5,59fe <strchr+0xc>
      return (char*)s;
  return 0;
    5a0a:	4501                	li	a0,0
}
    5a0c:	6422                	ld	s0,8(sp)
    5a0e:	0141                	addi	sp,sp,16
    5a10:	8082                	ret
  return 0;
    5a12:	4501                	li	a0,0
    5a14:	bfe5                	j	5a0c <strchr+0x1a>

0000000000005a16 <gets>:

char*
gets(char *buf, int max)
{
    5a16:	711d                	addi	sp,sp,-96
    5a18:	ec86                	sd	ra,88(sp)
    5a1a:	e8a2                	sd	s0,80(sp)
    5a1c:	e4a6                	sd	s1,72(sp)
    5a1e:	e0ca                	sd	s2,64(sp)
    5a20:	fc4e                	sd	s3,56(sp)
    5a22:	f852                	sd	s4,48(sp)
    5a24:	f456                	sd	s5,40(sp)
    5a26:	f05a                	sd	s6,32(sp)
    5a28:	ec5e                	sd	s7,24(sp)
    5a2a:	1080                	addi	s0,sp,96
    5a2c:	8baa                	mv	s7,a0
    5a2e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    5a30:	892a                	mv	s2,a0
    5a32:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    5a34:	4aa9                	li	s5,10
    5a36:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    5a38:	89a6                	mv	s3,s1
    5a3a:	2485                	addiw	s1,s1,1
    5a3c:	0344d863          	bge	s1,s4,5a6c <gets+0x56>
    cc = read(0, &c, 1);
    5a40:	4605                	li	a2,1
    5a42:	faf40593          	addi	a1,s0,-81
    5a46:	4501                	li	a0,0
    5a48:	00000097          	auipc	ra,0x0
    5a4c:	1b6080e7          	jalr	438(ra) # 5bfe <read>
    if(cc < 1)
    5a50:	00a05e63          	blez	a0,5a6c <gets+0x56>
    buf[i++] = c;
    5a54:	faf44783          	lbu	a5,-81(s0)
    5a58:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    5a5c:	01578763          	beq	a5,s5,5a6a <gets+0x54>
    5a60:	0905                	addi	s2,s2,1
    5a62:	fd679be3          	bne	a5,s6,5a38 <gets+0x22>
  for(i=0; i+1 < max; ){
    5a66:	89a6                	mv	s3,s1
    5a68:	a011                	j	5a6c <gets+0x56>
    5a6a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    5a6c:	99de                	add	s3,s3,s7
    5a6e:	00098023          	sb	zero,0(s3)
  return buf;
}
    5a72:	855e                	mv	a0,s7
    5a74:	60e6                	ld	ra,88(sp)
    5a76:	6446                	ld	s0,80(sp)
    5a78:	64a6                	ld	s1,72(sp)
    5a7a:	6906                	ld	s2,64(sp)
    5a7c:	79e2                	ld	s3,56(sp)
    5a7e:	7a42                	ld	s4,48(sp)
    5a80:	7aa2                	ld	s5,40(sp)
    5a82:	7b02                	ld	s6,32(sp)
    5a84:	6be2                	ld	s7,24(sp)
    5a86:	6125                	addi	sp,sp,96
    5a88:	8082                	ret

0000000000005a8a <stat>:

int
stat(const char *n, struct stat *st)
{
    5a8a:	1101                	addi	sp,sp,-32
    5a8c:	ec06                	sd	ra,24(sp)
    5a8e:	e822                	sd	s0,16(sp)
    5a90:	e426                	sd	s1,8(sp)
    5a92:	e04a                	sd	s2,0(sp)
    5a94:	1000                	addi	s0,sp,32
    5a96:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    5a98:	4581                	li	a1,0
    5a9a:	00000097          	auipc	ra,0x0
    5a9e:	18c080e7          	jalr	396(ra) # 5c26 <open>
  if(fd < 0)
    5aa2:	02054563          	bltz	a0,5acc <stat+0x42>
    5aa6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    5aa8:	85ca                	mv	a1,s2
    5aaa:	00000097          	auipc	ra,0x0
    5aae:	194080e7          	jalr	404(ra) # 5c3e <fstat>
    5ab2:	892a                	mv	s2,a0
  close(fd);
    5ab4:	8526                	mv	a0,s1
    5ab6:	00000097          	auipc	ra,0x0
    5aba:	158080e7          	jalr	344(ra) # 5c0e <close>
  return r;
}
    5abe:	854a                	mv	a0,s2
    5ac0:	60e2                	ld	ra,24(sp)
    5ac2:	6442                	ld	s0,16(sp)
    5ac4:	64a2                	ld	s1,8(sp)
    5ac6:	6902                	ld	s2,0(sp)
    5ac8:	6105                	addi	sp,sp,32
    5aca:	8082                	ret
    return -1;
    5acc:	597d                	li	s2,-1
    5ace:	bfc5                	j	5abe <stat+0x34>

0000000000005ad0 <atoi>:

int
atoi(const char *s)
{
    5ad0:	1141                	addi	sp,sp,-16
    5ad2:	e422                	sd	s0,8(sp)
    5ad4:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    5ad6:	00054603          	lbu	a2,0(a0)
    5ada:	fd06079b          	addiw	a5,a2,-48
    5ade:	0ff7f793          	andi	a5,a5,255
    5ae2:	4725                	li	a4,9
    5ae4:	02f76963          	bltu	a4,a5,5b16 <atoi+0x46>
    5ae8:	86aa                	mv	a3,a0
  n = 0;
    5aea:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
    5aec:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
    5aee:	0685                	addi	a3,a3,1
    5af0:	0025179b          	slliw	a5,a0,0x2
    5af4:	9fa9                	addw	a5,a5,a0
    5af6:	0017979b          	slliw	a5,a5,0x1
    5afa:	9fb1                	addw	a5,a5,a2
    5afc:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    5b00:	0006c603          	lbu	a2,0(a3) # 1000 <linktest+0x10a>
    5b04:	fd06071b          	addiw	a4,a2,-48
    5b08:	0ff77713          	andi	a4,a4,255
    5b0c:	fee5f1e3          	bgeu	a1,a4,5aee <atoi+0x1e>
  return n;
}
    5b10:	6422                	ld	s0,8(sp)
    5b12:	0141                	addi	sp,sp,16
    5b14:	8082                	ret
  n = 0;
    5b16:	4501                	li	a0,0
    5b18:	bfe5                	j	5b10 <atoi+0x40>

0000000000005b1a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    5b1a:	1141                	addi	sp,sp,-16
    5b1c:	e422                	sd	s0,8(sp)
    5b1e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    5b20:	02b57663          	bgeu	a0,a1,5b4c <memmove+0x32>
    while(n-- > 0)
    5b24:	02c05163          	blez	a2,5b46 <memmove+0x2c>
    5b28:	fff6079b          	addiw	a5,a2,-1
    5b2c:	1782                	slli	a5,a5,0x20
    5b2e:	9381                	srli	a5,a5,0x20
    5b30:	0785                	addi	a5,a5,1
    5b32:	97aa                	add	a5,a5,a0
  dst = vdst;
    5b34:	872a                	mv	a4,a0
      *dst++ = *src++;
    5b36:	0585                	addi	a1,a1,1
    5b38:	0705                	addi	a4,a4,1
    5b3a:	fff5c683          	lbu	a3,-1(a1)
    5b3e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    5b42:	fee79ae3          	bne	a5,a4,5b36 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    5b46:	6422                	ld	s0,8(sp)
    5b48:	0141                	addi	sp,sp,16
    5b4a:	8082                	ret
    dst += n;
    5b4c:	00c50733          	add	a4,a0,a2
    src += n;
    5b50:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    5b52:	fec05ae3          	blez	a2,5b46 <memmove+0x2c>
    5b56:	fff6079b          	addiw	a5,a2,-1
    5b5a:	1782                	slli	a5,a5,0x20
    5b5c:	9381                	srli	a5,a5,0x20
    5b5e:	fff7c793          	not	a5,a5
    5b62:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    5b64:	15fd                	addi	a1,a1,-1
    5b66:	177d                	addi	a4,a4,-1
    5b68:	0005c683          	lbu	a3,0(a1)
    5b6c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    5b70:	fee79ae3          	bne	a5,a4,5b64 <memmove+0x4a>
    5b74:	bfc9                	j	5b46 <memmove+0x2c>

0000000000005b76 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    5b76:	1141                	addi	sp,sp,-16
    5b78:	e422                	sd	s0,8(sp)
    5b7a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    5b7c:	ca05                	beqz	a2,5bac <memcmp+0x36>
    5b7e:	fff6069b          	addiw	a3,a2,-1
    5b82:	1682                	slli	a3,a3,0x20
    5b84:	9281                	srli	a3,a3,0x20
    5b86:	0685                	addi	a3,a3,1
    5b88:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    5b8a:	00054783          	lbu	a5,0(a0)
    5b8e:	0005c703          	lbu	a4,0(a1)
    5b92:	00e79863          	bne	a5,a4,5ba2 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    5b96:	0505                	addi	a0,a0,1
    p2++;
    5b98:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    5b9a:	fed518e3          	bne	a0,a3,5b8a <memcmp+0x14>
  }
  return 0;
    5b9e:	4501                	li	a0,0
    5ba0:	a019                	j	5ba6 <memcmp+0x30>
      return *p1 - *p2;
    5ba2:	40e7853b          	subw	a0,a5,a4
}
    5ba6:	6422                	ld	s0,8(sp)
    5ba8:	0141                	addi	sp,sp,16
    5baa:	8082                	ret
  return 0;
    5bac:	4501                	li	a0,0
    5bae:	bfe5                	j	5ba6 <memcmp+0x30>

0000000000005bb0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    5bb0:	1141                	addi	sp,sp,-16
    5bb2:	e406                	sd	ra,8(sp)
    5bb4:	e022                	sd	s0,0(sp)
    5bb6:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    5bb8:	00000097          	auipc	ra,0x0
    5bbc:	f62080e7          	jalr	-158(ra) # 5b1a <memmove>
}
    5bc0:	60a2                	ld	ra,8(sp)
    5bc2:	6402                	ld	s0,0(sp)
    5bc4:	0141                	addi	sp,sp,16
    5bc6:	8082                	ret

0000000000005bc8 <ugetpid>:

#ifdef LAB_PGTBL
int
ugetpid(void)
{
    5bc8:	1141                	addi	sp,sp,-16
    5bca:	e422                	sd	s0,8(sp)
    5bcc:	0800                	addi	s0,sp,16
  struct usyscall *u = (struct usyscall *)USYSCALL;
  return u->pid;
    5bce:	040007b7          	lui	a5,0x4000
}
    5bd2:	17f5                	addi	a5,a5,-3
    5bd4:	07b2                	slli	a5,a5,0xc
    5bd6:	4388                	lw	a0,0(a5)
    5bd8:	6422                	ld	s0,8(sp)
    5bda:	0141                	addi	sp,sp,16
    5bdc:	8082                	ret

0000000000005bde <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    5bde:	4885                	li	a7,1
 ecall
    5be0:	00000073          	ecall
 ret
    5be4:	8082                	ret

0000000000005be6 <exit>:
.global exit
exit:
 li a7, SYS_exit
    5be6:	4889                	li	a7,2
 ecall
    5be8:	00000073          	ecall
 ret
    5bec:	8082                	ret

0000000000005bee <wait>:
.global wait
wait:
 li a7, SYS_wait
    5bee:	488d                	li	a7,3
 ecall
    5bf0:	00000073          	ecall
 ret
    5bf4:	8082                	ret

0000000000005bf6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    5bf6:	4891                	li	a7,4
 ecall
    5bf8:	00000073          	ecall
 ret
    5bfc:	8082                	ret

0000000000005bfe <read>:
.global read
read:
 li a7, SYS_read
    5bfe:	4895                	li	a7,5
 ecall
    5c00:	00000073          	ecall
 ret
    5c04:	8082                	ret

0000000000005c06 <write>:
.global write
write:
 li a7, SYS_write
    5c06:	48c1                	li	a7,16
 ecall
    5c08:	00000073          	ecall
 ret
    5c0c:	8082                	ret

0000000000005c0e <close>:
.global close
close:
 li a7, SYS_close
    5c0e:	48d5                	li	a7,21
 ecall
    5c10:	00000073          	ecall
 ret
    5c14:	8082                	ret

0000000000005c16 <kill>:
.global kill
kill:
 li a7, SYS_kill
    5c16:	4899                	li	a7,6
 ecall
    5c18:	00000073          	ecall
 ret
    5c1c:	8082                	ret

0000000000005c1e <exec>:
.global exec
exec:
 li a7, SYS_exec
    5c1e:	489d                	li	a7,7
 ecall
    5c20:	00000073          	ecall
 ret
    5c24:	8082                	ret

0000000000005c26 <open>:
.global open
open:
 li a7, SYS_open
    5c26:	48bd                	li	a7,15
 ecall
    5c28:	00000073          	ecall
 ret
    5c2c:	8082                	ret

0000000000005c2e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    5c2e:	48c5                	li	a7,17
 ecall
    5c30:	00000073          	ecall
 ret
    5c34:	8082                	ret

0000000000005c36 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    5c36:	48c9                	li	a7,18
 ecall
    5c38:	00000073          	ecall
 ret
    5c3c:	8082                	ret

0000000000005c3e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    5c3e:	48a1                	li	a7,8
 ecall
    5c40:	00000073          	ecall
 ret
    5c44:	8082                	ret

0000000000005c46 <link>:
.global link
link:
 li a7, SYS_link
    5c46:	48cd                	li	a7,19
 ecall
    5c48:	00000073          	ecall
 ret
    5c4c:	8082                	ret

0000000000005c4e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    5c4e:	48d1                	li	a7,20
 ecall
    5c50:	00000073          	ecall
 ret
    5c54:	8082                	ret

0000000000005c56 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    5c56:	48a5                	li	a7,9
 ecall
    5c58:	00000073          	ecall
 ret
    5c5c:	8082                	ret

0000000000005c5e <dup>:
.global dup
dup:
 li a7, SYS_dup
    5c5e:	48a9                	li	a7,10
 ecall
    5c60:	00000073          	ecall
 ret
    5c64:	8082                	ret

0000000000005c66 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    5c66:	48ad                	li	a7,11
 ecall
    5c68:	00000073          	ecall
 ret
    5c6c:	8082                	ret

0000000000005c6e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    5c6e:	48b1                	li	a7,12
 ecall
    5c70:	00000073          	ecall
 ret
    5c74:	8082                	ret

0000000000005c76 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    5c76:	48b5                	li	a7,13
 ecall
    5c78:	00000073          	ecall
 ret
    5c7c:	8082                	ret

0000000000005c7e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    5c7e:	48b9                	li	a7,14
 ecall
    5c80:	00000073          	ecall
 ret
    5c84:	8082                	ret

0000000000005c86 <connect>:
.global connect
connect:
 li a7, SYS_connect
    5c86:	48f5                	li	a7,29
 ecall
    5c88:	00000073          	ecall
 ret
    5c8c:	8082                	ret

0000000000005c8e <pgaccess>:
.global pgaccess
pgaccess:
 li a7, SYS_pgaccess
    5c8e:	48f9                	li	a7,30
 ecall
    5c90:	00000073          	ecall
 ret
    5c94:	8082                	ret

0000000000005c96 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    5c96:	1101                	addi	sp,sp,-32
    5c98:	ec06                	sd	ra,24(sp)
    5c9a:	e822                	sd	s0,16(sp)
    5c9c:	1000                	addi	s0,sp,32
    5c9e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    5ca2:	4605                	li	a2,1
    5ca4:	fef40593          	addi	a1,s0,-17
    5ca8:	00000097          	auipc	ra,0x0
    5cac:	f5e080e7          	jalr	-162(ra) # 5c06 <write>
}
    5cb0:	60e2                	ld	ra,24(sp)
    5cb2:	6442                	ld	s0,16(sp)
    5cb4:	6105                	addi	sp,sp,32
    5cb6:	8082                	ret

0000000000005cb8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    5cb8:	7139                	addi	sp,sp,-64
    5cba:	fc06                	sd	ra,56(sp)
    5cbc:	f822                	sd	s0,48(sp)
    5cbe:	f426                	sd	s1,40(sp)
    5cc0:	f04a                	sd	s2,32(sp)
    5cc2:	ec4e                	sd	s3,24(sp)
    5cc4:	0080                	addi	s0,sp,64
    5cc6:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    5cc8:	c299                	beqz	a3,5cce <printint+0x16>
    5cca:	0805c863          	bltz	a1,5d5a <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    5cce:	2581                	sext.w	a1,a1
  neg = 0;
    5cd0:	4881                	li	a7,0
    5cd2:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    5cd6:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    5cd8:	2601                	sext.w	a2,a2
    5cda:	00003517          	auipc	a0,0x3
    5cde:	8b650513          	addi	a0,a0,-1866 # 8590 <digits>
    5ce2:	883a                	mv	a6,a4
    5ce4:	2705                	addiw	a4,a4,1
    5ce6:	02c5f7bb          	remuw	a5,a1,a2
    5cea:	1782                	slli	a5,a5,0x20
    5cec:	9381                	srli	a5,a5,0x20
    5cee:	97aa                	add	a5,a5,a0
    5cf0:	0007c783          	lbu	a5,0(a5) # 4000000 <base+0x3ff0388>
    5cf4:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    5cf8:	0005879b          	sext.w	a5,a1
    5cfc:	02c5d5bb          	divuw	a1,a1,a2
    5d00:	0685                	addi	a3,a3,1
    5d02:	fec7f0e3          	bgeu	a5,a2,5ce2 <printint+0x2a>
  if(neg)
    5d06:	00088b63          	beqz	a7,5d1c <printint+0x64>
    buf[i++] = '-';
    5d0a:	fd040793          	addi	a5,s0,-48
    5d0e:	973e                	add	a4,a4,a5
    5d10:	02d00793          	li	a5,45
    5d14:	fef70823          	sb	a5,-16(a4)
    5d18:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    5d1c:	02e05863          	blez	a4,5d4c <printint+0x94>
    5d20:	fc040793          	addi	a5,s0,-64
    5d24:	00e78933          	add	s2,a5,a4
    5d28:	fff78993          	addi	s3,a5,-1
    5d2c:	99ba                	add	s3,s3,a4
    5d2e:	377d                	addiw	a4,a4,-1
    5d30:	1702                	slli	a4,a4,0x20
    5d32:	9301                	srli	a4,a4,0x20
    5d34:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    5d38:	fff94583          	lbu	a1,-1(s2)
    5d3c:	8526                	mv	a0,s1
    5d3e:	00000097          	auipc	ra,0x0
    5d42:	f58080e7          	jalr	-168(ra) # 5c96 <putc>
  while(--i >= 0)
    5d46:	197d                	addi	s2,s2,-1
    5d48:	ff3918e3          	bne	s2,s3,5d38 <printint+0x80>
}
    5d4c:	70e2                	ld	ra,56(sp)
    5d4e:	7442                	ld	s0,48(sp)
    5d50:	74a2                	ld	s1,40(sp)
    5d52:	7902                	ld	s2,32(sp)
    5d54:	69e2                	ld	s3,24(sp)
    5d56:	6121                	addi	sp,sp,64
    5d58:	8082                	ret
    x = -xx;
    5d5a:	40b005bb          	negw	a1,a1
    neg = 1;
    5d5e:	4885                	li	a7,1
    x = -xx;
    5d60:	bf8d                	j	5cd2 <printint+0x1a>

0000000000005d62 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    5d62:	7119                	addi	sp,sp,-128
    5d64:	fc86                	sd	ra,120(sp)
    5d66:	f8a2                	sd	s0,112(sp)
    5d68:	f4a6                	sd	s1,104(sp)
    5d6a:	f0ca                	sd	s2,96(sp)
    5d6c:	ecce                	sd	s3,88(sp)
    5d6e:	e8d2                	sd	s4,80(sp)
    5d70:	e4d6                	sd	s5,72(sp)
    5d72:	e0da                	sd	s6,64(sp)
    5d74:	fc5e                	sd	s7,56(sp)
    5d76:	f862                	sd	s8,48(sp)
    5d78:	f466                	sd	s9,40(sp)
    5d7a:	f06a                	sd	s10,32(sp)
    5d7c:	ec6e                	sd	s11,24(sp)
    5d7e:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    5d80:	0005c903          	lbu	s2,0(a1)
    5d84:	18090f63          	beqz	s2,5f22 <vprintf+0x1c0>
    5d88:	8aaa                	mv	s5,a0
    5d8a:	8b32                	mv	s6,a2
    5d8c:	00158493          	addi	s1,a1,1
  state = 0;
    5d90:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    5d92:	02500a13          	li	s4,37
      if(c == 'd'){
    5d96:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
    5d9a:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
    5d9e:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
    5da2:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5da6:	00002b97          	auipc	s7,0x2
    5daa:	7eab8b93          	addi	s7,s7,2026 # 8590 <digits>
    5dae:	a839                	j	5dcc <vprintf+0x6a>
        putc(fd, c);
    5db0:	85ca                	mv	a1,s2
    5db2:	8556                	mv	a0,s5
    5db4:	00000097          	auipc	ra,0x0
    5db8:	ee2080e7          	jalr	-286(ra) # 5c96 <putc>
    5dbc:	a019                	j	5dc2 <vprintf+0x60>
    } else if(state == '%'){
    5dbe:	01498f63          	beq	s3,s4,5ddc <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
    5dc2:	0485                	addi	s1,s1,1
    5dc4:	fff4c903          	lbu	s2,-1(s1)
    5dc8:	14090d63          	beqz	s2,5f22 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
    5dcc:	0009079b          	sext.w	a5,s2
    if(state == 0){
    5dd0:	fe0997e3          	bnez	s3,5dbe <vprintf+0x5c>
      if(c == '%'){
    5dd4:	fd479ee3          	bne	a5,s4,5db0 <vprintf+0x4e>
        state = '%';
    5dd8:	89be                	mv	s3,a5
    5dda:	b7e5                	j	5dc2 <vprintf+0x60>
      if(c == 'd'){
    5ddc:	05878063          	beq	a5,s8,5e1c <vprintf+0xba>
      } else if(c == 'l') {
    5de0:	05978c63          	beq	a5,s9,5e38 <vprintf+0xd6>
      } else if(c == 'x') {
    5de4:	07a78863          	beq	a5,s10,5e54 <vprintf+0xf2>
      } else if(c == 'p') {
    5de8:	09b78463          	beq	a5,s11,5e70 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
    5dec:	07300713          	li	a4,115
    5df0:	0ce78663          	beq	a5,a4,5ebc <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    5df4:	06300713          	li	a4,99
    5df8:	0ee78e63          	beq	a5,a4,5ef4 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
    5dfc:	11478863          	beq	a5,s4,5f0c <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    5e00:	85d2                	mv	a1,s4
    5e02:	8556                	mv	a0,s5
    5e04:	00000097          	auipc	ra,0x0
    5e08:	e92080e7          	jalr	-366(ra) # 5c96 <putc>
        putc(fd, c);
    5e0c:	85ca                	mv	a1,s2
    5e0e:	8556                	mv	a0,s5
    5e10:	00000097          	auipc	ra,0x0
    5e14:	e86080e7          	jalr	-378(ra) # 5c96 <putc>
      }
      state = 0;
    5e18:	4981                	li	s3,0
    5e1a:	b765                	j	5dc2 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
    5e1c:	008b0913          	addi	s2,s6,8
    5e20:	4685                	li	a3,1
    5e22:	4629                	li	a2,10
    5e24:	000b2583          	lw	a1,0(s6)
    5e28:	8556                	mv	a0,s5
    5e2a:	00000097          	auipc	ra,0x0
    5e2e:	e8e080e7          	jalr	-370(ra) # 5cb8 <printint>
    5e32:	8b4a                	mv	s6,s2
      state = 0;
    5e34:	4981                	li	s3,0
    5e36:	b771                	j	5dc2 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    5e38:	008b0913          	addi	s2,s6,8
    5e3c:	4681                	li	a3,0
    5e3e:	4629                	li	a2,10
    5e40:	000b2583          	lw	a1,0(s6)
    5e44:	8556                	mv	a0,s5
    5e46:	00000097          	auipc	ra,0x0
    5e4a:	e72080e7          	jalr	-398(ra) # 5cb8 <printint>
    5e4e:	8b4a                	mv	s6,s2
      state = 0;
    5e50:	4981                	li	s3,0
    5e52:	bf85                	j	5dc2 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    5e54:	008b0913          	addi	s2,s6,8
    5e58:	4681                	li	a3,0
    5e5a:	4641                	li	a2,16
    5e5c:	000b2583          	lw	a1,0(s6)
    5e60:	8556                	mv	a0,s5
    5e62:	00000097          	auipc	ra,0x0
    5e66:	e56080e7          	jalr	-426(ra) # 5cb8 <printint>
    5e6a:	8b4a                	mv	s6,s2
      state = 0;
    5e6c:	4981                	li	s3,0
    5e6e:	bf91                	j	5dc2 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    5e70:	008b0793          	addi	a5,s6,8
    5e74:	f8f43423          	sd	a5,-120(s0)
    5e78:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    5e7c:	03000593          	li	a1,48
    5e80:	8556                	mv	a0,s5
    5e82:	00000097          	auipc	ra,0x0
    5e86:	e14080e7          	jalr	-492(ra) # 5c96 <putc>
  putc(fd, 'x');
    5e8a:	85ea                	mv	a1,s10
    5e8c:	8556                	mv	a0,s5
    5e8e:	00000097          	auipc	ra,0x0
    5e92:	e08080e7          	jalr	-504(ra) # 5c96 <putc>
    5e96:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5e98:	03c9d793          	srli	a5,s3,0x3c
    5e9c:	97de                	add	a5,a5,s7
    5e9e:	0007c583          	lbu	a1,0(a5)
    5ea2:	8556                	mv	a0,s5
    5ea4:	00000097          	auipc	ra,0x0
    5ea8:	df2080e7          	jalr	-526(ra) # 5c96 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    5eac:	0992                	slli	s3,s3,0x4
    5eae:	397d                	addiw	s2,s2,-1
    5eb0:	fe0914e3          	bnez	s2,5e98 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
    5eb4:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    5eb8:	4981                	li	s3,0
    5eba:	b721                	j	5dc2 <vprintf+0x60>
        s = va_arg(ap, char*);
    5ebc:	008b0993          	addi	s3,s6,8
    5ec0:	000b3903          	ld	s2,0(s6)
        if(s == 0)
    5ec4:	02090163          	beqz	s2,5ee6 <vprintf+0x184>
        while(*s != 0){
    5ec8:	00094583          	lbu	a1,0(s2)
    5ecc:	c9a1                	beqz	a1,5f1c <vprintf+0x1ba>
          putc(fd, *s);
    5ece:	8556                	mv	a0,s5
    5ed0:	00000097          	auipc	ra,0x0
    5ed4:	dc6080e7          	jalr	-570(ra) # 5c96 <putc>
          s++;
    5ed8:	0905                	addi	s2,s2,1
        while(*s != 0){
    5eda:	00094583          	lbu	a1,0(s2)
    5ede:	f9e5                	bnez	a1,5ece <vprintf+0x16c>
        s = va_arg(ap, char*);
    5ee0:	8b4e                	mv	s6,s3
      state = 0;
    5ee2:	4981                	li	s3,0
    5ee4:	bdf9                	j	5dc2 <vprintf+0x60>
          s = "(null)";
    5ee6:	00002917          	auipc	s2,0x2
    5eea:	6a290913          	addi	s2,s2,1698 # 8588 <malloc+0x255c>
        while(*s != 0){
    5eee:	02800593          	li	a1,40
    5ef2:	bff1                	j	5ece <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
    5ef4:	008b0913          	addi	s2,s6,8
    5ef8:	000b4583          	lbu	a1,0(s6)
    5efc:	8556                	mv	a0,s5
    5efe:	00000097          	auipc	ra,0x0
    5f02:	d98080e7          	jalr	-616(ra) # 5c96 <putc>
    5f06:	8b4a                	mv	s6,s2
      state = 0;
    5f08:	4981                	li	s3,0
    5f0a:	bd65                	j	5dc2 <vprintf+0x60>
        putc(fd, c);
    5f0c:	85d2                	mv	a1,s4
    5f0e:	8556                	mv	a0,s5
    5f10:	00000097          	auipc	ra,0x0
    5f14:	d86080e7          	jalr	-634(ra) # 5c96 <putc>
      state = 0;
    5f18:	4981                	li	s3,0
    5f1a:	b565                	j	5dc2 <vprintf+0x60>
        s = va_arg(ap, char*);
    5f1c:	8b4e                	mv	s6,s3
      state = 0;
    5f1e:	4981                	li	s3,0
    5f20:	b54d                	j	5dc2 <vprintf+0x60>
    }
  }
}
    5f22:	70e6                	ld	ra,120(sp)
    5f24:	7446                	ld	s0,112(sp)
    5f26:	74a6                	ld	s1,104(sp)
    5f28:	7906                	ld	s2,96(sp)
    5f2a:	69e6                	ld	s3,88(sp)
    5f2c:	6a46                	ld	s4,80(sp)
    5f2e:	6aa6                	ld	s5,72(sp)
    5f30:	6b06                	ld	s6,64(sp)
    5f32:	7be2                	ld	s7,56(sp)
    5f34:	7c42                	ld	s8,48(sp)
    5f36:	7ca2                	ld	s9,40(sp)
    5f38:	7d02                	ld	s10,32(sp)
    5f3a:	6de2                	ld	s11,24(sp)
    5f3c:	6109                	addi	sp,sp,128
    5f3e:	8082                	ret

0000000000005f40 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    5f40:	715d                	addi	sp,sp,-80
    5f42:	ec06                	sd	ra,24(sp)
    5f44:	e822                	sd	s0,16(sp)
    5f46:	1000                	addi	s0,sp,32
    5f48:	e010                	sd	a2,0(s0)
    5f4a:	e414                	sd	a3,8(s0)
    5f4c:	e818                	sd	a4,16(s0)
    5f4e:	ec1c                	sd	a5,24(s0)
    5f50:	03043023          	sd	a6,32(s0)
    5f54:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    5f58:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    5f5c:	8622                	mv	a2,s0
    5f5e:	00000097          	auipc	ra,0x0
    5f62:	e04080e7          	jalr	-508(ra) # 5d62 <vprintf>
}
    5f66:	60e2                	ld	ra,24(sp)
    5f68:	6442                	ld	s0,16(sp)
    5f6a:	6161                	addi	sp,sp,80
    5f6c:	8082                	ret

0000000000005f6e <printf>:

void
printf(const char *fmt, ...)
{
    5f6e:	711d                	addi	sp,sp,-96
    5f70:	ec06                	sd	ra,24(sp)
    5f72:	e822                	sd	s0,16(sp)
    5f74:	1000                	addi	s0,sp,32
    5f76:	e40c                	sd	a1,8(s0)
    5f78:	e810                	sd	a2,16(s0)
    5f7a:	ec14                	sd	a3,24(s0)
    5f7c:	f018                	sd	a4,32(s0)
    5f7e:	f41c                	sd	a5,40(s0)
    5f80:	03043823          	sd	a6,48(s0)
    5f84:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    5f88:	00840613          	addi	a2,s0,8
    5f8c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    5f90:	85aa                	mv	a1,a0
    5f92:	4505                	li	a0,1
    5f94:	00000097          	auipc	ra,0x0
    5f98:	dce080e7          	jalr	-562(ra) # 5d62 <vprintf>
}
    5f9c:	60e2                	ld	ra,24(sp)
    5f9e:	6442                	ld	s0,16(sp)
    5fa0:	6125                	addi	sp,sp,96
    5fa2:	8082                	ret

0000000000005fa4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    5fa4:	1141                	addi	sp,sp,-16
    5fa6:	e422                	sd	s0,8(sp)
    5fa8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    5faa:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5fae:	00003797          	auipc	a5,0x3
    5fb2:	4a27b783          	ld	a5,1186(a5) # 9450 <freep>
    5fb6:	a805                	j	5fe6 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    5fb8:	4618                	lw	a4,8(a2)
    5fba:	9db9                	addw	a1,a1,a4
    5fbc:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    5fc0:	6398                	ld	a4,0(a5)
    5fc2:	6318                	ld	a4,0(a4)
    5fc4:	fee53823          	sd	a4,-16(a0)
    5fc8:	a091                	j	600c <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    5fca:	ff852703          	lw	a4,-8(a0)
    5fce:	9e39                	addw	a2,a2,a4
    5fd0:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    5fd2:	ff053703          	ld	a4,-16(a0)
    5fd6:	e398                	sd	a4,0(a5)
    5fd8:	a099                	j	601e <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5fda:	6398                	ld	a4,0(a5)
    5fdc:	00e7e463          	bltu	a5,a4,5fe4 <free+0x40>
    5fe0:	00e6ea63          	bltu	a3,a4,5ff4 <free+0x50>
{
    5fe4:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5fe6:	fed7fae3          	bgeu	a5,a3,5fda <free+0x36>
    5fea:	6398                	ld	a4,0(a5)
    5fec:	00e6e463          	bltu	a3,a4,5ff4 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5ff0:	fee7eae3          	bltu	a5,a4,5fe4 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    5ff4:	ff852583          	lw	a1,-8(a0)
    5ff8:	6390                	ld	a2,0(a5)
    5ffa:	02059713          	slli	a4,a1,0x20
    5ffe:	9301                	srli	a4,a4,0x20
    6000:	0712                	slli	a4,a4,0x4
    6002:	9736                	add	a4,a4,a3
    6004:	fae60ae3          	beq	a2,a4,5fb8 <free+0x14>
    bp->s.ptr = p->s.ptr;
    6008:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    600c:	4790                	lw	a2,8(a5)
    600e:	02061713          	slli	a4,a2,0x20
    6012:	9301                	srli	a4,a4,0x20
    6014:	0712                	slli	a4,a4,0x4
    6016:	973e                	add	a4,a4,a5
    6018:	fae689e3          	beq	a3,a4,5fca <free+0x26>
  } else
    p->s.ptr = bp;
    601c:	e394                	sd	a3,0(a5)
  freep = p;
    601e:	00003717          	auipc	a4,0x3
    6022:	42f73923          	sd	a5,1074(a4) # 9450 <freep>
}
    6026:	6422                	ld	s0,8(sp)
    6028:	0141                	addi	sp,sp,16
    602a:	8082                	ret

000000000000602c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    602c:	7139                	addi	sp,sp,-64
    602e:	fc06                	sd	ra,56(sp)
    6030:	f822                	sd	s0,48(sp)
    6032:	f426                	sd	s1,40(sp)
    6034:	f04a                	sd	s2,32(sp)
    6036:	ec4e                	sd	s3,24(sp)
    6038:	e852                	sd	s4,16(sp)
    603a:	e456                	sd	s5,8(sp)
    603c:	e05a                	sd	s6,0(sp)
    603e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    6040:	02051493          	slli	s1,a0,0x20
    6044:	9081                	srli	s1,s1,0x20
    6046:	04bd                	addi	s1,s1,15
    6048:	8091                	srli	s1,s1,0x4
    604a:	0014899b          	addiw	s3,s1,1
    604e:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    6050:	00003517          	auipc	a0,0x3
    6054:	40053503          	ld	a0,1024(a0) # 9450 <freep>
    6058:	c515                	beqz	a0,6084 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    605a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    605c:	4798                	lw	a4,8(a5)
    605e:	02977f63          	bgeu	a4,s1,609c <malloc+0x70>
    6062:	8a4e                	mv	s4,s3
    6064:	0009871b          	sext.w	a4,s3
    6068:	6685                	lui	a3,0x1
    606a:	00d77363          	bgeu	a4,a3,6070 <malloc+0x44>
    606e:	6a05                	lui	s4,0x1
    6070:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    6074:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    6078:	00003917          	auipc	s2,0x3
    607c:	3d890913          	addi	s2,s2,984 # 9450 <freep>
  if(p == (char*)-1)
    6080:	5afd                	li	s5,-1
    6082:	a88d                	j	60f4 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
    6084:	0000a797          	auipc	a5,0xa
    6088:	bf478793          	addi	a5,a5,-1036 # fc78 <base>
    608c:	00003717          	auipc	a4,0x3
    6090:	3cf73223          	sd	a5,964(a4) # 9450 <freep>
    6094:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    6096:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    609a:	b7e1                	j	6062 <malloc+0x36>
      if(p->s.size == nunits)
    609c:	02e48b63          	beq	s1,a4,60d2 <malloc+0xa6>
        p->s.size -= nunits;
    60a0:	4137073b          	subw	a4,a4,s3
    60a4:	c798                	sw	a4,8(a5)
        p += p->s.size;
    60a6:	1702                	slli	a4,a4,0x20
    60a8:	9301                	srli	a4,a4,0x20
    60aa:	0712                	slli	a4,a4,0x4
    60ac:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    60ae:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    60b2:	00003717          	auipc	a4,0x3
    60b6:	38a73f23          	sd	a0,926(a4) # 9450 <freep>
      return (void*)(p + 1);
    60ba:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    60be:	70e2                	ld	ra,56(sp)
    60c0:	7442                	ld	s0,48(sp)
    60c2:	74a2                	ld	s1,40(sp)
    60c4:	7902                	ld	s2,32(sp)
    60c6:	69e2                	ld	s3,24(sp)
    60c8:	6a42                	ld	s4,16(sp)
    60ca:	6aa2                	ld	s5,8(sp)
    60cc:	6b02                	ld	s6,0(sp)
    60ce:	6121                	addi	sp,sp,64
    60d0:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    60d2:	6398                	ld	a4,0(a5)
    60d4:	e118                	sd	a4,0(a0)
    60d6:	bff1                	j	60b2 <malloc+0x86>
  hp->s.size = nu;
    60d8:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    60dc:	0541                	addi	a0,a0,16
    60de:	00000097          	auipc	ra,0x0
    60e2:	ec6080e7          	jalr	-314(ra) # 5fa4 <free>
  return freep;
    60e6:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    60ea:	d971                	beqz	a0,60be <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    60ec:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    60ee:	4798                	lw	a4,8(a5)
    60f0:	fa9776e3          	bgeu	a4,s1,609c <malloc+0x70>
    if(p == freep)
    60f4:	00093703          	ld	a4,0(s2)
    60f8:	853e                	mv	a0,a5
    60fa:	fef719e3          	bne	a4,a5,60ec <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
    60fe:	8552                	mv	a0,s4
    6100:	00000097          	auipc	ra,0x0
    6104:	b6e080e7          	jalr	-1170(ra) # 5c6e <sbrk>
  if(p == (char*)-1)
    6108:	fd5518e3          	bne	a0,s5,60d8 <malloc+0xac>
        return 0;
    610c:	4501                	li	a0,0
    610e:	bf45                	j	60be <malloc+0x92>