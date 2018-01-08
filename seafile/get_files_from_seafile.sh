#!/bin/bash
############################################
#
# MILO @ 2018
#
# Seafile Get File Names
#
#
############################################

function print_help() {
    echo "Seafile Get File Names";
    echo "MILO @ 2018"
    echo
    echo "Usage: $0 -o DATE -n NUMBER -s SERVER -r REPO [-d DIR] -u NAME -p PASS"
    echo "OR"
    echo "Usage: $0 -o DATE -n NUMBER -s SERVER -r REPO [-d DIR] -t TOKEN"
    echo "Parameters:"
    echo "  -o date    return files older than date. Must be something Unix"
    echo "             date understands, like \"2018-01-05T14:26\""
    echo "  -n number  return files except n newest ones"
    echo "  -s path    seafile server address"
    echo "  -r name    seafile repository id"
    echo "  -d path    library subdirectory for upload (default: /)"
    echo "  -t token   seafile auth token (use token or user/password pair)"
    echo "  -u name    seafile user (use token or user/password pair)"
    echo "  -p pass    user password (use token or user/password pair)"
    echo
}

# check if tools and paths are valid
# will stop on first error
function sanity_check() {

  if [ -z "$(type -t curl)" ]; then
    echo "Cannot run curl. Check if it's installed."
    ERROR=1; return
  fi

  if [ -z "$(type -t basename)" ]; then
    echo "Cannot run basename. Check if it's installed."
    ERROR=2; return
  fi

  if [ -z "$(type -t jq)" ]; then
    echo "Cannot run jq. Check if it's installed."
    ERROR=2; return
  fi

  if [ -z $DOMAIN ]; then
    echo "Server address not set (-d)"
    ERROR=4; return
  fi

  if [ -z $REPO_ID ]; then
    echo "Repository id not set (-r)"
    ERROR=5; return
  fi

  if [ -z $TOKEN ]; then
    if [ -z $USER ]; then
      echo "Use Token (-t) or User (-u) and Password (-p) pair"
      ERROR=6; return
    fi

    if [ -z $PASSWORD ]; then
      echo "Use Token (-t) or User (-u) and Password (-p) pair"
      ERROR=7; return
    fi
    echo "Token not set. Will try to get it automatically"
  fi
}

function get_token() {
  echo "obtaining token"
  TOKEN=$(curl -d "username=$USER&password=$PASSWORD" $DOMAIN/api2/auth-token/)
  #check if token keyword is in answer
  echo $TOKEN | grep token
  if [ $? -ne 0 ]; then
    echo "Could not get token. Server answer: $TOKEN"
    return
  fi
  #extract same token from answer - we now exactly where it is
  TOKEN=${TOKEN:11:$(expr ${#TOKEN} - 13)}
}

function get_files() {
  JSON=$(curl -s -H "Authorization: Token $TOKEN" -H 'Accept: application/json; indent=4' $DOMAIN/api2/repos/$REPO_ID/dir/?p=/$DIRECTORY)
  # Array of files in DIRECTORY
  FILES=($(echo $JSON | jq -r '.[].name'))
  # Array of timestapms of FILES
  TIMESTAMPS=($(echo $JSON | jq -r '.[].mtime'))
}

function parse_results() {
  # Number of packages to leave has been defined
  if [ ! -z $NUMBERTOLEAVE ]; then
    echo "-n option is not implemented! Aborting"
    exit 123
  fi

  # Older than has been defined
  if [ ! -z $OLDERTHAN ]; then
    DEADLINE=$(date +%s --date="$OLDERTHAN")
    INDEX=0
    for MDATE in "${TIMESTAMPS[@]}"; do
      #echo "Lessie: "$MDATE", and "$DEADLINE", while older than is: "$OLDERTHAN
      if (( $MDATE < $DEADLINE )); then
        if [ ! -z $RESULT ]; then
          RESULT+=":"
        fi
        RESULT+=${FILES[$INDEX]}
        #echo "Temp result: "$RESULT
      fi
      INDEX=$(($INDEX + 1))
    done
  fi
}

#main
ERROR=0
while getopts ":hno:s:r:d:t:u:p:" opt ;
do
    case $opt in
        h) print_help;
            exit 0;
            ;;
        n) NUMBERTOLEAVE=$OPTARG
            ;;
        o) OLDERTHAN=$OPTARG
            ;;
        s) DOMAIN=$OPTARG
            ;;
        r) REPO_ID=$OPTARG
            ;;
        d) DIRECTORY=$OPTARG
            ;;
	t) TOKEN=$OPTARG
	    ;;
        u) USER=$OPTARG
            ;;
        p) PASSWORD=$OPTARG
            ;;
        *) echo "Wrong parameter";
           echo "For help run $0 -h";
           exit 1
            ;;
    esac
done

sanity_check
if [ $ERROR != 0 ]; then
  exit $ERROR
fi

if [ -z $TOKEN ]; then
  get_token
  if [ -z $TOKEN ]; then
    exit 10
  fi
fi
get_files
parse_results
echo $RESULT
