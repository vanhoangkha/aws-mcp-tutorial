# AWS Account Setup for MCP Servers

## Complete Setup Guide

### 1. AWS Account Prerequisites

#### 1.1. Create AWS Account (if needed)

```bash
# Visit: https://aws.amazon.com/
# Click "Create an AWS Account"
# Follow the registration process
```

**Account Information:**
```
Email: your-email@example.com
Account Name: MyCompany-Production
Root User Password: [Use strong password]
```

#### 1.2. Enable MFA for Root Account

```bash
# 1. Login to AWS Console
# 2. Go to IAM > Security credentials
# 3. Activate MFA
# 4. Choose Virtual MFA device
# 5. Scan QR code with Google Authenticator/Authy
```

---

### 2. IAM User Setup for MCP

#### 2.1. Create IAM User

**Via AWS Console:**
```
1. Go to IAM Console: https://console.aws.amazon.com/iam/
2. Click "Users" → "Add users"
3. User name: mcp-admin
4. Access type: ☑ Programmatic access
5. Click "Next: Permissions"
```

#### 2.2. Attach Policies

**Option A: Quick Start (PowerUser - Recommended for Development)**
```json
{
  "Policies": [
    "PowerUserAccess",
    "IAMReadOnlyAccess"
  ]
}
```

**Option B: Production-Ready (Custom Policy)**

Create custom policy: `MCPServerPolicy`

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "MCPLambdaAccess",
      "Effect": "Allow",
      "Action": [
        "lambda:CreateFunction",
        "lambda:DeleteFunction",
        "lambda:GetFunction",
        "lambda:GetFunctionConfiguration",
        "lambda:InvokeFunction",
        "lambda:ListFunctions",
        "lambda:UpdateFunctionCode",
        "lambda:UpdateFunctionConfiguration",
        "lambda:AddPermission",
        "lambda:RemovePermission",
        "lambda:GetPolicy",
        "lambda:CreateEventSourceMapping",
        "lambda:ListEventSourceMappings",
        "lambda:GetEventSourceMapping",
        "lambda:DeleteEventSourceMapping"
      ],
      "Resource": "*"
    },
    {
      "Sid": "MCPDynamoDBAccess",
      "Effect": "Allow",
      "Action": [
        "dynamodb:CreateTable",
        "dynamodb:DeleteTable",
        "dynamodb:DescribeTable",
        "dynamodb:ListTables",
        "dynamodb:UpdateTable",
        "dynamodb:PutItem",
        "dynamodb:GetItem",
        "dynamodb:UpdateItem",
        "dynamodb:DeleteItem",
        "dynamodb:Query",
        "dynamodb:Scan",
        "dynamodb:BatchGetItem",
        "dynamodb:BatchWriteItem",
        "dynamodb:DescribeTimeToLive",
        "dynamodb:UpdateTimeToLive"
      ],
      "Resource": "*"
    },
    {
      "Sid": "MCPEC2Access",
      "Effect": "Allow",
      "Action": [
        "ec2:Describe*",
        "ec2:CreateTags",
        "ec2:CreateSecurityGroup",
        "ec2:AuthorizeSecurityGroupIngress",
        "ec2:AuthorizeSecurityGroupEgress",
        "ec2:CreateKeyPair",
        "ec2:RunInstances",
        "ec2:TerminateInstances",
        "ec2:StopInstances",
        "ec2:StartInstances"
      ],
      "Resource": "*"
    },
    {
      "Sid": "MCPCloudFormationAccess",
      "Effect": "Allow",
      "Action": [
        "cloudformation:CreateStack",
        "cloudformation:DeleteStack",
        "cloudformation:DescribeStacks",
        "cloudformation:DescribeStackEvents",
        "cloudformation:DescribeStackResources",
        "cloudformation:UpdateStack",
        "cloudformation:ValidateTemplate",
        "cloudformation:ListStacks"
      ],
      "Resource": "*"
    },
    {
      "Sid": "MCPCloudWatchAccess",
      "Effect": "Allow",
      "Action": [
        "cloudwatch:PutMetricData",
        "cloudwatch:GetMetricData",
        "cloudwatch:GetMetricStatistics",
        "cloudwatch:ListMetrics",
        "cloudwatch:DescribeAlarms",
        "cloudwatch:PutMetricAlarm",
        "cloudwatch:DeleteAlarms",
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams",
        "logs:GetLogEvents",
        "logs:FilterLogEvents"
      ],
      "Resource": "*"
    },
    {
      "Sid": "MCPCostExplorerAccess",
      "Effect": "Allow",
      "Action": [
        "ce:GetCostAndUsage",
        "ce:GetCostForecast",
        "ce:GetDimensionValues",
        "ce:GetReservationUtilization",
        "ce:GetSavingsPlansUtilization"
      ],
      "Resource": "*"
    },
    {
      "Sid": "MCPPricingAccess",
      "Effect": "Allow",
      "Action": [
        "pricing:GetProducts",
        "pricing:DescribeServices",
        "pricing:GetAttributeValues"
      ],
      "Resource": "*"
    },
    {
      "Sid": "MCPBedrockAccess",
      "Effect": "Allow",
      "Action": [
        "bedrock:InvokeModel",
        "bedrock:InvokeModelWithResponseStream",
        "bedrock:Retrieve",
        "bedrock:RetrieveAndGenerate"
      ],
      "Resource": "*"
    },
    {
      "Sid": "MCPEKSAccess",
      "Effect": "Allow",
      "Action": [
        "eks:CreateCluster",
        "eks:DeleteCluster",
        "eks:DescribeCluster",
        "eks:ListClusters",
        "eks:UpdateClusterConfig",
        "eks:UpdateClusterVersion",
        "eks:CreateNodegroup",
        "eks:DeleteNodegroup",
        "eks:DescribeNodegroup",
        "eks:ListNodegroups"
      ],
      "Resource": "*"
    },
    {
      "Sid": "MCPIAMPassRole",
      "Effect": "Allow",
      "Action": [
        "iam:PassRole",
        "iam:CreateRole",
        "iam:DeleteRole",
        "iam:GetRole",
        "iam:AttachRolePolicy",
        "iam:DetachRolePolicy",
        "iam:PutRolePolicy",
        "iam:DeleteRolePolicy"
      ],
      "Resource": "arn:aws:iam::*:role/*"
    },
    {
      "Sid": "MCPS3Access",
      "Effect": "Allow",
      "Action": [
        "s3:CreateBucket",
        "s3:DeleteBucket",
        "s3:ListBucket",
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject",
        "s3:GetBucketLocation",
        "s3:ListAllMyBuckets"
      ],
      "Resource": "*"
    },
    {
      "Sid": "MCPAPIGatewayAccess",
      "Effect": "Allow",
      "Action": [
        "apigateway:*"
      ],
      "Resource": "*"
    }
  ]
}
```

#### 2.3. Download Credentials

After creating user, **IMPORTANT**: Save these credentials securely!

```
Access Key ID: AKIAIOSFODNN7EXAMPLE
Secret Access Key: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
```

**Security Best Practices:**
- Never commit credentials to Git
- Use environment variables or AWS credentials file
- Rotate keys every 90 days
- Enable MFA for IAM user

---

### 3. Local AWS CLI Configuration

#### 3.1. Install AWS CLI

**Ubuntu/Debian:**
```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Verify
aws --version
# Output: aws-cli/2.x.x Python/3.x.x Linux/x.x.x
```

**macOS:**
```bash
brew install awscli

