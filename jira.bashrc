# Usage:
# export JIRA_USERNAME
# export JIRA_PASSWORD

# Constants
JIRA_BASE_URL='https://immediateco.atlassian.net'
JIRA_BOARD_ID=485

jira_map_status() {
    case "$1" in
    "10013")
        echo "${GRAY}●${NC}"
    ;;
    "10154")
        echo "${CYAN}→${NC}"
    ;;
    "10159")
        echo "${YELLOW}R${NC}"
    ;;
    "10166")
        echo "${LIGHT_CYAN}P${NC}"
    ;;
    "10004")
        echo "${LIGHT_PURPLE}T${NC}"
    ;;
    "10157")
        echo "${PURPLE}T${NC}"
    ;;
    "10448")
        echo "${RED}✘${NC}"
    ;;
    "10167")
        echo "${GREEN}✔${NC}"
    ;;
    esac
}

jira_request() {
    local h="Content-Type: application/json"
    echo $(curl -u "$JIRA_USERNAME":"$JIRA_PASSWORD" -X GET -H "$h" $1 -s)
}

jira_sprint() {
    local url="${JIRA_BASE_URL}/rest/agile/1.0/board/${JIRA_BOARD_ID}/issue"
    local params='fields=key,status,summary,assignee&maxResults=200'
    local json=$(jira_request "$url?$params")
    local fmt="[.fields.status.id, .key, .fields.summary, .fields.assignee.displayName]"
    echo "$json" | jq -r ".issues[] | $fmt | @tsv" |
        while IFS=$'\t' read -r status key summary assignee; do
            local sicon=$(jira_map_status "$status")
            if [ -n "$sicon" ]; then
                printf "$sicon "
                printf "["
                printf "${CYAN}%-9s${NC}" "$key"
                printf "] "
                printf "$summary" | perl -p -e 's/(.{80})(.{1,})$/\1.../'
                printf "\n"
            fi
        done
}
