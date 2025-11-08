# AWS MCP Servers Comparison

Complete comparison and decision guide for AWS MCP Servers.

## Quick Decision Matrix

| Your Goal | Recommended Servers | Priority |
|-----------|-------------------|----------|
| 🚀 Getting Started | aws-api-mcp-server + aws-pricing-mcp-server | **Essential** |
| 💰 Cost Management | aws-pricing-mcp-server + aws-cost-explorer-mcp-server | High |
| 🔧 Serverless Development | aws-lambda-tool-mcp-server + aws-dynamodb-mcp-server | High |
| 🏗️ Infrastructure as Code | aws-cdk-mcp-server OR aws-terraform-mcp-server | High |
| 📊 Monitoring & Ops | aws-cloudwatch-mcp-server | Medium |
| 🐳 Containers | aws-eks-mcp-server | Medium |
| 🤖 AI/ML | aws-bedrock-kb-retrieval-mcp-server | Medium |
| 📦 Storage | aws-s3-tables-mcp-server | Low |

---

## Detailed Server Comparison

### Core & Essential

#### 1. aws-api-mcp-server ⭐ **ESSENTIAL**

| Aspect | Details |
|--------|---------|
| **Purpose** | Core AWS API access |
| **Priority** | ⭐⭐⭐⭐⭐ Essential |
| **Use Cases** | - List/describe AWS resources<br>- Execute AWS CLI operations<br>- Cross-service operations |
| **Pros** | - Comprehensive AWS coverage<br>- Command validation<br>- Security controls<br>- Works with all AWS services |
| **Cons** | - Generic (no service-specific optimizations) |
| **Best For** | Everyone |
| **Install Command** | `claude mcp add --transport stdio aws-api-mcp-server -- uvx awslabs.aws-api-mcp-server@latest` |
| **Package** | `awslabs.aws-api-mcp-server` |
| **Status** | ✅ Stable |

---

### Infrastructure as Code

#### 2. aws-cdk-mcp-server

| Aspect | Details |
|--------|---------|
| **Purpose** | AWS CDK infrastructure deployment |
| **Priority** | ⭐⭐⭐⭐ High (if using CDK) |
| **Use Cases** | - Generate CDK code<br>- Deploy infrastructure<br>- Manage stacks |
| **Pros** | - TypeScript/Python support<br>- Best practices built-in<br>- Type safety |
| **Cons** | - Requires Node.js/Python knowledge<br>- Steeper learning curve |
| **Best For** | Developers familiar with CDK or TypeScript |
| **vs Terraform** | CDK = More programmatic, Terraform = More declarative |
| **Install Command** | `claude mcp add --transport stdio aws-cdk-mcp-server -- uvx awslabs.cdk-mcp-server@latest` |
| **Package** | `awslabs.cdk-mcp-server` |
| **Status** | ✅ Stable |

#### 3. aws-terraform-mcp-server

| Aspect | Details |
|--------|---------|
| **Purpose** | Terraform infrastructure management |
| **Priority** | ⭐⭐⭐⭐ High (if using Terraform) |
| **Use Cases** | - Generate Terraform configs<br>- Plan/apply changes<br>- State management |
| **Pros** | - Industry standard<br>- Multi-cloud support<br>- Large community |
| **Cons** | - HCL syntax<br>- State management complexity |
| **Best For** | Teams using Terraform |
| **vs CDK** | Terraform = More portable, CDK = More programmatic |
| **Install Command** | `claude mcp add --transport stdio aws-terraform-mcp-server -- uvx awslabs.terraform-mcp-server@latest` |
| **Package** | `awslabs.terraform-mcp-server` |
| **Status** | ✅ Stable |

**CDK vs Terraform - When to use what?**

| Factor | Use CDK | Use Terraform |
|--------|---------|---------------|
| **Team Background** | JavaScript/TypeScript/Python developers | DevOps with HCL experience |
| **Cloud Strategy** | AWS-only | Multi-cloud |
| **Complexity** | Complex logic, loops, conditions | Simple, declarative configs |
| **Type Safety** | Need compile-time checks | Runtime is OK |
| **Tooling** | IDE support for code | Terraform ecosystem tools |

---

### Serverless & Compute

#### 4. aws-lambda-tool-mcp-server

