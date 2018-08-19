# Kill all processes on a port
killport() {
    if [ $# -eq 0 ]; then
        printf "${RED}Invalid port${NC}\n"
        return
    fi 

    pids=$(lsof -t -i:$1)
    len=$(trim $(lsof -t -i:8080 | wc -l))
    if [ "$len" != 0 ]; then
        kill -9 $(lsof -t -i:$1)
    fi
    noun=$([ "$len" == 1 ] && echo "process" || echo "processes")
    printf "${BLUE}Killed $len $noun on port $1${NC}\n"
}
