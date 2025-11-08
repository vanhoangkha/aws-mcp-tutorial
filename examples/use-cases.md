# AWS MCP Servers - Use Cases Examples

## Table of Contents

1. [Infrastructure Deployment](#1-infrastructure-deployment)
2. [Serverless Application](#2-serverless-application)
3. [Database Operations](#3-database-operations)
4. [Cost Analysis](#4-cost-analysis)
5. [Monitoring Setup](#5-monitoring-setup)
6. [Container Orchestration](#6-container-orchestration)

---

## 1. Infrastructure Deployment

### Use Case: Deploy a complete web application infrastructure

**Goal**: Deploy VPC, ALB, EC2 Auto Scaling, RDS database

**MCP Servers used**:
- aws-cdk-mcp-server
- aws-api-mcp-server

**Claude prompt**:
```
Tạo CDK stack cho web application với:
- VPC: public và private subnets trong 2 AZs
- Application Load Balancer
- EC2 Auto Scaling group (min: 2, max: 6)
- RDS PostgreSQL (Multi-AZ)
- Security groups configured correctly
```

**Expected outcome**:
- CDK TypeScript code generated
- Infrastructure validated
- Deployment successful
- Output: ALB DNS name, RDS endpoint

---

## 2. Serverless Application

### Use Case: Build REST API for e-commerce product catalog

**Goal**: Create serverless API with CRUD operations

**MCP Servers used**:
- aws-lambda-tool-mcp-server
- aws-dynamodb-mcp-server
- aws-api-mcp-server

**Claude prompt**:
```
Tạo serverless REST API cho product catalog với:

Endpoints:
- POST /products - Create product
- GET /products - List all products
- GET /products/{id} - Get product detail
- PUT /products/{id} - Update product
- DELETE /products/{id} - Delete product

Database:
- DynamoDB table với GSI cho category query
- Partition key: productId
- GSI: category-index

Include:
- Lambda functions cho mỗi endpoint
- API Gateway configuration
- IAM roles và permissions
- Input validation
- Error handling
```

**Expected outcome**:
```
✅ Created DynamoDB table: products
✅ Created 5 Lambda functions
✅ Created API Gateway: product-catalog-api
✅ Configured CORS
✅ Deployed to production

API Endpoint: https://xxx.execute-api.us-east-1.amazonaws.com/prod
```

---

## 3. Database Operations

### Use Case: User management with DynamoDB

**MCP Servers used**:
- aws-dynamodb-mcp-server

**Claude prompt**:
```
Setup DynamoDB table cho user management:

Table: Users
Primary Key: userId (String)
Sort Key: timestamp (Number)

Attributes:
- email (String)
- username (String)
- firstName (String)
- lastName (String)
- status (String: active/inactive)
- createdAt (Number)
- updatedAt (Number)

GSI:
- email-index: email (PK)
- username-index: username (PK)

Sample operations:
1. Create 3 sample users
2. Query user by email
3. Update user status
4. List all active users
```

**Expected outcome**:
```
Table created: Users
- Capacity: PAY_PER_REQUEST
- Encryption: AWS_OWNED_KMS_KEY
- Point-in-time recovery: Enabled

Sample users created:
1. john.doe@example.com
2. jane.smith@example.com
3. bob.wilson@example.com

Query results: 3 active users
```

---

## 4. Cost Analysis

### Use Case: Monthly AWS cost optimization

**MCP Servers used**:
- aws-cost-explorer-mcp-server
- aws-pricing-mcp-server
- aws-api-mcp-server

**Claude prompt**:
```
Phân tích AWS costs và đưa ra recommendations:

1. Cost breakdown theo service (tháng hiện tại)
2. Top 5 services có chi phí cao nhất
3. Identify idle resources:
   - Unattached EBS volumes
   - Idle RDS instances
   - Unused Elastic IPs
4. Compare On-Demand vs Reserved Instance pricing
5. Savings recommendations với estimated ROI
```

**Expected outcome**:
```
📊 AWS Cost Analysis Report
━━━━━━━━━━━━━━━━━━━━━━━━━━

Current Month Spend: $12,450

Top 5 Services:
1. EC2: $4,500 (36%)
2. RDS: $3,200 (26%)
3. S3: $1,800 (14%)
4. Data Transfer: $1,200 (10%)
5. Lambda: $950 (8%)

💡 Optimization Opportunities:

1. EC2 Reserved Instances
   - Current: 15 t3.large On-Demand
   - Recommendation: 1-year Reserved
   - Savings: $1,800/month (40%)

2. Unused Resources
   - 8 unattached EBS volumes
   - Cost: $240/month
   - Action: Delete or archive

3. RDS Right-sizing
   - db.r5.2xlarge underutilized (15% CPU)
   - Recommendation: Downgrade to db.r5.xlarge
   - Savings: $620/month

Total Potential Savings: $2,660/month (21.4%)
```

---

## 5. Monitoring Setup

### Use Case: Comprehensive monitoring for production application

**MCP Servers used**:
- aws-cloudwatch-mcp-server
- aws-api-mcp-server

**Claude prompt**:
```
Setup comprehensive monitoring cho production application:

Resources to monitor:
- Lambda functions: error rate, duration, throttles
- DynamoDB: consumed capacity, throttled requests
- API Gateway: 4xx/5xx errors, latency
- ALB: target health, response time

Create:
1. CloudWatch dashboard với key metrics
2. Alarms cho critical issues:
   - Lambda error rate > 5%
   - DynamoDB throttling
   - API Gateway 5xx errors > 1%
   - ALB unhealthy targets
3. SNS topic cho notifications
4. Log groups với retention policy
```

**Expected outcome**:
```
✅ Monitoring Setup Complete

Dashboard: production-monitoring
- 12 widgets created
- Real-time metrics visualization

Alarms created (6):
1. lambda-high-error-rate (Threshold: 5%)
2. lambda-high-duration (Threshold: 3000ms)
3. dynamodb-throttled-requests
4. api-gateway-5xx-errors
5. alb-unhealthy-targets
6. alb-high-response-time (Threshold: 500ms)

SNS Topic: production-alerts
- Email: ops-team@company.com
- Subscribed and confirmed

Log Groups:
- /aws/lambda/* (Retention: 30 days)
- /aws/apigateway/* (Retention: 14 days)
- /aws/rds/* (Retention: 7 days)
```

---

## 6. Container Orchestration

### Use Case: Deploy microservices to EKS

**MCP Servers used**:
- aws-eks-mcp-server
- aws-api-mcp-server

**Claude prompt**:
```
Deploy microservices application to EKS:

Cluster setup:
- EKS version: 1.28
- Region: us-east-1
- Node group: t3.medium (min: 3, max: 10)

Microservices:
1. frontend-service (React app)
   - Replicas: 3
   - Service type: LoadBalancer
   - Resource: 500m CPU, 512Mi memory

2. backend-api (Node.js)
   - Replicas: 5
   - Service type: ClusterIP
   - Resource: 1 CPU, 1Gi memory

3. worker-service (Python)
   - Replicas: 2
   - Service type: ClusterIP
   - Resource: 2 CPU, 2Gi memory

4. redis-cache
   - Replicas: 1
   - Service type: ClusterIP

Include:
- Horizontal Pod Autoscaling
- AWS Load Balancer Controller
- Ingress configuration
- Secrets management
```

**Expected outcome**:
```
✅ EKS Cluster Deployment Complete

Cluster: production-cluster
- Status: ACTIVE
- Version: 1.28
- Endpoint: https://XXX.eks.amazonaws.com
- Node group: 3 nodes running

Deployed Microservices:

1. frontend-service
   - Pods: 3/3 Ready
   - LoadBalancer: http://xxx.us-east-1.elb.amazonaws.com
   - Health: ✓

2. backend-api
   - Pods: 5/5 Ready
   - Internal DNS: backend-api.default.svc.cluster.local
   - Health: ✓

3. worker-service
   - Pods: 2/2 Ready
   - Health: ✓

4. redis-cache
   - Pods: 1/1 Ready
   - Health: ✓

Autoscaling:
- frontend: CPU > 70% → Scale up to 6
- backend-api: CPU > 80% → Scale up to 10

Ingress:
- Host: app.company.com
- Paths:
  - / → frontend-service
  - /api → backend-api

kubectl configured: ✓
Deployment time: ~12 minutes
```

---

## Quick Prompts Cheat Sheet

### Infrastructure
```
"Deploy VPC with public and private subnets"
"Create RDS PostgreSQL database with read replica"
"Setup NAT Gateway for private subnets"
```

### Serverless
```
"Create Lambda function triggered by S3 upload"
"Deploy serverless GraphQL API with AppSync"
"Setup Step Functions workflow for ETL"
```

### Databases
```
"Create DynamoDB table with auto-scaling"
"Query DynamoDB by GSI"
"Setup DynamoDB streams"
```

### Monitoring
```
"Show CloudWatch metrics for Lambda function"
"Create dashboard for EC2 monitoring"
"Setup alarm for high CPU usage"
```

### Cost
```
"Show current month AWS spending"
"Compare EC2 pricing across regions"
"Find unused resources"
```

### Containers
```
"Create EKS cluster with Fargate"
"Deploy Kubernetes deployment to EKS"
"Setup horizontal pod autoscaling"
```

---

## Tips for Effective Use

1. **Be Specific**: Include exact requirements in prompts
2. **Use Context**: Mention existing resources if relevant
3. **Request Validation**: Ask Claude to validate before deploying
4. **Incremental Changes**: Build step-by-step for complex setups
5. **Error Handling**: Request proper error handling and logging

---

*More examples coming soon! Contribute your use cases via PR.*
