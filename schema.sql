-- Login events
CREATE TABLE cloudtrail_login_events (
                                         event_time TIMESTAMP,
                                         event_name VARCHAR(255),
                                         user_identity VARCHAR(255),
                                         source_ip VARCHAR(255),
                                         error_code VARCHAR(255)
) WITH (
      'materialized' = 'true',
      'connectors' = '[{
        "transport": {
        "name": "datagen",
        "config": {
            "plan": [
            { "rate": 100,
                "fields": {
                "event_time": { "range": ["2025-03-01T09:00:00Z", "2025-03-01T10:00:00Z"], "scale": 1000 },
                "event_name": { "values": ["ConsoleLogin", "AssumeRole", "GetObject", "PutObject"] },
                "user_identity": { "values": ["anita@example.org", "dallas@example.com", "tad@example.net", "kane@example.com"] },
                "source_ip": { "values": ["130.124.161.178", "71.172.68.132", "141.157.194.96", "236.106.228.194"] },
                "error_code": { "values": ["AccessDenied", ""] }
                }
            }
            ]
        }
        }
    }]'
      );

-- potential_brute_force.
create materialized view potential_brute_force (
    source_ip,
    failed_login_count
)
as
select source_ip, COUNT(*) AS failed_login_count
from cloudtrail_login_events
where event_time >= NOW() - INTERVAL '15' minutes -- Filter by the last 15 minutes
  and event_name = 'ConsoleLogin'
  and error_code = 'AccessDenied'
group by source_ip
having count(*) > 5;   -- Threshold for brute-force (more than 5 failed attempts)


-- redpanda (kafka) output
create view redpanda_potential_brute_force (
                                            source_ip,
                                            failed_login_count
    )
        with (
        'connectors' = '[{
        "format": {
          "name": "json",
          "config": {
              "update_format": "insert_delete",
              "array": false
          }
       },
        "transport": {
            "name": "kafka_output",
            "config": {
                "topic": "potential_brute_force",
                "bootstrap.servers": "redpanda:9092"
            }
        }
    }]'
        )
as
select source_ip, failed_login_count
from potential_brute_force;

-- delta lake output
create view deltalake_potential_brute_force (
                                             source_ip,
                                             failed_login_count
    )
        with (
        'connectors' = '[{
        "transport": {
            "name": "delta_table_output",
            "config": {
                "uri": "/app/data/potential_brute_force",
                "mode": "truncate"
            }
        },
        "enable_output_buffer": true,
        "max_output_buffer_time_millis": 10000
    }]'
        )
as
select source_ip, failed_login_count
from potential_brute_force;

