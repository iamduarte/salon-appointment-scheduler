#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ Barber Shop ~~~~~\n"

SALON_APP() {
  
  echo "Hello there! Please choose your service." 
  echo -e "\n1) Haircut\n2) Full Shave\n3) Beard Trim"
  read SERVICE_ID_SELECTED

if [[ ! $SERVICE_ID_SELECTED =~ ^[1-3]+$ ]]
    then
      echo -e "\n1) Haircut\n2) Full Shave\n3) Beard Trim"
    else
    echo -e "\nPlease enter your phone number:"
    read CUSTOMER_PHONE
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    
    if [[ -z $CUSTOMER_NAME ]]
        then
          echo -e "\nLooks like we don't know eachother, please enter you name:"
          read CUSTOMER_NAME
          INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
          GET_CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
          echo -e "\nNice too meet you $CUSTOMER_NAME, what time do you want to book?"
          read SERVICE_TIME
          MAKE_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($GET_CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
          GET_SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
          if [[ $MAKE_APPOINTMENT == "INSERT 0 1" ]]
            then
              echo -e "\nI have put you down for a $GET_SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
          fi
        else
          GET_CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
          echo -e "\nGood to see you again $CUSTOMER_NAME! What time do you want to book?"
          read SERVICE_TIME
          MAKE_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($GET_CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
          GET_SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
          if [[ $MAKE_APPOINTMENT == "INSERT 0 1" ]]
            then
              echo -e "\nI have put you down for a $GET_SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
          fi
    fi
fi
}


SALON_APP