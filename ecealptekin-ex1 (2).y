%{
#include <stdio.h>
#include <string.h>
#include <memory.h>
#include <stdlib.h>
#include <stdbool.h>

int yylex();
void yyerror (const char *s);

char * resetLocal(char * Local);

extern int line;  
extern int isGlobal;

char * Global;
char * Local;

int lineNo;
int detectGlob;

%}

%union {
  char * ch;
}

%token tRETURN tPRINT tIDENT tSTRINGVAL tPOSINTVAL tNEGINTVAL tLPAR tRPAR tCOMMA tMOD tASSIGNM tMINUS tPLUS tDIV tSTAR tSEMI tLBRAC tRBRAC tINTTYPE tSTRINGTYPE

%type <ch> tIDENT;

%left tIDENT
%left tSTAR tDIV tMOD
%left tPLUS tMINUS
%left tASSIGNM
%left tLPAR tRPAR



%start prog

%%

prog: itemlist
;

itemlist: itemlist item 
        | item
;

item: functiondef
    | variable
    | assignment
    | print  
;

type: tINTTYPE
    | tSTRINGTYPE
;

value: tIDENT                                          {
    						        if(isGlobal == 0) 
                                                           {
                                                             if(strstr(Global, $1) != NULL) 
                            				     {
						             
                                                             }
                                                             else if(strstr(Local, $1) != NULL) 
                            				     {
							 
                                                             }
                                                             else 
							     {
							     strcat(Local, $1);
                                                             printf("%d Undefined variable\n", line);
            						     exit(0);
                                                             }
                                                        }
                                                        else
                                                        {
                                                             if(strstr(Global, $1) != NULL) 
                            				     {
							   
                                                             }
                                                             else 
							     {
							     strcat(Global, $1);
                                                           
                                                             }
                                                         }       
                                                      }                                                   
    | tPOSINTVAL                                        
    | tSTRINGVAL                                 
;

expression: value                                    
          | functioncall
          | expression tSTAR expression      
          | expression tPLUS expression       
          | expression tMINUS expression       
          | expression tDIV expression       
          | expression tMOD expression 
          | value tNEGINTVAL   
          | tNEGINTVAL tNEGINTVAL
          | tNEGINTVAL value
          | tNEGINTVAL
;

functioncall: tIDENT {detectGlob = isGlobal;} tLPAR expressions tRPAR    {   if(detectGlob == 0) {isGlobal = 0;} 
					                                     else                {isGlobal = 1;} 
    									 }                
;

assignment: tIDENT {lineNo = line; detectGlob = isGlobal;} tASSIGNM expression tSEMI      
                      			               { 
        						 
					                if(detectGlob == 0) {isGlobal = 0;} 
					                else                {isGlobal = 1;} 
					      

                    					if(isGlobal == 0) 
                                                        {
						            
                                                           if(strstr(Global, $1) != NULL) 
                            				   {
							     
                                                           }

                                                           else if(strstr(Local, $1) != NULL) 
                            				   {
							      
                                                           }
                                                           else 
							   {
							     strcat(Local, $1);
							     if(line != lineNo) {printf("%d Undefined variable\n", lineNo); exit(0);}
                                                             else               {printf("%d Undefined variable\n", line);  exit(0);}
                                                           
                                                           }
                                                        }
                                                        else
                                                        {
                                                           if(strstr(Global, $1) != NULL) 
                            				   {
                                                           }
                                                           else 
							   {
							     strcat(Global, $1);
                      					     if(line != lineNo) {printf("%d Undefined variable\n", lineNo); exit(0);}
                                                             else               {printf("%d Undefined variable\n", line);  exit(0);}
                                                          }
                                                         }
                                                       }                                                            
; 

expressions:| expressions tCOMMA expression
            | expression
; 
   
functiondef: type tIDENT tLPAR parameters tRPAR tLBRAC bodys return tRBRAC         { Local = resetLocal(Local); }
;

variable: type tIDENT {lineNo = line;} tASSIGNM expressions tSEMI    
 					   	       { 
                    					if(isGlobal == 0) 
                                                        {
                              			           if(strstr(Global, $2) != NULL) 
                            				   {
							     if(line != lineNo) {printf("%d Redefinition of variable\n", lineNo); exit(0);}
                                                             else               {printf("%d Redefinition of variable\n", line);   exit(0);}
                                                           }

                                                           else if(strstr(Local, $2) != NULL) 
                            				   {
							     printf("%d Redefinition of variable\n", line);
           						     exit(0);
                                                           }
                                                           else 
							   {
							     strcat(Local, $2);
                                                           
                                                           }
                                                        }
                                                        else
                                                        {
                                                           if(strstr(Global, $2) != NULL) 
                            				   {
							     if(line != lineNo) {printf("%d Redefinition of variable\n", lineNo); exit(0);}
                                                             else               {printf("%d Redefinition of variable\n", line);  exit(0);}
                                                           }
                                                           else 
							   {
							     strcat(Global, $2);
                                                           
                                                           }
                                                        }
                                                       }
;

bodys: bodys body                               
     | body 
     | 
;

body: variable        
    | assignment    
    | print          
;

return: tRETURN expression tSEMI
;

parameter: type tIDENT                                 { 
                    					if(isGlobal == 0) 
                                                        {
                              			           if(strstr(Global, $2) != NULL) 
                            				   {
							     printf("%d Redefinition of variable\n", line);
							     exit(0);
                                                           }

                                                           else if(strstr(Local, $2) != NULL) 
                            				   {
							     printf("%d Redefinition of variable\n", line);
							     exit(0);
                                                           }
                                                           else 
							   {
							     strcat(Local, $2);
                                                     
                                                           }
                                                        }
                                                        else
                                                        {
                                                           if(strstr(Global, $2) != NULL) 
                            				   {
							   
                                                           }
                                                           else 
							   {
							     strcat(Global, $2);
                                                   
                                                           }
                                                        }
                                                      }
;

parameters: parameters tCOMMA parameter
          | parameter
          |                                                                   
;

print: tPRINT tLPAR expression tRPAR tSEMI
;

%%

void yyerror (const char *s) 
{
	printf ("Line: %d, %s\n", line, s); 
}

char * resetLocal(char * Local)
{
   char * ret = (char *)malloc (sizeof(100)); 
   return(ret);
}

int main ()
{
   Global = (char *)malloc (sizeof(100));
   Local = (char *)malloc (sizeof(100));

   if (yyparse()) {
   // parse error
       printf("ERROR\n");
       return 1;
   }
   else {
   // successful parsing
      printf("OK\n");
      return 0;
   }
}
