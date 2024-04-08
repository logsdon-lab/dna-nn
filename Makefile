CFLAGS=		-g -Wall -O2 -Wc++-compat #-Wextra
CPPFLAGS=	-DHAVE_PTHREAD
OBJS=		kautodiff.o kann.o dna-io.o
PROG=		gen-fq dna-cnn dna-brnn
LIBS=		-lm -lz -lpthread

ifneq ($(asan),)
	CFLAGS+=-fsanitize=address
	LIBS+=-fsanitize=address
endif

.PHONY:all clean depend docker
.SUFFIXES:.c .o

.c.o:
		$(CC) -c $(CFLAGS) $(CPPFLAGS) $(INCLUDES) $< -o $@

all:$(PROG)

gen-fq:gen-fq.o
		$(CC) -o $@ $< $(LIBS)

dna-cnn:dna-cnn.o $(OBJS)
		$(CC) -o $@ $^ $(LIBS)

dna-brnn:dna-brnn.o mss.o $(OBJS)
		$(CC) -o $@ $^ $(LIBS)

clean:
		rm -fr gmon.out *.o a.out $(PROG) *~ *.a *.dSYM

depend:
		(LC_ALL=C; export LC_ALL; makedepend -Y -- $(CFLAGS) $(CPPFLAGS) -- *.c)

docker:
		sudo docker build . -f docker/Dockerfile -t logsdonlab/dna-nn:latest
		docker image push logsdonlab/dna-nn:latest

# DO NOT DELETE

dna-brnn.o: ketopt.h dna-io.h kann.h kautodiff.h mss.h kseq.h
dna-cnn.o: ketopt.h kann.h kautodiff.h dna-io.h kseq.h
dna-io.o: dna-io.h kseq.h
gen-fq.o: ketopt.h kseq.h khash.h
kann.o: kann.h kautodiff.h
kautodiff.o: kautodiff.h
mss.o: mss.h