| Aspect | Details |
|--------|---------|
| **Purpose** | Lambda function management |
| **Priority** | ⭐⭐⭐⭐ High (for serverless) |
| **Use Cases** | - Create/update functions<br>- Configure triggers<br>- Manage versions |
| **Pros** | - Quick function deployment<br>- Environment variable management<br>- Trigger configuration |
| **Cons** | - Limited to Lambda |
| **Best For** | Serverless developers |
| **Install Command** | `claude mcp add --transport stdio aws-lambda-tool-mcp-server -- uvx awslabs.lambda-tool-mcp-server@latest` |
| **Package** | `awslabs.lambda-tool-mcp-server` |
| **Status** | ✅ Stable |

#### 5. aws-serverless-mcp-server

| Aspect | Details |
|--------|---------|
| **Purpose** | Complete serverless applications |
| **Priority** | ⭐⭐⭐ Medium |
| **Use Cases** | - SAM/Serverless Framework<br>- Multi-function apps<br>- Full stack serverless |
| **Pros** | - Holistic approach<br>- Multi-service deployment |
| **Cons** | - Overlaps with Lambda tool<br>- More complex |
| **Best For** | Complete serverless architectures |
| **vs Lambda Tool** | Serverless = Full app, Lambda Tool = Individual functions |
| **Install Command** | `claude mcp add --transport stdio aws-serverless-mcp-server -- uvx awslabs.aws-serverless-mcp-server@latest` |
| **Package** | `awslabs.aws-serverless-mcp-server` |
| **Status** | ✅ Stable |

---

### Databases

#### 6. aws-dynamodb-mcp-server

| Aspect | Details |
|--------|---------|
| **Purpose** | DynamoDB operations |
| **Priority** | ⭐⭐⭐⭐ High (if using DynamoDB) |
| **Use Cases** | - CRUD operations<br>- Query/Scan<br>- Index management |
| **Pros** | - Direct table access<br>- Query optimization<br>- Batch operations |
| **Cons** | - DynamoDB only |
| **Best For** | NoSQL data access |
| **Install Command** | `claude mcp add --transport stdio aws-dynamodb-mcp-server -- uvx awslabs.dynamodb-mcp-server@latest` |
| **Package** | `awslabs.dynamodb-mcp-server` |
| **Status** | ✅ Stable |

#### 7. aws-s3-tables-mcp-server

| Aspect | Details |
|--------|---------|
| **Purpose** | S3 Tables operations |
| **Priority** | ⭐⭐ Low |
| **Use Cases** | - Iceberg tables<br>- Tabular data in S3 |
| **Pros** | - Modern table format<br>- ACID transactions |
| **Cons** | - Niche use case<br>- Newer feature |
| **Best For** | Data lakes with Iceberg |
| **Install Command** | `claude mcp add --transport stdio aws-s3-tables-mcp-server -- uvx awslabs.s3-tables-mcp-server@latest` |
| **Package** | `awslabs.s3-tables-mcp-server` |
| **Status** | ✅ Stable |

---

### Cost Management

#### 8. aws-pricing-mcp-server ⭐ **ESSENTIAL**

| Aspect | Details |
|--------|---------|
| **Purpose** | AWS pricing information |
| **Priority** | ⭐⭐⭐⭐⭐ Essential |
| **Use Cases** | - Get service pricing<br>- Compare regions<br>- Cost estimation |
| **Pros** | - Real-time pricing<br>- All services<br>- Region comparison |
| **Cons** | - Read-only |
| **Best For** | Everyone (cost awareness) |
| **Install Command** | `claude mcp add --transport stdio aws-pricing-mcp-server -- uvx awslabs.aws-pricing-mcp-server@latest` |
| **Package** | `awslabs.aws-pricing-mcp-server` |
| **Status** | ✅ Stable |

#### 9. aws-cost-explorer-mcp-server

| Aspect | Details |
|--------|---------|
| **Purpose** | Cost analysis and optimization |
| **Priority** | ⭐⭐⭐⭐ High |
| **Use Cases** | - Cost breakdown<br>- Trend analysis<br>- Budget forecasting |
| **Pros** | - Actual spending data<br>- Historical analysis<br>- Recommendations |
| **Cons** | - Requires Cost Explorer API<br>- Slight API costs |
| **Best For** | Cost optimization teams |
| **vs Pricing** | Cost Explorer = Actual costs, Pricing = Projected costs |
| **Install Command** | `claude mcp add --transport stdio aws-cost-explorer-mcp-server -- uvx awslabs.cost-explorer-mcp-server@latest` |
| **Package** | `awslabs.cost-explorer-mcp-server` |
| **Status** | ✅ Stable |

