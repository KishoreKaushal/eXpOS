fdisk
load --library /home/kaushal/Documents/git/eXpOS/expl/library.lib
load --exhandler /home/kaushal/Documents/git/eXpOS/spl/spl_progs/common/exphandler.xsm
load --int=10 /home/kaushal/Documents/git/eXpOS/expl/samples/stage14/int10_interrupt.xsm
load --os /home/kaushal/Documents/git/eXpOS/expl/samples/stage14/os_startup.xsm
load --init /home/kaushal/Documents/git/eXpOS/expl/samples/stage14/oddnos.xsm
load --exec /home/kaushal/Documents/git/eXpOS/expl/samples/stage14/even.xsm
load --idle /home/kaushal/Documents/git/eXpOS/expl/samples/stage14/idleProcess_print.xsm
load --int=7 /home/kaushal/Documents/git/eXpOS/expl/samples/stage14/write_interrupt.xsm
load --int=timer /home/kaushal/Documents/git/eXpOS/expl/samples/stage14/timer_interrupt.xsm
load --module 7 /home/kaushal/Documents/git/eXpOS/expl/samples/stage14/boot_module.xsm
load --module 5 /home/kaushal/Documents/git/eXpOS/expl/samples/stage14/scheduler_module.xsm
dump --inodeusertable
exit
