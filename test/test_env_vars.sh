#!/usr/bin/env bash
# Test script for op-env environment variables functionality
#
# Usage:
#   ./test_env_vars.sh

set -e  # Exit on error

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OP_ENV="${SCRIPT_DIR}/../bin/op-env"
TEST_DIR=$(mktemp -d)
trap 'rm -rf "$TEST_DIR"' EXIT

# Create test environment
echo "Setting up test environment..."
cd "$TEST_DIR" || exit 1

cat > .env.example << EOL
FLORIDAY_CLIENT_ID=your_client_id
FLORIDAY_CLIENT_SECRET=your_client_secret
FLORIDAY_API_KEY=your_api_key
FLORIDAY_AUTH_URL=https://example.com
EOL

# Create test script
TEST_SCRIPT="$TEST_DIR/test_runner.sh"
cat > "$TEST_SCRIPT" << 'EOL'
#!/usr/bin/env bash
set -e

run_test() {
    local name="$1"
    local cmd="$2"
    local expected="$3"
    
    echo "=== Running test: $name ==="
    echo "Command: $cmd"
    echo "Expected: $expected"
    
    eval "$cmd" > output.txt 2>&1 || true
    cat output.txt
    
    if grep -q "$expected" output.txt; then
        echo "✓ $name passed"
        return 0
    else
        echo "✗ $name failed"
        echo "Expected output to contain: $expected"
        echo "Actual output:"
        cat output.txt
        return 1
    fi
}
EOL

# Add the specific test cases
cat >> "$TEST_SCRIPT" << EOL

# Test 1: Load with environment variables
run_test "Load with environment variables" "
    export OP_VAULT='Serra Vine'
    export OP_ITEM='Floriday Staging'
    . '$OP_ENV' load
" "Set FLORIDAY_CLIENT_ID"

# Test 2: Unset with environment variables
run_test "Unset with environment variables" "
    export OP_VAULT='Serra Vine'
    export OP_ITEM='Floriday Staging'
    . '$OP_ENV' unset
" "Unset FLORIDAY_CLIENT_ID"

# Test 3: Missing environment variables
run_test "Missing environment variables" "
    unset OP_VAULT OP_ITEM
    . '$OP_ENV' load
" "Error: No vault specified"

# Test 4: Environment variables override arguments
run_test "Environment variables override" "
    export OP_VAULT='Serra Vine'
    export OP_ITEM='Floriday Staging'
    . '$OP_ENV' load 'wrong_vault' 'wrong_item'
" "Set FLORIDAY_CLIENT_ID"
EOL

chmod +x "$TEST_SCRIPT"

echo "Running tests..."
bash "$TEST_SCRIPT"
