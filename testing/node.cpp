
#include "node.h"

Node::Node(){
}
Node::Node(NodeType t){
    type = t;
}

PrintNode::PrintNode(){
}
PrintNode::PrintNode(string s){
    stringValue = s;
}
PrintNode::PrintNode(int i){
    intValue = i;
}
PrintNode::PrintNode(string s, int i){
    stringValue = s;
    intValue = i;
}

AssignNode::AssignNode(){
}
AssignNode::AssignNode(string s, int i){
    variable = s;
    value = i;
}