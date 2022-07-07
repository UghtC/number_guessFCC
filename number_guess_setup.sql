-- psql --username=freecodecamp --dbname=postgres

-- number_guess

CREATE DATABASE number_guess;
\c number_guess


DROP TABLE IF EXISTS players, games CASCADE;


CREATE TABLE players
   (
        player_id           SERIAL NOT NULL PRIMARY KEY
      , player_name         VARCHAR UNIQUE
   )
;

CREATE TABLE games
  (
        game_id           SERIAL NOT NULL PRIMARY KEY
      , player_id         INT
      , guess_count       INT
      , FOREIGN KEY (player_id) REFERENCES players (player_id)
  )
;

INSERT INTO players(player_name) VALUES ('bob') RETURNING *;
INSERT INTO games(player_id, guess_count) VALUES (1, 2) RETURNING *;


SELECT * FROM players;
SELECT * FROM games;