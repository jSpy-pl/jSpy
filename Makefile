EXE = test-code-parser
CATCH = catch
SRC = code-parser.cpp generators.cpp
OBJ = $(SRC:.cpp=.o)

CXX    =  g++
DEBUG = -g
CFLAGS = -Wall -std=c++11 $(DEBUG)

# * * * * * Subdirectories * * * * *
MODULES=exp-parser
CFLAGS += -I./exp-parser
#SUB_OBJ = $(filter-out exp-parser/catch.o $(wildcard exp-parser/*.o))
SUB_OBJ = functions.o packToken.o shunting-yard.o

# * * * * * Recipes * * * * *

all: $(EXE)

%.o: %.cpp *.h; $(CXX) $(CFLAGS) -c $<

$(EXE): modules $(OBJ) $(SUB_OBJ) $(CATCH).o
	$(CXX) $(CFLAGS) $(OBJ) $(SUB_OBJ) $(CATCH).o $(EXE).cpp -o $(EXE)

jspy: modules $(OBJ) $(SUB_OBJ)
	$(CXX) $(CFLAGS) $(OBJ) $(SUB_OBJ) jspy.cpp -o jspy

run: jspy
	./jspy

test: $(EXE); ./$(EXE)

check: $(EXE); valgrind ./$(EXE)

modules: $(MODULES)
	@echo
	@echo "Checking submodule $<..."
	make -s -C $</
	@echo

$(SUB_OBJ): $(MODULES)
	rsync -u $(foreach module, $(MODULES), $(module))/*.o .

clean:; rm -f $(EXE) *.o
