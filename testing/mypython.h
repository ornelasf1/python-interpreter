#ifndef MYPYTHON_H
#define MYPYTHON_H

#include <string>
#include <vector>



enum NodeType
{	ADD_NODE,SUB_NODE,MULT_NODE,DIVIDE_NODE,GT_NODE,GTE_NODE,LT_NODE,LTE_NODE,
	EQUAL_NODE,NOT_EQUAL_NODE,FUNCTION_NODE, ASSIGN_NODE,
	FUNCRETURN_NODE,IF_NODE,CONDITION_NODE,ELSE_NODE,BLOCK_NODE,PRINT_NODE
};

class Node{
public:
	Node();
	Node(NodeType);
	NodeType type;
};

class PrintNode : public Node{
public:
	PrintNode();
	PrintNode(std::string);
	PrintNode(int);
	PrintNode(std::string, int);
	std::string stringValue;
	int intValue;
};

class AssignNode : public Node{
public:
	AssignNode();
	AssignNode(std::string, int);
	std::string variable;
	int value;
};


class Variable{
public:
    Variable();
    Variable(std::string, int, std::string);
    Variable(std::string, std::string, std::string);
    Variable(std::string, float, std::string);
    std::string TYPE;
    std::string getIdentifier();
    int getIntValue();
    void setIntValue(int);
    static void printVariableValue(Variable* var);
private:
    std::string identifier;
    int int_value;
};

class Function{
public:
    Function();
    Function(std::vector<Variable>);
    Function(std::string, int, std::vector<Variable>);
    std::string identifier;
    int index;
    int returnValue;
    std::vector<Node*> statements;
    std::vector<Variable> variables;
    void setReturnValue(int);
};

class Scope{
public:
    Scope();
    Scope(std::string, std::vector<Variable>);
    std::string identifier;
    std::vector<Variable> variables;
    std::vector<Function> functions;

    Variable* getVariable(std::string var);
};


extern Scope* program;

// Variable that is defined elsewhere (mypython.cpp)
// extern std::vector<Variable> variables;

// extern Variable* getVariable(std::string var);


#endif