# Verify
aws --version
```

**Windows:**
```powershell
# Download from: https://aws.amazon.com/cli/
# Run installer
# Verify in PowerShell:
aws --version
```

#### 3.2. Configure AWS Credentials

**Method 1: Using aws configure (Recommended)**

```bash
aws configure

# Enter when prompted:
AWS Access Key ID [None]: AKIAIOSFODNN7EXAMPLE
AWS Secret Access Key [None]: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
Default region name [None]: us-east-1
Default output format [None]: json
```

**Method 2: Manual Configuration**

Create credentials file:
```bash
mkdir -p ~/.aws

cat > ~/.aws/credentials << 'EOF'
[default]
aws_access_key_id = AKIAIOSFODNN7EXAMPLE
aws_secret_access_key = wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY

[production]
aws_access_key_id = AKIAI44QH8DHBEXAMPLE
aws_secret_access_key = je7MtGbClwBF/2Zp9Utk/h3yCo8nvbEXAMPLEKEY

[development]
aws_access_key_id = AKIAI44QH8DHBEXAMPLE
aws_secret_access_key = je7MtGbClwBF/2Zp9Utk/h3yCo8nvbEXAMPLEKEY
EOF

# Set permissions
chmod 600 ~/.aws/credentials
```

Create config file:
```bash
cat > ~/.aws/config << 'EOF'
[default]
region = us-east-1
output = json

[profile production]
region = us-east-1
output = json

[profile development]
region = us-west-2
output = json
EOF
```

#### 3.3. Verify Configuration

```bash
# Test credentials
aws sts get-caller-identity

# Expected output:
{
    "UserId": "AIDAI23HXE2NYPEXAMPLE",
    "Account": "123456789012",
    "Arn": "arn:aws:iam::123456789012:user/mcp-admin"
}

# Test specific profile
aws sts get-caller-identity --profile production

# List S3 buckets (to verify permissions)
aws s3 ls

