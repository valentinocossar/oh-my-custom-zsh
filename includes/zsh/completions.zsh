# Auto completion for works (go to workspace projects)
_works() {
  local workspace_path="$HOME/Workspace"
  local dirs
  dirs=(`ls -d "$workspace_path"/*/ | tr -d ' ' | xargs basename | tr '\n' ' '`)
  compadd -X "Select a workspace project:" $dirs
}
compdef _works works
