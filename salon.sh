#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c "

echo -e "\n~~~~~ The Nice Haircut Salon ~~~~~\n"

MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  echo "Welcome to My Salon, how can I help you?" 
  # get the services
  GET_AVAILABLE_SERVICES=$($PSQL "SELECT service_id,name FROM services")

  echo "$GET_AVAILABLE_SERVICES" | while read SERVICE_ID BAR SERVICE
    do
      echo "$SERVICE_ID) $SERVICE"
    done

  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in
    1) CUT ;;
    2) EXIT ;;
    3) EXIT ;;
    4) EXIT ;;
    5) EXIT ;;
    *) MAIN_MENU "I could not find that service. What would you like today?" ;;
  esac
}

CUT() {
  echo -e "Merci d'avoir choisi le service $SERVICE_ID_SELECTED"
  echo "you will have a nice cut"

  # get customer info
  echo "What's your phone number?"
  read CUSTOMER_PHONE

  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")

  # if customer doesn't exist
  if [[ -z $CUSTOMER_NAME ]]
  then
    # get new customer name
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME

    # insert new customer
    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')") 
  fi

  CUSTOMER_NAME_FORMATTED=$(echo $CUSTOMER_NAME | sed -E 's/^ *| *$//g')
  echo -e "\nWhat time would you like your cut, $CUSTOMER_NAME_FORMATTED?"
  read SERVICE_TIME

  echo -e "\n**$CUSTOMER_PHONE**\n"

  echo -e "\nI have put you down for a cut at $SERVICE_TIME, $CUSTOMER_NAME_FORMATTED."

  # insert new appointment
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id,time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')") 
}

EXIT() {
  echo -e "\nThank you for stopping in.\n"
}

MAIN_MENU