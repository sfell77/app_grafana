# app_grafana
Grafana deployment configuration leveraging a basic HA architecture (not application) strategy.

If this was a completely HA strategy, the the minimum design would be:
- multiple Grafana instances running in each region (use containers/Fargate and never have to manage EC2s)
- RDS backend (replicated to another region) to ensure data retention and centralization amongst numerous running instances
- Route53 entrypoint with failover to alternate region (active/passive) or if you are more geographically diverse, active/active with geolocation routing
