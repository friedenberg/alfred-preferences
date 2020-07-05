#! /bin/bash
# shellcheck disable=SC2154
cd "$alfred_preferences" || exit
if ERROR=$(pip3 install --user -r "$(dirname "$0")/../requirements.txt" 2>&1); then
	MESSAGE="Successfully installed python modules."
else
	MESSAGE="Failed to install python modules."
fi

json_escape () {
    printf '%s' "$1" | php -r 'echo json_encode(file_get_contents("php://stdin"));'
}

cat <<-EOM
{"alfredworkflow": {"variables": {"MESSAGE": $(json_escape "$MESSAGE"),
"ERROR": $(json_escape "$ERROR")}}}
EOM

