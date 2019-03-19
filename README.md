# Homelab Stack
A media centric homelab stack with a little bit of monitoring & management.
-
Comes with 9 containers and 7 networks:
Application|Container| Networks
-|-|-
qBittorrent|qbittorrent|(son\|rad)-net
Sonarr|sonarr|son-net
Radarr|radarr|rad-net
Plex|plex|plex-net
SMB|smb|smb-net
Netdata|netdata|data-net
Portainer|portainer|port-net
Watchtower|watchtower|*none*
Nginx|nginx|(port\|data\|qbit\|son\|rad)-net
## Networks
### **son-net & rad-net**
Sonarr and Radarr need access to qBittorrent, but don't need access to each other. They each get their own network and qBittorrent is a part of both. Nginx needs access to all 3 of these containers.
Container|Purpose
-|-
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
-|-
qbittorrent|http://container_host/qb
sonarr|http://container_host/sonarr
radarr|http://container_host/radarr
netdata|http://container_host/netdata
portainer|http://container_host/portainer

