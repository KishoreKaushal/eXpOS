# eXpOS

## 1. Experimental File System(eXpFS)

* eXpOS assumes that the disk is a sequence of blocks, where each block can store a sequence of words.
* The number of words in a block is hardware dependent.
* The eXpFS logical file system provides a file abstraction that allows application programs to think of each data (or executable) file stored in the disk as a continuous stream of data (or machine instructions) without having to worry about the details of disk block allocation.
* System calls are OS routines that does the translation of the user request into physical disk block operations.
* eXpFS needs an external interface through which executable and data files can be loaded into the file system externally.

### eXpFS File System Organization

* The eXpFS logical file system comprises of files organized in a single directory called the **root**. The root is also treated conceptually as a file.
* Every eXpFS file is a sequence of words.
* Each eXpFS file have three attributes - **name**, **size** and **type**, each attribute being one word long.
* The size of the file will be the total number of words stored in the file.
* In extended eXpOS, a file has two additional attributes, __username__ and __permission__.
* There are three types of eXpFS files - the __root__, __data files__ and __executable__ files.
* Each file in eXpFS has an entry in the root called its __root entry__.

### eXpFS Root File

* Root file has the name root and contains meta-data about the files stored in the file system.
* For each file in the eXpFS, the root file stores three words of information : __name__, __size__, and __type__.
* In extended eXpOS the root file stores two additional words - __user name__ and __permission__.
* The first root entry is for the root itself.
* The operations on the root file are __Open__, __Close__, __Read__ and __Seek__.
* The owner of the root file is set to kernel (userid = 0) and permissions set to exclusive (0) during the file system formatting.

### eXpFS Data Files

* A data file is a sequence of words. The maximum number of words permissible in a file is defined by the constant **MAX_FILE_SIZE**. It is recommended to use the extension ".dat" for data files.
* eXpFS treats every file other than root and executable files as a data files.
* eXpOS allows an application program to perform the following operations on data files: **Create, Delete, Open, Close, Read, Write, Seek**.
* Data files may be loaded into the eXpFS file system using the external interface.
* In Multiuser implementation of eXpOS the username of a data file corresponds to the user who creates the file.
* If a data file is externally loaded into the file system the owner field is set to root(value=1) and the access permission is set to open access(value=1).


### eXpFS Executable Files

* eXpFS specification does not allow executable files to be created by application programs. They can only be created externally and loaded using the external interface.
* The executable file format recognized by eXpOS is called the Ecperimental executable file (XEXE) format. In this format, an executable file is divided into two sections.
* The first section is called __header__ and the second section called the __code (or text)__ section.
* The code section contains the *program instructions*. The header section contains information like the size of the text and data segments in the file, the space to be allocated for stack and heap areas when the program is loaded for execution etc.


## 2. XFS Interface

XFS Interface (eXperimental File System Interface) is an external interface to access the eXpFS filesystem of the eXpOS "from the host (UNIX) system". The filesystem is simulated on a binary file called __disk.xfs__. The interface can format the disk, dump the disk data structures, load/remove files, list files, transfer data and executable files between eXpFS filesystem and the host (UNIX) file system and copy specified blocks of the XFS disk to a UNIX file.

__Note__ : XFS interface must not be run while the XSM simulator is run concurrently as it might leave the file system in inconsistent state.

## 3. Understanding the File System

The eXpOS package mainly consists of a machine simulator. he machine is called the **eXperimental String Machine (XSM)** and consists of a processor, memory and disk.

The package comes with three major support tools - two compilers and a disk interface tool called **XFS-Interface**. XSM machine's disk contains 512 blocks, each capable of storing 512 words.

The eXpFS format specifies that each data/executable file can span across at most four data blocks, and that the index to these blocks along with the name and the size of the file must be stored in a pre-define area of the disk called the **Inode table**. (The inode table is stored in disk blocks 3 and 4).

The eXperimental Filesystem (eXpFS) is a simulated filesystem. A UNIX file named **"disk.xfs"** simulates the hard disk of the XSM machine. Building eXpOS begins with understanding the underlying filesystem (eXpFS) and its interface (xfs-interface) to the host (UNIX) environment. The xfs-interface is used for transferring files between your linux system and the xsm disk.

### Inode Table

