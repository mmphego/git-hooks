# Git-hooks

[![GitHub](https://img.shields.io/github/license/mmphego/medium-to-speech.svg)](LICENSE)

A simple shell script to support per-repository [Git hooks](https://git-scm.com/docs/githooks), checked into the actual repository that uses them.

To make this work, it creates hook templates that are installed into the `.git/hooks` folders automatically on `git init` and `git clone`. When one of them executes, it will try to find matching files in the `.git/hooks` directory under the project root, and invoke them one-by-one.

> Check out the [blog post](https://blog.mphomphego.co.za/blog/2019/02/28/How-I-increased-my-productivity-using-dotfiles.html) for the long read!

## Layout and options

Take this snippet of a project layout as an example:

```bash
├── hooks
│   ├── commit-msg
│   ├── pre-commit
│   └── prepare-commit-msg
├── LICENSE
├── pip-requirements.txt
├── README.md
├── setup_hooks.sh
└── templates
    └── git-commit-template.txt
```

## Supported hooks

The supported hooks are listed below. Refer to the [Git documentation](https://git-scm.com/docs/githooks) for information on what they do and what parameters they receive.

- `pre-commit`
- `prepare-commit-msg`
- `commit-msg`

## Installation

To install the template and git-hooks, run:
```shell
 sudo ./setup_hooks.sh install_hooks
```
The script will:

1. Find all directories under the `/home` which contain any `.git` directory
2. Install the hooks into them
3. Sets `init.templateDir` to point to `templates/git-commit-template.txt`

## Uninstalling

If you want to get rid of these hooks and templates, you can run:

```shell
 sudo ./setup_hooks.sh delete_hooks
```

This will delete the template files, optionally the installed hooks from the existing local repositories.
