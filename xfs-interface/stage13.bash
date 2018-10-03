fdisk
load --library /home/kaushal/Documents/git/eXpOS/expl/library.lib
load --exhandler /home/kaushal/Documents/git/eXpOS/spl/spl_progs/common/exphandler.xsm
load --int=10 /home/kaushal/Documents/git/eXpOS/spl/spl_progs/common/haltprog.xsm
load --os /home/kaushal/Documents/git/eXpOS/expl/samples/stage13/os_startup.xsm
load --init /home/kaushal/Documents/git/eXpOS/expl/samples/stage13/oddnos.xsm
load --idle /home/kaushal/Documents/git/eXpOS/expl/samples/stage13/idleProcess_print.xsm
load --int=7 /home/kaushal/Documents/git/eXpOS/expl/samples/stage13/write_interrupt.xsm
load --int=timer /home/kaushal/Documents/git/eXpOS/expl/samples/stage13/timer_interrupt.xsm
load --module 7 /home/kaushal/Documents/git/eXpOS/expl/samples/stage13/boot_module.xsm
exit
