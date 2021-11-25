include:
  - xiangmu.haproxy.rsyslog

package-install:
  pkg.installed:
    - pkgs:
      - make 
      - gcc 
      - pcre-devel 
      - bzip2-devel 
      - openssl-devel 
      - systemd-devel

/usr/local:
  archive.extracted:
    - source: salt://xiangmu/haproxy/files/haproxy-2.4.7.tar.gz
    - if_missing: /usr/local/haproxy-2.4.7

haproxy:
  user.present:
    - shell: /sbin/nologin
    - createhome: files
    - system: true

haproxy-installsh:
  cmd.script:
    - name: salt://xiangmu/haproxy/files/install.sh.j2
    - template: jinja
    - unless: test -d /usr/local/haproxy

/usr/sbin/haproxy:
  file.symlink:
    - target: {{ pillar['haproxy_install_dir'] }}/sbin/haproxy

/etc/sysctl.conf:
  file.append:
    - text:
      - net.ipv4.ip_nonlocal_bind = 1
      - net.ipv4.ip_forward = 1
  cmd.run:
    - name: sysctl -p

/usr/local/haproxy/conf:
  file.directory:
    - user: root
    - group: root
    - mode: '0755'
    - makedirs: true

/usr/local/haproxy/conf/haproxy.cfg:
  file.managed:
    - source: salt://xiangmu/haproxy/files/haproxy.cfg.j2
    - template: jinja

/usr/lib/systemd/system/haproxy.service:
  file.managed:
    - source: salt://xiangmu/haproxy/files/haproxy.service.j2
    - template: jinja
  cmd.run:
    - name: systemctl daemon-reload
