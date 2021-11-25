/etc/rsyslog.conf:
  file.managed:
    - source: salt://xiangmu/haproxy/files/rsyslog.conf

stop-rsyslog.service:
  service.dead:
    - name: rsyslog.service

start-rsyslog.service:
  service.running:
    - name: rsyslog.service
    - enable: true
