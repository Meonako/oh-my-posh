#! /usr/bin/nu
def main [--release (-r)] {
    let _ = (git pull)
    let _ = (git fetch upstream)
    let _ = (git checkout main)
    let _ = (git merge upstream/main)

    let og_pwd = (pwd)

    $env.GOARCH = "amd64"

    cd src

    go mod tidy

    $env.GOOS = "linux"
    print ("Building for linux..." | ansi gradient --fgstart "0x8aabfc" --fgend "0xffffff")

    build

    let linux_path = (which oh-my-posh | get path)
    let linux_output_path = if ($linux_path | is-empty) or $release {
        let path = $'($og_pwd)/outputs/linux'
        mkdir $path
        $'($path)/oh-my-posh'
    } else {
        ($linux_path | first)
    }

    print -n $"(ansi yellow)Linux binary saving to " ($linux_output_path | ansi gradient --fgstart "0xffffff" --fgend "0xeb14ff") "...\n"

    sudo mv src $linux_output_path

    $env.GOOS = "windows"
    print ("Building for windows..." | ansi gradient --fgstart "0x8aabfc" --fgend "0xffffff")

    build

    let windows_path = (`/mnt/c/Program Files/nu/bin/nu.exe` -c "which oh-my-posh | get path | is-empty")
    let windows_output_path = if ($windows_path == "true") or $release {
        let path = $'($og_pwd)/outputs/windows'
        mkdir $path
        $'($path)/oh-my-posh.exe'
    } else {
        $'/mnt/(`/mnt/c/Program Files/nu/bin/nu.exe` -c "which oh-my-posh | get path | first | str replace ":" "" | str replace -a '\\' '/' | str downcase")'
    }

    print -n $"(ansi yellow)Windows binary saving to " ($windows_output_path | ansi gradient --fgstart "0xffffff" --fgend "0xeb14ff") "...\n"

    sudo mv src.exe $windows_output_path
}

def build [] {
    go build -ldflags="-s -w -X 'github.com/jandedobbeleer/oh-my-posh/src/build.Version=19.11.4'"
}
