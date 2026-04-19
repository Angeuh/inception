#!/bin/bash

mkdir -p secrets

echo "test" > secrets/db_password.txt
echo "test" > secrets/db_root_password.txt
echo "test" > secrets/wp_admin_password.txt
echo "test" > secrets/wp_user_password.txt

echo "Secrets files created successfully."