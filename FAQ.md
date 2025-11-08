# Frequently Asked Questions (FAQ)

## General Questions

### Q: What is MCP?

**A:** Model Context Protocol (MCP) is an open protocol that enables seamless integration between LLM applications (like Claude Code) and external data sources/tools. It's like a standardized "bridge" that lets AI assistants interact with your AWS services.

### Q: Why do I need AWS MCP Servers?

**A:** AWS MCP Servers provide:
- **Accurate data**: Real-time access to AWS APIs (no hallucinations)
- **Up-to-date information**: Latest AWS documentation and pricing
- **Automation**: Execute AWS operations directly from Claude
- **Best practices**: Built-in AWS expertise

### Q: Is this an official AWS product?

**A:** AWS MCP Servers are maintained by AWS Labs (awslabs), which is AWS's open-source initiative. While not an official AWS service, it's developed and maintained by AWS engineers.

---

## Installation & Setup

### Q: What are the system requirements?

**A:** You need:
- **uv** package manager (0.9.7+)
- **Python** 3.10 or higher
- **AWS CLI** configured with credentials
- **Claude Code** installed
- Internet connection

### Q: How long does installation take?

**A:**
- Quick install (3 servers): ~2 minutes
- Full install (13 servers): ~5-7 minutes
- First time setup with AWS: ~15 minutes

### Q: Do I need an AWS account?

**A:** Yes, you need an AWS account with:
- Valid credentials (Access Key + Secret Key)
- IAM permissions for services you want to use
- No minimum spending required (free tier works!)

### Q: Can I use this with AWS Free Tier?

**A:** Absolutely! All MCP servers work with Free Tier. They don't incur costs - they just help you manage your AWS resources.

---

## Usage

### Q: How do I know if MCP servers are working?

**A:** Run:
```bash
claude mcp list
```

You should see "✓ Connected" next to each server.

### Q: Can I use multiple MCP servers at once?

**A:** Yes! Claude can intelligently use multiple MCP servers in a single conversation. For example, it might use:
- `aws-api-mcp-server` to create resources
- `aws-pricing-mcp-server` to check costs
- `aws-cloudwatch-mcp-server` to set up monitoring

### Q: Which MCP servers should I install?

**A:** It depends on your use case:

**Everyone should have:**
- `aws-api-mcp-server` (core functionality)
- `aws-pricing-mcp-server` (cost awareness)

**For developers:**
- `aws-lambda-tool-mcp-server`
- `aws-dynamodb-mcp-server`
- `aws-cloudwatch-mcp-server`

**For infrastructure:**
- `aws-cdk-mcp-server`
- `aws-terraform-mcp-server`
- `aws-eks-mcp-server`

### Q: How do I update MCP servers?

**A:**
```bash
# Clear cache
uv cache clean

# Reinstall (automatically gets latest)
claude mcp remove SERVER_NAME -s local
claude mcp add --transport stdio SERVER_NAME -- uvx awslabs.SERVER_NAME@latest
```

---

## Troubleshooting

### Q: "MCP server failed to connect" - What do I do?

**A:** Try these steps:

1. **Test manually:**
   ```bash
   timeout 15s uvx awslabs.aws-api-mcp-server@latest
   ```

2. **Check AWS credentials:**
   ```bash
   aws sts get-caller-identity
   ```

3. **Clear cache and reinstall:**
   ```bash
   uv cache clean
   claude mcp remove SERVER_NAME -s local
   claude mcp add --transport stdio SERVER_NAME -- uvx awslabs.SERVER_NAME@latest
   ```

### Q: "Permission denied" errors?

**A:** This usually means IAM permissions issue:

1. Check your IAM policies
2. Ensure your user has necessary permissions
3. See [01-account-setup.md](./examples/01-account-setup.md) for recommended policies

### Q: MCP servers are slow?

**A:**
- First run is slower (downloads packages)
- Using `@latest` checks PyPI each time
- Solution: Pin versions for production:
  ```bash
  claude mcp add --transport stdio aws-api-mcp-server \
    -- uvx awslabs.aws-api-mcp-server==0.1.5
  ```

### Q: Can't find my resources?

**A:** Check the region:
- MCP servers default to your AWS CLI default region
- Specify region: `export AWS_REGION=us-west-2`
- Or ask Claude: "Show Lambda functions in us-west-2"

---

## Costs & Billing

### Q: Do MCP servers cost money?

**A:** No! MCP servers themselves are free. However:
- AWS resources you create will have normal AWS costs
- API calls count toward AWS Free Tier limits

### Q: Will Claude create expensive resources?

**A:** Claude will:
- Warn you about costs before creating resources
- Use cost-effective defaults (t3.micro, pay-per-request DynamoDB)
- Ask for confirmation on expensive operations

You can also:
- Set AWS billing alarms
- Use IAM policies to restrict resource types
- Review costs before deployment

### Q: How much does it cost to run the examples?

**A:** Estimated costs for tutorial examples:

- **Account Setup**: $0 (just configuration)
- **Serverless Example**: $0-2/month (mostly Free Tier)
- **Infrastructure Example**: $100-150/month (has EC2, RDS)
- **Real-world outputs**: $0 (read-only operations)

---

## Security

### Q: Is it safe to give Claude access to my AWS account?

**A:** Yes, with proper setup:

