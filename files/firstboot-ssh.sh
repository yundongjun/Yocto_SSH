#!/bin/sh
set -e
MARK=/var/lib/firstboot-ssh.done
[ -f "$MARK" ] && exit 0

sleep 2 || true

mkdir -p /var/run/sshd /var/empty /etc/ssh
chmod 755 /var/run/sshd
chmod 711 /var/empty
ssh-keygen -A
chmod 600 /etc/ssh/ssh_host_*_key 2>/dev/null || true

grep -q '^PermitRootLogin' /etc/ssh/sshd_config || echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
grep -q '^PasswordAuthentication' /etc/ssh/sshd_config || echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config

if command -v systemctl >/dev/null 2>&1; then
  systemctl enable sshd || systemctl enable ssh || true
  systemctl restart sshd || systemctl start ssh || true
else
  if [ -x /etc/init.d/sshd ]; then
    /etc/init.d/sshd restart || /etc/init.d/sshd start || true
  elif [ -x /usr/sbin/sshd ]; then
    /usr/sbin/sshd || true
  fi
fi

mkdir -p "$(dirname "$MARK")"
touch "$MARK"
exit 0

