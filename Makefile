MAIN=vkr
NAME=$(MAIN)
XELATEX=xelatex -jobname=$(NAME)

.PHONY: $(NAME).pdf clean depext depext-deb

all: $(NAME).pdf

FILES_TEX=$(MAIN).tex 000intro.tex 010task.tex 020related.tex 040method.tex 070experiment.tex 090conclusion.tex

$(NAME).pdf: $(FILES_TEX)
	$(XELATEX) $<
	bibtex $(MAIN).aux
	$(XELATEX) $<
	$(XELATEX) $<

clean:
	$(RM) *.bak *.out *.toc *.bcf *.bbl *.blg *.aux *.nav *.vrb *.snm *.log $(NAME).run.xml *.synctex.gz

aspell:
	aspell --mode=tex -l ru --home-dir=. --personal=personal_dict.txt  -c $(FILE)

depext: depext-deb

# Not a full list of external dependencies. To be extended...
depext-deb:
	sudo apt install fonts-cmu texlive-lang-cyrillic texlive-xetex texlive-bibtex-extra texlive-plain-generic \
  # for pzdr font
	sudo apt install texlive-fonts-recommended 
	sudo apt install hunspell-ru


