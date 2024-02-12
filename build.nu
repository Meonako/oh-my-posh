#! /usr/bin/nu

let _ = (git pull)

let fetch_result = (git fetch upstream)

if ($fetch_result | is-empty) {
    let user_input = (input $"(ansi green)No update. Do you want to continue? [y/N] ")
    if ($user_input | is-empty) or not ($user_input | str contains -i "y") {
        exit 0
    }
} else {
    let _ = (git checkout main)
    let _ = (git merge upstream/main)
}

$env.GOARCH = "amd64"

cd src

$env.GOOS = "linux"
print ("Building for linux..." | ansi gradient --fgstart "0x8aabfc" --fgend "0xffffff")

go build

let linux_path = (which oh-my-posh | get path | first)
print -n $"(ansi yellow)Rewriting " ($linux_path | ansi gradient --fgstart "0xffffff" --fgend "0xeb14ff") "...\n"

sudo mv src $linux_path

$env.GOOS = "windows"
print ("Building for windows..." | ansi gradient --fgstart "0x8aabfc" --fgend "0xffffff")

go build

let windows_path = $'/mnt/(`/mnt/c/Program Files/nu/bin/nu.exe` -c "which oh-my-posh | get path | first | str replace ':' '' | str replace -a '\\' '/' | str downcase")'
print -n $"(ansi yellow)Rewriting " ($windows_path | ansi gradient --fgstart "0xffffff" --fgend "0xeb14ff") "...\n"

sudo mv src.exe $windows_path