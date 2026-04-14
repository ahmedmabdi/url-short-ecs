# 🔗 URL Shortener — Production AWS Deployment

> A production-grade URL shortener built with FastAPI, deployed on AWS ECS Fargate using a full CI/CD pipeline with blue/green deployments via GitHub Actions and AWS CodeDeploy.


---

## Homepage

![Homepage](docs/screenshots/homepage.png)

> The homepage provides a clean interface to shorten URLs, a curl API reference, and links to the GitHub repository.

---

## What Is This?

A URL shortener REST API that accepts a long URL, hashes it using SHA-256 (8-character ID), stores the mapping in DynamoDB, and issues a redirect when the short link is visited.

**Core API:**

```bash
# Shorten a URL
curl -X POST https://ahmedumami.click/shorten \
  -H "Content-Type: application/json" \
  -d '{"url": "https://your-long-url.com/example"}'

# Response
{ "short": "a3f9b1c2", "url": "https://your-long-url.com/example" }

# Visit short link — issues 307 redirect
curl -L https://ahmedumami.click/a3f9b1c2

# Health check
curl https://ahmedumami.click/healthz
```

---

## Architecture

> *(Insert architecture diagram here — recommended tool: [draw.io](https://draw.io) or [Excalidraw](https://excalidraw.com))*

**High-level flow:**

```
User → Route 53 → CloudFront → ALB (HTTPS:443) → ECS Fargate → DynamoDB
                                     ↑
                              WAF (rate limiting + managed rules)
```

**Blue/Green deployment flow:**

```
GitHub Push → GitHub Actions → ECR (new image) → CodeDeploy
                                                      ↓
                                          New task on test TG (port 8081)
                                                      ↓
                                          Health check passes
                                                      ↓
                                          Traffic shifts to prod TG (port 443)
                                                      ↓
                                          Old task drained and terminated
```

---

## AWS Services Used

| Service | Purpose |
|---|---|
| **ECS Fargate** | Runs containerised FastAPI app — serverless compute, no EC2 management |
| **ECR** | Stores Docker images per environment, tagged by git SHA |
| **ALB** | Application Load Balancer — HTTPS termination, health checks, blue/green listener switching |
| **DynamoDB** | Serverless key-value store for URL mappings (`id` → `url`) |
| **Route 53** | DNS hosting — A record aliased to ALB |
| **ACM** | TLS certificates for `ahmedumami.click` (ALB) and CloudFront (us-east-1) |
| **CloudFront** | CDN — caches and accelerates global traffic, HTTPS enforcement |
| **WAF** | Web Application Firewall — AWS managed rules + IP-based rate limiting (1000 req/IP) |
| **CodeDeploy** | Orchestrates blue/green ECS deployments with automatic rollback on failure |
| **CloudWatch** | Log groups per environment, CPU-based auto-scaling alarms, ECS Container Insights |
| **IAM** | Least-privilege roles — separate execution role (ECR/CloudWatch) and task role (DynamoDB only) |
| **VPC** | Isolated network — public subnets (ALB), private subnets (ECS tasks) |
| **VPC Endpoints** | Private connectivity to DynamoDB and ECR without internet traversal |
| **Security Groups** | ALB SG (80/443/8081 inbound), ECS SG (8080 from ALB only) |
| **IGW** | Internet Gateway for public subnet outbound traffic (ALB) |
| **S3** | Stores CodeDeploy AppSpec files per environment |

### VPC Design

```
VPC (10.0.0.0/16)
├── Public Subnets (3 AZs)  — ALB
│   ├── eu-west-2a
│   ├── eu-west-2b
│   └── eu-west-2c
└── Private Subnets (3 AZs) — ECS Tasks (no NAT gateway)
    ├── eu-west-2a
    ├── eu-west-2b
    └── eu-west-2c
```

> **No NAT Gateway** — ECS tasks in private subnets communicate with AWS services (DynamoDB, ECR, CloudWatch) exclusively via VPC Interface Endpoints and Gateway Endpoints. This eliminates NAT Gateway costs (~$32/month) while maintaining full network isolation.

> **VPC DHCP Options** — Custom DHCP option set configured to use AmazonProvidedDNS. This ensures that VPC Endpoint DNS resolution works correctly inside the VPC — without this, private DNS hostnames for services like `ecr.eu-west-2.amazonaws.com` would not resolve to the private endpoint IPs, breaking ECR pulls from private subnets.

### IAM — Least Privilege

Two separate roles are used, following least-privilege principles:

**ECS Execution Role** (used by the ECS agent, not the app):
- `ecr:GetAuthorizationToken`, `ecr:BatchGetImage` — pull images from ECR
- `logs:CreateLogStream`, `logs:PutLogEvents` — write to CloudWatch

**ECS Task Role** (used by the running container):
- `dynamodb:PutItem`, `dynamodb:GetItem` on the specific table ARN only — nothing else

---

## CI/CD Pipeline

### GitHub Actions — Build, Scan & Deploy

The pipeline triggers on pushes to `dev`, `staging`, or `main` branches when files in `app/**` change.

![CI/CD Pipeline](docs/screenshots/github-actions.png)

**Pipeline stages:**

```
push to main
     │
     ▼
┌─────────────────────┐
│   build-and-push    │
│  1. Checkout code   │
│  2. Detect env      │
│  3. Configure AWS   │  ← OIDC (no static credentials)
│  4. Login to ECR    │
│  5. Build image     │  ← tagged: prod-{git-sha}
│  6. Trivy scan      │  ← blocks on CRITICAL CVEs
│  7. Push to ECR     │
└─────────────────────┘
          │
          ▼
┌─────────────────────┐
│      deploy         │
│  1. Register task   │  ← new task def with new image
│  2. Upload AppSpec  │  ← to S3
│  3. Trigger CD      │  ← CodeDeploy blue/green
│  4. Wait for result │  ← fails pipeline if deploy fails
└─────────────────────┘
```

**Key design decisions:**

- **OIDC authentication** — no long-lived AWS credentials stored in GitHub Secrets. The pipeline assumes an IAM role via GitHub's OIDC provider, scoped per environment (`dev`/`staging`/`prod`).
- **Trivy image scanning** — pipeline fails on unfixed CRITICAL CVEs before any image reaches ECR.
- **Environment isolation** — separate ECR repos, IAM roles, ECS clusters, and DynamoDB tables per environment.
- **Git SHA tagging** — every image is tagged `{env}-{git-sha}` for full traceability.

### CodeDeploy — Blue/Green

![CodeDeploy](docs/screenshots/codedeploy.png)

CodeDeploy manages the actual traffic shift:

1. New ECS task starts on the **test target group** (port 8081)
2. ALB health checks run against `/healthz`
3. Once healthy, traffic shifts from blue → green on port 443
4. Old task is drained and terminated
5. If health checks fail at any point, automatic rollback to the previous task

This gives zero-downtime deployments with automatic rollback — no manual intervention required.

---

## Tech Stack

| Layer | Technology |
|---|---|
| **API** | FastAPI (Python 3.12) |
| **Container** | Docker — multi-stage build (builder + distroless-style slim runtime) |
| **Database** | AWS DynamoDB (on-demand billing) |
| **Infrastructure** | Terraform (modular — `modules/vpc`, `alb`, `ecs`, `acm`, `codedeploy`, etc.) |
| **CI/CD** | GitHub Actions + AWS CodeDeploy |
| **Security** | Trivy (image scanning), WAF, VPC Endpoints, IAM least-privilege |

---

## What Went Well

**Infrastructure as Code from the start** — all AWS resources are Terraform modules, making environments reproducible. Spinning up a new `dev` or `staging` environment requires only a variable change.

**Zero-downtime deployments** — the blue/green CodeDeploy setup with ALB listener switching means deployments are invisible to users. Rollback is automatic.

**No NAT Gateway** — using VPC Endpoints for ECR, DynamoDB, and CloudWatch eliminated a significant cost centre while improving security posture (traffic stays on the AWS backbone).

**OIDC over static credentials** — GitHub Actions authenticates to AWS via OIDC rather than storing access keys. Keys can't be leaked because they don't exist.

**Security layered at every level** — WAF at the edge, ALB in the public subnet, ECS tasks in private subnets with no public IPs, security groups restricting port 8080 to ALB only, IAM task role scoped to a single DynamoDB table.

---

## Areas for Improvement at Industry Scale

### Observability
- **Distributed tracing** — add AWS X-Ray or OpenTelemetry to trace requests end-to-end from ALB → ECS → DynamoDB. Currently only CloudWatch logs are available.
- **Structured logging** — switch from uvicorn default logs to JSON-structured logs with request IDs for better CloudWatch Insights querying.
- **Custom metrics** — emit CloudWatch metrics for shortening rate, redirect latency, and 4xx/5xx rates. Currently only ECS CPU/memory metrics exist.

### Reliability
- **DynamoDB TTL** — the schema includes a TTL attribute but it's not being set on items. Expired links should auto-delete to prevent unbounded table growth.
- **Multi-region active-active** — for true high availability, DynamoDB Global Tables + multi-region ALB with Route 53 latency-based routing would serve global users with lower latency and survive a regional failure.
- **Circuit breaker** — add retry logic with exponential backoff on DynamoDB calls. Currently a DynamoDB throttle would surface as a 500.

### Security
- **Secrets Manager** — any future credentials (API keys, tokens) should use AWS Secrets Manager with automatic rotation rather than environment variables.
- **DynamoDB encryption** — enable customer-managed KMS keys (CMK) for DynamoDB at-rest encryption rather than the default AWS-managed key.
- **ALB access logs** — enable ALB access logs to S3 for security auditing and forensics.
- **GuardDuty** — enable AWS GuardDuty for threat detection across the account.

### Performance
- **DynamoDB DAX** — add a DAX (DynamoDB Accelerator) cluster in front of DynamoDB for microsecond read latency on popular short links. Currently every redirect hits DynamoDB directly.
- **CloudFront caching** — configure CloudFront to cache redirect responses for popular short links at the edge, eliminating origin hits entirely.
- **Connection pooling** — the current boto3 client is instantiated at module load time which is fine, but under high concurrency a connection pool would reduce TLS handshake overhead.

### Operations
- **Automated rollback triggers** — configure CodeDeploy to automatically roll back on CloudWatch alarm breach (e.g. elevated 5xx rate) rather than only on health check failure.
- **Cost allocation tags** — add consistent tagging (`Environment`, `Project`, `Owner`) to all resources for cost visibility in AWS Cost Explorer.
- **Runbook** — document operational procedures: how to manually roll back a deployment, how to restore DynamoDB from PITR, how to rotate IAM credentials.

---

## Running Locally

```bash
# Set environment variables
export AWS_REGION=eu-west-2
export TABLE_NAME=urlshortener-prod-table

# Install dependencies
pip install -r app/requirements.txt

# Run
cd app/src
uvicorn main:app --reload --port 8080
```

---

## License

MIT