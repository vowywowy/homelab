# Homelab Stack
A media centric homelab stack.
-
Comes with 10 services:

Application|Services|Networks
:--|:--|:--
qBittorrent|qbittorrent|(qb-sonarr\|qb-radarr)-net
Sonarr|sonarr|qb-sonarr-net
Radarr|radarr|qb-radarr-net
Jackett|jackett|(jackett-radarr\|jackett-sonarr)-net
Plex|plex|plex-net
SMB|smb|smb-net
Portainer|portainer<br>portainer_agent|port-net
Shepherd|shepherd|shepherd-net
Traefik|traefik|*front-end networks for web services*
## Networks
### **qb-sonarr-net/qb-radarr-net & jackett-radarr-net/jackett-sonarr-net**
Sonarr and Radarr need access to qBittorrent, but don't need access to each other. They each get their own network and qBittorrent is a part of both. Jackett need access to Sonarr and Radarr but not to qBittorrent.
Service|Purpose
:--|:--
sonarr|Automatically downloads TV shows from various sources. Uses qBittorrent as its downloader.
radarr|Same as sonarr but for movies.
jackett|Tracker indexer/translator for sonarr and radarr.
qbittorrent|Download client on behalf of sonarr and radarr.
### **plex-net**
Consists of just the Plex container. This keeps the Plex container in overlay mode yet off of the default and therefore isolated from the other containers. It doesn't need to talk to them, so it can't.
### **smb-net**
Has one container that exposes the media storage location and the .torrent location as an SMB share so it can easily managed from Windows. Same isolation concept as plex-net.
### **shepherd-net**
A shepherd container automatically updates all the containers' images and removes unused images. Same isolation concept as plex-net.
### **port-net**
A Portainer container and agent service that provides a web based management interface for Docker Swarm. 
### **traefik**
A Traefik service connects to purpse-built networks that have containers with web interfaces and provides a reverse proxy for said interfaces.

Original Container|Reverse Proxy
:--|:--
qbittorrent|http://container_host/qb
sonarr|http://container_host/sonarr
radarr|http://container_host/radarr
jackett|http://container_host/jackett
portainer|http://container_host/portainer
plex|http://container_host/plex

---
## How to run
1. Install git and Docker
2. Clone the repo
3. Modify `./.env/plex.env`, PLEX_CLAIM and ADVERTISE_IP are unique:
	- The plex claim token needs to be substituted in the compose file with your own. **These are only valid for 4 minutes.** *([plex.tv/claim](https://plex.tv/claim))*
	- The ADVERTISE_IP ip address should be your container host's IP.
4. `docker swarm init && docker stack up -c docker-compose.yml homelab`

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
	- These also need some post config to work behind path based reverse proxying:
	```sh
	# This only needs to be done once simce the config is volumized
	stackName='homelab'; \
	docker exec $(docker ps -qf name=${stackName}_jackett) \
        sed -i 's@"BasePathOverride":.*@"BasePathOveride":"/jackett"@g' \
        /config/Jackett/ServerConfig.json; \
    docker service update ${stackName}_jackett --force; \
    for arr in 'radarr' 'sonarr'; do \
        docker exec $(docker ps -qf name=${stackName}_${arr}) \
        sed -i "s@<UrlBase>.*</UrlBase>@<UrlBase>/${arr}</UrlBase>@g" /config/config.xml; \
        docker service update ${stackName}_${arr} --force; \
    done;
	```
4. Configuring Plex the first time must be done through the :32400 url.
## Notes
1. Reverse proxying Plex is finicky. Thats why there is a redirect from /plex -> /plex/web/. This is also why Plex is fully accessible without a reverse proxy at its standard `:32400`.
2. Everything important is a persistent volume so you only need to configure once.
3. The stack has anonymous volume config commented out at the bottom. The stack has existed since before anon volumes and I'm to lazy to move the data around.
4. Port configuration is also present but commented out, just in case you need it.

## TODO
- Set base URL for Sonarr/Radarr/Jackett at container runtime
- Make a `run.sh` that prompts for a Plex claim token, sets ADVERTISE_IP appropriately, and brings up the stack.