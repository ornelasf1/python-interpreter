#ifndef MYPYTHON_H
#define MYPYTHON_H

#include <string>
#include <vector>


class Variable{
public:
    Variable();
    Variable(std::string, int, std::string);
    Variable(std::string, std::string, std::string);
    Variable(std::string, float, std::string);
    std::string TYPE;
    std::string getIdentifier();
    int getIntValue();
    std::string getStrValue();
    float getFloValue();
    static void printVariableValue(Variable* var);
private:
    std::string identifier;
    int int_value;
    std::string str_value;
    float flo_value;
};

class Function{
public:
    void setReturnValue();
private:
    std::string identifier;
    int int_value;
};

class Scope{
public:
    Scope();
    Scope(std::vector<Variable> vars);
    Scope* innerScope;
private:
    std::vector<Variable> scopeVariables;
};

//Variable that is defined elsewhere (mypython.cpp)
extern std::vector<Variable> variables;

extern Variable* getVariable(std::string var);


#endif