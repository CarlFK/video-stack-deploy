# dhcp-server

Configure and manage a DHCP server.

## Tasks

Everything is in the `tasks/main.yml` file.

## Available variables

Main variables are :

* `eth_local_ip_address`:         Local IP address for the DHCP server.

* `eth_local_ip_netmask`:         Local netmask for the DHCP server.

* `eth_local_ip_gateway`:         Local IP gateway for the DHCP server. Only
                                  define thiscif you are not defining the uplink
                                  variables.

* `eth_local_mac_address`:        Local MAC address for the DHCP server.

* `eth_uplink_mac_address`:       Uplink MAC address for the DHCP server. If
                                  defined, this machine will act as a gateway
                                  and does masquerading.

* `use_static_ip`:                Boolean value. If false, the DHCP server uses
                                  DHCP to get an IP from the uplink.

* `eth_uplink_static_ip_address`: Static uplink IP address. Requires `use_static_ip`
                                  true.

* `eth_uplink_static_ip_gateway`: Static uplink IP gateway. Requires `use_static_ip`
                                  set to true.

* `dhcp_range`:                   Allowed IP range for the DHCP server. Syntax:
                                  `$start-addr,$end-addr,$netmask,$broadcast,$lease time`.

* `domain`:                       DNS domain for the DCHP server.

* `staticips.hosts`:              For the layout of the `staticips.hosts`
                                  variable, see the staticips role.
