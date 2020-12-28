grammar Gram3;
options {
    language=Java;
    k=1;
    backtrack=false;
    output = AST;
}

tokens{
    ROOT;
    DEF_CLASS;
    PARAM_CLASS;
    BODY;
    DEF_METHODE;
    DEF_CONS;
    DEC_ATT ;
    EXPR;
    AFFEC;
    IF;
    WHILE;
    RETOUR;
    BLOC;
    FONCT;
    POINTEUR;
    DECLAR_AFFECT;
    PARAM_FONCT;
    INSTANCIATION;
    PARENTH;
    
    
}



program
    : def_class* block? ->^(ROOT def_class* block?)
    ; 

def_class
    :'class' ID_CLASS ('(' (param_class(','param_class)*)?')')? ('extends' ID_CLASS)? 'is' block_class 
      ->^(DEF_CLASS ID_CLASS param_class* ID_CLASS? block_class)
    ;
param_class
    : 'var'? ID ':' ID_CLASS ->^(PARAM_CLASS ID ID_CLASS)
    ;

block_class
    :'{' expression_class '}' ->^(BODY expression_class)
    ;
expression_class 
    :attributAvC
    | 'def' (methodeAvC->methodeAvC | constructeur-> constructeur) 
    ;
constructeur
    : ID_CLASS '(' (param_class(',' param_class)*)? ')' (':' ID_CLASS '(' (expression(',' expression)*)? ')')? 'is' block expression_classSC?
     ->^(DEF_CONS ID_CLASS param_class* block expression_classSC?)
    ;
expression_classSC
    :'def' methodeSC -> methodeSC
    |attributSC
    ;
attributSC
    : attribut expression_classSC?
    ;
attributAvC
    : attribut expression_class
    ;
methodeAvC
    : methode expression_class
    ;
methodeSC
    : methode expression_classSC?
    ;

attribut 
    :'var' 'static'? ID ':' ID_CLASS (':=' expression)? ';' ->^(DEC_ATT ID ID_CLASS expression?)
    ;
methode 
    :  'static'? 'override'? ID '(' (param_class(',' param_class)*)? ')' methode_type -> ^(DEF_METHODE ID param_class* methode_type)
    ; 
methode_type
    : ':' ID_CLASS ('is' block -> ID_CLASS block | ':=' expression ';'-> ID_CLASS expression)
    | 'is' block -> block
    ;
block
    :'{' instruction* '}'->^(BLOC instruction*)
    ; 

instruction
    : expression fin ->^(EXPR expression fin?)
    | block 
    | 'return'';' ->
    | 'if' expression 'then' instruction 'else' instruction ->^(IF expression instruction instruction)
    | 'while' expression 'do' instruction ->^(WHILE expression instruction)
    ;

instanciation
    : 'new' ID_CLASS'('(expression (','expression)*)?')' ->^(INSTANCIATION ID_CLASS expression*)
    ;
fin 
    :  ':=' expression ';' ->^(AFFEC expression)
    | ':' ID_CLASS (':=' expression)? ';'  ->^(DECLAR_AFFECT ID_CLASS expression?)
    | ';' ->
    ;

expression
    : expr0
    ;

expr0
    :expr1(('<'^|'<>'^|'>'^|'='^) expr1)* 
    ;

expr1
    : expr2 (('+'^|'-'^) expr2)* 
    | ('+'|'-') valeur
    ;

expr2
    : expr3 (('*'^|'/'^) expr3)* 
    ;
 
 expr3
    :expr4 (('&'^) expr4)*
    ;
 expr4
    : valeur (('.'^) variable )*
    ; 


   
variable
    : ID (fonction -> ^(FONCT ID fonction?)| -> ID)
    ;
    
fonction
    :('(' ((expression) (',' (expression))*)? ')') -> ^(PARAM_FONCT expression*)?
    ;

valeur 
    : INT
    |IDENTIFICATEUR
    |STRING
    |ID_CLASS
    | variable
    |'(' cast?  expression ')' ->^(PARENTH cast? expression)
    | instanciation
    ;

cast
    :('as' ID_CLASS ':') -> ID_CLASS
    ;

IDENTIFICATEUR 
    :'this' 
    |'super' 
    |'result'
    ;

STRING  :   '"'(~'"')*'"' 
    ;
ID_CLASS:    ('A'..'Z')('a'..'z'|'A'..'Z'|'0'..'9'|'_')*
    ;

ID  :    ('a'..'z'|'A'..'Z'|'_') ('a'..'z'|'A'..'Z'|'0'..'9'|'_')*
        ;

INT :    '0'..'9'+
       ;

WS  :   ( ' '
        | '\t'
        | '\r'
        | '\n'
        | '//' (~'\n')* '\n'
        | '/*' (.)* '*/'
        ) {$channel=HIDDEN;}
    ;