#/bin/bash -

{% for v in group_names %}
{% if v not in allFatherGroups %}
curl http://{{ consul_url }}/v1/agent/service/register -X PUT -i -H "Content-Type:application/json" -d '
  {
    "id": "{{ inventory_hostname }}-{{ project_name }}",
    "name":"{{ v }}",
    "address":"{{ inventory_hostname }}",
    "port":{{ node_exporter_port }},
    "tags":[
        "exporter_type={{ node_exporter_name }}",
        "owner={{ owner }}"
    ],
    "checks":[
        {
            "http":"http://{{ inventory_hostname }}:9100/metrics",
            "interval":"15s"
        }
    ]
}'
{% endif %}
{% endfor %}