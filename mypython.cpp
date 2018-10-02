#include <iostream>
#include <fstream>
#include <string>

using namespace std;

int main(int argc, char** argv){
    string filename;
    ifstream inputFile;
    try{
        if(argc == 2){
            filename = argv[1];
            string ext = filename.substr(filename.find("."), string::npos);
            if(ext != ".py"){
                throw;
            }
            printf("Open %s \n", filename);
            inputFile.open(filename);
        }else{
            throw;
        }
    }catch(...){
        printf("Input: mypython <file.py>");
    }

    char c;
    if(inputFile.is_open()){
        while(inputFile.get(c)){
            printf("%c", c);
        }
    }
    inputFile.close();

    return 0;
}