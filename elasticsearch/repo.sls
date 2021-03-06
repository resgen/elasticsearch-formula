{%- set major_version = salt['pillar.get']('elasticsearch:major_version', 2) %}

{%- if major_version == 5 %}
  {%- set repo_url = 'https://artifacts.elastic.co/packages/5.x' %}
{%- else %}
  {%- set repo_url = 'http://packages.elastic.co/elasticsearch/2.x' %}
{%- endif %}

{%- if major_version == 5 and grains['os_family'] == 'Debian' %}
apt-transport-https:
  pkg.installed
{%- endif %}

elasticsearch_repo:
  pkgrepo.managed:
    - humanname: Elasticsearch {{ major_version }}
{%- if grains.get('os_family') == 'Debian' %}
  {%- if major_version == 5 %}
    - name: deb {{ repo_url }}/apt stable main
  {%- else %}
    - name: deb {{ repo_url }}/debian stable main
  {%- endif %}
    - dist: stable
    - file: /etc/apt/sources.list.d/elasticsearch.list
    - keyid: D88E42B4
    - keyserver: keyserver.ubuntu.com
    - clean_file: true
{%- elif grains['os_family'] == 'RedHat' %}
    - name: elasticsearch
  {%- if major_version == 5 %}
    - baseurl: {{ repo_url }}/yum
  {%- else %}
    - baseurl: {{ repo_url }}/centos
  {%- endif %}
    - enabled: 1
    - gpgcheck: 1
    - gpgkey: http://artifacts.elastic.co/GPG-KEY-elasticsearch
{%- endif %}