* Inode table is stored in disk blocks 3 & 4.
* It has an entry for each file present in the disk.
* A copy of the Inode table is maintained in the memory when the OS is running.
* It consists of **MAX_FILE_NUM** entries. Thus eXpFS permits a maximum of **MAX_FILE_NUM** files. This version of eXpOS sets **MAX_FILE_NUM** = 60.

The entry of an Inode table has the following format:
* FILE TYPE (1 word) - specifies the type of the given file (DATA, EXEC or ROOT).
* FILE NAME (1 word) - Name of the file
* FILE SIZE (1 word) - Size of the file. Maximum size for File = **MAX_FILE_SIZE = 2048 words**
* USER ID (1 word) - User Id of the owner of the file.
* PERMISSION (1 word) - Permission of the file; it can be OPEN_ACCESS or EXCLUSIVE.
* Unused (3 words)
* DATA BLOCK 1 to 4 (4 words) - each DATA BLOCK column stores the block number of a data block of the file. If a file does not use a particular DATA BLOCK , it is set to -1.
* Unused (4 words)

An unused entry is indicated by -1 in the FILE NAME field.

__Note 1__ : fdisk command of XFS Interface initilizes the inode table entry of the root file with values FILE TYPE = 1, FILE SIZE = 512, and DATA BLOCK = 5 (Root file is stored in block 5 of disk.)

__Note 2__ : A Free inode entry is denoted by -1 in the FILENAME field.

__Note 3__ : Memory copy of the Inode Table is present in page 59 of the memory (see Memory Organisation), and the SPL constant INODE_TABLE points to the starting address of the table.

## 4. Bootstrap Loader

### XSM Instruction Execution Cycle

* The CPU of the XSM machine contains 20 general-purpose registers R0-R19, each of which can store an integer or a string.
* Along with these are the registers stack pointer (SP), base pointer (BP) and instruction pointer (IP).
* There are special purpose registers: PTBR, PTLR, EIP, EC, EPN, EMA and four ports P0, P1, P2, P3.
* The machine's memory consists of 65536 memory words. Each word can store an integer or a string. The memory is divided into pages of 512 words each.
* The memory is **word addressable**. This means that XSM provides instructions that allows you to access any memory word.
* __The machine also has a disk having 512 blocks. Each disk block can store 512 words. Thus the total storage capacity is 512 x 512 = 262144 words. However, the disk is block addressable and not word addressable.__
* XSM provides just three instructions to manipulate the disk – __LOAD, LOADI__ and __STORE__. These instructions can be used to transfer a disk block to a memory page or back.
* The machine also has three devices – an I/O Console, a timer and disk controller.


### Boot-Up

When the XSM machine is started up, the ROM Code, which resides in page 0 of the memory, is executed. It is hard-coded into the machine.

That is, the ROM code at physical address 0 (to 511) is "already there" when machine starts up. The ROM code is called the "Boot ROM" in OS literature. Boot ROM code does the following operations : 1.) Loads block 0 of the disk to page 1 of the memory (physical address 512).2.) After loading the block to memory, it sets the value of the register IP (Instruction Pointer) to 512 so that the next instruction is fetched from location 512 (page 1 in memory starts from location 512).

What happens when the machine is powered on?

* _All registers will be set to value zero._ In particular, IP register also assumes value 0. Once powered on, the machine will start repeatedly executing the following fetch-execute cycle in privileged mode.
1. Transfer the contents of two memory locations starting at the address stored in IP register to the CPU. The XSM machine treats the contents read like a machine instruction. This action is called the instruction fetch cycle.
2. The next step is the execute cycle where the instruction fetched in Step 1 is executed by the machine.
3. The final step is to set the instruction pointer to the next instruction to be executed. Since each XSM instruction is two words, IP will normally be incremented by 2.

The bootstrap code is hard coded into a boot ROM so that the memory contents are not lost even after machine shutdown. This is necessary because when the machine is powered on, there must be some meaningful instruction at address 0 from where the first fetch takes place.

#### Loading a Boot-up code

    $ ./xfs-interface
    # load --os $HOME/myexpos/spl/spl_progs/helloworld.xsm
    # exit

#### Counting numbers on Boot-Up

    $ cat count20.xsm
        MOV R16, 1
        MOV R17 , 20
        PORT P1, R16
        OUT
        INR R16
        MOV R18 , R16
        LE R18 , R17
        JNZ R18 , 516
        HALT


## 5. XSM Unprivileged Mode Execution & Virtual Machine Model

