# Performance analysis

## Task Description

### System Call Use Case

Imagine you’re a software architect encountering performance issues in your software. To address these, you decide to gain insights from the system. You discover that various commands in user space serve similar purposes but may differ in performance. Examples include:

- `ls vs. find`
- `cp vs. rsync`
- `diff vs. cmp`
- `sort vs. uniq`
- `grep vs. sed`

### Main Tasks

- Measure the execution time for each command to assess performance.
System Interaction Identification

- Identify which system stack (e.g., file system, network) each command interacts with during execution.
Syscall Time Breakdown

- Break down the total execution time of each command into time per system call to understand resource consumption.
Performance Evaluation

- Analyze results to determine which command performs better based on execution time, system interaction, and syscall breakdown.

### Commands Comparison

1. `ls vs find`

```bash
    strace -c ls -a
```

> Command output

<style>
    .analysis1 {
        width: 100%;
        text-align: center;
    }
    .analysis1 th {
        background: gray;
        word-wrap: break-word;
        text-align: center;
    }
    .analysis1 tr:nth-child(22) { background: green; }
</style>

<div class="analysis1">

| % time | seconds  | usecs/call | calls | errors | syscall         |
|--------|----------|------------|-------|--------|-----------------|
| 31.24  | 0.001419 | 1419       | 1     |        | execve          |
| 24.50  | 0.001113 | 61         | 18    |        | mmap            |
|  8.87  | 0.000403 | 57         | 7     |        | mprotect        |
|  7.09  | 0.000322 | 46         | 7     |        | openat          |
|  3.63  | 0.000165 | 20         | 8     |        | newfstatat      |
|  3.59  | 0.000163 | 18         | 9     |        | close           |
|  3.37  | 0.000153 | 30         | 5     |        | read            |
|  2.58  | 0.000117 | 14         | 8     |        | write           |
|  2.38  | 0.000108 | 27         | 4     |        | pread64         |
|  2.14  | 0.000097 | 97         | 1     |        | munmap          |
|  1.96  | 0.000089 | 44         | 2     |        | getdents64      |
|  1.92  | 0.000087 | 43         | 2     | 2      | statfs          |
|  1.72  | 0.000078 | 26         | 3     |        | brk             |
|  0.97  | 0.000044 | 22         | 2     | 2      | access          |
|  0.81  | 0.000037 | 18         | 2     | 1      | arch_prctl      |
|  0.70  | 0.000032 | 16         | 2     |        | ioctl           |
|  0.59  | 0.000027 | 27         | 1     |        | getrandom       |
|  0.55  | 0.000025 | 25         | 1     |        | prlimit64       |
|  0.48  | 0.000022 | 22         | 1     |        | rseq            |
|  0.46  | 0.000021 | 21         | 1     |        | set_tid_address |
|  0.44  | 0.000020 | 20         | 1     |        | set_robust_list |
| 100.00 | 0.004542 | 52         | 86    | 5      | total           |

</div>

> Command

```bash
strace -c find ./ -maxdepth 1 -type d -name *
```

> Command output

<style>
    .analysis2 {
        width: 100%;
        text-align: center;
    }
    .analysis2 th {
        background: gray;
        word-wrap: break-word;
        text-align: center;
    }
    .analysis2 tr:nth-child(26) { background: green; }
</style>

<div class="analysis2">

| % time | seconds  | usecs/call | calls | errors | syscall         |
|--------|----------|------------|-------|--------|-----------------|
| 16.17  | 0.001259 | 1259       | 1     |        | execve          |
| 14.50  | 0.001129 | 59         | 19    |        | mmap            |
| 14.34  | 0.001117 | 53         | 21    |        | write           |
| 13.65  | 0.001063 | 33         | 32    |        | newfstatat      |
| 11.59  | 0.000903 | 26         | 34    |        | close           |
|  8.58  | 0.000668 | 27         | 24    |        | fcntl           |
|  7.06  | 0.000550 | 25         | 22    | 12     | openat          |
|  2.98  | 0.000232 | 33         | 7     |        | mprotect        |
|  1.80  | 0.000140 | 70         | 2     |        | getdents64      |
|  1.25  | 0.000097 | 97         | 1     |        | munmap          |
|  1.00  | 0.000078 | 11         | 7     |        | read            |
|  1.00  | 0.000078 | 19         | 4     |        | pread64         |
|  0.99  | 0.000077 | 25         | 3     |        | brk             |
|  0.96  | 0.000075 | 37         | 2     | 1      | arch_prctl      |
|  0.95  | 0.000074 | 74         | 1     |        | uname           |
|  0.85  | 0.000066 | 33         | 2     | 2      | statfs          |
|  0.64  | 0.000050 | 25         | 2     |        | ioctl           |
|  0.39  | 0.000030 | 15         | 2     | 2      | access          |
|  0.30  | 0.000023 | 23         | 1     |        | rseq            |
|  0.26  | 0.000020 | 20         | 1     |        | fchdir          |
|  0.24  | 0.000019 | 19         | 1     |        | getrandom       |
|  0.21  | 0.000016 | 16         | 1     |        | set_tid_address |
|  0.19  | 0.000015 | 15         | 1     |        | set_robust_list |
|  0.12  | 0.000009 | 9          | 1     |        | futex           |
|  0.00  | 0.000000 | 0          | 1     |        | prlimit64       |
| 100.00 | 0.007788 | 40         | 193   | 17     | total|

