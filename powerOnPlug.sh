#!/bin/bash

     mv ~/.outlet_auth_output ~/.outlet_auth_output.save > /dev/null

     access_token=$(cat ~/.outlet_access_token)
     refresh_token=$(cat ~/.outlet_refresh_token)

     if [ -z "$access_token" ]; then
          return
     fi

     echo \
     echo Requesting an access token . . .

     curl -H "Accept: application/json" \
          -H "Connection: Keep-Alive" \
          -H "Authorization: auth_token $access_token" \
          -H "Content-Type: application/json" \
          -A "Dalvik/2.1.0 (Linux; U; Android 7.1.1; Nexus 5X Build/NMF26F)" \
          -H "Accept-Encoding: gzip" \
          -X POST \
          -s \
          -o ~/.outlet_auth_output \
          -d '{"user":{"refresh_token":"'"$refresh_token"'"}}' \
          https://ads-field.aylanetworks.com/users/refresh_token.json

     cat ~/.outlet_auth_output | jq -r '.access_token' > ~/.outlet_access_token
     cat ~/.outlet_auth_output | jq -r '.refresh_token' > ~/.outlet_refresh_token

     access_token=$(cat ~/.outlet_access_token)
     refresh_token=$(cat ~/.outlet_refresh_token)

     if [ -z "$access_token" ]; then
          echo Access Token is empty - cannot continue
          return
     fi

     echo Access token: $access_token
     echo \

     curl -H "Authorization: auth_token $access_token" \
          -H "Content-Type: application/json" \
          -X POST -d '{"datapoint":{"value":1}}' \
          -s \
          -o /dev/null \
          https://ads-field.aylanetworks.com/apiv1/properties/17574029/datapoints.json

     echo Power On Request Submitted
     echo \
