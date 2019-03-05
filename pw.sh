#!/bin/bash
echo Enter username:
read USERNAME

echo Enter firstname:
read FIRSTNAME

echo Enter lastname:
read LASTNAME

echo Enter password:
read -s PASSWORD

echo Generating hash
HASH=$(npx bcrypt-cli $PASSWORD 14)

echo Adding user to database
echo "INSERT INTO Account (username, firstName, lastName, password) VALUES ('$USERNAME', '$FIRSTNAME', '$LASTNAME', '$HASH')"

