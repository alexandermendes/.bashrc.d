# Usage:
# export JIRA_USERNAME
# export JIRA_PASSWORD

# Constants
JIRA_BASE_URL='https://immediateco.atlassian.net/rest/greenhopper/latest'
JIRA_BOARD_ID=485
JIRA_SPRINT=-1

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

jira_issues() {
    local url="${JIRA_BASE_URL}/rapid/charts/sprintreport"
    local params="rapidViewId=${JIRA_BOARD_ID}&sprintId=$1"
    local r=$(jira_request "$url?$params")
    local fmt='[.completedIssues, .issuesNotCompletedInCurrentSprint]'
    echo "$r" | jq -c ".contents | $fmt | flatten"
}

jira_set_sprint() {
    local url="${JIRA_BASE_URL}/sprintquery/${JIRA_BOARD_ID}"
    local r=$(jira_request "$url")
    local s=$(echo "$r" | jq -c '.sprints[] | select(.state | contains("ACTIVE"))')
    export JIRA_SPRINT="$s"
    local name=$(echo "$s" | jq -r '.name')
    if [ "$1" != '-q' ]; then
        printf "${GREEN}Tracking $name ${NC}\n"
    fi
}

jira_print_header() {
    local name=$(echo "$JIRA_SPRINT" | jq -r '.name')
    printf "\n$name\n"
    printf '%*s\n' "${#name}" '' | tr ' ' -
}

jira_sprint() {
    if [ "$JIRA_SPRINT" < 0 ]; then
        jira_set_sprint -q
    fi
    jira_print_header
    local id=$(echo "$JIRA_SPRINT" | jq -r '.id')
    local swidth=$(expr $(tput cols) - 17)
    local issues=$(jira_issues "$id")
    local fmt="[.statusId, .key, .summary, .assignee]"
    echo "$issues" | jq -r ".[] | $fmt | @tsv" |
        while IFS=$'\t' read -r status key summary assignee; do
            local sicon=$(jira_status_map "$status")
            printf "$sicon "
            printf "["
            printf "${CYAN}%-9s${NC}" "$key"
            printf "] "
            printf "$summary" | perl -p -e "s/(.{$swidth})(.{1,})$/\1.../"
            printf "\n"
        done
}
