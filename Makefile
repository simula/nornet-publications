REFERENCES=~/src/papers/Referenzarchiv.bib

all:
	mkdir -p bibxml bibtex
	bibtexconv $(REFERENCES) -check-urls -only-check-new-urls <NorNet-Publications.export -export-to-separate-xmls=bibxml/ >/dev/null
	find bibxml/ -name "*.xml" | sort | xargs cat >bibxml/AllReferences.txt
	mv bibxml/AllReferences.txt bibxml/AllReferences.xml
	bibtexconv $(REFERENCES) -add-notes-with-isbn-and-issn <NorNet-Publications.export -export-to-separate-bibtexs=bibtex/ >/dev/null
	find bibtex/ -name "*.bib" | sort | xargs cat >bibtex/AllReferences.txt
	mv bibtex/AllReferences.txt bibtex/AllReferences.bib
	bibtexconv $(REFERENCES) <NorNet-Publications.export >NorNet-Publications.html.in
	sed -e "s/<\!-- BEGIN-OF-DATE -->.*<\!-- END-OF-DATE -->/<\!-- BEGIN-OF-DATE -->on `date "+%d.%m.%Y %H:%M:%S %Z"`<\!-- END-OF-DATE -->/g" <NorNet-Publications.html.in >NorNet-Publications.html
