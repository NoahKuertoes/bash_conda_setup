# Setting up a current version of *Conda* through the shell

- **WHY:** Setting up the conda environment through shell can be used to circument problem's occuring with a manual instatllation. Especially special character's in usernames (e.g.: "ü", "ö", "ä", "é", "ê") can cause encoding problems when interpreted by `conda init`and `conda activate`. Although it is generally advisable to avoid these characters in usernames, this pipeline provides a suitable workaround in case you don't want to or can't change usernames.
- **OS:** Currently this pipeline is written for a *git bash* shell running in *Windows*
- **HOW:** t.b.d


---

**_WORKFLOW:_**

 1. After cloning the repo via `git clone https://github.com/NoahKuertoes/bash_conda_setup.git`, it is advisable to first run `source clean_path.sh`. This will check your path directory for non-existing directories in your path variable, which can occur from previous faulty installations
 2. 
