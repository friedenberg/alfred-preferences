#! /bin/bash
# shellcheck disable=SC2154
cd "$alfred_preferences" || exit
if ERROR=$(git -c 'url.https://github.com/.insteadOf=git@github.com:' pull 2>&1); then
	MESSAGE="Successfully pulled Alfred preferences."
else
	MESSAGE="Failed to pull Alfred preferences"
fi

json_escape () {
    printf '%s' "$1" | php -r 'echo json_encode(file_get_contents("php://stdin"));'
}

cat <<-EOM
{"alfredworkflow": {"variables": {"MESSAGE": $(json_escape "$MESSAGE"),
"ERROR": $(json_escape "$ERROR")}}}
EOM

