# Oracle Linux 업그레이드 및 Ceph 스토리지 운영 가이드

Oracle Linux 서버 업그레이드와 Ceph 스토리지 운영을 함께 다루는 인프라 운영 가이드입니다.
OS 기본 설정, 프록시/가용성 구성, CephFS mount, 운영 점검 항목을 하나의 흐름으로 정리했습니다.

## 작업 범위

- Oracle Linux 7.9에서 8.10으로 업그레이드할 때 확인해야 하는 사전/사후 점검 항목
- LVM, fstab, NTP/Chrony, SSH, sysctl, network profile 등 Linux 기본 운영 설정
- HAProxy, Nginx, Keepalived 기반 프록시 및 VIP failover 구성
- Ceph monitor, manager, OSD 구성과 CephFS mount 운영
- 파일 백업, 이관, 재기동 이후 서비스 영향도 확인 절차

## 저장소 구성

```text
0.linux_기본설정/
  README.md                  # network, user, fstab, LVM, mount, SSH, sysctl 등 기본 설정
1.기존데몬삭제/
  README.md                  # 기존 daemon/service 정리 절차
2.haproxy_설치/
  README.md                  # HAProxy L4 proxy, health check, stats 설정 설명
3.nginx_설치/
  README.md                  # Nginx proxy/static config 운영 포인트
4.keepalived_설치/
  README.md                  # MASTER/BACKUP, VRRP, VIP failover 구성
5.ceph_설정/
  README.md                  # Ceph monitor, manager, OSD, CephFS mount 운영
6.파일백업/
  README.md                  # rsync 기반 파일 백업/이관 절차
docs/
  os-upgrade-checklist.md   # OS 업그레이드 전후 점검 절차
  ceph-storage-ops.md       # Ceph 구성값과 운영 확인 명령
examples/
  haproxy.cfg               # TCP 프록시와 backend health check 예시
  keepalived.conf           # VRRP 기반 VIP failover 예시
  network-nmcli.sh          # nmcli 기반 NIC 설정 예시
```

## Linux Base Configuration

| Area | Key Settings | Purpose |
| --- | --- | --- |
| Network | `nmcli con add`, `ipv4.addresses`, `ipv4.gateway`, `ipv4.dns` | 서버 NIC를 고정 IP 기반으로 구성하고 재부팅 이후에도 동일한 profile을 유지합니다. |
| Filesystem | `/etc/fstab`, `_netdev`, mount path | NFS/CephFS 같은 네트워크 스토리지가 OS 부팅 순서와 충돌하지 않도록 mount 정책을 명시합니다. |
| LVM | PV/VG/LV, filesystem, mount point | 데이터 영역을 논리 볼륨으로 분리해 확장성과 장애 대응성을 확보합니다. |
| Time Sync | Chrony/NTP server, tracking status | 클러스터, 인증, 로그 분석 기준 시간을 맞춰 운영 추적성을 높입니다. |
| SSH | 접근 허용 정책, key auth, root login policy | 운영 접근 경로를 제한하고 계정/권한 기준을 일관되게 유지합니다. |
| Kernel | `sysctl.conf`, file descriptor, network buffer | 프록시, Kafka, Ceph 등 장시간 연결이 많은 서비스의 기본 커널 파라미터를 조정합니다. |

## HAProxy Configuration Notes

`examples/haproxy.cfg`는 L4/TCP proxy 기준의 최소 구성을 담고 있습니다.

| Setting | Description |
| --- | --- |
| `global.maxconn` | HAProxy 프로세스가 동시에 처리할 수 있는 connection 상한입니다. |
| `defaults.mode tcp` | HTTP가 아닌 TCP stream 기준으로 트래픽을 전달합니다. |
| `timeout connect` | backend 서버와 연결을 맺을 때 기다리는 시간입니다. |
| `timeout client/server` | client/backend 방향 connection idle timeout입니다. |
| `frontend app_frontend` | 외부 요청을 받을 bind port를 정의합니다. |
| `backend app_backend` | 실제 application node 목록과 balancing 정책을 정의합니다. |
| `option tcp-check` | backend port 응답 여부를 기준으로 health check를 수행합니다. |
| `stats uri` | 운영자가 HAProxy 상태를 확인할 수 있는 stats endpoint입니다. |

## Keepalived Configuration Notes

`examples/keepalived.conf`는 VRRP 기반 VIP failover의 핵심 값만 포함합니다.

| Setting | Description |
| --- | --- |
| `state` | 초기 역할입니다. 일반적으로 주 노드는 `MASTER`, 대기 노드는 `BACKUP`으로 둡니다. |
| `interface` | VIP를 올릴 NIC 이름입니다. |
| `virtual_router_id` | 같은 VRRP 그룹을 식별하는 ID입니다. 동일 VIP 그룹에서는 같은 값을 사용합니다. |
| `priority` | MASTER 선출 우선순위입니다. 값이 높을수록 우선권을 가집니다. |
| `advert_int` | VRRP advertisement 주기입니다. 장애 감지 속도와 네트워크 부하에 영향을 줍니다. |
| `authentication` | VRRP peer 간 상태 교환에 사용할 인증 설정입니다. |
| `virtual_ipaddress` | 장애 전환 시 active node에 올라오는 service VIP입니다. |

## Ceph Storage Operations

Ceph는 monitor, manager, OSD 역할이 분리되어 있어 각 역할의 상태를 함께 확인해야 합니다.

| Component | Role |
| --- | --- |
| Monitor | cluster map과 quorum을 관리합니다. |
| Manager | dashboard, metric, module 등 관리 기능을 담당합니다. |
| OSD | 실제 data object를 저장하고 replication/recovery에 참여합니다. |
| CephFS | application server에서 mount해 사용하는 shared filesystem 계층입니다. |

주요 구성값은 다음 관점으로 확인합니다.

| Setting | Description |
| --- | --- |
| `mon_host` | client가 접속할 monitor endpoint 목록입니다. 2개 이상 지정하면 monitor 장애 시에도 접근 가능성이 높아집니다. |
| `public_network` | monitor, OSD, client 통신이 이루어지는 네트워크 대역입니다. |
| `auth_cluster_required` | cluster 내부 인증 방식을 정의합니다. 보통 `cephx`를 사용합니다. |
| `secretfile` | CephFS mount에 사용할 client secret file 경로입니다. 권한은 최소화해야 합니다. |
| `_netdev` | 네트워크가 준비된 뒤 mount되도록 OS 부팅 순서를 보정합니다. |

## Validation Commands

```bash
ceph -s
ceph health detail
ceph osd tree
ceph df
ceph mgr stat
mount | grep ceph
systemctl status haproxy
systemctl status keepalived
```

## Operation Flow

1. OS 업그레이드 전 서버 자원, mount, service, cron, network profile을 점검합니다.
2. config와 application data를 백업하고 rollback 경로를 확인합니다.
3. OS 업그레이드 후 kernel, package, network, mount, service 상태를 검증합니다.
4. HAProxy/Keepalived/Nginx 구성을 적용해 proxy와 VIP failover를 확인합니다.
5. CephFS mount와 read/write test를 수행하고 `ceph -s` 기준 health를 점검합니다.
6. 운영 로그, metric, backup job이 정상 수집되는지 확인합니다.

## Notes

`<...>` 형태의 값은 환경별로 바꿔야 하는 placeholder입니다.
운영 환경에 적용하기 전에는 OS 버전, 네트워크 정책, 스토리지 구조, 보안 기준에 맞춰 별도 검증이 필요합니다.
