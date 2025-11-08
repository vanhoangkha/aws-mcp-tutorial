# Complete Infrastructure Deployment with AWS CDK

## Project: Production Web Application Infrastructure

### Architecture Overview

```
┌──────────────────────────────────────────────────────────────────┐
│                          Internet                                 │
└───────────────────┬──────────────────────────────────────────────┘
                    │
                    ▼
┌────────────────────────────────────────────────────────────────┐
│                   Route 53 (DNS)                               │
│                app.example.com                                 │
└────────────────┬───────────────────────────────────────────────┘
                 │
                 ▼
┌────────────────────────────────────────────────────────────────┐
│                Application Load Balancer                       │
│                     (Public Subnets)                           │
└────────┬───────────────────────────────────────────┬───────────┘
         │                                           │
    ┌────▼────┐                                 ┌────▼────┐
    │  AZ-1   │                                 │  AZ-2   │
    │         │                                 │         │
    └────┬────┘                                 └────┬────┘
         │                                           │
┌────────▼───────────────────────────────────────────▼───────────┐
│                 Auto Scaling Group                             │
│              (Private Subnets)                                 │
│                                                                │
│   ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌─────────┐        │
│   │  EC2    │  │  EC2    │  │  EC2    │  │  EC2    │        │
│   │Instance │  │Instance │  │Instance │  │Instance │        │
│   └────┬────┘  └────┬────┘  └────┬────┘  └────┬────┘        │
└────────┼───────────┼─────────────┼─────────────┼─────────────┘
         │           │             │             │
         └───────────┴─────────────┴─────────────┘
                           │
                           ▼
┌──────────────────────────────────────────────────────────────────┐
│                        RDS (Multi-AZ)                            │
│                  PostgreSQL 15.x                                 │
│                  (Private Subnets)                               │
└──────────────────────────────────────────────────────────────────┘
```

---

## Step 1: Project Setup

```bash
# Create project directory
mkdir web-app-infrastructure
cd web-app-infrastructure

# Initialize CDK project
npx cdk init app --language=typescript

# Install dependencies
npm install @aws-cdk/aws-ec2 \
           @aws-cdk/aws-rds \
           @aws-cdk/aws-elbv2 \
           @aws-cdk/aws-autoscaling \
           @aws-cdk/aws-route53 \
           @aws-cdk/aws-certificatemanager
```

---

## Step 2: Ask Claude to Generate CDK Code

**Prompt:**
```
Create AWS CDK stack for production web application:

Stack name: WebAppInfrastructure

Components:

1. VPC:
   - CIDR: 10.0.0.0/16
   - 2 Availability Zones
   - Public subnets: 10.0.0.0/24, 10.0.1.0/24
   - Private subnets: 10.0.100.0/24, 10.0.101.0/24
   - NAT Gateways: 2 (one per AZ)
   - VPC Endpoints: S3, DynamoDB

2. Security Groups:
   - ALB: Allow 80, 443 from 0.0.0.0/0
   - Web servers: Allow 3000 from ALB only
   - RDS: Allow 5432 from web servers only

3. Application Load Balancer:
   - Internet-facing
   - Health check: /health
   - Stickiness: enabled
   - Deletion protection: enabled

4. Auto Scaling Group:
   - Instance type: t3.medium
   - Min: 2, Max: 10, Desired: 4
   - Health check: ELB
   - Scaling policies:
     * Scale up: CPU > 70%
     * Scale down: CPU < 30%

5. RDS PostgreSQL:
   - Engine: PostgreSQL 15.x
   - Instance: db.t3.medium
   - Multi-AZ: enabled
   - Storage: 100GB gp3
   - Automated backups: 7 days
   - Deletion protection: enabled

6. Outputs:
   - ALB DNS name
   - RDS endpoint
   - VPC ID
```

**Generated CDK Code:**

