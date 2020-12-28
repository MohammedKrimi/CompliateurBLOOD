# Projet de compilation
## Introduction
Dans le but du projet de compilation, nous avons créer une grammaire LL(1) permettant de reconnaître le language BLOOD. L'objectif étant dans cette première partie de générer l'analyseur syntaxique descandant ainsi qu'un arbre abstrait sur divers programmes. Ce document sert à appuyer la présentation de cette partie.

## Dépôt git
Notre dépôt git, est composé de notre grammaire ``Gram3.g``, de l'archive antlr3 ``antlr-3.5.2-complete.jar``, ansi que de plusieurs dossiers contenant des programmes écrits en language BLOOD qui nous serviront de tests.

## La grammaire
### Tests présentés
L'objectif de cette présentation est de montrer la construction d'un AST dans différents cas.
#### Expressions arithmétiques, affectations et déclarations de variables
```java
{
//Variable et opération
    a : Integer := 5;
    b : Integer := 6;
    c : Integer := - (1 + 4 + a + b * b / ( a - 12 ));
//Echange de deux variables
    temp : Integer := a;
    a := b;
    b := temp;
//Opérateurs booléens
    bool := a = b;
//Concaténation 
    chaine1:String:= "le test";
    chaine2:String:= " marche";
    chaine3:String:= chaine1 & chaine2;
}
```

#### Boucles if, while avec instructions et imbrications
```java
//if dans while
{
while True do 
    if True 
        then sta:="cc"; 
        else sta:="CC";
}
//while dans if
{

if False 
       then 
		while True do True:=True-1;

        else if True 
              then if True
                     then stb:=”gg”;
                     else stb := “hh”;
              else if False
		     then sta:="oui";
		     else stab:="non";






}
```

#### Définitions de classe, constructeur, méthodes avec paramètres ou non
```java
class Test( var int : Integer, var name : String) is 
{
    def avantTest() is {}
    def Test (var int : Integer, var name : String) is {/*definition du constructeur*/}
    def static setTest (var name : String) is {/*faire de opérations */} 
}
```

#### Appels de méthodes
```java
{
    // Accès à un attibut
    vehicle.price := 1000;

    // Appel de méthode sans paramètres
    vehicle.getModel().println();

    // Appel de méthode avec un ou plusieurs paramètres
    vehicle.setColor("blue");
    vehicle.setFeature("car","red",15000);

    // Appel de méthode à l'intérieur des paramètres
    vehicle.setPrice("15000".toInt());
}
```

### Tests complémentaires
Des test complémentaire ont été créés afin de vérifier la précision de notre grammaire.

## Intégration continue
Afin de faciliter l'exécution des tests, une intégration continue a été ajoutée à notre dépôt git. À chaque push, des pipelines réalisent les différents tests.
