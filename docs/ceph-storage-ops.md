# Ceph Storage Operations Guide

Ceph 기반 스토리지 운영에서 확인해야 하는 구성값과 점검 명령을 정리한 가이드입니다.

## 구성 범위

- monitor, manager, osd 구성
- CephFS mount 및 fstab 등록
- admin keyring, secret file 권한 관리
- dashboard 접근 포트와 계정 정책 확인
- 장애 또는 재기동 이후 cluster health 확인

## 운영 체크포인트

```bash
ceph -s
ceph health detail
ceph osd tree
ceph df
ceph mgr stat
```

## 주요 설정값

| Setting | Description |
| --- | --- |
| `mon_host` | Ceph client가 접근할 monitor endpoint 목록입니다. monitor quorum 장애를 고려해 복수 endpoint를 지정합니다. |
| `public_network` | client, monitor, OSD 통신이 이루어지는 network CIDR입니다. |
| `auth_cluster_required` | cluster 내부 인증 방식입니다. 일반적으로 `cephx`를 사용합니다. |
| `auth_service_required` | service daemon과 client 사이 인증 방식입니다. |
| `auth_client_required` | client 접근 인증 방식입니다. |
| `log.dirs` | daemon log와 data path가 분리되어 있는지 확인합니다. |
| `secretfile` | CephFS mount에 사용하는 client secret file 경로입니다. file permission을 제한합니다. |
| `_netdev` | 네트워크 준비 이후 mount되도록 부팅 순서를 보정하는 fstab option입니다. |

## Mount Checklist

- Ceph monitor endpoint 확인
- mount target directory 권한 확인
- secret file 권한을 최소화
- `_netdev` 옵션으로 network dependency 반영
- reboot 이후 mount 유지 여부 확인

## 장애 확인 관점

- `HEALTH_WARN`, `HEALTH_ERR` 발생 여부
- down/out 상태의 OSD 존재 여부
- manager active/standby 상태
- CephFS mount read/write 가능 여부
- application server에서 mount path 접근 가능 여부

## fstab 예시

```text
<monitor-endpoint>:/ <mount-path> ceph name=<client-name>,secretfile=<secret-file>,_netdev 0 0
```
