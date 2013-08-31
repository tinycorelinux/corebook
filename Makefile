NAME = corebook.txt
PDF = corebook.pdf

all: $(PDF)

$(PDF): $(NAME)
	a2x -f pdf --fop --icons \
	--xsltproc-opts='--stringparam page.height 9in \
		--stringparam double.sided 1 \
		--stringparam headers.on.blank.pages 0 \
		--stringparam footers.on.blank.pages 0 \
		--stringparam tablecolumns.extension 0 \
		--stringparam page.width 6in' \
	--xsl-file='fop.xsl' \
	--asciidoc-opts='-a docinfo1' \
	--fop-opts="-dpi 300" \
	$(NAME)

	mv $(PDF) $(PDF).1
	gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite \
	-dCompatibilityLevel=1.3 \
	-dPDFSETTINGS=/prepress \
	-o $(PDF) $(PDF).1
	rm $(PDF).1

$(NAME): heading $(wildcard part*/ch*/*) ending docinfo.xml Makefile fop.xsl
	cat heading part*/ch*/text ending > $(NAME)

clean:
	rm -f $(NAME) $(PDF) core*.xml *.fo

up: all
	scp $(PDF) tcbox:public_html
