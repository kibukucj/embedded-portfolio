# Week 1: Portfolio Setup and Automated Deployment

## 🎯 Objective
Establish a systematic, mobile-responsive portfolio to document my weekly Embedded Systems builds. The goal was to build a friction-free workflow where logging my progress is as simple as writing a Markdown file and pushing code, eliminating the need for manual web design.

## 🛠️ Tools & Tech Stack Used
* **Framework:** MkDocs with the `mkdocs-material` theme.
* **Environment:** Python virtual environment (`venv`).
* **Version Control:** Git.
* **CI/CD & Hosting:** GitHub Actions and GitHub Pages.

## 📐 System Architecture & Workflow
Instead of physical wiring, this week involved wiring up a deployment pipeline. The architecture relies on a Static Site Generator (SSG) model:

1. **Local Authoring:** Write weekly updates in standard `.md` files.
2. **Version Control:** Run `git push` to send the new logs to the `main` branch.
3. **Automated Build:** A GitHub Action detects the push, spins up an Ubuntu runner, installs Python and MkDocs, and compiles the Markdown into a static HTML/CSS website.
4. **Deployment:** The Action pushes the compiled site to a hidden `gh-pages` branch, which GitHub Pages then serves to the live URL.

## 💻 Code Implementation
Two core configuration files drive this setup.

**1. Site Configuration (`mkdocs.yml`)**
This dictates the site's structure, theme, and features, including syntax highlighting for future C/MicroPython code:

```yaml
site_name: Embedded Systems Portfolio
site_description: Weekly hardware builds, code, and logs.

theme:
  name: material
  palette:
    scheme: slate
    primary: teal
    accent: cyan
  features:
    - navigation.tabs
    - content.code.copy
    - content.code.annotate

markdown_extensions:
  - pymdownx.highlight:
      anchor_linenums: true
  - pymdownx.superfences