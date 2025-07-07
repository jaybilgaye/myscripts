
⸻

📄 elasticsearch-upgrade-8.12-to-8.16.md

# Elasticsearch 8.12 → 8.16 Upgrade Plan

**Cluster Overview:**
- **Nodes:** abc1.com to abc6.com
- **Kibana:** Running on abc1.com
- **Environment:** On-premises

---

## ✅ Pre-Upgrade Checklist

1. **Review Breaking Changes**
   - Examine the [Elasticsearch 8.16 breaking changes](https://www.elastic.co/guide/en/elasticsearch/reference/8.18/migrating-8.16.html) and [Kibana 8.16 upgrade notes](https://www.elastic.co/guide/en/kibana/8.18/breaking-changes-summary.html) to identify any modifications that might affect your cluster.

2. **Run the Upgrade Assistant**
   - Access the Upgrade Assistant in Kibana (`http://abc1.com:5601`) to detect deprecated settings and incompatible indices.
   - Address all critical issues before proceeding.

3. **Backup Your Cluster**
   - Create a snapshot of your cluster to safeguard against data loss.
   - Ensure that system indices (e.g., `.kibana`, `.security`) are included in the snapshot.

---

## 🔄 Rolling Upgrade Steps

Perform the upgrade one node at a time to maintain cluster availability.

### 1. Upgrade Non-Master-Eligible Nodes

Assuming `abc1.com` and `abc2.com` are master-eligible nodes, upgrade the remaining nodes first.

For each non-master-eligible node (`abc3.com` to `abc6.com`):

a. **Disable Shard Allocation**

On any master-eligible node, run:

```bash
curl -X PUT "http://abc1.com:9200/_cluster/settings" -H 'Content-Type: application/json' -d'
{
  "persistent": {
    "cluster.routing.allocation.enable": "none"
  }
}'

b. Stop the Node

SSH into the node and stop Elasticsearch:

sudo systemctl stop elasticsearch

c. Upgrade Elasticsearch

Follow the official installation guide to install Elasticsearch 8.16.

d. Start the Node

Start Elasticsearch:

sudo systemctl start elasticsearch

e. Verify Node Rejoins Cluster

Check cluster health and ensure the node has rejoined:

curl -X GET "http://abc1.com:9200/_cluster/health?pretty"

f. Re-enable Shard Allocation

Once the node is back and healthy:

curl -X PUT "http://abc1.com:9200/_cluster/settings" -H 'Content-Type: application/json' -d'
{
  "persistent": {
    "cluster.routing.allocation.enable": "all"
  }
}'

Repeat these steps for each non-master-eligible node.

2. Upgrade Master-Eligible Nodes

After all non-master-eligible nodes are upgraded, proceed with the master-eligible nodes (abc1.com and abc2.com).

For each master-eligible node:

a. Disable Shard Allocation

Run the same command as in step 1a.

b. Stop the Node

SSH into the node and stop Elasticsearch:

sudo systemctl stop elasticsearch

c. Upgrade Elasticsearch

Follow the official installation guide to install Elasticsearch 8.16.

d. Start the Node

Start Elasticsearch:

sudo systemctl start elasticsearch

e. Verify Node Rejoins Cluster

Check cluster health and ensure the node has rejoined:

curl -X GET "http://abc1.com:9200/_cluster/health?pretty"

f. Re-enable Shard Allocation

Once the node is back and healthy:

curl -X PUT "http://abc1.com:9200/_cluster/settings" -H 'Content-Type: application/json' -d'
{
  "persistent": {
    "cluster.routing.allocation.enable": "all"
  }
}'

Repeat these steps for each master-eligible node.

⸻

📊 Upgrade Kibana

After all Elasticsearch nodes are upgraded, proceed to upgrade Kibana on abc1.com.
	1.	Stop Kibana

SSH into abc1.com and stop Kibana:

sudo systemctl stop kibana

	2.	Upgrade Kibana

Follow the official Kibana installation guide to install Kibana 8.16.
	3.	Start Kibana

Start Kibana:

sudo systemctl start kibana

	4.	Verify Kibana Functionality

Access Kibana at http://abc1.com:5601 and ensure all dashboards and visualizations are functioning correctly.

⸻

✅ Post-Upgrade Validation
	•	Cluster Health
Ensure the cluster status is green:

curl -X GET "http://abc1.com:9200/_cluster/health?pretty"


	•	Node Versions
Verify all nodes are running Elasticsearch 8.16:

curl -X GET "http://abc1.com:9200/_cat/nodes?v"


	•	Kibana Functionality
Check that all Kibana features are operational and that saved objects have been migrated successfully.

⸻

📚 References
	•	Elasticsearch Upgrade Guide
	•	Kibana Upgrade Guide

 [oai_citation:0‡en.wikipedia.org](https://en.wikipedia.org/wiki/Markdown?utm_source=chatgpt.com) [oai_citation:1‡dillinger.io](https://dillinger.io/?utm_source=chatgpt.com) [oai_citation:2‡markdowneditor.net](https://markdowneditor.net/?utm_source=chatgpt.com)

---

You can save this content into a file named `elasticsearch-upgrade-8.12-to-8.16.md` using any text editor. If you're using Visual Studio Code, it offers Markdown syntax highlighting and a preview feature to help you visualize the formatted document.  [oai_citation:3‡markdown.land](https://markdown.land/readme-md?utm_source=chatgpt.com)

If you need further assistance or have specific questions about the upgrade process, feel free to ask! 
