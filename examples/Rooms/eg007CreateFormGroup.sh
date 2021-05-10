#!/bin/bash
# https://developers.docusign.com/docs/rooms-api/how-to/create-form-group/
# How to create a form group
#
# Check that we're in a bash shell
if [[ $SHELL != *"bash"* ]]; then
    echo "PROBLEM: Run these scripts from within the bash shell."
fi

# Step 1: Obtain your OAuth token
# Note: Substitute these values with your own
ACCESS_TOKEN=$(cat config/ds_access_token.txt)

# Set up variables for full code example
# Note: Substitute these values with your own
API_ACCOUNT_ID=$(cat config/API_ACCOUNT_ID)

base_path="https://demo.rooms.docusign.com"

# Step 2 Start
declare -a Headers=('--header' "Authorization: Bearer ${ACCESS_TOKEN}"
    '--header' "Accept: application/json"
    '--header' "Content-Type: application/json")
# Step 2 End

# Create a temporary file to store the response
response=$(mktemp /tmp/response-rooms.XXXXXX)


# Create a temporary file to store the JSON body
request_data=$(mktemp /tmp/request-rooms-007.XXXXXX)

# Step 3 Start
printf \
    '
{
  "name": "Sample Room Form Group",
}' >$request_data
# Step 3 End


# Step 4 Start
Status=$(curl -w '%{http_code}' --request POST ${base_path}/restapi/v2/accounts/${API_ACCOUNT_ID}/form_groups \
    "${Headers[@]}" \
    --data-binary @${request_data} \
    --output ${response})
# Step 4 End

FORM_GROUP_ID=$(cat $response | grep formGroupId | sed 's/.*formGroupId\":"//' | sed 's/\".*//')

# Store FORM_GROUP_ID into the file ./config/FORM_GROUP_ID
echo $FORM_GROUP_ID >./config/FORM_GROUP_ID

if [[ "$Status" -gt "201" ]]; then
    echo ""
    echo "Error:"
    echo ""
    cat $response
    exit 1
fi

echo ""
echo "Response:"
cat $response
echo ""

# Remove the temporary files
rm "$request_data"
rm "$response"
