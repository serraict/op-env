# op-env

A shell script to manage environment variables using 1Password.

## Features

- Reads variable names from `.env.example`
- Only manages variables that exist in 1Password
- Uses `source` to properly modify shell environment
- Never exposes sensitive values in output
- Supports configuration via environment variables or command line arguments

## Requirements

- 1Password CLI (op) version 2.30 or higher
- A `.env.example` file in your project listing the environment variables
- Bash shell

## Installation

Using Homebrew:

```bash
brew tap serraict/op-env https://github.com/serraict/op-env
brew install op-env
```

## Upgrading

To upgrade to the latest version:

```bash
brew update
brew upgrade op-env
```

## Usage

The script must be sourced (not executed) to modify environment variables. You can configure it using environment variables or command line arguments:

### Using Environment Variables

```bash
# Set configuration
export OP_VAULT="Your Vault"
export OP_ITEM="Your Item"

# Load variables from 1Password
source op-env load

# Unset variables that exist in 1Password
source op-env unset
```

### Using Command Line Arguments

```bash
# Load variables from 1Password
source op-env load "Your Vault" "Your Item"

# Unset variables that exist in 1Password
source op-env unset "Your Vault" "Your Item"
```

### Example

Given a `.env.example` file:
```
API_KEY=your_api_key
CLIENT_ID=your_client_id
DEBUG=true
BASE_URL=http://localhost:3000
```

And a 1Password item containing `API_KEY` and `CLIENT_ID`, running:
```bash
# Using environment variables
export OP_VAULT="My Vault"
export OP_ITEM="Project Secrets"
source op-env load

# Or using command line arguments
source op-env load "My Vault" "Project Secrets"
```

Will:
- Set `API_KEY` and `CLIENT_ID` from 1Password
- Ignore `DEBUG` and `BASE_URL` (not in 1Password)
- Show which variables were set/ignored

## Testing

Run the test script to verify functionality:
```bash
./test/test.sh "Your Vault" "Your Item"
