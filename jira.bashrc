# Usage:
# export JIRA_USERNAME
# export JIRA_PASSWORD

# Constants
JIRA_BASE_URL='https://immediateco.atlassian.net/rest/greenhopper/latest'
JIRA_BOARD_ID=485
JIRA_SPRINT_ID=0
JIRA_SPRINT_EXPIRES=0

jira_status_map() {
    case "$1" in
    "10155")
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
    echo $(curl -u "$JIRA_USERNAME":"$JIRA_PASSWORD" GET -H "$h" $1 -s)
}

jira_sprint_report() {
    local url="${JIRA_BASE_URL}/rapid/charts/sprintreport"
    local params="rapidViewId=${JIRA_BOARD_ID}&sprintId=$1"
    echo $(jira_request "$url?$params")
}

jira_issues() {
    local r=$(jira_sprint_report "$1")
    local fmt='[.completedIssues, .issuesNotCompletedInCurrentSprint]'
    echo "$r" | jq -c ".contents | $fmt | flatten"
}

jira_set_sprint_id() {
    local url="${JIRA_BASE_URL}/sprintquery/${JIRA_BOARD_ID}"
    local r=$(jira_request "$url")
    local id=$(echo "$r" | jq -c '.sprints[] | select(.state | contains("ACTIVE")) | .id')
    export JIRA_SPRINT_ID="$id"
}

jira_set_sprint_expiry() {
    local report=$(jira_sprint_report "$JIRA_SPRINT_ID")
    local expires=$(echo "$report" | jq -c '.sprint.isoEndDate')
    export JIRA_SPRINT_EXPIRES="$expires"
}

jira_refresh_sprint() {
    local fmt='+%Y-%m-%dT%H:%M:%S'
    if [ "$JIRA_SPRINT_ID" != 0 && date "$fmt" <  ]; then
        return
    fi
    jira_set_sprint_id
    jira_set_sprint_expiry
}

jira_sprint() {
    jira_refresh_sprint
    local issues=$(jira_issues "$JIRA_SPRINT_ID")
    local fmt="[.statusId, .key, .summary, .assignee]"
    echo "$issues" | jq -r ".[] | $fmt | @tsv" |
        while IFS=$'\t' read -r status key summary assignee; do
            local sicon=$(jira_status_map "$status")
            printf "$sicon "
            printf "["
            printf "${CYAN}%-9s${NC}" "$key"
            printf "] "
            printf "$summary" | perl -p -e 's/(.{80})(.{1,})$/\1.../'
            printf "\n"
        done
}