</div>

> As shown in the previous tables,
>
> - Time Measurment:
>
>> | ls       | find     |
    |----------|----------|
    | 0.004542 | 0.007788 |
>>
>> - System Interaction Identification

 | **Command** | **Number of Kernel Stacks**     |**Types of Kernel Stacks**  |
 |-------------|---------------------------------|----------------------------|
 | find        |      5 main stacks       | 1. **File System Stack**: Traverses directories and retrieves file information.<br>2. **Metadata Stack**: Accesses file metadata (e.g., `stat`, `lstat`).<br>3. **Permission Stack**: Checks permissions using `access` or `faccessat`.<br>4. **Memory Management Stack**: Allocates memory for recursive traversal (e.g., `mmap`, `brk`).<br>5. **Process Management Stack**: Spawns subprocesses for `-exec` actions (`execve`, `fork`). |
 | ls          |      3 main stacks       |    1. **File System Stack**: Lists contents of directories (`openat`, `getdents64`).<br>2. **Metadata Stack**: Retrieves file attributes (`stat`, `lstat`).<br>3. **Memory Management Stack**: Allocates memory for sorting and displaying large datasets (`mmap`, `brk`).  |

>> - Performance Evaluation

|**Command**|  |
|--|--|
|find|May be slower due to recursive search and filtering |
|ls|Typically faster for simple directory listings.|

>> **Comment**: the `ls` command is has less syscalls with more successful exit code, comparing with `find` command.
---

1. `cp vs. rsync`

|  Criteria | cp  | rsync  |
|-----------|-----|--------|
|**Time Measurement**   | - Simple copy operation.<br>- Time taken depends on the file size and disk speed.<br>- No built-in option to measure progress (unless using -v for verbose).| - Built-in progress monitoring with --progress.<br>- Option to measure transfer speed (-P or --progress).<br>- More accurate for incremental backups due to delta-transfer optimization. |
|**System Interaction**   | - Primarily interacts with the File System Stack.<br>- Uses open(), read(), write(), close() for copying files.<br>- Low interaction with network stacks (unless copying over network using scp or sftp).  |- More complex interactions.<br>- Similar file system interaction as cp, but with added network stack interaction when copying over SSH or remote connections.<br>- Uses delta algorithm to optimize file transfers.<br>- Uses rsyncd or SSH for remote copying.   |
|**Syscall Time Breakdown**   | - `open()`: Opens source and destination files.<br>- `read()` and `write()`: Read data from source and write to destination.<br>- `close()`: Closes files after copying.<br>- `fstat()`: To get file size and metadata.  |- Similar syscalls as cp for file access.<br>- `open()`, `read()`, `write()`, and `close()`.<br>- Uses `lstat()` for file metadata.<br>- `sendfile()`: May use for faster file copying in some cases.<br>- When transferring over SSH, syscalls related to network stack such as `socket()`, `connect()`, and `write()` are invoked.<br>- Delta algorithm reduces the need to copy unchanged parts, optimizing syscalls by only transferring modified data.   |
|**Performance**   |Suitable for local copies, slower for large data.   |  Optimized for large data, incremental copies, and remote transfers. |

| **Command** | **Number of Kernel Stacks** | **Types of Kernel Stacks**                                                                                             |
|-------------|-----------------------------|-----------------------------------------------------------------------------------------------------------------------|
| **cp**      | 4 main stacks               | 1. File System Stack<br>2. Memory Management Stack<br>3. Permissions Stack<br>4. Process Management Stack                 |
| **rsync**   | 5 main stacks               | 1. File System Stack<br>2. Network Stack<br>3. Memory Management Stack<br>4. Delta Algorithm Stack<br>5. Process Management Stack |

