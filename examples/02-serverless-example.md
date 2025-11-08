# Complete Serverless Application Example

## Project: Todo API with Authentication

### Overview

Build a production-ready serverless REST API with:
- User authentication (Cognito)
- CRUD operations for todos
- DynamoDB database
- API Gateway
- Lambda functions
- CloudWatch monitoring

### Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                        Client App                           │
└────────────┬────────────────────────────────────────────────┘
             │
             ▼
┌────────────────────────────────────────────────────────────┐
│                    Amazon Cognito                          │
│                  (Authentication)                          │
└────────────┬───────────────────────────────────────────────┘
             │
             ▼
┌────────────────────────────────────────────────────────────┐
│                   API Gateway (REST)                       │
│  ┌──────────┬──────────┬──────────┬──────────┬─────────┐  │
│  │ POST     │ GET      │ GET      │ PUT      │ DELETE  │  │
│  │ /todos   │ /todos   │ /todos/  │ /todos/  │ /todos/ │  │
│  │          │          │ {id}     │ {id}     │ {id}    │  │
│  └──────────┴──────────┴──────────┴──────────┴─────────┘  │
└────────────┬───────────────────────────────────────────────┘
             │
             ▼
┌────────────────────────────────────────────────────────────┐
│                   Lambda Functions                         │
│  ┌──────────┬──────────┬──────────┬──────────┬─────────┐  │
│  │ create   │ list     │ get      │ update   │ delete  │  │
│  │ Todo     │ Todos    │ Todo     │ Todo     │ Todo    │  │
│  └──────────┴──────────┴──────────┴──────────┴─────────┘  │
└────────────┬───────────────────────────────────────────────┘
             │
             ▼
┌────────────────────────────────────────────────────────────┐
│                     DynamoDB                               │
│                   Table: todos                             │
│             PK: userId | SK: todoId                        │
└────────────────────────────────────────────────────────────┘
```

---

## Step-by-Step Implementation

### Step 1: Setup Project

```bash
# Create project directory
mkdir todo-api
cd todo-api

# Initialize git
git init

# Create directory structure
mkdir -p lambda/{create,list,get,update,delete}
mkdir -p iac
mkdir -p tests
```

### Step 2: Ask Claude to Create DynamoDB Table

**Prompt:**
```
Create DynamoDB table for todo application:

Table name: todos
Partition key: userId (String)
Sort key: todoId (String)

Attributes:
- title (String)
- description (String)
- status (String: pending|in-progress|completed)
- priority (Number: 1-5)
- dueDate (String: ISO 8601)
- createdAt (Number: timestamp)
- updatedAt (Number: timestamp)

GSI for status queries:
- Index name: status-index
- Partition key: userId
- Sort key: status

Billing: PAY_PER_REQUEST
Encryption: AWS_OWNED_KMS_KEY
Point-in-time recovery: Enabled
```

**Expected Response:**

```python
# Claude will use aws-dynamodb-mcp-server

✅ DynamoDB table created successfully

Table Details:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Name: todos
ARN: arn:aws:dynamodb:us-east-1:123456789012:table/todos
Status: ACTIVE

Schema:
  Primary Key:
    - Partition: userId (String)
    - Sort: todoId (String)

  Global Secondary Indexes:
    1. status-index
       - Partition: userId
       - Sort: status
       - Projection: ALL

  Billing: PAY_PER_REQUEST
  Encryption: AWS_OWNED_KMS_KEY
  PITR: ENABLED

Table is ready for use!
```

### Step 3: Create Lambda Functions

#### 3.1. Create Todo Function

**Prompt:**
```
Create Lambda function for creating todos:

Function name: createTodo
Runtime: Python 3.11
Handler: lambda_function.lambda_handler
Memory: 256 MB
Timeout: 10 seconds

Environment variables:
- TABLE_NAME: todos

IAM permissions needed:
- dynamodb:PutItem on todos table
- logs:CreateLogGroup
- logs:CreateLogStream
- logs:PutLogEvents

Code should:
1. Parse request body (JSON)
2. Validate required fields (title, status)
3. Generate unique todoId (UUID)
4. Add timestamps (createdAt, updatedAt)
5. Store in DynamoDB
6. Return created todo with 201 status
7. Handle errors gracefully
```

**Generated Lambda Code:**

```python
# lambda/create/lambda_function.py

import json
import boto3
import uuid
import os
from datetime import datetime
from decimal import Decimal

