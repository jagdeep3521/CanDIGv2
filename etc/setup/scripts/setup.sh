#! /usr/bin/env bash
set -e

# checks for dev or prod
if [ $MODE == "" ]
  then
    echo "Please check the MODE in your environment varibles!"
    exit 1
fi


# -- Prerequisites --
echo
echo "- Generating prerequisites; -"

mkdir -p ${PWD}/lib/authz/tyk
mkdir -p ${PWD}/lib/authz/keycloak
mkdir -p ${PWD}/lib/authz/vault

export KC_CLIENT_ID_64=$(echo -n ${KC_CLIENT_ID} | base64)
echo "Generated KC_CLIENT_ID_64 as ${KC_CLIENT_ID_64}"

echo "- Done with prereqs.. -"
# --

echo
echo "Setting up Keycloak;"
source ${PWD}/etc/setup/scripts/subtasks/keycloak_setup.sh 
#$1


echo
echo "Setting up Tyk;"
${PWD}/etc/setup/scripts/subtasks/tyk_setup.sh

echo
echo "Setting up Vault;"
source ${PWD}/etc/setup/scripts/subtasks/vault_setup.sh

echo
echo "Setting up OPAs;"
${PWD}/etc/setup/scripts/subtasks/opa_setup.sh

echo
echo "Setting up Arbiters;"
${PWD}/etc/setup/scripts/subtasks/arbiter_setup.sh


echo
echo "Moving temporary files to ./tmp/authz/*"
mkdir -p ./tmp/authz

cp -r ./lib/authz/keycloak/tmp ./tmp/authz/keycloak/
cp -r ./lib/authz/tyk/tmp ./tmp/authz/tyk/
cp -r ./lib/authz/vault/tmp ./tmp/authz/vault/

cp -r ./lib/candig-server/authz/tmp ./tmp/authz/candig-server

rm -rf ./lib/authz/*/tmp 
rm -rf ./lib/candig-server/authz/tmp 


echo
echo "-- AuthZ Setup Done! --"
echo
