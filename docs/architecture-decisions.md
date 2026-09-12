# Architecture Decisions

## App Engine

The assessment explicitly evaluates secure App Engine and database provisioning. The project therefore includes a Terraform App Engine application resource. It is disabled by default because Google Cloud permits only one App Engine application per project. Enable it only during initial bootstrap of a project that does not already have an App Engine application.

## Pub/Sub and BigQuery streaming

The project provisions an onboarding Pub/Sub topic, a schema-conformant BigQuery streaming subscription, and a dead-letter topic. The raw streaming table is deliberately separate from the enforced analytics table so that ingestion and analytics access controls remain independently testable.

## Workload Identity Federation

GitHub Actions authenticates through OpenID Connect Workload Identity Federation. The identity provider is restricted to the exact repository and main branch or tag references. This avoids long-lived service-account keys.

## Terraform state

The main stack uses a Google Cloud Storage backend. A separate bootstrap stack creates the state bucket before the main stack is initialized in continuous integration or deployment.

## Least privilege

Runtime identities are separated by purpose. The deployment identity uses a dedicated project custom role rather than project Owner or Editor. Data, backend, analytics, and streaming writer identities receive narrower resource-specific permissions.