# Describe EC2 instances
aws ec2 describe-instances --region us-east-1
```

---

### 4. Environment Variables Setup

#### 4.1. Bash/Zsh (.bashrc or .zshrc)

```bash
# Add to ~/.bashrc or ~/.zshrc

# AWS Configuration
export AWS_DEFAULT_REGION=us-east-1
export AWS_DEFAULT_OUTPUT=json

# For specific profile
export AWS_PROFILE=production

# MCP Configuration
export MCP_TIMEOUT=30000
export MCP_TOOL_TIMEOUT=60000

# Optional: Enable debug mode
# export MCP_DEBUG=1
# export ANTHROPIC_LOG=debug

# Reload
source ~/.bashrc  # or source ~/.zshrc
```

#### 4.2. Per-Project Configuration

Create `.env` file in project:
```bash
cat > .env << 'EOF'
# AWS Configuration
AWS_REGION=us-east-1
AWS_PROFILE=development

# MCP Settings
MCP_TIMEOUT=30000
MCP_TOOL_TIMEOUT=60000

# Claude Code Settings
CLAUDE_CODE_AUTO_CONNECT_IDE=true
EOF

# Load environment
set -a
source .env
set +a
```

---

### 5. MCP Server Configuration

#### 5.1. Global MCP Configuration

**Location**: `~/.config/claude-code/mcp_settings.json`

```json
{
  "mcpServers": {
    "aws-api-mcp-server": {
      "type": "stdio",
      "command": "uvx",
      "args": ["awslabs.aws-api-mcp-server@latest"],
      "env": {
        "AWS_REGION": "us-east-1",
        "AWS_PROFILE": "default"
      }
    }
  }
}
```

#### 5.2. Project-Level MCP Configuration

**Location**: `<project-root>/.mcp.json`

```json
{
  "mcpServers": {
    "aws-api-mcp-server": {
      "type": "stdio",
      "command": "uvx",
      "args": ["awslabs.aws-api-mcp-server@latest"],
      "env": {
        "AWS_REGION": "us-east-1",
        "AWS_PROFILE": "production",
        "MCP_REQUIRE_APPROVAL": "true"
      }
    },
    "aws-cdk-mcp-server": {
      "type": "stdio",
      "command": "uvx",
      "args": ["awslabs.cdk-mcp-server@latest"],
      "env": {
        "AWS_REGION": "us-east-1"
      }
    },
    "aws-pricing-mcp-server": {
      "type": "stdio",
      "command": "uvx",
      "args": ["awslabs.aws-pricing-mcp-server@latest"],
      "env": {}
    }
  }
}
```

---

### 6. Testing the Setup

#### 6.1. Complete Verification Script

```bash
#!/bin/bash

echo "🔍 AWS MCP Setup Verification"
echo "=============================="
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

check_passed() {
    echo -e "${GREEN}✓${NC} $1"
}

check_failed() {
    echo -e "${RED}✗${NC} $1"
}

# 1. Check AWS CLI
echo "1. Checking AWS CLI..."
if command -v aws &> /dev/null; then
    VERSION=$(aws --version)
    check_passed "AWS CLI installed: $VERSION"
else
    check_failed "AWS CLI not installed"
    exit 1
fi

# 2. Check AWS Credentials
echo ""
echo "2. Checking AWS Credentials..."
if aws sts get-caller-identity &> /dev/null; then
    ACCOUNT=$(aws sts get-caller-identity --query Account --output text)
    USER=$(aws sts get-caller-identity --query Arn --output text)
    check_passed "AWS credentials configured"
    echo "   Account: $ACCOUNT"
    echo "   User: $USER"
else
    check_failed "AWS credentials not configured"
    exit 1
fi

# 3. Check uv
echo ""
echo "3. Checking uv package manager..."
if command -v uv &> /dev/null; then
    UV_VERSION=$(uv --version)
    check_passed "uv installed: $UV_VERSION"
else
    check_failed "uv not installed"
fi

# 4. Check Claude Code
echo ""
echo "4. Checking Claude Code..."
if command -v claude &> /dev/null; then
    CLAUDE_VERSION=$(claude --version 2>&1)
    check_passed "Claude Code installed: $CLAUDE_VERSION"
else
    check_failed "Claude Code not installed"
    exit 1
fi

# 5. Test AWS Permissions
echo ""
echo "5. Testing AWS Permissions..."

# Test Lambda
if aws lambda list-functions --max-items 1 &> /dev/null; then
    check_passed "Lambda access: OK"
else
    check_failed "Lambda access: DENIED"
fi

# Test DynamoDB
if aws dynamodb list-tables --max-items 1 &> /dev/null; then
    check_passed "DynamoDB access: OK"
