# $Id$

#PARAMS		do not remove this line!

SRC_DIR = $(SRC_HOME)/util/arch
EMH = $(TARGET_HOME)/h
EMBIN = $(TARGET_HOME)/bin
LIB = $(TARGET_HOME)/modules/lib
ULIB = $(UTIL_HOME)/modules/lib

LIBS =	$(LIB)/libobject.$(LIBSUF) $(LIB)/libprint.$(LIBSUF) \
	$(LIB)/libstring.$(LIBSUF) $(LIB)/libsystem.$(LIBSUF)
LINTLIBS = \
	$(ULIB)/$(LINTPREF)object.$(LINTSUF) \
	$(ULIB)/$(LINTPREF)print.$(LINTSUF) \
	$(ULIB)/$(LINTPREF)string.$(LINTSUF) \
	$(ULIB)/$(LINTPREF)system.$(LINTSUF)

INCLUDES = -I$(EMH)
CFLAGS= $(INCLUDES) -DDISTRIBUTION $(COPTIONS)
LDFLAGS = $(LDOPTIONS)
LINTFLAGS= $(INCLUDES) -DDISTRIBUTION $(LINTOPTIONS)

all:            arch aal

arch:		arch.$(SUF)
		$(CC) $(LDFLAGS) -o arch arch.$(SUF) $(LIBS)

aal:		aal.$(SUF)
		$(CC) $(LDFLAGS) -o aal aal.$(SUF) $(LIBS)

arch.$(SUF):	$(EMH)/arch.h $(SRC_DIR)/archiver.c
		$(CC) $(CFLAGS) -c $(SRC_DIR)/archiver.c
		mv archiver.$(SUF) arch.$(SUF)

aal.$(SUF):	$(EMH)/arch.h $(SRC_DIR)/archiver.c $(EMH)/ranlib.h $(EMH)/out.h
		$(CC) -DAAL $(CFLAGS) -c $(SRC_DIR)/archiver.c
		mv archiver.$(SUF) aal.$(SUF)

clean:
		rm -f aal arch *.$(SUF) *.old

lint:
		$(LINT) $(LINTFLAGS) -DAAL $(SRC_DIR)/archiver.c $(LINTLIBS)

install :       all
		cp aal $(EMBIN)/aal
		cp arch $(EMBIN)/arch
		if [ $(DO_MACHINE_INDEP) = y ] ; \
		then	mk_manpage $(SRC_DIR)/aal.1 $(TARGET_HOME) ; \
			mk_manpage $(SRC_DIR)/arch.1 $(TARGET_HOME) ; \
			mk_manpage $(SRC_DIR)/arch.5 $(TARGET_HOME) ; \
		fi

cmp :           all
		-cmp aal $(EMBIN)/aal
		-cmp arch $(EMBIN)/arch

opr:
		make pr ^ opr
pr:
		@pr $(SRC_DIR)/proto.make $(SRC_DIR)/archiver.c