# Initialize DynamoDB client
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table(os.environ['TABLE_NAME'])

def lambda_handler(event, context):
    """
    Create a new todo item

    Expected body:
    {
        "title": "string",
        "description": "string",
        "status": "pending|in-progress|completed",
        "priority": 1-5,
        "dueDate": "ISO 8601 date"
    }
    """

    try:
        # Parse request body
        body = json.loads(event.get('body', '{}'))

        # Get userId from authorizer context
        user_id = event['requestContext']['authorizer']['claims']['sub']

        # Validate required fields
        if not body.get('title'):
            return {
                'statusCode': 400,
                'headers': {
                    'Content-Type': 'application/json',
                    'Access-Control-Allow-Origin': '*'
                },
                'body': json.dumps({
                    'error': 'Missing required field: title'
                })
            }

        # Generate unique ID
        todo_id = str(uuid.uuid4())

        # Get current timestamp
        timestamp = int(datetime.now().timestamp())

        # Prepare item
        item = {
            'userId': user_id,
            'todoId': todo_id,
            'title': body['title'],
            'description': body.get('description', ''),
            'status': body.get('status', 'pending'),
            'priority': Decimal(str(body.get('priority', 3))),
            'dueDate': body.get('dueDate', ''),
            'createdAt': timestamp,
            'updatedAt': timestamp
        }

        # Store in DynamoDB
        table.put_item(Item=item)

        # Convert Decimal to int for JSON serialization
        item['priority'] = int(item['priority'])

        return {
            'statusCode': 201,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            'body': json.dumps({
                'message': 'Todo created successfully',
                'todo': item
            })
        }

    except Exception as e:
        print(f"Error: {str(e)}")
        return {
            'statusCode': 500,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            'body': json.dumps({
                'error': 'Internal server error',
                'message': str(e)
            })
        }
```

#### 3.2. List Todos Function

**Prompt:**
```
Create Lambda function to list all todos for a user:

Function name: listTodos
Runtime: Python 3.11
Memory: 256 MB

Features:
- Query by userId
- Support pagination (limit, lastEvaluatedKey)
- Filter by status (optional query parameter)
- Sort by createdAt (descending)
```

**Generated Code:**

```python
# lambda/list/lambda_function.py

import json
import boto3
import os
from boto3.dynamodb.conditions import Key
from decimal import Decimal

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table(os.environ['TABLE_NAME'])

class DecimalEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, Decimal):
            return int(obj)
        return super(DecimalEncoder, self).default(obj)

def lambda_handler(event, context):
    """
    List todos for a user with optional filtering

    Query parameters:
    - status: Filter by status
    - limit: Number of items to return (default: 50)
    - lastKey: For pagination
    """

    try:
        # Get userId from authorizer
        user_id = event['requestContext']['authorizer']['claims']['sub']

        # Get query parameters
        params = event.get('queryStringParameters', {}) or {}
        status_filter = params.get('status')
        limit = int(params.get('limit', 50))
        last_key = params.get('lastKey')

        # Build query
        if status_filter:
            # Use GSI for status filtering
            query_params = {
                'IndexName': 'status-index',
                'KeyConditionExpression': Key('userId').eq(user_id) &
                                         Key('status').eq(status_filter),
                'Limit': limit,
                'ScanIndexForward': False  # Descending order
            }
        else:
            # Query main table
            query_params = {
                'KeyConditionExpression': Key('userId').eq(user_id),
                'Limit': limit,
                'ScanIndexForward': False
            }

        # Add pagination key if provided
        if last_key:
            query_params['ExclusiveStartKey'] = json.loads(last_key)

        # Execute query
        response = table.query(**query_params)

        # Prepare response
        result = {
            'todos': response['Items'],
            'count': len(response['Items'])
        }

        # Add pagination info
        if 'LastEvaluatedKey' in response:
            result['lastEvaluatedKey'] = response['LastEvaluatedKey']
            result['hasMore'] = True
        else:
            result['hasMore'] = False

        return {
            'statusCode': 200,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            'body': json.dumps(result, cls=DecimalEncoder)
        }

    except Exception as e:
        print(f"Error: {str(e)}")
        return {
            'statusCode': 500,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            'body': json.dumps({
                'error': 'Internal server error',
                'message': str(e)
            })
        }
```

#### 3.3. Get, Update, Delete Functions

**Prompt:**
```
Create three more Lambda functions:

