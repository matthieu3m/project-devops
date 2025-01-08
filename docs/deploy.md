# Une bonne facon d'essayer de deploy mkdocs

Voici une bonne maniere de deploy ma doc mkdocs sur une instance EC2 à essayer dès que possible !

`deploy:
  needs: build`

`permissions:
    pages: write
    id-token: write`

  `environment:
    name: github-pages static
    url: ${{ steps.deployment.outputs.page_url }}`

  `runs-on: ubuntu-latest`

 `steps:`


    # 1. Vérification du code
    - name: Checkout code
      uses: actions/checkout@v2

    # 2. Set up SSH keys for EC2 access
    - name: Set up SSH key
      uses: webfactory/ssh-agent@v0.5.3
      with:
        ssh-private-key: ${{ secrets.EC2_SSH_PRIVATE_KEY }}  # Assurez-vous d'ajouter votre clé privée dans les Secrets GitHub

    # 3. Déployer les fichiers sur EC2 via SCP
    - name: Deploy to EC2
      run: |
        # Remplacez ces variables par vos valeurs réelles
        SERVER_IP="your-ec2-public-ip"   # Adresse IP publique de votre instance EC2
        USER="ubuntu"                     # Nom d'utilisateur de votre instance (généralement "ubuntu" pour les instances Ubuntu)
        TARGET_DIR="/home/ubuntu/mywebsite"  # Dossier cible sur votre instance EC2

        # Copier les fichiers nécessaires vers l'instance EC2
        scp -r ./site/* $USER@$SERVER_IP:$TARGET_DIR

    # 4. Redémarrer le serveur web (par exemple, Apache ou Nginx) pour qu'il serve la nouvelle documentation
    - name: Restart server to apply changes
      run: |
        ssh $USER@$SERVER_IP << 'EOF'
          sudo systemctl restart nginx   # Redémarre le serveur Nginx (ou Apache selon votre configuration)
        EOF



3. Configuration des Secrets GitHub
Pour que GitHub Actions puisse se connecter à votre instance EC2 via SSH, vous devez ajouter une clé SSH privée dans les Secrets GitHub de votre dépôt.

Générez une paire de clés SSH sur votre machine locale (si ce n'est pas déjà fait)
    `ssh-keygen -t rsa -b 4096 -C "github-actions" -f github-actions-key`

Ajoutez la clé publique à ~/.ssh/authorized_keys sur votre instance EC2 (par exemple, pour l'utilisateur ubuntu).
Ajoutez la clé privée (github-actions-key) comme secret dans GitHub :
Allez dans votre dépôt GitHub.
Cliquez sur Settings > Secrets > New repository secret.
Ajoutez un secret nommé EC2_SSH_PRIVATE_KEY avec la valeur de votre clé privée SSH.

4. (Optionnel) Configurer Nginx (ou Apache) pour servir la documentation
Si votre instance EC2 utilise un serveur web comme Nginx ou Apache, assurez-vous qu'il est correctement configuré pour servir la documentation générée.