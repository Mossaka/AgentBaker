[Unit]
Description=Kubelet
ConditionPathExists=/usr/local/bin/kubelet
ConditionPathExists=/opt/azure/containers/start-kubelet.sh
Wants=network-online.target containerd.service
After=network-online.target containerd.service

[Service]
Restart=always
RestartSec=2
EnvironmentFile=/etc/default/kubelet
SuccessExitStatus=143
ExecStartPre=/bin/bash /opt/azure/containers/kubelet.sh
ExecStartPre=/bin/mkdir -p /var/lib/kubelet
ExecStartPre=/bin/mkdir -p /var/lib/cni
ExecStartPre=/bin/bash -c "if [ $(mount | grep \"/var/lib/kubelet\" | wc -l) -le 0 ] ; then /bin/mount --bind /var/lib/kubelet /var/lib/kubelet ; fi"
ExecStartPre=/bin/mount --make-shared /var/lib/kubelet

ExecStartPre=-/sbin/ebtables -t nat --list
ExecStartPre=-/sbin/iptables -t nat --numeric --list

ExecStart=/opt/azure/containers/start-kubelet.sh

[Install]
WantedBy=multi-user.target
