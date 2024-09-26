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
 2. The installer will be fetched from `"https://repo.anaconda.com/archive/"`. Depending on the operating system (OS) the topmost `.sh`, `.pkg` or `.exe` will be fetched. The installation can   be performed in the current user directory or the base directory
    ```
    Where would you like to install Anaconda?
    1. Install for the current user (default)
    2. Install to base directory (requires admin privileges)
    3. Cancel installation
    Enter your choice (1, 2, or 3):
    ```
 3. 
