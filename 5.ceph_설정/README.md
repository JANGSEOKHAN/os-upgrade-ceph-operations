# Ceph 설정 및 스토리지 운영

Ceph monitor, manager, OSD 구성과 CephFS mount 운영을 위한 점검 항목입니다.

## 구성 요소

| 구성 요소 | 역할 |
| --- | --- |
| Monitor | cluster map과 quorum 관리 |
| Manager | dashboard, metric, module 관리 |
| OSD | object 저장, replication, recovery 참여 |
| CephFS | application server에서 mount하는 shared filesystem |

## 주요 설정

- `mon_host`: client가 접근할 monitor endpoint
- `public_network`: Ceph 통신 network
- `auth_*_required`: cephx 인증 적용 여부
- `secretfile`: mount에 사용하는 client secret file
- `_netdev`: network mount 부팅 순서 보정

## 운영 명령

```bash
ceph -s
ceph health detail
ceph osd tree
ceph df
ceph mgr stat
mount | grep ceph
```

## 운영 체크

- OSD down/out 여부
- quorum 정상 여부
- CephFS mount read/write 가능 여부
- reboot 이후 mount 유지 여부
- application에서 mount path 접근 가능 여부

상세 가이드는 [`docs/ceph-storage-ops.md`](../docs/ceph-storage-ops.md)에 정리했습니다.
