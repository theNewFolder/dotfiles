# Starship prompt - Beautiful, fast shell prompt

{ config, pkgs, colorScheme, ... }:

{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      # Format
      format = "$all$directory$character";

      # Add a newline before the prompt
      add_newline = true;

      # Character
      character = {
        success_symbol = "[➜](bold ${colorScheme.bright_green})";
        error_symbol = "[➜](bold ${colorScheme.bright_red})";
        vimcmd_symbol = "[❮](bold ${colorScheme.bright_yellow})";
      };

      # Directory
      directory = {
        truncation_length = 3;
        truncate_to_repo = true;
        format = "[$path]($style)[$read_only]($read_only_style) ";
        style = "bold ${colorScheme.bright_blue}";
        read_only = " 󰌾";
        read_only_style = "${colorScheme.bright_red}";
        truncation_symbol = "…/";

        substitutions = {
          "Documents" = "󰈙 ";
          "Downloads" = " ";
          "Music" = " ";
          "Pictures" = " ";
          "Videos" = " ";
          "Projects" = " ";
          "dotfiles" = " ";
        };
      };

      # Git
      git_branch = {
        symbol = " ";
        format = "[$symbol$branch(:$remote_branch)]($style) ";
        style = "${colorScheme.bright_purple}";
      };

      git_status = {
        format = "([$all_status$ahead_behind]($style)) ";
        style = "${colorScheme.bright_red}";
        conflicted = "🏳 ";
        ahead = "⇡\${count}";
        behind = "⇣\${count}";
        diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
        up_to_date = "";
        untracked = "🤷 ";
        stashed = "📦 ";
        modified = "📝 ";
        staged = "[++($count)](${colorScheme.bright_green})";
        renamed = "👅 ";
        deleted = "🗑 ";
      };

      # Programming languages
      nix_shell = {
        symbol = " ";
        format = "[$symbol$state( \\($name\\))]($style) ";
        style = "${colorScheme.bright_blue}";
      };

      nodejs = {
        symbol = " ";
        format = "[$symbol($version)]($style) ";
        style = "${colorScheme.bright_green}";
      };

      python = {
        symbol = " ";
        format = "[$symbol$pyenv_prefix($version)(\\($virtualenv\\))]($style) ";
        style = "${colorScheme.bright_yellow}";
      };

      rust = {
        symbol = " ";
        format = "[$symbol($version)]($style) ";
        style = "${colorScheme.bright_orange}";
      };

      # Time
      time = {
        disabled = false;
        format = "[$time]($style) ";
        style = "${colorScheme.gray}";
        time_format = "%T";
      };

      # Command duration
      cmd_duration = {
        min_time = 500;
        format = "took [$duration]($style) ";
        style = "${colorScheme.bright_yellow}";
      };

      # Battery
      battery = {
        full_symbol = "🔋";
        charging_symbol = "⚡";
        discharging_symbol = "💀";
        display = [
          {
            threshold = 10;
            style = "bold ${colorScheme.bright_red}";
          }
          {
            threshold = 30;
            style = "bold ${colorScheme.yellow}";
          }
        ];
      };

      # Memory
      memory_usage = {
        disabled = false;
        threshold = 75;
        format = "[$symbol$ram_pct]($style) ";
        style = "${colorScheme.bright_aqua}";
        symbol = " ";
      };
    };
  };
}
