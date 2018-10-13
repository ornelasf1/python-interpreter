#include <iostream>
#include <stdio.h>
#include <string>
#include "mypython.h"
#include "calc.tab.h"
#include <vector>

using namespace std;

extern int yylex();
extern int yyparse();
extern FILE* yyin;

vector<Variable> variables;

int main(int argc, char** argv) {
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
        yyin =stdin;
    }
    
	
    do {
		yyparse();
	} while(!feof(yyin));

    for(int i = 0; i < variables.size(); i++){
        printf("%d Variable: %s\n", i, variables[i].getIdentifier());
    }

	return 0;
}

Variable::Variable(char* name, int val){
    identifier = name;
    int_value = val;
}

char* Variable::getIdentifier(){
    return identifier;
}

int Variable::getIntVal(){
    return int_value;
}

