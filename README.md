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

