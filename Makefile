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


all:	bibtex/AllReferences.bib bibxml/AllReferences.xml NorNet-Publications.html.section


NorNet-Publications.html:	$(REFERENCES) NorNet-Publications.export
	bibtexconv $(REFERENCES) --quiet \
	   --check-urls --only-check-new-urls \
	   --mapping=author-url:authors.list:Name:URL \
	   <NorNet-Publications.export \
	   >NorNet-Publications.html.in
	sed -e "s/<\!-- BEGIN-OF-DATE -->.*<\!-- END-OF-DATE -->/<\!-- BEGIN-OF-DATE -->on `date "+%d.%m.%Y %H:%M:%S %Z"`<\!-- END-OF-DATE -->/g" <NorNet-Publications.html.in >NorNet-Publications.html
	rm -f NorNet-Publications.html.in

NorNet-Publications.html.section:	NorNet-Publications.html
	text-block --extract --min-actions 1 \
	   --begin-tag "- BEGIN-OF-PUBLICATIONS -" --end-tag "- END-OF-PUBLICATIONS -" \
	   --exclude-tags --full-tag-line \
	   --input NorNet-Publications.html --output NorNet-Publications.html.section

bibtex/AllReferences.bib:	NorNet-Publications.html
	mkdir -p bibtex
	rm -f bibtex/AllReferences.txt
	bibtexconv $(REFERENCES) --quiet \
	   --add-notes-with-isbn-and-issn \
	   --non-interactive \
	   --export-to-separate-bibtexs=bibtex/
	find bibtex/ -name "*.bib" | sort | xargs cat >bibtex/AllReferences.txt
	mv bibtex/AllReferences.txt bibtex/AllReferences.bib

bibxml/AllReferences.xml:	NorNet-Publications.html
	mkdir -p bibxml
	rm -f bibxml/AllReferences.txt
	bibtexconv $(REFERENCES) --quiet \
	   --export-to-separate-xmls=bibxml/ \
	   --non-interactive
	find bibxml/ -name "*.xml" | sort | xargs cat >bibxml/AllReferences.txt
	mv bibxml/AllReferences.txt bibxml/AllReferences.xml

clean:
	rm -f *~ NorNet-Publications.html bibtex/AllReferences.bib bibxml/AllReferences.xml
	rm -rf bibtex/ bibxml/
