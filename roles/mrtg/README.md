Role Name
=========

Deploys die folgenden WiTCOM MRTG-Komponenten als Podman-Container

* Worker
* Config-Generator
* Traffic-Sum
* Config-Maker
* Web-Frontend

Requirements
------------

* Die WiTCOM-MRTG Konfigurations und Accounting Datenbank muss vorhanden sein
* Die genannten Komponenten müssen auf dem gleichen Host installiert werden

Role Variables
--------------

Verfügbare Variablen mit Default-Werten (siehe auch `defaults/main.yml`) werden hier aufgelistet

    mrtg_repo: my-docker-repo/mrtg
    mrtg_version: "0.2.11"
    mrtg_web_version: "0.1.0"
    mrtg_worker_image: {{mrtg_repo}}/mrtg-run
    mrtg_worker_version: {{ mrtg_version }} 
    mrtg_cfgmaker_image: {{mrtg_repo}}/mrtg-cfgmaker
    mrtg_cfgmaker_version: {{ mrtg_version }} 
    mrtg_create_cfg_image: {{mrtg_repo}}/mrtg-create-cfg
    mrtg_create_cfg_version: {{ mrtg_version }} 
    mrtg_traffic_sum_image: {{mrtg_repo}}/mrtg-traffic-sum
    mrtg_traffic_sum_version: {{ mrtg_version }}
    mrtg_web_image: {{mrtg_repo}}/mrtg-web 

Das Standard Image-Repository kann pro Komponente definiert werden, ebenso die Image-Version. Per

    container_conf_dir: "/var/srv/containers/config"
    container_data_dir: "/var/srv/containers/volume"

Basis-Verzeichnisse für Konfiguration & Daten

    mrtg_config: "{{ container_conf_dir }}/{{inventory_hostname_short}}.mrtg_{{mrtg.instance_name}}"
    mrtg_data: "{{ container_data_dir }}/{{inventory_hostname_short}}.mrtg_{{mrtg.instance_name}}"

Spezifisccher Speicherort für die ausgerollte MRTG-Instanz

    mrtg_version: "0.2.11"
    mrtg_web_version: "0.1.0"

```
mrtg:
  #MRTG Instanz
  instance_name: "internal01"
  #MRTG-Konfigurations-DB
  db:
    user: dbuser
    password: password
    name: mrtg
    host: localhost
  #RADIUS-DB fuer Accounting-Daten DSL-User
  radius:
    db:
      user: radiusdbuser
      password: radiusdbpassword
      host: localhost
  # WEB Frontend
  web:
    # Container-Netzwerk fuer web-container
    # wird angelegt falls es nicht existiert
    network: "external-net"
    # definiert ob der container aktiviert wird
    enabled: true
    # container memory-limit
    memory_limit: 1g
    # container CPU-limit
    cpu_limit: 1
    # Authentifizierung (Details siehe https://github.com/witcom-gmbh/mrtg-web)
    keycloak:
      url: http://localhost:8080/auth
      realm: realm
      client: client
      secret: secret
  # MRTG worker, d.h. der Prozess der das Device-Pollign macht
  worker:
    # Aktivierung
    enabled: true
    # Intervall in Minuten - NICHT aendern
    interval: 5
  config_generator:
    # Aktivierung
    enabled: true
    # Ausführungs-Interval in Minuten
    interval: 15
  traffic_sum:
    # Aktivierung
    enabled: true
    # Ausführungs-Interval in Minuten
    interval: 15
    # Im Test-Modus (dry_run = 1) werden die Daten nicht in die DB geschrieben
    dry_run: 0
```

Dependencies
------------

* containers.podman

Example Playbook
----------------

```
---
- hosts: all
  remote_user: "conductor"
  become: yes
  become_method: sudo
  collections:
    - witcom.witcom_mrtg

- name: Deploy MRTG
  remote_user: "conductor"
  hosts: mrtg_hosts
  become: yes
  become_method: sudo
  roles:
    - name: witcom.witcom_mrtg.mrtg
````

License
-------

BSD

Author Information
------------------

An optional section for the role authors to include contact information, or a website (HTML is not allowed).