In the privileged mode, a memory address referes to the actual physical memory address. For eg., the instruction sequence:
```
    MOV SP, 1000
    PUSH R0
```
MOV instruction sets the stack pointer register SP to 1000 and then the PUSH instruction will first increment SP (to value 1001) and then transfers contents of the register R0 to the top of the stack - that is - to the memory location 1001 pointed to by SP.

PUSH and other *unprivileged instructions* have a different behaviour when executed in unprivileged mode. PUSH will increment SP to 1001 as before, but in unprivileged mode the address are not physical address instead they are logical and hence the address translation mechanism of XSM is used to convert it to physical address and then transfer the contents of R0 to that location.

User programs are executed in unpriviledged mode. Consequently, the privileged mode instructions cannot be used by them. Their memory view and registers available are also limited.

__Registers available in unpriviledged mode are:__

|Registers|Purpose|
|----------|--------------|
|R0-R19|General purpose program registers|
|BP, SP, IP|Base, Stack and Instruction Pointers|

### Virtual(Memory) Address Space

The logical memory addresses that can be generated by a user program is determined by the value of the PTLR register. The virtual address space of a user mode program is a contiguous address space starting from 0 to 512*PTLR-1.

![Address Translation]
(http://exposnitc.github.io/img/addr_transln.png)


## 6. XSM Paging hardware and Address Translation

### Page Table

Every user mode program has an associated page table which maps its virtual address space to the machine's physical address space. The base address of the Page Table (of the user mode program currently in execution) is stored in the __Page Table Base Register (PTBR)__ and the __number of entries__ in this Page Table must be stored in the __Page Table Length Register (PTLR)__. The page tables must be set up in the **privileged mode**.

_Each Page Table stores the physical page number corresponding to all the logical pages of a user mode program_. The logical page numbers of a user mode program can vary from 0 to PTLR - 1. Therefore, each user mode program has a Page Table with PTLR entries.

Each page table entry for a logical page is of __2 words__. The 1st word must be set to the physical page number in the memory where the logical page is actually loaded. In this case, the page table entry is said to be __valid__. If the page has not been loaded into the memory, the page table entry is said to be **invalid**.

The 2nd word in a page table entry stores a sequence of flag bits storing information regarding whether the page
a) is valid or not
b) is read only/read write,
c) has been referenced in the user mode after being set to valid, and
d) has been modified in the user mode after being set to valid (dirty).

* __Reference Bit(R)__ : As soon as the page is accessed for the first time, this bit is changed from 0 to 1
* __Valid/Invalid Bit(V)__ : This bit indicates whether the entry of the page table is valid or invalid. Its value is set to 0 if the entry is invalid.
* __Write Permission Bit (W)__ : This bit must be set to 1 if the user mode program is permitted to write into the page, otherwise it must be set to 0. If memory access is made to a page whose page table entry is invalid, the machine transfers control to the **Exception Handler routine**.
* __Dirty Bit(D)__ : This bit is set to 1 by the machine if an instruction modifies the contents of the page.

### Address Translation Scheme

The addresses generated by the machine while executing in user mode are _logical addresses_. The paging hardware translates these addresses to physical addresses.

__Location of Page table entry = PTBR + 2 x (Logical Address / 512)__

The value stored in the 1st word in the page table entry corresponds to the physical page number.

__Physical Page Number = [Location of Page table entry]__

__offset = Logical Address % 512__

__Physical Address = Physical Page Number x 512 + offset__


The translation of a logical address to physical address is done completely by the machine's paging hardware. The sequence of steps involved may abstractly be described by the following steps:

1. Given a logical address – **find the logical page number and offset** specified by the address.
2. Search the page table to **find the physical page number** from the logical page number.
3. Multiply physical page number by page size to **find the physical page address**.
4. **physical address = physical page address + offset**.

The machine assumes that the PTBR register holds the base(starting) address of the page table in memory. Since PTBR register can be accessed only in privileged mode, your code must have set the PTBR register to store the address of the page table before entering unprivileged mode execution. Moreover, to get the address translation hardware to work the way you want it to, your must write privilaged code to set appropriate values in the page table before executing an IRET instruction to switch the machine to unprivileged mode . Thus, **some setup work needs to be done in the privileged mode before a switch to unprivileged mode**.

### Paging and virtual memory

Paging allows the OS to provide each application program running in unprivileged mode with a virtual (or logical) address space. The application's access can be restricted to this address space.