---

### Monitoring

#### 10. aws-cloudwatch-mcp-server

| Aspect | Details |
|--------|---------|
| **Purpose** | CloudWatch monitoring |
| **Priority** | ⭐⭐⭐ Medium-High |
| **Use Cases** | - View metrics<br>- Query logs<br>- Create alarms |
| **Pros** | - Real-time metrics<br>- Log insights<br>- Alarm management |
| **Cons** | - Can be verbose |
| **Best For** | Operations/monitoring |
| **Install Command** | `claude mcp add --transport stdio aws-cloudwatch-mcp-server -- uvx awslabs.cloudwatch-mcp-server@latest` |
| **Package** | `awslabs.cloudwatch-mcp-server` |
| **Status** | ✅ Stable |

---

### Containers

#### 11. aws-eks-mcp-server

| Aspect | Details |
|--------|---------|
| **Purpose** | EKS cluster management |
| **Priority** | ⭐⭐⭐ Medium (if using K8s) |
| **Use Cases** | - Create clusters<br>- Manage node groups<br>- Deploy workloads |
| **Pros** | - Full EKS support<br>- Node group management |
| **Cons** | - K8s knowledge required<br>- Complex |
| **Best For** | Container orchestration teams |
| **Install Command** | `claude mcp add --transport stdio aws-eks-mcp-server -- uvx awslabs.eks-mcp-server@latest` |
| **Package** | `awslabs.eks-mcp-server` |
| **Status** | ✅ Stable |

---

### AI/ML

#### 12. aws-bedrock-kb-retrieval-mcp-server

| Aspect | Details |
|--------|---------|
| **Purpose** | Bedrock Knowledge Base retrieval |
| **Priority** | ⭐⭐⭐ Medium (if using Bedrock) |
| **Use Cases** | - RAG applications<br>- Document Q&A<br>- Knowledge retrieval |
| **Pros** | - Semantic search<br>- Context augmentation |
| **Cons** | - Requires Bedrock KB setup |
| **Best For** | AI/ML applications |
| **Install Command** | `claude mcp add --transport stdio aws-bedrock-kb-retrieval-mcp-server -- uvx awslabs.bedrock-kb-retrieval-mcp-server@latest` |
| **Package** | `awslabs.bedrock-kb-retrieval-mcp-server` |
| **Status** | ✅ Stable |

---

## Installation Strategies

### Strategy 1: Minimal (Start Here)

Install only essentials:
```bash
claude mcp add --transport stdio aws-api-mcp-server -- uvx awslabs.aws-api-mcp-server@latest
claude mcp add --transport stdio aws-pricing-mcp-server -- uvx awslabs.aws-pricing-mcp-server@latest
```

**Pros**: Fast, simple, covers basics
**Use when**: Just getting started

### Strategy 2: Serverless Developer

```bash
# Minimal +
claude mcp add --transport stdio aws-lambda-tool-mcp-server -- uvx awslabs.lambda-tool-mcp-server@latest
claude mcp add --transport stdio aws-dynamodb-mcp-server -- uvx awslabs.dynamodb-mcp-server@latest
claude mcp add --transport stdio aws-cloudwatch-mcp-server -- uvx awslabs.cloudwatch-mcp-server@latest
```

**Pros**: Everything for serverless
**Use when**: Building serverless apps

### Strategy 3: Infrastructure Engineer

```bash
# Minimal +
claude mcp add --transport stdio aws-cdk-mcp-server -- uvx awslabs.cdk-mcp-server@latest
# OR
claude mcp add --transport stdio aws-terraform-mcp-server -- uvx awslabs.terraform-mcp-server@latest

claude mcp add --transport stdio aws-cloudwatch-mcp-server -- uvx awslabs.cloudwatch-mcp-server@latest
claude mcp add --transport stdio aws-cost-explorer-mcp-server -- uvx awslabs.cost-explorer-mcp-server@latest
```

**Pros**: Full infrastructure management
**Use when**: Managing AWS infrastructure

### Strategy 4: Full Stack (Everything)

```bash
./install.sh
```

