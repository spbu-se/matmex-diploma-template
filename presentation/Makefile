NAME ?= presentation
ENGINE ?= xelatex # Only `xelatex` or `lualatex` are allowed here

.PHONY: $(NAME).pdf clean dist-clean format depext depext-deb

all: $(NAME).pdf

$(NAME).pdf:
	latexmk -$(ENGINE) -synctex=1 -interaction=nonstopmode -file-line-error -shell-escape $(NAME).tex

clean:
	latexmk -c $(NAME).tex

dist-clean:
	latexmk -C $(NAME).tex

format:
	$(foreach file, $(shell find . -name "*.tex" -o -name "*.bib" -o -name "*.cls"), latexindent -l -s -o=$(file) -m $(file);)

aspell:
	aspell --mode=tex -l ru --home-dir=. --personal=personal_dict.txt  -c $(FILE)

depext: depext-deb

# Not a full list of external dependencies. To be extended...
depext-deb:
	sudo apt update
	sudo apt install fonts-cmu texlive-lang-cyrillic texlive-xetex texlive-bibtex-extra texlive-science texlive-plain-generic latexmk python3-pygments --yes
  # for pzdr font
	sudo apt install texlive-fonts-recommended --yes
	sudo apt install hunspell-ru --yes
