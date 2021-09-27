
# FT_SERVICES

![](https://www.combell.com/fr/blog/files/Kubernetes-Combell-750x256.jpg)

⚠ Ce repo ne présente pas la dernière version du sujet.

---

# Compétences abordées 📚

- Bash script
- Mise en place de divers services majeurs
- Réseau
- [Kubernetes][url_kubernetes]
- [Docker / Conteneurisation](url_docker)
- Bases de données

# Temp de réalisation ⌚️

> 3 Semaines ( Environ 130 heures )

# Sujet 📄

Ecrire un script Bash dans le but de deployer une serie de services dans Kubernetes.
Les services deployés sont :

| Nom		| Description	|
|-----------|---------------|
| [FTPS][url_ftps]		| Serveur de fichier sécurisé par le protocole SSL pour le chiffrement des transferts. |
| [nginx][url_nginx]		| Serveur web permetant d'heberger un site web. |
| [wordpress][url_wordpress]	| Site web Wordpress permetant de créer facilement une page web. |
| [mariaDB][url_mariadb] | Base de donnée utilisée par Wordpress pour y stocker ses données |
| [phpmyadmin][url_phpmyadmin] | Site web d'administration de la base de donnée |
| [grafana][url_grafana] | Site web de monitoring de tout les services déployés |
| [influxDB][url_influxdb] | Base de donnée temporel servant a stocké les mesures des services, c'est où Grafana prends les données |
| [telegraf][url_telegraf] | Logiciel de prise d'information pour acquerir les données des services pour les stocker dans InfluxDB |

# Explications Techniques 🤓

### Processus de réalisation
- Développement de la première version du script pour vérifier les dépendances et les installer si besoins pour les PC de notre école.
- Création d'une première version de toutes les images Docker pour faire les tests de leurs bon fonctionnement en local.
- Decouverte de Kubernetes par [Minikube][url_minikube].
- Écriture des deploiments et tests des images Docker.
- Ouverture au réseau de ces services vers l'exterieur pour pouvoir y accéder en tant que client.
- Automatisation des constructions des images Docker dans le script bash.
- Automatisation des deploiments dans minikube dans le script bash.
- Mise en place d'inspection d'état de santé des services appelés [livenessprobe][url_livenessprobe].
- Finitions du script.

### Details
Étant donné qu'on se corrige entre élèves, pas sur la même machine, le cluster k8s que l'on doit deployer est dans minikube pour des raisons de practicitées.

J'ai fais un script pour generer un .yaml de *secrets* avec des mots de passes aléatoires pour ne pas avoir de mots de passes critiques en clair sur le repo. Ce n'est pas nécessaire mais je trouvais cela intéressant.

Nginx dispose d'une redirection 301 qui permet une transformation automatique d'une requète HTTP vers HTTPS.

# Avis personnel du projet 👨🏻‍🔬

> J'ai touvé le projet très intéressant car cela m'a permis de découvrir cette technologie.
> 
> Kubernetes pourrais optimiser la façon dont on met en place des services actuellement et permet de réduire les besoins de maintenance et la consommation de ressources.
> 
> J'ai beaucoup aimé faire du script bash car je penses que c'est important d'avoir un bon niveau dans ce domaine et que cela apprends à utiliser de nouvelles commandes très utiles.
> J'ai aussi appris beaucoup sur les services deployés ce qui me servira très probablement dans mes missions et mes projets personnels.

[url_kubernetes]: https://fr.wikipedia.org/wiki/Kubernetes
[url_ftps]: https://fr.wikipedia.org/wiki/File_Transfer_Protocol_Secure#:~:text=Le%20File%20Transfer%20Protocol%20Secure%C3%A0%20un%20certificat%20d'authentification.
[url_docker]: https://www.redhat.com/fr/topics/containers
[url_nginx]: https://fr.wikipedia.org/wiki/NGINX
[url_wordpress]: https://fr.wikipedia.org/wiki/WordPress
[url_mariadb]: https://fr.wikipedia.org/wiki/MariaDB
[url_phpmyadmin]: https://fr.wikipedia.org/wiki/PhpMyAdmin
[url_grafana]: https://grafana.com/grafana/
[url_influxdb]: https://docs.influxdata.com/influxdb/v1.8/
[url_telegraf]: https://docs.influxdata.com/telegraf/v1.15/
[url_minikube]: https://kubernetes.io/fr/docs/setup/learning-environment/minikube/
[url_livenessprobe]: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/

Pour toute question n'hésitez pas à me contacter via les liens sur mon profil.
