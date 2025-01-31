# Script Repo

This repo contains scripts and tools I use in my workflow.

## Example usage

1. Clone your repo (or create it locally).
2. Add code to cmd/go-tool/main.go, plus a simple build.conf with LANGUAGE=go.
3. Add code to cmd/python-tool/main.py, plus LANGUAGE=python.
4. Run:

   ```bash
   cd scripts-repo
   ./build.sh
   ./deploy.sh
   ```

5. Check: the built binaries should appear in $HOME/Applications
6. Ensure $HOME/scripts is on your $PATH:

````bash
echo 'export PATH="$HOME/scripts:$PATH"' >> ~/.bashrc
source ~/.bashrc
7. ```
````
