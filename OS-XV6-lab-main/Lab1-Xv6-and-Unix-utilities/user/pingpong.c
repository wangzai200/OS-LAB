#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(int argc, char *argv[])
{
    // 确保没有提供不必要的命令行参数
    if (argc > 1) {
        fprintf(2, "No argument is needed!\n");
        exit(1);
    }

    int parent2child[2], child2parent[2]; // 分别代表父到子和子到父的管道  0是读端 1是写端
    char buf[5]; // 只需要足够的空间存储 "ping" 或 "pong"

    // 创建两个管道
    if (pipe(parent2child) < 0 || pipe(child2parent) < 0) {
        printf("pipe creation failed\n");
        exit(1);
    }
    // 在父进程中，fork() 返回新创建的子进程的进程ID（PID），这个值大于0。
    // 在子进程中，fork() 返回0。
    int pid = fork();

    if (pid < 0) {
        printf("fork failed\n");
        exit(1);
    }

    if (pid == 0) { // 子进程代码
        close(parent2child[1]); // 关闭不需要的写端
        close(child2parent[0]); // 关闭不需要的读端

        // 从父进程读取字节
        if (read(parent2child[0], buf, sizeof(buf)) != 4) {
            printf("child process read failed\n");
            exit(1);
        }
        printf("%d: received %s\n", getpid(), buf);
        close(parent2child[0]); // 关闭读端

        // 回应父进程
        if (write(child2parent[1], "pong", 4) != 4) {
            printf("child process write failed\n");
            exit(1);
        }
        close(child2parent[1]); // 关闭写端
        exit(0);
    } else { // 父进程代码
        close(parent2child[0]); // 关闭不需要的读端
        close(child2parent[1]); // 关闭不需要的写端

        // 向子进程发送字节
        if (write(parent2child[1], "ping", 4) != 4) {
            printf("parent process write failed\n");
            exit(1);
        }
        close(parent2child[1]); // 关闭写端

        // 等待子进程结束
        wait(0);

        // 从子进程读取字节
        if (read(child2parent[0], buf, sizeof(buf)) != 4) {
            printf("parent process read failed\n");
            exit(1);
        }
        printf("%d: received %s\n", getpid(), buf);
        close(child2parent[0]); // 关闭读端

        exit(0);
    }
}