1. getTodo:
   - Get single todo by userId and todoId
   - Return 404 if not found

2. updateTodo:
   - Update todo attributes
   - Update 'updatedAt' timestamp
   - Return updated item

3. deleteTodo:
   - Delete todo by userId and todoId
   - Return 204 on success
```

**Generated deployment script will create all functions**

### Step 4: Setup API Gateway

**Prompt:**
```
Create API Gateway REST API for todo application:

API name: todo-api
Stage: prod

Cognito Authorizer:
- Name: CognitoAuthorizer
- User Pool: (will create)

Resources and Methods:

/todos:
  POST:
    - Integration: createTodo Lambda
    - Authorization: Cognito
  GET:
    - Integration: listTodos Lambda
    - Authorization: Cognito

/todos/{id}:
  GET:
    - Integration: getTodo Lambda
    - Authorization: Cognito
  PUT:
    - Integration: updateTodo Lambda
    - Authorization: Cognito
  DELETE:
    - Integration: deleteTodo Lambda
    - Authorization: Cognito

CORS: Enabled for all methods
Request/Response models: Define schemas
```

**Expected Output:**

```
✅ API Gateway created successfully

API Details:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Name: todo-api
ID: abc123xyz
Stage: prod

Invoke URL:
https://abc123xyz.execute-api.us-east-1.amazonaws.com/prod

Endpoints:
  POST   /todos           → createTodo
  GET    /todos           → listTodos
  GET    /todos/{id}      → getTodo
  PUT    /todos/{id}      → updateTodo
  DELETE /todos/{id}      → deleteTodo

Authorization: Cognito User Pool
CORS: Enabled
```

### Step 5: Setup Cognito Authentication

**Prompt:**
```
Create Cognito User Pool for authentication:

User Pool name: todo-users
Sign-in: Email
Password policy:
  - Minimum length: 8
  - Require uppercase: Yes
  - Require lowercase: Yes
  - Require numbers: Yes
  - Require symbols: Yes

MFA: Optional
Email verification: Required

App client:
  - Name: todo-web-client
  - Generate secret: No
  - Auth flows: USER_PASSWORD_AUTH

Domain: todo-app-{random}
```

### Step 6: Deploy and Test

```bash
# Package Lambda functions
cd lambda/create
zip -r ../../create-function.zip .

# Deploy using AWS CLI or let Claude use MCP servers

# Test the API
```

**Testing with curl:**

```bash
# 1. Register user
curl -X POST https://cognito-idp.us-east-1.amazonaws.com/ \
  -H "X-Amz-Target: AWSCognitoIdentityProviderService.SignUp" \
  -H "Content-Type: application/x-amz-json-1.1" \
  -d '{
    "ClientId": "your-client-id",
    "Username": "user@example.com",
    "Password": "SecurePass123!",
    "UserAttributes": [
      {"Name": "email", "Value": "user@example.com"}
    ]
  }'

# 2. Confirm user (check email for code)
curl -X POST https://cognito-idp.us-east-1.amazonaws.com/ \
  -H "X-Amz-Target: AWSCognitoIdentityProviderService.ConfirmSignUp" \
  -H "Content-Type: application/x-amz-json-1.1" \
  -d '{
    "ClientId": "your-client-id",
    "Username": "user@example.com",
    "ConfirmationCode": "123456"
  }'

# 3. Login
TOKEN=$(curl -X POST https://cognito-idp.us-east-1.amazonaws.com/ \
  -H "X-Amz-Target: AWSCognitoIdentityProviderService.InitiateAuth" \
  -H "Content-Type: application/x-amz-json-1.1" \
  -d '{
    "ClientId": "your-client-id",
    "AuthFlow": "USER_PASSWORD_AUTH",
    "AuthParameters": {
      "USERNAME": "user@example.com",
      "PASSWORD": "SecurePass123!"
    }
  }' | jq -r '.AuthenticationResult.IdToken')

# 4. Create todo
curl -X POST https://abc123xyz.execute-api.us-east-1.amazonaws.com/prod/todos \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Complete AWS MCP tutorial",
    "description": "Learn all about AWS MCP servers",
    "status": "in-progress",
    "priority": 5,
    "dueDate": "2025-12-31T23:59:59Z"
  }'

