CC = csc
SRC = src

.PHONY: all
.PHONY: clean
.PHONY: install

all: grep_fasta

clean:
	-rm -r $(SRC)/*.o ./grep_fasta

install:
	cp ./grep_fasta /usr/local/bin

grep_fasta:
	$(CC) -c $(SRC)/pfa.scm
	$(CC) -c $(SRC)/cli.scm
	$(CC) -c $(SRC)/grep_fasta.scm
	$(CC) -o $@ $(SRC)/pfa.o $(SRC)/cli.o $(SRC)/grep_fasta.o
