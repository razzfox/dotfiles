# These scripts are likely to be fired-off once for a specific task,
# possibly with a long running time, and possibly by a process scheduler (cron, systemd).
# Also, these are not necessarily written in shell code. 

# TODO:
  - reverse-ssh hourly 6pm-3am + log and make into systemd
  - make port-forward into systemd, using -g option (not GatewayPorts in config)
  - make update-ip into systemd
