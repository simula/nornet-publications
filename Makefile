# NorNet Publications List
# Copyright (C) 2012-2025 by Thomas Dreibholz
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# Contact: dreibh@simula.no

REFERENCES=~/src/papers/Referenzarchiv.bib


all:	bibtex/AllReferences.bib bibxml/AllReferences.xml \
	NorNet-Publications.html.block \
	NorNet-Publications.odt NorNet-Publications.docx


NorNet-Publications.html:	$(REFERENCES) NorNet-Publications.export
	bibtexconv $(REFERENCES) --quiet \
	   --check-urls --only-check-new-urls \
	   --mapping=author-url:authors.list:Name:URL \
	   <NorNet-Publications.export \
	   >NorNet-Publications.html.in
	sed -e "s/<\!-- BEGIN-OF-DATE -->.*<\!-- END-OF-DATE -->/<\!-- BEGIN-OF-DATE -->on `date "+%d.%m.%Y %H:%M:%S %Z"`<\!-- END-OF-DATE -->/g" <NorNet-Publications.html.in >NorNet-Publications.html.out
	rm -f NorNet-Publications.html.in
	if which -s tidy ; then tidy -o /dev/null -q NorNet-Publications.html.out ; fi
	mv NorNet-Publications.html.out NorNet-Publications.html

NorNet-Publications.html.block:	NorNet-Publications.html
	text-block --extract --min-actions 1 \
	   --begin-tag "- BEGIN-OF-PUBLICATIONS -" --end-tag "- END-OF-PUBLICATIONS -" \
	   --exclude-tags --full-tag-line \
	   --input NorNet-Publications.html --output NorNet-Publications.html.block

bibtex/AllReferences.bib:	NorNet-Publications.html
	mkdir -p bibtex
	rm -f bibtex/AllReferences.out
	bibtexconv $(REFERENCES) --quiet \
	   --mapping=author-url:authors.list:Name:URL \
	   --export-to-separate-bibtexs=bibtex/ \
	   <NorNet-Publications.export \
	   >/dev/null
	find bibtex/ -name "*.bib" | sort | xargs cat >bibtex/AllReferences.out
	mv bibtex/AllReferences.out bibtex/AllReferences.bib

bibxml/AllReferences.xml:	NorNet-Publications.html
	mkdir -p bibxml
	rm -f bibxml/AllReferences.out
	bibtexconv $(REFERENCES) --quiet \
	   --mapping=author-url:authors.list:Name:URL \
	   --export-to-separate-xmls=bibxml/ \
	   <NorNet-Publications.export \
	   >/dev/null
	print-utf8 -n '<?xml version="1.0" encoding="UTF-8"?>' >bibxml/AllReferences.out
	echo "<references>" >>bibxml/AllReferences.out
	echo "" >>bibxml/AllReferences.out
	find bibxml/ -name "*.xml" -a ! -name "AllReferences.xml" | sort | xargs -n1 text-block -X --select 3 0 -i >>bibxml/AllReferences.out
	echo "" >>bibxml/AllReferences.out
	echo "</references>" >>bibxml/AllReferences.out
	mv bibxml/AllReferences.out bibxml/AllReferences.xml

NorNet-Publications.odt:	NorNet-Publications-ODT.export bibtex/AllReferences.bib
	bibtexconv-odt /usr/share/doc/bibtexconv/examples/ODT-Template.odt NorNet-Publications.odt bibtex/AllReferences.bib  NorNet-Publications-ODT.export

NorNet-Publications.docx:	NorNet-Publications.odt
	./odt2docx NorNet-Publications.odt


clean:
	rm -f *~ NorNet-Publications.html bibtex/AllReferences.bib bibxml/AllReferences.xml NorNet-Publications.odt
	rm -rf bibtex/ bibxml/
