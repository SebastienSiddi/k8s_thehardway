# Creation d'un paire de clés SSH pour se connecter aux instances EC2

# Création d'une clé privé au format openssh
resource "tls_private_key" "kubernetes" {
    algorithm = "RSA"
    rsa_bits  = 4096
}

# Création d'une clé privée au format PEM et stockage dans un fichier
resource "aws_key_pair" "kubernetes" {
    key_name   = var.key_pair_name
    public_key = tls_private_key.kubernetes.public_key_openssh
    
    provisioner "local-exec"{
        command = "echo '${tls_private_key.kubernetes.private_key_pem}' > ./${var.key_pair_name}.pem && chmod 600 ./${var.key_pair_name}.pem"
    }
}