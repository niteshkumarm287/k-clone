# k-clone

`k-clone` is a command-line tool for cloning Kubernetes cronjobs or jobs. This is useful for running a one-off instance of a cronjob, or for creating a copy of a job to modify and run.

## Features

*   Clone a Kubernetes `cronjob` as a `job`.
*   Clone an existing `job` to create a new one.
*   Interactive selector to choose the resource to clone if not specified.
*   Ability to specify the namespace to operate in.
*   Ability to iterate over multiple namespaces with a given prefix.

## Prerequisites

*   `kubectl`: The Kubernetes command-line tool.
*   `zsh`: The Z-shell.
*   `jq`: A lightweight and flexible command-line JSON processor (only required for cloning jobs).

## Installation

If you are on macOS and use Homebrew, you can install `k-clone` from the `homebrew-k-clone` tap:

```bash
brew install niteshkumarm287/k-clone/k-clone
```

For other installation methods, please see the documentation in the `docs` directory.

## Usage

```
Usage: k-clone [options]

A script to clone Kubernetes cronjobs or jobs.

Options:
  -t, --type <type>      The type of resource to clone (cronjob or job). Defaults to cronjob.
  -n, --namespace <ns>   The namespace to operate in. Defaults to the current namespace.
  --name <name>          The name of the resource to clone. If not provided, an interactive selector will be shown.
  --namespace-prefix <p> A prefix to select multiple namespaces to iterate over.
  -h, --help             Display this help message.
```

### Examples

**Clone a cronjob interactively:**

```bash
k-clone -t cronjob -n my-namespace
```

This will show a list of cronjobs in the `my-namespace` namespace and prompt you to select one to clone.

**Clone a specific job by name:**

```bash
k-clone -t job -n my-namespace --name my-job
```

This will create a new job named `clone-of-my-job` in the `my-namespace` namespace.

**Iterate over multiple namespaces:**

```bash
k-clone --namespace-prefix my-app-
```

This will find all namespaces with the `my-app-` prefix and prompt you to select which ones to operate on.