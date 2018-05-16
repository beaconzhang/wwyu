#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include "util.h"

int main(int argc,char**argv){
	if(argc!=2){
		perror("please input string\n");
		exit(-1);
	}
	char* p=(char*)malloc(strlen(argv[1])+1);
	memcpy(p,argv[1],strlen(argv[1])+1);
	trim(p,' ',strlen(argv[1]));
	printf("origin:%s\ntrim:%s\n",argv[1],p);
	free(p);
	return 0;
}
