Here is a short, clean, production-safe Bash script to check if all Kafka topics listed in a file have zero-byte log segments in the Kafka log directory (like your screenshot).


---

✅ Script: check-topic-log-sizes.sh

Uses:

A file topics.txt containing topic names (one per line)

Kafka log directory: /data/kafka-logs/



---

✔ Script Output Example

[OK]  VICPOL_PRIMARY_HI3 log size = 0 bytes
[OK]  WAPOL_PRIMARY_HI2 log size = 0 bytes
[FAIL] random_topic log size = 104857600 bytes


---

🟦 SCRIPT

#!/bin/bash

TOPIC_FILE="topics.txt"
LOG_DIR="/data/kafka-logs"

echo "Checking Kafka topic log sizes..."
echo "----------------------------------"

while read -r topic; do
    [[ -z "$topic" ]] && continue

    # Find log directory for partition 0 (default)
    PART_DIR=$(find "$LOG_DIR" -maxdepth 1 -type d -name "${topic}-0" | head -n 1)

    if [[ -z "$PART_DIR" ]]; then
        echo "[MISS] $topic → directory not found"
        continue
    fi

    # Find all .log files and sum their sizes
    LOG_SIZE=$(find "$PART_DIR" -type f -name "*.log" -printf "%s\n" 2>/dev/null | awk '{sum+=$1} END{print sum}')

    if [[ -z "$LOG_SIZE" ]]; then
        LOG_SIZE=0
    fi

    if [[ "$LOG_SIZE" -eq 0 ]]; then
        echo "[OK]   $topic → log size = 0 bytes"
    else
        echo "[FAIL] $topic → log size = ${LOG_SIZE} bytes"
    fi

done < "$TOPIC_FILE"


---

📌 How to Use

1️⃣ Create your topics.txt

VICPOL_PRIMARY_HI3
WAPOL_PRIMARY_HI2
ANOTHER_TOPIC

2️⃣ Save script:

vi check-topic-log-sizes.sh

Paste the script, then:

chmod +x check-topic-log-sizes.sh

3️⃣ Run:

./check-topic-log-sizes.sh


---

🟢 What This Script Detects

Topic directory missing

Multiple partitions (can extend to all partitions)

Zero-size .log segment (retention working)

Large .log file (retention not working)



---

🔵 Optional: Check ALL partitions for each topic

I can also give an extended version that checks topic-0, topic-1, topic-2, etc.


---

If you want, I can also make:

✅ JSON output
✅ CSV report
✅ Only show failed topics
✅ Highlight retention.ms & cleanup settings
Just tell me!



Here is a short and clean script to run your kafka-configs.sh describe command for every topic listed in a file, exactly like your screenshot.


---

✅ Script: describe-topics.sh

Requirements:

File: topics.txt (one topic per line)

Your command template (copied from screenshot)



---

🟦 SCRIPT

#!/bin/bash

TOPIC_FILE="topics.txt"
CMD="./kafka-configs.sh"
BOOTSTRAP="ost-cdc-cat-skp-c01.linux.ostrava.corp.telstra.com:9093,ost-cdc-cat-skp-c02.linux.ostrava.corp.telstra.com:9093,ost-cdc-cat-skp-c03.linux.ostrava.corp.telstra.com:9093"
CLI_CONFIG="/app/kafka/kafka/config/client-ssl.properties"

while read -r topic; do
    [[ -z "$topic" ]] && continue

    echo "-------------------------------------------"
    echo "Checking topic: $topic"
    
    $CMD --bootstrap-server "$BOOTSTRAP" \
         --entity-type topics \
         --entity-name "$topic" \
         --describe \
         --command-config "$CLI_CONFIG"

done < "$TOPIC_FILE"


---

📌 How to use

1️⃣ Create topics.txt

topic1
topic2
topic3

2️⃣ Save script

vi describe-topics.sh

Paste script.

3️⃣ Make executable

chmod +x describe-topics.sh

4️⃣ Run

./describe-topics.sh


---

🟢 Output Example

-------------------------------------------
Checking topic: svc-catania-delivery-function-dc-events
Dynamic configs for topic svc-catania-delivery-function-dc-events are:
  retention.ms=259200000  sensitive=false  synonyms={DYNAMIC_TOPIC_CONFIG:retention.ms=259200000}

-------------------------------------------
Checking topic: VICPOL_PRIMARY_HI3
Dynamic configs for topic VICPOL_PRIMARY_HI3 are:
  retention.ms=10000 ...


---

If you want:

✅ Only print retention.ms
✅ Save output to a file
✅ Highlight topics not matching 10 sec (10000 ms)

Just tell me and I will generate it.