1. **Use IAM roles with limited permissions**
2. **Enable MFA** on your AWS account
3. **Use read-only permissions** for testing
4. **Review actions** before execution
5. **Set up CloudTrail** for audit logging

### Q: What permissions do MCP servers need?

**A:** Minimum for read-only:
```json
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Action": [
      "lambda:List*",
      "lambda:Get*",
      "dynamodb:Describe*",
      "dynamodb:List*",
      "ec2:Describe*",
      "s3:List*",
      "cloudwatch:Get*",
      "cloudwatch:Describe*"
    ],
    "Resource": "*"
  }]
}
```

For full functionality, see [01-account-setup.md](./examples/01-account-setup.md).

### Q: Can Claude delete my resources?

**A:** Only if you:
1. Give it IAM permissions to delete
2. Explicitly ask it to delete something

Best practice: Use separate AWS accounts for development/production.

---

## Advanced

### Q: Can I create custom MCP servers?

**A:** Yes! MCP is an open protocol. You can:
- Create custom servers for your internal tools
- Extend existing AWS MCP servers
- Build integrations with other services

See: https://modelcontextprotocol.io/

### Q: Can I use this in CI/CD pipelines?

**A:** Yes! Claude Code has SDK support:
```bash
# Headless mode
claude --print "Deploy the infrastructure"

# With specific configuration
claude --mcp-config ./production.json
```

### Q: How do I configure different environments?

**A:** Use AWS profiles:

```bash
# Development
export AWS_PROFILE=dev
claude

# Production
export AWS_PROFILE=prod
claude --mcp-config ./production-mcp.json
```

### Q: Can I use this with other AWS accounts?

**A:** Yes! Configure multiple profiles in `~/.aws/credentials`:

```ini
[default]
aws_access_key_id = YOUR_DEFAULT_KEY
aws_secret_access_key = YOUR_DEFAULT_SECRET

[production]
aws_access_key_id = YOUR_PROD_KEY
aws_secret_access_key = YOUR_PROD_SECRET

[client-a]
aws_access_key_id = CLIENT_A_KEY
aws_secret_access_key = CLIENT_A_SECRET
```

Then switch with:
```bash
export AWS_PROFILE=production
```

---

## Compatibility

### Q: What AWS services are supported?

**A:** Currently supported:
- ✅ Lambda
- ✅ DynamoDB
- ✅ S3
- ✅ EC2
- ✅ RDS
- ✅ EKS
- ✅ CloudWatch
- ✅ Cost Explorer
- ✅ Pricing API
- ✅ CDK
- ✅ Terraform
- ✅ Bedrock

More services being added regularly!

### Q: Does this work on Windows?

**A:** Yes! AWS MCP Servers work on:
- ✅ Linux (Ubuntu, Debian, etc.)
- ✅ macOS
- ✅ Windows (with WSL2 recommended)

### Q: Can I use this with Claude Desktop?

**A:** Not yet. Currently works with:
- ✅ Claude Code (CLI)
- ⏳ Claude Desktop (coming soon)

---

## Performance

### Q: How fast are MCP operations?

**A:** Typical response times:
- List operations: 1-2 seconds
- Create operations: 2-5 seconds
- Complex deployments: 30-300 seconds

Factors affecting speed:
- Network latency to AWS
- Complexity of operation
- First-time package downloads

### Q: Can I run multiple Claude instances?

**A:** Yes! Each Claude Code instance can have its own MCP configuration.

### Q: Is there a rate limit?

**A:** Limits come from:
- **AWS API limits**: Varies by service (usually very high)
- **uv/PyPI**: No practical limit
- **Claude API**: Based on your plan

---

## Getting Help

### Q: Where can I get help?

**A:** Multiple options:

1. **Documentation**
   - [README.md](./README.md)
   - [blog.md](./blog.md)
   - [Examples](./examples/)

2. **Community**
   - [GitHub Issues](https://github.com/vanhoangkha/aws-mcp-tutorial/issues)
   - [GitHub Discussions](https://github.com/vanhoangkha/aws-mcp-tutorial/discussions)

3. **Official Resources**
   - [AWS MCP Docs](https://awslabs.github.io/mcp/)
   - [Claude Code Docs](https://docs.claude.com/en/docs/claude-code)
   - [MCP Protocol](https://modelcontextprotocol.io/)

### Q: How do I report a bug?

**A:**
1. Check [existing issues](https://github.com/vanhoangkha/aws-mcp-tutorial/issues)
2. Create new issue with:
   - Clear description
   - Steps to reproduce
   - Expected vs actual behavior
   - System info (`uv --version`, `claude --version`, OS)
   - Error messages

### Q: Can I contribute?

**A:** Absolutely! See [CONTRIBUTING.md](./CONTRIBUTING.md) for guidelines.

We welcome:
- Bug fixes
- New examples
- Documentation improvements
- Use case stories
- Performance optimizations

---

## Still have questions?

- 💬 [Ask in Discussions](https://github.com/vanhoangkha/aws-mcp-tutorial/discussions)
- 🐛 [Report an Issue](https://github.com/vanhoangkha/aws-mcp-tutorial/issues)
- 📧 Contact: [Create a support request](https://github.com/vanhoangkha/aws-mcp-tutorial/issues/new)

---

**Last updated**: January 2025
