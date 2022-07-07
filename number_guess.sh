#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=number_guess -t -c"

# Number guessing game

SECRET_NUMBER=$(( RANDOM % 1000 + 1 ))


GUESS_LOOP(){

read GUESS_NO

((GUESSES++))

# not a number
if ! [[ "$GUESS_NO" =~ ^[0-9]+$ ]]
then
  echo "That is not an integer, guess again:"
  GUESS_LOOP

# gone low
elif [[ "$GUESS_NO" -gt "$SECRET_NUMBER" ]]
then
  echo "It's lower than that, guess again:"
  GUESS_LOOP

# gone high
elif [[ "$GUESS_NO" -lt "$SECRET_NUMBER" ]]
then
  echo "It's higher than that, guess again:"
  GUESS_LOOP

# got it
else
  echo "You guessed it in $GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!"

  # write game data
  PLAYER_ID=$($PSQL "SELECT player_id FROM players WHERE player_name = '$USER_NAME'")
  INSERT_GAME_SCORE=$($PSQL "INSERT INTO games(player_id, guess_count) VALUES($PLAYER_ID, $GUESSES)")

exit
fi

}


START_GAME() {

read -p "Enter your username: " USER_NAME

# check database for username
PLAYER_DATA=$($PSQL "SELECT player_id, player_name FROM players WHERE player_name = '$USER_NAME'")

# echo "$PLAYER_DATA" | read PLAYER_ID BAR PLAYER

  if [[ -z $PLAYER_DATA ]]
  then
    echo "Welcome, $USER_NAME! It looks like this is your first time here."

    INSERT_NEW_PLAYER=$($PSQL "INSERT INTO players(player_name) VALUES('$USER_NAME')")

    echo "Guess the secret number between 1 and 1000:"
    GUESS_LOOP
  else

  # SQL  get total games played and lowest score based on username
  echo $($PSQL "SELECT COUNT(game_id), MIN(guess_count) FROM games INNER JOIN players USING(player_id) WHERE player_name = '$USER_NAME'") | while read GAMES_PLAYED BAR BEST_GAME
  do
    echo "Welcome back, $USER_NAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
  done
    echo "Guess the secret number between 1 and 1000:"
    GUESS_LOOP
  fi


}


START_GAME