---

3. diff vs cmp

| **Aspect**                | **diff**                                                                                                      | **cmp**                                                                                                      |
|---------------------------|---------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------|
| **Time Measurement**       | - **`diff`** compares files line-by-line, so its time complexity depends on the size and differences in the files.<br> - The larger and more complex the differences, the more time is taken. | - **`cmp`** compares files byte-by-byte, making it generally faster for binary files and when there are fewer differences.<br> - It’s more efficient when only checking the first mismatch between files. |
| **System Interaction**     | - **File System Stack**: Reads the input files and writes the comparison result (e.g., `open()`, `read()`, `write()`).<br> - **Memory Management Stack**: Allocates memory for reading and comparing file contents (e.g., `mmap()`, `brk()`).<br> - **Process Management Stack**: Manages processes for file comparison (e.g., `fork()`, `execve()`). | - **File System Stack**: Reads input files byte-by-byte (e.g., `open()`, `read()`).<br> - **Memory Management Stack**: Allocates memory for comparing file bytes (e.g., `mmap()`, `brk()`).<br> - **Process Management Stack**: Manages input/output and compares files (e.g., `fork()`, `execve()`). |
| **Syscall Time Breakdown** | - **`open()`**: To open files for reading.<br> - **`read()`**: To read file contents.<br> - **`write()`**: To write the comparison output.<br> - **`fstat()`**: To check file metadata.<br> - **`mmap()`**: For memory-mapped files.<br> - **`brk()`**: For memory allocation. | - **`open()`**: To open files for reading.<br> - **`read()`**: To read file contents byte-by-byte.<br> - **`fstat()`**: To check file metadata.<br> - **`mmap()`**: For memory-mapped files.<br> - **`brk()`**: For memory allocation during file comparison. |
| **Performance**            | - **`diff`** is slower for large files or files with many differences.<br> - It performs well with text files that have differences in lines but can be inefficient for large datasets.<br> - It is more appropriate for line-by-line comparisons of textual data. | - **`cmp`** is faster when dealing with binary files or files with fewer differences.<br> - It performs a byte-by-byte comparison, which is optimal for finding the first mismatch.<br> - It is more efficient for quickly checking if two files are identical. |
| **Kernel Stack Interaction** | 3 main stacks: <br> 1. **File System Stack**: Reads input files and writes comparison results (e.g., `open()`, `read()`, `write()`).<br> 2. **Memory Management Stack**: Allocates memory for comparing file contents (e.g., `mmap()`, `brk()`).<br> 3. **Process Management Stack**: Manages processes for comparing files and handling output (e.g., `fork()`, `execve()`). | 3 main stacks: <br> 1. **File System Stack**: Reads files byte-by-byte and writes results (e.g., `open()`, `read()`).<br> 2. **Memory Management Stack**: Allocates memory for comparing file bytes (e.g., `mmap()`, `brk()`).<br> 3. **Process Management Stack**: Manages file comparison operations and output handling (e.g., `fork()`, `execve()`). |

---

4. sort vs uniq

