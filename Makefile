DEFINES  ?= 
INCLUDES ?= -I./ -I/usr/include/SDL -I./utils -I./include/vlc2x -I./include
CXXFLAGS ?= -fvisibility=hidden -Wno-multichar -fexceptions  -fpermissive
CFLAGS   ?= -fvisibility=hidden -Wno-multichar
PREFIX   ?= /usr/local
LIBDIR   ?= $(PREFIX)/lib
INCDIR   ?= $(PREFIX)/include

LIBS = -lrt -lm -lpthread -lc -ldl


TOOLCHAIN_PATH=/usr/bin

LD=    $(TOOLCHAIN_PATH)/ld
AR=    $(TOOLCHAIN_PATH)/ar
RANLIB=$(TOOLCHAIN_PATH)/ranlib
CC=    $(TOOLCHAIN_PATH)/gcc
CXX=   $(TOOLCHAIN_PATH)/g++
STRIP= $(TOOLCHAIN_PATH)/strip










SOURCES  :=    \
	VideoSource.cpp \
	HomeXml.c \
	utils/xdw_list.c \
	utils/xdw_lock.c \
	utils/xdw_socket_ipc.c 
    



OBJECTS  =$(filter %.o,$(SOURCES:.c=.o))
OBJECTS  +=$(filter %.o,$(SOURCES:.cpp=.o))

DEPS+=$(filter %.P,$(OBJECTS:.o=.P))

GEN_DEPS=\
  cp $*.d $*.P \
  && sed -e 's/\#.*//' -e 's/^[^:]*: *//' -e 's/ *\\$$//' \
         -e '/^$$/ d' -e 's/$$/ :/' < $*.d >> $*.P \
  && rm -f $*.d \
  || ( rm -f $*.P $@ && exit 1 )



SILENT_CPP=@echo "CPP     $(rel_top_srcdir)$@";
SILENT_CC =@echo "CC      $(rel_top_srcdir)$@";
SILENT_S  =@echo "S       $(rel_top_srcdir)$@";
SILENT_GCH=@echo "GCH     $(rel_top_srcdir)$@";
SILENT_MM =@echo "MM      $(rel_top_srcdir)$@";
SILENT_AR =@echo "AR      $(rel_top_srcdir)$@";
SILENT_LD =@echo "LD      $(rel_top_srcdir)$@";






airmirrorserver: $(OBJECTS)
	$(SILENT_LD) $(CXX) $(CXXFLAGS) $(LDFLAGS) -o $@  $(OBJECTS) $(LIBS) \
		./lib/libavformat.a\
		./lib/libavcodec.a\
		./lib/libavutil.a\
		./lib/libswresample.a\
		./lib/libavdevice.a\
		./lib/libswscale.a\
		./lib/libavfilter.a\
        ./libmediaserver.so\
		-lbz2\
		-lssl\
		-lcrypto\
		-lva\
		/usr/lib/libvlc.so.5\
		-lcrystalhd\
		-lpthread\
		-lSDL\
		-lz\
		-lrt\
		-rdynamic
#		$(STRIP) airmirrorserver





%.o: %.cpp
	@rm -f $@
	$(SILENT_CPP) $(CXX) -MF $*.d -MD -c $(CXXFLAGS) $(DEFINES) $(INCLUDES) $< -o $@ \
        && $(GEN_DEPS)

%.o: %.cc
	@rm -f $@
	$(SILENT_CPP) $(CXX) -MF $*.d -MD -c $(CXXFLAGS) $(DEFINES) $(INCLUDES) $< -o $@ \
        && $(GEN_DEPS)

%.o: %.c
	@rm -f $@
	$(SILENT_CC) $(CC) -MF $*.d -MD -c $(CFLAGS) $(DEFINES) $(INCLUDES) $< -o $@ \
        && $(GEN_DEPS)

%.o: %.C
	@rm -f $@
	$(SILENT_CPP) $(CXX) -MF $*.d -MD -c $(CFLAGS) $(DEFINES) $(INCLUDES) $< -o $@ \
        && $(GEN_DEPS)



clean:
	-rm  $(DEPS)  $(OBJECTS) airmirrorserver