```typescript
// lib/web-app-infrastructure-stack.ts

import * as cdk from 'aws-cdk-lib';
import * as ec2 from 'aws-cdk-lib/aws-ec2';
import * as elbv2 from 'aws-cdk-lib/aws-elasticloadbalancingv2';
import * as autoscaling from 'aws-cdk-lib/aws-autoscaling';
import * as rds from 'aws-cdk-lib/aws-rds';
import { Construct } from 'constructs';

export class WebAppInfrastructureStack extends cdk.Stack {
  constructor(scope: Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    // 1. VPC
    const vpc = new ec2.Vpc(this, 'WebAppVPC', {
      ipAddresses: ec2.IpAddresses.cidr('10.0.0.0/16'),
      maxAzs: 2,
      natGateways: 2,
      subnetConfiguration: [
        {
          cidrMask: 24,
          name: 'Public',
          subnetType: ec2.SubnetType.PUBLIC,
        },
        {
          cidrMask: 24,
          name: 'Private',
          subnetType: ec2.SubnetType.PRIVATE_WITH_EGRESS,
        },
      ],
      gatewayEndpoints: {
        S3: {
          service: ec2.GatewayVpcEndpointAwsService.S3,
        },
        DynamoDB: {
          service: ec2.GatewayVpcEndpointAwsService.DYNAMODB,
        },
      },
    });

    // 2. Security Groups

    // ALB Security Group
    const albSecurityGroup = new ec2.SecurityGroup(this, 'ALBSecurityGroup', {
      vpc,
      description: 'Security group for Application Load Balancer',
      allowAllOutbound: true,
    });

    albSecurityGroup.addIngressRule(
      ec2.Peer.anyIpv4(),
      ec2.Port.tcp(80),
      'Allow HTTP traffic'
    );

    albSecurityGroup.addIngressRule(
      ec2.Peer.anyIpv4(),
      ec2.Port.tcp(443),
      'Allow HTTPS traffic'
    );

    // Web Server Security Group
    const webServerSecurityGroup = new ec2.SecurityGroup(this, 'WebServerSecurityGroup', {
      vpc,
      description: 'Security group for web servers',
      allowAllOutbound: true,
    });

    webServerSecurityGroup.addIngressRule(
      albSecurityGroup,
      ec2.Port.tcp(3000),
      'Allow traffic from ALB'
    );

    // RDS Security Group
    const rdsSecurityGroup = new ec2.SecurityGroup(this, 'RDSSecurityGroup', {
      vpc,
      description: 'Security group for RDS database',
      allowAllOutbound: false,
    });

    rdsSecurityGroup.addIngressRule(
      webServerSecurityGroup,
      ec2.Port.tcp(5432),
      'Allow PostgreSQL from web servers'
    );

    // 3. Application Load Balancer
    const alb = new elbv2.ApplicationLoadBalancer(this, 'WebAppALB', {
      vpc,
      internetFacing: true,
      securityGroup: albSecurityGroup,
      deletionProtection: true,
    });

    const listener = alb.addListener('HttpListener', {
      port: 80,
      open: true,
    });

    // 4. Auto Scaling Group

    // User data script
    const userData = ec2.UserData.forLinux();
    userData.addCommands(
      '#!/bin/bash',
      'yum update -y',
      'yum install -y docker',
      'service docker start',
      'usermod -a -G docker ec2-user',

      '# Pull and run application',
      'docker pull your-app-image:latest',
      'docker run -d -p 3000:3000 \\',
      '  -e DATABASE_HOST=$DATABASE_HOST \\',
      '  -e DATABASE_NAME=$DATABASE_NAME \\',
      '  your-app-image:latest',

      '# Configure CloudWatch agent',
      'wget https://s3.amazonaws.com/amazoncloudwatch-agent/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm',
      'rpm -U ./amazon-cloudwatch-agent.rpm',

      '# Install CodeDeploy agent',
      'yum install -y ruby',
      'cd /home/ec2-user',
      'wget https://aws-codedeploy-us-east-1.s3.us-east-1.amazonaws.com/latest/install',
      'chmod +x ./install',
      './install auto'
    );

    const asg = new autoscaling.AutoScalingGroup(this, 'WebAppASG', {
      vpc,
      instanceType: ec2.InstanceType.of(
        ec2.InstanceClass.T3,
        ec2.InstanceSize.MEDIUM
      ),
      machineImage: ec2.MachineImage.latestAmazonLinux2(),
      minCapacity: 2,
      maxCapacity: 10,
      desiredCapacity: 4,
      securityGroup: webServerSecurityGroup,
      userData,
      healthCheck: autoscaling.HealthCheck.elb({
        grace: cdk.Duration.seconds(300),
      }),
      updatePolicy: autoscaling.UpdatePolicy.rollingUpdate({
        maxBatchSize: 2,
        minInstancesInService: 2,
        pauseTime: cdk.Duration.minutes(5),
      }),
    });

    // Configure scaling policies
    asg.scaleOnCpuUtilization('CPUScaling', {
      targetUtilizationPercent: 70,
      cooldown: cdk.Duration.minutes(5),
    });

    // Add target group
    const targetGroup = listener.addTargets('WebAppTarget', {
      port: 3000,
      protocol: elbv2.ApplicationProtocol.HTTP,
      targets: [asg],
      healthCheck: {
        path: '/health',
        interval: cdk.Duration.seconds(30),
        timeout: cdk.Duration.seconds(5),
        healthyThresholdCount: 2,
        unhealthyThresholdCount: 3,
      },
      stickinessCookieDuration: cdk.Duration.hours(1),
      deregistrationDelay: cdk.Duration.seconds(30),
    });

    // 5. RDS Database
    const dbInstance = new rds.DatabaseInstance(this, 'WebAppDatabase', {
      engine: rds.DatabaseInstanceEngine.postgres({
        version: rds.PostgresEngineVersion.VER_15_3,
      }),
      instanceType: ec2.InstanceType.of(
        ec2.InstanceClass.T3,
        ec2.InstanceSize.MEDIUM
      ),
      vpc,
      vpcSubnets: {
        subnetType: ec2.SubnetType.PRIVATE_WITH_EGRESS,
      },
      securityGroups: [rdsSecurityGroup],
      multiAz: true,
      allocatedStorage: 100,
      storageType: rds.StorageType.GP3,
      deletionProtection: true,
      backupRetention: cdk.Duration.days(7),
      preferredBackupWindow: '03:00-04:00',
      preferredMaintenanceWindow: 'sun:04:00-sun:05:00',
      databaseName: 'webapp',
      credentials: rds.Credentials.fromGeneratedSecret('admin', {
        secretName: 'webapp-db-credentials',
      }),
      monitoringInterval: cdk.Duration.seconds(60),
      enablePerformanceInsights: true,
      performanceInsightRetention: rds.PerformanceInsightRetention.DEFAULT,
      cloudwatchLogsExports: ['postgresql'],
    });

    // 6. CloudWatch Alarms

    // ALB target unhealthy alarm
    const albTargetUnhealthyAlarm = new cdk.aws_cloudwatch.Alarm(this, 'ALBTargetUnhealthyAlarm', {
      metric: targetGroup.metricUnhealthyHostCount(),
      threshold: 1,
      evaluationPeriods: 2,
      alarmDescription: 'Alert when ALB has unhealthy targets',
    });

    // ASG CPU alarm
    const asgCPUAlarm = new cdk.aws_cloudwatch.Alarm(this, 'ASGHighCPUAlarm', {
      metric: asg.metricCPUUtilization(),
      threshold: 80,
      evaluationPeriods: 2,
      alarmDescription: 'Alert when ASG CPU > 80%',
    });

    // RDS CPU alarm
    const rdsCPUAlarm = new cdk.aws_cloudwatch.Alarm(this, 'RDSHighCPUAlarm', {
      metric: dbInstance.metricCPUUtilization(),
      threshold: 80,
      evaluationPeriods: 2,
      alarmDescription: 'Alert when RDS CPU > 80%',
    });

    // 7. Outputs
    new cdk.CfnOutput(this, 'LoadBalancerDNS', {
      value: alb.loadBalancerDnsName,
      description: 'Application Load Balancer DNS name',
      exportName: 'ALBDNSName',
    });

    new cdk.CfnOutput(this, 'DatabaseEndpoint', {
      value: dbInstance.dbInstanceEndpointAddress,
      description: 'RDS database endpoint',
      exportName: 'DBEndpoint',
    });

    new cdk.CfnOutput(this, 'DatabaseSecretArn', {
      value: dbInstance.secret!.secretArn,
      description: 'RDS credentials secret ARN',
      exportName: 'DBSecretArn',
    });

    new cdk.CfnOutput(this, 'VpcId', {
      value: vpc.vpcId,
      description: 'VPC ID',
      exportName: 'VpcId',
    });

    // Tags
    cdk.Tags.of(this).add('Project', 'WebApp');
    cdk.Tags.of(this).add('Environment', 'Production');
    cdk.Tags.of(this).add('ManagedBy', 'CDK');
  }
}
```