else
    check_failed "DynamoDB access: DENIED"
fi

# Test EC2
if aws ec2 describe-instances --max-results 5 &> /dev/null; then
    check_passed "EC2 access: OK"
else
    check_failed "EC2 access: DENIED"
fi

# Test CloudWatch
if aws cloudwatch list-metrics --max-records 1 &> /dev/null; then
    check_passed "CloudWatch access: OK"
else
    check_failed "CloudWatch access: DENIED"
fi

# Test Pricing
if aws pricing describe-services --service-code AmazonEC2 --region us-east-1 &> /dev/null; then
    check_passed "Pricing API access: OK"
else
    check_failed "Pricing API access: DENIED"
fi

# 6. Check MCP Servers
echo ""
echo "6. Checking MCP Servers..."
claude mcp list

echo ""
echo "=============================="
echo "✅ Setup verification complete!"
echo ""
echo "Next steps:"
echo "  1. Try: claude"
echo "  2. Ask Claude: 'List my Lambda functions'"
echo "  3. Check the examples/ folder for tutorials"
```

Save as `verify-setup.sh` and run:
```bash
chmod +x verify-setup.sh
./verify-setup.sh
```

---

### 7. Example: Complete Workflow

#### 7.1. Create Test Resources

```bash
# Set environment
export AWS_PROFILE=development
export AWS_REGION=us-east-1

# Start Claude Code
claude

# In Claude, try these prompts:
```

**Prompt 1: List Resources**
```
Show me all Lambda functions in us-east-1
```

**Prompt 2: Create Lambda**
```
Create a simple Lambda function:
- Name: hello-world
- Runtime: Python 3.11
- Handler: lambda_function.lambda_handler
- Code: Return "Hello from Lambda!"
```

**Prompt 3: Query DynamoDB**
```
Create DynamoDB table:
- Name: test-users
- Partition key: userId (String)
- On-demand billing
Then add 2 sample users
```

**Prompt 4: Check Costs**
```
Show me the cost breakdown for this month by service
```

---

### 8. Security Checklist

Before using MCP servers in production:

- [ ] Enable MFA on root account
- [ ] Enable MFA on IAM users
- [ ] Use IAM roles instead of IAM users when possible
- [ ] Apply principle of least privilege
- [ ] Enable CloudTrail for audit logging
- [ ] Set up AWS Config for compliance
- [ ] Enable GuardDuty for threat detection
- [ ] Rotate access keys every 90 days
- [ ] Use AWS Secrets Manager for sensitive data
- [ ] Enable encryption at rest and in transit
- [ ] Review IAM policies regularly
- [ ] Set up billing alarms
- [ ] Use AWS Organizations for multi-account setup
- [ ] Enable AWS SSO for centralized access

---

### 9. Troubleshooting Common Issues

#### Issue 1: "Unable to locate credentials"

```bash
# Solution: Configure credentials
aws configure

# Or check credentials file
cat ~/.aws/credentials
```

#### Issue 2: "Access Denied" errors

```bash
# Check your permissions
aws iam get-user
aws iam list-attached-user-policies --user-name mcp-admin

# Test specific service
aws lambda list-functions
```

#### Issue 3: MCP server connection failed

```bash
# Test server manually
timeout 15s uvx awslabs.aws-api-mcp-server@latest

# Clear cache
uv cache clean

# Reinstall
claude mcp remove aws-api-mcp-server -s local
claude mcp add --transport stdio aws-api-mcp-server -- uvx awslabs.aws-api-mcp-server@latest
```

#### Issue 4: Region mismatch

```bash
# Set default region
export AWS_DEFAULT_REGION=us-east-1

# Or specify in command
aws ec2 describe-instances --region us-west-2
```

---

### 10. Cost Optimization Tips

1. **Use appropriate regions**: us-east-1 is usually cheapest
2. **Enable billing alerts**: Get notified when costs exceed threshold
3. **Use tags**: Tag all resources for cost allocation
4. **Monitor regularly**: Use Cost Explorer MCP server
5. **Clean up**: Delete unused resources regularly

```bash
# Set up billing alert
aws cloudwatch put-metric-alarm \
  --alarm-name high-aws-spending \
  --alarm-description "Alert when spending exceeds $100" \
  --metric-name EstimatedCharges \
  --namespace AWS/Billing \
  --statistic Maximum \
  --period 21600 \
  --evaluation-periods 1 \
  --threshold 100 \
  --comparison-operator GreaterThanThreshold
```

---

**Setup complete! You're ready to use AWS MCP Servers with Claude Code.** 🚀

For detailed examples, see:
- `02-serverless-example.md` - Complete serverless app
- `03-infrastructure-example.md` - Full IaC deployment
- `04-database-example.md` - Database operations
