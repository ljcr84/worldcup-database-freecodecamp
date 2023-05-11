#! /bin/bash

# the '--no-align' option forces an 'unaligned tableoutput mode'.
# the '--tuples-only' option indicates to print rows only.
PSQL="psql --username=freecodecamp --dbname=worldcup --no-align --tuples-only -c"


# Do not change code above this line. Use the PSQL variable above to query your database.

echo -e "\nTotal number of goals in all games from winning teams:"
echo "$($PSQL "SELECT SUM(winner_goals) FROM games")"

echo -e "\nTotal number of goals in all games from both teams combined:"
echo "$($PSQL "SELECT SUM(winner_goals) + SUM(opponent_goals) FROM games")"

echo -e "\nAverage number of goals in all games from the winning teams:"
echo "$($PSQL "SELECT AVG(winner_goals) FROM games")"

echo -e "\nAverage number of goals in all games from the winning teams rounded to two decimal places:"
echo "$($PSQL "SELECT ROUND(AVG(winner_goals),2) FROM games")"

# I've tried the following using SELECT (SUM(winner_goals) + SUM(opponent_goals)) / COUNT(*) FROM games
# but it give me a result of 2. I tried both term separatly and it was 90 / 32 which it would give the correct result.
# In the postgresql documentation it says: Division (for integral types, division truncates the result towards zero).
# In PostgreSQL, integral types are data types that can store whole numbers. They include smallint, integer, and bigint.
# These types are used to store numbers that do not have decimal points.
# You can use the CAST operator to convert an integer to a decimal. The syntax is as follows: CAST ( expression AS target_type )
echo -e "\nAverage number of goals in all games from both teams:"
#echo "$($PSQL "SELECT (AVG(winner_goals) + AVG(opponent_goals)) / 2 FROM games")"
echo "$($PSQL "SELECT CAST((SUM(winner_goals) + SUM(opponent_goals)) AS DECIMAL) / COUNT(*) FROM games")"

echo -e "\nMost goals scored in a single game by one team:"
echo "$($PSQL "SELECT MAX(winner_goals) FROM games")"

echo -e "\nNumber of games where the winning team scored more than two goals:"
echo "$($PSQL "SELECT COUNT(*) FROM games WHERE winner_goals > 2")"

echo -e "\nWinner of the 2018 tournament team name:"
echo "$($PSQL "SELECT name FROM games INNER JOIN teams ON games.winner_id=teams.team_id WHERE year=2018 AND round='Final'")"

echo -e "\nList of teams who played in the 2014 'Eighth-Final' round:"
# In the following I make the inner join of 'three' tables, the teams tabla is repeated two times, one for the winners and another time for the opponent.
# We need to make aliases in order to avoid abiougosness. But we ends up with two columns for the names of teams. Don't know how to combine them.
# echo "$($PSQL "SELECT * FROM games INNER JOIN teams AS t1 ON games.winner_id=t1.team_id INNER JOIN teams AS t2 ON games.opponent_id=t2.team_id WHERE year=2014 AND round='Eighth-Final'")"
#echo "$($PSQL "SELECT name FROM games INNER JOIN teams ON games.winner_id=teams.team_id WHERE year=2014 AND round='Eighth-Final'")"
#echo "$($PSQL "SELECT name FROM games INNER JOIN teams ON games.opponent_id=teams.team_id WHERE year=2014 AND round='Eighth-Final'")"
#echo "$($PSQL "SELECT t1.name, t2.name FROM games AS g1 INNER JOIN teams AS t1 ON g1.winner_id=t1.team_id, games AS g2 INNER JOIN teams AS t2 ON g2.opponent_id=t2.team_id WHERE g1.year=2014 AND g1.round='Eighth-Final' AND g2.year=2014 AND g2.round='Eighth-Final'")"
echo "$($PSQL "SELECT name FROM games INNER JOIN teams ON games.winner_id=teams.team_id WHERE year=2014 AND round='Eighth-Final'\
                UNION\
                SELECT name FROM games INNER JOIN teams ON games.opponent_id=teams.team_id WHERE year=2014 AND round='Eighth-Final'\
                ORDER BY name")"


echo -e "\nList of unique winning team names in the whole data set:"
echo "$($PSQL "SELECT DISTINCT name FROM games INNER JOIN teams ON games.winner_id=teams.team_id ORDER BY name")"

echo -e "\nYear and team name of all the champions:"
echo "$($PSQL "SELECT year, name FROM games INNER JOIN teams ON games.winner_id=teams.team_id WHERE round='Final' ORDER BY year")"

echo -e "\nList of teams that start with 'Co':"
echo "$($PSQL "SELECT name FROM teams WHERE name LIKE 'Co%'")"
