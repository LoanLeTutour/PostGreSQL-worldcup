#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNERGOALS OPPONENTGOALS
do
if [[ $WINNER != 'winner' ]]
then
#get winner_id
WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
#if not found
if [[ -z $WINNER_ID ]]
then
#insert winner
INSERT_WINNER=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
echo "$WINNER inserted in the database"
#get new winner_id
WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
fi
#get opponent_id
OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
#if not found
if [[ -z $OPPONENT_ID ]]
then
#insert opponent
INSERT_OPPONENT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
echo "$OPPONENT inserted in the databse"
#get new opponent_id
OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
fi
INSERT_GAME=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES($YEAR,'$ROUND','$WINNER_ID','$OPPONENT_ID',$WINNERGOALS,$OPPONENTGOALS)")
echo "game inserted"
fi
done