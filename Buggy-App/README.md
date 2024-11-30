# The first task in the linux fundamental module

## Task Describtion
> - It is about running A C++ application that attempts to execute a system call throught the GLIBC. <br>
> - Run the `strace` command to observe the system calls requested by the user space application. <br>
> - The application has bug, that should be discovered by using `strace` command

## Bug Analysis
> The bug is discovered by running the command `$ strace ./testApp.out`. <br>
> **It seems that the user space application attempts to open a file that doesn't exist on the specified path** <br>
> The application failed with the system call 
> `openat(int dirfd, const char *pathname, int flags)` and  returned  the error code ***-1 ENOENT*** which refers to ***(No such file or directory).***<br>

### Application time analysis <br>
By running the command `$ strace -c ./testApp.out` you should get table like that.
| % time | seconds   | usecs/call | calls | errors | syscall        |
|--------|-----------|------------|-------|--------|----------------|
| 34.01  | 0.000486  | 22         | 22    |        | mmap           |
| 31.35  | 0.000448  | 448        | 1     |        | execve         |
| 9.38   | 0.000134  | 16         | 8     |        | mprotect       |
| 7.91   | 0.000113  | 18         | 6     | 1      | openat         |
| 3.22   | 0.000046  | 9          | 5     |        | newfstatat     |
| 2.87   | 0.000041  | 10         | 4     |        | read           |
| 2.59   | 0.000037  | 7          | 5     |        | close          |
| 2.10   | 0.000030  | 7          | 4     |        | pread64        |
| 1.61   | 0.000023  | 23         | 1     |        | munmap         |
| 1.33   | 0.000019  | 6          | 3     |        | brk            |
| 1.05   | 0.000015  | 15         | 1     | 1      | access         |
| 0.91   | 0.000013  | 6          | 2     | 1      | arch_prctl     |
| 0.35   | 0.000005  | 5          | 1     |        | set_tid_address|
| 0.28   | 0.000004  | 4          | 1     |        | set_robust_list|
| 0.28   | 0.000004  | 4          | 1     |        | prlimit64      |
| 0.28   | 0.000004  | 4          | 1     |        | getrandom      |
| 0.28   | 0.000004  | 4          | 1     |        | rseq           |
| 0.21   | 0.000003  | 3          | 1     |        | futex          |
| 0.00   | 0.000000  | 0          | 1     |        | write          |
|--------|-----------|------------|-------|--------|----------------|
| 100.00 | 0.001429  | 20         | 69    | 3      | total          |

### Table analysis 
> The application attepmts to make system calls through the glibc. these system calls are mentioned in the most left column. <br>
> **3 system calls** failed with errors, which are:
> 1. openat
> 2. access
> 3. arch_prctl
