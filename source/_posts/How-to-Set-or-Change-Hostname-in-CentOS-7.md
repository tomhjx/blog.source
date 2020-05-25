---
title: How to Set or Change Hostname in CentOS 7
categories:
  - 操作系统
  - Linux
tags:
  - 操作系统
  - Linux
date: 2020-05-25 11:33:42
---

A computer hostname represents a unique name that gets assigned to a computer in a network in order to uniquely identify that computer in that specific network. A computer hostname can be set to any name you like, but you should keep in mind the following rules:

*   hostnames can contain letters (from a to z).
*   hostnames can contain digits (from 0 to 9).
*   hostnames can contain only the hyphen character `( – )` as special character.
*   hostnames can contains the dot special character `( . )`.
*   hostnames can contain a combination of all three rules but must start and end with a letter or a number.
*   hostnames letters are case\-insensitive.
*   hostnames must contains between 2 and 63 characters long.
*   hostnames should be descriptive (to ease identifying the computer purpose, location, geographical area, etc on the network).

In order to display a computer name in **CentOS 7** and **RHEL 7** systems via console, issue the following command. The `-s` flag displayed the computer short name (hostname only) and the `-f` flag displays the computer FQDN in the network (only if the computer is a part of a domain or realm and the FQDN is set).

```bash
# hostname
# hostname -s
# hostname -f
```

[![Check Hostname in CentOS 7](https://www.tecmint.com/wp-content/uploads/2017/12/Check-Hostname-in-CentOS-7.png)

![Check Hostname in CentOS 7](https://www.tecmint.com/wp-content/uploads/2017/12/Check-Hostname-in-CentOS-7.png)

![Check Hostname in CentOS 7](https://www.tecmint.com/wp-content/uploads/2017/12/Check-Hostname-in-CentOS-7.png)

Check Hostname in CentOS 7

You can also display a Linux system hostname by inspecting the content of **/etc/hostname** file using the [cat command](https://www.tecmint.com/13-basic-cat-command-examples-in-linux/).

```bash
# cat /etc/hostname
```

![Display CentOS 7 Hostname](https://www.tecmint.com/wp-content/uploads/2017/12/Display-CentOS-7-Hostname.png)

![Display CentOS 7 Hostname](https://www.tecmint.com/wp-content/uploads/2017/12/Display-CentOS-7-Hostname.png)

![Check Hostname in CentOS 7](https://www.tecmint.com/wp-content/uploads/2017/12/Display-CentOS-7-Hostname.png)

Display CentOS 7 Hostname

In order to change or set a **CentOS 7** machine hostname, use the **hostnamectl** command as shown in the below command excerpt.

```bash
# hostnamectl set-hostname your-new-hostname
```

In addition to **hostname** command you can also use **hostnamectl** command to display a Linux machine hostname.

```bash
# hostnamectl
```

In order to apply the new hostname, a system **reboot** is required, issue one of the below commands in order to reboot a CentOS 7 machine.

```bash
# init 6
# systemctl reboot
# shutdown \-r
```

[![Set CentOS 7 Hostname](https://www.tecmint.com/wp-content/uploads/2017/12/Set-CentOS-7-Hostname.png)

![Set CentOS 7 Hostname](https://www.tecmint.com/wp-content/uploads/2017/12/Set-CentOS-7-Hostname.png)

![Set CentOS 7 Hostname](https://www.tecmint.com/wp-content/uploads/2017/12/Set-CentOS-7-Hostname.png)

Set CentOS 7 Hostname

A second method to setup a **CentOS 7** machine hostname is to manually edit the **/etc/hostname** file and type your new hostname. Also, a system reboot is necessary in order to apply the new machine name.

```bash
# vi /etc/hostname
```

A third method that can be used to change a **CentOS 7** machine hostname is by using Linux **sysctl** interface. However, using this method to change machine name results in setting\-up the machine transient hostname.

The transient hostname is a special hostname initialized and maintained only by the Linux kernel as an auxiliary machine name in addition to he static hostname and doesn’t survive reboots.

```bash
# sysctl kernel.hostname
# sysctl kernel.hostname=new-hostname
# sysctl -w kernel.hostname=new-hostname
```

To display machine transient hostname issue the below commands.

```bash
# sysctl kernel.hostname
# hostnamectl
```

[![Change CentOS 7 Hostname](https://www.tecmint.com/wp-content/uploads/2017/12/Change-CentOS-7-Hostname.png)

![Change CentOS 7 Hostname](https://www.tecmint.com/wp-content/uploads/2017/12/Change-CentOS-7-Hostname.png)

![Change CentOS 7 Hostname](https://www.tecmint.com/wp-content/uploads/2017/12/Change-CentOS-7-Hostname.png)

Change CentOS 7 Hostname

Finally, the **hostnamectl** command can be used to achieve the following hostname setups: **–pretty**, **–static**, and **–transient**.

Although, there are other more specific ways to [change a Linux machine hostname](https://www.tecmint.com/set-hostname-permanently-in-linux/), such as issuing **nmtui command** or manually editing some configuration files specific to each Linux distribution (**/etc/sysconfig/network\-scripts/ifcfg\-ethX** for CentOS), the above rules are general available regardless of the used Linux distribution.