#include <iostream>
#include <stdio.h>
#include <string>
#include "mypython.h"
#include "calc.tab.h"
#include <vector>
#include <stdexcept>

using namespace std;

extern int yylex();
extern int yyparse();
extern FILE* yyin;

Scope* program = new Scope();

// vector<Variable> variables;
// Variable* getVariable(string var);

int main(int argc, char** argv) {
    // extern int yydebug;
    // yydebug = 1;
    string filename;
    const char* FILE_filename;
    FILE* inputFile;
    try{
        if(argc == 2){
            filename = argv[1];
            FILE_filename = argv[1];
            string ext = filename.substr(filename.find("."), string::npos);
            if(ext != ".py"){
                throw runtime_error("error");
            }
            printf("Opening %s \n\n", filename.c_str());
            inputFile = fopen(FILE_filename, "r");
            yyin = inputFile;
        }else{
            throw runtime_error("error");
        }
    }catch(...){
        // printf("Input: mypython <file.py>\n");
        // return 1;
        yyin = stdin;
    }
    
	
    do {
		yyparse();
	} while(!feof(yyin));

    for(int i = 0; i < program->variables.size(); i++){
        printf("%d Variable: %s and its value is %d \n", i, program->variables[i].getIdentifier().c_str(),program->variables[i].getIntValue());
    }

	return 0;
}

Scope::Scope(){}

Scope::Scope(string id, vector<Variable> vars){
    identifier = id;
    variables = vars;
}

Function::Function(){
}
Function::Function(vector<Variable> v){
    variables = v;
}
Function::Function(string s, int i, vector<Variable> v){
    identifier = s;
    index = i;
    variables = v;
}


Variable::Variable(string name, int val, string type){
    identifier = name;
    int_value = val;
    TYPE = type;
}

string Variable::getIdentifier(){
    return identifier;
}

void Variable::setIntValue(int val){
    int_value = val;
}
int Variable::getIntValue(){
    return int_value;
}

void Variable::printVariableValue(Variable* var){
	if(var->TYPE == "INT")
		printf("Printing: %d\n", var->getIntValue());
}

Variable* Scope::getVariable(string var){
	for(int i = 0; i < program->variables.size(); i++)
		if(var == program->variables[i].getIdentifier())
			return &(program->variables[i]);
	return NULL;
}
