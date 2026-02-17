# Git configuration

{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "dev";
        email = "dev@tuxnix.local";  # Update with your real email
      };

      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      credential.helper = "store";
      core.editor = "nvim";
      color.ui = "auto";

      alias = {
        st = "status";
        co = "checkout";
        br = "branch";
        ci = "commit";
        di = "diff";
        dc = "diff --cached";
        aa = "add --all";
        unstage = "reset HEAD --";
        last = "log -1 HEAD";
        lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
      };
    };

    ignores = [
      "*~"
      "*.swp"
      "*.swo"
      ".DS_Store"
      "Thumbs.db"
      ".env"
      ".direnv"
      "result"
      ".envrc"
    ];
  };
}
