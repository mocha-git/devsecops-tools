module "serverless_arch" {
  source       = "./modules/serverless-arch"
  project_name = var.project_name
  aws_region   = var.aws_region

  # Par défaut, le module va créer un Cognito Domain unique.
  # Si besoin, vous pouvez surcharger (ex: "my-unique-domain-xyz")
  # cognito_domain_prefix = "my-unqiue-domain"
}

