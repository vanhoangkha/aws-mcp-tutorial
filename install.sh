#!/bin/bash

# AWS MCP Servers Installation Script
# This script automates the installation of AWS MCP servers for Claude Code

set -e  # Exit on error

echo "🚀 AWS MCP Servers Installation Script"
echo "========================================"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${YELLOW}ℹ${NC} $1"
}

# Check prerequisites
echo "Step 1: Checking prerequisites..."
echo "-----------------------------------"

# Check uv
if command -v uv &> /dev/null; then
    UV_VERSION=$(uv --version)
    print_success "uv is installed: $UV_VERSION"
else
    print_error "uv is not installed"
    print_info "Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    export PATH="$HOME/.local/bin:$PATH"
    print_success "uv installed successfully"
fi

# Check Python
if command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 --version)
    print_success "Python is installed: $PYTHON_VERSION"
else
    print_error "Python 3 is not installed"
    print_info "Installing Python 3.10..."
    uv python install 3.10
    print_success "Python 3.10 installed"
fi

# Check AWS CLI
if command -v aws &> /dev/null; then
    AWS_VERSION=$(aws --version)
    print_success "AWS CLI is installed: $AWS_VERSION"
else
    print_error "AWS CLI is not installed"
    print_info "Please install AWS CLI: https://aws.amazon.com/cli/"
    exit 1
fi

# Check AWS credentials
if aws sts get-caller-identity &> /dev/null; then
    print_success "AWS credentials are configured"
else
    print_error "AWS credentials are not configured"
    print_info "Run 'aws configure' to set up credentials"
    exit 1
fi

# Check Claude Code
if command -v claude &> /dev/null; then
    CLAUDE_VERSION=$(claude --version)
    print_success "Claude Code is installed: $CLAUDE_VERSION"
else
    print_error "Claude Code is not installed"
    print_info "Please install Claude Code first"
    exit 1
fi

echo ""
echo "Step 2: Installing AWS MCP Servers..."
echo "--------------------------------------"

# Array of MCP servers to install
declare -a servers=(
    "aws-api-mcp-server:awslabs.aws-api-mcp-server@latest"
    "aws-cdk-mcp-server:awslabs.cdk-mcp-server@latest"
    "aws-terraform-mcp-server:awslabs.terraform-mcp-server@latest"
    "aws-lambda-tool-mcp-server:awslabs.lambda-tool-mcp-server@latest"
    "aws-serverless-mcp-server:awslabs.aws-serverless-mcp-server@latest"
    "aws-dynamodb-mcp-server:awslabs.dynamodb-mcp-server@latest"
    "aws-s3-tables-mcp-server:awslabs.s3-tables-mcp-server@latest"
    "aws-bedrock-kb-retrieval-mcp-server:awslabs.bedrock-kb-retrieval-mcp-server@latest"
    "aws-pricing-mcp-server:awslabs.aws-pricing-mcp-server@latest"
    "aws-cloudwatch-mcp-server:awslabs.cloudwatch-mcp-server@latest"
    "aws-cost-explorer-mcp-server:awslabs.cost-explorer-mcp-server@latest"
    "aws-eks-mcp-server:awslabs.eks-mcp-server@latest"
)

# Install each server
for server_info in "${servers[@]}"; do
    IFS=':' read -r server_name server_package <<< "$server_info"

    print_info "Installing $server_name..."

    if claude mcp add --transport stdio "$server_name" -- uvx "$server_package" 2>&1; then
        print_success "$server_name installed"
    else
        print_error "Failed to install $server_name (may already exist or package unavailable)"
    fi
done

echo ""
echo "Step 3: Verifying installation..."
echo "----------------------------------"

# List all MCP servers
print_info "Checking MCP server health..."
claude mcp list

echo ""
echo "✅ Installation complete!"
echo "=========================="
echo ""
echo "Installed MCP servers:"
echo "  • aws-api-mcp-server (Core AWS API access)"
echo "  • aws-cdk-mcp-server (AWS CDK)"
echo "  • aws-terraform-mcp-server (Terraform)"
echo "  • aws-lambda-tool-mcp-server (Lambda)"
echo "  • aws-serverless-mcp-server (Serverless)"
echo "  • aws-dynamodb-mcp-server (DynamoDB)"
echo "  • aws-s3-tables-mcp-server (S3 Tables)"
echo "  • aws-bedrock-kb-retrieval-mcp-server (Bedrock KB)"
echo "  • aws-pricing-mcp-server (Pricing)"
echo "  • aws-cloudwatch-mcp-server (CloudWatch)"
echo "  • aws-cost-explorer-mcp-server (Cost Explorer)"
echo "  • aws-eks-mcp-server (EKS)"
echo ""
echo "Next steps:"
echo "  1. Try asking Claude: 'List my EC2 instances'"
echo "  2. Check the blog.md for detailed use cases"
echo "  3. Run 'claude mcp list' to see all servers"
echo ""
print_success "Happy building with AWS MCP! 🚀"
