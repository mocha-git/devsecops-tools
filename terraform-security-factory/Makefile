# Fichier: Makefile

# Variables
GO_TEST_DIR=./tests
HCL_DIR=./deployments
TF_VALIDATE_DIR=$(HCL_DIR)/minimal-setup

# Commandes par défaut
.PHONY: all
all: test-go test-hcl

# =========================
# === TEST TERRATEST ===
# =========================

.PHONY: test-go
test-go:
	@echo "🔍 Lancement des tests Go (Terratest)..."
	cd $(GO_TEST_DIR) && go test -v -timeout 15m

.PHONY: test-go-clean
test-go-clean:
	@echo "🧹 Nettoyage des fichiers générés par les tests Go..."
	find $(GO_TEST_DIR) -name "*.tfstate" -delete
	find $(GO_TEST_DIR) -name "*.tfplan" -delete
	find $(GO_TEST_DIR) -name ".terraform" -type d -exec rm -rf {} +

# ==============================
# === VALIDATION HCL / TF ===
# ==============================

.PHONY: test-hcl
test-hcl: tf-fmt tf-validate tf-lint

.PHONY: tf-fmt
tf-fmt:
	@echo "🎨 Vérification du format des fichiers Terraform..."
	terraform -chdir=$(TF_VALIDATE_DIR) fmt -check -diff

.PHONY: tf-validate
tf-validate:
	@echo "🧪 Validation Terraform..."
	terraform -chdir=$(TF_VALIDATE_DIR) init -backend=false -input=false
	terraform -chdir=$(TF_VALIDATE_DIR) validate

.PHONY: tf-lint
tf-lint:
	@echo "🔍 Analyse statique avec tflint..."
	cd $(TF_VALIDATE_DIR) && tflint --recursive

# =====================
# === INSTALL TOOLS ===
# =====================

.PHONY: install
install:
	@echo "📦 Installation des outils requis..."
	go install github.com/terraform-linters/tflint@latest

# ========================
# === AIDE / UTILITAIRE ===
# ========================

.PHONY: help
help:
	@echo "Commandes disponibles :"
	@echo "  make test-go        → Lancer les tests Go (Terratest)"
	@echo "  make test-hcl       → Lancer la validation des fichiers Terraform (fmt, validate, tflint)"
	@echo "  make all            → Tout lancer"
	@echo "  make install        → Installer les outils nécessaires"
	@echo "  make help           → Affiche ce message"

