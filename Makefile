.PHONY: all

all:
	$(MAKE) -C spl 
	$(MAKE) -C xfs-interface
	$(MAKE) -C xsm
       
