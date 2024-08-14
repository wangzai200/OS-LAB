#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"


void findPrimes(int leftPipe[]) {
    int prime;
    // 从左侧管道读取素数
    int isRead = read(leftPipe[0], &prime, sizeof(prime));
    if (isRead == 0) {
        close(leftPipe[0]); // 关闭读端
        exit(0); // 无数据读取时退出
    } else if (isRead == -1) {
        printf("read failed"); // 读取失败
        exit(1);
    } else {
        printf("prime %d\n", prime); // 打印找到的素数
    }

    int parent2child[2];
    if (pipe(parent2child) < 0) {
        printf("pipe creation failed"); // 创建管道失败
        exit(1);
    }

    int pid = fork();
    if (pid < 0) {
        printf("fork failed"); // 创建进程失败
        exit(1);
    }

    if (pid == 0) {
        // 子进程逻辑
        close(parent2child[1]); // 关闭写端
        findPrimes(parent2child); // 递归调用以创建新的筛选进程
    } else {
        // 父进程逻辑
        close(parent2child[0]); // 关闭子进程的读端
        int tmp;
        while (read(leftPipe[0], &tmp, sizeof(tmp)) > 0) {
            if (tmp % prime != 0) {
                if (write(parent2child[1], &tmp, sizeof(tmp)) == -1) {
                    printf("write failed"); // 写入失败
                    exit(1);
                }
            }
        }
        close(leftPipe[0]); // 关闭读端
        close(parent2child[1]); // 关闭写端
        wait(0); // 等待子进程完成
    }

    exit(0);
}

int main(int argc, char *argv[]) {
    // 检查参数数量，确保不接受任何命令行参数
    if (argc > 1) {
        fprintf(2, "No argument is needed!\n");
        exit(1);
    }

    int nums[36];  // 创建数组以存储整数

    // 初始化整数数组
    for (int i = 2; i <= 35; i++) {
        nums[i] = i;
    }

    int parent2child[2];  // 管道数组
    // 创建管道
    if (pipe(parent2child) < 0) {
        printf("pipe creation failed");
        exit(1);
    }

    int pid = fork();  // 创建子进程
    if (pid < 0) {
        printf("fork failed");
        exit(1);
    }

    if (pid == 0) {
        // 子进程
        close(parent2child[1]);  // 子进程关闭写端
        findPrimes(parent2child);  // 调用递归处理函数
    } else {
        // 父进程
        close(parent2child[0]);  // 父进程关闭读端
        // 向管道写入整数
        for (int i = 2; i <= 35; i++) {
            if (write(parent2child[1], &nums[i], sizeof(nums[i])) == -1) {
                printf("write failed");  // 输出写入错误信息
                close(parent2child[1]);
                wait(0);  // 等待子进程结束
                exit(1);
            }
        }
        close(parent2child[1]);  // 写入完成后关闭写端
        wait(0);  // 等待子进程结束
    }
    return 0;  // 正常退出
}
