# Installing XFCE4 on NGINX servers for VNC access

- After installing Ubuntu on any platform; do

```
sudo apt-get update
sudo apt-get install xfce4
vncserver (configure vncserver password)
```
- Kill the vncserver initiated in the previous step
```
vncserver -kill :1
```
- Backup the original xstartup file
```
mv ~/ .vnc/xstartup ~/ .vnc/xstartup.bak
```
- Add these commands in the startup file
```
#!/bin/bash
xrdb $HOME/ .Xresources
startxfce4 &
```
- Change the permissions
```
sudo chmod +x ~/ .vnc/xstartup
```
- Create a VNC server file
```
sudo nano /etc/init.d/vncserver
```
- Edit the file and add the following contents
```
#!/bin/bash
PATH="$PATH:/usr/bin/"
export USER="root"
DISPLAY="1"
DEPTH="16"
GEOMETRY="1024x768"
OPTIONS="-depth ${DEPTH} -geometry ${GEOMETRY} :${DISPLAY} -localhost"
. /lib/lsb/init-functions
```
- First, we need to create an SSH connection on your local computer that securely forwards to the localhost connection for VNC. You can do this via the terminal on Linux or OS X via the following command:
```
ssh -L 5901:127.0.0.1:5901 -N -f -l user server_ip_address
```
