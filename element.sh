#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

ELEMENT_PROVIDED=$1

if [[ -z $ELEMENT_PROVIDED ]]
  then 
    echo "Please provide an element as an argument."
  else    
    # If the users selection is a positive integer set atomic_number based on atomic number
    if [[ $ELEMENT_PROVIDED =~ ^[0-9]+$ ]]
      then
      ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$ELEMENT_PROVIDED")
      
      # Else set atomic_number based on their symbol or their name
      elif  [[ $ELEMENT_PROVIDED =~ [A-Z]+ ]]
        then        
        ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$ELEMENT_PROVIDED' OR name='$ELEMENT_PROVIDED'")              
      fi

    if [[ -z $ATOMIC_NUMBER ]]
      then
      echo "I could not find that element in the database."
      else 

      # Gather symbol, name, mass, melting point and boiling point
      SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$ATOMIC_NUMBER")
      ELEMENT=$($PSQL "SELECT name FROM elements WHERE atomic_number=$ATOMIC_NUMBER")  
      MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
      MELT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
      BOIL=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
      TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
      TYPE=$($PSQL "SELECT type FROM types WHERE type_id=$TYPE_ID")
    
      echo "The element with atomic number $ATOMIC_NUMBER is $ELEMENT ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $ELEMENT has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
    fi
fi
