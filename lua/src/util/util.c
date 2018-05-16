#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include "util.h"
void trim(char* str,char c,int len){
	int32_t start=-1,p=0;
	while(p<len){
		if(str[p] != c){
			str[++start]=str[p++];
		}else{
			p++;
		}
	}
	str[start+1]='\0';
}