The virtual address space (or the logical address space) of an application is a contiguous memory address space starting from logical address 0 to a maximum limit set by the OS.

Each application's code and data must fit into its logical address space. The OS views this address space as being divided into logical pages of 512 words each. Hence logical addresses 0 to 511 belongs to logical page 0 of the program, logical addresses 512 to 1023 belongs to logical page 1 and so forth.

The XSM machine on the other hand has 128 physical pages into which the logical pages of all programs running in the system has to be mapped into. Hence, there needs to be some data structure to map the logical pages of each program to the corresponding physical pages. This data structure is called the page table. The OS maintains a seperate page table for each program that stores the physical page number to which each logical page of the program is mapped to.

### Setting Up Paging for an Application

Steps:

1. Set the PTLR register to define the address space maximum limit.
2. Set up a valid page table in memory and the PTBR register to the beginning address of the page table of the particular application.
3. Set up the application's stack. Set SP to point to the top of the stack.
4. Compute the physical address corresponding to the logical address in SP. Then, copy the logical address of the first instruction (entry point) that much be fetched after IRET into this physical memory location and execute IRET.

### Interrupts

A program running in the unpriviledged mode may switch the machine back to the privileged mode using the trap instruction INT n, where n can take values from 4 to 18. The INT n instruction will result in the following:
1. Increment the SP and transfer contents of IP register to the stack. (SP register holds the logical address of the top of the stack).
2. IP is loaded with a value that depends on the value of n.
3. Machine switches to privileged mode.  

## 7. Running a user Program(unpriviledged mode)

* The first user program which is executed is called the INIT program.
* The eXpOS design stipulates that the INIT program must be stored in blocks 7 and 8 of the XSM disk.
* Write a user program in assembly language and load it into the disk as the INIT program using XFS-Interface.
* Write the OS startup code such that it loads the INIT program into the memory and initiate its execution at the time of system startup.

> In OS jargon, a user program in execution is called a process.

While executing in the user mode, the machine uses logical addressing scheme. The machine translates logical addresses to physical addresses using the address translation mechanism.

Load the following INIT program using the xfs-interface:

```
$ cat $HOME/myexpos/expl/expl_progs/squares.xsm
MOV R0, 1
MOV R2, 5
GE R2, R0
JZ R2, 18
MOV R1, R0
MUL R1, R0
BRKP
ADD R0, 1
JMP 2
INT 10
$ xfs-interface
# load --init $HOME/myexpos/expl/expl_progs/squares.xsm
```

The xfs-interface will sotre this program to disk blocks 7-8.

### INT 10
INT 10 instruction calls the exit system call to return control back to the operating system. INT 10 will invoke the software interrupt handler 10. Since we have only one user process for now, we will write the interrupt 10 handler with only the "halt" statement.

Contents of the haltprog.spl:
```
print "Bye Bye";
halt;
```

Compile the program and load:
```
load --int=10 ../spl/spl_progs/haltprog.xsm
```

### Exception handler

The machine may raise an exception if it encounters any unexpected events like illegal instruction, invalid address, page table entry for a logical page not set valid etc. Our default action is to halt machine exection in the case of an exception. In later stages we'll learn to handle exceptions in a more elaborate way.

Contents of the exceptionhandler.spl:
```
print "Exception";
halt;
```

Compile and load:
```
load --exhandler ../spl/spl_progs/exceptionhandler.xsm
```

### OS startup code
This is the first piece of the OS code to be executed on bootstrap, is responsible for loading the rest of the OS into the memory, initialize OS data structures and set up the first user program for execution.

* Write the OS startup code to load the init program and setup the OS data structures necessary to run the program as a process. Finally, the OS startup code will transfer control to the init program using the IRET instruction.

**STEPS:**

1. Load the INIT program from disk blocks(7-8) to memory pages(65-66).
2. Load the INT10 module from the disk blocks(35-36) to the memory pages(22-23).
3. Load the exception handler routine from the disk blocks(15-16) to memory pages(2-3).
4. Since, INIT is a user process page table must be set up for the address translation scheme to work correctly. Set **PTBR** (Page table base register) to the starting address of the page table of INIT. Set the PTLR.
5. Initialize the page table entries of INIT.
6. Set the top of the stack.
7. Tranfer the control to the user process using IRET (unpriviledged mode). IRET performs the following operations:
    * The instruction pointer is set to the value at the top of the user stack.
    * The value of SP is decremented by 1.