---

## Step 3: Deploy Infrastructure

```bash
# Bootstrap CDK (first time only)
npx cdk bootstrap aws://ACCOUNT-ID/us-east-1

# Synthesize CloudFormation template
npx cdk synth

# Review changes
npx cdk diff

# Deploy
npx cdk deploy

# Expected output:
✅  WebAppInfrastructureStack

Outputs:
WebAppInfrastructureStack.LoadBalancerDNS = webapp-alb-123456789.us-east-1.elb.amazonaws.com
WebAppInfrastructureStack.DatabaseEndpoint = webapp-db.c9akciq32.us-east-1.rds.amazonaws.com
WebAppInfrastructureStack.DatabaseSecretArn = arn:aws:secretsmanager:us-east-1:123456789012:secret:webapp-db-credentials-AbCdEf
WebAppInfrastructureStack.VpcId = vpc-0123456789abcdef0

Stack ARN:
arn:aws:cloudformation:us-east-1:123456789012:stack/WebAppInfrastructureStack/12345678-1234-1234-1234-123456789012
```

---

## Step 4: Post-Deployment Configuration

### 4.1. Retrieve Database Credentials

```bash
# Get database credentials from Secrets Manager
aws secretsmanager get-secret-value \
  --secret-id webapp-db-credentials \
  --query SecretString \
  --output text | jq '.'

# Output:
{
  "username": "admin",
  "password": "GeneratedSecurePassword123!",
  "engine": "postgres",
  "host": "webapp-db.c9akciq32.us-east-1.rds.amazonaws.com",
  "port": 5432,
  "dbname": "webapp"
}
```

