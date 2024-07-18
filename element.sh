#!/bin/bash
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  PSQL="psql -X --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"
  #If argument is a number
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1")
  else
  #argument is not number
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1' OR name='$1'")
  fi
  if [[ -z $ATOMIC_NUMBER ]]
  then
    #element not found
    echo "I could not find that element in the database."
  else
    #element found
    QUERY=$($PSQL "SELECT elements.atomic_number,elements.name,elements.symbol,types.type,properties.atomic_mass,properties.melting_point_celsius,boiling_point_celsius FROM elements LEFT JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE elements.atomic_number=$ATOMIC_NUMBER")
    echo "$QUERY" | while IFS='|' read ANUMBER NAME SYMBOL TYPE AMASS MELTING BOILING
    do
      echo "The element with atomic number $ANUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $AMASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius." 
    done
  fi
fi
