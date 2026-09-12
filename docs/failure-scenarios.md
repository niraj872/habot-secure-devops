# Failure Scenarios

| Scenario | Detection | Deployment |
|---|---|---|
| Terraform formatting error | `terraform fmt -check` | Blocked |
| Terraform validation error | `terraform validate` | Blocked |
| Hardcoded secret | Gitleaks | Blocked |
| Python lint failure | Ruff | Blocked |
| Unit test failure | Django tests | Blocked |
| Schema mismatch | JSON Schema test / serializer | Data rejected |
| Missing required field | DRF serializer | Request rejected |
| Invalid Boolean / Yes-No value | DRF + DCYN | Request rejected |
| Unauthorized GCP access | IAM | Access denied |
| Unauthorized BigQuery row | RLS | Row not visible |

The operating principle is:

**FAILURE → STOP → NO DEPLOYMENT**
