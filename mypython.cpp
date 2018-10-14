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

vector<Variable> variables;
Variable* getVariable(string var);

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

    for(int i = 0; i < variables.size(); i++){
        printf("%d Variable: %s\n", i, variables[i].getIdentifier().c_str());
    }

	return 0;
}

Variable::Variable(string name, int val, string type){
    identifier = name;
    int_value = val;
    TYPE = type;
}
Variable::Variable(string name, string val, string type){
    identifier = name;
    str_value = val;
    TYPE = type;
}
Variable::Variable(string name, float val, string type){
    identifier = name;
    flo_value = val;
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
string Variable::getStrValue(){
    return str_value;
}
float Variable::getFloValue(){
    return flo_value;
}

void Variable::printVariableValue(Variable* var){
	if(var->TYPE == "STRING")
		printf("Printing: %s\n", var->getStrValue().c_str());
	if(var->TYPE == "INT")
		printf("Printing: %d\n", var->getIntValue());
	if(var->TYPE == "FLOAT")
		printf("Printing: %f\n", var->getFloValue());
}

Variable* getVariable(string var){
	for(int i = 0; i < variables.size(); i++)
		if(var == variables[i].getIdentifier())
			return &(variables[i]);
	return NULL;
}
