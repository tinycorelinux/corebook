NAME = corebook.txt
PDF = corebook.pdf

all: $(PDF)

$(PDF): $(NAME)
	a2x -f pdf --fop \
	--xsltproc-opts='--stringparam page.height 9in --stringparam page.width 6in' \
	--xsltproc-opts='--stringparam highlight.source 1' \
	--xsl-file='fop.xsl' \
	--asciidoc-opts='-a docinfo1' \
	$(NAME)

	mv $(PDF) $(PDF).1
	gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite \
	-dCompatibilityLevel=1.3 \
	-dPDFSETTINGS=/prepress \
	-o $(PDF) $(PDF).1
	rm $(PDF).1

$(NAME): heading $(wildcard part*/ch*/*) ending docinfo.xml Makefile
	cat heading part*/ch*/text ending > $(NAME)

clean:
	rm -f $(NAME) $(PDF) core*.xml *.fo
