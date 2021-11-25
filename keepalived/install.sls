keep-installpkg:
  pkg.installed:
    - pkgs:
      - epel-release 
      - vim-enhanced 
      - wget 
      - gcc 
      - gcc-c++
      - keepalived
      - nginx

start-nginx:
  service.running:
    - name: nginx
    - enable: true
    
