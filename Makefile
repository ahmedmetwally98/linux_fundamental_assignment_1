SRC=$(wildcard *.cpp)
OBJ=$(patsubst %cpp,%o,$(SRC))

CXXFLAGS= -c -O2 -Wall
LDFLAGS = -Wall

TARGET=testApp.out

all: $(TARGET)

$(TARGET): $(OBJ)
	@$(CXX) $(LDFLAGS) -o $@ $^

%.o: %.cpp
	@$(CXX) $(CXXFLAGS) -o $@ $<
clean:
	@rm -f $(TARGET)

.PHONY: clean all