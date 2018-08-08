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




