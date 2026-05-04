# k-clone

A command-line tool to clone Kubernetes cronjobs or jobs interactively.

## Installation

### Using Homebrew

```bash
brew install niteshkumarm287/k-clone/k-clone
```

Or tap first, then install:

```bash
brew tap niteshkumarm287/k-clone
brew install k-clone
```

### Manual Installation

```bash
curl -o k-clone https://raw.githubusercontent.com/niteshkumarm287/k-clone/main/k-clone.zsh
chmod +x k-clone
mv k-clone /usr/local/bin/
```

## Prerequisites

- `kubectl` - Kubernetes command-line tool
- `jq` - Command-line JSON processor (required for cloning jobs)

## Usage

```bash
k-clone [options]
```

### Options

- `-t, --type <type>` - The type of resource to clone (`cronjob` or `job`). Defaults to `cronjob`.
- `-n, --namespace <ns>` - The namespace to operate in. Defaults to the current namespace.
- `--name <name>` - The name of the resource to clone. If not provided, an interactive selector will be shown.
- `--namespace-prefix <p>` - A prefix to select multiple namespaces to iterate over.
- `-h, --help` - Display help message.

### Examples

Clone a cronjob interactively in the current namespace:
```bash
k-clone
```

Clone a specific cronjob:
```bash
k-clone --name my-cronjob -n production
```

Clone a job:
```bash
k-clone -t job --name my-job -n production
```

Clone across multiple namespaces with prefix:
```bash
k-clone --namespace-prefix staging
```

## How It Works

- **Cronjob cloning**: Creates a new job from an existing cronjob using `kubectl create job --from=cronjob`
- **Job cloning**: Fetches the job definition, removes immutable fields, and creates a new job with a `clone-of-` prefix

## License

MIT