| **Aspect**                | **sort**                                                                                                     | **uniq**                                                                                                      |
|---------------------------|--------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------|
| **Time Measurement**       | - **`sort`** sorts the input data, so time depends on the size of the input.<br> - The larger the dataset, the more time is taken due to sorting complexity (typically O(n log n)). | - **`uniq`** works on sorted data and identifies unique lines, so time depends on the number of lines.<br> - It’s faster than `sort` because it only performs a linear scan (O(n)). |
| **System Interaction**     | - **File System Stack**: Reads input files and writes output to files (e.g., `open()`, `read()`, `write()`).<br> - **Memory Management Stack**: Allocates memory for storing input data before sorting (e.g., `mmap()`, `brk()`).<br> - **Process Management Stack**: Manages processes for sorting large datasets using external programs (`fork()`, `execve()`). | - **File System Stack**: Reads sorted input files (e.g., `open()`, `read()`).<br> - **Memory Management Stack**: Allocates memory for storing and comparing unique lines (e.g., `mmap()`, `brk()`).<br> - **Process Management Stack**: Runs processes to handle input/output streams (e.g., `fork()`, `execve()`). |
| **Syscall Time Breakdown** | - **`open()`**: To open files for reading.<br> - **`read()`**: To read input data.<br> - **`write()`**: To write sorted output.<br> - **`fstat()`**: To check file metadata.<br> - **`mmap()`**: For memory-mapped input files.<br> - **`brk()`**: For memory allocation during sorting. | - **`open()`**: To open files for reading.<br> - **`read()`**: To read sorted data.<br> - **`fstat()`**: To check file metadata.<br> - **`mmap()`**: For memory allocation during processing.<br> - **`brk()`**: To allocate space for processing unique lines. |
| **Performance**            | - **`sort`** is generally slower due to its complexity (O(n log n)) when dealing with large datasets.<br> - Requires additional memory for sorting large files.<br> - Best suited for ordered input or where sorting is required before further processing. | - **`uniq`** is faster because it only requires a linear scan (O(n)) of sorted data to eliminate duplicates.<br> - More efficient when used on pre-sorted data.<br> - It doesn't require sorting, making it less computationally expensive than `sort` when only identifying unique entries. |
| **Kernel Stack Interaction** | 3 main stacks: <br> 1. **File System Stack**: Reads input files and writes output to sorted files (e.g., `open()`, `read()`, `write()`).<br> 2. **Memory Management Stack**: Allocates memory for sorting data in memory (e.g., `mmap()`, `brk()`).<br> 3. **Process Management Stack**: May spawn external sorting processes for large datasets (e.g., `fork()`, `execve()`). | 3 main stacks: <br> 1. **File System Stack**: Reads sorted files for unique line extraction (e.g., `open()`, `read()`).<br> 2. **Memory Management Stack**: Allocates memory for comparing and storing unique lines (e.g., `mmap()`, `brk()`).<br> 3. **Process Management Stack**: Manages input/output streams and processing (e.g., `fork()`, `execve()`). |

---

5. grep vs sed 

| **Aspect**                | **grep**                                                                                                     | **sed**                                                                                                       |
|---------------------------|--------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------|
| **Time Measurement**       | - **`grep`** searches for patterns in the input data, so time depends on the size of the input.<br> - The larger the dataset, the more time is taken due to searching complexity (O(n)). | - **`sed`** performs text transformations on the input data, so time depends on the size and complexity of the transformations.<br> - It can be more time-consuming than `grep` due to complex pattern replacements. |
| **System Interaction**     | - **File System Stack**: Reads input files and writes output to files (e.g., `open()`, `read()`, `write()`).<br> - **Memory Management Stack**: Allocates memory for storing data during the search (e.g., `mmap()`, `brk()`).<br> - **Process Management Stack**: Executes subprocesses for searching patterns (e.g., `fork()`, `execve()`). | - **File System Stack**: Reads input files and writes output (e.g., `open()`, `read()`, `write()`).<br> - **Memory Management Stack**: Allocates memory for performing text transformations (e.g., `mmap()`, `brk()`).<br> - **Process Management Stack**: Runs commands and processes the text stream (e.g., `fork()`, `execve()`). |
| **Syscall Time Breakdown** | - **`open()`**: To open files for reading.<br> - **`read()`**: To read input data.<br> - **`write()`**: To write filtered output.<br> - **`fstat()`**: To check file metadata.<br> - **`mmap()`**: For memory-mapped input files.<br> - **`brk()`**: For memory allocation during processing. | - **`open()`**: To open input/output files.<br> - **`read()`**: To read input data.<br> - **`write()`**: To write modified data.<br> - **`fstat()`**: To check file metadata.<br> - **`mmap()`**: For memory-mapped input files.<br> - **`brk()`**: To allocate memory for text transformations. |
| **Performance**            | - **`grep`** is optimized for searching patterns in large files or streams.<br> - It’s efficient for simple searches with regular expressions.<br> - It can be slower when used with complex regular expressions or very large datasets. | - **`sed`** can be slower than `grep` when performing complex transformations.<br> - Its performance depends on the complexity of the transformation patterns.<br> - **`sed`** is slower when used with intricate editing operations or large input data. |
| **Kernel Stack Interaction** | 3 main stacks: <br> 1. **File System Stack**: Reads input files and writes output to matching lines (e.g., `open()`, `read()`, `write()`).<br> 2. **Memory Management Stack**: Allocates memory for searching through input data (e.g., `mmap()`, `brk()`).<br> 3. **Process Management Stack**: May spawn subprocesses for searching patterns and printing output (e.g., `fork()`, `execve()`). | 3 main stacks: <br> 1. **File System Stack**: Reads input and writes output (e.g., `open()`, `read()`, `write()`).<br> 2. **Memory Management Stack**: Allocates memory for editing and storing text (e.g., `mmap()`, `brk()`).<br> 3. **Process Management Stack**: Executes transformations on data and manages input/output (e.g., `fork()`, `execve()`). |
