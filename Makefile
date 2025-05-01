REFERENCES=~/src/papers/Referenzarchiv.bib

all:
	mkdir -p bibxml bibtex
	rm -f bibxml/AllReferences.txt
	rm -f bibtex/AllReferences.bib
	bibtexconv $(REFERENCES) --quiet --check-urls --only-check-new-urls --mapping=author-url:authors.list:Name:URL <NorNet-Publications.export --export-to-separate-xmls=bibxml/ >/dev/null
	find bibxml/ -name "*.xml" | sort | xargs cat >bibxml/AllReferences.txt
	mv bibxml/AllReferences.txt bibxml/AllReferences.xml
	bibtexconv $(REFERENCES) --quiet --add-notes-with-isbn-and-issn --mapping=author-url:authors.list:Name:URL <NorNet-Publications.export --export-to-separate-bibtexs=bibtex/ >/dev/null
	find bibtex/ -name "*.bib" | sort | xargs cat >bibtex/AllReferences.txt
	mv bibtex/AllReferences.txt bibtex/AllReferences.bib
	bibtexconv $(REFERENCES) --mapping=author-url:authors.list:Name:URL <NorNet-Publications.export >NorNet-Publications.html.in
	sed -e "s/<\!-- BEGIN-OF-DATE -->.*<\!-- END-OF-DATE -->/<\!-- BEGIN-OF-DATE -->on `date "+%d.%m.%Y %H:%M:%S %Z"`<\!-- END-OF-DATE -->/g" <NorNet-Publications.html.in >NorNet-Publications.html

clean:
	rm -f *~ NorNet-Publications.html NorNet-Publications.html.in
	rm -rf bibtex/ bibxml/
