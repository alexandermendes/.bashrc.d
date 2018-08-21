# Usage:
# export JIRA_USERNAME
# export JIRA_PASSWORD

# Constants
JIRA_BASE_URL='https://immediateco.atlassian.net'
JIRA_BOARD_ID=485

jira_request() {
    local h="Content-Type: application/json"
    echo $(curl -u "$JIRA_USERNAME":"$JIRA_PASSWORD" -X GET -H "$h" $1 -s)
}

jira_sprint() {
    local url="${JIRA_BASE_URL}/rest/agile/1.0/board/${JIRA_BOARD_ID}/issue"
    local params='fields=key,status,summary,assignee'
    local json=$(jira_request "$url?$params")
    local fmt="[.fields.status.id, .key, .fields.summary, .fields.assignee.displayName]"
    echo "$json" | jq -r ".issues[] | $fmt | @tsv" |
        while IFS=$'\t' read -r status key summary assignee; do
            printf "["
            printf "${GREEN}%-9s${NC}" "$key"
            printf "] "
            printf "$summary" | perl -p -e 's/(.{50})(.{1,})$/\1.../'
            printf "\n"
        done
}
