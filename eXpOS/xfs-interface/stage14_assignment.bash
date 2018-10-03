fdisk
load --library /home/kaushal/Documents/git/eXpOS/expl/library.lib
load --exhandler /home/kaushal/Documents/git/eXpOS/spl/spl_progs/common/exphandler.xsm
load --int=10 /home/kaushal/Documents/git/eXpOS/expl/samples/stage14_assignment/int10_interrupt.xsm
load --os /home/kaushal/Documents/git/eXpOS/expl/samples/stage14_assignment/os_startup.xsm
load --init /home/kaushal/Documents/git/eXpOS/expl/samples/stage14_assignment/oddnos.xsm
load --exec /home/kaushal/Documents/git/eXpOS/expl/samples/stage14_assignment/even.xsm
load --exec /home/kaushal/Documents/git/eXpOS/expl/samples/stage14_assignment/prime.xsm
load --idle /home/kaushal/Documents/git/eXpOS/expl/samples/stage14_assignment/idleProcess_print.xsm
load --int=7 /home/kaushal/Documents/git/eXpOS/expl/samples/stage14_assignment/write_interrupt.xsm
load --int=timer /home/kaushal/Documents/git/eXpOS/expl/samples/stage14_assignment/timer_interrupt.xsm
load --module 7 /home/kaushal/Documents/git/eXpOS/expl/samples/stage14_assignment/boot_module.xsm
load --module 5 /home/kaushal/Documents/git/eXpOS/expl/samples/stage14_assignment/scheduler_module.xsm
dump --inodeusertable
exit
