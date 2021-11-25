include:
  - modules.keepalived.install

update-index.html:
  cmd.run:
    - name: mv /usr/share/nginx/html/index.html{,.best}

/usr/share/nginx/html/index.html:
  file.append:
    - text:
      - master

/etc/keepalived/keepalived.conf:
  file.managed:
    - source: salt://modules/keepalived/master/files/keepalived.conf.j2
    - template: jinja

/etc/sysctl.conf:
  file.append:
    - text:
      - net.ipv4.ip_nonlocal_bind = 1
  cmd.run:
    - name: sysctl -p

/scripts:
  file.directory:
    - user: root
    - group: root
    - mode: '0755'
    - makedirs: true

monitoring-nginx-sh:
  file.managed:
    - names:
      - /scripts/check_n.sh:
        - source: salt://modules/keepalived/master/files/check_n.sh
        - user: root
        - group: root
        - mode: '0755'
      - /scripts/notify.sh:
        - source: salt://modules/keepalived/master/files/notify.sh
        - user: root
        - group: root
        - mode: '0755'

start-keepalaved:
  service.running:
    - name: keepalived.service
    - enable: true
    - reload: true
    - watch:
      - file: monitoring-nginx-sh
