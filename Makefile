MAIN=vkr
NAME=$(MAIN)
XELATEX=xelatex -jobname=$(NAME)

.PHONY: $(NAME).pdf clean depext depext-deb

all: $(NAME).pdf

FILES_TEX=$(MAIN).tex intro.tex related.tex

$(NAME).pdf: $(FILES_TEX)
	$(XELATEX) $<
	bibtex $(MAIN).aux
	$(XELATEX) $<
	$(XELATEX) $<

clean:
	$(RM) *.bak *.out *.toc  *.bbl *.blg *.aux *.nav *.vrb *.snm *.log *.synctex.gz

aspell:
	aspell --mode=tex -l ru --home-dir=. --personal=personal_dict.txt  -c $(FILE)

depext: depext-deb

# Not a full list of external dependencies. To be extended...
depext-deb:
	sudo apt install fonts-cmu texlive-lang-cyrillic texlive-xetex