### 4.2. Test Database Connection

```bash
# Install PostgreSQL client
sudo yum install -y postgresql15

# Connect to database
psql -h webapp-db.c9akciq32.us-east-1.rds.amazonaws.com \
     -U admin \
     -d webapp

# Once connected, create schema
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    name VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_users_email ON users(email);
```

### 4.3. Update Application Configuration

```bash
# Store database config in Parameter Store
aws ssm put-parameter \
  --name /webapp/database/host \
  --value "webapp-db.c9akciq32.us-east-1.rds.amazonaws.com" \
  --type String

aws ssm put-parameter \
  --name /webapp/database/name \
  --value "webapp" \
  --type String

# Update ASG launch template to use these parameters
```

---

## Step 5: Setup Monitoring Dashboard

**Prompt to Claude:**
```
Create CloudWatch dashboard for the web application:

Dashboard name: WebApp-Production

Widgets:

Row 1: ALB Metrics
- ALB request count (sum, 5min)
- ALB target response time (p50, p90, p99)
- ALB HTTP 4xx errors
- ALB HTTP 5xx errors

Row 2: Auto Scaling Metrics
- ASG instance count
- ASG CPU utilization (average, max)
- ASG network in/out

Row 3: RDS Metrics
- RDS CPU utilization
- RDS database connections
- RDS read/write IOPS
- RDS freeable memory

Row 4: Custom Application Metrics
- Request duration
- Active users
- Error rate
```

---

## Step 6: Cost Analysis

**Prompt to Claude:**
```
Calculate monthly cost for this infrastructure:

Resources:
- ALB: 1 instance
- EC2: 4 x t3.medium (average)
- NAT Gateway: 2 instances
- RDS: 1 x db.t3.medium (Multi-AZ)
- Data transfer: 500 GB/month
- CloudWatch: Standard metrics + logs (10GB)

Region: us-east-1
```

**Expected Response:**

```
💰 Monthly Cost Breakdown
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Compute:
├─ EC2 Instances (4 x t3.medium)
│  └─ 4 × $30.37 = $121.48
├─ ALB
│  ├─ Hour charge: $16.20
│  └─ LCU charge: ~$18.00
│  └─ Total: $34.20
└─ NAT Gateway (2)
   ├─ Hour charge: $65.70
   └─ Data: ~$45.00
   └─ Total: $110.70

Database:
└─ RDS (db.t3.medium Multi-AZ)
   ├─ Instance: $121.44
   ├─ Storage (100GB gp3): $23.00
   └─ Backup storage: ~$10.00
   └─ Total: $154.44

Networking:
├─ Data transfer out: $45.00
└─ VPC endpoints: $14.60

Monitoring:
└─ CloudWatch
   ├─ Metrics: $3.00
   ├─ Alarms: $1.00
   └─ Logs (10GB): $5.00
   └─ Total: $9.00

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Total Monthly Cost: ~$489.42

💡 Optimization Opportunities:
1. Use Reserved Instances (-40%): Save ~$97/month
2. Use Savings Plans: Save ~$85/month
3. Single NAT Gateway: Save $65/month
4. RDS Reserved Instance: Save ~$50/month

Potential Optimized Cost: ~$292/month (-40%)
```

---

## Step 7: Destroy Infrastructure (when needed)

```bash
# WARNING: This will delete all resources!

# Disable deletion protection first
aws rds modify-db-instance \
  --db-instance-identifier webapp-db \
  --no-deletion-protection

aws elbv2 modify-load-balancer-attributes \
  --load-balancer-arn <alb-arn> \
  --attributes Key=deletion_protection.enabled,Value=false

# Destroy stack
npx cdk destroy

# Confirm when prompted
```

---

## Complete Project Structure

```
web-app-infrastructure/
├── bin/
│   └── web-app-infrastructure.ts
├── lib/
│   ├── web-app-infrastructure-stack.ts
│   ├── vpc-stack.ts
│   ├── compute-stack.ts
│   └── database-stack.ts
├── test/
│   └── web-app-infrastructure.test.ts
├── cdk.json
├── tsconfig.json
├── package.json
└── README.md
```

---

**Next**: See `04-database-example.md` for advanced DynamoDB operations!