**Pros**: All capabilities
**Cons**: Slower startup
**Use when**: Need comprehensive access

---

## Performance Comparison

| Server | Startup Time | Memory Usage | Typical Response Time |
|--------|--------------|--------------|----------------------|
| aws-api-mcp-server | 2-3s | ~50MB | 1-2s |
| aws-pricing-mcp-server | 1-2s | ~30MB | 0.5-1s |
| aws-cdk-mcp-server | 3-4s | ~80MB | 2-5s |
| aws-terraform-mcp-server | 2-3s | ~60MB | 2-4s |
| aws-lambda-tool-mcp-server | 2s | ~40MB | 1-2s |
| aws-dynamodb-mcp-server | 2s | ~40MB | 0.5-1s |
| aws-cloudwatch-mcp-server | 2-3s | ~50MB | 1-3s |
| aws-cost-explorer-mcp-server | 2s | ~40MB | 2-4s |
| aws-eks-mcp-server | 3-4s | ~70MB | 5-10s |

**Note**: First run is slower (downloads packages). Subsequent runs use cache.

---

## Cost Impact

| Server | AWS API Costs | Notes |
|--------|---------------|-------|
| aws-api-mcp-server | Standard AWS API rates | Usually free tier eligible |
| aws-pricing-mcp-server | Free | Pricing API is free |
| aws-cost-explorer-mcp-server | $0.01 per request | After 50 free requests/month |
| aws-cloudwatch-mcp-server | Standard CW rates | Metrics & logs cost money |
| All others | Standard AWS API rates | Depends on operations |

---

## Compatibility Matrix

| Server | Linux | macOS | Windows (WSL) | AWS Regions |
|--------|-------|-------|---------------|-------------|
| aws-api-mcp-server | ✅ | ✅ | ✅ | All |
| aws-pricing-mcp-server | ✅ | ✅ | ✅ | All |
| aws-cdk-mcp-server | ✅ | ✅ | ✅ | All |
| aws-terraform-mcp-server | ✅ | ✅ | ✅ | All |
| aws-lambda-tool-mcp-server | ✅ | ✅ | ✅ | All |
| aws-dynamodb-mcp-server | ✅ | ✅ | ✅ | All |
| aws-cloudwatch-mcp-server | ✅ | ✅ | ✅ | All |
| aws-cost-explorer-mcp-server | ✅ | ✅ | ✅ | All |
| aws-eks-mcp-server | ✅ | ✅ | ✅ | EKS regions only |
| aws-bedrock-kb-retrieval | ✅ | ✅ | ✅ | Bedrock regions only |

---

## Decision Flowchart

```
Start Here
    │
    ▼
Do you have AWS account?
    │
    ├─ No ──> Setup AWS account first (see 01-account-setup.md)
    │
    ▼ Yes
    │
Install essentials:
    - aws-api-mcp-server
    - aws-pricing-mcp-server
    │
    ▼
What's your primary use case?
    │
    ├─ Serverless Apps ──────> + aws-lambda-tool-mcp-server
    │                           + aws-dynamodb-mcp-server
    │
    ├─ Infrastructure ───────> + aws-cdk-mcp-server (or terraform)
    │                           + aws-cloudwatch-mcp-server
    │
    ├─ Cost Management ──────> + aws-cost-explorer-mcp-server
    │                           + aws-cloudwatch-mcp-server
    │
    ├─ Containers ───────────> + aws-eks-mcp-server
    │
    └─ AI/ML ────────────────> + aws-bedrock-kb-retrieval-mcp-server
```

---

## Recommendations by Role

### For DevOps Engineers
```
Priority: aws-api-mcp-server, aws-cdk/terraform, aws-cloudwatch, aws-cost-explorer
```

### For Backend Developers
```
Priority: aws-api-mcp-server, aws-lambda-tool, aws-dynamodb, aws-cloudwatch
```

### For Cloud Architects
```
Priority: All (use ./install.sh)
```

### For Students/Learners
```
Priority: aws-api-mcp-server, aws-pricing (keep costs low!)
```

### For Cost Optimization Teams
```
Priority: aws-pricing, aws-cost-explorer, aws-cloudwatch
```

---

**Last Updated**: January 2025

Need help choosing? See [FAQ.md](./FAQ.md) or [open a discussion](https://github.com/vanhoangkha/aws-mcp-tutorial/discussions)!
