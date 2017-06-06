#Assembled by dawidd6
COMPILER=g++
CFLAGS=-Wall -fPIC -std=c++11 $(shell pkg-config --libs --cflags Qt5Core Qt5Gui Qt5Network Qt5Widgets Qt5Test) -Iinclude -Iinclude/srv
PROGRAM=qtictactoe
SRC=$(wildcard src/*.cpp)
OBJ=$(SRC:.cpp=.o)
START_COLOR=\033[0;33m
CLOSE_COLOR=\033[m
DESTDIR=

all: banner $(PROGRAM)

travis: all debian

src/%.o: src/%.cpp
	@echo "$(START_COLOR)[CXX]$(CLOSE_COLOR)   $<"
	@$(COMPILER) -c -o $@ $< $(CFLAGS)

$(PROGRAM): $(OBJ)
	@echo "$(START_COLOR)[LD]$(CLOSE_COLOR)   $@"
	@$(COMPILER) -o $@ $^ $(CFLAGS)

install:
	@echo "$(START_COLOR)[INSTALL]$(CLOSE_COLOR)   /usr/bin/$(PROGRAM)"
	@echo "$(START_COLOR)[INSTALL]$(CLOSE_COLOR)   /usr/share/applications/$(PROGRAM).desktop"
	@install -d $(DESTDIR)/usr/bin
	@install -d $(DESTDIR)/usr/share/applications
	@install $(PROGRAM) $(DESTDIR)/usr/bin
	@install data/$(PROGRAM).desktop $(DESTDIR)/usr/share/applications

uninstall:
	@echo "$(START_COLOR)[RM]$(CLOSE_COLOR)   /usr/bin/$(PROGRAM)"
	@echo "$(START_COLOR)[RM]$(CLOSE_COLOR)   /usr/share/applications/$(PROGRAM).desktop"
	@rm -rf /usr/bin/$(PROGRAM)
	@rm -rf /usr/share/applications/$(PROGRAM).desktop

clean:
	@echo "$(START_COLOR)[RM]$(CLOSE_COLOR)   src/*.o $(PROGRAM) ../*.deb ../*.changes"
	@rm -rf src/*.o $(PROGRAM) ../*.deb ../*.changes

debian:
	@echo "$(START_COLOR)[DH]$(CLOSE_COLOR)   debian"
	@dpkg-buildpackage -uc -us -b -nc > /dev/null 2>&1
	@dh_clean

docs:
	@echo "$(START_COLOR)[DOXYGEN]$(CLOSE_COLOR)   docs"
	@rm -rf docs
	@doxygen Doxyfile > /dev/null
	@touch docs/.nojekyll

vim:
	@vim src/*.cpp include/*.h src/srv/*.cpp include/srv/*.h

banner:
	@head -n 8 src/main.cpp |cut -d '*' -f2

.PHONY: install uninstall clean debian docs vim banner travis
