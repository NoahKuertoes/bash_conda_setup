# __Setting up a current version of *Anaconda* through the shell__

Disclaimer:

---

- **WHY:** Setting up the conda environment through shell can be used to circument problem's occuring with a manual instatllation. Especially special character's in usernames (e.g.: "ü", "ö", "ä", "é", "ê",...) can cause encoding problems when interpreted by `conda init`and `conda activate`. Although it is generally advisable to avoid these characters in usernames, this pipeline provides a suitable workaround in case you don't want to or can't change usernames.
- **OS:** Currently this pipeline is written for a *git bash* shell running in *Windows*
- **HOW:** t.b.d


---

## __WORKFLOW:__

 1. After cloning the repo via `git clone https://github.com/NoahKuertoes/bash_conda_setup.git`, it is advisable to first run `source clean_path.sh`. This will check your path directory for non-existing directories in your path variable, which can occur from previous faulty installations. If no missing directories are detected nothing will happen:

```
PATH not updated
All directories present.
```

---
 
 2. The installer will be fetched from `"https://repo.anaconda.com/archive/"`. Depending on the operating system (OS) the topmost `.sh`, `.pkg` or `.exe` will be fetched. The installation can   be performed in the current user directory or the base directory
```
Where would you like to install Anaconda?
1. Install for the current user (default)
2. Install to base directory (requires admin privileges)
3. Cancel installation
Enter your choice (1, 2, or 3):
```

 `install_anaconda.sh` will do the following:

- Check operating system
- Ask for install `[current user | base directory]`
 - *Windows:* will call `check_ascii.sh` to check for **ASCII** conformity of the username.
 - If the username is not ASCII-conform will call `get_shortname.ps1` to retrieve the associated **Short Username** through the *Windows api*
 - If that is the case end the installation with the statement:
  ```
   ATTENTION!       </c/Users/<username>> contains non-ASCII conform characters:
                    conda init in will likely fail to initiate <profile.ps1> correctly
   ADVICE           run <conda_init_custom.sh>
  ```
- Fetch and - if necessary - download the proper installer
- Install Anaconda:
  - *Windows:* `powershell.exe -Command "& {Start-Process -FilePath './$INSTALLER' -ArgumentList '/S', '/InstallationType=$INSTMODE', '/RegisterPython=0', '/AddToPath=0', '/D=$INSTDIR' -NoNewWindow -Wait}"`
  - *Mac:* `sudo installer -pkg "$INSTALLER" -target /`
- Modify `PATH` variable:
  - *Windows:* `powershell.exe -Command "[System.Environment]::SetEnvironmentVariable('PATH', [System.Environment]::GetEnvironmentVariable('PATH', 'User') + ';$INSTDIR\\Scripts;$INSTDIR\\', 'User')"`
  - *Linux/Mac:* `echo "export PATH=\"$INSTDIR/bin:\$PATH\"" >> ~/.bashrc`
- Remove installer file

---

3. The Custom conda initiation

Files to edit:
- bashrc
- profile.ps1
- condahook.ps1
- conda.sh

---

_Bug reports:_

|Date|Problem|Fix|
|---|---|---|
| 20240927 | `install_anaconda.sh` fails to create the *$HOME/Anaconda* directory but defaults to lowercase | changing hardcode to lowercase *anaconda* |
| 20240930 | in `install_anaconda.sh` $PATH export via `powershell.exe` adds *$HOME/Anaconda* to the $PATH | no fix yet but calling works | 

---

_Related forum posts_:

- [Conda environment activation not working in PowerShell #8428](https://github.com/conda/conda/issues/8428)
- [Why are conda and mamba not fully activating my environment on Cheaha?](https://ask.cyberinfrastructure.org/t/why-are-conda-and-mamba-not-fully-activating-my-environment-on-cheaha/2649)



