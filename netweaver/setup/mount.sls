{%- from "netweaver/map.jinja" import netweaver with context -%}
{% set host = grains['host'] %}

{% for node in netweaver.nodes if host == node.host %}
{% set instance = '{:0>2}'.format(node.instance) %}
{% set instance_name =  node.sid~'_'~instance %}

{% if node.sap_instance.lower() == 'ascs' %}

mount_ascs_{{ instance_name }}:
  mount.mounted:
    - name: /usr/sap/{{ node.sid.upper() }}/ASCS{{ instance }}
    - device: {{ node.shared_disk_dev }}2
    - fstype: xfs
    - mkmnt: True
    - persist: True
    - opts:
      - defaults

{% elif node.sap_instance.lower() == 'ers' %}

mount_ers_{{ instance_name }}:
  mount.mounted:
    - name: /usr/sap/{{ node.sid.upper() }}/ERS{{ instance }}
    - device: {{ node.shared_disk_dev }}3
    - fstype: xfs
    - mkmnt: True
    - persist: True
    - opts:
      - defaults

{% elif node.sap_instance.lower() in ['pas', 'aas'] %}

create_dialog_folder_{{ node.sap_instance.lower() }}_{{ instance_name }}:
  file.directory:
    - name: /usr/sap/{{ node.sid.upper() }}/D{{ instance }}

{% endif %}
{% endfor %}
