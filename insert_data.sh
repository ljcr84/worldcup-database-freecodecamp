#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# What's inside $() gets evaluated in a separate shell instance.
# We TRUNCATE in order to clean the tables and not get duplicates if we re-run the script.

echo $($PSQL "TRUNCATE teams, games")

# Changing the internal environment variable IFS to a command allows us to overwrite the default
# Internal Field Separator (space, new line, tabs). The command 'read' populate the different variables.
# It returns a value of zero (which 'while' takes) when it reaches a new line, returns something else
# when reaches the EOF (which terminates the while loop). It reads a single line at a time.

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS 
do 

# Checks for the first line in the file (heading).

if [[ $YEAR != "year" ]]

then

# Query for the team_id for the given team's name.

  WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
# Checks if there were not a result, the variable is an empty string.
  if [[ -z $WINNER_ID ]]
    then
    INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) values('$WINNER')")
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    
  fi
  OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  if [[ -z $OPPONENT_ID ]]
  then
    INSERT_OPPONENT_RESULT=$($PSQL "INSERT INTO teams(name) values('$OPPONENT')")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  fi

  INSERT_DATA_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) values($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
fi
done