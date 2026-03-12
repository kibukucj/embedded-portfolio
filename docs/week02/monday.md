# Week 2 (Monday): Version Control and Collaborative Workflows

## Objective
> Master the fundamentals of Git and GitHub to transition from localized file management to a robust, cloud-backed version control system.

## Tools & Tech Stack Used
* **CLI Engine:** Git (Command Line Interface)
* **Remote Repository:** GitHub
* **Concepts:** Local staging, remote tracking, branching, and asynchronous collaboration (Pull Requests).

## System Architecture & Workflow
The Git architecture separates the development environment into distinct states. Moving code through these states ensures that only stable, intentional changes make it to the main project.

The workflow follows a specific lifecycle:
1. **Initialization & Configuration:** Setting up the repository and defining user credentials.
2. **The Local Cycle:** Modifying files in the Working Directory, staging them, and committing them to the Local Repository.
3. **Remote Synchronization:** Pushing local changes to GitHub, or fetching/pulling updates from collaborators.
4. **Parallel Development:** Using branches to isolate experimental firmware changes, which are later reviewed via Pull Requests (PRs) before merging into the `main` branch.

## Code Implementation (Core Commands)
Here is the operational command syntax used to execute the workflow.

### 1. Environment Setup
Before tracking code, Git requires identity configuration and a repository foundation.
```bash
# Set global identity for all commits
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Initialize a new local repository in the current directory
git init

# Alternatively, download an existing remote repository
git clone <url>

```

### 2. The Local Commit Cycle

This is the daily loop: saving snapshots of working code.

```bash
# Stage specific files (or use 'git add .' for all changed files)
git add <filename>

# Permanently record the staged changes with a descriptive message
git commit -m "Configure I2C sensor reading logic"

```

### 3. Remote Synchronization

Moving data between the local machine and the GitHub server.

```bash
# Upload local commits to the remote repository
git push

# Download remote history WITHOUT automatically merging it
git fetch

# Download remote history AND automatically merge it into the current branch
git pull

```

### 4. Branching & Collaboration

Branching allows for safe experimentation without breaking the main codebase.

```bash
# Switch to a different branch (or create one using -b)
git checkout <branchname>

```

> **Pull Requests (PRs) & Merging:** > When a feature branch is complete, it is pushed to GitHub. Instead of forcing it directly into `main`, a **Pull Request** is opened. This triggers a review process where collaborators can inspect the code, request changes, and test the firmware. Once approved, the PR is **merged**, integrating the new code safely into the production branch.

## Debugging & Challenges

* **Challenge:** Confusion between `git fetch` and `git pull`.
* **Resolution:** Understood that `fetch` is purely a safe read-only operation to check what teammates have uploaded, whereas `pull` is destructive and actively overwrites the local working directory with the remote data.
* **Challenge:** Merge conflicts when two people edit the same lines of code.
* **Resolution:** Learned to manually open the conflicted file, locate the Git injection markers (`<<<<<<< HEAD`), decide which code block to keep, and run a new `git commit` to resolve it.

## Final Result

The repository is now fully version-controlled. Moving forward, all embedded systems project files, schematics, and code will be tracked, allowing for safe rollbacks if a firmware update breaks the hardware logic.
