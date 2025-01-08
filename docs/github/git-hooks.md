---
tags:
  - Git
  - Git hooks
---

# Les hooks Git

Git permet de déclencher des actions en fonction en fonction d'évenements particuliers comme par exemple un `git commit`, ces évenements sont l'occasion pour le DevOps de mettre en place des contrôles et de déclencher des automatisation particulières.

On peut distinguer les hooks Git selon deux catégories :

- Les **hooks clients**, qui se déclenchent sur le poste du développeur et vont permettre de contrôler ce qui est envoyé par le développeur sur le serveur Git (dans notre cas Github).
- Les **hooks coté serveur**, se déclenchent sur le serveur Github lors d'actions remote sur les branches, par exemple un `git push`.

## Les hooks coté client

Leur utilisation ne peut pas être imposé par le DevOps, chaque développeur a la main sur cette partie et peut le configurer comme bon lui semble.

Le hook le plus classiquement utilisé est le hook **pre-commit**, vous pouvez trouver un exemple dans `.git/hooks/pre-commit.sample`

Ce hook de pre-commit intervient avant que le commit soit envoyé et peut donc vous permettre de vérifier deux points essentiels :

- appliquer un linter sur votre code : vérifier que le code correspond aux normes définies par votre équipe de développement.
- s'assurer que le message de commit correspond bien aux normes définies par votre équipe de développement, par exemple les conventional commit.

Un utilitaire `pre-commit` peut vous permettre de vous aider dans sa mise en place, vous trouverez plus d'information [ici](https://pre-commit.com/#intro)

### Les conventional commit

Il est utilile de partager une convention pour nommer ses commits message, cela va nous permettre par la suite d'automatiser la génération des changelogs des releases. Chaque entreprise / équipe de dévéloppement peut se mettre d'accord sur un nommage particulier, mais une bonne pratique aujourd'hui est d'adopter ce qu'on appelle les conventional commit.

Vous trouverez plus d'informations sur les conventional commits [ici](https://www.conventionalcommits.org/en/v1.0.0/)

Un [cheatsheet](https://gist.github.com/qoomon/5dfcdf8eec66a051ecd85625518cfd13)

### Bon usage et mauvaise pratique

Les hooks côté client ne sont pas imposable par le DevOps, chaque développeur a la possibilité de le modifier et le customiser il ne faut pas chercher à l'imposer car il finira par être désactivé individuellement par la plupart des développeurs : certains désactiveront, d'autre améliorerons avec d'autres contrôles.

Au final c'est plus une pratique du développeur, utile à connaitre pour le DevOps mais pas utilisable directement.

Il faut savoir que les commit messages peuvent être écrasé lors du merge d'une PR, pour se concentrer sur un seul message bien normalisé. Il est donc tout à fait possible d'utiliser des commits message moche lors de la phase de dev sur notre branche puis de faire un merge propre lors de la PR avec un beau message (stash merge).

## Les hooks coté serveur

Le répertoire `.git/hooks/` ne fait pas partie du dépôt Git, ce n'est donc pas possible de le commit ou de le paramétrer via ce biais sur un serveur git distant, c'est d'ailleurs la raison qui fait que les hooks clients ne peuvent pas être définis et partagé via ce biais.

Si les scripts sample existent c'est que Git fonctionne de manière décentralisé et chaque utilisateur de Git est à la fois serveur et client.

Vous n'avez donc pas la possibilité de définir un hook git sur le serveur en modifiant un hook de post receive par exemple.

Les actions de déclenchement dans le cas de Github ou de Gitlab-ci devront donc se paramétrer dans les paramètres du dépôts du logiciel en question.

Dans **le cas de Github** les actions de déclenchement se feront via ce qu'on appelle des **Github action**.

