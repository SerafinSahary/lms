
# Lan Management System (LMS)
LMS (LAN Management System) is a package of applications for managing LAN networks. 
Its main goal is to provide the best service to customers, as seen in large ISP companies. 
LMS is written in PHP, Perl and C and can use MySQL or PostgreSQL as its database backends. 
The following features are provided at the time: customer database (names, addresses, phones, comments, etc),
computers inventory (IP, MAC), simple financial system suited for network operations, financial balances and invoices, email warnings to users, automatic billing schedule, ability to generate (almost) any kind of config file ie. ipchains/iptables firewall scripts, DHCP daemon configuration, zones for bind, /etc/ethers entries, oident, htb and more, visualization of bandwidth consumption per host, request tracker system (Helpdesk), timetable (Organizer).


## LMS4LAN

This is clone of LMS repository meant to develop LMS4LAN branch - an updated version of LMS dedicated for enterprise LAN management. The main reason for creating this fork was the need for webconsole for Radius database management. 
There are two branches in the repo:
- master - meant for tracking source LMS project,
- lms4lan - meant for developing updates for LAN management.

Additionally, within LMS4LAN branch there are two extras available:
- [Vagrant](https://www.vagrantup.com/) configuration scripts for provisioning LMS development environment,
- [FreeRADIUS](https://freeradius.org/) integration scripts for database views, to provide LMS data for RADIUS integration within FreeRADIUS table formats.
