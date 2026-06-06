@echo off
echo Initializing Git repository...
"C:\Program Files\Git\cmd\git.exe" init
"C:\Program Files\Git\cmd\git.exe" remote add origin https://github.com/1325ilya/Goida.git
"C:\Program Files\Git\cmd\git.exe" fetch origin

echo Setting branch to main...
"C:\Program Files\Git\cmd\git.exe" checkout -b main
"C:\Program Files\Git\cmd\git.exe" branch --set-upstream-to=origin/main main

echo Adding changes...
"C:\Program Files\Git\cmd\git.exe" add .

echo Committing changes...
"C:\Program Files\Git\cmd\git.exe" commit -m "feat: Implement Sosuzagram Local History UI and Core"

echo Pushing to GitHub...
"C:\Program Files\Git\cmd\git.exe" push origin main

echo Done! Now check the Actions tab on GitHub.
pause
