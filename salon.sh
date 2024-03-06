#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

SERVICES=$($PSQL "SELECT * FROM services")

echo -e "\n\nWELCOME TO MY SALON\n"

MAIN_MENU ()
{
if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

echo "wich service would you like to hire?, we have 3 unique haircut names"
    


    echo "$SERVICES" | while read SERVICE_ID BAR NAME
    do
    echo  "$SERVICE_ID) $NAME"
    done

echo  -e "\nenter the number of the haircut"

read SERVICE_ID_SELECTED

SERVICE=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")

if [[ -z $SERVICE ]]
then
  MAIN_MENU "i couldn't find what you want"
else
  echo -e "\nEnter your number"

  read CUSTOMER_PHONE

  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")

  if [[ -z $CUSTOMER_NAME ]]
  then
    echo "Enter your NAME"
    read CUSTOMER_NAME
    INSERT_CUSTOMER_NAME=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
    echo -e "\n Your Name has been registered"
  fi

  echo -e "\nPleaste tell us at wich time would you like have the session"
  
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  read SERVICE_TIME

  INSERT_VALUES=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")

  SERVICE_FORMATTED=$(echo "$SERVICE" | sed -e 's/\(.*\)/\L\1/')

   echo -e "I have put you down for a $SERVICE_FORMATTED at $SERVICE_TIME, $(echo $CUSTOMER_NAME | sed -E 's/^ *| *$//g')."

fi

}

MAIN_MENU


