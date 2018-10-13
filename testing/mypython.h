#ifndef MYPYTHON_H
#define MYPYTHON_H

#include <string>
#include <vector>


class Variable{
public:
    Variable();
    Variable(char* name, int val);
    char* getIdentifier();
    int getIntVal();
private:
    char* identifier;
    int int_value;
};

class Function{
public:
    void setReturnValue();
private:
    std::string identifier;
    int int_value;
};

//Variable that is defined elsewhere (mypython.cpp)
extern std::vector<Variable> variables;

#endif