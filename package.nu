#! /usr/bin/nu

cd outputs/linux

print $'> (ansi white_dimmed)tar -czvf omp-x64-linux.tar.gz oh-my-posh(ansi reset)'
tar -czvf omp-x64-linux.tar.gz oh-my-posh

cd ../windows

print $'> (ansi white_dimmed)7z a -t7z ompomp-x64-windows.7z oh-my-posh.exe(ansi reset)'
7z a -t7z omp-x64-windows.7z oh-my-posh.exe

echo "Successfully packaged"