# Expected response:
{
  "message": "Todo created successfully",
  "todo": {
    "userId": "user-sub-id",
    "todoId": "550e8400-e29b-41d4-a716-446655440000",
    "title": "Complete AWS MCP tutorial",
    "description": "Learn all about AWS MCP servers",
    "status": "in-progress",
    "priority": 5,
    "dueDate": "2025-12-31T23:59:59Z",
    "createdAt": 1704067200,
    "updatedAt": 1704067200
  }
}

# 5. List todos
curl -X GET "https://abc123xyz.execute-api.us-east-1.amazonaws.com/prod/todos?status=in-progress&limit=10" \
  -H "Authorization: Bearer $TOKEN"

# 6. Get specific todo
curl -X GET https://abc123xyz.execute-api.us-east-1.amazonaws.com/prod/todos/550e8400-e29b-41d4-a716-446655440000 \
  -H "Authorization: Bearer $TOKEN"

# 7. Update todo
curl -X PUT https://abc123xyz.execute-api.us-east-1.amazonaws.com/prod/todos/550e8400-e29b-41d4-a716-446655440000 \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "status": "completed"
  }'

# 8. Delete todo
curl -X DELETE https://abc123xyz.execute-api.us-east-1.amazonaws.com/prod/todos/550e8400-e29b-41d4-a716-446655440000 \
  -H "Authorization: Bearer $TOKEN"
```

### Step 7: Add Monitoring

**Prompt:**
```
Setup CloudWatch monitoring for the todo API:

Metrics to track:
- Lambda invocations (all functions)
- Lambda errors
- Lambda duration
- API Gateway 4xx errors
- API Gateway 5xx errors
- API Gateway latency
- DynamoDB consumed capacity

Create alarms for:
- Lambda error rate > 5%
- API Gateway 5xx rate > 1%
- API Gateway p99 latency > 1000ms

Create dashboard: todo-api-monitoring
SNS topic for alerts: todo-api-alerts
```

### Step 8: Cost Estimation

**Prompt:**
```
Calculate monthly cost estimation for:
- 1 million API requests
- Average 5 Lambda invocations per request
- Lambda: 256MB, 200ms average duration
- DynamoDB: 1M reads, 500K writes
- Cognito: 10K active users
```

**Expected Response:**

```
💰 Monthly Cost Estimation
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

API Gateway:
  Requests: 1,000,000
  Cost: $3.50

Lambda:
  Invocations: 5,000,000
  Duration: 200ms avg, 256MB
  GB-seconds: 250,000
  Cost: $3.75 (includes free tier)

DynamoDB:
  Read requests: 1,000,000
  Write requests: 500,000
  Storage: ~1GB
  Cost: $2.75

Cognito:
  MAU: 10,000
  Cost: $275.00 (after 50K free)

CloudWatch:
  Metrics: Standard
  Logs: ~10GB
  Cost: $5.00

Data Transfer:
  Out: ~50GB
  Cost: $4.50

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Total Estimated Cost: ~$294.50/month

Optimization opportunities:
- Use DynamoDB on-demand pricing
- Implement caching (API Gateway/CloudFront)
- Optimize Lambda memory allocation
```

---

## Complete Deployment Script

Save as `deploy.sh`:

```bash
#!/bin/bash

set -e

echo "🚀 Deploying Todo API"
echo "===================="

# Variables
STACK_NAME="todo-api-stack"
REGION="us-east-1"

# Deploy using AWS SAM or ask Claude:
claude << EOF
Deploy the complete todo API stack we discussed:
1. DynamoDB table
2. All 5 Lambda functions
3. API Gateway with Cognito auth
4. CloudWatch monitoring
5. Output the API endpoint and Cognito details
EOF

echo "✅ Deployment complete!"
```

---

## Repository Structure

```
todo-api/
├── lambda/
│   ├── create/
│   │   ├── lambda_function.py
│   │   └── requirements.txt
│   ├── list/
│   │   ├── lambda_function.py
│   │   └── requirements.txt
│   ├── get/
│   │   └── lambda_function.py
│   ├── update/
│   │   └── lambda_function.py
│   └── delete/
│       └── lambda_function.py
├── tests/
│   ├── test_create.py
│   ├── test_list.py
│   └── integration_test.py
├── iac/
│   ├── cloudformation.yaml
│   └── sam-template.yaml
├── docs/
│   ├── api-spec.yaml
│   └── postman-collection.json
├── .env.example
├── deploy.sh
├── test.sh
└── README.md
```

---

**Next**: See `03-infrastructure-example.md` for full infrastructure deployment with VPC, ALB, and Auto Scaling!
