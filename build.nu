#! /usr/bin/nu

let git_result = git pull

if ($git_result == "Already up to date.") {
    echo "No update. Terminated."
    exit 0
}

$env.GOARCH = "amd64"

cd src

$env.GOOS = "linux"

go build
sudo mv src (which oh-my-posh | get path | first)

$env.GOOS = "windows"

go build
sudo mv src.exe (`/mnt/c/Program Files/nu/bin/nu.exe` -c "which oh-my-posh | get path | first")