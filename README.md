````
# 🌍 Multi-Environment Terraform Project with CI/CD

This project provides a modular and environment-driven Terraform setup for managing Azure infrastructure, including:

- Multiple environments: `dev`, `test`, `preprod`, and `prod`
- Modular resource definitions
- Conditional deployments
- GitHub Actions CI/CD pipeline with manual approval & environment selection
- Remote state backend support (per environment)

---

## 📁 Project Structure

```bash
terraform/
├── .github/workflows/         # GitHub Actions pipeline
│   └── terraform.yml
├── backend/                   # Backend configs (per env)
│   ├── dev.backend
│   ├── test.backend
│   ├── preprod.backend
│   └── prod.backend
├── environments/              # Variable files (per env)
│   ├── dev.tfvars
│   ├── test.tfvars
│   ├── preprod.tfvars
│   └── prod.tfvars
├── modules/                   # Reusable Terraform modules
│   ├── rg/                    # Resource group module
│   └── storage_account/       # Storage account module
├── main.tf                    # Root module composition
├── variables.tf               # Input variable declarations
└── outputs.tf                 # Output values
````

````

---

## 🛠️ What It Deploys

- **All environments**: Resource Group
- **Only `test` and `prod`**: Azure Storage Account (conditionally using a variable)

---

## ⚙️ How to Use Locally

```bash
cd terraform
terraform init -backend-config="backend/dev.backend"
terraform plan -var-file="environments/dev.tfvars"
terraform apply -var-file="environments/dev.tfvars"
```

---

## 🔁 GitHub Actions CI/CD

### 🔐 Secrets Required

You must configure the following GitHub Secrets in your repository:

- `ARM_CLIENT_ID`
- `ARM_CLIENT_SECRET`
- `ARM_SUBSCRIPTION_ID`
- `ARM_TENANT_ID`

### ✅ Behavior Matrix

| Trigger              | Init | Plan | Apply | Manual? | Approval?     |
| -------------------- | ---- | ---- | ----- | ------- | ------------- |
| Push to `dev`        | ✅   | ✅   | ✅    | No      | No            |
| Push to `test`       | ✅   | ✅   | ❌    | No      | -             |
| Push to `preprod`    | ✅   | ✅   | ❌    | No      | -             |
| Push to `prod`       | ✅   | ✅   | ❌    | No      | -             |
| Manual Dispatch (UI) | ✅   | ✅   | ✅    | Yes     | Yes (non-dev) |

---

## 🚀 Manual Deployment from GitHub UI

You can manually trigger a deployment using GitHub’s **workflow dispatch**:

1. Go to **Actions → Terraform CI/CD → Run workflow**
2. Select an environment (`dev`, `test`, `preprod`, or `prod`)
3. Click **Run workflow**

> 🚨 **Only deploys from the `main` branch**
> 🔒 **Requires manual approval** for `test`, `preprod`, and `prod`

---

```

````
