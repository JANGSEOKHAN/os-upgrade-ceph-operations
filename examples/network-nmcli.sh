#!/usr/bin/env bash
set -euo pipefail

# Public example. Replace placeholders before use.

CONNECTION_NAME="<connection-name>"
INTERFACE_NAME="<interface-name>"
ADDRESS_CIDR="<address-cidr>"
GATEWAY="<gateway>"
DNS_SERVERS="<dns-servers>"

nmcli con add type ethernet ifname "$INTERFACE_NAME" con-name "$CONNECTION_NAME" ipv4.method manual
nmcli con mod "$CONNECTION_NAME" ipv4.addresses "$ADDRESS_CIDR"
nmcli con mod "$CONNECTION_NAME" ipv4.gateway "$GATEWAY"
nmcli con mod "$CONNECTION_NAME" ipv4.dns "$DNS_SERVERS"
nmcli con mod "$CONNECTION_NAME" ipv6.method ignore
nmcli con up "$CONNECTION_NAME"
