# Quick Start Guide

Get started with AWS MCP Servers in 5 minutes!

## Prerequisites Check

```bash
# 1. Check uv
uv --version
# If not installed: curl -LsSf https://astral.sh/uv/install.sh | sh

# 2. Check AWS CLI
aws --version
# If not installed: https://aws.amazon.com/cli/

# 3. Check Claude Code
claude --version
# If not installed: https://docs.claude.com/en/docs/claude-code

# 4. Verify AWS credentials
aws sts get-caller-identity
```

## Quick Installation

### Option 1: One-Click Install (Recommended)

```bash
# Clone repository
git clone https://github.com/vanhoangkha/aws-mcp-tutorial.git
cd aws-mcp-tutorial

# Run installation script
./install.sh
```

### Option 2: Manual Install

```bash
# Install essential MCP servers
claude mcp add --transport stdio aws-api-mcp-server \
  -- uvx awslabs.aws-api-mcp-server@latest

claude mcp add --transport stdio aws-pricing-mcp-server \
  -- uvx awslabs.aws-pricing-mcp-server@latest

# Verify
claude mcp list
```

## First Steps

### 1. Start Claude Code

```bash
claude
```

### 2. Try Your First Prompts

**List AWS Resources:**
```
Show me all my Lambda functions
```

**Check Costs:**
```
What's my AWS spending this month?
```

**Get Pricing:**
```
How much does EC2 t3.medium cost in us-east-1?
```

**Create Resources:**
```
Create a DynamoDB table named 'users' with userId as partition key
```

## What's Next?

### 📚 Read the Documentation

- **[README.md](./README.md)** - Overview and installation
- **[blog.md](./blog.md)** - 15-minute deep dive
- **[Examples](./examples/)** - Real-world tutorials

### 🎯 Try These Examples

1. **[Account Setup](./examples/01-account-setup.md)** - Configure AWS account
2. **[Serverless App](./examples/02-serverless-example.md)** - Build Todo API
3. **[Infrastructure](./examples/03-infrastructure-example.md)** - Deploy with CDK
4. **[Real Outputs](./examples/04-real-world-outputs.md)** - See actual AWS data

### 💡 Common Use Cases

**Cost Analysis:**
```
Analyze my AWS costs and suggest optimizations
```

**Infrastructure Deployment:**
```
Create a VPC with public and private subnets in 2 AZs
```

**Serverless Development:**
```
Create Lambda function to process S3 uploads
```

**Database Operations:**
```
Query my DynamoDB table and show the results
```

## Troubleshooting

### MCP Server Not Connecting

```bash
# Test manually
timeout 15s uvx awslabs.aws-api-mcp-server@latest

# Clear cache
uv cache clean

# Reinstall
claude mcp remove aws-api-mcp-server -s local
claude mcp add --transport stdio aws-api-mcp-server -- uvx awslabs.aws-api-mcp-server@latest
```

### AWS Credentials Error

```bash
# Check credentials
aws sts get-caller-identity

# Reconfigure
aws configure
```

### Permission Denied

```bash
# Check IAM permissions
aws iam get-user
aws iam list-attached-user-policies --user-name YOUR_USERNAME
```

## Need Help?

- 📖 [Full Documentation](./README.md)
- 🐛 [Report Issues](https://github.com/vanhoangkha/aws-mcp-tutorial/issues)
- 💬 [Discussions](https://github.com/vanhoangkha/aws-mcp-tutorial/discussions)
- 📚 [AWS MCP Docs](https://awslabs.github.io/mcp/)

## Quick Reference

```bash
# List MCP servers
claude mcp list

# View server details
claude mcp get aws-api-mcp-server

# Remove server
claude mcp remove SERVER_NAME -s local

# Update to latest version
uv cache clean
# Then reinstall
```

---

**Ready to build?** Start with `claude` and ask away! 🚀
