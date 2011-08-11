TEXMF=${HOME}/texmf
INSTALLDIR=${TEXMF}/tex/latex/collectbox
DOCINSTALLDIR=${TEXMF}/doc/latex/collectbox
CP=cp
RMDIR=rm -rf
PDFLATEX=pdflatex -interaction=batchmode
LATEXMK=latexmk -pdf -silent

PACKEDFILES=collectbox.sty
DOCFILES=collectbox.pdf 
#collectbox-de.pdf
SRCFILES=collectbox.dtx collectbox.ins README Makefile

all: unpack doc

package: unpack
class: unpack

${PACKEDFILES}: collectbox.dtx collectbox.ins
	yes | pdflatex collectbox.ins

unpack: ${PACKEDFILES}

doc: ${DOCFILES}

pdfopt: doc
	@-pdfopt collectbox.pdf .temp.pdf && mv .temp.pdf collectbox.pdf
	@-pdfopt collectbox-de.pdf .temp.pdf && mv .temp.pdf collectbox-de.pdf

collectbox.pdf: collectbox.dtx
	${LATEXMK} $<

collectbox-de.pdf: collectbox-de.tex collectbox.dtx
	${LATEXMK} $<

collectbox.tex: unpack

.PHONY: test

test: unpack
	for T in test*.tex; do echo "$$T"; pdflatex -interaction=batchmode $$T && echo "OK" || echo "Failure"; done

clean:
	-latexmk -C collectbox.dtx
	-latexmk -C collectbox-de.tex
	${RM} ${PACKEDFILES} *.zip *.log *.aux *.toc *.vrb *.nav *.pdf *.snm *.out *.fdb_latexmk *.glo *.gls *.hd *.sta *.stp *.cod
	${RMDIR} tds

install: unpack doc ${INSTALLDIR} ${DOCINSTALLDIR}
	${CP} ${PACKEDFILES} ${INSTALLDIR}
	${CP} ${DOCFILES} ${DOCINSTALLDIR}
	texhash ${TEXMF}

${INSTALLDIR}:
	mkdir -p $@

${DOCINSTALLDIR}:
	mkdir -p $@

.PHONY: build

build: collectbox.dtx collectbox.ins README
	rm -rf build/
	mkdir build
	perl ../dtx/dtx.pl collectbox.dtx build/collectbox.dtx
	${CP} collectbox.ins README build/
	cd build && yes | tex collectbox.ins
	cd build && latexmk -pdf collectbox.dtx
	cd build && pdfopt collectbox.pdf opt.pdf && mv opt.pdf collectbox.pdf
	cd build && ctanify collectbox.dtx collectbox.ins collectbox.sty README collectbox.pdf
	cd build && ${CP} collectbox.tar.gz /tmp


