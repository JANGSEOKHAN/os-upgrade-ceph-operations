# 기존 데몬 및 서비스 정리

OS 업그레이드 또는 서버 역할 변경 전, 기존 daemon/service 상태를 확인하고 불필요한 항목을 정리하는 절차입니다.

## 확인 항목

- `systemctl list-unit-files`
- `systemctl list-units --type=service`
- `crontab -l`
- `/etc/systemd/system`
- application auto-start script

## 정리 기준

- 현재 서버 역할에 필요 없는 service
- 중복 실행 중인 monitoring/exporter
- 이전 버전 application unit
- 더 이상 사용하지 않는 cron job
- legacy startup script

## 작업 순서

1. 대상 service와 dependency를 확인합니다.
2. service stop 후 application 영향도를 확인합니다.
3. disable 또는 mask 적용 여부를 결정합니다.
4. 설정 파일은 삭제 전 백업합니다.
5. reboot 이후 불필요한 service가 다시 올라오지 않는지 확인합니다.
