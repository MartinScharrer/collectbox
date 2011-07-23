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

all: doc

package: unpack
class: unpack

${PACKEDFILES}: collectbox.dtx collectbox.ins
	pdflatex collectbox.ins

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

ctanify: ${SRCFILES} ${DOCFILES} collectbox.tds.zip
	${RM} collectbox.zip
	zip collectbox.zip $^ 
	unzip -t collectbox.zip
	unzip -t collectbox.tds.zip

zip: collectbox.zip

tdszip: collectbox.tds.zip

collectbox.zip: ${SRCFILES} ${DOCFILES} | pdfopt
	${RM} $@
	zip $@ $^ 

collectbox.tds.zip: ${SRCFILES} ${PACKEDFILES} ${DOCFILES} | pdfopt
	${RMDIR} tds
	mkdir -p tds/tex/latex/collectbox
	mkdir -p tds/doc/latex/collectbox
	mkdir -p tds/source/latex/collectbox
	${CP} ${DOCFILES}    tds/doc/latex/collectbox
	${CP} ${PACKEDFILES} tds/tex/latex/collectbox
	${CP} ${SRCFILES}    tds/source/latex/collectbox
	cd tds; zip -r ../$@ .