8. Compile and load the code.
```
# load --os $HOME/myexpos/spl/spl_progs/os_startup.xsm
# exit
```
9. Run the machine in the debug mode (diable the timer interrupt for now).
```
./xsm --debug --timer 0
```
10. The final code may look like this:

```
// loading Init code
loadi(65 , 7);
loadi(66 , 8);

// Interrupt 10 routine
loadi(22 , 35);
loadi(23 , 36);

// exception handler
loadi(2 , 15);
loadi(3 , 16);

PTBR = PAGE_TABLE_BASE;

// total pages allocated to init code
PTLR = 3;

// page table entry
[PTBR+8] = 65;
[PTBR+9] = "0100";
[PTBR+10] = 66;
[PTBR+11] = "0100";
[PTBR+16] = 76;
[PTBR+17] = "0110";

// top of the stack
[76*512] = 0;
// stack pointer
SP = 2*512;

ireturn;
```

## 8. ABI and XEXE Format

Application binary interface is the interface between a user program and the kernel.

eXpOS ABI defines the following:
* __Machine Model__ : Instruction Set, Virtual Memory Address Space. Architecture Specific.
* __Regions__ : text , stack , heap and library and the low level system call interface. Both the OS and architecture specific.
* __File Format__ to be followed for executable files by the compiler. OS specific and architecture independent.
* __Low level system call interface__ : Architecture dependent.
* __Low level runtime library interface__ : consists of user level routines which provide a layer of abstraction between the low level system call interface and the application program by providing a unified interface for all system calls, hiding low level interrupt details from the application.

### Virtual Address Space Model
The virtual address space of any eXpOS process is logically divided into four parts namely: **Shared Library, Heap, Code & Stack**.

_Shared library_ can be shared by more than one executable file. The maximum size of this memory region is **X_LSIZE**.

eXpOS provides a library that provides a unified interface for system calls and dynamic memory allocation/deallocation routines. The library is pre-loaded into memory at the time of OS startup and is linked to the address space of a process when an executable program is loaded into the memory for execution if required (as determined by the Library flag in the executable file) . The eXpOS implementation for the XSM architecture discussed here sets X_LSIZE to 1024 words. Thus the shared library will be loaded into the region between memory addresses **0 and 1023** in the address space of the process.

_Heap_ is the portion of the address space of a process reserved as the memory pool from which dynamic memory allocation is done by the allocator routines in the shared library (for example, memory allocated via malloc in C). The maximum size of this memory region is X_HSIZE. The eXpOS implementation for the XSM architecture discussed here sets X_HSIZE to 1024 words. Thus the heap region will be between memory addresses **1024 and 2047** in the address space of the process.

_Code_ contains the header and code part of the XEXE executable file, which is loaded by the eXpOS loader from the file system when the Exec system call is executed. The first eight words of the executable file contains the header. The rest of the code region contains the XSM instructions. The total size of code section cannot exceed X_CSIZE. The eXpOS implementation for the XSM architecture discussed here sets X_CSIZE to 2048 words. Hence, the code region will be between memory addressess 2048 and 4095 in the address space of the process.



## 9. Handling Timer Interrupt

XSM has a timer device which can be set to interrupt the machine at regular intervals of time. The following code will set the timer interrupt interval as ten instructions in unpriviledged mode.

```
./xsm --timer 10
```

The machine does the following actions on timer interrupt:

1. Push the IP value into the top of the stack.
2. Set IP to value stored in the interrupt vector table entry for the timer interrupt handler. The vector table entry for timer interrupt is located at physical address 492 in page 9 (ROM) of XSM and the value 2048 is preset in this location.
3. Machine then switches to the priviledged mode and address translation is disabled. Hence, next instruction will be fetched from the physical address 2048.

**Interrupts are disabled when machine runs in the priviledged mode so that there are no race conditions.** After returning from the timer interrupt handler,  the next entry into the handler occurs only after the machine executes another ten instructions in user mode.

> The timer device can be used to ensure that priviledged code gets control of the machine at regular intervals of time. This is necessary to ensure that an application onve started is not allowed to run "forever". in a time-sharing environment, timer handler invokes the scheduler of the OS to do a context switch to a different process when one process has completed its time quantum.

### Modifications to OS Startup Code

Add the code to load the
