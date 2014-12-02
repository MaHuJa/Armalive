all: armalive.so loader armalive_dump.in

armalive.so:
	$(MAKE) -C armalive armalive.so
	ln -s armalive/armalive.so .

loader:
	$(MAKE) -C linuxloader loader
	ln -s linuxloader/loader .

armalive_dump.in:
	ln -s loading/armalive_dump.in .

clean:
	rm -f armalive.so loader armalive_dump.in
	$(MAKE) -C armalive clean
	$(MAKE) -C linuxloader clean
