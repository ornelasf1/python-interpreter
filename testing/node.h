#include <string>

enum NodeType
{	ADD_NODE,SUB_NODE,MULT_NODE,DIVIDE_NODE,GT_NODE,GTE_NODE,LT_NODE,LTE_NODE,
	EQUAL_NODE,NOT_EQUAL_NODE,FUNCTION_NODE, ASSIGN_NODE
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
	PrintNode(string);
	PrintNode(int);
	PrintNode(string, int);
	std::string stringValue;
	int intValue;
}

class AssignNode : public Node{
public:
	AssignNode();
	AssignNode(string, int);
	std::string variable;
	int value;
}