# Model Context Protocol (MCP) servers for AI knowledge management
# Integration with Claude and Gemini

{ config, pkgs, ... }:

{
  # MCP server packages
  home.packages = with pkgs; [
    nodejs  # Required for MCP servers
    # Add MCP-related tools here when available in nixpkgs
  ];

  # Create MCP configuration directory
  home.file.".config/mcp/servers.json".text = builtins.toJSON {
    mcpServers = {
      # Filesystem server for accessing dotfiles
      filesystem = {
        command = "npx";
        args = [ "-y" "@modelcontextprotocol/server-filesystem" "/home/dev" ];
      };

      # Git server for repository operations
      git = {
        command = "npx";
        args = [ "-y" "@modelcontextprotocol/server-git" ];
      };

      # SQLite server for org-roam database
      sqlite = {
        command = "npx";
        args = [ "-y" "@modelcontextprotocol/server-sqlite" ];
      };

      # GitHub server (requires authentication)
      github = {
        command = "npx";
        args = [ "-y" "@modelcontextprotocol/server-github" ];
        env = {
          GITHUB_PERSONAL_ACCESS_TOKEN = "\${GITHUB_TOKEN}";
        };
      };

      # Memory server for persistent AI context
      memory = {
        command = "npx";
        args = [ "-y" "@modelcontextprotocol/server-memory" ];
      };
    };
  };

  # Claude Code configuration with MCP
  home.file.".claude/config.json".text = builtins.toJSON {
    mcpServers = {
      filesystem = {
        command = "npx";
        args = [ "-y" "@modelcontextprotocol/server-filesystem" "/home/dev/dotfiles" "/home/dev/org" ];
      };

      git = {
        command = "npx";
        args = [ "-y" "@modelcontextprotocol/server-git" ];
      };

      memory = {
        command = "npx";
        args = [ "-y" "@modelcontextprotocol/server-memory" ];
      };
    };

    # AI model preferences
    preferredModels = {
      default = "claude-sonnet-4-5";
      coding = "claude-sonnet-4-5";
      chat = "claude-sonnet-4-5";
    };

    # Enable experimental features
    experimental = {
      mcpServers = true;
      memoryFeatures = true;
    };
  };

  # Helper aliases for AI tools
  programs.zsh.shellAliases = {
    # Claude CLI shortcuts
    claude = "claude-code";
    cc = "claude-code";

    # Gemini CLI (when installed)
    gm = "gemini";

    # Start Claude with specific context
    claude-docs = "cd ~/dotfiles/docs && claude-code";
    claude-org = "cd ~/org && claude-code";

    # AI-assisted commands
    ai-commit = "git add -A && claude-code --prompt 'Generate a concise git commit message for these changes'";
    ai-explain = "claude-code --prompt 'Explain this code:'";
    ai-refactor = "claude-code --prompt 'Suggest refactorings for this code:'";
  };

  # Integration scripts
  home.file.".local/bin/ai-learn" = {
    text = ''
      #!/usr/bin/env bash
      # AI-assisted learning script
      # Usage: ai-learn <topic>

      TOPIC="$1"

      if [ -z "$TOPIC" ]; then
        echo "Usage: ai-learn <topic>"
        exit 1
      fi

      # Create learning note in org-mode
      NOTE_FILE="$HOME/org/learning-$TOPIC-$(date +%Y%m%d).org"

      cat > "$NOTE_FILE" << EOF
      #+TITLE: Learning: $TOPIC
      #+DATE: $(date +%Y-%m-%d)
      #+STARTUP: overview

      * Overview

      Ask Claude or Gemini about $TOPIC

      * Key Concepts

      * Practice Examples

      * Resources

      * Questions

      EOF

      echo "Created learning note: $NOTE_FILE"
      emacsclient -c "$NOTE_FILE"
    '';
    executable = true;
  };

  home.file.".local/bin/ai-note" = {
    text = ''
      #!/usr/bin/env bash
      # Quick AI-assisted note taking
      # Usage: ai-note "your note content"

      NOTE="$*"

      if [ -z "$NOTE" ]; then
        echo "Usage: ai-note <note content>"
        exit 1
      fi

      # Add to daily note with AI enhancement
      TODAY=$(date +%Y-%m-%d)
      DAILY_NOTE="$HOME/org/daily-$TODAY.org"

      if [ ! -f "$DAILY_NOTE" ]; then
        cat > "$DAILY_NOTE" << EOF
      #+TITLE: Daily Note - $TODAY
      #+DATE: $TODAY

      * Notes

      EOF
      fi

      echo "** $(date +%H:%M) - $NOTE" >> "$DAILY_NOTE"
      echo "Note added to $DAILY_NOTE"
    '';
    executable = true;
  };
}
