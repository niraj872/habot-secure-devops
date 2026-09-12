# Data Flow

1. A student onboarding JSON payload enters the Django REST Framework endpoint.
2. The serializer enforces the JSON schema limits and strict Boolean types.
3. Binary Yes/No logic evaluates the deterministic onboarding rules.
4. Accepted transactional events are wrapped in the documented streaming event envelope and published to the onboarding Pub/Sub topic.
5. The Pub/Sub subscription writes schema-conformant messages to the raw BigQuery landing table.
6. The D1 Staged/Enforced student table is protected by table IAM and BigQuery row-level security.
7. Failed streaming delivery is retained by the dead-letter topic for operational investigation.

The Pub/Sub to BigQuery subscription uses the declared BigQuery table schema. This makes the streaming contract explicit rather than allowing an untyped downstream payload to silently change analytics structure.

The streaming event envelope is defined in `data/pubsub_event_schema.json`. Its fields map one-to-one to the raw BigQuery streaming table: `event_id`, `payload`, and `published_at`.
