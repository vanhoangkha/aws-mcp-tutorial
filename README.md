# AWS MCP Servers Tutorial

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![GitHub Stars](https://img.shields.io/github/stars/vanhoangkha/aws-mcp-tutorial?style=social)](https://github.com/vanhoangkha/aws-mcp-tutorial/stargazers)
[![GitHub Issues](https://img.shields.io/github/issues/vanhoangkha/aws-mcp-tutorial)](https://github.com/vanhoangkha/aws-mcp-tutorial/issues)
[![Documentation](https://img.shields.io/badge/docs-complete-brightgreen.svg)](https://vanhoangkha.github.io/aws-mcp-tutorial/)
[![AWS](https://img.shields.io/badge/AWS-MCP-orange.svg)](https://awslabs.github.io/mcp/)
[![Claude Code](https://img.shields.io/badge/Claude-Code-blue.svg)](https://claude.ai/code)

> **Comprehensive guide for AWS MCP Servers** - Installation, real-world examples, and best practices for integrating AWS services with Claude Code.

## Documentation Website

**[Visit the full documentation site →](https://vanhoangkha.github.io/aws-mcp-tutorial/)**

Hướng dẫn toàn diện về cài đặt và sử dụng AWS Model Context Protocol (MCP) Servers cho Claude Code với **real AWS data** và **working examples**.

## Quick Links

- **[Quick Start](./QUICKSTART.md)** - Get started in 5 minutes!
- **[FAQ](./FAQ.md)** - 40+ frequently asked questions
- **[MCP Servers Comparison](./MCP-SERVERS-COMPARISON.md)** - Detailed comparison & decision guide
- **[Blog](./blog.md)** - 15-minute deep dive
- **[Examples](./examples/)** - Real-world tutorials with actual AWS data

## Mục lục

- [Giới thiệu](#giới-thiệu)
- [Yêu cầu hệ thống](#yêu-cầu-hệ-thống)
- [Cài đặt](#cài-đặt)
- [Danh sách MCP Servers](#danh-sách-mcp-servers)
- [Hướng dẫn sử dụng](#hướng-dẫn-sử-dụng)
- [Best Practices](#best-practices)
- [Troubleshooting](#troubleshooting)

## Giới thiệu

Model Context Protocol (MCP) là một giao thức mở cho phép tích hợp liền mạch giữa các ứng dụng LLM và nguồn dữ liệu/công cụ bên ngoài. AWS MCP Servers cung cấp bộ công cụ chuyên biệt để làm việc hiệu quả hơn với các dịch vụ AWS.

### Lợi ích chính

- **Nâng cao chất lượng output**: Giảm hallucination và cung cấp thông tin kỹ thuật chính xác
- **Truy cập tài liệu mới nhất**: Cung cấp AWS APIs, SDKs và releases mới nhất
- **Tự động hóa workflow**: Chuyển đổi các quy trình phổ biến (CDK, Terraform, etc.) thành công cụ cho AI
- **Chuyên môn sâu**: Cung cấp kiến thức ngữ cảnh sâu về các dịch vụ AWS

## Yêu cầu hệ thống

### Prerequisites

1. **uv package manager**
   ```bash
   # Cài đặt uv
   curl -LsSf https://astral.sh/uv/install.sh | sh
   ```

2. **Python 3.10+**
   ```bash
   uv python install 3.10
   ```

3. **AWS Credentials**
   ```bash
   # Kiểm tra AWS credentials
   aws configure
   # hoặc
   cat ~/.aws/credentials
   ```

4. **Claude Code**
   ```bash
   # Kiểm tra Claude Code đã cài đặt
   claude --version
   ```

## Cài đặt

### Cài đặt nhanh

```bash
# Cài đặt AWS API MCP Server (Essential)
claude mcp add --transport stdio aws-api-mcp-server -- uvx awslabs.aws-api-mcp-server@latest

# Kiểm tra trạng thái
claude mcp list
```

### Cài đặt bộ đầy đủ

Xem [blog chi tiết](./blog.md) để biết cách cài đặt tất cả các MCP servers cần thiết.

### Tự động cài đặt

```bash
# Sử dụng installation script
./install.sh
```

## Danh sách MCP Servers

### Infrastructure as Code (3 servers)

| Server | Mô tả | Use Case |
|--------|-------|----------|
| **aws-cdk-mcp-server** | AWS CDK support | Tạo và deploy infrastructure bằng CDK |
| **aws-terraform-mcp-server** | Terraform automation | Quản lý infrastructure với Terraform |
| ~~aws-cloudformation-mcp-server~~ | CloudFormation support | *Hiện chưa khả dụng* |

### Serverless & Lambda (2 servers)

| Server | Mô tả | Use Case |
|--------|-------|----------|
| **aws-lambda-tool-mcp-server** | Lambda function management | Tạo, deploy và quản lý Lambda functions |
| **aws-serverless-mcp-server** | Serverless application deployment | Deploy serverless applications hoàn chỉnh |

### Database & Storage (2 servers)

| Server | Mô tả | Use Case |
|--------|-------|----------|
| **aws-dynamodb-mcp-server** | DynamoDB operations | CRUD operations, query và scan DynamoDB |
| **aws-s3-tables-mcp-server** | S3 Tables support | Làm việc với S3 Tables |

### AI/ML & Bedrock (1 server)

| Server | Mô tả | Use Case |
|--------|-------|----------|
| **aws-bedrock-kb-retrieval-mcp-server** | Bedrock Knowledge Base retrieval | Retrieve thông tin từ Bedrock Knowledge Bases |

### Cost & Monitoring (3 servers)

| Server | Mô tả | Use Case |
|--------|-------|----------|
| **aws-pricing-mcp-server** | AWS pricing information | Tra cứu giá các AWS services |
| **aws-cloudwatch-mcp-server** | CloudWatch monitoring | Xem metrics, logs và alarms |
| **aws-cost-explorer-mcp-server** | Cost analysis | Phân tích và tối ưu chi phí AWS |

### Container & Kubernetes (1 server)

| Server | Mô tả | Use Case |
|--------|-------|----------|
| **aws-eks-mcp-server** | EKS cluster management | Quản lý EKS clusters và workloads |

### Core (1 server)

| Server | Mô tả | Use Case |
|--------|-------|----------|
| **aws-api-mcp-server** | Core AWS API access | Truy cập programmatic vào AWS services |

## Hướng dẫn sử dụng

### 1. Infrastructure as Code

#### AWS CDK

```bash
# Trong Claude Code, bạn có thể yêu cầu:
"Hãy tạo một CDK stack với API Gateway và Lambda function"

# MCP server sẽ giúp:
# - Tạo CDK code structure
# - Validate configuration
# - Deploy stack
```

#### Terraform

```bash
# Yêu cầu Claude:
"Tạo Terraform configuration cho EC2 instance với security group"

# MCP server hỗ trợ:
# - Generate Terraform files
# - Plan và apply changes
# - Manage state
```

### 2. Serverless Development

```bash
# Lambda function development
"Tạo Lambda function xử lý S3 events"

# MCP servers giúp:
# - Generate function code
# - Configure triggers
# - Deploy và test
```

### 3. Database Operations

```bash
# DynamoDB operations
"Tạo DynamoDB table cho user management với GSI"

# MCP server hỗ trợ:
# - Create/update tables
# - Query và scan operations
# - Manage indexes
```

### 4. AI/ML với Bedrock

```bash
# Knowledge Base retrieval
"Retrieve thông tin về AWS Lambda từ Bedrock KB"

# MCP server thực hiện:
# - Semantic search
# - Document retrieval
# - Context enhancement
```

### 5. Cost Management

```bash
# Pricing information
"Chi phí cho EC2 t3.medium ở us-east-1 là bao nhiêu?"

# CloudWatch monitoring
"Show me CPU metrics cho EC2 instance i-xxxxx"

# Cost Explorer
"Phân tích chi phí AWS tháng này theo service"
```

### 6. Container Orchestration

```bash
# EKS management
"Tạo EKS cluster với managed node group"

# MCP server hỗ trợ:
# - Cluster creation
# - Node group management
# - Workload deployment
```

## Best Practices

### 1. Security

```bash
# Luôn sử dụng IAM roles và permissions tối thiểu
# Không hardcode credentials trong code

# Ví dụ IAM policy cho MCP:
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Action": [
      "lambda:ListFunctions",
      "lambda:GetFunction",
      "cloudwatch:GetMetricData"
    ],
    "Resource": "*"
  }]
}
```

### 2. Performance

- Sử dụng `@latest` để có phiên bản mới nhất, nhưng cân nhắc performance trade-off
- Cache MCP results khi có thể
- Sử dụng parallel operations cho independent tasks

### 3. Organization

```bash
# Tổ chức MCP servers theo use case
# Project-level: .mcp.json cho team
# User-level: ~/.config/claude-code/mcp_settings.json cho cá nhân
```

### 4. Monitoring

```bash
# Kiểm tra health định kỳ
claude mcp list

# Debug khi có vấn đề
timeout 15s uvx awslabs.aws-api-mcp-server@latest
```

## Troubleshooting

### MCP Server không connect

```bash
# 1. Kiểm tra credentials
aws sts get-caller-identity

# 2. Test server manually
timeout 15s uvx awslabs.[server-name]@latest

# 3. Xóa cache và reinstall
uv cache clean
claude mcp remove [server-name] -s local
claude mcp add --transport stdio [server-name] -- uvx awslabs.[server-name]@latest
```

### Permission denied

```bash
# Kiểm tra IAM permissions
aws iam get-user
aws iam list-attached-user-policies --user-name [your-user]

# Cập nhật permissions trong AWS IAM Console
```

### Slow performance

```bash
# Tối ưu bằng cách pin version thay vì @latest
claude mcp add --transport stdio aws-api-mcp-server -- uvx awslabs.aws-api-mcp-server==0.1.0

# Clear UV cache
uv cache clean
```

## Examples

### Detailed Tutorials

- **[01-account-setup.md](./examples/01-account-setup.md)** - Complete AWS account và IAM setup
- **[02-serverless-example.md](./examples/02-serverless-example.md)** - Todo API với Lambda, DynamoDB, Cognito
- **[03-infrastructure-example.md](./examples/03-infrastructure-example.md)** - Full infrastructure với CDK
- **[04-real-world-outputs.md](./examples/04-real-world-outputs.md)** - **NEW!** Real outputs từ AWS account thực tế
- **[use-cases.md](./examples/use-cases.md)** - 6 use cases thực tế

### Real-World Examples

File **[04-real-world-outputs.md](./examples/04-real-world-outputs.md)** chứa:
- Real Lambda function listings
- Actual DynamoDB table data
- Live S3 bucket information
- Real cost analysis và forecasts
- Complete workflow examples với actual outputs

## Resources

- [AWS MCP Servers Documentation](https://awslabs.github.io/mcp/)
- [GitHub Repository](https://github.com/awslabs/mcp)
- [Model Context Protocol Spec](https://modelcontextprotocol.io/)
- [Claude Code Documentation](https://docs.claude.com/en/docs/claude-code)

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This tutorial is licensed under MIT License. AWS MCP Servers are maintained by AWS Labs.

---

**Built with Claude Code**

*Last updated: January 2025*
