# Homelab Stack
A media centric homelab stack with a little bit of monitoring and management.
-
Comes with 9 containers and 6 networks:

Application|Container|Networks
:--|:--|:--
qBittorrent|qbittorrent|(son\|rad)-net
Sonarr|sonarr|son-net
Radarr|radarr|rad-net
Plex|plex|plex-net
SMB|smb|smb-net
Netdata|netdata|data-net
Portainer|portainer|port-net
Watchtower|watchtower|*none*
Ofelia|ofelia|*none*
Nginx|nginx|(port\|data\|qbit\|son\|rad\|plex)-net
## Networks
### **son-net & rad-net**
Sonarr and Radarr need access to qBittorrent, but don't need access to each other. They each get their own network and qBittorrent is a part of both. Nginx needs access to all 3 of these containers.

Container|Purpose
:--|:--
sonarr|Automatically downloads TV shows from various sources. Uses qBittorrent as its downloader.
radarr|Same as sonarr but for movies.
qbittorrent|Download client on behalf of sonarr and radarr.
### **plex-net**
Consists of just the Plex container. This keeps the Plex container in bridge mode isolated from the other containers. It doesn't need to talk to them, so it can't.
### **smb-net**
Has one container that exposes the media storage location as an SMB share so it can easily managed from Windows. Same isolation concept as plex-net.
### **data-net**
A Netdata container that monitors and visualizes the container host's metrics.
### **port-net**
A Portainer container that provides a web based management interface for Docker. 
### **nginx**
An Nginx container connects to all networks that have containers with web interfaces and provides a reverse proxy for said interfaces.

Original Container|Reverse Proxy
:--|:--
qbittorrent|http://container_host/qb
sonarr|http://container_host/sonarr
radarr|http://container_host/radarr
netdata|http://container_host/netdata
portainer|http://container_host/portainer
plex|http://container_host/plex
### **watchtower**
A Watchtower container automatically updates all the containers' images and removes unused images.
### **ofelia**
Ofelia is docker based cron. All it does now is restart plex at 2AM to trigger PMS updates and system prunes at 4AM.

---
## How to run
1. Install git, Docker, and Docker Compose
2. Clone the repo
3. Modify the compose file, PLEX_CLAIM and ADVERTISE_IP are unique:
	- The plex claim token needs to be substituted in the compose file with your own. **These are only valid for 4 minutes.** *([plex.tv/claim](https://plex.tv/claim))*
	- The ADVERTISE_IP ip address should be your container host's IP.
4. `docker-compose up -d`

Thats it! Services are now available at:
- http://container_host/portainer
- http://container_host/netdata
- http://container_host/qb
- http://container_host/sonarr
- http://container_host/radarr
- http://container_host/plex *(redirects to /web/)*
- \\\container_host\downloads

You will need to do configuration on some of these services to get them functioning with each other:
1. Make a user and password in qBittorrent's web interface. *(admin:adminadmin)*
2. Configure qBittorrent how you want.
3. Setup Sonarr/Radarr.
	- Since these are things that do the hard stuff, they need the most work and I can't provide a config for obvious reasons. You can setup qBittorrent access with `qbittorrent:8080` and the username/password from qBittorrent's web interface. Google is your friend for configuring the rest.
4. Configure Plex how you want, like adding libraries, etc.
## Notes
1. Reverse proxying Plex is finicky. Thats why there is a redirect from /plex -> /web/. This is also why Plex is fully accessible without a reverse proxy at its standard `:32400`.
2. Everything important is a persistent volume so you only need to configure once. 

## TODO
- Make a `run.sh` that prompts for a Plex claim token, sets ADVERTISE_IP appropriately, and brings up the stack.
- Make a central reverse proxy option to proxy **all** traffic through Nginx. Currently only SMB and Plex non-web ports are not being proxied. SMB is easy to proxy and has been tested but Plex's non-web ports aren't as simple.