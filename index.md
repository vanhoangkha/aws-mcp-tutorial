---
layout: default
title: Home
---

# AWS MCP Servers Tutorial

<p align="center">
  <img src="https://img.shields.io/badge/AWS-MCP-orange.svg" alt="AWS MCP">
  <img src="https://img.shields.io/badge/Claude-Code-blue.svg" alt="Claude Code">
  <img src="https://img.shields.io/badge/License-MIT-yellow.svg" alt="License">
  <img src="https://img.shields.io/badge/docs-complete-brightgreen.svg" alt="Documentation">
</p>

> 🚀 **Comprehensive guide for AWS MCP Servers** - Installation, real-world examples, and best practices for integrating AWS services with Claude Code.

## What is AWS MCP?

Model Context Protocol (MCP) is an open protocol that enables seamless integration between LLM applications (like Claude Code) and external data sources. AWS MCP Servers provide specialized tools for working efficiently with AWS services.

### Key Benefits

- ✅ **Accurate AWS Operations** - Direct API access eliminates hallucinations
- ✅ **Latest Documentation** - Always up-to-date AWS APIs and services
- ✅ **Automated Workflows** - Transform common tasks into AI-powered tools
- ✅ **Deep Expertise** - Built-in AWS best practices and patterns

## Quick Start

Get started in 5 minutes:

```bash
# Install essential MCP servers
claude mcp add --transport stdio aws-api-mcp-server \
  -- uvx awslabs.aws-api-mcp-server@latest

claude mcp add --transport stdio aws-pricing-mcp-server \
  -- uvx awslabs.aws-pricing-mcp-server@latest

# Verify installation
claude mcp list
```

[**Full Quick Start Guide →**](./QUICKSTART)

## What's Included

### 📚 Comprehensive Documentation

- **[⚡ Quick Start](./QUICKSTART)** - 5-minute setup guide
- **[📖 Deep Dive Blog](./blog)** - 15-minute comprehensive walkthrough
- **[❓ FAQ](./FAQ)** - 40+ frequently asked questions
- **[📊 MCP Servers Comparison](./MCP-SERVERS-COMPARISON)** - Detailed decision guide

### 💻 Real-World Examples

All examples include actual AWS account outputs:

1. **[Account Setup](./examples/01-account-setup)** - Complete IAM configuration
2. **[Serverless Todo API](./examples/02-serverless-example)** - Lambda + DynamoDB + Cognito
3. **[Infrastructure Deployment](./examples/03-infrastructure-example)** - Full CDK stack
4. **[Real AWS Outputs](./examples/04-real-world-outputs)** - ⭐ Live data from production account
5. **[Use Cases](./examples/use-cases)** - 6 practical scenarios

### 🛠️ Available MCP Servers

We support **13 production-ready AWS MCP servers**:

| Category | Servers | Priority |
|----------|---------|----------|
| **Core** | aws-api-mcp-server | ⭐⭐⭐⭐⭐ Essential |
| **Infrastructure** | aws-cdk-mcp-server, aws-terraform-mcp-server | ⭐⭐⭐⭐ High |
| **Serverless** | aws-lambda-tool, aws-serverless | ⭐⭐⭐⭐ High |
| **Database** | aws-dynamodb, aws-s3-tables | ⭐⭐⭐⭐ High |
| **Cost** | aws-pricing, aws-cost-explorer | ⭐⭐⭐⭐⭐ Essential |
| **Monitoring** | aws-cloudwatch | ⭐⭐⭐ Medium |
| **Containers** | aws-eks | ⭐⭐⭐ Medium |
| **AI/ML** | aws-bedrock-kb-retrieval | ⭐⭐⭐ Medium |

[**View Full Comparison →**](./MCP-SERVERS-COMPARISON)

## Installation Methods

### Method 1: Automated (Recommended)

```bash
git clone https://github.com/vanhoangkha/aws-mcp-tutorial.git
cd aws-mcp-tutorial
./install.sh
```

### Method 2: Manual Selection

Choose only the servers you need:

```bash
# Essential
claude mcp add --transport stdio aws-api-mcp-server -- uvx awslabs.aws-api-mcp-server@latest

# For Serverless
claude mcp add --transport stdio aws-lambda-tool-mcp-server -- uvx awslabs.lambda-tool-mcp-server@latest
claude mcp add --transport stdio aws-dynamodb-mcp-server -- uvx awslabs.dynamodb-mcp-server@latest

# For Infrastructure
claude mcp add --transport stdio aws-cdk-mcp-server -- uvx awslabs.cdk-mcp-server@latest
```

[**Full Installation Guide →**](./blog#installation)

## Use Cases

### 1. Serverless Development

```
"Create a Lambda function to process S3 uploads and store metadata in DynamoDB"
```

### 2. Infrastructure as Code

```
"Deploy a VPC with public/private subnets across 2 AZs using CDK"
```

### 3. Cost Optimization

```
"Analyze my AWS costs this month and suggest optimizations"
```

### 4. Database Management

```
"Create a DynamoDB table for user management with email GSI"
```

### 5. Monitoring & Observability

```
"Set up CloudWatch alarms for Lambda errors and DynamoDB throttling"
```

### 6. Container Orchestration

```
"Create an EKS cluster with managed node group for production workload"
```

[**View All Use Cases →**](./examples/use-cases)

## System Requirements

- **uv** package manager (0.9.7+)
- **Python** 3.10 or higher
- **AWS CLI** configured with credentials
- **Claude Code** installed
- Active AWS account (Free Tier works!)

## Features

✨ **Real AWS Data** - Examples use actual AWS account outputs
🔒 **Security First** - IAM best practices and least privilege
💰 **Cost Aware** - Pricing info and cost optimization built-in
📊 **Production Ready** - Enterprise patterns and monitoring
🎯 **13 MCP Servers** - All tested and production-ready
📚 **40+ FAQ Entries** - Comprehensive troubleshooting
🚀 **Quick Start** - Get running in 5 minutes

## Getting Help

- 📖 [Full Documentation](./README)
- 🐛 [Report Issues](https://github.com/vanhoangkha/aws-mcp-tutorial/issues)
- 💬 [GitHub Discussions](https://github.com/vanhoangkha/aws-mcp-tutorial/discussions)
- 🔗 [AWS MCP Official Docs](https://awslabs.github.io/mcp/)
- 🤖 [Claude Code Docs](https://docs.claude.com/en/docs/claude-code)

## Contributing

We welcome contributions! See [CONTRIBUTING.md](./CONTRIBUTING) for guidelines.

## License

This tutorial is licensed under [MIT License](./LICENSE). AWS MCP Servers are maintained by AWS Labs.

---

<p align="center">
  <strong>Built with Claude Code</strong> 🚀
  <br>
  <em>Last updated: January 2025</em>
</p>

<p align="center">
  <a href="https://github.com/vanhoangkha/aws-mcp-tutorial">View on GitHub</a> •
  <a href="./QUICKSTART">Quick Start</a> •
  <a href="./blog">Blog</a> •
  <a href="./FAQ">FAQ</a> •
  <a href="./examples/">Examples</a>
</p>
