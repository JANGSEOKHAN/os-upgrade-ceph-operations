# Ceph 스토리지 구축 및 운영 기록

Ceph monitor, manager, MDS, OSD 구성과 CephFS mount 운영을 위한 작업 기록입니다.

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

## 구축 단계

1. Ceph package 설치 및 host mapping 정리
2. `ceph.conf` 생성: fsid, monitor, public network, cephx 인증 설정
3. MON/Admin/bootstrap-osd keyring 생성 및 병합
4. monmap 생성 후 첫 monitor bootstrapping
5. manager daemon 구성 및 dashboard 모듈 확인
6. MDS 구성 후 CephFS metadata/data pool 생성
7. OSD directory 생성, OSD service 등록, OSD tree 확인
8. CephFS mount 및 `/etc/fstab` 등록
9. 추가 node에 MON/MDS/MGR/OSD 역할 확장

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

상세 설명은 [`docs/ceph-storage-ops.md`](../docs/ceph-storage-ops.md), 실제 작업 명령은 [`ceph_설정`](ceph_%EC%84%A4%EC%A0%95)에 정리했습니다.
