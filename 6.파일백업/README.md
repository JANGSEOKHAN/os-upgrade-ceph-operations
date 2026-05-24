# 파일 백업 및 이관

OS 업그레이드, 스토리지 이관, 서버 교체 과정에서 파일 백업과 동기화 상태를 확인하는 절차입니다.

## 주요 도구

- `rsync`
- `scp`
- `ssh`
- `cron`
- `tee`

## rsync 옵션 관점

| 옵션 | 설명 |
| --- | --- |
| `-a` | archive mode로 권한, 소유자, timestamp 유지 |
| `-HAX` | hardlink, ACL, xattr 유지 |
| `--numeric-ids` | uid/gid를 이름 변환 없이 숫자로 유지 |
| `--info=progress2,stats` | 전체 진행률과 통계 확인 |
| `--append-verify` | 이어받기 후 checksum 검증 |
| `--inplace` | 기존 파일을 직접 갱신 |

## 운영 체크

- source/target path 오타 확인
- dry-run으로 대상 파일 수와 용량 확인
- 이관 중 변경되는 파일 처리 방식 결정
- backup log 저장 경로 확인
- cron 등록 시 실행 계정과 권한 확인
- 완료 후 파일 개수, 용량, application read test 확인

## 적용 흐름

1. 대상 path와 용량 확인
2. dry-run 수행
3. 1차 동기화
4. 변경분 재동기화
5. application 정합성 확인
6. 정기 백업이 필요한 경우 cron 등록
